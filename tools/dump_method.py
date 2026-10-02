#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dump_method.py —— 打印某个方法体的「字符串常量 / 引用类型 / 调用的方法」  🐲"""
import re, sys, os

RE_CLASS = re.compile(r'^\.class\s+(.*?)\s*(L[^;]+;)\s*$')
RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_INVOKE = re.compile(r'invoke-[a-z/]+ \{[^}]*\}, (L[^;]+;)->([^\s(]+)\(([^)]*)\)(.*)$')
CONST_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')
RE_TYPE = re.compile(r'L[A-Za-z0-9_$]+(?:/[A-Za-z0-9_$]+)*;')

def main():
    root = sys.argv[1]
    for spec in sys.argv[2:]:
        c, m = spec.split(':')
        path = os.path.join(root, c + '.smali')
        if not os.path.exists(path):
            print(f'### {spec} ❌ 没这个文件'); continue
        inside = False
        S, R, V = [], set(), []
        for line in open(path, encoding='utf-8', errors='replace'):
            line = line.rstrip('\n')
            if not inside:
                mm = RE_METHOD.match(line)
                if mm and mm.group(2) == m:
                    inside = True
                    print(f'\n### {spec}   {mm.group(1)} {mm.group(2)}({mm.group(3)}){mm.group(4)}')
                continue
            if line.startswith('.end method'):
                break
            ms = CONST_STR.match(line)
            if ms:
                try: S.append(ms.group(1).encode('utf-8','surrogateescape').decode('unicode_escape'))
                except Exception: S.append(ms.group(1))
                continue
            mi = RE_INVOKE.match(line)
            if mi:
                V.append(f'{mi.group(1)}->{mi.group(2)}({mi.group(3)}){mi.group(4)}')
                continue
            for t in RE_TYPE.findall(line):
                R.add(t)
        print('  串: ' + (' | '.join(S) if S else '(无)'))
        print('  引用类型: ' + ' '.join(sorted(R)[:18]))
        print('  调用(前10): ' + ' | '.join(V[:10]))

if __name__ == '__main__':
    main()
