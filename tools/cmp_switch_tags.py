#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
cmp_switch_tags.py —— 「分派桶」逐 case 对齐器 🐲 尼得亚伯 2026-10-01

为什么需要它（教训 #340）：
    "名字对上了" ≠ "语义对上了"。
    宿主里有一类方法是「按 this.a(tag) 分派的 packed-switch 桶」，
    R8 会把 case 顺序重排 ⇒ 同名 tag 指向完全不同的业务。
    验证方法：把新旧两版的**分派表逐 case 对齐**，用 `check-cast` 的目标类型当**指纹**。

用法：
    python3 tools/cmp_switch_tags.py <旧树里的类.smali> <新树里的类.smali> [方法名]

例（本轮抓出 0xf → 0x12 的那次）：
    python3 tools/cmp_switch_tags.py tmp/h252/p5.smali tmp/h261/x5.smali
"""
import re
import sys


def parse(path):
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    # ① packed-switch 表：.packed-switch 0x0 之后依次列出的 label
    tbl, started = [], False
    for ln in lines:
        s = ln.strip()
        if s.startswith('.packed-switch'):
            started = True
            continue
        if started:
            if re.match(r'^:\w+$', s):
                tbl.append(s)
            elif s.startswith('.end packed-switch'):
                break
    # ② 每个 label 在正文里的位置
    pos = {}
    for i, ln in enumerate(lines):
        s = ln.strip()
        if s in tbl:
            pos.setdefault(s, i)
    # ③ 每个分支段落里最后的 check-cast 目标类型（= 该 case 期望的类型指纹）
    out = []
    for idx, lab in enumerate(tbl):
        a = pos.get(lab)
        if a is None:
            out.append((idx, lab, '??(正文里没找到 label)'))
            continue
        nxt = len(lines)
        for j in range(a + 1, len(lines)):
            s = lines[j].strip()
            if re.match(r'^:\w+$', s) and not re.match(r'^:(cond|goto|try|catch)', s):
                nxt = j
                break
        seg = lines[a:nxt]
        casts = [re.search(r'check-cast \S+, L([\w/$]+);', x).group(1)
                 for x in seg if 'check-cast' in x]
        out.append((idx, lab, ','.join(casts) if casts else '-'))
    return out


def fingerprint(casts):
    """结构指纹：把类型名压成 X / 基本类型名。
    因为 R8 会把**两边都改名**（ns8→k2a、it9→d9b）—— 直接比字符串会把
    "只是改名"误报成"错位"（2026-10-01 晚踩过：s5/a6 被误报 29 处全错位）。
    指纹只看**类型的形状序列**：X、String、Float… 位置和个数对不对。
    """
    if not casts or casts == '-':
        return '-'
    prim = {'java/lang/String', 'java/lang/Float', 'java/lang/Number',
            'java/lang/Boolean', 'java/util/List', 'java/lang/Integer',
            'java/lang/Long', 'java/lang/Double'}
    return ','.join(c if c in prim else 'X' for c in casts.split(','))


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    old, new = parse(sys.argv[1]), parse(sys.argv[2])
    print('tag  | 旧分支 / cast                          || 新分支 / cast                          |')
    print('-----+' + '-' * 42 + '+' + '-' * 42 + '+')
    same = dif = 0
    old_fp = {}
    for i, o in enumerate(old):
        if o[2] not in ('', '-', None):
            old_fp.setdefault(fingerprint(o[2]), []).append(i)
    for i in range(max(len(old), len(new))):
        o = old[i] if i < len(old) else (0, '', '')
        n = new[i] if i < len(new) else (0, '', '')
        if o[2] == n[2] and o[2] not in ('', '-'):
            mark, same = '<== 原样', same + 1
        elif fingerprint(o[2]) == fingerprint(n[2]) and o[2] not in ('', '-'):
            mark, same = '<== 同构(只改名)', same + 1
        elif o[2] != n[2]:
            mark, dif = '~~~ 错位', dif + 1
        else:
            mark = ''
        print(f"0x{i:<3x}| {o[1]:>14} {o[2]:<26} || {n[1]:>14} {n[2]:<26}| {mark}")
    print(f"\n同型 {same} 个 / 错位 {dif} 个")

    # ── ★ 自动配对：没在原位找到同构体的，给出"它跑到哪个 tag 去了"
    print('\n=== 自动配对（形状相同 ⇒ 判为同一个 lambda）===')
    moved = []
    for i, o in enumerate(old):
        if o[2] in ('', '-', None):
            continue
        n = new[i] if i < len(new) else (0, '', '')
        if fingerprint(o[2]) == fingerprint(n[2]):
            continue
        cands = [j for j, x in enumerate(new)
                 if fingerprint(x[2]) == fingerprint(o[2]) and x[2] not in ('', '-')]
        if len(cands) == 1:
            moved.append((i, cands[0], o[2], new[cands[0]][2]))
    if moved:
        for a, b, t, nt in moved:
            print(f"  旧 tag 0x{a:<3x} ({t:<24})  →  新 tag 0x{b:<3x} ({nt})")
    else:
        print('  （没有唯一候选的位移）')
    print('\n★ 只在**会 setResult 覆盖返回值**的那些钩子上，错位才会咬人（其余只是静默不生效）。')



if __name__ == '__main__':
    main()
