#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gray_check.py —— 灰度「类型核验 + 新键纳管」 🐲 尼得亚伯 2026-10-01

背景（《宿主升级适配指南》§5.2）：
  「**键名对得上 ≠ 能生效**」—— 类型不符会**静默失效**（UI 显示已保存，宿主读回默认值）。
  历史：3 版里 2 版坏在这。

本脚本做三件事：
  ① 从**新宿主**的类型字典类里抽出 (键名, 类型串, 默认值, **解码方法**)
  ② 从**模块** GmDialog 的 <clinit> 里抽出 (键名, 类型码)
  ③ 逐键比对 ⇒ 列出「类型不符」和「宿主新增、模块不认识」的键

用法：
  python3 tools/gray_check.py <新树> <模块树>
"""
import os, re, sys, collections

CONST = re.compile(r'^\s*const-string(?:/jumbo)?\s+[vp]\d+,\s*"(.*)"\s*$')

# 宿主 MMKV 解码方法 → 模块类型码（见指南 §5.2 那张表）
DECODER2CODE = {'c': 'b', 'g': 'i', 'e': 'f', 'j': 's', 'k': 't', 'q': 's'}  # q(String)=decodeString
CODE2DESC = {'b': 'Boolean', 'i': 'Int', 'f': 'Float', 's': 'String', 't': 'String(另一域)'}
TYPE2CODE = {'Boolean': 'b', 'Int': 'i', 'Float': 'f', 'String': 's'}

def unesc(s):
    try:
        return s.encode('utf-8', 'surrogateescape').decode('unicode_escape')
    except Exception:
        return s

def parse_host_dict(path):
    """跟踪寄存器值，从 `Leu2;-><init>(SSSS)V` 的四个参数里取 (键名, 中文名, 类型串, 默认值)。
       解码方法：该条之后第一条 MMKV;->?(Ljava/lang/String;) 的字母。"""
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    regs = {}
    out = []
    CS = re.compile(r'^\s*const-string(?:/jumbo)?\s+([vp]\d+),\s*"(.*)"\s*$')
    CI = re.compile(r'^\s*const(?:/4|/16|/high16)?\s+([vp]\d+),\s*(0x[0-9a-fxA-F]+|[-0-9]+)\s*$')
    for i, l in enumerate(lines):
        m = CS.match(l)
        if m:
            regs[m.group(1)] = unesc(m.group(2)); continue
        m2 = CI.match(l)
        if m2:
            try: regs[m2.group(1)] = str(int(m2.group(2), 0))
            except Exception: pass
            continue
        if re.search(r'L[a-z0-9_$]+;-><init>\(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;\)V$', l):
            mm = re.search(r'\{([^}]*)\}', l)
            if mm:
                a = [x.strip() for x in mm.group(1).split(',')]
                if len(a) >= 5:
                    key  = regs.get(a[1], '')
                    name = regs.get(a[2], '')
                    typ  = regs.get(a[3], '')
                    dflt = regs.get(a[4], '')
                    dec = None
                    for j in range(i, min(i + 60, len(lines))):
                        dm = re.search(r'Lcom/tencent/mmkv/MMKV;->([a-z])\(Ljava/lang/String;\)', lines[j])
                        if dm:
                            dec = dm.group(1); break
                    if key:
                        out.append(dict(key=key, name=name, typ=typ, dflt=dflt, dec=dec))
            continue
    return out

def parse_module_table(path):
    """模块 GmDialog.<clinit>：const/4 v4,<idx> + 三条 const-string（键/中文名/类型码）"""
    txt = open(path, encoding='utf-8', errors='replace').read()
    m = re.search(r'\.method static constructor <clinit>\(\)V(.*?)\.end method', txt, re.S)
    if not m:
        return []
    lines = m.group(1).split('\n')
    out = []
    buf = []
    for l in lines:
        mm = CONST.match(l)
        if mm:
            buf.append(unesc(mm.group(1)))
            continue
        if 'aput-object' in l and len(buf) >= 3:
            # 三条一组：key, name, type（顺序出现）
            if len(buf) == 3:
                out.append((buf[0], buf[1], buf[2]))
            buf = []
        elif 'aput-object' in l and len(buf) == 1:
            buf = []
    # 兜底：按 3 个一组直接切
    if not out:
        allstr = [unesc(x.group(1)) for x in (CONST.match(l) for l in lines) if x]
        for k in range(0, len(allstr) - 2, 3):
            out.append((allstr[k], allstr[k+1], allstr[k+2]))
    return out

def parse_direct(path):
    """兜底：直接 MMKV->?(String) 读取的键（如 TTS 域的 key_*）。"""
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    regs = {}
    out = []
    CS = re.compile(r'^\s*const-string(?:/jumbo)?\s+([vp]\d+),\s*"(.*)"\s*$')
    for i, l in enumerate(lines):
        m = CS.match(l)
        if m:
            regs[m.group(1)] = unesc(m.group(2)); continue
        dm = re.search(r'invoke-[a-z/]+ \{([^}]*)\}, Lcom/tencent/mmkv/MMKV;->([a-z])\(', l)
        if dm:
            args = [x.strip() for x in dm.group(1).split(',')]
            key = regs.get(args[1]) if len(args) >= 2 else None
            if key and not key.startswith('kv_settings_') and not key.startswith('fuckds_'):
                out.append(dict(key=key, name='(直接读)', typ='?', dflt='', dec=dm.group(2)))
    return out


def main():
    newroot, modroot = sys.argv[1], sys.argv[2]
    # ① 宿主字典（总表 + 录音语音 + TTS）
    host = {}
    for cls in ('fu2', 'yib', 'wza'):
        p = os.path.join(newroot, cls + '.smali')
        if not os.path.exists(p):
            print(f'  ⚠️ 找不到宿主字典 {cls}'); continue
        ents = parse_host_dict(p) or parse_direct(p)
        print(f'  · {cls}: 解析出 {len(ents)} 条')
        for e in ents:
            host[e['key']] = e
    # ② 模块表
    mp = os.path.join(modroot, 'com/nidyaber/fuckdsmanger/gm/GmDialog.smali')
    mod = parse_module_table(mp)
    print(f'  · 模块 GmDialog: {len(mod)} 条')
    modmap = {k: t for k, _n, t in mod}

    print('\n══════ ① 类型不符（危险：会静默失效）══════')
    bad = 0
    for k, t in modmap.items():
        h = host.get(k)
        if not h:
            continue
        want = DECODER2CODE.get(h['dec'], '?')
        if t != want:
            print(f'  ❌ {k}\n     模块={t}({CODE2DESC.get(t,"?")})  宿主解码={h["dec"]}⇒{want}({CODE2DESC.get(want,"?")})  类型串={h["typ"]}')
            bad += 1
    if not bad:
        print('  ✓ 全部一致')

    print('\n══════ ② 宿主有、模块没有的键（新键纳管候选）══════')
    new_keys = [k for k in host if k not in modmap]
    for k in new_keys:
        h = host[k]
        print(f'  🆕 {k:<52} 类型={h["typ"]:<8} 解码={h["dec"]} 默认={h.get("dflt","")}  名={h["name"]}')
    if not new_keys:
        print('  （没有新键）')

    print('\n══════ ③ 模块有、宿主字典里没有的键（可能是别的域/已删）══════')
    miss = [k for k in modmap if k not in host]
    for k in miss:
        print(f'  ❓ {k}  (模块类型码={modmap[k]})')
    if not miss:
        print('  （无）')

    print(f'\n小结：模块 {len(modmap)} 键 · 宿主 {len(host)} 键 · 类型不符 {bad} · 新键 {len(new_keys)} · 未收录 {len(miss)}')

if __name__ == '__main__':
    main()
