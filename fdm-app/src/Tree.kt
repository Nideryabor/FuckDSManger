// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger
import android.content.Context
import androidx.compose.ui.res.stringResource

/**
 * 界面树 —— **照原模块 smali UI 抄的**（规格见 `专题/原UI结构.md`）🐲
 *
 * 标签、说明、顺序、层级都照抄；不要自己编、不要"精简"。
 * 原 UI 出处：`GmHomeUi` / `GmMenuDialog` / `GmChatDialog` / `GmBeautyDialog` /
 *           `GmBubbleDialog` / `GmBgDialog` / `GmEnvDialog` / `GmDsDialog` /
 *           `GmDumpDialog` / `GmSuggestDialog` / `GmHelloDialog` /
 *           `GmPromptDialog` / `GmDbDialog`
 */

/** 条目形态 */
enum class K {
    SW,     // 开关
    SL,     // 滑块（原 UI 多是 ± 按钮，这里等价）
    CH,     // 枚举（一排 chip）
    CO,     // 颜色
    TX,     // 文本
    SUB,    // 子页
    ACT,    // 动作（走宿主的专用入口）
    PICK,   // 选图片（UI 侧 SAF）
    COPY,   // 复制（UI 侧剪贴板）
    INFO,   // 只读信息
}

data class It(
    val label: String,
    val hint: String? = null,
    val k: K,
    val key: String? = null,
    val def: Any? = null,
    val min: Int = 0,
    val max: Int = 0,
    val choices: List<String> = emptyList(),
    val sub: String? = null,      // 子页 id
    val cmd: String? = null,      // 宿主侧动作 id
    val sk: String? = null,       // 状态键（宿主 cfg_state 回传的键，用它显示真值）
)

data class Pg(val id: String, val title: String, val items: List<It>)

object Tree {

    /** 首页（照 `GmHomeUi`） */
    fun home(ctx: Context) = listOf(
        // ★ 首页这一项在原版里就是"宿主隐藏设置的编辑器"（= GmDialog 那张灰度开关表），不是模块菜单
        It(ctx.getString(R.string.scr_002), ctx.getString(R.string.scr_003), K.SUB, sub = "gray"),
        It(ctx.getString(R.string.scr_007), ctx.getString(R.string.scr_008), K.SUB, sub = "env"),
        It(ctx.getString(R.string.scr_009), ctx.getString(R.string.scr_010), K.SUB, sub = "debug"),
        It(ctx.getString(R.string.scr_005), null, K.SUB, sub = "chat"),
        It(ctx.getString(R.string.scr_006), null, K.SUB, sub = "beauty"),
    )

    fun pages(ctx: Context): List<Pg> = listOf(

        /* ───────── 菜单（GmMenuDialog）───────── */
        Pg("menu", ctx.getString(R.string.tree_001), listOf(
            It(ctx.getString(R.string.scr_002), ctx.getString(R.string.tree_002),
                K.SUB, sub = "gray"),
            It(ctx.getString(R.string.scr_005), null, K.SUB, sub = "chat"),
            It(ctx.getString(R.string.scr_006), null, K.SUB, sub = "beauty"),
            It(ctx.getString(R.string.spv_003), ctx.getString(R.string.tree_003), K.SUB, sub = "suggest"),
            It(ctx.getString(R.string.tree_004), ctx.getString(R.string.tree_005), K.SUB, sub = "env"),
            It(ctx.getString(R.string.tree_006), null, K.SUB, sub = "debug"),
        )),

        /* ───────── 聊天（GmChatDialog）───────── */
        Pg("chat", ctx.getString(R.string.scr_005), listOf(
            It(ctx.getString(R.string.tree_007), ctx.getString(R.string.tree_008),
                K.SW, key = "ui_db_on", def = true, cmd = "db_on", sk = "db_on"),
            It(ctx.getString(R.string.tree_009), ctx.getString(R.string.tree_010),
                K.SW, key = "fuckds_model_switch", def = false),
            It(ctx.getString(R.string.tree_011), null, K.SUB, sub = "db"),
            It(ctx.getString(R.string.tree_012), ctx.getString(R.string.tree_013),
                K.SUB, sub = "suggest"),
            // ★ 2026-10-10（3.65.0）主人：「把 v2 迁移到聊天页面，把原来的系统提示词那个页面删掉」
            //   ⇒ 这一项现在指向**卡片式新版**（容器里的卡片按顺序拼成提示词）
            It(ctx.getString(R.string.tree_014), ctx.getString(R.string.tree_015),
                K.SUB, sub = "sysprompt_v2"),
            It(ctx.getString(R.string.tree_016), ctx.getString(R.string.tree_017), K.SUB, sub = "richtext"),
        )),

        /* ───────── 美化（GmBeautyDialog）───────── */
        Pg("beauty", ctx.getString(R.string.scr_006), listOf(
            It(ctx.getString(R.string.tree_018), ctx.getString(R.string.tree_019), K.SUB, sub = "avatar_img"),
            It(ctx.getString(R.string.tree_020), ctx.getString(R.string.tree_021),
                K.SUB, sub = "bubble_conv"),
            It(ctx.getString(R.string.tree_022), ctx.getString(R.string.tree_023),
                K.TX, key = "ui_nick", def = "", cmd = "name_put", sk = "name"),
            It(ctx.getString(R.string.tree_024), ctx.getString(R.string.tree_025),
                K.SW, key = "ui_uavatar_on", def = false, cmd = "uavatar_on", sk = "uavatar_on"),
            It(ctx.getString(R.string.tree_026), null, K.PICK, cmd = "uavatar"),
            It(ctx.getString(R.string.tree_027), ctx.getString(R.string.tree_028), K.SUB, sub = "prompt"),
            It(ctx.getString(R.string.tree_029), ctx.getString(R.string.tree_030), K.SUB, sub = "hello"),
            It(ctx.getString(R.string.tree_031), ctx.getString(R.string.tree_032), K.SUB, sub = "bg"),
            It(ctx.getString(R.string.tree_033), ctx.getString(R.string.tree_034),
                K.SUB, sub = "glass"),
            // ★ 2026-10-10（3.64.0）拆「悬浮全家桶」：
            //   便签**上移一层**到这儿（主人：「把里面的便签功能往上移一层」）；
            //   而"悬浮迷你条"那一项**删掉了** —— 它的家在**音乐页**（那儿有开关 + 一个「悬浮条设置」入口），
            //   两处都能开同一个悬浮条，本来就是冲突（主人报的「两个都能用」）。
            It(ctx.getString(R.string.tree_035), ctx.getString(R.string.tree_036),
                K.SUB, sub = "note"),
        )),

        /* ───────── 网易云登录（2026-10-06）───────── */
        //  ⚠️ 明文存储 —— 主人特意要求告诉用户（页面里有专门的「隐私」卡）
        Pg("musiclogin", ctx.getString(R.string.mlg_004), listOf(
            It(ctx.getString(R.string.tree_037), ctx.getString(R.string.tree_038), K.INFO),
            It(ctx.getString(R.string.tree_039),
                ctx.getString(R.string.tree_040) +
                ctx.getString(R.string.tree_041),
                K.INFO),
        )),

        /* ───────── 悬浮迷你条（2026-10-06）───────── */
        //  它是**显示端**：播放器在模块自己的进程（MusicService），迷你条挂在宿主进程的窗口上，
        //  两边靠广播说话（ACTION_STATE / ACTION_CMD）。
        //  只有「正在放歌」时才出现；没歌自动收起。
        //  ⚠️ 与便签同一套语义：`✕` = 本会话收起，拨开关 / 重启宿主即恢复。
        //  ★ 2026-10-10（3.64.0）：这一页**只从音乐页进来**（那儿有「悬浮条设置」入口）——
        //    美化页那条入口已删（两处都能开同一个悬浮条 = 冲突）。
        Pg("bar", ctx.getString(R.string.tree_042), listOf(
            It(ctx.getString(R.string.tree_043), ctx.getString(R.string.tree_044), K.SL,
                key = "fuckds_bar_w", def = 320, min = 190, max = 600),
            It(ctx.getString(R.string.tree_045), ctx.getString(R.string.tree_046), K.SL,
                key = "fuckds_bar_h", def = 200, min = 120, max = 640),
            It(ctx.getString(R.string.tree_047),
                ctx.getString(R.string.tree_048) +
                ctx.getString(R.string.tree_049),
                K.INFO),
            It(ctx.getString(R.string.tree_050),
                ctx.getString(R.string.tree_051) +
                ctx.getString(R.string.tree_052) +
                ctx.getString(R.string.tree_053),
                K.INFO),
            It(ctx.getString(R.string.tree_054),
                ctx.getString(R.string.tree_055) +
                ctx.getString(R.string.tree_056) +
                ctx.getString(R.string.tree_057),
                K.INFO),
        )),

        /* ───────── 悬浮便签（2026-10-06）───────── */
        //  ★ 做法：往宿主窗口的 decorView 里塞一个子 View —— **零权限**
        //    （系统悬浮窗 TYPE_APPLICATION_OVERLAY 要「显示在其他应用上层」，得用户手动去开）
        //  手感：≡ 拖动 · 点正文就地编辑 · ＋新建 · ‹›切换 · －删 · ▣最小化 · ✕本会话关闭
        //        最小化形态 = 一颗圆球，点它回来
        //  ⚠️ `✕` = 「本次宿主进程里不再出现」；拨一下总开关 / 重启宿主就回来
        Pg("note", ctx.getString(R.string.tree_058), listOf(
            It(ctx.getString(R.string.tree_059), ctx.getString(R.string.tree_060), K.SW,
                key = "fuckds_note_on", def = false),
            // ★ 2026-10-06 主人：「把便签内容那个输入框去了，里面的提示单独拎出来，
            //   再加一个『左上角三条杠可以拖』的提示」
            //   ⇒ 内容框拆成三条只读说明（这条是拖动，下面两条是原框里的提示）。
            It(ctx.getString(R.string.tree_047),
                ctx.getString(R.string.tree_061),
                K.INFO),
            It(ctx.getString(R.string.tree_062),
                ctx.getString(R.string.tree_063),
                K.INFO),
            It(ctx.getString(R.string.tree_064),
                ctx.getString(R.string.tree_065) +
                ctx.getString(R.string.tree_066),
                K.INFO),
            It(ctx.getString(R.string.tree_067), ctx.getString(R.string.tree_068), K.CO, key = "fuckds_note_bg", def = 0xFFFFF3B0.toInt()),
            It(ctx.getString(R.string.tree_069), ctx.getString(R.string.tree_070), K.SL,
                key = "fuckds_note_alpha", def = 230, min = 0, max = 255),
            It(ctx.getString(R.string.tree_071), ctx.getString(R.string.tree_072), K.SL,
                key = "fuckds_note_size", def = 14, min = 10, max = 28),
        )),

        /* ───────── AI 气泡富文本（2026-10-03 · 标记 → 富文本）───────── */
        //  落点 = 宿主 markdown 渲染的「成品 AnnotatedString」唯一汇流点（fz2.p）：
        //    AI 文本 → svb.c（AssistantTextItem）→ eu6.c（Markdown）→ v91.m → fz2.p
        //  做法：用**宿主自己的** AnnotatedString.Builder 重建 ——
        //    原文段 append(orig, start, end)（样式自动跟着走）
        //    标记段 pushStyle(样式) + append(文字) + pop()
        //  锚点表、结构自检、风险清单见 专题/AI气泡富文本-锚点勘察.md。
        Pg("richtext", ctx.getString(R.string.tree_073), listOf(
            It(ctx.getString(R.string.tree_074),
                ctx.getString(R.string.tree_075),
                K.INFO),
            It(ctx.getString(R.string.tree_076), ctx.getString(R.string.tree_077),
                K.SW, key = "fuckds_rich_on", def = false),
            It(ctx.getString(R.string.tree_078),
                ctx.getString(R.string.tree_079) +
                ctx.getString(R.string.tree_080) +
                ctx.getString(R.string.tree_081) +
                ctx.getString(R.string.tree_082) +
                ctx.getString(R.string.tree_083),
                K.SW, key = "fuckds_rich_bare", def = true),
            It(ctx.getString(R.string.tree_084),
                ctx.getString(R.string.tree_085),
                K.TX, key = "fuckds_rich_tpls", def = ""),
            // ★ 2026-10-10（3.61.0）：这里原来有两个按钮 ——
            //   ①「把格式约定写进系统提示词」②（旧③）「清空灌入的约定」——**都搬走了**。
            //   新版界面把这两件事换成「把卡片拖进 / 拖出容器」：
            //   拖进容器 = 灌入 · 拖回抽屉 = 清空**这一张卡**灌进去的那一段。
            //   位置：首页 › 附加の功能 › 调试 ›「系统提示词 v2」。
            It(ctx.getString(R.string.tree_086), ctx.getString(R.string.tree_087),
                K.ACT, cmd = "rich_demo"),
            It(ctx.getString(R.string.tree_088),
                ctx.getString(R.string.tree_089) +
                ctx.getString(R.string.tree_090) +
                ctx.getString(R.string.tree_091) +
                ctx.getString(R.string.tree_092) +
                ctx.getString(R.string.tree_093) +
                ctx.getString(R.string.tree_094),
                K.SW, key = "fuckds_html_on", def = false),
            It(ctx.getString(R.string.tree_095), ctx.getString(R.string.tree_096),
                K.SW, key = "fuckds_html_light", def = false),
            It(ctx.getString(R.string.tree_097), ctx.getString(R.string.tree_098), K.CO, key = "fuckds_rich_c1", def = 0xFFFF5252.toInt()),
            It(ctx.getString(R.string.tree_099), null, K.CO, key = "fuckds_rich_c2", def = 0xFFFFB300.toInt()),
            It(ctx.getString(R.string.tree_100), null, K.CO, key = "fuckds_rich_c3", def = 0xFFFFD600.toInt()),
            It(ctx.getString(R.string.tree_101), null, K.CO, key = "fuckds_rich_c4", def = 0xFF4CAF50.toInt()),
            It(ctx.getString(R.string.tree_102), null, K.CO, key = "fuckds_rich_c5", def = 0xFF26A69A.toInt()),
            It(ctx.getString(R.string.tree_103), null, K.CO, key = "fuckds_rich_c6", def = 0xFF42A5F5.toInt()),
            It(ctx.getString(R.string.tree_104), null, K.CO, key = "fuckds_rich_c7", def = 0xFF7E57C2.toInt()),
            It(ctx.getString(R.string.tree_105), null, K.CO, key = "fuckds_rich_c8", def = 0xFFEC407A.toInt()),
            It(ctx.getString(R.string.tree_106), null, K.CO, key = "fuckds_rich_c9", def = 0xFF9E9E9E.toInt()),
        )),

        /* ───────── 液态玻璃（2026-09-30 · 参照「底栏液态玻璃」）───────── */
        //  ★ 主人拍板做减法：圆角 / 水滴 / 亮边 / 斜向高光 全部拆掉，
        //    只留「液态玻璃本体（糊 + 折射）+ 一个自定义颜色」。
        Pg("glass", ctx.getString(R.string.tree_107), listOf(
            It(ctx.getString(R.string.tree_108),
                ctx.getString(R.string.tree_109), K.INFO),
            It(ctx.getString(R.string.tree_110), ctx.getString(R.string.tree_111),
                K.SW, key = "fuckds_glass_on", def = false, sk = "glass_on"),
            It(ctx.getString(R.string.tree_112), ctx.getString(R.string.tree_113),
                K.CO, key = "fuckds_glass_color", def = 0xFFFFFFFF.toInt()),
            It(ctx.getString(R.string.tree_114), ctx.getString(R.string.tree_115),
                K.SL, key = "fuckds_glass_tint", def = 45, min = 0, max = 100),
            It(ctx.getString(R.string.tree_116), ctx.getString(R.string.tree_117), K.SL, key = "fuckds_glass_blur", def = 20, min = 0, max = 40),
            It(ctx.getString(R.string.tree_118), ctx.getString(R.string.tree_119),
                K.SL, key = "fuckds_glass_disp", def = 12, min = 0, max = 60),
            It(ctx.getString(R.string.tree_120), ctx.getString(R.string.tree_121),
                K.SW, key = "fuckds_glass_fit", def = true),
            It(ctx.getString(R.string.tree_122), ctx.getString(R.string.tree_123) +
                    ctx.getString(R.string.tree_124),
                K.CH, key = "fuckds_glass_form", def = 0,
                choices = listOf(ctx.getString(R.string.tree_125), ctx.getString(R.string.tree_126), ctx.getString(R.string.tree_127))),
            It(ctx.getString(R.string.tree_128), ctx.getString(R.string.tree_129),
                K.SL, key = "fuckds_glass_edge", def = 20, min = 0, max = 60),
            It(ctx.getString(R.string.tree_130), ctx.getString(R.string.tree_131),
                K.SL, key = "fuckds_glass_fade", def = 50, min = 0, max = 100),
            It(ctx.getString(R.string.tree_132), ctx.getString(R.string.tree_133),
                K.CH, key = "fuckds_glass_scope", def = 0,
                choices = listOf(ctx.getString(R.string.tree_134), ctx.getString(R.string.tree_135))),
            It(ctx.getString(R.string.tree_136), ctx.getString(R.string.tree_137),
                K.CH, key = "fuckds_glass_engine", def = 0,
                choices = listOf(ctx.getString(R.string.tree_138), ctx.getString(R.string.tree_139), ctx.getString(R.string.tree_140))),
            It(ctx.getString(R.string.tree_141), ctx.getString(R.string.tree_142),
                K.SW, key = "fuckds_glass_clean", def = false),
            It(ctx.getString(R.string.tree_143), ctx.getString(R.string.tree_144),
                K.SL, key = "fuckds_glass_clean_tol", def = 12, min = 0, max = 60),
            It(ctx.getString(R.string.tree_145), ctx.getString(R.string.tree_146) +
                    ctx.getString(R.string.tree_147) +
                    ctx.getString(R.string.tree_148) +
                    ctx.getString(R.string.tree_149),
                K.CH, key = "fuckds_glass_src", def = 0,
                choices = listOf(ctx.getString(R.string.tree_150), ctx.getString(R.string.tree_151), ctx.getString(R.string.tree_152))),
            It(ctx.getString(R.string.tree_153), ctx.getString(R.string.tree_154),
                K.CH, key = "fuckds_glass_impl", def = 0,
                choices = listOf(ctx.getString(R.string.tree_155), ctx.getString(R.string.tree_156), ctx.getString(R.string.tree_157))),
        )),

        /* ───────── 气泡（GmBubbleDialog）───────── */
        /* ───────── 修改助手图片（二级菜单 · 2026-10-03 主人要求）───────── */
        Pg("avatar_img", ctx.getString(R.string.tree_158), listOf(
            It(ctx.getString(R.string.tree_158), ctx.getString(R.string.tree_159),
                K.SW, key = "ui_avatar_on", def = false, cmd = "avatar_on", sk = "avatar_on"),
            It(ctx.getString(R.string.tree_160), null, K.PICK, cmd = "avatar"),
        )),

        /* ───────── 对话气泡设置（二级菜单 · AI/我的气泡 + 通用锚点）───────── */
        Pg("bubble_conv", ctx.getString(R.string.tree_161), listOf(
            It(ctx.getString(R.string.tree_162), ctx.getString(R.string.tree_163), K.SUB, sub = "bubble_ai"),
            It(ctx.getString(R.string.tree_164), ctx.getString(R.string.tree_165), K.SUB, sub = "bubble_u"),
            It(ctx.getString(R.string.tree_166), ctx.getString(R.string.tree_167),
                K.CH, key = "fuckds_bubble_anchor", def = 1,
                choices = listOf(ctx.getString(R.string.tree_168), ctx.getString(R.string.tree_169), ctx.getString(R.string.tree_170), ctx.getString(R.string.tree_171), ctx.getString(R.string.tree_172), ctx.getString(R.string.tree_173), ctx.getString(R.string.tree_174), ctx.getString(R.string.tree_175), ctx.getString(R.string.tree_176))),
        )),

        Pg("bubble_ai", ctx.getString(R.string.tree_177), listOf(
            It(ctx.getString(R.string.tree_178), ctx.getString(R.string.tree_179),
                K.SW, key = "fuckds_bubble_on", def = true, sk = "bubble_on"),
            It(ctx.getString(R.string.tree_180), null, K.CO, key = "fuckds_bubble_color", def = 0),
            It(ctx.getString(R.string.tree_181), ctx.getString(R.string.tree_182), K.SL, key = "fuckds_bubble_radius", def = 0, min = 0, max = 48),
            It(ctx.getString(R.string.tree_183), "0–255", K.SL, key = "fuckds_bubble_alpha", def = 255, min = 0, max = 255),
            It(ctx.getString(R.string.tree_184), ctx.getString(R.string.tree_185),
                K.SL, key = "fuckds_bubble_maxz", def = 100, min = 50, max = 200),
            It(ctx.getString(R.string.tree_186), ctx.getString(R.string.tree_187), K.SW, key = "fuckds_bubble_img", def = false),
            It(ctx.getString(R.string.tree_188), null, K.PICK, cmd = "bubble"),
        )),
        Pg("bubble_u", ctx.getString(R.string.tree_189), listOf(
            It(ctx.getString(R.string.tree_190), ctx.getString(R.string.tree_191),
                K.SW, key = "fuckds_ububble_on", def = true, sk = "ububble_on"),
            It(ctx.getString(R.string.tree_180), null, K.CO, key = "fuckds_ububble_color", def = 0),
            It(ctx.getString(R.string.tree_181), ctx.getString(R.string.tree_182), K.SL, key = "fuckds_ububble_radius", def = 0, min = 0, max = 48),
            It(ctx.getString(R.string.tree_186), null, K.SW, key = "fuckds_ububble_img", def = false),
            It(ctx.getString(R.string.tree_188), null, K.PICK, cmd = "ububble"),
        )),

        /* ───────── 修改背景（GmBgDialog）───────── */
        Pg("bg", ctx.getString(R.string.tree_192), listOf(
            It(ctx.getString(R.string.tree_193),
                null, K.INFO),
            It(ctx.getString(R.string.tree_194), null, K.SW, key = "fuckds_bg_on", def = false),
            It(ctx.getString(R.string.tree_195), null, K.CH, key = "fuckds_bg_mode", def = 0,
                choices = listOf(ctx.getString(R.string.tree_196), ctx.getString(R.string.tree_197), ctx.getString(R.string.tree_198))),
            It(ctx.getString(R.string.tree_160), null, K.PICK, cmd = "bg"),
            It(ctx.getString(R.string.tree_199), null, K.CH, key = "fuckds_bg_cam", def = 0,
                choices = listOf(ctx.getString(R.string.tree_200), ctx.getString(R.string.tree_201))),
            It(ctx.getString(R.string.tree_202), ctx.getString(R.string.tree_203), K.SL, key = "fuckds_bg_rot", def = 0, min = 0, max = 360),
            It(ctx.getString(R.string.tree_204), ctx.getString(R.string.tree_205), K.SL, key = "fuckds_bg_crop", def = 0, min = 0, max = 100),
            It(ctx.getString(R.string.tree_206), ctx.getString(R.string.tree_207), K.SL, key = "fuckds_bg_grad", def = 0, min = 0, max = 3),
            It(ctx.getString(R.string.tree_183), ctx.getString(R.string.tree_205), K.SL, key = "fuckds_bg_alpha", def = 25, min = 0, max = 100),
            It(ctx.getString(R.string.tree_208), null, K.CH, key = "fuckds_bg_pos", def = 0,
                choices = listOf(ctx.getString(R.string.tree_155), ctx.getString(R.string.tree_209), ctx.getString(R.string.tree_210))),
        )),

        /* ───────── 环境伪装（GmEnvDialog）───────── */
        Pg("env", ctx.getString(R.string.tree_004), listOf(
            It(ctx.getString(R.string.tree_211), null, K.INFO),
            It(ctx.getString(R.string.tree_212), ctx.getString(R.string.tree_213),
                K.SW, key = "fuckds_gm", def = true),
            It(ctx.getString(R.string.tree_214), ctx.getString(R.string.tree_215),
                K.SW, key = "fuckds_gm", def = true, cmd = "env_api"),
            It(ctx.getString(R.string.tree_216), ctx.getString(R.string.tree_217),
                K.SW, key = "fuckds_device_on", def = false, sk = "device_on"),
            It(ctx.getString(R.string.tree_218), null, K.ACT, cmd = "dev_reset"),
            It(ctx.getString(R.string.tree_219)
                    + ctx.getString(R.string.tree_220), null, K.INFO),
        )),

        /* ───────── 调试（GmDsDialog）───────── */
        Pg("debug", ctx.getString(R.string.scr_009), listOf(
            It(ctx.getString(R.string.tree_221), ctx.getString(R.string.tree_222), K.SUB, sub = "dump"),
            It(ctx.getString(R.string.tree_223), ctx.getString(R.string.tree_224),
                K.ACT, cmd = "probe_toggle"),
            // 调试页加一条：把宿主存储整个倒出来（诊断键名用）
            It(ctx.getString(R.string.tree_225), ctx.getString(R.string.tree_226),
                K.ACT, cmd = "rows_dump"),
            It(ctx.getString(R.string.tree_227), ctx.getString(R.string.tree_228),
                K.ACT, cmd = "store_dump"),
            // ★ 2026-10-10（3.63.7）**暂时禁用**（主人：「把旧提示词输入暂时禁用，改成新提示词试试」）：
            //   这个入口会打开**老 UI**，而老 UI 的系统提示词页**可以手打提示词内容**
            //   （还能点旧的「灌入约定」）—— 它会跟新版界面的「卡片拼接」互相覆盖。
            //   ⇒ 先摘掉这个入口，让**新提示词（卡片拼接）成为唯一的写入方**。
            //   （想恢复：把下面两行注释解开即可。）
            //
            // It("模块菜单（原 GmMenuDialog）", "灰度选项管理 / 聊天 / 美化 / 回复建议 / 环境伪装 / 日志",
            //     K.SUB, sub = "menu"),
            It(ctx.getString(R.string.tree_229),
                ctx.getString(R.string.tree_230) +
                ctx.getString(R.string.tree_231) +
                ctx.getString(R.string.tree_232) +
                ctx.getString(R.string.tree_233),
                K.INFO),
        )),

        /* ───────── 系统提示词（2026-10-10 · 卡片式新版，已迁到「聊天 › 系统提示词」）───────── */
        //  真身由 Pages.kt 特判渲染（SysPromptV2Page），这里的 items 是空占位 ——
        //  只为了让 Tree.page("sysprompt_v2") 有据可查，不至于变成"找不到这一页"。
        Pg("sysprompt_v2", ctx.getString(R.string.spv_013), emptyList()),

        /* ───────── 日志（GmDumpDialog）───────── */
        Pg("dump", ctx.getString(R.string.tree_006), listOf(
            It(ctx.getString(R.string.tree_234), ctx.getString(R.string.tree_235),
                K.ACT, cmd = "dump_text"),
            It(ctx.getString(R.string.tree_236), null, K.ACT, cmd = "dump_clear"),
            It(ctx.getString(R.string.tree_237), null, K.COPY, cmd = "dump_text"),
        )),

        /* ───────── 回复建议（GmSuggestDialog）───────── */
        Pg("suggest", ctx.getString(R.string.spv_003), listOf(
            It(ctx.getString(R.string.tree_074),
                ctx.getString(R.string.tree_075),
                K.INFO),
            It(ctx.getString(R.string.tree_238),
                ctx.getString(R.string.tree_239) +
                ctx.getString(R.string.tree_240) +
                ctx.getString(R.string.tree_241),
                K.INFO),
            It(ctx.getString(R.string.tree_212), ctx.getString(R.string.tree_242), K.SW, key = "fuckds_suggest_on", def = false),
            // ★ 2026-10-10（3.61.0）：原来这里有两个按钮
            //   ①「一键灌入提示词」②「清空灌入的约定」——**都搬走了**：
            //   新版界面用「把「回复建议」卡片拖进 / 拖出容器」代替
            //   （拖进 = 灌入【追问建议】那段 · 拖回 = 只摘那一段）。
            It(ctx.getString(R.string.tree_243), ctx.getString(R.string.tree_244),
                K.SW, key = "fuckds_suggest_ai", def = false),
            It(ctx.getString(R.string.tree_245), null, K.SL, key = "fuckds_suggest_count", def = 3, min = 1, max = 10),
            It(ctx.getString(R.string.tree_246), null, K.TX, key = "fuckds_suggest_text", def = "", sk = "suggest_text"),
            It(ctx.getString(R.string.tree_247), null, K.ACT, cmd = "suggest_reset"),
        )),

        /* ───────── 招呼语（GmHelloDialog）───────── */
        Pg("hello", ctx.getString(R.string.tree_248), listOf(
            It(ctx.getString(R.string.tree_249), null, K.INFO),
            It(ctx.getString(R.string.tree_250), ctx.getString(R.string.tree_251), K.TX, key = "fuckds_welcome_msg", def = "", sk = "welcome"),
            It(ctx.getString(R.string.tree_252), null, K.ACT, cmd = "hello_reset"),
        )),

        /* ───────── 文件快捷选项（GmPromptDialog）───────── */
        Pg("prompt", ctx.getString(R.string.tree_253), listOf(
            It(ctx.getString(R.string.tree_254),
                null, K.INFO),
            It(ctx.getString(R.string.tree_255), ctx.getString(R.string.tree_256), K.TX, key = "fuckds_prompt_feature", def = "", sk = "prompt"),
            It(ctx.getString(R.string.tree_252), null, K.ACT, cmd = "prompt_reset"),
        )),

        /* ───────── 本地数据库（GmDbDialog）───────── */
        Pg("db", ctx.getString(R.string.tree_257), listOf(
            It(ctx.getString(R.string.tree_258), null, K.INFO),
            It(ctx.getString(R.string.tree_259), null, K.ACT, cmd = "db_clear"),
        )),
    )

    fun page(ctx: Context, id: String): Pg? = pages(ctx).firstOrNull { it.id == id }

    /** 颜色调色板（原 UI 是"点选色块"） */
    fun palette(ctx: Context) = listOf(
        0x00000000, 0xFFEF5350.toInt(), 0xFFFFA726.toInt(), 0xFFFFEE58.toInt(),
        0xFF66BB6A.toInt(), 0xFF42A5F5.toInt(), 0xFF7E57C2.toInt(), 0xFFEC407A.toInt(),
    )
}
