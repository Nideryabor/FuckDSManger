# 方案B：独立 Compose UI —— 已跑通 ✓（2026-09-25 深夜）

## 成品

```
★ FDM-UI-3.0-signed.apk   34.63 MB   package=com.nidyaber.fdmui
   点桌面图标「FuckDSManger UI」→ 界面正常显示 ✓（主人实测：能打开）
   dex=3(多 dex) · resources.arsc ✓ · META-INF/services ×2 ✓ · 自有私钥签名 ✓
```

## 为什么是"独立 App"而不是"注入宿主"

主人在 2.22.111~142 那条路上把 Compose 注入宿主进程，一路推到"视图测量"阶段，
最后卡在一个**结构性死结**：

```
宿主自己的 Compose 是【未混淆】的 ⇒ 运行时我们的类被解析到宿主那份
⇒ ViewTreeLifecycleOwner 的 tag key（宿主 R）与写入时（我们 R）不是一个数
⇒ Compose 永远找不到 owner ⇒ 崩
```

参照物 `Deekseep`(com.dsmod.probe) 的做法给出了答案：
**它的 UI 是自己的 SettingsActivity（桌面有图标），宿主侧只用 Intent 拉起** ✓
⇒ 参考它，改走独立进程，问题从结构上消失 ✓

## 构建链（可复现）

```bash
# ① 资源：我们的矢量图 + 所有 AAR 的 res
aapt2 compile --dir <res> -o <zip>                 # 每份 res 各来一次
aapt2 link -o base.apk -I android.jar --manifest AppManifest.xml \
    --custom-package com.nidyaber.fuckdsmanger \    # ★ R 必须落在源码期望的包
    --java rjava --output-text-symbols symbols.txt \
    mine.zip ids.zip aarres/*.zip

# ② R 类：aapt2 的 app R + 各库 R（tools/respipe/gen_r.py 按 symbols 生成）
javac -d rcls $(app R + 库 R) && jar cf rcls.jar -C rcls .

# ③ Kotlin + Compose 编译器插件
kotlinc -jvm-target 17 -Xplugin=$KOTLINC/lib/compose-compiler-plugin.jar \
        -cp "<所有 classes.jar>:android.jar:rcls" src/*.kt -d appcls

# ④ dex：R8 只裁剪不改名（真名日志！）+ 宽松 keep + 多 dex
r8 --release --lib android.jar --pg-conf r8-app.pro --main-dex-rules maindex.pro \
   --output out (所有 jar) appcls.jar rcls.jar kotlin-stdlib.jar

# ⑤ 注入 + 服务文件（关键两招，见下）
d8 --output merged $(ls out/*.dex) vt_dex/classes.dex          # 手写的库内部 R 类
zip 里补 META-INF/services/*                                    # 协程调度器等
# ⑥ apksigner 签（自有私钥）
```

## 踩坑总表（每条都真机验证过）

| 现象 | 真因 | 修法 |
|---|---|---|
| `moduleApk not found` | LSPosed 从**内存**加载模块 dex，拿不到 APK 路径 | 用 `IXposedHookZygoteInit.StartupParam.modulePath`（xposed_init 可多行） |
| `NameNotFoundException` | Android 11+ **包可见性** | `android:forceQueryable="true"`（参照物清单里就有） |
| `IllegalAccessError: sAct inaccessible` | 真身字段是**包级私有**，桩写成 public 骗过了编译器 | **桩必须照抄真身的访问修饰符** |
| `NoClassDefFoundError: poolingcontainer.R$id` | 库的**内部 R 类**只被自身引用 ⇒ R8 当没用删掉 | 手写 R 类（**纯常量即可，id 不必是真资源**）+ D8 单独出 dex 注入 |
| `Class R$id requires its nest host R` | javac 高版本给内部类加了 **NestHost** | `javac --release 8` 编译那个 R |
| `NoClassDefFoundError: core.viewtree.R$id` | 同上 | 同上 |
| `Main dispatcher is missing` | 协程实现类**只被 META-INF/services 文本引用** ⇒ 被裁 + 服务文件没进 APK | `-keep kotlinx.coroutines.android.**` + **手动把 services 文件塞进 APK** |
| `NoSuchMethodException: <init>[]` | 反射 newInstance 的**无参构造器被裁** | `-keepclassmembers ... { <init>(...); }` |
| `Cannot fit requested classes in a single dex` | 宽松 keep ⇒ 12 万方法 | `--main-dex-rules` + 多 dex（minSdk 26 原生支持） |
| `Icons.Rounded.* ClassNotFound` | 我把 `material-icons-extended` 从输入剔了 ⇒ 代码在用图标 | 加回输入（或改用我们自己的 42 个矢量图瘦身） |
| 秒崩、无堆栈 | 我**用 grep 把 kotlinc 的报错吞了**（4 次！） | **构建步骤不许无脑过滤输出** |

另一条**方法论**教训：自检脚本本身写错会产生**假阴性**（我按原始名去混淆后的 dex 里找类 ✗、shell 把 `$id` 吃掉 ✗）——
**自检也要验证"它能不能发现已知存在的目标"**。

## 下一步

1. **数据桥**：~~App 用 root 读写宿主配置（参照物用 Shizuku ✓ 我们有 root）~~
   ❌ **2026-09-26 更正（主人指出 + 已核实）**：
   参照物的 **Shizuku 是给 AI Agent 的本地工具（文件/Shell/截屏）当权限后端**，
   **和 UI ↔ 宿主通信毫无关系**（证据见 `专题/参照物-Deekseep-架构核实.md` 第一节）。
   它真正的桥是 **`XposedActivationProvider`（ContentProvider `call()` + Bundle + callingUid 白名单）**，
   **不需要 root**。⇒ 本项改为「搭 provider 桥」，详见
   `专题/双层架构-UI与hook分离.md`。
2. **模块入口**：宿主里点「检查更新」→ `startActivity` 拉起本 App
   （参照物的 `deekseep-module://` trampoline 那套 —— 已核实：hook 层类 `Main` 里
   `requestPublicTunnelBridge` / `requestLocalApiKeepAlive` 等都在用这个 scheme）
3. **瘦身**：改用我们自己的 42 个 Material Symbols 矢量图（可去掉 material-icons-extended ⇒ ~20MB）
4. **搬二级页**：旧 UI 的 17 个页面逐个搬进 Compose

## 资产（全部可复用）

```
tools/aapt2/{aapt2_64,aapt_64}      arm64 原生 aapt2（主人搞来的，价值连城）
tools/symbols/                       Material Symbols 官方 TTF + 7854 个 SVG + svg2vd.py
tools/respipe/gen_r.py               各库 R 类生成器
pipeline/r8-app.pro / maindex.pro    可用的 R8 配置（不改名版）
pipeline/out/mapping.txt             51 万行映射表（模块那条路用）
```
