#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""si_exact.py —— SourceInfo 串集合「精确方法对位」
用法: si_exact.py <旧树> <新树> [锚点类清单]
对每个旧方法: H=SI集合; 在新树找 SI集合完全一致 且 参数形状一致 的方法
输出: 旧类.旧方法 -> 新类.新方法  (唯一=✅ / 多个=?)
"""
import os,re,sys,collections
RE_METHOD=re.compile(r'^\s*\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_END=re.compile(r'^\s*\.end method')
SI=re.compile(r'\(([A-Za-z0-9_$]+\.kt):(\d+)\)')

def kind(t):
    m={'I':'I','J':'J','F':'F','D':'D','Z':'Z','B':'B','C':'C','S':'S','V':'V'}
    return m.get(t,t)
def shape(params,ret):
    ps=[]
    i=0;n=len(params)
    while i<n:
        j=i
        while j<n and params[j]=='[': j+=1
        if j>=n: break
        if params[j]=='L':
            k=params.find(';',j)
            if k<0: break
            ps.append('L');i=k+1
        else:
            ps.append(kind(params[j]));i=j+1
    return '(' + ''.join(ps) + ')' + kind(ret.strip())

def parse(root,filt=None):
    out={}
    for rt,_,fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'): continue
            cls=f[:-6]
            if filt is not None and cls not in filt: continue
            p=os.path.join(rt,f)
            cur=None;sig=None;hits=[]
            try: lines=open(p,encoding='utf-8',errors='ignore').read().split('\n')
            except: continue
            for ln in lines:
                m=RE_METHOD.match(ln)
                if m and cur is None:
                    cur=f"{m.group(2)}({m.group(3)}){m.group(4).strip()}"
                    sig=shape(m.group(3),m.group(4));hits=[];continue
                if cur is not None:
                    for s in SI.finditer(ln): hits.append(f"{s.group(1)}:{s.group(2)}")
                    if RE_END.match(ln):
                        out.setdefault(cls,{})[cur]=(frozenset(hits),sig)
                        cur=None
    return out

oldroot,newroot=sys.argv[1],sys.argv[2]
anc=set(x.strip() for x in open(sys.argv[3])) if len(sys.argv)>3 else None
old=parse(oldroot,anc)
sys.stderr.write(f"旧类 {len(old)}\n")
# 新树建 SI->方法 倒排（只要方法带SI）
inv=collections.defaultdict(list)
newall={}
for rt,_,fs in os.walk(newroot):
    for f in fs:
        if not f.endswith('.smali'): continue
        cls=f[:-6]
        p=os.path.join(rt,f)
        cur=None;sig=None;hits=[]
        try: lines=open(p,encoding='utf-8',errors='ignore').read().split('\n')
        except: continue
        for ln in lines:
            m=RE_METHOD.match(ln)
            if m and cur is None:
                cur=f"{m.group(2)}({m.group(3)}){m.group(4).strip()}"
                sig=shape(m.group(3),m.group(4));hits=[];continue
            if cur is not None:
                for s in SI.finditer(ln): hits.append(f"{s.group(1)}:{s.group(2)}")
                if RE_END.match(ln):
                    if hits:
                        h=frozenset(hits)
                        newall[(cls,cur)]=(h,sig)
                        inv[h].append((cls,cur))
                    cur=None
sys.stderr.write(f"新方法(带SI) {len(newall)}\n")

cls_vote=collections.defaultdict(collections.Counter)
done=[]
for oc,ms in old.items():
    for om,(h,sig) in ms.items():
        if not h: continue
        # ① 完全一致
        cand=[c for c in inv.get(h,[]) if newall[c][1]==sig]
        tag='✅完整' if len(cand)==1 else ('?' if len(cand)>1 else '')
        if not cand:
            # ② 子集：旧H ⊆ 新H
            c2=[c for c,(nh,ns) in newall.items() if h<=nh and ns==sig and len(nh)-len(h)<=2]
            if len(c2)==1: cand=c2;tag='✅子集'
        if not cand:
            # ③ 交集>=60%
            c3=[]
            for (nc,nm),(nh,ns) in newall.items():
                if ns!=sig: continue
                inter=h&nh
                if inter and len(inter)>=max(1,int(len(h)*0.6)): c3.append(((nc,nm),len(inter)))
            c3.sort(key=lambda x:-x[1])
            if c3 and (len(c3)==1 or c3[0][1]>c3[1][1]):
                cand=[c3[0][0]];tag='~交集'
        if cand:
            nc,nm=cand[0]
            cls_vote[oc][nc]+=1
            done.append((oc,om,sig,'|'.join(sorted(h)),nc,nm,tag,len(cand)))
print("旧类\t新类\t命中方法数\t占比")
for oc,c in sorted(cls_vote.items()):
    tot=sum(1 for m,(h,s) in old[oc].items() if h)
    top=c.most_common(3)
    print(f"{oc}\t{top[0][0]}\t{top[0][1]}/{tot}\t{100*top[0][1]//max(1,tot)}%\t" + "  ".join(f"{k}:{v}" for k,v in top[1:]))
print()
print("旧类\t旧方法\t形状\tSI\t新类\t新方法\t标记\t候选数")
for r in done: print("\t".join(str(x) for x in r))
