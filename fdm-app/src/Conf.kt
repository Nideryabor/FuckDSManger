// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger
import android.content.Context
import androidx.compose.ui.res.stringResource

/**
 * 配置键表 —— 界面这一侧的「数据模型」🐲
 *
 * 每一条都是从 smali 里扫出来的（见 `专题/配置键总表.md`），**不是猜的**：
 *   key   配置键（宿主 MMKV 里的 `fuckds_*`）
 *   label 界面显示名
 *   type  B=开关  I=整数（带范围）  C=颜色  T=文本  E=枚举（带选项名）
 *   def   默认值
 *   hint  一句话说明（界面上的辅助文本）
 */
enum class KType { B, I, C, T, E }

data class Key(
    val key: String,
    val label: String,
    val type: KType,
    val def: Any,
    val min: Int = 0,
    val max: Int = 100,
    val choices: List<String> = emptyList(),
    val hint: String? = null,
)

object Conf {
    // ───────── 背景（GmBg，9 键）─────────
    fun bg(ctx: Context) = listOf(
        Key("fuckds_bg_on", ctx.getString(R.string.tree_192), KType.B, false, hint = ctx.getString(R.string.conf_001)),
        Key("fuckds_bg_mode", ctx.getString(R.string.tree_195), KType.E, 0, choices = listOf(ctx.getString(R.string.tree_197), ctx.getString(R.string.tree_196), ctx.getString(R.string.tree_198))),
        Key("fuckds_bg_alpha", ctx.getString(R.string.tree_183), KType.I, 25, 0, 100, hint = ctx.getString(R.string.conf_002)),
        Key("fuckds_bg_grad", ctx.getString(R.string.conf_003), KType.E, 0, choices = listOf(ctx.getString(R.string.conf_004), ctx.getString(R.string.conf_005), ctx.getString(R.string.conf_006), ctx.getString(R.string.conf_007))),
        Key("fuckds_bg_crop", ctx.getString(R.string.conf_008), KType.E, 0, choices = listOf(ctx.getString(R.string.conf_009), ctx.getString(R.string.conf_010))),
        Key("fuckds_bg_pos", ctx.getString(R.string.conf_011), KType.E, 1, choices = listOf(ctx.getString(R.string.conf_012), ctx.getString(R.string.conf_013), ctx.getString(R.string.conf_014))),
        Key("fuckds_bg_dir", ctx.getString(R.string.conf_015), KType.E, 0, choices = listOf(ctx.getString(R.string.conf_016), ctx.getString(R.string.conf_017))),
        Key("fuckds_bg_rot", ctx.getString(R.string.tree_202), KType.I, 0, 0, 360, hint = ctx.getString(R.string.tree_203)),
        Key("fuckds_bg_cam", ctx.getString(R.string.tree_198), KType.E, 0, choices = listOf(ctx.getString(R.string.tree_200), ctx.getString(R.string.tree_201))),
    )

    // ───────── AI 气泡（6 键）＋ 我的气泡（4 键）─────────
    fun bubble(ctx: Context) = listOf(
        Key("fuckds_bubble_on", ctx.getString(R.string.tree_177), KType.B, true),
        Key("fuckds_bubble_color", ctx.getString(R.string.conf_018), KType.C, 0),
        Key("fuckds_bubble_radius", ctx.getString(R.string.conf_019), KType.I, 0, 0, 48, hint = ctx.getString(R.string.tree_182)),
        Key("fuckds_bubble_alpha", ctx.getString(R.string.conf_020), KType.I, 0, 0, 255),
        Key("fuckds_bubble_maxz", ctx.getString(R.string.conf_021), KType.I, 100, 50, 200, hint = ctx.getString(R.string.conf_022)),
        Key("fuckds_bubble_img", ctx.getString(R.string.conf_023), KType.B, false, hint = ctx.getString(R.string.tree_187)),
        Key("fuckds_ububble_on", ctx.getString(R.string.conf_024), KType.B, true),
        Key("fuckds_ububble_color", ctx.getString(R.string.conf_025), KType.C, 0),
        Key("fuckds_ububble_radius", ctx.getString(R.string.conf_026), KType.I, 0, 0, 48, hint = ctx.getString(R.string.tree_182)),
        Key("fuckds_ububble_img", ctx.getString(R.string.conf_027), KType.B, false),
    )

    // ───────── 回复建议（4 键）─────────
    fun suggest(ctx: Context) = listOf(
        Key("fuckds_suggest_on", ctx.getString(R.string.spv_003), KType.B, false, hint = ctx.getString(R.string.conf_028)),
        Key("fuckds_suggest_ai", ctx.getString(R.string.conf_029), KType.B, false),
        Key("fuckds_suggest_count", ctx.getString(R.string.conf_030), KType.I, 3, 1, 10),
        Key("fuckds_suggest_text", ctx.getString(R.string.conf_031), KType.T, "", hint = ctx.getString(R.string.conf_032)),
    )

    // ───────── 液态玻璃（4 键 · 2026-09-30）─────────
    //  宿主侧读法见 mod-src/.../glass/GmGlassCfg.java —— 两边默认值必须一致
    //
    //  ★ 2026-09-30 主人拍板做减法：「把圆角高光去了，只保留液态玻璃和可自定义玻璃颜色本身」
    //    ⇒ 圆角 / 水滴高光 / 亮边 / 斜向高光 **全部拆掉**，键也一并撤掉
    fun glass(ctx: Context) = listOf(
        Key("fuckds_glass_on", ctx.getString(R.string.tree_107), KType.B, false, hint = ctx.getString(R.string.conf_033)),
        Key("fuckds_glass_color", ctx.getString(R.string.tree_112), KType.C, 0xFFFFFFFF.toInt(),
            hint = ctx.getString(R.string.tree_113)),
        Key("fuckds_glass_tint", ctx.getString(R.string.tree_114), KType.I, 45, 0, 100,
            hint = ctx.getString(R.string.conf_034)),
        Key("fuckds_glass_blur", ctx.getString(R.string.tree_116), KType.I, 20, 0, 40, hint = ctx.getString(R.string.conf_035)),
        Key("fuckds_glass_disp", ctx.getString(R.string.tree_118), KType.I, 12, 0, 60,
            hint = ctx.getString(R.string.tree_119)),
        Key("fuckds_glass_scope", ctx.getString(R.string.tree_132), KType.E, 0,
            choices = listOf(ctx.getString(R.string.tree_134), ctx.getString(R.string.tree_135))),
        // ★ 主人 2026-09-30：「再疯一点：多方案切换」
        //   shader 正文在 参考/液态玻璃多方案/*.agsl，由 tools/gen_glass_shaders.py 逐字生成
        Key("fuckds_glass_engine", ctx.getString(R.string.tree_136), KType.E, 0,
            choices = listOf(ctx.getString(R.string.tree_138), ctx.getString(R.string.tree_139), ctx.getString(R.string.tree_140))),
        // ★ 主人：「还是会抓到别的文字……」——底图是整屏截图，连字一起截进去了。
        //   打开后从元素边缘估背景色，把离它太远的像素（文字/图标）替换掉 ⇒ 底图干净
        Key("fuckds_glass_clean", ctx.getString(R.string.tree_141), KType.B, false,
            hint = ctx.getString(R.string.conf_036)),
        Key("fuckds_glass_clean_tol", ctx.getString(R.string.tree_143), KType.I, 12, 0, 60,
            hint = ctx.getString(R.string.tree_144)),
        // ★ 底图来源（2026-09-30 主人拍板走「底色」）
        // ★ 第三种（2026-10-01 主人：「糊了就不叫玻璃了」）——
        //   玻璃要的是「看清 + 边缘掰弯」，不是糊。而背景图正好给"清晰 + 有纹理"
        Key("fuckds_glass_src", ctx.getString(R.string.tree_145), KType.E, 0,
            choices = listOf(ctx.getString(R.string.tree_150), ctx.getString(R.string.tree_151), ctx.getString(R.string.tree_152))),
        // ★ 主人：「顺便实现方式加一个 cpu 模拟做备用」
        //   GPU = RenderNode + RenderEffect（画质好、性能好，但要硬件画布）
        //   CPU = 纯 Canvas 绘制（BitmapShader 当 Paint 的 shader），兼容面更宽
        Key("fuckds_glass_impl", ctx.getString(R.string.tree_153), KType.E, 0,
            choices = listOf(ctx.getString(R.string.tree_155), ctx.getString(R.string.tree_156), ctx.getString(R.string.tree_157))),
    )

    // ───────── 其它文本（2 键）─────────
    fun texts(ctx: Context) = listOf(
        Key("fuckds_welcome_msg", ctx.getString(R.string.tree_250), KType.T, "", hint = ctx.getString(R.string.conf_037)),
        Key("fuckds_prompt_feature", ctx.getString(R.string.conf_038), KType.T, ""),
    )

    // ───────── 过检（5 键）─────────
    fun pass(ctx: Context) = listOf(
        Key("fuckds_gm", ctx.getString(R.string.tree_212), KType.B, false, hint = ctx.getString(R.string.conf_039)),
        Key("fuckds_device_on", ctx.getString(R.string.tree_216), KType.B, false, hint = ctx.getString(R.string.conf_040)),
        Key("fuckds_device_id", ctx.getString(R.string.conf_041), KType.T, "", hint = ctx.getString(R.string.conf_042)),
        Key("fuckds_dev_ask3", ctx.getString(R.string.conf_043), KType.B, false),
        Key("fuckds_model_switch", ctx.getString(R.string.tree_009), KType.B, false, hint = ctx.getString(R.string.conf_044)),
    )

    // ───────── 悬浮便签（5 键 · 2026-10-06）─────────
    //  宿主侧读法见 mod-src/.../bridge/GmNote.java —— 两边默认值必须一致
    //  ⚠️ fuckds_note_data（便签全部内容的 JSON 存档）由宿主自己维护，界面不直接碰
    fun note(ctx: Context) = listOf(
        Key("fuckds_note_on", ctx.getString(R.string.tree_059), KType.B, false, hint = ctx.getString(R.string.conf_045)),
        Key("fuckds_note_bg", ctx.getString(R.string.tree_067), KType.C, 0xFFFFF3B0.toInt()),
        Key("fuckds_note_alpha", ctx.getString(R.string.tree_069), KType.I, 230, 0, 255),
        Key("fuckds_note_size", ctx.getString(R.string.tree_071), KType.I, 14, 10, 28, hint = ctx.getString(R.string.conf_046)),
        // ⚠️ `fuckds_note_text` 不在界面上了（2026-10-06 主人：「把那个输入框去了」）——
        //    它是**宿主自己维护**的键，界面不再读写。
        //    （宿主侧仍留了一条 adb 通道：`cfg_put … note_text`，那是我调试便签文字用的。）
    )

    // ───────── 悬浮迷你条（1 键 · 2026-10-06）─────────
    //  播放器在模块自己进程（MusicService），迷你条挂在宿主进程 ⇒ 两边靠广播。
    //  这里只有「显示开关」；位置（fuckds_bar_y）由迷你条自己维护。
    fun bar(ctx: Context) = listOf(
        Key("fuckds_bar_on", ctx.getString(R.string.mus_004), KType.B, false, hint = ctx.getString(R.string.conf_047)),
        Key("fuckds_bar_w", ctx.getString(R.string.tree_043), KType.I, 320, 190, 600, hint = ctx.getString(R.string.conf_048)),
        Key("fuckds_bar_h", ctx.getString(R.string.tree_045), KType.I, 200, 120, 640, hint = ctx.getString(R.string.conf_048)),
        // ★ 2026-10-06 · 音源伪装：换一种"客户端身份"去请求（pc / android / iPhone）
        //   ⚠️ 实测：对 VIP 曲（fee=1）**没差别**，三档都只给试听片段 ——
        //      那要登录+会员才行。保留它是因为"os 与 UA 一致"本身是必要的修正。
        Key("fuckds_music_os", ctx.getString(R.string.mus_020), KType.E, 2, choices = listOf("PC", "Android", "iPhone")),
    )

    /**
     * 调试页用：全部键（含只读的）。
     * ★ 3.68.0：因为每一项的**显示名**现在来自资源（要按"说话方式"取），
     *   所以这里也变成一个"要 ctx 的函数"（原来是顶层 val）。
     */
    fun all(ctx: Context): List<Key> =
        bg(ctx) + bubble(ctx) + suggest(ctx) + glass(ctx) + texts(ctx) + pass(ctx) + note(ctx) + bar(ctx)

    fun find(ctx: Context, key: String): Key? = all(ctx).firstOrNull { it.key == key }

    /**
     * 可选颜色（界面用；值本身是 ARGB int）。
     *
     * 前面 5 个是给**液态玻璃**用的中性色（玻璃是磨砂质感，中性色才对味），
     * 后面是气泡一直用的那批彩色。
     */
    fun palette(ctx: Context) = listOf(
        0xFFFFFFFF.toInt(), 0xFFE8E8E8.toInt(), 0xFF9E9E9E.toInt(),
        0xFF3A3A3A.toInt(), 0xFF000000.toInt(),
        0x00000000, 0xFFEF5350.toInt(), 0xFFFFA726.toInt(), 0xFFFFEE58.toInt(),
        0xFF66BB6A.toInt(), 0xFF42A5F5.toInt(), 0xFF7E57C2.toInt(), 0xFFEC407A.toInt(),
    )
}
