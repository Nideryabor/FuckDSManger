#!/bin/sh
# limcp 客户端小助手：往 8790 / 8860 这些 MCP 端口发一条工具调用
#   sh tools/limcp.sh <端口> <工具名> '<json参数>'
# 例：
#   sh tools/limcp.sh 8860 info '{}'
#   sh tools/limcp.sh 8860 views '{"maxNodes":60}'
#   sh tools/limcp.sh 8860 cls_find '{"kw":"mmkv"}'
P="${1:-8790}"
T="${2:-info}"
A="${3:-{}}"
curl -sS -m 120 -X POST "http://127.0.0.1:$P/mcp" -H 'Content-Type: application/json' \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$T\",\"arguments\":$A}}" \
  | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
except Exception as e:
    print("(非 JSON 响应)", e); sys.exit(1)
if "error" in d: print("ERR", d["error"]); sys.exit(1)
r=d.get("result",{})
c=r.get("content")
print(c[0]["text"] if c else r)'
