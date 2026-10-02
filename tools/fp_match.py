#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_match.py —— R8 跨版本「类重定位」自动配对器 v2（IDF 加权） 🐲 尼得亚伯 2026-10-01

原理：R8 改「名」不改「形」。
  每个类的**字符串常量集合**是幸存物（SourceInfo / 错误文案 / 协议键名 / 资源名…）。
  用 IDF 加权覆盖率匹配：**稀有串命中权重高**，避免「大类被通用串稀释」。

用法：
  python3 tools/fp_match.py <旧树> <新树> <旧类名> [旧类名 ...]
  python3 tools/fp_match.py <旧树> <新树> --file anchors.txt
"""
import os, re, sys, math, collections

CONST_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')
RE_CLASS  = re.compile(r'^\.class\s+(.*?)\s*(L[^;]+;)\s*$')
RE_SUPER  = re.compile(r'^\.super\s+(L[^;]+;)\s*$')
RE_IMPL   = re.compile(r'^\.implements\s+(L[^;]+;)\s*$')
RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_FIELD  = re.compile(r'^\.field\s+(.*?)\s*([^\s:]+):(.*)$')
RE_SOURCE = re.compile(r'^\.source\s+"(.*)"\s*$')

def unescape(s):
    try:
        return s.encode('utf-8', 'surrogateescape').decode('unicode_escape')
    except Exception:
        return s

def parse_params(s):
    out, i = [], 0
    while i < len(s):
        c = s[i]
        if c == '[':
            i += 1
            while i < len(s) and s[i] == '[':
                i += 1
            c = s[i]
        if c == 'L':
            j = s.find(';', i)
            if j < 0: break
            out.append('O'); i = j + 1
        else:
            out.append(c); i += 1
    return out

def parse_tree(root):
    out = {}
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if not fn.endswith('.smali'):
                continue
            path = os.path.join(dirpath, fn)
            desc = None; sup = None; impls = set(); flags = ''
            strings = set(); methods = []; nfields = 0; source = None
            try:
                with open(path, 'r', encoding='utf-8', errors='replace') as f:
                    for line in f:
                        line = line.rstrip('\n')
                        if desc is None:
                            m = RE_CLASS.match(line)
                            if m:
                                flags, desc = m.group(1), m.group(2); continue
                        if line.startswith('.super '):
                            m = RE_SUPER.match(line)
                            if m: sup = m.group(1)
                        elif line.startswith('.implements '):
                            m = RE_IMPL.match(line)
                            if m: impls.add(m.group(1))
                        elif line.startswith('.source '):
                            m = RE_SOURCE.match(line)
                            if m: source = m.group(1)
                        elif line.startswith('.field '):
                            nfields += 1
                        elif line.startswith('.method '):
                            m = RE_METHOD.match(line)
                            if m:
                                ps = parse_params(m.group(3))
                                methods.append((m.group(2), tuple(ps), m.group(4)))
                        elif 'const-string' in line:
                            m = CONST_STR.match(line)
                            if m: strings.add(unescape(m.group(1)))
            except Exception:
                continue
            if desc:
                out[desc] = dict(strings=strings, super=sup, impls=impls, flags=flags,
                                 methods=methods, nfields=nfields, source=source, path=path)
    return out

def mshape(c):
    return collections.Counter(str((len(p), r)) for (_, p, r) in c['methods'])

def main():
    if len(sys.argv) < 4:
        print(__doc__); sys.exit(1)
    old_root, new_root = sys.argv[1], sys.argv[2]
    args = sys.argv[3:]
    targets = []
    if args and args[0] == '--file':
        targets = [l.strip() for l in open(args[1]) if l.strip() and not l.startswith('#')]
    else:
        targets = args

    print('· 解析旧树...', file=sys.stderr); OLD = parse_tree(old_root)
    print(f'· 解析新树... (旧 {len(OLD)} 类)', file=sys.stderr); NEW = parse_tree(new_root)
    print(f'· 新树 {len(NEW)} 类', file=sys.stderr)

    # 倒排 + IDF
    inv = collections.defaultdict(set)
    for d, c in NEW.items():
        for s in c['strings']:
            inv[s].add(d)
    N = len(NEW)
    def idf(s):
        df = len(inv.get(s, ()))
        return math.log(1 + N / (1 + df))

    for t in targets:
        desc = t if t.startswith('L') else 'L' + t.lstrip('L').rstrip(';') + ';'
        a = OLD.get(desc)
        if not a:
            print(f'\n### {desc}  —— ❌ 旧树里不存在'); continue
        aset = a['strings']
        hdr = (f'\n### {desc}  旧: {a["flags"]}, {len(a["methods"])}方法/{a["nfields"]}字段/'
               f'{len(aset)}串' + (f', .source="{a["source"]}"' if a['source'] else ''))
        print(hdr)
        if not aset:
            print('   ⚠️ 无字符串常量 —— 指纹法失效，需按结构/调用链定位'); continue

        total_w = sum(idf(s) for s in aset)
        sc = collections.Counter(); hitw = collections.Counter(); hit = collections.defaultdict(set)
        for s in aset:
            w = idf(s)
            for d in inv.get(s, ()):
                sc[d] += 1; hitw[d] += w; hit[d].add(s)
        ash = mshape(a)
        ranked = sorted(sc, key=lambda d: -hitw[d])[:6]
        for d in ranked:
            c = NEW[d]
            cov = hitw[d] / total_w if total_w else 0
            nsh = mshape(c)
            shape_sim = (ash == nsh)
            struct = (a['super'] == c['super']) + (len(a['methods']) == len(c['methods'])) \
                     + (a['nfields'] == c['nfields']) + (a['source'] == c['source'] and c['source'] is not None)
            mark = '★' if (cov > 0.75 and struct >= 2) else ('·' if cov > 0.4 else ' ')
            print(f'   {mark} {d:<30} 加权覆盖 {cov*100:5.1f}% ({sc[d]}/{len(aset)}串)  '
                  f'方法{len(a["methods"])}->{len(c["methods"])} 字段{a["nfields"]}->{c["nfields"]} '
                  f'结构{struct}/4 {"[形状全同]" if shape_sim else ""}')
            for s in sorted(hit[d], key=lambda x: -idf(x))[:5]:
                print(f'        「{s[:120]}」')

if __name__ == '__main__':
    main()
