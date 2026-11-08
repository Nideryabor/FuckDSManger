#!/usr/bin/env python3
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
# Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
"""
res_dump.py —— 生成「宿主の终极美化策略」的初始清单 🐲 2026-11-07

产出 fdm-app/i18n/host_res_names.json：
  {
   "string": { "0x7f0f0312": {"n": "session_init_title", "c": "新对话"}, ... },
   "drawable": { "0x7f07005a": {"n": "assistant_message_avatar", "c": ""}, ... }
  }
  · n = 资源名（**没被混淆**，宿主升级也不变 ⇒ 运行时按名字反查 id）
  · c = 当前值（中文 `b+zh+Hans` 优先，没有就 default；图片留空）

只收「smali 里真的硬编码引用过」的 id —— 那是宿主自己的 UI 真会用到的那批。

用法：python3 tools/res_dump.py <aapt2资源dumps.txt> <smali目录> [输出.json]
"""
import json
import os
import re
import sys

RES_RE = re.compile(r"^\s+resource\s+(0x7f[0-9a-f]{6})\s+([a-z]+)/(\S+)\s*$")
VAL_RE = re.compile(r'^\s+\(([^)]*)\)\s+"(.*)"\s*$')
# 8 位十六进制。⚠️ 少写一位会静默 0 命中（踩过）
ID_RE = re.compile(r"0x7f[0-9a-f]{6}", re.IGNORECASE)

# 中文配置的候选顺序（新版 aapt2 用 b+zh+Hans，老版用 zh-rCN / zh）
ZH_KEYS = ("b+zh+Hans", "zh-rCN", "zh-rHans", "zh")


def parse(path):
    """→ {id: {"type":…, "name":…, "vals": {locale: text}}}"""
    out = {}
    cur = None
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            m = RES_RE.match(line)
            if m:
                rid, typ, name = m.group(1).lower(), m.group(2), m.group(3)
                cur = {"type": typ, "name": name, "vals": {}}
                out[rid] = cur
                continue
            if cur is None:
                continue
            v = VAL_RE.match(line)
            if v:
                cur["vals"][v.group(1)] = v.group(2)
            elif line.strip() and not line.startswith("      "):
                cur = None      # 离开这个资源块（遇到下个 type/package/…）
    return out


def refs(root):
    got = set()
    for dirpath, _d, files in os.walk(root):
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


def pick(locales):
    """中文优先，其次 default"""
    for k in ZH_KEYS:
        if k in locales:
            return locales[k]
    return locales.get("", "")


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    table = parse(sys.argv[1])
    used = refs(sys.argv[2])

    out = {}
    for rid, info in sorted(table.items()):
        if rid not in used:
            continue
        typ = info["type"]
        if typ not in ("string", "drawable"):
            continue
        out.setdefault(typ, {})[rid] = {
            "n": info["name"],
            "c": pick(info["vals"]) if typ == "string" else "",
        }

    n_s = len(out.get("string", {}))
    n_d = len(out.get("drawable", {}))
    print("string   %d 条（带当前中文值）" % n_s)
    print("drawable %d 条" % n_d)

    # 顺手统计：有多少条真的有中文值（没中文的改了也看不见）
    empty = sum(1 for v in out.get("string", {}).values() if not v["c"])
    print("（其中没有当前值的 %d 条 —— 可能是格式化串或纯符号）" % empty)

    if len(sys.argv) > 3:
        with open(sys.argv[3], "w", encoding="utf-8") as f:
            json.dump(out, f, ensure_ascii=False, indent=1, sort_keys=True)
        kb = os.path.getsize(sys.argv[3]) / 1024.0
        print("→ %s（%.1f KB）" % (sys.argv[3], kb))
    return 0


if __name__ == "__main__":
    sys.exit(main())
