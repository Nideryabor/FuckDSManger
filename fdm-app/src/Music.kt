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
            (sp.getString("cfg.fuckds_bar_on", null)
                ?: sp.getString("fuckds_bar_on", "false")) == "true"
        )
    }
    var tick by remember { mutableIntStateOf(0) }

    // ★ 3.57.1 · 提示词音乐变量的两个开关（读法同 barOn：新格式 `cfg.<key>` 优先）
    var pvarOn by remember {
        mutableStateOf(
            (sp.getString("cfg.fuckds_pvar_on", null)
                ?: sp.getString("fuckds_pvar_on", "false")) == "true"
        )
    }
    var lyricOn by remember {
        mutableStateOf(
            (sp.getString("cfg.fuckds_pvar_lyric", null)
                ?: sp.getString("fuckds_pvar_lyric", "false")) == "true"
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
        topBar = { FdmTopBar("音乐", onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier
                .padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(bottom = 24.dp),
        ) {
            // ───────── 迷你卡开关 ─────────
            SectionLabel("悬浮迷你卡")
            CardBox {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            "在宿主上常驻一张播放卡",
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            "卡片上就是全部界面：封面 · 曲名&歌手 · 歌词 · 进度条 · 控件；" +
                            "点 ♪ 还能搜歌。开关一开，每个页面都挂着它。",
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
                            FdmPush.sp(ctx).edit().putString("cfg.fuckds_bar_on", v.toString()).apply()
                            tick++
                        },
                    )
                }
            }

            // ───────── 当前状态 ─────────
            SectionLabel("宿主里正在放")
            CardBox {                Text(
                    if (name.isEmpty()) "还没选歌" else name,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onSurface,
                )
                Text(
                    if (name.isEmpty()) "去宿主里点卡片上的 ♪ 搜一首"
                    else artist + "　·　" + fmtMs(pos) + " / " + fmtMs(dur) + "　·　队列 " + queue,
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
                    "这几个按钮也能用（走宿主进程里的播放器）；不过平时在宿主里直接点卡片更顺手。",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 登录 ─────────
            SectionLabel("网易云账号")
            CardBox {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            if (st.optBoolean("music_logged", false))
                                "✅ 已登录 " + st.optString("music_user", "")
                            else "未登录",
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            "不登录也能听 320k；登录后才能听会员曲 / 无损。",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Button(onClick = { onNav("musiclogin") }) { Text("登录") }
                }
            }

            // ───────── 音源（伪装成哪种客户端）─────────
            SectionLabel("音源伪装")
            CardBox {
                Text(
                    "有些歌对「客户端」比对「网页」更宽松。这里可以换一种身份去请求。\n" +
                    "⚠️ 尼尼原来写的是 os=pc + UA=iPhone（**自相矛盾**），现已改成三档一致。",
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
                    "换完要**重新点一下那首歌**才会用新身份去取地址（正在放的不会自动切）。",
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
            SectionLabel("提示词音乐变量")
            CardBox {
                Text(
                    "让 AI 知道你在听什么。提示词里写这些占位符，会在**发消息那一刻**" +
                    "替换成真值（所以歌词行、进度天然是实时的）：\n" +
                    "· {music}           《歌名》 - 歌手 (1:23/3:42)\n" +
                    "· {music_or_none}  ★ 同上，但**没在听**时明确写「没有在听歌」\n" +
                    "· {song}  {artist}  {album}\n" +
                    "· {music_pos}  {music_dur}  {music_left}   已听 / 总长 / 剩余\n" +
                    "· {music_state}   playing / paused\n" +
                    "· {lyric}  {lyric_prev}  {lyric_next}   当前这一句 / 上一句 / 下一句",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(8.dp))
                Text(
                    "⚠️ 「空」不等於「没在放歌」——空有三种原因：\n" +
                    "① 总开关关着　② 真没在放歌　③ 歌词开关关着 / 歌词还没缓存到。\n" +
                    "所以本页**不替你做任何「空 = 没在听」的断言**，两种需求各给一个工具：\n" +
                    "· 想「没在听就整句别出现」⇒ 用 [[ ]] 把整行包起来：\n" +
                    "    [[正在听：{music}]]   ← 变量全空时整行（连 [[ ]]）一起删掉\n" +
                    "· 想「让模型知道我没在听」⇒ 用 {music_or_none}：\n" +
                    "    它只在【开关开着但真没在听】时写「没有在听歌」；开关关着时它也是空。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(12.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            "音乐变量",
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            "总开关。关着时所有变量都替换成**空串** —— 绝不会把裸 {music} 发给模型。" +
                            "开着之后，只要提示词里有音乐变量，注入就强制「每轮」（忽略系统提示词页的注入模式）。",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Switch(
                        checked = pvarOn,
                        onCheckedChange = { v ->
                            pvarOn = v
                            FdmPush.sendCmd(ctx, "cfg_put", "fuckds_pvar_on\u001fb\u001f$v")
                            FdmPush.sp(ctx).edit().putString("cfg.fuckds_pvar_on", v.toString()).apply()
                            tick++
                        },
                    )
                }
                Spacer(Modifier.height(10.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            "允许歌词变量（⚠️ 版权）",
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            "默认关。开启后 {lyric} 系列才生效。\n" +
                            "⚠️ 歌名/歌手/专辑是事实性信息；歌词是作品。项目对歌词的铁律是「只放内存」，" +
                            "但那是**显示给自己看** —— 开启本项意味着歌词行会**随提示词上传给服务器、" +
                            "并留在对话历史里**，性质完全不同。",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Switch(
                        checked = lyricOn,
                        onCheckedChange = { v ->
                            lyricOn = v
                            FdmPush.sendCmd(ctx, "cfg_put", "fuckds_pvar_lyric\u001fb\u001f$v")
                            FdmPush.sp(ctx).edit().putString("cfg.fuckds_pvar_lyric", v.toString()).apply()
                            tick++
                        },
                    )
                }
                Spacer(Modifier.height(12.dp))
                Button(onClick = { FdmPush.sendCmd(ctx, "pvar_spec", null) }) {
                    Text("① 把示例写进系统提示词")
                }
                Spacer(Modifier.height(6.dp))
                Text(
                    "▲ 点它会把上面那两行 [[ … ]] 示例写进「系统提示词」（在「聊天 › 系统提示词」里能看到）。\n" +
                    "★ 它是**更新语义**：重复点不会叠加，而且会把旧版本的示例**换成新版**" +
                    "（你自己写的内容一个字都不动）。\n" +
                    "⚠️ 灌完记得把上面的「音乐变量」开关打开，否则变量一律变成空串。",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 说明 ─────────
            SectionLabel("说明")
            CardBox {
                Text(
                    "· 播放器跑在**宿主进程**里 ⇒ 从最近任务里把模块划掉，音乐不会断。\n" +
                    "· 代价：划掉 DeepSeek 就停；也**没有通知栏播放控制**（宿主清单改不了，声明不了前台服务）。\n" +
                    "· 想安静地听：把迷你卡拖到角落、或者在卡片上按 ✕ 收起（拨一下开关就回来）。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 版权 ─────────
            SectionLabel("版权")
            CardBox {
                Text(
                    "本功能**只做在线播放**：\n" +
                    "· 音频：流式播放网易云 CDN 给的链接，**不下载、不落盘**\n" +
                    "· 封面 / 歌词：由宿主自己联网取回，**只放在内存**，退出即消失\n" +
                    "· 状态文件 `files/FDMmusic/state.json` 里只有事实性信息（歌名 / 歌手 / 进度 / 播放态）\n" +
                    "听歌本身仍受网易云的版权约束，请勿用于转载或再分发。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 致谢 ─────────
            SectionLabel("致谢")
            CardBox {
                Text(
                    "接口与加密算法来自 NeteaseCloudMusicApi" +
                    "（作者 Binaryify，MIT 许可）。\n" +
                    "本模块只用它的算法与接口约定，把加密层用 Java 重新实现了一遍 —— " +
                    "原项目是 Node.js 服务，塞不进 Xposed 模块。\n" +
                    "感谢原作者与所有贡献者 🐲",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }
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
