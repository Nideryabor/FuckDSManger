#!/bin/sh
# adbx.sh —— 抗掉线的 adb 包装（每次调用内部自愈 + 整条命令重试）
# 用法: sh adbx.sh '<要执行的 shell 命令>'   例: sh adbx.sh 'ls -la /data/local/tmp'
export PATH="$PATH:/workspace/tools/adb"
CMD="$*"
n=0
while [ $n -lt 4 ]; do
  n=$((n+1))
  adb start-server >/dev/null 2>&1
  i=0
  while [ $i -lt 8 ]; do
    st=$(adb get-state 2>/dev/null)
    [ "$st" = "device" ] && break
    adb kill-server >/dev/null 2>&1
    adb start-server >/dev/null 2>&1
    sleep 2
    i=$((i+1))
  done
  if [ "$(adb get-state 2>/dev/null)" = "device" ]; then
    out=$(adb shell "$CMD" 2>&1)
    if echo "$out" | grep -q "device offline\|device not found\|no devices"; then
      sleep 2
      continue
    fi
    echo "$out"
    exit 0
  fi
  sleep 2
done
echo "[adbx] FAILED after $n tries"
exit 1
