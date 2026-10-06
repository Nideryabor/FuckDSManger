#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
SP=/data/data/com.little_femaleboy.cannot_show.the_big_won_whale/shared_prefs/fdm_ui.xml
echo "--- 关玻璃前的相关键 ---"
adb shell "su -c 'grep -o \"fuckds_glass[^/]*\" $SP'" 2>/dev/null
adb shell "su -c 'sed -i \"s/\\(name=\\\"fuckds_glass_on\\\" value=\\\"\\)true/\\1false/\" $SP'" 2>/dev/null
echo "--- 关玻璃后 ---"
adb shell "su -c 'grep -o \"fuckds_glass[^/]*\" $SP'" 2>/dev/null
echo "--- 重启 UI + 宿主 ---"
adb shell "su -c 'am force-stop com.little_femaleboy.cannot_show.the_big_won_whale'" >/dev/null 2>&1
adb shell "su -c 'am start -n com.little_femaleboy.cannot_show.the_big_won_whale/com.nidyaber.fuckdsmanger.MainActivity'" >/dev/null 2>&1
sleep 5
adb shell "su -c 'am force-stop com.deepseek.chat.a'" >/dev/null 2>&1
sleep 2
adb shell "su -c 'monkey -p com.deepseek.chat.a -c android.intent.category.LAUNCHER 1'" >/dev/null 2>&1
sleep 12
adb shell "su -c 'am start -n com.deepseek.chat.a/com.deepseek.chat.MainActivity'" >/dev/null 2>&1
sleep 4
adb exec-out screencap -p > "$1" 2>/dev/null
ls -la "$1"
