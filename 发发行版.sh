#!/bin/sh
# =====================================================================
#  发发行版.sh —— 建 Release + 传 APK 附件
#  用法:
#     GH_TOKEN=ghp_xxx sh 发发行版.sh <版本号> [说明文件]
#  例:
#     GH_TOKEN=ghp_xxx sh 发发行版.sh 3.50.4
#     GH_TOKEN=ghp_xxx sh 发发行版.sh 3.50.4 版本/3.50.4.md
#
#  默认:
#     · tag   = v<版本号>（指向 main 当前 HEAD）
#     · 说明  = 版本/<版本号>.md 全文
#     · 附件  = out/FDM-<版本号>-single-signed.apk   ← 单包（模块+UI+桥）
# =====================================================================
set -e
cd "$(dirname "$0")"

OWNER=Nideryabor
REPO=FuckDSManger
VER="${1:?用法: sh 发发行版.sh <版本号> [说明文件]}"
NOTES="${2:-版本/$VER.md}"
APK="out/FDM-$VER-single-signed.apk"
T="${GH_TOKEN:?请先 export GH_TOKEN=...}"

API="https://api.github.com/repos/$OWNER/$REPO"
UP="https://uploads.github.com/repos/$OWNER/$REPO/releases"
red() { sed -E "s/${T}/***TOKEN***/g"; }

[ -f "$APK" ]   || { echo "✗ 找不到 APK: $APK"; exit 1; }
[ -f "$NOTES" ] || { echo "✗ 找不到说明: $NOTES"; exit 1; }

TAG="v$VER"
NAME="FuckDSManger $VER"
SZ=$(stat -c%s "$APK")
SHA=$(sha256sum "$APK" | awk '{print $1}')

printf '== 准备发布 ==\n'
printf '  tag   : %s\n' "$TAG"
printf '  附件  : %s (%.2f MB)\n' "$APK" "$(echo "$SZ" | awk '{print $1/1048576}')"
printf '  sha256: %s\n' "$SHA"
printf '  说明  : %s (%s 字节)\n' "$NOTES" "$(stat -c%s "$NOTES")"

# —— 说明正文：md 全文 + 附件信息 ——
python3 - "$NOTES" "$APK" "$SHA" > /tmp/relbody.json <<'PY'
import json, sys, os
notes, apk, sha = sys.argv[1], sys.argv[2], sys.argv[3]
body = open(notes, encoding="utf-8").read()
body += "\n\n---\n\n## 📦 附件\n\n"
body += "| 文件 | 说明 |\n|---|---|\n"
body += "| `%s` | **单包**：模块 + UI + 桥，装这一个就够 |\n" % os.path.basename(apk)
body += "\n```\nsha256  %s\n```\n" % sha
body += "\n> 宿主：DeepSeek 客户端 2.5.2 / 2.6.1\n"
print(json.dumps({"tag_name": None, "body": body}, ensure_ascii=False))
PY
BODY=$(python3 -c 'import json,sys; print(json.load(open("/tmp/relbody.json"))["body"])' 2>/dev/null || true)

REQ=$(python3 - "$TAG" "$NAME" "$BODY" <<'PY'
import json, sys
tag, name, body = sys.argv[1], sys.argv[2], sys.argv[3]
print(json.dumps({
    "tag_name": tag, "name": name, "body": body,
    "target_commitish": "main", "draft": False, "prerelease": False,
}, ensure_ascii=False))
PY
)

printf '\n== 1. 建 Release ==\n'
RESP=$(printf '%s' "$REQ" | curl -sS -X POST "$API/releases" \
        -H "Authorization: token $T" \
        -H "Accept: application/vnd.github+json" \
        -H "Content-Type: application/json" \
        --data-binary @- 2>&1 | red)

RID=$(printf '%s' "$RESP" | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
    print(d.get("id",""))
except Exception: print("")' 2>/dev/null)

if [ -z "$RID" ]; then
  printf '✗ 建 Release 失败：\n%s\n' "$RESP" | head -c 1200
  exit 1
fi
printf '  ✓ release id=%s\n' "$RID"
printf '  URL: %s\n' "$(printf '%s' "$RESP" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("html_url",""))' 2>/dev/null)"

printf '\n== 2. 传附件 ==\n'
RESP2=$(curl -sS -X POST "$UP/$RID/assets?name=$(basename "$APK")" \
        -H "Authorization: token $T" \
        -H "Content-Type: application/octet-stream" \
        --data-binary "@$APK" 2>&1 | red)

printf '%s' "$RESP2" | python3 -c '
import json,sys
try:
    d=json.load(sys.stdin)
except Exception as e:
    print("✗ 上传响应无法解析:", e); sys.exit(1)
if "browser_download_url" in d:
    print("  ✓ %s" % d["browser_download_url"])
    print("    size: %s bytes · state: %s" % (d.get("size"), d.get("state")))
else:
    print("✗ 上传失败:", json.dumps(d, ensure_ascii=False)[:600])
    sys.exit(1)
'

printf '\n✓ 完成 → https://github.com/%s/%s/releases/tag/%s\n' "$OWNER" "$REPO" "$TAG"
