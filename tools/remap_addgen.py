#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""给 GmRemap 的 CLS/MTH 表加新的一代（默认从 2.7.2 列推 2.7.5）。

用法: remap_addgen.py <GmRemap.java> <映射json>
  映射json: {"cls": {"k27": "s27", ...}, "mth": {"k27.D": ["s27","E"], ...}}
  - cls 里值为 null  -> 该锚点在新版未定位（写字符串 "null"，安全失败）
  - mth 里值为 null  -> 该类没登记
"""
import json, re, sys

def parse_vals(line):
    """把 {"a", "b,c", null} 解析成 ['"a"', '"b,c"', 'null']（保护引号内逗号）"""
    inner = line[line.index('{') + 1: line.rindex('}')]
    tmp = re.sub(r'"[^"]*"', lambda m: m.group(0).replace(',', '\x00'), inner)
    return [p.strip().replace('\x00', ',') for p in tmp.split(',')]

def unq(v):
    v = v.strip()
    if v == 'null':
        return None
    if v.startswith('"') and v.endswith('"'):
        return v[1:-1]
    return v

def main():
    path, mapfile = sys.argv[1], sys.argv[2]
    m = json.load(open(mapfile))
    cls_map, mth_map = m['cls'], m['mth']
    lines = open(path, encoding='utf-8').read().split('\n')
    out, in_cls, in_mth, miss = [], False, False, []

    for ln in lines:
        s = ln.strip()
        if 'String[][] CLS5' in ln:
            ln = ln.replace('String[][] CLS5', 'String[][] CLS6')
            in_cls = True
        elif 'String[][] MTH' in ln:
            in_mth = True
        elif in_cls and s.startswith('};'):
            in_cls = False
        elif in_mth and s.startswith('};'):
            in_mth = False

        if (in_cls or in_mth) and s.startswith('{"'):
            vals = parse_vals(ln)
            if in_cls:
                old = unq(vals[-1])                       # 2.7.2 列
                if old is None:
                    new = [None]                          # yp1 那行
                elif old in cls_map:
                    v = cls_map[old]
                    new = [v]
                else:
                    miss.append(('CLS', old)); new = [old]   # 没登记 -> 沿用
                add = ','.join('null' if x is None else '"%s"' % x for x in new)
                ln = ln.rstrip()
                ln = ln.replace('}', ', ' + add + '}', 1)
            else:
                old_cls, old_mth = unq(vals[-2]), unq(vals[-1])
                key = '%s.%s' % (old_cls, old_mth)
                if key in mth_map:
                    pair = mth_map[key]
                    if pair is None:
                        add = 'null, null'
                    else:
                        add = '"%s", "%s"' % (pair[0], pair[1])
                    ln = ln.rstrip().replace('}', ', ' + add + '}', 1)
                else:
                    miss.append(('MTH', key))
        out.append(ln)

    open(path, 'w', encoding='utf-8').write('\n'.join(out))
    print('已加代 ->', path)
    if miss:
        print('未登记的键（沿用旧值，需人工确认）:')
        for k in miss:
            print('   ', k)

if __name__ == '__main__':
    main()
