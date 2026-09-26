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

HERE=$(dirname "$0")
CACHE="$HERE/.adbport"
SCAN="$HERE/扫adb端口.py"
KNOWN="34597"

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

exec adb "$@"
