#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su -c 'grep -ah -A 14 \"扒背景元素失败\" /data/adb/lspd/log/modules_*.log 2>/dev/null | head -30'" 2>/dev/null
echo "=========== 配置刷新 / 换掉绘制 / 底图 ==========="
adb shell "su -c 'grep -ah -E \"配置刷新|换掉绘制|底图截取|坐标反推|发现元素\" /data/adb/lspd/log/modules_*.log 2>/dev/null | tail -30'" 2>/dev/null
