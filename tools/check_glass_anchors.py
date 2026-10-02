#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""核验玻璃锚点在 2.6.1 树上能否挂上（模拟 GmGlassScope.looksLikeComposable）🐲"""
import os, re, sys

TREE = sys.argv[1] if len(sys.argv) > 1 else "/workspace/tmp/h261"

NEW_ANCHORS = [
    ("xta", "a"), ("xta", "b"), ("xta", "c"),
    ("l10", "a"), ("l10", "b"), ("l10", "c"), ("l10", "d"),
    ("v91", "c"),
    ("hs7", "c"), ("hs7", "d"),
    ("l10", "h"),
    ("k53", "f"), ("k53", "o"),
]

def parse_params(sig):
    assert sig[0] == "("
    i, out = 1, []
    while sig[i] != ")":
        c = sig[i]
        if c == "[":
            i += 1
            continue
        if c == "L":
            j = sig.index(";", i)
            out.append(sig[i:j+1]); i = j + 1
        else:
            out.append(c); i += 1
    return out

def is_interface(cls_token, cache={}):
    """cls_token like 'Lmu4;' -> 查树里该类是不是 interface"""
    name = cls_token[1:-1]
    if name in cache:
        return cache[name]
    p = os.path.join(TREE, name + ".smali")
    r = False
    if os.path.isfile(p):
        with open(p, "r", encoding="utf-8", errors="ignore") as f:
            head = f.read(4000)
        r = bool(re.search(r"^\.class.*\binterface\b", head, re.M))
    cache[name] = r
    return r

def methods_of(cls):
    p = os.path.join(TREE, cls + ".smali")
    if not os.path.isfile(p):
        return None
    out = []
    with open(p, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            m = re.match(r"^\.method.*?\s([a-zA-Z0-9_$<>]+)\(([^)]*)\)(\S+)$", line.strip())
            if m:
                out.append((m.group(1), "(" + m.group(2) + ")" + m.group(3)))
    return out

def looks_like_composable(sig):
    ps = parse_params(sig)
    if len(ps) < 4: return False
    if ps[-1] != "I": return False
    for t in ps:
        if t.startswith("L") and is_interface(t):
            return True
    return False

print("=== 新锚点核验（2.6.1）===")
ok_all = True
for cls, meth in NEW_ANCHORS:
    ms = methods_of(cls)
    if ms is None:
        print("✗ 类不存在: %s" % cls); ok_all = False; continue
    cands = [s for (n, s) in ms if n == meth and looks_like_composable(s)]
    if cands:
        print("✓ %s.%s  -> %d 个候选" % (cls, meth, len(cands)))
        for s in cands:
            print("      %s" % s)
    else:
        print("✗ %s.%s 无候选（类存在但方法不合）" % (cls, meth))
        ok_all = False

print()
print("=== 画底原语核验 qk7.D ===")
ms = methods_of("qk7") or []
hit = [s for (n, s) in ms if n == "D" and len(parse_params(s)) == 3 and parse_params(s)[1] in ("J",)]
for s in hit:
    ps = parse_params(s)
    print("✓ qk7.D %s  第0参接口=%s 第1参=%s" % (s, is_interface(ps[0]), ps[1]))

print()
print("=== 旧锚点是否还活着（应失效）===")
for cls in ["uk8", "zc", "i52", "yb5", "a18", "zl9", "uia"]:
    p = os.path.join(TREE, cls + ".smali")
    if not os.path.isfile(p):
        print("· %s.smali 不存在" % cls); continue
    ms = methods_of(cls) or []
    print("· %s.smali 存在（%d 个方法）" % (cls, len(ms)))

print()
print("结论:", "全部通过 ✅" if ok_all else "存在失败项 ❌")
