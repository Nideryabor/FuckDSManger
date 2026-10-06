#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su -c 'grep -ah \"GmGlass\" /data/adb/lspd/log/modules_*.log 2>/dev/null | tail -25'" 2>/dev/null
