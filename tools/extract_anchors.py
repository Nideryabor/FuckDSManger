#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
extract_anchors.py —— 全量提取模块对「宿主」的锚点引用 🐲 尼得亚伯 2026-10-16

比 extract_reflect.py 更全：除反射字面量外，还抓
  ① findClass / findAndHookMethod / findAndHookConstructor 的类名字面量
  ② hookAllMethods / hookAllConstructors 的「类来源」（回追到 findClass 的寄存器）
  ③ 每条锚点旁边的成员名字面量（callMethod/getObjectField/...）

产出 TSV: 文件 | 行号 | 模块类 | API | 锚点字面量 | 形态
用法: python3 tools/extract_anchors.py <smali根> > out.tsv
"""
import os, re, sys

CONST = re.compile(r'^\s*const-string(?:/jumbo)?\s+([vp]\d+),\s*"((?:[^"\\]|\\.)*)"\s*$')
INV = re.compile(r'invoke-(?:static|virtual|direct)\s+\{([^}]*)\},\s*Lde/robv/android/xposed/XposedHelpers;->(\w+)\(')
INV2 = re.compile(r'invoke-(?:static|virtual|direct)\s+\{([^}]*)\},\s*Lde/robv/android/xposed/XposedBridge;->(\w+)\(')
MEMBER = {"callMethod", "callStaticMethod", "getObjectField", "getStaticObjectField",
          "setObjectField", "setStaticObjectField", "getIntField", "setIntField",
          "getLongField", "setLongField", "getFloatField", "setFloatField",
          "getBooleanField", "setBooleanField", "getDoubleField", "getAdditionalInstanceField",
          "getAdditionalStaticField"}
CLASSARG0 = {"findClass", "findAndHookMethod", "findAndHookConstructor"}


def unesc(s):
    try:
        return s.encode('utf-8', 'surrogateescape').decode('unicode_escape')
    except Exception:
        return s


def main(root):
    print("文件\t行号\t模块类\tAPI\t锚点字面量\t形态")
    for dp, _, fs in os.walk(root):
        for fn in sorted(fs):
            if not fn.endswith(".smali"):
                continue
            p = os.path.join(dp, fn)
            lines = open(p, encoding='utf-8', errors='replace').read().split("\n")
            regs = {}          # 寄存器 → 字面量（粗略跟踪，足够用）
            modcls = fn[:-6]
            for i, l in enumerate(lines):
                m = CONST.match(l)
                if m:
                    regs[m.group(1)] = unesc(m.group(2))
                    continue
                mm = INV.search(l) or INV2.search(l)
                if not mm:
                    continue
                args = [a.strip() for a in mm.group(1).split(',')]
                api = mm.group(2)
                if api in CLASSARG0 and len(args) >= 1:
                    v = regs.get(args[0], "")
                    print(f"{p}\t{i+1}\t{modcls}\t{api}\t{v}\t类名")
                elif api in MEMBER and len(args) >= 2:
                    v = regs.get(args[1], "")
                    print(f"{p}\t{i+1}\t{modcls}\t{api}\t{v}\t成员名")
                elif api in ("hookAllMethods", "hookAllConstructors") and len(args) >= 2:
                    # hookAllMethods(classObj, methodName, cb) —— 类来自寄存器（多半是 findClass/const-class）
                    v = regs.get(args[0], "")
                    print(f"{p}\t{i+1}\t{modcls}\t{api}\t{v}\t★Hook落点")


if __name__ == "__main__":
    main(sys.argv[1])
