#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
locate_by_sourceinfo.py —— 用 SourceInfo 串精确定位「方法」🐲 尼得亚伯 2026-10-24

用法：
  python3 tools/locate_by_sourceinfo.py <smali树> <pattern1> [pattern2 ...]
  python3 tools/locate_by_sourceinfo.py <smali树> --file patterns.txt

pattern 可以是 "AppButton.kt:298" 这种带行号的，也可以只是 "AppButton.kt"。
输出： pattern -> 类.方法  (形参签名)
"""
import os, re, sys

RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_END = re.compile(r'^\.end method\s*$')
CONST_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')


def scan(root, pats):
    hits = {p: [] for p in pats}
    for rt, _, fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            p = os.path.join(rt, f)
            cls = os.path.relpath(p, root).replace(os.sep, '/')[:-6]
            try:
                lines = open(p, encoding='utf-8', errors='ignore').read().split('\n')
            except Exception:
                continue
            cur = None
            for line in lines:
                if cur is None:
                    mm = RE_METHOD.match(line)
                    if mm:
                        cur = {'name': mm.group(2), 'ps': mm.group(3), 'ret': mm.group(4)}
                else:
                    if RE_END.match(line):
                        cur = None
                        continue
                    node = CONST_STR.match(line)
                    if node:
                        s = node.group(1)
                        for pt in pats:
                            if pt in s:
                                hits[pt].append((cls, cur['name'], cur['ps'], cur['ret'], s))
    return hits


def main():
    root = sys.argv[1]
    args = sys.argv[2:]
    if args and args[0] == '--file':
        pats = [l.strip() for l in open(args[1], encoding='utf-8')
                if l.strip() and not l.startswith('#')]
    else:
        pats = args
    hits = scan(root, pats)
    for pt in pats:
        print(f'\n=== {pt} ===')
        seen = set()
        for cls, name, ps, ret, s in hits[pt]:
            key = (cls, name, ps)
            if key in seen:
                continue
            seen.add(key)
            print(f'   {cls}.{name}({ps}){ret}')
            print(f'      「{s[:150]}」')


if __name__ == '__main__':
    main()
