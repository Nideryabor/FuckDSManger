// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.LaunchedEffect
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
                // ★★ 2026-11-08 · 夜间模式（带颜色渐变动效）
                //
                //  ① 初始值从 SP 读（记住上次的选择）
                //  ② `isSystemInDarkTheme()` 只在"跟随系统"那档起作用
                //  ③ 关键：**不让 MaterialTheme 直接吃目标配色** ——
                //     先过 `animatedColorScheme()` 把每个颜色角色用
                //     animateColorAsState 插值，看起来才是一起渐变。
                //     （直接换 CompositionLocal 是瞬间的，会"啪"一下闪。）
                val sysDark = androidx.compose.foundation.isSystemInDarkTheme()
                var nightMode by remember {
                    mutableIntStateOf(NightMode.mode(base))
                }
                // 冷启动不要动画（一进来就渐变会很怪）
                var justLaunched by remember { mutableStateOf(true) }
                LaunchedEffect(Unit) {
                    kotlinx.coroutines.delay(80)
                    justLaunched = false
                }
                val wantDark = NightMode.resolve(nightMode, sysDark)
                val baseScheme = if (wantDark) FdmSchemeDark else FdmScheme
                val scheme = animatedColorScheme(baseScheme, animate = !justLaunched)

                FdmTheme(scheme) {
                    Surface(
                        modifier = Modifier.fillMaxSize(),
                        color = MaterialTheme.colorScheme.surface,
                    ) {
                        // ★ 夜间模式通过 CompositionLocal 往下传 ——
                        //   FdmTopBar 有 5 个调用点，逐层传参要改一堆签名，
                        //   而这件事只跟主题有关，CompositionLocal 才是它的位置。
                        CompositionLocalProvider(
                            LocalNight provides NightState(wantDark) {
                                nightMode = if (wantDark) NightMode.LIGHT else NightMode.DARK
                                NightMode.setMode(base, nightMode)
                            },
                        ) {
                            // ★ 深链接：宿主迷你卡的 ♪
                            FdmApp(initialPage = intent?.getStringExtra("page"))
                        }
                    }
                }
            }
        }
    }
}
