#!/bin/sh
# 拉起宿主并截图 🐲
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su -c 'am force-stop com.deepseek.chat.a; input keyevent KEYCODE_WAKEUP'" >/dev/null 2>&1
sleep 1
adb shell "su -c 'monkey -p com.deepseek.chat.a -c android.intent.category.LAUNCHER 1'" >/dev/null 2>&1
sleep 6
adb exec-out screencap -p > "$1" 2>/dev/null
ls -la "$1"
