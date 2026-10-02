#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_shape.py —— 无字符串类的「纯形状」配对（R8 跨版本）  🐲 尼得亚伯 2026-10-01

字符串指纹失效时（类里没有常量），改用**类型无关的形状**：
  · 方法形状多重集 Counter((参数个数, 返回kind))     —— R8 不改形参个数
  · 字段形状多重集 Counter(字段类型kind)             —— 基本类型/对象 可辨
  · 访问标志种类（interface / abstract / enum / final）
  · 静态字段数 / 方法数（作为弱信号）
"""
import os, re, sys, math, collections

CONST_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')
RE_CLASS  = re.compile(r'^\.class\s+(.*?)\s*(L[^;]+;)\s*$')
RE_SUPER  = re.compile(r'^\.super\s+(L[^;]+;)\s*$')
RE_IMPL   = re.compile(r'^\.implements\s+(L[^;]+;)\s*$')
RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_FIELD  = re.compile(r'^\.field\s+(.*?)\s*([^\s:]+):(.*)$')

def unescape(s):
    try:
        return s.encode('utf-8','surrogateescape').decode('unicode_escape')
    except Exception:
        return s

def parse_params(s):
    out, i = [], 0
    while i < len(s):
        c = s[i]
        if c == '[':
            i += 1
            while i < len(s) and s[i] == '[': i += 1
            c = s[i]
        if c == 'L':
            j = s.find(';', i)
            if j < 0: break
            out.append('O'); i = j + 1
        else:
            out.append(c); i += 1
    return out

def kind(t):
    t = t.strip()
    if t.startswith('L') or t.startswith('['): return 'O'
    return t

def parse_tree(root):
    out = {}
    for dirpath, _, files in os.walk(root):
        for fn in files:
            if not fn.endswith('.smali'): continue
            path = os.path.join(dirpath, fn)
            desc=None; flags=''; sup=None; impls=set()
            mf=collections.Counter(); ff=collections.Counter()
            nsf=0; nfields=0; strings=set(); nsrc=None
            try:
                with open(path,'r',encoding='utf-8',errors='replace') as f:
                    for line in f:
                        line=line.rstrip('\n')
                        if desc is None:
                            m=RE_CLASS.match(line)
                            if m: flags,desc=m.group(1),m.group(2); continue
                        if line.startswith('.super '):
                            m=RE_SUPER.match(line)
                            if m: sup=m.group(1)
                        elif line.startswith('.implements '):
                            m=RE_IMPL.match(line)
                            if m: impls.add(m.group(1))
                        elif line.startswith('.field '):
                            m=RE_FIELD.match(line)
                            if m:
                                nfields+=1
                                if ' static ' in ' '+m.group(1)+' ': nsf+=1
                                ff[kind(m.group(3))]+=1
                        elif line.startswith('.method '):
                            m=RE_METHOD.match(line)
                            if m: mf[(len(parse_params(m.group(3))), kind(m.group(4)))]+=1
                        elif 'const-string' in line:
                            m=CONST_STR.match(line)
                            if m: strings.add(unescape(m.group(1)))
            except Exception:
                continue
            if desc:
                k = ('interface' if 'interface' in flags else
                     'enum' if 'enum' in flags else
                     'abstract' if 'abstract' in flags else
                     'final' if 'final' in flags else 'plain')
                out[desc]=dict(mf=mf, ff=ff, kind=k, nsf=nsf, nfields=nfields,
                               nmeth=sum(mf.values()), strings=strings, flags=flags)
    return out

def jac(a, b):
    if not a and not b: return 1.0
    A=set(a); B=set(b)
    inter=sum(min(a[k],b[k]) for k in A&B)
    union=sum(max(a[k],b[k]) for k in A|B)
    return inter/union if union else 0.0

def main():
    old_root,new_root = sys.argv[1],sys.argv[2]
    targets = [l.strip() for l in open(sys.argv[3]) if l.strip() and not l.startswith('#')]
    print('· 解析旧树...',file=sys.stderr); OLD=parse_tree(old_root)
    print('· 解析新树...',file=sys.stderr); NEW=parse_tree(new_root)
    for t in targets:
        d = t if t.startswith('L') else 'L'+t.lstrip('L').rstrip(';')+';'
        a = OLD.get(d)
        if not a:
            print(f'\n### {d} ❌ 旧树无'); continue
        print(f'\n### {d}  旧: {a["kind"]}, {a["nmeth"]}方法/{a["nfields"]}字段(静态{a["nsf"]})/{len(a["strings"])}串')
        cands=[]
        for nd,c in NEW.items():
            if c['kind']!=a['kind']: continue
            s = jac(a['mf'],c['mf'])*2.0 + jac(a['ff'],c['ff'])
            if abs(a['nmeth']-c['nmeth'])<=max(3,a['nmeth']*0.35): s+=0.5
            if abs(a['nsf']-c['nsf'])<=max(2,a['nsf']*0.35): s+=0.5
            cands.append((s,nd,c))
        cands.sort(key=lambda x:-x[0])
        for s,nd,c in cands[:5]:
            strs = len(a['strings']&c['strings'])
            print(f'   {"★" if s>2.6 else "·" if s>1.8 else " "} {nd:<30} 形状分{s:4.2f}  '
                  f'方法{a["nmeth"]}->{c["nmeth"]} 字段{a["nfields"]}->{c["nfields"]} 静态{a["nsf"]}->{c["nsf"]} 共用串{strs}')

if __name__=='__main__':
    main()
