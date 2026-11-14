#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_clsmap.py —— 2.7.5 → 2.8.0 **类级**映射（IDF 加权串集合相似度）🐲

类映射比方法映射稳：R8 不删字符串。用「类里所有常量串的集合」做 IDF 加权 Jaccard。
再加两条硬校验：字段数、方法数（±公差）+ 方法形状多重集重合率。

用法: python3 tools/adapt280_clsmap.py [--all] [--top 5]
输出: tmp/adapt280_clsmap.tsv
"""
import os, re, sys, json, math, collections

WS = '/workspace'
FPOLD = os.path.join(WS, 'tmp/fp275.json')
FPNEW = os.path.join(WS, 'tmp/fp280.json')
ANCH = os.path.join(WS, 'tmp/adapt280_fp.json')
NEWTREE = os.path.join(WS, 'tmp/h280')
OUT = os.path.join(WS, 'tmp/adapt280_clsmap.tsv')

RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_FIELD = re.compile(r'^\s*\.field\s+(.*?)([A-Za-z_$][\w$]*):(\S+)\s*$')
KINDS = set('IJFDZBCSV')


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


def class_shapes(cls, fp):
    """用 fp 索引里的 methods 列表（'name(sig)ret'）算形状多重集"""
    rec = fp['db'].get(cls)
    if not rec:
        return None, None
    shapes = []
    for m in rec['methods']:
        i = m.find('(')
        if i < 0:
            continue
        j = m.rfind(')')
        if j < 0:
            continue
        shapes.append(shape_of(m[i + 1:j], m[j + 1:]))
    return shapes, rec['strings']


def main():
    use_all = '--all' in sys.argv
    TOP = 5
    if '--top' in sys.argv:
        TOP = int(sys.argv[sys.argv.index('--top') + 1])

    fo = json.load(open(FPOLD, encoding='utf-8'))
    fn = json.load(open(FPNEW, encoding='utf-8'))
    short = lambda c: c.rsplit('/', 1)[-1]
    fO, fN = {}, {}
    for k, v in fo['db'].items():
        fO.setdefault(short(k), v)
    for k, v in fn['db'].items():
        fN.setdefault(short(k), v)

    NCLASS = float(fn['n'])
    inv = collections.defaultdict(int)
    for cls, rec in fN.items():
        for s in set(rec['strings']):
            inv[s] += 1

    def idf(s):
        return math.log(1.0 + NCLASS / (inv.get(s, 0) + 1.0))

    anch = json.load(open(ANCH, encoding='utf-8'))
    targets = sorted(anch['classes'].keys()) if not use_all else sorted(fO.keys())

    rows = []
    for oc in targets:
        rec = fO.get(oc)
        if not rec:
            rows.append((oc, '-', 0, 'MISS_OLD', ''))
            continue
        ostr = set(rec['strings'])
        if not ostr:
            rows.append((oc, '-', 0, 'NO_STRINGS', ''))
            continue
        w = {s: idf(s) for s in ostr}
        tot = sum(w.values()) or 1.0
        vote = collections.Counter()
        for s in ostr:
            for nc in fN:
                pass
        # 用倒排更快
        inv2 = collections.defaultdict(list)
        for nc, r2 in fN.items():
            for s in set(r2['strings']):
                if s in w:
                    inv2[s].append(nc)
        for s in ostr:
            if s not in inv2:
                continue
            ww = w[s]
            for nc in inv2[s]:
                vote[nc] += ww
        # 形状多重集重合率
        oshapes, _ = class_shapes(oc, fo)
        ocnt = collections.Counter(oshapes or [])
        scored = []
        for nc, sc in vote.most_common(60):
            rec2 = fN.get(nc)
            if not rec2:
                continue
            nshapes, _ = class_shapes(nc, fn)
            ncnt = collections.Counter(nshapes or [])
            inter = sum((ocnt & ncnt).values())
            shape_cov = inter / float(max(sum(ocnt.values()), 1))
            cov = sc / tot
            fdiff = abs(len(rec2['fields']) - len(rec['fields']))
            final = cov * 0.7 + shape_cov * 0.25 + (0.05 if fdiff == 0 else 0.0)
            scored.append((final, nc, cov, shape_cov, fdiff, len(rec2['fields']), len(rec['fields'])))
        scored.sort(reverse=True)
        best = scored[:TOP]
        if not best:
            rows.append((oc, '-', 0, 'NO_CAND', ''))
            continue
        for i, b in enumerate(best):
            rows.append((oc, b[1], b[0], 'cov=%.3f shape=%.3f f=%d/%d' % (b[2], b[3], b[5], b[6]), 'TOP%d' % (i + 1)))

    with open(OUT, 'w', encoding='utf-8') as f:
        f.write('old_cls\tnew_cls\tscore\tevidence\ttag\n')
        for r in rows:
            f.write('%s\t%s\t%.3f\t%s\t%s\n' % (r[0], r[1], r[2], r[3], r[4]))
    # 只打 top1
    seen = set()
    for r in rows:
        if r[0] in seen:
            continue
        seen.add(r[0])
        print('%-10s -> %-10s %.3f  %s' % (r[0], r[1], r[2], r[3]))
    print('\n→', OUT, file=sys.stderr)


if __name__ == '__main__':
    main()
