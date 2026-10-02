#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_method_global.py —— 全局方法定位（第五把武器，兜底杀器）  🐲 尼得亚伯 2026-10-01

用在：类对不上了（R8 把几十个函数合进同一个桶，1:1 映射不存在）。
做法：**不限定类**，在全 dex 里搜「形参 kinds + 返回 kind 相同」的方法，
      再按 ① 方法体字符串交集 ② 方法体里**已映射类型**的交集 打分。

用法：
  python3 tools/fp_method_global.py <旧树> <新树> <映射.tsv> <旧类:方法名,...>
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
    return 'O' if (t.startswith('L') or t.startswith('[')) else t

def parse_tree(root):
    out = {}
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if not fn.endswith('.smali'): continue
            path = os.path.join(dirpath, fn)
            desc = None; methods = {}
            cur = None; S = set(); R = set()
            def flush():
                if cur is not None:
                    methods[cur[0]] = dict(ps=cur[1], ret=cur[2], strings=S.copy(), refs=R.copy())
            try:
                with open(path, 'r', encoding='utf-8', errors='replace') as f:
                    for line in f:
                        line = line.rstrip('\n')
                        if desc is None:
                            m = RE_CLASS.match(line)
                            if m: desc = m.group(2); continue
                        if line.startswith('.method '):
                            flush()
                            m = RE_METHOD.match(line)
                            cur = (m.group(2), parse_params(m.group(3)), m.group(4)) if m else None
                            S = set(); R = set(); continue
                        if line.startswith('.end method'):
                            flush(); cur = None; S = set(); R = set(); continue
                        if cur is None: continue
                        ms = CONST_STR.match(line)
                        if ms:
                            try: S.add(ms.group(1).encode('utf-8','surrogateescape').decode('unicode_escape'))
                            except Exception: S.add(ms.group(1))
                        else:
                            for t in RE_TYPE.findall(line): R.add(t)
            except Exception:
                pass
            flush()
            if desc: out[desc] = methods
    return out

def main():
    old_root, new_root, maps, targets = sys.argv[1:5]
    known = {}
    for line in open(maps):
        line = line.split('#')[0].strip()
        if not line: continue
        p = line.split('\t')
        if len(p) >= 2: known['L'+p[0].strip().lstrip('L').rstrip(';')+';'] = 'L'+p[1].strip().lstrip('L').rstrip(';')+';'
    OLD = parse_tree(old_root); NEW = parse_tree(new_root)
    # 新树所有方法索引（按形状）
    idx = collections.defaultdict(list)
    for d, ms in NEW.items():
        for mn, m in ms.items():
            idx[(len(m['ps']), kind(m['ret']), tuple(kind(x) for x in m['ps']))].append((d, mn, m))
    for item in targets.split(','):
        item = item.strip()
        if ':' not in item: continue
        cn, mn = item.split(':')
        cd = 'L'+cn.lstrip('L').rstrip(';')+';'
        ms = OLD.get(cd)
        if not ms or mn not in ms:
            print(f'\n### {cn}:{mn} ❌ 旧树无此方法'); continue
        m = ms[mn]
        key = (len(m['ps']), kind(m['ret']), tuple(kind(x) for x in m['ps']))
        cands = idx.get(key, [])
        expect = {known[r] for r in m['refs'] if r in known}
        rows = []
        for d, bmn, bm in cands:
            sc = len(bm['strings'] & m['strings']) * 3
            if expect:
                sc += len(bm['refs'] & expect) * 2
            rows.append((sc, d, bmn, bm))
        rows.sort(key=lambda x: -x[0])
        print(f'\n### {cn}:{mn}  → 形状({key[0]}参, 返回{key[1]})  候选{len(cands)}个  期望引用{len(expect)}个')
        for sc, d, bmn, bm in rows[:6]:
            hit = sorted(bm['refs'] & expect) if expect else []
            print(f'   {"★" if sc>6 else "·" if sc>0 else " "} {d:<24} .{bmn:<12} 分{sc:<4}'
                  f' 串{len(bm["strings"]&m["strings"])} 引用命中{len(hit)} {hit[:4]}')

if __name__ == '__main__':
    main()
