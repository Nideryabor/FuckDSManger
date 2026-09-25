#!/usr/bin/env python3
"""
check_apk.py —— 出包后的六项验收（不跑完不许装）

用法: python3 check_apk.py <基础APK> <新APK> [期望SHA1]
"""
import hashlib
import os
import re
import subprocess
import sys
import zipfile

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "pack"))
import axml  # noqa: E402

OK, BAD = "\033[32m✓\033[0m", "\033[31m✗\033[0m"
fails = []


def check(name, ok, detail=""):
    print("  %s %s%s" % (OK if ok else BAD, name, ("   " + detail) if detail else ""))
    if not ok:
        fails.append(name)


def main():
    base_path, new_path = sys.argv[1], sys.argv[2]
    want_sha1 = sys.argv[3] if len(sys.argv) > 3 else None

    zb, zn = zipfile.ZipFile(base_path), zipfile.ZipFile(new_path)
    nb, nn = zb.namelist(), zn.namelist()

    print("═══ ① 结构 ═══")
    for must in ("AndroidManifest.xml", "classes.dex", "assets/xposed_init", "resources.arsc"):
        check("有 %s" % must, must in nn)
    for e in zb.namelist():
        if e.startswith("res/"):
            check("搬过来了 %s" % e, e in nn)
    arsc = zn.getinfo("resources.arsc")
    off = arsc.header_offset + 30 + len(arsc.filename.encode()) + len(arsc.extra)
    check("resources.arsc STORED", arsc.compress_type == 0)
    check("resources.arsc 4 字节对齐", off % 4 == 0, "offset=%d" % off)

    print("═══ ② manifest（自己造的）═══")
    mb, mn = zb.read("AndroidManifest.xml"), zn.read("AndroidManifest.xml")
    _, eb = axml.decode(mb)
    _, en = axml.decode(mn)
    gb = next(e[4] for e in eb if e[0] == "start" and e[3] == "manifest")
    gn = next(e[4] for e in en if e[0] == "start" and e[3] == "manifest")

    def val(attrs, name):
        for a in attrs:
            if a[1] == name:
                return a[2] if a[2] is not None else a[4]
        return None

    check("包名没变（原地升级）", val(gb, "package") == val(gn, "package"), val(gn, "package"))
    check("versionCode 递增", val(gn, "versionCode") == val(gb, "versionCode") + 1,
          "%s → %s" % (val(gb, "versionCode"), val(gn, "versionCode")))
    check("versionName 更新", val(gn, "versionName") != val(gb, "versionName"),
          "%s → %s" % (val(gb, "versionName"), val(gn, "versionName")))
    diff = [i for i in range(min(len(mb), len(mn))) if mb[i] != mn[i]]
    check("与基础 manifest 只差版本号那几个字节", len(diff) <= 4 and len(mb) == len(mn),
          "差异 %d 字节（大小 %d/%d）" % (len(diff), len(mb), len(mn)))

    print("═══ ③ dex ═══")
    db, dn = zb.read("classes.dex"), zn.read("classes.dex")
    check("classes.dex 与基础包逐字节相同（一个字节没动）",
          hashlib.sha256(db).hexdigest() == hashlib.sha256(dn).hexdigest())
    check("有 classes2.dex（我们真编译的）", "classes2.dex" in nn,
          "%d B" % zn.getinfo("classes2.dex").file_size)

    print("═══ ④ xposed_init ═══")
    ent = zn.read("assets/xposed_init").decode().strip()
    check("指向我们的新入口", ent == "com.nidyaber.fuckdsmanger.GmEntry", ent)

    print("═══ ⑤ 入口类真的在包里 ═══")
    smali_cp = ("/usr/share/java/smali.jar:/usr/share/java/baksmali.jar:/usr/share/java/dexlib2.jar:"
                "/usr/share/java/smali-util.jar:/usr/share/java/jcommander.jar:/usr/share/java/guava.jar")
    tmp = "/tmp/_check_cls.dex"
    with open(tmp, "wb") as f:
        f.write(zn.read("classes2.dex"))
    out = subprocess.run(["java", "-cp", smali_cp, "org.jf.baksmali.Main", "list", "classes", tmp],
                         capture_output=True, text=True).stdout
    check("classes2.dex 里有 GmEntry",
          "Lcom/nidyaber/fuckdsmanger/GmEntry;" in out)

    print("═══ ⑥ 签名 ═══")
    r = subprocess.run(["apksigner", "verify", "--print-certs", "-v", new_path],
                       capture_output=True, text=True)
    out = r.stdout + r.stderr
    check("apksigner verify 通过", "Verifies" in out and "DOES NOT VERIFY" not in out)
    m = re.search(r"certificate SHA-1 digest: ([0-9a-f]+)", out)
    got = m.group(1) if m else "?"
    if want_sha1:
        check("证书 SHA-1 = 我们的私钥", got == want_sha1.replace(":", "").lower(),
              "%s" % got)
    else:
        print("      证书 SHA-1 = %s" % got)

    print()
    if fails:
        print("\033[31m✗ 有 %d 项没过：%s\033[0m" % (len(fails), ", ".join(fails)))
        sys.exit(1)
    print("\033[32m🎉 六项全过 —— 可以装了\033[0m")


if __name__ == "__main__":
    main()
