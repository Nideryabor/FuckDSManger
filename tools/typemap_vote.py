#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""typemap_vote.py —— 从「方法级对位」反推类型映射表（逐位投票）"""
import sys,collections
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
def norm(t):
    return t.lstrip('[')
vote=collections.defaultdict(collections.Counter)
skip=('Ljava/','Landroid/','Lkotlin/','Lkotlinx/','Lorg/','Lokhttp3/','Lcom/google/','Ljavax/','Ldalvik/','Lcom/ishumei/')
pairs=[l.rstrip('\n').split('\t') for l in open(sys.argv[1],encoding='utf-8')]
for p in pairs:
    if len(p)<7: continue
    oldcls,oldmth,sh,si,newcls,newmth,tag=p
    # 从签名拿形参（mth 里括号部分）
    def params(m):
        i=m.find('(');j=m.rfind(')')
        return split_types(m[i+1:j]) if i>=0 else []
    op=params(oldmth);np_=params(newmth)
    if len(op)!=len(np_): continue
    if tag!='完全': continue
    for a,b in zip(op,np_):
        if a.startswith('L') and b.startswith('L') and not a.startswith(skip) and not b.startswith(skip):
            vote[a[1:-1]][b[1:-1]]+=1
out=[]
for a,c in vote.items():
    if not c: continue
    tot=sum(c.values())
    for b,n in c.items():
        out.append((a,b,n,tot))
out.sort(key=lambda x:(-x[2]))
with open(sys.argv[2],'w') as f:
    f.write("旧\t新\t票数\t该旧类总票\n")
    for r in out: f.write('\t'.join(map(str,r))+'\n')
print(f"候选对 {len(out)}  旧类 {len(vote)}")
# 唯一胜出
uniq={}
for a,c in vote.items():
    tot=sum(c.values())
    top=c.most_common(1)[0]
    if tot>=2 and top[1]/tot>=0.7:
        uniq[a]=(top[0],top[1],tot)
print(f"高置信映射 {len(uniq)}")
with open(sys.argv[2]+'.uniq.tsv','w') as f:
    for a,(b,n,t) in sorted(uniq.items()): f.write(f"{a}\t{b}\t{n}\t{t}\n")
