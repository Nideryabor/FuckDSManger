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

private fun readValue(ctx: Context, it: It): Any = when (it.k) {
    K.SW -> hostBool(ctx, it.key!!) ?: ctxSp(ctx).getBoolean(it.key!!, it.def as? Boolean ?: false)
    K.SL, K.CH, K.CO -> ctxSp(ctx).getInt(it.key!!, (it.def as? Int) ?: 0)
    K.TX -> hostStr(ctx, it.key!!) ?: (ctxSp(ctx).getString(it.key!!, it.def as? String ?: "") ?: "")
    else -> ""
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
            FdmPush.sendCmd(ctx, "cfg_put", it.key!! + "\u001f" + "i" + "\u001f" + v); bump()
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
        K.INFO -> SettingInfo(it.label, "")
    }
}

/** 按类型把值存到本地（界面显示 + 重进回显都靠它）。 */
private fun saveLocal(ctx: Context, it: It, v: Any) {
    val k = it.key ?: return
    val ed = ctxSp(ctx).edit()
    when (v) {
        is Boolean -> ed.putBoolean(k, v)
        is Int -> ed.putInt(k, v)
        else -> ed.putString(k, v.toString())
    }
    ed.apply()
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
    val ctx = LocalContext.current
    var tick by remember { mutableIntStateOf(0) }
    val t = tick
    val pg = Tree.page(id)
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
            pg.items.forEachIndexed { i, it ->
                if (i > 0) Spacer(Modifier.height(8.dp))
                // ★ 在这里读值 —— 这里观察了 `t`，`tick` 变了才会带着新值调用 ItemRow ⇒ 它会重组
                val hv = it.key?.let { k ->
                    ctxSp(ctx).getString("host.kv_remote_settings_" + k, null)
                        ?: ctxSp(ctx).getString("host.kv_settings_" + k, null)
                        ?: ctxSp(ctx).getString(FdmPush.HOST_PREFIX + k, null)
                }
                // 模块真值（cfg_state 回传）：有 sk 的项用它显示 —— 不再读我编的键
                val stJson = ctxSp(ctx).getString("cmd.cfg_state", "{}") ?: "{}"
                val st = jsonToMap(stJson)
                val value: Any = it.sk?.let { sk ->
                    st[sk]?.let { v ->
                        when (it.k) {
                            K.SW -> v.equals("true", true) || v == "1"
                            K.SL, K.CH, K.CO -> v.toIntOrNull() ?: readValue(ctx, it)
                            else -> v
                        }
                    }
                } ?: readValue(ctx, it)
                ItemRow(it, value, hv, onNav) { tick++ }
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
            SectionLabel("改完点保存，重启 App 生效；均会自动备份原值，点全部恢复可还原")
            GrayTable.items.forEachIndexed { i, g ->
                if (i > 0) Spacer(Modifier.height(6.dp))
                GrayRow(g, hostVals[g.key]) { tick++ }
            }
            Spacer(Modifier.height(16.dp))
            SettingAction("保存并推给宿主", "逐项写入宿主的 kv_remote_settings_*（先备份原值）") {
                FdmPush.sendCmd(ctx, "gray_all", null); tick++
            }
            SettingAction("全部恢复灰度", "把之前备份的原值还原回去") {
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
private fun jsonToMap(s: String): Map<String, String> {
    val m = mutableMapOf<String, String>()
    val re = Regex("\"([^\"]+)\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"")
    re.findAll(s).forEach { m[it.groupValues[1]] = it.groupValues[2] }
    return m
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
                    Triple("过检", Icons.Rounded.AdminPanelSettings, "如果ds压力root设备/发现lsp，点我"),
                    Triple("调试", Icons.Rounded.Build, "如果没bug，里面的东西别乱动"),
                    Triple("聊天", Icons.Rounded.Sms, null as String?),
                    Triple("美化", Icons.Rounded.Mood, null as String?),
                )
                val ids = listOf("env", "debug", "chat", "beauty")
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
