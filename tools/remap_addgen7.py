#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""remap_addgen7.py -- 给 GmRemap 的 CLS/MTH 表加新的一代（自动识别当前代数）

为什么不用旧的 remap_addgen.py：
  它把 'String[][] CLS5' -> 'CLS6' 写死了，只对那一轮有效。
  这里改成自动检测：读当前名字（CLS6），生成 CLS7，并把代码里的 CLS6 引用一起改掉。

用法: remap_addgen7.py <GmRemap.java> <映射json>
  json: {"cls": {"<旧值>": "<新值>|null"}, "mth": {"<旧类>.<旧方法>": ["<新类>","<新方法>"] | null}}
"""
import json, re, sys


def parse_vals(line):
    inner = line[line.index('{') + 1: line.rindex('}')]
    tmp = re.sub(r'"[^"]*"', lambda m: m.group(0).replace(',', '\x00'), inner)
    return [p.strip().replace('\x00', ',') for p in tmp.split(',')]


def unq(v):
    v = v.strip()
    if v == 'null':
        return None
    if len(v) >= 2 and v.startswith('"') and v.endswith('"'):
        return v[1:-1]
    return v


def find_block(src, name):
    i = src.find('String[][] ' + name)
    if i < 0:
        return None
    i = src.find('{', i)
    depth, j = 0, i
    while j < len(src):
        if src[j] == '{':
            depth += 1
        elif src[j] == '}':
            depth -= 1
            if depth == 0:
                break
        j += 1
    return (i, j)


def main():
    path, mapfile = sys.argv[1], sys.argv[2]
    m = json.load(open(mapfile, encoding='utf-8'))
    cls_map, mth_map = m['cls'], m['mth']
    src = open(path, encoding='utf-8').read()

    cur = None
    for g in range(2, 12):
        if 'String[][] CLS%d = {' % g in src:
            cur = g
            break
    if cur is None:
        sys.exit('X 找不到 CLS<N> 表')
    nxt = cur + 1
    print('当前代数 CLS%d -> 目标 CLS%d' % (cur, nxt))

    stats = {'cls_add': 0, 'cls_keep': 0, 'mth_add': 0, 'mth_skip': 0}
    miss = []
    for name, kind in (('CLS%d' % cur, 'cls'), ('MTH', 'mth')):
        seg = find_block(src, name)
        if not seg:
            sys.exit('X 找不到块 ' + name)
        st, en = seg
        block = src[st:en + 1]
        # 关键：按 {...} 整体匹配，不按行切 -- 表里有跨行的行（updatevm.check 折两行）
        #   先把 // 注释剥掉（注释里可能有 { }）
        # ⚠️ 2026-11-13 血证：原写成 re.sub(r'//[^\n]*','',block) ——
        #   剥离后**长度变了**，而后面 out_lines 用 nocmt 的索引去切 block
        #   ⇒ 索引错位，表被写成 {"{"fh6"...
        #   现在替换成**等长空格**，索引严格对齐。
        nocmt = re.sub(r'//[^\n]*', lambda m: ' ' * len(m.group(0)), block)
        out_lines = []
        pos = 0
        for mm in re.finditer(r'\{[^{}]*\}', nocmt):
            ob, cb = mm.start(), mm.end() - 1
            # 该 {...} 前面的原样文本（含注释）直接保留
            out_lines.append(block[pos:ob])
            code = nocmt[ob:cb + 1]
            vals = parse_vals(code)
            if kind == 'cls':
                old = unq(vals[-1])
                key = 'null' if old is None else old
                if old is None:
                    add = 'null'
                elif key in cls_map:
                    v = cls_map[key]
                    add = 'null' if v is None else '"%s"' % v
                    stats['cls_add'] += 1
                else:
                    add = '"%s"' % old
                    stats['cls_keep'] += 1
                    miss.append(('CLS', key))
            else:
                oc, om = unq(vals[-2]), unq(vals[-1])
                key = '%s.%s' % ('null' if oc is None else oc, 'null' if om is None else om)
                if key in mth_map:
                    pair = mth_map[key]
                    add = 'null, null' if pair is None else '"%s", "%s"' % (pair[0], pair[1])
                    stats['mth_add'] += 1
                else:
                    stats['mth_skip'] += 1
                    miss.append(('MTH', key))
                    add = 'null, null'
            body = code.rstrip()
            i = body.rindex('}')
            out_lines.append(body[:i].rstrip() + ', ' + add + '}')
            pos = cb + 1
        out_lines.append(block[pos:])
        src = src[:st] + ''.join(out_lines) + src[en + 1:]

    src = src.replace('String[][] CLS%d = {' % cur, 'String[][] CLS%d = {' % nxt)
    src = re.sub(r'\bCLS%d\b' % cur, 'CLS%d' % nxt, src)
    src = re.sub(r'gen=[0-9.]+', 'gen=2.8.0', src)
    open(path, 'w', encoding='utf-8').write(src)
    print('OK 已加代 ->', path)
    print('   CLS 新增 %d / 沿用 %d ; MTH 新增 %d / 跳过 %d'
          % (stats['cls_add'], stats['cls_keep'], stats['mth_add'], stats['mth_skip']))
    if miss:
        print('\n!! 未登记的键（已保守处理，请人工确认）:')
        for k in miss:
            print('   ', k)


if __name__ == '__main__':
    main()
