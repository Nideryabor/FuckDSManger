#!/usr/bin/env python3
"""
dex_strings.py —— 把 dex 里**每个类用到的字符串，按代码顺序**抽出来 🐲

用途：原模块的 UI 是**手写 smali**（没有 XML 布局、文案都内联在代码里）。
要"照原 UI 抄"，就得知道它每个类、每个方法里依次出现了哪些文案 ——
普通反编译器给的是"字符串池"（乱序、混着所有类），这份工具给的是**代码顺序**。

原理：解析 class_data_item → method → code_item 的指令流，
     只挑 `const-string`(0x1A, fmt 21c) 与 `const-string/jumbo`(0x1B, fmt 31c)。

用法：python3 tools/respipe/dex_strings.py <classes.dex> [过滤正则]
"""
import re
import struct
import sys


def uleb128(d, off):
    r = 0
    s = 0
    while True:
        b = d[off]
        off += 1
        r |= (b & 0x7F) << s
        if not (b & 0x80):
            break
        s += 7
    return r, off


class Dex:
    def __init__(self, data):
        self.d = data
        self.string_ids_off = struct.unpack_from("<I", data, 0x3C)[0]
        # 头部偏移（★ size/off 是相邻的一对：0x48 size→0x4C off，千万别把 size 当 off）
        self.type_ids_off = struct.unpack_from("<I", data, 0x44)[0]
        self.proto_ids_off = struct.unpack_from("<I", data, 0x4C)[0]
        self.field_ids_off = struct.unpack_from("<I", data, 0x54)[0]
        self.method_ids_off = struct.unpack_from("<I", data, 0x5C)[0]
        self.class_defs_size, self.class_defs_off = struct.unpack_from("<II", data, 0x60)

    def string(self, i):
        (off,) = struct.unpack_from("<I", self.d, self.string_ids_off + 4 * i)
        n, p = uleb128(self.d, off)                 # uleb128 长度（UTF-8 字节数 + 1 表示 utf16）
        end = self.d.index(b"\x00", p)
        return self.d[p:end].decode("utf-8", "replace")

    def type_(self, i):
        (idx,) = struct.unpack_from("<I", self.d, self.type_ids_off + 4 * i)
        return self.string(idx)

    def method_name(self, i):
        _c, _p, n = struct.unpack_from("<HHI", self.d, self.method_ids_off + 8 * i)
        return self.string(n)

    def classes(self):
        for i in range(self.class_defs_size):
            base = self.class_defs_off + 32 * i
            class_idx, _acc, _sup, _if, _src, _anno, cd_off = struct.unpack_from(
                "<IIIIIII", self.d, base)
            yield self.type_(class_idx), cd_off


def code_const_strings(dex, class_desc):
    d = dex.d
    for desc, cd_off in dex.classes():
        if desc != class_desc:
            continue
        p = cd_off
        sf, p = uleb128(d, p)
        inst_f, p = uleb128(d, p)
        mf, p = uleb128(d, p)
        cf, p = uleb128(d, p)
        for skip in (sf, inst_f, cf):
            for _ in range(skip):
                _x, p = uleb128(d, p)          # field_idx_diff
                _y, p = uleb128(d, p)          # access_flags ← ★ 也是 uleb128（我先前按 4 字节跳 ⇒ 之后全错位）
        for _ in range(mf):
            _mi, p = uleb128(d, p)
            _ac, p = uleb128(d, p)
            code_off, p = uleb128(d, p)
            if code_off == 0:
                continue
            yield from _scan_code(dex, code_off)


# ── dalvik 指令长度表（单位：code unit）────────────────────────────────
# 只有长度对了，才能在指令流里稳稳地扫到每一条 const-string
# （先前偷懒"非 const-string 一律 +1" ⇒ 遇到多字节指令就错位，读到垃圾索引）
_LEN = [
    # 00..0F
    1, 1, 2, 3, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    # 10..1F
    1, 1, 1, 2, 3, 2, 2, 3, 5, 2, 2, 3, 2, 1, 1, 2,
    # 20..2F
    2, 1, 2, 2, 3, 3, 3, 1, 1, 2, 3, 3, 3, 2, 2, 2,
    # 30..3F
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1,
    # 40..4F
    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    # 50..5F
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    # 60..6F
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3,
    # 70..7F
    3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    # 80..8F
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    # 90..AF（23x）
] + [2] * 32 + [
    # B0..CF（12x）
] + [1] * 32 + [
    # D0..D7（22s） D8..E2（22b）
] + [2] * 19 + [
    # E3..FF 未用
] + [1] * 29
assert len(_LEN) == 256, len(_LEN)


def _scan_code(dex, code_off):
    d = dex.d
    _regs, _ins, _outs, _tries, _dbg, insns_size = struct.unpack_from("<HHHHII", d, code_off)
    base = code_off + 16
    i = 0
    while i < insns_size:
        op = d[base + 2 * i]
        if op == 0x00:                                  # nop 或伪指令（payload）
            unit = struct.unpack_from("<H", d, base + 2 * i)[0]
            i += (unit >> 8) * 2 if unit != 0 else 1
            continue
        if op == 0x1A:                                  # const-string vAA, string@BBBB (21c)
            idx = struct.unpack_from("<H", d, base + 2 * i + 2)[0]
            yield dex.string(idx)
        elif op == 0x1B:                                # const-string/jumbo (31c)
            idx = struct.unpack_from("<I", d, base + 2 * i + 2)[0]
            yield dex.string(idx)
        i += _LEN[op]


def dump_pool(data, pat, skip_tech=True):
    """按**字符串池顺序**打印（= 编译时首次出现的顺序，基本就是 UI 的书写顺序）。

    这比解指令流可靠得多：池顺序天然带"书写顺序"，而指令流要维护完整长度表。
    """
    dex = Dex(data)
    n, off = struct.unpack_from("<II", data, 0x38)
    TYPES = re.compile(r"^[\[L]|;$")
    for i in range(n):
        s = dex.string(i)
        if not s or (skip_tech and TYPES.search(s)):
            continue
        if pat and not pat.search(s):
            continue
        print("%5d  %s" % (i, s.replace("\n", "\\n")))


def main():
    data = open(sys.argv[1], "rb").read()
    if len(sys.argv) > 2 and sys.argv[2] == "--pool":
        pat = re.compile(sys.argv[3]) if len(sys.argv) > 3 else re.compile(r"[\u4e00-\u9fff]")
        dump_pool(data, pat)
        return
    dex = Dex(data)
    pat = re.compile(sys.argv[2]) if len(sys.argv) > 2 else re.compile(r"[\u4e00-\u9fff]")
    want = sys.argv[3] if len(sys.argv) > 3 else None
    for desc, _off in dex.classes():
        if want and want not in desc:
            continue
        got = [s for s in code_const_strings(dex, desc) if pat.search(s)]
        if got:
            print("=== %s（%d 条）" % (desc, len(got)))
            for s in got:
                print("    " + s.replace("\n", "\\n"))


if __name__ == "__main__":
    main()
