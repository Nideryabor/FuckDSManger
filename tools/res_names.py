#!/usr/bin/env python3
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
# Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
"""
res_names.py —— 从资源表 + smali 里提「宿主真正用到的资源名」🐲 2026-11-07

为什么要这个（而不是运行时抓）：
  · 运行时抓 = 只拿到「用户点过的界面」用到的（实测 60 秒只有 44 条）
  · 静态提 = 全库硬编码引用一次扫完（实测 string 747/762、drawable 204/266）
  · 而**资源名没被混淆**（new_chat / assistant_message_avatar…），宿主升级也不变
    ⇒ 表里只存**名字**，运行时 `res.getIdentifier(name, type, pkg)` 换回 id
    ⇒ 宿主升级 id 变了自动跟着走，不会像写死 0x7f0f0312 那样静默失效

用法：
    python3 tools/res_names.py <aapt2资源dumps.txt> <smali目录> [输出.json]
"""
import json
import os
import re
import subprocess
import sys

# 资源表 dump 里的行形如：  resource 0x7f0f0312 string/session_init_title
RES_RE = re.compile(r"^\s+resource\s+(0x7f[0-9a-f]{6})\s+([a-z]+)/(\S+)\s*$")
# ⚠️ 2026-11-07 踩过：写成 0x7f0[0-9a-f]{4}（7 位）⇒ 一条都匹配不到，
#    而脚本"成功"输出 0 条，看起来像"宿主没用资源"—— 这种静默错误最坑。
#    资源 id 是 **8 位**十六进制：0x7f + 6 位。
ID_RE = re.compile(r"0x7f[0-9a-f]{6}", re.IGNORECASE)


def parse_table(path):
    """{type: {id: name}}"""
    out = {}
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            m = RES_RE.match(line)
            if not m:
                continue
            rid, typ, name = m.group(1).lower(), m.group(2), m.group(3)
            out.setdefault(typ, {})[rid] = name
    return out


def refs_in_smali(root):
    """全库扫硬编码 id → set(0x7f0fxxxx)"""
    got = set()
    for dirpath, _dirs, files in os.walk(root):
        for fn in files:
            if not fn.endswith(".smali"):
                continue
            try:
                with open(os.path.join(dirpath, fn), "r",
                          encoding="utf-8", errors="replace") as f:
                    got.update(m.group(0).lower() for m in ID_RE.finditer(f.read()))
            except OSError:
                pass
    return got


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    table = parse_table(sys.argv[1])
    used = refs_in_smali(sys.argv[2])

    result = {}
    total = 0
    for typ in ("string", "drawable", "color", "dimen", "layout", "mipmap", "raw"):
        m = table.get(typ, {})
        if not m:
            continue
        hit = {rid: name for rid, name in m.items() if rid in used}
        result[typ] = hit
        total += len(hit)
        print("%-9s 表内 %4d · 被引用 %4d" % (typ, len(m), len(hit)))
    print("合计可用 %d 条" % total)

    if len(sys.argv) > 3:
        with open(sys.argv[3], "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=1, sort_keys=True)
        print("→ 写出 %s" % sys.argv[3])
    return 0


if __name__ == "__main__":
    sys.exit(main())
