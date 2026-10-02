#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
extract_reflect.py —— 从底座 smali 里抽出所有"带字面量的反射调用"

产出 TSV: 文件 | 行号 | 类 | 方法 | 形态 | 成员名字面量
用途：这是"R8 改了成员名 ⇒ 功能全哑"那条线上的【待改清单】。

用法: python3 tools/frida/extract_reflect.py <smali根目录> > 参考/数据/反射调用清单.tsv
"""
import os, re, sys

# XposedHelpers 的反射方法 → (签名, 第几个参数是"成员名")
APIS = {
    "callMethod":           (r"Ljava/lang/Object;Ljava/lang/String;\[Ljava/lang/Object;", 1),
    "callStaticMethod":     (r"Ljava/lang/Class;Ljava/lang/String;\[Ljava/lang/Object;",   1),
    "getObjectField":       (r"Ljava/lang/Object;Ljava/lang/String;",                      1),
    "getStaticObjectField": (r"Ljava/lang/Class;Ljava/lang/String;",                       1),
    "setObjectField":       (r"Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;",    1),
    "findClass":            (r"Ljava/lang/String;Ljava/lang/ClassLoader;",                 0),
}

INVOKE_RE = re.compile(
    r"invoke-(?:static|virtual|direct)\s+\{([^}]*)\},\s*Lde/robv/android/xposed/XposedHelpers;->(\w+)\(")
CONST_RE = re.compile(r'^\s*const-string(?:/jumbo)?\s+(v\d+|p\d+),\s*"((?:[^"\\]|\\.)*)"')


def main(root):
    rows = []
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if not fn.endswith(".smali"):
                continue
            path = os.path.join(dirpath, fn)
            try:
                lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
            except Exception:
                continue
            for i, ln in enumerate(lines):
                m = INVOKE_RE.search(ln)
                if not m:
                    continue
                regs = [r.strip() for r in m.group(1).split(",") if r.strip()]
                api = m.group(2)
                if api not in APIS:
                    continue
                _, pos = APIS[api]
                if pos >= len(regs):
                    continue
                want = regs[pos]          # 这个名字所在的寄存器
                # 往回找 const-string（最多 12 行）
                lit = None
                for j in range(i - 1, max(-1, i - 13), -1):
                    cm = CONST_RE.match(lines[j])
                    if cm and cm.group(1) == want:
                        lit = cm.group(2)
                        break
                cls = os.path.basename(path)[:-6]
                rows.append((os.path.relpath(path, root), i + 1, cls, api, lit or "(非字面量/未找到)"))

    print("文件\t行号\t类\tAPI\t成员名字面量")
    for r in sorted(rows, key=lambda x: (x[2], x[1])):
        print("\t".join(str(x) for x in r))

    # 汇总
    sys.stderr.write("\n===== 汇总 =====\n")
    from collections import Counter
    c = Counter(r[3] for r in rows)
    for k, v in c.most_common():
        sys.stderr.write("  %-22s %d\n" % (k, v))
    lit = [r for r in rows if r[4] != "(非字面量/未找到)"]
    sys.stderr.write("  带字面量的: %d / 总 %d\n" % (len(lit), len(rows)))
    nonlit = Counter(r[2] for r in rows if r[4] == "(非字面量/未找到)")
    if nonlit:
        sys.stderr.write("  ⚠ 非字面量（要人工看）集中在:\n")
        for k, v in nonlit.most_common(10):
            sys.stderr.write("      %-28s %d\n" % (k, v))


if __name__ == "__main__":
    root = sys.argv[1] if len(sys.argv) > 1 else "mod-src/work/sm_new"
    main(root)
