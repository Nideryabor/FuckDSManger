#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_brute.py —— 按 (行数, 形状) 全树索引暴力定位小方法 🐲

小方法（<30 行归一化指令）没有常量串，只能靠「形状 + 行数」筛出候选，
再逐个 difflib 比对。先建一次索引，之后秒查。

用法:
  python3 tools/adapt280_brute.py build           # 建索引
  python3 tools/adapt280_brute.py find <类> <方法> [--shape 1] [--tol 0]
"""
import os, re, sys, json, collections, difflib

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
IDX = os.path.join(WS, 'tmp/adapt280_ln_index.json')
KINDS = set('IJFDZBCSV')
RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
RE_LBL = re.compile(r':[\w_]+')
SKIP = ('.line', '.local', '.param', '.prologue', '.source', '#', '.restart local', '.end local',
        '.annotation', '.end annotation', '.catch', '.end try')


def shape_of(params, ret):
    ps, i, n = [], 0, len(params)
    while i < n:
        j = i
        while j < n and params[j] == '[':
            j += 1
        if j >= n:
            break
        if params[j] == 'L':
            k = params.find(';', j)
            if k < 0:
                break
            ps.append('L')
            i = k + 1
        else:
            ps.append(params[j] if params[j] in KINDS else '?')
            i = j + 1
    r = ret.strip()
    return '(' + ''.join(ps) + ')' + (r if r in KINDS or r == 'V' else ('L' if (r.startswith('L') or r.startswith('[')) else '?'))


def norm(ln):
    s = ln.strip()
    if not s or s.startswith(SKIP):
        return ''
    s = RE_TYPE.sub('L;', s)
    s = RE_LBL.sub(':L', s)
    s = RE_NUM.sub('N', s)
    s = RE_REG.sub('V', s)
    return re.sub(r'\s+', ' ', s)


_IDX_CACHE = {}


def pathof(root, cls):
    if root not in _IDX_CACHE:
        d = {}
        for rt, _, fs in os.walk(root):
            for f in fs:
                if f.endswith('.smali'):
                    d.setdefault(f[:-6], os.path.join(rt, f))
        _IDX_CACHE[root] = d
    return _IDX_CACHE[root].get(cls)


def methods(root, cls, path=None):
    p = path or pathof(root, cls)
    if not p:
        return None
    lines = open(p, encoding='utf-8', errors='ignore').read().split('\n')
    out = []
    cur, body = None, []
    for ln in lines:
        mm = RE_METHOD.match(ln)
        if mm and cur is None:
            cur = (mm.group(2), '(' + mm.group(3) + ')' + mm.group(4).strip(), shape_of(mm.group(3), mm.group(4)))
            body = []
            continue
        if cur is not None:
            if RE_END.match(ln):
                nz = [x for x in (norm(b) for b in body) if x]
                out.append({'name': cur[0], 'sig': cur[1], 'shape': cur[2], 'body': nz, 'nlines': len(nz)})
                cur, body = None, []
            else:
                body.append(ln)
    return out


def build():
    idx = collections.defaultdict(list)
    n = 0
    for rt, _, fs in os.walk(NEW):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            cls = f[:-6]
            for m in methods(NEW, cls, os.path.join(rt, f)) or []:
                if m['name'] in ('<clinit>',) or m['nlines'] < 2 or m['nlines'] >= 60:
                    continue
                idx['%d|%s' % (m['nlines'], m['shape'])].append([cls, m['name'], m['name'] + m['sig']])
                n += 1
    json.dump(idx, open(IDX, 'w'), separators=(',', ':'))
    print('小方法 %d，桶 %d → %s' % (n, len(idx), IDX))


def find(cls, mth, want_shape=True, tol=0):
    idx = json.load(open(IDX))
    om = [m for m in (methods(OLD, cls) or []) if m['name'] == mth]
    if not om:
        print('MISS_OLD')
        return
    ometh = om[0]
    print('旧 %s.%s shape=%s lines=%d' % (cls, mth, ometh['shape'], ometh['nlines']))
    cands = []
    for t in range(-tol, tol + 1):
        k = '%d|%s' % (ometh['nlines'] + t, ometh['shape'])
        for c, name, sig in idx.get(k, []):
            cands.append((c, name))
    for k, v in idx.items():
        ln, sh = k.split('|')
        if abs(int(ln) - ometh['nlines']) <= tol and sh == ometh['shape']:
            for c, name, sig in v:
                cands.append((c, name))
    cands = list(dict.fromkeys(cands))
    print('候选 %d 个，逐个比对…' % len(cands))
    scored = []
    for c, name in cands:
        for m in methods(NEW, c) or []:
            if m['name'] != name:
                continue
            r = difflib.SequenceMatcher(None, ometh['body'], m['body'], autojunk=False).ratio()
            scored.append((r, c, name, m['shape'], m['nlines']))
    scored.sort(reverse=True)
    for s in scored[:10]:
        print('  %.3f  %-10s.%-12s shape=%-16s lines=%d' % (s[0], s[1], s[2], s[3], s[4]))


if __name__ == '__main__':
    if sys.argv[1] == 'build':
        build()
    else:
        tol = 0
        if '--tol' in sys.argv:
            tol = int(sys.argv[sys.argv.index('--tol') + 1])
        find(sys.argv[2], sys.argv[3], tol=tol)
