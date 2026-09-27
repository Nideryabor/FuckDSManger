package com.nidyaber.fuckdsmanger

import androidx.compose.material3.lightColorScheme
import androidx.compose.ui.graphics.Color

/* 规范给定的 Blue 浅色配色 —— 全应用颜色都从这些【角色】引用，不写死色值 */
val FdmScheme = lightColorScheme(
    primary = Color(0xFF0B57D0),
    onPrimary = Color(0xFFFFFFFF),
    primaryContainer = Color(0xFFD3E3FD),
    onPrimaryContainer = Color(0xFF041E49),
    secondaryContainer = Color(0xFFDCE2F9),
    onSecondaryContainer = Color(0xFF131C2B),
    tertiaryContainer = Color(0xFFFFD8EE),
    onTertiaryContainer = Color(0xFF2E1125),
    surface = Color(0xFFFAF9FD),
    surfaceContainerLow = Color(0xFFF3F3FA),
    surfaceContainer = Color(0xFFEEEDF3),
    surfaceContainerHigh = Color(0xFFE9E8EF),
    surfaceContainerHighest = Color(0xFFE3E2E6),
    onSurface = Color(0xFF1B1B1F),
    onSurfaceVariant = Color(0xFF44474E),
    outline = Color(0xFF74777F),
    outlineVariant = Color(0xFFC4C6D0),
    inverseSurface = Color(0xFF303034),
    inverseOnSurface = Color(0xFFF2F0F4),
    inversePrimary = Color(0xFFA8C7FA),
    error = Color(0xFFB3261E),
    onError = Color(0xFFFFFFFF),
    errorContainer = Color(0xFFF9DEDC),
    onErrorContainer = Color(0xFF410E0B),
)
