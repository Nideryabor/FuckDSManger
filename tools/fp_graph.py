#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_graph.py —— 用「类型引用图」做 R8 跨版本配对（第三把武器）  🐲 尼得亚伯 2026-10-01

思路：
  前两把武器（字符串 / 形状）对**没有字符串常量**的类失效。
  但这些类会**引用别的类** —— 而那些类可能已经被前两把武器定死了。
  ⇒ 已知映射当锚，看「谁引用了这些锚」来反推剩下的类。

打分：
  forward  = |refs(新候选) ∩ {已知映像(refs(旧锚))}| / |已知映像(refs(旧锚))|   ← 召回
  reverse  = |refs(新候选) ∩ 已知映像集| / |refs(新候选) ∩ 已知映像集|          ← 精确
  综合 = recall*2 + precision

用法：
  python3 tools/fp_graph.py <旧树> <新树> <已知映射.tsv> <待定清单.txt>
  已知映射.tsv 每行: 旧类名<TAB>新类名   （可带 # 注释）
"""
import os, re, sys, collections

RE_TYPE = re.compile(r'L[A-Za-z0-9_$]+(?:/[A-Za-z0-9_$]+)*;')
RE_CLASS = re.compile(r'^\.class\s+(.*?)\s*(L[^;]+;)\s*$')
RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_FIELD = re.compile(r'^\.field\s+(.*?)\s*([^\s:]+):(.*)$')

def kind_of(flags):
    if 'interface' in flags: return 'interface'
    if 'enum' in flags: return 'enum'
    if 'abstract' in flags: return 'abstract'
    if 'final' in flags: return 'final'
    return 'plain'

def parse_tree(root):
    out = {}
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if not fn.endswith('.smali'): continue
            path = os.path.join(dirpath, fn)
            desc = None; flags = ''; refs = set(); nm = 0; nf = 0; strings = set()
            try:
                with open(path, 'r', encoding='utf-8', errors='replace') as f:
                    for line in f:
                        if desc is None:
                            m = RE_CLASS.match(line)
                            if m: flags, desc = m.group(1), m.group(2); continue
                        if line.startswith('.method '): nm += 1
                        elif line.startswith('.field '): nf += 1
                        elif 'const-string' in line:
                            j = line.find('"'); k = line.rfind('"')
                            if j >= 0 and k > j: strings.add(line[j+1:k])
                        for t in RE_TYPE.findall(line):
                            if t != desc: refs.add(t)
            except Exception:
                continue
            if desc:
                out[desc] = dict(refs=refs, kind=kind_of(flags), nm=nm, nf=nf, strings=strings)
    return out

def norm(s):
    s = s.strip()
    if not s: return None
    if s.startswith('L') and s.endswith(';'): return s
    return 'L' + s.lstrip('L').rstrip(';') + ';'

def main():
    old_root, new_root, mapfile, tgtfile = sys.argv[1:5]
    known = {}
    for line in open(mapfile):
        line = line.split('#')[0].strip()
        if not line: continue
        parts = line.split('\t')
        if len(parts) < 2: continue
        o, n = norm(parts[0]), norm(parts[1])
        if o and n: known[o] = n
    inv_known = {v: k for k, v in known.items()}
    print(f'· 已知锚 {len(known)} 条', file=sys.stderr)

    print('· 解析旧树...', file=sys.stderr); OLD = parse_tree(old_root)
    print('· 解析新树...', file=sys.stderr); NEW = parse_tree(new_root)
    targets = [l.strip() for l in open(tgtfile) if l.strip() and not l.startswith('#')]

    # 新树里"已知锚的映像"全集
    known_img = set(known.values())

    for t in targets:
        d = norm(t)
        a = OLD.get(d)
        if not a:
            print(f'\n### {d} ❌ 旧树无'); continue
        # 旧锚引用过的、且已知映射的类 → 期望新候选也引用它们
        expect = {known[r] for r in a['refs'] if r in known}
        print(f'\n### {d}  旧: {a["kind"]} {a["nm"]}方法/{a["nf"]}字段/{len(a["refs"])}引用 '
              f'（其中 {len(expect)} 个引用有已知映像）')
        if not expect:
            print('   ⚠️ 它的引用里没有已知锚 —— 图法失效'); continue
        rows = []
        for nd, c in NEW.items():
            if c['kind'] != a['kind']: continue
            common = c['refs'] & expect
            if not common: continue
            recall = len(common) / len(expect)
            cimg = c['refs'] & known_img
            prec = len(common) / len(cimg) if cimg else 0
            s = recall * 2 + prec
            rows.append((s, nd, c, common, recall, prec))
        rows.sort(key=lambda x: -x[0])
        for s, nd, c, common, recall, prec in rows[:5]:
            back = {inv_known[x] for x in common}
            print(f'   {"★" if s > 1.6 else "·" if s > 1.0 else " "} {nd:<28} 分{s:4.2f} '
                  f'召回{recall*100:4.0f}% 精确{prec*100:4.0f}%  方法{a["nm"]}->{c["nm"]} 字段{a["nf"]}->{c["nf"]}')
            print(f'        命中的调用对象: {sorted(back)[:6]}')
        if not rows:
            print('   （没有候选）')

if __name__ == '__main__':
    main()
