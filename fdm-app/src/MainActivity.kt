// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            /*
             * ★ 3.68.0「说话方式」🐲 —— 全树的 ctx 就在这一处定下来。
             *
             * 龙龙语时它是一个带 `zz` locale 的 Configuration ⇒ 全 UI 的
             * `ctx.getString(...)` / `stringResource(...)` **自动**去
             * `res/values-zz/strings.xml` 取文案，取不到就回落到人话版。
             *
             *   · 读 `Lang.version` 是为了换说话方式时**当场**换语言
             *     （不必重启 Activity，也就不会闪一下）；
             *   · 只在这一层 provides，所以 App.kt / Screens.kt / Music.kt …
             *     一行都不用为了这个彩蛋而改。
             */
            val base = LocalContext.current
            val langVer = Lang.version
            val uiCtx = remember(langVer) { Lang.wrap(base, Lang.current(base)) }

            CompositionLocalProvider(LocalContext provides uiCtx) {
                FdmTheme {
                    Surface(
                        modifier = Modifier.fillMaxSize(),
                        color = MaterialTheme.colorScheme.surface,
                    ) {
                        FdmApp(intent?.getStringExtra("page"))      // ★ 深链接：宿主迷你卡的 ♪
                    }
                }
            }
        }
    }
}
