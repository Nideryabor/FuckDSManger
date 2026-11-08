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
 *   2026-11-06 升级为「**六代键**」，值 = **2.7.5**（CLS5 → CLS6；clsAll 改成遍历前 N-1 列）
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
    //  宿主类名：{2.5.2, 2.6.1, 2.6.2, 2.7.1, 2.7.2, 2.7.5}
    //  · 值允许逗号分隔（R8 拆类）
    //  · null = 未定位 ⇒ 安全跳过
    //  · ⚠️ 前 N-1 列都是「键」，**最后一列才是目标值**；clsAll 自动遍历前 N-1 列
    // ══════════════════════════════════════════════════════════════════
    private static final String[][] CLS6 = {
        //  2.5.2   2.6.1   2.6.2              2.7.1          2.7.2
        {"kf5", "kh7", "j77", "pc7", "k27", "s27"},         // 杂物间（painterResource）★ 串 PainterResources.android.kt
        {"fh6", "w2b", "e3c", "kmc", "qx6", "wx6"},         // Modifier.paint ★ a0(6类型逐位)→e0；★合并了 pic
        {"me4", "pe5", "pe5", "th5", "lj5", "qj5"},         // 图标 Hook 锚 ★ 签名逐位
        {"m5", "t5", "t5", "u5", "y5", "z5"},          // 入口：设置行→路由桶 ★ 串 batch_management_click
        {"h91", "d12", "j12", "j32", "c42", "h42"},         // 消息列表 Composable ★ 串 messageListWidth
        {"p5", "x5", "x5", "x5", "a6", "b6"},          // 账号头像桶 ★ 2.7.5 = b6（见 MTH 注释）
        {"pn9", "i93", "jtb", "szb,x4c,fxb", "cfb,mdb,j37,v5a,vcc", "y2c"}, // 气泡单元 Composable ★★ 拆 3（八参逐位→szb.o）
        {"ls9", "ua0", "xa0", "za0", "wb0", "yb0"},         // 气泡作用域 ★ 8 串中 7 条逐字相同
        {"uia", "qk7", "us6", "p68,dz7,r0b", "x98,qu7,z2c,g83,j37,zi9", "da8,yu7"}, // Modifier 扩展桶 ★★ 拆 3
        {"tn0", "jq0", "oq0", "or0", "ks0", "ls0"},         // ShaderBrush 实现 ★ 字段 c:I/d:Object 同形
        {"jd8", "dn9", "xp9", "pt9", "py9", "vy9"},         // 气泡阴影 ★ fp_match 100% 5/5
        {"se0", "eh0", "ih0", "fi0", "yi0", "zi0"},         // 背景 Element ★ 4 字段 + ctor 逐位
        {"zc", "pr6", "qn7", "jr7", "px6", "vx6"},         // ChatPage 作用域 ★ 串 STRIKETHROUGH/INLINE_MATH
                                               //   ⚠️ 但方法 s 在 dz7！见 MTH + clsFor()
        {"s5", "a6", "a6", "z5", "c6", "d6"},          // 账号名桶 ★★ 2.7.1 的 a6 已换主人（r(Object,Object)Object）
        {"p66", "m97", "tb7", "rf7", "mj7", "tj7"},         // 配置源头 model 域 ★ fp_match 100% + h() 未变
        {"h02", "yt2", "bu2", "iw2", "cx2", "hx2"},         // 配置源头 main 域 ★ fp_match 97.2%
        {"ao1", "gh2", "kh2", "oj2", "ik2", "nk2"},         // 会话提供接口 ★ fp_match 100% 66/66
        {"bx4", "py5", "py5", "w16", "a46", "f46"},         // 下发数据对象 ★ fp_match 100% 27/28 方法
        {"yb5", "hs7", "rd7", "oh7", "h67", "p67"},         // 建议 Prompt 视图 ★ 串 promptCrossfade 唯一
        {"pd5", "i93", "rb7", "pf7", "y27", "g37"},         // 提示词文本 ★ s(Lhe7;Context;)String 逐位
        {"hp8", "dz9", "w1a", "k5a", "qaa", "zaa"},         // 渲染列表 ★ fp_match 100%
        {"wr", "ns", "ns", "ps", "ys", "zs"},          // 消息主存储 ★ fp_match 100% 30/39 方法
        {"sr9", "zx8", "r09", "a79", "ng9", "ug9"},         // 字节 APM root 检测 ★ fp_match 86.2% + C()Z 原样
        {"lp9", "s4b", "l7b", "qbb", "ahb", "ghb"},         // Kotlin Unit 单例 ★ fp_match 100% 形状全同
        {"le", "af", "cf", "rf", "qf", "rf"},          // 图像包装 ★ implements Lei5 + a:Bitmap
        {"ok0", "an0", "dn0", "bo0", "uo0", "vo0"},         // BitmapPainter ★ 字段 f/g/h/i/j/k 逐位同形
        {"ku6", "mz7", "l18", "d58", "k88", "q88"},         // Painter 基类 ★ bo0.super Ld58
        {"vq", "mr", "lr", "nr", "xr", "yr"},          // 消息基类 ★ fp_match 100% 46/46
        {"c76", "x97", "gc7", "eg7", "yj7", "fk7"},         // Modifier 接口 ★ 三参签名逐位
        {"ey3", "yx4", "by4", "n05", "r15", "v15"},         // Compose Composer ★ fp_match 100% 21/21
        {"sn0", "iq0", "nq0", "nr0", "js0", "ks0"},         // Brush ★ 同上第 2 参（abstract class）
        {"dd8", "im9", "cp9", "us9", "tx9", "ay9"},         // ShaderBrush（抽象）★ or0.super Lus9
        {"md8", "gn9", "aq9", "st9", "sy9", "yy9"},         // Shape ★ 同上第 3 参
        {"we5", "pz7", "rw8", "f09", "p39", null},         // GmReplyHook 用 ★ fp_match 100% 8/8
        {"vk0", "jn0", "on0", "mo0", "fp0", "gp0"},         // GmPaintModHook 用 ★ bo0.k:Lmo0 交叉验证
        {"gz3", "bz4", "ez4", "q15", "v25", "a35"},         // GmCallDialog 用 ★ fp_match 100% 4/4
        {"it9", "d9b", "xbb", "zfb", "olb", null},         // 账号数据类 ★ Companion:Lyfb + f:[Lnf6
        {"u19", "u19", "m49", "x79", "jb9", "qb9"},         // Shape 工厂 ★ a()/b(F)/c(FFFF)/d(FFI)/e() 全同
        // ★ 2026-10-31（3.73.19）：宿主「通用表面容器」AppSurface(Modifier, Shape, color, contentColor, …)
        //   它是**气泡**的载体（每个消息气泡都套一层它）。气泡背景只能在这一层改。
        //   真机实证：caller=l23.a:167 → 用户气泡(色=-9223372036854775808) / 透明外壳(色=0)
        //   注意：同一方法也被大量按钮/卡片用 ⇒ 调用方**必须再加颜色与计数器过滤**。
        // ═══ 2026-11-06（3.75.18）· 气泡背景专用锚点（GmBubbleBg）═══
        //   为什么要「语义键」而不是用 2.7.2 的原名当键：
        //   2.7.5 里 `zi0`/`vcc`/`t82` 这几个短名**全部被复用**（同名诈尸），
        //   直接 cls("zi0") 会返回 2.7.5 的背景 Element（不是绘制节点！）；
        //   cls("vcc") 会返回气泡单元碎片 y2c（不是 clip 所在类！）
        //   ⇒ 用我们自己的语义键，一个锚点一条，永不歧义。
        //
        //   判据（2.7.2 → 2.7.5，逐条实测）：
        {"nod", "nod", "nod", "nod", "zi0", "aj0"},      // 绘制节点：字段 o:J/p:Brush/q:F/r:Shape 全同形，super xj7→ek7
        {"nodbase", "nodbase", "nodbase", "nodbase", "xj7", "ek7"}, // 节点基类：14 字段 abstract
        {"shapeholder", "shapeholder", "shapeholder", "shapeholder", "t82", "y82"}, // 气泡 Shape 容器：35 字段全同（t:Lib9;→Lpb9;、n:Lk78;→Lq78;）
        {"clipmod", "clipmod", "clipmod", "clipmod", "vcc", "dec"}, // clip(Modifier,Shape)：`w(Lfk7;Lyy9;)Lfk7;` 全树唯一
        // RoundedCornerShape 实现（`new oc5(2)`）—— cls 和 mth 都要有，别只加一边
        {"clipmod.round", "clipmod.round", "clipmod.round", "clipmod.round", "kc5", "oc5"},
        // 助手气泡注入的两个候选容器（GmBubbleBg 用）—— 用 SourceInfo 定位：
        //   e40.a  ↔  h40.a   （AssistantChatMessageCell.kt:130，13 形参逐位同形）
        //   ru7.c  ↔  yu7.?   （AssistantChatMessageContent.kt:100；yu7 现在是大杂烩，
        //                       还含 GotoBottomButton，所以只当兜底）
        {"assistcell", "assistcell", "assistcell", "assistcell", "e40", "h40"},
        {"assistbody", "assistbody", "assistbody", "assistbody", "ru7", "yu7"},
        {"l23", "l23", "l23", "appsurface", "l23", "q23"},   // AppSurface ★ 2.7.2 = l23.a(Lyj7;Lsy9;JJLr33;Lr15;I)V
        {"g56", "g87", "ja7", "he7", "gi7", "ni7"},         // 建议/快捷项 item 类 ★ fp_match 100% 7/7
        // ═══ 2026-11-07（2.7.5 从零静态定位）· 更新弹窗「立即更新」的落点 ═══
        //   宿主那一整条「打开更新链接」的类：**只有一个 Context 字段 + 一个 (String)V 方法**，
        //   方法体 = Uri.parse → Intent(ACTION_VIEW) → Context.startActivity（无 setPackage / 无 chooser）。
        //   全 dex 该方法的 xref **只有 1 处** ⇒ 这就是弹窗里「立即更新」按钮的唯一落点，
        //   天然无歧义（对比设置行那条 `pg7.z` 被复制/删除/重生成四家共用，判据不可能可靠）。
        //   判据：类里同时含 "android.intent.action.VIEW" + "Can't open " 两个串、单 Context 字段。
        //   2.7.5 = `zi`（见 专题/宿主更新按钮-静态链路-2.7.5.md）
        {"openlink", "openlink", "openlink", "openlink", "openlink", "zi"},
        // ═══ 2026-11-07 · 设置页「检查更新」那一行的**唯一语义落点** ═══
        //   2.7.5 的 `fy2` = UpdateViewModel；它有两个入口：
        //     · `a(Lec3)`                 ← 方法体里**写死** "check_update" ⇒ 手动检查（就它）
        //     · `b(String,J,Lec3)`        ← scenario 由参数传入（"conversation" 等）自动检查
        //   ⇒ `a()` 是"手动检查更新"唯一入口，且它的 xref 只有 2 处
        //     （都是它自己的协程状态机：`cy2.z` 是 lambda invokeSuspend、`dx9.z` 是调用点）。
        //   ★ 为什么不用旧的 `pg7.z`/`sj0.h`：那是 R8 合并出来的**路由桶下标**
        //     （复制/删除对话/重新生成 四家共用 e=22/23）⇒ 必然误伤，已四次血证。
        {"updatevm", "updatevm", "updatevm", "updatevm", "updatevm", "fy2"},

        {"yp1", "yp1", "yp1", null, null, null},          // 语音门控（GmAsrHook / GmSeeHook）
                                               //   ⚠️ 2.7.1 **同名已换主人**：变成 implements Ld15 的
                                               //   合成 lambda（a()Ltm9; / c()[Lt86; / d(Lbn3;)Object）
                                               //   ⇒ 同名的 a/c 方法存在且能被 hook，但**钩的是错误的东西**
                                               //   ⇒ 显式置 null 让它安全失败（宁可不干活，不要乱咬宿主）
                                               //   历史：2.6.1 起就标「待定」，一直没真正定位过
    };

    // ══════════════════════════════════════════════════════════════════
    //  方法重映射：{2.5.2键, 2.6.1键, 2.6.2键, 2.7.2类, 2.7.2方法, 2.7.5类, 2.7.5方法}
    //    · 键格式 = "类.方法"；**前 N-2 列都是键**，倒数第 2 列 = 类，最后 1 列 = 方法
    //    · 没登记 = 没改名 / 没搬类
    //    · 最后一列写 null = 该锚点在最新版已消失 ⇒ method() 返回 GONE 名，安全失败
    // ══════════════════════════════════════════════════════════════════
    private static final String[][] MTH = {
        //  2.5.2键    2.6.1键    2.6.2键        2.7.2类  2.7.2方法
        {"kf5.K", "kh7.K", "j77.p", "k27", "D", "s27", "E"},   // 头像 Painter ★ 全树唯一 (II,Composer)LPainter;
        {"fh6.N", "w2b.N", "e3c.a0", "qx6", "l0", "wx6", "P"},  // Modifier.paint ★ 六类型逐位唯一
        {"m5.v", "t5.v", "t5.w", "y5", "v", "z5", "w"},   // 入口行点击
        //  ★ 2026-11-06 修正（3.75.0）：方法名 **v → w**。
        //    真机实测：2.7.5 的 `z5` 只有 **`w()Ljava/lang/Object;`** 一个方法（没有 v）。
        //    这就是「设置页里点我们那一行没反应」的直接原因（findAndHookMethod 抛 NoSuchMethod 被吞）。
        {"p5.v", "x5.v", "x5.w", "a6", "v", "b6", "w"},   // 账号头像 ★★ 2.7.5 = b6.w
        //  ★ 2026-11-06 定位过程（3.75.17）—— 之前的「安全失败」现在补上了：
        //    ① 2.7.5 里 `a6` 这个短名**还在**，但已被复用成
        //       `a:I + b:String + q(Object,Object)Object`（同名诈尸，绝对不是头像桶）
        //    ② 用 2.7.2 `a6` 的**方法体形状**全树找 2 字段 + `<init>(Liea;I)V` 的类：
        //         b6 / d54 / bs / g6
        //    ③ 判据一：**行数** —— 2.7.2 a6 = 1045 行，2.7.5 **b6 = 1045 行**（其余 793/348/4882）
        //    ④ 判据二：**方法体逐行同形**（这是铁证）：
        //         a6.v                              b6.w
        //         .registers 6                      .registers 6
        //         iget v0, p0, La6;->a:I            iget v0, p0, Lb6;->a:I
        //         const/4 v1..v4 = 0,0,0,1          完全相同
        //         iget-object p0, La6;->b:Lzda;     iget-object p0, Lb6;->b:Liea;
        //         packed-switch v0, :pswitch_data_186   **连标签名都一样**
        //         invoke-interface Lzda;->getValue()   Liea;->getValue()
        //       ⇒ 唯一差别就是 `Lzda; → Liea;`（Compose MutableState 改名）
        //    ⑤ 方法名 `v → w`：和 z5（0x1d→w）、d6（v→w）同一批重命名规律
        {"s5.v", "a6.v", "a6.w", "c6", "v", "d6", "w"},   // 账号名 ★★ 类换人 + **方法 v→w**
        //  ★ 2026-11-06 修（3.75.17）：方法名 `v → w`
        //    真机铁证：日志 `hookM d6.v count=0`（挂不上，昵称一直是坏的）
        //    形状对照（2.7.2 c6 → 2.7.5 d6）：
        //      c6: `.field a:I / b:Object / c:Object / d:Object`
        //          `.method private final a()Object` + `.method public final v()Object`
        //      d6: 同样 `a:int / b:Object / c:Object / d:Object`
        //          同样 `a()Object` + **`w()Object`**
        //    ⇒ c6 的 public v() 对应 d6 的 public w()（a() 是 private 的同名辅助，别挂错）
        {"h91.a", "d12.a", "j12.a", "c42", "a", "h42", "a"},   // 消息列表 ★ 11 形参逐位
        {"pn9.c", "i93.c", "jtb.f", "cfb", "g", "y2c", "k"},   // 气泡单元 ★ 八参逐位
        {"ls9.f", "ua0.f", "xa0.g", "wb0", "e", "yb0", "e"},   // 气泡作用域
        {"zc.s", "pr6.s", "qn7.p", "qu7", "r", "yu7", "n"},   // ★★ GotoBottomButton —— 方法跑到 dz7！
        {"tn0.b", "jq0.b", "oq0.b", "ks0", "b", "ls0", "b"},   // ShaderBrush
        {"se0.c", "eh0.c", "ih0.g", "yi0", "d", "zi0", "d"},   // 背景 Element
        {"uia.u", "qk7.C", "us6.y", "x98", "s", "da8", "p"},   // 画底原语·4 参 Brush 版
        {"uia.v", "qk7.D", "us6.z", "x98", "t", "da8", "q"},   // 画底原语·3 参颜色版
        // ★ 2026-11-06：给「气泡背景」用的语义键。
        //   血证（3.75.18）：GmBubbleBg 里写 `clsFor("x98","t")` / `method("x98","t")`，
        //   但 MTH 的**键只认前三代**（uia.v / qk7.D / us6.z），"x98" 是 2.7.2 的**值列**
        //   ⇒ method("x98","t") 原样返回 "t" ⇒ 在 da8 里找不到 t 方法
        //   ⇒ 日志 `⑥ x98.t(Modifier,long,Shape) 没找到 ⇒ 不注入助手背景`。
        //   现在用语义键 "clipmod.bg"，一个入口两条路都通。
        {"clipmod.bg", "clipmod.bg", "clipmod.bg", "x98", "t", "da8", "q"},
        // ★ 2026-11-06：clip(Modifier, Shape) 的**方法名**也要走表。
        //   血证（3.75.19 日志）：`② 挂上 clip: B(yq8,zo)` —— 方法名还是 "B"（2.7.2 的值），
        //   而 2.7.5 的 `dec` 里是 **`w(Lfk7;Lyy9;)Lfk7;`** ⇒ 挂到的是别的方法，
        //   用户气泡的 clip 根本没被拦下来。
        //   （同一个坑第三次：`x98.t` / `MTH_CLIP` / `GmEntryHook` 的 case 号，
        //     都是「把上一版的字面量写死在代码里」）
        {"clipmod.clip", "clipmod.clip", "clipmod.clip", "vcc", "B", "dec", "w"},
        // ★ 2026-11-06：RoundedCornerShape（`new RoundedCornerShape(2)`）
        //   血证（3.75.20 日志）：`✗ 助手注入异常: method da8.q argument 3 has type yy9, got java.lang.Object`
        //   ⇒ 我们拿的 `dec.n` 在 2.7.5 里是 **`new Object()` 空壳**（R8 把真实形状内联掉了），
        //     不是 Shape ⇒ 传给 `da8.q(Modifier, long, Shape)` 直接被类型检查拒绝。
        //   2.7.2 的 `vcc.n` 是 `new kc5(2)`；2.7.5 对应 **`oc5`**：
        //     行号 10/12/16/20/63/104/695 全同、都是 `<init>(I)V` synthetic、
        //     `toString()` 都返回 "RectangleShape"。
        {"clipmod.round", "clipmod.round", "clipmod.round", "vcc", "n", "oc5", "<init>"},
        {"p66.h", "m97.h", "tb7.h", "mj7", "h", "tj7", "h"},   // model 域下发 ★ 方法名未变
        {"h02.u", "yt2.u", "bu2.v", "cx2", "y", "hx2", "y"},   // main 域下发
        //  ★ 2026-11-06 修正（3.75.0）：上一轮写的是 `cx2 -> v`，那是**错的**。
        //    铁证：2.7.2 树里 `s4.smali:4171` → `invoke-virtual {v0,...}, Lcx2;->y(La46;ILjava/lang/String;Ljava/lang/String;)V`
        //    而 `cx2.v()` 是 `()Ljava/lang/String;`（无参 getter）。
        //    ⇒ main 域下发从 2.7.2 起就挂在错方法上（静默失效），本轮一并纠正。
        //    真机复核（2.7.5）：`hx2.y(f46, int, String, String)` ✓，与 `tj7.h` 是同签名对。
        {"ao1.I", "gh2.I", "kh2.k", "ik2", "k", "nk2", "k"},   // 会话接口
        {"ao1.J", "gh2.J", "kh2.l0", "ik2", "P", "nk2", "P"},   // 会话接口
        {"ao1.M", "gh2.M", "kh2.W", "ik2", "Y", "nk2", "Y"},   // 会话接口（W()Lns; → Y()Lps;）
        {"bx4.get", "py5.get", "py5.get", "a46", "get", "f46", "get"}, // 下发数据对象
        {"yb5.e", "hs7.e", "rd7.c", "h67", "e", "p67", "f"},   // 建议列表 ★ 九参逐位
        {"yb5.f", "hs7.f", "rd7.d", "h67", "f", "p67", "g"},   // 建议列表 ★ 九参逐位
        {"pd5.I", "i93.I", "rb7.K", "y27", "z", null, null},   // 提示词文本 ★ Context 唯一
        {"pd5.H", "i93.H", "rb7.J", "y27", "y", "g37", "A"},   // 提示词文本
        {"wr.x", "ns.x", "ns.D", "ys", "C", "zs", "C"},   // 渲染列表（D()Lw1a → C()Lk5a）
        {"wr.z", "ns.z", "ns.F", "ys", "E", "zs", "E"},   // 列表更新
        {"me4.a", "pe5.a", "pe5.a", "lj5", "a", "qj5", "a"},   // 图标 Hook 锚
        {"hp8.isEmpty", "dz9.isEmpty", "w1a.isEmpty", "qaa", "isEmpty", "zaa", "isEmpty"}, // 渲染列表判空
        {"sr9.w", "zx8.w", "r09.C", "ng9", "C", "ug9", "C"},   // 字节 APM root 检测
        // ★★ 2026-11-07：设置页「检查更新」那一行的**点击逻辑**（≠ 改文案！）
        //
        //   来由 —— 主人一句戳中：
        //     「如果你挂了修改文字的 hook 但没挂/挂错这个按钮点击逻辑的 hook，
        //       你怎么改模块 UI 都起不来」
        //   之前 `m5/t5/z5` 挂的是**设置行路由桶**（29 个 case 全是「批量管理、
        //   语言、外观」这类**有路由键**的行）——「检查更新」根本不走它。
        //   而 `GmResTextHook` 只改 `profile_check_for_updates` 的**字**，
        //   点击还是宿主原逻辑 ⇒ 必然"还是检查新版本"。文案与点击是两条路。
        //
        //   真凶（frida 实测栈，2026-11-07 00:07，两次点击都可复现）：
        //     Context.getString(0x7f0f0267 「当前已是最新版本」)
        //       ← ol2.j(:121)                通用 lambda 分发
        //       ← pg7.z(:428)  ★★★★★        点击逻辑本体
        //       ← sj0.h(:5)                  协程 ContinuationImpl.resumeWith
        //       ← wy3.run ← Handler.post
        //   且 `pg7.z` 的 `this.e`（R8 合并 lambda 的 switch 索引）= **22 / 23**
        //   （两次点击分别落 23 / 22，都直通同一句"当前已是最新版本"⇒ 同一功能）。
        //
        //   ⚠️ 为什么必须写当前宿主名而不能写 null：
        //      null ⇒ `cls()` 返回必然不存在的类 ⇒ 钩子静默不挂 ⇒ 又回到"点了没反应"。
        //      代价是宿主升级要重新定位，手段就是上面这条 frida 栈
        //      （记在 `专题/写死字面量坑` 的账上）。
        {"settings.row.update.z", "settings.row.update.z", "settings.row.update.z", null, null, "pg7", "z"},   // 设置「检查更新」点击 ★ e=22/23
        {"cont.impl.h.h", "cont.impl.h.h", "cont.impl.h.h", null, null, "sj0", "h"},   // 协程 resumeWith ★ 吞掉它=宿主逻辑一行不跑
        // ═══ 2026-11-07 · 「手动检查更新」的**唯一语义入口** ═══
        //   `fy2.a(Lec3)Object` = UpdateViewModel 里写死 scenario="check_update" 的那个 suspend 函数。
        //   xref 只有 2 处：`cy2.z`（它自己的协程 invokeSuspend）+ `dx9.z`（设置页那一行的调用点）。
        //   ⇒ 语义唯一，可安全旁路（**不 setResult**，只顺手把我们的 UI 拉起来，
        //     宿主那次检查更新照跑，但它的 Toast/Dialog 已被 FdmUpdatePopupHook 拦掉）。
        {"updatevm.check", "updatevm.check", "updatevm.check", "updatevm.check",
                "updatevm.check", "fy2", "a"},
    };

    /**
     * 宿主类名重映射 —— **多类版**。
     *
     * <p>拆类时返回长度 &gt; 1 的数组（例：`uia` → `{"p68","dz7","r0b"}`）。
     * <p>⚠️ `hookAllMethods` 型钩子**必须**遍历这个数组，否则拆类后只挂到 1/N 且不报错。
     */
    public static String[] clsAll(String old) {
        if (old == null) return new String[] { GONE + "null" };
        for (String[] p : CLS6) {
            // ★ 2026-11-06（3.75.18）：改成「遍历前 N-1 列」而不是写死 p[0]..p[3]。
            //   历史教训（指南 U 条）：2.7.2 那轮加列后漏了 clsAll 里的 p[3]→p[4]，
            //   结果所有 cls() 都返回旧类名，玻璃/头像/富文本/提示词全挂，卡了半宿。
            //   现在再加一代只要往每行末尾追加一列，**这里永远不用动**。
            for (int i = 0; i < p.length - 1; i++) {
                if (hitKey(p[i], old)) {
                    String v = p[p.length - 1];
                    if (v == null) return new String[] { GONE + p[0] };   // 未定位 ⇒ 安全失败
                    return v.split(",");
                }
            }
        }
        return new String[] { old };   // 不是宿主锚点 —— 原样放行
    }

    /**
     * 【自检】这组 (类, 方法) 到底有没有**命中** MTH 表？
     *
     * <p>★ 2026-11-07 —— 因为这个坑犯过两次，实在受不了了：
     * <ul>
     *   <li>3.75.28：表里写 {@code settings.row.update}（少了 {@code .z}）</li>
     *   <li>3.75.38：表里写 {@code cont.impl.h}（少了 {@code .h}）</li>
     * </ul>
     * 症状一模一样：{@code ClassNotFoundException: xxx$yyy}，
     * 而且**看起来像类名写错**，特别费时间。
     *
     * <p>根因是表里的键必须是 {@code 旧类名 + "." + 旧方法名} **拼出来的完整串**，
     * 而 {@code clsAll()} 在没命中时会**原样返回旧的类名**。
     * ⇒ 调用方光看返回值分不清"命中了"还是"没命中"，于是就拿着
     *   一个不存在的类名去 findClass。
     *
     * <p>用法：所有 {@link #clsFor}/{@link #method} 的调用点都应先问一句
     * <pre>
     *   if (!GmRemap.hit(KEY, MTH)) { log("键写错了：应为 " + KEY + "." + MTH); return; }
     * </pre>
     */
    public static boolean hit(String oldCls, String oldMth) {
        if (oldCls == null || oldMth == null) return false;
        String k = oldCls + "." + oldMth;
        for (String[] p : MTH) {
            if (isKey(p, k)) return true;
        }
        return false;
    }

    /**
     * 单列是否命中 {@code old}。
     *
     * <p>★ 2026-11-06 修的一个**真 bug**：拆类后某些键列的值是**逗号串**
     * （例：`"x98,qu7,z2c,g83,j37,zi9"` 表示「2.7.2 里这一族被切成 6 个碎片」）。
     * 原来的 `eq(p[i], old)` 是整串比较 ⇒ {@code clsAll("x98")} **永远匹配不到**
     * ⇒ {@code cls("x98")} 原样返回 `"x98"`，而那在 2.7.5 已经是个只剩 1 个方法的
     * 诈尸接口 ⇒ 画底原语/气泡背景**整族静默失效**（日志：`Modifier 不是接口`）。
     *
     * <p>现在：含逗号就逐段比。这样 `cls("x98")` → `da8`、`cls("qu7")` → `yu7` 都对。
     */
    private static boolean hitKey(String col, String old) {
        if (col == null) return false;
        if (col.equals(old)) return true;
        if (col.indexOf(',') < 0) return false;
        for (String seg : col.split(",")) {
            if (seg.equals(old)) return true;
        }
        return false;
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
            if (isKey(p, k)) {
                String v = p[p.length - 1];
                // 该锚点在新版已消失 ⇒ 还一个必然找不到的方法名，让调用方干净地失败
                return v != null ? v : (GONE + "gone");
            }
        }
        return oldMth;
    }

    /**
     * 方法真正所在的**最新版**类名；未登记或新版未定位 ⇒ GONE（让 findClass 干净失败）。
     */
    public static String methodOwner(String oldCls, String oldMth) {
        if (oldCls == null || oldMth == null) return null;
        String k = oldCls + "." + oldMth;
        for (String[] p : MTH) {
            if (isKey(p, k)) {
                String owner = p[p.length - 2];
                // ★ owner 为 null 表示「这版没这个方法了」。
                //   不能返回 null —— 那会让 clsFor 回退 clsAll()[0]（很可能是个错类），
                //   于是「方法名对不上」会变成「钩到别的类」，比不干活更糟。
                return owner != null ? owner : (GONE + "none");
            }
        }
        return null;
    }

    /**
     * 判断某一行是否命中了键 {@code k}。
     *
     * <p>★ 2026-11-06（3.75.0 第一版的血）：MTH 行是
     * <b>「3 个键列 + 每代一对(类,方法)」</b>，**不是**「键 + 单个值」。
     * 我一开始按 clsAll 的「前 N-1 列都是键」去写，`k = "y5.v"` 永远匹配不到
     * （因为 p[3]="y5"、p[4]="v" 都不是 "y5.v"）⇒ {@code method()} 恒返回旧名、
     * {@code methodOwner()} 恒 null ⇒ **整张方法表等于没生效**，
     * 表现就是「入口点了没反应」（`findAndHookMethod(z5, "v")` 抛 NoSuchMethod 被吞）。
     *
     * <p>所以改成按<b>形状</b>认键：键列的格式是 {@code "类.方法"}（<b>含点</b>），
     * 而类名/方法名列都是 R8 的裸短名（<b>不含点</b>）。这样以后再加代也永远不用改这里。
     */
    private static boolean isKey(String[] p, String k) {
        for (int i = 0; i < p.length - 2; i++) {
            String v = p[i];
            if (v != null && v.indexOf('.') >= 0 && v.equals(k)) return true;
        }
        return false;
    }

    /** 当前表里登记了多少条（自检用） */
    public static String stats() {
        return "CLS6=" + CLS6.length + " MTH=" + MTH.length + " gen=2.7.5";
    }

    private static boolean eq(String a, String b) {
        return a != null && a.equals(b);
    }
}
