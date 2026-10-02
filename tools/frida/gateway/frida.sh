#!/system/bin/sh
# ============================================================================
#  frida.sh —— 白名单网关【起停】 🐲  v4
#  2026-10-01 · 尼得亚伯
#
#  ⚠️⚠️ 这个文件必须住在 /data/adb/frida/ （root:root 0700）⚠️⚠️
#
#  为什么：它要被 root（su）执行。如果它躺在 /data/local/tmp/，那就等于
#          "让一个尼尼能改的脚本以 root 运行" —— 整个白名单设计当场作废。
#
#  ★v2 起：它【不再自动安装/升级 run.sh】★
#     自动 cp 意味着 root 会去读一个尼尼可写的文件。
#     安装/升级必须由主人【过目后手动 cp】，见文末。
#
#  ★v4 起（review#7 补）★
#     [1] PAT 里的 . 要转义：run\.sh（resolve_pid 都记得转，这里漏了）
#     [2] PAT_INJ 收窄到【我们那个】二进制路径，别误杀用户自己开的 frida-inject
#     [3] -s 不再依赖 ps -o（旧 toybox 不一定有），改用 pgrep + /proc/cmdline
#     [4] chmod 0755 加了解释：为什么不能设成更严的 700（尼尼要读 result.txt）
#
#  ★v3 起（review#6 补）★
#     [1] -k 现在会【连子孙一起带走】：timeout / frida-inject 是 run.sh 的后代，
#         只杀 run.sh 会让 frida-inject 继续挂着 —— 目标里的钩子不会卸、
#         .stage/.out 也会留着。现在杀完还清一次临时文件。
#     [2] 起窗口前先 mkdir -p 输出目录（之前对不存在的路径静默 chown，
#         然后 run.sh 报"输出目录不存在"，完全指向不到 mkdir 这一步）
#     [3] -s 不再用 awk 切 ls -la 的列（不同 ROM 日期列数不一样，会串位），
#         改 stat -c，并直白地显示 run.sh 的属主/权限
#     [4] pkill 的匹配串改成带路径的 "[f]rida/run.sh"，不会误伤别处的同名脚本
#
#  用法（都要 su，且路径必须是 /data/adb/frida/frida.sh）：
#     su -c 'sh /data/adb/frida/frida.sh'        起窗口（后台 30 分钟）
#     su -c 'sh /data/adb/frida/frida.sh -f'     起窗口（前台，能看进度）
#     su -c 'sh /data/adb/frida/frida.sh -s'     看状态
#     su -c 'sh /data/adb/frida/frida.sh -k'     停掉
# ============================================================================

SELF_DIR=$(cd "$(dirname "$0")" && pwd)
GOOD_DIR=/data/adb/frida
RUN="$SELF_DIR/run.sh"
OUT_DIR=/data/local/tmp/frida_out
SECS=1800
PAT_WATCH='[f]rida/run\.sh --watch'     # 带路径 + 转义 . + [f] 防自杀
PAT_INJ='[a]db/frida/frida-inject'       # 收窄到【我们那个】二进制，别误杀用户自己的

say() { printf '%s\n' "$*"; }
die() { printf '✗ %s\n' "$*" >&2; exit 1; }

[ "$(id -u 2>/dev/null)" = "0" ] || die "要以 root 跑：su -c 'sh $GOOD_DIR/frida.sh'"

# ── 自我保护：必须在 root-only 目录里跑 ──
if [ "$SELF_DIR" != "$GOOD_DIR" ]; then
  say "⚠️⚠️ 你现在跑的是【$SELF_DIR/frida.sh】，这个位置尼尼能改！"
  say "    它被 su 执行 = 让尼尼能改的脚本以 root 运行。"
  say ""
  say "    正确做法（先 cat 一遍看清楚，再装）："
  say "      su -c 'mkdir -p $GOOD_DIR && chmod 700 $GOOD_DIR'"
  say "      cat $SELF_DIR/frida.sh              # ← 过目"
  say "      su -c 'cp $SELF_DIR/frida.sh $GOOD_DIR/frida.sh'"
  say "      su -c 'chmod 700 $GOOD_DIR/frida.sh; chown root:root $GOOD_DIR/frida.sh'"
  say "    以后就用：su -c 'sh $GOOD_DIR/frida.sh'"
  exit 1
fi

# ── 停：连子孙一起带走 ──
stop_all() {
  PIDS=$(pgrep -f "$PAT_WATCH" 2>/dev/null)
  if [ -n "$PIDS" ]; then
    for p in $PIDS; do pkill -P "$p" 2>/dev/null; done   # 直系子进程 timeout
    sleep 1
    kill $PIDS 2>/dev/null
    sleep 1
  fi
  # 兜底：timeout 死了不会带走 frida-inject（父死子不自动死）
  if pgrep -f "$PAT_INJ" >/dev/null 2>&1; then
    say "   （有 frida-inject 残留，单独收掉）"
    pkill -f "$PAT_INJ" 2>/dev/null
    sleep 1
    pgrep -f "$PAT_INJ" >/dev/null 2>&1 && pkill -9 -f "$PAT_INJ" 2>/dev/null
    sleep 1
  fi
  # 残留的临时文件（正常情况下 run.sh 自己会删）
  rm -f "$GOOD_DIR"/.job.* "$GOOD_DIR"/.stage.* "$GOOD_DIR"/.out.* 2>/dev/null
}

MODE="${1:-bg}"

# ── -s 状态 ──
if [ "$MODE" = "-s" ]; then
  say "=== frida 网关状态 ==="
  # ★v12：ps -o 在旧 toybox 上不一定有 —— 直接用 pgrep，它本来就在用
  WP=$(pgrep -f "$PAT_WATCH" 2>/dev/null)
  if [ -n "$WP" ]; then
    say "  窗口: 在跑"
    for p in $WP; do
      say "        pid $p  $(tr '\0' ' ' < /proc/$p/cmdline 2>/dev/null)"
    done
  else
    say "  窗口: 没在跑"
  fi

  if [ -f "$RUN" ]; then
    say "  run.sh    : $(stat -c '%A  %U:%G  %s 字节  %y' "$RUN" 2>/dev/null)"
    say "  run.sh 校验: $(stat -c '%U:%a' "$RUN" 2>/dev/null)   ← 必须是 root:700"
    say "  sha256    : $(sha256sum "$RUN" 2>/dev/null | awk '{print $1}')"
  else
    say "  run.sh    : ✗ 不存在"
  fi

  if [ -d "$OUT_DIR" ]; then
    say "  输出目录  : $(stat -c '%A  %U:%G' "$OUT_DIR" 2>/dev/null)   ← 必须 root、非全局可写"
  else
    say "  输出目录  : ✗ 不存在（尼尼要先 mkdir /data/local/tmp/frida_out）"
  fi

  IJ="$GOOD_DIR/frida-inject"
  if [ -f "$IJ" ]; then
    say "  frida-inject: $(stat -c '%A  %U:%G  %s 字节' "$IJ" 2>/dev/null)"
  else
    say "  frida-inject: ✗ 不存在"
  fi

  say ""
  say "  最近审计:"; tail -6 "$GOOD_DIR/audit.log" 2>/dev/null | sed 's/^/        /'
  say "  最近结果:"; head -6 "$OUT_DIR/result.txt" 2>/dev/null | sed 's/^/        /'
  exit 0
fi

# ── -k 停 ──
if [ "$MODE" = "-k" ]; then
  stop_all
  if pgrep -f "$PAT_WATCH" >/dev/null 2>&1; then
    die "没停干净，手动看：ps -A -o PID,ARGS | grep -E 'run.sh|frida-inject'"
  fi
  say "✓ 已停（窗口 + timeout + frida-inject 全部收掉，临时文件也清了）"
  exit 0
fi

# ── 前置检查（不装东西，只确认现状）──
[ -f "$RUN" ] || die "缺 $RUN —— 见文末安装步骤"
[ -f "$GOOD_DIR/frida-inject" ] || die "缺 $GOOD_DIR/frida-inject"
[ -f "$GOOD_DIR/allow.txt" ] || die "缺 $GOOD_DIR/allow.txt"

# ★v3：目录不存在就先建（不然 chown 静默失败，run.sh 报错跑偏）
if [ ! -d "$OUT_DIR" ]; then
  say "③ 输出目录不存在，试着建…"
  mkdir -p "$OUT_DIR" 2>/dev/null
  if [ ! -d "$OUT_DIR" ]; then
    die "建不了 $OUT_DIR（root 在 /data/local/tmp 下可能没写权限）—— 让尼尼先 mkdir，你再 chown"
  fi
fi
OWN=$(stat -c %U "$OUT_DIR" 2>/dev/null)
MOD=$(stat -c %a "$OUT_DIR" 2>/dev/null)
if [ "$OWN" != "root" ] || [ "$MOD" != "755" ]; then
  say "③ 修输出目录（原本 ${OWN:-未知}:${MOD:-未知}）…"
  chown root:root "$OUT_DIR" 2>/dev/null
  chmod 0755 "$OUT_DIR" 2>/dev/null
  say "   → 现在 $(stat -c '%U:%a' "$OUT_DIR" 2>/dev/null)"
  say "   （为什么是 755 而不是更严的 700：尼尼要【读】result.txt，"
  say "     它相对 root:root 是 other —— 设成 700 尼尼就看不到结果了）"
fi

stop_all
say "② 旧窗口已清"

if [ "$MODE" = "-f" ]; then
  say "③ 起窗口（前台，${SECS}s，Ctrl-C 停）"
  exec sh "$RUN" --watch "$SECS"
else
  say "③ 起窗口（后台，${SECS}s）"
  setsid sh "$RUN" --watch "$SECS" < /dev/null > /dev/null 2>&1 &
  sleep 2
  if pgrep -f "$PAT_WATCH" >/dev/null 2>&1; then
    say "   ✓ 起来了"
  else
    say "   ✗ 没起来 —— 用 -f 前台跑看报错"; exit 1
  fi
fi

say ""
say "═══════════════════════════════════════════"
say " 网关已就位。"
say " 停止: su -c 'sh $GOOD_DIR/frida.sh -k'"
say " 状态: su -c 'sh $GOOD_DIR/frida.sh -s'"
say "═══════════════════════════════════════════"
say ""
say "── 装 / 升级 run.sh（必须主人手动，且先过目）──"
say "  su -c 'cp /data/local/tmp/run.sh $GOOD_DIR/run.sh'"
say "  su -c 'chmod 700 $GOOD_DIR/run.sh; chown root:root $GOOD_DIR/run.sh'"
say "  理由：自动 cp 等于 root 去读尼尼可写的文件 —— 那就不用谈白名单了。"
