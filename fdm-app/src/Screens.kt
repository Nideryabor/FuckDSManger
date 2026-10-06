// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.AdminPanelSettings
import androidx.compose.material.icons.rounded.Build
import androidx.compose.material.icons.rounded.EditNote
import androidx.compose.material.icons.rounded.Mood
import androidx.compose.material.icons.rounded.Sms
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/* ═════════════════════════ 主页 ═════════════════════════ */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    onGray: () -> Unit,
    onFeature: (String) -> Unit,
    onNav: (Int) -> Unit,
) {
    val sb = TopAppBarDefaults.pinnedScrollBehavior()
    Scaffold(
        topBar = { FdmTopBar("FuckDSManger", scrollBehavior = sb) },
        bottomBar = { FdmNavBar(selected = 0, onSelect = onNav) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(top = 8.dp, bottom = 16.dp),
        ) {
            SectionLabel("核心の功能")
            FdmListItem(
                title = "灰度选项管理",
                supporting = "查看宿主隐藏设置(小心封号)",
                leading = Icons.Rounded.EditNote,
                shape = groupedShape(0, 1),
                onClick = onGray,
            )
            FdmDivider()
            SectionLabel("附加の功能")
            val extra = listOf(
                Triple("聊天", Icons.Rounded.Sms, null as String?),
                Triple("美化", Icons.Rounded.Mood, null),
                Triple("过检", Icons.Rounded.AdminPanelSettings, "如果ds压力root设备/发现lsp，点我"),
                Triple("调试", Icons.Rounded.Build, "如果没bug，里面的东西别乱动"),
            )
            Column(verticalArrangement = Arrangement.spacedBy(3.dp)) {
                extra.forEachIndexed { i, (title, icon, sup) ->
                    FdmListItem(
                        title = title,
                        supporting = sup,
                        leading = icon,
                        shape = groupedShape(i, extra.size),
                        onClick = { onFeature(title) },
                    )
                }
            }
        }
    }
}

/* ═════════════════════════ 关于 ═════════════════════════ */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AboutScreen(onNav: (Int) -> Unit) {
    Scaffold(
        bottomBar = { FdmNavBar(selected = 1, onSelect = onNav) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad)
                .verticalScroll(rememberScrollState()),
        ) {
            /* ── 412×368 容器：图片居中 + 下部粗体标题（组件叠在容器之上） ── */
            ContainerBox(368.dp, MaterialTheme.colorScheme.primaryContainer) {
                ImagePlaceholder(200.dp, Modifier.align(Alignment.Center)) {
                    Icon(
                        Icons.Rounded.EditNote, null,
                        modifier = Modifier.size(72.dp),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                Text(
                    "FDM-100%由DS鬼脑发动的神秘模块",
                    fontSize = 22.sp,
                    lineHeight = 30.sp,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onPrimaryContainer,
                    modifier = Modifier.align(Alignment.BottomCenter)
                        .padding(horizontal = Edge, vertical = 24.dp),
                )
            }
            Spacer(Modifier.height(24.dp))
            /* ── 412×316 容器：放致谢说明 ── */
            ContainerBox(316.dp, MaterialTheme.colorScheme.surfaceContainerHigh) {
                Column(
                    Modifier.fillMaxSize().padding(Edge).verticalScroll(rememberScrollState()),
                    verticalArrangement = Arrangement.spacedBy(6.dp),
                ) {
                    Text(
                        "致谢",
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                    )
                    listOf(
                        "尼得亚伯(DS驱动版)：所有的核心代码都是Ta写的",
                        "lsposed：提供了 hook 及注入",
                        "token：许多都被尼得亚伯当夜宵了",
                        "底栏液态玻璃（mmliquidglass 0.2.1）：液态玻璃的实现参考"
                                + "（StackBlur 糊底 + 折射 + 弹簧回弹）",
                        "Deekseep 模块 1.7.4 开源版：双层架构（UI 与 hook 分离）的参考",
                        "Haze（chrisbanes）：液态玻璃的坐标模型 / over 合成 / 色散 / GPU 管线参考",
                        "项目地址：https://github.com/chrisbanes/haze",
                        "Cloudy（skydoves）：距离场折射 + RGB 色散 + 四重镜面高光（本模块「Cloudy 式」方案）",
                        "项目地址：https://github.com/skydoves/Cloudy",
                        "AndroidLiquidGlass（Kyant0）：Modifier 级液态玻璃的思路参考",
                        "项目地址：https://github.com/Kyant0/AndroidLiquidGlass",
                        "liquid（FletchMcKee）：可液化修饰符 / 背景像素采样的思路参考",
                        "项目地址：https://github.com/FletchMcKee/liquid",
                        "liquid-glass（NadeemIqbal）：轻量折射 + 自动分级降级的思路参考",
                        "项目地址：https://github.com/NadeemIqbal/liquid-glass",
                        "m3e-canvas（本项目的 UI 设计/实现参考）",
                        "项目地址：https://github.com/lnkiai/m3e-canvas",
                        "■神：我也不知道怎么会有这个。",
                    ).forEach {
                        Text(
                            it,
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
            Spacer(Modifier.height(16.dp))
        }
    }
}

/* ═════════════════════════ 灰度工具箱（二级菜单示例） ═════════════════════════ */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GrayToolboxScreen(onBack: () -> Unit, onFeature: () -> Unit) {
    val ctx = LocalContext.current
    var option by remember { mutableStateOf(Prefs.toolboxOption(ctx)) }
    Scaffold(
        topBar = { FdmTopBar("灰度工具箱", onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(Modifier.fillMaxSize().padding(pad).padding(top = 8.dp)) {
            FdmListItem(
                title = "二级菜单示例",
                supporting = "这里是辅助文本",
                shape = groupedShape(0, 1),
                onClick = onFeature,
            )
            Spacer(Modifier.height(12.dp))
            FdmSwitchRow("选项", option) {
                option = it
                Prefs.setToolboxOption(ctx, it)   // 真实持久化，重启后仍在
            }
        }
    }
}

/* ═════════════════════════ 功能页（照原 UI 的树渲染） ═════════════════════════ */
@Composable
fun FeatureScreen(title: String, onNav: (String) -> Unit, onBack: () -> Unit) {
    TreePage(title, onNav, onBack)
}
