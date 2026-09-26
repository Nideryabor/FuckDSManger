#!/usr/bin/env python3
"""
patch_base.py —— 重建底座（把「不依赖宿主包名」那三处改掉）🐲

> ★ 为什么需要这个脚本：`mod-src/out/*.apk` 是 **gitignore** 的（`*.apk`），
>   光把包留在小窝里没用 —— 换台机器 / 换个会话就复现不了。
>   **脚本才留得住。**

## 它干的活（2.22.120 → 2.22.121）

底座里有三处依赖宿主包名 / 宿主类名，宿主一改名就**静默全灭**：

| # | 位置 | 原来 | 改成 |
|---|---|---|---|
| 1 | `GmEntry.hookPickAll` | `findClass("com.deepseek.chat.MainActivity")` 起手爬父类 | `findClass("android.app.Activity")`（框架类，名字永不变） |
| 2 | `GmEntry.handleLoadPackage` 总闸 | `packageName.startsWith("com.deepseek.chat")` → 否则 `return-void` | **锚点探针**：`findClass("kf5")` / `findClass("uia")` 任一成功即宿主；全失败**打日志**再退 |
| 3 | `GmEntry.handleLoadPackage` | hook `com.deepseek.chat.MainActivity.onResume` | hook `android.app.Activity.onResume` |

> 依据（都是实测过的，不是猜的）：
> · 宿主 `MainActivity` **没声明** `onActivityResult` ⇒ 今天生效的本就是爬到框架类那条路，换过去零损失
> · `GmResumeHook` 只做 `thisObject as Activity` + 维护，**天生与名字无关**
> · `GmPickHook` **只认 `requestCode == 0x435b`**，挂框架类零副作用
> · 底座自己的 `GmResumeHook.ensurePick` 早就在挂 `android.app.Activity.onActivityResult`

## 用法

    python3 mod-src/pack/patch_base.py \\
        --base   mod-src/out/FuckDSManger_NL_2.22.120_for_ds2.5.2-signed.apk \\
        --out    mod-src/out/FuckDSManger_NL_2.22.121_for_ds2.5.2-signed.apk \\
        --version-code 452 --version-name 2.22.121

**出包前会自动复核**（不通过就不写盘）：
  ① 原始 vs 新 反编译 diff —— 只允许 `GmEntry.smali` 一个文件不同
  ② `types / methods / classes` 三个计数必须一致
  ③ dex 里不许再出现 `com.deepseek.chat` / `com/deepseek/chat`

> ⚠️ **别拿 md5 校验这个 dex**：`smali assemble` **不是字节级确定的**
> （类顺序 / 常量池布局会变），所以同一个 smali 跑两次 md5 都不一样。
> 复核一律走 **反编译后 diff**（`baksmali` → 文本比较）—— 那才是语义。
"""
import argparse
import os
import re
import shutil
import struct
import subprocess
import sys
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
WORK = os.path.join(ROOT, "mod-src", "work")
SMALI_CP = ":".join(["/usr/share/java/smali.jar", "/usr/share/java/baksmali.jar",
                     "/usr/share/java/dexlib2.jar", "/usr/share/java/smali-util.jar",
                     "/usr/share/java/jcommander.jar", "/usr/share/java/guava.jar"])
HOST_ENTRY = "com/nidyaber/fuckdsmanger/GmEntry.smali"
HOST_MARKERS = (b"com.deepseek.chat", b"com/deepseek/chat")


def run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit("✗ 命令失败：%s\n%s" % (" ".join(cmd[:4]), (r.stderr or r.stdout)[:2000]))


def dex_counts(path):
    d = open(path, "rb").read()
    n_type, = struct.unpack_from("<I", d, 64)
    n_meth, = struct.unpack_from("<I", d, 88)
    n_cls, = struct.unpack_from("<I", d, 96)
    return n_type, n_meth, n_cls


def baksmali(dex, out):
    shutil.rmtree(out, ignore_errors=True)
    run(["java", "-cp", SMALI_CP, "org.jf.baksmali.Main", "disassemble", dex, "-o", out])


# ------------------------------------------------------------------ 三处改动

def _find(L, pred, lo=0):
    for i in range(lo, len(L)):
        if pred(L[i]):
            return i
    sys.exit("✗ 找不到目标行（底座版本对不上？）")


def _patch_str_near(L, anchor, want, newline):
    for j in range(anchor, anchor + 6):
        if L[j].strip().startswith("const-string") and want in L[j]:
            L[j] = newline
            return
    sys.exit("✗ 锚点附近没找到含 %s 的 const-string" % want)


def patch_gm_entry(path):
    L = open(path, encoding="utf-8").read().split("\n")

    # ① hookPickAll：起点类 → 框架 Activity
    i = _find(L, lambda s: s.strip() == ".line 211")
    _patch_str_near(L, i, "com.deepseek.chat.MainActivity",
                    '    const-string v0, "android.app.Activity"')

    # ③ onResume 落点 → 框架 Activity
    r = _find(L, lambda s: s.strip() == ":try_start_5e")
    _patch_str_near(L, r, "com.deepseek.chat.MainActivity",
                    '    const-string v0, "android.app.Activity"')

    # ④ 日志文案（诚实一点）
    k = _find(L, lambda s: "hooked MainActivity.onResume OK" in s)
    L[k] = L[k].replace("hooked MainActivity.onResume OK", "hooked Activity.onResume OK")

    # ② 总闸：放最后改（它在文件更靠后，先改会挪动上面两处的定位）
    g = _find(L, lambda s: s.strip() == ".line 36")
    assert L[g + 1].strip() == 'const-string v1, "com.deepseek.chat"', L[g + 1]
    assert L[g + 9].strip() == "return-void", repr(L[g + 9])
    L[g:g + 10] = '''    .line 36
    :try_start_g1
    const-string v1, "kf5"

    iget-object v2, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;
    :try_end_g1
    .catchall {:try_start_g1 .. :try_end_g1} :catchall_g1

    goto :cond_26

    :catchall_g1
    move-exception v1

    :try_start_g2
    const-string v1, "uia"

    iget-object v2, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;
    :try_end_g2
    .catchall {:try_start_g2 .. :try_end_g2} :catchall_g2

    goto :cond_26

    :catchall_g2
    move-exception v1

    const-string v1, "[GATE] anchors kf5/uia missing - not host, skip"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void'''.split("\n")

    open(path, "w", encoding="utf-8").write("\n".join(L))


# ------------------------------------------------------------------ 主流程

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--version-code", type=int, default=452)
    ap.add_argument("--version-name", default="2.22.121")
    a = ap.parse_args()

    tmp = os.path.join(WORK, "patch_base")
    shutil.rmtree(tmp, ignore_errors=True)
    os.makedirs(tmp)

    # 取出底座 dex
    orig_dex = os.path.join(tmp, "orig.dex")
    with zipfile.ZipFile(a.base) as z:
        open(orig_dex, "wb").write(z.read("classes.dex"))
    print("底座 dex : %d 字节" % os.path.getsize(orig_dex))

    # 反编译 → 改 → 回编
    baksmali(orig_dex, os.path.join(tmp, "sm"))
    patch_gm_entry(os.path.join(tmp, "sm", HOST_ENTRY))
    new_dex = os.path.join(tmp, "new.dex")
    run(["java", "-cp", SMALI_CP, "org.jf.smali.Main", "assemble", "--api", "26",
         "-o", new_dex, os.path.join(tmp, "sm")])
    print("新 dex   : %d 字节" % os.path.getsize(new_dex))

    # ---------- 复核 ① diff ----------
    baksmali(new_dex, os.path.join(tmp, "sm2"))
    baksmali(orig_dex, os.path.join(tmp, "sm0"))
    diffs = []
    for root, _d, files in os.walk(os.path.join(tmp, "sm0")):
        for f in files:
            p0 = os.path.join(root, f)
            rel = os.path.relpath(p0, os.path.join(tmp, "sm0"))
            p2 = os.path.join(tmp, "sm2", rel)
            if not os.path.exists(p2) or open(p0, "rb").read() != open(p2, "rb").read():
                diffs.append(rel)
    print("① diff   : 不同的类 %d 个 %s" % (len(diffs), diffs[:5]))
    if diffs != [HOST_ENTRY]:
        sys.exit("✗ 只允许 %s 一个文件不同，实际：%s" % (HOST_ENTRY, diffs))

    # ---------- 复核 ② 三计数 ----------
    c0, c1 = dex_counts(orig_dex), dex_counts(new_dex)
    print("② 计数   : 原 types/methods/classes=%s  新=%s %s"
          % (c0, c1, "✓" if c0 == c1 else "✗"))
    if c0 != c1:
        sys.exit("✗ dex 规模变了，说明改坏了")

    # ---------- 复核 ③ 不许再有宿主包名 ----------
    nb = open(new_dex, "rb").read()
    bad = [m.decode() for m in HOST_MARKERS if m in nb]
    print("③ 铁律   : 宿主包名残留 %d 处 %s" % (len(bad), "✓" if not bad else bad))
    if bad:
        sys.exit("✗ 还有宿主包名：%s" % bad)

    # ---------- 组新底座 APK ----------
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
