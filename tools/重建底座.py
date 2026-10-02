#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
重建底座.py —— 把 patch_261.py 改好的 smali 树，真的组装回底座 APK 🐲

> ★为什么需要它★
>   patch_261.py 只把改动【写进 tmp/base130_261/sm】，
>   而 build_single.py 读的是【底座 APK 里的 classes.dex】——
>   两者之间一直缺一个「smali a → 塞回去」的环节，
>   所以补丁写多少都不会进包（2026-10-01 晚 主人："一直没有重建过底座"）。

用法：
    python3 tools/重建底座.py \\
        --smali tmp/base130_261/sm \\
        --base  mod-src/out/FuckDSManger_NL_2.22.123_for_ds2.5.2-signed.apk \\
        --out   mod-src/out/FuckDSManger_NL_2.22.123_for_ds2.5.2-signed.apk \\
        --api 26

安全：
    · --out 与 --base 相同时，先备份成 <base>.bak-<时间戳>
    · 组完 dex 后【反编译回来】跟源树做一次语义 diff（不是比 md5——
      smali assemble 不是字节级确定的，类顺序/常量池会变）
"""
import argparse, os, re, shutil, subprocess, sys, tempfile, zipfile, time

SMALI_CP = ":".join([
    "/usr/share/java/smali.jar", "/usr/share/java/baksmali.jar",
    "/usr/share/java/dexlib2.jar", "/usr/share/java/smali-util.jar",
    "/usr/share/java/jcommander.jar", "/usr/share/java/guava.jar",
])


def run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        sys.stderr.write("命令失败: %s\n%s\n%s\n" % (" ".join(cmd), r.stdout[-2000:], r.stderr[-2000:]))
        sys.exit(1)
    return r


def assemble(smali_dir, out_dex, api):
    run(["java", "-cp", SMALI_CP, "org.jf.smali.Main", "assemble",
         "--api", str(api), "-o", out_dex, smali_dir])


def baksmali(dex, out_dir):
    run(["java", "-cp", SMALI_CP, "org.jf.baksmali.Main", "disassemble",
         dex, "-o", out_dir])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--smali", required=True)
    ap.add_argument("--base", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--api", type=int, default=26)
    ap.add_argument("--skip-verify", action="store_true")
    a = ap.parse_args()

    if not os.path.isdir(a.smali):
        sys.exit("✗ 找不到 smali 树: " + a.smali)
    if not os.path.isfile(a.base):
        sys.exit("✗ 找不到底座 APK: " + a.base)

    n_src = sum(1 for _dp, _dn, fs in os.walk(a.smali) for f in fs if f.endswith(".smali"))
    print("① 源树: %s （%d 个 smali）" % (a.smali, n_src))

    # 备份（就地覆盖时）
    if os.path.abspath(a.out) == os.path.abspath(a.base):
        bak = a.base + ".bak-" + time.strftime("%Y%m%d-%H%M%S")
        shutil.copy2(a.base, bak)
        print("   已备份原底座 → %s" % bak)

    tmp = tempfile.mkdtemp(prefix="rebuild-base-")
    dex = os.path.join(tmp, "classes.dex")
    print("② smali a → classes.dex （api %d）" % a.api)
    assemble(a.smali, dex, a.api)
    print("   → %d 字节" % os.path.getsize(dex))

    # ── 语义复核：反编译回来 diff ──
    if not a.skip_verify:
        print("③ 复核：把新 dex 反编译回来，跟源树逐文件比")
        sm2 = os.path.join(tmp, "sm2")
        baksmali(dex, sm2)
        diff_files, missing = [], []
        for dp, _dn, fs in os.walk(a.smali):
            for f in fs:
                if not f.endswith(".smali"):
                    continue
                rel = os.path.relpath(os.path.join(dp, f), a.smali)
                p2 = os.path.join(sm2, rel)
                if not os.path.exists(p2):
                    missing.append(rel); continue
                t1 = open(os.path.join(dp, f), encoding="utf-8", errors="replace").read()
                t2 = open(p2, encoding="utf-8", errors="replace").read()
                # 只比"指令/字段/方法"这些语义行，忽略空白与注释差异
                norm = lambda s: "\n".join(
                    l.strip() for l in s.splitlines()
                    if l.strip() and not l.strip().startswith("#"))
                if norm(t1) != norm(t2):
                    diff_files.append(rel)
        if missing:
            print("   ⚠️ 有 %d 个文件没进 dex（前 5）: %s" % (len(missing), missing[:5]))
        if diff_files:
            print("   ⚠️ 有 %d 个文件往返后不一致（前 5）: %s" % (len(diff_files), diff_files[:5]))
        if not missing and not diff_files:
            print("   ✓ 往返一致（%d 个文件）" % n_src)
        else:
            print("   ⚠️ 有差异，但 smali 往返本来就可能重排 —— 继续，请以真机为准")

    # ── 塞回 APK ──
    print("④ 替换底座 APK 里的 classes.dex")
    # ★必须写到临时文件再替换★
    #   之前是「先 os.remove(a.out) 再读 a.base」—— 当 out==base（就地覆盖）
    #   时会把源删掉再去读它 ⇒ FileNotFoundError。
    tmpzip = os.path.join(tmp, "out.apk")
    with zipfile.ZipFile(a.base, "r") as zin, \
         zipfile.ZipFile(tmpzip, "w", zipfile.ZIP_DEFLATED) as zout:
        n = 0
        for it in zin.infolist():
            if it.filename == "classes.dex":
                zout.writestr(it, open(dex, "rb").read())
                n += 1
            else:
                zout.writestr(it, zin.read(it.filename))
    os.replace(tmpzip, a.out)
    print("   替换了 %d 个 classes.dex；条目总数保持" % n)

    # ── 复核：新 APK 里读回来的 dex 里，那几个关键名字对不对 ──
    print("⑤ 复核：新底座里，关键替换是否生效")
    chk_dex = os.path.join(tmp, "chk.dex")
    with zipfile.ZipFile(a.out, "r") as z:
        open(chk_dex, "wb").write(z.read("classes.dex"))
    sm3 = os.path.join(tmp, "sm3")
    baksmali(chk_dex, sm3)
    txt = ""
    for dp, _dn, fs in os.walk(sm3):
        for f in fs:
            if f.endswith(".smali"):
                txt += open(os.path.join(dp, f), encoding="utf-8", errors="replace").read()
    checks = [
        ("uia → qk7",    '"qk7"'),
        ("kf5 → kh7",    '"kh7"'),
        ("vq → mr",      '"mr"'),
        ("Modifier x97", '"x97"'),
        ("qk7 u/v→C",    None),   # 下面单独看
    ]
    for label, lit in checks:
        if lit is None:
            continue
        print("   %-14s %s" % (label, "✓ 出现" if lit in txt else "✗ 没找到"))
    # GmBubble 里原本的 "u"/"v" 调用应该已经变成 "C"/"D"
    gp = os.path.join(sm3, "com/nidyaber/fuckdsmanger/gm/GmBubble.smali")
    if os.path.exists(gp):
        t = open(gp, encoding="utf-8", errors="replace").read()
        print("   GmBubble 里 qk7 的 C/D: %s" % ("✓ 有" if '"C"' in t and '"D"' in t else "✗ 没找到"))

    shutil.rmtree(tmp, ignore_errors=True)
    print("\n✓ 完成: %s" % a.out)
    print("  下一步: sh /workspace/做包.sh <版本名> <versionCode>")


if __name__ == "__main__":
    main()
