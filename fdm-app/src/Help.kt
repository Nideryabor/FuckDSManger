// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Info
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp

/**
 * 「功能原理 & 帮助」🐲（2026-10-10 · 3.66.0）
 *
 * <p>主人：「这些可以改掉了，先改文本，然后把改好的文本迁移到一个 compose 子框里面，
 * 通过对应页面末尾加一个「功能原理&帮助」来打开这个子框」。
 *
 * <p>之前那几段说明是**散在各页里的 INFO 卡**，而且写着"调试 › 系统提示词 v2"、
 * "① 把格式约定写进系统提示词"这类**已经过时**的话（现在的做法是"把卡片拖进容器"）。
 * ⇒ 统一改写成下面三份文本（**按现在的实际做法写的**），收进一个弹窗；页面里只留一个入口。
 *
 * <p>⚠️ 弹窗里的文字是**纯文本**（不做 Markdown 渲染）⇒ 不要写 `**加粗**` 那种标记，
 * 引用统一用「」。
 */
object HelpText {

    /** 「拖卡片 / 保存 / 排查」这三段是三个功能共用的，抽出来免得写三份。 */
    private const val DRAG_RULES = """
【拖卡片的规矩】
· 拖进容器 = 灌入这一段（这一段就进了系统提示词）
· 拖回抽屉 = 只摘掉这一段（别的段、你自己写的内容一个字都不动）
· 卡片在容器里的上下顺序 = 提示词里段落的顺序（段与段之间自动空一行）
· 容器是空的 ⇒ 提示词就是空的（提示词内容完全由容器里的卡片决定）
· 想放你自己的话：把「系统提示词内容」那张模板卡拖进容器（每拖一次复制一张），
  点卡片展开就能改标题与正文；「标题也进提示词」开关默认关。
"""

    private const val SAVE_RULES = """
【保存 / 看结果】
· 改完点右上角 💾（或卡片里的「提交到提示词」）
  ⇒ 会弹出「拼合后的系统提示词」—— 那就是真正发出去的内容，可以逐字校对
· 改一行、拖一下都会即时生效，💾 只是"再存一次 + 给我看一眼"
· ⚠️ 提示词是**宿主（DeepSeek）里的模块**负责写进去的
  ⇒ 保存前请先打开 DeepSeek；宿主没在跑时会提示「宿主没回话」，那不是界面坏了
"""

    private const val ENTRY_TIP = """
【入口在哪】
聊天 › 系统提示词（右上角 ⋮ 里有「开启注入」等开关）
"""

    val suggest = """
【这个功能是干什么的】
让 AI 在回复末尾写一行：
    <Suggestion>▸ 你的建议问题</Suggestion>
界面会把它渲染成一条「可点的建议」—— 点一下 = 替你把它当消息发出去。

【怎么让它生效（3 步）】
① 打开总开关：聊天 › 系统提示词 › 右上角 ⋮ › 开启注入
② 在那个页面里，把「回复建议」这张卡片拖进上面的容器
   —— 这一步 = 把 <Suggestion> 的写法灌进提示词
③ 回会话里问一句，AI 才会在末尾给出可点的建议

【这个页面上的其它开关】
· 「总开关」= 界面要不要显示那排建议（关了就什么都不显示）
· 「AI 生成建议」= 让模块自己读上下文，多问一次 DeepSeek 生成预回复
· 「显示数量 / 模板池」= 固定文本的候选建议（模型没给 <Suggestion> 时兜底用）
· ⚠️ 这类开关是**宿主启动时注册钩子**的 ⇒ 改完把 DeepSeek 重启一次才稳妥
""" + DRAG_RULES + SAVE_RULES + ENTRY_TIP + """
【不生效时按顺序查】
1) ⋮ 里的「开启注入」开了吗
2) 「回复建议」卡片在**容器**里吗（还在抽屉里 = 这一段没进提示词）
3) 本页那个「总开关」开了吗
4) 刚刚改过开关的话 —— 重启一次 DeepSeek
"""

    val richtext = """
【这个功能是干什么的】
AI 回复里写      ⟦FDM:模板名|参数1|参数2⟧
→ 这一段会被替换成你在「模板池」里配好的富文本。

也可以直接写标签（推荐开「裸标签直接渲染」）：
· <b>粗</b>  <i>斜</i>  <u>下划线</u>  <s>删除线</s>
· <c1>…</c9>   九种颜色；<c#FF0000>…</c> 直接给六位十六进制
· <bg1>…</bg9> 九种高亮；<bg#FFFF00>…</bg> 同理
· <br> 换行（模板里不能写真换行，就用它）
· 支持嵌套；不认识的标签会被整段丢掉，不会漏出尖括号

【怎么让它生效（3 步）】
① 打开总开关：聊天 › 系统提示词 › 右上角 ⋮ › 开启注入
② 在那个页面里把「富文本」这张卡片拖进上面的容器
   —— 这一步 = 把标签与模板的用法灌进提示词（模型不会凭空知道我们自定义了这套写法）
③ 回会话里让 AI 写一段带标签的内容，就会被渲染成真样式

【这个页面上的其它开关】
· 「开启」= 渲染本身的总闸（关掉 = 什么都不渲染）
· 「裸标签直接渲染」= 开着：直接写 <b> 就生效；关掉：只认 ⟦FDM:…⟧ 那种写法
  （模型天生爱写 HTML，关掉它你会看到满屏尖括号）
· 「渲染任意 HTML（实验）」= AI 用 ```html 代码块写的内容真的当网页渲染
  ⚠️ 它是在"投递那一刻跑完 JS 再截图"⇒ 渲染出来是一张**静态图**：页面里的按钮、输入框、链接都点不动，这是设计如此
""" + DRAG_RULES + SAVE_RULES + ENTRY_TIP + """
【不生效时按顺序查】
1) ⋮ 里的「开启注入」开了吗
2) 「富文本」卡片在**容器**里吗
3) 本页「开启」开了吗
4) 模板名拼对了吗（模板池里每行一条：名字|富文本）
"""

    val music = """
【这个功能是干什么的】
在系统提示词里写占位符，模块会在**发消息那一刻**把它们替换成真值
（所以歌词行、进度天然是实时的，不用轮询）：

· {music}            《歌名》 - 歌手 (1:23/3:42)
· {music_or_none}   同上，但"没在听"时明确写「没有在听歌」
· {song}  {artist}  {album}
· {music_pos}  {music_dur}  {music_left}   已听 / 总长 / 剩余
· {music_state}     playing / paused
· {lyric}  {lyric_prev}  {lyric_next}      当前这一句 / 上一句 / 下一句

【怎么让它生效（3 步）】
① 本页把「音乐变量」开关打开（关着时所有变量一律替换成空串）
② 打开总开关：聊天 › 系统提示词 › 右上角 ⋮ › 开启注入
③ 把「音乐」这张卡片拖进那里的容器 —— 这一步 = 把上面那两行示例写进提示词

【「空」有三种原因（别误判）】
① 总开关关着　② 真没在放歌　③ 歌词开关关着 / 歌词还没缓存到
三种在模型眼里长得一样，所以本页不替它做任何「空 = 没在听」的断言：
· 想「没在听就整句别出现」⇒ 用 [[ ]] 把整行包起来（变量全空时整行连括号一起删）
· 想「让模型知道我没在听」⇒ 用 {music_or_none}

【歌词的版权提醒】
{lyric} 系列默认关。打开之后歌词会**随提示词上传、并留在对话历史里** ——
这和"只显示在屏幕上给自己看"是完全两件事，请自己权衡。

【这个页面上的其它开关】
· 「悬浮迷你条」= 宿主界面上那张常驻播放卡（点它右边的「悬浮条设置」调尺寸/把手）
· 「音源伪装」= 换身份去取播放地址（VIP 曲目只有 30~45 秒试听，那不是 bug）
""" + DRAG_RULES + SAVE_RULES + ENTRY_TIP + """
【不生效时按顺序查】
1) 本页「音乐变量」开了吗
2) ⋮ 里的「开启注入」开了吗
3) 提示词里确实写了 {music} 这类花括号吗（只认 {名字} 这一种形态）
4) 用了 {lyric} 的话，本页「允许歌词变量」也开了吗
"""
}

/**
 * 帮助子框（弹窗）。`topic` 用 `"suggest"` / `"richtext"` / `"music"`。
 *
 * <p>正文可滚动（这几段挺长），右上角一个「好」关掉。
 */
@Composable
fun HelpDialog(topic: String, onClose: () -> Unit) {
    val (title, body) = when (topic) {
        "suggest" -> "回复建议 · 功能原理 & 帮助" to HelpText.suggest
        "richtext" -> "AI 气泡富文本 · 功能原理 & 帮助" to HelpText.richtext
        "music" -> "音乐 · 功能原理 & 帮助" to HelpText.music
        else -> "功能原理 & 帮助" to HelpText.suggest
    }
    AlertDialog(
        onDismissRequest = onClose,
        confirmButton = { TextButton(onClick = onClose) { Text("好") } },
        title = { Text(title) },
        text = {
            Column(
                Modifier
                    .fillMaxWidth()
                    .heightIn(max = 420.dp)
                    .verticalScroll(rememberScrollState()),
            ) {
                Text(
                    body.trim(),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurface,
                )
            }
        },
    )
}

/** 页面末尾那个入口（整条可点）。 */
@Composable
fun HelpEntry(label: String = "功能原理 & 帮助", onOpen: () -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(24.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .clickable { onOpen() }
            .padding(horizontal = Edge, vertical = 14.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(
            Icons.Rounded.Info, null,
            modifier = Modifier.size(20.dp),
            tint = MaterialTheme.colorScheme.primary,
        )
        Spacer(Modifier.width(10.dp))
        Column(Modifier.weight(1f)) {
            Text(
                label,
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface,
            )
            Text(
                "这个功能是怎么工作的、怎么让它生效、不生效怎么查",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        Spacer(Modifier.width(8.dp))
        Text(
            "打开",
            style = MaterialTheme.typography.labelMedium,
            color = MaterialTheme.colorScheme.primary,
        )
    }
}

/** 页内小标题（跟 Pages.kt 的 SectionLabel 一个观感，但这里不依赖那边的私有实现）。 */
@Composable
fun HelpSection(label: String) {
    Text(
        label,
        style = MaterialTheme.typography.labelMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(start = Edge, top = 8.dp, bottom = 4.dp),
    )
}

/** 空的占位（给"这段说明搬去帮助框了"留一行小字用）。 */
@Composable
fun HelpMovedNote(to: String) {
    Text(
        "（详细说明已搬到页面末尾的「功能原理 & 帮助」" + to + "）",
        style = MaterialTheme.typography.labelSmall,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(start = Edge, top = 2.dp),
    )
    Spacer(Modifier.height(2.dp))
}
