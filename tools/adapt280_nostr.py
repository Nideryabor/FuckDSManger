#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_nostr.py —— 「无常量串」小类的形状级定位 + 类内方法定位 🐲

两类问题：
  A 类没有常量串（纯数据类/接口/Shape 实现）⇒ 用「字段类型多重集 + 方法形状多重集 + 行数」全树搜
  B 方法没有常量串（小方法）⇒ 已定类后，用「形状 + 行数 + 类内相对位置」定方法

用法:
  python3 tools/adapt280_nostr.py cls <旧类名> [旧类名...]
  python3 tools/adapt280_nostr.py mth <旧类> <旧方法> <新类1[,新类2...]>
"""
import os, re, sys, json, collections, difflib

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
KINDS = set('IJFDZBCSV')

RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_FIELD = re.compile(r'^\s*\.field\s+(.*?)([A-Za-z_$][\w$]*):(\S+)\s*$')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
RE_LBL = re.compile(r':[\w_]+')
SKIP = ('.line', '.local', '.param', '.prologue', '.source', '#', '.restart local', '.end local',
        '.annotation', '.end annotation', '.catch', '.end try')


def fshape(t):
    t = t.strip()
    if t.startswith('['):
        return '[' + fshape(t[1:])
    if t.startswith('L'):
        return 'L'
    return t


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


def parse(path):
    lines = open(path, encoding='utf-8', errors='ignore').read().split('\n')
    fields, methods = [], {}
    cur, body = None, []
    for ln in lines:
        fm = RE_FIELD.match(ln)
        if fm and cur is None:
            fields.append(fshape(fm.group(3)))
        mm = RE_METHOD.match(ln)
        if mm and cur is None:
            cur = (mm.group(2), '(' + mm.group(3) + ')' + mm.group(4).strip(), shape_of(mm.group(3), mm.group(4)))
            body = []
            continue
        if cur is not None:
            if RE_END.match(ln):
                nz = [x for x in (norm(b) for b in body) if x]
                methods[cur[0] + cur[1]] = {'name': cur[0], 'sig': cur[1], 'shape': cur[2], 'body': nz}
                cur, body = None, []
            else:
                body.append(ln)
    return {'fields': fields, 'methods': methods, 'nlines': len(lines), 'path': path}


CACHE = {}


def tree(root):
    if root in CACHE:
        return CACHE[root]
    idx = {}
    for rt, _, fs in os.walk(root):
        for f in fs:
            if f.endswith('.smali'):
                idx[f[:-6]] = os.path.join(rt, f)
    CACHE[root] = idx
    return idx


def get(root, cls):
    idx = tree(root)
    p = idx.get(cls)
    if not p:
        return None
    k = root + '|' + cls
    if k not in CACHE:
        CACHE[k] = parse(p)
    return CACHE[k]


def cls_template(d):
    return (len(d['fields']), tuple(sorted(collections.Counter(d['fields']).items())),
            tuple(sorted(collections.Counter(m['shape'] for m in d['methods'].values()).items())))


def cmd_cls(names):
    oi, ni = tree(OLD), tree(NEW)
    # 新树全部类模板（一次）
    tp = collections.defaultdict(list)
    for nc in ni:
        try:
            d = get(NEW, nc)
        except Exception:
            continue
        if d is None:
            continue
        tp[cls_template(d)].append(nc)
    for oc in names:
        d = get(OLD, oc)
        if not d:
            print('%-8s MISS_OLD' % oc)
            continue
        t = cls_template(d)
        cands = tp.get(t, [])
        print('%-8s f=%d m=%d lines=%d -> %s' % (oc, len(d['fields']), len(d['methods']), d['nlines'],
                                                 ','.join(cands[:8]) if cands else 'NONE'))
        for c in cands[:8]:
            nd = get(NEW, c)
            print('         %-8s lines=%-6d f=%d m=%d' % (c, nd['nlines'], len(nd['fields']), len(nd['methods'])))


def cmd_mth(oc, om, ncs):
    d = get(OLD, oc)
    if not d:
        print('MISS_OLD')
        return
    cand = [m for m in d['methods'].values() if m['name'] == om]
    if not cand:
        print('MISS_OLD_MTH')
        return
    ometh = cand[0]
    # 旧类内方法顺序（用于相对位置）
    order = list(d['methods'].values())
    opos = order.index(ometh)
    print('旧 %s.%s  shape=%s lines=%d pos=%d/%d' % (oc, om, ometh['shape'], len(ometh['body']), opos, len(order)))
    for nc in ncs.split(','):
        nd = get(NEW, nc)
        if not nd:
            print('  %-8s MISS_NEW' % nc)
            continue
        scored = []
        for m in nd['methods'].values():
            if m['name'] == '<clinit>':
                continue
            sh = 1.0 if m['shape'] == ometh['shape'] else 0.0
            sm = difflib.SequenceMatcher(None, ometh['body'], m['body'], autojunk=False)
            r = sm.ratio()
            scored.append((r * 0.85 + sh * 0.15, m['name'], m['shape'], len(m['body']), r, sh))
        scored.sort(reverse=True)
        print('  == %s (f=%d m=%d)' % (nc, len(nd['fields']), len(nd['methods'])))
        for s in scored[:6]:
            print('     %-6s shape=%-14s lines=%-5d sim=%.3f sh=%d  => %.3f' % (s[1], s[2], s[3], s[4], s[5], s[0]))


if __name__ == '__main__':
    if sys.argv[1] == 'cls':
        cmd_cls(sys.argv[2:])
    else:
        cmd_mth(sys.argv[2], sys.argv[3], sys.argv[4])
