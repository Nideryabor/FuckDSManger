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

# ★ 手写表（键 = 人话原文，值 = 龙龙语）—— 主人也能直接改这个文件
HAND_FILE = os.path.join(I18N, "dragon_hand.json")

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


def tailable(t):
    """配不配加尾巴？🐲

    主人 2026-10-11：「很多地方只是加了嗷和咕」—— 所以这里故意定得很严：
      · 长说明（>14 字）不加 —— 加在技术说明尾巴上只会显得吵
      · 开头/结尾是标点的一律不加 —— 那些是**被拼进句子的片段**
        （如 `字节）`、`内容（`、`（无）`、` 字）`），加尾巴会插到句子中间 ✗
      · 带括号的不加 —— 多是说明/单位/英文注
      · 必须**本来就是一句话**（里面有逗号/顿号/分号这种句子结构）才加
    其余一律保持人话（靠资源 fallback），等手写表来收。
    """
    if "\n" in t or len(t) > 14:
        return False
    if re.match(r"^[\s（()【】「」·—\-…、，,。：:；;]", t):
        return False
    if re.search(r"[（()【】「」：:，,、；;—…]$", t):
        return False
    if re.search(r"[（()【】「」]", t):
        return False
    return bool(re.search(r"[。！？，、；]", t))


def dragon(key, human):
    """返回龙龙语；返回 None = **保持人话**（不写进 zz.json，靠资源 fallback）。"""
    text = human

    # ① 手写表最优先（精确匹配整句）
    if text in HAND:
        return HAND[text]

    # ② 词库（长词优先，只收"换完还是同义词"的）
    hits = 0
    for w in sorted(LEX, key=len, reverse=True):
        if w in text:
            text = re.sub(re.escape(w), LEX[w], text)
            hits += 1
    if not re.search(r"[\u4e00-\u9fff]", text):
        return text                                  # 纯英文/符号：原样
    if hits:
        # 命中词库 ⇒ 已经"龙"过了；只有整句才再加尾
        if tailable(human) and not re.search(r"[。！？：:—…、,\.]$", text):
            return text + _pick(key, TAIL_SENT)
        return text

    # ③ 没命中：短句/短标签加尾巴；**光秃秃的长标签宁可保持人话**
    if len(human) > MAX_TAIL_LEN or "\n" in human:
        return None
    if re.search(r"[。！？]$", human):
        return human[:-1] + _pick(key, TAIL_SENT) + human[-1]
    if re.search(r"[：:—－～~、,，…\.]$", human):
        return None
    if tailable(human):
        return human + _pick(key, TAIL_SENT)
    # ↓★ 关键改动：**光秃秃的标签一律不加尾巴**。
    #   主人 2026-10-11：「很多地方只是加了嗷和咕」—— 那是偷懒，不是翻译。
    #   现在：标签要么被手写表/词库真正改写，要么**保持人话**（资源 fallback）。
    #   尾巴只留给"像一句话"的（上面 _sentence_like 那一支）。
    return None


HAND = {}
if os.path.exists(HAND_FILE):
    HAND = {k: v for k, v in json.load(open(HAND_FILE, encoding="utf-8")).items()
            if not k.startswith("_")}


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "gen"
    keys = json.load(open(KEYS, encoding="utf-8"))
    human_set = set(keys.values())
    old = json.load(open(ZZ, encoding="utf-8")) if os.path.exists(ZZ) else {}
    out = {}
    n_hand = n_lex = n_tail = 0
    for k, v in keys.items():
        if k == "app_name":
            continue
        d = dragon(k, v)
        if d == v:
            d = None            # 跟人话一模一样 ⇒ 没必要占一条 zz 变体
        if d is not None:
            out[k] = d
            if v in HAND:
                n_hand += 1
            elif d != v:
                n_lex += 1          # 词库改写（含"短标签+尾巴"）
            else:
                n_tail += 1
    if cmd == "show":
        n = int(sys.argv[2]) if len(sys.argv) > 2 else 30
        for i, k in enumerate(sorted(out)):
            if i % max(1, len(out) // n) == 0:
                print("%-14s %-34s → %s" % (k, keys[k][:33], out[k]))
    else:
        json.dump(out, open(ZZ, "w", encoding="utf-8"), ensure_ascii=False, indent=1, sort_keys=True)
        dead = sorted(h for h in HAND if h not in human_set)
        print("zz.json：%d 条 / 原始 %d 条 ⇒ %d 条仍回落人话"
              % (len(out), len(keys), len(keys) - len(out)))
        print("  组成：手写表 %d 条（命中率 %.0f%%）· 词库改写 %d 条 · 只加尾巴 %d 条"
              % (n_hand, 100.0 * n_hand / max(1, len(HAND)), n_lex, n_tail))
        if dead:
            print("  ⚠️ 手写表里这 %d 条没对上任何原文（白写了，去看看）：" % len(dead))
            for d in dead[:20]:
                print("       %s" % d)

        # ★ 兜底：一句都不该"原样返回但被当鳞片数成 tail"------不适用于此


if __name__ == "__main__":
    main()
