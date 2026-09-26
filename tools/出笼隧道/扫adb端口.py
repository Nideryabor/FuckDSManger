#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
扫adb端口.py —— 全段扫本地开放端口（poll 非阻塞）

安卓无线调试的端口每次都是随机的，所以 adb.sh 在缓存失效时要靠它重新找。

用法：
    python3 扫adb端口.py [起始端口] [结束端口]     # 默认 30000 50001
输出：
    一行空格分隔的端口号；找不到就输出空行
"""
import select
import socket
import sys
import time

LO = int(sys.argv[1]) if len(sys.argv) > 1 else 30000
HI = int(sys.argv[2]) if len(sys.argv) > 2 else 50001

socks, poller = {}, select.poll()
for p in range(LO, HI):
    s = socket.socket()
    s.setblocking(False)
    try:
        s.connect_ex(("127.0.0.1", p))
    except Exception:
        s.close()
        continue
    socks[s.fileno()] = (s, p)
    poller.register(s, select.POLLOUT | select.POLLERR | select.POLLHUP)

opened, deadline = [], time.time() + 4.0
while socks and time.time() < deadline:
    for fd, _ in poller.poll(200):
        s, p = socks.pop(fd, (None, None))
        if s is None:
            continue
        if s.getsockopt(socket.SOL_SOCKET, socket.SO_ERROR) == 0:
            opened.append(p)
        poller.unregister(s)
        s.close()
for s, _ in socks.values():
    s.close()

print(" ".join(str(p) for p in sorted(opened)))
