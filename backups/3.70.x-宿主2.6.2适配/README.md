# 3.70.x · 宿主 2.6.2 适配 —— 改动存档

> 2026-10-16 · 尼得亚伯 🐲
> 为什么有这个目录：**底座补丁树 `tmp/base130_261/sm` 不在 git 里**（设计如此，
> 见 `专题/备份分级清单.md` §二·4「补丁树…无任何备份」）。
> ⇒ 按项目惯例（同 `backups/3.42.45-FitHook修订/`），**把本轮改动的文件入库**，
> 保证换机器/灾难后能**原样重建**。

---

## 一、改了哪 14 个文件

```
com/nidyaber/fuckdsmanger/GmEntry.smali              ← 33 处 findClass 接 GmRemap + 2 处手工
com/nidyaber/fuckdsmanger/gm/GmBubble.smali          ← 4 处 callStaticMethod 字面量 C/D → y/z
com/nidyaber/fuckdsmanger/gm/GmBubbleCellHook.smali  ← findClass 接 GmRemap
com/nidyaber/fuckdsmanger/gm/GmCallDialog.smali      ← 同上
com/nidyaber/fuckdsmanger/gm/GmEntryHook.smali       ← 同上
com/nidyaber/fuckdsmanger/gm/GmEnv.smali             ← h2() 接 GmRemap（registers 6→8）
com/nidyaber/fuckdsmanger/gm/GmPaintModHook.smali    ← 同上
com/nidyaber/fuckdsmanger/gm/GmPainterHook.smali     ← 同上
com/nidyaber/fuckdsmanger/gm/GmPromptTextHook.smali  ← idxOf 恢复设计映射（排 12/16）
com/nidyaber/fuckdsmanger/gm/GmReplyHook.smali       ← findClass 接 GmRemap
com/nidyaber/fuckdsmanger/gm/GmResumeHook.smali      ← 同上
com/nidyaber/fuckdsmanger/gm/GmSuggestAi.smali       ← 同上
com/nidyaber/fuckdsmanger/gm/GmSuggestHook.smali     ← buildMut2 夹取 + findClass 接表
com/nidyaber/fuckdsmanger/gm/GmSync.smali            ← 同上
```

**另外桥侧**（在 `mod-src/src/`，**已被 git 跟踪**，不在此目录）：
`GmRemap.java` · `FdmEntry.java` · `GmCallPin.java` · `GmHtmlHook.java` · `GmProbe.java` ·
`GmRichLink.java` · `GmRichTextHook.java` · `GmSendProbe.java` · `GmSender.java` ·
`GmSysPromptHideHook.java` · `GmSysPromptHook.java` · `GmGlassScope.java` · `GmGlassSink.java`
（本目录另存了 `GmRemap.java` 的改动前后版，便于对照）

---

## 二、怎么用它（重建底座）

```sh
# ① 拿「改动前」的树（= 上一版树，若无则用任意 2.6.1 适配后的树）
# ② 把 after/ 覆盖上去
cd /workspace
cp -a backups/3.70.x-宿主2.6.2适配/after/. tmp/base130_261/sm/
# ③ 重建底座（smali a → 替换 classes.dex）
python3 tools/重建底座.py \
    --smali tmp/base130_261/sm \
    --base  mod-src/out/FuckDSManger_NL_2.22.133_for_ds2.6.1.apk \
    --out   mod-src/out/FuckDSManger_NL_2.22.133_for_ds2.6.1.apk --api 26
# ④ 出包
sh 做包.sh 3.70.4 720
```

**回滚**：把 `before/` 覆盖回去，重跑 ③④。

---

## 三、⚠️ 不能靠「重放脚本」重建

底座改动里有一批**手工**内容（`if-eq` 的 case 号、字面量、**寄存器暂存**），
`patch_261.py` 之类的重放脚本**会抹掉**它们 ⇒ **树是唯一真相源**（教训 347）。
所以这份存档是**文本级**的（整文件），不是补丁级。

---

## 四、本轮改动的三处「手工要点」（下轮别忘）

| 位置 | 要点 |
|---|---|
| `GmEntry.handleLoadPackage` | 803 那处用了 **`v0` 做暂存**（`v7` 会被 1063 复用）—— 注意 `v0` 在该区间**必须空闲** |
| `GmEntry` 同块 | `const-string v7, "ao1"` 是**为复用者还原**的，别当冗余删掉 |
| `GmEnv.h2` | `.registers` 从 **6 抬到 8**（腾出 `v3`/`v4` 给 `cls()`/`method()`）|
