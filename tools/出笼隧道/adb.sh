#!/bin/sh
# ============================================================================
#  adb.sh —— 尼得亚伯的出笼隧道 🐲
#
#  用法（跟真 adb 一模一样，前面加个 sh 就行）：
#      sh /workspace/tools/出笼隧道/adb.sh shell id
#      sh /workspace/tools/出笼隧道/adb.sh shell logcat -d -t 50
#      sh /workspace/tools/出笼隧道/adb.sh install -r /workspace/FDM-<版本>-single-signed.apk
#      sh /workspace/tools/出笼隧道/adb.sh shell am force-stop com.deepseek.chat.a
#
#  自动做的事：
#    ① 起 server（容器每次调用都会回收后台进程，所以每次都得重连）
#    ② 拿缓存端口连；连不上就全段扫，扫到能用的就记住
#    ③ 然后原样把参数丢给 adb
#
#  详见：专题/出笼隧道-adb.md
# ============================================================================
export HOME=/root

# ═══════════════════════════════════════════════════════════════════════════
#  ★★ 2026-11-07 · 关掉 mDNS 自动连接（主人报「老是弹连接无线调试」的真凶）★★
#
#  证据：`strings adb` 里写着
#    "$ADB_MDNS_AUTO_CONNECT  comma-separated list of mdns services
#     to allow auto-connect (default adb-tls-connect)"
#  ⇒ adb **默认**会扫 mDNS、发现手机广播的 `_adb-tls-connect._tcp` 就**自动去连**，
#    手机那边就弹「允许无线调试吗」。
#
#  为什么在这台机器上会变成「反复弹」：
#    容器**每次工具调用都会回收后台进程** ⇒ adb server 每轮都得重启
#    ⇒ 每重启一次就重扫一次 mDNS、自动连一次 ⇒ 弹一次。
#
#  我们的路只有一条：`adb connect 127.0.0.1:<无线调试端口>`（见下面的端口探测）。
#  根本不需要 mDNS 发现 ⇒ 设为空 = 一个服务都不许自动连。
# ═══════════════════════════════════════════════════════════════════════════
export ADB_MDNS_AUTO_CONNECT=

HERE=$(dirname "$0")
CACHE="$HERE/.adbport"
SCAN="$HERE/扫adb端口.py"
KNOWN="34597"
PORT=""

adb start-server >/dev/null 2>&1

alive() {
  adb devices 2>/dev/null | grep -qE "^127\.0\.0\.1:[0-9]+[[:space:]]+device"
}

try() {
  [ -z "$1" ] && return 1
  adb connect "127.0.0.1:$1" >/dev/null 2>&1
  if alive; then echo "$1" > "$CACHE"; return 0; fi
  adb disconnect "127.0.0.1:$1" >/dev/null 2>&1
  return 1
}

# ① 缓存 → ② 上次已知 → ③ 全段扫
if ! alive; then
  for p in "$(cat $CACHE 2>/dev/null)" "$KNOWN"; do
    try "$p" && break
  done
fi

if ! alive; then
  for p in $(python3 "$SCAN" 2>/dev/null); do
    try "$p" && break
  done
fi

# ★ 取到端口后必须带 -s：容器里可能同时挂着多个设备
#   （无线调试端口 + 局域网 IP + 幽灵 emulator-5554）
#   不带 -s 就会报 "more than one device/emulator"
if alive; then
  P=$(adb devices 2>/dev/null \
      | awk '/^127\.0\.0\.1:[0-9]+[[:space:]]+device/{sub(/^127\.0\.0\.1:/,"",$1); print $1; exit}')
  [ -n "$P" ] && PORT="$P"
fi

if [ -n "$PORT" ]; then
  exec adb -s "127.0.0.1:$PORT" "$@"
fi
exec adb "$@"
