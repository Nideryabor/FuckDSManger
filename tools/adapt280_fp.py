#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_fp.py —— 为 2.7.5 → 2.8.0 适配做准备：
从 GmRemap.java 抽出所有「2.7.5 类/方法」锚点，再回 2.7.5 smali 树取指纹：
  · SourceInfo 串（File.kt:行号）—— 最强武器（指南 S 条）
  · 方法签名（形参逐位）
  · 字段形状
输出 JSON：/workspace/tmp/adapt280_fp.json
用法: python3 tools/adapt280_fp.py [旧树=tmp/h275]
"""
import os, re, sys, json, collections

WS = "/workspace"
OLD_TREE = os.path.join(WS, sys.argv[1] if len(sys.argv) > 1 else "tmp/h275")
REMAP = os.path.join(WS, "mod-src/src/com/nidyaber/fuckdsmanger/bridge/GmRemap.java")

RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_FIELD = re.compile(r'^\s*\.field\s+(.*?)([A-Za-z_$][\w$]*):(\S+)\s*$')
SI = re.compile(r'\(([A-Za-z0-9_$]+\.kt):(\d+)\)')


def parse_remap():
    """返回 [(kind, keys, cls_275, mth_275, note)]"""
    src = open(REMAP, encoding='utf-8').read()
    rows = []

    def blocks(name):
        i = src.find('String[][] ' + name)
        if i < 0:
            return []
        i = src.find('{', i)
        depth = 0
        j = i
        while j < len(src):
            if src[j] == '{':
                depth += 1
            elif src[j] == '}':
                depth -= 1
                if depth == 0:
                    break
            j += 1
        body = src[i:j + 1]
        out = []
        for line in body.split('\n'):
            line = line.split('//')[0]
            m = re.search(r'\{([^{}]*)\}', line)
            if not m:
                continue
            cells = []
            for c in m.group(1).split(','):
                c = c.strip()
                cells.append(None if c == 'null' else c.strip('"'))
            if cells:
                out.append(cells)
        return out

    for cells in blocks('CLS6'):
        if len(cells) < 6:
            continue
        keys = [c for c in cells[:-1] if c]
        last = cells[-1]
        if last and not last.startswith('com.gm.gone'):
            for c in last.split(','):
                rows.append(('CLS', keys, c.strip(), None, cells[0]))
    for cells in blocks('MTH'):
        if len(cells) < 7:
            continue
        keys = [c for c in cells[:-2] if c]
        oldcls, oldmth = cells[-2], cells[-1]
        if oldcls and oldmth and not oldcls.startswith('com.gm.gone'):
            rows.append(('MTH', keys, oldcls, oldmth, cells[0]))
    return rows


def read_class(cls):
    p = os.path.join(OLD_TREE, cls + '.smali')
    if os.path.exists(p):
        try:
            return open(p, encoding='utf-8', errors='ignore').read().split('\n')
        except Exception:
            return None
    for rt, _, fs in os.walk(OLD_TREE):
        if cls + '.smali' in fs:
            try:
                return open(os.path.join(rt, cls + '.smali'), encoding='utf-8', errors='ignore').read().split('\n')
            except Exception:
                return None
    return None


def shape_of(params, ret):
    KM = {'I': 'I', 'J': 'J', 'F': 'F', 'D': 'D', 'Z': 'Z', 'B': 'B', 'C': 'C', 'S': 'S', 'V': 'V'}
    ps = []
    i, n = 0, len(params)
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
            ps.append(KM.get(params[j], '?'))
            i = j + 1
    return '(' + ''.join(ps) + ')' + KM.get(ret.strip(), '?')


def analyze(lines):
    methods = {}
    fields = []
    si_all = collections.Counter()
    cur = None
    for ln in lines:
        fm = RE_FIELD.match(ln)
        if fm:
            fields.append(fm.group(2) + ':' + fm.group(3))
        mm = RE_METHOD.match(ln)
        if mm and cur is None:
            cur = {'name': mm.group(2), 'sig': '(' + mm.group(3) + ')' + mm.group(4),
                   'shape': shape_of(mm.group(3), mm.group(4)),
                   'si': [], 'strings': [], 'nlines': 0}
            continue
        if cur is not None:
            cur['nlines'] += 1
            for s in SI.finditer(ln):
                t = s.group(1) + ':' + s.group(2)
                cur['si'].append(t)
                si_all[t] += 1
            m2 = re.search(r'const-string(?:/jumbo)?\s+v\d+,\s*"(.*)"\s*$', ln)
            if m2 and len(cur['strings']) < 12:
                cur['strings'].append(m2.group(1)[:60])
            if RE_END.match(ln):
                methods[cur['name'] + cur['sig']] = cur
                cur = None
    return methods, fields, si_all


def main():
    rows = parse_remap()
    classes, seen = [], set()
    for kind, keys, cls, mth, note in rows:
        if cls not in seen:
            seen.add(cls)
            classes.append(cls)
    print('锚点类 %d 个 / 表行 %d 条' % (len(classes), len(rows)))

    out = {'oldTree': OLD_TREE, 'classes': {}, 'anchors': []}
    miss = []
    for cls in sorted(classes):
        lines = read_class(cls)
        if lines is None:
            miss.append(cls)
            continue
        methods, fields, si_all = analyze(lines)
        out['classes'][cls] = {'nlines': len(lines), 'fields': fields,
                               'field_count': len(fields), 'methods': methods,
                               'si_top': si_all.most_common(8)}
    for kind, keys, cls, mth, note in rows:
        d = {'kind': kind, 'keys': keys, 'old_cls': cls, 'old_mth': mth, 'note': note}
        if cls in out['classes']:
            c = out['classes'][cls]
            d['field_count'] = c['field_count']
            if mth:
                cand = [v for k, v in c['methods'].items() if v['name'] == mth and v['name'] != '<init>']
                ctor = [v for k, v in c['methods'].items() if v['name'] == mth]
                d['method'] = (cand or ctor or [None])[0]
                d['method_found'] = bool(cand or ctor)
        out['anchors'].append(d)

    p = os.path.join(WS, 'tmp/adapt280_fp.json')
    json.dump(out, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('已写', p)
    print('缺失类:', ', '.join(miss) if miss else '无')
    nof = [a for a in out['anchors'] if a['kind'] == 'MTH' and not a.get('method_found')]
    print('未找到方法的锚点 %d: %s' % (len(nof), ', '.join('%s.%s' % (a['old_cls'], a['old_mth']) for a in nof)))


if __name__ == '__main__':
    main()
