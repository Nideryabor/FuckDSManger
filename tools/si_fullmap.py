#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""si_fullmap.py —— 全树 SourceInfo 串「精确方法对位」→ 全量类映射
用法: si_fullmap.py <旧树> <新树> <输出前缀>
"""
import os,re,sys,collections,pickle
RE_METHOD=re.compile(r'^\s*\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_END=re.compile(r'^\s*\.end method')
SI=re.compile(r'\(([A-Za-z0-9_$]+\.kt):(\d+)\)')
KM={'I':'I','J':'J','F':'F','D':'D','Z':'Z','B':'B','C':'C','S':'S','V':'V'}
def shape(params,ret):
    ps=[];i=0;n=len(params)
    while i<n:
        j=i
        while j<n and params[j]=='[': j+=1
        if j>=n: break
        if params[j]=='L':
            k=params.find(';',j)
            if k<0: break
            ps.append('L');i=k+1
        else:
            ps.append(KM.get(params[j],'?'));i=j+1
    return '('+''.join(ps)+')'+KM.get(ret.strip(),'?')
def parse(root):
    out={}
    for rt,_,fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'): continue
            cls=f[:-6]
            try: lines=open(os.path.join(rt,f),encoding='utf-8',errors='ignore').read().split('\n')
            except: continue
            cur=None;hits=[];sh=''
            for ln in lines:
                mm=RE_METHOD.match(ln)
                if mm and cur is None:
                    cur=f"{mm.group(2)}({mm.group(3)}){mm.group(4).strip()}"
                    sh=shape(mm.group(3),mm.group(4));hits=[];continue
                if cur is not None:
                    for s in SI.finditer(ln): hits.append(f"{s.group(1)}:{s.group(2)}")
                    if RE_END.match(ln):
                        if hits: out[(cls,cur)]=(frozenset(hits),sh)
                        cur=None
    return out
oldroot,newroot,pref=sys.argv[1],sys.argv[2],sys.argv[3]
old=parse(oldroot); sys.stderr.write(f"旧带SI方法 {len(old)}\n")
new=parse(newroot); sys.stderr.write(f"新带SI方法 {len(new)}\n")
# 倒排（两棵树都建，用稀有的找）
def inv(m):
    d=collections.defaultdict(list)
    for k,(h,s) in m.items():
        for t in h: d[t].append(k)
    return d
iold=inv(old); inew=inv(new)
pairs=[]; stats=collections.Counter()
cvote=collections.defaultdict(collections.Counter)
for (oc,om),(h,sh) in old.items():
    # 用旧树里最稀有的 SI（且新树里也有）
    cands=sorted((len(inew.get(t,[])),t) for t in h if t in inew)
    if not cands: stats['无对应串']+=1; continue
    best=None
    for _,t in cands:
        for nk in inew[t]:
            nh,ns=new[nk]
            if ns!=sh: continue
            if nh==h: best=nk;break
        if best: break
    if best:
        pairs.append((oc,om,sh,'|'.join(sorted(h)),best[0],best[1],'完全'));stats['完全']+=1
        cvote[oc][best[0]]+=1
    else:
        # 退一步：H ⊆ 新H 且 shape 同，唯一
        found=[]
        for _,t in cands[:3]:
            for nk in inew[t]:
                nh,ns=new[nk]
                if ns==sh and h<=nh and len(nh)-len(h)<=2: found.append(nk)
        if len(found)==1:
            pairs.append((oc,om,sh,'|'.join(sorted(h)),found[0][0],found[0][1],'子集'));stats['子集']+=1
            cvote[oc][found[0][0]]+=1
        else: stats['未定']+=1
sys.stderr.write(str(dict(stats))+"\n")
with open(pref+'.pairs.tsv','w') as f:
    for r in pairs: f.write('\t'.join(r)+'\n')
with open(pref+'.cls.tsv','w') as f:
    for oc,c in sorted(cvote.items()):
        tot=len([1 for (cc,_) in old if cc==oc])
        top=c.most_common(1)[0]
        f.write(f"{oc}\t{top[0]}\t{top[1]}\t{tot}\t{100*top[1]//max(1,tot)}\n")
print(f"方法对位 {len(pairs)}  类映射 {len(cvote)}")
