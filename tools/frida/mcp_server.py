#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
frida-mcp —— 把 Frida 包成 MCP server 🐲（stdio / JSON-RPC 2.0）

设计原则（很重要）：
  1. **只读纪律**：除了「启动已经存在于设备上的 frida-server」，本服务**不往设备写任何东西**。
     二进制需要由主人一次性放好（见 frida_up 的报错提示）。
  2. **会话常驻**：同一个 target 的 attach 会被缓存，后续 eval 复用 ⇒ 秒级迭代。
  3. **超时 + 截断**：脚本可能挂住、输出可能巨大，两边都要兜住，不能把调用方拖死。
  4. **失败要说人话**：把设备上的真实报错原样带回去（含踩坑提示），不要吞。

启动：
    python3 mcp_server.py            # stdio，给 MCP host 用

MCP host 配置（示例）：
    {
      "mcpServers": {
        "frida": {
          "command": "python3",
          "args": ["/workspace/tools/frida/mcp_server.py"]
        }
      }
    }
"""
import json
import os
import subprocess
import sys
import threading
import time
import traceback

HERE = os.path.dirname(os.path.abspath(__file__))
FRIDA_PORT = 27042
DEV_BIN = "/data/adb/frida-server"
HOST_PKG = "com.deepseek.chat.a"
SNAP_SRC = "/data/data/%s/files/fdm-snap.png" % HOST_PKG

MAX_TEXT = 20000          # 回给调用方的单条文本上限
ADB_TIMEOUT = 60
RUN_TIMEOUT = 30          # 一段 JS 最长跑多久
KEEP_SESSION = True       # 会话常驻

# ────────────────────────────── 基础工具 ──────────────────────────────

def sh(args, timeout=ADB_TIMEOUT):
    """跑一条命令，返回 (rc, stdout, stderr)。"""
    try:
        p = subprocess.run(args, capture_output=True, timeout=timeout)
        return p.returncode, p.stdout.decode("utf-8", "replace"), p.stderr.decode("utf-8", "replace")
    except subprocess.TimeoutExpired:
        return 124, "", "命令超时（%ss）：%s" % (timeout, " ".join(args))
    except Exception as exc:                       # noqa: BLE001
        return 125, "", "执行异常：%s" % exc


def adb(args, timeout=ADB_TIMEOUT):
    return sh(["adb"] + args, timeout)


def adb_wait(tries=30):
    """adb daemon 会自己死 ⇒ 重启 + 等 device。"""
    adb(["kill-server"], 20)
    adb(["start-server"], 20)
    for _ in range(tries):
        rc, out, _ = adb(["get-state"], 10)
        if rc == 0 and out.strip() == "device":
            return True
        time.sleep(1)
    return False


_SU = None


def su_prefix():
    """这台设备是 `su 0`（KernelSU），不一定是 `su -c`。自动探测一次并记住。"""
    global _SU
    if _SU:
        return _SU
    for cand in (["su", "0", "id"], ["su", "-c", "id"]):
        rc, out, _ = adb(["shell"] + cand, 15)
        if rc == 0 and "uid=0" in out:
            _SU = ["su", "0"] if cand[1] == "0" else ["su", "-c"]
            return _SU
    return ["su", "0"]


def su_sh(cmd, timeout=ADB_TIMEOUT):
    """以 root 跑一段 shell。"""
    pre = su_prefix()
    if pre == ["su", "0"]:
        return adb(["shell"] + pre + ["sh", "-c", cmd], timeout)
    return adb(["shell", "su", "-c", cmd], timeout)


def clip(s):
    if s is None:
        return ""
    s = s.rstrip()
    if len(s) > MAX_TEXT:
        return s[:MAX_TEXT] + "\n…[截断，共 %d 字符]" % len(s)
    return s


# ────────────────────────────── Frida 会话 ──────────────────────────────

_sessions = {}          # target -> (device, session)
_lock = threading.Lock()


def _device():
    import frida
    return frida.get_device_manager().add_remote_device("127.0.0.1:%d" % FRIDA_PORT)


def _resolve_pid(device, target):
    try:
        return int(target)
    except ValueError:
        pass
    for p in device.enumerate_processes():
        if p.name == target:
            return p.pid
    return None


def _session_for(target, force_new=False):
    """拿一个（可能缓存的）session。"""
    import frida
    with _lock:
        if not force_new and KEEP_SESSION and target in _sessions:
            dev, sess = _sessions[target]
            try:
                _ = sess.enumerate_scripts()      # 探活
                return dev, sess
            except Exception:                     # noqa: BLE001
                _sessions.pop(target, None)
        dev = _device()
        pid = _resolve_pid(dev, target)
        if pid is None:
            raise RuntimeError("找不到进程 %s（先把它拉起来；或者用 frida_ps 看看名字）" % target)
        sess = dev.attach(pid)
        if KEEP_SESSION:
            _sessions[target] = (dev, sess)
        return dev, sess


_BOOTSTRAP = r"""
var __emit = function (s) { send(String(s)); };
var __log = function () {
  var parts = [];
  for (var i = 0; i < arguments.length; i++) {
    var x = arguments[i];
    try { parts.push((typeof x === 'object' && x !== null) ? JSON.stringify(x) : String(x)); }
    catch (e) { parts.push(String(x)); }
  }
  __emit(parts.join(' '));
};
rpc.exports = {
  run: function (src) {
    try { (new Function('log', src))( __log ); return 'OK'; }
    catch (e) { return 'ERR: ' + (e && e.stack ? e.stack : e); }
  }
};
"""


def frida_run(target, js):
    """attach（或复用）+ 跑一段 JS，返回打印出来的文本。"""
    lines = []
    sess = None
    try:
        dev, sess = _session_for(target)
        script = sess.create_script(_BOOTSTRAP)

        def on_message(msg, data):
            if msg.get("type") == "send":
                lines.append(str(msg.get("payload")))
            elif msg.get("type") == "error":
                lines.append("[script-error] %s" % (msg.get("stack") or msg.get("description")))

        script.on("message", on_message)
        script.load()
        res = script.exports_sync.run(js)
        head = "[frida] %s" % res
        return head + ("\n" + "\n".join(lines) if lines else "")
    except Exception as exc:                       # noqa: BLE001
        if KEEP_SESSION:
            with _lock:
                _sessions.pop(target, None)
        return "✗ %s\n%s" % (exc, traceback.format_exc(limit=3))


# ────────────────────────────── MCP tools ──────────────────────────────

def t_up(_):
    if not adb_wait():
        return "✗ 等不到设备（adb get-state 不是 device）"
    rc, out, _ = su_sh("test -x %s && echo YES" % DEV_BIN, 20)
    if "YES" not in out:
        return ("✗ 设备上还没有 frida-server。\n"
                "  主人一次性放一下（我不往设备写文件）：\n"
                "    adb push %s/frida-server-17.19.0-arm64 /data/local/tmp/fs\n"
                "    %s cp /data/local/tmp/fs %s && %s chmod 755 %s\n"
                "    chmod 777 /data/local/tmp      # 否则 helper dex 写不进去\n"
                % (HERE, "su 0", DEV_BIN, "su 0", DEV_BIN))
    su_sh("killall frida-server", 15)
    time.sleep(1)
    su_sh("TMPDIR=/data/adb nohup %s -D -d /data/adb >/data/adb/fs.log 2>&1 &" % DEV_BIN, 20)
    time.sleep(4)
    rc, out, _ = su_sh("ps -A | grep -c frida-server", 20)
    if not out.strip() or out.strip() == "0":
        rc2, log, _ = su_sh("cat /data/adb/fs.log", 20)
        return "✗ frida-server 没起来：\n%s" % clip(log)
    adb(["forward", "tcp:%d" % FRIDA_PORT, "tcp:%d" % FRIDA_PORT], 20)
    time.sleep(1)
    try:
        pids = [p.name for p in _device().enumerate_processes()]
        return "✓ 起来了 · 端口转发 OK · 看到 %d 个进程" % len(pids)
    except Exception as exc:                       # noqa: BLE001
        return ("✗ 服务在跑但连不上：%s\n"
                "  如果报 frida-helper-*.dex: Permission denied ⇒\n"
                "    在自己的 root 里执行： chmod 777 /data/local/tmp\n"
                "    （不要 setenforce 0 —— 我试过，没用）" % exc)


def t_down(_):
    adb_wait()
    su_sh("killall frida-server", 15)
    adb(["forward", "--remove-all"], 15)
    with _lock:
        _sessions.clear()
    return "✓ 已停 + 端口已撤（二进制留在 %s）" % DEV_BIN


def t_status(_):
    if not adb_wait():
        return "✗ 设备不在线"
    rc, abi, _ = adb(["shell", "getprop ro.product.cpu.abi"], 15)
    rc, sdk, _ = adb(["shell", "getprop ro.build.version.sdk"], 15)
    rc, ps, _ = su_sh("ps -A | grep -c frida-server", 20)
    rc, fw, _ = adb(["forward", "--list"], 15)
    conn = "—"
    try:
        conn = "✓ %d 个进程" % len(_device().enumerate_processes())
    except Exception as exc:                       # noqa: BLE001
        conn = "✗ %s" % exc
    return ("设备 %s / API %s\nfrida-server 进程数: %s\n端口: %s\n连接: %s"
            % (abi.strip(), sdk.strip(), ps.strip(), clip(fw) or "（无）", conn))


def t_ps(_):
    try:
        dev = _device()
        return "\n".join("%-8s %s" % (p.pid, p.name) for p in dev.enumerate_processes())
    except Exception as exc:                       # noqa: BLE001
        return "✗ %s（服务没起？先 frida_up）" % exc


def t_eval(a):
    target = a.get("target") or HOST_PKG
    js = a.get("js") or ""
    if not js.strip():
        return "✗ 缺 js"
    return clip(frida_run(target, js))


def t_classes(a):
    target = a.get("target") or HOST_PKG
    pattern = a.get("pattern") or "."
    limit = int(a.get("limit") or 300)
    js = """
    var re = new RegExp(%s);
    var n = 0, out = [];
    Java.enumerateLoadedClassesSync().forEach(function (c) {
      if (re.test(c)) { n++; if (out.length < %d) out.push(c); }
    });
    log("命中 " + n + " 个（最多列 %d）：");
    out.forEach(function (c) { log(c); });
    """ % (json.dumps(pattern), limit, limit)
    return clip(frida_run(target, js))


def t_instances(a):
    target = a.get("target") or HOST_PKG
    cls = a.get("cls") or ""
    limit = int(a.get("limit") or 20)
    if not cls:
        return "✗ 缺 cls"
    js = """
    Java.perform(function () {
      var n = 0;
      try {
        Java.choose(%s, {
          onMatch: function (inst) { n++; if (n <= %d) log("#" + n + " " + inst); },
          onComplete: function () { log("一共 " + n + " 个实例"); }
        });
      } catch (e) { log("choose 失败：" + e); }
    });
    """ % (json.dumps(cls), limit)
    return clip(frida_run(target, js))


def t_selfshot(a):
    out = a.get("out") or "/workspace/tmp/shots/snap.png"
    if not adb_wait():
        return "✗ 等不到设备"
    adb(["shell", "am", "start", "-n", "%s/com.deepseek.chat.MainActivity" % HOST_PKG], 20)
    time.sleep(4)
    adb(["shell", "am", "broadcast", "-a", "com.little_femaleboy.fdm.CMD",
         "--es", "cmd", "glass_snap"], 20)
    time.sleep(4)
    os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
    pre = su_prefix()
    # ⚠️ 必须走 bytes：PNG 用文本模式读会被 utf-8 解码毁掉（我自己先踩了一次）
    if pre == ["su", "0"]:
        argv = ["adb", "exec-out", "su", "0", "cat", SNAP_SRC]
    else:
        argv = ["adb", "exec-out", "su", "-c", "cat %s" % SNAP_SRC]
    try:
        p = subprocess.run(argv, capture_output=True, timeout=90)
    except Exception as exc:                       # noqa: BLE001
        return "✗ 自拍拉取异常：%s" % exc
    data = p.stdout or b""
    if len(data) < 1000 or not data[:8] == b"\x89PNG\r\n\x1a\n":
        return ("✗ 自拍没拉到合法 PNG（%d B）stderr=%s\n"
                "  宿主这个版本带自拍功能吗？先 %s 一次再看日志 【GmGlass】自拍"
                % (len(data), clip(p.stderr.decode("utf-8", "replace")), "glass_snap"))
    with open(out, "wb") as fh:
        fh.write(data)
    return "✓ 已存到 %s（%d B）" % (out, os.path.getsize(out))


TOOLS = [
    ("frida_up", "启动设备上的 frida-server + 端口转发 + 自检（不往设备写任何文件）", {}, t_up),
    ("frida_down", "停 frida-server + 撤端口转发", {}, t_down),
    ("frida_status", "看设备/服务/连接状态", {}, t_status),
    ("frida_ps", "列设备进程（找宿主 pid/名字）", {}, t_ps),
    ("frida_eval", "★ 挂上目标进程跑一段 JS，回传 log()/send() 的输出（会话常驻，秒级）",
     {"target": "包名或 pid，默认 com.deepseek.chat.a", "js": "要跑的 JS"}, t_eval),
    ("frida_classes", "按正则列运行时真实加载的类（不用再猜混淆名了）",
     {"target": "包名/pid", "pattern": "正则", "limit": "最多列几个"}, t_classes),
    ("frida_find_instances", "拿某个类的活对象（Java.choose），最多列 limit 个",
     {"target": "包名/pid", "cls": "完整类名", "limit": "最多几个"}, t_instances),
    ("frida_selfshot", "让宿主自拍当前画面并拉到本地（我的眼睛；只读，不写设备）",
     {"out": "本地保存路径"}, t_selfshot),
]


def tools_list():
    out = []
    for name, desc, props, _fn in TOOLS:
        schema = {"type": "object", "properties": {}}
        for k, v in props.items():
            schema["properties"][k] = {"type": "string", "description": v}
        out.append({"name": name, "description": desc, "inputSchema": schema})
    return out


def call_tool(name, args):
    for n, _d, _p, fn in TOOLS:
        if n == name:
            try:
                return fn(args or {})
            except Exception:                      # noqa: BLE001
                return "✗ 内部异常：\n%s" % traceback.format_exc(limit=5)
    return "✗ 未知工具 %s" % name


# ────────────────────────────── MCP stdio 循环 ──────────────────────────────

def send(obj):
    sys.stdout.write(json.dumps(obj, ensure_ascii=False) + "\n")
    sys.stdout.flush()


# ────────────────────── HTTP（streamable_http）模式 ──────────────────────
#
# ★ 为什么必须有这个：RikkaHub 的 MCP 配置里只有 `streamable_http`（实测三个：
#   apk=http://127.0.0.1:8787/mcp · wechat=http://127.0.0.1:3001/mcp ·
#   github=https://api.githubcopilot.com/mcp/），**没有 stdio**。
#   而且实测：从沙箱 curl 127.0.0.1:8787/mcp 能直接打通 ⇒ 沙箱与 RikkaHub 共用一个 localhost。
#   所以只要在这里绑一个 127.0.0.1 端口，RikkaHub 就能连上。
#
# 规格（对齐 MCP 2025-06-18 的 streamable HTTP）：
#   POST /mcp   → JSON-RPC，回 application/json（官方客户端接受普通 JSON）
#   GET  /mcp   → 405（我们不做 SSE 推送）
#   DELETE /mcp → 200（会话终止）
#   通知（无 id）→ 202 Accepted，空体

def _handle_rpc(req):
    """处理一条（或一批）JSON-RPC，返回 (result_obj 或 None, is_notification)。"""
    mid = req.get("id")
    method = req.get("method")
    params = req.get("params") or {}

    if method == "initialize":
        return {"jsonrpc": "2.0", "id": mid, "result": {
            "protocolVersion": params.get("protocolVersion") or "2025-06-18",
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "frida-mcp", "version": "1.0.0"},
        }}, False
    if method in ("notifications/initialized", "initialized",
                  "notifications/cancelled", "notifications/progress"):
        return None, True
    if method == "tools/list":
        return {"jsonrpc": "2.0", "id": mid, "result": {"tools": tools_list()}}, False
    if method == "tools/call":
        text = call_tool(params.get("name"), params.get("arguments") or {})
        return {"jsonrpc": "2.0", "id": mid, "result": {
            "content": [{"type": "text", "text": text}],
            "isError": text.startswith("✗"),
        }}, False
    if method == "ping":
        return {"jsonrpc": "2.0", "id": mid, "result": {}}, False
    if mid is None:
        return None, True
    return {"jsonrpc": "2.0", "id": mid,
            "error": {"code": -32601, "message": "method not found: %s" % method}}, False


def serve_http(port):
    from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

    class H(BaseHTTPRequestHandler):
        protocol_version = "HTTP/1.1"

        def _send(self, code, obj=None, extra=None):
            body = b"" if obj is None else json.dumps(obj, ensure_ascii=False).encode("utf-8")
            self.send_response(code)
            if body:
                self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            for k, v in (extra or {}).items():
                self.send_header(k, v)
            self.end_headers()
            if body:
                self.wfile.write(body)

        def do_POST(self):
            try:
                n = int(self.headers.get("Content-Length") or 0)
                raw = self.rfile.read(n) if n else b""
                msg = json.loads(raw.decode("utf-8")) if raw else {}
            except Exception:                      # noqa: BLE001
                return self._send(400, {"jsonrpc": "2.0", "id": None,
                                        "error": {"code": -32700, "message": "parse error"}})
            try:
                if isinstance(msg, list):          # 批量
                    out = []
                    for one in msg:
                        res, note = _handle_rpc(one)
                        if not note and res:
                            out.append(res)
                    return self._send(200, out or None)
                res, note = _handle_rpc(msg)
                if note:
                    return self._send(202, None)
                return self._send(200, res)
            except Exception:                      # noqa: BLE001
                return self._send(500, {"jsonrpc": "2.0", "id": msg.get("id"),
                                        "error": {"code": -32603,
                                                  "message": traceback.format_exc(limit=3)}})

        def do_GET(self):
            self._send(405, {"jsonrpc": "2.0", "id": None,
                             "error": {"code": -32601, "message": "SSE not supported"}})

        def do_DELETE(self):
            with _lock:
                _sessions.clear()
            self._send(200, {"ok": True})

        def log_message(self, fmt, *args):         # 别刷屏
            sys.stderr.write("[mcp-http] %s\n" % (fmt % args))
            sys.stderr.flush()

    srv = ThreadingHTTPServer(("127.0.0.1", port), H)
    sys.stderr.write("[mcp-http] listening on http://127.0.0.1:%d/mcp\n" % port)
    sys.stderr.flush()
    srv.serve_forever()


def main():
    if len(sys.argv) >= 3 and sys.argv[1] == "--http":
        return serve_http(int(sys.argv[2]))

    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
        except Exception:                          # noqa: BLE001
            continue
        mid = req.get("id")
        method = req.get("method")
        params = req.get("params") or {}

        if method == "initialize":
            send({"jsonrpc": "2.0", "id": mid, "result": {
                "protocolVersion": params.get("protocolVersion") or "2024-11-05",
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "frida-mcp", "version": "1.0.0"},
            }})
        elif method in ("notifications/initialized", "initialized"):
            continue
        elif method == "tools/list":
            send({"jsonrpc": "2.0", "id": mid, "result": {"tools": tools_list()}})
        elif method == "tools/call":
            name = params.get("name")
            args = params.get("arguments") or {}
            text = call_tool(name, args)
            send({"jsonrpc": "2.0", "id": mid, "result": {
                "content": [{"type": "text", "text": text}],
                "isError": text.startswith("✗"),
            }})
        elif method == "ping":
            send({"jsonrpc": "2.0", "id": mid, "result": {}})
        elif mid is not None:
            send({"jsonrpc": "2.0", "id": mid,
                  "error": {"code": -32601, "message": "method not found: %s" % method}})


if __name__ == "__main__":
    main()
