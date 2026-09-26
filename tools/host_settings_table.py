#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
host_settings_table.py —— **C0：抽宿主的「权威设置表」** 🐲

> 为什么需要它：模块改灰度值一直"改了没生效"，根因是**我们不知道宿主到底读哪个键、什么类型**。
> 这张表把"猜"全部换成"抄"。

## 表从哪来

宿主里有一个 Kotlin data class `n02`（`toString()` 把它出卖了）：

    SettingModel(key=…, comment=…, type=…, defaultValue=…)

而 `Lo02.<init>()`（1738 指令 / 167 串 / 493 invoke）**把每一项设置都 new 出来一次**，
紧跟着还会调 `MMKV.contains("kv_settings_<纯名>")` ——
⇒ **字节码里同时写着：纯名 / 类型 / 默认值 / 宿主实际探测的键形**。

## 用法

    python3 tools/host_settings_table.py \\
        --dex  tmp/host252/classes.dex \\
        --keys 参考/数据/module-83-keys.txt \\
        --out  参考/数据/host-2.5.2-设置表.tsv

`--keys` 给的是**模块自己那 83 项**的纯名（一行一个）。脚本会把它和宿主表对齐，算出
**每一项"宿主实际读哪个键"**（三选一），落进 `宿主读的键` 那一列。

## 三选一的分派（实测 2.5.2）

| 走哪条 | 判据 | 2.5.2 实测 |
|---|---|---|
| `kv_settings_<纯名>` | 在 `Lo02.<init>` 里（SettingModel 表） | **63 项** |
| `kv_remote_settings_<纯名>` | 不在表里，但宿主 dex 里有这个字面量 | **18 项** |
| `<纯名>`（裸名） | 上面两个都没有，只有裸字面量 | **2 项** |
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile

SMALI_CP = ":".join(["/usr/share/java/baksmali.jar", "/usr/share/java/dexlib2.jar",
                     "/usr/share/java/guava.jar", "/usr/share/java/jcommander.jar"])
TARGET = "Lo02;"          # 设置表的构造点
MODEL = "Ln02;"           # SettingModel


def baksmali_class(dex, outdir, classes):
    os.makedirs(outdir, exist_ok=True)
    r = subprocess.run(["java", "-cp", SMALI_CP, "org.jf.baksmali.Main", "disassemble",
                        dex, "-o", outdir, "--classes", classes],
                       capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit("✗ baksmali 失败：\n%s" % (r.stderr or r.stdout)[:1500])


def parse_entries(smali_path):
    """从 Lo02.<init> 里抽 (纯名, 注释, 类型, 默认值, 宿主探测的键形)。"""
    src = open(smali_path, encoding="utf-8").read().split("\n")
    i0 = next(i for i, l in enumerate(src) if l.startswith(".method public constructor <init>()V"))
    i1 = next(i for i in range(i0, len(src)) if src[i].strip() == ".end method")
    body = [l.strip() for l in src[i0:i1]
            if l.strip() and not l.strip().startswith((".line", ".registers", ".param", "#"))]

    reg, entries, pending, last = {}, [], None, None

    def val(r):
        v = reg.get(r.strip().lstrip("v"))
        return str(v[1]) if v else "?"

    for k, ins in enumerate(body):
        m = re.match(r'const-string v(\d+), "(.*)"$', ins)
        if m:
            reg[m.group(1)] = ("str", m.group(2)); pending = m.group(1); continue
        m = re.match(r'const(?:/4|/16|/high16)? v(\d+), (0x[0-9a-fA-F-]+|-?\d+)$', ins)
        if m:
            reg[m.group(1)] = ("int", int(m.group(2), 0)); pending = m.group(1); continue
        m = re.match(r'const-wide(?:/16|/32|/high16)? v(\d+), (0x[0-9a-fA-F-]+|-?\d+)$', ins)
        if m:
            reg[m.group(1)] = ("long", int(m.group(2), 0)); pending = m.group(1); continue
        m = re.match(r'sget-object v(\d+), (L[^;]+;->[^:]+:.*)$', ins)
        if m:
            reg[m.group(1)] = ("obj", m.group(2)); pending = None; continue
        m = re.match(r'new-instance v(\d+), (L[^;]+;)$', ins)
        if m:
            reg[m.group(1)] = ("new", m.group(2)); pending = None; continue
        if "String;->valueOf(I)" in ins or "String;->valueOf(J)" in ins:
            continue
        m = re.match(r'move-result-object v(\d+)$', ins)
        if m:
            prev = body[k - 1] if k else ""
            reg[m.group(1)] = ("str", val(pending)) if ("String;->valueOf" in prev and pending) \
                else ("obj", "<call>")
            pending = None; continue
        m = re.match(r'move-result(?:-wide)? v(\d+)$', ins)
        if m:
            reg[m.group(1)] = ("int", "<call>"); continue
        # ★ 一项设置 = new n02(纯名, 注释, 类型, 默认值)
        m = re.match(r'invoke-direct \{([^}]+)\}, Ln02;-><init>'
                     r'\(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;\)V$', ins)
        if m:
            rs = [x.strip() for x in m.group(1).split(",")]
            if len(rs) == 5:
                last = {"key": val(rs[1]), "comment": val(rs[2]),
                        "type": val(rs[3]), "default": val(rs[4]), "probe": "?"}
                entries.append(last)
            continue
        # 紧跟其后：MMKV.contains("kv_settings_<纯名>") ⇒ 宿主实际探测的键形
        m = re.match(r'invoke-virtual \{v\d+, (v\d+)\}, Lcom/tencent/mmkv/MMKV;->contains'
                     r'\(Ljava/lang/String;\)Z$', ins)
        if m and last is not None:
            last["probe"] = val(m.group(1)); continue
        if ins.startswith("invoke-"):
            pending = None
    return entries


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dex", required=True, help="宿主的 classes.dex")
    ap.add_argument("--keys", help="模块自己的键表（纯名，一行一个）；给了就做三选一分派")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    dex_bytes = open(a.dex, "rb").read()
    tmp = tempfile.mkdtemp(prefix="c0_")
    try:
        baksmali_class(a.dex, tmp, "Lo02;,Ln02;")
        entries = parse_entries(os.path.join(tmp, "o02.smali"))
    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    import collections
    print("宿主 SettingModel 表 : %d 项" % len(entries))
    print("类型分布            : %s" % dict(collections.Counter(e["type"] for e in entries)))
    print("未解析字段          : %d" % sum(1 for e in entries
                                          if "?" in (e["key"], e["type"]) or e["default"] == "?"))
    probes = collections.Counter(e["probe"].split("_")[1] if "_" in e["probe"] else e["probe"]
                                 for e in entries)
    print("宿主探测的键形      : %s" % dict(probes))

    host = {e["key"]: e for e in entries}

    def host_form(bare):
        """三选一：kv_settings_ / kv_remote_settings_ / 裸名"""
        if bare in host:
            return host[bare]["probe"], "SettingModel"
        if ("kv_remote_settings_" + bare).encode() in dex_bytes:
            return "kv_remote_settings_" + bare, "远程设置字面量"
        if bare.encode() in dex_bytes:
            return bare, "裸名字面量"
        return "?", "宿主里查不到"

    lines = ["# 宿主 DeepSeek 2.5.2 (com.deepseek.chat.a / vc273) —— 权威设置表 🐲",
             "# 来源：Lo02.<init>（SettingModel 表）+ 宿主 dex 字面量；工具 tools/host_settings_table.py",
             "# 列：纯名\t类型\t默认值\t宿主实际读的键\t来源"]
    keys = [l.strip() for l in open(a.keys, encoding="utf-8")] if a.keys else []
    keys = [k for k in keys if k and not k.startswith("#")]
    if keys:
        n = collections.Counter()
        for k in keys:
            form, src = host_form(k)
            n[src] += 1
            e = host.get(k, {"type": "?", "default": "?"})
            lines.append("%s\t%s\t%s\t%s\t%s" % (k, e["type"], e["default"], form, src))
        print("模块 %d 项的分派     : %s" % (len(keys), dict(n)))
        print("⚠️ 宿主里查不到的    : %s" % [k for k in keys if host_form(k)[0] == "?"])
    else:
        for e in entries:
            lines.append("%s\t%s\t%s\t%s\t%s" % (e["key"], e["type"], e["default"],
                                                 e["probe"], "SettingModel"))
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    open(a.out, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print("→ %s（%d 行）" % (a.out, len(lines) - 3))


if __name__ == "__main__":
    main()
