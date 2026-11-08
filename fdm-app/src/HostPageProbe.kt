// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger

import android.view.View
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * 【HostPageProbe】「能不能把整个 Compose 页面塞进宿主」的**活体探针** 🐲
 *
 * ── 它和保底弹窗的区别 ──────────────────────────────────────────
 * 保底弹窗只有 Column + Text + 一个按钮，**证明不了整页可行**。
 * 真正会咬人的是这三样（页面才有、弹窗没有）：
 *
 * | 项 | 为什么危险 |
 * |---|---|
 * | **IME（输入法）** | 窗口是**宿主 Activity 的**，softInputMode 由宿主决定，我们改不了；`imePadding()` 能不能拿到正确的 insets 完全取决于宿主的 WindowInsets 分发 |
 * | **LazyColumn 滚动** | 需要真正的帧时钟 + 可观察的 recomposition；我们的 recomposer 是手工建的，要确认它真的在推帧 |
 * | **状态刷新** | `mutableStateOf` + 输入 → 每次按键都要重组；手工 recomposer 若没接上 lifecycle 就会**静默不刷新** |
 *
 * 三样都过 ⇒ 整页方案落地可行；任何一样不过 ⇒ 提前知道，不拿正式功能去赌。
 *
 * ── 怎么触发 ──────────────────────────────────────────────────
 * ```
 * adb shell am broadcast -a com.little_femaleboy.fdm.CMD --es cmd page_probe
 * ```
 * 弹出来的是**全屏**的（不是小卡片），所以能真实压测 IME 与滚动。
 */
object HostPageProbe {

    private val C_BG = Color(0xFF14141A)
    private val C_CARD = Color(0xFF23232B)
    private val C_TXT = Color(0xFFEDEDF2)
    private val C_DIM = Color(0xFF9A9AA6)
    private val C_PRIMARY = Color(0xFF3D7EFF)

    /**
     * 把一个 **全屏** 的探针页面装进给定的 ComposeView。
     *
     * 与保底弹窗共用同一套 owner（[FallbackLifecycle]），
     * 这样"能跑"本身就是对 owner 方案的验证。
     */
    @JvmStatic
    fun install(cv: View) {
        val compose = cv as ComposeView
        compose.setContent {
            ProbePage()
        }
    }

    @Composable
    private fun ProbePage() {
        var input by remember { mutableStateOf("") }
        var taps by remember { mutableStateOf(0) }
        val rows = remember { (1..60).map { "第 $it 行 —— 滚动测试" } }

        Column(
            Modifier
                .fillMaxSize()
                .background(C_BG)
                .imePadding()
                .padding(horizontal = 18.dp, vertical = 14.dp)
        ) {
            Text(
                text = "宿主内嵌页面探针",
                color = C_TXT,
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold
            )
            Text(
                text = "验证 IME（输入法）、滚动、状态刷新三件事",
                color = C_DIM,
                fontSize = 12.sp,
                modifier = Modifier.padding(top = 4.dp)
            )

            Spacer(Modifier.height(14.dp))

            // ① IME + 状态刷新：输入框
            Box(
                Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(10.dp))
                    .background(C_CARD)
                    .padding(horizontal = 12.dp, vertical = 10.dp)
            ) {
                if (input.isEmpty()) {
                    Text("在这里打字，看键盘会不会盖住它", color = C_DIM, fontSize = 13.sp)
                }
                BasicTextField(
                    value = input,
                    onValueChange = { input = it },
                    textStyle = TextStyle(color = C_TXT, fontSize = 13.sp),
                    modifier = Modifier.fillMaxWidth()
                )
            }
            Text(
                text = "已输入 " + input.length + " 个字符",
                color = if (input.isEmpty()) C_DIM else C_PRIMARY,
                fontSize = 11.sp,
                modifier = Modifier.padding(top = 6.dp)
            )

            Spacer(Modifier.height(12.dp))

            // ② 点击 → 重组
            Row(
                Modifier
                    .clip(RoundedCornerShape(10.dp))
                    .background(C_PRIMARY)
                    .clickable { taps++ }
                    .padding(horizontal = 16.dp, vertical = 9.dp),
                horizontalArrangement = Arrangement.Center
            ) {
                Text("点了 " + taps + " 次", color = Color.White, fontSize = 13.sp)
            }

            Spacer(Modifier.height(12.dp))

            // ③ LazyColumn 滚动（60 行，必须能滚）
            LazyColumn(Modifier.fillMaxSize()) {
                items(rows) { line ->
                    Box(
                        Modifier
                            .fillMaxWidth()
                            .padding(vertical = 3.dp)
                            .clip(RoundedCornerShape(8.dp))
                            .background(C_CARD)
                            .padding(horizontal = 12.dp, vertical = 10.dp),
                        contentAlignment = Alignment.CenterStart
                    ) {
                        Text(line, color = C_TXT, fontSize = 13.sp)
                    }
                }
            }
        }
    }
}
