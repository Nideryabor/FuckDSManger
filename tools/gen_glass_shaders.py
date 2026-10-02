#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_glass_shaders.py —— 把各方案的 AGSL 源码**逐字**生成成 Java 🐲

为什么要有这个脚本：
  液态玻璃这一块，我要同时支持多套方案（Haze / Cloudy / 参照物 …）。
  手抄 shader 进 Java 字符串 = 迟早抄错一个字符，而 AGSL 编译错误**很难看出来**。
  ⇒ shader 正文一律以 `.agsl` 文件为准，Java 由脚本生成。

用法:
    python3 tools/gen_glass_shaders.py

输入: 参考/液态玻璃多方案/*.agsl
输出: mod-src/src/com/nidyaber/fuckdsmanger/glass/GmGlassShaders.java
"""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "参考", "液态玻璃多方案")
DST = os.path.join(ROOT, "mod-src", "src", "com", "nidyaber",
                   "fuckdsmanger", "glass", "GmGlassShaders.java")

# 方案表：(常量名, 文件名, 说明)
PLANS = [
    ("HAZE",   "haze.agsl",   "Haze 式：sampleSize/materialOrigin/materialSize + over 合成 + 色散"),
    ("CLOUDY", "cloudy.agsl", "Cloudy 式：距离场折射 + RGB 色散 + 四重镜面高光 + 抖动防色带"),
    ("RIPPLE", "nadeem.agsl", "Nadeem 式：最轻的正弦扰动（没有真折射，但便宜）"),
]


# ─────────────────────────────────────────────────────────────────────────────
#  公共前奏：**「擦掉内容，只留背景」** 的采样器
#
#  主人 2026-09-30：「效果很好，但是还是会抓到别的文字……
#                    实在不行加个开关，打开只把特定颜色做折射背景」
#
#  根因：底图是 PixelCopy 截的**整屏**，连文字一起截进来了 ⇒ 玻璃里糊出字，
#        和上层清晰的字**叠影**。
#
#  做法：Java 侧从**元素边缘**估出背景色（边缘基本是纯背景），
#        再在 shader 里把「离背景色太远」的像素（= 文字/图标）替换成背景色。
#        ⇒ 底图干净，玻璃只折射"背景"。
#
#  下面的前奏**注入到每一套方案**里，并把正文里的 content.eval( 全部换成 fdmSample(。
# ─────────────────────────────────────────────────────────────────────────────
PRELUDE = """// ── fdm 公共前奏（由 tools/gen_glass_shaders.py 注入）──
uniform float fdmCleanOn;
uniform float fdmCleanTol;
uniform float4 fdmCleanColor;

half4 fdmSample(float2 p) {
    half4 c = content.eval(p);
    if (fdmCleanOn < 0.5) { return c; }
    float d = distance(float3(c.rgb), float3(fdmCleanColor.rgb));
    // 离背景色太远 ⇒ 认为是文字/图标 ⇒ 换成背景色
    return (d > fdmCleanTol) ? half4(half3(fdmCleanColor.rgb), c.a) : c;
}

// ── 「边缘过渡」公共件（2026-10-02 主人：「颜色没有过渡也很生硬」）──
//   sd = 有符号距离（负值 = 内部、0 = 边缘）⇒ 颜色从边缘往里柔和衰减。
//   fdmFade   = 强度 0..1（滑杆）
//   fdmFadePx = 过渡距离（px）；「仅边缘」= 边缘带宽；「正常」= 按元素尺寸取。
uniform float fdmFade;
uniform float fdmFadePx;

float fdmFadeFac(float sd) {
    float inner = clamp(-sd / max(fdmFadePx, 1.0), 0.0, 1.0);
    return 1.0 - fdmFade * inner;
}
// ──────────────────────────────────────────────
"""


def java_string(text: str, indent: int = 12) -> str:
    """把一段文本转成 Java 字符串字面量拼接（Java 8 没有 text block）。"""
    pad = " " * indent
    out = []
    for line in text.split("\n"):
        esc = line.replace("\\", "\\\\").replace('"', '\\"')
        out.append(f'{pad}+ "{esc}\\n"')
    # 去掉最后那个换行，避免多一个空行
    if out:
        out[-1] = out[-1].replace('\\n"', '"')
    # 第一行前面不带 +
    if out:
        out[0] = out[0].replace("+ ", "  ", 1)
    return "\n".join(out)


def main() -> int:
    if not os.path.isdir(SRC):
        print(f"✗ 找不到 {SRC}")
        return 1

    body = []
    for const, fname, desc in PLANS:
        path = os.path.join(SRC, fname)
        if not os.path.isfile(path):
            print(f"⚠️  跳过 {fname}（不在）")
            continue
        text = open(path, encoding="utf-8").read().rstrip("\n")
        # ★ 注入前奏 + 把所有 content.eval( 换成 fdmSample(
        #   （先换正文，前奏自己的那句 content.eval( 在 PRELUDE 里）
        text = text.replace("content.eval(", "fdmSample(")

        # ⚠️ 前奏必须插在 `uniform shader content;` **之后**！
        #    前奏里的 fdmSample() 用到了 content —— 如果前奏在前面，
        #    AGSL 会报 `error: 7: unknown identifier 'content'`（真机踩过）。
        anchor = "uniform shader content;"
        i = text.find(anchor)
        if i >= 0:
            j = text.find("\n", i)
            j = len(text) if j < 0 else j + 1
            text = text[:j] + PRELUDE + text[j:]
        else:
            text = PRELUDE + text      # 兜底（理论上不会走到）
        body.append(f"    /** {desc} */")
        body.append(f"    static final String {const} =")
        body.append(java_string(text))
        body.append("            ;\n")
        print(f"✓ {const}  ← {fname}  ({len(text)} 字符 / {text.count(chr(10))+1} 行)")

    header = '''package com.nidyaber.fuckdsmanger.glass;

/**
 * 液态玻璃 · **多方案 shader 表** 🐲
 *
 * <p>⚠️ <b>本文件由脚本生成，不要手改</b> ——
 * 跑 `python3 tools/gen_glass_shaders.py` 重新生成。
 * shader 正文以 `参考/液态玻璃多方案/*.agsl` 为准（逐字，不手抄）。
 *
 * <p>为什么要多方案：主人 2026-09-30 拍板「**再疯一点：多方案切换**」——
 * 社区里几个活跃实现思路差别很大，与其猜哪个好，不如**让用户切着试**。
 */
final class GmGlassShaders {

    private GmGlassShaders() {
    }

'''
    src = header + "\n".join(body) + "}\n"
    os.makedirs(os.path.dirname(DST), exist_ok=True)
    open(DST, "w", encoding="utf-8").write(src)
    print(f"\n→ 写出 {DST}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
