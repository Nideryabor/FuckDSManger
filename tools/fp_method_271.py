#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_method_271.py —— 跨版本「方法名对照」via 签名翻译 🐲 尼得亚伯 2026-10-24

原理：R8 改方法名，但**签名形状**（形参个数 / 各形参的语义类 / 返回类型）可翻译。
  已知「类级映射」后，把旧方法签名里的每个类型按类映射翻成新名，
  再到新类里找**翻译后签名完全一致**的方法 ⇒ 方法名对照。
  （前提：宿主内部类型必须都在映射表里；三方/系统类型原样不动）

用法：
  python3 tools/fp_method_271.py <旧cls.tsv> <新cls.tsv> <映射表.tsv> <目标列表.txt>
映射表.tsv: 每行 "旧名\t新名"（类名不带 L; 前缀）
目标列表.txt: 每行 "旧类名\t新类名1[,新类名2...]"
"""
import sys, re, collections

BASIC = set('IJSBZCFDV')
RE_M = re.compile(r'^(.*?)\s+(\S+?)\((.*?)\)(\S+)$')


def split_types(s):
    """把 'Lgc7;Lnq0;Laq9;I' 拆成类型列表"""
    out, i, n = [], 0, len(s)
    while i < n:
        j = i
        while j < n and s[j] == '[':
            j += 1
        if j >= n:
            break
        if s[j] == 'L':
            k = s.find(';', j)
            if k < 0:
                out.append(s[i:])
                break
            out.append(s[i:k + 1])
            i = k + 1
        else:
            out.append(s[i:j + 1])
            i = j + 1
    return out


def trans_one(t, m):
    """翻译单个类型；查不到映射就保留"""
    pre = ''
    while t.startswith('['):
        pre += '['
        t = t[1:]
    if t.startswith('L') and t.endswith(';'):
        name = t[1:-1]
        base = name.split('$')[0]
        # 只翻译「根包下的混淆短名」（无 '.' 或只有极短前缀）
        if '.' not in name:
            new = m.get(name)
            if new:
                return pre + 'L' + new + ';'
        return pre + t
    return pre + t


def trans_sig(params, ret, m):
    ps = tuple(trans_one(t, m) for t in split_types(params))
    rs = trans_one(ret, m)
    return ps, rs


def load_tsv(p):
    d = {}
    for line in open(p, encoding='utf-8', errors='ignore'):
        cols = line.rstrip('\n').split('\t')
        if len(cols) < 7:
            continue
        d[cols[0]] = {
            'acc': cols[1], 'super': cols[2],
            'impl': [x for x in cols[3].split(',') if x],
            'meth': [x for x in cols[4].split('\x01') if x],
            'fld': [x for x in cols[5].split('\x01') if x],
        }
    return d


def parse_methods(lst):
    out = []
    for raw in lst:
        mm = RE_M.match(raw)
        if not mm:
            continue
        acc, name, params, ret = mm.groups()
        out.append({'acc': acc, 'name': name, 'params': params,
                    'ret': ret, 'raw': raw})
    return out


def main():
    old_p, new_p, map_p, tgt_p = sys.argv[1:5]
    OLD = load_tsv(old_p)
    NEW = load_tsv(new_p)
    M = {}
    for line in open(map_p, encoding='utf-8'):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        a, b = line.split('\t')[:2]
        if b and b != '-':
            M[a.strip()] = b.strip()
    M.setdefault('L', '')

    for line in open(tgt_p, encoding='utf-8'):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        parts = line.split('\t')
        oc = parts[0].strip()
        ncs = [x.strip() for x in parts[1].replace(',', ' ').split()] if len(parts) > 1 else []
        o = OLD.get(oc)
        if not o:
            print(f'\n### L{oc}; ❌ 旧树无此类')
            continue
        print(f'\n### L{oc};  ({len(o["meth"])} 方法) → 候选 {ncs}')
        omeths = parse_methods(o['meth'])
        # 索引新类方法： (params_translated, ret_translated) -> [names]
        for nc in ncs:
            n = NEW.get(nc)
            if not n:
                print(f'   ⚠️ L{nc}; 新树无此类')
                continue
            nmeths = parse_methods(n['meth'])
            idx = collections.defaultdict(list)
            for nm in nmeths:
                ps, rs = trans_sig(nm['params'], nm['ret'], {})  # 新树签名原样
                idx[(tuple(split_types(nm['params'])), nm['ret'])].append(nm['name'])
            hit, miss = [], []
            for om in omeths:
                ps, rs = trans_sig(om['params'], om['ret'], M)
                cand = idx.get((ps, rs))
                if cand:
                    hit.append((om['name'], cand[0], len(cand)))
                else:
                    # 宽松：同参数个数 + 同返回
                    loose = [nm['name'] for nm in nmeths
                             if nm['ret'] == rs and len(split_types(nm['params'])) == len(ps)]
                    miss.append((om['name'], om['raw'], loose[:3]))
            print(f'   ── L{nc};  方法{len(nmeths)}  精确命中 {len(hit)}/{len(omeths)}')
            for a, b, cn in hit:
                flag = '' if a == b else '  ★改名'
                amb = f'  (多候选{cn})' if cn > 1 else ''
                print(f'      {a:<14} → {b:<14}{flag}{amb}')
            for a, raw, loose in miss:
                print(f'      {a:<14} → ❌未命中   宽松:{loose}   [{raw[:110]}]')


if __name__ == '__main__':
    main()
