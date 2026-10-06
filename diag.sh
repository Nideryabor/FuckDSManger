#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
echo "=== 宿主 pid ==="
PID=$(adb shell "su -c 'pidof com.deepseek.chat.a'" 2>/dev/null | tr -d '\r')
echo "pid=$PID"
echo "=== 界面树（前 60 行）==="
adb shell "su -c 'uiautomator dump /sdcard/ui.xml >/dev/null 2>&1; cat /sdcard/ui.xml'" 2>/dev/null | head -c 4000
echo
echo "=== 宿主进程最近报错 ==="
adb logcat -d 2>/dev/null | grep -a " $PID " | grep -aiE "E |W |Exception|Error" | tail -30
