#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
patch_base_123.py —— 底座 2.22.122 → 2.22.123：**B1' 修落点** 🐲

## 为什么（3.15.0 真机失败的原因，已逐字节核实）

宿主 `Lqa5.D` 读一个设置的真实流程是：

```java
if (mmkv.contains("kv_settings_x")) {          // ★ 先问「存储里有没有」
    if (类型 == Int)     new m02( mmkv.g("kv_settings_x") );   // g = getInt
    else /*String*/          mmkv.j("kv_settings_x");          // j = getString(key)  ← 1 参数！
} else {
    remoteMap.containsKey(name) …              // 远程下发
}
```

而 `GmEntry` 只把 `GmMmkvHook` 挂在了 `k`（**2 参** getString）和 `q`（encode）上
⇒ **一个类型化 getter 都没挂** ⇒ **`pin` 表永远查不到** ⇒ 3.15.0 的 `pin 命中 = 0`。

（另：`kv_settings_` 的键只有 7 个物理存在，其余 56 项 `contains` 为假 ⇒ 走远程 map ⇒
  所以还必须**hook `contains`**，让它对我们的 pin 键回答 true。）

## 改什么

**① `GmEntry`**：给 `com.tencent.mmkv.MMKV` 补挂 `j`（1 参 getString）和 `contains`。

**② `GmMmkvHook.afterHookedMethod`**：重写为**按返回类型分派**（不再假设 args 一定是 2 个 String）：
   - 结果是 `String`（`j` / `k`）⇒ 查 pin，命中就 `setResult(pin)`；没命中就落回原有的 `handle()` 逻辑
   - 结果是 `Boolean` 且为 `false`（`contains` 说"没有"）⇒ 我们有 pin 就把答案改成 `true`
   - 守卫从 `args.length == 2` 放宽到 `>= 1`

> 本步只铺 **String 路径**（够验通链路）。`g/d/i/e`（Int/Boolean/Long/Float）
> 另开一步（B2），那时的分派写在这个骨架里就很自然了。

## 用法

    python3 mod-src/pack/patch_base_123.py \\
        --base mod-src/out/FuckDSManger_NL_2.22.122_for_ds2.5.2-signed.apk \\
        --out  mod-src/out/FuckDSManger_NL_2.22.123_for_ds2.5.2-signed.apk \\
        --version-code 454 --version-name 2.22.123
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

WORK = os.path.join(ROOT, "mod-src", "work", "patch_base_123")
GM = os.path.join("com", "nidyaber", "fuckdsmanger", "gm", "GmMmkvHook.smali")
ENTRY = "com/nidyaber/fuckdsmanger/GmEntry.smali"

HOOKM = "Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"

# ---------- ① GmEntry：补挂 j 和 contains ----------
ENTRY_ANCHOR = """    .line 63
    const-string v1, "k"

    invoke-static {p1, v5, v1, v6}, """ + HOOKM

ENTRY_NEW = ENTRY_ANCHOR + """

    # \\u2605 B1'\\uff1a\\u5bbf\\u4e3b\\u8bfb\\u4e00\\u4e2a\\u8bbe\\u7f6e\\u7684\\u771f\\u5b9e\\u8def\\u5f84\\u662f
    #   contains(\\u952e) \\u4e3a\\u771f \\u21d2 \\u7c7b\\u578b\\u5316 getter\\uff08j = getString 1 \\u53c2\\uff09
    #   \\u6240\\u4ee5\\u300c\\u60f3\\u8986\\u76d6\\u300d\\u5c31\\u5fc5\\u987b\\u540c\\u65f6\\u62e6\\u4f4f\\u8fd9\\u4e24\\u4e2a\\u3002
    const-string v1, "j"

    invoke-static {p1, v5, v1, v6}, """ + HOOKM + """

    const-string v1, "contains"

    invoke-static {p1, v5, v1, v6}, """ + HOOKM

# ---------- ② GmMmkvHook.afterHookedMethod 重写 ----------
NEW_AFTER = """.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_end

    array-length v1, v0

    const/4 v2, 0x1

    if-lt v1, v2, :cond_end

    const/4 v1, 0x0

    aget-object v1, v0, v1

    instance-of v2, v1, Ljava/lang/String;

    if-eqz v2, :cond_end

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_end

    instance-of v3, v2, Ljava/lang/String;

    if-eqz v3, :cond_bool

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->pin(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_strmiss

    invoke-virtual {p1, v3}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v3, "[mmkv] pin \\u547d\\u4e2d\\uff08\\u8bfb\\u65f6\\u66ff\\u6362\\uff09"

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->logPin(Ljava/lang/String;)V

    return-void

    :cond_strmiss
    check-cast v2, Ljava/lang/String;

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->handle(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_end

    invoke-virtual {p1, v3}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v0, "mmkv.k"

    const-string v1, "[\\u5efa\\u8bae] \\u5df2\\u63a5\\u7ba1\\u3010\\u8bfb\\u53d6\\u3011\\u8fd4\\u56de\\u503c\\uff1aprompt_feature \\u6362\\u6210\\u6a21\\u677f\\u6c60"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :cond_end

    :cond_bool
    instance-of v3, v2, Ljava/lang/Boolean;

    if-eqz v3, :cond_end

    check-cast v2, Ljava/lang/Boolean;

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    if-nez v2, :cond_end

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->pin(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_end

    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v2, "[mmkv] pin \\u547d\\u4e2d\\uff08contains \\u63d0\\u4e3a true\\uff09"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmMmkvHook;->logPin(Ljava/lang/String;)V

    :cond_end
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
"""


def patch_entry(path):
    src = open(path, encoding="utf-8").read()
    assert src.count(ENTRY_ANCHOR) == 1, "GmEntry 的 MMKV 注册锚点不唯一"
    src = src.replace(ENTRY_ANCHOR, ENTRY_NEW)
    open(path, "w", encoding="utf-8").write(src)


def patch_after(path):
    lines = open(path, encoding="utf-8").read().split("\n")
    i = next(k for k, l in enumerate(lines) if l.startswith(".method protected afterHookedMethod"))
    j = next(k for k in range(i, len(lines)) if lines[k].strip() == ".end method")
    old = "\n".join(lines[i:j + 1])
    assert "handle(Ljava/lang/String;Ljava/lang/String;)" in old, "拿到的不是读侧回调"
    new = NEW_AFTER.rstrip("\n").split("\n")
    out = lines[:i] + new + lines[j + 1:]
    open(path, "w", encoding="utf-8").write("\n".join(out))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--version-code", type=int, default=454)
    ap.add_argument("--version-name", default="2.22.123")
    a = ap.parse_args()

    shutil.rmtree(WORK, ignore_errors=True)
    os.makedirs(WORK)
    orig_dex = os.path.join(WORK, "orig.dex")
    with zipfile.ZipFile(a.base) as z:
        open(orig_dex, "wb").write(z.read("classes.dex"))
    print("底座 dex : %d 字节" % os.path.getsize(orig_dex))

    baksmali(orig_dex, os.path.join(WORK, "sm"))
    patch_entry(os.path.join(WORK, "sm", ENTRY))
    patch_after(os.path.join(WORK, "sm", GM))
    new_dex = os.path.join(WORK, "new.dex")
    run(["java", "-cp", SMALI_CP, "org.jf.smali.Main", "assemble", "--api", "26",
         "-o", new_dex, os.path.join(WORK, "sm")])
    print("新 dex   : %d 字节" % os.path.getsize(new_dex))

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
    want = sorted([GM, ENTRY])
    print("① diff   : 不同的类 %d 个 %s" % (len(diffs), diffs))
    if sorted(diffs) != want:
        sys.exit("✗ 只允许这两个文件不同：%s" % want)

    c0, c1 = dex_counts(orig_dex), dex_counts(new_dex)
    same = (c0[0] == c1[0] and c0[2] == c1[2])
    print("② 计数   : types %d→%d · classes %d→%d · method_ids %d→%d %s"
          % (c0[0], c1[0], c0[2], c1[2], c0[1], c1[1], "✓" if same else "✗"))
    if not same:
        sys.exit("✗ types/classes 变了")

    nb = open(new_dex, "rb").read()
    for tok in (b"contains", b"pin \xe5\x91\xbd\xe4\xb8\xad",
                b"contains \xe6\x8f\x90\xe4\xb8\xba true", b"j"):
        if tok not in nb:
            sys.exit("✗ 新 dex 里没有 %s" % tok)
    # ★ 别拿 smali 标签名去 dex 里找 —— 汇编器会重编号（`:cond_bool` 会变成 `:cond_2e` 之类）
    print("③ 新符号 : contains / pin 命中 / contains 提为 true 都在 ✓")

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
