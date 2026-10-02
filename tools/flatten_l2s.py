#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""flatten_l2s.py —— 把沙箱存储层的"链式软链"平铺成普通文件 🐲

背景（2026-10-02 事故后新增）：
  RikkaHub 工作区的文件系统会把「经 rename 写入」的文件存成：
      可见名 -> .l2s.<名>NNNN -> .l2s.<名>NNNN.0001（真身）
  只要这个目录**不发生移动**，一切正常；但一旦整树被移动/搬迁过，
  链接里的绝对路径失效，即使手工改写链接前缀，**新做的链接 lstat 语义也可能是坏的** ——
  git 的快速有效性检查（show-ref 的 ref 校验等）会因此误报 "bad ref / not a valid object"。

  本脚本把**可见名**（不含 .l2s* 的名字）平铺为普通文件（读→删→原地写回）：
    · 内容不变、对象哈希不变；· lstat/stat 全部恢复正常语义；· .l2s* 原件保留不动（绝不删！）

用法：
    python3 tools/flatten_l2s.py [/workspace/.git]
"""
import os
import sys

root = sys.argv[1] if len(sys.argv) > 1 else '/workspace/.git'

fixed = []
skipped = []
for dp, dn, fn in os.walk(root, followlinks=False):
    for name in list(dn) + list(fn):
        if name.startswith('.l2s.'):
            continue                      # 数据原件的链，保留不动
        p = os.path.join(dp, name)
        try:
            os.readlink(p)                # 只有链式条目才有 readlink
        except OSError:
            continue
        try:
            data = open(p, 'rb').read()
        except Exception as e:
            skipped.append((p, str(e)))
            continue
        try:
            os.remove(p)
            with open(p, 'wb') as f:
                f.write(data)
            os.chmod(p, 0o444 if '/objects/' in p else 0o644)
            fixed.append((p, len(data)))
        except Exception as e:
            skipped.append((p, str(e)))

print('flattened: %d' % len(fixed))
for p, n in fixed[:10]:
    print('  %s (%d B)' % (p, n))
if skipped:
    print('skipped: %d' % len(skipped))
    for p, e in skipped[:10]:
        print('  %s :: %s' % (p, e))

# 留档
try:
    with open('/workspace/backups/小窝-20261002-平铺清单.txt', 'w') as f:
        for p, n in fixed:
            f.write('%s\t%d\n' % (p, n))
    print('清单已存：backups/小窝-20261002-平铺清单.txt')
except Exception as e:
    print('清单写入失败:', e)
