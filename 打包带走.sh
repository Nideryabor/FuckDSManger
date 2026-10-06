#!/bin/sh
# =====================================================================
#  打包带走.sh —— 把小窝「原原本本」打成可拷走的包 🐲
#
#  用法:
#     sh 打包带走.sh <目标目录>                    # 不拆卷（exFAT/NTFS/ext4 用这个）
#     sh 打包带走.sh <目标目录> --split 3500m      # 拆卷（FAT32 用这个）
#     sh 打包带走.sh <目标目录> --slim             # 精简版（去掉 out/ tmp/ 依赖缓存）
#
#  例:
#     sh 打包带走.sh /storage/ABCD-1234
#     sh 打包带走.sh /storage/ABCD-1234 --split 3500m
#
#  为什么先打包再拷（而不是直接拖文件）：
#   ① proot 的 --link2symlink 造了一批软链，直接拷到 FAT 会报「没有这个文件」
#   ② 560 个文件名含 `:`（tmp/lsp/log/ 时间戳），FAT/exFAT 拒收
#   ③ 15G / 12.8 万文件，逐个拷极慢；tar 是顺序读写，快得多
#   打进 tar 后：容器文件名干净、软链是"记录"、非法名字也不碰文件系统
# =====================================================================
set -e
cd "$(dirname "$0")"

DEST=""
SPLIT=""
SLIM=0
while [ $# -gt 0 ]; do
  case "$1" in
    --split) SPLIT="$2"; shift 2 ;;
    --slim)  SLIM=1; shift ;;
    -h|--help) sed -n '2,22p' "$0"; exit 0 ;;
    *) [ -z "$DEST" ] && DEST="$1" || { echo "多余的参数: $1"; exit 1; }; shift ;;
  esac
done

[ -n "$DEST" ] || { echo "用法: sh 打包带走.sh <目标目录> [--split 3500m] [--slim]"; exit 1; }
[ -d "$DEST" ] || { echo "✗ 目标目录不存在: $DEST"; exit 1; }
[ -w "$DEST" ] || { echo "✗ 目标目录不可写: $DEST"; exit 1; }

STAMP=$(date +%Y%m%d-%H%M)
NAME="小窝-$STAMP"
TAR="$DEST/$NAME.tar"

say() { printf '\n\033[1m== %s\033[0m\n' "$*"; }
ok()  { printf '\033[32m✓ %s\033[0m\n' "$*"; }

# ── 排除清单（都是"不应该带"或"带了会出错"的）────────────────────
EXCLUDES="
--exclude=./抓日志.sh
--exclude=./.git.broken-*
--exclude=./.l2s*
--exclude=*/.l2s*
"
if [ "$SLIM" = "1" ]; then
  EXCLUDES="$EXCLUDES
--exclude=./out
--exclude=./tmp
--exclude=./fdm-app/work
--exclude=./fdm-app/libs
--exclude=./fdm-app/libs_new
--exclude=./fdm-app/libs_extra
--exclude=./fdm-app/libs_legacy
--exclude=./fdm-app/libs_all
--exclude=./tools/node
--exclude=./tools/aapt2
--exclude=./tools/frida/py16
--exclude=./tools/frida/frida-server-*
--exclude=./tools/jvm/lib
--exclude=./tools/jvm/kotlinc
--exclude=./tools/jvm/dex-tools
"
fi

say "0. 自检"
printf '  源     : %s (大小 %s / 文件 %s)\n' "$(pwd)" "$(du -sh . 2>/dev/null | cut -f1)" "$(find . -type f 2>/dev/null | wc -l)"
printf '  目标   : %s (可用 %s)\n' "$DEST" "$(df -h "$DEST" 2>/dev/null | tail -1 | awk '{print $4}')"
printf '  模式   : %s%s\n' "$([ "$SLIM" = 1 ] && echo 精简版 || echo 完整版)" "$([ -n "$SPLIT" ] && echo " · 拆卷 $SPLIT" || echo " · 单包")"
echo "  排除   : 抓日志.sh(坏软链) · .git.broken-* · .l2s*(proot残渣)"
[ "$SLIM" = 1 ] && echo "         + out/ tmp/ 依赖缓存/ 工具链二进制/"

# 断链检查（除已知那个）
BAD=$(find . -type l ! -exec test -e {} \; -print 2>/dev/null | grep -v '^./抓日志.sh$' | wc -l)
[ "$BAD" = "0" ] || { echo "⚠️  还有 $BAD 个断链，先看一下："; find . -type l ! -exec test -e {} \; -print 2>/dev/null | grep -v '^./抓日志.sh$' | head -5; }

say "1. 打包（tar，顺序读写）"
if [ -n "$SPLIT" ]; then
  # 拆卷：先打成管道 → split
  tar -c $EXCLUDES -f - . 2>/dev/null | split -b "$SPLIT" -a 3 - "$DEST/$NAME.tar.part."
  ok "拆卷完成: $DEST/$NAME.tar.part.aaa … $(ls -1 "$DEST/$NAME.tar.part."* 2>/dev/null | tail -1 | xargs basename 2>/dev/null)"
  REAL="$DEST/$NAME.tar.part.*"
else
  tar -c $EXCLUDES -f "$TAR" . 2>/dev/null
  ok "已写出: $TAR ($(du -h "$TAR" 2>/dev/null | cut -f1))"
  REAL="$TAR"
fi

say "2. 校验"
if [ -n "$SPLIT" ]; then
  printf '  %s\n' "$(cat "$DEST/$NAME.tar.part."* 2>/dev/null | wc -c | sed 's/^/  合计字节: /')"
  echo "  ⚠️ 拆卷包要还原：cat $NAME.tar.part.* > $NAME.tar"
  ( cd "$DEST" && sha256sum "$NAME.tar.part."* > "$NAME.tar.part.sha256" ) && ok "已写 sha256: $NAME.tar.part.sha256"
else
  ( cd "$DEST" && sha256sum "$(basename "$TAR")" > "$NAME.tar.sha256" ) && ok "已写 sha256: $NAME.tar.sha256"
  printf '  包内条目: %s\n' "$(tar -tf "$TAR" 2>/dev/null | wc -l)"
fi

say "3. 附一份「怎么还原」"
cat > "$DEST/$NAME-怎么还原.md" <<EOF
# 小窝备份 · $STAMP

## 里面是什么
整个工作区「\`/workspace\`」的原样归档（**含 \`.git\` 全部历史**）。
模式：$([ "$SLIM" = 1 ] && echo "精简版（去掉了 out/ tmp/ 依赖缓存/ 工具链二进制）" || echo "完整版（原原本本）")

## 怎么还原（Linux / Android / macOS）
\`\`\`sh
# 单包
mkdir -p 小窝 && tar -xf $NAME.tar -C 小窝

# 拆卷
cat $NAME.tar.part.* > $NAME.tar
mkdir -p 小窝 && tar -xf $NAME.tar -C 小窝

# 校验
sha256sum -c $NAME.tar.sha256
\`\`\`

> ⚠️ **别在 FAT32 上直接解包**（里面有 560 个文件名含 \`:\`，还有软链）
> —— 拷进 tar 就是为了绕开这些；解包请到 Linux 文件系统（ext4/f2fs）。

## 还原后自检
\`\`\`sh
cd 小窝
git rev-parse --short HEAD     # 应为 35f2628 附近
git log --oneline | wc -l      # 272
git fsck --full                # 应无 error
\`\`\`
EOF
ok "已写: $DEST/$NAME-怎么还原.md"

say "✓ 完成"
echo "  目标: $DEST"
ls -lh "$DEST" 2>/dev/null | grep -E "$NAME|total" | sed 's/^/    /'
echo
echo "  提醒：拷完拔盘前，先 umount/sync，别直接拽 🐲"
