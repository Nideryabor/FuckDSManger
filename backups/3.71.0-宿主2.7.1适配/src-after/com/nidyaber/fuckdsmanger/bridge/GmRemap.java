// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

/**
 * GmRemap —— 宿主锚点重映射表（**一处维护，全局一致**）🐲 尼得亚伯
 *
 * 历史：
 *   2026-10-01 建表（2.5.2 → 2.6.1），键 = 2.5.2 名
 *   2026-10-16 升级为「**多代键**」（2.5.2 与 2.6.1 都收），值 = **2.6.2**
 *   2026-10-24 升级为「**四代键 + 拆类**」，值 = **2.7.1**
 *
 * 为什么要「多代键」（2.6.2 轮的血泪）：
 *   底座各文件不是同一代写的 —— GmEntry 的 hookM 用 **2.5.2 名**（走本表），
 *   但 GmBubble/GmSync/GmEnv… 是**直接 findClass**、且被上一轮**文本替换成 2.6.1 名**；
 *   更坑的是 GmEntry 里还有**寄存器共享**：
 *       const-string v7, "ao1"   → hookM(p1, v7, "I", …)      ← v7 走本表
 *                                → findClass(v7, p1)          ← 同一个 v7！
 *   ⇒ 改字面量会「连累」另一条路径。**所以不再改字面量，改成一律过本表。**
 *
 * 2.7.1 新增的两个概念（本轮实测）：
 *
 *   ① **拆类**：R8 会把合并出来的大杂烩类重新切开，而且是**按业务域聚簇**分。
 *      `us6`(51 方法) → `p68` + `dz7` + `r0b`（共 175 方法，3.4×）
 *      `jtb`(96 方法) → `szb` + `x4c` + `fxb`（共 219 方法，2.3×）
 *      ⇒ 本表的值**允许逗号分隔多个类**；`clsAll()` 返回数组，`cls()` 取第一个。
 *
 *   ② **方法会跑到别的碎片**：`qn7` 的 48 个方法里 **47 个在 `jr7`，
 *      只有 `s`（GotoBottomButton）跟着 `ChatFloatingToolViewV2` 域跑到了 `dz7`**。
 *      ⇒ **`cls("qn7")` = `jr7` 是错的！** 必须用 `clsFor(类,方法)` 按方法查 owner。
 *      ⇒ 走 MTH 的钩子，类名一律用 `clsFor()` / `methodOwner()`，**不要用 `cls()`**。
 *
 * 安全铁律（沿用）：
 *   没定位出来的锚点 → 返回必然不存在的类名 ⇒ findClass 抛异常 ⇒ 调用方 catch 吞掉 ⇒
 *   **那一条 hook 不注册**。宁可不干活，也不要挂到错误的类上乱咬宿主。
 */
public final class GmRemap {

    /** 必然不存在的类名前缀 —— 让 findClass 干净地失败 */
    private static final String GONE = "com.gm.gone.";

    private GmRemap() {}

    // ══════════════════════════════════════════════════════════════════
    //  宿主类名：{2.5.2, 2.6.1, 2.6.2, 2.7.1}
    //  · 值允许逗号分隔（R8 拆类）
    //  · null = 未定位 ⇒ 安全跳过
    // ══════════════════════════════════════════════════════════════════
    private static final String[][] CLS4 = {
        //  2.5.2   2.6.1   2.6.2              2.7.1
        {"kf5", "kh7", "j77",  "pc7"},         // 杂物间（painterResource）★ 串 PainterResources.android.kt
        {"fh6", "w2b", "e3c",  "kmc"},         // Modifier.paint ★ a0(6类型逐位)→e0；★合并了 pic
        {"me4", "pe5", "pe5",  "th5"},         // 图标 Hook 锚 ★ 签名逐位
        {"m5",  "t5",  "t5",   "u5"},          // 入口：设置行→路由桶 ★ 串 batch_management_click
        {"h91", "d12", "j12",  "j32"},         // 消息列表 Composable ★ 串 messageListWidth
        {"p5",  "x5",  "x5",   "x5"},          // 账号头像桶 ★ 真幸存；cast Lzfb 唯一
        {"pn9", "i93", "jtb",  "szb,x4c,fxb"}, // 气泡单元 Composable ★★ 拆 3（八参逐位→szb.o）
        {"ls9", "ua0", "xa0",  "za0"},         // 气泡作用域 ★ 8 串中 7 条逐字相同
        {"uia", "qk7", "us6",  "p68,dz7,r0b"}, // Modifier 扩展桶 ★★ 拆 3
        {"tn0", "jq0", "oq0",  "or0"},         // ShaderBrush 实现 ★ 字段 c:I/d:Object 同形
        {"jd8", "dn9", "xp9",  "pt9"},         // 气泡阴影 ★ fp_match 100% 5/5
        {"se0", "eh0", "ih0",  "fi0"},         // 背景 Element ★ 4 字段 + ctor 逐位
        {"zc",  "pr6", "qn7",  "jr7"},         // ChatPage 作用域 ★ 串 STRIKETHROUGH/INLINE_MATH
                                               //   ⚠️ 但方法 s 在 dz7！见 MTH + clsFor()
        {"s5",  "a6",  "a6",   "z5"},          // 账号名桶 ★★ 2.7.1 的 a6 已换主人（r(Object,Object)Object）
        {"p66", "m97", "tb7",  "rf7"},         // 配置源头 model 域 ★ fp_match 100% + h() 未变
        {"h02", "yt2", "bu2",  "iw2"},         // 配置源头 main 域 ★ fp_match 97.2%
        {"ao1", "gh2", "kh2",  "oj2"},         // 会话提供接口 ★ fp_match 100% 66/66
        {"bx4", "py5", "py5",  "w16"},         // 下发数据对象 ★ fp_match 100% 27/28 方法
        {"yb5", "hs7", "rd7",  "oh7"},         // 建议 Prompt 视图 ★ 串 promptCrossfade 唯一
        {"pd5", "i93", "rb7",  "pf7"},         // 提示词文本 ★ s(Lhe7;Context;)String 逐位
        {"hp8", "dz9", "w1a",  "k5a"},         // 渲染列表 ★ fp_match 100%
        {"wr",  "ns",  "ns",   "ps"},          // 消息主存储 ★ fp_match 100% 30/39 方法
        {"sr9", "zx8", "r09",  "a79"},         // 字节 APM root 检测 ★ fp_match 86.2% + C()Z 原样
        {"lp9", "s4b", "l7b",  "qbb"},         // Kotlin Unit 单例 ★ fp_match 100% 形状全同
        {"le",  "af",  "cf",   "rf"},          // 图像包装 ★ implements Lei5 + a:Bitmap
        {"ok0", "an0", "dn0",  "bo0"},         // BitmapPainter ★ 字段 f/g/h/i/j/k 逐位同形
        {"ku6", "mz7", "l18",  "d58"},         // Painter 基类 ★ bo0.super Ld58
        {"vq",  "mr",  "lr",   "nr"},          // 消息基类 ★ fp_match 100% 46/46
        {"c76", "x97", "gc7",  "eg7"},         // Modifier 接口 ★ 三参签名逐位
        {"ey3", "yx4", "by4",  "n05"},         // Compose Composer ★ fp_match 100% 21/21
        {"sn0", "iq0", "nq0",  "nr0"},         // Brush ★ 同上第 2 参（abstract class）
        {"dd8", "im9", "cp9",  "us9"},         // ShaderBrush（抽象）★ or0.super Lus9
        {"md8", "gn9", "aq9",  "st9"},         // Shape ★ 同上第 3 参
        {"we5", "pz7", "rw8",  "f09"},         // GmReplyHook 用 ★ fp_match 100% 8/8
        {"vk0", "jn0", "on0",  "mo0"},         // GmPaintModHook 用 ★ bo0.k:Lmo0 交叉验证
        {"gz3", "bz4", "ez4",  "q15"},         // GmCallDialog 用 ★ fp_match 100% 4/4
        {"it9", "d9b", "xbb",  "zfb"},         // 账号数据类 ★ Companion:Lyfb + f:[Lnf6
        {"u19", "u19", "m49",  "x79"},         // Shape 工厂 ★ a()/b(F)/c(FFFF)/d(FFI)/e() 全同
        {"g56", "g87", "ja7",  "he7"},         // 建议/快捷项 item 类 ★ fp_match 100% 7/7
    };

    // ══════════════════════════════════════════════════════════════════
    //  方法重映射：{2.5.2键, 2.6.1键, 2.6.2键, 2.7.1类, 2.7.1方法}
    //    · 键格式 = "类.方法"
    //    · 2.7.1类 是**方法真正所在的类**（可能是拆类后的某个碎片）
    //    · 没登记 = 没改名 / 没搬类
    // ══════════════════════════════════════════════════════════════════
    private static final String[][] MTH = {
        //  2.5.2键    2.6.1键    2.6.2键        2.7.1类  2.7.1方法
        {"kf5.K",  "kh7.K",  "j77.p",  "pc7",  "v"},   // 头像 Painter ★ 全树唯一 (II,Composer)LPainter;
        {"fh6.N",  "w2b.N",  "e3c.a0", "kmc",  "e0"},  // Modifier.paint ★ 六类型逐位唯一
        {"m5.v",   "t5.v",   "t5.w",   "u5",   "w"},   // 入口行点击
        {"p5.v",   "x5.v",   "x5.w",   "x5",   "w"},   // 账号头像
        {"s5.v",   "a6.v",   "a6.w",   "z5",   "w"},   // 账号名 ★★ 类换人
        {"h91.a",  "d12.a",  "j12.a",  "j32",  "a"},   // 消息列表 ★ 11 形参逐位
        {"pn9.c",  "i93.c",  "jtb.f",  "szb",  "o"},   // 气泡单元 ★ 八参逐位
        {"ls9.f",  "ua0.f",  "xa0.g",  "za0",  "g"},   // 气泡作用域
        {"zc.s",   "pr6.s",  "qn7.p",  "dz7",  "o"},   // ★★ GotoBottomButton —— 方法跑到 dz7！
        {"tn0.b",  "jq0.b",  "oq0.b",  "or0",  "b"},   // ShaderBrush
        {"se0.c",  "eh0.c",  "ih0.g",  "fi0",  "d"},   // 背景 Element
        {"uia.u",  "qk7.C",  "us6.y",  "p68",  "B"},   // 画底原语·4 参 Brush 版
        {"uia.v",  "qk7.D",  "us6.z",  "p68",  "C"},   // 画底原语·3 参颜色版
        {"p66.h",  "m97.h",  "tb7.h",  "rf7",  "h"},   // model 域下发 ★ 方法名未变
        {"h02.u",  "yt2.u",  "bu2.v",  "iw2",  "v"},   // main 域下发
        {"ao1.I",  "gh2.I",  "kh2.k",  "oj2",  "k"},   // 会话接口
        {"ao1.J",  "gh2.J",  "kh2.l0", "oj2",  "P"},   // 会话接口
        {"ao1.M",  "gh2.M",  "kh2.W",  "oj2",  "Y"},   // 会话接口（W()Lns; → Y()Lps;）
        {"bx4.get","py5.get","py5.get","w16",  "get"}, // 下发数据对象
        {"yb5.e",  "hs7.e",  "rd7.c",  "oh7",  "d"},   // 建议列表 ★ 九参逐位
        {"yb5.f",  "hs7.f",  "rd7.d",  "oh7",  "e"},   // 建议列表 ★ 九参逐位
        {"pd5.I",  "i93.I",  "rb7.K",  "pf7",  "s"},   // 提示词文本 ★ Context 唯一
        {"pd5.H",  "i93.H",  "rb7.J",  "pf7",  "r"},   // 提示词文本
        {"wr.x",   "ns.x",   "ns.D",   "ps",   "C"},   // 渲染列表（D()Lw1a → C()Lk5a）
        {"wr.z",   "ns.z",   "ns.F",   "ps",   "E"},   // 列表更新
        {"me4.a",  "pe5.a",  "pe5.a",  "th5",  "a"},   // 图标 Hook 锚
        {"hp8.isEmpty","dz9.isEmpty","w1a.isEmpty","k5a","isEmpty"}, // 渲染列表判空
        {"sr9.w",  "zx8.w",  "r09.C",  "a79",  "C"},   // 字节 APM root 检测
    };

    /**
     * 宿主类名重映射 —— **多类版**。
     *
     * <p>拆类时返回长度 &gt; 1 的数组（例：`uia` → `{"p68","dz7","r0b"}`）。
     * <p>⚠️ `hookAllMethods` 型钩子**必须**遍历这个数组，否则拆类后只挂到 1/N 且不报错。
     */
    public static String[] clsAll(String old) {
        if (old == null) return new String[] { GONE + "null" };
        for (String[] p : CLS4) {
            if (eq(p[0], old) || eq(p[1], old) || eq(p[2], old)) {
                if (p[3] == null) return new String[] { GONE + p[0] };   // 未定位 ⇒ 安全失败
                return p[3].split(",");
            }
        }
        return new String[] { old };   // 不是宿主锚点 —— 原样放行
    }

    /**
     * 宿主类名重映射 —— **兼容版**（取第一个）。
     *
     * <p>⚠️ 拆类后这个方法可能返回「不含目标方法」的那个类！
     * <br>凡是要 hook 具体方法的场景，一律改用 {@link #clsFor(String, String)}。
     */
    public static String cls(String old) {
        return clsAll(old)[0];
    }

    /**
     * 按「类 + 方法」查方法真正所在的类 —— **拆类安全版**。
     *
     * <p>2.7.1 实测：`qn7` 的 48 个方法里 47 个在 `jr7`，只有 `s` 在 `dz7`。
     * 若按 `cls("qn7")` = `jr7` 去 hook `s`，会**静默找不到**（hookM 吞异常）。
     *
     * @param oldCls 旧类名（2.5.2 / 2.6.1 / 2.6.2 任一代均可）
     * @param oldMth 旧方法名
     */
    public static String clsFor(String oldCls, String oldMth) {
        String owner = methodOwner(oldCls, oldMth);
        return owner != null ? owner : clsAll(oldCls)[0];
    }

    /** 方法名重映射；没登记 = 没改名，原样返回 */
    public static String method(String oldCls, String oldMth) {
        if (oldCls == null || oldMth == null) return oldMth;
        String k = oldCls + "." + oldMth;
        for (String[] p : MTH) {
            if (eq(p[0], k) || eq(p[1], k) || eq(p[2], k)) return p[4];
        }
        return oldMth;
    }

    /**
     * 方法真正所在的 2.7.1 类名；未登记 ⇒ null（调用方回退到 {@link #clsAll}）。
     */
    public static String methodOwner(String oldCls, String oldMth) {
        if (oldCls == null || oldMth == null) return null;
        String k = oldCls + "." + oldMth;
        for (String[] p : MTH) {
            if (eq(p[0], k) || eq(p[1], k) || eq(p[2], k)) return p[3];
        }
        return null;
    }

    /** 当前表里登记了多少条（自检用） */
    public static String stats() {
        return "CLS4=" + CLS4.length + " MTH=" + MTH.length;
    }

    private static boolean eq(String a, String b) {
        return a != null && a.equals(b);
    }
}
