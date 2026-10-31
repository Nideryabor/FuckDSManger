# -*- coding: utf-8 -*-
import struct,sys
d=open(sys.argv[1],'rb').read()
def varint(b,i):
    v=0;s=0
    while i<len(b):
        c=b[i];i+=1;v|=(c&0x7f)<<s;s+=7
        if not c&0x80: return v,i
    return None,i
out=[];i=0;n=len(d)
while i<n:
    klen,ni=varint(d,i)
    if klen is None or not (4<=klen<=95): i+=1;continue
    kb=d[ni:ni+klen]
    try: k=kb.decode('utf-8')
    except: i+=1;continue
    if not all(32<=ord(c)<127 for c in k): i+=1;continue
    if not (k.startswith('kv_') or k.startswith('fuckds_') or k.startswith('key_')): i+=1;continue
    vlen,vp=varint(d,ni+klen)          # ★ 补上 valueLen
    if vlen is None or vlen<1 or vlen>50000: i+=1;continue
    raw=d[vp:vp+vlen]
    if len(raw)<1: i+=1;continue
    t=raw[0];body=raw[1:]
    try:
        if t==0: v=bool(body[0]) if body else False
        elif t==1: v=struct.unpack_from('<i',body,0)[0]
        elif t==2: v=struct.unpack_from('<q',body,0)[0]
        elif t==3: v=struct.unpack_from('<f',body,0)[0]
        elif t==4: v=struct.unpack_from('<d',body,0)[0]
        elif t==5: v=body.decode('utf-8','replace')
        elif t==6: v='<bytes %d>'%len(body)
        else: i+=1;continue
        out.append((k,v));i=vp+vlen
    except: i+=1
seen=set();res=[]
for k,v in out:
    if k in seen: continue
    seen.add(k);res.append((k,v))
print('解析出 %d 条'%len(res))
for k,v in res: print('  %-58s = %s'%(k,v))
