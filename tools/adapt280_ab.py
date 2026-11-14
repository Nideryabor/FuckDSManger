#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_ab.py — 灰度(AB)/settings 读取链路 2.7.5 → 2.8.0 类级对位 🐲

灰度键名在 R8 下**一字不改**（字符串常量），所以每个类的「kv_remote_settings_id_* 键集合」
就是天然指纹：集合完全相等 ⇒ 高置信映射。
"""
import os, re, sys, json, collections

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
OUT = os.path.join(WS, 'tmp/adapt280_ab.tsv')

RE_AB = re.compile(r'kv_remote_settings_id_([a-z0-9_]+)')
RE_ST = re.compile(r'kv_settings_([a-z0-9_]+)')


def scan(root, rx):
    out = {}
    for rt, _, fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            p = os.path.join(rt, f)
            try:
                s = open(p, encoding='utf-8', errors='ignore').read()
            except Exception:
                continue
            ks = set(rx.findall(s))
            if ks:
                out[f[:-6]] = ks
    return out


def match(a, b):
    res, used = {}, set()
    for k, v in a.items():
        cand = [ck for ck, cv in b.items() if cv == v and ck not in used]
        if len(cand) == 1:
            res[k] = (cand[0], 1.0, 'EXACT_SET')
            used.add(cand[0])
    for k, v in a.items():
        if k in res:
            continue
        best = None
        for ck, cv in b.items():
            if ck in used:
                continue
            j = len(v & cv) / float(len(v | cv))
            if best is None or j > best[0]:
                best = (j, ck)
        if best and best[0] >= 0.7:
            res[k] = (best[1], best[0], 'JACCARD')
            used.add(best[1])
    return res


def main():
    for label, rx, sfx in (('AB', RE_AB, '.ab'), ('SETTINGS', RE_ST, '.set')):
        a = scan(OLD, rx)
        b = scan(NEW, rx)
        print('\n==== %s keys: 2.7.5 %d cls / 2.8.0 %d cls ====' % (label, len(a), len(b)))
        res = match(a, b)
        rows = []
        for k in sorted(a, key=lambda x: -len(a[x])):
            if k in res:
                nk, j, how = res[k]
                rows.append((k, nk, j, len(a[k]), how))
                print('  %-10s -> %-10s  %-10s j=%.2f  keys=%d' % (k, nk, how, j, len(a[k])))
            else:
                rows.append((k, '-', 0.0, len(a[k]), 'MISS'))
                print('  %-10s -> %-10s  %-10s        keys=%d  e.g.%s' %
                      (k, '?', 'MISS', len(a[k]), sorted(a[k])[:3]))
        with open(OUT + sfx, 'w', encoding='utf-8') as f:
            f.write('old_cls\tnew_cls\tjaccard\tkeys\thow\n')
            for r in rows:
                f.write('%s\t%s\t%.3f\t%d\t%s\n' % r)


if __name__ == '__main__':
    main()
