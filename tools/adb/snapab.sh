#!/bin/sh
# 关/开玻璃各拍一张，抓下来做 diff 🐲
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
SEP=$(printf '\037')
B=com.little_femaleboy.fdm.CMD
put() { adb shell "su -c 'am broadcast -a $B --es cmd cfg_put --es arg \"$1${SEP}$2${SEP}$3\"'" >/dev/null 2>&1; }
snap() {
  adb shell "su -c 'am broadcast -a $B --es cmd glass_snap'" >/dev/null 2>&1
  sleep 3
  adb shell "su -c 'cp /data/data/com.deepseek.chat.a/files/fdm-snap.png /sdcard/s.png; chmod 666 /sdcard/s.png'" >/dev/null 2>&1
  adb pull /sdcard/s.png "$1" >/dev/null 2>&1
}
adb shell "su -c 'am start -n com.deepseek.chat.a/com.deepseek.chat.MainActivity'" >/dev/null 2>&1
sleep 4
put fuckds_glass_on b false ; sleep 2 ; snap /workspace/tmp/shots/off.png
put fuckds_glass_on b true  ; sleep 3 ; snap /workspace/tmp/shots/on.png
ls -la /workspace/tmp/shots/off.png /workspace/tmp/shots/on.png
