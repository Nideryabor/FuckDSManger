package com.nidyaber.fuckdsmanger

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
    val home = listOf(
        // ★ 首页这一项在原版里就是"宿主隐藏设置的编辑器"（= GmDialog 那张灰度开关表），不是模块菜单
        It("灰度选项管理", "查看宿主隐藏设置(小心封号)", K.SUB, sub = "gray"),
        It("过检", "如果ds压力root设备/发现lsp，点我", K.SUB, sub = "env"),
        It("调试", "如果没bug，里面的东西别乱动", K.SUB, sub = "debug"),
        It("聊天", null, K.SUB, sub = "chat"),
        It("美化", null, K.SUB, sub = "beauty"),
    )

    val pages: List<Pg> = listOf(

        /* ───────── 菜单（GmMenuDialog）───────── */
        Pg("menu", "DeepSeek 灰度开关工具箱", listOf(
            It("灰度选项管理", "宿主下发配置的开关编辑器（改完保存，自动备份原值）",
                K.SUB, sub = "gray"),
            It("聊天", null, K.SUB, sub = "chat"),
            It("美化", null, K.SUB, sub = "beauty"),
            It("回复建议", "AI 最新回复下方加一排追问按钮，点一下即发送", K.SUB, sub = "suggest"),
            It("环境伪装", "隐藏 root / 模块痕迹，绕过风控环境检测", K.SUB, sub = "env"),
            It("调试 / 日志（DSMlogs）", null, K.SUB, sub = "debug"),
        )),

        /* ───────── 聊天（GmChatDialog）───────── */
        Pg("chat", "聊天", listOf(
            It("防撤回", "开启后消息会备份到本地数据库，占用存储空间",
                K.SW, key = "ui_db_on", def = true, cmd = "db_on", sk = "db_on"),
            It("模型切换", "开启后可在会话中切换到专家模式 / 识图模式",
                K.SW, key = "fuckds_model_switch", def = false),
            It("本地数据库管理", null, K.SUB, sub = "db"),
            It("回复建议 ›", "输入框上方显示一排可点击的回复建议，点一下直接发送（数量/文字可自定义）",
                K.SUB, sub = "suggest"),
        )),

        /* ───────── 美化（GmBeautyDialog）───────── */
        Pg("beauty", "美化", listOf(
            It("修改助手图片", "开启后可自定义 AI 回复旁的头像",
                K.SW, key = "ui_avatar_on", def = false, cmd = "avatar_on", sk = "avatar_on"),
            It("选择图片", null, K.PICK, cmd = "avatar"),
            It("AI 气泡美化", "颜色 / 圆角 / 图片底（点进设置）", K.SUB, sub = "bubble_ai"),
            It("用户气泡美化", "颜色 / 圆角 / 图片底（点进设置）", K.SUB, sub = "bubble_u"),
            It("自定义账号名", "留空 = 隐藏账号名；修改后重启宿主生效",
                K.TX, key = "ui_nick", def = "", cmd = "name_put", sk = "name"),
            It("修改账号头像", "开启后可自定义侧边栏底部的账号头像",
                K.SW, key = "ui_uavatar_on", def = false, cmd = "uavatar_on", sk = "uavatar_on"),
            It("选择账号头像", null, K.PICK, cmd = "uavatar"),
            It("文件快捷选项 ›", "自定义上传文件后的快捷发送项（JSON）", K.SUB, sub = "prompt"),
            It("招呼用语 ›", "自定义新会话的开屏招呼语", K.SUB, sub = "hello"),
            It("修改背景 ›", "图片或动态渐变背景，透明度可调", K.SUB, sub = "bg"),
            It("液态玻璃 ›", "给宿主所有按钮换上玻璃底（截底层→糊→折射）",
                K.SUB, sub = "glass"),
        )),

        /* ───────── 液态玻璃（2026-09-30 · 参照「底栏液态玻璃」）───────── */
        //  ★ 主人拍板做减法：圆角 / 水滴 / 亮边 / 斜向高光 全部拆掉，
        //    只留「液态玻璃本体（糊 + 折射）+ 一个自定义颜色」。
        Pg("glass", "液态玻璃", listOf(
            It("✦ 做法：抄窗口像素 → 糊掉 → AGSL 折射 → 叠你要的那一层颜色",
                "参照物：底栏液态玻璃 0.2.1（io.github.liuran001.mmliquidglass）", K.INFO),
            It("开启液态玻璃", "给宿主所有元素套上玻璃（整页根节点除外）",
                K.SW, key = "fuckds_glass_on", def = false, sk = "glass_on"),
            It("玻璃颜色", "玻璃本体就这一层颜色；浓度当它的透明度",
                K.CO, key = "fuckds_glass_color", def = 0xFFFFFFFF.toInt()),
            It("浓度（= 透明度）", "0 = 全透只剩玻璃；100 = 完全不透",
                K.SL, key = "fuckds_glass_tint", def = 45, min = 0, max = 100),
            It("模糊度", "0–40，越大越磨砂", K.SL, key = "fuckds_glass_blur", def = 20, min = 0, max = 40),
            It("色散", "边缘按 RGB 分离采样（×0.1px）—— 这是「液态」最像的那一下",
                K.SL, key = "fuckds_glass_disp", def = 12, min = 0, max = 60),
            It("贴合元素形状", "玻璃按元素真实形状绘制（圆角/胶囊/异形都贴合，而不是统一方块圆角）",
                K.SW, key = "fuckds_glass_fit", def = true),
            It("玻璃形态", "正常 = 满铺玻璃；镂空 = 填充全透（只留元素自己的边框/内容）；" +
                    "仅边缘 = 只在边缘一圈做折射/高光、中间透明（最像 iOS26）",
                K.CH, key = "fuckds_glass_form", def = 0,
                choices = listOf("正常", "镂空", "仅边缘")),
            It("边缘宽度", "「仅边缘」：从元素内边缘往里的化开距离（dp）——小一点更像一条边框",
                K.SL, key = "fuckds_glass_edge", def = 20, min = 0, max = 60),
            It("边缘过渡", "「正常」的颜色柔化程度；「仅边缘」固定完全化开（向里一点点减色）",
                K.SL, key = "fuckds_glass_fade", def = 50, min = 0, max = 100),
            It("作用范围", "所有元素 = 只要画了底就套（含卡片/大条）；仅标准按钮 = 只认 App 按钮",
                K.CH, key = "fuckds_glass_scope", def = 0,
                choices = listOf("所有元素", "仅标准按钮")),
            It("方案", "三套独立实现的折射 shader，切着试（Haze / Cloudy / 轻量扰动）",
                K.CH, key = "fuckds_glass_engine", def = 0,
                choices = listOf("Haze 式", "Cloudy 式", "轻量扰动")),
            It("擦掉内容（只留背景色）", "从元素边缘自动估背景色，把文字/图标从折射底图里擦掉",
                K.SW, key = "fuckds_glass_clean", def = false),
            It("擦除容差", "×0.01；越大擦得越狠（可能连浅色图标一起擦）",
                K.SL, key = "fuckds_glass_clean_tol", def = 12, min = 0, max = 60),
            It("底图来源", "元素底色 = 用元素自己的背景色合成（不透，但后台可用、零延迟、无叠影）；" +
                    "屏幕截图 = 透出背后内容，但后台失效、有延迟、会截到文字；" +
                    "★ 我的背景图 = 用「修改背景」那张图当玻璃内容（清晰、透明、有纹理可见折射）；" +
                    "背景开关关了会自动回退到「元素底色」",
                K.CH, key = "fuckds_glass_src", def = 0,
                choices = listOf("元素底色", "屏幕截图", "我的背景图")),
            It("实现方式", "自动 / 强制 GPU（画质最好）/ 强制 CPU（备用，兼容面更宽）",
                K.CH, key = "fuckds_glass_impl", def = 0,
                choices = listOf("自动", "强制 GPU", "强制 CPU")),
        )),

        /* ───────── 气泡（GmBubbleDialog）───────── */
        Pg("bubble_ai", "AI 气泡美化", listOf(
            It("开启 AI 气泡美化", "给 AI 回复加深色底 + 紫青渐变（默认开启）",
                K.SW, key = "fuckds_bubble_on", def = true, sk = "bubble_on"),
            It("颜色（点选色块）", null, K.CO, key = "fuckds_bubble_color", def = 0),
            It("圆角", "单位 dp", K.SL, key = "fuckds_bubble_radius", def = 0, min = 0, max = 48),
            It("透明度", "0–255", K.SL, key = "fuckds_bubble_alpha", def = 255, min = 0, max = 255),
            It("最大放大", "百分数，100 = 原大小", K.SL, key = "fuckds_bubble_maxz", def = 100, min = 50, max = 200),
            It("图片底", "用自定义图片当气泡底", K.SW, key = "fuckds_bubble_img", def = false),
            It("选择气泡图", null, K.PICK, cmd = "bubble"),
        )),
        Pg("bubble_u", "用户气泡美化", listOf(
            It("开启用户气泡美化", "给自己发出的消息加气泡底（默认开启）",
                K.SW, key = "fuckds_ububble_on", def = true, sk = "ububble_on"),
            It("颜色（点选色块）", null, K.CO, key = "fuckds_ububble_color", def = 0),
            It("圆角", "单位 dp", K.SL, key = "fuckds_ububble_radius", def = 0, min = 0, max = 48),
            It("图片底", null, K.SW, key = "fuckds_ububble_img", def = false),
            It("选择气泡图", null, K.PICK, cmd = "ububble"),
        )),

        /* ───────── 修改背景（GmBgDialog）───────── */
        Pg("bg", "修改背景", listOf(
            It("✦ 蒙层=半透明叠加；混合=底图混进界面；摄像头=实时取景当底图",
                null, K.INFO),
            It("开启背景", null, K.SW, key = "fuckds_bg_on", def = false),
            It("背景来源", null, K.CH, key = "fuckds_bg_mode", def = 0,
                choices = listOf("图片", "渐变", "摄像头")),
            It("选择图片", null, K.PICK, cmd = "bg"),
            It("摄像头方向", null, K.CH, key = "fuckds_bg_cam", def = 0,
                choices = listOf("后置", "前置")),
            It("旋转", "单位：度", K.SL, key = "fuckds_bg_rot", def = 0, min = 0, max = 360),
            It("裁切", "百分数", K.SL, key = "fuckds_bg_crop", def = 0, min = 0, max = 100),
            It("渐变样式", "共 4 种", K.SL, key = "fuckds_bg_grad", def = 0, min = 0, max = 3),
            It("透明度", "百分数", K.SL, key = "fuckds_bg_alpha", def = 25, min = 0, max = 100),
            It("混合方向", null, K.CH, key = "fuckds_bg_pos", def = 0,
                choices = listOf("自动", "浅色底", "深色底")),
        )),

        /* ───────── 环境伪装（GmEnvDialog）───────── */
        Pg("env", "环境伪装", listOf(
            It("隐藏 root / LSPosed / 模块痕迹，绕过风控环境检测", null, K.INFO),
            It("总开关", "接管数美 SDK 的环境检测（默认开启）",
                K.SW, key = "fuckds_gm", def = true),
            It("系统 API 伪装", "隐藏 root 路径 / 包名 / 系统属性（更激进）",
                K.SW, key = "fuckds_gm", def = true, cmd = "env_api"),
            It("设备身份伪装", "伪造 android_id（x-device-id），让服务端视为新设备",
                K.SW, key = "fuckds_device_on", def = false, sk = "device_on"),
            It("换一个新设备身份（重启宿主后生效）", null, K.ACT, cmd = "dev_reset"),
            It("✦ 已覆盖：数美反欺诈 SDK 的 root / Xposed / 模块探测、root 文件路径、"
                    + "Magisk・LSPosed 包名、Build.TAGS 与系统属性", null, K.INFO),
        )),

        /* ───────── 调试（GmDsDialog）───────── */
        Pg("debug", "调试", listOf(
            It("DIAG 诊断 + 服务器最新下发数据", "模块日志&服务器最新下发内容", K.SUB, sub = "dump"),
            It("元素捕获器", "挂一个小悬浮点：拖到目标元素上，单击写日志 / 长按复制",
                K.ACT, cmd = "probe_toggle"),
            // 调试页加一条：把宿主存储整个倒出来（诊断键名用）
            It("探模块的数据源（rows）", "diagnose：原 UI 能抓到值 ⇒ 它走的肯定是模块自己的路，这里把它挖出来",
                K.ACT, cmd = "rows_dump"),
            It("倒出宿主存储（键名+值）", "diagnose：看宿主 MMKV 里真实键名 —— 灰度键叫什么一目了然",
                K.ACT, cmd = "store_dump"),
            It("模块菜单（原 GmMenuDialog）", "灰度选项管理 / 聊天 / 美化 / 回复建议 / 环境伪装 / 日志",
                K.SUB, sub = "menu"),
        )),

        /* ───────── 日志（GmDumpDialog）───────── */
        Pg("dump", "调试 / 日志（DSMlogs）", listOf(
            It("模块日志 + 服务器最新下发数据", "点下面「回读」从宿主取（DIAG + DS DATA）",
                K.ACT, cmd = "dump_text"),
            It("清空日志缓冲", null, K.ACT, cmd = "dump_clear"),
            It("复制到剪贴板", null, K.COPY, cmd = "dump_text"),
        )),

        /* ───────── 回复建议（GmSuggestDialog）───────── */
        Pg("suggest", "回复建议", listOf(
            It("总开关", "输入框上方显示一排可点击的回复建议", K.SW, key = "fuckds_suggest_on", def = false),
            It("AI 生成 (wip)", "自动读取当前对话上下文，向 DS 单独发一次请求生成预回复",
                K.SW, key = "fuckds_suggest_ai", def = false),
            It("显示数量", null, K.SL, key = "fuckds_suggest_count", def = 3, min = 1, max = 10),
            It("模板池（每行一条，点按钮即发送）", null, K.TX, key = "fuckds_suggest_text", def = "", sk = "suggest_text"),
            It("恢复默认模板", null, K.ACT, cmd = "suggest_reset"),
        )),

        /* ───────── 招呼语（GmHelloDialog）───────── */
        Pg("hello", "招呼用语", listOf(
            It("新会话开屏招呼语。清空即删除该条；新增条目会自动加入所有时段。", null, K.INFO),
            It("招呼语", "每行一条", K.TX, key = "fuckds_welcome_msg", def = "", sk = "welcome"),
            It("恢复默认", null, K.ACT, cmd = "hello_reset"),
        )),

        /* ───────── 文件快捷选项（GmPromptDialog）───────── */
        Pg("prompt", "文件快捷选项", listOf(
            It("上传文件后的快捷发送项。场景填 image 或 file；内容为点击后发送的文字，清空即删除该行。",
                null, K.INFO),
            It("内容", "每行一条：场景|内容", K.TX, key = "fuckds_prompt_feature", def = "", sk = "prompt"),
            It("恢复默认", null, K.ACT, cmd = "prompt_reset"),
        )),

        /* ───────── 本地数据库（GmDbDialog）───────── */
        Pg("db", "本地数据库", listOf(
            It("防撤回备份库：共 N 条 / 占用 N KB（宿主回读）", null, K.INFO),
            It("清空", null, K.ACT, cmd = "db_clear"),
        )),
    )

    fun page(id: String): Pg? = pages.firstOrNull { it.id == id }

    /** 颜色调色板（原 UI 是"点选色块"） */
    val palette = listOf(
        0x00000000, 0xFFEF5350.toInt(), 0xFFFFA726.toInt(), 0xFFFFEE58.toInt(),
        0xFF66BB6A.toInt(), 0xFF42A5F5.toInt(), 0xFF7E57C2.toInt(), 0xFFEC407A.toInt(),
    )
}
