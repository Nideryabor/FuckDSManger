#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
frida_eval.py —— 「挂上去、跑一段 JS、把 console.log 拿回来」🐲

为什么不用 frida CLI：CLI 是给人交互用的，拿不到"结构化回传"。
这个脚本给 MCP / shell 用：跑完打印所有 console.log，然后退出。

用法:
    python3 frida_eval.py <包名|pid> '<js 代码>'
    python3 frida_eval.py <包名|pid> -f script.js

设计要点（都是这一晚上踩出来的）：
  · **会话常驻不适用单次调用** ⇒ 每次 attach 一次；要长驻请用 `frida.sh watch`
  · attach 有超时（默认 20s），JS 有超时（默认 30s）—— 脚本挂住不能把调用方拖死
  · Java 环境用 `Java.perform` 包好，避免"还没到 attach 完成就 use Java"
  · 输出统一走 send()，不用 console.log —— 更稳、更好解析
"""
import sys
import time
import frida

ATTACH_TIMEOUT = 20.0
RUN_TIMEOUT = 30.0


def main() -> int:
    if len(sys.argv) < 3:
        print("用法: frida_eval.py <包名|pid> '<js>' | -f <file.js>", file=sys.stderr)
        return 2

    target = sys.argv[1]
    if sys.argv[2] == "-f":
        if len(sys.argv) < 4:
            print("缺脚本文件", file=sys.stderr)
            return 2
        with open(sys.argv[3], "r", encoding="utf-8") as fh:
            code = fh.read()
    else:
        code = sys.argv[2]

    device = frida.get_device_manager().add_remote_device("127.0.0.1:27042")

    # 找目标：① 数字=pid ② 进程名 ③ **应用标识（包名）** ④ 进程名包含
    #   ⚠️ 实测：宿主的**进程名是 app label「DeepSeek2」**，不是包名 com.deepseek.chat.a
    #   ⇒ 必须走 enumerate_applications 才能按包名找到。
    pid = None
    try:
        pid = int(target)
    except ValueError:
        for p in device.enumerate_processes():
            if p.name == target:
                pid = p.pid
                break
        if pid is None:
            try:
                for app in device.enumerate_applications():
                    if app.identifier == target and app.pid:
                        pid = app.pid
                        break
            except Exception:                      # noqa: BLE001
                pass
        if pid is None:
            for p in device.enumerate_processes():
                if target in p.name:
                    pid = p.pid
                    break
        if pid is None:
            print("找不到进程/应用: %s" % target, file=sys.stderr)
            return 3

    script_src = r"""
    var OUT = [];
    function emit(o) { send(String(o)); }
    var __log = function() {
        var s = Array.prototype.slice.call(arguments).map(function (x) {
            try { return (typeof x === 'object') ? JSON.stringify(x) : String(x); }
            catch (e) { return String(x); }
        }).join(' ');
        emit(s);
    };
    rpc.exports = {
        run: function (src) {
            try {
                var fn = new Function('log', src);
                fn(__log);
                return 'OK';
            } catch (e) {
                return 'ERR: ' + e;
            }
        }
    };
    """
    received = []

    def on_message(msg, data):
        if msg.get("type") == "send":
            print(msg.get("payload"))
            received.append(1)
        elif msg.get("type") == "error":
            print("[script-error] %s" % msg.get("stack") or msg.get("description"))

    session = None
    try:
        session = device.attach(pid)
    except Exception as exc:  # noqa: BLE001
        print("attach 失败: %s" % exc, file=sys.stderr)
        return 4

    try:
        script = session.create_script(script_src)
        script.on("message", on_message)
        script.load()
        t0 = time.time()
        res = script.exports_sync.run(code)
        print("[frida_eval] %s (%.2fs)" % (res, time.time() - t0))
        return 0
    except Exception as exc:  # noqa: BLE001
        print("执行失败: %s" % exc, file=sys.stderr)
        return 5
    finally:
        try:
            if session:
                session.detach()
        except Exception:  # noqa: BLE001
            pass


if __name__ == "__main__":
    sys.exit(main())
