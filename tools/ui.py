#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ui.py —— 手机上"看界面 / 点东西"的一次性小工具（不需要常驻服务）

  python3 ui.py dump [kw]        抓控件树（kw 过滤）
  python3 ui.py click "<文字>"   按文字点（含 content-desc）
  python3 ui.py clickid "<id>"   按资源 id 点
  python3 ui.py shot <out.png>   截图
  python3 ui.py key <KEYCODE>    按键
  python3 ui.py text "<内容>"    输入（不支持中文）
"""
import json
import os
import re
import subprocess
import sys
import xml.etree.ElementTree as ET

SERIALS = ["127.0.0.1:5555", "192.168.1.5:5555", "emulator-5554"]
REMOTE = "/sdcard/_ui.xml"


def adm(*a, t=60, binary=False):
    for s in SERIALS:
        c = ["adb", "-s", s] + list(a)
        try:
            p = subprocess.run(c, capture_output=True, timeout=t)
        except Exception:
            continue
        if p.returncode == 0 and (binary or b"error" not in p.stdout.lower()[:200]):
            return p.stdout if binary else p.stdout.decode("utf-8", "replace")
    # 最后一搏：不带 -s
    p = subprocess.run(["adb"] + list(a), capture_output=True, timeout=t)
    return p.stdout if binary else p.stdout.decode("utf-8", "replace")


def shell(cmd, t=60):
    return adm("shell", cmd, t=t)


def dump_xml():
    shell("rm -f %s" % REMOTE)
    shell("uiautomator dump %s" % REMOTE, t=90)
    data = adm("exec-out", "cat", REMOTE, t=90)
    return data


def parse():
    x = dump_xml()
    i = x.find("<?xml")
    if i < 0:
        i = x.find("<hierarchy")
    if i < 0:
        print("(dump 失败)")
        sys.exit(1)
    return ET.fromstring(x[i:])


def desc(n):
    a = n.attrib
    return "%s text=%r desc=%r id=%r %s" % (
        a.get("class", "").split(".")[-1], a.get("text", ""), a.get("content-desc", ""),
        a.get("resource-id", "").split("/")[-1], a.get("bounds", ""))


def center(n):
    b = list(map(int, re.findall(r"-?\d+", n.attrib.get("bounds", ""))))
    return (b[0] + b[2]) // 2, (b[1] + b[3]) // 2


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "dump"
    if cmd == "dump":
        kw = sys.argv[2].lower() if len(sys.argv) > 2 else ""
        r = parse()
        n = 0
        for node in r.iter("node"):
            d = desc(node)
            if not kw or kw in d.lower():
                print(d)
                n += 1
        print("-- %d 行 --" % n)
    elif cmd in ("click", "clickid"):
        key = sys.argv[2]
        r = parse()
        for node in r.iter("node"):
            a = node.attrib
            hay = (a.get("text", "") + a.get("content-desc", "")) if cmd == "click" else a.get("resource-id", "")
            if key in hay:
                x, y = center(node)
                shell("input tap %d %d" % (x, y))
                print("✓ 点到 %r @ (%d,%d)" % (key, x, y))
                return
        print("✗ 没找到 %r" % key)
    elif cmd == "shot":
        out = sys.argv[2] if len(sys.argv) > 2 else "/workspace/tmp/ui.png"
        os.makedirs(os.path.dirname(out), exist_ok=True)
        d = adm("exec-out", "screencap", "-p", binary=True, t=90)
        open(out, "wb").write(d)
        print("✓ %s (%d B)" % (out, len(d)))
    elif cmd == "key":
        shell("input keyevent %s" % sys.argv[2])
        print("✓ key %s" % sys.argv[2])
    elif cmd == "text":
        shell("input text %s" % sys.argv[2].replace(" ", "%s"))
        print("✓ text")
    elif cmd == "start":
        print(shell("am start -n %s" % sys.argv[2]))
    else:
        print(__doc__)


if __name__ == "__main__":
    main()
