// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animate
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

/**
 * 「系统提示词 v2」—— 重构骨架页 🐲（2026-10-07）
 *
 * <p>主人：「我们的系统提示词列表比较反人类，我要重构。新界面先塞调试菜单，稳了再并进主菜单。」
 * 这一版**只搭壳**，里面不放业务：
 *
 * 1. **页面内的空白容器** —— 中间一行占位文字，以后的内容往它里面塞。
 * 2. **底部抽屉** —— 可向上拉，最高到**屏幕 1/2**；初始收在底部、只露一条把手。
 *    （原计划是左右两个独占界面 + 左右滑切页；主人当天改成**先只做第一页**，
 *      所以这里是单页 —— 要分页时把 `DrawerPageOne()` 换成 HorizontalPager 即可。）
 * 3. **顶部工具栏右对齐的「更多」** —— 点了出一个 Compose 弹窗（`AlertDialog`，
 *    **带确认键**，不是吐司）。
 *
 * <p>为什么抽屉不用 `ModalBottomSheet`：它没法「收在底部只露一条把手」——
 * 一打开就至少是半个屏，而且背后会压一层 scrim。这里要的是**常驻在页面里的抽屉**，
 * 所以自己用 `draggable` + `animate` 做两档吸附（收起 0 ⇄ 拉满 = 半屏）。
 *
 * <p>★ 手势方向：Compose 的 drag delta 沿轴正向为正（竖向 = 往下为正），
 * 所以「往上拉」是负 delta ⇒ `live = live - delta`。
 */

/** 把手条的高度（收起时露出来的就是它）。 */
private val DrawerHandleH = 28.dp

/** 抽屉最大高度 = 屏幕的一半（含把手）。 */
private const val DrawerMaxRatio = 0.5f

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SysPromptV2Page(onBack: () -> Unit) {
    var more by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            FdmTopBar(
                title = "系统提示词 v2",
                onBack = onBack,
                onMore = { more = true },     // ★ 右上角「更多」→ Compose 弹窗
            )
        },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        BoxWithConstraints(Modifier.fillMaxSize().padding(pad)) {
            val density = LocalDensity.current
            val handlePx = with(density) { DrawerHandleH.toPx() }
            // 抽屉总高 = 页面高的一半；可拉升的距离 = 总高 − 把手
            val sheetPx = with(density) { maxHeight.toPx() } * DrawerMaxRatio
            val travel = (sheetPx - handlePx).coerceAtLeast(1f)
            val sheetDp = with(density) { sheetPx.toDp() }

            // live = 已经拉起来多少（0 = 收在底部；travel = 拉满）
            var live by remember { mutableFloatStateOf(0f) }
            var dragging by remember { mutableStateOf(false) }
            var target by remember { mutableFloatStateOf(0f) }

            // 松手后的吸附动画：拖拽中不做动画（拖拽自己写 live）
            LaunchedEffect(target, dragging) {
                if (!dragging) {
                    animate(
                        initialValue = live,
                        targetValue = target,
                        animationSpec = spring(
                            dampingRatio = Spring.DampingRatioNoBouncy,
                            stiffness = Spring.StiffnessMediumLow,
                        ),
                    ) { v, _ -> live = v }
                }
            }

            Box(Modifier.fillMaxSize()) {

                /* ── ① 页面内容：一块空白容器（中间一行占位文字） ── */
                Column(Modifier.fillMaxSize()) {
                    BlankContainer(
                        Modifier
                            .fillMaxWidth()
                            .weight(1f)
                            .padding(horizontal = Edge),
                        text = "（空白容器 · 内容待定）",
                    )
                    Spacer(Modifier.height(DrawerHandleH))   // 给收起的抽屉把手留位
                }

                /* ── ② 底部抽屉（叠在内容之上） ── */
                Box(
                    Modifier
                        .align(Alignment.BottomCenter)
                        .fillMaxWidth()
                        .height(sheetDp)
                        .offset {
                            // 收起时整体下移 travel ⇒ 只留最上面那条把手可见
                            IntOffset(0, (travel - live.coerceIn(0f, travel)).roundToInt())
                        }
                        .clip(RoundedCornerShape(topStart = 28.dp, topEnd = 28.dp))
                        .background(MaterialTheme.colorScheme.surfaceContainerHigh)
                        .draggable(
                            orientation = Orientation.Vertical,
                            state = rememberDraggableState { delta ->
                                live = (live - delta).coerceIn(0f, travel)
                            },
                            onDragStarted = { dragging = true },
                            onDragStopped = { v ->
                                // 甩得快就按方向走，否则按过没过一半
                                val open = when {
                                    v < -600f -> true
                                    v > 600f -> false
                                    else -> live > travel / 2f
                                }
                                dragging = false
                                target = if (open) travel else 0f
                            },
                        ),
                ) {
                    Column(Modifier.fillMaxSize()) {

                        /* 把手：点一下也能开合 */
                        Box(
                            Modifier
                                .fillMaxWidth()
                                .height(DrawerHandleH)
                                .clickable {
                                    target = if (live < travel / 2f) travel else 0f
                                },
                            contentAlignment = Alignment.Center,
                        ) {
                            Box(
                                Modifier
                                    .size(width = 40.dp, height = 4.dp)
                                    .clip(CircleShape)
                                    .background(MaterialTheme.colorScheme.onSurfaceVariant),
                            )
                        }

                        /* 抽屉内容：现在就这一页 */
                        DrawerPageOne()
                    }
                }
            }
        }
    }

    /* ── ③ 「更多」弹窗：标题 + 确认键（骨架阶段点了就关） ── */
    if (more) {
        AlertDialog(
            onDismissRequest = { more = false },
            confirmButton = {
                TextButton(onClick = { more = false }) { Text("确认") }
            },
            title = { Text("更多") },
        )
    }
}

/** 空白容器：只有底色 + 圆角，中间一行占位文字，本身没有行为。 */
@Composable
private fun BlankContainer(modifier: Modifier = Modifier, text: String) {
    Box(
        modifier
            .clip(RoundedCornerShape(28.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerHigh),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center,
        )
    }
}

/** 抽屉第一页（占位）。要分左右两页时，把这里换成 `HorizontalPager` 就行。 */
@Composable
private fun DrawerPageOne() {
    Column(
        Modifier.fillMaxSize().padding(horizontal = Edge, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        Text(
            "第一页",
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onSurface,
        )
        Text(
            "（占位 · 待填）",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}
