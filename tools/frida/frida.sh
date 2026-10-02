#!/bin/sh
# ============================================================================
#  frida.sh —— Frida 一条龙 🐲（2026-09-30 · 尼得亚伯）
#
#  用法：
#     sh frida.sh up                      # 起服务（推二进制 / 找可写目录 / 转发端口 / 自检）
#     sh frida.sh status                  # 看服务 + 连接状态
#     sh frida.sh ps                      # 列设备进程
#     sh frida.sh attach <包名|pid> [js]  # 挂上去，可选跑一个脚本
#     sh frida.sh eval   <包名|pid> '<js>'# 跑一段 JS，回传 console.log
#     sh frida.sh watch  <包名> <js>      # 挂着跑，Ctrl-C 退出（长驻脚本用）
#     sh frida.sh selfshot [输出png]      # 让宿主自拍当前画面并拉回来（我的"眼睛"）
#     sh frida.sh down                    # 停服务 + 撤端口转发
#
#  设计要点（都是这晚上踩出来的）：
#     · adb daemon 会自己死 ⇒ 每条命令前 restart + 重试到 device
#     · 这台设备的 root 是 `su 0 <cmd>`，**不是** `su -c '<cmd>'`（KernelSU）
#     · `/data/local/tmp` root 也写不进（susfs 保护）⇒ 二进制放 /data/adb
#     · frida 的 helper dex 需要可写 temp ⇒ 起服务时带 TMPDIR
#     · **不在设备上留下任何多余文件**（除了 /data/adb/frida-server 本身）
# ============================================================================
set -u

HERE=$(cd "$(dirname "$0")" && pwd)

# ═══════════════════════════════════════════════════════════════════════════
#  ★★ 2026-10-01 重大修正：必须用 16.7.19 那一套 ★★
#
#  实测（见 专题/2026-10-01-frida-agent-崩溃-完整尸检.md）：
#    同一台机器上直接 dlopen 各版 frida-agent：
#      frida-agent 17.19.0  → .init_array 构造函数里 NULL 解引用（SIGSEGV, fault 0x38）
#      frida-agent 17.16.0  → 构造函数 OK
#      frida-agent 16.7.19  → 构造函数 OK
#    17.16.0 / 16.7.19 服务端 + 客户端 实测**注入、跑 JS、Java.use、方法 hook 全通**。
#
#  ⇒ BIN 固定用 16.7.19；并且把 CLI/python 也切到同一版本的 private 目录（py16）。
#     17.19.0 的二进制留在原地当证据，**不要再用**。
# ═══════════════════════════════════════════════════════════════════════════
BIN="$HERE/frida-server-16.7.19-arm64"

F16="$HERE/py16"
if [ -d "$F16" ]; then
  PYTHONPATH="$F16${PYTHONPATH:+:$PYTHONPATH}"
  PATH="$F16/bin:$PATH"
  export PYTHONPATH PATH
fi
PORT=27042
TMP_ON_DEV=/data/local/tmp
ADB_TMP=/data/adb
DEV_BIN="$ADB_TMP/frida-server"
PKG_HOST=com.deepseek.chat.a

say() { printf '\033[36m· %s\033[0m\n' "$*"; }
ok()  { printf '\033[32m✓ %s\033[0m\n' "$*"; }
bad() { printf '\033[31m✗ %s\033[0m\n' "$*"; }

# ── adb 重连（这台环境的 daemon 老自己死）──────────────────────────────
adb_wait() {
  adb kill-server >/dev/null 2>&1
  adb start-server >/dev/null 2>&1
  i=0
  while [ $i -lt 40 ]; do
    [ "$(adb get-state 2>/dev/null)" = "device" ] && return 0
    sleep 1; i=$((i+1))
  done
  bad "等不到设备（adb get-state 不是 device）"
  return 1
}

# ── 这台设备的 su 写法（su 0 还是 su -c）────────────────────────────────
SU=""
su_detect() {
  if [ -n "$SU" ]; then return 0; fi
  if adb shell "su 0 id" 2>/dev/null | grep -q 'uid=0'; then
    SU="su 0"; ok "root 写法：su 0（KernelSU）"; return 0
  fi
  if adb shell "su -c id" 2>/dev/null | grep -q 'uid=0'; then
    SU="su -c"; ok "root 写法：su -c"; return 0
  fi
  bad "拿不到 root —— 后面几步会失败"
  return 1
}
sh0() { adb shell "$SU sh -c '$*'" 2>/dev/null; }

# ═══════════════════════════ up ═══════════════════════════
cmd_up() {
  adb_wait || return 1
  su_detect
  [ -f "$BIN" ] || { bad "缺二进制：$BIN"; return 1; }

  # 1) 二进制就位（/data/adb —— /data/local/tmp 写不进去）
  if sh0 "test -x $DEV_BIN" | grep -q .; then
    ok "设备上已有 $DEV_BIN"
  else
    say "推二进制（59MB，分两步：先到 tmp 再 root cp 到 /data/adb）"
    adb push "$BIN" $TMP_ON_DEV/frida-server >/dev/null 2>&1 || { bad "push 失败"; return 1; }
    sh0 "cp $TMP_ON_DEV/frida-server $DEV_BIN" >/dev/null 2>&1
    sh0 "chmod 755 $DEV_BIN" >/dev/null 2>&1
    sh0 "rm -f $TMP_ON_DEV/frida-server" >/dev/null 2>&1
    ok "已就位 $DEV_BIN"
  fi

  # 2) 干掉旧的
  sh0 "killall frida-server" >/dev/null 2>&1
  sleep 1

  # 3) 起服务（TMPDIR 指到可写目录，否则 helper dex 写不进 /data/local/tmp）
  say "起 frida-server（TMPDIR=$ADB_TMP, -d $ADB_TMP）"
  adb shell "$SU sh -c 'TMPDIR=$ADB_TMP nohup $DEV_BIN -D -d $ADB_TMP >$ADB_TMP/fs.log 2>&1 &'" >/dev/null 2>&1
  sleep 4
  if ! sh0 "ps -A" | grep -q frida-server; then
    bad "frida-server 没起来，日志："
    sh0 "cat $ADB_TMP/fs.log"
    return 1
  fi
  ok "frida-server 在跑"

  # 4) 端口转发
  adb forward tcp:$PORT tcp:$PORT >/dev/null 2>&1
  ok "端口转发 tcp:$PORT"

  # 5) 自检
  sleep 1
  if frida-ps -H 127.0.0.1:$PORT >/dev/null 2>&1; then
    ok "连接自检通过 —— 可以用 attach / eval 了"
  else
    bad "连不上。如果报 'failed to create ... frida-helper-*.dex: Permission denied'："
    echo "      /data/local/tmp 对 root 也不可写（susfs）。解决办法二选一："
    echo "        a) 你先 chmod 777 /data/local/tmp"
    echo "        b) 用 TMPDIR 指到别的可写目录（本脚本已带，若仍失败说明 glib 没吃到 env）"
    return 1
  fi
}

# ═══════════════════════════ status ═══════════════════════════
cmd_status() {
  adb_wait >/dev/null 2>&1 || { bad "设备不在线"; return 1; }
  echo "── 设备 ──"
  adb shell "getprop ro.product.cpu.abi; getprop ro.build.version.sdk" 2>/dev/null | tr '\n' ' '; echo
  echo "── frida-server ──"
  if adb shell "$SU ps -A" 2>/dev/null | grep -q frida-server; then ok "在跑"; else bad "没在跑（先 up）"; fi
  echo "── 端口 ──"; adb forward --list 2>/dev/null | grep $PORT || echo "（没转发）"
  echo "── 连接 ──"
  frida-ps -H 127.0.0.1:$PORT 2>&1 | head -3
}

# ═══════════════════════════ ps ═══════════════════════════
cmd_ps() {
  adb_wait >/dev/null 2>&1 || return 1
  frida-ps -H 127.0.0.1:$PORT 2>&1 | tail -n +1
}

# ═══════════════════════════ attach / eval / watch ═══════════════════════════
cmd_attach() {
  T="${1:?用法: attach <包名|pid> [脚本.js]}"; JS="${2:-}"
  adb_wait >/dev/null 2>&1
  if [ -n "$JS" ]; then
    exec frida -H 127.0.0.1:$PORT -n "$T" -l "$JS" -q
  else
    exec frida -H 127.0.0.1:$PORT -n "$T" -q
  fi
}

cmd_eval() {
  T="${1:?用法: eval <包名|pid> '<js>'}"; JS="${2:?缺 JS}"
  adb_wait >/dev/null 2>&1
  python3 "$HERE/frida_eval.py" "$T" "$JS"
}

cmd_watch() {
  T="${1:?用法: watch <包名|pid> <脚本.js>}"; JS="${2:?缺脚本}"
  adb_wait >/dev/null 2>&1
  exec frida -H 127.0.0.1:$PORT -n "$T" -l "$JS"
}

# ═══════════════════════════ selfshot（我的眼睛）═══════════════════════════
cmd_selfshot() {
  OUT="${1:-/workspace/tmp/shots/snap.png}"
  SRC="/data/data/$PKG_HOST/files/fdm-snap.png"
  adb_wait >/dev/null 2>&1 || return 1
  say "拉起宿主 + 触发自拍"
  adb shell "am start -n $PKG_HOST/com.deepseek.chat.MainActivity" >/dev/null 2>&1
  sleep 4
  adb shell "am broadcast -a com.little_femaleboy.fdm.CMD --es cmd glass_snap" >/dev/null 2>&1
  sleep 4
  mkdir -p "$(dirname "$OUT")"
  adb exec-out "$SU cat $SRC" > "$OUT" 2>/dev/null   # ★ 纯读，不往设备写
  ls -la "$OUT"
}

# ═══════════════════════════ down ═══════════════════════════
cmd_down() {
  adb_wait >/dev/null 2>&1
  say "停服务"
  adb shell "$SU killall frida-server" >/dev/null 2>&1
  adb forward --remove-all >/dev/null 2>&1
  ok "已停 + 端口已撤"
  echo "（二进制留在 $DEV_BIN，下次 up 直接用；要删：$SU rm -f $DEV_BIN）"
}

case "${1:-}" in
  up)       cmd_up ;;
  status)   cmd_status ;;
  ps)       cmd_ps ;;
  attach)   shift; cmd_attach "$@" ;;
  eval)     shift; cmd_eval "$@" ;;
  watch)    shift; cmd_watch "$@" ;;
  selfshot) shift; cmd_selfshot "$@" ;;
  down)     cmd_down ;;
  *)        sed -n '2,25p' "$0" ;;
esac
