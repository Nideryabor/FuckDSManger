# 🐉 Java / Kotlin / Android 工具链（尼得亚伯装的）

> **结论先说：不需要 MCP。** 工作区里本来就能跑 shell，一条命令的事。
> MCP 只在「要跟宿主上的 MT 管理器说话」时才必要 —— 而那个已经有 `mt_apk_*` 了。

这套东西解决的是本项目最大的一个痛点：

> `README.md` / `大纲.md` 里写着 **「纯手写 Smali（无 java / python 工具链）」**。
> 手写 smali 的翻车率有多高，`版本/索引.md` 里 800+ 条教训已经写满了。
> 现在可以**写 Java / Kotlin，编译，拿现成的 smali**，只把方法体搬进目标类。

---

## 一、装了什么

| 组件 | 版本 | 从哪来 | 干什么 |
|---|---|---|---|
| **OpenJDK** | 17.0.20.1 (arm64) | `apt` ports（Ubuntu 24.04） | `javac` / 跑一切 jar |
| **smali / baksmali** | 2.5.2 | `apt` → `libsmali-java` | dex ⇄ smali |
| **d8 (r8)** | **9.4.24** | 阿里云谷歌镜像 | `.class` → `.dex` |
| **kotlinc** | **2.4.20** | GitHub Releases (JetBrains/kotlin) | `.kt` → `.class` |
| **android.jar** | API 34 桩 | `Sable/android-platforms` (GitHub) | 编译期认 `android.*` |
| **Xposed API** | 82 | 阿里云 jcenter 镜像 | 编译期认 `de.robv.android.xposed.*` |
| **dex2jar** | v2.4 | GitHub Releases | `.dex`/`.apk` → `.jar`（拿宿主 .class 桩） |

**谷歌域名一个都没碰**（`dl.google.com` / `maven.google.com` 全不通）。
走的替代源：`ports.ubuntu.com` · `maven.aliyun.com` · `mirrors.cloud.tencent.com` · `github.com` / `raw.githubusercontent.com`。

---

## 二、目录

```
tools/jvm/
├── README.md          ← 你正在看的
├── bin/
│   ├── _env.sh        ← 公共环境（路径 / 默认参数 / 缺件自检）
│   ├── j2s            ← ★ Java 源码 → smali（javac → d8 → baksmali）
│   ├── k2s            ← ★ Kotlin 源码 → smali（kotlinc → d8 → baksmali）
│   ├── d8             ← .class/.jar → .dex
│   ├── smali          ← .smali 目录 → .dex（手写 smali 自检用）
│   ├── baksmali       ← .dex/.apk → .smali
│   └── dex2jar        ← .dex/.apk → .jar
├── lib/               ← 大件（已 gitignore）
│   ├── r8.jar             20 MB  (9.4.24，默认)
│   ├── r8-8.13.24.jar     18 MB  (备用：认的 metadata 老一档)
│   ├── android.jar        26 MB  (API 34)
│   ├── xposed-api-82.jar  25 KB
│   └── kotlin-stdlib-1.9.24.jar
├── kotlinc/           ← Kotlin 编译器 2.4.20（已 gitignore，~120 MB）
├── dex-tools/         ← dex2jar v2.4（已 gitignore，20 MB）
└── work/              ← 临时目录（已 gitignore）
```

加进 PATH：

```sh
export PATH=/workspace/tools/jvm/bin:$PATH
```

---

## 三、安装（可重放，沙箱重建后照着跑）

```sh
export DEBIAN_FRONTEND=noninteractive
apt-get install -y --no-install-recommends openjdk-17-jdk-headless libsmali-java

mkdir -p /workspace/tools/jvm/lib && cd /workspace/tools/jvm/lib

# d8（r8）—— 阿里云镜像的 com.android.tools:r8
curl -L -o r8.jar \
  https://maven.aliyun.com/repository/google/com/android/tools/r8/9.4.24/r8-9.4.24.jar

# android.jar 编译桩
curl -L -o android.jar \
  https://raw.githubusercontent.com/Sable/android-platforms/master/android-34/android.jar

# Xposed API
curl -L -o xposed-api-82.jar \
  https://maven.aliyun.com/repository/public/de/robv/android/xposed/api/82/api-82.jar

# kotlin-stdlib（备用，压版本用）
curl -L -o kotlin-stdlib-1.9.24.jar \
  https://repo1.maven.org/maven2/org/jetbrains/kotlin/kotlin-stdlib/1.9.24/kotlin-stdlib-1.9.24.jar

# dex2jar
curl -L -o /tmp/dex-tools.zip \
  https://github.com/pxb1988/dex2jar/releases/download/v2.4/dex-tools-v2.4.zip
cd /workspace/tools/jvm && unzip -q /tmp/dex-tools.zip && mv dex-tools-v2.4 dex-tools

# kotlinc
curl -L -o /tmp/kotlinc.zip \
  https://github.com/JetBrains/kotlin/releases/download/v2.4.20/kotlin-compiler-2.4.20.zip
cd /workspace/tools/jvm && mkdir -p kotlinc && unzip -q /tmp/kotlinc.zip -d kotlinc \
  && mv kotlinc/kotlinc/* kotlinc/ && rmdir kotlinc/kotlinc
```

---

## 四、怎么用

### 1. Java → smali

```sh
j2s Foo.java                      # → ./smali-out/Foo.smali
j2s -o out/ src/                  # 整个目录
j2s -cp host.jar Foo.java         # 对着宿主的类写
j2s -k Foo.java                   # 留着 classes/ 和 dex/
```

选项：`-o` 输出目录 · `-cp` 额外 classpath · `-lib` 换 android.jar ·
`-api` min-api（默认 21）· `-r` javac release（默认 8）· `--no-android` · `--no-xposed`

### 2. Kotlin → smali

```sh
k2s Foo.kt                        # → ./smali-out/com/xx/Foo.smali
k2s -stdlib lib/kotlin-stdlib-1.9.24.jar Foo.kt    # 压 stdlib 版本
k2s --no-param-assertions Foo.kt  # 去掉 Intrinsics.checkNotNullParameter
```

选项：`-o` · `-cp` · `-lib` · `-stdlib` · `-jvm`（默认 1.8）· `-api` · `-k` · `--no-param-assertions`

> **宿主是 Kotlin 写的，所以 `k2s` 往往比 `j2s` 更贴**：
> 产物形态（`Intrinsics`、`$default`、`@Metadata`、lambda 合成类）跟目标类同一个模子。

### 3. 拿宿主的 .class 桩，对着它写代码

```sh
dex2jar /path/host.apk -o host.jar
j2s -cp host.jar MyHook.java
k2s -cp host.jar MyHook.kt        # javac/kotlinc 会替我盯住类型，不用猜
```

### 4. 手写 smali 的自检

```sh
smali assemble /workspace/smali-out -o /tmp/check.dex   # 能过 = 语法/结构没崩
baksmali disassemble /tmp/check.dex -o /tmp/back        # 回头看一眼
```

> ⚠️ `smali` 只做**结构校验**，**不跑字节码验证器（verifier）**。
> 寄存器数错、类型不对，照样能汇编过，装到真机上才 `VerifyError`。
> 真验证还得靠 `tools/vercheck.pl` + 真机日志。

---

## 五、已验证（2026-09-25）

### Java 闭环

样例 `work/test-src/DemoHook.java`（同时用 `android.*` 和 Xposed API）：

| 步骤 | 命令 | 结果 |
|---|---|---|
| Java → smali | `j2s test-src/DemoHook.java` | ✅ 2 个 .class → 2 个 .smali |
| smali → dex | `smali assemble /tmp/smali-out -o /tmp/rt.dex` | ✅ 2448 B |
| dex → jar | `dex2jar /tmp/rt.dex -o /tmp/rt.jar` | ✅ 2 个 class 还原 |

### Kotlin 闭环

拿**之前手写 smali 时参考过的** `kotlin2smali/demo.kt` 当输入（`data class` + 顶层函数 + 默认参数）：

| 项 | 编译器吐的 | 我之前手搓的 |
|---|---|---|
| `User.smali` | 246 行 | 205 行 |
| `DemoKt.smali` | 90 行 | 74 行 |
| 方法签名比对 | — | **11 / 11 完全一致** ✅ |

**`User` 的方法表（编译器 vs 手搓，逐行相同）**：

```
public constructor <init>(Ljava/lang/String;I)V
public equals(Ljava/lang/Object;)Z
public final component1()Ljava/lang/String;
public final component2()I
public final copy(Ljava/lang/String;I)Lcom/example/User;
public final getAge()I
public final getName()Ljava/lang/String;
public final setAge(I)V
public hashCode()I
public static synthetic copy$default(Lcom/example/User;Ljava/lang/String;IILjava/lang/Object;)Lcom/example/User;
public toString()Ljava/lang/String;
```

**唯一的偏差**（手搓版有、编译器没有）：我给 `UserKt` 多写了一个
`public constructor <init>()V` —— 编译器出的顶层函数类是 `final` 且**没有**那个构造器。

**行数差在哪**：`@Metadata` 注解块（`d1`/`d2`/`k`/`mv` 那一大坨）
+ `.line` 调试指令 + 更啰嗦的寄存器分配。**`@Metadata` 正好是我笔记里写着
「手写基本没法精确还原」的那一块** —— 现在不用还了。

---

## 六、踩过的坑（写给自己）

1. **`smali.jar` 和 `baksmali.jar` 是两个 jar**，主类分别在各自里面
   （`org.jf.smali.Main` / `org.jf.baksmali.Main`，2.5.2 的包名是 `org.jf.*`
   不是 `com.android.tools.smali.*`）。一个 CP 全挂上最省事。
2. **d8 的 `--classpath` 只吃单个路径**，`a.jar:b.jar` 会被当成一个文件名 ⇒
   报 `NoSuchFileException: .../android.jar:.../xposed-api-82.jar`。要**重复传**。
3. **d8 不挂 `--lib android.jar` 会警告**「Type xxx was not found … desugaring」；
   Xposed / kotlin-stdlib 挂 `--classpath` 就没有警告。
4. **r8 8.13.24 认不了 Kotlin 2.4 的 metadata**：
   `Provided Metadata instance has version 2.4.0, while maximum supported version is 2.3.0`
   ⇒ 报 `malformed kotlin.Metadata` + 一大坨 stack trace（**dex 照样出**，但吓人）。
   **换 r8 9.4.24 就干净了**，所以现在默认是 9.4.24，8.13.24 留作备用。
5. `--release 8` 能读 android.jar（major 52）和 Xposed API（major 51）。
6. **国内别碰 `dl.google.com`** —— 直接超时。r8 走 `maven.aliyun.com/repository/google/`。
7. **kotlinc 吃内存**：沙箱 11 GB 总量，默认给 `-Xmx1500m`（`JAVA_OPTS` 可覆盖）。
   一次编译约 5 秒，不算慢。
