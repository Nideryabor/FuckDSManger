// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

/**
 * GmRemap —— 宿主 2.5.2 → 2.6.1 的锚点重映射表 🐲 尼得亚伯 2026-10-01
 *
 * 为什么放在这里（而不是去改底座那 100 多处字符串）：
 *   底座的 GmEntry 里**寄存器被复用**，同一个字符串 "v" 同时被 m5/uia/s5 三个锚点引用，
 *   而它们要映射到不同的新方法名（w / D / w）⇒ 纯文本替换必然出错。
 *   ⇒ 把映射放到**运行时**：hookM 一进来先查表，一处维护、绝对一致。
 *
 * 安全铁律（本轮最贵的教训）：
 *   没定位出来的锚点 → 返回一个**必然不存在**的类名 ⇒ findClass 抛异常 ⇒
 *   hookM 自己的 catch 吞掉 ⇒ **那一条 hook 不注册**。
 *   宁可不干活，也不要挂到错误的类上乱咬宿主。
 */
public final class GmRemap {

    /** 必然不存在的类名前缀 —— 让 findClass 干净地失败 */
    private static final String GONE = "com.gm.gone.";

    private GmRemap() {}

    // ── 宿主类名：2.5.2 → 2.6.1（null 项 = 本轮未定位 ⇒ 安全跳过）
    private static final String[][] CLS = {
        {"kf5", "kh7"},   // 杂物间（painterResource）      ★★★
        {"fh6", "w2b"},   // Modifier.paint                 ★★★
        {"me4", "pe5"},   // 图标 Hook 锚                   ★★★
        {"m5",  "t5"},    // 入口：设置行→路由桶（含串 batch_management_click；分支 sget Lz32;->a）★★★
        {"h91", "d12"},   // 消息列表 Composable            ★★★
        {"p5",  "x5"},    // 账号头像桶                     ★★★
        {"pn9", "i93"},   // 气泡单元 Composable            ★★★
        {"ls9", "ua0"},   // 气泡作用域                     ★★★
        {"uia", "qk7"},   // Modifier 扩展桶                ★★★
        {"tn0", "jq0"},   // ShaderBrush 实现               ★★★
        {"jd8", "dn9"},   // 气泡阴影                       ★★★
        {"se0", "eh0"},   // 背景 Element                   ★★★
        {"zc",  "pr6"},   // ChatPage 作用域                ★★★
        {"s5",  "a6"},    // 账号名桶                       ★★★
        {"p66", "m97"},   // 配置源头 model 域              ★★★
        {"h02", "yt2"},   // 配置源头 main 域               ★★★
        {"ao1", "gh2"},   // 会话提供接口                   ★★★
        {"bx4", "py5"},   // 下发数据对象                   ★★★
        {"yb5", "hs7"},   // 建议 Prompt 视图               ★★★
        {"pd5", "i93"},   // 提示词文本（与 pn9 合并进 i93） ★★★
        {"hp8", "dz9"},   // 渲染列表                       ★★★
        {"wr",  "ns"},    // 消息主存储                     ★★★
        {"sr9", "zx8"},   // 字节 APM root 检测             ★★★
        {"lp9", "s4b"},   // Kotlin Unit 单例               ★★★
        {"le",  "af"},    // 图像包装                       ★★★
        {"ok0", "an0"},   // BitmapPainter                  ★★★
        {"ku6", "mz7"},   // Painter 基类                   ★★★
        {"vq",  "mr"},    // 消息基类                       ★★☆
        {"c76", "x97"},   // Modifier 接口                  ★★★
        {"ey3", "yx4"},   // Compose Composer               ★★★
        {"sn0", "iq0"},   // Brush                          ★★★
        {"dd8", "im9"},   // ShaderBrush                    ★★★
        {"md8", "gn9"},   // Shape                          ★★★
        {"we5", "pz7"},   // GmReplyHook 用                 ★★☆
        {"vk0", "jn0"},   // GmPaintModHook 用              ★★★
        {"gz3", "bz4"},   // GmCallDialog 用                ★★★
        {"it9", "d9b"},   // 账号数据类                     ★★★
        // ↓↓↓ 本轮未定位 —— 安全跳过（不改名、不注册）
        {"yp1", null},    // ASR/门控（满树未找到唯一候选）
        {"um1", null},    // 状态机信号
        {"cn1", null},    // 打字发送命令（2.6.1 未定位；发送改走 gh2.h0 —— 见 bridge/GmSender）
        {"c73", null}, {"tt7", null}, {"pr8", null},
        {"g56", null}, {"c1", null},  {"i1", null},
    };

    // ── (宿主类.旧方法) → 新方法（只在改名了的地方写）
    private static final String[][] MTH = {
        {"m5.v",   "w"},
        {"p5.v",   "w"},
        {"s5.v",   "w"},
        {"kf5.K",  "x"},
        {"fh6.N",  "Y"},
        {"h91.a",  "a"},
        {"pn9.c",  "i"},
        {"ls9.f",  "e"},
        {"zc.s",   "j"},
        {"tn0.b",  "b"},
        {"se0.c",  "c"},
        {"uia.u",  "C"},
        {"uia.v",  "D"},
        {"p66.h",  "h"},
        {"h02.u",  "v"},
        {"ao1.I",  "k"},
        {"ao1.J",  "l0"},
        {"ao1.M",  "W"},
        {"bx4.get","get"},
        {"yb5.e",  "e"},
        {"yb5.f",  "f"},
        {"pd5.I",  "S"},
        {"pd5.H",  "R"},
        {"wr.x",   "D"},
        {"wr.z",   "F"},
        {"me4.a",  "a"},
        {"hp8.isEmpty", "isEmpty"},
    };

    /** 宿主类名重映射；未登记/未定位 ⇒ 返回 GONE 前缀的假名，让 findClass 安全失败 */
    public static String cls(String old) {
        if (old == null) return GONE + "null";
        for (String[] p : CLS) {
            if (p[0].equals(old)) {
                if (p[1] == null) return GONE + p[0];   // 未定位 ⇒ 安全跳过
                return p[1];
            }
        }
        return old;   // 不是宿主锚点（系统类 / 第三方库）—— 原样放行
    }

    /** 方法名重映射；没登记就是没改名，原样返回 */
    public static String method(String oldCls, String oldMethod) {
        if (oldCls == null || oldMethod == null) return oldMethod;
        String k = oldCls + "." + oldMethod;
        for (String[] p : MTH) {
            if (p[0].equals(k)) return p[1];
        }
        return oldMethod;
    }
}
