// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.app.Activity
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.OnBackPressedDispatcherOwner
import androidx.activity.compose.LocalActivity
import androidx.activity.compose.LocalActivityResultRegistryOwner
import androidx.activity.compose.LocalOnBackPressedDispatcherOwner
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.ActivityResultRegistryOwner
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ProvidedValue
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

            /*
             * ★★ 3.68.1 修崩溃（主人报：「换语言以后点击原本的调试菜单会崩溃」）
             *
             * 真凶：`Lang.wrap` 出来的是 `createConfigurationContext` 的**包装 Context**，
             * 它**不再是 Activity** —— 而 Compose 里有两个 local 的取值方式是
             * 「没被显式 provide 就**向下转型 `LocalContext`**」：
             *
             *   · `LocalActivityResultRegistryOwner` —— `rememberLauncherForActivityResult()` 用
             *     （我们「选图片」那个入口）⇒ 找不到就 **checkNotNull 抛异常**：
             *       IllegalStateException: No ActivityResultRegistryOwner was provided
             *       via LocalActivityResultRegistryOwner            ← 主人遇到的正是这条
             *   · `LocalOnBackPressedDispatcherOwner` —— `BackHandler()` 用（我们的返回键）
             *     ⇒ 一样抛：No NavigationEventDispatcherOwner / OnBackPressedDispatcherOwner…
             *
             * ⇒ 人话时不崩（那时 `uiCtx` **就是** Activity，转型成功）；
             *   一换成龙龙语，`uiCtx` 变成包装 Context，这两条路**同时断掉**。
             *
             * 修法：把**真正的 Activity**（`base`）作为这两个 owner 显式喂下去 ——
             * 我们只换了「说话方式」，Activity 本身一个字都没动。
             */
            val activityLocals = remember(base) {
                buildList<ProvidedValue<*>> {
                    // ★ 三重保险：谁问「你是哪个 Activity」都把**真的**给它。
                    //   `LocalActivity` 在 activity-compose 1.13 还是 public（ProvidableCompositionLocal）
                    (base as? Activity)?.let {
                        add(LocalActivity provides it)
                    }
                    (base as? ActivityResultRegistryOwner)?.let {
                        add(LocalActivityResultRegistryOwner provides it)
                    }
                    (base as? OnBackPressedDispatcherOwner)?.let {
                        add(LocalOnBackPressedDispatcherOwner provides it)
                    }
                }
            }

            CompositionLocalProvider(
                LocalContext provides uiCtx,          // ← 说话方式（文案从这里出去）
                *activityLocals.toTypedArray(),       // ← Activity 的能力（选图 / 返回键）
            ) {
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
