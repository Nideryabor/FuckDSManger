#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
echo "--- 前台 Activity ---"
adb shell "su -c 'dumpsys activity activities | grep -m2 topResumedActivity'" 2>/dev/null
echo "--- 起 UI ---"
adb shell "su -c 'am start -n com.little_femaleboy.cannot_show.the_big_won_whale/com.nidyaber.fuckdsmanger.MainActivity'" 2>&1 | head -5
sleep 6
echo "--- 再看前台 ---"
adb shell "su -c 'dumpsys activity activities | grep -m2 topResumedActivity'" 2>/dev/null
