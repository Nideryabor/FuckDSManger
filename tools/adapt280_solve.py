#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_solve.py —— 宿主 2.7.5 → 2.8.0 锚点全自动对位 🐲 尼得亚伯

三路信号：
  A 方法体归一化字节码（抹掉 R8 换掉的 Lxxx; 类型名与 v/p 寄存器号）—— 最强的「逐行同形」
  B 方法体 const-string 的 IDF 加权覆盖率
  C 形状（参数每位 kind + 返回 kind）+ 行数

流程：
  1) 类级：旧类常串 → 新树倒排投票（IDF 加权）→ top-K 候选
  2) 方法级：在候选类里按 A+B+C 打分定位
  3) 输出 tmp/adapt280_map.tsv

用法: python3 tools/adapt280_solve.py [--k 5]
"""
import os, re, sys, json, math, collections

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
FPOLD = os.path.join(WS, 'tmp/fp275.json')
FPNEW = os.path.join(WS, 'tmp/fp280.json')
ANCH = os.path.join(WS, 'tmp/adapt280_fp.json')
OUT = os.path.join(WS, 'tmp/adapt280_map.tsv')

RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_FIELD = re.compile(r'^\s*\.field\s+(.*?)([A-Za-z_$][\w$]*):(\S+)\s*$')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
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


def norm_line(ln):
    s = ln.strip()
    if not s or s.startswith('#') or s.startswith('.line') or s.startswith('.local') or s.startswith('.param'):
        return ''
    s = RE_STR.sub(lambda m: 'S:' + m.group(1), s)
    s = RE_TYPE.sub('L;', s)
    s = RE_NUM.sub('N', s)
    s = RE_REG.sub('V', s)
    s = re.sub(r'^:[\w_]+$', ':L', s)
    s = re.sub(r'\s+', ' ', s)
    return s


def mk_method(name, sig, shape, body):
    nz = [x for x in (norm_line(b) for b in body) if x]
    return {'name': name, 'sig': sig, 'shape': shape, 'body': nz,
            'ngrams': set(tuple(nz[i:i + 3]) for i in range(max(0, len(nz) - 2))),
            'strings': set(re.findall(r'S:([^"\\]*)', '\n'.join(nz))),
            'nlines': len(nz)}


def parse_class(path):
    try:
        lines = open(path, encoding='utf-8', errors='ignore').read().split('\n')
    except Exception:
        return None
    methods, fields = {}, []
    cur, body = None, []
    for ln in lines:
        fm = RE_FIELD.match(ln)
        if fm and cur is None:
            fields.append(fm.group(3))
        mm = RE_METHOD.match(ln)
        if mm and cur is None:
            cur = (mm.group(2), '(' + mm.group(3) + ')' + mm.group(4).strip(), shape_of(mm.group(3), mm.group(4)))
            body = []
            continue
        if cur is not None:
            if RE_END.match(ln):
                methods[cur[0] + cur[1]] = mk_method(cur[0], cur[1], cur[2], body)
                cur, body = None, []
            else:
                body.append(ln)
    if cur is not None:
        methods[cur[0] + cur[1]] = mk_method(cur[0], cur[1], cur[2], body)
    return {'fields': fields, 'methods': methods}


class LazyTree(object):
    """惰性 smali 树：只有被访问的类才解析"""

    def __init__(self, root):
        self.root = root
        self.cache = {}
        self.index = {}
        for rt, _, fs in os.walk(root):
            for f in fs:
                if f.endswith('.smali'):
                    self.index[f[:-6]] = os.path.join(rt, f)

    def __contains__(self, cls):
        return cls in self.index

    def __len__(self):
        return len(self.index)

    def __getitem__(self, cls):
        if cls not in self.cache:
            d = parse_class(self.index[cls]) or {'fields': [], 'methods': {}}
            d['path'] = self.index[cls]
            self.cache[cls] = d
        return self.cache[cls]

    def keys(self):
        return self.index.keys()


def jac(a, b):
    if not a or not b:
        return 0.0
    i = len(a & b)
    return i / float(len(a) + len(b) - i)


def main():
    K = 6
    if '--k' in sys.argv:
        K = int(sys.argv[sys.argv.index('--k') + 1])

    o = LazyTree(OLD)
    n = LazyTree(NEW)
    print('旧 %d 类 / 新 %d 类' % (len(o), len(n)), file=sys.stderr)

    fpO = json.load(open(FPOLD, encoding='utf-8'))
    fpN = json.load(open(FPNEW, encoding='utf-8'))
    NCLASS = float(fpN['n'])
    short = lambda c: c.rsplit('/', 1)[-1]
    inv = collections.defaultdict(set)
    for cls, rec in fpN['db'].items():
        for s in set(rec['strings']):
            inv[s].add(short(cls))

    idf_cache = {}

    def idf(s):
        if s not in idf_cache:
            df = len(inv.get(s, ()))
            idf_cache[s] = math.log(1.0 + NCLASS / (df + 1.0)) if df else 6.5
        return idf_cache[s]

    # 旧树串（按短名索引）
    fpShort = {}
    for cls, rec in fpO['db'].items():
        fpShort.setdefault(short(cls), set()).update(rec['strings'])

    anch = json.load(open(ANCH, encoding='utf-8'))
    targets = sorted(anch['classes'].keys())

    # ── 类级候选 ──
    cls_cand = {}
    for oc in targets:
        ostr = fpShort.get(oc, set())
        cands = collections.Counter()
        for s in ostr:
            for nc in inv.get(s, ()):
                cands[nc] += idf(s)
        # 方法体 n-gram 二次校验（只对 top 40 做，省算力）
        top = [c for c, _ in cands.most_common(40)]
        osig = set()
        if oc in o:
            for m in o[oc]['methods'].values():
                osig.update(sorted(m['ngrams'])[:80])
        scored = []
        of = len(o[oc]['fields']) if oc in o else 0
        omm = len(o[oc]['methods']) if oc in o else 0
        for nc in top:
            if nc not in n:
                continue
            nd = n[nc]
            nsig = set()
            for m in nd['methods'].values():
                nsig.update(sorted(m['ngrams'])[:80])
            ng = jac(osig, nsig)
            fs = 1.0 - abs(len(nd['fields']) - of) / float(max(of, len(nd['fields']), 1))
            ms = 1.0 - abs(len(nd['methods']) - omm) / float(max(omm, len(nd['methods']), 1))
            scored.append((cands[nc] * (0.5 + 0.3 * ng + 0.15 * fs + 0.05 * ms), nc, cands[nc], ng, fs, ms))
        scored.sort(reverse=True)
        cls_cand[oc] = scored[:K]

    lines = ['note\told_cls\told_mth\tnew_cls\tnew_mth\tnew_sig\tconf\tevidence']
    fails = []

    for a in anch['anchors']:
        note, oc, om = a['note'], a['old_cls'], a['old_mth']
        cand = cls_cand.get(oc) or []
        if not cand:
            fails.append((note, oc, om, '无候选类'))
            continue

        if a['kind'] == 'CLS' or not om:
            b0 = cand[0]
            lines.append('%s\t%s\t-\t%s\t-\t-\t%.2f\tcls=%.1f ng=%.2f f=%d/%d m=%d/%d' %
                         (note, oc, b0[1], b0[0], b0[2], b0[3],
                          len(n[b0[1]]['fields']), a.get('field_count', 0) or (len(o[oc]['fields']) if oc in o else 0),
                          len(n[b0[1]]['methods']), len(o[oc]['methods']) if oc in o else 0))
            continue

        om_ = [m for m in o[oc]['methods'].values() if m['name'] == om]
        if not om_:
            fails.append((note, oc, om, '旧树无此方法'))
            continue
        ometh = om_[0]
        best = None
        for score_cls, nc, raw, ng, fs, ms in cand:
            for nm in n[nc]['methods'].values():
                if nm['name'] == '<clinit>' or nm['name'] == '<init>':
                    if ometh['name'] not in ('<init>',):
                        continue
                sh = 1.0 if nm['shape'] == ometh['shape'] else 0.0
                a_ = jac(ometh['ngrams'], nm['ngrams'])
                b_ = 0.0
                if ometh['strings']:
                    tot = sum(idf(s) for s in ometh['strings'])
                    b_ = sum(idf(s) for s in (ometh['strings'] & nm['strings'])) / tot if tot else 0.0
                ln_ = 1.0 - abs(nm['nlines'] - ometh['nlines']) / float(max(nm['nlines'], ometh['nlines'], 1))
                sc = 0.55 * a_ + 0.28 * b_ + 0.12 * sh + 0.05 * ln_
                ev = 'ng=%.2f st=%.2f sh=%d ln=%d/%d cls=%.1f' % (a_, b_, int(sh), nm['nlines'], ometh['nlines'], score_cls)
                if best is None or sc > best[0]:
                    best = (sc, nc, nm, ev)
        if best:
            lines.append('%s\t%s\t%s\t%s\t%s\t%s\t%.3f\t%s' %
                         (note, oc, om, best[1], best[2]['name'], best[2]['sig'], best[0], best[3]))
        else:
            fails.append((note, oc, om, '方法未定位'))

    open(OUT, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
    for ln in lines:
        print(ln)
    print('\n未定位 %d 条:' % len(fails), file=sys.stderr)
    for f in fails:
        print('   ', ' | '.join(f), file=sys.stderr)


if __name__ == '__main__':
    main()
