#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su -c 'input keyevent KEYCODE_WAKEUP
am start -n com.deepseek.chat.a/com.deepseek.chat.MainActivity >/dev/null 2>&1
sleep 5
dumpsys window | grep -m1 mCurrentFocus
screencap -p /sdcard/hs.png
ls -la /sdcard/hs.png'" 2>/dev/null
adb pull /sdcard/hs.png "$1" 2>&1 | tail -1
ls -la "$1"
