#!/system/bin/sh
# ============================================================================
#  deploy.sh v2 —— lspctl 网关部署 🐲
#  2026-10-24 · 尼得亚伯
#
#  v2 修掉 v1 的循环依赖：
#    v1 结尾 `rm -f $SRC_RUN $SRC_ALLOW` 把暂存源删了
#    ⇒ **第二次跑 deploy 就报「缺源文件」**
#    ⇒ 现在**默认保留源**（重跑用），只在 `-c` 时才清
#
#  用法（主人，真 su）：
#    su -c 'sh /data/local/tmp/deploy.sh'        # 部署/重跑（保留源）
#    su -c 'sh /data/local/tmp/deploy.sh -c'     # 部署 + 清源
#    su -c 'sh /data/local/tmp/deploy.sh -R'     # 只重跑 run.sh（不动 allow.txt）
#
#  为什么需要独立部署脚本：
#    run.sh 里的 PUB_DIR **只校验、不重建**。
#    原因是 run.sh 若在运行期做 rm -rf / mkdir / chown / chmod，
#    shell 用户可以在 rm 与 mkdir 之间塞一个符号链接，让 root 的
#    chown/chmod 跟随到攻击者指定路径（本地提权面）。
#    ⇒ 目录结构和权限必须在这里**一次性定死**。
# ============================================================================

set -u

MUST_DIR=/data/adb/lspctl-gw
OUT_DIR=$MUST_DIR/out
PUB_DIR=/data/local/tmp/lspctl_out
ALLOW=$MUST_DIR/allow.txt
RUN=$MUST_DIR/run.sh
LOCK=$OUT_DIR/.gw.lock
PID_FILE=$OUT_DIR/gw.pid

SRC_RUN=/data/local/tmp/lspctl_gw_run.sh
SRC_ALLOW=/data/local/tmp/lspctl_gw_allow.txt

MODE=full
case "${1:-}" in
    -c) MODE=full_clean ;;
    -R) MODE=run_only ;;
    -h|--help)
        echo "用法: sh $0 [-c|-R]"
        echo "  (无参数)  全量部署，保留源文件（可重跑）"
        echo "  -c        全量部署，成功后删除源文件"
        echo "  -R        只更新 run.sh（allow.txt 保持不动）"
        exit 0
        ;;
esac

say() { printf '%s\n' "$*"; }

say "════════════════════════════════════════"
say " lspctl 网关部署 v2 · $(date '+%m-%d %H:%M:%S')"
say "════════════════════════════════════════"

# ── 0. 必须 root ──
if [ "$(id -u)" != "0" ]; then
    say "✗ 必须以 root 运行：su -c 'sh $0'"
    exit 1
fi

# ── 0.5 网关在跑就先停（否则重建目录会让它踩空）──
if [ -d "$LOCK" ] || [ -f "$PID_FILE" ]; then
    say "⚠ 检测到网关在跑 ⇒ 先停"
    if [ -f "$PID_FILE" ]; then
        _p=$(cat "$PID_FILE" 2>/dev/null)
        [ -n "$_p" ] && kill -9 "$_p" 2>/dev/null && say "  已杀 pid $_p"
    fi
    # 顺带杀可能残留的子进程
    for _f in "$OUT_DIR/child.pid"; do
        [ -f "$_f" ] && { _c=$(cat "$_f" 2>/dev/null); [ -n "$_c" ] && kill -9 "$_c" 2>/dev/null; }
    done
    rm -rf "$LOCK" 2>/dev/null
    rm -f "$PID_FILE" "$OUT_DIR/child.pid" 2>/dev/null
    say "  已清锁"
fi

# ── 1. 源文件检查（**先查再动**，避免删了目录才发现没源）──
say "① 源文件"
if [ "$MODE" = "run_only" ]; then
    [ -f "$SRC_RUN" ] || { say "✗ 缺 $SRC_RUN"; exit 1; }
    say "  ✓ run.sh（$SRC_RUN）"
else
    MISS=0
    [ -f "$SRC_RUN" ]   || { say "✗ 缺 $SRC_RUN";   MISS=1; }
    [ -f "$SRC_ALLOW" ] || { say "✗ 缺 $SRC_ALLOW"; MISS=1; }
    if [ "$MISS" = "1" ]; then
        say ""
        say "  怎么补：在电脑/手机上重新推送，例如"
        say "    adb push run.sh   /data/local/tmp/lspctl_gw_run.sh"
        say "    adb push allow.txt /data/local/tmp/lspctl_gw_allow.txt"
        exit 1
    fi
    say "  ✓ run.sh   $(wc -c < "$SRC_RUN"   | tr -d ' ') 字节  sha256=$(sha256sum "$SRC_RUN"   | cut -c1-16)"
    say "  ✓ allow.txt $(wc -c < "$SRC_ALLOW" | tr -d ' ') 字节  sha256=$(sha256sum "$SRC_ALLOW" | cut -c1-16)"
fi

# ── 2. 主目录（root-only）──
say "② 主目录 $MUST_DIR"
mkdir -p "$OUT_DIR" 2>/dev/null || { say "✗ mkdir 失败"; exit 1; }

cp -f "$SRC_RUN" "$RUN" 2>/dev/null || { say "✗ 复制 run.sh 失败"; exit 1; }
if [ "$MODE" != "run_only" ]; then
    cp -f "$SRC_ALLOW" "$ALLOW" 2>/dev/null || { say "✗ 复制 allow.txt 失败"; exit 1; }
fi

chown -R root:root "$MUST_DIR" 2>/dev/null
chmod 0700 "$MUST_DIR" 2>/dev/null
chmod 0700 "$RUN"      2>/dev/null
[ -f "$ALLOW" ] && chmod 0600 "$ALLOW" 2>/dev/null
chmod 0700 "$OUT_DIR"  2>/dev/null

# ── 3. 对外副本目录（root 拥有 + group/other 只读）──
say "③ 副本目录 $PUB_DIR"
if [ -L "$PUB_DIR" ]; then
    say "  （发现符号链接 ⇒ 删除）"
    rm -f "$PUB_DIR" 2>/dev/null
fi
mkdir -p "$PUB_DIR" 2>/dev/null || { say "✗ mkdir 失败"; exit 1; }

chown root:root "$PUB_DIR" 2>/dev/null
chmod 0755 "$PUB_DIR"      2>/dev/null

rm -f "$PUB_DIR/result.txt" "$PUB_DIR/audit.log" 2>/dev/null

# ── 4. 自检 ──
say "④ 自检"
FAIL=0

chk_dir() {
    _p="$1"; _want="$2"; _desc="$3"
    _o=$(stat -c %U "$_p" 2>/dev/null)
    _m=$(stat -c %a "$_p" 2>/dev/null)
    _l=$( [ -L "$_p" ] && echo "SYMLINK" || echo "-" )
    if [ "$_o" = "root" ] && [ "$_m" = "$_want" ] && [ "$_l" = "-" ]; then
        say "  ✅ $_desc: root:root $_m"
    else
        say "  ✗ $_desc: 实际 ${_o:-?} ${_m:-?} $_l（期望 root $_want 非链接）"
        FAIL=1
    fi
}

chk_file() {
    _p="$1"; _want="$2"; _desc="$3"
    _o=$(stat -c %U "$_p" 2>/dev/null)
    _m=$(stat -c %a "$_p" 2>/dev/null)
    if [ "$_o" = "root" ] && [ "$_m" = "$_want" ]; then
        say "  ✅ $_desc: root:root $_m"
    else
        say "  ✗ $_desc: 实际 ${_o:-?} ${_m:-?}（期望 root $_want）"
        FAIL=1
    fi
}

chk_dir  "$MUST_DIR" 700 "主目录"
chk_file "$RUN"      700 "run.sh"
chk_file "$ALLOW"    600 "allow.txt"
chk_dir  "$OUT_DIR"  700 "权威输出"
chk_dir  "$PUB_DIR"  755 "对外副本"

if command -v lspctl >/dev/null 2>&1; then
    say "  ✅ lspctl: $(command -v lspctl)"
else
    say "  ⚠ lspctl 不在 PATH（LSPosed 2.2.0+ 才有）"
fi

# ── 5. 源文件处理 ──
if [ "$MODE" = "full_clean" ]; then
    say "⑤ 清理源文件（-c）"
    rm -f "$SRC_RUN" "$SRC_ALLOW" 2>/dev/null
    say "  已删 /data/local/tmp/lspctl_gw_*"
else
    say "⑤ 源文件保留（可重跑；要清就加 -c）"
fi

say ""
if [ "$FAIL" = "0" ]; then
    say "════════════════════════════════════════"
    say " ✅ 部署完成"
    say "════════════════════════════════════════"
    say ""
    say "起网关："
    say "  su -c 'sh $RUN'        # 后台（30 分钟空闲自动退）"
    say "  su -c 'sh $RUN -f'     # 前台"
    say "  su -c 'sh $RUN -s'     # 状态"
    say "  su -c 'sh $RUN -k'     # 停"
else
    say "✗ 自检有失败项，先修再起"
    exit 1
fi
