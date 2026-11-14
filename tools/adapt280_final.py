#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_final.py —— 2.7.5 → 2.8.0 **逐锚点最终定位**（多证据融合）🐲 尼得亚伯

证据：
  ① 常量串钥匙（稀有串 IDF 投票）—— 类级
  ② 类映射表（adapt280_clsmap / nostr 已定的）—— 给出候选类集合（含拆类碎片）
  ③ 方法体归一化 difflib 相似度 —— 方法级最强
  ④ 形状 + 行数 —— 消歧

输出 tmp/adapt280_final.tsv ，带 sim 置信度，<0.85 标 NEED_EYES
"""
import os, re, sys, json, collections, difflib

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
ANCH = os.path.join(WS, 'tmp/adapt280_fp.json')
IDX = os.path.join(WS, 'tmp/adapt280_str_index.json')
OUT = os.path.join(WS, 'tmp/adapt280_final.tsv')

KINDS = set('IJFDZBCSV')
RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+\s*,\s*"(.*)"\s*$')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
RE_LBL = re.compile(r':[\w_]+')
SKIP = ('.line', '.local', '.param', '.prologue', '.source', '#', '.restart local', '.end local',
        '.annotation', '.end annotation', '.catch', '.end try')

# ── 已人工/半自动确认的 2.7.5 → 2.8.0 类映射 ──
CLSMAP = {
    'a35': 'm35', 'aj0': 'cj0', 'ay9': 'h0a', 'b6': 'a6', 'd6': 'c6',
    'da8': 'dgb', 'dec': 'ee', 'ek7': 'dm7', 'f46': 'b66', 'fk7': 'em7',
    'fy2': 'oy2', 'g37': 's57', 'ghb': 'ghb', 'gp0': 'hp0', 'h40': 'j40',
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


TREE = {}


def index(root):
    if root not in TREE:
        d = {}
        for rt, _, fs in os.walk(root):
            for f in fs:
                if f.endswith('.smali'):
                    d.setdefault(f[:-6], os.path.join(rt, f))
        TREE[root] = d
    return TREE[root]


MCACHE = {}


def methods_of(root, cls):
    k = root + '|' + cls
    if k in MCACHE:
        return MCACHE[k]
    p = index(root).get(cls)
    if not p:
        MCACHE[k] = None
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
                strs = [RE_STR.match(b).group(1) for b in body if RE_STR.match(b)]
                out.append({'name': cur[0], 'sig': cur[1], 'shape': cur[2], 'body': nz,
                            'strings': set(strs), 'nlines': len(nz)})
                cur, body = None, []
            else:
                body.append(ln)
    MCACHE[k] = out
    return out


def main():
    idx = json.load(open(IDX))
    inv, meta = idx['inv'], idx['meta']
    anch = json.load(open(ANCH, encoding='utf-8'))

    rows = []
    done = set()
    for a in anch['anchors']:
        if a['kind'] != 'MTH':
            continue
        oc, om = a['old_cls'], a['old_mth']
        if om is None or (oc, om) in done:
            continue
        done.add((oc, om))
        ms = methods_of(OLD, oc) or []
        ometh = next((m for m in ms if m['name'] == om), None)
        if not ometh:
            rows.append([oc, om, '-', '-', 0.0, 'MISS_OLD'])
            continue

        # 候选类：① 串投票 ② 类映射 ③ 同类其它方法落点
        cands = set()
        if CLSMAP.get(oc):
            cands.add(CLSMAP[oc])
        keys = [k for k in sorted(ometh['strings'], key=lambda s: len(inv.get(s, ())) or 999)[:10] if k in inv]
        vote = collections.Counter()
        for k in keys:
            for c in inv[k]:
                vote[c] += 1.0 / len(inv[k])
        cands.update([c for c, _ in vote.most_common(8)])
        if not cands:
            cands.update(meta.keys())

        best = None
        for c in cands:
            for m in methods_of(NEW, c) or []:
                if m['name'] == '<clinit>':
                    continue
                sh = m['shape'] == ometh['shape']
                # 大方法做 difflib，小方法做精确行比
                if len(ometh['body']) >= 6 or len(m['body']) >= 6:
                    r = difflib.SequenceMatcher(None, ometh['body'], m['body'], autojunk=False).ratio()
                else:
                    r = 1.0 if ometh['body'] == m['body'] else 0.0
                lnok = 1.0 if m['nlines'] == ometh['nlines'] else 0.0
                strj = len(ometh['strings'] & m['strings']) / float(len(ometh['strings']) or 1)
                sc = 0.62 * r + 0.16 * lnok + 0.14 * (1.0 if sh else 0.0) + 0.08 * strj
                if best is None or sc > best[0]:
                    best = (sc, c, m, r, lnok, sh, strj)
        if not best:
            rows.append([oc, om, '-', '-', 0.0, 'NO_CAND'])
            continue
        sc, c, m, r, lnok, sh, strj = best
        verdict = 'OK' if r >= 0.85 else ('NEED_EYES' if r >= 0.6 else 'LOW')
        rows.append([oc, om, c, m['name'], r, '%s sh=%d ln=%d str=%.2f lines=%d/%d' %
                     (verdict, int(sh), int(lnok), strj, ometh['nlines'], m['nlines'])])

    with open(OUT, 'w', encoding='utf-8') as f:
        f.write('old_cls\told_mth\tnew_cls\tnew_mth\tsim\tevidence\n')
        for r in rows:
            f.write('%s\t%s\t%s\t%s\t%.3f\t%s\n' % tuple(r))
    ok = sum(1 for r in rows if r[5].startswith('OK'))
    print('== %d/%d 高置信 ==' % (ok, len(rows)))
    for r in rows:
        flag = '' if r[5].startswith('OK') else '   <<<'
        print('%-8s.%-14s -> %-8s.%-14s %.3f  %s%s' % (r[0], r[1], r[2], r[3], r[4], r[5], flag))
    print('\n→ ' + OUT, file=sys.stderr)


if __name__ == '__main__':
    main()
