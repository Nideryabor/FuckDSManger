#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dev-mcp —— 把「adb 直连手机」包成 MCP server 🐲（streamable_http / JSON-RPC 2.0）

给谁用：尼得亚伯自己（AI）。主人只负责看。
干什么：让我能**看着手机屏幕 + 动手点**，从而驱动任何 App（尤其是只能手点的黑盒工具，
        比如 Layout Inspect 的悬浮窗菜单）。

设计原则：
  1. **只读优先**：默认动作都是"看"；"点/输入"这类写动作单独命名，一眼能认出来。
  2. **不碰系统开关**：不 setenforce、不 stop/start、不动 zygote（有血的教训）。
  3. **非 root**：全部走 adb 普通权限；需要 root 的地方明确报 "NOSU" 而不是瞎试。
  4. **超时兜底**：每条命令都有 timeout，设备掉线不会把调用方拖死。

启动：
    python3 mcp_server.py --http 8789
    （8787=MT的apk MCP · 8788=frida MCP · 3001=wechat · 8789=本服务）
"""
import json
import os
import re
import subprocess
import sys
import time
import traceback
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
SHOT_DIR = "/workspace/tmp/devshots"
DUMP_XML = "/workspace/tmp/devshots/ui.xml"

MAX_TEXT = 30000
ADB_TIMEOUT = 60

# ────────────────────────────── adb 基础 ──────────────────────────────

_SERIAL = None


def _candidates():
    return ["127.0.0.1:5555", "192.168.1.5:5555", "emulator-5554"]


def _adb_raw(args, timeout=ADB_TIMEOUT):
    try:
        p = subprocess.run(["adb"] + args, capture_output=True, timeout=timeout)
        return p.returncode, p.stdout.decode("utf-8", "replace"), p.stderr.decode("utf-8", "replace")
    except subprocess.TimeoutExpired:
        return 124, "", "adb 超时（%ss）：%s" % (timeout, " ".join(args))
    except Exception as exc:                                    # noqa: BLE001
        return 125, "", "adb 异常：%s" % exc


def serial():
    """认设备：优先 127.0.0.1:5555，其次第一个 device 状态的。"""
    global _SERIAL
    if _SERIAL:
        rc, out, _ = _adb_raw(["-s", _SERIAL, "shell", "echo", "ok"], 15)
        if rc == 0 and "ok" in out:
            return _SERIAL
        _SERIAL = None
    rc, out, _ = _adb_raw(["devices"], 20)
    online = [l.split("\t")[0] for l in out.splitlines()
              if l.strip().endswith("device") and "\t" in l]
    if not online:
        raise RuntimeError("没有在线设备（adb devices）")
    for c in _candidates():
        if c in online:
            _SERIAL = c
            return _SERIAL
    _SERIAL = online[0]
    return _SERIAL


def dev(args, timeout=ADB_TIMEOUT):
    """跑一条 adb shell 命令（非 root）。"""
    return _adb_raw(["-s", serial(), "shell"] + args, timeout)


def sh(cmd, timeout=ADB_TIMEOUT):
    """跑一段 shell 字符串。

    ⚠️ 必须把整条命令当【一个参数】给 `adb shell`：
       adb 会把 argv 用空格拼起来再交给设备端 shell，多参数会被重新拆词
       （踩过：`sh -c 'getprop ro.product.model'` 变成 `getprop`，把全表倒出来 134KB）。
    """
    rc, out, err = dev([cmd], timeout)
    return (out + (("\n[stderr] " + err) if err.strip() else "")).rstrip()


def clip(s, n=MAX_TEXT):
    s = s or ""
    return s if len(s) <= n else s[:n] + "\n…[截断，共 %d 字符]" % len(s)


# ────────────────────────────── 工具 ──────────────────────────────

def t_device(_):
    model = sh("getprop ro.product.model").strip()
    brand = sh("getprop ro.product.brand").strip()
    rel = sh("getprop ro.build.version.release").strip()
    sdk = sh("getprop ro.build.version.sdk").strip()
    abi = sh("getprop ro.product.cpu.abi").strip()
    size = sh("wm size").strip()
    dens = sh("wm density").strip()
    return ("设备: %s %s · Android %s (API %s) · %s\n"
            "屏幕: %s · %s\n"
            "adb: %s" % (brand, model, rel, sdk, abi, size, dens, serial()))


def t_cur(_):
    out = sh("dumpsys activity activities | grep -E 'topResumedActivity|mResumedActivity' | head -4")
    pkgs = sorted(set(re.findall(r"u0 ([a-zA-Z0-9_.]+)/", out)))
    return "%s\n\n前台包名: %s" % (out.strip() or "（读不到）", pkgs[0] if pkgs else "?")


def t_pkgs(a):
    kw = (a.get("kw") or "").strip()
    third = (a.get("third_party") or "1") not in ("0", "false", "False")
    cmd = "pm list packages %s" % ("-3" if third else "")
    out = sh(cmd)
    lines = [l.replace("package:", "").strip() for l in out.splitlines() if l.startswith("package:")]
    if kw:
        lines = [l for l in lines if kw.lower() in l.lower()]
    lines.sort()
    return "共 %d 个\n%s" % (len(lines), "\n".join(lines))


def t_ps(a):
    kw = (a.get("kw") or "").strip()
    out = sh("ps -A -o PID,NAME 2>/dev/null | head -400")
    if kw:
        out = "\n".join(l for l in out.splitlines() if kw.lower() in l.lower())
    return clip(out)


def _ui_dump(path=DUMP_XML):
    """uiautomator dump 并拉回本地，返回 (本地路径, 原始XML)。"""
    os.makedirs(SHOT_DIR, exist_ok=True)
    remote = "/sdcard/devmcp_ui.xml"
    sh("rm -f %s" % remote)
    out = sh("uiautomator dump %s" % remote, 90)
    if "dumped" not in out and "UI hierchary" not in out and "UI hierchary dumped" not in out:
        # 有些机器输出 "UI hierchary dumped to: ..."
        pass
    rc, o, e = _adb_raw(["-s", serial(), "pull", remote, path], 90)
    if not os.path.exists(path):
        return None, "拉取失败: %s%s\n(dump 输出: %s)" % (o.strip(), e.strip(), out.strip())
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        return path, fh.read()


def _walk(node, depth=0):
    """把 uiautomator xml 拍平成行。"""
    rows = []
    a = node.attrib
    t = a.get("text", "")
    d = a.get("resource-id", "")
    c = a.get("class", "").split(".")[-1]
    cd = a.get("content-desc", "")
    if t or d or cd:
        rows.append("  " * depth + "%s  text=%r id=%r desc=%r" % (c, t, d, cd))
    for ch in node:
        rows.extend(_walk(ch, depth + 1))
    return rows


def t_ui(a):
    kw = (a.get("kw") or "").strip()
    path, xml = _ui_dump()
    if path is None:
        return "✗ %s" % xml
    try:
        root = ET.fromstring(xml)
    except Exception as exc:                                    # noqa: BLE001
        return "✗ XML 解析失败: %s" % exc
    lines = _walk(root)
    if kw:
        lines = [l for l in lines if kw.lower() in l.lower()]
    return "（本地: %s）共 %d 行\n%s" % (path, len(lines), clip("\n".join(lines)))


def t_find(a):
    """按文字/资源id 找控件，返回坐标。"""
    text = (a.get("text") or "").strip()
    rid = (a.get("id") or "").strip()
    path, xml = _ui_dump()
    if path is None:
        return "✗ %s" % xml
    root = ET.fromstring(xml)
    hits = []
    for n in root.iter("node"):
        at = n.attrib
        ok_t = (not text) or (text in (at.get("text", "") + at.get("content-desc", "")))
        ok_i = (not rid) or (rid in at.get("resource-id", ""))
        if (text or rid) and ok_t and ok_i:
            b = re.findall(r"-?\d+", at.get("bounds", ""))
            if len(b) == 4:
                x1, y1, x2, y2 = map(int, b)
                hits.append((at.get("class", "").split(".")[-1],
                             at.get("text", "") or at.get("content-desc", ""),
                             (x1 + x2) // 2, (y1 + y2) // 2, at.get("bounds", "")))
    if not hits:
        return "没找到（text=%r id=%r）" % (text, rid)
    return "\n".join("%s %r -> (%d, %d) %s" % h for h in hits[:30])


def _tap(x, y):
    return sh("input tap %d %d" % (int(x), int(y)))


def t_tap(a):
    return "✓ tap (%s,%s)" % (a.get("x"), a.get("y")) if _tap(a.get("x"), a.get("y")) == "" \
        else _tap(a.get("x"), a.get("y"))


def t_tap_text(a):
    text = (a.get("text") or "").strip()
    if not text:
        return "✗ 缺 text"
    path, xml = _ui_dump()
    if path is None:
        return "✗ %s" % xml
    root = ET.fromstring(xml)
    for n in root.iter("node"):
        at = n.attrib
        if text in (at.get("text", "") + at.get("content-desc", "")):
            b = re.findall(r"-?\d+", at.get("bounds", ""))
            if len(b) == 4:
                x1, y1, x2, y2 = map(int, b)
                x, y = (x1 + x2) // 2, (y1 + y2) // 2
                _tap(x, y)
                return "✓ 点到 %r @ (%d,%d)" % (text, x, y)
    return "✗ 没找到 %r" % text


def t_swipe(a):
    sh("input swipe %s %s %s %s %s" % (a.get("x1"), a.get("y1"), a.get("x2"), a.get("y2"),
                                       a.get("ms") or 300), 40)
    return "✓ swipe"


def t_input(a):
    txt = a.get("text") or ""
    # 空格用 %s，其余直接送；中文请用 adb 的 text 不支持 ⇒ 提示走 inputkeyevent/剪贴板
    sh("input text %s" % txt.replace(" ", "%s"), 40)
    return "✓ 输入了 %r（注意：adb input text 不支持中文）" % txt


def t_key(a):
    k = a.get("key") or "KEYCODE_BACK"
    if not k.startswith("KEYCODE_"):
        k = "KEYCODE_" + k.upper()
    sh("input keyevent %s" % k, 30)
    return "✓ keyevent %s" % k


def t_screen(a):
    out = a.get("out") or os.path.join(SHOT_DIR, "shot.png")
    os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
    try:
        p = subprocess.run(["adb", "-s", serial(), "exec-out", "screencap", "-p"],
                           capture_output=True, timeout=90)
    except Exception as exc:                                    # noqa: BLE001
        return "✗ 截图异常：%s" % exc
    data = p.stdout or b""
    if not data[:8] == b"\x89PNG\r\n\x1a\n":
        return "✗ 不是合法 PNG（%d B）" % len(data)
    with open(out, "wb") as fh:
        fh.write(data)
    return "✓ 已存 %s（%d B）" % (out, os.path.getsize(out))


def t_start(a):
    pkg = (a.get("pkg") or "").strip()
    if not pkg:
        return "✗ 缺 pkg"
    act = (a.get("activity") or "").strip()
    if act:
        out = sh("am start -n %s/%s" % (pkg, act), 40)
    else:
        out = sh("monkey -p %s -c android.intent.category.LAUNCHER 1" % pkg, 40)
    time.sleep(1)
    return clip(out.strip())


def t_stop(a):
    return clip(sh("am force-stop %s" % (a.get('pkg') or '')).strip())


def t_shell(a):
    return clip(sh(a.get("cmd") or "echo hi", int(a.get("timeout") or 60)))


def t_pull(a):
    dst = a.get("dst") or ("/workspace/tmp/pulled/" + os.path.basename(a.get("src", "f")))
    os.makedirs(os.path.dirname(dst) or ".", exist_ok=True)
    rc, o, e = _adb_raw(["-s", serial(), "pull", a.get("src"), dst], 180)
    return clip("rc=%d\n%s%s" % (rc, o.strip(), e.strip()))


def t_push(a):
    rc, o, e = _adb_raw(["-s", serial(), "push", a.get("src"), a.get("dst")], 180)
    return clip("rc=%d\n%s%s" % (rc, o.strip(), e.strip()))


def t_logcat(a):
    kw = (a.get("kw") or "").strip()
    n = int(a.get("n") or 200)
    cmd = "logcat -d -t %d" % n
    if kw:
        cmd += " | grep -iE %s" % json.dumps(kw)
    return clip(sh(cmd, 60))


def t_ls(a):
    return clip(sh("ls -la %s" % (a.get("path") or "/sdcard/")))


def t_read(a):
    p = a.get("path") or ""
    n = int(a.get("n") or 200)
    return clip(sh("head -n %d %s" % (n, json.dumps(p))))


def t_write(a):
    """往设备写文件（base64 传输，避免引号地狱）。"""
    import base64
    dst = a.get("path") or ""
    data = (a.get("text") or "").encode("utf-8")
    b64 = base64.b64encode(data).decode()
    out = sh("printf '%%s' '%s' | base64 -d > %s && wc -c %s" % (b64, json.dumps(dst), json.dumps(dst)))
    return clip(out)


def t_li_shot(a):
    """针对 Layout Inspect：截图 + 顺手把当前前台记下来（它是只读的"看"）。"""
    r1 = t_screen(a or {})
    r2 = t_cur({})
    return "%s\n\n%s" % (r1, r2)


TOOLS = [
    ("dev_device", "设备/屏幕基本信息", {}, t_device),
    ("dev_cur", "当前前台 App 与 Activity", {}, t_cur),
    ("dev_pkgs", "列已安装应用（kw 过滤；third_party=1 只看第三方）",
     {"kw": "包名关键字", "third_party": "1=只看第三方，0=全部"}, t_pkgs),
    ("dev_ps", "列进程", {"kw": "名字关键字"}, t_ps),
    ("dev_ui", "★ 抓当前界面的控件树（可 kw 过滤）", {"kw": "关键字过滤"}, t_ui),
    ("dev_find", "★ 按文字/资源id 找控件 → 回坐标", {"text": "文字", "id": "资源id片段"}, t_find),
    ("dev_tap", "★ 点坐标", {"x": "x", "y": "y"}, t_tap),
    ("dev_tap_text", "★ 按文字点（自己找坐标）", {"text": "文字"}, t_tap_text),
    ("dev_swipe", "滑动", {"x1": "", "y1": "", "x2": "", "y2": "", "ms": "时长"}, t_swipe),
    ("dev_input", "输入文字（不支持中文）", {"text": "内容"}, t_input),
    ("dev_key", "按键 BACK/HOME/ENTER 等", {"key": "KEYCODE_xxx 或 BACK"}, t_key),
    ("dev_screen", "★ 截图存到工作区（我的眼睛）", {"out": "本地路径"}, t_screen),
    ("dev_start", "启动 App（可指定 activity）", {"pkg": "包名", "activity": "可选"}, t_start),
    ("dev_stop", "强停 App", {"pkg": "包名"}, t_stop),
    ("dev_shell", "在手机上跑 shell（非 root）", {"cmd": "命令", "timeout": "秒"}, t_shell),
    ("dev_pull", "从手机拉文件到工作区", {"src": "", "dst": ""}, t_pull),
    ("dev_push", "从工作区推文件到手机", {"src": "", "dst": ""}, t_push),
    ("dev_logcat", "抓 logcat（可 grep）", {"kw": "过滤", "n": "行数"}, t_logcat),
    ("dev_ls", "列目录", {"path": "路径"}, t_ls),
    ("dev_read", "读文本文件前 n 行", {"path": "", "n": ""}, t_read),
    ("dev_write", "写文件到设备（base64 安全传输）", {"path": "", "text": ""}, t_write),
    ("li_shot", "★ Layout Inspect 专用：截图+前台快照", {"out": "本地路径"}, t_li_shot),
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
            except Exception:                                   # noqa: BLE001
                return "✗ 内部异常：\n%s" % traceback.format_exc(limit=5)
    return "✗ 未知工具 %s" % name


# ────────────────────────────── MCP 协议 ──────────────────────────────

def _handle_rpc(req):
    mid = req.get("id")
    method = req.get("method")
    params = req.get("params") or {}
    if method == "initialize":
        return {"jsonrpc": "2.0", "id": mid, "result": {
            "protocolVersion": params.get("protocolVersion") or "2025-06-18",
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "dev-mcp", "version": "1.0.0"},
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

        def _send(self, code, obj=None):
            body = b"" if obj is None else json.dumps(obj, ensure_ascii=False).encode("utf-8")
            self.send_response(code)
            if body:
                self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            if body:
                self.wfile.write(body)

        def do_POST(self):
            try:
                n = int(self.headers.get("Content-Length") or 0)
                msg = json.loads(self.rfile.read(n).decode("utf-8")) if n else {}
            except Exception:                                   # noqa: BLE001
                return self._send(400, {"jsonrpc": "2.0", "id": None,
                                        "error": {"code": -32700, "message": "parse error"}})
            try:
                if isinstance(msg, list):
                    out = []
                    for one in msg:
                        res, note = _handle_rpc(one)
                        if not note and res:
                            out.append(res)
                    return self._send(200, out or None)
                res, note = _handle_rpc(msg)
                return self._send(202, None) if note else self._send(200, res)
            except Exception:                                   # noqa: BLE001
                return self._send(500, {"jsonrpc": "2.0", "id": msg.get("id"),
                                        "error": {"code": -32603,
                                                  "message": traceback.format_exc(limit=3)}})

        def do_GET(self):
            self._send(405, {"jsonrpc": "2.0", "id": None,
                             "error": {"code": -32601, "message": "SSE not supported"}})

        def do_DELETE(self):
            self._send(200, {"ok": True})

        def log_message(self, fmt, *args):
            sys.stderr.write("[dev-mcp] %s\n" % (fmt % args))

    srv = ThreadingHTTPServer(("127.0.0.1", port), H)
    sys.stderr.write("[dev-mcp] listening http://127.0.0.1:%d/mcp\n" % port)
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
        except Exception:                                       # noqa: BLE001
            continue
        res, note = _handle_rpc(req)
        if res:
            sys.stdout.write(json.dumps(res, ensure_ascii=False) + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    main()
