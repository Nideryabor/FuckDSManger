// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
//
//  音乐页 🐲 —— 2026-10-06 改版：**只当「开关 / 入口」**
//
//  为什么变这么薄：主人拍板「播放交给宿主」⇒ 播放器搬进了 DeepSeek 进程
//  （`bridge/GmMusicPlayer.java`），**界面全在宿主的悬浮卡上**（播放页 + 搜索页）。
//  这一页只剩：① 迷你卡开关 ② 看一眼状态 ③ 几个遥控按钮 ④ 说明与致谢。
//
//  ⚠️ 版权：音频只流式播放、封面与歌词只放内存 —— 一律不落盘（见 GmMusicPlayer 文件头）。
//  搜索走宿主：宿主自己有网络，搜索结果直接显示在悬浮卡上。
package com.nidyaber.fuckdsmanger

import androidx.compose.ui.res.stringResource
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Icon
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ChevronRight
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.nidyaber.fuckdsmanger.bridge.FdmPush
import kotlinx.coroutines.delay
import org.json.JSONObject

@Composable
internal fun CardBox(content: @Composable () -> Unit) {
    Column(
        Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(28.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .padding(horizontal = Edge, vertical = 12.dp),
    ) { content() }
}

private fun fmtMs(ms: Int): String {
    if (ms <= 0) return "0:00"
    val s = ms / 1000
    return "%d:%02d".format(s / 60, s % 60)
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MusicPage(onNav: (String) -> Unit, onBack: () -> Unit) {
    val ctx = LocalContext.current
    val sp = remember { FdmPush.sp(ctx) }

    // 迷你卡开关（走宿主自己的入口 GmMiniBar.setOn）
    // ★ 2026-10-06：**新格式优先**（`cfg.<key>`）—— 以前这里读新格式、写旧格式，
    //   两边不一致 ⇒ 重启 UI 后开关显示会和实际不符。
    var barOn by remember {
        mutableStateOf(
            Bridge.boolOf(
                sp.getString("cfg.fuckds_bar_on", null)
                    ?: sp.getString("fuckds_bar_on", null)
            )
        )
    }
    var tick by remember { mutableIntStateOf(0) }
    // ★ 2026-10-10（3.66.0）：「功能原理 & 帮助」子框的状态
    var helpTopic by remember { mutableStateOf<String?>(null) }

    // ★ 3.57.1 · 提示词音乐变量的两个开关（读法同 barOn：新格式 `cfg.<key>` 优先）
    var pvarOn by remember {
        mutableStateOf(
            Bridge.boolOf(
                sp.getString("cfg.fuckds_pvar_on", null)
                    ?: sp.getString("fuckds_pvar_on", null)
            )
        )
    }
    var lyricOn by remember {
        mutableStateOf(
            Bridge.boolOf(
                sp.getString("cfg.fuckds_pvar_lyric", null)
                    ?: sp.getString("fuckds_pvar_lyric", null)
            )
        )
    }

    // 定时问宿主要状态（宿主回 cmd.cfg_state）
    LaunchedEffect(tick) {
        FdmPush.sendCmd(ctx, "cfg_state", null)
        delay(1200)
        tick++
    }

    val st: JSONObject = remember(tick) {
        try {
            JSONObject(sp.getString("cmd.cfg_state", "{}") ?: "{}")
        } catch (t: Throwable) {
            JSONObject()
        }
    }
    val name = st.optString("music_name", "")
    val artist = st.optString("music_artist", "")
    val playing = st.optBoolean("music_playing", false)
    val pos = st.optInt("music_pos", 0)
    val dur = st.optInt("music_dur", 0)
    val queue = st.optInt("music_queue", 0)

    Scaffold(
        topBar = { FdmTopBar(stringResource(R.string.mus_001), onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier
                .padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(bottom = 24.dp),
        ) {
            // ★ 2026-10-10（3.65.0）：「猜你想跳转」—— 音乐页顶上给一条去系统提示词的路
            JumpHintCard(onOpen = { onNav("sysprompt_v2") }, text = stringResource(R.string.mus_002))
            Spacer(Modifier.height(10.dp))

            // ───────── 迷你卡开关 ─────────
            SectionLabel(stringResource(R.string.mus_003))
            CardBox {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            stringResource(R.string.mus_004),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            stringResource(R.string.mus_005) +
                            stringResource(R.string.mus_006),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Switch(
                        checked = barOn,
                        onCheckedChange = { v ->
                            barOn = v
                            // ★ 走宿主自己的入口（拨一下当场显示/收起）
                            FdmPush.sendCmd(ctx, "cfg_put", "fuckds_bar_on\u001fb\u001f$v")
                            // ★ 本地也存**新格式**（跟界面读法一致；旧格式顶层键交给桥的自愈去清）
                            FdmPush.sp(ctx).edit().putString("cfg.fuckds_bar_on", Bridge.boolStr(v)).apply()
                            tick++
                        },
                    )
                }
                // ★ 2026-10-10（3.64.0）：迷你条的**详细设置**收到这儿来
                //   （原来挂在「美化 › 悬浮全家桶」里 —— 两处都能开它，冲突；
                //    现在它是音乐功能的亲儿子，设置也就近放）
                Spacer(Modifier.height(6.dp))
                Row(
                    Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .clickable { onNav("bar") }
                        .padding(vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            stringResource(R.string.mus_007),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            stringResource(R.string.mus_008),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Icon(
                        Icons.Rounded.ChevronRight, stringResource(R.string.mus_009),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }

            // ───────── 当前状态 ─────────
            SectionLabel(stringResource(R.string.mus_010))
            CardBox {                Text(
                    if (name.isEmpty()) stringResource(R.string.mus_011) else name,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onSurface,
                )
                Text(
                    if (name.isEmpty()) stringResource(R.string.mus_012)
                    else artist + "　·　" + fmtMs(pos) + " / " + fmtMs(dur) + stringResource(R.string.mus_013) + queue,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(10.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Ctrl("◀◀") { FdmPush.sendCmd(ctx, "music_prev", null) }
                    Ctrl(if (playing) "❚❚" else "▶") { FdmPush.sendCmd(ctx, "music_toggle", null) }
                    Ctrl("▶▶") { FdmPush.sendCmd(ctx, "music_next", null) }
                    Ctrl("↻") { FdmPush.sendCmd(ctx, "music_loop", null) }
                }
                Spacer(Modifier.height(4.dp))
                Text(
                    stringResource(R.string.mus_014),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 登录 ─────────
            SectionLabel(stringResource(R.string.mus_015))
            CardBox {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            if (st.optBoolean("music_logged", false))
                                stringResource(R.string.mus_016) + st.optString("music_user", "")
                            else stringResource(R.string.mus_017),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            stringResource(R.string.mus_018),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Button(onClick = { onNav("musiclogin") }) { Text(stringResource(R.string.mus_019)) }
                }
            }

            // ───────── 音源（伪装成哪种客户端）─────────
            SectionLabel(stringResource(R.string.mus_020))
            CardBox {
                Text(
                    stringResource(R.string.mus_021) +
                    stringResource(R.string.mus_022),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(8.dp))
                val osMode = st.optInt("music_os_mode", 2)
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf("iPhone" to 2, "Android" to 1, "PC" to 0).forEach { (label, m) ->
                        OsTab(label, osMode == m) {
                            FdmPush.sendCmd(ctx, "music_os_mode", m)
                            FdmPush.set(ctx, "fuckds_music_os", m)
                            tick++
                        }
                    }
                }
                Spacer(Modifier.height(6.dp))
                Text(
                    stringResource(R.string.mus_023),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 提示词音乐变量（2026-10-07 · 3.57.0；3.57.1 从「系统提示词」页搬过来）─────────
            //
            //  ★ 主人 2026-10-07：「音乐相关的不用管在系统提示词，应该在音乐板块」
            //    它是音乐功能 —— 主人找它的时候，脑子在「音乐」，手不该去「系统提示词」。
            //
            //  ★★ 同一版还修了一个**真漏洞**（主人指出）：
            //    「系统提示词里面写没有播放就是没在放歌，但是如果我放歌把总开关关掉了呢」
            //    ⇒ 「变量为空」至少有三种原因（开关关着 / 真没在放歌 / 歌词开关关着），
            //      而模型看到的只是"空"。第一版示例还写了「没在放歌时两行整体消失」
            //      ＝ 我们替模型做了一个可能不准的断言。修法见下（不写断言 + {music_or_none}）。
            SectionLabel(stringResource(R.string.mus_024))
            CardBox {
                Text(
                    stringResource(R.string.mus_025) +
                    stringResource(R.string.mus_026) +
                    stringResource(R.string.mus_027) +
                    stringResource(R.string.mus_028) +
                    "· {song}  {artist}  {album}\n" +
                    stringResource(R.string.mus_029) +
                    "· {music_state}   playing / paused\n" +
                    stringResource(R.string.mus_030),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(8.dp))
                Text(
                    stringResource(R.string.mus_031) +
                    stringResource(R.string.mus_032) +
                    stringResource(R.string.mus_033) +
                    stringResource(R.string.mus_034) +
                    stringResource(R.string.mus_035) +
                    stringResource(R.string.mus_036) +
                    stringResource(R.string.mus_037),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(12.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            stringResource(R.string.mus_038),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            stringResource(R.string.mus_039) +
                            stringResource(R.string.mus_040),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Switch(
                        checked = pvarOn,
                        onCheckedChange = { v ->
                            pvarOn = v
                            FdmPush.sendCmd(ctx, "cfg_put", "fuckds_pvar_on\u001fb\u001f$v")
                            FdmPush.sp(ctx).edit().putString("cfg.fuckds_pvar_on", Bridge.boolStr(v)).apply()
                            tick++
                        },
                    )
                }
                Spacer(Modifier.height(10.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            stringResource(R.string.mus_041),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            stringResource(R.string.mus_042) +
                            stringResource(R.string.mus_043) +
                            stringResource(R.string.mus_044) +
                            stringResource(R.string.mus_045),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Switch(
                        checked = lyricOn,
                        onCheckedChange = { v ->
                            lyricOn = v
                            FdmPush.sendCmd(ctx, "cfg_put", "fuckds_pvar_lyric\u001fb\u001f$v")
                            FdmPush.sp(ctx).edit().putString("cfg.fuckds_pvar_lyric", Bridge.boolStr(v)).apply()
                            tick++
                        },
                    )
                }
                Spacer(Modifier.height(12.dp))
                // ★ 2026-10-10（3.66.0）：这段说明**过时了**（还写着"调试 › 系统提示词 v2"）
                //   ⇒ 整段搬进页面末尾的「功能原理 & 帮助」，这里只留一行指路。
                Text(
                    stringResource(R.string.mus_046),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 说明 ─────────
            SectionLabel(stringResource(R.string.mus_047))
            CardBox {
                Text(
                    stringResource(R.string.mus_048) +
                    stringResource(R.string.mus_049) +
                    stringResource(R.string.mus_050),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 版权 ─────────
            SectionLabel(stringResource(R.string.mus_051))
            CardBox {
                Text(
                    stringResource(R.string.mus_052) +
                    stringResource(R.string.mus_053) +
                    stringResource(R.string.mus_054) +
                    stringResource(R.string.mus_055) +
                    stringResource(R.string.mus_056),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 致谢 ─────────
            //  ★ 2026-10-10（3.67.0）：主人「音乐菜单不是有个致谢吗，搬到关于页面里面」
            //    ⇒ 内容搬到「关于 › 致谢」，这里留一行指路。
            Text(
                stringResource(R.string.mus_057),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )

            // ★ 2026-10-10（3.66.0）：页面**末尾**的「功能原理 & 帮助」入口
            Spacer(Modifier.height(16.dp))
            HelpEntry(label = Lang.S.helpEntry(ctx)) { helpTopic = "music" }
        }
    }

    // 帮助子框（Compose 弹窗）
    helpTopic?.let { tp -> HelpDialog(tp) { helpTopic = null } }
}

@Composable
private fun OsTab(label: String, on: Boolean, onClick: () -> Unit) {
    Box(
        Modifier
            .clip(RoundedCornerShape(20.dp))
            .background(
                if (on) MaterialTheme.colorScheme.primaryContainer
                else MaterialTheme.colorScheme.surfaceContainerHigh
            )
            .clickable { onClick() }
            .padding(horizontal = 16.dp, vertical = 8.dp),
    ) {
        Text(
            label,
            style = MaterialTheme.typography.labelLarge,
            color = if (on) MaterialTheme.colorScheme.onPrimaryContainer
            else MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

@Composable
private fun Ctrl(label: String, onClick: () -> Unit) {
    Box(
        Modifier
            .size(44.dp)
            .clip(RoundedCornerShape(22.dp))
            .background(MaterialTheme.colorScheme.primaryContainer)
            .clickable { onClick() },
        contentAlignment = Alignment.Center,
    ) {
        Text(label, color = MaterialTheme.colorScheme.onPrimaryContainer, fontSize = 15.sp)
    }
}
