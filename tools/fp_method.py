#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_method.py —— 方法级 + 类型级 对齐（第四把武器）  🐲 尼得亚伯 2026-10-01

场景：类已经配对上了（前几把武器干的），但
  ① 我们 hook 的**方法名**也变了（kf5.K → kh7.x）
  ② 方法签名里的**类型名**也变了（Ley3; → Lyx4;、Lgz3; → ?）

做法：在**配对好的两个类**里，把方法按「形参 kinds + 返回 kind + 方法体字符串」对齐；
     对齐上以后，**形参逐位**给出类型映射（老类型 → 新类型），全库投票取多数。

用法：
  python3 tools/fp_method.py <旧树> <新树> <类映射.tsv> <目标旧类,...>
"""
import os, re, sys, collections

RE_CLASS  = re.compile(r'^\.class\s+(.*?)\s*(L[^;]+;)\s*$')
RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_TYPE   = re.compile(r'L[A-Za-z0-9_$]+(?:/[A-Za-z0-9_$]+)*;')
CONST_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')

def parse_params(s):
    out, i = [], 0
    while i < len(s):
        c = s[i]
        if c == '[':
            i += 1
            while i < len(s) and s[i] == '[': i += 1
            c = s[i]
        if c == 'L':
            j = s.find(';', i)
            if j < 0: break
            out.append(s[i:j+1]); i = j + 1
        else:
            out.append(c); i += 1
    return out

def kind(t):
    if t.startswith('L') or t.startswith('['): return 'O'
    return t

def parse_tree(root):
    out = {}
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if not fn.endswith('.smali'): continue
            path = os.path.join(dirpath, fn)
            desc = None; flags = ''; methods = {}
            cur = None; body = []
            def flush():
                if cur is not None:
                    methods[cur[0]] = dict(ps=cur[1], ret=cur[2],
                                           strings=set(x for x in body if isinstance(x, str)),
                                           refs=set(r for x in body if not isinstance(x, str) for r in [x]))
            try:
                with open(path, 'r', encoding='utf-8', errors='replace') as f:
                    for line in f:
                        line = line.rstrip('\n')
                        if desc is None:
                            m = RE_CLASS.match(line)
                            if m: flags, desc = m.group(1), m.group(2); continue
                        if line.startswith('.method '):
                            if cur is not None: flush()
                            m = RE_METHOD.match(line)
                            if m:
                                cur = (m.group(2), parse_params(m.group(3)), m.group(4))
                                body = []
                            else:
                                cur = None
                            continue
                        if line.startswith('.end method'):
                            flush(); cur = None; body = []; continue
                        if cur is None: continue
                        ms = CONST_STR.match(line)
                        if ms:
                            try: body.append(ms.group(1).encode('utf-8','surrogateescape').decode('unicode_escape'))
                            except Exception: body.append(ms.group(1))
                        else:
                            for t in RE_TYPE.findall(line):
                                body.append(t)
            except Exception:
                pass
            flush()
            if desc:
                out[desc] = dict(methods=methods, flags=flags)
    return out

def main():
    old_root, new_root, maps, targets = sys.argv[1:5]
    known = {}
    for line in open(maps):
        line = line.split('#')[0].strip()
        if not line: continue
        p = line.split('\t')
        if len(p) >= 2: known[p[0].strip()] = p[1].strip()
    OLD = parse_tree(old_root); NEW = parse_tree(new_root)
    tlist = targets.split(',') if targets != 'ALL' else list(known)

    typevotes = collections.Counter()
    for a_name in tlist:
        a_desc = 'L'+a_name+';' if not a_name.startswith('L') else a_name
        b_desc = known.get(a_name) or known.get(a_desc)
        if not b_desc: continue
        b_desc = 'L'+b_desc+';' if not b_desc.startswith('L') else b_desc
        A = OLD.get(a_desc); B = NEW.get(b_desc)
        if not A or not B: 
            print(f'\n### {a_desc} -> {b_desc}  ⚠️ 缺树'); continue
        print(f'\n### {a_desc} -> {b_desc}   ({len(A["methods"])} vs {len(B["methods"])} 方法)')
        used = set()
        for mname, m in A['methods'].items():
            best = None
            for bn, bm in B['methods'].items():
                if bn in used: continue
                if kind(bm['ret']) != kind(m['ret']): continue
                if len(bm['ps']) != len(m['ps']): continue
                if [kind(x) for x in bm['ps']] != [kind(x) for x in m['ps']]: continue
                sc = len(bm['strings'] & m['strings']) * 3
                sc += len(bm['refs'] & {known[r] for r in m['refs'] if r in known})
                if best is None or sc > best[0]: best = (sc, bn, bm)
            if not best:
                print(f'   ? {mname}{m["refs"] and ""}  无同形候选')
                continue
            sc, bn, bm = best
            used.add(bn)
            print(f'   {mname:<14} -> {bn:<14} 分数{sc}  参数 {len(m["ps"])} 个')
            for o, n in zip(m['ps'], bm['ps']):
                if o != n and (o.startswith('L') or n.startswith('L')):
                    typevotes[(o, n)] += 1
            if m['ret'] != bm['ret'] and m['ret'].startswith('L'):
                typevotes[(m['ret'], bm['ret'])] += 1
    print('\n\n========== 类型映射投票（老 -> 新, 票数）==========')
    agg = {}
    for (o, n), v in typevotes.items():
        agg.setdefault(o, []).append((v, n))
    for o in sorted(agg):
        lst = sorted(agg[o], reverse=True)[:3]
        print(f'  {o:<34} -> ' + '   '.join(f'{n}({v})' for v, n in lst))

if __name__ == '__main__':
    main()
