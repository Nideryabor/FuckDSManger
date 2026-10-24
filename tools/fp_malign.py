#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fp_malign.py —— 方法级对齐（串指纹 + 形状 + 类型投票）🐲 尼得亚伯 2026-10-24

场景：类已配对，但方法名/签名里的内部类型名全被 R8 换掉 ⇒ 光靠签名翻译对不上。
做法（三路信号打分，无需类型映射即可工作）：
  ① 方法体 const-string 的 **IDF 加权覆盖率**（最准：SourceInfo 串是天然指纹）
  ② 形状：参数个数 + 每位 kind(O/I/J/F/D/Z/B/C/S) + 返回 kind
  ③ 唯一性：候选必须显著领先第二名，否则标「?」不下结论
对齐上以后，**逐位把 (旧类型 → 新类型) 投票**，喂回类型映射表。

用法：
  python3 tools/fp_malign.py <旧树> <新树> <目标列表.txt> [--typeout 文件]
目标列表.txt: 每行 "旧类名\t新类名1[,新类名2...]"
"""
import os, re, sys, math, collections

RE_CLASS = re.compile(r'^\.class\s+(.*?)\s*(L[^;]+;)\s*$')
RE_METHOD = re.compile(r'^\.method\s+(.*?)\s*([^\s(]+)\((.*?)\)(.*)$')
RE_END = re.compile(r'^\.end method\s*$')
CONST_STR = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')


def parse_params(s):
    out, i, n = [], 0, len(s)
    while i < n:
        j = i
        while j < n and s[j] == '[':
            j += 1
        if j >= n:
            break
        if s[j] == 'L':
            k = s.find(';', j)
            if k < 0:
                break
            out.append(s[i:k + 1])
            i = k + 1
        else:
            out.append(s[i:j + 1])
            i = j + 1
    return out


def kind(t):
    t = t.lstrip('[')
    return 'O' if t.startswith('L') else t


def load(root):
    """类名(相对 root，带包路径) -> {'flags','methods':[{name,ps,ret,strings,order}]}"""
    d = {}
    for rt, _, fs in os.walk(root):
        for f in fs:
            if not f.endswith('.smali'):
                continue
            p = os.path.join(rt, f)
            cls = os.path.relpath(p, root).replace(os.sep, '/')[:-6]
            try:
                lines = open(p, encoding='utf-8', errors='ignore').read().split('\n')
            except Exception:
                continue
            methods = []
            cur = None
            for line in lines:
                if cur is None:
                    mm = RE_METHOD.match(line)
                    if mm:
                        acc, name, ps, ret = mm.groups()
                        cur = {'acc': acc, 'name': name,
                               'ps': parse_params(ps), 'ret': ret,
                               'strings': [], 'order': len(methods)}
                else:
                    if RE_END.match(line):
                        methods.append(cur)
                        cur = None
                    else:
                        node = CONST_STR.match(line)
                        if node:
                            cur['strings'].append(node.group(1))
            d[cls] = {'methods': methods}
    return d


def main():
    old_root, new_root, tgt_p = sys.argv[1:4]
    typeout = None
    if '--typeout' in sys.argv:
        typeout = sys.argv[sys.argv.index('--typeout') + 1]

    print('· 解析旧树...', file=sys.stderr)
    OLD = load(old_root)
    print(f'· 解析新树... ({len(OLD)} 类)', file=sys.stderr)
    NEW = load(new_root)
    print(f'· 新树 {len(NEW)} 类', file=sys.stderr)

    # 新树串 IDF
    inv = collections.defaultdict(set)
    for c, v in NEW.items():
        for m in v['methods']:
            for s in m['strings']:
                inv[s].add(c)
    N = max(1, len(NEW))

    def idf(s):
        return math.log(1 + N / (1 + len(inv.get(s, ()))))

    typevotes = collections.defaultdict(collections.Counter)
    report = []

    for line in open(tgt_p, encoding='utf-8'):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        parts = line.split('\t')
        oc = parts[0].strip()
        ncs = [x.strip() for x in parts[1].replace(',', ' ').split()] if len(parts) > 1 else []
        A = OLD.get(oc)
        if not A:
            print(f'\n### L{oc}; ❌ 旧树无此类'); continue
        print(f'\n### L{oc};  ({len(A["methods"])} 方法) → {ncs}')
        # 候选方法池
        pool = []
        for nc in ncs:
            B = NEW.get(nc)
            if not B:
                print(f'   ⚠️ L{nc}; 新树无此类'); continue
            for bm in B['methods']:
                pool.append((nc, bm))
        print(f'   候选方法池 {len(pool)} 个')
        used = collections.defaultdict(set)   # 新类 -> 已用方法名
        for am in A['methods']:
            aset = set(am['strings'])
            aw = sum(idf(s) for s in aset)
            best = []
            for nc, bm in pool:
                if bm['name'] in used[nc] and am['name'] not in ('<init>', '<clinit>'):
                    continue
                # 形状硬门槛
                if len(bm['ps']) != len(am['ps']):
                    continue
                if kind(bm['ret']) != kind(am['ret']):
                    continue
                if [kind(x) for x in bm['ps']] != [kind(x) for x in am['ps']]:
                    continue
                bset = set(bm['strings'])
                inter = aset & bset
                cov = (sum(idf(s) for s in inter) / aw) if aw else 0.0
                sc = cov * 10
                if am['name'] == bm['name']:
                    sc += 1.0          # 同名的弱加分（R8 也常保留）
                if bm['order'] == am['order']:
                    sc += 0.3          # 顺序位置的弱加分
                best.append((sc, cov, nc, bm, len(inter)))
            best.sort(key=lambda x: -x[0])
            if not best:
                print(f'   ? {am["name"]:<12} 无同形候选  [{am["name"]}({",".join(am["ps"])}){am["ret"]}]')
                continue
            sc, cov, nc, bm, ni = best[0]
            conf = ''
            if len(best) > 1:
                if best[0][0] - best[1][0] < 0.5:
                    conf = f'  ⚠️歧义(次: {best[1][2]}.{best[1][3]["name"]} {best[1][1]*100:.0f}%)'
            mark = '★' if (cov > 0.85 or (cov > 0.5 and not conf)) else ('·' if cov > 0.3 else '?')
            rename = '' if am['name'] == bm['name'] else '  ★改名'
            print(f'   {mark} {am["name"]:<12} → {nc}.{bm["name"]:<12} 串覆盖{cov*100:5.1f}%({ni}/{len(aset)}){rename}{conf}')
            if am['name'] not in ('<init>', '<clinit>') and cov > 0.5 and not conf:
                used[nc].add(bm['name'])
                # 类型投票
                for a_t, b_t in zip(am['ps'], bm['ps']):
                    if a_t != b_t:
                        typevotes[a_t][b_t] += 1
                if am['ret'] != bm['ret']:
                    typevotes[am['ret']][bm['ret']] += 1

    print('\n\n========== 类型映射投票（旧 → 新）==========')
    lines = []
    for a_t in sorted(typevotes, key=lambda x: -sum(typevotes[x].values())):
        v = typevotes[a_t]
        tot = sum(v.values())
        top = v.most_common(3)
        s = '   '.join(f'{n}({c})' for n, c in top)
        print(f'  {a_t:<28} → {s}    共{tot}票')
        # 全量输出（含 1 票），冲突交给 merge_typemap.py 统一裁决
        for n, c in top:
            if a_t.startswith('L') and n.startswith('L'):
                lines.append(f'{a_t[1:-1]}\t{n[1:-1]}\t{c}')
    if typeout:
        open(typeout, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
        print(f'\n· 高置信类型映射 {len(lines)} 条 → {typeout}', file=sys.stderr)


if __name__ == '__main__':
    main()
