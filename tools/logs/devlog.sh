#!/bin/sh
# ============================================================================
#  devlog.sh —— 日志网关客户端 🐲
#
#  网关：devlog_gw.py（设备侧，必须 su 起）→ 127.0.0.1:8756
#  本脚本：推脚本 / 查状态 / 发请求 / 把包拉回小窝
#
#  用法：
#      sh devlog.sh push          # 把网关脚本推到设备
#      sh devlog.sh up            # 打印起网关的命令（要你在 Termux 里 su 起）
#      sh devlog.sh ping          # 自检：root？各日志源有多少文件？
#      sh devlog.sh sync [标签]   # 全套拉回 /workspace/tmp/devlogs/<标签>/
#      sh devlog.sh lspd          # 只要 LSPosed 的 verbose* / modules*
#      sh devlog.sh crash         # 只要应用崩溃 + ANR + tombstone
#      sh devlog.sh run           # 只要 app 自己写的运行日志
#      sh devlog.sh ls <路径>     # 列设备目录（root）
#      sh devlog.sh tail <路径> [字节]
#      sh devlog.sh grep <词>     # 在最近落地目录里搜
#      sh devlog.sh open [标签]
#      sh devlog.sh stop
#
#  ⚠️ 网关必须 root：/data/adb/lspd 和 /data/system/dropbox 都是 0700 root。
#     adb shell（uid=2000）读不到，所以这里不做任何提权尝试。
# ============================================================================
export HOME=/root

ADB_SH=/workspace/tools/出笼隧道/adb.sh
GW_SRC=/workspace/tools/logs/devlog_gw.py
GW_DEV=/data/local/tmp/devlog_gw.py
OUT=${DEVLOG_OUT:-/workspace/tmp/devlogs}
APP=${DEVLOG_APP:-com.deepseek.chat.a}
HOST=${DEVLOG_HOST:-127.0.0.1}
PORT=${DEVLOG_PORT:-8756}

BASE="http://$HOST:$PORT"
STATE="$OUT/.state"
TOKEN_DEV=${DEVLOG_TOKEN_FILE:-/data/local/tmp/devlog_token}
TOKEN_CACHE="$OUT/.token"

ADB() { sh "$ADB_SH" "$@" </dev/null; }

# token：环境变量 > 本地缓存 > 从设备拉一次并缓存
# （网关启动时随机生成，写进 $TOKEN_DEV，代码里没有硬编码口令）
resolve_token() {
  [ -n "${DEVLOG_TOKEN:-}" ] && { TOKEN="$DEVLOG_TOKEN"; return 0; }
  if [ -r "$TOKEN_CACHE" ]; then
    TOKEN=$(tr -d '\r\n' < "$TOKEN_CACHE" 2>/dev/null)
    [ -n "$TOKEN" ] && return 0
  fi
  TOKEN=$(ADB shell "cat $TOKEN_DEV 2>/dev/null" 2>/dev/null | tr -d '\r\n')
  if [ -n "$TOKEN" ]; then
    mkdir -p "$OUT" 2>/dev/null
    printf '%s' "$TOKEN" > "$TOKEN_CACHE" 2>/dev/null
    chmod 600 "$TOKEN_CACHE" 2>/dev/null
    return 0
  fi
  return 1
}
say()  { printf '%s\n' "$*"; }
dim()  { printf '  \033[90m%s\033[0m\n' "$*"; }
ok()   { printf '\033[32m%s\033[0m\n' "$*"; }
err()  { printf '\033[31m%s\033[0m\n' "$*" >&2; }

alive() {
  resolve_token || return 1
  curl -s -m 3 -o /dev/null "$BASE/ping?token=$TOKEN" 2>/dev/null
}

# token 变了（网关重启）→ 缓存作废重取
refresh_token() { rm -f "$TOKEN_CACHE"; resolve_token; }

get() {
  _q="$1"; _t="${2:-120}"; _sep='?'
  case "$_q" in *\?*) _sep='&';; esac
  curl -sS -m "$_t" "$BASE$_q${_sep}token=$TOKEN"
}

need() {
  alive && return 0
  err "✗ 设备侧网关没在跑（$BASE 无响应）"
  cat <<'EOF'

  在 Termux 里执行（必须 su，否则读不到 /data/adb 和 /data/system）：

      su -c 'sh /data/local/tmp/devlog_start.sh --daemon'

  首次部署先：sh /workspace/tools/logs/devlog.sh push
EOF
  return 1
}

# ---------------------------------------------------------------- 部署
cmd_push() {
  ADB push "$GW_SRC" "$GW_DEV" 2>&1 | tail -1
  cat > /tmp/_devlog_start.sh <<'EOS'
#!/system/bin/sh
set -u
PY=""
for c in python3 /data/data/com.termux/files/usr/bin/python3; do
  if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then PY="$c"; break; fi
done
[ -z "$PY" ] && { echo "✗ 找不到 python3（Termux: pkg install python）"; exit 1; }
GW=/data/local/tmp/devlog_gw.py
[ -f "$GW" ] || { echo "✗ 缺 $GW ，先跑 devlog.sh push"; exit 1; }
echo "python: $PY   uid: $(id -u)"
exec "$PY" "$GW" "$@"
EOS
  ADB push /tmp/_devlog_start.sh /data/local/tmp/devlog_start.sh 2>&1 | tail -1
  rm -f /tmp/_devlog_start.sh
  ADB shell 'chmod 755 /data/local/tmp/devlog_gw.py /data/local/tmp/devlog_start.sh' >/dev/null 2>&1
  ok "已推送到 $GW_DEV + /data/local/tmp/devlog_start.sh"
}

cmd_up() {
  alive && { ok "已经在线：$BASE"; return 0; }
  say "网关必须在 Termux 里用 su 起，我没有这个权限，请你执行："
  say ""
  say "    su -c 'sh /data/local/tmp/devlog_start.sh --daemon'"
  say ""
  say "起完回来自检： sh /workspace/tools/logs/devlog.sh ping"
  ADB shell "[ -f $GW_DEV ] && echo '  (设备上已有 devlog_gw.py ✓)' || echo '  (设备上还没有，先 devlog.sh push)'" 2>/dev/null
}

cmd_stop() {
  if alive; then get "/quit" >/dev/null 2>&1 && ok "已请网关退出"; else err "网关本来就没跑"; fi
}

# ---------------------------------------------------------------- 查询
cmd_ping() {
  need || return 1
  get "/ping" | python3 -c '
import json,sys
d=json.load(sys.stdin)
print("网关   : 在线 v%s   端口 %s" % (d["version"], d["port"]))
print("身份   : uid=%s  root=%s%s" % (d["uid"], d["root"],
      "" if d["root"] else "   <- 非 root，什么都读不到"))
print("目标App: %s" % d["app"])
print("服务端 : %s" % d["time"])
print()
print("%-7s %-30s %5s %10s  %s" % ("组","路径","文件","字节","最新"))
for s in d["sources"]:
    if not s["exists"]:
        note = "(不存在)"
    elif not s["readable"]:
        note = "(无权限)"
    else:
        note = s.get("newest","")
    print("%-7s %-30s %5s %10s  %s" % (s["group"], s["root"],
        s.get("count","-"), s.get("bytes","-"), note))
'
}

cmd_ls()   { need || return 1; get "/ls?path=$1"; }
cmd_tail() { need || return 1; get "/file?path=$1&tail=${2:-20000}"; }

# ---------------------------------------------------------------- 拉包
cmd_bundle() {   # $1=only  $2=标签
  need || return 1
  _only="$1"; _label="${2:-$(date +%m%d_%H%M%S)}"
  _dir="$OUT/$_label"
  _since=0
  if [ -f "$STATE" ]; then _since=$(cat "$STATE"); fi
  mkdir -p "$_dir" || return 1

  _url="/bundle?mode=logs&app=$APP&since=$_since"
  [ -n "$_only" ] && _url="$_url&only=$_only"
  dim "拉取中 (since=${_since})  ->  $_dir"

  _code=$(curl -sS -m 900 -o "$_dir/bundle.tgz" -w '%{http_code}' "$BASE$_url&token=$TOKEN")
  if [ "$_code" != "200" ]; then
    err "拉取失败 HTTP $_code"; head -c 300 "$_dir/bundle.tgz"; rm -rf "$_dir"; return 1
  fi
  tar -xzf "$_dir/bundle.tgz" -C "$_dir" 2>/dev/null
  rm -f "$_dir/bundle.tgz"

  _n=$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["file_count"])' \
        "$_dir/MANIFEST.json" 2>/dev/null || echo 0)
  if [ "$_n" = "0" ]; then
    python3 -c 'import json,sys;m=json.load(open(sys.argv[1]));open(sys.argv[2],"w").write("%.3f"%m["server_time"])' \
      "$_dir/MANIFEST.json" "$STATE" 2>/dev/null
    rm -rf "$_dir"
    dim "无新文件（增量 since=$_since）"
    return 0
  fi

  python3 - "$_dir" "$STATE" <<'PY'
import json,os,sys
d,state=sys.argv[1],sys.argv[2]
m=json.load(open(os.path.join(d,"MANIFEST.json"),encoding="utf-8"))
print("打包于 %s   root=%s   %d 文件 / %.1f KB" % (
    m["generated"], m["root"], m["file_count"], m["total_bytes"]/1024))
for s in m["skipped"][:6]:
    print("  跳过 %-32s %s" % (s["path"], s["why"]))
g={}
for f in m["files"]:
    k=f["arc"].split("/")[0]; g[k]=g.get(k,0)+1
if g: print("  内容: " + "  ".join("%s x%d"%(k,v) for k,v in sorted(g.items())))
for f in sorted(m["files"], key=lambda x:-x["mtime"])[:8]:
    print("    %-46s %9d B" % (f["arc"], f["size"]))
open(state,"w").write("%.3f" % m["server_time"])
PY
  ln -sfn "$_dir" "$OUT/latest"
  ok "落地完成：$_dir   (软链 $OUT/latest)"
}

cmd_sync()  { cmd_bundle ""      "${1:-}"; }
cmd_lspd()  { cmd_bundle "lspd"  "lspd_$(date +%m%d_%H%M%S)"; }
cmd_crash() { cmd_bundle "crash,anr,tomb" "crash_$(date +%m%d_%H%M%S)"; }
cmd_run()   { cmd_bundle "app"   "run_$(date +%m%d_%H%M%S)"; }

# ---------------------------------------------------------------- 本地
cmd_grep() {
  _pat="${1:?用法: devlog.sh grep <词>}"
  _l=$(readlink -f "$OUT/latest" 2>/dev/null)
  [ -d "$_l" ] || { err "还没拉过包"; return 1; }
  grep -rhaE "$_pat" "$_l" 2>/dev/null | tail -60
}

cmd_open() {
  mkdir -p "$OUT"
  if [ -n "$1" ] && [ -d "$OUT/$1" ]; then ls -la "$OUT/$1"; return; fi
  say "落地目录 $OUT:"
  ls -1t "$OUT" 2>/dev/null | grep -v '^\.' | head -15
  _l=$(readlink -f "$OUT/latest" 2>/dev/null)
  [ -n "$_l" ] && { say ""; say "latest -> $_l"; find "$_l" -type f | sed "s|$_l/||" | head -20; }
}

case "${1:-help}" in
  push)  shift; cmd_push "$@";;
  up)    shift; cmd_up "$@";;
  stop)  shift; cmd_stop "$@";;
  ping)  shift; cmd_ping "$@";;
  sync)  shift; cmd_sync "$@";;
  lspd)  shift; cmd_lspd "$@";;
  crash) shift; cmd_crash "$@";;
  run)   shift; cmd_run "$@";;
  ls)    shift; cmd_ls "$@";;
  tail)  shift; cmd_tail "$@";;
  grep)  shift; cmd_grep "$@";;
  open)  shift; cmd_open "$@";;
  *) cat <<'EOF'
devlog.sh —— 日志网关客户端

  push         把网关脚本推到设备
  up           打印起网关的命令（需你在 Termux 里 su 起）
  ping         自检：root？各日志源有多少文件、最新是哪个
  sync [标签]  全套拉回 /workspace/tmp/devlogs/<标签>/
  lspd         只要 LSPosed verbose* / modules*
  crash        只要应用崩溃 + ANR + tombstone
  run          只要 app 自己写的运行日志
  ls <路径>    列设备目录（root）
  tail <路径> [字节]
  grep <词>    在最近落地目录里搜
  open [标签]
  stop

抓什么（都是文件，不看 logcat 缓冲区）：
  lspd   /data/adb/lspd/log/{verbose*,modules*}
  crash  /data/system/dropbox/*crash* *anr*
  anr    /data/anr/*
  tomb   /data/tombstones/*
  app    /data/data/<包>/ 下名字像日志的文件

环境变量：DEVLOG_OUT  DEVLOG_APP  DEVLOG_PORT  DEVLOG_TOKEN
EOF
  ;;
esac
