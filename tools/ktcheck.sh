#!/bin/sh
# ============================================================================
#  ktcheck.sh —— 只跑 kotlinc（秒级迭代用）🐲
#
#  为什么：build_ui.py 全量要走 aapt2 + R8（两三分种），而"搬家"这类批量改写
#  会反复报编译错 ⇒ 需要一个"只编 Kotlin"的快通道。
#  classpath 取 **全集**（libs*/**.jar + work 里上次的 b_*.jar + android.jar +
#  kotlin 运行时）——比 build_ui.py 略宽，只用来判"能不能编过"。
#
#  用法：  sh tools/ktcheck.sh            # 编 src/*.kt
#          sh tools/ktcheck.sh Screens.kt # 只编一个（少报点无关错）
# ============================================================================
set -u
ROOT=/workspace
FD="$ROOT/fdm-app"
KOTLINC="$ROOT/tools/jvm/kotlinc"
KC="$KOTLINC/lib/kotlin-compiler.jar"
PLUGIN="$KOTLINC/lib/compose-compiler-plugin.jar"
AJ="$ROOT/tools/jvm/lib/android.jar"

# ★ 顺序要紧：`b_rcls.jar`（aapt2 刚生成的新 R）必须在**最前**。
#   work/ 里还躺着几个旧时代的 R jar（rcls_app.jar 等），先被解析到就会"新键找不到"✗
CP="$FD/work/b_rcls.jar:$FD/work/b_bridge.jar:"
CP="$CP$(find "$FD/work/b_cls" -maxdepth 1 -name '*.jar' 2>/dev/null | tr '\n' ':')"
CP="$CP$(find "$FD/libs" "$FD/libs_all" "$FD/libs_extra" "$FD/libs_new" "$FD/libs_legacy" \
        -name '*.jar' 2>/dev/null | tr '\n' ':')"
CP="$CP$AJ:$KOTLINC/lib/kotlin-stdlib.jar:$KOTLINC/lib/kotlinx-coroutines-core-jvm.jar"

if [ $# -gt 0 ]; then SRC=""; for f in "$@"; do SRC="$SRC $FD/src/$f"; done
else SRC="$FD/src/*.kt"; fi

OUT=$(mktemp -d)
java -Xmx3g -cp "$KC" org.jetbrains.kotlin.cli.jvm.K2JVMCompiler \
     -jvm-target 17 -nowarn -Xplugin="$PLUGIN" \
     -classpath "$CP" -d "$OUT" $SRC 2>&1 | grep -E "error:" | sed "s|$FD/src/||"
rm -rf "$OUT"
