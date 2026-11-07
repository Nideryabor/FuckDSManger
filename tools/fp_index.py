#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把一棵 smali 树建成指纹库：cls -> super/fields/methods/strings，并统计每个串出现在多少个类里。
用法:
  fp_index.py build <树根> <out.json>
  fp_index.py show  <out.json> <类名...>        # 只看「全树唯一」的串 + 方法签名
"""
import os, re, sys, json

CLS_RE = re.compile(r'^\.class\s+(.*?)(L[^;]+;)\s*$')
FIELD_RE = re.compile(r'^\.field\s+(.*?)([A-Za-z_$][\w$]*):(\S+)\s*$')
METH_RE = re.compile(r'^\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)(\([^)]*\)\S+)\s*$')
STR_RE = re.compile(r'^\s*const-string(?:/jumbo)?\s+v\d+,\s*"(.*)"\s*$')


def build(root, out):
    db = {}
    seen = set()
    for dp, _, fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            p = os.path.join(dp, f)
            sup = None
            fields, meths, strs = [], [], []
            try:
                fh = open(p, 'r', encoding='utf-8', errors='replace')
            except Exception:
                continue
            with fh:
                for line in fh:
                    if line.startswith('.class'):
                        m = CLS_RE.match(line.rstrip('\n'))
                        if m:
                            d = m.group(2)[1:-1]
                        continue
                    if line.startswith('.super'):
                        sup = line.split()[-1]
                    elif line.startswith('.field'):
                        m = FIELD_RE.match(line.rstrip('\n'))
                        if m:
                            fields.append('%s:%s' % (m.group(2), m.group(3)))
                    elif line.startswith('.method'):
                        m = METH_RE.match(line.rstrip('\n'))
                        if m:
                            meths.append(m.group(2) + m.group(3))
                    elif 'const-string' in line:
                        m = STR_RE.match(line.rstrip('\n'))
                        if m:
                            strs.append(m.group(1))
            if not d:
                continue
            if d in seen:      # 三 dex 合并造成的重复文件
                continue
            seen.add(d)
            db[d] = {'p': p, 'super': sup, 'fields': fields,
                     'methods': sorted(set(meths)), 'strings': sorted(set(strs))}
    # 串 -> 类数
    cnt = {}
    for d, v in db.items():
        for s in v['strings']:
            cnt[s] = cnt.get(s, 0) + 1
    json.dump({'n': len(db), 'db': db, 'cnt': cnt}, open(out, 'w'), ensure_ascii=False)
    print('classes=%d strings=%d -> %s' % (len(db), len(cnt), out))


def show(path, names, maxn=25):
    data = json.load(open(path))
    db, cnt = data['db'], data['cnt']
    for name in names:
        name = name.strip().lstrip('L').rstrip(';')
        v = db.get(name)
        if not v:
            # 前缀猜（内嵌类）
            cand = [k for k in db if k.startswith(name)]
            print('### %s  【不在】  相近: %s' % (name, cand[:6]))
            continue
        print('### %s  (%s)' % (name, v['p']))
        print('  super: %s' % v['super'])
        print('  nfield=%d nmeth=%d' % (len(v['fields']), len(v['methods'])))
        print('  methods: %s' % ' '.join(v['methods']))
        uniq = [s for s in v['strings'] if cnt.get(s) == 1]
        print('  唯一串(%d):' % len(uniq))
        for s in uniq[:maxn]:
            print('    %r' % s)
        rare = [s for s in v['strings'] if 1 < cnt.get(s, 0) <= 3]
        print('  稀有串(<=3类)(%d):' % len(rare))
        for s in rare[:10]:
            print('    %r  x%s' % (s, cnt[s]))
        print()


if __name__ == '__main__':
    if sys.argv[1] == 'build':
        build(sys.argv[2], sys.argv[3])
    else:
        show(sys.argv[2], sys.argv[3:])
