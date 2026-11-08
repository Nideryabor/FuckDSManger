// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
//
//  本地音乐 🐲 —— 2026-11-07
//
//  ═══════════════════════════════════════════════════════════════════════
//  ★★ 架构（三轮真机取证之后才定下来的，别再改回去）
//  ═══════════════════════════════════════════════════════════════════════
//
//  真机证明了两件事，都是**机制层面**的，不是配置问题：
//
//    ① 宿主清单里**没有 READ_MEDIA_AUDIO**（系统连「音乐和音频」权限项都不显示给它）
//       ⇒ 它按绝对路径读 /sdcard/xxx.mp3 一律
//          FileNotFoundException: open failed: EACCES (Permission denied)
//       ⇒ 所以「写死一个目录让宿主播」这条路**不可能通**，换目录也没用。
//
//    ② 我们自己的 provider 借 fd 也不行：
//       宿主 resolveContentProvider = null ⇒ "No content provider"
//       ⇒ 这是 **Android 11+ 包可见性**（跟 3.75.x「Compose UI 打不开」同一个坑）。
//
//  ⇒ 唯一活路：**宿主自己**用系统选择器授权一个文件夹（SAF），
//      ACTION_OPEN_DOCUMENT_TREE + FLAG_GRANT_READ/WRITE + takePersistableUriPermission
//      ⇒ 零权限、不碰 provider、重启还在。
//
//  ⚠️ 由此得出一个**必须记住的推论**：
//      那个授权记在**宿主的 uid** 上，本进程（UI）用不了它。
//      ⇒ 扫描 / 导入 / 生成提示词文本**全部在宿主做**；
//        这一页只负责：① 请它扫（local_list）② 显示 ③ 勾选发给它（local_sel）
//        ④ 请它拉起选目录/导入（local_pick_tree / local_import）。
//      这就是为什么这里**一个 File / MediaStore 扫描都没有** —— 
//      我们看得见宿主播不了，那种代码只会让人误判。
//
package com.nidyaber.fuckdsmanger

import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Checkbox
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.nidyaber.fuckdsmanger.bridge.FdmPush
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject

/** 本地曲库页需要的、**只跟本进程有关**的那点状态 🐲 */
object Lm {

    /** 「自动追加」开关的键 —— 存的是**反面**（没写过 = false = 开），跟 GmMusicDj 同一套结论 */
    const val K_AUTO_OFF = "cfg.fuckds_localmusic_auto_off"
    /** 勾选表（序号数组；空 = 全选） */
    private const val K_SEL = "cfg.fuckds_localmusic_sel"

    fun autoOn(ctx: android.content.Context): Boolean =
        !Bridge.boolOf(FdmPush.sp(ctx).getString(K_AUTO_OFF, null))

    /** 读勾选（序号）。空集 = 全选 —— 跟宿主那边同一套语义。 */
    fun readSel(ctx: android.content.Context): Set<Int> {
        val raw = FdmPush.sp(ctx).getString(K_SEL, null) ?: return emptySet()
        val out = HashSet<Int>()
        try {
            val a = JSONArray(raw)
            for (i in 0 until a.length()) out.add(a.optInt(i, 0))
        } catch (t: Throwable) {
            android.util.Log.e("FDM-LM", "勾选表坏了，当全选处理", t)
            return emptySet()
        }
        return out
    }

    fun writeSel(ctx: android.content.Context, sel: Set<Int>) {
        val a = JSONArray()
        sel.sorted().forEach { a.put(it) }
        FdmPush.sp(ctx).edit().putString(K_SEL, a.toString()).apply()
    }
}

private fun fmtMs(ms: Int): String {
    if (ms <= 0) return ""
    val s = ms / 1000
    return "%d:%02d".format(s / 60, s % 60)
}

/**
 * 有效勾选 = 勾选表 ∩ 当前列表里的序号。
 *
 * <p>⚠️ 为什么需要它：勾选表是按**序号**记的，而曲库会变（删歌/换目录/重扫），
 * 残留序号会让页面显示「共 2 首 · 已勾选 3」这种自相矛盾的数字。
 * 空集仍然表示"全选"（那是我们要的默认语义）。
 */
private fun effectiveSel(list: List<JSONObject>, sel: Set<Int>): Set<Int> {
    if (sel.isEmpty()) return list.map { it.optInt("n", 0) }.toSet()
    val live = list.map { it.optInt("n", 0) }.toSet()
    return sel.filter { live.contains(it) }.toSet()
}

/** 把勾选集合编成 JSON 数组送给宿主。 */
private fun selJson(sel: Set<Int>): String {
    val a = JSONArray()
    sel.sorted().forEach { a.put(it) }
    return a.toString()
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LocalMusicPage(onBack: () -> Unit) {
    val ctx = LocalContext.current
    val scope = rememberCoroutineScope()
    val sp = remember { FdmPush.sp(ctx) }

    /** 宿主扫出来的曲库（n / name / artist / dur）。来源 = `cmd.local_list` */
    var list by remember { mutableStateOf<List<JSONObject>>(emptyList()) }
    /** 勾选的序号（空 = 全选） */
    var sel by remember { mutableStateOf(Lm.readSel(ctx)) }
    var busy by remember { mutableStateOf(false) }
    var note by remember { mutableStateOf("") }
    var autoOn by remember { mutableStateOf(Lm.autoOn(ctx)) }
    var tick by remember { mutableIntStateOf(0) }
    /** 宿主回报的「当前授权目录」（人话版） */
    var treeText by remember { mutableStateOf("") }
    /** 正在编辑哪一首（null = 没开单曲设置） */
    var editing by remember { mutableStateOf<JSONObject?>(null) }

    /** 请宿主扫一遍，然后把它回传的 JSON 读出来。 */
    fun pull() {
        scope.launch {
            busy = true
            // ★ 先问「当前授权的目录是哪个」——避免"选了个空目录却以为程序坏了"
            FdmPush.sendCmd(ctx, "local_tree", null)
            FdmPush.sendCmd(ctx, "local_list", null)
            delay(900)                       // 宿主扫目录是 IO，给它一点时间
            treeText = sp.getString("cmd.local_tree", "") ?: ""
            val raw = sp.getString("cmd.local_list", "[]") ?: "[]"
            val arr = try {
                JSONArray(raw)
            } catch (t: Throwable) {
                JSONArray()
            }
            val out = ArrayList<JSONObject>()
            for (i in 0 until arr.length()) {
                arr.optJSONObject(i)?.let { out.add(it) }
            }
            list = out
            busy = false
            tick++
            if (out.isEmpty()) {
                note = ctx.getString(R.string.lm_035)
            }
        }
    }

    LaunchedEffect(Unit) { pull() }

    /** 勾选变化 → 本地记住 + 告诉宿主（宿主据此重算提示词文本）。 */
    fun pushSel(next: Set<Int>) {
        sel = next
        Lm.writeSel(ctx, next)
        FdmPush.sendCmd(ctx, "local_sel", selJson(next))
        tick++
    }

    Scaffold(
        topBar = { FdmTopBar(stringResource(R.string.lm_001), onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier
                .padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(bottom = 24.dp),
        ) {
            Spacer(Modifier.height(10.dp))

            // ───────── 曲库目录（用户授权）─────────
            SectionLabel(stringResource(R.string.lm_002))
            CardBox {
                Text(
                    stringResource(R.string.lm_037),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                )
                if (treeText.isNotBlank()) {
                    Spacer(Modifier.height(4.dp))
                    Text(
                        treeText,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.primary,
                    )
                }
                Spacer(Modifier.height(4.dp))
                Text(
                    stringResource(R.string.lm_003),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(10.dp))
                // ★★★ 2026-11-08（主人要求）：「选文件夹」**从这儿删掉** ——
                //   它和首页那张「宿主文件夹授权」卡完全重复（两处都能拉同一个选择器，
                //   用户会疑惑"到底该点哪个"）。
                //
                //   首页那张卡是**唯一入口**（它管着音乐曲库 + 图片预览 + 导出入三件事，
                //   放首页才合理）。这里只显示状态，没授权时给一句指路。
                if (treeText.isBlank()) {
                    Text(
                        stringResource(R.string.lm_045),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.error,
                    )
                } else {
                    Text(
                        stringResource(R.string.lm_046),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                Spacer(Modifier.height(10.dp))
                Text(
                    stringResource(R.string.lm_004) + list.size +
                        stringResource(R.string.lm_006) + effectiveSel(list, sel).size,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                if (note.isNotEmpty()) {
                    Spacer(Modifier.height(6.dp))
                    Text(
                        note,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.primary,
                    )
                }
                Spacer(Modifier.height(10.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Button(onClick = { pull() }, enabled = !busy) {
                        Text(
                            if (busy) stringResource(R.string.lm_007)
                            else stringResource(R.string.lm_008)
                        )
                    }
                    OutlinedButton(onClick = {
                        // ★ 导入也必须让**宿主**拉起：回调的临时读权限挂在发起者 uid 上，
                        //   我们这边选完文件，宿主照样读不到（旧方案就是这么废掉的）。
                        FdmPush.sendCmd(ctx, "local_import", null)
                        note = ctx.getString(R.string.lm_036)
                    }, enabled = !busy) {
                        Text(stringResource(R.string.lm_009))
                    }
                }
                if (list.isEmpty() && !busy) {
                    Spacer(Modifier.height(8.dp))
                    Text(
                        stringResource(R.string.lm_010) + stringResource(R.string.lm_011),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }

            // ───────── 提示词 ─────────
            SectionLabel(stringResource(R.string.lm_012))
            CardBox {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            stringResource(R.string.lm_013),
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        Text(
                            stringResource(R.string.lm_014) + stringResource(R.string.lm_015),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Switch(
                        checked = autoOn,
                        onCheckedChange = { v ->
                            autoOn = v
                            // 存反面（没写过 = 开）：跟 GmMusicDj 同一套踩坑结论
                            sp.edit().putString(Lm.K_AUTO_OFF, Bridge.boolStr(!v)).apply()
                            FdmPush.push(ctx)
                            FdmPush.sendCmd(ctx, "local_sel", selJson(sel))
                        },
                    )
                }
                Spacer(Modifier.height(8.dp))
                Text(
                    stringResource(R.string.lm_016) + "\n" + stringResource(R.string.lm_017),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 曲库列表 ─────────
            SectionLabel(stringResource(R.string.lm_018))
            CardBox {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.lm_019) +
                            effectiveSel(list, sel).size + " / " + list.size,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.weight(1f),
                    )
                    OutlinedButton(onClick = {
                        pushSel(emptySet())        // 空集 = 全选（与宿主同一套语义）
                    }) { Text(stringResource(R.string.lm_020)) }
                    Spacer(Modifier.padding(horizontal = 4.dp))
                    OutlinedButton(onClick = {
                        // 「全不选」用一个不会命中的序号(-1) ⇒ 宿主那边就是"一个都不勾"
                        pushSel(setOf(-1))
                    }) { Text(stringResource(R.string.lm_021)) }
                }
                Spacer(Modifier.height(6.dp))
                if (list.isEmpty()) {
                    Text(
                        stringResource(R.string.lm_022),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                // ⚠️ 不用 LazyColumn：外层已经是 verticalScroll 的 Column，
                //    同方向嵌套滚动容器会抢手势（Compose 里会直接崩）。
                list.forEach { o ->
                    val no = o.optInt("n", 0)
                    val checked = sel.isEmpty() || sel.contains(no)
                    val name = o.optString("name", "")
                    val artist = o.optString("artist", "")
                    val dur = o.optInt("dur", 0)
                    Row(
                        Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            // ★ 2026-11-07 · 主人要求：**只有点勾选框**才改提示词勾选；
                            //   点条目本身 = 打开这首歌的「单曲设置」（歌词/封面在哪）。
                            .clickable { editing = o }
                            .padding(vertical = 6.dp),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        // 复选框自己接管点击（点它只切换勾选，不打开设置）
                        Checkbox(
                            checked = checked,
                            onCheckedChange = {
                                val base = if (sel.isEmpty()) {
                                    list.map { it.optInt("n", 0) }.toSet()
                                } else sel
                                pushSel(if (checked) base - no else base + no)
                            },
                        )
                        Column(Modifier.weight(1f)) {
                            Text(
                                name,
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurface,
                            )
                            Text(
                                (if (artist.isBlank()) stringResource(R.string.lm_023) else artist) +
                                    (if (dur > 0) "　·　" + fmtMs(dur) else ""),
                                style = MaterialTheme.typography.labelSmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                        Text(
                            // ★ 序号 = 宿主扫出来的 n，跟 [[LOCAL:N]] 用的是同一套
                            if (checked) "#$no" else "",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.primary,
                        )
                    }
                }
            }

            // ★ 2026-11-08（主人要求）：署名卡 —— 本功能是网友提的思路，尼尼照着做的
            Spacer(Modifier.height(18.dp))
            CardBox {
                Text(
                    stringResource(R.string.lm_047),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }

    // ───────── 单曲设置（点列表条目打开）─────────
    //
    //  ★ 2026-11-07 · 主人要的：「点列表对应项目打开对应歌曲单独设置（歌词文件在哪里，封面在哪里）」
    editing?.let { o ->
        val no = o.optInt("n", 0)
        SingleSongDialog(
            no = no,
            name = o.optString("name", ""),
            artist = o.optString("artist", ""),
            onSetLrc = {
                FdmPush.sendCmd(ctx, "local_pick_lrc", no.toString())
                note = ctx.getString(R.string.lm_040)
            },
            onSetCover = {
                FdmPush.sendCmd(ctx, "local_pick_cover", no.toString())
                note = ctx.getString(R.string.lm_041)
            },
            onReset = {
                // 清掉手动指定 ⇒ 回到「同名自动配对」
                FdmPush.sendCmd(ctx, "local_set_lrc", "$no|")
                FdmPush.sendCmd(ctx, "local_set_cover", "$no|")
                note = ctx.getString(R.string.lm_042)
            },
            onDismiss = { editing = null },
        )
    }
}

/**
 * 单曲设置弹窗：**只负责改变更哪一份文件**，真正的挑选交给宿主拉起系统选择器。
 *
 * <p>为什么挑文件不能让 UI 自己做：SAF 的临时/持久授权记在**发起者 uid** 上，
 * 我们拉起选择器选完的文件，宿主（播放器所在进程）依旧读不到。
 */
@Composable
private fun SingleSongDialog(
    no: Int,
    name: String,
    artist: String,
    onSetLrc: () -> Unit,
    onSetCover: () -> Unit,
    onReset: () -> Unit,
    onDismiss: () -> Unit,
) {
    androidx.compose.material3.AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                "#$no  " + name + (if (artist.isBlank()) "" else " · $artist"),
                style = MaterialTheme.typography.titleMedium,
            )
        },
        text = {
            Column {
                Text(
                    stringResource(R.string.lm_043),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Spacer(Modifier.height(10.dp))
                OutlinedButton(
                    onClick = onSetLrc,
                    modifier = Modifier.fillMaxWidth(),
                ) { Text(stringResource(R.string.lm_044)) }
                Spacer(Modifier.height(8.dp))
                OutlinedButton(
                    onClick = onSetCover,
                    modifier = Modifier.fillMaxWidth(),
                ) { Text(stringResource(R.string.lm_045)) }
                Spacer(Modifier.height(8.dp))
                OutlinedButton(
                    onClick = onReset,
                    modifier = Modifier.fillMaxWidth(),
                ) { Text(stringResource(R.string.lm_046)) }
            }
        },
        confirmButton = {
            androidx.compose.material3.TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.c_back))
            }
        },
    )
}
