#!/usr/bin/env python3
# MMKV 文件解析器 🐲 2026-11-01
#
# 格式（MMKV / MiniPBCoder，全部 varint 长度前缀）：
#     [varint keyLen][key utf8][varint valLen][val bytes] × N
#
# ⚠️ 不追求 100% 还原（bool/int 的类型标记在这层看不到），
#    但只要 key 能读出来、value 能当 bytes 看，就已经够用了。
import sys, json

def read_varint(d, i, n):
    r = 0
    s = 0
    while i < n:
        b = d[i]
        i += 1
        r |= (b & 0x7F) << s
        if not (b & 0x80):
            break
        s += 7
    return r, i

def parse(path):
    d = open(path, 'rb').read()
    n = len(d)
    i = 0
    out = []
    bad = 0
    while i < n:
        start = i
        try:
            klen, i = read_varint(d, i, n)
            if klen == 0 or klen > 512 or i + klen > n:
                i = start + 1
                bad += 1
                continue
            key = d[i:i + klen]
            i += klen
            try:
                ks = key.decode('utf-8')
            except UnicodeDecodeError:
                i = start + 1
                bad += 1
                continue
            if any(ord(c) < 0x20 for c in ks):
                i = start + 1
                bad += 1
                continue
            vlen, i = read_varint(d, i, n)
            if i + vlen > n:
                i = start + 1
                bad += 1
                continue
            val = d[i:i + vlen]
            i += vlen
            out.append((ks, val))
        except Exception:
            i = start + 1
            bad += 1
    return out, bad

def show(val, maxlen=200):
    try:
        s = val.decode('utf-8')
        if s.isprintable() or '\n' in s:
            return s[:maxlen] + ('...' if len(s) > maxlen else '')
    except UnicodeDecodeError:
        pass
    if len(val) <= 8:
        return '<bytes %s>' % val.hex()
    return '<%d bytes hex> %s' % (len(val), val[:24].hex())

if __name__ == '__main__':
    path = sys.argv[1] if len(sys.argv) > 1 else 'tmp/mmkv272/default.bin'
    want = sys.argv[2] if len(sys.argv) > 2 else None
    items, bad = parse(path)
    print('# 解析出 %d 条（跳过脏位置 %d）' % (len(items), bad))
    for k, v in items:
        if want and want.lower() not in k.lower():
            continue
        print('%-52s = %s' % (k, show(v)))
