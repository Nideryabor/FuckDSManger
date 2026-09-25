#!/bin/sh
# 尼得亚伯的 JVM 工具链 · 公共环境
# 全部走能在国内通的源（apt ports / 阿里云谷歌镜像 / GitHub），不碰 dl.google.com。

JVM_HOME=${JVM_HOME:-/workspace/tools/jvm}
JVM_LIB="$JVM_HOME/lib"
JVM_BIN="$JVM_HOME/bin"

# —— JDK（apt: openjdk-17-jdk-headless）——
JAVA=${JAVA:-java}
JAVAC=${JAVAC:-javac}

# —— d8 / r8：阿里云镜像下的 com.android.tools:r8 ——
R8_JAR="$JVM_LIB/r8.jar"
D8_MAIN="com.android.tools.r8.D8"
R8_MAIN="com.android.tools.r8.R8"

# —— smali / baksmali（apt: libsmali-java 2.5.2，主类 org.jf.*）——
# 注意: smali.jar 与 baksmali.jar 是两个独立 jar，主类分别在各自里面 ⇒ 一个 CP 全挂上
SYS_JAVA=/usr/share/java
SMALI_CP="$SYS_JAVA/smali.jar:$SYS_JAVA/baksmali.jar:$SYS_JAVA/dexlib2.jar:$SYS_JAVA/smali-util.jar:$SYS_JAVA/jcommander.jar:$SYS_JAVA/guava.jar"
SMALI_CLI_MAIN="org.jf.smali.Main"
BAKSMALI_CLI_MAIN="org.jf.baksmali.Main"

# —— 编译期依赖桩 ——
ANDROID_JAR=${ANDROID_JAR:-$JVM_LIB/android.jar}
XPOSED_JAR="$JVM_LIB/xposed-api-82.jar"

# —— dex2jar ——
DEX2JAR_HOME="$JVM_HOME/dex-tools"
DEX2JAR_CP="$DEX2JAR_HOME/lib/*"

# —— 默认编译参数 ——
JAVA_RELEASE=${JAVA_RELEASE:-8}     # Android 上最稳
D8_MIN_API=${D8_MIN_API:-21}

die() { printf '\033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }
info() { printf '\033[36m· %s\033[0m\n' "$*" >&2; }
ok()  { printf '\033[32m✓ %s\033[0m\n' "$*" >&2; }

# 缺件自检
check_tools() {
  [ -f "$R8_JAR" ]      || die "缺 $R8_JAR（见 README 的「安装」一节）"
  [ -f "$ANDROID_JAR" ] || die "缺 $ANDROID_JAR"
  [ -f "$SYS_JAVA/smali.jar" ] || die "缺 libsmali-java，先 apt-get install libsmali-java"
}
