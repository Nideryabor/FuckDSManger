// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.AdminPanelSettings
import androidx.compose.material.icons.rounded.Build
import androidx.compose.material.icons.rounded.EditNote
import androidx.compose.material.icons.rounded.Mood
import androidx.compose.material.icons.rounded.MusicNote
import androidx.compose.material.icons.rounded.Sms
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.nidyaber.fuckdsmanger.bridge.FdmPush
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * 界面渲染器 🐲 —— 照 `Tree`（= 原模块 smali UI 的规格）渲染。
 *
 * 三种值分清楚：
 *   · **本机设**：我们请求过的（`fdm_ui`）
 *   · **宿主真值**：宿主回读广播回来的
 *   · **动作结果**：宿主执行动作后回传的一句话（`last_result`）
 */

/**
 * 交接图片的中转目录：**公共的 Pictures 下** ✅
 * · 不用知道宿主包名（它换包名也不炸 ✅ —— 主人特意提的 ✗）
 * · 我们写：有 MANAGE_EXTERNAL_STORAGE ✅；宿主读：那是媒体目录，它有相册权限 ✅
 */
private val IMG_DIR = java.io.File("/sdcard/Pictures/FDM")
private const val TAG = "FDM-UI"

private fun ctxSp(ctx: Context) = FdmPush.sp(ctx)

/** 读一张图 → 缩到 maxPx → PNG（保留透明）→ base64。任何一步失败返回 null。 */
private fun readScaledBase64(ctx: Context, uri: Uri, maxPx: Int = 384): String? {
    val ins = ctx.contentResolver.openInputStream(uri) ?: return null
    val bmp = android.graphics.BitmapFactory.decodeStream(ins)
    ins.close()
    if (bmp == null) return null
    val big = maxOf(bmp.width, bmp.height)
    val out = if (big > maxPx) {
        val k = maxPx.toFloat() / big
        android.graphics.Bitmap.createScaledBitmap(
            bmp, (bmp.width * k).toInt().coerceAtLeast(1),
            (bmp.height * k).toInt().coerceAtLeast(1), true)
    } else bmp
    val baos = java.io.ByteArrayOutputStream()
    out.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, baos)
    return android.util.Base64.encodeToString(baos.toByteArray(), android.util.Base64.NO_WRAP)
}

/**
 * 读一个配置项的当前值 🐲
 *
 * <p>★ 2026-10-01 修：「**液态玻璃总是自动变回 Haze**」的真因 ——
 * 界面**写的是新格式 `cfg.<key>`、读的却是旧格式顶层键**，两套对不上 ⇒
 * 读不到就走默认值 ⇒ 显示成 Haze（**而宿主那边一直是对的**，日志 `engine=1`，被界面骗了）。
 *
 * <p>⇒ 规则改成：**新格式优先（`cfg.<key>`）**，读不到再退回旧格式顶层键。
 * 旧格式只当兜底，不再作为主路径。
 */
private fun readValue(ctx: Context, row: It): Any {
    val key = row.key ?: return ""
    // ① 新格式：cfg.<key>（一律存成字符串，按行的类型转回来）
    val raw = ctxSp(ctx).getString("cfg.$key", null)
    // ★ 2026-10-03：**文本项允许"空"是一个有效值** ——
    //   典型场景：包装前缀/后缀被主人**故意清空**（= 不加包装）。
    //   原来一律要求 `raw.isNotEmpty()` ⇒ 清空后判为"没设置" ⇒ 又回落到默认值显示，
    //   界面看到的是默认文案、实际注入的却是空 ⇒ 读写不一致，人会以为没清掉。
    //   非文本类仍保持原样（它们的空值确实等于"没设置"）。
    val hasLocal = ctxSp(ctx).contains("cfg.$key")
    if (raw != null && (raw.isNotEmpty() || (hasLocal && row.k == K.TX))) {
        when (row.k) {
            K.SW -> return raw.equals("true", true) || raw == "1"
            K.SL, K.CH, K.CO -> raw.toIntOrNull()?.let { return it }
            K.TX -> return raw
            else -> {}          // 类型对不上 ⇒ 继续往下兜底
        }
    }
    // ② ★ 2026-10-01 修：**不再退回旧格式顶层键！**
    //
    //   原来这里会退回读顶层 `fuckds_<key>`，结果——
    //   `cfg.<key>` 一旦被写成空（宿主回执缺 value），就会**读到旧格式的残留值**：
    //   主人症状：「切回模块会变回 **47 和 20**」「浓度和模糊度死活改不了」。
    //   而那个残留值又会被 push 回宿主 ⇒ 死循环，怎么改都没用。
    //
    //   ⇒ 现在只认 `cfg.<key>`；读不到就直接用**行定义的默认值**。
    //     旧格式键交给桥的**自愈**去清理（见 FdmPush.push），不再参与读取。
    return when (row.k) {
        K.SW -> hostBool(ctx, key) ?: (row.def as? Boolean ?: false)
        K.SL, K.CH, K.CO -> (row.def as? Int) ?: 0
        K.TX -> hostStr(ctx, key) ?: (row.def as? String ?: "")
        else -> ""
    }
}

/** 宿主报回来的"模块接口项"真值（cmd.state_all 的 JSON）—— 有就以它为准 */
private fun hostState(ctx: Context): Map<String, String> =
    jsonToMap(ctxSp(ctx).getString("cmd.state_all", "{}") ?: "{}")

private fun hostBool(ctx: Context, key: String): Boolean? =
    hostState(ctx)[key]?.let { it.equals("true", true) || it == "1" }

private fun hostStr(ctx: Context, key: String): String? =
    hostState(ctx)[key]?.takeIf { it.isNotEmpty() }

/* ─────────────── 条目渲染 ─────────────── */

@Composable
private fun ItemRow(
    it: It,
    valueParam: Any,
    hostText: String?,
    onNav: (String) -> Unit,
    bump: () -> Unit,
) {
    val ctx = LocalContext.current
    val host = hostText

    // 选图片：★ 传**路径**（主人的主意 ✅）——
    //   界面把**原图**（不压缩 ✗）写进**宿主自己的外部目录** ✅
    //   宿主用自己的权限读自己的文件 ⇒ 零权限问题、不受大小限制
    val picker = rememberLauncherForActivityResult(
        ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        if (uri != null) {
            try {
                val kind = it.cmd ?: "avatar"
                FdmPush.sendCmd(ctx, "ui_step", "选图开始 kind=$kind uri=$uri")
                val dir = IMG_DIR
                val made = if (!dir.exists()) dir.mkdirs() else true
                FdmPush.sendCmd(ctx, "ui_step", "目录=$dir 建好了=$made 能写=" + dir.canWrite())
                val dst = java.io.File(dir, "img_" + kind + ".png")
                ctx.contentResolver.openInputStream(uri)?.use { ins ->
                    java.io.FileOutputStream(dst).use { out -> ins.copyTo(out) }
                }
                FdmPush.sendCmd(ctx, "ui_step", "写出 " + dst.length() + " 字节 → " + dst.absolutePath)
                if (dst.length() > 0) {
                    FdmPush.sendCmd(ctx, "img_path", kind + "|" + dst.absolutePath)
                    Log.e(TAG, "传路径 $kind → " + dst.absolutePath + "（" + dst.length() + " 字节）")
                } else {
                    Log.e(TAG, "写进宿主目录失败（0 字节）")
                }
                bump()
            } catch (t: Throwable) {
                FdmPush.sendCmd(ctx, "ui_step", "选图异常: " + t)
                Log.e(TAG, "传图异常", t)
            }
        }
    }

    when (it.k) {
        K.SW -> SettingSwitch(it.label, valueParam as Boolean, it.key, host, it.hint) { v ->
            poke(bump)
            Log.e(TAG, "点了 " + it.key + " = " + v)
            saveLocal(ctx, it, v)                        // ★ 本地也存（界面要显示/重进要回显）
            if (it.cmd != null) FdmPush.sendCmd(ctx, it.cmd, v)
            else FdmPush.sendCmd(ctx, "cfg_put", it.key!! + "\u001f" + "b" + "\u001f" + v)
            bump()
        }
        K.SL -> SettingSlider(it.label, valueParam as Int,
            it.min, it.max, host, it.hint) { v ->
            saveLocal(ctx, it, v)
            if (it.cmd != null) FdmPush.sendCmd(ctx, it.cmd, v)
            else FdmPush.sendCmd(ctx, "cfg_put", it.key!! + "\u001f" + "i" + "\u001f" + v)
            bump()
        }
        K.CH -> SettingChoice(it.label, valueParam as Int, it.choices, host, it.hint) { v ->
            saveLocal(ctx, it, v)
            FdmPush.sendCmd(ctx, "cfg_put", it.key!! + "\u001f" + "i" + "\u001f" + v)
            bump()
        }
        K.CO -> SettingColor(it.label, valueParam as Int, host, it.hint) { v ->
            saveLocal(ctx, it, v)
            FdmPush.sendCmd(ctx, "cfg_put", it.key!! + "\u001f" + "i" + "\u001f" + v)
            bump()
        }
        K.TX -> SettingText(it.label, valueParam as String, it.key, host, it.hint) { v ->
            poke(bump)
            // ★ 2026-09-30 修：文本项原来发的是 "i"（整数）⇒ 桥里 Integer.parseInt("你好") 直接抛
            //   ⇒ 招呼语/回复建议/提示词这些**一个字都写不进去**。文本必须发 "s"。
            // ★ 2026-10-03 补：**本地也要存**！
            //   开关/滑条/枚举/颜色四类都有 saveLocal，唯独文本项漏了 ⇒
            //   本地 `cfg.<key>` 只能靠宿主回执来更新；回执没回来（宿主没跑 / 广播丢）
            //   就永远是旧值 ⇒ 现象「改完退出，又变回之前的东西」。
            saveLocal(ctx, it, v)
            FdmPush.sendCmd(ctx, "cfg_put", it.key!! + "\u001f" + "s" + "\u001f" + v); bump()
        }
        K.SUB -> SettingNav(it.label, it.hint) { onNav(it.sub!!) }
        K.ACT -> SettingAction(it.label, it.hint ?: "走模块自己的入口执行") {
            FdmPush.sendCmd(ctx, it.cmd!!, null); bump()
        }
        K.PICK -> SettingAction(it.label, it.hint ?: "选一张图（界面读原图 → 丢进宿主目录 → 宿主用模块自己的保存例程写进**内部**目录 ✅）") {
            picker.launch("image/*")     // ★ 调起**系统**选择器（不是让宿主弹 ✗）
        }
        K.COPY -> SettingAction(it.label, it.hint ?: "复制宿主的日志到剪贴板") {
            FdmPush.sendCmd(ctx, it.cmd ?: "dump_text", null)
            val t = ctxSp(ctx).getString("cmd.dump_text", "（还没回读到日志）") ?: ""
            val cb = ctx.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            cb.setPrimaryClip(ClipData.newPlainText("FDM", t))
            Log.e(TAG, "已复制 " + t.length + " 字")
            bump()
        }
        K.INFO -> SettingInfo(it.label, it.hint ?: "")
    }
}

/** 按类型把值存到本地（界面显示 + 重进回显都靠它）。 */
/**
 * 本地存一个配置项。
 *
 * <p>★ 2026-10-01 修：原来写的是**旧格式顶层键**，而读取路径（现在）以 `cfg.<key>` 为主 ⇒
 * 读写又对不上。统一成**只写新格式** `cfg.<key>`：
 * <ul>
 *   <li>读取（[readValue]）→ 新格式优先 ✅</li>
 *   <li>桥（`FdmPush.push`）→ 新格式优先 ✅</li>
 *   <li>桥的**自愈**会把残留的旧格式键删掉 ⇒ 老存档自然消亡 ✅</li>
 * </ul>
 */
private fun saveLocal(ctx: Context, row: It, v: Any) {
    val k = row.key ?: return
    // ★ 2026-10-10（3.64.5）：布尔统一写成 "1"/"0"
    //   （原来写 "true"/"false"，而库里另一半地方是 "1"/"0" ⇒ 只认一种的读法就会显示错）
    val txt = if (v is Boolean) Bridge.boolStr(v) else v.toString()
    ctxSp(ctx).edit().putString("cfg.$k", txt).apply()
}

/* ─────────────── 页面 ─────────────── */

/** 发完值之后短轮询几次 —— 宿主回执是**异步**回来的，不刷就看不见（这是先前"要重启才变"的根因 ✗） */
private fun poke(bump: () -> Unit) {
    bump()
}

/** 在协程里多刷几拍（点击后用） */
private suspend fun pokeDelayed(bump: () -> Unit) {
    repeat(4) { kotlinx.coroutines.delay(400); bump() }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TreePage(id: String, onNav: (String) -> Unit, onBack: () -> Unit) {
    if (id == "gray") {                       // 「灰度选项管理」= 宿主开关编辑器
        GrayPage(onBack)
        return
    }
    if (id == "music") {                      // 「音乐」= 独立播放器页（2026-10-06）
        MusicPage(onNav, onBack)
        return
    }
    if (id == "musiclogin") {                 // 「网易云登录」（2026-10-06）
        MusicLoginPage(onBack)
        return
    }
    if (id == "sysprompt_v2") {               // 「系统提示词 v2」= 重构页（2026-10-10）
        SysPromptV2Page(onBack, onNav)
        return
    }
    val ctx = LocalContext.current
    var tick by remember { mutableIntStateOf(0) }
    val t = tick
    val pg = Tree.page(id)
    // ★ 2026-10-10（3.66.0）：「功能原理 & 帮助」子框（页面末尾那个入口打开它）
    var helpTopic by remember { mutableStateOf<String?>(null) }
    // 进页面索要"模块接口项"的真值（助手图片/账号名/防撤回/环境…），并等宿主回话后重画
    LaunchedEffect(id) {
        FdmPush.sendCmd(ctx, "state_all", null)
        repeat(5) { kotlinx.coroutines.delay(1000); tick++ }
    }
    // ★ 状态通道：进任何页都先问一次"模块自己 getter 的当前值"，之后定时重问
    LaunchedEffect(id) {
        FdmPush.sendCmd(ctx, "cfg_state", null)
        repeat(6) {
            kotlinx.coroutines.delay(1200)
            tick++
        }
    }
    // ★ 进任何页面都问一次"模块真值"（cfg_state）——
    //   之前**界面从来没请求过它** ✗ ⇒ 带 sk 的项（账号名/助手图片/防撤回…）拿不到模块真值，
    //   就退回读我那套本地键 ⇒ 全空 ✗（实测：账号名/助手图片不生效、开关显示也不对）
    LaunchedEffect(id) {
        FdmPush.sendCmd(ctx, "cfg_state", null)
        repeat(6) {
            kotlinx.coroutines.delay(1200)
            tick++
        }
    }

    // 日志页一进来就回读一次，并等宿主把内容发回来
    if (id == "dump") {
        LaunchedEffect(Unit) {
            FdmPush.sendCmd(ctx, "dump_text", null)
            repeat(6) {
                kotlinx.coroutines.delay(1200)
                tick++
            }
        }
    }

    Scaffold(
        topBar = { FdmTopBar(pg?.title ?: id, onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(top = 8.dp, bottom = 24.dp),
        ) {
            if (pg == null) {
                SettingInfo("找不到这一页", id)
                return@Column
            }
            // ★ 2026-10-10（3.65.0）：「猜你想跳转」—— 回复建议 / 富文本顶上给一条去系统提示词的路
            if (id == "suggest" || id == "richtext") {
                JumpHintCard(onOpen = { onNav("sysprompt_v2") })
                Spacer(Modifier.height(10.dp))
            }
            pg.items.forEachIndexed { i, it ->
                if (i > 0) Spacer(Modifier.height(8.dp))
                // ★ 在这里读值 —— 这里观察了 `t`，`tick` 变了才会带着新值调用 ItemRow ⇒ 它会重组
                ItemRow(it, itemValue(ctx, it, stateMap(ctx)), itemHostText(ctx, it), onNav) { tick++ }
            }

            Spacer(Modifier.height(16.dp))
            if (id == "dump") {
                // 日志内容本体（原 UI 是滚动的一张长文本）
                val dump = ctxSp(ctx).getString("cmd.dump_text", "（还没回读；点上面「回读」）") ?: ""
                SectionLabel("内容（" + dump.length + " 字）")
                SettingInfo("", dump)
                Spacer(Modifier.height(12.dp))
            }
            SectionLabel("宿主状态")
            val res = ctxSp(ctx).getString("last_result", null)
            SettingInfo("动作结果", res ?: "（还没执行过动作）",
                "时间：" + fmt(ctxSp(ctx).getLong("last_result_at", 0L)))
            SettingInfo("回执 rev", if (Bridge.appliedRev(ctx) < 0) "无" else Bridge.appliedRev(ctx).toString(),
                "宿主真值同步于 " + fmt(Bridge.hostAt(ctx)))
            SettingAction("推送一次 + 让宿主回读", "改完一般已自动推过；这个用来确认") {
                Bridge.push(ctx); tick++
            }
            SettingAction("问一下宿主最新状态", "让宿主跑一遍 status 动作并把结果回传") {
                FdmPush.sendCmd(ctx, "avatar_status", null); tick++
            }

            // ★ 2026-10-10（3.66.0）：页面**末尾**的「功能原理 & 帮助」入口
            if (id == "suggest" || id == "richtext") {
                Spacer(Modifier.height(16.dp))
                HelpEntry(label = Lang.S.helpEntry(ctx)) { helpTopic = id }
            }
        }
    }

    // 帮助子框（Compose 弹窗，内容可滚动）
    helpTopic?.let { tp -> HelpDialog(tp) { helpTopic = null } }
}

/**
 * 一批条目现场值的来源：**宿主回执**（`cmd.cfg_state`，模块自己 getter 的真值）。
 *
 * <p>把它和 [itemValue] / [itemHostText] 抽出来，是为了让**「更多」弹窗**里的控件
 * （见 `SysPromptV2.kt`）跟普通页走**完全同一套取数规矩** —— 不然同一个开关两处显示两个值，
 * 比显示错更难看。
 */
private fun stateMap(ctx: Context): Map<String, String> =
    jsonToMap(ctxSp(ctx).getString("cmd.cfg_state", "{}") ?: "{}")

/** 一项的「宿主侧原话」（老格式的三处兜底读取，给控件显示用）。 */
private fun itemHostText(ctx: Context, it: It): String? = it.key?.let { k ->
    ctxSp(ctx).getString("host.kv_remote_settings_" + k, null)
        ?: ctxSp(ctx).getString("host.kv_settings_" + k, null)
        ?: ctxSp(ctx).getString(FdmPush.HOST_PREFIX + k, null)
}

/** 一项的「现场值」：**模块真值优先**（有 `sk` 就用它）→ 本地兜底 [readValue]。 */
private fun itemValue(ctx: Context, it: It, st: Map<String, String>): Any =
    it.sk?.let { sk ->
        st[sk]?.let { v ->
            when (it.k) {
                K.SW -> v.equals("true", true) || v == "1"
                K.SL, K.CH, K.CO -> v.toIntOrNull() ?: readValue(ctx, it)
                else -> v
            }
        }
    } ?: readValue(ctx, it)

/**
 * 把一批条目渲染出来（给**弹窗**用的那一版）🐲
 *
 * <p>为什么要有它：「更多」弹窗里要放**旧「系统提示词」页那 6 项**（开关/内容/模式/承载/前缀/后缀），
 * 而那 6 项的真值、推送、回显逻辑全在 `ItemRow` 里 —— 与其抄一遍，不如把 `ItemRow`
 * 连同这一小圈"取数 + 定时问宿主"一起复用。
 *
 * <p>取数规矩与普通页**逐字一致**（`stateMap` / `itemHostText` / `itemValue` 同一套函数）⇒
 * 同一个开关在弹窗里和在页面上，显示的永远是同一个值。
 */
@Composable
fun ItemsBlock(items: List<It>, onNav: (String) -> Unit) {
    val ctx = LocalContext.current
    var tick by remember { mutableIntStateOf(0) }
    val t = tick
    // 弹窗一开就问一次宿主真值，随后短轮询几拍（回执是**异步**的，不刷就看不见）
    LaunchedEffect(items) {
        FdmPush.sendCmd(ctx, "cfg_state", null)
        repeat(6) {
            kotlinx.coroutines.delay(1200)
            tick++
        }
    }
    Column(Modifier.fillMaxWidth()) {
        items.forEachIndexed { i, it ->
            if (i > 0) Spacer(Modifier.height(8.dp))
            ItemRow(it, itemValue(ctx, it, stateMap(ctx)), itemHostText(ctx, it), onNav) { tick++ }
        }
    }
}

/**
 * 「灰度选项管理」页 = **宿主下发配置的开关编辑器**（原 UI 那一页）。
 * 改完保存，自动备份原值；「全部恢复灰度」把备份还原回去。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GrayPage(onBack: () -> Unit) {
    val ctx = LocalContext.current
    var tick by remember { mutableIntStateOf(0) }
    val t = tick
    // 页面一进来就让宿主回读，并**等它回来**（数据是广播回来的，界面得主动重算）
    LaunchedEffect(Unit) {
        FdmPush.sendCmd(ctx, "gray_all", null)
        FdmPush.sendCmd(ctx, "call_state", null)     // ★ 通话开关状态（宿主回 cmd.call_state）
        FdmPush.sendCmd(ctx, "call_pin_state", null) // ★ 通话页留驻状态（cmd.call_pin_state）
        repeat(8) {
            kotlinx.coroutines.delay(1200)
            tick++
        }
    }

    val hostJson = ctxSp(ctx).getString("cmd.gray_all", "{}") ?: "{}"
    val hostVals = remember(t, hostJson) { jsonToMap(hostJson) }

    Scaffold(
        topBar = { FdmTopBar("FuckDSManger", onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(top = 8.dp, bottom = 24.dp),
        ) {
            // ★★ 2026-10-02「通话功能（实验）」
            //    这一项**不是**宿主灰度键 —— 它是往宿主的 model_configs 里补
            //    "call_feature":{}，对应宿主 2.6.1 的通话入口判据（ChatPageTopBar.kt:105）。
            //    ⇒ 单独摆在最上面，跟下面那堆 kv_remote_settings_* 区分开。
            CallFeatureRow { tick++ }
            Spacer(Modifier.height(6.dp))
            CallPinRow { tick++ }
            Spacer(Modifier.height(14.dp))
            SectionLabel("改完点保存，重启 App 生效；均会自动备份原值，点全部恢复可还原")
            GrayTable.items.forEachIndexed { i, g ->
                if (i > 0) Spacer(Modifier.height(6.dp))
                GrayRow(g, hostVals[g.key]) { tick++ }
            }
            Spacer(Modifier.height(16.dp))
            // ★ 2026-10-02 修（Bug B）：这里原来有个「保存并推给宿主」按钮，
            //   实际只发了 `gray_all`（**回读**），**什么都没推** ——
            //   而每项改动在 GrayRow 里已经**实时写进宿主**了。
            //   ⇒ 删掉这个安慰剂（下面那个「重新读取」才是真的回读）。
            SettingAction("全部恢复灰度", "撤掉影子覆盖 + 把备份的原值写回真实键") {
                FdmPush.sendCmd(ctx, "gray_restore_all", null); tick++
            }
            SettingAction("重新读取宿主当前值", "让宿主再回读一遍") {
                FdmPush.sendCmd(ctx, "gray_all", null); tick++
            }
            Spacer(Modifier.height(8.dp))
            SettingInfo("最近一次动作", ctxSp(ctx).getString("last_result", "（无）") ?: "（无）")
        }
    }
}

/**
 * 「通话功能（实验）」开关行 🐲 2026-10-02
 *
 * 它**不是**宿主灰度键，所以不参与 GrayTable / gray_put 那一套。
 * 做法：让宿主进程往 `kv_remote_settings_model_configs_v1` 的每个 model 里
 * 补一个 `"call_feature":{}` —— 宿主 2.6.1 的通话入口判据就是
 * `ChatPageTopBar.kt:105` 读 `ModelConfig.call_feature != null`。
 *
 * 状态串由宿主回传：`cmd.call_state = "开关|已生效"`（如 `"1|1"`）。
 * 两位不一致 ⇒ "开了但没生效"（model_configs 还没被宿主写过）。
 */
@Composable
private fun CallFeatureRow(bump: () -> Unit) {
    val ctx = LocalContext.current
    val raw = ctxSp(ctx).getString("cmd.call_state", "") ?: ""
    val on = raw.startsWith("1")
    val feat = raw.endsWith("1")
    val label = when {
        raw.isEmpty() -> "通话功能（实验）：—"
        !on -> "通话功能（实验）：已关闭"
        feat -> "通话功能（实验）：已开启 · 已生效"
        else -> "通话功能（实验）：已开启 · 未生效"
    }
    SettingAction(
        label,
        "往 model_configs 补 \"call_feature\":{} ⇒ 聊天页顶部栏出现「打电话」图标（宿主 2.6.1）",
    ) {
        FdmPush.sendCmd(ctx, "call_set", if (on) "0" else "1")
        bump()
    }
}

/**
 * 「通话页留驻」开关行 🐲 2026-10-02
 *
 * 宿主渲染通话页的闸门 = `ChatCallHost` 里那句 `if (callPageViewModel.a()) CallPage(...)`
 * （`ChatCallHost.kt:32`）。服务端一还错误（`call mode disabled`）状态就回落到空闲，
 * 闸门立刻变 false ⇒ **通话页被摘掉**，根本来不及看清它长什么样。
 *
 * 本开关钩住那个返回值并强制 true ⇒ 通话页**留在那儿**。
 *
 * ⚠️ 副作用（已知）：`a()` 也被聊天页（`hq` = ChatCallState）调用 ⇒
 *    开着时聊天页可能也认为"正在通话中"（多一条横幅）。不崩，关掉即还原。
 */
@Composable
private fun CallPinRow(bump: () -> Unit) {
    val ctx = LocalContext.current
    val raw = ctxSp(ctx).getString("cmd.call_pin_state", "") ?: ""
    val on = raw.startsWith("1")
    val label = when {
        raw.isEmpty() -> "通话页留驻：—"
        on -> "通话页留驻：已开启"
        else -> "通话页留驻：已关闭"
    }
    SettingAction(
        label,
        "服务端报错时不让通话页自动消失 —— 钩住 ChatCallHost 的渲染闸门（CallPageViewModel.a）",
    ) {
        FdmPush.sendCmd(ctx, "call_pin_set", if (on) "0" else "1")
        bump()
    }
}

@Composable
private fun GrayRow(g: Gray, hostValIn: String?, bump: () -> Unit) {
    val ctx = LocalContext.current
    val full = g.key
    val k = "gray." + full
    // ★ 宿主真值就在回读来的 `host.<完整键>` 里（su 抓的 SP 已证实：
    //   host.kv_remote_settings_picture_compress_format=webp ✅）
    //   依次试：kv_remote_settings_ → kv_settings_ → 动作回传的 gray_all
    val hostVal = remember(hostValIn) {
        ctxSp(ctx).getString("host.kv_remote_settings_" + full, null)
            ?: ctxSp(ctx).getString("host.kv_settings_" + full, null)
            ?: hostValIn
    }
    // ★ 初值取**宿主当前值**（原 UI 就是直接读宿主的），本机改过的才用本机的
    var tv by remember(k, hostVal) {
        mutableStateOf(ctxSp(ctx).getString(k, hostVal ?: "") ?: "")
    }
    val hint = g.hint.ifEmpty { null }
    when (g.type) {
        GrayType.B -> {
            val b = tv.equals("true", true) || tv == "1"
            SettingSwitch(g.label, b, full, hostVal, hint) { v ->
                tv = v.toString()
                ctxSp(ctx).edit().putString(k, tv).apply()
                FdmPush.sendCmd(ctx, "gray_put", full + "\u001f" + "b" + "\u001f" + tv)
                bump()
            }
        }
        GrayType.I, GrayType.L -> {
            val ty = if (g.type == GrayType.L) "l" else "i"
            SettingText(g.label, tv, full, hostVal, hint) { v ->
                tv = v
                ctxSp(ctx).edit().putString(k, v).apply()
                FdmPush.sendCmd(ctx, "gray_put", full + "\u001f" + ty + "\u001f" + v)
            }
        }
        GrayType.S -> {
            SettingText(g.label, tv, full, hostVal, hint) { v ->
                tv = v
                ctxSp(ctx).edit().putString(k, v).apply()
                FdmPush.sendCmd(ctx, "gray_put", full + "\u001f" + "s" + "\u001f" + v)
            }
        }
    }
}

/** 极简 JSON 解析（value 都是字符串） */
fun jsonToMap(s: String): Map<String, String> {
    val m = mutableMapOf<String, String>()
    // ★ 2026-09-30 修：原来用手写正则，只"匹配"转义但不"还原" ⇒ 带换行的值（模板池/招呼语）
    //   回读出来是字面 `\n` 的一坨，用户一保存还把转义版写回存储 ✗。
    //   正解：用真 JSON 解析器（它负责还原 \n \" \uXXXX）。
    try {
        val o = org.json.JSONObject(s)
        val ks = o.keys()
        while (ks.hasNext()) {
            val k = ks.next()
            val v = o.opt(k)
            if (v != null && v !is org.json.JSONObject) m[k] = v.toString()
        }
        return m
    } catch (t: Throwable) {
        // 兜底：还是解析不了就退回老正则（至少别让整页空白）
        val re = Regex("\"([^\"]+)\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"")
        re.findAll(s).forEach { m[it.groupValues[1]] = it.groupValues[2] }
        return m
    }
}

private fun fmt(ms: Long): String =
    if (ms <= 0) "—" else SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(Date(ms))

/** 首页：照 `Tree.home` 渲染（原 UI 的五个入口） */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TreeHome(onNav: (String) -> Unit, onAbout: () -> Unit) {
    val ctx = LocalContext.current
    var tick by remember { mutableIntStateOf(0) }
    val t = tick
    Scaffold(
        topBar = { FdmTopBar("FuckDSManger") },
        bottomBar = { FdmNavBar(selected = 0, onSelect = { if (it == 1) onAbout() }) },
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
                onClick = { onNav("gray") },
            )
            FdmDivider()
            SectionLabel("附加の功能")
            Column(verticalArrangement = Arrangement.spacedBy(3.dp)) {
                val extra = listOf(
                    Triple("音乐", Icons.Rounded.MusicNote, "搜歌 / 播放 / 歌词 —— 免登录 320k"),
                    Triple("过检", Icons.Rounded.AdminPanelSettings, "如果ds压力root设备/发现lsp，点我"),
                    Triple("调试", Icons.Rounded.Build, "如果没bug，里面的东西别乱动"),
                    Triple("聊天", Icons.Rounded.Sms, null as String?),
                    Triple("美化", Icons.Rounded.Mood, null as String?),
                )
                val ids = listOf("music", "env", "debug", "chat", "beauty")
                extra.forEachIndexed { i, item ->
                    FdmListItem(
                        title = item.first,
                        leading = item.second,
                        shape = groupedShape(i, extra.size),
                        supporting = item.third,
                        onClick = { onNav(ids[i]) },
                    )
                }
            }
        }
    }
}
