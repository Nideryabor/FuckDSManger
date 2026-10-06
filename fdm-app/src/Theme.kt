// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.runtime.Composable

/* M3 Expressive 主题。
 * material3 1.4.0 把 Expressive 那套（MaterialExpressiveTheme / MotionScheme）在
 * Kotlin 元数据里标成了 internal（字节码其实是 public），第三方得用
 * 「全限定名 + @Suppress」这个标准手法访问 —— 见 Kotlin 的 INVISIBLE_MEMBER。 */
@Suppress("INVISIBLE_MEMBER", "INVISIBLE_REFERENCE")
@Composable
fun FdmTheme(content: @Composable () -> Unit) {
    androidx.compose.material3.MaterialExpressiveTheme(
        colorScheme = FdmScheme,
        motionScheme = androidx.compose.material3.MotionScheme.standard(),
        content = content,
    )
}
