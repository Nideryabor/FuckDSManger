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
│   └── keys/               🔑 我们自己的私钥（fuckdsmanger.*）＋ 备用的 AOSP testkey
│                           ⚠️ 已 gitignore；副本在 /workspace/签名钥匙备份-2026-09-25/
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
| **签名** | `apksigner verify --print-certs` | 已换成**我们自己的私钥**，SHA-1 `32c8b057…`；旧包是 AOSP testkey（`61ed377e…`），靠核心破解覆盖 |

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

## 六、签名

从 2.22.111 起，模块用**我们自己的私钥**签（2026-09-25 生，4096-bit RSA，30 年）：

| 项 | 值 |
|---|---|
| Subject | `CN=FuckDSManger, OU=Nidyaber, O=dxyabab, C=CN` |
| SHA-1 | `32:C8:B0:57:9D:BE:41:E7:65:FB:25:F5:63:5B:73:3D:B9:FD:24:25` |
| SHA-256 | `9C:2D:D7:4D:F0:09:FA:57:43:D1:16:F3:A4:7F:EE:CE:29:30:F5:31:C3:09:2A:B5:91:09:16:14:5C:A3:78:05` |

- 正本：`pack/keys/fuckdsmanger.{jks,p12,pk8,x509.pem}`（密码 `***REMOVED***`，别名 `fuckdsmanger`）
- 给主人带走的副本：`/workspace/签名钥匙备份-2026-09-25/`（含 zip，已 gitignore）
- **丢了就再也签不出能覆盖安装的包** ⇒ 至少存两处

> 旧包是 MT管理器 用 **AOSP testkey** 签的（`pack/keys/testkey.*` 保留着当备用）。
> 证书变了，正常要卸载重装 —— 主人用**核心破解**，直接覆盖即可。

---

## 七、还没做的

- [ ] **用 2.22.110 真包出一版 2.22.111**（等基础 APK 进沙箱）
- [ ] **把模板那两个 `DisableFlagSecure` 类从 dex 里彻底删掉**：
      现在只是「没人指向它」（`xposed_init` 已指向新入口），
      要硬删得走 R8：`--pg-conf` 里 `-keep` 整个 `gm.**` + 我们的入口，其余不可达即被裁。
      （`gm.**` 全是 `Class.forName` 反射加载，keep 规则少不得）
- [ ] 后续把别的 `gm/` 类也陆续搬进 `src/`（一次一个，用 `verify/` 同样的法子验等价）

---

## 八、Resource pipeline（2026-09-25 更新：**arm64 有 aapt2 了**）

主人搞来了一份 **arm64 原生** aapt2（`Android Asset Packaging Tool 2.19-V.55bc87c`），
**不再需要 qemu**。工具在 `/workspace/tools/aapt2/{aapt2_64, aapt_64}`。

> 之前那句「arm64 上没有 aapt2，所以只能手绘/不能加资源」**作废**。

标准流程（= AGP 的做法，我们手工照做）：

```sh
cd /workspace

# ① 编每一份 res（我们的 + 每个 AAR 的）
tools/aapt2/aapt2_64 compile --dir res -o work/res.zip
for a in fdm-app/libs/*.aar; do unzip -o "$a" 'res/*' -d work/aar_res/$(basename $a .aar)/ ; done
# 每份 AAR 的 res 也 compile，产物一起 link

# ② 把所有 AAR 的 R.txt 变成 stable-ids，钉死库期望的资源 ID
#    格式: <包名>:<type>/<name> = 0x7f0x0000
python3 tools/…/make_stable_ids.py > work/stable-ids.txt

# ③ link：出 resources.arsc + AXML + R.java（ID 与库一致 ⇒ 库代码能取到自己的资源）
tools/aapt2/aapt2_64 link -o work/base.apk -I tools/jvm/lib/android.jar \
    --manifest AndroidManifest.xml --java work/rjava \
    --stable-ids work/stable-ids.txt --min-sdk-version 26 \
    work/res.zip work/aar_res/*.zip

# ④ 之后照旧：d8/r8 出 dex → 自己组 zip（arsc STORED+4 对齐）→ apksigner 签
```

**影响**：
- 我们的 UI **可以上真矢量图**（Material Symbols 的 VectorDrawable XML），不用再拿 Unicode 字符糊
- 那个"独立 Compose App 秒崩"的根（资源表空）**已经可修**
- Compose 路线成立：捆 Compose + **R8 `-repackageclasses` 全量改名** ⇒ 不会和宿主的 Compose 撞车
