// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.LocalIndication
import androidx.compose.foundation.clickable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.ArrowBack
import androidx.compose.material.icons.rounded.ChevronRight
import androidx.compose.material.icons.rounded.Home
import androidx.compose.material.icons.rounded.Info
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.material.icons.rounded.Save
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/* ───────────────────────── 尺寸常量（规范：边缘 16dp，组件间 8〜16dp） ───────────────────────── */
val Edge = 16.dp
val ListItemH = 72.dp
val LeadingBox = 40.dp
val LeadingIcon = 24.dp

/* ───────────────────────── 分组列表的「外 28 / 内 8」圆角 ───────────────────────── */
fun groupedShape(index: Int, count: Int): Shape {
    val outer = 28.dp; val inner = 8.dp
    val tl = if (index == 0) outer else inner
    val tr = if (index == 0) outer else inner
    val br = if (index == count - 1) outer else inner
    val bl = if (index == count - 1) outer else inner
    return RoundedCornerShape(topStart = tl, topEnd = tr, bottomEnd = br, bottomStart = bl)
}

/* ───────────────────────── 「猜你想跳转」小卡 ─────────────────────────
 *  ★ 2026-10-10（3.65.0）主人：「分别在音乐、回复建议、富文本顶上加一个容器，
 *    标题是"猜你想跳转"，里面一行可点击的蓝色文字指向系统提示词的界面」
 */
private val BlueLink = Color(0xFF1E88E5)

@Composable
fun JumpHintCard(onOpen: () -> Unit, text: String = "去「系统提示词」看看 ›") {
    Column(
        Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(24.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .padding(horizontal = Edge, vertical = 12.dp),
    ) {
        Text(
            "猜你想跳转",
            style = MaterialTheme.typography.labelMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Spacer(Modifier.height(6.dp))
        Text(
            text,
            style = MaterialTheme.typography.bodyMedium,
            color = BlueLink,
            modifier = Modifier
                .clip(RoundedCornerShape(8.dp))
                .clickable { onOpen() }
                .padding(vertical = 6.dp),
        )
    }
}

/* ───────────────────────── 顶部应用栏：64dp / surface / titleLarge / 左右 48dp 图标钮 ───────────────────────── */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FdmTopBar(
    title: String,
    scrollBehavior: TopAppBarScrollBehavior? = null,
    onBack: (() -> Unit)? = null,
    /** 传非空 ⇒ 右上角出现一个「保存」图标钮（**排在「更多」左边**，48dp）。 */
    onSave: (() -> Unit)? = null,
    /** 传非空 ⇒ 右上角出现一个「更多」图标钮（最右一个，48dp）。不传就还是原来那副样子。 */
    onMore: (() -> Unit)? = null,
) {
    TopAppBar(
        title = { Text(title, style = MaterialTheme.typography.titleLarge) },
        navigationIcon = {
            if (onBack != null) {
                IconButton(onClick = onBack, modifier = Modifier.size(48.dp)) {
                    Icon(Icons.AutoMirrored.Rounded.ArrowBack, "返回")
                }
            }
        },
        actions = {
            // ★ 顺序即位置：先「保存」后「更多」⇒ 保存落在更多左边
            if (onSave != null) {
                IconButton(onClick = onSave, modifier = Modifier.size(48.dp)) {
                    Icon(Icons.Rounded.Save, "保存")
                }
            }
            if (onMore != null) {
                IconButton(onClick = onMore, modifier = Modifier.size(48.dp)) {
                    Icon(Icons.Rounded.MoreVert, "更多")
                }
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = MaterialTheme.colorScheme.surface,
            scrolledContainerColor = MaterialTheme.colorScheme.surfaceContainer,
        ),
        scrollBehavior = scrollBehavior,
    )
}

/* ───────────────────────── 列表项：72dp，前置图标 24dp 置于 40dp primaryContainer 圆上 ───────────────────────── */
@Composable
fun FdmListItem(
    title: String,
    leading: ImageVector? = null,
    shape: Shape,
    supporting: String? = null,
    trailingChevron: Boolean = true,
    onClick: () -> Unit,
) {
    val src = remember { MutableInteractionSource() }
    val pressed by src.collectIsPressedAsState()
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(ListItemH)
            .clip(shape)
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .scale(if (pressed) 0.98f else 1f)
            .clickable(interactionSource = src, indication = LocalIndication.current) { onClick() }
            .padding(horizontal = Edge),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        if (leading != null) {
            Box(
                Modifier.size(LeadingBox).clip(CircleShape)
                    .background(MaterialTheme.colorScheme.primaryContainer),
                contentAlignment = Alignment.Center,
            ) {
                Icon(
                    leading, null,
                    modifier = Modifier.size(LeadingIcon),
                    tint = MaterialTheme.colorScheme.onPrimaryContainer,
                )
            }
            Spacer(Modifier.width(Edge))
        }
        Column(Modifier.weight(1f)) {
            Text(
                title,
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface,
                maxLines = 1, overflow = TextOverflow.Ellipsis,
            )
            if (supporting != null) {
                Text(
                    supporting,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 2, overflow = TextOverflow.Ellipsis,
                )
            }
        }
        if (trailingChevron) {
            Spacer(Modifier.width(8.dp))
            Icon(
                Icons.Rounded.ChevronRight, null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

/* ───────────────────────── 段落小标题：16sp ───────────────────────── */
@Composable
fun SectionLabel(text: String) {
    Text(
        text,
        fontSize = 16.sp,
        lineHeight = 22.sp,
        color = MaterialTheme.colorScheme.onSurface,
        modifier = Modifier.fillMaxWidth().padding(start = Edge, top = 4.dp, bottom = 8.dp),
    )
}

/* ───────────────────────── 分割线：1dp outlineVariant，左右 16dp ───────────────────────── */
@Composable
fun FdmDivider() {
    Box(
        Modifier.fillMaxWidth().padding(horizontal = Edge, vertical = 12.dp)
            .height(1.dp)
            .background(MaterialTheme.colorScheme.outlineVariant),
    )
}

/* ───────────────────────── 开关行：标签在左，开关靠右（M3 标准 52×32） ───────────────────────── */
@Composable
fun FdmSwitchRow(label: String, checked: Boolean, onChange: (Boolean) -> Unit) {
    Row(
        Modifier.fillMaxWidth().height(ListItemH).clip(RoundedCornerShape(28.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .padding(horizontal = Edge),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            label,
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.weight(1f),
        )
        Switch(checked = checked, onCheckedChange = onChange)
    }
}

/* ───────────────────────── 容器框：只有底色和圆角，本身没有行为 ───────────────────────── */
@Composable
fun ContainerBox(
    height: Dp,
    color: Color,
    topRadius: Dp = 28.dp,
    bottomRadius: Dp = 28.dp,
    content: @Composable BoxScope.() -> Unit,
) {
    Box(
        Modifier.fillMaxWidth().height(height)
            .clip(RoundedCornerShape(topStart = topRadius, topEnd = topRadius, bottomEnd = bottomRadius, bottomStart = bottomRadius))
            .background(color),
        content = content,
    )
}

/* ───────────────────────── 图片占位符：圆角 20dp，未指定时用 surfaceContainerHighest ───────────────────────── */
@Composable
fun ImagePlaceholder(size: Dp, modifier: Modifier = Modifier, content: @Composable BoxScope.() -> Unit = {}) {
    Box(
        modifier.size(size).clip(RoundedCornerShape(20.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerHighest),
        contentAlignment = Alignment.Center,
        content = content,
    )
}

/* ───────────────────────── 底部导航栏：80dp / surfaceContainer / 选中项为 secondaryContainer 胶囊 ───────────────────────── */
@Composable
fun FdmNavBar(selected: Int, onSelect: (Int) -> Unit) {
    NavigationBar(containerColor = MaterialTheme.colorScheme.surfaceContainer) {
        NavigationBarItem(
            selected = selected == 0,
            onClick = { onSelect(0) },
            icon = { Icon(Icons.Rounded.Home, "首页") },
            label = { Text("首页", style = MaterialTheme.typography.labelMedium) },
            colors = NavigationBarItemDefaults.colors(
                indicatorColor = MaterialTheme.colorScheme.secondaryContainer,
                selectedIconColor = MaterialTheme.colorScheme.onSecondaryContainer,
                selectedTextColor = MaterialTheme.colorScheme.onSurface,
                unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
            ),
        )
        NavigationBarItem(
            selected = selected == 1,
            onClick = { onSelect(1) },
            icon = { Icon(Icons.Rounded.Info, "关于") },
            label = { Text("关于", style = MaterialTheme.typography.labelMedium) },
            colors = NavigationBarItemDefaults.colors(
                indicatorColor = MaterialTheme.colorScheme.secondaryContainer,
                selectedIconColor = MaterialTheme.colorScheme.onSecondaryContainer,
                selectedTextColor = MaterialTheme.colorScheme.onSurface,
                unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
            ),
        )
    }
}
