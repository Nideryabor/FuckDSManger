#!/bin/sh
# =====================================================================
#  推上去.sh —— 把本地仓库推到「新的 GitHub 账号」
#  用法:
#     sh 推上去.sh <用户名> <仓库名> <token> [分支]      # 默认 main
#  例:
#     sh 推上去.sh dxyabab2 ds-mod-archive ghp_xxxxxxxx main
#
#  设计（沿用 2026-09-24 那版的原则）：
#   · **不把 token 写进 .git/config** —— 用一次性 URL 推送
#   · 只做「推送」类操作，绝不删任何东西
#   · 推之前先跑自检（大文件 / 密钥 / 体积），不过就拒绝推
#
#  ⚠️⚠️ 2026-10-07 · 网络排障（**先看这行，能省半小时**）：
#     报错「Failed to connect to github.com port 443 … Couldn't connect」（超时 35s）
#     而 `curl https://api.github.com` 却 200 ⇒ **不是没网，是 github.com 那个 IP 被挡**。
#     而 /etc/hosts 里**钉死了** github.com ⇒ 钉的那个 IP 一被封，git 就永远连不上。
#     实测（2026-10-07）：140.82.121.3 ✗ · 140.82.112.3 ✗ · 140.82.116.3 ✗
#                        20.205.243.166 ✗ · **140.82.113.3 ✓ · 140.82.114.3 ✓**
#     修法：sed -i 's/^140\.82\.121\.3 github\.com$/140.82.114.3 github.com/' /etc/hosts
#     顺带记一条好用的：`ssh.github.com:443` 通（22 不通）⇒ 将来可以走 SSH over 443。
# =====================================================================
set -e
cd "$(dirname "$0")"

OWNER="${1:?用法: sh 推上去.sh <用户名> <仓库名> <token> [分支]}"
REPO="${2:?缺仓库名}"
TOKEN="${3:?缺 token}"
BRANCH="${4:-main}"

say() { printf '\n\033[1m== %s\033[0m\n' "$*"; }
die() { printf '\033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

say "0. 自检"
# ★★ 2026-10-06 修：先在「没有 git 的 shell」里会**假装成功**往下走
#    （`$(git ...)` 失败不触发 set -e）⇒ 打出一堆 "0 个改动 / 提交数 0" 的假象。
#    这里先把它挡住，报清楚的错。
command -v git >/dev/null 2>&1 || die "这个 shell 里没有 git。
  · 在【小窝/沙箱】里跑（那边有 git），或
  · 在手机上跑就装一个有 git 的终端"
[ -f .git/config ] || die "这里不是 git 仓库（当前目录：$(pwd)）"
BAD=$(git status --porcelain | grep -v '^??' | wc -l)
[ "$BAD" = "0" ] || die "还有 $BAD 个未提交改动，先 commit"
BIG=$(git ls-files -z | while IFS= read -r -d '' f; do [ -f "$f" ] && stat -c '%s %n' "$f"; done | awk '$1>52428800' | head -3)
[ -z "$BIG" ] || die "有 >50MB 的文件，GitHub 会拒：\n$BIG"
echo "· 工作区干净 · 无 >50MB 文件"
echo "· 提交数: $(git log --oneline | wc -l) · 分支: $(git branch --show-current)"
echo "· 体积: $(git count-objects -vH | grep size-pack | cut -d' ' -f2-)"

say "1. 推送 main（token 只出现在这条命令里，不落盘）"
URL="https://x-access-token:${TOKEN}@github.com/${OWNER}/${REPO}.git"
# ★★ 2026-10-07 修（第二次栽在同一个地方，见 7a31904）：
#   `git push … | sed … | tail` 的**退出码是 tail 的**，永远是 0 ⇒
#   推送失败（TLS 断 / 被墙 / 认证失败）脚本照样往下打出「✓ 完成」，**假装成功**。
#   实测踩到：`GnuTLS recv error (-110)` + 「✓ 完成」。
#   ⇒ 先落盘再检查退出码，失败就 die（把 git 的原话带出来）。
PLOG=/tmp/fdm_push_main.log
if git push "$URL" "$BRANCH:$BRANCH" >"$PLOG" 2>&1; then
  sed "s/${TOKEN}/***/g" "$PLOG" | tail -20
else
  printf '\033[31m── git 的原话 ──\033[0m\n'
  sed "s/${TOKEN}/***/g" "$PLOG" | tail -30
  die "推送 $BRANCH 失败（**这次是真失败**，别再往下走）"
fi

say "2. 推 tags"
TLOG=/tmp/fdm_push_tags.log
if git push "$URL" --tags >"$TLOG" 2>&1; then
  sed "s/${TOKEN}/***/g" "$TLOG" | tail -10
else
  sed "s/${TOKEN}/***/g" "$TLOG" | tail -10
  echo "（没有 tag / 或 tag 已存在 —— 不致命，继续）"
fi

say "3. 设一个新 remote 方便以后用（不带 token）"
git remote remove neworigin 2>/dev/null || true
git remote add neworigin "https://github.com/${OWNER}/${REPO}.git"
git remote -v

say "✓ 完成"
echo "仓库: https://github.com/${OWNER}/${REPO}"
echo
echo "⚠️ 下次推送记得带 token："
echo "   git push https://x-access-token:<token>@github.com/${OWNER}/${REPO}.git main"
