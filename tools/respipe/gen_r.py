#!/usr/bin/env python3
"""按库生成 R 类：AGP 8 的 nonFinalResIds ⇒ AAR 里的 R 值是 0，必须用【我们 link 分配的真 ID】
重新生成各库的 R 类，并剃掉 AAR 自带的 R 类。"""
import re, sys, os, zipfile, glob, collections

symbols, aar_glob, outdir, apppkg = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]

# ① 解析 aapt2 的 symbols.txt（容错：抓行尾的 0xID + 前两个 token 当 type/name）
sym = {}
hexpat = re.compile(r'(0x[0-9a-fA-F]{8})')
for line in open(symbols, encoding="utf-8", errors="ignore"):
    m = hexpat.search(line)
    if not m: continue
    toks = [t for t in re.split(r'[\s:=]+', line.strip()) if t and not t.startswith("0x")]
    if len(toks) < 2: continue
    tname = toks[-1].split("/")[-1] if "/" in toks[-1] else toks[-1]
    ttype = toks[-2].split("/")[0] if "/" in toks[-2] else toks[-2]
    if "/" in line:
        mm = re.search(r'(\w+)/([\w.]+)', line)
        if mm: ttype, tname = mm.group(1), mm.group(2)
    sym[(ttype, tname)] = int(m.group(1), 16)

# ② 每个 AAR 的 R.txt → 它属于哪个包（读 AAR 内 AndroidManifest 的 package）
pkgs = collections.defaultdict(dict)      # pkg -> {(type,name): id}
row = re.compile(r'^int\s+(\w+)\s+(\S+)\s+(0x[0-9a-fA-F]+)$')
# ★ styleable 在 R.txt 里是另一种写法，原来两条正则都匹配不上 ⇒ R$styleable 整个类型被跳过，
#   真机上就报 `NoClassDefFoundError: androidx/xxx/R$styleable`（AGP8 的 R 字段不是常量）
row_arr = re.compile(r'^int\[\]\s+(\w+)\s+(\S+)\s+\{([^}]*)\}\s*$')
row_idx = re.compile(r'^int\s+(\w+)\s+(\S+)\s+(-?\d+)\s*$')
# 我们 link 分配的真 id（styleable 数组要从这里取，不能用 AAR 里的占位）
sym_arr = {}
for line in open(symbols, encoding="utf-8", errors="ignore"):
    m = row_arr.match(line.strip())
    if m and m.group(1) == "styleable":
        sym_arr[m.group(2)] = [int(x, 16) for x in re.findall(r'0x[0-9a-fA-F]+', m.group(3))]
style_arr = collections.defaultdict(dict)   # pkg -> {name: [id...]}
style_idx = collections.defaultdict(dict)   # pkg -> {name: 下标}
for a in sorted(glob.glob(aar_glob)):
    z = zipfile.ZipFile(a)
    try: rt = z.read("R.txt").decode("utf-8", "ignore")
    except KeyError: continue
    pkg = None
    try:
        mf = z.read("AndroidManifest.xml").decode("utf-8", "ignore")
        mm = re.search(r'package="([^"]+)"', mf)
        pkg = mm.group(1) if mm else None
    except KeyError: pass
    if not pkg:
        continue
    for line in rt.splitlines():
        s = line.strip()
        m = row_arr.match(s)
        if m and m.group(1) == "styleable":
            ids = sym_arr.get(m.group(2))
            if ids:
                style_arr[pkg][m.group(2)] = ids
            continue
        m = row_idx.match(s)
        if m and m.group(1) == "styleable":
            style_idx[pkg][m.group(2)] = int(m.group(3))
    for line in rt.splitlines():
        m = row.match(line.strip())
        if not m: continue
        t, n = m.group(1), m.group(2)
        if (t, n) in sym:
            pkgs[pkg][(t, n)] = sym[(t, n)]

# ③ 写 R.java（按包 + 嵌套类型类）
n_pkg = n_field = 0
allpkgs = set(pkgs) | set(style_arr) | set(style_idx)
for pkg in sorted(allpkgs):
    entries = pkgs.get(pkg, {})
    sarr = style_arr.get(pkg, {})
    sidx = style_idx.get(pkg, {})
    if not entries and not sarr and not sidx:
        continue
    d = os.path.join(outdir, *pkg.split("."))
    os.makedirs(d, exist_ok=True)
    bytype = collections.defaultdict(list)
    for (t, n), i in entries.items(): bytype[t].append((n, i))
    body = ["package %s;" % pkg, "", "/** 由 gen_r.py 生成：用我们 link 分配的真 ID 覆盖 AAR 的占位 0 */",
            "public final class R {"]
    for t, items in sorted(bytype.items()):
        if t == "styleable":
            continue
        body.append("    public static final class %s {" % t)
        for n, i in sorted(items):
            body.append("        public static final int %s = 0x%08x;" % (n, i)); n_field += 1
        body.append("    }")
    # ★ styleable：数组用我们 link 的真 id，下标用 AAR R.txt 里的十进制
    if sarr or sidx:
        body.append("    public static final class styleable {")
        for n, ids in sorted(sarr.items()):
            body.append("        public static final int[] %s = {%s};"
                        % (n, ", ".join("0x%08x" % i for i in ids)))
            n_field += 1
        for n, i in sorted(sidx.items()):
            body.append("        public static final int %s = %d;" % (n, i))
            n_field += 1
        body.append("    }")
    body.append("}")
    open(os.path.join(d, "R.java"), "w", encoding="utf-8").write("\n".join(body) + "\n")
    n_pkg += 1
print("  生成 R 类: %d 个包 / %d 个字段（app 包 %s 的 R 由 aapt2 直接产出）" % (n_pkg, n_field, apppkg))
