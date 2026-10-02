#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
# 1) 先把模块 UI 拉起来（它才是配置的源头）
adb shell "su -c 'am start -n com.little_femaleboy.cannot_show.the_big_won_whale/com.nidyaber.fuckdsmanger.MainActivity'" >/dev/null 2>&1
sleep 5
# 2) 再让宿主走一遍启动（启动时会 CONFIG_REQ，UI 应答 CONFIG_PUSH）
adb shell "su -c 'am force-stop com.deepseek.chat.a'" >/dev/null 2>&1
sleep 2
adb shell "su -c 'monkey -p com.deepseek.chat.a -c android.intent.category.LAUNCHER 1'" >/dev/null 2>&1
echo "已重启宿主（UI 在后台等着应答）"
