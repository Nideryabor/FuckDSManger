# 构建速查（两条命令）

> 2026-09-26 起，UI 和单包**都是脚本化的**，不用再手敲。

## 一、编 UI（Compose，从 Kotlin 源码）

```sh
python3 pipeline/build_ui.py --out out/FDM-UI.apk --version-code 473 --version-name 3.7.0
```

八步（脚本里都有注释）：AAR 依赖 → aapt2 compile/link → R 类 → **kotlinc（Compose 插件）**
→ **R8** → 手工补 `poolingcontainer R$id` 单独 D8 注入 → 组包（含 `META-INF/services`）→ 签名。

## 二、组单包（模块 + 桥 + UI → 一个 APK）

```sh
cd mod-src && sh build.sh && cd ..
python3 pipeline/build_single.py \
    --ui out/FDM-UI-3.7.0-signed.apk \
    --base FuckDSManger_NL_2.22.120_for_ds2.5.2-signed.apk \
    --our-dex mod-src/build/dex/classes.dex \
    --app-class com.nidyaber.fuckdsmanger.bridge.FdmApp \
    --version-code 474 --version-name 3.7.0 \
    --out out/FDM-3.7.0-single.apk
```

## 三、出包前自检（脚本自动跑，任一不过就拒绝出包）

`build_ui.py`：`META-INF/services` 必须 2 个（丢了 UI 第一帧就崩）
`build_single.py`：

| # | 检查 | 由来 |
|---|---|---|
| ① | 底座与我们的 dex **同名类 = 0** | 同名类谁被加载看 dex 顺序 ⇒ 随机行为 |
| ② | 底座 dex **真的定义**了 `GmEntry` | 踩过：底座选错（2.22.110 的 gm 包是旧包名） |
| ③ | 我们的 dex 真的定义了入口 | — |
| ④ | 底座 dex 的**资源常量 = 0** | 这样才能安全复用 UI 的 resources.arsc |
| ⑤ | 条目搬运：源包除签名/清单/dex 外**一件不许少** | 踩过：一刀切 `META-INF/` 把协程主调度器丢了 |
| ⑥ | **dex 比 src/ 新** | 踩过：编译失败但用了旧 dex 照样出包 |
| ⑦ | 图标资源 id 存在（当前已停用） | 硬编码 id 的风险 |
| ⑧ | 每个元素的属性**按资源 id 升序** | 踩过三次：乱序 ⇒ 平台静默漏读属性 |
| ⑨ | 清单声明的组件类**必须在 dex 里** | 踩过：相对名 + 改包名 ⇒ `ClassNotFoundException` |
| ⑩ | **父类闭包完整**（非框架类的父类都得在 dex 并集里） | 踩过：kotlin-stdlib 没进 dex ⇒ 1102 个类缺父类 |

## 四、每步为什么这么写（踩过的坑，别再动）

| 位置 | 坑 | 正确做法 |
|---|---|---|
| **清单组件名** | 写相对名 `.MainActivity` —— `build_single.py` 会改 `package` ⇒ 相对名跟着变 ⇒ 指向不存在的类（`ClassNotFoundException`，一点图标就炸） | **一律写全限定名** |
| **Kotlin 运行时** | `kotlin-stdlib` / `kotlinx-coroutines-core` 是 **jar**，依赖闭包（只扫 aar）扫不到；R8 的 `-dontwarn **` 又不报错 ⇒ **1102 个类缺父类** ⇒ 表现为 `ClassNotFoundException: MainActivity`（其实是父类链断在 kotlin 那几个类上） | 显式把 `KOTLINC/lib/kotlin-stdlib.jar`、`kotlinx-coroutines-core-jvm.jar` **加进 dex 输入**（不是只加 classpath） |
| **只发 jar 的依赖** | `lifecycle-common-jvm` / `kotlinx-serialization-core-jvm` 同理 | 写进 `FORCE_JARS`，从 `libs_extra` / `work/m2` 里挑最高版本进 dex |
| **闭包里没列的 aar** | `navigationevent` / `lifecycle-livedata-core` / `window` 被引用但不在 pom 闭包 | 写进 `FORCE_AARS`（用**构件名**匹配，别用带版本的文件名） |
| AAR 收集 | 遍历全部 libs*/ 会把老的 `support-*` 塞进去 ⇒ 资源冲突 | 按 `libs_all/*.pom` 的**依赖闭包**取，并按**构件族**（去 `-android`）去重 |
| R 类 | 高版本 javac 给内部类加 `NestHost` ⇒ 单独 D8 失败 | 一律 `javac --release 8` |
| kotlinc 依赖 | 只发 jar 的依赖（`annotation-jvm` 等）不在 AAR 里 | `work/m2/**/*.jar` + `work/cp/*.jar` **只进 classpath，不进 dex** |
| R8 | 不给 `--min-api` ⇒ 按单 dex 处理 ⇒ 方法数超限失败 | `--min-api 26` |
| R8 | `--main-dex-rules` 与 min-api ≥ 21 冲突 | 别给（原生多 dex 不需要） |
| R8 | 输入不能是**目录** | 先 `jar cf` 打包 |
| 组包 | `AndroidManifest.xml` 被跳过 ⇒ 签名报 "Missing AndroidManifest.xml" | 单独加回来 |
| poolingcontainer | R8 会把 `R$id` 吃掉（`-keep` 也没用） | 手工 R 类 + **`--release 8` 重编** + 单独 D8 注入成一个 dex |
