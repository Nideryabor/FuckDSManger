#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dex_const_patch.py —— 在 **dex 字节层面**改一个常量，不重建 🐲 尼得亚伯 2026-10-01

为什么需要它（血的教训 #341/#342）：
    "重跑 patch_261.py + 重建底座" 是个**重量级动作** —— 它会 rmtree 重建整棵树，
    把只存在于产物树里、没写回模板的手工改动静默抹掉（3.42.22 就是这么崩的）。
    ⇒ 当改动**很小**（改一个常量）时，应该直接改 dex 字节：
      ① 只动那几个字节，其余零风险；
      ② 出包后可以给主人一个**机械证明**："两个包的 dex 只差 N 字节"。

用法：
    python3 tools/dex_const_patch.py --apk <底座.apk> --out <新底座.apk> \
        --hex 0A0113020F003312 --offset-in-pattern 4 --value 0x12

    --hex                 要搜的字节模式（hex，不带空格）
    --offset-in-pattern   模式里第几个字节要改（0 起）
    --value               改成的值（0x.. / 十进制）

安全：
    · 模式必须**恰好命中 1 处**，否则拒绝（宁可不动，也不要改错）
    · 改完自动重算 dex 头部的 SHA-1 signature 和 Adler-32 checksum
    · APK 其余条目原样搬运（保留压缩方式）
"""
import argparse
import hashlib
import sys
import zipfile
import zlib


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apk', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--entry', default='classes.dex', help='APK 内条目名（默认 classes.dex）')
    ap.add_argument('--hex', required=True, dest='hexpat', help='字节模式，如 0A0113020F003312')
    ap.add_argument('--offset-in-pattern', type=int, default=0)
    ap.add_argument('--value', required=True, help='改成什么，如 0x12')
    ap.add_argument('--expect', default=None, help='可选：要求被改字节当前等于这个值')
    a = ap.parse_args()

    pat = bytes.fromhex(a.hexpat)
    val = int(a.value, 0)

    zin = zipfile.ZipFile(a.apk)
    d = bytearray(zin.read(a.entry))
    print('读入 %s: %d 字节' % (a.entry, len(d)))

    hits = [i for i in range(len(d) - len(pat) + 1) if d[i:i + len(pat)] == pat]
    if len(hits) != 1:
        print('✗✗ 模式命中 %d 处（要求恰好 1 处）—— 拒绝修改' % len(hits))
        for h in hits[:8]:
            print('   0x%x' % h)
        sys.exit(1)
    base = hits[0]
    idx = base + a.offset_in_pattern

    old = d[idx]
    if a.expect is not None and old != int(a.expect, 0):
        print('✗✗ 位置 0x%x 当前是 0x%02x，期望 0x%02x —— 拒绝修改' % (idx, old, int(a.expect, 0)))
        sys.exit(1)
    if old == val:
        print('· 已经是 0x%02x，无需改' % val)
    else:
        d[idx] = val
        print('✓ 位置 0x%x: 0x%02x -> 0x%02x' % (idx, old, val))

    # dex header: checksum(off 8, Adler-32 of [12:]) + signature(off 12, SHA-1 of [32:])
    d[12:32] = hashlib.sha1(bytes(d[32:])).digest()
    d[8:12] = (zlib.adler32(bytes(d[12:])) & 0xffffffff).to_bytes(4, 'little')
    print('✓ dex 头部 checksum / signature 已重算')

    zout = zipfile.ZipFile(a.out, 'w', zipfile.ZIP_DEFLATED)
    for item in zin.infolist():
        data = zin.read(item.filename)
        if item.filename == a.entry:
            data = bytes(d)
        zout.writestr(item, data)
    zout.close()
    print('✓ 写出 → %s' % a.out)


if __name__ == '__main__':
    main()
