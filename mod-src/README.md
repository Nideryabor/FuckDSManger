# 🐉 mod-src —— 模块「真编译」工程

> 这个文件夹解决一件事：**模块不再手写 smali**。
> 写 Java / Kotlin → `javac` / `kotlinc` → `d8` → 进包，寄存器、类型、分支极性全交给编译器。

建立于 2026-09-25，第一件成品是**入口类 `GmEntry`**（替代模板带过来的 `com.varuns2002.disable_flag_secure.DisableFlagSecure`）。

---

## 一、目录

```
mod-src/
├── src/                    ★ 我们真正在编的代码（真编译）
│   └── com/nidyaber/fuckdsmanger/GmEntry.java     入口（原 DisableFlagSecure 的等价移植）
├── stub/                   编译期「签名桩」——只挂 -classpath，绝不进 dex
│   └── com/varuns2002/disable_flag_secure/gm/     GmUtil / GmDiag / GmCrashHook / GmCallDialog
│                                                  + 8 个 hook 类（只要无参构造 + 是 XC_MethodHook）
├── verify/                 验证（不通过就不许出包）
│   ├── expected-hooks.txt  期望的 hook 注册序列（从 2.22.110 手抄下来）
│   └── extract_hooks.py    从编译产物里按【调用点顺序】把注册序列抽出来比对
├── pack/                   自己造 APK 的家伙
│   ├── axml.py             自己写的 Android 二进制 XML 编解码器
│   ├── build_apk.py        封包：manifest + dex + init + resources + 签名
│   └── keys/               AOSP testkey（与现网模块同证书 ⇒ 能原地升级）
├── build.sh                真编译：桩 → javac → d8 → baksmali
└── package.sh              一键：build.sh + build_apk.py
```

---

## 二、怎么用

```sh
cd /workspace/mod-src

./build.sh                       # 只真编译 → out/smali/ + build/dex/classes.dex

./package.sh <基础APK> 442 2.22.111
#   → out/FuckDSManger_NL_2.22.111_for_ds2.5.2-signed.apk  （已签名，可直接装）
```

基础 APK 就是**上一版的模块包**：从它身上搬 `classes.dex`（一个字节不改）和 `res/`、`resources.arsc` 素材，
新版本的 manifest / 我们编译的 dex / `xposed_init` 由我们自己造。

---

## 三、加一条 hook 有多难？

以前：数 `.registers`、算 `p0 = v(N-K)`、念 `if-*z` 六兄弟、插完回读人工复核。

现在：

```java
hookM(cl, "wr", "z", GM + "GmSuggestAi");     // ← 就一行
```

新 hook 类照样放 `gm/` 包（`Class.forName` 按名字加载，所以宿主改名不影响注册），
需要在入口里 `new` 出来的，就往 `stub/` 里补一个签名桩。

---

## 四、已经验证过什么（都是"对着真文件"验的，不是自洽）

| 项 | 怎么验的 | 结果 |
|---|---|---|
| **入口移植等价** | `verify/extract_hooks.py` 从编译产物里抽注册序列，与手抄的 2.22.110 序列 diff | **51/51 逐条一致**（类名 / 方法名 / hook 类 / 顺序） |
| **AXML 编码器** | 拿真实的 2.9.7 `AndroidManifest.xml` 解码 → 重新编码 → 逐字节比对 | **1548 字节完全一致** |
| **AXML 能改版本** | 同上，只改 versionCode/versionName 后重新比对 | **只差 2 个字节**，正是那两处 |
| **封包结构** | `apksigner verify` + 自己解析 zip | V2+V3 通过；`resources.arsc` STORED 且 `offset%4==0` |
| **签名** | `apksigner verify --print-certs` | SHA-1 `61ed377e…` = 现网模块证书，**可原地升级** |

---

## 五、顺手修掉的一个真 bug

`hkAdd`（往通话诊断对话框的自检串里追加记录）原 smali：

```smali
sget-object v1, GmCallDialog->sHookInfo
if-nez v1, :cond_c                 # ← 非空才跳过 append ⇒ append 只在 null 时执行
invoke-virtual {v0, v1}, StringBuilder->append(String)
```

⇒ `StringBuilder.append(null)` 出来的是字面量 `"null"`，
**自检串第一次被拼出来就成了 `nullcom.ao1.I=3 | ...`**。
按意图改成「非空才 append」：`if (cur != null) sb.append(cur);`

> 这个 bug 手写 smali 时看不见（字节码完全合法），翻译成 Java 时一眼就露馅了 —— 正好是「真编译」的价值。

---

## 六、还没做的

- [ ] **用 2.22.110 真包出一版 2.22.111**（等基础 APK 进沙箱）
- [ ] **把模板那两个 `DisableFlagSecure` 类从 dex 里彻底删掉**：
      现在只是「没人指向它」（`xposed_init` 已指向新入口），
      要硬删得走 R8：`--pg-conf` 里 `-keep` 整个 `gm.**` + 我们的入口，其余不可达即被裁。
      （`gm.**` 全是 `Class.forName` 反射加载，keep 规则少不得）
- [ ] 后续把别的 `gm/` 类也陆续搬进 `src/`（一次一个，用 `verify/` 同样的法子验等价）
