#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_locate.py —— 锚点定向定位（2.7.5 → 2.8.0）🐲 尼得亚伯

思路：R8 换类名/方法名，但**方法体内的常量串一字不改**。
  ① 旧锚点方法体 → 取「唯一的 const-string」作为钥匙串
  ② 新树建一次「串 → 类」倒排（只索引稀有串）
  ③ 钥匙串全中 ⇒ 该类就是候选；再在其方法里按 **行数 + 形状** 定方法

用法: python3 tools/adapt280_locate.py [--rebuild]
输出: tmp/adapt280_locate.json
"""
import os, re, sys, json, collections

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
ANCH = os.path.join(WS, 'tmp/adapt280_fp.json')
IDX = os.path.join(WS, 'tmp/adapt280_str_index.json')
OUT = os.path.join(WS, 'tmp/adapt280_locate.json')

RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
RE_LBL = re.compile(r':[\w_]+')
KINDS = set('IJFDZBCSV')
SKIP = ('.line', '.local', '.param', '.prologue', '.source', '#', '.restart local', '.end local', '.annotation', '.end annotation')


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


def iter_methods(path):
    try:
        lines = open(path, encoding='utf-8', errors='ignore').read().split('\n')
    except Exception:
        return
    cur, body = None, []
    for ln in lines:
        mm = RE_METHOD.match(ln)
        if mm and cur is None:
            cur = (mm.group(2), '(' + mm.group(3) + ')' + mm.group(4).strip(), shape_of(mm.group(3), mm.group(4)))
            body = []
            continue
        if cur is not None:
            if RE_END.match(ln):
                strs, nz = [], 0
                for b in body:
                    m = RE_STR.match(b)
                    if m:
                        strs.append(m.group(1))
                    if norm(b):
                        nz += 1
                yield cur[0], cur[1], cur[2], nz, strs
                cur, body = None, []
            else:
                body.append(ln)


def build_index():
    inv = collections.defaultdict(set)
    meta = {}
    n = 0
    for rt, _, fs in os.walk(NEW):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            cls = f[:-6]
            recs, ss = [], set()
            for name, sig, shape, nz, strs in iter_methods(os.path.join(rt, f)):
                recs.append([name, shape, nz])
                ss.update(strs)
                n += 1
            meta[cls] = recs
            for s in ss:
                inv[s].add(cls)
    print('新树方法 %d，串 %d' % (n, len(inv)), file=sys.stderr)
    small = {s: sorted(v) for s, v in inv.items() if len(v) <= 40}
    json.dump({'inv': small, 'meta': meta}, open(IDX, 'w'), separators=(',', ':'))
    print('稀有串 %d → %s' % (len(small), IDX), file=sys.stderr)


def main():
    if '--rebuild' in sys.argv or not os.path.exists(IDX):
        build_index()
    d = json.load(open(IDX))
    inv, meta = d['inv'], d['meta']
    print('索引 %d 稀有串 / %d 类' % (len(inv), len(meta)), file=sys.stderr)

    anch = json.load(open(ANCH, encoding='utf-8'))
    oldpath = {}
    for rt, _, fs in os.walk(OLD):
        for f in fs:
            if f.endswith('.smali'):
                oldpath.setdefault(f[:-6], os.path.join(rt, f))

    results, seen = [], set()
    for a in anch['anchors']:
        note, oc, om = a['note'], a['old_cls'], a['old_mth']
        if om is None or (oc, om) in seen:
            continue
        seen.add((oc, om))
        p = oldpath.get(oc)
        if not p:
            results.append({'note': note, 'old': [oc, om], 'status': 'MISS_OLD'})
            continue
        cand = None
        for name, sig, shape, nz, strs in iter_methods(p):
            if name == om:
                cand = (sig, shape, nz, strs)
                break
        if not cand:
            results.append({'note': note, 'old': [oc, om], 'status': 'MISS_OLD_MTH'})
            continue
        sig, shape, nz, strs = cand
        keys = [k for k in sorted(set(strs), key=lambda s: len(inv.get(s, ())) or 999)[:8] if k in inv]
        vote = collections.Counter()
        for k in keys:
            w = 1.0 / len(inv[k])
            for c in inv[k]:
                vote[c] += w
        cands = [c for c, _ in vote.most_common(14)]
        if not cands:
            for c, recs in meta.items():
                if any(r[2] == nz for r in recs):
                    vote[c] += 0.01
            cands = [c for c, _ in vote.most_common(20)]
        best = None
        for c in cands:
            for r in meta[c]:
                if r[2] != nz or r[1] != shape or r[0] == '<clinit>':
                    continue
                sc = vote[c] + 1.0
                if best is None or sc > best[0]:
                    best = (sc, c, r[0], r[1], r[2])
        if not best:
            for c in cands:
                for r in meta[c]:
                    if r[2] == nz and r[0] != '<clinit>':
                        best = (vote[c] * 0.5, c, r[0], r[1], r[2])
                        break
                if best:
                    break
        if best:
            results.append({'note': note, 'old': [oc, om], 'old_sig': sig, 'old_shape': shape, 'old_lines': nz,
                            'new_cls': best[1], 'new_mth': best[2], 'new_lines': best[4],
                            'keys': keys[:4], 'status': 'OK'})
        else:
            results.append({'note': note, 'old': [oc, om], 'old_sig': sig, 'old_shape': shape, 'old_lines': nz,
                            'keys': keys[:4], 'status': 'FAIL',
                            'top': [(c, round(v, 2)) for c, v in vote.most_common(4)]})

    json.dump(results, open(OUT, 'w'), ensure_ascii=False, indent=1)
    ok = sum(1 for r in results if r['status'] == 'OK')
    print('\n== 方法锚点定位 %d/%d ==' % (ok, len(results)))
    for r in results:
        if r['status'] == 'OK':
            print('%-26s %-20s -> %-10s %-6s  lines %d/%d  keys=%s' %
                  (r['note'], '.'.join(r['old']), r['new_cls'], r['new_mth'], r['old_lines'], r['new_lines'],
                   '|'.join(k[:26] for k in r['keys'][:2])))
        else:
            print('%-26s %-20s !! %s  top=%s  keys=%s' %
                  (r['note'], '.'.join(r['old']), r['status'], r.get('top'), '|'.join(k[:26] for k in r.get('keys', [])[:2])))


if __name__ == '__main__':
    main()
