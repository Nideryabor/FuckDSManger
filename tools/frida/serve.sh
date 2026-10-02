#!/bin/sh
# frida-mcp 的 HTTP 服务启停 🐲
#   sh serve.sh start [端口]   # 默认 8788（8787 被 MT 的 apk MCP 占了，3001 是 wechat）
#   sh serve.sh stop
#   sh serve.sh status
PORT_DEFAULT=8788
HERE=$(cd "$(dirname "$0")" && pwd)
LOG=/workspace/tmp/frida-mcp.log
PIDF=/workspace/tmp/frida-mcp.pid

case "${1:-start}" in
  start)
    P="${2:-$PORT_DEFAULT}"
    if [ -f "$PIDF" ] && kill -0 "$(cat $PIDF)" 2>/dev/null; then
      echo "已在跑 (pid $(cat $PIDF))"; exit 0
    fi
    mkdir -p /workspace/tmp
    nohup python3 "$HERE/mcp_server.py" --http "$P" > "$LOG" 2>&1 &
    echo $! > "$PIDF"
    sleep 2
    if curl -sS -m 5 -X POST "http://127.0.0.1:$P/mcp" -H 'Content-Type: application/json' \
         -d '{"jsonrpc":"2.0","id":1,"method":"ping"}' >/dev/null 2>&1; then
      echo "✓ 起来了 · http://127.0.0.1:$P/mcp · pid $(cat $PIDF)"
    else
      echo "✗ 起不来，日志："; tail -5 "$LOG"
    fi
    ;;
  stop)
    [ -f "$PIDF" ] && kill "$(cat $PIDF)" 2>/dev/null && rm -f "$PIDF"
    pkill -f "mcp_server.py --http" 2>/dev/null
    echo "✓ 已停"
    ;;
  status)
    if [ -f "$PIDF" ] && kill -0 "$(cat $PIDF)" 2>/dev/null; then
      echo "✓ 在跑 pid $(cat $PIDF)"
      curl -sS -m 5 -X POST http://127.0.0.1:${2:-$PORT_DEFAULT}/mcp \
        -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' \
        | head -c 200
    else
      echo "✗ 没在跑"
    fi
    ;;
esac
