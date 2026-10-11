#!/usr/bin/env python3
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
# Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
"""
i18n_dragon.py —— 把人话生成「龙龙语」🐲

为什么要脚本而不是手写 771 条：手写会写漏、也会写歪；脚本至少**一致**，
而且主人看到哪句不顺眼，改这里一行、重跑即可。

策略（保守优先，宁可少变也不要变歪）：
  ① **词库替换**：长词优先（"系统提示词" 命中就别再拆成 "系统" + "提示词"）
  ② **语气尾巴**：没命中词库的句子加个龙味尾巴（"，嗷呜" / "，咕噜"），
     短标签加 "嗷" / "咕" / "～"（按 key 稳定选取，所以每次生成结果一样）
  ③ **长段落不动**：超过 `MAX_TAIL_LEN` 的整段（帮助正文 / 致谢）保持人话 ——
     它们是"读的东西"，翻歪了只会让人看不懂（要翻告诉我，我单独写）

用法：
    python3 tools/i18n_dragon.py gen     # 生成/覆盖 fdm-app/i18n/zz.json
    python3 tools/i18n_dragon.py show 30 # 抽 30 条看效果
"""
import hashlib
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
I18N = os.path.join(ROOT, "fdm-app", "i18n")
KEYS = os.path.join(I18N, "keys.json")
ZZ = os.path.join(I18N, "zz.json")

MAX_TAIL_LEN = 26          # 超过这么长的句子：只在"命中词库"时改，否则保持人话

# ── 词库：长词写前面（按长度降序排过） ─────────────────────────────
LEX = {
    # ★ 只收"换完还是同义词、绝不会改错意思"的（安全第一）
    # 导航 / 页面
    "关于尼尼": "关于尼尼",
    "功能原理 & 帮助": "本事原理 & 帮忙",
    "首页": "窝",
    "返回": "回窝",
    "帮助": "帮忙",
    "更多": "还有啥",
    "调试": "修毛病",
    "美化": "打扮",
    "过检": "躲检查",
    "聊天": "唠嗑",
    # 动作
    "保存": "存好",
    "删除": "咬掉",
    "复制": "再叼一份",
    "添加": "叼来",
    "清空": "全倒掉",
    "取消": "算了",
    "确认": "好嗷",
    "确定": "好嗷",
    "恢复默认": "回原来那样",
    # 概念（都是"同义且可爱"的）
    "宿主": "大窝",
    "模块": "小挂",
    "抽屉": "窝边",
    "空白容器": "空空的窝",
    "液态玻璃": "水玻璃",
    "气泡": "泡泡",
    "背景": "窝底",
    "失败": "没成",
    "成功": "成啦",
}

TAIL_LABEL = ["嗷", "咕", "～嗷", "嗷呜"]
TAIL_SENT = ["，嗷呜", "，咕噜", "，嗷～", "，嗷呜咕"]


def _pick(key, arr):
    """按 key 稳定挑一个（同一句永远同一个尾巴，生成可复现）。"""
    h = int(hashlib.md5(key.encode("utf-8")).hexdigest()[:8], 16)
    return arr[h % len(arr)]


def dragon(key, human):
    text = human
    # ① 词库（长词优先）
    hits = 0
    for w in sorted(LEX, key=len, reverse=True):
        if w in text:
            # 「关于」在「关于尼尼」里别二次替换
            text = re.sub(re.escape(w), LEX[w], text)
            hits += 1
    # ② 全是英文/符号/URL 的，原样
    if not re.search(r"[\u4e00-\u9fff]", text):
        return text
    if hits:
        # 命中了词库 ⇒ 已经够龙了，短句再加个尾
        if len(text) <= 8 and "\n" not in text and not re.search(r"[。！？!?：:，,、—…\.]$", text):
            return text + _pick(key, TAIL_LABEL)
        return text
    # ③ 没命中：短句加尾巴，长段/多行/不明结尾的保持人话
    if len(human) > MAX_TAIL_LEN:
        return None                      # None = 不写进 zz.json ⇒ 自动回落人话
    if "\n" in text:
        return None                      # ★ 多行串别加尾（尾巴会飘到下一行去）
    if re.search(r"[。！？!?]$", text):
        return text[:-1] + _pick(key, TAIL_SENT) + text[-1]
    if re.search(r"[：:—－～~、,，…\.]$", text):
        return None                      # ★ 以标点/破折号收尾的，加尾反而怪
    if len(text) <= 6:
        return text + _pick(key, TAIL_LABEL)
    return text + _pick(key, TAIL_SENT)


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "gen"
    keys = json.load(open(KEYS, encoding="utf-8"))
    old = json.load(open(ZZ, encoding="utf-8")) if os.path.exists(ZZ) else {}
    out = {}
    for k, v in keys.items():
        if k == "app_name":
            continue
        d = dragon(k, v)
        if d is not None:
            out[k] = d
    if cmd == "show":
        n = int(sys.argv[2]) if len(sys.argv) > 2 else 30
        for i, k in enumerate(sorted(out)):
            if i % max(1, len(out) // n) == 0:
                print("%-14s %-34s → %s" % (k, keys[k][:33], out[k]))
    else:
        json.dump(out, open(ZZ, "w", encoding="utf-8"), ensure_ascii=False, indent=1, sort_keys=True)
        print("zz.json：%d 条（原始 %d 条，%d 条仍回落人话）"
              % (len(out), len(keys), len(keys) - len(out)))


if __name__ == "__main__":
    main()
