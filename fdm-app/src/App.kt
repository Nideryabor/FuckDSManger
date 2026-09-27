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
fun FdmApp() {
    var page by remember { mutableStateOf(HOME) }
    var tr by remember { mutableStateOf(Tr.FADE) }
    var stack by remember { mutableStateOf(listOf<String>()) }

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
            HOME -> SwipeRightToGo(onGo = { go(ABOUT, Tr.IN_LEFT) }) {
                TreeHome(
                    onNav = { id -> go(id, Tr.IN_RIGHT, push = true) },
                    onAbout = { go(ABOUT, Tr.IN_RIGHT) },
                )
            }
            ABOUT -> SwipeRightToGo(onGo = { go(HOME, Tr.IN_LEFT) }) {
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

/** 向右滑动：跟随手指移动；超过阈值就跳转，否则弹回 */
@Composable
private fun SwipeRightToGo(onGo: () -> Unit, content: @Composable () -> Unit) {
    var dx by remember { mutableFloatStateOf(0f) }
    val threshold = with(LocalDensity.current) { 88.dp.toPx() }
    Box(
        Modifier
            .fillMaxSize()
            .offset { IntOffset(dx.roundToInt(), 0) }
            .pointerInput(Unit) {
                detectHorizontalDragGestures(
                    onDragEnd = {
                        if (dx > threshold) onGo()
                        dx = 0f
                    },
                    onHorizontalDrag = { _, delta ->
                        dx = (dx + delta).coerceIn(0f, size.width.toFloat())
                    },
                )
            },
    ) { content() }
}
