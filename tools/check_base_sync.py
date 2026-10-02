#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
check_base_sync.py —— 「树里的改动回灌底座了吗？」机械闸门 🐲

> 为什么要有它（2026-10-03 血案）：
>   主人报「AI 气泡缩放完全不会缩放」——真因是
>   **smali 树里的修复一直没回灌底座**：底座里的 GmBubbleFitHook 落后一整代
>   （125 行），另外 17 个文件也落后（GmBubble 455 行、GmBubblePaintHook 289 行…）。
>   而 `重建底座.py` 是**手动**步骤 ⇒ 靠记性 = 迟早再犯。
>   ⇒ 出包前机械核对：把底座的 classes.dex 反编译回来，跟树**逐文件比**。

用法：
    python3 tools/check_base_sync.py --smali tmp/base130_261/sm --base <底座.apk>

退出码：
    0 = 同步（可以出包）
    1 = 有差异（**别出包**，先跑 重建底座.py）
    2 = 环境问题（反编译失败等）

比对口径：两边都是 baksmali 产物 ⇒ 忽略空行与 `#` 注释行后逐行比。
（smali 往返会重排某些东西，但**真改动必然是行级差异**——够用。）
"""
import argparse
import os
import subprocess
import sys
import tempfile
import zipfile

JAVA_CP = ":".join([
    "/usr/share/java/smali.jar", "/usr/share/java/baksmali.jar",
    "/usr/share/java/dexlib2.jar", "/usr/share/java/smali-util.jar",
    "/usr/share/java/jcommander.jar", "/usr/share/java/guava.jar",
])


def norm_line(s):
    import re
    s = " ".join(s.split())
    # ① 去掉行尾注释（只动引号外面的 #）
    parts = s.split('"')
    for i in range(0, len(parts), 2):
        j = parts[i].find("#")
        if j >= 0:
            parts[i] = parts[i][:j].rstrip()
    s = '"'.join(parts).strip()
    # ② \uXXXX → 真字符（baksmali 往返会把非 ASCII 转义回去，树里是原文）
    s = re.sub(r"\\u([0-9a-fA-F]{4})",
               lambda m: chr(int(m.group(1), 16)), s)
    # ③ 抹平寄存器与标签名
    s = re.sub(r"\b[vp]\d+\b", "r", s)
    s = re.sub(r":[A-Za-z0-9_]+", ":L", s)
    return s


DROP = (".line ", ".source ", ".registers", ".locals", ".param ", ".local ",
        ".prologue", ".epilogue", ".end local", ".end param")


def parse_units(path):
    """把一个 smali 文件拆成「单元」：class 头 / 字段 / 方法块 / 注解块。

    为什么要按单元：**dex 里的字段与方法顺序跟源树文本顺序可以不同**
    （回灌往返会重排）⇒ 逐行比会满屏假阳性。按单元比 = 对重排免疫、
    对"方法体真改了"敏感。
    """
    units = {}
    counts = {}
    cur_key, cur_body = None, None

    def add(key, body):
        n = counts.get(key, 0)
        counts[key] = n + 1
        units["%s#%d" % (key, n)] = body

    with open(path, encoding="utf-8") as f:
        for raw in f:
            s = raw.strip()
            if not s or s.startswith("#") or s.startswith(DROP):
                continue
            s = norm_line(s)
            if not s or s == ":L":                 # 空标签行：往返可能出现，无意义
                continue
            if cur_body is not None:
                if s.startswith(".end method") or s.startswith(".end annotation"):
                    add(cur_key, cur_body)
                    cur_key, cur_body = None, None
                else:
                    cur_body.append(s)
                continue
            if s.startswith(".method "):
                cur_key, cur_body = "M " + s, []
            elif s.startswith(".annotation "):
                cur_key, cur_body = "A " + s, []
            elif s.startswith(".field "):
                add("F " + s, [])
            else:
                add("H " + s, [])
    return units



def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--smali", required=True, help="smali 源树目录")
    ap.add_argument("--base", required=True, help="底座 APK")
    ap.add_argument("--max-list", type=int, default=25, help="最多列出几条差异")
    a = ap.parse_args()

    if not os.path.isdir(a.smali):
        print("✗ 找不到 smali 树：%s" % a.smali)
        return 2
    if not os.path.isfile(a.base):
        print("✗ 找不到底座：%s" % a.base)
        return 2

    with tempfile.TemporaryDirectory(prefix="basechk-") as tmp:
        with zipfile.ZipFile(a.base) as z:
            names = [n for n in z.namelist() if n.endswith(".dex")]
            if "classes.dex" not in names:
                print("✗ 底座里没有 classes.dex")
                return 2
            z.extract("classes.dex", tmp)
        src = os.path.join(tmp, "classes.dex")
        dump = os.path.join(tmp, "sm")
        r = subprocess.run(
            ["java", "-cp", JAVA_CP, "org.jf.baksmali.Main", "d", src, "-o", dump],
            capture_output=True, text=True)
        if r.returncode != 0:
            print("✗ 底座 dex 反编译失败：\n%s" % r.stderr[-800:])
            return 2

        diffs = []
        tree_count = 0
        for root, _, files in os.walk(a.smali):
            for fn in files:
                if not fn.endswith(".smali"):
                    continue
                tree_count += 1
                n = os.path.join(root, fn)
                rel = os.path.relpath(n, a.smali)
                o = os.path.join(dump, rel)
                if not os.path.exists(o):
                    diffs.append((rel, "底座里没有（新类）"))
                    continue
                t1, t2 = parse_units(n), parse_units(o)
                only_tree = [k for k in t1 if k not in t2]
                only_base = [k for k in t2 if k not in t1]
                changed = [k for k in t1 if k in t2 and t1[k] != t2[k]]
                if only_tree or only_base or changed:
                    note = []
                    if changed:
                        note.append("%d 个方法/单元体不同" % len(changed))
                    if only_tree:
                        note.append("%d 个单元只在树里" % len(only_tree))
                    if only_base:
                        note.append("%d 个单元只在底座里" % len(only_base))
                    sample = ""
                    if changed:
                        sample = "（如 %s）" % changed[0].split("#")[0][:60]
                    diffs.append((rel, "、".join(note) + sample))

        base_only = []
        for root, _, files in os.walk(dump):
            for fn in files:
                if not fn.endswith(".smali"):
                    continue
                rel = os.path.relpath(os.path.join(root, fn), dump)
                if not os.path.exists(os.path.join(a.smali, rel)):
                    base_only.append(rel)

    if not diffs and not base_only:
        print("✓ 底座与 smali 树同步（%d 个文件）" % tree_count)
        return 0

    print("✗ 底座与 smali 树**不同步**：树里 %d 个文件，其中 %d 个跟底座不一致"
          % (tree_count, len(diffs)))
    for rel, note in diffs[:a.max_list]:
        print("   · %-58s %s" % (rel, note))
    if len(diffs) > a.max_list:
        print("   …（还有 %d 个）" % (len(diffs) - a.max_list))
    if base_only:
        print("   ⚠️ 底座里有而树里没有的类 %d 个（也算不同步）" % len(base_only))
    print()
    print("⇒ 先回灌底座（会自动备份 + 语义复核）：")
    print("   python3 tools/重建底座.py --smali %s --base %s --out %s --api 26"
          % (a.smali, a.base, a.base))
    return 1


if __name__ == "__main__":
    sys.exit(main())
