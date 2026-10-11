#!/usr/bin/env python3
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
# Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
"""
i18n_migrate.py —— 把 Kotlin 里的中文字面量搬进 resources.arsc 🐲

配合 `Lang.wrap`（伪 locale `zz` + `res/values-zz/`）一起用：
  · 人话  = 原字面量（进 res/values/strings.xml）
  · 龙龙语 = 可选的复写（进 res/values-zz/strings.xml；**没写的自动回落人话**）

★ 为什么不直接在 Kotlin 里写 `t(ctx, R.string.a, R.string.b)`：
   那样每加一句都要改调用点；900 条就是 900 次改动。搬进资源后调用点只有一句
   `stringResource(R.string.xxx)`，语言由 ctx 决定。

用法：
    python3 tools/i18n_migrate.py scan   <file.kt> ...       # 只盘点，不改
    python3 tools/i18n_migrate.py apply  <前缀>=<file.kt> ... # 搬运（原地改 + 记 keys.json）
    python3 tools/i18n_migrate.py render                     # 渲染两个 strings.xml
    python3 tools/i18n_migrate.py status                     # 覆盖率

产物/中间件（都在 fdm-app/i18n/）：
    keys.json   {键: 人话}     ← apply 自动追加
    zz.json     {键: 龙龙语}   ← 由 tools/i18n_dragon.py 生成 / 人工改
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "fdm-app", "src")
I18N = os.path.join(ROOT, "fdm-app", "i18n")
RES = os.path.join(ROOT, "fdm-app", "res")
KEYS = os.path.join(I18N, "keys.json")
ZZ = os.path.join(I18N, "zz.json")

CJK = re.compile(r"[\u4e00-\u9fff]")

# ── 哪些字面量不搬 ──────────────────────────────────────────────
SKIP_HINTS = (
    # 日志 / 调试通道：搬了只会让日志看不懂（主人 2026-10-10 确认：日志也搬；
    # 但宿主进程读不到我们的偏好 ⇒ 这里仍以 UI 文案为主，"日志"另行处理）
)


def load_json(p, default):
    if os.path.exists(p):
        with open(p, encoding="utf-8") as f:
            return json.load(f)
    return default


def save_json(p, obj):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w", encoding="utf-8") as f:
        json.dump(obj, f, ensure_ascii=False, indent=1, sort_keys=True)
        f.write("\n")


# ── Kotlin 字符串词法分析（正确跳过注释） ───────────────────────
def tokens(src):
    """产出 (start, end, raw) —— raw 含引号；正确处理 // /* */ 与 \" 转义。"""
    out = []
    i, n = 0, len(src)
    while i < n:
        if src.startswith("//", i):
            j = src.find("\n", i)
            i = n if j < 0 else j
            continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2)
            i = n if j < 0 else j + 2
            continue
        if src[i] == '"':
            triple = src.startswith('"""', i)
            q = '"""' if triple else '"'
            j = i + len(q)
            while j < n:
                if not triple and src[j] == "\\":
                    j += 2
                    continue
                if src.startswith(q, j):
                    break
                j += 1
            out.append((i, j + len(q), src[i:j + len(q)], triple))
            i = j + len(q)
            continue
        i += 1
    return out


def unescape(raw):
    """把 Kotlin 字面量的内容还原成"真正要显示的文字"。"""
    body = raw[3:-3] if raw.startswith('"""') else raw[1:-1]
    if raw.startswith('"""'):
        return body
    return (body.replace("\\n", "\n").replace("\\t", "\t")
                .replace('\\"', '"').replace("\\\\", "\\"))


def scan_file(path):
    src = open(path, encoding="utf-8").read()
    hit = []
    for s, e, raw, triple in tokens(src):
        if triple:
            continue                       # 多行块（帮助文案）先不动，见 status
        txt = unescape(raw)
        if not CJK.search(txt):
            continue
        if "$" in txt:
            hit.append((s, e, raw, txt, "跳过：含 $ 模板（要改成位置化参数，手工处理）"))
            continue
        hit.append((s, e, raw, txt, None))
    return src, hit


def cmd_scan(paths):
    tot = 0
    for p in paths:
        src, hit = scan_file(p)
        bad = [h for h in hit if h[4]]
        okn = len(hit) - len(bad)
        print("%-20s 可搬 %3d 条  跳过 %2d 条" % (os.path.basename(p), okn, len(bad)))
        for h in bad:
            print("      · %s   %s" % (h[4], h[3][:60]))
        tot += okn
    print("-" * 46)
    print("合计可搬 %d 条" % tot)


def cmd_apply(pairs):
    keys = load_json(KEYS, {})
    zz = load_json(ZZ, {})
    used = set(k for k in keys)
    for prefix, path in pairs:
        src, hit = scan_file(path)
        todo = [h for h in hit if not h[4]]
        if not todo:
            print("%-20s 没有可搬的" % os.path.basename(path))
            continue
        # 已存在的键不重复造：按"键的现有值 == 这条文字"复用
        by_val = {}
        for k, v in keys.items():
            by_val.setdefault(v, k)
        new = src
        mapping = []
        n_new = 0
        for idx, (s, e, raw, txt, _why) in enumerate(todo):
            k = by_val.get(txt)
            if k is None:
                n = 1
                while "%s_%03d" % (prefix, n) in used:
                    n += 1
                k = "%s_%03d" % (prefix, n)
                used.add(k)
                keys[k] = txt
                by_val.setdefault(txt, k)
                n_new += 1
            mapping.append((s, e, raw, txt, k))
        # 从后往前替换，偏移不失效
        for s, e, raw, txt, k in sorted(mapping, key=lambda x: -x[0]):
            new = new[:s] + "stringResource(R.string.%s)" % k + new[e:]
        # 补 import
        if "import androidx.compose.ui.res.stringResource" not in new:
            m = re.search(r"^import .*$", new, re.M)
            if m:
                new = new[:m.start()] + "import androidx.compose.ui.res.stringResource\n" + new[m.start():]
            else:
                new = new.replace("package ", "import androidx.compose.ui.res.stringResource\n\npackage ", 1)
        open(path, "w", encoding="utf-8").write(new)
        print("%-20s 搬了 %3d 条（其中新键 %d，其余复用同一句话的旧键）"
              % (os.path.basename(path), len(mapping), n_new))
    save_json(KEYS, keys)
    print("→ %s（共 %d 键）" % (KEYS, len(keys)))


def xml_escape(s, quote=False):
    s = s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    if quote:
        s = s.replace('"', "&quot;").replace("'", "\\'")
    return s


def render_one(path, data, header):
    lines = ['<?xml version="1.0" encoding="utf-8"?>', header, "<resources>"]
    for k in sorted(data):
        v = data[k]
        esc = xml_escape(v)
        attrs = ['name="%s"' % k]
        if "%" in v:
            attrs.append('formatted="false"')
        if v != v.strip() or '"' in v:
            esc = '"' + xml_escape(v, quote=True) + '"'
        lines.append("    <string %s>%s</string>" % (" ".join(attrs), esc))
    lines.append("</resources>")
    open(path, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print("  %-46s %3d 条" % (os.path.relpath(path, ROOT), len(data)))


def cmd_render():
    keys = load_json(KEYS, {})
    zz = load_json(ZZ, {})
    os.makedirs(os.path.join(RES, "values"), exist_ok=True)
    os.makedirs(os.path.join(RES, "values-zz"), exist_ok=True)
    render_one(os.path.join(RES, "values", "strings.xml"), keys,
               "<!-- 人话（默认）。键名规则：语义前缀_编号；值就是原文，方便拿 MT 认。 -->")
    only = {k: zz[k] for k in zz if k in keys}
    render_one(os.path.join(RES, "values-zz", "strings.xml"), only,
               "<!-- 🐲 龙龙语。没写的键自动回落到 values/ 的人话版。 -->")


def cmd_status():
    keys = load_json(KEYS, {})
    zz = load_json(ZZ, {})
    have = sum(1 for k in keys if k in zz)
    print("资源键 %d 个；其中龙龙语已写 %d 个（%.1f%%）" % (len(keys), have, 100.0 * have / max(1, len(keys))))
    miss = [k for k in sorted(keys) if k not in zz]
    print("还是人话的前 40 个：")
    for k in miss[:40]:
        print("   %-14s %s" % (k, keys[k][:56]))
    print("……共 %d 个" % len(miss))


if __name__ == "__main__":
    a = sys.argv[1:]
    if not a:
        print(__doc__); sys.exit(1)
    cmd = a[0]
    if cmd == "scan":
        cmd_scan(a[1:])
    elif cmd == "apply":
        pairs = []
        for x in a[1:]:
            p, f = x.split("=", 1)
            pairs.append((p, os.path.join(SRC, f)))
        cmd_apply(pairs)
    elif cmd == "render":
        cmd_render()
    elif cmd == "status":
        cmd_status()
    else:
        print(__doc__); sys.exit(1)
