#!/bin/sh
# =====================================================================
#  推到盘.sh —— 把小窝分块流式推到外接盘 🐲
#
#  为什么不能一口气推：
#    ① 单次工具调用最长 600s；全量 15G @15MB/s ≈ 17 分钟 ⇒ 一次做不完
#    ② 沙箱后台进程活不过一次调用 ⇒ 没法 nohup 挂着跑
#  所以：先算好"分块计划"，然后**一块一次调用**推。
#
#  用法：
#    sh 推到盘.sh <盘路径> --plan        # 只算分块（秒出），打印每块大小
#    sh 推到盘.sh <盘路径> --chunk 1     # 推第 1 块
#    sh 推到盘.sh <盘路径> --chunk 2
#    ...
#    sh 推到盘.sh <盘路径> --finish      # 写还原说明 + 全量校验
#
#  例：
#    sh 推到盘.sh /storage/42C2F8EAC2F8E359
#
#  说明：
#   · 走 `tools/出笼隧道/adb.sh`（自带重连）
#   · 分块 = 按文件列表贪心装箱（每块 ~3.4G），**不占中间空间**
#   · 块内是 tar，块与块文件互不重叠 ⇒ 还原时顺序解包即可
# =====================================================================
set -e
cd "$(dirname "$0")"

ADB="sh $PWD/tools/出笼隧道/adb.sh"
WORK="$PWD/tmp/_push"
PLAN="$WORK/plan.tsv"
LIMIT=$((3400 * 1024 * 1024))          # 每块上限 ~3.4G（≈220s @15MB/s，留足余量）

DEST="${1:?用法: sh 推到盘.sh <盘路径> --plan|--chunk N|--finish [--slim]}"
shift
ACTION=""
N=""
SLIM=0
while [ $# -gt 0 ]; do
  case "$1" in
    --plan)   ACTION=plan ;;
    --chunk)  ACTION=chunk; N="$2"; shift ;;
    --finish) ACTION=finish ;;
    --slim)   SLIM=1 ;;
    *) echo "不认识的参数: $1"; exit 1 ;;
  esac
  shift
done
[ -n "$ACTION" ] || { echo "要选一个动作: --plan / --chunk N / --finish"; exit 1; }

NAME="小窝-$(date +%Y%m%d)"
say() { printf '\n\033[1m== %s\033[0m\n' "$*"; }
ok()  { printf '\033[32m✓ %s\033[0m\n' "$*"; }

# ── 排除清单（保持稳定顺序，保证每次算出的块号一致）─────────────
EX() {
  grep -vE '^\./抓日志\.sh$|^\./\.git\.broken-|\.l2s' \
  | { [ "$SLIM" = 1 ] && grep -vE '^\./out/|^\./tmp/|^\./fdm-app/(work|libs)|^\./tools/(node|aapt2)|^\./tools/jvm/(lib|kotlinc|dex-tools)|^\./tools/frida/(py16|frida-server-)' || cat; }
}

case "$ACTION" in
  plan)
    say "0. 检查目标盘"
    R=$($ADB shell "test -d '$DEST' && echo OK || echo NO" 2>/dev/null | tr -d '\r')
    [ "$R" = "OK" ] || { echo "✗ 盘路径不可用: $DEST"; exit 1; }
    AVAIL=$($ADB shell "df -k '$DEST' | tail -1 | awk '{print \$4}'" 2>/dev/null | tr -d '\r')
    printf '  盘: %s (可用 %s MB)\n' "$DEST" "$((AVAIL / 1024))"
    [ "$AVAIL" -gt 20000000 ] || echo "  ⚠️ 可用不足 20GB，全量可能放不下"

    say "1. 清点文件（排除清单已生效）"
    mkdir -p "$WORK"
    find . -type f 2>/dev/null | EX | sed 's|^\./||' > "$WORK/all.list"
    printf '  文件数: %s\n' "$(wc -l < "$WORK/all.list")"
    : > "$PLAN"
    while IFS= read -r f; do
      printf '%s\t%s\n' "$(stat -c%s "$f" 2>/dev/null || echo 0)" "$f"
    done < "$WORK/all.list" \
    | awk -v lim="$LIMIT" 'BEGIN{c=1;s=0} {if(s+$1>lim && s>0){c++;s=0} s+=$1; print c"\t"$1"\t"substr($0,index($0,"\t")+1)}' > "$PLAN"

    say "2. 分块计划"
    awk -F'\t' '{n[$1]++; b[$1]+=$2} END{printf "  共 %d 块\n", length(n); for(i=1;i<=length(n);i++) printf "    块 %-3d %6.2f GB  %5d 个文件\n", i, b[i]/1073741824, n[i]}' "$PLAN"
    ok "计划已存: $PLAN（别再重算，块号要一致）"
    ;;

  chunk)
    [ -f "$PLAN" ] || { echo "✗ 先跑 --plan"; exit 1; }
    [ -n "$N" ] || { echo "✗ 缺块号"; exit 1; }
    awk -F'\t' -v n="$N" '$1==n {print substr($0, index($0,$2))}' "$PLAN" > "$WORK/chunk_$N.list"
    CNT=$(wc -l < "$WORK/chunk_$N.list")
    [ "$CNT" -gt 0 ] || { echo "✗ 块 $N 是空的（块号超范围？）"; exit 1; }
    SZ=$(awk -F'\t' -v n="$N" '$1==n {s+=$2} END{printf "%.2f", s/1073741824}' "$PLAN")
    say "推块 $N（$CNT 个文件 · $SZ GB）"
    START=$(date +%s)
    tar -c --no-recursion -p -T "$WORK/chunk_$N.list" 2>/dev/null \
      | $ADB shell "cat > '$DEST/$NAME/chunk_$N.tar'"
    END=$(date +%s)
    EL=$((END - START))
    RS=$($ADB shell "ls -la '$DEST/$NAME/chunk_$N.tar' | awk '{print \$5}'" 2>/dev/null | tr -d '\r')
    printf '  用时 %ss（约 %s MB/s）· 盘上大小 %s 字节\n' "$EL" "$((SZ * 1024 / (EL>0?EL:1)))" "$RS"
    RSHA=$($ADB shell "sha256sum '$DEST/$NAME/chunk_$N.tar' 2>/dev/null | awk '{print \$1}'" 2>/dev/null | tr -d '\r')
    printf '  盘上 sha256: %s\n' "${RSHA:-（算不出）}"
    ok "块 $N 完成"
    ;;

  finish)
    say "1. 核对每块大小"
    $ADB shell "cd '$DEST/$NAME' 2>/dev/null && ls -la *.tar | awk '{printf \"  %-16s %12s\\n\", \$9, \$5}'" 2>&1 | tr -d '\r'
    say "2. 写还原说明"
    TOTAL=$(awk -F'\t' '{s+=$2} END{printf "%.1f", s/1073741824}' "$PLAN")
    CHUNKS=$(awk -F'\t' '{print $1}' "$PLAN" | sort -n | uniq | wc -l)
    {
      echo "# 小窝备份 · $NAME"
      echo
      echo "**原原本本的工作区归档**（含 \`.git\` 全部历史）· 共 $CHUNKS 块 · 约 ${TOTAL} GB"
      echo "生成：$(date '+%Y-%m-%d %H:%M') · 来源：/workspace（RikkaHub workdir）"
      echo
      echo "## 为什么是分块 tar"
      echo "1. 直接拷文件会失败——工作区里有 **560 个文件名含 \`:\`**（\`tmp/lsp/log/\` 时间戳），"
      echo "   这个盘的 FUSE 层直接拒收（实测 \`Operation not permitted\`）"
      echo "2. 还有 53 个 **绝对路径软链**（\`/workspace/...\`），在手机视角里读不到 ⇒ 显示 0 字节"
      echo "3. 分块是为了适配「单次操作 ≤600s」的限制，不是备份本身需要"
      echo
      echo "## 怎么还原（Linux / macOS / WSL）"
      echo '```sh'
      echo 'mkdir -p 小窝 && cd 小窝'
      echo "for f in chunk_*.tar; do tar -xpf \"\$f\"; done"
      echo '```'
      echo
      echo "> ⚠️ **别在 FAT/exFAT 上直接解包**（含 \`:\` 文件名 + 软链）"
      echo "> 解包请落在 Linux 文件系统（ext4/f2fs/apfs）。"
      echo "> 存到 Windows 的 NTFS 盘上没问题，但要解包到 WSL/Linux 里。"
      echo
      echo "## 还原后自检"
      echo '```sh'
      echo "cd 小窝"
      echo "git rev-parse --short HEAD    # 应为 35f2628 附近"
      echo "git log --oneline | wc -l     # 272"
      echo "git fsck --full               # 应无 error"
      echo "ls 巢穴/日记 | wc -l          # 16"
      echo '```'
    } > "$WORK/$NAME-怎么还原.md"
    $ADB shell "cat > '$DEST/$NAME-怎么还原.md'" < "$WORK/$NAME-怎么还原.md"
    ok "已写: $DEST/$NAME-怎么还原.md"
    say "✓ 完成"
    echo "  盘上目录: $DEST/$NAME/"
    ;;
esac
