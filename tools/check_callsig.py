#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
check_callsig.py —— 检查 smali 里 invoke-* 的**寄存器个数**是否与目标方法的签名匹配 🐲 2026-10-31

为什么要有它（真机两次踩坑）：
  ① 3.73.5：`catch` 处理器里用了 try 区内未赋值的寄存器 ⇒ VerifyError ⇒ **整个类不加载**
  ② 3.73.8：`invoke-static {v3}, GmUtil->logOnce(String,String)` —— 只传 1 个寄存器，
     而 logOnce 要 2 个 ⇒ ART 报 `Rejecting invocation, expected 1 argument registers,
     method signature has 2 or more` ⇒ **GmBubblePaintHook 整个类不加载**
     ⇒ x98.t / x98.s 的 hook 全 FAIL ⇒ 用户气泡背景彻底没有。

第二类问题是**纯机械错误**，能静态查出来 —— 就是本脚本干的事：
  对每个 `invoke-X {regs}, Lcls;->meth(sig)ret`：
    · 静态方法：需要 = 参数个数（long/double 算 2）
    · 实例方法：需要 = 参数个数 + 1（this）
  只检查能解析到签名的调用（签名就写在 invoke 行里，不用外部 dex）。

用法：
  python3 tools/check_callsig.py <smali 目录> [更多目录...]
退出码：0 = 没问题；1 = 有问题（会逐条列出文件:行号）
"""
import os, re, sys

# 参数类型 → 占几个寄存器
def slot_count(desc: str) -> int:
    n = 0
    i = 0
    while i < len(desc):
        c = desc[i]
        if c == '[':
            # 数组：一路跳到类型字符结束
            while i < len(desc) and desc[i] in '[L':
                if desc[i] == 'L':
                    j = desc.find(';', i)
                    i = j if j >= 0 else len(desc) - 1
                    break
                i += 1
            i += 1
            n += 1
        elif c == 'L':
            j = desc.find(';', i)
            i = (j if j >= 0 else len(desc) - 1) + 1
            n += 1
        else:
            n += 2 if c in 'JD' else 1
            i += 1
    return n

INVOKE = re.compile(
    r'invoke-(static|virtual|interface|direct|super|static/range|virtual/range|'
    r'interface/range|direct/range|super/range)\s*(?:/\w+)?\s*\{([^}]*)\},\s*'
    r'(L[^;]+;)->([\w$<>]+)\(([^)]*)\)(\S+)')

def main(paths):
    bad = 0
    for root in paths:
        for dp, _, fs in os.walk(root):
            for fn in fs:
                if not fn.endswith('.smali'):
                    continue
                p = os.path.join(dp, fn)
                try:
                    src = open(p, encoding='utf-8', errors='ignore').read().split('\n')
                except Exception:
                    continue
                for ln, line in enumerate(src, 1):
                    m = INVOKE.search(line)
                    if not m:
                        continue
                    kind, regs, cls, meth, psig, ret = m.groups()
                    reg_list = [r.strip() for r in regs.split(',') if r.strip()]
                    # /range 形式：{v0 .. v7} 按逗号切完只有 1 个元素，得先按 '..' 识别
                    if '..' in regs:
                        pair = [x.strip() for x in regs.split('..')]
                        if len(pair) == 2:
                            def idx(r):
                                return int(r[1:]) + (10000 if r.startswith('p') else 0)
                            try:
                                a, b = idx(pair[0]), idx(pair[1])
                            except Exception:
                                continue
                            got = abs(b - a) + 1
                            need = slot_count(psig) + (0 if 'static' in kind else 1)
                            if got != need:
                                bad += 1
                                print(f'⚠️  {p}:{ln}\n'
                                      f'      {kind} {cls}->{meth}({psig}){ret}\n'
                                      f'      传了 {got} 个寄存器（range），应为 {need}')
                            continue
                    if len(reg_list) == 3 and reg_list[1] == '..':
                        def idx(r):
                            return int(r[1:]) + (10000 if r.startswith('p') else 0)
                        a, b = idx(reg_list[0]), idx(reg_list[2])
                        got = abs(b - a) + 1
                        need = slot_count(psig) + (0 if 'static' in kind else 1)
                        if got != need:
                            bad += 1
                            print(f'⚠️  {p}:{ln}\n'
                                  f'      {kind} {cls}->{meth}({psig}){ret}\n'
                                  f'      传了 {got} 个寄存器（range），应为 {need}')
                        continue
                    need = slot_count(psig)
                    if 'static' not in kind:
                        need += 1                      # this
                    got = len(reg_list)
                    if got != need:
                        bad += 1
                        print(f'⚠️  {p}:{ln}\n'
                              f'      {kind} {cls}->{meth}({psig}){ret}\n'
                              f'      传了 {got} 个寄存器，应为 {need}')
    print(f'\n=== 可疑调用：{bad} 处 ===')
    return 1 if bad else 0

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    sys.exit(main(sys.argv[1:]))
