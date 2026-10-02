#!/bin/sh
# 装模块 + 修作用范围默认值 + 重启宿主 🐲
APK="${1:-/workspace/FDM-3.30.1-single-signed.apk}"
PKG=com.little_femaleboy.cannot_show.the_big_won_whale
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
echo "state=$(adb get-state 2>/dev/null)"

echo "=== 安装 ==="
adb install -r -d "$APK" 2>&1 | tail -2

echo "=== 把「作用范围」修正成 1（仅标准按钮）==="
SP=/data/data/$PKG/shared_prefs/fdm_ui.xml
adb shell "su -c 'echo s/fuckds_glass_scope\\\" value=\\\"0/fuckds_glass_scope\\\" value=\\\"1/ > /data/local/tmp/fix.sed'" >/dev/null 2>&1
adb shell "su -c 'sed -i -f /data/local/tmp/fix.sed $SP'" >/dev/null 2>&1
adb shell "su -c 'grep -o \"fuckds_glass_scope[^/]*\" $SP'" 2>/dev/null | head -2

echo "=== 重启 UI + 宿主 ==="
adb shell "su -c 'am force-stop $PKG'" >/dev/null 2>&1
adb shell "su -c 'am start -n $PKG/com.nidyaber.fuckdsmanger.MainActivity'" >/dev/null 2>&1
sleep 4
adb shell "su -c 'am force-stop com.deepseek.chat.a'" >/dev/null 2>&1
sleep 2
adb shell "su -c 'monkey -p com.deepseek.chat.a -c android.intent.category.LAUNCHER 1'" >/dev/null 2>&1
sleep 10
echo "宿主已拉起"
