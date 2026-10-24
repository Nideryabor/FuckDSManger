// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

/**
 * GmRemap —— 宿主锚点重映射表（**一处维护，全局一致**）🐲 尼得亚伯
 *
 * 历史：
 *   2026-10-01 建表（2.5.2 → 2.6.1），键 = 2.5.2 名
 *   2026-10-16 升级为「**多代键**」（2.5.2 与 2.6.1 都收），值 = **2.6.2**
 *
 * 为什么要「多代键」（本轮血泪）：
 *   底座各文件不是同一代写的 —— GmEntry 的 hookM 用 **2.5.2 名**（走本表），
 *   但 GmBubble/GmSync/GmEnv… 是**直接 findClass**、且被上一轮**文本替换成 2.6.1 名**；
 *   更坑的是 GmEntry 里还有**寄存器共享**：
 *       const-string v7, "ao1"   → hookM(p1, v7, "I", …)      ← v7 走本表
 *                                → findClass(v7, p1)          ← 同一个 v7！
 *   ⇒ 改字面量会「连累」另一条路径。**所以不再改字面量，改成一律过本表。**
 *   ⇒ 本表同时收 2.5.2 / 2.6.1 两代键，统一输出 2.6.2。
 *
 * 另一条铁律（2.6.2 实测）：
 *   **R8 是「部分重排」** —— 2.6.1 的名字在 2.6.2 里 42/42 全都还在，
 *   但一批**换了主人**（例：`hs7` 从"建议视图"变成"某个小类"）。
 *   ⇒ 绝不能凭名字放行，必须「按形不按名」（串指纹 / 形状 / 形参逐位）。
 *   `yb5→hs7` 就是这么坏的：hookAllMethods 命中 0 个方法 ⇒ 建议功能静默失效。
 *
 * 安全铁律（沿用）：
 *   没定位出来的锚点 → 返回必然不存在的类名 ⇒ findClass 抛异常 ⇒ 调用方 catch 吞掉 ⇒
 *   **那一条 hook 不注册**。宁可不干活，也不要挂到错误的类上乱咬宿主。
 */
public final class GmRemap {

    /** 必然不存在的类名前缀 —— 让 findClass 干净地失败 */
    private static final String GONE = "com.gm.gone.";

    private GmRemap() {}

    // ── 宿主类名：{2.5.2 名, 2.6.1 名, 2.6.2 名}（null = 未定位 ⇒ 安全跳过）
    private static final String[][] CLS3 = {
        //  2.5.2   2.6.1   2.6.2
        {"kf5", "kh7", "j77"},   // 杂物间（painterResource）★ 串 painterResource
        {"fh6", "w2b", "e3c"},   // Modifier.paint           ★ a0(Lgc7;Ll18;Lca;Lc83;FLon0;I)Lgc7;
        {"me4", "pe5", "pe5"},   // 图标 Hook 锚             ★ fp_match 100% 形状全同
        {"m5",  "t5",  "t5"},    // 入口：设置行→路由桶      ★ 串 batch_management_click
        {"h91", "d12", "j12"},   // 消息列表 Composable      ★ 11 形参逐位 + ChatMessageList.kt:78
        {"p5",  "x5",  "x5"},    // 账号头像桶/用户头像      ★ 方法体指纹：31 cast/15 uniq 完全一致 + cast 含 Lxbb;（↔Ld9b;）
                                 //   ⚠️ 2026-10-16 修：曾误判为 ai5（同为 lambda 形状，靠 cast 数才分开）
        {"pn9", "i93", "jtb"},   // 气泡单元 Composable      ★ f(ILyf6;Lu32;Lns;Llr;Lgc7;Lby4;I)V
        {"ls9", "ua0", "xa0"},   // 气泡作用域               ★ fp_match 100% 形状全同
        {"uia", "qk7", "us6"},   // Modifier 扩展桶          ★ y(Lgc7;Lnq0;Laq9;I)Lgc7;
        {"tn0", "jq0", "oq0"},   // ShaderBrush 实现         ★ 逐行相同 <init>(RuntimeShader)+b(J)Shader
        {"jd8", "dn9", "xp9"},   // 气泡阴影                 ★ fp_match 100% 5/5
        {"se0", "eh0", "ih0"},   // 背景 Element             ☆ fp_shape 4.00
        {"zc",  "pr6", "qn7"},   // ChatPage 作用域          ★ 串 STRIKETHROUGH/INLINE_MATH
        {"s5",  "a6",  "a6"},    // 账号名桶                 ★ fp_match 100% 形状全同
        {"p66", "m97", "tb7"},   // 配置源头 model 域        ★ fp_match 100% + h() 未变
        {"h02", "yt2", "bu2"},   // 配置源头 main 域         ★ fp_match 98.6% + v() 未变
        {"ao1", "gh2", "kh2"},   // 会话提供接口             ★ fp_match 100% + session_closed
        {"bx4", "py5", "py5"},   // 下发数据对象             ★ 同名同形
        {"yb5", "hs7", "rd7"},   // 建议 Prompt 视图         ★ 5 条 SourceInfo 全重合（hs7 在 2.6.2 是别的类！）
        {"pd5", "i93", "rb7"},   // 提示词文本               ★ K(Lja7;Landroid/content/Context;)Ljava/lang/String;
        {"hp8", "dz9", "w1a"},   // 渲染列表                 ★ fp_match 100%
        {"wr",  "ns",  "ns"},    // 消息主存储               ★ 同名同形 f:LinkedHashMap
        {"sr9", "zx8", "r09"},   // 字节 APM root 检测       ★ fp_match 100% + /sbin/su
        {"lp9", "s4b", "l7b"},   // Kotlin Unit 单例         ★ fp_match 100% 形状全同
        {"le",  "af",  "cf"},    // 图像包装                 ★ 逐行相同 + 被当 Laf5 传
        {"ok0", "an0", "dn0"},   // BitmapPainter            ★ 逐行相同（字段 f/g/h/i/j 全同）
        {"ku6", "mz7", "l18"},   // Painter 基类             ★ dn0.super Ll18; + fp_shape 4.00
        {"vq",  "mr",  "lr"},    // 消息基类                 ★ fp_match 100%
        {"c76", "x97", "gc7"},   // Modifier 接口            ★ fp_shape 4.00 + C(Lgc7;)Lgc7;
        {"ey3", "yx4", "by4"},   // Compose Composer         ★ 类型投票 12 票
        {"sn0", "iq0", "nq0"},   // Brush                    ★ cp9.super Lnq0;
        {"dd8", "im9", "cp9"},   // ShaderBrush（抽象）      ★ oq0.super Lcp9;
        {"md8", "gn9", "aq9"},   // Shape                    ★ us6.y 第 3 参 + 1 方法接口
        {"we5", "pz7", "rw8"},   // GmReplyHook 用           ★ fp_match 100%
        {"vk0", "jn0", "on0"},   // GmPaintModHook 用        ★ fp_match 100% 形状全同
        {"gz3", "bz4", "ez4"},   // GmCallDialog 用          ★ fp_match 100% 形状全同
        {"it9", "d9b", "xbb"},   // 账号数据类               ☆ fp_shape 4.00
        {"u19", "u19", "m49"},   // Shape 工厂               ★ 逐行相同 a()/b(F)/c(FFFF)/d(FFI)/e()
        {"g56", "g87", "ja7"},   // 建议/快捷项 item 类       ★ 逐行相同（字段 a/b/c/d + 双构造器）
                                 //   ⚠️ 2026-10-16 补录：此前缺此行 ⇒ findClass("g87") 落到 2.6.2 的同名
                                 //      协程 lambda ⇒ newInstance 失败 ⇒ 建议列表构造静默失效
    };

    // ── (类.旧方法) → 新方法（键可用 2.5.2 或 2.6.1 名；没登记 = 没改名）
    private static final String[][] MTH = {
        {"kf5.K",  "p",  "kh7.K",  "p"},    // ★ 2.6.1=x → 2.6.2=p（对齐分 207）
        {"fh6.N",  "a0", "w2b.N",  "a0"},   // ★ 2.6.1=Y → 2.6.2=a0
        {"m5.v",   "w",  "t5.v",   "w"},    // 入口行点击
        {"p5.v",   "w",  "x5.v",   "w"},
        {"s5.v",   "w",  "a6.v",   "w"},
        {"h91.a",  "a",  "d12.a",  "a"},    // 未变
        {"pn9.c",  "f",  "i93.c",  "f"},    // ★ 2.6.1=i → 2.6.2=f（八参逐位）
        {"ls9.f",  "g",  "ua0.f",  "g"},    // ★ 2.6.1=e → 2.6.2=g
        {"zc.s",   "p",  "pr6.s",  "p"},    // ★ 2.6.1=j → 2.6.2=p
        {"tn0.b",  "b",  "jq0.b",  "b"},    // 未变
        {"se0.c",  "g",  "eh0.c",  "g"},    // ★ 2.6.1=c → 2.6.2=g
        {"uia.u",  "y",  "qk7.C",  "y"},    // ★ 2.5.2=u（4参）→ 2.6.2=y
        {"uia.v",  "z",  "qk7.D",  "z"},    // ★ 2.5.2=v（3参）→ 2.6.2=z（原先误写 x）
        {"p66.h",  "h",  "m97.h",  "h"},    // 未变（model 域下发）
        {"h02.u",  "v",  "yt2.u",  "v"},    // 未变（main 域下发）
        {"ao1.I",  "k",  "gh2.I",  "k"},    // 未变
        {"ao1.J",  "l0", "gh2.J",  "l0"},   // 未变
        {"ao1.M",  "W",  "gh2.M",  "W"},    // 未变
        {"bx4.get","get","py5.get","get"},  // 未变（下发数据对象）
        {"yb5.e",  "c",  "hs7.e",  "c"},    // ★ 2.6.1=e → 2.6.2=c（九参逐位）
        {"yb5.f",  "d",  "hs7.f",  "d"},    // ★ 2.6.1=f → 2.6.2=d（九参逐位）
        {"pd5.I",  "K",  "i93.I",  "K"},    // ★ 2.6.1=S → 2.6.2=K
        {"pd5.H",  "J",  "i93.H",  "J"},    // ★ 2.6.1=R → 2.6.2=J
        {"wr.x",   "D",  "ns.x",   "D"},    // 未变（消息主存储）
        {"wr.z",   "F",  "ns.z",   "F"},    // 未变
        {"me4.a",  "a",  "pe5.a",  "a"},    // 未变（7 参 12 分）
        {"hp8.isEmpty","isEmpty","dz9.isEmpty","isEmpty"},  // 未变
        {"sr9.w",  "C",  "zx8.w",  "C"},    // ★ 字节 APM root 检测：2.6.1=w → 2.6.2=C
    };

    /**
     * 宿主类名重映射（**支持多代键**）。
     * 未登记 ⇒ 原样放行（系统类 / 第三方库）；已登记但未定位 ⇒ 返回 GONE 假名，让 findClass 安全失败。
     */
    public static String cls(String old) {
        if (old == null) return GONE + "null";
        for (String[] p : CLS3) {
            // p[0]=2.5.2, p[1]=2.6.1, p[2]=2.6.2
            if (p[0].equals(old) || (p[1] != null && p[1].equals(old))) {
                if (p[2] == null) return GONE + p[0];   // 未定位 ⇒ 安全跳过
                return p[2];
            }
        }
        return old;   // 不是宿主锚点 —— 原样放行
    }

    /** 方法名重映射（**支持多代键**）；没登记就是没改名，原样返回 */
    public static String method(String oldCls, String oldMethod) {
        if (oldCls == null || oldMethod == null) return oldMethod;
        String k = oldCls + "." + oldMethod;
        for (String[] p : MTH) {
            if (p[0].equals(k) || (p[2] != null && p[2].equals(k))) return p[1];
        }
        return oldMethod;
    }
}
