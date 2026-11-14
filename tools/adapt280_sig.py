#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_sig.py —— 用「签名翻译 + 全树唯一定位」收尾 🐲 尼得亚伯

思路（指南里的 sig_translate）：
  R8 换的是名字，**签名结构（参数个数/种类/顺序 + 返回类型种类）不变**。
  把旧签名里的类型先翻译成 2.8.0 的名字（用 CLSMAP），再到新树里找
  「签名完全相等」的方法 —— 常常是**全树唯一**。

对没有 CLSMAP 的类型，退化为「形状匹配 + 行数」再 difflib。

用法: python3 tools/adapt280_sig.py
输出: tmp/adapt280_sig.tsv
"""
import os, re, sys, json, collections, difflib

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
ANCH = os.path.join(WS, 'tmp/adapt280_fp.json')
OUT = os.path.join(WS, 'tmp/adapt280_sig.tsv')
SIGIDX = os.path.join(WS, 'tmp/adapt280_sig_index.json')

KINDS = set('IJFDZBCSV')
RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
RE_LBL = re.compile(r':[\w_]+')
SKIP = ('.line', '.local', '.param', '.prologue', '.source', '#', '.restart local', '.end local',
        '.annotation', '.end annotation', '.catch', '.end try')

CLSMAP = {
    'a35': 'm35', 'aj0': 'cj0', 'ay9': 'h0a', 'b6': 'a6', 'd6': 'c6',
    'da8': 'dgb', 'dec': 'ee', 'ek7': 'dm7', 'f46': 'b66', 'fk7': 'em7',
    'fy2': 'oy2', 'g37': 's57', 'gp0': 'hp0', 'h40': 'j40',
    'h42': 'p42', 'hx2': 'qx2', 'ks0': 'ls0', 'ls0': 'ms0', 'ni7': 'lk7',
    'nk2': 'wk2', 'oc5': 'je5', 'p67': 's17', 'pg7': 'yg7', 'q23': 'oy5',
    'q88': 'ra8', 'qb9': 'yd9', 'qj5': 'll5', 'rf': 'rf', 's27': 'q57',
    'sj0': 'uj0', 'tj7': 'sl7', 'ug9': 'd89', 'v15': 'h25', 'vo0': 'xo0',
    'vx6': 'zw7', 'vy9': 'e1a', 'wx6': 'u48', 'y2c': 'qgc', 'y82': 'g92',
    'yb0': 'ac0', 'yr': 'zr', 'yu7': 'o8a', 'yy9': 'h1a', 'z5': 'y5',
    'zaa': 'kda', 'zi': 'aj', 'zi0': 'bj0', 'zs': 'at',
}


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


def split_types(sig):
    """'(Lx;I)V' -> (['Lx;','I'], 'V')"""
    m = re.match(r'^\((.*)\)(\S+)$', sig)
    if not m:
        return None, None
    ps, i, n = [], 0, len(m.group(1))
    body = m.group(1)
    while i < n:
        j = i
        while j < n and body[j] == '[':
            j += 1
        if j >= n:
            break
        if body[j] == 'L':
            k = body.find(';', j)
            if k < 0:
                break
            ps.append(body[i:k + 1])
            i = k + 1
        else:
            ps.append(body[i:j + 1])
            i = j + 1
    return ps, m.group(2).strip()


def translate_type(t):
    """把类型里的 Lxxx; 用 CLSMAP 翻译；未知保持 ''（通配）"""
    arr = ''
    while t.startswith('['):
        arr += '['
        t = t[1:]
    if t.startswith('L'):
        inner = t[1:-1]
        base = inner.rsplit('/', 1)[-1]
        pkg = inner[:-(len(base) + 1)] if '/' in inner else ''
        if base in CLSMAP:
            nb = CLSMAP[base]
            return arr + 'L' + (pkg + '/' if pkg else '') + nb + ';'
        return arr + 'L?;'
    return arr + t


def translate_sig(sig):
    ps, ret = split_types(sig)
    if ps is None:
        return None
    return '(' + ''.join(translate_type(t) for t in ps) + ')' + translate_type(ret)


_PIDX = {}
_MCACHE = {}


def pathof(root, cls):
    if root not in _PIDX:
        d = {}
        for rt, _, fs in os.walk(root):
            for f in fs:
                if f.endswith('.smali'):
                    d.setdefault(f[:-6], os.path.join(rt, f))
        _PIDX[root] = d
    return _PIDX[root].get(cls)


def methods(root, cls, path=None):
    k = root + '|' + cls
    if k in _MCACHE:
        return _MCACHE[k]
    p = path or pathof(root, cls)
    if not p or not os.path.exists(p):
        _MCACHE[k] = None
        return None
    lines = open(p, encoding='utf-8', errors='ignore').read().split('\n')
    out = {}
    cur, body = None, []
    for ln in lines:
        mm = RE_METHOD.match(ln)
        if mm and cur is None:
            cur = (mm.group(2), '(' + mm.group(3) + ')' + mm.group(4).strip())
            body = []
            continue
        if cur is not None:
            if RE_END.match(ln):
                nz = [x for x in (norm(b) for b in body) if x]
                out[cur[0] + cur[1]] = {'name': cur[0], 'sig': cur[1], 'body': nz,
                                        'shape': shape_of(*split_types(cur[1])), 'nlines': len(nz)}
                cur, body = None, []
            else:
                body.append(ln)
    _MCACHE[k] = out
    return out


def build_index():
    """签名 → [(cls, key)]"""
    idx = collections.defaultdict(list)
    n = 0
    for rt, _, fs in os.walk(NEW):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            cls = f[:-6]
            for key, m in (methods(NEW, cls, os.path.join(rt, f)) or {}).items():
                idx[m['sig']].append([cls, key])
                n += 1
    json.dump(idx, open(SIGIDX, 'w'), separators=(',', ':'))
    print('签名 %d 个类记录 %d → %s' % (len(idx), n, SIGIDX))


def main():
    if not os.path.exists(SIGIDX):
        build_index()
    idx = json.load(open(SIGIDX))
    anch = json.load(open(ANCH, encoding='utf-8'))

    rows, done = [], set()
    for a in anch['anchors']:
        if a['kind'] != 'MTH':
            continue
        oc, om = a['old_cls'], a['old_mth']
        if om is None or (oc, om) in done:
            continue
        done.add((oc, om))
        ms = methods(OLD, oc) or {}
        ometh = next((m for m in ms.values() if m['name'] == om), None)
        if not ometh:
            rows.append([oc, om, '-', '-', '-', 0.0, 'MISS_OLD'])
            continue
        tsig = translate_sig(ometh['sig'])
        hits = idx.get(tsig, []) if tsig else []
        # 同形状的（翻译含通配），再按名字/行数筛
        if not hits:
            lo = ometh['nlines']
            cands = []
            for s, lst in idx.items():
                if len(lst) > 60:
                    continue
                if s.endswith(ometh['shape'][-1]) and s.split(')')[0].count('L') == ometh['shape'].split(')')[0].count('L'):
                    cands.extend(lst)
            hits = cands[:400]
        best = None
        for c, key in hits:
            nm = methods(NEW, c) or {}
            m = nm.get(key)
            if not m:
                continue
            if m['name'] == '<clinit>':
                continue
            r = difflib.SequenceMatcher(None, ometh['body'], m['body'], autojunk=False).ratio()
            bonus = 0.15 if m['nlines'] == ometh['nlines'] else 0.0
            sc = r + bonus
            if best is None or sc > best[0]:
                best = (sc, c, m, r, m['nlines'] == ometh['nlines'])
        if not best:
            rows.append([oc, om, '-', '-', tsig or '-', 0.0, 'NO_SIG_HIT'])
            continue
        sc, c, m, r, lnok = best
        rows.append([oc, om, c, m['name'], tsig or '-', r, 'sig_hits=%d ln_ok=%d lines=%d/%d' %
                     (len(hits), int(lnok), ometh['nlines'], m['nlines'])])

    with open(OUT, 'w', encoding='utf-8') as f:
        f.write('old_cls\told_mth\tnew_cls\tnew_mth\ttsig\tsim\tevidence\n')
        for r in rows:
            f.write('%s\t%s\t%s\t%s\t%s\t%.3f\t%s\n' % tuple(r))
    for r in rows:
        flag = '' if r[5] >= 0.85 else ' <<<'
        print('%-8s.%-12s -> %-8s.%-12s %.3f  %s%s' % (r[0], r[1], r[2], r[3], r[5], r[6], flag))
    print('\n→ ' + OUT, file=sys.stderr)


if __name__ == '__main__':
    main()
