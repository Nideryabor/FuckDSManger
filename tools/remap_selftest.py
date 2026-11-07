#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""离线自检 GmRemap 表：模拟 clsAll / cls / method / methodOwner 的语义。

★ 为什么要有这个：3.75.0 第一版我把 method() 的键匹配写成「前 N-2 列」，
   而 MTH 行是「3 个键列 + 每代一对(类,方法)」⇒ 匹配恒失败 ⇒ **整张方法表等于没生效**。
   这种错误真机上是「静默失效」（异常被 hookM 吞掉），极难发现。
   ⇒ 用纯 Python 复刻一遍语义，出包前先跑，一眼就能看出来。

用法: remap_selftest.py <GmRemap.java>
"""
import re, sys

def parse_rows(src, name):
    m = re.search(name + r'\s*=\s*\{(.*?)\n    \};', src, re.S)
    if not m:
        return []
    rows = []
    for line in m.group(1).split('\n'):
        s = line.strip()
        if not s.startswith('{"'):
            continue
        body = s[s.index('{') + 1: s.rindex('}')]
        tmp = re.sub(r'"[^"]*"', lambda x: x.group(0).replace(',', '\x00'), body)
        vals = []
        for p in tmp.split(','):
            p = p.strip().replace('\x00', ',')
            if p == 'null':
                vals.append(None)
            elif p.startswith('"'):
                vals.append(p[1:-1])
            else:
                vals.append(p)
        rows.append(vals)
    return rows




def check_key_resolves(mth_rows):
    """★ 2026-11-07：键必须真的命中表，不能"没命中却看起来正常"。

    这个坑我犯过**两次**：
      · 3.75.28  `settings.row.update`（少了 .z）
      · 3.75.38  `cont.impl.h`（少了 .h）

    ★ 判据（关键）：`clsAll` 在**没命中**时会 `return new String[]{old}`，
      也就是把**键自己**原样返回。而键是 "类.方法" ⇒ **一定带点**；
      真命中的 R8 短名（pg7 / sj0 / da8 …）**一定不带点**。
      ⇒ 所以「解析出来的 owner 里有点」= 没命中 = 键写错了。
      （不能只判 key.endswith('.'+mth)：`"cont.impl.h".endswith(".h")` 是 True，
        也 不能用 rfind('.') 拆完再查 —— 拆出来的两半拼回去必然等于原键，自洽。）
    """
    bad = []
    for row in mth_rows:
        if len(row) < 3:
            continue
        exp_cls, exp_mth = row[-2], row[-1]
        if exp_cls is None or exp_mth is None:
            continue        # 故意标"未定位"的行，走 GONE 是预期行为
        for k in row[:len(row) - 2]:
            if k is None or '.' not in k:
                continue
            i = k.rfind('.')
            got = sim_owner(mth_rows, k[:i], k[i + 1:])
            if got is not None and '.' in got:
                bad.append((k, exp_cls, exp_mth, got))
    return bad

GONE_PREFIX = 'com.gm.gone.'

def sim_cls_all(rows, old):
    if old is None:
        return [GONE_PREFIX + 'null']
    for p in rows:
        for i in range(len(p) - 1):
            col = p[i]
            if col == old or (col and ',' in col and old in col.split(',')):
                v = p[-1]
                if v is None:
                    return [GONE_PREFIX + p[0]]
                return v.split(',')
    return [old]

def is_key(p, k):
    for i in range(len(p) - 2):
        v = p[i]
        if v is not None and '.' in v and v == k:
            return True
    return False

def sim_method(rows, cls, mth):
    if cls is None or mth is None:
        return mth
    k = cls + '.' + mth
    for p in rows:
        if is_key(p, k):
            v = p[-1]
            return v if v is not None else GONE_PREFIX + 'gone'
    return mth

def sim_owner(rows, cls, mth):
    if cls is None or mth is None:
        return None
    k = cls + '.' + mth
    for p in rows:
        if is_key(p, k):
            o = p[-2]
            return o if o is not None else GONE_PREFIX + 'none'
    return None

def main():
    src = open(sys.argv[1], encoding='utf-8').read()
    cls_rows = parse_rows(src, r'String\[\]\[\] CLS6')
    mth_rows = parse_rows(src, r'String\[\]\[\] MTH')
    print('CLS6=%d 行   MTH=%d 行' % (len(cls_rows), len(mth_rows)))

    bad = 0
    # ① 每行长度必须一致（防止漏加一列）
    if cls_rows:
        widths = set(len(r) for r in cls_rows)
        print('CLS6 各行列数 =', sorted(widths), '（应只有 1 个值）')
        if len(widths) != 1:
            print('  ✗ 列数不一致 —— 有行漏加代'); bad += 1
    if mth_rows:
        widths = set(len(r) for r in mth_rows)
        print('MTH  各行列数 =', sorted(widths), '（应只有 1 个值）')
        if len(widths) != 1:
            print('  ✗ 列数不一致；MTH 应为 3 键列 + 2×代数'); bad += 1

    # ② 每个「最后一列」都必须能解析出东西（clsAll 不返回空串）
    for r in cls_rows:
        v = r[-1]
        if v is not None and v.strip() == '':
            print('  ✗ 空目标值:', r); bad += 1

    # ③ 关键锚点的语义抽查（这些是出过事的）
    # ⚠️ MTH 的键**只认前三代**（2.5.2 / 2.6.1 / 2.6.2 的 "类.方法"），
    #    2.7.x 那两列是「类/方法对」，不是键 —— 这是表结构本身的设计，别搞错。
    check = [
        # (键类, 键方法, 期望 2.7.5 类, 期望 2.7.5 方法)
        ('j77', 'p', 's27', 'E'),        # 头像 Painter
        ('us6', 'z', 'da8', 'q'),        # 画底原语 3 参
        ('us6', 'y', 'da8', 'p'),        # 画底原语 4 参
        ('t5', 'w', 'z5', 'w'),          # ← BUG A 本次修的：方法名 v→w
        ('yt2', 'u', 'hx2', 'y'),        # ← 本次修的：main 域下发 v→y
        ('tb7', 'h', 'tj7', 'h'),        # model 域下发
        ('jtb', 'f', 'y2c', 'k'),        # 气泡单元
        ('xa0', 'g', 'yb0', 'e'),        # 气泡作用域
        ('qn7', 'p', 'yu7', 'n'),        # GotoBottom
        ('kh2', 'k', 'nk2', 'k'),        # 会话接口
        ('e3c', 'a0', 'wx6', 'P'),       # Modifier.paint
        # x5.w 故意不查（a6 未定位 ⇒ 走 GONE 安全失败），单独验
    ]
    # ④ 键反查（★ 2026-11-07 新增 —— 这个坑犯过两次）
    _bad_keys = check_key_resolves(mth_rows)
    if _bad_keys:
        print('\n键反查:')
        for k, ec, em, gc, gm in _bad_keys:
            print('  ✗ 键 %-30s 应解析成 %s.%s，实际 %s.%s' % (k, ec, em, gc, gm))
            bad += 1
    else:
        print('\n键反查: ✓ 所有键都能解析回自己那一行')

    print('\n语义抽查:')
    for oldc, oldm, expc, expm in check:
        own = sim_owner(mth_rows, oldc, oldm)
        mth = sim_method(mth_rows, oldc, oldm)
        allc = sim_cls_all(cls_rows, oldc)
        okline = (own == expc and mth == expm)
        print('  %-5s.%-4s → owner=%-5s method=%-5s clsAll=%-24s %s'
              % (oldc, oldm, own, mth, ','.join(allc), '✓' if okline else '✗ 期望 %s.%s' % (expc, expm)))
        if not okline:
            bad += 1

    # ③b 已定位锚点必须解析到位（2026-11-06：x5.w 原来是 GONE，现在钉到 b6.w）
    gone = sim_owner(mth_rows, 'x5', 'w')
    gm = sim_method(mth_rows, 'x5', 'w')
    okb = (gone == 'b6' and gm == 'w')
    print('  x5.w → owner=%s method=%s  %s' % (gone, gm, '✓' if okb else '✗ 期望 b6.w'))
    if not okb:
        bad += 1

    # ③c 真正的「未定位」锚点必须走 GONE（防止回退到旧类名乱咬宿主）
    for kc, km in (('yp1', 'a'), ('yp1', 'c')):
        g2 = sim_owner(mth_rows, kc, km)
        m2 = sim_method(mth_rows, kc, km)
        ok2 = (g2 is None or g2.startswith(GONE_PREFIX)) and \
              (m2.startswith(GONE_PREFIX) or m2 == km)
        print('  %s.%s（未定位）→ owner=%s method=%s  %s'
              % (kc, km, g2, m2, '✓ 安全失败' if ok2 else '✗ 不该成功'))
        if not ok2:
            bad += 1

    # ④ 所有 MTH 行都必须至少有一个「含点」的键列（否则 isKey 永远匹配不到）
    print('\n键列形状检查:')
    noname = [r for r in mth_rows if not any(v is not None and '.' in v for v in r[:-2])]
    if noname:
        print('  ✗ 有 %d 行没有任何形如「类.方法」的键列:' % len(noname))
        for r in noname[:5]:
            print('     ', r)
        bad += 1
    else:
        print('  ✓ 每行都有含点的键列')

    # ⑤ method() 对「不认识的键」必须原样返回（不能瞎改）
    if sim_method(mth_rows, 'zzz', 'q') != 'q':
        print('  ✗ 未登记键没有原样返回'); bad += 1

    print('\n%s' % ('✅ 全部通过' if bad == 0 else '❌ 有 %d 处问题' % bad))
    sys.exit(1 if bad else 0)

if __name__ == '__main__':
    main()
