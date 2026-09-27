package com.nidyaber.fuckdsmanger

import androidx.compose.foundation.LocalIndication
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ChevronRight
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.platform.LocalContext
import android.content.Context
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp

/**
 * 设置项的行控件 🐲 —— 只用现有设计语言（28dp 圆角 / surfaceContainerLow / Edge 边距）。
 *
 * 每种配置键对应一种行：开关 / 滑块 / 枚举 / 颜色 / 文本 / 只读。
 * 每行都显示 **宿主真值**（有的话），因为界面要回答的是"宿主现在是什么"，
 * 不是"我们请求过什么"。
 */

@Composable
private fun RowShell(content: @Composable ColumnScope.() -> Unit) {
    Column(
        Modifier.fillMaxWidth()
            .clip(RoundedCornerShape(28.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .padding(horizontal = Edge, vertical = 12.dp),
        content = content,
    )
}

@Composable
private fun LabelLine(label: String, hostText: String?) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Text(
            label,
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.weight(1f),
        )
        if (hostText != null) {
            Text(
                hostText,
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                maxLines = 1, overflow = TextOverflow.Ellipsis,
            )
        }
    }
}

@Composable
private fun HintLine(hint: String?) {
    if (hint != null) {
        Text(
            hint,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

/**
 * 开关行 🐲 —— 按主人的设计做（"三次握手"）：
 *   ① 点一下**立刻**反映在界面上（不让用户等）
 *   ② 把新状态推给宿主
 *   ③ 宿主**回读真值**并结构化回执（`cfg.<key>`）⇒ **只同步这一个按钮**
 *      · 如果宿主没回（失败），本地先保持乐观值，页面上「最近一次动作」会显示原因
 */
@Composable
fun SettingSwitch(
    label: String, initial: Boolean, key: String?, hostText: String?, hint: String?,
    onSend: (Boolean) -> Unit,
) {
    val ctx = LocalContext.current
    val sp = ctx.getSharedPreferences("fdm_ui", Context.MODE_PRIVATE)
    val confirmed = key?.let { sp.getString("cfg.$it", null) }
    var checked by remember(key) { mutableStateOf(initial) }
    // ★ 宿主回执到了 ⇒ 采纳它（这就是"只重绘这一个按钮"）
    LaunchedEffect(key, confirmed) {
        if (confirmed != null) checked = confirmed.equals("true", true) || confirmed == "1"
    }
    RowShell {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                LabelLine(label, null)
                HintLine(hint)
            }
            Switch(
                checked = checked,
                onCheckedChange = { v ->
                    checked = v          // ① 立刻反映
                    onSend(v)            // ② 推给宿主（回执来了会走上面的 remember 同步）
                },
            )
        }
        if (hostText != null) {
            Text(
                "宿主： " + hostText,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.tertiary,
            )
        }
    }
}

/** 整数滑块行 */
@Composable
fun SettingSlider(
    label: String, value: Int, min: Int, max: Int,
    hostText: String?, hint: String?, onChange: (Int) -> Unit,
) {
    RowShell {
        LabelLine(label, "本机设: $value")
        if (max > min) {
            Slider(
                value = value.toFloat(),
                onValueChange = { onChange(it.toInt()) },
                valueRange = min.toFloat()..max.toFloat(),
            )
        }
        HintLine(hint)
        if (hostText != null) {
            Text(
                "宿主： " + hostText,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.tertiary,
            )
        }
    }
}

/** 枚举行（一排 chip） */
@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
fun SettingChoice(
    label: String, value: Int, choices: List<String>,
    hostText: String?, hint: String?, onChange: (Int) -> Unit,
) {
    RowShell {
        LabelLine(label, null)
        FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            choices.forEachIndexed { i, name ->
                FilterChip(
                    selected = i == value,
                    onClick = { onChange(i) },
                    label = { Text(name, style = MaterialTheme.typography.labelMedium) },
                )
            }
        }
        HintLine(hint)
        if (hostText != null) {
            Text(
                "宿主： " + hostText,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.tertiary,
            )
        }
    }
}

/** 颜色行 */
@Composable
fun SettingColor(
    label: String, value: Int, hostText: String?, hint: String?,
    onChange: (Int) -> Unit,
) {
    RowShell {
        LabelLine(label, null)
        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            Conf.palette.forEach { c ->
                val selected = c == value
                Box(
                    Modifier.size(if (selected) 36.dp else 30.dp)
                        .clip(CircleShape)
                        .background(Color(c))
                        .border(
                            width = if (selected) 3.dp else 1.dp,
                            color = if (selected) MaterialTheme.colorScheme.primary
                            else MaterialTheme.colorScheme.outlineVariant,
                            shape = CircleShape,
                        )
                        .clickable { onChange(c) },
                )
            }
        }
        HintLine(hint)
        if (hostText != null) {
            Text(
                "宿主： " + hostText,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.tertiary,
            )
        }
    }
}

/**
 * 文本行 🐲 —— 按主人的设计做：
 *   · **获得焦点后就不跟随宿主**（不然每敲一个字都被宿主的值盖回去 ⇒ 打不进字 ✗）
 *   · **失焦时**才把框里的内容发给宿主
 *   · 宿主回执（`cfg.<key>`）到了才同步
 */
@Composable
fun SettingText(
    label: String, initial: String, key: String?, hostText: String?, hint: String?,
    onSend: (String) -> Unit,
) {
    val ctx = LocalContext.current
    val sp = ctx.getSharedPreferences("fdm_ui", Context.MODE_PRIVATE)
    val cfgAt = key?.let { sp.getLong("cfg.$it.at", 0L) } ?: 0L
    var tv by remember(key) { mutableStateOf(initial) }
    var focused by remember(key) { mutableStateOf(false) }
    var touched by remember(key) { mutableStateOf(false) }   // 用户动过没有

    // ★ 宿主真值(=initial)可能**晚到**（state_all 是异步的）——只要用户还没动过，就填进去
    LaunchedEffect(initial) { if (!touched && !focused && initial.isNotEmpty()) tv = initial }
    // 回执到了：同样只在"没动过 + 不在编辑"时才采纳
    LaunchedEffect(key, cfgAt) {
        if (!touched && !focused && cfgAt > 0L) tv = sp.getString("cfg.$key", "") ?: ""
    }
    // 离开页面也提交一次（防"还没失焦就退出去了"）
    val latest by rememberUpdatedState(tv)
    DisposableEffect(Unit) { onDispose { if (touched) onSend(latest) } }
    RowShell {
        LabelLine(label, if (focused) "编辑中…（离开即保存）" else null)
        OutlinedTextField(
            value = tv,
            onValueChange = { tv = it; touched = true },   // ★ 只改本地；标记"用户动过"
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 6.dp)
                .onFocusChanged { st ->
                    val was = focused
                    focused = st.isFocused
                    if (was && !st.isFocused) onSend(tv)   // ★ 失焦才提交
                },
            singleLine = false,
            minLines = 2,
            maxLines = 6,
            placeholder = { Text(hint ?: "", style = MaterialTheme.typography.bodySmall) },
        )
        if (hostText != null) {
            Text(
                "宿主： " + hostText,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.tertiary,
            )
        }
    }
}

/** 只读信息行 —— 值**可选可复制**（日志页要能长按选中） */
@Composable
fun SettingInfo(label: String, value: String, hint: String? = null) {
    RowShell {
        LabelLine(label, null)
        SelectionContainer {
            Text(
                value,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        HintLine(hint)
    }
}

/** 子页行：标题 + 说明 + 右箭头（原 UI 的「点进设置 ›」那种） */
@Composable
fun SettingNav(label: String, hint: String?, onClick: () -> Unit) {
    val src = remember { MutableInteractionSource() }
    val pressed by src.collectIsPressedAsState()
    Row(
        Modifier.fillMaxWidth()
            .clip(RoundedCornerShape(28.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .scale(if (pressed) 0.98f else 1f)
            .clickable(interactionSource = src, indication = LocalIndication.current) { onClick() }
            .padding(horizontal = Edge, vertical = 14.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Column(Modifier.weight(1f)) {
            Text(label, style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface)
            if (hint != null) {
                Text(hint, style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant, maxLines = 2)
            }
        }
        Icon(androidx.compose.material.icons.Icons.Rounded.ChevronRight, null,
            tint = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

/** 动作行（按钮） */
@Composable
fun SettingAction(label: String, hint: String? = null, onClick: () -> Unit) {
    RowShell {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                LabelLine(label, null)
                HintLine(hint)
            }
            FilledTonalButton(onClick = onClick) { Text("执行") }
        }
    }
}
