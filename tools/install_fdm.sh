#!/bin/sh
# ============================================================================
#  install_fdm.sh —— 一键装模块 + 修 LSPosed 路径 + 重启宿主 + 自检  🐲
#
#  为什么要这个脚本：
#    每次 `adb install -r` 安卓都会换一个全新的 /data/app/~~xxx==/ 路径，
#    而 LSPosed 的 modules 表缓存着旧路径 ⇒ **模块静默不加载**
#    ⇒ 表现成"功能全哑"，让人以为是代码错了，白白排查一小时。
#
#  用法： sh tools/install_fdm.sh <apk路径>
# ============================================================================
set -u
APK="${1:-/workspace/FDM-3.42.10-single-signed.apk}"
PKG="com.little_femaleboy.cannot_show.the_big_won_whale"
DB="/data/adb/lspd/config/modules_config.db"
HOST="com.deepseek.chat.a"

R() { for i in $(seq 1 15); do adb kill-server >/dev/null 2>&1; adb start-server >/dev/null 2>&1; sleep 3; \
        [ "$(adb get-state 2>/dev/null)" = device ] && return 0; sleep 3; done; return 1; }

echo "═══ ① 安装 $APK"
R && adb install -r "$APK" 2>&1 | tail -1

echo "═══ ② 读实际路径"
NEW=$(R && adb shell "pm path $PKG" | sed 's/package://' | tr -d '\r\n')
echo "    $NEW"

echo "═══ ③ 修 LSPosed 记录的路径（需要时）"
R && adb exec-out "su 0 cat $DB" > /tmp/lspd_now.db 2>/dev/null
python3 - "$NEW" <<'PY'
import sqlite3, shutil, sys
NEW = sys.argv[1]
PKG = "com.little_femaleboy.cannot_show.the_big_won_whale"
shutil.copy('/tmp/lspd_now.db', '/tmp/lspd_fix.db')
c = sqlite3.connect('/tmp/lspd_fix.db')
old = c.execute("select apk_path from modules where module_pkg_name=?", (PKG,)).fetchone()
if old is None:
    print("    ⚠️ LSPosed 里没有这个模块（scope 要先在管理器里勾一次）")
elif old[0] != NEW:
    c.execute("update modules set apk_path=? where module_pkg_name=?", (NEW, PKG)); c.commit()
    print("    旧: %s\n    → 需要修" % old[0][:70])
    open('/tmp/needfix','w').write('1')
else:
    print("    ✓ 一致，不用动")
PY
if [ -f /tmp/needfix ]; then
  R && adb push /tmp/lspd_fix.db /data/local/tmp/lspd_fix.db >/dev/null 2>&1
  R && adb shell "su 0 sh -c 'cp -f /data/local/tmp/lspd_fix.db $DB; chown root:root $DB; chmod 600 $DB'" \
    && echo "    ✓ 已修正（若模块仍不加载，请在 LSPosed 里把本模块取消勾选再勾选）"
  rm -f /tmp/needfix
fi

echo "═══ ④ 强停 + 拉起宿主"
R && adb shell "am force-stop $HOST"; sleep 2
R && adb shell "am start -n $HOST/com.deepseek.chat.MainActivity" >/dev/null 2>&1
sleep 14

echo "═══ ⑤ 自检（模块到底加载了没）"
R && adb exec-out "su 0 sh -c 'cat \$(ls -t /data/adb/lspd/log/modules*.log | head -1)'" > /tmp/lspd_check.log 2>/dev/null
N=$(grep -ac "FuckDSManger" /tmp/lspd_check.log)
echo -n "    模块日志行数: $N  "
if [ "$N" -gt 5 ]; then echo "✅ 已加载"; else echo "❌ 没加载 —— 去 LSPosed 里取消勾选再勾选本模块"; fi
echo -n "    门禁通过: "; grep -ac "NL 2.22.112 启动" /tmp/lspd_check.log
echo "    入口桶:"; grep -aoE "hookM (t5|ew1)\.[a-z]+ count=[0-9]+" /tmp/lspd_check.log | head -1
echo "    按设计跳过:"; grep -aoE "hookM FAIL com\.gm\.gone\.[^ ]+" /tmp/lspd_check.log | sort -u | head -8
