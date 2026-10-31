#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""si_locate.py —— 用 Compose trace 串（含原始类名+File.kt:行号）做类级/方法级定位
用法: si_locate.py <新树> <h271旧树> <锚点类清单> [--out 前缀]
思路: 旧锚点类里每个方法提取 SourceInfo 串 -> 在新树里反查 owner
"""
import os,re,sys
RE_METHOD=re.compile(r'^\s*\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_END=re.compile(r'^\s*\.end method')
SI=re.compile(r'\(([A-Za-z0-9_$]+\.kt):(\d+)\)')
newroot,oldroot,anc=sys.argv[1],sys.argv[2],sys.argv[3]
anchors=set(x.strip() for x in open(anc) if x.strip())
# 1. 旧树: 锚点类 -> 方法 -> SI 集合
oldm={}
for f in os.listdir(oldroot):
    if not f.endswith('.smali'): continue
    cls=f[:-6]
    if cls not in anchors: continue
    cur=None;hits=[]
    for ln in open(os.path.join(oldroot,f),encoding='utf-8',errors='ignore'):
        m=RE_METHOD.match(ln)
        if m and cur is None:
            cur=f"{m.group(2)}({m.group(3)}){m.group(4)}";hits=[];continue
        if cur is not None:
            for s in SI.finditer(ln): hits.append(f"{s.group(1)}:{s.group(2)}")
            if RE_END.match(ln):
                if hits: oldm.setdefault(cls,{})[cur]=set(hits)
                cur=None
pats=set()
for cls,ms in oldm.items():
    for m,h in ms.items(): pats|=h
sys.stderr.write(f"旧锚点类 {len(oldm)}  方法数 {sum(len(v) for v in oldm.values())}  唯一SI {len(pats)}\n")
# 2. 新树: 扫每个类的方法 SI
newmap={}
for rt,_,fs in os.walk(newroot):
    for f in fs:
        if not f.endswith('.smali'): continue
        p=os.path.join(rt,f)
        rel=os.path.relpath(p,newroot)[:-6].replace(os.sep,'/')
        cls0=f[:-6]
        cur=None;hits=[]
        try: lines=open(p,encoding='utf-8',errors='ignore').read().split('\n')
        except: continue
        for ln in lines:
            m=RE_METHOD.match(ln)
            if m and cur is None:
                cur=f"{m.group(2)}({m.group(3)}){m.group(4)}";hits=[];continue
            if cur is not None:
                for s in SI.finditer(ln):
                    t=f"{s.group(1)}:{s.group(2)}"
                    if t in pats: hits.append(t)
                if RE_END.match(ln):
                    if hits: newmap.setdefault(cls0,{})[cur]=set(hits)
                    cur=None
sys.stderr.write(f"新树带SI类 {len(newmap)}\n")
# 3. 投票: 旧类 -> 新类
import collections
for oldcls,ms in sorted(oldm.items()):
    votes=collections.Counter(); mvotes=collections.defaultdict(collections.Counter)
    for oldmth,h in ms.items():
        for nc,nms in newmap.items():
            sc=len(h & nms.get('__none__',set()))
            # 逐方法比对
        for nc,nms in newmap.items():
            for nmth,nh in nms.items():
                common=h & nh
                if common:
                    votes[nc]+=len(common); mvotes[oldmth][f"{nc}.{nmth}"]+=len(common)
    tot=sum(len(h) for h in ms.values())
    print(f"\n### {oldcls}  (SI总{tot})")
    for nc,sc in votes.most_common(4):
        print(f"   {nc:12s} 命中{sc:4d}  覆盖{min(100,100*sc/max(1,tot)):.0f}%")
    for om,c in mvotes.items():
        best=c.most_common(1)[0]
        print(f"     {om:55s} -> {best[0]}  ({best[1]})")
