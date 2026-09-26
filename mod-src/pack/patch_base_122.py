#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
patch_base_122.py —— 底座 2.22.121 → 2.22.122：**B1 的底座侧（读侧替换）** 🐲

> 为什么：`fuckds_pin_*` 影子键**写进去了但没人读**（全底座只有 `GmStore` 的 write/remove 两处提到它）。
> 这个脚本给 `GmMmkvHook` 装上一张 **pin 表**，并在**已有的读侧钩子**里查表替换。

## 改什么（`GmMmkvHook` 一个类，三处）

1. 加静态字段 `sPins:Ljava/util/HashMap;`
2. 加三个方法
   - `public static setPins(Ljava/util/HashMap;)V` ← 桥把**同一个 map 实例**塞进来（之后 put 立刻可见）
   - `private static pin(Ljava/lang/String;)Ljava/lang/String;` ← 查表
   - `private static logPin(Ljava/lang/String;)V` ← 带 try/catch 的日志（pin 命中是高频事件）
3. 在 `afterHookedMethod`（已挂在 `MMKV.k` = getString 上）里，**拿到 key 之后先查 pin**：
   命中 ⇒ `setResult(pin)` + 打一行日志 + 返回（原有的 `handle()` 逻辑**一个字不动**）

## 为什么落在这里（不新增钩子）

`GmEntry` 早就把 `GmMmkvHook` 挂在 `com.tencent.mmkv.MMKV` 的 `k`（读字符串）/ `q`（写字符串）上了，
`afterHookedMethod` 的骨架就是"读到值 → 调 handle → setResult(新值)"。
⇒ B1 只是**往这个已有骨架里塞一次查表**，不新建机制、不新增 hook 注册点。

## 用法

    python3 mod-src/pack/patch_base_122.py \\
        --base mod-src/out/FuckDSManger_NL_2.22.121_for_ds2.5.2-signed.apk \\
        --out  mod-src/out/FuckDSManger_NL_2.22.122_for_ds2.5.2-signed.apk \\
        --version-code 453 --version-name 2.22.122

出包前自动复核：① 只有 `GmMmkvHook.smali` 一个文件变 ② types/methods/classes 三计数不变
"""
import argparse
import os
import shutil
import sys
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
from patch_base import SMALI_CP, run, dex_counts, baksmali   # noqa: E402

WORK = os.path.join(ROOT, "mod-src", "work", "patch_base_122")
GM = os.path.join("com", "nidyaber", "fuckdsmanger", "gm", "GmMmkvHook.smali")

FIELD_BLOCK = """# static fields
.field private static sPins:Ljava/util/HashMap;
"""

NEW_METHODS = """
.method public static setPins(Ljava/util/HashMap;)V
    .registers 1

    sput-object p0, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->sPins:Ljava/util/HashMap;

    return-void
.end method

.method private static logPin(Ljava/lang/String;)V
    .registers 3

    :try_start_0
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_5

    :catchall_5
    return-void
.end method

.method private static pin(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->sPins:Ljava/util/HashMap;

    if-nez v0, :cond_5

    const/4 v0, 0x0

    return-object v0

    :cond_5
    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    return-object v0
.end method
"""

ANCHOR = """    check-cast v1, Ljava/lang/String;

    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;"""

PIN_CHECK = """    check-cast v1, Ljava/lang/String;

    # \\u2605 B1\\uff1a\\u5148\\u67e5 pin \\u8868\\uff08\\u5bbf\\u4e3b\\u8bfb\\u8fd9\\u4e2a key \\u65f6\\uff0c\\u82e5\\u6211\\u4eec\\u6709\\u8986\\u76d6\\u503c\\u5c31\\u6362\\u6389\\uff09
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->pin(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_pinmiss

    invoke-virtual {p1, v4}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v4, "[mmkv] pin \\u547d\\u4e2d\\uff08\\u8bfb\\u65f6\\u66ff\\u6362\\uff09"

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->logPin(Ljava/lang/String;)V

    return-void

    :cond_pinmiss

    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;"""


def patch_mmkv(path):
    src = open(path, encoding="utf-8").read()

    # ---------- ① 静态字段 ----------
    old_hdr = '.source "GmMmkvHook.java"\n\n\n# direct methods\n'
    assert src.count(old_hdr) == 1, "类头格式变了"
    src = src.replace(old_hdr, '.source "GmMmkvHook.java"\n\n' + FIELD_BLOCK + '\n# direct methods\n')

    # ---------- ② 三个新方法（插在构造函数之后，仍在 direct methods 区）----------
    i = src.index(".method public constructor <init>()V")
    j = src.index(".end method", i) + len(".end method")
    src = src[:j] + "\n" + NEW_METHODS + src[j:]

    # ---------- ③ afterHookedMethod 里查 pin ----------
    assert src.count(ANCHOR) == 1, "读侧锚点不唯一"
    src = src.replace(ANCHOR, PIN_CHECK)

    open(path, "w", encoding="utf-8").write(src)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--version-code", type=int, default=453)
    ap.add_argument("--version-name", default="2.22.122")
    a = ap.parse_args()

    shutil.rmtree(WORK, ignore_errors=True)
    os.makedirs(WORK)
    orig_dex = os.path.join(WORK, "orig.dex")
    with zipfile.ZipFile(a.base) as z:
        open(orig_dex, "wb").write(z.read("classes.dex"))
    print("底座 dex : %d 字节" % os.path.getsize(orig_dex))

    baksmali(orig_dex, os.path.join(WORK, "sm"))
    patch_mmkv(os.path.join(WORK, "sm", GM))
    new_dex = os.path.join(WORK, "new.dex")
    run(["java", "-cp", SMALI_CP, "org.jf.smali.Main", "assemble", "--api", "26",
         "-o", new_dex, os.path.join(WORK, "sm")])
    print("新 dex   : %d 字节" % os.path.getsize(new_dex))

    # ---------- 复核 ----------
    baksmali(new_dex, os.path.join(WORK, "sm2"))
    baksmali(orig_dex, os.path.join(WORK, "sm0"))
    diffs = []
    for root, _d, files in os.walk(os.path.join(WORK, "sm0")):
        for f in files:
            p0 = os.path.join(root, f)
            rel = os.path.relpath(p0, os.path.join(WORK, "sm0"))
            p2 = os.path.join(WORK, "sm2", rel)
            if not os.path.exists(p2) or open(p0, "rb").read() != open(p2, "rb").read():
                diffs.append(rel)
    print("① diff   : 不同的类 %d 个 %s" % (len(diffs), diffs[:5]))
    if diffs != [GM]:
        sys.exit("✗ 只允许 %s 一个文件不同，实际：%s" % (GM, diffs))

    c0, c1 = dex_counts(orig_dex), dex_counts(new_dex)
    # ★ types / classes 必须**一个不差**。
    # ★ methods 这一栏是 dex 头里的 method_ids —— **数的是"方法引用"不是"方法定义"**：
    #   我们新增 3 个方法定义，smali 侧正好 +3；method_ids 还会因为新引入的**调用引用**
    #   （如 HashMap.get / 我们自己的新方法）再多涨几个 ⇒ 只要求"小幅正增长"。
    same = (c0[0] == c1[0] and c0[2] == c1[2])
    dm = c1[1] - c0[1]
    print("② 计数   : types %d→%d · classes %d→%d · method_ids %d→%d (%+d) %s"
          % (c0[0], c1[0], c0[2], c1[2], c0[1], c1[1], dm, "✓" if same else "✗"))
    if not same:
        sys.exit("✗ types/classes 变了，说明改坏了")
    if not (3 <= dm <= 8):
        sys.exit("✗ method_ids 只该小幅增长（新增 3 个定义 + 少量新调用），实际 %+d" % dm)
    print("         （3 个新方法定义 + 少量新调用引用，符合预期）")

    nb = open(new_dex, "rb").read()
    for tok in ("setPins", "sPins", "logPin"):
        if tok.encode() not in nb:
            sys.exit("✗ 新 dex 里没有 %s" % tok)
    print("③ 新符号 : setPins / sPins / logPin 都在 ✓")

    run([sys.executable, os.path.join(HERE, "build_apk.py"),
         "--base", a.base, "--dex", new_dex,
         "--version-code", str(a.version_code), "--version-name", a.version_name,
         "--entry-class", "com.nidyaber.fuckdsmanger.GmEntry",
         "--out", a.out])
    signed = a.out.replace(".apk", "-signed.apk")
    if os.path.exists(signed):
        shutil.move(signed, a.out)
    print("→ 新底座 : %s (%d 字节)" % (a.out, os.path.getsize(a.out)))


if __name__ == "__main__":
    main()
