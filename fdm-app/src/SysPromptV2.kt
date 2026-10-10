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
 * 「系统提示词 v2」—— 重构页 🐲（2026-10-10）
 *
 * <p>主人：「我们的系统提示词列表比较反人类，我要重构。新界面先塞调试菜单，稳了再并进主菜单。」
 *
 * 1. **页面内的空白容器**（内容区）—— 卡片可以从抽屉**拖进来**、在里面**拖拽排序**。
 * 2. **底部抽屉** —— 可向上拉，最高到**页面 1/2**；初始收在底部、只露一条把手。
 *    抽屉里放三张**提示词卡片**：回复建议 / 音乐 / 富文本。
 * 3. **卡片两件事分得很开**：**点本体 ⇒ 展开**（展开块暂空）· **点右边 ▸ ⇒ 跳对应页面** ·
 *    **按住拖 ⇒ 搬运**（抽屉 ⇄ 容器，同容器内还能排序）。
 * 4. **顶部工具栏**：`[💾] [⋮]` —— 改动**实时落盘**（切摆/展开都立刻写），
 *    那个 💾 是**保险**（手动再写一次 + 给个回执），不是唯一的保存路径。
 *
 * <p>为什么抽屉不用 `ModalBottomSheet`：它没法「收在底部只露一条把手」——
 * 一打开就至少是半个屏，而且背后会压一层 scrim。这里要的是**常驻在页面里的抽屉**，
 * 所以自己用 `draggable` + `animate` 做两档吸附（收起 0 ⇄ 拉满 = 半屏）。
 *
 * <p>★ 手势方向：Compose 的 drag delta 沿轴正向为正（竖向 = 往下为正），
 * 所以「往上拉」是负 delta ⇒ `live = live - delta`。
 *
 * <p>★★ **拖的是真卡片本体**（不是另画一张幽灵）：
 * 卡片留在自己的槽位里，只叠一个 `offset`（位移 = 拖拽增量的累加）⇒ 手指上就是这张真卡。
 * 由此带来三个必须做对的地方：
 * • **位移必须用 delta 累加**（`dragAmount`），**不能用** `change.position` ——
 *   后者是「相对卡片自己」的坐标，而卡片自己正在动 ⇒ 会自己追自己。
 * • **槽位矩形要在拖拽开始时缓存**（`dragSlot`），不能拖到一半再读 —— 那时的坐标已经被 offset 带偏。
 * • **拖出去要能看见**：容器/抽屉原来都有 `clip(...)` 会把出界的卡片**裁掉**
 *   ⇒ 改成「**圆角底只当背景画**」（`background(color, shape)`）+ 不裁切子节点
 *   （容器的 8dp 内边距 + 卡片 20dp 圆角，刚好和 28dp 的外圆角同心 ⇒ 平时看不出来）。
 *   ＋ 从**容器**往外拖时把内容层 `zIndex` 提到抽屉之上（否则卡片会钻到抽屉底下消失）；
 *   容器因为给抽屉让了位，永不与抽屉重叠 ⇒ 提层不会有任何视觉副作用。
 */

/** 把手条的高度（收起时露出来的就是它）。 */
private val DrawerHandleH = 28.dp

/** 抽屉最大高度 = 屏幕的一半（含把手）。 */
private const val DrawerMaxRatio = 0.5f

/** 卡片标题行 / 展开块的高度。 */
private val CardRowH = 64.dp
private val CardExpandH = 56.dp

/** 卡片圆角（拖拽时的影子也照这个形状）。 */
private val CardRadius = 20.dp

/** 三张提示词卡片。`nav` = 点 ▸ 要跳到的**页面 id**（App 导航栈认这个）。 */
private enum class PCard(val id: String, val title: String, val hint: String, val nav: String) {
    SUGGEST("suggest", "回复建议", "让 AI 在回复末尾写 <Suggestion>▸ 追问 —— 那排可点的建议就是这么来的", "suggest"),
    MUSIC("music", "音乐", "把「我在听什么」送进提示词：{music} / {artist} / {lyric} …", "music"),
    RICHTEXT("richtext", "富文本", "⟦FDM:模板名|参数⟧ → 那一段变成你配好的富文本（<b> <c1> <bg3> …）", "richtext"),
}

private fun cardOf(id: String): PCard? = PCard.values().firstOrNull { it.id == id }

/** 三张卡片的 id（默认全在抽屉里）。 */
private fun allCardIds(): List<String> = PCard.values().map { it.id }

/* ═════════════════════ 落盘（实时 + 手动保险） ═════════════════════ */

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

    /* ── 摆放状态（初值从盘上同步读一次 —— 免得首帧拿默认值把存档冲掉） ── */
    val initial = remember { readLayout(ctx) }
    var inDrawer by remember { mutableStateOf(initial?.first ?: allCardIds()) }
    var inBox by remember { mutableStateOf(initial?.second ?: emptyList()) }
    var expanded by remember { mutableStateOf(initial?.third ?: emptySet()) }

    // ★ 实时保存：改动一提交就写盘。`watch` 挡住首帧（首帧要先把盘上的值读回来，不能反过来冲掉）
    var watch by remember { mutableStateOf(false) }
    LaunchedEffect(Unit) { watch = true }
    LaunchedEffect(inDrawer, inBox, expanded, watch) {
        if (watch) writeLayout(ctx, inDrawer, inBox, expanded)
    }

    /* ── 拖拽状态（真卡片本体跟手） ── */
    var dragId by remember { mutableStateOf<String?>(null) }
    var dragOff by remember { mutableStateOf(Offset.Zero) }      // 位移（累加增量）
    var dragSlot by remember { mutableStateOf(Rect.Zero) }       // 拖拽开始时的**槽位**矩形（根坐标）
    val bounds = remember { mutableStateMapOf<String, Rect>() }  // 各卡片的槽位矩形（根坐标）
    var boxRect by remember { mutableStateOf(Rect.Zero) }        // 投放区：容器（根坐标）
    var drawerRect by remember { mutableStateOf(Rect.Zero) }     // 投放区：抽屉内容（根坐标）

    Scaffold(
        topBar = {
            FdmTopBar(
                title = "系统提示词 v2",
                onBack = onBack,
                onSave = {                       // ★ 保险按钮（改动本来就实时存了）
                    writeLayout(ctx, inDrawer, inBox, expanded)
                    Toast.makeText(
                        ctx,
                        "已保存摆放（抽屉 ${inDrawer.size} 张 / 容器 ${inBox.size} 张）",
                        Toast.LENGTH_SHORT,
                    ).show()
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

            // live = 已经拉起来多少（0 = 收在底部；travel = 拉满）
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

            /** 往 list 里按「松手位置 y」插到合适下标 ⇒ 拖拽排序顺手就有了。 */
            fun insertByY(list: List<String>, id: String, y: Float): List<String> {
                val others = list.filter { it != id }
                val idx = others.count { (bounds[it]?.center?.y ?: 0f) < y }
                return others.take(idx) + id + others.drop(idx)
            }

            /** 当前被拖的卡片矩形 = 缓存槽位 + 位移（槽位在拖拽开始时冻结，绝不被 offset 带偏）。 */
            fun draggedRect(): Rect = dragSlot.translate(dragOff)

            /** 松手：落在哪边就归哪边；哪边都不是 ⇒ 什么都不做（原地不动）。 */
            fun drop() {
                val id = dragId
                if (id != null) {
                    val r = draggedRect()
                    if (boxRect.contains(r.center)) {
                        inDrawer = inDrawer.filter { it != id }
                        inBox = insertByY(inBox, id, r.center.y)
                    } else if (drawerRect.contains(r.center)) {
                        inBox = inBox.filter { it != id }
                        inDrawer = insertByY(inDrawer, id, r.center.y)
                    }
                }
                dragId = null
                dragOff = Offset.Zero
            }

            fun startDrag(id: String) {
                dragId = id
                dragOff = Offset.Zero
                dragSlot = bounds[id] ?: Rect.Zero
            }

            fun moveDrag(delta: Offset) {
                dragOff += delta
            }

            // 从**容器**里往外拖时，把内容层提到抽屉之上（否则卡片会钻到抽屉底下看不见）。
            // 容器给抽屉让了位、永不重叠 ⇒ 提层没有任何视觉副作用。
            val lifting = dragId != null && dragId in inBox

            Box(Modifier.fillMaxSize()) {

                /* ── ① 内容区：容器（抽屉拉开时跟着变矮，别被盖住） ── */
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
                            // ★ 只当背景画、**不裁子节点** —— 卡片要能拖出去还看得见
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
                                    .padding(8.dp),
                                verticalArrangement = Arrangement.spacedBy(8.dp),
                            ) {
                                inBox.forEach { id ->
                                    PromptCard(
                                        id = id,
                                        expanded = id in expanded,
                                        dragging = id == dragId,
                                        dragOff = if (id == dragId) dragOff else Offset.Zero,
                                        onToggle = {
                                            expanded = if (id in expanded) expanded - id else expanded + id
                                        },
                                        onNav = { cardOf(id)?.nav?.let(onNav) },
                                        bounds = bounds,
                                        onDragStart = { startDrag(id) },
                                        onDragMove = { moveDrag(it) },
                                        onDragEnd = { drop() },
                                        onDragCancel = { dragId = null; dragOff = Offset.Zero },
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
                        .zIndex(1f)
                        .offset {
                            IntOffset(0, (travel - live.coerceIn(0f, travel)).roundToInt())
                        }
                        // ★ 同样：圆角只当背景，不裁子节点（卡片要能拖出去）
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
                                    v < -600f -> true      // 往上甩 ⇒ 开
                                    v > 600f -> false      // 往下甩 ⇒ 收
                                    else -> live > travel / 2f   // 慢慢拖 ⇒ 过半算数
                                }
                                draggingSheet = false
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
                                PromptCard(
                                    id = id,
                                    expanded = id in expanded,
                                    dragging = id == dragId,
                                    dragOff = if (id == dragId) dragOff else Offset.Zero,
                                    onToggle = {
                                        expanded = if (id in expanded) expanded - id else expanded + id
                                    },
                                    onNav = { cardOf(id)?.nav?.let(onNav) },
                                    bounds = bounds,
                                    onDragStart = { startDrag(id) },
                                    onDragMove = { moveDrag(it) },
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

    /* ── 「更多」弹窗：标题 + 确认键（骨架阶段点了就关） ── */
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
 * · **按住拖** ⇒ 整张卡片本体跟着手指走（叠 `offset`，不另画幽灵）
 *
 * <p>★ 顺序讲究：`clickable` 在前、`pointerInput` 在后 ⇒ 拖拽检测在**内层**、
 * 先拿到事件（超过 touch slop 就 consume）⇒ 拖动时点击自动作废；
 * 轻点不动则拖拽不 consume ⇒ 点击照常生效。两个手势不打架，**不用做拖动把手**。
 *
 * <p>★ 位移只认 `dragAmount`（**增量**）。**不能用 `change.position`** ——
 * 那是「相对卡片自己」的坐标，而卡片自己正在被 offset 挪走 ⇒ 会变成自己追自己。
 */
@Composable
private fun PromptCard(
    id: String,
    expanded: Boolean,
    dragging: Boolean,
    dragOff: Offset,
    onToggle: () -> Unit,
    onNav: () -> Unit,
    bounds: MutableMap<String, Rect>,
    onDragStart: () -> Unit,
    onDragMove: (Offset) -> Unit,
    onDragEnd: () -> Unit,
    onDragCancel: () -> Unit,
) {
    val card = cardOf(id) ?: return
    val scale = if (dragging) 1.03f else 1f
    Column(
        Modifier
            .fillMaxWidth()
            .zIndex(if (dragging) 10f else 0f)
            // ① 槽位矩形（**在 offset 之前**记 ⇒ 永远是"槽位"，不会被位移带偏）
            .onGloballyPositioned { bounds[id] = it.boundsInRoot() }
            // ② 位移：整张卡片本体跟手
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
            .pointerInput(id) {
                detectDragGestures(
                    onDragStart = { onDragStart() },
                    onDrag = { change, amount ->
                        onDragMove(amount)
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
