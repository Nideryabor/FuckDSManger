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

    /** 调试页用：全部键（含只读的） */
    val all: List<Key> = bg + bubble + suggest + texts + pass

    fun find(key: String): Key? = all.firstOrNull { it.key == key }

    /** 气泡可选颜色（界面用；值本身是 ARGB int） */
    val palette = listOf(
        0x00000000, 0xFFEF5350.toInt(), 0xFFFFA726.toInt(), 0xFFFFEE58.toInt(),
        0xFF66BB6A.toInt(), 0xFF42A5F5.toInt(), 0xFF7E57C2.toInt(), 0xFFEC407A.toInt(),
    )
}
