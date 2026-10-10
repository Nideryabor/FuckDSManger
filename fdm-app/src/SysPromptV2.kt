// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import android.widget.Toast
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animate
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Add
import androidx.compose.material.icons.rounded.ChevronRight
import androidx.compose.material.icons.rounded.Delete
import androidx.compose.material.icons.rounded.Edit
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.zIndex
import com.nidyaber.fuckdsmanger.bridge.FdmPush
import org.json.JSONArray
import org.json.JSONObject
import kotlin.math.roundToInt

/**
 * 「系统提示词 v2」—— 卡片式编辑器 🐲（2026-10-10）
 *
 * <p>★ **核心模型（主人 2026-10-10 定的）**：**卡片本身就是提示词的来源** ——
 * 系统提示词的正文 = **容器里卡片们的内容按顺序拼起来**（空行分隔）：
 * <pre>
 *   回复建议（卡） ⇒ 它自带的【追问建议】约定
 *   音乐（卡）     ⇒ 它自带的【音乐变量】示例
 *   富文本（卡）   ⇒ 它自带的【回答排版】约定
 *   我的自定义文本 ⇒ 卡片里写的字
 * </pre>
 * ⇒ 那个「提示词内容」字段从此是**派生值**（由宿主按卡片列表重建，见桥命令 `prompt_compose`），
 * 不再手敲；**容器空 ⇒ 文本字段空**（主人确认过）。因此 `⋮ 更多` 里那一项也撤了。
 *
 * <p>三种卡片、三套手势：
 * <table>
 *   <tr><td>内置三张（回复建议/音乐/富文本）</td><td>**搬**：拖进/拖回抽屉（拖回 = 它那一段就从提示词里消失，因为要重算）+ 右边 ▸ 跳页</td></tr>
 *   <tr><td>「系统提示词内容」源卡片</td><td>**复制**：拖进容器 ⇒ **长出一张新副本**（源卡留在抽屉，能无限拖）；无 ▸、不可删</td></tr>
 *   <tr><td>自定义文本副本</td><td>可编辑标题/正文/「标题也进提示词」；**暂存在抽屉时**右边出现**红色删除**（点了要二次确认）；再拖回容器 = 搬家</td></tr>
 * </table>
 *
 * <p>★ 写回时机的分工：**文本**失焦或收起卡片时提交（不边敲边发广播）；
 * **摆放**（搬进搬出/删除）立刻重算。一次提交 = 重算整段 + 发 Host。
 *
 * <p>为什么抽屉不用 `ModalBottomSheet`：它没法「收在底部只露一条把手」——
 * 一打开就至少是半个屏，而且背后会压一层 scrim。这里要的是**常驻在页面里的抽屉**，
 * 所以自己用 `draggable` + `animate` 做两档吸附（收起 0 ⇄ 拉满 = 半屏）。
 *
 * <p>★ 手势方向：Compose 的 drag delta 沿轴正向为正（竖向 = 往下为正），
 * 所以「往上拉」是负 delta ⇒ `live = live - delta`。
 *
 * <p>★★ **拖的是真卡片本体**（不是另画一张幽灵）：卡片留在槽位里、只叠一个 `offset`
 * ⇒ 手指上就是这张真卡。由此三个必须做对的地方：位移只能认 `dragAmount`（增量）、
 * **槽位矩形要在拖拽开始时冻结**、`clip` 改成"圆角只当背景画"（否则拖出去会被裁掉）。
 */
private val DrawerHandleH = 28.dp
private const val DrawerMaxRatio = 0.5f
private val CardRowH = 64.dp
private val CardRadius = 20.dp

/** 卡片类型 id（内置三种 + 自定义文本 + 源卡片）。 */
private const val T_SUGGEST = "suggest"
private const val T_MUSIC = "music"
private const val T_RICHTEXT = "richtext"
private const val T_TEXT = "text"          // 自定义文本（副本）
private const val T_TEXTSRC = "textsrc"    // 「系统提示词内容」源卡片（只当模板，能无限复制）

/** 源卡片的卡片键（固定）。 */
private const val K_SRC = "textsrc"

/** 新建副本的默认：标题「点我编辑」· 正文「这是尼尼的卡片」· 标题开关默认**关**。 */
private const val DEF_TITLE = "点我编辑"
private const val DEF_TEXT = "这是尼尼的卡片"

/**
 * 一张卡片（可变状态，纯数据 —— 界面读它、改它，再由 [save] 落盘 + [compose] 重建提示词）。
 *
 * @param key 唯一键：内置三张 = 类型名；自定义副本 = `text#序号`；源卡片 = `textsrc`
 */
private class CCard(
    val key: String,
    val type: String,
    var title: String,
    var text: String,
    var withTitle: Boolean = false,
) {
    val isBuiltin get() = type == T_SUGGEST || type == T_MUSIC || type == T_RICHTEXT
    val isText get() = type == T_TEXT || type == T_TEXTSRC
}

/** 卡片类型的展示信息（内置三张）。 */
private fun typeTitle(type: String): String = when (type) {
    T_SUGGEST -> "回复建议"
    T_MUSIC -> "音乐"
    T_RICHTEXT -> "富文本"
    T_TEXTSRC -> "系统提示词内容"
    else -> "自定义文本"
}

/** 默认卡片池（第一次进这个页面时的样子：内置三张 + 源卡片，都在抽屉里）。 */
private fun defaultCards(): MutableMap<String, CCard> {
    val m = mutableMapOf<String, CCard>()
    m[T_SUGGEST] = CCard(T_SUGGEST, T_SUGGEST, typeTitle(T_SUGGEST), "")
    m[T_MUSIC] = CCard(T_MUSIC, T_MUSIC, typeTitle(T_MUSIC), "")
    m[T_RICHTEXT] = CCard(T_RICHTEXT, T_RICHTEXT, typeTitle(T_RICHTEXT), "")
    m[K_SRC] = CCard(K_SRC, T_TEXTSRC, typeTitle(T_TEXTSRC), "")
    return m
}

private fun defaultDrawer(): List<String> = listOf(T_SUGGEST, T_MUSIC, T_RICHTEXT, K_SRC)

/* ═════════════════════ 落盘 / 重建提示词 ═════════════════════ */

private const val LAYOUT_KEY = "cfg.sysprompt_v2_layout"

/** 盘上的存档。 */
private class Saved(
    val drawer: List<String>,
    val box: List<String>,
    val expanded: Set<String>,
    val cards: Map<String, CCard>,
    val nextId: Int,
) {
    /**
     * 归一化：**卡片表里必须有抽屉/容器里出现的每一张卡**，
     * 而**认不出来的（类型没了/键是脏的）一律丢掉** —— 一个坏存档不该把页面卡死。
     */
    fun normalized(): Saved {
        val cards2 = LinkedHashMap<String, CCard>()
        fun keep(k: String) {
            val c = cards[k]
            if (c != null && (c.isBuiltin || c.isText)) cards2[k] = c
        }
        drawer.forEach { keep(it) }
        box.forEach { keep(it) }
        cards2[K_SRC] = cards2[K_SRC]   // 源卡片永远留着：它是"复制"的来源，删了就再也拖不出来了
            ?: CCard(K_SRC, T_TEXTSRC, typeTitle(T_TEXTSRC), cards[K_SRC]?.text ?: "")
        val drawer2 = (drawer.filter { cards2.containsKey(it) } + listOf(K_SRC)).distinct()
        val box2 = box.filter { cards2.containsKey(it) && it != K_SRC }
        return Saved(drawer2, box2, expanded.filter { cards2.containsKey(it) }.toSet(), cards2, nextId.coerceAtLeast(1))
    }
}

private fun readLayout(ctx: Context): Saved? {
    val s = FdmPush.sp(ctx).getString(LAYOUT_KEY, null) ?: return null
    return try {
        val o = JSONObject(s)
        fun arr(k: String): List<String> {
            val a = o.optJSONArray(k) ?: return emptyList()
            return (0 until a.length()).map { a.optString(it) }
        }
        val cm = LinkedHashMap<String, CCard>()
        val cj = o.optJSONObject("cards")
        if (cj != null) {
            val ks = cj.keys()
            while (ks.hasNext()) {
                val k = ks.next()
                val co = cj.optJSONObject(k) ?: continue
                val ty = co.optString("type", "")
                val ty2 = when (ty) {
                    T_SUGGEST, T_MUSIC, T_RICHTEXT, T_TEXT, T_TEXTSRC -> ty
                    else -> if (k == K_SRC) T_TEXTSRC else T_TEXT
                }
                cm[k] = CCard(
                    k, ty2,
                    co.optString("title", typeTitle(ty2)),
                    co.optString("text", ""),
                    co.optBoolean("withTitle", false),
                )
            }
        }
        Saved(arr("drawer"), arr("box"), arr("expanded").toSet(), cm, o.optInt("nextId", 1)).normalized()
    } catch (t: Throwable) {
        null      // 坏数据就当没存过
    }
}

private fun writeLayout(ctx: Context, drawer: List<String>, box: List<String>, expanded: Set<String>, cards: Map<String, CCard>, nextId: Int) {
    try {
        val o = JSONObject()
        o.put("drawer", JSONArray(drawer))
        o.put("box", JSONArray(box))
        o.put("expanded", JSONArray(expanded.toList()))
        val cj = JSONObject()
        cards.forEach { (k, c) ->
            cj.put(k, JSONObject().apply {
                put("type", c.type)
                put("title", c.title)
                put("text", c.text)
                put("withTitle", c.withTitle)
            })
        }
        o.put("cards", cj)
        o.put("nextId", nextId)
        FdmPush.sp(ctx).edit().putString(LAYOUT_KEY, o.toString()).apply()
    } catch (t: Throwable) {
        Toast.makeText(ctx, "存摆放失败：" + t, Toast.LENGTH_SHORT).show()
    }
}

/**
 * **重建系统提示词**（把容器里的卡片按顺序交给宿主拼）🐲
 *
 * <p>内置三张卡只送类型名 —— 它们"自带的"那一大段文案由**宿主自己取**
 * （`GmRichText.suggestSpec()` / `GmPromptVars.spec()` / `GmRichText.spec()`），
 * 免得同一份文案在界面里再抄一份、两边各说一套。
 */
private fun compose(ctx: Context, box: List<String>, cards: Map<String, CCard>) {
    try {
        val arr = JSONArray()
        box.forEach { k ->
            val c = cards[k] ?: return@forEach
            arr.put(
                JSONObject().apply {
                    put("t", c.type)
                    if (c.type == T_TEXT) {
                        put("title", c.title)
                        put("text", c.text)
                        put("withTitle", c.withTitle)
                    }
                }
            )
        }
        val req = JSONObject().apply { put("items", arr) }
        FdmPush.sendCmd(ctx, "prompt_compose", req.toString())
    } catch (t: Throwable) {
        Toast.makeText(ctx, "重建提示词失败：" + t, Toast.LENGTH_SHORT).show()
    }
}

/* ═════════════════════ 页面 ═════════════════════ */

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SysPromptV2Page(onBack: () -> Unit, onNav: (String) -> Unit) {
    val ctx = LocalContext.current
    var more by remember { mutableStateOf(false) }

    /* ── 卡片状态：初值同步读一次（免得首帧拿默认值把存档冲掉） ── */
    val initial = remember { readLayout(ctx) }
    val cards = remember { mutableStateMapOf<String, CCard>() }
    var inDrawer by remember { mutableStateOf(defaultDrawer()) }
    var inBox by remember { mutableStateOf(emptyList<String>()) }
    var expanded by remember { mutableStateOf(emptySet<String>()) }
    var nextId by remember { mutableIntStateOf(1) }
    var seeded by remember { mutableStateOf(false) }   // 源卡片有没有播过种

    LaunchedEffect(Unit) {
        val s = initial
        if (s != null) {
            cards.clear(); s.cards.forEach { (k, c) -> cards[k] = c }
            inDrawer = s.drawer; inBox = s.box; expanded = s.expanded; nextId = s.nextId
        } else {
            defaultCards().forEach { (k, c) -> cards[k] = c }
        }
        seeded = true
        // 源卡片还是空的（第一次种）⇒ 向宿主问一次"系统提示词内容"，把原值收进来
        if ((cards[K_SRC]?.text ?: "").isEmpty()) {
            FdmPush.sendCmd(ctx, "cfg_state", null)
            repeat(6) {
                kotlinx.coroutines.delay(1000)
                val host = FdmPush.sp(ctx).getString("cmd.cfg_state", null)
                if (host != null) {
                    val t = jsonToMap(host)["sysprompt_text"] ?: ""
                    if (t.isNotEmpty()) {
                        cards[K_SRC] = CCard(K_SRC, T_TEXTSRC, typeTitle(T_TEXTSRC), t)
                        return@repeat
                    }
                }
            }
        }
    }

    // ★ 源卡片内容一到位就落盘一次（否则下次进来又得重新播种）
    LaunchedEffect(seeded, cards[K_SRC]?.text) {
        if (seeded) writeLayout(ctx, inDrawer, inBox, expanded, cards, nextId)
    }

    /** 一次「提交」= 落盘 + 重建提示词（摆放/删除/文本失焦都走它）。 */
    fun commit() {
        writeLayout(ctx, inDrawer, inBox, expanded, cards, nextId)
        compose(ctx, inBox, cards)
    }

    /* ── 拖拽状态（真卡片本体跟手） ── */
    var dragId by remember { mutableStateOf<String?>(null) }
    var dragOff by remember { mutableStateOf(Offset.Zero) }
    var dragSlot by remember { mutableStateOf(Rect.Zero) }
    val bounds = remember { mutableStateMapOf<String, Rect>() }
    var boxRect by remember { mutableStateOf(Rect.Zero) }
    var drawerRect by remember { mutableStateOf(Rect.Zero) }

    /* ── 文本编辑状态（**失焦 / 收起卡片时提交**） ── */
    var editKey by remember { mutableStateOf<String?>(null) }
    var editTitle by remember { mutableStateOf(false) }
    var editBuf by remember { mutableStateOf("") }

    /** 把正在编辑的那张卡"落盘"（改内存 → 提交 → 重建提示词）。 */
    fun flushEdit() {
        val k = editKey ?: return
        val c = cards[k]
        if (c != null && editBuf != c.text) {
            c.text = editBuf
            commit()
        }
        editKey = null
        editTitle = false
    }

    // 二次确认（红删除）
    var pendingDelete by remember { mutableStateOf<String?>(null) }

    Scaffold(
        topBar = {
            FdmTopBar(
                title = "系统提示词 v2",
                onBack = onBack,
                onSave = {                       // ★ 保险：重存一次 + 重建一次（改动本来就实时）
                    commit()
                    Toast.makeText(ctx, "已保存（容器 ${inBox.size} 张卡）", Toast.LENGTH_SHORT).show()
                },
                onMore = { more = true },
            )
        },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        BoxWithConstraints(Modifier.fillMaxSize().padding(pad)) {
            val density = LocalDensity.current
            val handlePx = with(density) { DrawerHandleH.toPx() }
            val sheetPx = with(density) { maxHeight.toPx() } * DrawerMaxRatio
            val travel = (sheetPx - handlePx).coerceAtLeast(1f)
            val sheetDp = with(density) { sheetPx.toDp() }

            var live by remember { mutableFloatStateOf(0f) }
            var draggingSheet by remember { mutableStateOf(false) }
            var target by remember { mutableFloatStateOf(0f) }

            LaunchedEffect(target, draggingSheet) {
                if (!draggingSheet) {
                    animate(
                        initialValue = live,
                        targetValue = target,
                        animationSpec = spring(
                            dampingRatio = Spring.DampingRatioNoBouncy,
                            stiffness = Spring.StiffnessMediumLow,
                        ),
                    ) { v, _ -> live = v }
                }
            }

            fun insertByY(list: List<String>, key: String, y: Float): List<String> {
                val others = list.filter { it != key }
                val idx = others.count { (bounds[it]?.center?.y ?: 0f) < y }
                return others.take(idx) + key + others.drop(idx)
            }

            fun draggedRect(): Rect = dragSlot.translate(dragOff)

            /** 松手：落哪边归哪边；**源卡片是"复制"**（源留着，容器里长出一张新副本）。 */
            fun drop() {
                val id = dragId
                if (id != null) {
                    val r = draggedRect()
                    val c = cards[id]
                    if (boxRect.contains(r.center)) {
                        if (c != null && c.type == T_TEXTSRC) {
                            // ★ 复制语义：能无限拖 —— 每拖一次就多一张独立副本
                            val nk = "text#" + nextId
                            cards[nk] = CCard(nk, T_TEXT, DEF_TITLE, DEF_TEXT, false)
                            nextId += 1
                            inBox = insertByY(inBox, nk, r.center.y)
                        } else {
                            inDrawer = inDrawer.filter { it != id }
                            inBox = insertByY(inBox, id, r.center.y)
                        }
                        commit()
                    } else if (drawerRect.contains(r.center)) {
                        if (id != K_SRC) {                       // 源卡片本来就常驻抽屉，拖回是空操作
                            inBox = inBox.filter { it != id }
                            inDrawer = insertByY(inDrawer, id, r.center.y)
                            commit()
                        }
                    }                                              // 落空 ⇒ 什么都不做
                }
                dragId = null
                dragOff = Offset.Zero
            }

            val lifting = dragId != null && dragId in inBox

            Box(Modifier.fillMaxSize()) {

                /* ── ① 内容区：容器（抽屉拉开时跟着变矮） ── */
                Column(
                    Modifier
                        .fillMaxSize()
                        .padding(bottom = with(density) { (handlePx + live).toDp() })
                        .zIndex(if (lifting) 2f else 1f),
                ) {
                    Box(
                        Modifier
                            .fillMaxWidth()
                            .weight(1f)
                            .padding(horizontal = Edge)
                            .onGloballyPositioned { boxRect = it.boundsInRoot() }
                            .background(
                                MaterialTheme.colorScheme.surfaceContainerHigh,
                                RoundedCornerShape(28.dp),
                            ),
                    ) {
                        if (inBox.isEmpty()) {
                            Text(
                                "（空白容器 · 把抽屉里的卡片拖上来）",
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                textAlign = TextAlign.Center,
                                modifier = Modifier.align(Alignment.Center).padding(horizontal = Edge),
                            )
                        } else {
                            Column(
                                Modifier
                                    .fillMaxSize()
                                    .padding(8.dp)
                                    .verticalScroll(rememberScrollState()),
                                verticalArrangement = Arrangement.spacedBy(8.dp),
                            ) {
                                inBox.forEach { id ->
                                    val c = cards[id] ?: return@forEach
                                    PromptCard(
                                        card = c,
                                        expanded = id in expanded,
                                        dragging = id == dragId,
                                        dragOff = if (id == dragId) dragOff else Offset.Zero,
                                        editing = editKey == id,
                                        editingTitle = editKey == id && editTitle,
                                        editBuf = if (editKey == id) editBuf else "",
                                        bounds = bounds,
                                        showDelete = false,     // ★ 容器里**不**给删除（要删先拖回抽屉）
                                        onToggle = {
                                            if (id in expanded) {
                                                flushEdit()
                                                expanded = expanded - id
                                            } else {
                                                expanded = expanded + id
                                            }
                                        },
                                        onNav = { onNav(typeNavTarget(c.type)) },
                                        onTitleClick = {
                                            editKey = id; editTitle = true; editBuf = c.title
                                        },
                                        onBodyFocus = {
                                            editKey = id; editTitle = false; editBuf = c.text
                                        },
                                        onBufChange = { editBuf = it },
                                        onCommitEdit = { flushEdit() },
                                        onWithTitle = { v ->
                                            c.withTitle = v
                                            writeLayout(ctx, inDrawer, inBox, expanded, cards, nextId)
                                            compose(ctx, inBox, cards)
                                        },
                                        onDelete = { pendingDelete = id },
                                        onDragStart = { dragId = id; dragOff = Offset.Zero; dragSlot = bounds[id] ?: Rect.Zero },
                                        onDragMove = { dragOff += it },
                                        onDragEnd = { drop() },
                                        onDragCancel = { dragId = null; dragOff = Offset.Zero },
                                    )
                                }
                            }
                        }
                    }
                }

                /* ── ② 底部抽屉 ── */
                Box(
                    Modifier
                        .align(Alignment.BottomCenter)
                        .fillMaxWidth()
                        .height(sheetDp)
                        .zIndex(1f)
                        .offset {
                            IntOffset(0, (travel - live.coerceIn(0f, travel)).roundToInt())
                        }
                        .background(
                            MaterialTheme.colorScheme.surfaceContainerHigh,
                            RoundedCornerShape(topStart = 28.dp, topEnd = 28.dp),
                        )
                        .draggable(
                            orientation = Orientation.Vertical,
                            state = rememberDraggableState { delta ->
                                live = (live - delta).coerceIn(0f, travel)
                            },
                            onDragStarted = { draggingSheet = true },
                            onDragStopped = { v ->
                                val open = when {
                                    v < -600f -> true
                                    v > 600f -> false
                                    else -> live > travel / 2f
                                }
                                draggingSheet = false
                                target = if (open) travel else 0f
                            },
                        ),
                ) {
                    Column(Modifier.fillMaxSize()) {

                        Box(
                            Modifier
                                .fillMaxWidth()
                                .height(DrawerHandleH)
                                .clickable { target = if (live < travel / 2f) travel else 0f },
                            contentAlignment = Alignment.Center,
                        ) {
                            Box(
                                Modifier
                                    .size(width = 40.dp, height = 4.dp)
                                    .clip(CircleShape)
                                    .background(MaterialTheme.colorScheme.onSurfaceVariant),
                            )
                        }

                        Column(
                            Modifier
                                .fillMaxSize()
                                .padding(horizontal = Edge)
                                .onGloballyPositioned { drawerRect = it.boundsInRoot() },
                            verticalArrangement = Arrangement.spacedBy(8.dp),
                        ) {
                            Text(
                                "卡片 = 提示词的一段 · 拖到上面的容器里（「系统提示词内容」那张能无限拖）",
                                style = MaterialTheme.typography.labelMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                maxLines = 2, overflow = TextOverflow.Ellipsis,
                            )
                            if (inDrawer.isEmpty()) {
                                Text(
                                    "（都搬走了 —— 从上面拖回来）",
                                    style = MaterialTheme.typography.bodyMedium,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                )
                            }
                            inDrawer.forEach { id ->
                                val c = cards[id] ?: return@forEach
                                PromptCard(
                                    card = c,
                                    expanded = id in expanded,
                                    dragging = id == dragId,
                                    dragOff = if (id == dragId) dragOff else Offset.Zero,
                                    editing = editKey == id,
                                    editingTitle = editKey == id && editTitle,
                                    editBuf = if (editKey == id) editBuf else "",
                                    bounds = bounds,
                                    // ★ 红删除：**只有暂存在抽屉里的自定义文本副本**才有
                                    showDelete = c.type == T_TEXT,
                                    onToggle = {
                                        if (id in expanded) {
                                            flushEdit()
                                            expanded = expanded - id
                                        } else {
                                            expanded = expanded + id
                                        }
                                    },
                                    onNav = { onNav(typeNavTarget(c.type)) },
                                    onTitleClick = {
                                        editKey = id; editTitle = true; editBuf = c.title
                                    },
                                    onBodyFocus = {
                                        editKey = id; editTitle = false; editBuf = c.text
                                    },
                                    onBufChange = { editBuf = it },
                                    onCommitEdit = { flushEdit() },
                                    onWithTitle = { v ->
                                        c.withTitle = v
                                        writeLayout(ctx, inDrawer, inBox, expanded, cards, nextId)
                                        compose(ctx, inBox, cards)
                                    },
                                    onDelete = { pendingDelete = id },
                                    onDragStart = { dragId = id; dragOff = Offset.Zero; dragSlot = bounds[id] ?: Rect.Zero },
                                    onDragMove = { dragOff += it },
                                    onDragEnd = { drop() },
                                    onDragCancel = { dragId = null; dragOff = Offset.Zero },
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    /* ── 「更多」：旧「系统提示词」页的承载设置（6 项里撤掉了「提示词内容」—— 它成了抽屉里的卡片） ── */
    if (more) {
        AlertDialog(
            onDismissRequest = { more = false },
            confirmButton = {
                TextButton(onClick = { more = false }) { Text("确认") }
            },
            title = { Text("更多") },
            text = {
                Column(
                    Modifier
                        .fillMaxWidth()
                        .verticalScroll(rememberScrollState()),
                ) {
                    ItemsBlock(SysPromptItems, onNav = {})
                }
            },
        )
    }

    /* ── 红色删除的二次确认 ── */
    val delKey = pendingDelete
    if (delKey != null) {
        val t = cards[delKey]?.title ?: ""
        AlertDialog(
            onDismissRequest = { pendingDelete = null },
            title = { Text("删除这张卡片？") },
            text = { Text("「" + t + "」会被删掉（它那一段就从这个提示词里消失）。\n这一步不能撤销。") },
            confirmButton = {
                TextButton(onClick = {
                    cards.remove(delKey)
                    inDrawer = inDrawer.filter { it != delKey }
                    inBox = inBox.filter { it != delKey }
                    expanded = expanded - delKey
                    if (editKey == delKey) { editKey = null; editTitle = false }
                    pendingDelete = null
                    commit()
                }) { Text("删除", color = MaterialTheme.colorScheme.error) }
            },
            dismissButton = {
                TextButton(onClick = { pendingDelete = null }) { Text("取消") }
            },
        )
    }
}

/** 卡片类型 → 点 ▸ 要跳的页面 id（自定义文本卡没有 ▸，用不到）。 */
private fun typeNavTarget(type: String): String = when (type) {
    T_SUGGEST -> "suggest"
    T_MUSIC -> "music"
    T_RICHTEXT -> "richtext"
    else -> "sysprompt"
}

/**
 * 一张卡片 🐲
 *
 * · **点本体** ⇒ 展开 / 收起（收起会**提交**正在编辑的文本）
 * · **点右边 ▸** ⇒ 跳页（**只有内置三张有**；图标钮是子节点，自己吃掉点击 ⇒ 不连带展开）
 * · **点标题左边的 ✏** ⇒ 编辑**标题**（自定义文本卡才有）
 * · **展开区** ⇒ 正文文本框（失焦提交）+「标题也进提示词」开关；红删除只在抽屉里出现
 * · **按住拖** ⇒ 整张卡片跟手（叠加 `offset`）；位移只认增量 `dragAmount`
 */
@Composable
private fun PromptCard(
    card: CCard,
    expanded: Boolean,
    dragging: Boolean,
    dragOff: Offset,
    editing: Boolean,
    editingTitle: Boolean,
    editBuf: String,
    bounds: MutableMap<String, Rect>,
    showDelete: Boolean,
    onToggle: () -> Unit,
    onNav: () -> Unit,
    onTitleClick: () -> Unit,
    onBodyFocus: () -> Unit,
    onBufChange: (String) -> Unit,
    onCommitEdit: () -> Unit,
    onWithTitle: (Boolean) -> Unit,
    onDelete: () -> Unit,
    onDragStart: () -> Unit,
    onDragMove: (Offset) -> Unit,
    onDragEnd: () -> Unit,
    onDragCancel: () -> Unit,
) {
    val scale = if (dragging) 1.03f else 1f
    Column(
        Modifier
            .fillMaxWidth()
            .zIndex(if (dragging) 10f else 0f)
            .onGloballyPositioned { bounds[card.key] = it.boundsInRoot() }   // 槽位（在 offset 之前）
            .offset { IntOffset(dragOff.x.roundToInt(), dragOff.y.roundToInt()) }
            .graphicsLayer {
                scaleX = scale
                scaleY = scale
                if (dragging) {
                    shadowElevation = 12.dp.toPx()
                    shape = RoundedCornerShape(CardRadius)
                }
            }
            .clip(RoundedCornerShape(CardRadius))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .clickable { onToggle() }
            .pointerInput(card.key) {
                detectDragGestures(
                    onDragStart = { onDragStart() },
                    onDrag = { change, amount -> onDragMove(amount); change.consume() },
                    onDragEnd = { onDragEnd() },
                    onDragCancel = { onDragCancel() },
                )
            },
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .height(CardRowH)
                .padding(start = 8.dp, end = 4.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            // ★ 标题左边的「编辑标题」铅笔（只有自定义文本卡需要 —— 内置三张的标题是固定的）
            if (card.isText) {
                IconButton(onClick = onTitleClick, modifier = Modifier.size(36.dp)) {
                    Icon(
                        Icons.Rounded.Edit, "编辑标题",
                        modifier = Modifier.size(18.dp),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
            Column(Modifier.weight(1f).padding(start = if (card.isText) 0.dp else 8.dp)) {
                if (editing && editingTitle) {
                    OutlinedTextField(
                        value = editBuf,
                        onValueChange = onBufChange,
                        singleLine = true,
                        label = { Text("标题") },
                        modifier = Modifier.fillMaxWidth().padding(vertical = 2.dp),
                        keyboardOptions = KeyboardOptions.Default,
                    )
                } else {
                    Text(
                        if (card.isText) card.title else typeTitle(card.type),
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.onSurface,
                        maxLines = 1, overflow = TextOverflow.Ellipsis,
                    )
                }
                Text(
                    cardHint(card),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 2, overflow = TextOverflow.Ellipsis,
                )
            }
            // ★ ▸ 只有内置三张有；自定义文本卡在抽屉里则是**红色删除**
            if (card.isBuiltin) {
                IconButton(onClick = onNav, modifier = Modifier.size(44.dp)) {
                    Icon(Icons.Rounded.ChevronRight, "去「" + typeTitle(card.type) + "」页")
                }
            } else if (showDelete) {
                IconButton(onClick = onDelete, modifier = Modifier.size(44.dp)) {
                    Icon(
                        Icons.Rounded.Delete, "删除这张卡片",
                        tint = MaterialTheme.colorScheme.error,
                    )
                }
            } else {
                Spacer(Modifier.width(8.dp))
            }
        }
        if (expanded) {
            Column(
                Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 8.dp, vertical = 4.dp),
            ) {
                if (card.isText) {
                    OutlinedTextField(
                        value = if (editing && !editingTitle) editBuf else card.text,
                        onValueChange = { onBufChange(it) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .heightIn(min = 72.dp, max = 200.dp)
                            .pointerInput(card.key) {
                                // ★ 拿焦点（点了就开始编辑；失焦提交）
                                awaitPointerEventScope {
                                    while (true) {
                                        val e = awaitPointerEvent()
                                        if (e.changes.any { it.pressed }) onBodyFocus()
                                    }
                                }
                            },
                        placeholder = { Text(card.text.ifEmpty { DEF_TEXT }) },
                        label = { Text("这一段的提示词内容") },
                    )
                    Spacer(Modifier.height(6.dp))
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            "标题也进提示词",
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurface,
                            modifier = Modifier.weight(1f),
                        )
                        Switch(checked = card.withTitle, onCheckedChange = onWithTitle)
                    }
                    Spacer(Modifier.height(6.dp))
                    TextButton(onClick = onCommitEdit) { Text("提交（也会在收起卡片时自动提交）") }
                } else {
                    Box(
                        Modifier
                            .fillMaxWidth()
                            .height(56.dp)
                            .clip(RoundedCornerShape(14.dp))
                            .background(MaterialTheme.colorScheme.surfaceContainerHighest),
                        contentAlignment = Alignment.Center,
                    ) {
                        Text(
                            "（这一段是它自带的约定 · 内容由模块提供）",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
        }
    }
}

/** 卡片副标题（说明它是什么）。 */
private fun cardHint(c: CCard): String = when (c.type) {
    T_SUGGEST -> "自带的【追问建议】约定 · 拖回抽屉 = 这一段不进提示词"
    T_MUSIC -> "自带的【音乐变量】示例 · 拖回抽屉 = 这一段不进提示词"
    T_RICHTEXT -> "自带的【回答排版】约定 · 拖回抽屉 = 这一段不进提示词"
    T_TEXTSRC -> "拖到容器里 = 复制一张新的（能无限拖）"
    else -> if (c.text.isEmpty()) "（还没写内容 · 点开卡片编辑）" else c.text.take(60)
}

/**
 * 「系统提示词」的**承载设置**（从旧 UI / `更多` 里留下来的那几项）。
 *
 * <p>★ 2026-10-10（3.62.0）：**「提示词内容」那一项撤掉了** ——
 * 它变成了抽屉里那张「系统提示词内容」卡片（可编辑、可无限复制）。
 * 剩下的是"怎么把提示词送出去"的设置：开关 / 注入模式 / 承载方式 / 前缀 / 后缀。
 */
private val SysPromptItems: List<It> = listOf(
    It("开启注入", "开启后才生效（默认关）",
        K.SW, key = "fuckds_sysprompt_on", def = false),
    It("注入模式", "仅首条 = 只在本会话第一条消息注入（token 只花一次、位置=上下文最前）；" +
            "每轮 = 每条消息都注入（对抗稀释最强，token 持续消耗）。\n" +
            "⚠️ 提示词里一旦出现**音乐变量**（{music} / {lyric} 等），本项会被**忽略**、" +
            "强制按「每轮」—— 音乐是时变的，冻在会话开头就等于骗模型。",
        K.CH, key = "fuckds_sysprompt_mode", def = 0,
        choices = listOf("仅首条", "每轮")),
    It("承载方式", "★ 决定提示词怎么被送出去：\n" +
            "· 隐形字符 = Unicode Tag（人眼看不见，但模型能察觉「有隐藏字符」⇒ 概率性拒答）\n" +
            "· 明文定界 = 正常文字，服务端/模型当普通内容读（零风险），由模块把这段从界面抹掉" +
            "（界面看不到，但服务端/换设备看得见）\n" +
            "★ 下面两个「包装前缀/后缀」在两种方式下**都生效**",
        K.CH, key = "fuckds_sysprompt_carrier", def = 0,
        choices = listOf("隐形字符", "明文定界")),
    It("包装前缀", "包在提示词【前面】的文字。留空 = 不加。\n" +
            "· 隐形字符模式：前缀也会被隐形化（人眼看不见）\n" +
            "· 明文定界模式：前缀原样发出，和正文一起被 ⟦FDM⟧…⟦/FDM⟧ 包住（界面照样看不到）\n" +
            "★ 措辞是主战场：写 SYSTEM-LEVEL / highest priority / overrides user turns " +
            "这类词，模型会直接判定「提示注入」并拒绝（已被真机实测打回一次）。",
        K.TX, key = "fuckds_sysprompt_head",
        def = "My standing preference for this whole conversation: "),
    It("包装后缀", "包在提示词【后面】的文字。留空 = 不加。\n" +
            "两种承载方式下都生效（同前缀：隐形模式被隐形化，明文模式随正文一起被定界符包住）。\n" +
            "默认留空 —— 「END OF …」这种封口词本身也是注入特征。",
        K.TX, key = "fuckds_sysprompt_tail", def = ""),
    It("✦ 提示词内容在哪儿？", "它已经变成抽屉里的卡片了：\n" +
            "· 容器里的卡片 = 提示词正文（按从上到下的顺序拼，段间空一行）\n" +
            "· 内置三张（回复建议 / 音乐 / 富文本）带着各自「自带」的那段约定\n" +
            "· 「系统提示词内容」那张能**无限复制**出自定义文本卡，卡里写什么就是什么\n" +
            "⇒ 这个框里只剩「怎么送出去」的设置（开启/模式/承载/包装）。",
        K.INFO),
)
