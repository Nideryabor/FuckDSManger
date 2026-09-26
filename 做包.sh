#!/bin/sh
# ============================================================================
#  做包.sh —— 一条命令出「单包」🐲（尼得亚伯）
#
#  用法：  sh /workspace/做包.sh 3.9.2 482
#                    ↑版本名    ↑versionCode（可省，默认 482）
#
#  做三件事：
#    ① 真编译「桥」        mod-src/build.sh
#    ② 编 Compose UI       pipeline/build_ui.py
#    ③ 组单包              pipeline/build_single.py（含出包前自检 ①~⑩）
#
#  产物：/workspace/FDM-<版本>-single-signed.apk
#  日志：/workspace/out/做包-<版本>.log
#
#  ★ 失败会明确报错（不会假装成功）——失败时把日志最后 40 行贴给我就行。
# ============================================================================
V="${1:-3.9.2}"
VC="${2:-482}"
ROOT=/workspace
# 底座 APK：自动找（可能在 /workspace 下，也可能在 mod-src/out 里）
BASE=""
# ★ 2.22.121：底座去掉「依赖宿主包名」三处；2.22.122：底座加 pin 表（读侧替换）
#   见 `专题/铁律-不依赖宿主包名.md`
for c in "$ROOT/FuckDSManger_NL_2.22.122_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.122_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.121_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.121_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.120_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.120_for_ds2.5.2-signed.apk"; do
  [ -f "$c" ] && BASE="$c" && break
done
[ -z "$BASE" ] && { echo "✗ 找不到底座 APK（2.22.120-signed）"; exit 1; }
echo "底座：$BASE"
LOG="$ROOT/out/做包-$V.log"
mkdir -p "$ROOT/out"

run_all() {
  echo "═══ ① 真编译桥 ═══"
  cd "$ROOT/mod-src" && sh build.sh
  echo
  echo "═══ ② 编 Compose UI ═══"
  cd "$ROOT" && python3 pipeline/build_ui.py \
      --out "out/FDM-UI-$V.apk" --version-code "$VC" --version-name "$V"
  echo
  echo "═══ ③ 组单包 ═══"
  cd "$ROOT" && python3 pipeline/build_single.py \
      --ui "out/FDM-UI-$V-signed.apk" \
      --base "$BASE" \
      --our-dex mod-src/build/dex/classes.dex \
      --app-class com.nidyaber.fuckdsmanger.bridge.FdmApp \
      --version-code "$VC" --version-name "$V" \
      --out "out/FDM-$V-single.apk"
  cp -f "out/FDM-$V-single-signed.apk" "$ROOT/FDM-$V-single-signed.apk"
}

set +e
run_all > "$LOG" 2>&1
RC=$?
set -e

tail -45 "$LOG"
echo
if [ "$RC" -ne 0 ]; then
  echo "✗✗✗ 构建失败（退出码 $RC）—— 上面就是原因，完整日志：$LOG"
  exit "$RC"
fi
echo "✅ 好了：$ROOT/FDM-$V-single-signed.apk"
sha256sum "$ROOT/FDM-$V-single-signed.apk"
echo "   完整日志：$LOG"
