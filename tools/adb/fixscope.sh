#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
PKG=com.little_femaleboy.cannot_show.the_big_won_whale
SP=/data/data/$PKG/shared_prefs/fdm_ui.xml
adb shell "su -c 'sed -i /fuckds_glass_scope/d $SP'" >/dev/null 2>&1
echo "--- 现在还有没有 scope 键 ---"
adb shell "su -c 'grep -c fuckds_glass_scope $SP'" 2>/dev/null | tr -d '\r'
adb shell "su -c 'am force-stop $PKG; am start -n $PKG/com.nidyaber.fuckdsmanger.MainActivity'" >/dev/null 2>&1
sleep 5
adb shell "su -c 'am force-stop com.deepseek.chat.a'" >/dev/null 2>&1
sleep 2
adb shell "su -c 'monkey -p com.deepseek.chat.a -c android.intent.category.LAUNCHER 1'" >/dev/null 2>&1
sleep 12
