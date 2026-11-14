#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""adapt280_verify.py —— 对 adapt280_locate.py 的候选做「方法体逐行同形」复核 🐲"""
import os, re, sys, json, difflib

WS = '/workspace'
OLD = os.path.join(WS, 'tmp/h275')
NEW = os.path.join(WS, 'tmp/h280')
LOC = os.path.join(WS, 'tmp/adapt280_locate.json')
FP = os.path.join(WS, 'tmp/adapt280_fp.json')

RE_METHOD = re.compile(r'^\s*\.method\s+(.*?)([A-Za-z_$<>][\w$<>]*)\(([^)]*)\)(\S+)\s*$')
RE_END = re.compile(r'^\s*\.end method')
RE_REG = re.compile(r'\b[vp]\d+\b')
RE_TYPE = re.compile(r'L[\w$/]+;')
RE_NUM = re.compile(r'(?<=[ ,{])-?0x[0-9a-fA-F]+|(?<=[ ,{])-?\d+')
RE_LBL = re.compile(r':[\w_]+')
SKIP = ('.line', '.local', '.param', '.prologue', '.source', '#', '.restart local', '.end local',
        '.annotation', '.end annotation', '.catch', '.end try')


def norm(ln):
    s = ln.strip()
    if not s or s.startswith(SKIP):
        return ''
    s = RE_TYPE.sub('L;', s)
    s = RE_LBL.sub(':L', s)
    s = RE_NUM.sub('N', s)
    s = RE_REG.sub('V', s)
    return re.sub(r'\s+', ' ', s)


def body_of(root, cls, mth):
    p = os.path.join(root, cls + '.smali')
    if not os.path.exists(p):
        for rt, _, fs in os.walk(root):
            if cls + '.smali' in fs:
                p = os.path.join(rt, cls + '.smali')
                break
        else:
            return None
    lines = open(p, encoding='utf-8', errors='ignore').read().split('\n')
    cur, body = None, []
    for ln in lines:
        mm = RE_METHOD.match(ln)
        if mm and cur is None:
            cur = mm.group(2)
            body = []
            continue
        if cur is not None:
            if RE_END.match(ln):
                if cur == mth:
                    return [x for x in (norm(b) for b in body) if x]
                cur, body = None, []
            else:
                body.append(ln)
    return None


def main():
    loc = json.load(open(LOC))
    print('%-26s %-22s %-24s %-6s %s' % ('note', 'old', 'new', 'sim', 'verdict'))
    bad = []
    for r in loc:
        if r['status'] != 'OK':
            continue
        oc, om = r['old']
        nc, nm = r['new_cls'], r['new_mth']
        bo = body_of(OLD, oc, om)
        bn = body_of(NEW, nc, nm)
        if bo is None or bn is None:
            print('%-26s %-22s %-24s %-6s BODY_MISS' % (r['note'], oc + '.' + om, nc + '.' + nm, '-'))
            bad.append(r)
            continue
        sm = difflib.SequenceMatcher(None, bo, bn, autojunk=False)
        ratio = sm.ratio()
        verdict = 'OK' if ratio >= 0.80 else ('SUSPECT' if ratio >= 0.5 else 'BAD')
        print('%-26s %-22s %-24s %.3f  %s  (%d/%d)' % (r['note'], oc + '.' + om, nc + '.' + nm, ratio, verdict, len(bo), len(bn)))
        if verdict != 'OK':
            bad.append(r)
            n = 0
            for tag, i1, i2, j1, j2 in sm.get_opcodes():
                if tag == 'equal':
                    continue
                print('      %-8s OLD=%s' % (tag, (bo[i1:i2] or [''])[0][:88]))
                print('      %-8s NEW=%s' % ('', (bn[j1:j2] or [''])[0][:88]))
                n += 1
                if n >= 3:
                    break
    print('\n需人工处理 %d 条' % len(bad))


if __name__ == '__main__':
    main()
