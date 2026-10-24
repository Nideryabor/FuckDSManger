#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dump_hookm.py —— 从 GmEntry.smali 里把所有 hookM(类,方法,钩子类) 调用解出来 🐲 尼得亚伯

原理：hookM(ClassLoader p0, String cls, String mth, String hookCls)
  在 smali 里是 `invoke-static {p1, A, B, C}` ⇒ A=类、B=方法、C=钩子类。
  每个 invoke 前会有若干 `const-string vX, "..."`，做一次寄存器→字面量的数据流追踪即可。

用法： python3 tools/dump_hookm.py <GmEntry.smali>
输出： TSV  cls \t mth \t hook
"""
import re
import sys

RE_CONST = re.compile(r'^\s*const-string(?:/jumbo)?\s+([vp]\d+),\s*"(.*)"\s*$')
RE_MOVE = re.compile(r'^\s*move-object(?:/from16)?\s+([vp]\d+),\s*([vp]\d+)\s*$')
RE_INVOKE = re.compile(r'^\s*invoke-static\s*\{([^}]*)\},\s*L[^;]*;->hookM\(')
RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\(')
RE_END = re.compile(r'^\.end method\s*$')


def main():
    path = sys.argv[1]
    lines = open(path, encoding='utf-8', errors='ignore').read().split('\n')
    cur_m = '?'
    reg = {}
    out = []
    for line in lines:
        mm = RE_METHOD.match(line)
        if mm:
            cur_m = mm.group(2)
            reg = {}
            continue
        if RE_END.match(line):
            reg = {}
            continue
        c = RE_CONST.match(line)
        if c:
            reg[c.group(1)] = c.group(2)
            continue
        mv = RE_MOVE.match(line)
        if mv:
            if mv.group(2) in reg:
                reg[mv.group(1)] = reg[mv.group(2)]
            else:
                reg.pop(mv.group(1), None)
            continue
        inv = RE_INVOKE.match(line)
        if inv:
            args = [a.strip() for a in inv.group(1).split(',')]
            if len(args) == 4:
                cls = reg.get(args[1], '?')
                mth = reg.get(args[2], '?')
                hk = reg.get(args[3], '?')
                out.append((cls, mth, hk.split('.')[-1]))
    print('cls\tmth\thook')
    for r in out:
        print('\t'.join(r))


if __name__ == '__main__':
    main()
