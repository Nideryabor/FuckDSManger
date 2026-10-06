#!/usr/bin/env python3
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
# Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
"""
keys_scan.py —— 把模块里的配置键扫成一张表 🐲

为什么需要：要做设置界面，就得知道每个键的**类型 / 默认值 / 谁读它**。
这些全藏在 smali 里 —— 靠猜做出来的界面，滑块上下限、枚举取值、"拨了没用"都躲不掉。

做法：把每个 .smali 按 .method 切块，逐块找 `fuckds_*` 字面量，
     再看这块里出现的读法（getBoolean/getInt/…）和类型常量（b/i/l/f/t）。

用法：python3 pipeline/keys_scan.py <baksmali 输出目录>
"""
import os
import re
import sys
import collections

KEYS = re.compile(r'"((?:fuckds_[a-z0-9_]+|kv_[a-z0-9_]+))"')
METHOD = re.compile(r"^\.method")
ENDM = re.compile(r"^\.end method")
# <clinit> 里：const-string "fuckds_x" 紧跟着 sput-object Cls->FIELD
SPUT = re.compile(r"sput-object [^,]+, L([^;]+);->([A-Za-z0-9_$]+):")
SGET = re.compile(r"sget-object [^,]+, L([^;]+);->([A-Za-z0-9_$]+):")
CONSTSTR = re.compile(r'const-string [^,]+, "([^"]+)"')
TYPE_BY_CALL = {
    "getBoolean": "b", "putBoolean": "b",
    "getInt": "i", "putInt": "i",
    "getLong": "l", "putLong": "l",
    "getFloat": "f", "putFloat": "f",
    "getString": "t", "putString": "t",
}
TYPENAME = {"b": "bool", "i": "int", "l": "long", "f": "float", "t": "string"}


def build_field_map(root):
    """Cls->FIELD → 键字面量（从各文件的 <clinit> 里收）。

    为什么必须做：`GmBg.<clinit>` 里 `const-string "fuckds_bg_on"` + `sput-object …->KEY_ON`，
    而真正读的时候写的是 `sget-object …->KEY_ON` —— 不建这张映射，扫描器就只能看到 <clinit>。
    """
    fmap = {}
    for dirpath, _dirs, files in os.walk(root):
        for fn in files:
            if not fn.endswith(".smali"):
                continue
            cls = "L%s;" % os.path.relpath(os.path.join(dirpath, fn), root)[:-6].replace(os.sep, "/")
            lines = open(os.path.join(dirpath, fn), encoding="utf-8",
                         errors="ignore").read().splitlines()
            last_const = None
            for ln in lines:
                m = CONSTSTR.search(ln)
                if m and m.group(1).startswith(("fuckds_", "kv_")):
                    last_const = m.group(1)
                    continue
                s = SPUT.search(ln)
                if s and last_const:
                    fmap[(s.group(1), s.group(2))] = last_const
    return fmap


def scan(root):
    fmap = build_field_map(root)
    rows = collections.defaultdict(lambda: {"readers": set(), "calls": set(),
                                            "defaults": set(), "types": set()})
    for dirpath, _dirs, files in os.walk(root):
        for fn in files:
            if not fn.endswith(".smali"):
                continue
            cls = fn[:-6]
            lines = open(os.path.join(dirpath, fn), encoding="utf-8",
                         errors="ignore").read().splitlines()
            cur_method, buf, blocks = "?", [], []
            for ln in lines:
                if METHOD.match(ln):
                    cur_method = ln.split()[-1]
                    buf = []
                buf.append(ln)
                if ENDM.match(ln):
                    blocks.append((cur_method, buf))
            for m, blk in blocks:
                keys = set(KEYS.findall("\n".join(blk)))
                for ln in blk:                       # 通过字段引用反查（sget-object→KEY_*）
                    for c, f in SGET.findall(ln):
                        if (c, f) in fmap:
                            keys.add(fmap[(c, f)])
                if not keys:
                    continue
                calls, types, defs = set(), set(), set()
                for i, ln in enumerate(blk):
                    for c, t in TYPE_BY_CALL.items():
                        if "->" + c + "(" in ln:
                            calls.add(c)
                            types.add(t)
                    mm = re.search(r'const-string [^,]+, "([biltf])"', ln)
                    if mm:
                        types.add(mm.group(1))
                    if re.search(r'const-string [^,]+, "(true|false)"', ln):
                        defs.add(ln.strip().split('"')[1])
                    for j in range(max(0, i - 3), i):     # get 调用前 3 行里的 const 当默认值
                        if "const" in blk[j] and "const-string" not in blk[j]:
                            v = blk[j].strip().split()[-1]
                            if re.fullmatch(r"-?\d+|0x[0-9a-f]+", v):
                                defs.add(v)
                for k in keys:
                    r = rows[k]
                    r["readers"].add("%s.%s" % (cls, m))
                    r["calls"] |= calls
                    r["defaults"] |= defs
                    r["types"] |= types
    return rows


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else "/tmp/bsm/sm"
    rows = scan(root)
    print("%-26s %-8s %-14s %s" % ("键", "类型", "默认值(候选)", "谁在读 / 用法"))
    print("-" * 130)
    for k in sorted(rows):
        r = rows[k]
        types = "".join(sorted(r["types"])) or "?"
        defs = ",".join(sorted(r["defaults"]))[:14] or "-"
        rders = sorted(r["readers"])
        calls = ",".join(sorted(r["calls"]))[:34]
        print("%-26s %-8s %-14s %s%s" % (
            k, types, defs,
            " ".join(rders[:3]) + (" …+%d" % (len(rders) - 3) if len(rders) > 3 else ""),
            ("  [" + calls + "]") if calls else ""))
    print("\n共 %d 个键" % len(rows))


if __name__ == "__main__":
    main()
