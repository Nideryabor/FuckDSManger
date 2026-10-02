#!/bin/sh
# 只在「宿主真的在前台」时才截图 🐲
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su -c 'input keyevent KEYCODE_WAKEUP'" >/dev/null 2>&1
for try in 1 2 3 4 5 6; do
  adb shell "su -c 'am start -n com.deepseek.chat.a/com.deepseek.chat.MainActivity'" >/dev/null 2>&1
  sleep 4
  F=$(adb shell "su -c 'dumpsys window | grep -m1 mCurrentFocus'" 2>/dev/null)
  case "$F" in
    *deepseek*) echo "✓ 宿主在前台（第 $try 次）"; adb exec-out screencap -p > "$1" 2>/dev/null; ls -la "$1"; return 0 2>/dev/null || exit 0;;
    *) echo "  第 $try 次没抢到：$F";;
  esac
done
echo "✗ 6 次都没抢到前台"
