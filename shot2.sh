#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su -c 'input keyevent KEYCODE_WAKEUP'" >/dev/null 2>&1
sleep 1
adb exec-out screencap -p > "$1" 2>/dev/null
ls -la "$1"
