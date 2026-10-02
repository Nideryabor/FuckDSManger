#!/system/bin/sh
# ============================================================================
#  frida-device.sh —— 【手机端】一条龙 v4（真 su 直跑，不用 adb、不用拷文件）
#
#  一条命令（用你的**真 su**跑）：
#      su -c 'sh /data/data/me.rerere.rikkahub/files/workspaces/*/files/tools/frida/frida-device.sh all'
#
#  装 + 起 + 自检，就这些。**不碰权限、不动 SELinux、不改系统设置。**
#
#  为什么用真 su 就行：
#      frida 的 Java 桥要往 /data/local/tmp 写 helper dex（路径写死，TMPDIR 改不动）。
#      经 adb 的 su 进不去那个目录，**真 su 可以** —— 所以这一步由你来。
#
#  二进制不用拷：脚本从**自己旁边**找（工作区就在手机上）。
#
#  ⚠️ 别做的事（都试过，没用）：
#      setenforce 0            —— 实测无效
#      chmod /data/local/tmp   —— 经 adb 的 su 会被拒（真 su 不需要这步）
# ============================================================================
set -u

SELF_DIR=$(cd "$(dirname "$0")" && pwd)
DEST="/data/adb/frida-server"
TMPD="/data/adb/frida-tmp"
LOCAL_TMP="/data/local/tmp"
PORT="27042"
LOG="$TMPD/fs.log"

say() { echo "[frida] $*"; }

need_root() {
  [ "$(id -u)" = "0" ] || {
    echo "请用真 su 跑："
    echo "  su -c 'sh $0 all'"
    exit 1
  }
}

find_bin() {
  [ -n "${1:-}" ] && [ -f "$1" ] && { echo "$1"; return; }
  # ★ 2026-10-01：**17.19.0 的 agent 在这台机器上 dlopen 就崩**，必须用 16.7.19。
  #   详见 专题/2026-10-01-frida-agent-崩溃-完整尸检.md
  for c in "$SELF_DIR/frida-server-16.7.19-arm64" \
           "$SELF_DIR/frida-server-17.16.0-arm64" \
           "$SELF_DIR"/frida-server-*-arm64 \
           /sdcard/Download/frida-server \
           "$DEST" ; do
    for f in $c; do [ -f "$f" ] && { echo "$f"; return; }; done   # glob 故意不加引号
  done
  echo ""
}

do_install() {
  need_root
  mkdir -p /data/adb
  SRC=$(find_bin "${1:-}")
  if [ -z "$SRC" ]; then
    echo "✗ 找不到 frida-server 二进制。找过："
    echo "    $SELF_DIR/frida-server-17.19.0-arm64"
    echo "    /sdcard/Download/frida-server"
    echo "    $DEST"
    exit 1
  fi
  if [ "$SRC" != "$DEST" ]; then
    say "装：$(basename "$SRC") → $DEST"
    cp -f "$SRC" "$DEST" || { echo "复制失败"; exit 1; }
  else
    say "装：二进制已在 $DEST"
  fi
  chmod 755 "$DEST"
  mkdir -p "$TMPD"
  say "就位 ✓（$DEST）"
}

do_stop() {
  pkill -f frida-server >/dev/null 2>&1
  sleep 1
  say "已停"
}

do_start() {
  need_root
  [ -x "$DEST" ] || { echo "✗ $DEST 不可执行，先跑 install"; exit 1; }
  mkdir -p "$TMPD"
  do_stop

  # 自检：frida 必须往这里写 helper dex
  if touch "$LOCAL_TMP/.w" 2>/dev/null; then
    rm -f "$LOCAL_TMP/.w"
    say "自检：$LOCAL_TMP 可写 ✓"
  else
    say "自检：$LOCAL_TMP 写不进 ✗ —— attach 会失败"
    echo "      （说明这次不是真 su 跑的，或者 KernelSU 给了受限配置）"
    exit 1
  fi

  say "起服务（监听 127.0.0.1:$PORT）"
  TMPDIR="$TMPD" nohup "$DEST" -d /data/adb -l "127.0.0.1:$PORT" > "$LOG" 2>&1 &
  sleep 3
  if pgrep -f frida-server >/dev/null 2>&1; then
    say "✓ 起来了 pid=$(pgrep -f frida-server | head -1)"
    echo
    echo "→ 现在跟我说一声，我跑 attach 测试。"
  else
    echo "✗ 没起来。日志："; tail -30 "$LOG" 2>/dev/null
    exit 1
  fi
}

do_status() {
  if pgrep -f frida-server >/dev/null 2>&1; then
    say "在跑 pid=$(pgrep -f frida-server | head -1)"
  else
    say "没在跑"
  fi
  if touch "$LOCAL_TMP/.w" 2>/dev/null; then rm -f "$LOCAL_TMP/.w"; echo "  $LOCAL_TMP 可写 ✓"; else echo "  $LOCAL_TMP 写不进 ✗"; fi
  ls -l "$DEST" 2>/dev/null || echo "  二进制没有"
  echo "--- 日志尾 ---"; tail -8 "$LOG" 2>/dev/null || echo "  （空）"
}

case "${1:-all}" in
  install) do_install "${2:-}" ;;
  start)   do_start ;;
  stop)    do_stop ;;
  status)  do_status ;;
  all)     do_install "${2:-}"; do_start; echo; do_status ;;
  *) cat <<'USAGE'
frida-device.sh —— 手机端一条龙（用真 su 跑）

  sh frida-device.sh all      # 装 + 起 + 自检（默认）
  sh frida-device.sh install [二进制路径]
  sh frida-device.sh start
  sh frida-device.sh stop
  sh frida-device.sh status
USAGE
  ;;
esac
