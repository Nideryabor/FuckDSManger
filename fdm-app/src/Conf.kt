// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

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
    val bg = listOf(
        Key("fuckds_bg_on", "修改背景", KType.B, false, hint = "总开关：关掉就完全不动宿主背景"),
        Key("fuckds_bg_mode", "背景来源", KType.E, 0, choices = listOf("渐变", "图片", "摄像头")),
        Key("fuckds_bg_alpha", "透明度", KType.I, 25, 0, 100, hint = "越小越透（25 = 露出 25%）"),
        Key("fuckds_bg_grad", "渐变预设", KType.E, 0, choices = listOf("预设 1", "预设 2", "预设 3", "预设 4")),
        Key("fuckds_bg_crop", "裁切方式", KType.E, 0, choices = listOf("居中填满", "拉伸")),
        Key("fuckds_bg_pos", "位置", KType.E, 1, choices = listOf("顶", "中", "底")),
        Key("fuckds_bg_dir", "方向", KType.E, 0, choices = listOf("横向", "纵向")),
        Key("fuckds_bg_rot", "旋转", KType.I, 0, 0, 360, hint = "单位：度"),
        Key("fuckds_bg_cam", "摄像头", KType.E, 0, choices = listOf("后置", "前置")),
    )

    // ───────── AI 气泡（6 键）＋ 我的气泡（4 键）─────────
    val bubble = listOf(
        Key("fuckds_bubble_on", "AI 气泡美化", KType.B, true),
        Key("fuckds_bubble_color", "AI 气泡颜色", KType.C, 0),
        Key("fuckds_bubble_radius", "AI 气泡圆角", KType.I, 0, 0, 48, hint = "单位 dp"),
        Key("fuckds_bubble_alpha", "AI 气泡透明度", KType.I, 0, 0, 255),
        Key("fuckds_bubble_maxz", "AI 气泡放大", KType.I, 100, 50, 200, hint = "百分数，100 = 原大小"),
        Key("fuckds_bubble_img", "AI 气泡用图片", KType.B, false, hint = "用自定义图片当气泡底"),
        Key("fuckds_ububble_on", "我的气泡美化", KType.B, true),
        Key("fuckds_ububble_color", "我的气泡颜色", KType.C, 0),
        Key("fuckds_ububble_radius", "我的气泡圆角", KType.I, 0, 0, 48, hint = "单位 dp"),
        Key("fuckds_ububble_img", "我的气泡用图片", KType.B, false),
    )

    // ───────── 回复建议（4 键）─────────
    val suggest = listOf(
        Key("fuckds_suggest_on", "回复建议", KType.B, false, hint = "在输入框上方给建议"),
        Key("fuckds_suggest_ai", "用 AI 生成建议", KType.B, false),
        Key("fuckds_suggest_count", "建议条数", KType.I, 3, 1, 10),
        Key("fuckds_suggest_text", "自定义建议文本", KType.T, "", hint = "留空 = 不用固定文本"),
    )

    // ───────── 液态玻璃（4 键 · 2026-09-30）─────────
    //  宿主侧读法见 mod-src/.../glass/GmGlassCfg.java —— 两边默认值必须一致
    //
    //  ★ 2026-09-30 主人拍板做减法：「把圆角高光去了，只保留液态玻璃和可自定义玻璃颜色本身」
    //    ⇒ 圆角 / 水滴高光 / 亮边 / 斜向高光 **全部拆掉**，键也一并撤掉
    val glass = listOf(
        Key("fuckds_glass_on", "液态玻璃", KType.B, false, hint = "给宿主所有元素套上玻璃"),
        Key("fuckds_glass_color", "玻璃颜色", KType.C, 0xFFFFFFFF.toInt(),
            hint = "玻璃本体就这一层颜色；浓度当它的透明度"),
        Key("fuckds_glass_tint", "浓度（= 透明度）", KType.I, 45, 0, 100,
            hint = "0 = 全透只剩玻璃，100 = 完全不透"),
        Key("fuckds_glass_blur", "模糊度", KType.I, 20, 0, 40, hint = "越大越磨砂"),
        Key("fuckds_glass_disp", "色散", KType.I, 12, 0, 60,
            hint = "边缘按 RGB 分离采样（×0.1px）—— 这是「液态」最像的那一下"),
        Key("fuckds_glass_scope", "作用范围", KType.E, 0,
            choices = listOf("所有元素", "仅标准按钮")),
        // ★ 主人 2026-09-30：「再疯一点：多方案切换」
        //   shader 正文在 参考/液态玻璃多方案/*.agsl，由 tools/gen_glass_shaders.py 逐字生成
        Key("fuckds_glass_engine", "方案", KType.E, 0,
            choices = listOf("Haze 式", "Cloudy 式", "轻量扰动")),
        // ★ 主人：「还是会抓到别的文字……」——底图是整屏截图，连字一起截进去了。
        //   打开后从元素边缘估背景色，把离它太远的像素（文字/图标）替换掉 ⇒ 底图干净
        Key("fuckds_glass_clean", "擦掉内容（只留背景色）", KType.B, false,
            hint = "解决「玻璃里糊出字、和上层文字叠影」"),
        Key("fuckds_glass_clean_tol", "擦除容差", KType.I, 12, 0, 60,
            hint = "×0.01；越大擦得越狠（可能连浅色图标一起擦）"),
        // ★ 底图来源（2026-09-30 主人拍板走「底色」）
        // ★ 第三种（2026-10-01 主人：「糊了就不叫玻璃了」）——
        //   玻璃要的是「看清 + 边缘掰弯」，不是糊。而背景图正好给"清晰 + 有纹理"
        Key("fuckds_glass_src", "底图来源", KType.E, 0,
            choices = listOf("元素底色", "屏幕截图", "我的背景图")),
        // ★ 主人：「顺便实现方式加一个 cpu 模拟做备用」
        //   GPU = RenderNode + RenderEffect（画质好、性能好，但要硬件画布）
        //   CPU = 纯 Canvas 绘制（BitmapShader 当 Paint 的 shader），兼容面更宽
        Key("fuckds_glass_impl", "实现方式", KType.E, 0,
            choices = listOf("自动", "强制 GPU", "强制 CPU")),
    )

    // ───────── 其它文本（2 键）─────────
    val texts = listOf(
        Key("fuckds_welcome_msg", "招呼语", KType.T, "", hint = "打开 App 时显示的那句话"),
        Key("fuckds_prompt_feature", "提示词注入", KType.T, ""),
    )

    // ───────── 过检（5 键）─────────
    val pass = listOf(
        Key("fuckds_gm", "总开关", KType.B, false, hint = "模块的总闸（改它影响面最大）"),
        Key("fuckds_device_on", "设备身份伪装", KType.B, false, hint = "换掉 android_id，治风控 RISK_DEVICE_DETECTED"),
        Key("fuckds_device_id", "当前伪造 ID", KType.T, "", hint = "只读展示；一次性换、换完别来回拨"),
        Key("fuckds_dev_ask3", "已提示过（内部）", KType.B, false),
        Key("fuckds_model_switch", "模型切换", KType.B, false, hint = "改完要重启宿主才看得见（它会改写宿主的模型配置）"),
    )

    // ───────── 悬浮便签（5 键 · 2026-10-06）─────────
    //  宿主侧读法见 mod-src/.../bridge/GmNote.java —— 两边默认值必须一致
    //  ⚠️ fuckds_note_data（便签全部内容的 JSON 存档）由宿主自己维护，界面不直接碰
    val note = listOf(
        Key("fuckds_note_on", "显示便签", KType.B, false, hint = "挂在宿主窗口上的浮层（零权限）"),
        Key("fuckds_note_bg", "便签底色", KType.C, 0xFFFFF3B0.toInt()),
        Key("fuckds_note_alpha", "不透明度", KType.I, 230, 0, 255),
        Key("fuckds_note_size", "字号", KType.I, 14, 10, 28, hint = "单位 sp"),
        // ⚠️ `fuckds_note_text` 不在界面上了（2026-10-06 主人：「把那个输入框去了」）——
        //    它是**宿主自己维护**的键，界面不再读写。
        //    （宿主侧仍留了一条 adb 通道：`cfg_put … note_text`，那是我调试便签文字用的。）
    )

    // ───────── 悬浮迷你条（1 键 · 2026-10-06）─────────
    //  播放器在模块自己进程（MusicService），迷你条挂在宿主进程 ⇒ 两边靠广播。
    //  这里只有「显示开关」；位置（fuckds_bar_y）由迷你条自己维护。
    val bar = listOf(
        Key("fuckds_bar_on", "显示迷你条", KType.B, false, hint = "常驻卡片，放歌时才显示"),
        Key("fuckds_bar_w", "卡片宽度", KType.I, 320, 190, 600, hint = "单位 dp（拖角也行）"),
        Key("fuckds_bar_h", "卡片高度", KType.I, 200, 120, 640, hint = "单位 dp（拖角也行）"),
        // ★ 2026-10-06 · 音源伪装：换一种"客户端身份"去请求（pc / android / iPhone）
        //   ⚠️ 实测：对 VIP 曲（fee=1）**没差别**，三档都只给试听片段 ——
        //      那要登录+会员才行。保留它是因为"os 与 UA 一致"本身是必要的修正。
        Key("fuckds_music_os", "音源伪装", KType.E, 2, choices = listOf("PC", "Android", "iPhone")),
    )

    /** 调试页用：全部键（含只读的） */
    val all: List<Key> = bg + bubble + suggest + glass + texts + pass + note + bar

    fun find(key: String): Key? = all.firstOrNull { it.key == key }

    /**
     * 可选颜色（界面用；值本身是 ARGB int）。
     *
     * 前面 5 个是给**液态玻璃**用的中性色（玻璃是磨砂质感，中性色才对味），
     * 后面是气泡一直用的那批彩色。
     */
    val palette = listOf(
        0xFFFFFFFF.toInt(), 0xFFE8E8E8.toInt(), 0xFF9E9E9E.toInt(),
        0xFF3A3A3A.toInt(), 0xFF000000.toInt(),
        0x00000000, 0xFFEF5350.toInt(), 0xFFFFA726.toInt(), 0xFFFFEE58.toInt(),
        0xFF66BB6A.toInt(), 0xFF42A5F5.toInt(), 0xFF7E57C2.toInt(), 0xFFEC407A.toInt(),
    )
}
