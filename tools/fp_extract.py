#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""从 smali 树里抽取一个类的「指纹包」：方法签名 / 字段 / const-string。
用法: fp_extract.py <树根> <类名1> <类名2> ...   （类名不带 L;  如 cx2 / x98）
输出: 每个类一段，便于人工挑旗舰指纹。
"""
import os, re, sys, json

CLS_RE = re.compile(r'^\.class\s+(.*?)(L[^;]+;)\s*$')
FIELD_RE = re.compile(r'^\.field\s+(.*?)([A-Za-z_$][\w$]*):(\S+)\s*$')
METH_RE = re.compile(r'^\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)(\([^)]*\)\S+)\s*$')
STR_RE = re.compile(r'^\s*const-string(?:/jumbo)?\s+v\d+,\s*"(.*)"\s*$')

def index(root):
    m = {}
    for dp, _, fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            p = os.path.join(dp, f)
            try:
                with open(p, 'r', encoding='utf-8', errors='replace') as fh:
                    head = fh.read(400)
            except Exception:
                continue
            mm = CLS_RE.search(head.split("\n", 40)[0]) or CLS_RE.search(head)
            if not mm:
                continue
            d = mm.group(2)
            if d.endswith(';'):
                d = d[:-1]
            d = d[1:] if d.startswith('L') else d
            m.setdefault(d, p)
    return m

def parse(path):
    fields, meths, strs, sup = [], [], [], None
    with open(path, 'r', encoding='utf-8', errors='replace') as fh:
        for line in fh:
            s = line.rstrip('\n')
            if s.startswith('.super'):
                sup = s.split()[-1]
            elif s.startswith('.field'):
                fm = FIELD_RE.match(s)
                if fm:
                    fields.append('%s:%s' % (fm.group(2), fm.group(3)))
            elif s.startswith('.method'):
                mm = METH_RE.match(s)
                if mm:
                    meths.append(mm.group(2) + mm.group(3))
            elif 'const-string' in s:
                sm = STR_RE.match(s)
                if sm:
                    strs.append(sm.group(1))
    return sup, fields, meths, strs

def main():
    root = sys.argv[1]
    idx = index(root)
    for name in sys.argv[2:]:
        name = name.strip().lstrip('L').rstrip(';')
        p = idx.get(name)
        if not p:
            print('### %s  【不在树里】' % name)
            continue
        sup, fields, meths, strs = parse(p)
        uniq = []
        seen = set()
        for s in strs:
            if s in seen:
                continue
            seen.add(s)
            uniq.append(s)
        print('### %s  (%s)' % (name, p))
        print('  super: %s' % sup)
        print('  fields(%d): %s' % (len(fields), ' '.join(fields)))
        print('  methods(%d): %s' % (len(meths), ' '.join(meths)))
        print('  strings(%d/%d uniq):' % (len(uniq), len(strs)))
        for s in uniq:
            print('    %r' % s)
        print()

if __name__ == '__main__':
    main()
