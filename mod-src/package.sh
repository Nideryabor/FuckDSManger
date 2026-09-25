#!/bin/sh
# ============================================================
#  package.sh —— 一键：真编译 + 自造 APK + 签名
# ============================================================
#  用法:  ./package.sh <基础APK> [versionCode] [versionName]
#  例:    ./package.sh /workspace/mod-src/base/FuckDSManger_NL_2.22.110_for_ds2.5.2.apk 442 2.22.111
#
#  产出:  out/FuckDSManger_NL_<版本>_for_ds2.5.2.apk （已签名，可直接装）
# ============================================================
set -e
cd "$(dirname "$0")"

BASE="$1"
VC="${2:-442}"
VN="${3:-2.22.111}"
ENTRY="com.nidyaber.fuckdsmanger.GmEntry"

[ -n "$BASE" ] || { echo "用法: ./package.sh <基础APK> [versionCode] [versionName]"; exit 1; }
[ -f "$BASE" ] || { echo "找不到基础包: $BASE"; exit 1; }

echo "═══ ① 真编译 ═══"
sh build.sh

echo
echo "═══ ② 自造 APK ═══"
mkdir -p out
python3 pack/build_apk.py \
    --base "$BASE" \
    --entry-dex build/dex/classes.dex \
    --entry-class "$ENTRY" \
    --version-code "$VC" --version-name "$VN" \
    --out "out/FuckDSManger_NL_${VN}_for_ds2.5.2.apk"

echo
echo "═══ ③ 结果 ═══"
ls -la out/*.apk
echo
echo "装之前建议先看一遍："
echo "  apksigner verify --print-certs -v out/FuckDSManger_NL_${VN}_for_ds2.5.2-apk"
