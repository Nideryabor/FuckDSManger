#!/usr/bin/env python3
"""
build_apk.py —— 从头自己造一个 LSPosed 模块 APK 🐲

不用 aapt2、不用 zipalign、不用 MT。整套自己来：

  AndroidManifest.xml  ← axml.py 现造（已验证可逐字节还原 aapt2 产物）
  classes.dex          ← 基础包原封不动搬过来（一个字节都不动）
  classes2.dex         ← 我们真编译出来的入口类
  assets/xposed_init   ← 指向我们的新入口
  res/ · resources.arsc← 素材，从基础包搬（resources.arsc 必须 STORED + 4 字节对齐）
  签名                  ← apksigner，AOSP testkey（与现有包同证书 ⇒ 原地升级）

用法:
  python3 build_apk.py --base 基础APK --entry-dex 我们的.dex \
      --version-code 442 --version-name 2.22.111 \
      --entry-class com.nidyaber.fuckdsmanger.GmEntry \
      --out 输出.apk [--sign/--no-sign] [--dump]
"""
import argparse
import binascii
import os
import struct
import subprocess
import sys
import time
import zipfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import axml  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
# 默认用我们自己的私钥（2026-09-25 生成，4096-bit RSA，30 年）
DEFAULT_KEY = os.path.join(HERE, "keys", "fuckdsmanger.pk8")
DEFAULT_CERT = os.path.join(HERE, "keys", "fuckdsmanger.x509.pem")
# 备用：AOSP testkey（= 现网旧包的证书；只在需要"同证书覆盖"时用）
FALLBACK_KEY = os.path.join(HERE, "keys", "testkey.pk8")
FALLBACK_CERT = os.path.join(HERE, "keys", "testkey.x509.pem")


# ------------------------------------------------------------------ 读基础包

def read_base(base_apk):
    """→ (manifest信息, 基础 classes.dex 字节, 资源条目列表)"""
    with zipfile.ZipFile(base_apk) as z:
        names = z.namelist()
        raw_manifest = z.read("AndroidManifest.xml")
        base_dex = z.read("classes.dex") if "classes.dex" in names else None
        resources = [(n, z.read(n)) for n in names
                     if n == "resources.arsc" or n.startswith("res/")]

    pool, ev = axml.decode(raw_manifest)
    info = {"package": None, "versionCode": 1, "versionName": "1.0",
            "label": 0, "icon": 0, "desc": 0, "scope": 0,
            "min_sdk": 26, "target_sdk": 30, "compile_sdk": 30, "codename": "11"}
    for e in ev:
        if e[0] != "start":
            continue
        tag = e[3]
        if tag == "manifest":
            for (ns, name, rawv, dtype, data) in e[4]:
                if name == "versionCode":
                    info["versionCode"] = data
                elif name == "versionName":
                    info["versionName"] = rawv
                elif name == "package":
                    info["package"] = rawv
                elif name == "compileSdkVersion":
                    info["compile_sdk"] = data
                elif name == "compileSdkVersionCodename":
                    info["codename"] = rawv
        elif tag == "uses-sdk":
            for (ns, name, rawv, dtype, data) in e[4]:
                if name == "minSdkVersion":
                    info["min_sdk"] = data
                elif name == "targetSdkVersion":
                    info["target_sdk"] = data
        elif tag == "application":
            for (ns, name, rawv, dtype, data) in e[4]:
                if name == "label":
                    info["label"] = data
                elif name == "icon":
                    info["icon"] = data
        elif tag == "meta-data":
            nm, val, res = None, 0, 0
            for (ns, name, rawv, dtype, data) in e[4]:
                if name == "name":
                    nm = rawv
                elif name == "value":
                    val = data if dtype == axml.TYPE_REFERENCE else rawv
                elif name == "resource":
                    res = data
            if nm == "xposeddescription":
                info["desc"] = val
            elif nm == "xposedscope":
                info["scope"] = res
    return info, base_dex, resources


# ------------------------------------------------------------------ 自己写 zip

def write_zip(path, entries):
    """
    entries: [{"name":str, "data":bytes, "store":bool, "align":int|None}]
    align = 让「数据起点」按 N 字节对齐（Android 11+ 要求 resources.arsc 4 字节对齐 + 不压缩）
    """
    dt = time.localtime()
    dos_time = (dt.tm_hour << 11) | (dt.tm_min << 5) | (dt.tm_sec // 2)
    dos_date = ((dt.tm_year - 1980) << 9) | (dt.tm_mon << 5) | dt.tm_mday

    central = []
    with open(path, "wb") as f:
        off = 0

        def w(b):
            nonlocal off
            f.write(b)
            off += len(b)

        for e in entries:
            name = e["name"].encode("utf-8")
            data = e["data"]
            if e.get("store"):
                method, cdata = 0, data
            else:
                import zlib
                co = zlib.compressobj(9, zlib.DEFLATED, -15)
                method, cdata = 8, co.compress(data) + co.flush()
            crc = binascii.crc32(data) & 0xFFFFFFFF

            extra = b""
            if e.get("align"):
                start = off + 30 + len(name)
                pad = (-start) % e["align"]
                if pad:
                    if pad < 4:
                        pad += 4
                    extra = struct.pack("<HH", 0xCAFE, pad - 4) + b"\x00" * (pad - 4)

            lho = off
            w(struct.pack("<IHHHHHIIIHH", 0x04034B50, 20, 0, method,
                          dos_time, dos_date, crc, len(cdata), len(data),
                          len(name), len(extra)))
            w(name)
            w(extra)
            w(cdata)
            central.append((name, method, crc, len(cdata), len(data), lho, extra))

        cd_off = off
        for (name, method, crc, csize, usize, lho, extra) in central:
            w(struct.pack("<IHHHHHHIIIHHHHHII", 0x02014B50, 20, 20, 0, method,
                          dos_time, dos_date, crc, csize, usize,
                          len(name), len(extra), 0, 0, 0, 0, lho))
            w(name)
            w(extra)
        cd_size = off - cd_off
        w(struct.pack("<IHHHHIIH", 0x06054B50, 0, 0,
                      len(central), len(central), cd_size, cd_off, 0))


# ------------------------------------------------------------------ 主流程

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, help="基础 APK（提供 dex 与资源素材）")
    ap.add_argument("--dex", help="整包替换用的 classes.dex（全量重建时）")
    ap.add_argument("--entry-dex", help="我们真编译出来的入口 dex（追加为 classes2.dex）")
    ap.add_argument("--entry-class", default="com.nidyaber.fuckdsmanger.GmEntry")
    ap.add_argument("--version-code", type=int)
    ap.add_argument("--version-name")
    ap.add_argument("--out", required=True)
    ap.add_argument("--sign", dest="sign", action="store_true", default=True)
    ap.add_argument("--no-sign", dest="sign", action="store_false")
    ap.add_argument("--keystore", default=DEFAULT_KEY)
    ap.add_argument("--cert", default=DEFAULT_CERT)
    ap.add_argument("--dump", action="store_true", help="打印参与打包的每一件")
    a = ap.parse_args()

    info, base_dex, resources = read_base(a.base)
    vc = a.version_code if a.version_code is not None else info["versionCode"] + 1
    vn = a.version_name or info["versionName"]

    print("基础包  : %s" % a.base)
    print("包名    : %s   （保持不变 ⇒ 原地升级）" % info["package"])
    print("版本    : %s (%d)  →  %s (%d)" % (info["versionName"], info["versionCode"], vn, vc))
    print("资源    : label=%#x icon=%#x desc=%#x scope=%#x"
          % (info["label"], info["icon"], info["desc"], info["scope"]))

    manifest = axml.build_manifest(
        version_code=vc, version_name=vn, package=info["package"],
        label_ref=info["label"], icon_ref=info["icon"],
        desc_ref=info["desc"], scope_ref=info["scope"],
        min_sdk=info["min_sdk"], target_sdk=info["target_sdk"],
        compile_sdk=info["compile_sdk"], sdk_codename=info["codename"])
    print("新 manifest: %d 字节（自己造的）" % len(manifest))

    entries = [
        {"name": "AndroidManifest.xml", "data": manifest},
    ]
    if a.dex:
        with open(a.dex, "rb") as f:
            whole = f.read()
        entries.append({"name": "classes.dex", "data": whole})
        print("classes.dex : %d 字节（★ 整包重建）" % len(whole))
    else:
        if base_dex:
            entries.append({"name": "classes.dex", "data": base_dex})
            print("classes.dex : %d 字节（基础包原样）" % len(base_dex))
        if a.entry_dex:
            with open(a.entry_dex, "rb") as f:
                our = f.read()
            name = "classes2.dex" if base_dex else "classes.dex"
            entries.append({"name": name, "data": our})
            print("%s : %d 字节（我们真编译的入口）" % (name, len(our)))

    init = (a.entry_class + "\n").encode("utf-8")
    entries.append({"name": "assets/xposed_init", "data": init})
    print("xposed_init : %s" % a.entry_class)

    arsc = [r for r in resources if r[0] == "resources.arsc"]
    rest = [r for r in resources if r[0] != "resources.arsc"]
    for n, d in arsc:
        entries.append({"name": n, "data": d, "store": True, "align": 4})
        print("resources.arsc : %d 字节（STORED + 4 字节对齐）" % len(d))
    for n, d in rest:
        entries.append({"name": n, "data": d})
    if rest:
        print("res/ 素材    : %d 个文件" % len(rest))

    write_zip(a.out, entries)
    print("→ 自造 APK: %s (%d 字节)" % (a.out, os.path.getsize(a.out)))

    if a.dump:
        with zipfile.ZipFile(a.out) as z:
            for i in z.infolist():
                print("   %-42s %8d  method=%d" % (i.filename, i.file_size, i.compress_type))

    if a.sign:
        signed = a.out.replace(".apk", "-signed.apk") if a.out.endswith(".apk") else a.out + ".signed"
        cmd = ["apksigner", "sign", "--key", a.keystore, "--cert", a.cert,
               "--v1-signing-enabled", "true",
               "--v2-signing-enabled", "true",
               "--v3-signing-enabled", "true",
               "--out", signed, a.out]
        subprocess.run(cmd, check=True)
        print("→ 已签名: %s (%d 字节)" % (signed, os.path.getsize(signed)))
        subprocess.run(["apksigner", "verify", "--print-certs", "-v", signed], check=True)


if __name__ == "__main__":
    main()
