#!/bin/sh
# 把「液态玻璃 · 作用范围」改成 1（仅标准按钮）并让 UI 推给宿主 🐲
VAL="${1:-1}"
adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1
i=0; while [ $i -lt 30 ]; do [ "$(adb get-state 2>/dev/null)" = "device" ] && break; sleep 2; i=$((i+1)); done
PKG=com.little_femaleboy.cannot_show.the_big_won_whale
REAL=/data/data/$PKG/shared_prefs/fdm_ui.xml
adb shell "su -c 'am force-stop $PKG; cp $REAL /sdcard/fdm_ui.xml; chmod 666 /sdcard/fdm_ui.xml'" >/dev/null 2>&1
adb pull /sdcard/fdm_ui.xml /tmp/ui.xml >/dev/null 2>&1
python3 - "$VAL" <<'PY'
import re, sys
val = sys.argv[1]
p = '/tmp/ui.xml'
s = open(p, encoding='utf-8').read()
if 'fuckds_glass_scope' in s:
    s = re.sub(r'(name="fuckds_glass_scope" value=")[^"]*(")', r'\g<1>'+val+r'\g<2>', s)
else:
    s = s.replace('</map>', '<int name="fuckds_glass_scope" value="%s" />\n</map>' % val)
open(p, 'w', encoding='utf-8').write(s)
print("本地改好:", re.findall(r'fuckds_glass_scope[^/]*', s))
PY
adb push /tmp/ui.xml /sdcard/fdm_ui_m.xml >/dev/null 2>&1
adb shell "su -c 'cp /sdcard/fdm_ui_m.xml $REAL; chown $(stat -c %u:%g /dev/null 2>/dev/null || echo 0:0) $REAL' " >/dev/null 2>&1
adb shell "su -c 'chmod 660 $REAL'" >/dev/null 2>&1
adb shell "su -c 'am start -n $PKG/com.nidyaber.fuckdsmanger.MainActivity'" >/dev/null 2>&1
sleep 5
adb shell "su -c 'am force-stop com.deepseek.chat.a'" >/dev/null 2>&1
sleep 2
adb shell "su -c 'monkey -p com.deepseek.chat.a -c android.intent.category.LAUNCHER 1'" >/dev/null 2>&1
sleep 12
