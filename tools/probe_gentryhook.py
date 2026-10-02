#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
probe_gentryhook.py —— 给 GmEntryHook 插一条「自证探针」  🐲

目的：2.6.1 把设置行的**行号表**换了（旧宿主 case 0x14 = 检查更新行；新宿主 ew1 只有 13 个 case）。
      与其猜，不如让 dex 自己说：每次点设置行都把 `thisObject.a` 打出来，
      主人点一下「检查更新」行，日志里就写着答案。

寄存器：.registers 8 且有 2 个参数 ⇒ p0=v6,p1=v7；原码只用 v0..v3 ⇒ v4/v5 空闲。
"""
import sys

P = sys.argv[1]
txt = open(P, encoding='utf-8').read()

SNIP = """
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "FDS row a="

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/16 v2, 0x14
"""

old = """
    const/16 v2, 0x14
"""
assert txt.count(old) == 1, '锚点不唯一/不存在：%d' % txt.count(old)
txt = txt.replace(old, SNIP, 1)
open(P, 'w', encoding='utf-8').write(txt)
print('✓ GmEntryHook 探针已插')
