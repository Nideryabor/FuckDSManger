#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
echo "=== 屏幕状态 ==="
adb shell "su -c 'dumpsys power | grep -m2 -E \"mWakefulness=|Display Power\"'" 2>/dev/null
echo "=== 当前焦点窗口 ==="
adb shell "su -c 'dumpsys window | grep -m4 -E \"mCurrentFocus|mFocusedApp\"'" 2>/dev/null
echo "=== 宿主进程在不在 ==="
adb shell "su -c 'pidof com.deepseek.chat.a'" 2>/dev/null | tr -d '\r'
echo "=== 最近崩溃/ANR ==="
adb logcat -d 2>/dev/null | grep -aE "FATAL EXCEPTION|ANR in" | tail -5
