#!/bin/sh
# 抓 LSPosed 模块日志（一条命令 + 重试）🐲
OUT="${1:-/workspace/tmp/lspd.log}"
adb kill-server >/dev/null 2>&1
adb start-server >/dev/null 2>&1
i=0
while [ $i -lt 20 ]; do
  st=$(adb get-state 2>/dev/null)
  [ "$st" = "device" ] && break
  sleep 2; i=$((i+1))
done
echo "state=$(adb get-state 2>/dev/null) (试了 $i 次)"
LATEST=$(adb shell "su -c 'ls -t /data/adb/lspd/log/modules_*.log | head -1'" 2>/dev/null | tr -d '\r')
echo "最新模块日志: $LATEST"
adb shell "su -c 'cat $LATEST'" > "$OUT" 2>/dev/null
wc -l "$OUT"
