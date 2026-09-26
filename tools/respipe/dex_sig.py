#!/usr/bin/env python3
"""dex_sig.py —— 打印某个 dex 里指定类的方法**完整签名**（含参数与返回类型）🐲

为什么需要它：给模块的类写"编译期桩"时，**参数类型写错就 NoSuchMethodException** ✗
（实测：GmEnv.isOn 不是 (Context) ✗、GmAvatar.reset 返回 String ✗）。
猜签名会浪费好几轮真机验证，不如一次扫准。

用法：python3 tools/respipe/dex_sig.py <classes.dex> GmEnv GmAvatar ...
"""
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dex_strings as ds  # noqa: E402


def main():
    d = ds.Dex(open(sys.argv[1], "rb").read())

    def proto(i):
        _s, rt, po = struct.unpack_from("<III", d.d, d.proto_ids_off + 12 * i)
        params = []
        if po:
            n = struct.unpack_from("<I", d.d, po)[0]
            for k in range(n):
                params.append(d.type_(struct.unpack_from("<H", d.d, po + 4 + 2 * k)[0]))
        return "(" + "".join(params) + ")" + d.type_(rt)

    size, off = struct.unpack_from("<II", d.d, 0x58)      # method_ids
    want = set(sys.argv[2:])
    out = {}
    for i in range(size):
        cls, pi, ni = struct.unpack_from("<HHI", d.d, off + 8 * i)
        c, nm = d.type_(cls), d.string(ni)
        simple = c.rstrip(";").split("/")[-1]
        if simple in want:
            out.setdefault(simple, set()).add(nm + proto(pi))
    for k in sorted(out):
        print("── %s" % k)
        for sig in sorted(s for s in out[k] if not s.startswith("<")):
            print("   %s" % sig.replace("Lcom/nidyaber/fuckdsmanger/", "L…/"))


if __name__ == "__main__":
    main()
