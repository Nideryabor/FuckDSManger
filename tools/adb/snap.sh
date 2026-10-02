#!/bin/sh
# 宿主自拍 → 只读拉出来（不往设备写任何东西）🐲
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su 0 sh -c 'am start -n com.deepseek.chat.a/com.deepseek.chat.MainActivity'" >/dev/null 2>&1
sleep 4
adb shell "su 0 sh -c 'am broadcast -a com.little_femaleboy.fdm.CMD --es cmd glass_snap'" >/dev/null 2>&1
sleep 4
# ★ 纯读：cat 出来，不写设备
adb exec-out "su 0 cat /data/data/com.deepseek.chat.a/files/fdm-snap.png" > "$1" 2>/dev/null
ls -la "$1"
