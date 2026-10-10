// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.activity.compose.BackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.offset
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

/**
 * 导航状态 = **页面 id 本身**（不是枚举）。
 *
 * ★ 踩过的坑：原来用 `enum Scr {HOME, ABOUT, GRAY, FEATURE}` 当状态，而真正的页面身份
 *   是另一个字符串 `featTitle` ✗ ⇒ "美化 → AI气泡美化"这种**页内跳页**里 Scr 没变
 *   ⇒ ① `AnimatedContent` 不重画（看着像"点了没反应"✗）
 *     ② 每点一次都往返回栈塞一条 ⇒ 返回要按两次 ✗
 *   换成 id 之后，每个页面都是一个不同的状态 ✅（一次点击 = 一次跳转 = 一条栈 ✅）
 */

/** 过渡方向 */
private enum class Tr { IN_RIGHT, IN_LEFT, FADE }

private const val HOME = "home"
private const val ABOUT = "about"

/* 「平滑、不回弹」——空域 tween 与效果域各自一套 spring，阻尼都是 1.0（无回弹） */
private val spatial = spring<IntOffset>(dampingRatio = Spring.DampingRatioNoBouncy, stiffness = Spring.StiffnessMediumLow)
private val effects = spring<Float>(dampingRatio = Spring.DampingRatioNoBouncy, stiffness = Spring.StiffnessMediumLow)

@Composable
fun FdmApp(initialPage: String? = null) {
    var page by remember { mutableStateOf(HOME) }
    var tr by remember { mutableStateOf(Tr.FADE) }
    var stack by remember { mutableStateOf(listOf<String>()) }

    // ★ 2026-10-06：从宿主迷你卡点 ♪ 进来时，直接落到指定页（默认音乐）
    LaunchedEffect(initialPage) {
        val t = initialPage
        if (!t.isNullOrEmpty() && t != HOME && t != ABOUT) {
            tr = Tr.FADE
            stack = listOf(HOME)
            page = t
        }
    }

    fun go(target: String, t: Tr, push: Boolean = false) {
        if (target == page) return          // 同页不重复入栈（防"返回两次"）
        tr = t
        if (push) stack = stack + page
        page = target
    }

    fun back() {
        val prev = stack.lastOrNull() ?: return
        tr = Tr.IN_LEFT                     // 反向播放：新页从左滑入，旧页向右滑出
        stack = stack.dropLast(1)
        page = prev
    }

    BackHandler(enabled = stack.isNotEmpty()) { back() }

    AnimatedContent(
        targetState = page,
        transitionSpec = {
            when (tr) {
                Tr.IN_RIGHT -> (slideInHorizontally(spatial) { it } + fadeIn(effects)) togetherWith
                        (slideOutHorizontally(spatial) { -it / 4 } + fadeOut(effects))
                Tr.IN_LEFT -> (slideInHorizontally(spatial) { -it } + fadeIn(effects)) togetherWith
                        (slideOutHorizontally(spatial) { it / 4 } + fadeOut(effects))
                Tr.FADE -> fadeIn(effects) togetherWith fadeOut(effects)
            }
        },
        label = "page",
    ) { p ->
        when (p) {
            // ★ 3.68.0：首页**左滑**进关于 —— 内容跟手往左，关于页从右边滑进来（Tr.IN_RIGHT）
            HOME -> SwipeToGo(dir = -1, onGo = { go(ABOUT, Tr.IN_RIGHT) }) {
                TreeHome(
                    onNav = { id -> go(id, Tr.IN_RIGHT, push = true) },
                    onAbout = { go(ABOUT, Tr.IN_RIGHT) },
                )
            }
            // 关于页：**右滑**回首页（主人：「关于页没问题」⇒ 一个字不动）
            ABOUT -> SwipeToGo(dir = +1, onGo = { go(HOME, Tr.IN_LEFT) }) {
                AboutScreen(onNav = { i -> if (i == 0) go(HOME, Tr.IN_RIGHT) })
            }
            else -> TreePage(
                id = p,
                onNav = { id -> go(id, Tr.IN_RIGHT, push = true) },
                onBack = { back() },
            )
        }
    }
}

/**
 * 跟手横滑：内容**跟着手指**走；松手过阈值就跳转，否则弹回原位。
 *
 * @param dir 允许的滑动方向 —— `+1` = 向右滑，`-1` = 向左滑。
 *
 * ★ 3.68.0（主人 2026-10-10：「首页应该是左滑到关于，关于页没问题」）：
 *   原来只有一个 `SwipeRightToGo`（只认右滑），首页被挂成了「**右**滑→关于」⇒ 方向反了。
 *   ⇒ 加一个 `dir` 参数：首页传 `-1`（左滑进关于），关于页保持 `+1`（右滑回首页）。
 *
 * 再记一笔：这里 `pointerInput` 的 key 里不放 lambda（`onGo`）——
 * 每次重组 lambda 都是新实例，放进 key 会让 pointerInput **在拖动中途重启**（拖一半就断）。
 * 它闭包里读的 `page` / `stack` / `tr` 都是 state，所以读到的一定是新值 ✓。
 */
@Composable
private fun SwipeToGo(dir: Int, onGo: () -> Unit, content: @Composable () -> Unit) {
    var dx by remember { mutableFloatStateOf(0f) }
    val threshold = with(LocalDensity.current) { 88.dp.toPx() }
    Box(
        Modifier
            .fillMaxSize()
            .offset { IntOffset(dx.roundToInt(), 0) }
            .pointerInput(dir) {
                detectHorizontalDragGestures(
                    onDragEnd = {
                        val passed = if (dir > 0) dx > threshold else dx < -threshold
                        if (passed) onGo()
                        dx = 0f
                    },
                    onHorizontalDrag = { _, delta ->
                        dx = if (dir > 0) {
                            (dx + delta).coerceIn(0f, size.width.toFloat())          // 只能往右
                        } else {
                            (dx + delta).coerceIn(-size.width.toFloat(), 0f)         // 只能往左
                        }
                    },
                )
            },
    ) { content() }
}
