#!/bin/sh
# 在所有 LSPosed 模块日志里搜关键词（重试 + 一条命令）🐲
PAT="${1:-GmGlass}"
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
echo "state=$(adb get-state 2>/dev/null)"
adb shell "su -c 'grep -ah \"$PAT\" /data/adb/lspd/log/modules_*.log 2>/dev/null | tail -40'" 2>/dev/null
