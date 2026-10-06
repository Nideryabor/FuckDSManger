#!/bin/sh
# =====================================================================
#  修邮箱.sh —— 方案 B：重写那 18 个提交的作者邮箱（PyGuy2 的终极解法）
#
#  ⚠️⚠️ 这个脚本会**重写历史**（所有后代提交的 SHA 都会变）⇒ 必须 force push。
#      只有在 `.mailmap` 不好使（GitHub 过了一天还在算 PyGuy2 头上）时才用。
#
#  用法：
#      sh 修邮箱.sh              # 只做本地重写 + 自检，不推送
#      sh 修邮箱.sh --push <token>   # 重写 + 强推（覆盖远端 main 与 tag）
#
#  重写后会失效的东西（脚本会提醒你重建）：
#      · tag v2.9.7 / v3.50.4（指向旧 SHA）
#      · Release v3.50.4（指向旧 tag）
# =====================================================================
set -e
cd "$(dirname "$0")"

OLD="noreply@example.com"
NAME="Nideryabor"
MAIL="338461957+Nideryabor@users.noreply.github.com"
DEST="https://github.com/Nideryabor/FuckDSManger.git"

say() { printf '\n\033[1m== %s\033[0m\n' "$*"; }

if [ "$1" = "--push" ] && [ -z "$2" ]; then
  echo "用法: sh 修邮箱.sh --push <token>"; exit 1
fi

say "0. 现状"
echo "  待修邮箱: $OLD"
echo "  目标身份: $NAME <$MAIL>"
echo "  命中提交:"
git log --all --author="$OLD" --format='    %h %s' | head -20
N=$(git log --all --author="$OLD" --oneline | wc -l)
echo "  共 $N 个"

say "1. 备份当前 main（万一要回滚）"
BK="backups/main-$(date +%Y%m%d-%H%M%S).bundle"
mkdir -p backups
git bundle create "$BK" --all 2>/dev/null || true
echo "  → $BK"

say "2. 重写（filter-branch）"
FILTER='
if [ "$GIT_AUTHOR_EMAIL" = "'"$OLD"'" ]; then
  export GIT_AUTHOR_NAME="'"$NAME"'"
  export GIT_AUTHOR_EMAIL="'"$MAIL"'"
fi
if [ "$GIT_COMMITTER_EMAIL" = "'"$OLD"'" ]; then
  export GIT_COMMITTER_NAME="'"$NAME"'"
  export GIT_COMMITTER_EMAIL="'"$MAIL"'"
fi
'
git filter-branch -f --env-filter "$FILTER" -- --all

say "3. 自检"
LEFT=$(git log --all --author="$OLD" --oneline | wc -l)
if [ "$LEFT" = "0" ]; then echo "  ✓ 已无 $OLD 的提交"; else echo "  ✗ 还剩 $LEFT 个，检查一下"; fi
git log --all --format='%an <%ae>' | sort -u | sed 's/^/    /'

if [ "$1" != "--push" ]; then
  say "（只做了本地重写，未推送）"
  echo "要推送就再跑:  sh 修邮箱.sh --push <token>"
  exit 0
fi

TOKEN="$2"
say "4. 强推 main + tags（token 只出现在这条命令里）"
URL="https://x-access-token:${TOKEN}@github.com/Nideryabor/FuckDSManger.git"
git push --force "$URL" main:main 2>&1 | sed -E "s/${TOKEN}/***/g"
git push --force "$URL" --tags   2>&1 | sed -E "s/${TOKEN}/***/g"

say "5. 收尾提醒"
cat <<'EOF'
  ⚠️ 远端 tag 已被强推覆盖，但 **Release 需要手动重建**（旧 Release 指向的提交已不在 main 上）：
      · 删掉旧 Release：https://github.com/Nideryabor/FuckDSManger/releases
      · 重新发：        GH_TOKEN=<token> sh 发发行版.sh 3.50.4
  · 本地 `git config user.*` 已设成规范身份（见修邮箱前的配置），以后提交不会再犯
EOF
