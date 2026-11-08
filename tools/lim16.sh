#!/bin/sh
# lim16.sh —— 调 Layout Inspect 自宿主 MCP
#   用法: sh lim16.sh <远端端口> <工具名> ['{json参数}']
#   例:   sh lim16.sh 8790 info '{}'
#         sh lim16.sh 8790 views '{"filter":"Button"}'
set -e
export PATH="$PATH:/workspace/tools/adb"
PORT="${1:-8790}"
TOOL="$2"
ARGS="${3:-{\}}"
LOCAL=$((PORT + 10000))

adb start-server >/dev/null 2>&1
adb connect 127.0.0.1:5555 >/dev/null 2>&1
S=127.0.0.1:5555
adb -s $S forward tcp:$LOCAL tcp:$PORT >/dev/null 2>&1 || true

curl -sS -m 30 -X POST "http://127.0.0.1:$LOCAL/mcp" \
  -H 'Content-Type: application/json' \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$TOOL\",\"arguments\":$ARGS}}"
