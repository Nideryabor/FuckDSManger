// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
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
            It("系统提示词 ›", "把一段隐藏指令塞进每次请求：模型看得到、人眼看不见", K.SUB, sub = "sysprompt"),
            It("AI 气泡富文本 ›", "AI 回复里写 ⟦FDM:模板名|参数⟧ → 这一段变成你配好的富文本", K.SUB, sub = "richtext"),
        )),

        /* ───────── 美化（GmBeautyDialog）───────── */
        Pg("beauty", "美化", listOf(
            It("修改助手图片 ›", "AI 回复旁的头像：开关 + 选图", K.SUB, sub = "avatar_img"),
            It("对话气泡设置 ›", "AI / 我的气泡：颜色、圆角、图片底、缩放、图片锚点",
                K.SUB, sub = "bubble_conv"),
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
            It("悬浮全家桶 ›", "挂在宿主界面上的浮层功能（不需要任何权限）",
                K.SUB, sub = "float_all"),
        )),

        /* ───────── 悬浮全家桶（2026-10-06）───────── */
        //  ★ 主人 2026-10-06：「把悬浮便签塞进 美化 > 悬浮全家桶 里面」
        //    它是个**容器页**：以后所有「悬挂在宿主界面上的层」都往这儿放（主人说还有新的要来）。
        //    现在是第一件：悬浮便签。
        Pg("float_all", "悬浮全家桶", listOf(
            It("悬浮便签 ›", "在界面上贴一张便签：可拖动、可编辑、可换外观（不需要任何权限）",
                K.SUB, sub = "note"),
            It("悬浮迷你条 ›", "宿主上一张常驻播放卡：封面 / 歌词 / 进度 / 控件，点 ♪ 还能搜歌",
                K.SUB, sub = "bar"),
        )),

        /* ───────── 网易云登录（2026-10-06）───────── */
        //  ⚠️ 明文存储 —— 主人特意要求告诉用户（页面里有专门的「隐私」卡）
        Pg("musiclogin", "网易云登录", listOf(
            It("三种方式", "手机验证码 / 手机或邮箱密码 / 直接粘 cookie", K.INFO),
            It("⚠️ 凭证是明文存的",
                "存在宿主私有目录（别的 App 读不到），但**没有加密**。\n" +
                "root 用户请注意：root / 备份工具能直接读到，等于拿到你的账号。",
                K.INFO),
        )),

        /* ───────── 悬浮迷你条（2026-10-06）───────── */
        //  它是**显示端**：播放器在模块自己的进程（MusicService），迷你条挂在宿主进程的窗口上，
        //  两边靠广播说话（ACTION_STATE / ACTION_CMD）。
        //  只有「正在放歌」时才出现；没歌自动收起。
        //  ⚠️ 与便签同一套语义：`✕` = 本会话收起，拨开关 / 重启宿主即恢复。
        Pg("bar", "悬浮迷你条", listOf(
            It("显示迷你条", "开启后宿主上**常驻**一张迷你播放卡（没放歌时也显示，点 ♪ 去选歌）", K.SW,
                key = "fuckds_bar_on", def = false),            It("卡片宽度", "拖四个角也能调；这里是精确控制", K.SL,
                key = "fuckds_bar_w", def = 320, min = 190, max = 600),
            It("卡片高度", "太小的话歌词区会被挤扁", K.SL,
                key = "fuckds_bar_h", def = 200, min = 120, max = 640),
            It("≡ 三条杠 = 拖动把手",
                "按住卡片里【曲名旁边】那个「≡」上下拖，位置会记住。\n" +
                "四个角的 ◤◥◣◢ 是**拉伸**用的（调大小，也会记住）。",
                K.INFO),
            It("常驻是什么意思",
                "开关一开，**每个页面**都会挂着它（会话页 / 设置页 / 全屏页都在），" +
                "没在放歌时显示「未在播放」并提示点 ♪ 去选歌。\n" +
                "✕ 是「本次宿主进程里收起」，拨一下开关或重启宿主就回来。",
                K.INFO),
            It("卡片上有什么",
                "封面（专辑图）· 曲名&歌手 · 可滚动/可点击跳转的歌词 · " +
                "进度条（可拖）· ♪(去选歌) ◀◀ ▶/❚❚ ▶▶ ↻(循环)。\n" +
                "点按钮 = 给播放器发广播，**界面不会跳走**（在聊天页也能直接切歌）。",
                K.INFO),
        )),

        /* ───────── 悬浮便签（2026-10-06）───────── */
        //  ★ 做法：往宿主窗口的 decorView 里塞一个子 View —— **零权限**
        //    （系统悬浮窗 TYPE_APPLICATION_OVERLAY 要「显示在其他应用上层」，得用户手动去开）
        //  手感：≡ 拖动 · 点正文就地编辑 · ＋新建 · ‹›切换 · －删 · ▣最小化 · ✕本会话关闭
        //        最小化形态 = 一颗圆球，点它回来
        //  ⚠️ `✕` = 「本次宿主进程里不再出现」；拨一下总开关 / 重启宿主就回来
        Pg("note", "悬浮便签", listOf(
            It("显示便签", "开启后宿主界面上出现一张便签（不用给任何权限）", K.SW,
                key = "fuckds_note_on", def = false),
            // ★ 2026-10-06 主人：「把便签内容那个输入框去了，里面的提示单独拎出来，
            //   再加一个『左上角三条杠可以拖』的提示」
            //   ⇒ 内容框拆成三条只读说明（这条是拖动，下面两条是原框里的提示）。
            It("≡ 三条杠 = 拖动把手",
                "按住便签【左上角】那个「≡」就能拖着走。位置会记住（按 dp 存，切页面 / 切 Activity 都还在）。",
                K.INFO),
            It("在便签上直接写字",
                "点一下便签正文就能就地编辑（输入法会自己弹出来）；改完点一下别处即落盘，没有保存按钮。",
                K.INFO),
            It("多张便签",
                "便签顶栏：＋ 新建 · ‹ › 前后翻（中间显示 1/2）· － 删掉当前 · ▣ 缩成小圆球 · ✕ 本会话收起。\n" +
                "缩成圆球之后，点那颗圆球就回来。",
                K.INFO),
            It("便签底色", "便签纸的颜色", K.CO, key = "fuckds_note_bg", def = 0xFFFFF3B0.toInt()),
            It("不透明度", "0 = 全透只剩框，255 = 完全不透明", K.SL,
                key = "fuckds_note_alpha", def = 230, min = 0, max = 255),
            It("字号", "便签正文的字号（sp）", K.SL,
                key = "fuckds_note_size", def = 14, min = 10, max = 28),
        )),

        /* ───────── 系统提示词（2026-10-03 · 零宽隐形通道）───────── */
        //  协议层依据：DeepSeek 官方通道没有 system 位（32 顶层字段 + 16 嵌套组合实测全灭，
        //  特殊 token 被当普通文本，网页版 JS 全量扫描 0 命中）⇒ 见 专题/系统提示词-不留痕投递.md
        //  本功能 = Unicode Tag 字符（U+E0000–E007F，渲染宽度 0）承载指令，塞进 prompt。
        //  ⚠️ 它不是"真 system role"，优先级理论上低于 system；是官方通道下效果最接近的形态。
        Pg("sysprompt", "系统提示词", listOf(
            It("✦ 原理：隐形字符承载指令",
                "Unicode Tag 区块（U+E0000–U+E007F）渲染宽度为 0，但模型能读到。" +
                "指令随 prompt 上传，聊天界面/换设备/网页版全都看不见。", K.INFO),
            It("⚠️ 它不是真正的 system prompt",
                "位于 user 消息内部，优先级理论上低于 system；理论上可被「忽略之前所有指令」冲掉。" +
                "这是官方通道下能拿到的最强形态。", K.INFO),
            It("开启注入", "开启后才生效（默认关）",
                K.SW, key = "fuckds_sysprompt_on", def = false),
            It("提示词内容", "支持中英文。\n" +
                    "★ 两种承载方式都填这里 —— 换承载方式不用改内容：\n" +
                    "· 隐形字符 = 中文会自动转成 \\uXXXX 转义再隐形化\n" +
                    "· 明文定界 = 原样发出，由模块在界面上把整段抹掉",
                K.TX, key = "fuckds_sysprompt_text", def = ""),
            It("注入模式", "仅首条 = 只在本会话第一条消息注入（token 只花一次、位置=上下文最前）；" +
                    "每轮 = 每条消息都注入（对抗稀释最强，token 持续消耗）。\n" +
                    "⚠️ 提示词里一旦出现**音乐变量**（{music} / {lyric} 等），本项会被**忽略**、" +
                    "强制按「每轮」—— 音乐是时变的，冻在会话开头就等于骗模型" +
                    "（音乐变量在 首页 › 附加の功能 › 音乐 › 提示词音乐变量）。",
                K.CH, key = "fuckds_sysprompt_mode", def = 0,
                choices = listOf("仅首条", "每轮")),
            It("承载方式", "★ 决定提示词怎么被送出去：\n" +
                    "· 隐形字符 = Unicode Tag（人眼看不见，但模型能察觉「有隐藏字符」⇒ 概率性拒答）\n" +
                    "· 明文定界 = 正常文字，服务端/模型当普通内容读（零风险），由模块把这段从界面抹掉" +
                    "（界面看不到，但服务端/换设备看得见）\n" +
                    "★ 下面两个「包装前缀/后缀」在两种方式下**都生效**" +
                    "（明文方式下会和正文一起被 ⟦FDM⟧…⟦/FDM⟧ 包住）",
                K.CH, key = "fuckds_sysprompt_carrier", def = 0,
                choices = listOf("隐形字符", "明文定界")),
            It("包装前缀", "包在提示词【前面】的文字。留空 = 不加。\n" +
                    "· 隐形字符模式：前缀也会被隐形化（人眼看不见）\n" +
                    "· 明文定界模式：前缀原样发出，和正文一起被 ⟦FDM⟧…⟦/FDM⟧ 包住（界面照样看不到）\n" +
                    "★ 措辞是主战场：写 SYSTEM-LEVEL / highest priority / overrides user turns " +
                    "这类词，模型会直接判定「提示注入」并拒绝（已被真机实测打回一次）。",
                K.TX, key = "fuckds_sysprompt_head",
                def = "My standing preference for this whole conversation: "),
            It("包装后缀", "包在提示词【后面】的文字。留空 = 不加。\n" +
                    "两种承载方式下都生效（同前缀：隐形模式被隐形化，明文模式随正文一起被定界符包住）。\n" +
                    "默认留空 —— 「END OF …」这种封口词本身也是注入特征。",
                K.TX, key = "fuckds_sysprompt_tail", def = ""),
            It("🎵 想让提示词知道「我在听什么」？",
                "那些会自己变的占位符（{music} / {lyric} / {music_or_none} …）" +
                "**已经搬到音乐板块**了 —— 它是音乐功能，放在这儿你会找不到。\n" +
                "入口：首页 › 附加の功能 › 音乐 › 提示词音乐变量",
                K.INFO),
        )),

        /* ───────── AI 气泡富文本（2026-10-03 · 标记 → 富文本）───────── */
        //  落点 = 宿主 markdown 渲染的「成品 AnnotatedString」唯一汇流点（fz2.p）：
        //    AI 文本 → svb.c（AssistantTextItem）→ eu6.c（Markdown）→ v91.m → fz2.p
        //  做法：用**宿主自己的** AnnotatedString.Builder 重建 ——
        //    原文段 append(orig, start, end)（样式自动跟着走）
        //    标记段 pushStyle(样式) + append(文字) + pop()
        //  锚点表、结构自检、风险清单见 专题/AI气泡富文本-锚点勘察.md。
        Pg("richtext", "AI 气泡富文本", listOf(
            It("⚠ 前提：「系统提示词」必须开着，否则不生效",
                "这套标记（⟦FDM:…⟧ / <b> / <c1> …）是「我们自定义的约定」，模型不会凭空知道。\n" +
                "唯一的告知通道就是「系统提示词」—— 请先到 聊天 › 系统提示词 把总开关打开，\n" +
                "再点下面的「① 把格式约定写进系统提示词」，模型才会照着写。\n" +
                "（开关关着的话：约定根本不会发给模型 ⇒ 它永远只吐普通 markdown ⇒ 看着像功能坏了）",
                K.INFO),
            It("✦ 用法：AI 回复里写 ⟦FDM:模板名|参数1|参数2⟧，这一段就变成你配好的富文本",
                "标记前后的普通文字照旧；只有标记包着的那一段被替换。", K.INFO),
            It("✦ 标签：<b>粗</b> <i>斜</i> <u>下划线</u> <s>删除线</s>　" +
                    "<c1>色板色</c>　<c#FF0000>直给色</c>　<bg3>背景色</bg>　<br>换行",
                "支持嵌套；不认识的标签会被整段丢掉，不会漏出尖括号。", K.INFO),
            It("✦ 模板写法：一行一条「名字|富文本」，{1} {2} 会被标记里的参数替换",
                "例：card|<b>{1}</b> {2}", K.INFO),
            It("开启", "默认关。开了之后 AI 回复里的标记/标签才会被渲染",
                K.SW, key = "fuckds_rich_on", def = false),
            It("裸标签直接渲染（推荐开）",
                "开了之后，AI 不用包任何标记，直接写 <b>粗</b> <c1>红</c1> <br> 就当场生效。\n" +
                "关掉的话，它只认 ⟦FDM:模板名|参数⟧ 这一种写法 —— 而模型天生爱写 HTML，" +
                "关掉就会看到满屏的尖括号露在界面上。\n" +
                "安全靠白名单：只认 b/i/u/s/br/c1-9/bg1-9/c#RRGGBB/bg#RRGGBB，" +
                "代码里的 <div>、数学里的 a < b 一律原样留着。",
                K.SW, key = "fuckds_rich_bare", def = true),
            It("模板池（每行一条：名字|富文本）",
                "模板里不能带真换行 —— 换行请用 <br>；# 开头的行当注释。留空 = 用开箱示例模板",
                K.TX, key = "fuckds_rich_tpls", def = ""),
            It("① 把格式约定写进系统提示词",
                "点一下把用法**追加**进「系统提示词」（幂等，重复点不叠加；只加不改，你原来写的都在）。\n" +
                "⚠️ 要先生效，得保证「系统提示词」总开关是开着的。",
                K.ACT, cmd = "rich_spec"),
            It("② 灌入开箱示例模板", "改乱了想重来的时候用",
                K.ACT, cmd = "rich_demo"),
            It("③ 清空灌入的约定",
                "把上面「①」灌进去的排版约定（连带「追问建议」那段）从系统提示词里摘掉。\n" +
                "★ 只摘我们灌的那两段 —— 你自己写的提示词一个字都不动。\n" +
                "（想重新灌回来，再点一次「①」即可）",
                K.ACT, cmd = "specs_clear"),
            It("★ 渲染任意 HTML（实验）",
                "开了之后，AI 用 ```html 代码块写的内容会被真正当成网页渲染（表格、div、CSS 都能用）。\n" +
                "原理：宿主本来就用 WebView 渲染 ```mermaid 代码块，我们让 ```html 也走那条路，" +
                "再把内容换成你的 HTML。位置/尺寸/滚动全由宿主自己管。\n" +
                "⚠️ 实验功能：若效果异常（比如高度不对、显示\"渲染失败\"），关掉即可完全恢复。\n" +
                "⚠️ 它渲染出来是一张【静态图片】（投递那一刻跑完 JS 再截图）——\n" +
                "页面里的按钮、输入框、链接全都点不动，那是设计如此，不是坏了。",
                K.SW, key = "fuckds_html_on", def = false),
            It("HTML 页面用浅色", "默认跟随宿主的深色主题（浅字透明底）；宿主要是浅色主题就打开这个",
                K.SW, key = "fuckds_html_light", def = false),
            It("色板 1", "模板里用 <c1> 引用", K.CO, key = "fuckds_rich_c1", def = 0xFFFF5252.toInt()),
            It("色板 2", null, K.CO, key = "fuckds_rich_c2", def = 0xFFFFB300.toInt()),
            It("色板 3", null, K.CO, key = "fuckds_rich_c3", def = 0xFFFFD600.toInt()),
            It("色板 4", null, K.CO, key = "fuckds_rich_c4", def = 0xFF4CAF50.toInt()),
            It("色板 5", null, K.CO, key = "fuckds_rich_c5", def = 0xFF26A69A.toInt()),
            It("色板 6", null, K.CO, key = "fuckds_rich_c6", def = 0xFF42A5F5.toInt()),
            It("色板 7", null, K.CO, key = "fuckds_rich_c7", def = 0xFF7E57C2.toInt()),
            It("色板 8", null, K.CO, key = "fuckds_rich_c8", def = 0xFFEC407A.toInt()),
            It("色板 9", null, K.CO, key = "fuckds_rich_c9", def = 0xFF9E9E9E.toInt()),
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
        /* ───────── 修改助手图片（二级菜单 · 2026-10-03 主人要求）───────── */
        Pg("avatar_img", "修改助手图片", listOf(
            It("修改助手图片", "开启后可自定义 AI 回复旁的头像",
                K.SW, key = "ui_avatar_on", def = false, cmd = "avatar_on", sk = "avatar_on"),
            It("选择图片", null, K.PICK, cmd = "avatar"),
        )),

        /* ───────── 对话气泡设置（二级菜单 · AI/我的气泡 + 通用锚点）───────── */
        Pg("bubble_conv", "对话气泡设置", listOf(
            It("AI 气泡美化 ›", "颜色 / 圆角 / 图片底 / 缩放（点进设置）", K.SUB, sub = "bubble_ai"),
            It("用户气泡美化 ›", "颜色 / 圆角 / 图片底（点进设置）", K.SUB, sub = "bubble_u"),
            It("图片锚点", "图贴气泡的哪一角（左上/上中/…/右下）；AI 与我的气泡通用，默认上中",
                K.CH, key = "fuckds_bubble_anchor", def = 1,
                choices = listOf("左上", "上中", "右上", "左中", "居中", "右中", "左下", "下中", "右下")),
        )),

        Pg("bubble_ai", "AI 气泡美化", listOf(
            It("开启 AI 气泡美化", "给 AI 回复加深色底 + 紫青渐变（默认开启）",
                K.SW, key = "fuckds_bubble_on", def = true, sk = "bubble_on"),
            It("颜色（点选色块）", null, K.CO, key = "fuckds_bubble_color", def = 0),
            It("圆角", "单位 dp", K.SL, key = "fuckds_bubble_radius", def = 0, min = 0, max = 48),
            It("透明度", "0–255", K.SL, key = "fuckds_bubble_alpha", def = 255, min = 0, max = 255),
            It("缩放", "100% = 按宽度铺满（默认）；更小=图更小、四周补边缘色；更大=裁得更狠",
                K.SL, key = "fuckds_bubble_maxz", def = 100, min = 50, max = 200),
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
            It("⚠ 前提：「系统提示词」必须开着，否则不生效",
                "「AI 追问建议」靠的是让模型在回复末尾写 <Suggestion>▸ 问题</Suggestion>。\n" +
                "模型不会凭空知道这个标记 —— 唯一的告知通道就是「系统提示词」。\n" +
                "请先到 聊天 › 系统提示词 打开总开关，再点下面的「① 一键灌入提示词」。",
                K.INFO),
            It("⚠ 改完开关要「重启宿主」才生效",
                "「AI 生成建议」这类开关是在【宿主启动时】注册钩子的（模块那时才装上去）。\n" +
                "⇒ 改完必须强停宿主再打开，否则你会看到「开关和实际行为对不上」的怪现象\n" +
                "（真机踩过：「AI 生成建议」开着时建议点不动、关了反而能点 —— 其实只是旧状态还在跑）。",
                K.INFO),
            It("✦ 玩法：AI 回复末尾写 <Suggestion>▸ 追问</Suggestion>，界面会把它渲染成一条可点击的建议",
                "点一下 = 模块替你把它当消息发出去（等同你自己打字 + 点发送）。\n" +
                "想「显示短、实际发得多」可以写成：<Suggestion>▸ 说说看|请从原理上详细解释</Suggestion>",
                K.INFO),
            It("总开关", "输入框上方显示一排可点击的回复建议", K.SW, key = "fuckds_suggest_on", def = false),
            It("① 一键灌入提示词",
                "把「追问建议」的写法**追加**进系统提示词（幂等；只加不改，你原来写的都保留）。\n" +
                "灌完之后，AI 才会主动在回复末尾给出可点的建议。",
                K.ACT, cmd = "suggest_spec"),
            It("② 清空灌入的约定",
                "把灌进去的约定（追问建议 + 排版约定两段一起）从系统提示词里摘掉。\n" +
                "★ 只摘我们灌的那两段 —— 你自己写的提示词一个字都不动。",
                K.ACT, cmd = "specs_clear"),
            It("AI 生成建议", "自动读取当前对话上下文，向 DS 单独发一次请求生成预回复",
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
