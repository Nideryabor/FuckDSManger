#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
patch_gentry_261.py v2 —— 只动 GmEntry.smali  🐲

① 门禁：findClass("kf5")/"uia" → "kh7"/"qk7"
② hookM  / hookC2 入口插桩：先查 GmRemap 表
   · hookM  : cls + method 都要重映射
   · hookC2 : 只重映射 cls（它 hook 的是 <init>）
   · 两个方法各自的 .registers 都要 +2（腾出临时寄存器；pN 别名自动顺延）
   · 未定位的锚点 ⇒ GmRemap.cls 返回"必然找不到"的假名 ⇒ findClass 抛异常 ⇒
     被方法自带的 catchall 吞掉 ⇒ **那条 hook 不注册**（宁可不干活，也不乱咬）
"""
import os, re, sys

P = sys.argv[1] if len(sys.argv) > 1 else 'tmp/base130_261/sm/com/nidyaber/fuckdsmanger/GmEntry.smali'
# ── 直连调用的锚点（绕过 GmRemap 的那几处，必须直接改字面量）🐲
DIRECT_EDITS = [
    # 直连调用（绕过 GmRemap）：findAndHookConstructor("bx4", cl, [Map.class, GmDsHook3])
    #   老 bx4 的 ctor 是 (Map)，新 py5 完全一样 ⇒ 只换类名
    ('    const-string v1, "bx4"\n\n    const-class v6, Ljava/util/Map;',
     '    const-string v1, "py5"\n\n    const-class v6, Ljava/util/Map;'),
    # 纯观感日志
    ('"hooked bx4 init Map"', '"hooked py5 init Map"'),
    ('"hook bx4 init FAIL"',  '"hook py5 init FAIL"'),
]

lines = open(P, encoding='utf-8').read().split('\n')

SNIP_M = [
    '    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;',
    '',
    '    move-result-object v2',
    '',
    '    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->method(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;',
    '',
    '    move-result-object v3',
    '',
    '    move-object p1, v2',
    '',
    '    move-object p2, v3',
    '',
]
SNIP_C2 = [
    '    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;',
    '',
    '    move-result-object v0',
    '',
    '    move-object p1, v0',
    '',
]

out = []
gate = 0
done = set()
cur = None          # 当前方法名
pending_sig = None  # 刚读到的 .method 行
for i, line in enumerate(lines):
    mth = re.match(r'^\.method\s+(.*)$', line)
    if mth:
        cur = mth.group(1)
        out.append(line)
        continue
    # ① 门禁
    m = re.match(r'^(\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*")(kf5|uia)("\s*)$', line)
    if m and 'findClass' in '\n'.join(lines[i+1:i+9]):
        out.append(m.group(1) + {'kf5': 'kh7', 'uia': 'qk7'}[m.group(2)] + m.group(3))
        gate += 1
        continue
    # ② 插桩
    r = re.match(r'^(\s*)\.registers\s+(\d+)\s*$', line)
    if r and 'hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V' in (cur or '') and 'hookM' not in done:
        out.append('    .registers %d' % (int(r.group(2)) + 2))
        out.extend(SNIP_M)
        done.add('hookM')
        continue
    if r and 'hookC2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V' in (cur or '') and 'hookC2' not in done:
        out.append('    .registers %d' % (int(r.group(2)) + 2))
        out.extend(SNIP_C2)
        done.add('hookC2')
        continue
    out.append(line)

assert 'hookM' in done, 'hookM 插桩失败'
assert 'hookC2' in done, 'hookC2 插桩失败'
txt2 = '\n'.join(out)
_nd = 0
for _o, _n in DIRECT_EDITS:
    if _o in txt2:
        txt2 = txt2.replace(_o, _n, 1); _nd += 1
    else:
        print('  ⚠️ 直连编辑没匹配上:', _o[:40])
open(P, 'w', encoding='utf-8').write(txt2)
print(f'✓ 直连锚点编辑 {_nd} 处')

def fix_flagsecure_ctors(dst):
    """把三个 FlagSecure hook 类的包级私有构造器改成 public
       （Kotlin internal 编译出来是 package-private，GmEntry 在别的包 ⇒
        Class.newInstance() 抛 IllegalAccessException）"""
    n = 0
    for c in ('GmFlagSecureIntHook', 'GmFlagSecureLpHook', 'GmFlagSecureBoolHook'):
        fp = os.path.join(dst, 'com/nidyaber/fuckdsmanger/gm', c + '.smali')
        if not os.path.exists(fp):
            print('  ⚠️ 缺', c); continue
        t = open(fp, encoding='utf-8').read()
        if '\n.method constructor <init>()V' in t:
            t = t.replace('\n.method constructor <init>()V', '\n.method public constructor <init>()V', 1)
            open(fp, 'w', encoding='utf-8').write(t); n += 1
    return n

print(f'✓ GmEntry：门禁 {gate} 处 · 插桩 {sorted(done)}')
