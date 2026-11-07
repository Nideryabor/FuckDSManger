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
DEV="${3:-}"          # 传 dev 才允许带调试功能出包（自拍/细日志）
ROOT=/workspace

# ============================================================================
#  ④.5 出包前自检 · 调试总闸
#  主人 2026-09-30：「出正式包记得把自拍删掉」。
#  靠记性不可靠 ⇒ 这里做机械闸门：GmDebug.ENABLED = true 时**拒绝出正式包**。
# ============================================================================
GmDebugFile="$ROOT/mod-src/src/com/nidyaber/fuckdsmanger/glass/GmDebug.java"
if [ -f "$GmDebugFile" ] && grep -qE 'ENABLED[[:space:]]*=[[:space:]]*true' "$GmDebugFile"; then
  if [ "$DEV" != "dev" ]; then
    echo "✗ 调试总闸还开着（GmDebug.ENABLED = true）—— 正式包不许出。"
    echo "    · 只是自己调： sh 做包.sh $V $VC dev"
    echo "    · 要发版：     先把 GmDebug.java 里 ENABLED 改成 false，再原样跑"
    exit 1
  fi
  echo "⚠️  调试包（GmDebug.ENABLED = true）：自拍 + 细日志都在里面，**别当正式包发**。"
  echo
fi
# 底座 APK：自动找（可能在 /workspace 下，也可能在 mod-src/out 里）
BASE=""
# ★ 2.22.121：去掉「依赖宿主包名」三处 · 2.22.122：pin 表 · 2.22.123：B1' 修落点（contains + j）
#   见 `专题/铁律-不依赖宿主包名.md`
for c in "$ROOT/mod-src/out/FuckDSManger_NL_2.22.133_for_ds2.6.1.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.132_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.132_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.131_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.131_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.130_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.130_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.128_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.128_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.124_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.124_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.123_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.123_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.122_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.122_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.121_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.121_for_ds2.5.2-signed.apk" \
         "$ROOT/FuckDSManger_NL_2.22.120_for_ds2.5.2-signed.apk" \
         "$ROOT/mod-src/out/FuckDSManger_NL_2.22.120_for_ds2.5.2-signed.apk"; do
  [ -f "$c" ] && BASE="$c" && break
done
[ -z "$BASE" ] && { echo "✗ 找不到底座 APK（2.22.120-signed）"; exit 1; }
echo "底座：$BASE"

# ============================================================================
#  ⓪ 底座/树 同步检查（2026-10-03 加）
#  血案：树里的修复没回灌底座 ⇒ 「AI 气泡缩放完全不会缩放」（FitHook 落后 125 行）。
#  靠记性会再犯 ⇒ 机械闸门：不同步就拒绝出包（确要强出： ALLOW_STALE_BASE=1）。
# ============================================================================
echo "═══ ⓪ 底座/树 同步检查 ═══"
if ! python3 "$ROOT/tools/check_base_sync.py" --smali "$ROOT/tmp/base130_261/sm" --base "$BASE" --max-list 12; then
  if [ "${ALLOW_STALE_BASE:-0}" != "1" ]; then
    echo "✗ 底座落后于 smali 树 —— 先回灌底座，再重跑本脚本。"
    exit 1
  fi
  echo "⚠️ 底座/树不同步，但 ALLOW_STALE_BASE=1 ⇒ 继续出包（后果自负）。"
fi
echo
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
