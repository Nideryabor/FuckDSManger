#!/usr/bin/env python3
"""
rename_pkg.py —— 把 smali 树里的模板包名整体换掉（含隐形的字符串引用）

  com.varuns2002.disable_flag_secure.gm.*        → com.nidyaber.fuckdsmanger.gm.*
  com.varuns2002.disable_flag_secure.a / b / c   → .../gm/GmFlagSecure{Int,Lp,Bool}Hook     （FLAG_SECURE 三件套）
  com.varuns2002.disable_flag_secure.DisableFlagSecure   → 删（已被 GmEntry 取代）
  com.little_femaleboy...whale.DisableFlagSecure         → 删（转发壳，死代码）
  "com.varuns2002."                              → "com.nidyaber."      （GmUtil.caller 的栈帧过滤前缀）

★ 可审计：跑完会做一次「反向归一化比对」——
  把新树的包名换回旧的，跟原树逐字节 diff。**必须一字不差**，
  才能证明「除了名字，什么都没动」。

用法: python3 rename_pkg.py <原 smali 目录> <新 smali 目录>
"""
import filecmp
import os
import shutil
import sys

OLD_PKG = "com/varuns2002/disable_flag_secure"      # smali 描述符里也是斜杠
NEW_PKG = "com/nidyaber/fuckdsmanger"
OLD_GM = OLD_PKG + "/gm"
NEW_GM = NEW_PKG + "/gm"
OLD_DOT = "com.varuns2002.disable_flag_secure.gm."
NEW_DOT = "com.nidyaber.fuckdsmanger.gm."

# 三个 FLAG_SECURE 钩子：换个说得清名字
SECURE = {
    OLD_PKG + "/a": NEW_GM + "/GmFlagSecureIntHook",
    OLD_PKG + "/b": NEW_GM + "/GmFlagSecureLpHook",
    OLD_PKG + "/c": NEW_GM + "/GmFlagSecureBoolHook",
}

DEAD = [
    OLD_PKG + "/DisableFlagSecure",
    "com/little_femaleboy/cannot_show/the_big_won_whale/DisableFlagSecure",
]


def main(src, dst):
    if os.path.exists(dst):
        shutil.rmtree(dst)
    shutil.copytree(src, dst)

    # ---------- 1) 删死类 ----------
    for d in DEAD:
        p = os.path.join(dst, d + ".smali")
        if os.path.exists(p):
            os.remove(p)
            print("  删死类  %s" % d.replace("/", "."))

    # ---------- 2) 搬目录 + 改名 ----------
    os.makedirs(os.path.join(dst, NEW_PKG), exist_ok=True)
    os.makedirs(os.path.join(dst, NEW_GM), exist_ok=True)
    # gm 整包
    if os.path.isdir(os.path.join(dst, OLD_GM)):
        for f in os.listdir(os.path.join(dst, OLD_GM)):
            shutil.move(os.path.join(dst, OLD_GM, f), os.path.join(dst, NEW_GM, f))
        os.rmdir(os.path.join(dst, OLD_GM))
    # 三件套
    for old, new in SECURE.items():
        op = os.path.join(dst, old + ".smali")
        if os.path.exists(op):
            np_ = os.path.join(dst, new + ".smali")
            os.makedirs(os.path.dirname(np_), exist_ok=True)
            shutil.move(op, np_)
            print("  改名字  %s  →  %s" % (old.replace("/", "."), new.replace("/", ".")))

    # 清掉空的 com/varuns2002
    for root, dirs, files in os.walk(os.path.join(dst, "com/varuns2002"), topdown=False):
        if not os.listdir(root):
            os.rmdir(root)

    # ---------- 3) 全树文本替换 ----------
    n_files = 0
    for root, _, files in os.walk(dst):
        for f in files:
            if not f.endswith(".smali"):
                continue
            p = os.path.join(root, f)
            t = open(p, encoding="utf-8").read()
            o = t
            t = t.replace("L" + OLD_GM + "/", "L" + NEW_GM + "/")       # 所有类型描述符
            for old, new in SECURE.items():
                t = t.replace("L" + old + ";", "L" + new + ";")          # 三件套的引用
            t = t.replace('"com.varuns2002."', '"com.nidyaber."')        # GmUtil.caller 的过滤前缀
            t = t.replace(OLD_DOT, NEW_DOT)                              # 点号形态的类名字面量
            if t != o:
                open(p, "w", encoding="utf-8").write(t)
                n_files += 1
    print("  改写文件数: %d" % n_files)

    # ---------- 4) 残留检查 ----------
    left = []
    for root, _, files in os.walk(dst):
        for f in files:
            p = os.path.join(root, f)
            for i, line in enumerate(open(p, encoding="utf-8"), 1):
                if "varuns2002" in line:
                    left.append("%s:%d: %s" % (p.replace(dst, ""), i, line.strip()))
    print("  残留 varuns2002: %d 处" % len(left))
    for l in left[:10]:
        print("     ⚠️ " + l)

    # ---------- 5) ★ 反向归一化比对 ----------
    print("\n═══ 反向归一化比对：新树把名字换回旧的，应与原树逐字节相同 ═══")

    def norm(t):
        # ★ 特例先反（那三个类连类名都换了）
        for old, new in SECURE.items():
            t = t.replace("L" + new + ";", "L" + old + ";")
        t = t.replace("L" + NEW_GM + "/", "L" + OLD_GM + "/")
        t = t.replace('"com.nidyaber."', '"com.varuns2002."')
        return t

    bad = 0
    checked = 0
    for root, _, files in os.walk(dst):
        for f in files:
            np_ = os.path.join(root, f)
            rel = os.path.relpath(np_, dst)
            # 新路径 → 旧路径
            old_rel = rel
            hit = False
            for old, new in SECURE.items():          # ★ 特例要先判（它们也在 gm/ 下面）
                if rel == new + ".smali":
                    old_rel = old + ".smali"
                    hit = True
                    break
            if not hit and rel.startswith(NEW_GM + "/"):
                old_rel = OLD_GM + "/" + rel[len(NEW_GM) + 1:]
            op_ = os.path.join(src, old_rel)
            if not os.path.exists(op_):
                print("  ⚠️ 新树多出文件: %s" % rel)
                bad += 1
                continue
            checked += 1
            if norm(open(np_, encoding="utf-8").read()) != open(op_, encoding="utf-8").read():
                print("  ✗ 内容不同: %s" % rel)
                bad += 1
    print("  比对 %d 个文件，不一致 %d 个" % (checked, bad))
    if bad == 0 and not left:
        print("\n  🎉 干净：只改了名字，代码一个字节没动")
    else:
        print("\n  ⚠️ 有问题，别往下走")
        sys.exit(1)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
