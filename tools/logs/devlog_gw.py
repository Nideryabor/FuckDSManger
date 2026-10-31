#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
devlog_gw.py —— 日志网关（设备端，必须 root 起）

  su -c 'python3 /data/local/tmp/devlog_gw.py --daemon'

小窝侧用 /workspace/tools/logs/devlog.sh 发请求。
监听 127.0.0.1:8756（proot 与 Android 共享网络命名空间，小窝直接 curl）。

只做一件事：把 root-only 的日志文件打包成 tar.gz 流回去。
不落中间文件、不写设备、不留副本。

日志源（按用户要求）：
  lspd   /data/adb/lspd/log/{verbose*,modules*}       ← LSPosed 框架/模块日志
  crash  /data/system/dropbox/*crash* *anr*            ← 应用崩溃 / ANR（文件，不是 logcat 缓冲）
  anr    /data/anr/*                                   ← ANR traces
  tomb   /data/tombstones/*                            ← native crash
  app    /data/data/<pkg>/ 下名字像日志的文件           ← 应用自己写的运行日志
"""
import io
import json
import os
import stat as statmod
import subprocess
import sys
import tarfile
import time
import traceback
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse, parse_qs

VERSION = "1.0"
PORT = int(os.environ.get("DEVLOG_PORT", "8756"))
BIND = os.environ.get("DEVLOG_BIND", "127.0.0.1")
APP = os.environ.get("DEVLOG_APP", "com.deepseek.chat.a")

# ★ 允许抓取的应用包名白名单 —— 只能在启动时用 DEVLOG_ALLOWED_APPS 配置，
#   请求参数一律不能扩展（防止 /bundle?app=别的包 越权）
ALLOWED_APPS = tuple(x.strip() for x in
                     os.environ.get("DEVLOG_ALLOWED_APPS", APP).split(",") if x.strip())

# ★ token：没有就用随机的，写进文件供客户端读（不再有硬编码默认值）
TOKEN_FILE = os.environ.get("DEVLOG_TOKEN_FILE", "/data/local/tmp/devlog_token")
TOKEN = os.environ.get("DEVLOG_TOKEN", "").strip()

MAX_FILE = int(os.environ.get("DEVLOG_MAX_FILE", str(16 * 1024 * 1024)))
MAX_TOTAL = int(os.environ.get("DEVLOG_MAX_TOTAL", str(128 * 1024 * 1024)))

# 路径都可用环境变量覆盖（测试/自定义用）
LSPD_DIR = os.environ.get("DEVLOG_LSPD", "/data/adb/lspd/log")
LSPD_PREFIX = tuple(x for x in os.environ.get("DEVLOG_LSPD_PREFIX", "verbose,modules").split(",") if x)
DROPBOX = os.environ.get("DEVLOG_DROPBOX", "/data/system/dropbox")
DROPBOX_MATCH = tuple(x for x in os.environ.get("DEVLOG_DROPBOX_MATCH", "crash,anr").split(",") if x)
ANR_DIR = os.environ.get("DEVLOG_ANR", "/data/anr")
TOMB_DIR = os.environ.get("DEVLOG_TOMB", "/data/tombstones")

# 只收这些扩展名（白名单）
LOG_EXT = {".log", ".vlog", ".txt", ".trace", ".dmp", ".stacktrace", ".out", ".err", ".anr"}

# 明确不收：凭据 / 二进制缓存 / 标记文件
SKIP_EXT = {".json", ".json5", ".xml", ".db", ".sqlite", ".mmkv", ".cache", ".guard",
            ".bin", ".dat", ".png", ".jpg", ".zip", ".gz", ".bak", ".so", ".dex"}
SKIP_NAME_PAT = ("login", "token", "credential", "secret", "password", "passwd",
                 "cookie", "auth", "has_anr_signal", "session", "account")

# 小于这个大小的当标记文件，不收
MIN_SIZE = int(os.environ.get("DEVLOG_MIN_SIZE", "64"))

SKIP_DIRS = {"lib", "code_cache", "no_backup", "oat", "app_webview", "databases",
             "shared_prefs", "cache_http", "code_cache_secondary", "FDMmusic"}


def run(cmd, timeout=20):
    try:
        p = subprocess.run(cmd, capture_output=True, timeout=timeout,
                           env={**os.environ, "LC_ALL": "C"})
        return (p.stdout or b"").decode("utf-8", "replace")
    except Exception:
        return ""


def readable(p):
    try:
        os.listdir(p)
        return True
    except Exception:
        return False


def is_reg(st):
    return statmod.S_ISREG(st.st_mode)


def pick_files(root, prefixes=None, match_words=None, max_depth=None, ext_filter=True):
    """遍历 root，返回 [(path, size, mtime)]"""
    out = []
    if not root or not os.path.isdir(root):
        return out
    base = root.rstrip("/").count("/")
    for dirpath, dirnames, filenames in os.walk(root, followlinks=False):
        if max_depth is not None and dirpath.count("/") - base >= max_depth:
            dirnames[:] = []
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for fn in filenames:
            low = fn.lower()
            if prefixes:
                if not any(fn.startswith(p) for p in prefixes):
                    continue
            elif match_words:
                if not any(w in low for w in match_words):
                    continue
            elif ext_filter:
                if os.path.splitext(low)[1] not in LOG_EXT:
                    continue
            # 统一黑名单（所有组都适用）
            if os.path.splitext(low)[1] in SKIP_EXT:
                continue
            if any(w in low for w in SKIP_NAME_PAT):
                continue
            fp = os.path.join(dirpath, fn)
            try:
                st = os.lstat(fp)
            except OSError:
                continue
            if not is_reg(st) or st.st_size < MIN_SIZE or st.st_size > MAX_FILE:
                continue
            out.append((fp, st.st_size, st.st_mtime))
    out.sort(key=lambda t: t[2])
    return out


def allowed_roots(app_list=None):
    """唯一允许 /ls /file /bundle 触及的目录树"""
    roots = [LSPD_DIR, DROPBOX, ANR_DIR, TOMB_DIR]
    for a in (app_list or ALLOWED_APPS):
        roots.append("/data/data/%s" % a)
        roots.append("/data/user_de/0/%s" % a)
    apd = os.environ.get("DEVLOG_APPDIR")
    if apd:
        roots.append(apd)
    return roots


def safe_path(p, app_list=None):
    """把请求路径解析成 realpath；不在白名单目录树内一律返回 None。
    用 realpath 是为了吃掉 ../ 和符号链接逃逸。"""
    if not p or not isinstance(p, str):
        return None
    if "\x00" in p:
        return None
    try:
        rp = os.path.realpath(p)
    except Exception:
        return None
    for root in allowed_roots(app_list):
        try:
            rr = os.path.realpath(root)
        except Exception:
            continue
        if rp == rr or rp.startswith(rr + os.sep):
            return rp
    return None


def check_app(name):
    """请求里的 app 参数只能落在白名单内"""
    if not name:
        return None
    return name if name in ALLOWED_APPS else None


def sources(app):
    """[(组名, 根目录, 文件名前缀过滤, 关键字过滤, 深度)]"""
    return [
        ("lspd",  LSPD_DIR, LSPD_PREFIX, None, None),
        ("crash", DROPBOX, None, DROPBOX_MATCH, 1),
        ("anr",   ANR_DIR, None, None, 1),
        ("tomb",  TOMB_DIR, None, None, 1),
        ("app",   os.environ.get("DEVLOG_APPDIR", "/data/data/%s" % app), None, ("log", "crash", "anr", "trace"), 5),
    ]


class Handler(BaseHTTPRequestHandler):
    server_version = "devlog-gw/" + VERSION
    protocol_version = "HTTP/1.0"

    def log_message(self, fmt, *args):
        sys.stderr.write("[%s] %s\n" % (time.strftime("%H:%M:%S"), fmt % args))

    def _send(self, code, body, ctype="text/plain; charset=utf-8"):
        if isinstance(body, str):
            body = body.encode("utf-8", "replace")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        try:
            self.wfile.write(body)
        except Exception:
            pass

    def _json(self, code, obj):
        self._send(code, json.dumps(obj, ensure_ascii=False, indent=1),
                   "application/json; charset=utf-8")

    def do_GET(self):
        u = urlparse(self.path)
        q = parse_qs(u.query, keep_blank_values=True)
        if TOKEN:
            got = (q.get("token", [""])[0] or self.headers.get("X-Devlog-Token", "")).strip()
            if got != TOKEN:
                return self._send(401, "bad token\n")
        try:
            return self.route(u.path, q)
        except BrokenPipeError:
            pass
        except Exception:
            return self._send(500, "server error:\n" + traceback.format_exc())

    def route(self, path, q):
        g = lambda k, d="": (q.get(k, [d])[0] or "")
        i = lambda k, d=0: int(g(k, str(d)) or d)
        # ★ app 参数只能落在白名单内，越权直接忽略（用默认的）
        app = check_app(g("app", "")) or APP

        if path == "/ping":
            srcs = []
            for name, root, pref, words, depth in sources(app):
                item = {"group": name, "root": root,
                        "exists": os.path.isdir(root), "readable": readable(root)}
                if item["readable"]:
                    fs = pick_files(root, pref, words, depth)
                    item["count"] = len(fs)
                    item["bytes"] = sum(s for _, s, _ in fs)
                    if fs:
                        item["newest"] = os.path.basename(fs[-1][0])
                        item["newest_mtime"] = time.strftime(
                            "%m-%d %H:%M:%S", time.localtime(fs[-1][2]))
                srcs.append(item)
            return self._json(200, {
                "ok": True, "version": VERSION,
                "time": time.strftime("%Y-%m-%d %H:%M:%S"),
                "uid": os.getuid(), "root": os.getuid() == 0,
                "app": app, "port": PORT,
                "allowed_apps": list(ALLOWED_APPS),
                "allowed_roots": allowed_roots(),
                "sources": srcs,
            })

        if path == "/ls":
            p = g("path", "")
            sp = safe_path(p, [app])
            if sp is None:
                return self._send(403, "path not allowed: %s\n" % p)
            p = sp
            if not os.path.isdir(p):
                return self._send(404, "not a directory: %s\n" % p)
            try:
                names = sorted(os.listdir(p))
            except PermissionError:
                return self._send(403, "permission denied: %s\n" % p)
            lines = []
            for n in names[:500]:
                fp = os.path.join(p, n)
                try:
                    st = os.lstat(fp)
                    lines.append("%s %10d %s  %s" % (
                        time.strftime("%m-%d %H:%M", time.localtime(st.st_mtime)),
                        st.st_size, "d" if statmod.S_ISDIR(st.st_mode) else "-", n))
                except OSError:
                    continue
            return self._send(200, "%s\n%s\n" % (p, "\n".join(lines)))

        if path == "/file":
            p = g("path", "")
            tail = i("tail", 0)
            sp = safe_path(p, [app])
            if sp is None:
                return self._send(403, "path not allowed: %s\n" % p)
            p = sp
            if not os.path.isfile(p):
                return self._send(404, "no such file: %s\n" % p)
            try:
                with open(p, "rb") as f:
                    if tail > 0:
                        f.seek(0, os.SEEK_END)
                        size = f.tell()
                        f.seek(max(0, size - tail))
                        data = f.read()
                        if size > tail:
                            data = ("...（共 %d 字节，只给最后 %d）...\n" % (size, tail)).encode() + data
                    else:
                        data = f.read(4 * 1024 * 1024)
            except Exception as e:
                return self._send(500, "read error: %r\n" % (e,))
            return self._send(200, data)

        if path == "/bundle":
            return self.do_bundle(g, i)

        if path == "/quit":
            self._send(200, "bye\n")
            import threading
            threading.Thread(target=self.server.shutdown, daemon=True).start()
            return

        return self._send(404, "unknown: %s\nendpoints: /ping /ls /file /bundle /quit\n" % path)

    def do_bundle(self, g, i):
        app = check_app(g("app", "")) or APP   # ★ 白名单，禁止越权
        since = float(g("since", "0") or 0)
        only = g("only", "")
        keep = set(x for x in only.split(",") if x) if only else None

        plan, skipped, seen = [], [], set()
        total = 0
        for name, root, pref, words, depth in sources(app):
            if keep and name not in keep:
                continue
            if not os.path.isdir(root):
                skipped.append({"group": name, "path": root, "why": "not exist"})
                continue
            if not readable(root):
                skipped.append({"group": name, "path": root, "why": "permission denied"})
                continue
            real = os.path.realpath(root)
            if real in seen:
                continue
            seen.add(real)
            fs = pick_files(root, pref, words, depth)
            fs = [t for t in fs if t[2] > since]
            if not fs:
                skipped.append({"group": name, "path": root, "why": "no new files"})
                continue
            for fp, size, mtime in fs:
                if total + size > MAX_TOTAL:
                    skipped.append({"group": name, "path": fp,
                                    "why": "total cap %d reached" % MAX_TOTAL})
                    break
                plan.append((name, root, fp, size, mtime))
                total += size

        manifest = {
            "generated": time.strftime("%Y-%m-%d %H:%M:%S"),
            "server_time": time.time(), "since": since,
            "app": app, "root": os.getuid() == 0,
            "file_count": len(plan), "total_bytes": total,
            "skipped": skipped,
            "files": [{"arc": "%s/%s" % (n, os.path.relpath(f, r).replace(os.sep, "/")),
                       "size": s, "mtime": m} for n, r, f, s, m in plan],
        }
        mb = json.dumps(manifest, ensure_ascii=False, indent=1).encode()

        self.send_response(200)
        self.send_header("Content-Type", "application/gzip")
        self.send_header("X-Devlog-Files", str(len(plan)))
        self.send_header("X-Devlog-Time", "%.3f" % time.time())
        self.end_headers()
        try:
            with tarfile.open(fileobj=self.wfile, mode="w|gz", compresslevel=6) as tf:
                ti = tarfile.TarInfo("MANIFEST.json")
                ti.size, ti.mtime, ti.mode = len(mb), int(time.time()), 0o644
                tf.addfile(ti, io.BytesIO(mb))
                for name, root, fp, size, mtime in plan:
                    arc = "%s/%s" % (name, os.path.relpath(fp, root).replace(os.sep, "/"))
                    try:
                        ti = tf.gettarinfo(fp, arcname=arc)
                        ti.uid = ti.gid = 0
                        ti.uname = ti.gname = "root"
                        with open(fp, "rb") as fh:
                            tf.addfile(ti, fh)
                    except OSError as e:
                        self.log_message("skip %s: %r", fp, e)
        except (BrokenPipeError, ConnectionResetError):
            self.log_message("client 断开")
        return


def init_token():
    """token：环境变量 > 已有文件 > 新随机。
    随机 token 写进 TOKEN_FILE（0644，shell 可读），客户端从那里取。
    这样代码里不存在硬编码口令。"""
    global TOKEN
    if TOKEN:
        return
    try:
        with open(TOKEN_FILE, "r") as f:
            t = f.read().strip()
        if t:
            TOKEN = t
            return
    except OSError:
        pass
    import secrets
    TOKEN = secrets.token_hex(16)
    try:
        os.makedirs(os.path.dirname(TOKEN_FILE), exist_ok=True)
        fd = os.open(TOKEN_FILE, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o640)
        with os.fdopen(fd, "w") as f:
            f.write(TOKEN)
        # 交给 shell:shell 0640 —— 小窝经 adb shell 能读，别的 app 读不到
        try:
            os.chown(TOKEN_FILE, 2000, 2000)
            os.chmod(TOKEN_FILE, 0o640)
        except OSError:
            pass
    except OSError as e:
        print("⚠ 无法写 token 文件 %s: %r" % (TOKEN_FILE, e), file=sys.stderr)


def main():
    global PORT, TOKEN, APP
    args = sys.argv[1:]
    for a in args:
        if a.startswith("--port="):
            PORT = int(a.split("=", 1)[1])
        elif a.startswith("--token="):
            TOKEN = a.split("=", 1)[1]
        elif a.startswith("--app="):
            APP = a.split("=", 1)[1]

    if os.getuid() != 0 and not os.environ.get("DEVLOG_FORCE"):
        print("✗ 必须 root 起（su -c）—— 否则 /data/adb /data/system 读不到", file=sys.stderr)
        return 2

    init_token()

    if "--daemon" in args:
        if os.fork() > 0:
            print("devlog_gw 已后台启动")
            os._exit(0)
        os.setsid()
        for cand in ("/data/local/tmp", os.environ.get("TMPDIR"), "/tmp"):
            if cand and os.path.isdir(cand):
                try:
                    open(os.path.join(cand, "devlog_gw.pid"), "w").write(str(os.getpid()))
                    break
                except OSError:
                    pass
        dn = os.open(os.devnull, os.O_RDWR)
        os.dup2(dn, 0); os.dup2(dn, 1); os.dup2(dn, 2)

    srv = ThreadingHTTPServer((BIND, PORT), Handler)
    srv.daemon_threads = True
    print("devlog_gw %s  http://%s:%d  uid=%d" % (VERSION, BIND, PORT, os.getuid()))
    print("  lspd: %s (%s)" % (LSPD_DIR, "ok" if readable(LSPD_DIR) else "不可读"))
    print("  dropbox: %s" % ("ok" if readable(DROPBOX) else "不可读"))
    print("  允许的包: %s" % ", ".join(ALLOWED_APPS))
    print("  token: %s..." % TOKEN[:8])
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        print("\nbye")
    return 0


if __name__ == "__main__":
    sys.exit(main())
