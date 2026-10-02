#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_rank.py —— 按「被引用次数(入度)排名」跨版本对齐类型  🐲 尼得亚伯 2026-10-01

理由：像 Compose 的 `Composer`、`Modifier`、`Brush` 这类**框架级类型**，
      R8 改了名，但"被多少人引用"这个**拓扑位次**是稳定的。
      入度排名 = 结构指纹的又一种。
"""
import os, re, sys, collections

RE_TYPE = re.compile(r'L[A-Za-z0-9_$]+(?:/[A-Za-z0-9_$]+)*;')
RE_CLASS = re.compile(r'^\.class\s+(.*?)\s*(L[^;]+;)\s*$')

def indeg(root):
    cnt = collections.Counter()
    cls = set()
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if not fn.endswith('.smali'): continue
            with open(os.path.join(dirpath, fn), 'r', encoding='utf-8', errors='replace') as f:
                desc = None
                for line in f:
                    if desc is None:
                        m = RE_CLASS.match(line)
                        if m: desc = m.group(2)
                    for t in RE_TYPE.findall(line):
                        if t != desc:
                            cnt[t] += 1
            if desc: cls.add(desc)
    return cnt, cls

def main():
    a_root, b_root = sys.argv[1], sys.argv[2]
    n = int(sys.argv[3]) if len(sys.argv) > 3 else 50
    print('· 统计旧树入度...', file=sys.stderr); A, _ = indeg(a_root)
    print('· 统计新树入度...', file=sys.stderr); B, _ = indeg(b_root)
    la = [t for t, _ in A.most_common(n * 3)]
    lb = [t for t, _ in B.most_common(n * 3)]
    print(f'{"#":>4}  {"旧 2.5.2":<26} {"入度":>6}   {"新 2.6.1":<26} {"入度":>6}')
    print('-' * 82)
    for i in range(n):
        ta = la[i] if i < len(la) else ''
        tb = lb[i] if i < len(lb) else ''
        print(f'{i:>4}  {ta:<26} {A.get(ta,0):>6}   {tb:<26} {B.get(tb,0):>6}')

if __name__ == '__main__':
    main()
