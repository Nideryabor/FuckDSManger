#!/bin/sh
# ============================================================
#  build.sh —— 模块「真编译」脚本（尼得亚伯 🐲）
# ============================================================
#  stub/*.java（模块内 API 的签名桩，不进 dex）
#      ↓ javac
#  src/*.java（我们真正要编的代码）
#      ↓ javac --release 8   ← 对着 android.jar + Xposed API + 桩
#  build/classes/*.class
#      ↓ d8 --min-api 26
#  build/dex/classes.dex        ← 交给打包脚本
#      ↓ baksmali
#  out/smali/**                 ← 给人看的 / 给 MT 注入用的
#
#  用法:  ./build.sh
# ============================================================
set -e
cd "$(dirname "$0")"

JLIB=/workspace/tools/jvm/lib
ANDROID="$JLIB/android.jar"
XPOSED="$JLIB/xposed-api-82.jar"
SMALI_CP="/usr/share/java/smali.jar:/usr/share/java/baksmali.jar:/usr/share/java/dexlib2.jar:/usr/share/java/smali-util.jar:/usr/share/java/jcommander.jar:/usr/share/java/guava.jar"
MODSRC=$(pwd)
STUB="$MODSRC/build/stub"

say() { printf '\033[36m· %s\033[0m\n' "$*"; }
ok()  { printf '\033[32m✓ %s\033[0m\n' "$*"; }

[ -f "$ANDROID" ] || { echo "缺 $ANDROID"; exit 1; }
[ -f "$XPOSED" ]  || { echo "缺 $XPOSED";  exit 1; }

# ---------- ① 桩（只做编译期 classpath，绝不进 dex）----------
say "① 编译桩"
rm -rf "$STUB" && mkdir -p "$STUB"
javac --release 8 -nowarn -encoding UTF-8 \
      -classpath "$ANDROID:$XPOSED" \
      -d "$STUB" $(find stub -name '*.java')
ok "桩 → $(find "$STUB" -name '*.class' | wc -l) 个 .class"

# ---------- ② 真编译 ----------
say "② 真编译（javac --release 8）"
rm -rf build/classes && mkdir -p build/classes
javac --release 8 -encoding UTF-8 -Xlint:-options \
      -classpath "$ANDROID:$XPOSED:$STUB" \
      -d build/classes $(find src -name '*.java')
ok "javac → $(find build/classes -name '*.class' | wc -l) 个 .class"

# ---------- ③ d8 → dex ----------
say "③ d8 --min-api 26"
rm -rf build/dex && mkdir -p build/dex
java -cp "$JLIB/r8.jar" com.android.tools.r8.D8 \
     --release --min-api 26 \
     --lib "$ANDROID" \
     --classpath "$ANDROID" --classpath "$XPOSED" --classpath "$STUB" \
     --output build/dex \
     $(find build/classes -name '*.class')
[ -f build/dex/classes.dex ] || { echo "d8 没出 dex"; exit 1; }
ok "dex → $(wc -c < build/dex/classes.dex) B"

# ---------- ④ baksmali（给人看 / 给注入用）----------
say "④ baksmali"
rm -rf out/smali && mkdir -p out/smali
java -cp "$SMALI_CP" org.jf.baksmali.Main disassemble build/dex/classes.dex -o out/smali
ok "smali:"
find out/smali -name '*.smali' | sed 's|^|    |'
