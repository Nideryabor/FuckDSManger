#!/usr/bin/env python3
"""extract_agent.py —— 从 frida-server 里抠出内嵌的 frida-agent-<arch>.so

原理：frida-server 在文件里内嵌了一整只 aarch64 ET_DYN（就是 agent）。
扫描所有 "\\x7fELF" 魔数，挑出满足下面条件的那一只：
  · e_type == ET_DYN(3)
  · e_machine == 0xB7 (AArch64)
  · 有 .text 且体积 > 1MB（排除 stub / 误命中）
然后把 shoff + shnum*shentsize 这段截出来。

2026-10-01 首次用它在 frida-server-17.19.0-arm64 上验证：
  命中偏移 0x85aae0，截出 24,942,256 字节，段布局与 tombstone 映射逐字节一致。

用法:
    python3 extract_agent.py <frida-server文件> [输出路径]
"""
import struct
import sys


def pick(data):
    cands = []
    i = data.find(b"\x7fELF")
    while i != -1:
        try:
            e_type, e_machine = struct.unpack_from("<HH", data, i + 16)
            e_shoff, = struct.unpack_from("<Q", data, i + 40)
            e_shentsize, e_shnum = struct.unpack_from("<HH", data, i + 58)
            e_shstrndx, = struct.unpack_from("<H", data, i + 62)
            if e_type == 3 and e_machine == 0xB7 and 0 < e_shnum < 200:
                total = e_shoff + e_shnum * e_shentsize
                if i + total <= len(data):
                    # 看 .text 大小
                    text_size = 0
                    for k in range(e_shnum):
                        p = i + e_shoff + k * e_shentsize
                        name, typ, flags, addr, off, size = struct.unpack_from("<IIQQQQ", data, p)
                        if typ == 1 and size > text_size:
                            text_size = size
                    if text_size > 1024 * 1024:
                        cands.append((i, total, text_size, e_shnum))
        except Exception:
            pass
        i = data.find(b"\x7fELF", i + 1)
    # 排除偏移 0 —— 那是 frida-server 自己（它也是 aarch64 ET_DYN，会霸榜）
    cands = [c for c in cands if c[0] != 0]
    cands.sort(key=lambda c: -c[2])
    return cands


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    path = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else "frida-agent-64.so"
    data = open(path, "rb").read()
    print("file", path, len(data), "bytes")
    cands = pick(data)
    if not cands:
        print("✗ 没找到内嵌 agent")
        return 1
    for (off, total, text, shnum) in cands[:5]:
        print("  candidate @%#x  size=%d  maxsect=%#x  shnum=%d" % (off, total, text, shnum))
    off, total, text, shnum = cands[0]
    open(out, "wb").write(data[off:off + total])
    print("✓ 抠出 -> %s  (%d bytes, base=%#x)" % (out, total, off))
    return 0


if __name__ == "__main__":
    sys.exit(main())
