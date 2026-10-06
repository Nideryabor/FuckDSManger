#!/bin/sh
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
adb shell "su -c 'monkey -p com.little_femaleboy.cannot_show.the_big_won_whale -c android.intent.category.LAUNCHER 1'" >/dev/null 2>&1
