#!/usr/bin/env python3
"""Material Symbols SVG → Android VectorDrawable XML
用法: python3 svg2vd.py <SVG根目录> <输出res/drawable> <图标名...>
Material Symbols 的 SVG 很干净：单个或几个 <path d="...">，24x24 viewBox。
"""
import re, sys, os

def find_svg(root, name):
    hits = []
    for dp, dn, fn in os.walk(root):
        if name + ".svg" in fn:
            hits.append(os.path.join(dp, name + ".svg"))
    if not hits: return None
    # 优先 wght400 / fill0（标准字重、实心）
    for pref in ("wght400", "fill0", "rounded"):
        for h in hits:
            if pref in h: return h
    return sorted(hits)[0]

def conv(svg_path):
    s = open(svg_path, encoding="utf-8").read()
    vb = re.search(r'viewBox\s*=\s*"([^"]+)"', s)
    vb = vb.group(1).split() if vb else ["0", "0", "24", "24"]
    vw, vh = vb[2], vb[3]
    paths = re.findall(r'<path[^>]*\sd\s*=\s*"([^"]+)"', s)
    if not paths: return None
    body = "\n".join(
        '    <path\n        android:fillColor="#FF000000"\n        android:pathData="%s" />' % d
        for d in paths)
    return ('<?xml version="1.0" encoding="utf-8"?>\n'
            '<vector xmlns:android="http://schemas.android.com/apk/res/android"\n'
            '    android:width="24dp"\n    android:height="24dp"\n'
            '    android:viewportWidth="%s"\n    android:viewportHeight="%s">\n%s\n</vector>\n'
            % (vw, vh, body))

if __name__ == "__main__":
    root, out = sys.argv[1], sys.argv[2]
    names = sys.argv[3:]
    os.makedirs(out, exist_ok=True)
    ok, miss = [], []
    for n in names:
        p = find_svg(root, n)
        if not p: miss.append(n); continue
        x = conv(p)
        if not x: miss.append(n + "(无path)"); continue
        open(os.path.join(out, "ic_" + n + ".xml"), "w", encoding="utf-8").write(x)
        ok.append(n)
    print("  转换成功 %d / %d" % (len(ok), len(names)))
    if miss: print("  没拿到: %s" % miss)
