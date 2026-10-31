#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""mth_probe.py —— 按 2.7.1 的 (类,方法,签名) 在新树里找候选（形状+名字+引用类）"""
import os,re,sys,collections
RE_METHOD=re.compile(r'^\s*\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_END=re.compile(r'^\s*\.end method')
KM={'I':'I','J':'J','F':'F','D':'D','Z':'Z','B':'B','C':'C','S':'S','V':'V'}
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
def shape(params,ret):
    return '('+''.join('L' if t.endswith(';') else KM.get(t,'?') for t in split_types(params))+')'+('L' if ret.strip().endswith(';') else KM.get(ret.strip(),'?'))
def methods(root,cls):
    p=os.path.join(root,cls+'.smali')
    if not os.path.exists(p): return {}
    out={};cur=None;hits=[]
    for ln in open(p,encoding='utf-8',errors='ignore'):
        m=RE_METHOD.match(ln)
        if m and cur is None:
            cur=(m.group(2),m.group(3),m.group(4).strip());hits=[];continue
        if cur is not None:
            if RE_END.match(ln): out[cur]=hits;cur=None
    return out
def main():
    oldroot,newroot,probe=sys.argv[1],sys.argv[2],sys.argv[3]
    root=sys.argv[4] if len(sys.argv)>4 else None
    # probe 行: 旧类\t旧方法\t候选新类(逗号)
    # root: 在哪个目录找新类文件（平铺 or 带包）
    for ln in open(probe,encoding='utf-8'):
        if ln.startswith('#') or not ln.strip(): continue
        oc,om,cands=ln.rstrip('\n').split('\t')[:3]
        cands=[c for c in cands.split(',') if c]
        oms=[x for x in om.split(',') if x]
        ms=methods(oldroot,oc)
        tgt=[(n,p,r) for (n,p,r) in ms if n in oms]
        if not tgt:
            print(f"!! {oc}.{om} 在旧树没找到"); continue
        print(f"\n### {oc}.{om}  旧签名候选 {[(n,p,r) for n,p,r in tgt]}")
        for tname,tp,tr in tgt:
            sh=shape(tp,tr)
            print(f"  形状 {sh}   形参 {split_types(tp)}")
            for nc in cands:
                nmi=methods(newroot,nc)
                exact=[(n,p,r) for (n,p,r) in nmi if n==tname]
                same_shape=[(n,p,r) for (n,p,r) in nmi if shape(p,r)==sh]
                print(f"   -> {nc}: 同名 {[(p,r) for n,p,r in exact]} | 同形状 {[(n,p,r) for n,p,r in same_shape][:5]}")
main()
