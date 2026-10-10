// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.clickable
import androidx.compose.ui.res.painterResource
import androidx.compose.material3.TextButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.AlertDialog
import androidx.compose.foundation.Image
import android.widget.Toast
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
    val ctx = LocalContext.current
    // ★ 3.67.0 彩蛋状态：连点计数 + 语言弹窗 + 当前说话方式（用 state 是为了让标语当场跟着变）
    var taps by remember { mutableIntStateOf(0) }
    var showLangPick by remember { mutableStateOf(false) }
    var lang by remember { mutableIntStateOf(Lang.current(ctx)) }
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
                // ★ 2026-10-10（3.67.0）彩蛋：这个方块换成尼尼的图，**连点 7 下**弹「说话方式」弹窗
                Box(
                    Modifier
                        .size(200.dp)
                        .align(Alignment.Center)
                        .clip(RoundedCornerShape(24.dp))
                        .clickable {
                            taps += 1
                            if (taps >= 7) {          // 连点七下（点了别处会由下面那句 Toast 之外的重置兜住）
                                taps = 0
                                showLangPick = true
                            }
                        },
                    contentAlignment = Alignment.Center,
                ) {
                    Image(
                        painter = painterResource(R.drawable.fdm_mascot),
                        contentDescription = "FDM",
                        modifier = Modifier.size(200.dp),
                    )
                }
                Text(
                    Lang.S.tagline(ctx),
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
                        // ★ 3.67.0：从「音乐」页搬过来的那条
                        "NeteaseCloudMusicApi（Binaryify，MIT）：音乐功能的接口与加密算法参考"
                                + "（本模块只用它的算法与接口约定，加密层用 Java 重写了一遍）",
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

    /* ★ 3.67.0 彩蛋：说话方式（人话 / 龙龙语） */
    if (showLangPick) {
        AlertDialog(
            onDismissRequest = { showLangPick = false },
            title = { Text("说话方式") },
            text = {
                Column {
                    Text(
                        "点这张图七下才出来的小彩蛋 —— 选一种说话方式：",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Spacer(Modifier.height(8.dp))
                    listOf(Lang.HUMAN to "人话", Lang.DRAGON to "龙龙语").forEach { (v, name) ->
                        Row(
                            Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(12.dp))
                                .clickable { lang = v }
                                .padding(vertical = 6.dp),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            RadioButton(selected = lang == v, onClick = { lang = v })
                            Spacer(Modifier.width(8.dp))
                            Column {
                                Text(
                                    name,
                                    style = MaterialTheme.typography.bodyLarge,
                                    color = MaterialTheme.colorScheme.onSurface,
                                )
                                Text(
                                    if (v == Lang.DRAGON) "尼尼的母语（嗷呜咕噜）" else "正经说话（默认）",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                )
                            }
                        }
                    }
                    Spacer(Modifier.height(6.dp))
                    Text(
                        "现在接进去的地方还不多（关于页标语 / 系统提示词页的空容器 / 帮助入口）—— 要加哪一句跟我说。",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    Lang.set(ctx, lang)
                    showLangPick = false
                    Toast.makeText(
                        ctx,
                        if (lang == Lang.DRAGON) "嗷呜～以后就这么说话咕" else "好，正经说话。",
                        Toast.LENGTH_SHORT,
                    ).show()
                }) { Text("确认") }
            },
            dismissButton = {
                TextButton(onClick = { showLangPick = false }) { Text("取消") }
            },
        )
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
