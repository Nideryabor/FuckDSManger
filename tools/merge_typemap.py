#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
merge_typemap.py —— 类型映射合并去冲突 🐲 尼得亚伯 2026-10-24

从 fp_malign 的投票结果里，只采纳**一对一**的映射：
  · 一个旧类型只投给一个新类型，且该新类型也只被这一个旧类型指着
  · 系统/三方包名（含 '/'）一律丢弃（R8 不动它们）
输出可直接并入类映射表。
"""
import sys, collections

src = sys.argv[1]
dst = sys.argv[2]
extra = sys.argv[3] if len(sys.argv) > 3 else None

fwd = collections.defaultdict(collections.Counter)
for line in open(src, encoding='utf-8'):
    line = line.rstrip('\n')
    if not line or line.startswith('#'):
        continue
    cols = line.split('\t')
    a, b = cols[0], cols[1]
    n = int(cols[2]) if len(cols) > 2 else 1
    fwd[a][b] += n

# 反向：新类型被几个旧类型指着
rev = collections.defaultdict(set)
for a, c in fwd.items():
    for b in c:
        rev[b].add(a)

keep = {}
drop = []
for a, c in fwd.items():
    b, n = c.most_common(1)[0]
    if '/' in a or '/' in b:
        drop.append((a, b, '系统/三方类'))
        continue
    if len(rev[b]) > 1:
        drop.append((a, b, f'新类型被 {len(rev[b])} 个旧类型争（{",".join(sorted(rev[b]))[:60]}）'))
        continue
    if len(c) > 1 and n - c.most_common(2)[1][1] < 2:
        drop.append((a, b, '旧类型多个候选票数接近'))
        continue
    keep[a] = b

out = []
if extra:
    for line in open(extra, encoding='utf-8'):
        line = line.rstrip('\n')
        if line and not line.startswith('#'):
            out.append(line)
for a, b in sorted(keep.items()):
    out.append(f'{a}\t{b}')
open(dst, 'w', encoding='utf-8').write('\n'.join(out) + '\n')

print(f'采纳 {len(keep)} 条，丢弃 {len(drop)} 条 → {dst}')
for a, b, why in drop:
    print(f'   ✗ {a} → {b}   {why}')
