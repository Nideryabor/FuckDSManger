#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_hash.py —— 用「归一化方法体哈希」全量对位 2.7.5 → 2.8.0 🐲

原理：
  R8 只改 类型名 / 方法名 / 寄存器分配，**方法体的指令序列骨架不变**。
  所以把方法体每行归一化（抹掉 Lxxx; / v0 / 常量 / 标签名）后求哈希，
  同一个方法在两版里的哈希**完全相同** —— 这是比 SourceInfo 覆盖更广的指纹。

策略：一次扫新树建 hash → [(cls,mth)] 索引；再扫旧树查表。
  同一 hash 多个命中时，用「形状 + 行数 + 相邻方法组」消歧。

用法: python3 tools/adapt280_hash.py [--build-only]
输出: tmp/adapt280_hash_map.tsv
"""
import os, re, sys, json, hashlib, collections

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
OUT = os.path.join(WS, 'tmp/adapt280_hash_map.tsv')
IDX = os.path.join(WS, 'tmp/adapt280_hash_index.json')
ANCH = os.path.join(WS, 'tmp/adapt280_fp.json')

RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
RE_LBL = re.compile(r':[\w_]+')
KINDS = set('IJFDZBCSV')
SKIP_PREFIX = ('.line', '.local', '.param', '.prologue', '.source', '#', '.restart local', '.end local')


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
    if not s or s.startswith(SKIP_PREFIX):
        return ''
    s = RE_STR.sub(lambda m: 'S:' + m.group(1), s)
    s = RE_TYPE.sub('L;', s)
    s = RE_LBL.sub(':L', s)
    s = RE_NUM.sub('N', s)
    s = RE_REG.sub('V', s)
    s = re.sub(r'\s+', ' ', s)
    return s


def scan(root, want_hash_index=False):
    """生成 (cls, name, sig, shape, nlines, h_full, h_loose)"""
    for rt, _, fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            cls = f[:-6]
            try:
                lines = open(os.path.join(rt, f), encoding='utf-8', errors='ignore').read().split('\n')
            except Exception:
                continue
            cur = None
            body = []
            for ln in lines:
                mm = RE_METHOD.match(ln)
                if mm and cur is None:
                    cur = (mm.group(2), '(' + mm.group(3) + ')' + mm.group(4).strip(),
                           shape_of(mm.group(3), mm.group(4)))
                    body = []
                    continue
                if cur is not None:
                    if RE_END.match(ln):
                        yield (cls, cur[0], cur[1], cur[2], body)
                        cur, body = None, []
                    else:
                        body.append(ln)
            if cur is not None:
                yield (cls, cur[0], cur[1], cur[2], body)


def digests(body):
    nz = [x for x in (norm(b) for b in body) if x]
    if not nz:
        return None, None, 0
    j = '\n'.join(nz).encode('utf-8', 'ignore')
    h1 = hashlib.blake2b(j, digest_size=8).hexdigest()
    # 松版：去掉首尾各 2 行（R8 有时会多/少一两条边界指令）
    loose = '\n'.join(nz[2:-2] if len(nz) > 8 else nz).encode('utf-8', 'ignore')
    h2 = hashlib.blake2b(loose, digest_size=8).hexdigest()
    return h1, h2, len(nz)


def build_index():
    idx = collections.defaultdict(list)
    n = 0
    for cls, name, sig, shape, body in scan(NEW):
        h1, h2, nl = digests(body)
        if not h1 or nl < 4:
            continue
        idx[h1].append([cls, name, shape, nl])
        n += 1
    print('新树方法 %d，唯一 hash %d' % (n, len(idx)), file=sys.stderr)
    json.dump(idx, open(IDX, 'w'), separators=(',', ':'))
    print('索引 →', IDX, file=sys.stderr)


def main():
    if '--build-only' in sys.argv or not os.path.exists(IDX):
        build_index()
    idx = json.load(open(IDX))
    print('索引载入 %d' % len(idx), file=sys.stderr)

    anch = json.load(open(ANCH, encoding='utf-8'))
    want = set()
    for a in anch['anchors']:
        want.add((a['old_cls'], a['old_mth']))

    rows = []
    for cls, name, sig, shape, body in scan(OLD):
        key = (cls, name)
        if name not in ('<init>', '<clinit>') and key not in want:
            continue
        h1, h2, nl = digests(body)
        if not h1:
            continue
        hits = idx.get(h1)
        kind = 'EXACT'
        if not hits:
            continue
        rows.append((cls, name, sig, nl, hits))
    print('命中明细 %d 条' % len(rows), file=sys.stderr)

    out = ['old_cls\told_mth\told_sig\tnlines\tnew_cls\tnew_mth\tnew_shape\tnhits']
    for cls, name, sig, nl, hits in rows:
        hits = [h for h in hits if h[3] == nl] or hits
        hits.sort(key=lambda h: (h[3] != nl,))
        for h in hits[:4]:
            out.append('%s\t%s\t%s\t%d\t%s\t%s\t%s\t%d' % (cls, name, sig, nl, h[0], h[1], h[2], len(hits)))
    open(OUT, 'w', encoding='utf-8').write('\n'.join(out) + '\n')
    print('\n'.join(out[:120]))
    print('… 全量 →', OUT, file=sys.stderr)


if __name__ == '__main__':
    main()
