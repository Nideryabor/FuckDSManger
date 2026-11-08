// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.tween
import androidx.compose.material3.ColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.ui.graphics.Color

/**
 * 夜间模式 🐲 2026-11-08
 *
 * <h3>⭐ 渐变是怎么做的</h3>
 * Compose 的 `MaterialTheme(colorScheme = ...)` 换配色是**瞬间**的
 * （只是一个 CompositionLocal 值变了）—— 直接换会"啪"一下闪。
 *
 * 做法：不让 `MaterialTheme` 直接吃目标配色，而是先把**每一个颜色角色**
 * 用 `animateColorAsState` 从旧色插值到新色，再把插值中的配色交给
 * `MaterialTheme` ⇒ 看起来就是整个界面一起渐变。
 *
 * 代价：30 多个颜色各起一个动画。这是**主题级**切换（一天点几次），
 * 不在绘制热路径上，所以无所谓；但**不要**把这个技巧用到列表里的每个 item。
 */
object NightMode {

    private const val KEY = "ui_night_mode"

    /** 0 = 跟随系统 · 1 = 强制亮 · 2 = 强制暗 */
    const val FOLLOW = 0
    const val LIGHT = 1
    const val DARK = 2

    fun mode(ctx: Context): Int =
        ctx.getSharedPreferences("fdm", Context.MODE_PRIVATE).getInt(KEY, FOLLOW)

    fun setMode(ctx: Context, v: Int) {
        ctx.getSharedPreferences("fdm", Context.MODE_PRIVATE)
            .edit().putInt(KEY, v).apply()
    }

    /** 算出现在到底该不该用深色。 */
    fun resolve(mode: Int, systemDark: Boolean): Boolean = when (mode) {
        LIGHT -> false
        DARK -> true
        else -> systemDark
    }
}

/**
 * 把「静态配色」变成「会渐变的配色」。
 *
 * @param target  目标配色（亮或暗）
 * @param animate 是否渐变（false = 立刻生效，冷启动时用）
 */
@Composable
fun animatedColorScheme(target: ColorScheme, animate: Boolean = true): ColorScheme {
    // ★ 动画时长 420ms —— 比列表动效长得多。
    //   主题切换是"全局大动作"，太快会显得闪；420ms 是"能感觉到渐变但不用等"。
    val spec = tween<Color>(durationMillis = 420)

    // ⚠️ 不能用「局部函数 + 里面调 @Composable」—— Kotlin 的 Compose 编译器插件
    //    不会给局部函数加 @Composable 标记 ⇒ 编译报
    //    "functions which invoke @Composable functions must be marked with @Composable"。
    //    ⇒ 所以每个角色都写成**顶层内联表达式**（下面 copy() 里那段）。

    return target.copy(
        primary = (if (!animate) target.primary else animateColorAsState(target.primary, spec, label = "primary").value),
        onPrimary = (if (!animate) target.onPrimary else animateColorAsState(target.onPrimary, spec, label = "onPrimary").value),
        primaryContainer = (if (!animate) target.primaryContainer else animateColorAsState(target.primaryContainer, spec, label = "primaryContainer").value),
        onPrimaryContainer = (if (!animate) target.onPrimaryContainer else animateColorAsState(target.onPrimaryContainer, spec, label = "onPrimaryContainer").value),
        inversePrimary = (if (!animate) target.inversePrimary else animateColorAsState(target.inversePrimary, spec, label = "inversePrimary").value),
        secondary = (if (!animate) target.secondary else animateColorAsState(target.secondary, spec, label = "secondary").value),
        onSecondary = (if (!animate) target.onSecondary else animateColorAsState(target.onSecondary, spec, label = "onSecondary").value),
        secondaryContainer = (if (!animate) target.secondaryContainer else animateColorAsState(target.secondaryContainer, spec, label = "secondaryContainer").value),
        onSecondaryContainer = (if (!animate) target.onSecondaryContainer else animateColorAsState(target.onSecondaryContainer, spec, label = "onSecondaryContainer").value),
        tertiary = (if (!animate) target.tertiary else animateColorAsState(target.tertiary, spec, label = "tertiary").value),
        onTertiary = (if (!animate) target.onTertiary else animateColorAsState(target.onTertiary, spec, label = "onTertiary").value),
        tertiaryContainer = (if (!animate) target.tertiaryContainer else animateColorAsState(target.tertiaryContainer, spec, label = "tertiaryContainer").value),
        onTertiaryContainer = (if (!animate) target.onTertiaryContainer else animateColorAsState(target.onTertiaryContainer, spec, label = "onTertiaryContainer").value),
        background = (if (!animate) target.background else animateColorAsState(target.background, spec, label = "background").value),
        onBackground = (if (!animate) target.onBackground else animateColorAsState(target.onBackground, spec, label = "onBackground").value),
        surface = (if (!animate) target.surface else animateColorAsState(target.surface, spec, label = "surface").value),
        onSurface = (if (!animate) target.onSurface else animateColorAsState(target.onSurface, spec, label = "onSurface").value),
        surfaceVariant = (if (!animate) target.surfaceVariant else animateColorAsState(target.surfaceVariant, spec, label = "surfaceVariant").value),
        onSurfaceVariant = (if (!animate) target.onSurfaceVariant else animateColorAsState(target.onSurfaceVariant, spec, label = "onSurfaceVariant").value),
        surfaceTint = (if (!animate) target.surfaceTint else animateColorAsState(target.surfaceTint, spec, label = "surfaceTint").value),
        inverseSurface = (if (!animate) target.inverseSurface else animateColorAsState(target.inverseSurface, spec, label = "inverseSurface").value),
        inverseOnSurface = (if (!animate) target.inverseOnSurface else animateColorAsState(target.inverseOnSurface, spec, label = "inverseOnSurface").value),
        error = (if (!animate) target.error else animateColorAsState(target.error, spec, label = "error").value),
        onError = (if (!animate) target.onError else animateColorAsState(target.onError, spec, label = "onError").value),
        errorContainer = (if (!animate) target.errorContainer else animateColorAsState(target.errorContainer, spec, label = "errorContainer").value),
        onErrorContainer = (if (!animate) target.onErrorContainer else animateColorAsState(target.onErrorContainer, spec, label = "onErrorContainer").value),
        outline = (if (!animate) target.outline else animateColorAsState(target.outline, spec, label = "outline").value),
        outlineVariant = (if (!animate) target.outlineVariant else animateColorAsState(target.outlineVariant, spec, label = "outlineVariant").value),
        scrim = (if (!animate) target.scrim else animateColorAsState(target.scrim, spec, label = "scrim").value),
        surfaceBright = (if (!animate) target.surfaceBright else animateColorAsState(target.surfaceBright, spec, label = "surfaceBright").value),
        surfaceDim = (if (!animate) target.surfaceDim else animateColorAsState(target.surfaceDim, spec, label = "surfaceDim").value),
        surfaceContainer = (if (!animate) target.surfaceContainer else animateColorAsState(target.surfaceContainer, spec, label = "surfaceContainer").value),
        surfaceContainerHigh = (if (!animate) target.surfaceContainerHigh else animateColorAsState(target.surfaceContainerHigh, spec, label = "surfaceContainerHigh").value),
        surfaceContainerHighest = (if (!animate) target.surfaceContainerHighest else animateColorAsState(target.surfaceContainerHighest, spec, label = "surfaceContainerHighest").value),
        surfaceContainerLow = (if (!animate) target.surfaceContainerLow else animateColorAsState(target.surfaceContainerLow, spec, label = "surfaceContainerLow").value),
        surfaceContainerLowest = (if (!animate) target.surfaceContainerLowest else animateColorAsState(target.surfaceContainerLowest, spec, label = "surfaceContainerLowest").value),
    )
}

/**
 * 夜间模式的「当前状态 + 切换」往子级传的通道。
 *
 * <h3>为什么用 CompositionLocal 而不是逐层传参</h3>
 * `FdmTopBar` 在 5 个地方被调用（首页 / 各功能页 / 美化页 / 工具页 / 更多页）。
 * 逐层加参数要改 5 个调用点 + 中间每个 Composable 的签名，
 * 而这件事**只跟主题有关、和业务无关** ⇒ CompositionLocal 才是它的位置。
 */
data class NightState(val dark: Boolean, val onToggle: () -> Unit)

val LocalNight = androidx.compose.runtime.staticCompositionLocalOf<NightState?> { null }
