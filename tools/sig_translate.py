#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sig_translate.py —— 用类型映射把 2.7.1 方法签名翻译成 2.7.2 签名，全树唯一定位
用法: sig_translate.py <旧树> <新树> <typemap.uniq.tsv> <probe.tsv>
probe.tsv: 旧类\t旧方法(可逗号)\t新类候选(可逗号,可空)
"""
import os,re,sys,collections
RE_METHOD=re.compile(r'^\s*\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_END=re.compile(r'^\s*\.end method')
def split_types(s):
    out=[];i=0;n=len(s)
    while i<n:
        j=i
        while j<n and s[j]=='[': j+=1
        if j>=n: break
        if s[j]=='L':
            k=s.find(';',j)
            if k<0: break
            out.append(s[i:k+1]);i=k+1
        else:
            out.append(s[i:j+1]);i=j+1
    return out
def scan(root,filt=None):
    out={}
    for rt,_,fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'): continue
            cls=f[:-6]
            if filt and cls not in filt: continue
            cur=None;ps=None;ret=None
            try: lines=open(os.path.join(rt,f),encoding='utf-8',errors='ignore').read().split('\n')
            except: continue
            for ln in lines:
                m=RE_METHOD.match(ln)
                if m and cur is None:
                    cur=m.group(2);ps=m.group(3);ret=m.group(4).strip();continue
                if cur is not None and RE_END.match(ln):
                    out.setdefault(cls,set()).add((cur,ps,ret));cur=None
    return out
oldroot,newroot,tm,probe=sys.argv[1:5]
T={}
for ln in open(tm,encoding='utf-8'):
    p=ln.rstrip('\n').split('\t')
    if len(p)>=2: T[p[0]]=p[1]
SYS=('Ljava/','Landroid/','Lkotlin/','Lkotlinx/','Lorg/','Lokhttp3/','Lcom/google/','Ljavax/','Ldalvik/','Lcom/ishumei/','Lcom/tencent/','Lcom/bytedance/')
def tr(t):
    arr=''
    while t.startswith('['): arr+='['; t=t[1:]
    if not t.startswith('L'): return arr+t
    inner=t[1:-1]
    if inner.startswith(SYS): return arr+t
    n=T.get(inner)
    return arr+('L'+n+';' if n else t)
def trsig(ps,ret):
    return (''.join(tr(x) for x in split_types(ps)), tr(ret))
old=scan(oldroot)
new=scan(newroot)
idx=collections.defaultdict(list)
for c,ms in new.items():
    for (m,ps,ret) in ms: idx[(m,ps,ret)].append(c)
byps=collections.defaultdict(list)
for c,ms in new.items():
    for (m,ps,ret) in ms: byps[(ps,ret)].append((c,m))
print(f"旧类 {len(old)} 新类 {len(new)}")
for ln in open(probe,encoding='utf-8'):
    if ln.startswith('#') or not ln.strip(): continue
    p=ln.rstrip('\n').split('\t')
    oc=p[0]; oms=[x for x in p[1].split(',') if x]; cands=[x for x in (p[2].split(',') if len(p)>2 and p[2] else []) if x]
    if oc not in old: print(f"!! 旧树缺 {oc}"); continue
    print(f"\n### {oc}")
    for (m,ps,ret) in sorted(old[oc]):
        if m not in oms: continue
        tps,tret=trsig(ps,ret)
        transl=('' if tps==ps and tret==ret else f"  翻译:{tps}){tret}")
        exact=idx.get((m,tps,tret),[])
        exact=[c for c in exact if not cands or c in cands]
        others=[(c,nm) for (c,nm) in byps.get((tps,tret),[]) if nm!=m]
        others=[x for x in others if not cands or x[0] in cands]
        print(f"  {m}({ps}){ret}  {transl}")
        if len(exact)==1 and not others: print(f"     ✅ {exact[0]}.{m}   (同名同形状唯一)")
        elif len(exact)==1: print(f"     ✓? {exact[0]}.{m}   同形状另有改名候选 {others[:4]}")
        elif len(exact)>1: print(f"     ⚠️ 同名多类 {exact}")
        elif others: print(f"     ~ 无同名，同形状候选 {others[:6]}")
        else: print(f"     ✗ 无双  (签名未翻译完全?)")
