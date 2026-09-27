# FuckDSManger UI（Compose · M3 Expressive）

规范来源：主人给的提示词（412×892dp 竖屏、Blue 浅色配色、M3 Expressive、Android 原生）。

## 怎么构建（沙箱里全套工具链，**不用 Android Studio / 不用 aapt2**）

```sh
cd /workspace/fdm-app

# ① 拉依赖（按 compose-bom 2026.09.00 对齐；x86_64 的 aapt2 在这台 arm64 上不存在，所以用 aapt v1）
python3 fetch3.py

# ② 抽 classpath（AAR → classes.jar）
#    （见 work/cp.txt / work/cp_ok.txt 的生成脚本）

# ③ 编译：kotlinc 2.4 + 自带的 Compose 编译器插件
/workspace/tools/jvm/kotlinc/bin/kotlinc -cp "$(cat work/cp.txt)" \
  -Xplugin=/workspace/tools/jvm/kotlinc/lib/compose-compiler-plugin.jar \
  -jvm-target 11 src/*.kt -d work/classes

# ④ dex：D8（安全，53MB dex）或 R8（裁剪，1.4MB dex）
java -cp /workspace/tools/jvm/lib/r8.jar com.android.tools.r8.R8 --release --min-api 26 \
  --lib /workspace/tools/jvm/lib/android.jar --output work/dex-r8 \
  --pg-conf work/rules.pro <依赖 jar...> work/classes.jar

# ⑤ 资源 + 清单
aapt package -f -M AndroidManifest.xml -S res -I /workspace/tools/jvm/lib/android.jar -F work/base3.apk -J work/rjava

# ⑥ 封包（自写 zip：resources.arsc 必须 STORED）+ 签名（我们自己的私钥）
apksigner sign --key /workspace/mod-src/pack/keys/fuckdsmanger.pk8 \
               --cert /workspace/mod-src/pack/keys/fuckdsmanger.x509.pem \
               --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true \
               --min-sdk-version 26 --out 输出.apk 输入.apk
```

## 源码结构

| 文件 | 内容 |
|---|---|
| `src/Color.kt` | 规范里那套 Blue 浅色配色的全部角色（primary / surfaceContainer… ） |
| `src/Theme.kt` | `FdmTheme` = M3 Expressive 主题 |
| `src/Components.kt` | 顶部应用栏 / 列表项 / 分组圆角 / 分割线 / 开关行 / 容器框 / 图片占位 / 导航栏 |
| `src/Screens.kt` | 主页 · 关于 · 灰度工具箱 · 单独功能页示例 |
| `src/App.kt` | 导航 + 过渡（右侧滑入 / 淡入 / 反向回放）+ 右滑跟随手指 |
| `src/Prefs.kt` | 「选项」开关的持久化（SharedPreferences） |
| `src/MainActivity.kt` | 入口（edge-to-edge） |

## 两处需要知道的"手艺"

1. **Expressive API 是 internal 的**：material3 1.4.0 把 `MaterialExpressiveTheme` / `MotionScheme`
   在 Kotlin 元数据里标成 internal（字节码其实是 public）。用
   `@Suppress("INVISIBLE_MEMBER","INVISIBLE_REFERENCE")` + **全限定名（不能 import）** 访问。
2. **aapt2 在 arm64 上没有**：Google 只发 x86_64 版。所以资源走 `aapt` v1，
   manifest 也是它编的（`AndroidManifest.xml` → AXML）。

## 未验项 ⚠️

**没有真机/模拟器验证**（沙箱里跑不了 Android）。两版都给：
- `FuckDSManger_UI_1.0-debugsafe.apk`（D8，什么都不裁，14.7MB）← 先装这个，最保险
- `FuckDSManger_UI_1.0-release.apk`（R8 裁剪，0.53MB）← 体积正常，但裁剪规则没经过真机检验
