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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ChevronRight
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.positionInRoot
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
 * 「系统提示词 v2」—— 重构页 🐲（2026-10-10）
 *
 * <p>主人：「我们的系统提示词列表比较反人类，我要重构。新界面先塞调试菜单，稳了再并进主菜单。」
 *
 * 1. **页面内的空白容器**（内容区）—— 卡片可以从抽屉**拖进来**、在里面**拖拽排序**。
 * 2. **底部抽屉** —— 可向上拉，最高到**页面 1/2**；初始收在底部、只露一条把手。
 *    抽屉里放三张**提示词卡片**：回复建议 / 音乐 / 富文本。
 * 3. **卡片两件事分得很开**（主人特意定的）：
 *    · **点卡片本体** ⇒ **展开 / 收起**（展开内容**暂时空白**，先占位）
 *    · **点右边那个 ▸ 图标钮** ⇒ **跳到对应页面**（返回回到本页，走 App 的导航栈）
 * 4. **顶部工具栏**：`[保存] [更多]` —— **保存是手动的**，点了才写 JSON；平时不自动落盘。
 *
 * <p>为什么抽屉不用 `ModalBottomSheet`：它没法「收在底部只露一条把手」——
 * 一打开就至少是半个屏，而且背后会压一层 scrim。这里要的是**常驻在页面里的抽屉**，
 * 所以自己用 `draggable` + `animate` 做两档吸附（收起 0 ⇄ 拉满 = 半屏）。
 *
 * <p>★ 手势方向：Compose 的 drag delta 沿轴正向为正（竖向 = 往下为正），
 * 所以「往上拉」是负 delta ⇒ `live = live - delta`。
 *
 * <p>★ 卡片拖拽用的是「**全局幽灵层**」：拖的时候在页面根节点上画一张跟着手指的幽灵卡，
 * 松手时拿**手指在根坐标系里的位置**去撞两个投放区（容器 / 抽屉）的矩形 ——
 * 这样跨容器（抽屉 ⇄ 容器）的搬运不用做任何坐标换算的脏活。
 * 顺序 = 松手时数一数「有几个同列表卡片的中心在我上面」⇒ 得到插入下标（拖拽排序顺手就有了）。
 */

/** 把手条的高度（收起时露出来的就是它）。 */
private val DrawerHandleH = 28.dp

/** 抽屉最大高度 = 屏幕的一半（含把手）。 */
private const val DrawerMaxRatio = 0.5f

/** 幽灵卡的尺寸（跟手指的那张）。 */
private val GhostW = 220.dp
private val GhostH = 56.dp

/** 卡片标题行 / 展开块的高度。 */
private val CardRowH = 64.dp
private val CardExpandH = 56.dp

/** 三张提示词卡片。`nav` = 点 ▸ 要跳到的**页面 id**（App 导航栈认这个）。 */
private enum class PCard(val id: String, val title: String, val hint: String, val nav: String) {
    SUGGEST("suggest", "回复建议", "让 AI 在回复末尾写 <Suggestion>▸ 追问 —— 那排可点的建议就是这么来的", "suggest"),
    MUSIC("music", "音乐", "把「我在听什么」送进提示词：{music} / {artist} / {lyric} …", "music"),
    RICHTEXT("richtext", "富文本", "⟦FDM:模板名|参数⟧ → 那一段变成你配好的富文本（<b> <c1> <bg3> …）", "richtext"),
}

private fun cardOf(id: String): PCard? = PCard.values().firstOrNull { it.id == id }

/** 三张卡片的 id（默认全在抽屉里）。 */
private fun allCardIds(): List<String> = PCard.values().map { it.id }

/* ═════════════════════ 落盘（手动保存才写） ═════════════════════ */

/** 摆放的 JSON 键（存在**我们自己的** SharedPreferences 里，不推给宿主）。 */
private const val LAYOUT_KEY = "cfg.sysprompt_v2_layout"

private fun readLayout(ctx: Context): Triple<List<String>, List<String>, Set<String>>? {
    val s = FdmPush.sp(ctx).getString(LAYOUT_KEY, null) ?: return null
    return try {
        val o = JSONObject(s)
        fun arr(k: String): List<String> {
            val a = o.optJSONArray(k) ?: return emptyList()
            return (0 until a.length()).map { a.optString(it) }
                // 认不出来的 id 一律丢掉（以后卡片增删也不会读到脏数据）
                .filter { cardOf(it) != null }
        }
        val drawer = arr("drawer")
        val box = arr("box")
        val exp = arr("expanded").toSet()
        // 谁都没提到的卡片不能凭空消失 ⇒ 补回抽屉
        val missing = allCardIds().filterNot { it in drawer || it in box }
        Triple(drawer + missing, box, exp)
    } catch (t: Throwable) {
        null      // 坏数据就当没存过，别把页面卡死
    }
}

private fun writeLayout(ctx: Context, drawer: List<String>, box: List<String>, expanded: Set<String>) {
    val o = JSONObject()
    o.put("drawer", JSONArray(drawer))
    o.put("box", JSONArray(box))
    o.put("expanded", JSONArray(expanded.toList()))
    FdmPush.sp(ctx).edit().putString(LAYOUT_KEY, o.toString()).apply()
}

/* ═════════════════════ 页面 ═════════════════════ */

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SysPromptV2Page(onBack: () -> Unit, onNav: (String) -> Unit) {
    val ctx = LocalContext.current
    var more by remember { mutableStateOf(false) }

    /* ── 摆放状态 ── */
    var inDrawer by remember { mutableStateOf(allCardIds()) }
    var inBox by remember { mutableStateOf(emptyList<String>()) }
    var expanded by remember { mutableStateOf(emptySet<String>()) }

    // 进来读一次（**只读不写** —— 写盘只在主人点「保存」时发生）
    LaunchedEffect(Unit) {
        readLayout(ctx)?.let { (d, b, e) ->
            inDrawer = d; inBox = b; expanded = e
        }
    }

    /* ── 拖拽状态（全局幽灵层） ── */
    var dragId by remember { mutableStateOf<String?>(null) }
    var ghost by remember { mutableStateOf(Offset.Zero) }              // 手指位置（根坐标 px）
    val origins = remember { mutableStateMapOf<String, Offset>() }     // 卡片左上角（根坐标）
    val bounds = remember { mutableStateMapOf<String, Rect>() }        // 卡片矩形（根坐标）
    var boxRect by remember { mutableStateOf(Rect.Zero) }              // 投放区：容器
    var drawerRect by remember { mutableStateOf(Rect.Zero) }           // 投放区：抽屉内容

    Scaffold(
        topBar = {
            FdmTopBar(
                title = "系统提示词 v2",
                onBack = onBack,
                onSave = {                       // ★ 手动保存（不点就不写盘）
                    writeLayout(ctx, inDrawer, inBox, expanded)
                    Toast.makeText(ctx, "已保存摆放（抽屉 ${inDrawer.size} 张 / 容器 ${inBox.size} 张）", Toast.LENGTH_SHORT).show()
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
            val ghostW = with(density) { GhostW.toPx() }
            val ghostH = with(density) { GhostH.toPx() }

            // live = 已经拉起来多少（0 = 收在底部；travel = 拉满）
            var live by remember { mutableFloatStateOf(0f) }
            var dragging by remember { mutableStateOf(false) }
            var target by remember { mutableFloatStateOf(0f) }

            LaunchedEffect(target, dragging) {
                if (!dragging) {
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

            /** 往 list 里按「松手位置 y」插到合适下标 ⇒ 拖拽排序顺手就有了。 */
            fun insertByY(list: List<String>, id: String, y: Float): List<String> {
                val others = list.filter { it != id }
                val idx = others.count { (bounds[it]?.center?.y ?: 0f) < y }
                return others.take(idx) + id + others.drop(idx)
            }

            Box(Modifier.fillMaxSize()) {

                /* ── ① 内容区：容器（抽屉拉开时跟着变矮，别被盖住） ── */
                Column(
                    Modifier
                        .fillMaxSize()
                        .padding(bottom = with(density) { (handlePx + live).toDp() }),
                ) {
                    Box(
                        Modifier
                            .fillMaxWidth()
                            .weight(1f)
                            .padding(horizontal = Edge)
                            .onGloballyPositioned { boxRect = it.boundsInRoot() }
                            .clip(RoundedCornerShape(28.dp))
                            .background(MaterialTheme.colorScheme.surfaceContainerHigh),
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
                                    .padding(8.dp),
                                verticalArrangement = Arrangement.spacedBy(8.dp),
                            ) {
                                inBox.forEach { id ->
                                    CardView(
                                        id = id,
                                        expanded = id in expanded,
                                        onToggle = {
                                            expanded = if (id in expanded) expanded - id else expanded + id
                                        },
                                        onNav = { cardOf(id)?.nav?.let(onNav) },
                                        origins = origins,
                                        bounds = bounds,
                                        onDragStart = { p -> dragId = id; ghost = p },
                                        onDragMove = { p -> ghost = p },
                                        onDragEnd = {
                                            // 落在容器里 ⇒ 留在容器（含排序）；落在抽屉里 ⇒ 搬回去；落别处 ⇒ 原地不动
                                            if (boxRect.contains(ghost)) {
                                                inDrawer = inDrawer.filter { it != id }
                                                inBox = insertByY(inBox, id, ghost.y)
                                            } else if (drawerRect.contains(ghost)) {
                                                inBox = inBox.filter { it != id }
                                                inDrawer = insertByY(inDrawer, id, ghost.y)
                                            }
                                            dragId = null
                                        },
                                        onDragCancel = { dragId = null },
                                    )
                                }
                            }
                        }
                    }
                }

                /* ── ② 底部抽屉（叠在内容之上） ── */
                Box(
                    Modifier
                        .align(Alignment.BottomCenter)
                        .fillMaxWidth()
                        .height(sheetDp)
                        .offset {
                            IntOffset(0, (travel - live.coerceIn(0f, travel)).roundToInt())
                        }
                        .clip(RoundedCornerShape(topStart = 28.dp, topEnd = 28.dp))
                        .background(MaterialTheme.colorScheme.surfaceContainerHigh)
                        .draggable(
                            orientation = Orientation.Vertical,
                            state = rememberDraggableState { delta ->
                                live = (live - delta).coerceIn(0f, travel)
                            },
                            onDragStarted = { dragging = true },
                            onDragStopped = { v ->
                                val open = when {
                                    v < -600f -> true      // 往上甩 ⇒ 开
                                    v > 600f -> false      // 往下甩 ⇒ 收
                                    else -> live > travel / 2f   // 慢慢拖 ⇒ 过半算数
                                }
                                dragging = false
                                target = if (open) travel else 0f
                            },
                        ),
                ) {
                    Column(Modifier.fillMaxSize()) {

                        /* 把手：点一下也能开合 */
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

                        /* 抽屉内容：三张提示词卡片 */
                        Column(
                            Modifier
                                .fillMaxSize()
                                .padding(horizontal = Edge)
                                .onGloballyPositioned { drawerRect = it.boundsInRoot() },
                            verticalArrangement = Arrangement.spacedBy(8.dp),
                        ) {
                            Text(
                                "提示词卡片 · 拖到上面的容器里 · 点 ▸ 进对应页面",
                                style = MaterialTheme.typography.labelMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                            if (inDrawer.isEmpty()) {
                                Text(
                                    "（都搬走了 —— 从上面拖回来）",
                                    style = MaterialTheme.typography.bodyMedium,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                )
                            }
                            inDrawer.forEach { id ->
                                CardView(
                                    id = id,
                                    expanded = id in expanded,
                                    onToggle = {
                                        expanded = if (id in expanded) expanded - id else expanded + id
                                    },
                                    onNav = { cardOf(id)?.nav?.let(onNav) },
                                    origins = origins,
                                    bounds = bounds,
                                    onDragStart = { p -> dragId = id; ghost = p },
                                    onDragMove = { p -> ghost = p },
                                    onDragEnd = {
                                        if (boxRect.contains(ghost)) {
                                            inDrawer = inDrawer.filter { it != id }
                                            inBox = insertByY(inBox, id, ghost.y)
                                        } else if (drawerRect.contains(ghost)) {
                                            inBox = inBox.filter { it != id }
                                            inDrawer = insertByY(inDrawer, id, ghost.y)
                                        }
                                        dragId = null
                                    },
                                    onDragCancel = { dragId = null },
                                )
                            }
                        }
                    }
                }

                /* ── ③ 幽灵卡（跟手指那一片） ── */
                dragId?.let { id ->
                    Box(
                        Modifier
                            .offset {
                                IntOffset(
                                    (ghost.x - ghostW / 2f).roundToInt(),
                                    (ghost.y - ghostH / 2f).roundToInt(),
                                )
                            }
                            .size(GhostW, GhostH)
                            .zIndex(10f)
                            .clip(RoundedCornerShape(18.dp))
                            .background(MaterialTheme.colorScheme.primaryContainer),
                        contentAlignment = Alignment.Center,
                    ) {
                        Text(
                            cardOf(id)?.title ?: id,
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.onPrimaryContainer,
                        )
                    }
                }
            }
        }
    }

    /* ── ④ 「更多」弹窗：标题 + 确认键（骨架阶段点了就关） ── */
    if (more) {
        AlertDialog(
            onDismissRequest = { more = false },
            confirmButton = {
                TextButton(onClick = { more = false }) { Text("确认") }
            },
            title = { Text("更多") },
        )
    }
}

/**
 * 一张提示词卡片 🐲
 *
 * · **点本体** ⇒ 展开 / 收起（展开块**暂时空白**）
 * · **点右边 ▸** ⇒ `onNav()`（图标钮是子节点，自己吃掉点击 ⇒ 不会连带展开）
 * · **按住拖** ⇒ 交给页面级的幽灵层
 *
 * <p>★ 顺序讲究：`clickable` 在前、`pointerInput` 在后 ⇒ 拖拽检测在**内层**、
 * 先拿到事件（超过 touch slop 就 consume）⇒ 拖动时点击自动作废；
 * 轻点不动则拖拽不 consume ⇒ 点击照常生效。两个手势不打架。
 */
@Composable
private fun CardView(
    id: String,
    expanded: Boolean,
    onToggle: () -> Unit,
    onNav: () -> Unit,
    origins: MutableMap<String, Offset>,
    bounds: MutableMap<String, Rect>,
    onDragStart: (Offset) -> Unit,
    onDragMove: (Offset) -> Unit,
    onDragEnd: () -> Unit,
    onDragCancel: () -> Unit,
) {
    val card = cardOf(id) ?: return
    Column(
        Modifier
            .fillMaxWidth()
            .onGloballyPositioned {
                origins[id] = it.positionInRoot()
                bounds[id] = it.boundsInRoot()
            }
            .clip(RoundedCornerShape(20.dp))
            .background(MaterialTheme.colorScheme.surfaceContainerLow)
            .clickable { onToggle() }
            .pointerInput(id) {
                detectDragGestures(
                    onDragStart = { local -> onDragStart((origins[id] ?: Offset.Zero) + local) },
                    onDrag = { change, _ ->
                        onDragMove((origins[id] ?: Offset.Zero) + change.position)
                        change.consume()
                    },
                    onDragEnd = { onDragEnd() },
                    onDragCancel = { onDragCancel() },
                )
            },
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .height(CardRowH)
                .padding(start = Edge, end = 4.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(Modifier.weight(1f)) {
                Text(
                    card.title,
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurface,
                    maxLines = 1, overflow = TextOverflow.Ellipsis,
                )
                Text(
                    card.hint,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 2, overflow = TextOverflow.Ellipsis,
                )
            }
            IconButton(onClick = onNav, modifier = Modifier.size(44.dp)) {
                Icon(Icons.Rounded.ChevronRight, "去「${card.title}」页")
            }
        }
        if (expanded) {
            Box(
                Modifier
                    .fillMaxWidth()
                    .height(CardExpandH)
                    .padding(horizontal = 8.dp, vertical = 4.dp)
                    .clip(RoundedCornerShape(14.dp))
                    .background(MaterialTheme.colorScheme.surfaceContainerHighest),
                contentAlignment = Alignment.Center,
            ) {
                Text(
                    "（展开内容 · 待定）",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }
}
