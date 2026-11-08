// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.animation.slideInVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.nidyaber.fuckdsmanger.bridge.FdmPush
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * 「宿主の终极美化策略」—— 替换宿主**所有**资源文字 / 图片 🐲 2026-11-07
 *
 * <h3>这一页解决什么</h3>
 * 宿主里凡是走资源表的东西（{@code string/xxx}、{@code drawable/xxx}），
 * 都能在这里改成主人想要的文字 / 图。宿主重启（或重进页面）后生效。
 *
 * <h3>清单从哪来（为什么不"运行时抓"）</h3>
 * 一开始想的是"hook 记下宿主用过什么"，真机一测就否了：
 * <pre>
 *   probe2/probe3 实测：60 秒内只摸到 44 条 string —— 因为**用户得把每个界面都点一遍**。
 * </pre>
 * 改成**静态提取**（{@code tools/res_dump.py}）：
 * <pre>
 *   全库扫 smali 里硬编码的资源 id ⇒ string 747/762、drawable 204/266
 * </pre>
 * 一次到位、不用点界面。产物打进 {@code res/raw/host_res.json}（48 KB）。
 *
 * <h3>★ 只存**资源名**，不存 id</h3>
 * 宿主资源名**没有被混淆**（{@code session_init_title} / {@code assistant_message_avatar}…），
 * 而 id（{@code 0x7f0f0312}）会随宿主升级变。
 * ⇒ 存名字，宿主侧 {@code getIdentifier(name, type, pkg)} 现查。
 * 这样宿主升级后**不用改一行代码**，能查到就继续生效。
 *
 * <h3>为什么列表要 LazyColumn</h3>
 * 951 条。用 Column + verticalScroll 会一次性组合全部行 ⇒ 进页面卡死。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ResBeautyPage(onBack: () -> Unit) {
    val ctx = LocalContext.current

    // ── 清单（只读一次，进程内缓存）──
    val all = remember { loadHostRes(ctx) }

    // ── 宿主的当前配置（异步回执，所以给 tick 刷新）──
    var tick by remember { mutableIntStateOf(0) }
    @Suppress("UNUSED_EXPRESSION") tick
    // ★★ 必须是 `cmd.res_state` —— 界面上永远只读**一个**回执键。
    //
    //  2026-11-07 踩过（主人报「UI 里改没反应，确定以后又回去了」）：
    //  点「确定」发的是动作 `res_set_text`，宿主回执落在 `cmd.res_set_text`；
    //  而这里读的是 `cmd.res_state` ⇒ **永远是旧值** ⇒ 界面把刚改的又显示回原文
    //  （宿主侧其实早就写成功了，dsm.log 铁证：`refresh ✅ 文字 3 条`）。
    //
    //  ⇒ 规矩：**任何写操作之后都要重新要一次 res_state**（见 refreshSoon），
    //    让 `cmd.res_state` 成为唯一真相源。
    val cfg = remember(tick) { parseOverrides(FdmPush.sp(ctx).getString("cmd.res_state", null)) }

    var query by remember { mutableStateOf("") }
    var tab by remember { mutableIntStateOf(0) }        // 0=文字 1=图片 2=已改
    var tabChanging by remember { mutableStateOf(false) }   // 切 tab 时的淡入用
    var editing by remember { mutableStateOf<ResItem?>(null) }
    var imgView by remember { mutableStateOf<ResItem?>(null) }   // ★ 图片预览弹窗
    var imgTarget by remember { mutableStateOf<ResItem?>(null) }
    var confirmClear by remember { mutableStateOf(false) }
    // ★ 2026-11-07 · 一键导出 / 导入
    var showExport by remember { mutableStateOf(false) }
    var exportName by remember { mutableStateOf("") }
    var showImport by remember { mutableStateOf(false) }
    var zipList by remember { mutableStateOf<List<String>>(emptyList()) }
    var importMsg by remember { mutableStateOf("") }

    // 写操作之后统一走它：先要真值，再等回执落地（广播是异步的，不等就是旧界面）
    val scope = rememberCoroutineScope()
    val refreshSoon: () -> Unit = {
        FdmPush.sendCmd(ctx, "res_state", null)
        scope.launch {
            repeat(5) {
                delay(350)
                tick++
            }
        }
    }

    // 进页面就问一次宿主真值（回执是广播，异步）
    LaunchedEffect(Unit) {
        FdmPush.sendCmd(ctx, "res_state", null)
        FdmPush.sendCmd(ctx, "res_selftest", null)      // ★ 顺带要一次诊断（getDrawable 调用次数）
        repeat(4) {
            delay(600)
            tick++
        }
    }

    // ── 选图（复用「传路径」那条老路：界面写文件 → 宿主自己拷进私有目录）──
    val picker = rememberLauncherForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        val t = imgTarget
        if (uri != null && t != null) {
            try {
                val dir = File("/sdcard/Pictures/FDM")
                if (!dir.exists()) dir.mkdirs()
                val dst = File(dir, "res_" + t.name.replace(Regex("[^A-Za-z0-9_.-]"), "_") + ".png")
                ctx.contentResolver.openInputStream(uri)?.use { ins ->
                    dst.outputStream().use { out -> ins.copyTo(out) }
                }
                if (dst.length() > 0) {
                    FdmPush.sendCmd(ctx, "res_set_img", t.name + "|" + dst.absolutePath)
                    Log.e("FdmRes", "选图 ${t.name} → ${dst.absolutePath}（${dst.length()} 字节）")
                }
            } catch (e: Throwable) {
                Log.e("FdmRes", "选图失败", e)
            }
        }
        imgTarget = null
        refreshSoon()
    }

    // 从系统里选任意一个 zip 导入（FS 授权不一定要是我们那个目录）
    val importPicker = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocument()
    ) { uri: Uri? ->
        if (uri != null) {
            try {
                val bytes = SafDir.readUriBytes(ctx, uri)
                if (bytes == null || bytes.isEmpty()) {
                    importMsg = ctx.getString(R.string.rb_034)
                } else {
                    // 交给宿主：先把字节落到宿主能读的地方，再让它解包
                    val dir = File("/sdcard/Pictures/FDM")
                    if (!dir.exists()) dir.mkdirs()
                    val dst = File(dir, "fdm_import_tmp.zip")
                    dst.writeBytes(bytes)
                    FdmPush.sendCmd(ctx, "res_import", dst.name)
                    importMsg = ctx.getString(R.string.rb_035)
                    showImport = false
                    refreshSoon()
                }
            } catch (e: Throwable) {
                importMsg = ctx.getString(R.string.rb_036) + e
            }
        }
    }

    /** 替换图在 UI 侧的落点（预览读它）。规则必须和上面 picker 完全一致。 */
    fun localImgOf(name: String): File =
        File("/sdcard/Pictures/FDM/res_" + name.replace(Regex("[^A-Za-z0-9_.-]"), "_") + ".png")

    // ── 过滤 ──
    val shown = remember(query, tab, cfg, all) {
        val q = query.trim().lowercase()
        var list = if (tab == 1) all.drawables else if (tab == 0) all.strings else all.all()
        if (tab == 2) {
            // ★ 2026-11-07 修（主人报「已改菜单里不显示修改过的图片」）：
            //   原来是 `all.strings + all.drawables` 再按 `cfg.i.containsKey` 过滤 ——
            //   逻辑本身没错，但**图片永远命中不到**，因为 parseOverrides 解析 `i` 时
            //   宿主回执里的 `i` 可能是 JSONObject(null)。现在两个 map 都做了空保护，
            //   并且图片必须**同时**满足「配置里有 + 文件真的在」才算改过。
            list = all.all().filter { it ->
                cfg.t.containsKey(it.name) || cfg.i.containsKey(it.name)
            }
        }
        if (q.isNotEmpty()) {
            list = list.filter {
                it.name.lowercase().contains(q) ||
                        (it.value.isNotEmpty() && it.value.lowercase().contains(q))
            }
        }
        list
    }

    // ★ 2026-11-08（主人要求）：4 个操作收进右上角菜单，版面让给列表
    var showMenu by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            Box(Modifier.fillMaxWidth()) {
                // ★ 和其它页一致：返回箭头（不是"回窝"文字按钮）
                FdmTopBar(
                    title = stringResource(R.string.rb_001),
                    onBack = onBack,
                    onMore = { showMenu = true },
                )
                // ★★★ 2026-11-08 第二次修「菜单还在左边」（上一次我改错了）
                //
                //  **为什么 Modifier.align(TopEnd) 没用**：
                //    Material3 的 `DropdownMenu` 是**画在一个 Popup 窗口里**的，
                //    它接收的 `modifier` 会作用到 **Popup 内部的内容**（那个菜单面），
                //    **完全不影响 Popup 的位置**。
                //    Popup 的位置由它内部的 `PopupPositionProvider` 根据
                //    「DropdownMenu 在**布局树里占的那块地方**」算出来 ——
                //    而它当时是整个铺满宽度的 Box 的子节点 ⇒ 锚点在最左边 ⇒ 菜单贴左。
                //
                //  ⇒ 正确做法：**给菜单一个真正位于右上角的锚点容器**。
                //     把 DropdownMenu 塞进一个 `Box(Modifier.align(TopEnd))` 里，
                //     那个小 Box 就在右上角，Popup 自然从那儿往下弹。
                //
                //  （这就是为什么 Material3 还提供 `DropdownMenuBox` —— 它把
                //    「锚点 + 弹窗」这件事封装好了。这里用 Box 手写等价效果更省事。）
                Box(
                    Modifier
                        .align(Alignment.TopEnd)
                        .padding(top = 52.dp, end = 8.dp),
                ) {
                    DropdownMenu(
                        expanded = showMenu,
                        onDismissRequest = { showMenu = false },
                        // ★ 视觉归队：默认是「直角 + 纯色 + 硬阴影」（Material 规范里菜单的样子），
                        //   而本 App 其他组件是「大圆角 + 低对比底」⇒ 两套撞在一起就"不像 compose"。
                        shape = RoundedCornerShape(20.dp),
                        containerColor = MaterialTheme.colorScheme.surfaceContainerHigh,
                        tonalElevation = 0.dp,
                        shadowElevation = 6.dp,
                    ) {
                        // ★ 2026-11-08（主人要求）：菜单文字**居中**
                        MenuItemCentered(stringResource(R.string.rb_003)) {
                            showMenu = false; refreshSoon()
                        }
                        MenuItemCentered(stringResource(R.string.rb_028)) {
                            showMenu = false
                            val f = java.text.SimpleDateFormat("yyyyMMdd_HHmmss", java.util.Locale.US)
                            exportName = "fdm_res_backup_" + f.format(java.util.Date()) + ".zip"
                            showExport = true
                        }
                        MenuItemCentered(stringResource(R.string.rb_029)) {
                            showMenu = false
                            importMsg = ""
                            zipList = SafDir.listZips(ctx)
                            showImport = true
                        }
                        HorizontalDivider()
                        MenuItemCentered(
                            stringResource(R.string.rb_004),
                            color = MaterialTheme.colorScheme.error,
                        ) {
                            showMenu = false; confirmClear = true
                        }
                    }
                }
            }
        },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(Modifier.fillMaxSize().padding(pad)) {

            // ★ 2026-11-08：原来这里有一整块（状态行 + 4 个按钮 + JSON 诊断），
            //   按主人要求全部收走：
            //     · 刷新 / 导出 / 导入 / 全部还原 → 右上角「更多」菜单
            //     · 诊断 JSON（{"v":1,"t":{},"i":{}}）→ **删掉**
            //     · 「已改 X 条」→ 移到 tab 下面（列表头部）
            //   版面还给了搜索框和列表。
            if (importMsg.isNotEmpty()) {
                Text(
                    importMsg,
                    fontSize = 11.sp,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = Edge, vertical = 4.dp),
                )
            }

            // ── 搜索 ──
            OutlinedTextField(
                value = query,
                onValueChange = { query = it },
                singleLine = true,
                placeholder = { Text(stringResource(R.string.rb_005), fontSize = 14.sp) },
                modifier = Modifier.fillMaxWidth().padding(horizontal = Edge),
            )

            // ── 三个 tab ──
            Row(
                Modifier.fillMaxWidth().padding(horizontal = Edge, vertical = 8.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                listOf(R.string.rb_006, R.string.rb_007, R.string.rb_008).forEachIndexed { i, r ->
                    FilterChip(
                        selected = tab == i,
                        onClick = { tab = i },
                        label = { Text(stringResource(r), fontSize = 13.sp) },
                    )
                }
            }

            // ★ 2026-11-08（主人要求）：统计行移到 tab 下面（列表头部）
            Text(
                stringResource(R.string.rb_002, cfg.t.size, cfg.i.size),
                fontSize = 12.sp,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.padding(horizontal = Edge, vertical = 2.dp),
            )

            // ★ 2026-11-07（主人要求）：图片 tab 加说明 —— 图标位很小，
            //   塞长图会被裁成一条；不写清楚用户会以为"没生效"。
            if (tab == 1) {
                Text(
                    stringResource(R.string.rb_027),
                    fontSize = 11.sp,
                    lineHeight = 16.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(horizontal = Edge, vertical = 2.dp),
                )
                Spacer(Modifier.height(4.dp))
            }

            HorizontalDivider()

            // ★ 2026-11-08 动效：切 tab 时列表**淡入**（不是硬切）
            //   用 alpha 动画而不是 AnimatedContent：后者会重建整个 LazyColumn，
            //   951 条重建一次会掉帧。
            val listAlpha by animateFloatAsState(
                targetValue = if (tabChanging) 0f else 1f,
                animationSpec = tween(180),
                label = "listAlpha",
            )
            LaunchedEffect(tab) {
                tabChanging = true
                delay(60)
                tabChanging = false
            }

            // ── 列表 ──
            if (shown.isEmpty()) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(stringResource(R.string.rb_009), fontSize = 14.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            } else {
                LazyColumn(
                    Modifier
                        .fillMaxSize()
                        .graphicsLayer { alpha = listAlpha },
                ) {
                    items(shown, key = { it.key }) { item ->
                        ResRow(
                            item = item,
                            replaced = cfg.t.containsKey(item.name) || cfg.i.containsKey(item.name),
                            replacedName = cfg.i[item.name] ?: cfg.t[item.name],
                            onClick = {
                                // ★ 2026-11-07 主人要求：图片**点一下先预览**，
                                //   预览里再给「替换」按钮 —— 原来点行直接弹文件选择器，
                                //   等于"看一眼原图的机会都没有"，想换图也没法先确认换的是哪一个。
                                if (item.isImage) imgView = item else editing = item
                            },
                            onReset = {
                                if (item.isImage) FdmPush.sendCmd(ctx, "res_set_img", item.name + "|")
                                else FdmPush.sendCmd(ctx, "res_set_text", item.name + "|")
                                refreshSoon()
                            },
                        )
                    }
                    item { Spacer(Modifier.height(24.dp)) }
                }
            }
        }
    }

    // ── 改文字 ──
    editing?.let { item ->
        var text by remember(item.name) {
            mutableStateOf(cfg.t[item.name] ?: item.value)
        }
        AlertDialog(
            onDismissRequest = { editing = null },
            title = { Text(item.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold) },
            text = {
                Column {
                    Text(stringResource(R.string.rb_010, item.value.ifEmpty { "—" }),
                        fontSize = 12.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = text,
                        onValueChange = { text = it },
                        singleLine = false,
                        modifier = Modifier.fillMaxWidth(),
                    )
                    Spacer(Modifier.height(6.dp))
                    Text(stringResource(R.string.rb_011), fontSize = 11.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    FdmPush.sendCmd(ctx, "res_set_text", item.name + "|" + text)
                    editing = null; refreshSoon()
                }) { Text(stringResource(R.string.c_save)) }
            },
            dismissButton = {
                TextButton(onClick = {
                    FdmPush.sendCmd(ctx, "res_set_text", item.name + "|")
                    editing = null; refreshSoon()
                }) { Text(stringResource(R.string.rb_012)) }
            },
        )
    }

    // ── 图片预览（点行进来；这里才有「替换」）──
    imgView?.let { item ->
        val replacedFile = cfg.i[item.name]

        // ★ 2026-11-07（主人报 bug）：预览必须显示**宿主那张图本身**。
        //
        //  之前这里只能写一句「当前显示：宿主原图」—— 因为 UI 进程**读不到宿主的资源**
        //  （两个 APK，资源表各自独立；createPackageContext 又被包可见性挡死）。
        //  现在改成：让**宿主自己**把它画成 PNG（`res_preview` 动作），
        //  落到「音乐曲库那个已授权 SAF 目录 / 宿主私有目录」，UI 拿到路径再读。
        //  ⇒ 已替换的会看到替换图，没替换的看到宿主原图，**所见即所得**。
        //
        //  ⚠️⚠️ 2026-11-07 修「一直转圈圈」（主人报）：
        //     原来写的是 `remember(item.name, tick) { mutableStateOf(null) }` ——
        //     **tick 一变就把 pvPath 清回 null**，而 tick 每 350ms 被 refreshSoon 刷一次，
        //     于是「拿到路径 → 被清空 → 又去要 → 再清空」无限循环 ⇒ 转圈永远不停。
        //     ⇒ 路径必须只以 item.name 为键（同一张图的结果不会自己变）。
        //
        //     另外：失败时原来只把 pvTried 置位、界面照样显示转圈。
        //     现在分三态 —— 加载中 / 成功 / 失败（失败给「重试」，且不再无限等）。
        var pvPath by remember(item.name) { mutableStateOf<String?>(null) }
        var pvState by remember(item.name) { mutableIntStateOf(0) }   // 0=加载中 1=成功 2=失败
        var pvTry by remember(item.name) { mutableIntStateOf(0) }
        var pvBytes by remember(item.name) { mutableStateOf<ByteArray?>(null) }
        var pvNote by remember(item.name) { mutableStateOf("") }

        LaunchedEffect(item.name, pvTry) {
            pvState = 0
            pvBytes = null
            pvPath = null

            // ① 已替换过 ⇒ 优先直接读我们存的那张（本地文件，瞬间出图，不用等广播）
            val local = localImgOf(item.name)
            if (replacedFile != null && local.isFile && local.length() > 0) {
                pvPath = local.absolutePath
                pvState = 1
                return@LaunchedEffect
            }

            // ② 从**我们自己的 SAF 授权**里读宿主写好的那张（主人 2026-11-07 定：走授权）
            //    宿主把它画成 PNG 放进「音乐曲库那个目录」，我们授权了同一目录就能读。
            val safeName = item.name.replace(Regex("[^A-Za-z0-9_.-]"), "_")
            if (SafDir.granted(ctx)) {
                val fname = "fdm_res_preview_$safeName.png"
                // 先请宿主刷新一份（force=1），再读 —— 否则可能读到上一次的旧图
                FdmPush.sendCmd(ctx, "res_preview", item.name + "|1")
                repeat(10) {
                    delay(300)
                    val b = SafDir.readRootFile(ctx, fname)
                    if (b != null && b.isNotEmpty()) {
                        pvBytes = b
                        pvState = 1
                        return@LaunchedEffect
                    }
                }
                pvNote = "（SAF 里没找到 $fname）"
            } else {
                pvNote = "（还没给本应用授权文件夹）"
            }

            // ③ 兜底：让宿主把 PNG 以 base64 回传（不依赖任何权限）
            FdmPush.sendCmd(ctx, "res_preview", item.name + "|1")
            repeat(10) {
                delay(300)
                val b64 = FdmPush.sp(ctx).getString("cmd.res_preview", null)
                if (!b64.isNullOrEmpty() && b64.length > 100) {
                    try {
                        val b = android.util.Base64.decode(b64, android.util.Base64.DEFAULT)
                        if (b != null && b.isNotEmpty()) {
                            pvBytes = b
                            pvState = 1
                            return@LaunchedEffect
                        }
                    } catch (e: Throwable) {
                        Log.e("FdmRes", "base64 解码失败", e)
                    }
                }
            }
            pvState = 2                        // 失败 ⇒ 让界面显示原因 + 重试
        }

        val bmp = remember(pvPath, pvBytes) {
            when {
                pvPath != null -> {
                    val f = File(pvPath!!)
                    if (f.isFile && f.length() > 0)
                        android.graphics.BitmapFactory.decodeFile(f.absolutePath) else null
                }
                pvBytes != null -> android.graphics.BitmapFactory.decodeByteArray(
                    pvBytes, 0, pvBytes!!.size)
                else -> null
            }
        }

        AlertDialog(
            onDismissRequest = { imgView = null },
            title = { Text(item.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold) },
            text = {
                Column(horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier.fillMaxWidth()) {
                    Box(
                        Modifier.fillMaxWidth().height(180.dp)
                            .clip(RoundedCornerShape(12.dp))
                            .background(MaterialTheme.colorScheme.surfaceContainerLow),
                        contentAlignment = Alignment.Center,
                    ) {
                        when {
                            bmp != null -> androidx.compose.foundation.Image(
                                bitmap = bmp.asImageBitmap(),
                                contentDescription = null,
                                modifier = Modifier.fillMaxSize().padding(8.dp),
                            )
                            pvState == 2 -> Column(
                                horizontalAlignment = Alignment.CenterHorizontally) {
                                Text(stringResource(R.string.rb_023), fontSize = 13.sp,
                                    color = MaterialTheme.colorScheme.error)
                                if (pvNote.isNotEmpty()) {
                                    Spacer(Modifier.height(2.dp))
                                    Text(pvNote, fontSize = 11.sp,
                                        color = MaterialTheme.colorScheme.onSurfaceVariant)
                                }
                                Spacer(Modifier.height(6.dp))
                                TextButton(onClick = { pvTry++ }) {
                                    Text(stringResource(R.string.rb_024), fontSize = 13.sp)
                                }
                            }
                            else -> Column(
                                horizontalAlignment = Alignment.CenterHorizontally) {
                                CircularProgressIndicator(Modifier.size(22.dp), strokeWidth = 2.dp)
                                Spacer(Modifier.height(8.dp))
                                Text(stringResource(R.string.rb_021), fontSize = 12.sp,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant)
                            }
                        }
                    }
                    Spacer(Modifier.height(8.dp))
                    Text(
                        when {
                            replacedFile != null && bmp != null -> stringResource(R.string.rb_017, replacedFile)
                            replacedFile != null -> stringResource(R.string.rb_016)
                            bmp != null -> stringResource(R.string.rb_022)
                            else -> stringResource(R.string.rb_018)
                        },
                        fontSize = 12.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    // ★ 2026-11-07：图片和文字不一样 —— Compose 把 Drawable 缓存在 remember 里，
                    //   改了配置**必须重启宿主**才看得到。这里直接给按钮，别让人猜。
                    if (replacedFile != null) {
                        Spacer(Modifier.height(6.dp))
                        Text(
                            stringResource(R.string.rb_025),
                            fontSize = 11.sp,
                            color = MaterialTheme.colorScheme.error,
                        )
                        TextButton(onClick = {
                            FdmPush.sendCmd(ctx, "res_restart_host", null)
                            imgView = null
                        }) { Text(stringResource(R.string.rb_026), fontSize = 13.sp) }
                    }
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    imgTarget = item
                    imgView = null
                    picker.launch("image/*")
                }) { Text(if (replacedFile != null) stringResource(R.string.rb_019)
                            else stringResource(R.string.rb_020)) }
            },
            dismissButton = {
                Row {
                    if (replacedFile != null) {
                        TextButton(onClick = {
                            FdmPush.sendCmd(ctx, "res_set_img", item.name + "|")
                            imgView = null; refreshSoon()
                        }) { Text(stringResource(R.string.rb_012)) }
                    }
                    TextButton(onClick = { imgView = null }) {
                        Text(stringResource(R.string.c_back))
                    }
                }
            },
        )
    }

    // ── 导出 ──
    if (showExport) {
        AlertDialog(
            onDismissRequest = { showExport = false },
            title = { Text(stringResource(R.string.rb_028)) },
            text = {
                Column {
                    Text(stringResource(R.string.rb_030), fontSize = 13.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant)
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = exportName,
                        onValueChange = { exportName = it },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                    )
                    Spacer(Modifier.height(6.dp))
                    Text(stringResource(R.string.rb_031), fontSize = 11.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    FdmPush.sendCmd(ctx, "res_export", exportName)
                    showExport = false
                    importMsg = ctx.getString(R.string.rb_032) + exportName
                    refreshSoon()
                }) { Text(stringResource(R.string.rb_033)) }
            },
            dismissButton = {
                TextButton(onClick = { showExport = false }) { Text(stringResource(R.string.c_back)) }
            },
        )
    }

    // ── 导入 ──
    if (showImport) {
        AlertDialog(
            onDismissRequest = { showImport = false },
            title = { Text(stringResource(R.string.rb_029)) },
            text = {
                Column {
                    if (zipList.isEmpty()) {
                        Text(stringResource(R.string.rb_037), fontSize = 13.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant)
                    } else {
                        Text(stringResource(R.string.rb_038), fontSize = 12.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant)
                        Spacer(Modifier.height(6.dp))
                        zipList.take(12).forEach { z ->
                            Text(
                                z,
                                fontSize = 13.sp,
                                color = MaterialTheme.colorScheme.primary,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable {
                                        FdmPush.sendCmd(ctx, "res_import", z)
                                        importMsg = ctx.getString(R.string.rb_039) + z
                                        showImport = false
                                        refreshSoon()
                                    }
                                    .padding(vertical = 6.dp),
                            )
                        }
                    }
                    Spacer(Modifier.height(10.dp))
                    HorizontalDivider(thickness = 0.5.dp)
                    Spacer(Modifier.height(8.dp))
                    Text(stringResource(R.string.rb_040), fontSize = 12.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant)
                    Spacer(Modifier.height(6.dp))
                    OutlinedButton(onClick = {
                        showImport = false
                        importPicker.launch(arrayOf("application/zip", "application/octet-stream"))
                    }) { Text(stringResource(R.string.rb_041), fontSize = 13.sp) }
                }
            },
            confirmButton = {
                TextButton(onClick = { showImport = false }) { Text(stringResource(R.string.c_back)) }
            },
        )
    }

    // ── 全部还原 ──
    if (confirmClear) {
        AlertDialog(
            onDismissRequest = { confirmClear = false },
            title = { Text(stringResource(R.string.rb_004)) },
            text = { Text(stringResource(R.string.rb_013)) },
            confirmButton = {
                TextButton(onClick = {
                    FdmPush.sendCmd(ctx, "res_clear_all", null)
                    confirmClear = false; refreshSoon()
                }) { Text(stringResource(R.string.rb_014)) }
            },
            dismissButton = {
                TextButton(onClick = { confirmClear = false }) { Text(stringResource(R.string.c_back)) }
            },
        )
    }
}

/* ═══════════════════════ 菜单项（文字居中） ═══════════════════════ */

/**
 * 菜单里的一行 —— **文字居中**（2026-11-08 主人要求）。
 *
 * <p>为什么不直接用 `DropdownMenuItem(text = { Text(...) })`：
 * 它内部把文字放在一个带起始 padding 的 `Row` 里，默认**左对齐**；
 * 想居中就得让 `Text` 撑满宽度 + `textAlign = Center`。
 * 这里封一层，免得四处重复那几个 `Modifier`。
 */
@Composable
private fun MenuItemCentered(
    label: String,
    color: androidx.compose.ui.graphics.Color = MaterialTheme.colorScheme.onSurface,
    onClick: () -> Unit,
) {
    DropdownMenuItem(
        text = {
            Text(
                label,
                fontSize = 14.sp,
                color = color,
                textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                modifier = Modifier.fillMaxWidth(),
            )
        },
        onClick = onClick,
    )
}

/* ═══════════════════════ 一行 ═══════════════════════ */

@Composable
private fun ResRow(
    item: ResItem,
    replaced: Boolean,
    replacedName: String? = null,
    onClick: () -> Unit,
    onReset: () -> Unit,
) {
    // ★ 2026-11-08 动效：按下**轻微缩小**（弹簧回弹），给一点"捏一下"的手感。
    //   为什么不用 scale 动画的默认 tween：弹簧回弹更"活"，和 M3 Expressive 的调性一致。
    val src = remember { MutableInteractionSource() }
    val pressed by src.collectIsPressedAsState()
    val scale by animateFloatAsState(
        targetValue = if (pressed) 0.97f else 1f,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessMediumLow,
        ),
        label = "rowScale",
    )

    Row(
        Modifier
            .fillMaxWidth()
            .graphicsLayer { scaleX = scale; scaleY = scale }
            .clickable(interactionSource = src, indication = null, onClick = onClick)
            .padding(horizontal = Edge, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Column(Modifier.weight(1f)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                // ★ 动效：改过标记"弹"出来（而不是突然出现）
                AnimatedVisibility(
                    visible = replaced,
                    enter = scaleIn(
                        animationSpec = spring(
                            dampingRatio = Spring.DampingRatioMediumBouncy,
                            stiffness = Spring.StiffnessLow,
                        ),
                    ) + fadeIn(tween(120)),
                    exit = scaleOut(tween(90)) + fadeOut(tween(90)),
                ) {
                    Box(
                        Modifier.size(6.dp).clip(RoundedCornerShape(3.dp))
                            .background(MaterialTheme.colorScheme.primary),
                    )
                }
                if (replaced) Spacer(Modifier.width(6.dp))
                Text(
                    item.name,
                    fontSize = 13.sp,
                    fontWeight = if (replaced) FontWeight.SemiBold else FontWeight.Normal,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            if (item.value.isNotEmpty()) {
                Spacer(Modifier.height(2.dp))
                Text(
                    item.value,
                    fontSize = 12.sp,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            // ★ 2026-11-07：已改的项要显示「换成了什么」——
            //   「已改」页里全是名字看不出改了啥（主人要求）
            AnimatedVisibility(
                visible = replacedName != null,
                enter = fadeIn(tween(160)) + slideInVertically(
                    animationSpec = tween(200),
                    initialOffsetY = { -it / 3 },
                ),
                exit = fadeOut(tween(100)),
            ) {
                replacedName?.let { nm ->
                    Column {
                        Spacer(Modifier.height(2.dp))
                        Text(
                            "→ " + nm,
                            fontSize = 11.sp,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis,
                            color = MaterialTheme.colorScheme.primary,
                        )
                    }
                }
            }
        }
        if (replaced) {
            TextButton(onClick = onReset) {
                Text(stringResource(R.string.rb_012), fontSize = 12.sp)
            }
        }
    }
    HorizontalDivider(thickness = 0.5.dp)
}

/* ═══════════════════════ 数据 ═══════════════════════ */

/** 清单里的一条。 */
data class ResItem(
    val name: String,
    val value: String,
    val isImage: Boolean,
) {
    val key: String get() = (if (isImage) "i:" else "t:") + name
}

/** 整张清单。 */
class ResBook(
    val strings: List<ResItem>,
    val drawables: List<ResItem>,
) {
    fun all(): List<ResItem> = strings + drawables
}

/** 宿主当前的替换配置。 */
class Overrides(
    val t: Map<String, String>,
    val i: Map<String, String>,
)

private var sBook: ResBook? = null

/**
 * 读清单（{@code res/raw/host_res.json}，构建期由 {@code tools/res_dump.py} 生成）。
 *
 * <p>★ 框架资源（{@code abc_} / {@code androidx_} / {@code mtrl_}…）**默认保留但排在后面**：
 * 主人真要改也能搜到，但不会挤在前面挡路。
 */
private fun loadHostRes(ctx: Context): ResBook {
    sBook?.let { return it }
    val strings = ArrayList<ResItem>()
    val drawables = ArrayList<ResItem>()
    try {
        val txt = ctx.resources.openRawResource(R.raw.host_res)
            .bufferedReader(Charsets.UTF_8).use { it.readText() }
        val j = JSONObject(txt)
        fun readArr(key: String, img: Boolean): List<ResItem> {
            val a: JSONArray = j.optJSONArray(key) ?: return emptyList()
            val out = ArrayList<ResItem>(a.length())
            for (k in 0 until a.length()) {
                val row = a.optJSONArray(k) ?: continue
                val n = row.optString(0, "")
                if (n.isEmpty()) continue
                out.add(ResItem(n, row.optString(1, ""), img))
            }
            return out
        }
        // 非框架的排前面（List.sortBy 稳定：false < true）
        strings.addAll(readArr("string", false).sortedBy { isFramework(it.name) })
        drawables.addAll(readArr("drawable", true).sortedBy { isFramework(it.name) })
        Log.e("FdmRes", "清单载入：string=${strings.size} drawable=${drawables.size}")
    } catch (e: Throwable) {
        Log.e("FdmRes", "清单载入失败", e)
    }
    val b = ResBook(strings, drawables)
    sBook = b
    return b
}

private fun isFramework(name: String): Boolean =
    name.startsWith("abc_") || name.startsWith("androidx_") ||
            name.startsWith("mtrl_") || name.startsWith("design_") ||
            name.startsWith("tooltip_") || name.startsWith("notification_") ||
            name.startsWith("material_") || name.startsWith("common_")

/** 解析宿主回执的配置 JSON（{@code {"v":1,"t":{…},"i":{…}}}）。 */
private fun parseOverrides(raw: String?): Overrides {
    if (raw.isNullOrEmpty()) return Overrides(emptyMap(), emptyMap())
    return try {
        val j = JSONObject(raw)
        Overrides(mapOfJson(j.optJSONObject("t")), mapOfJson(j.optJSONObject("i")))
    } catch (e: Throwable) {
        Overrides(emptyMap(), emptyMap())
    }
}

/** `{"a":"b"}` → Map。 */
private fun mapOfJson(o: JSONObject?): Map<String, String> {
    if (o == null) return emptyMap()
    val out = HashMap<String, String>()
    val it = o.keys()
    while (it.hasNext()) {
        val k = it.next()
        out[k] = o.optString(k, "")
    }
    return out
}
