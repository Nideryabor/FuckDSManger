// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import android.widget.Toast
import androidx.compose.animation.core.Spring
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.animation.core.animate
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.detectDragGesturesAfterLongPress
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Add
import androidx.compose.material.icons.rounded.Archive
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
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.positionInRoot
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.input.ImeAction
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
        /**
         * ★ 2026-10-10（3.62.2）修 ——「**三个内置卡片被当夜宵吃了**」。
         *
         * <p>老存档（3.60 / 3.61 那套格式）里**只有 id 列表、没有 `cards` 表**；
         * 而这里原来要求"卡片表里得有这一张"才认 ⇒ 三张内置卡被当成脏数据**整批丢掉**，
         * 丢掉之后**又被写回存档** ⇒ **永久丢失**（主人视角：抽屉里那三张凭空消失）。
         *
         * <p>修法两条：
         * ① 内置三张 + 源卡片的**键就是它自己的类型名** ⇒ 卡片表里没有也能**现造**；
         * ② 「两边都没有」的它们**补回抽屉** —— 它们本来就**删不掉**（没有删除按钮），
         *    所以"失踪"只可能是存档坏了（或这次的 bug），补回来是安全的。
         */
        // ★★ 2026-10-10（3.63.1）：「卡片被当夜宵吃了」的**根治** ——
        //  卡片表是**唯一真相**：表里有的卡片，这里**一张都不许丢**；
        //  谁都不在列表里（孤儿）就**补回抽屉**；要删只有一条路 —— 主人点那张红删除。
        //  （老写法只认"列表里提到的"，表里没条目的（老存档）或列表漏掉的就当脏数据清掉 ⇒ 会真丢东西。）
        fun coerce(k: String) {
            val ex = cards[k]
            val c: CCard? = when (k) {
                T_SUGGEST -> CCard(k, T_SUGGEST, typeTitle(T_SUGGEST), ex?.text ?: "")
                T_MUSIC -> CCard(k, T_MUSIC, typeTitle(T_MUSIC), ex?.text ?: "")
                T_RICHTEXT -> CCard(k, T_RICHTEXT, typeTitle(T_RICHTEXT), ex?.text ?: "")
                K_SRC -> CCard(k, T_TEXTSRC, typeTitle(T_TEXTSRC), ex?.text ?: "")
                else -> if (ex != null && ex.isText) ex else null
            }
            if (c != null && !cards2.containsKey(k)) cards2[k] = c
        }
        // ① 先把**卡片表里的全部**收下（只丢"类型不认识"的）
        cards.forEach { (k, c) -> if (c.isBuiltin || c.isText) cards2[k] = c }
        // ② 老存档（只有 id 列表、没有卡片表）：内置三张 + 源卡片的键就是类型名 ⇒ 现造
        drawer.forEach { coerce(it) }
        box.forEach { coerce(it) }
        val missing = listOf(T_SUGGEST, T_MUSIC, T_RICHTEXT, K_SRC).filter { !cards2.containsKey(it) }
        missing.forEach { coerce(it) }
        // ③ 两边都没提到的（孤儿）⇒ 补回抽屉，**绝不静默丢掉**
        val orphans = cards2.keys.filter { it !in drawer && it !in box }
        val drawer2 = (drawer.filter { cards2.containsKey(it) } + missing + orphans + listOf(K_SRC)).distinct()
        val box2 = box.filter { cards2.containsKey(it) && it != K_SRC }.distinct()
        // ④ nextId 保险：绝不允许跟已有的键撞车（撞了就"复制"成覆盖别人的内容）
        var nx = nextId
        cards2.keys.forEach { k ->
            val m = Regex("^text#(\\d+)$").find(k)
            if (m != null) nx = maxOf(nx, m.groupValues[1].toInt() + 1)
        }
        return Saved(drawer2, box2, expanded.filter { cards2.containsKey(it) }.toSet(), cards2, nx.coerceAtLeast(1))
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

    /**
     * 一次「提交」= 落盘 + 重建提示词（摆放 / 删除 / 文本失焦 / 切开关都走它）。
     *
     * <p>★ 2026-10-10（3.63.1）：**没读回存档之前直接返回** ——
     * 否则会把"半加载"的状态（卡片表还是空的）写回存档，一次就把卡片吃光。
     */
    fun commit() {
        if (!seeded) return
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
    // ★ 2026-10-10（3.63.1）：判定用**根坐标**，但画线要用**页面内坐标** ——
    //   页面 Box 的原点已被 Scaffold 的 padding（顶栏 + 状态栏）推下去，
    //   直接拿根坐标当 offset ⇒ 线整体偏一个顶栏的高度（主人报的"严重偏移"）。
    var pagePos by remember { mutableStateOf(Offset.Zero) }

    /* ── 抽屉里左右两列（内置 / 自定义）：各占一屏，横滑切换 ── */
    //  ★ 主人 2026-10-10：「我还是决定左右列 …… 左边是内置功能提示词，右边是专门放用户自定义提示词的，
    //    这样不会混在一起」。左边 = 三张内置卡；右边 = 源卡片 + 所有自定义副本。
    var colIdx by remember { mutableIntStateOf(0) }        // 0 = 内置列 / 1 = 自定义列
    // ★★ 2026-10-10（3.63.5）：**不再做"左右分页位移"那套**。
    //   前两版想"横滑跟手 + 吸附到整列"，结果反复出现"两列同屏 / 卡在中间"（主人截图为证）。
    //   ⇒ 换成最笨也最稳的：**只渲染当前那一列**，另一列**根本不进组合** ——
    //     "两列同屏"在结构上就不可能发生。横滑只用来**换列**（不跟随、不做连续位移），
    //     换列时用 `AnimatedContent` 播一个离散的滑入滑出（位置永远只有 0/1 两个状态）。

    /* ── 文本编辑状态（**失焦 / 收起卡片时提交**） ── */
    var editKey by remember { mutableStateOf<String?>(null) }
    var editTitle by remember { mutableStateOf(false) }
    var editBuf by remember { mutableStateOf("") }

    /**
     * 把正在编辑的那张卡"提交"（改内存 → 落盘 → 重建提示词）。
     *
     * <p>★ 这里**必须区分**"正在编辑标题"还是"正在编辑正文" ——
     * 两者共用同一个输入缓冲 `editBuf`，不小心就会把标题写进正文里（3.62.0 的真实 bug）。
     */
    /** 提交正在编辑的文本；**返回这次有没有真的改动**（按钮反馈要用）。 */
    fun flushEditChanged(): Boolean {
        val k = editKey
        var changed = false
        if (k != null) {
            val c = cards[k]
            if (c != null) {
                if (editTitle) {
                    if (editBuf != c.title) { c.title = editBuf; changed = true }
                } else {
                    if (editBuf != c.text) { c.text = editBuf; changed = true }
                }
                if (changed) commit()
            }
        }
        editKey = null
        editTitle = false
        return changed
    }

    /** 只当"提交一下"用的薄封装（收起卡片 / 切目标时调）。 */
    fun flushEdit() {
        flushEditChanged()
    }

    /** 切到别的输入目标之前，先把上一次的编辑**收干净**（否则那一笔就丢了）。 */
    fun beginEdit(key: String, title: Boolean) {
        if (editKey != null && editKey != key) flushEdit()
        else if (editKey == key && editTitle != title) flushEdit()
        editKey = key
        editTitle = title
        editBuf = if (title) cards[key]?.title ?: "" else cards[key]?.text ?: ""
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

            /**
             * 按 y 插到合适下标（就近插入）。
             *
             * <p>★ 抽屉里**只跟同一列的卡片比** —— 左右两列是两个独立列表，
             * 拿另一列的卡片算序号会把位置算歪（它们只是"屏幕外"、不是"在那条线上"）。
             */
            fun insertByY(list: List<String>, key: String, y: Float, sameColumnOnly: Boolean = false): List<String> {
                val others = list.filter { it != key }
                val isB = cards[key]?.isBuiltin == true
                val idx = others.count { k ->
                    (!sameColumnOnly || (cards[k]?.isBuiltin == true) == isB) &&
                            (bounds[k]?.center?.y ?: 0f) < y
                }
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
                            inDrawer = insertByY(inDrawer, id, r.center.y, sameColumnOnly = true)
                            // ★ 归档回去之后，自动切到它该在的那一列（不然主人还得自己找）
                            colIdx = if (c?.isBuiltin == true) 0 else 1
                            commit()
                        }
                    }                                              // 落空 ⇒ 什么都不做
                }
                dragId = null
                dragOff = Offset.Zero
            }

            /**
             * 拖动中：算出「会插到哪儿」—— 目标列表 + 下标 + 那条指示线的 y。
             *
             * <p>★ 主人 2026-10-10：「切换位置应该改成随着拖动位置就近插入」。
             * <b>判定本来就是按拖动位置算的</b>（不是按方向），但以前**没有任何反馈** ——
             * 卡片在手指上、别的卡片一动不动，看起来就像"只挪了一格"。
             * ⇒ 现在拖到哪儿，就在那儿画一条线（并且长按拖动之后，列表也能正常滑了，
             * 想拖到远端才真的拖得到）。
             */
            fun dropHint(): Triple<List<String>, Int, Float>? {
                val id = dragId ?: return null
                val r = dragSlot.translate(dragOff)
                val center = r.center
                val list = when {
                    boxRect.contains(center) -> inBox
                    drawerRect.contains(center) -> inDrawer
                    else -> return null
                }
                val sameColOnly = list === inDrawer
                val isB = cards[id]?.isBuiltin == true
                val others = list.filter { it != id }
                val idx = others.count { k ->
                    (!sameColOnly || (cards[k]?.isBuiltin == true) == isB) &&
                            (bounds[k]?.center?.y ?: 0f) < center.y
                }
                val y = when {
                    others.isEmpty() -> center.y
                    idx == 0 -> (bounds[others[0]]?.top ?: r.top) - 4f
                    else -> (bounds[others[idx - 1]]?.bottom ?: r.bottom) + 4f
                }
                return Triple(list, idx, y)
            }

            /** 一张可拖的卡片（容器的列表 / 抽屉的两列都用它，免得抄三份）。 */
            @Composable
            fun CardSlot(id: String, fromDrawer: Boolean) {
                val c = cards[id] ?: return
                PromptCard(
                    card = c,
                    expanded = id in expanded,
                    dragging = id == dragId,
                    dragOff = if (id == dragId) dragOff else Offset.Zero,
                    editing = editKey == id,
                    editingTitle = editKey == id && editTitle,
                    editBuf = if (editKey == id) editBuf else "",
                    bounds = bounds,
                    // ★ 主人：「抽屉里的卡片改成不能展开，不然会出显示bug」⇒ 抽屉里只当"卡片条"，
                    //   展开（编辑内容）在容器里做 —— 那儿空间够，也不会把抽屉挤爆。
                    noExpand = fromDrawer,
                    // ★ 红删除：**只有暂存在抽屉里的自定义文本副本**才有
                    showDelete = fromDrawer && c.type == T_TEXT,
                    onToggle = {
                        flushEdit()          // 先把别的卡的编辑收干净
                        val wasOpen = id in expanded
                        expanded = if (wasOpen) expanded - id else expanded + id
                        // ★ 2026-10-10（3.63.7）修：「必须聚焦一下输入框，按钮才刷新状态」——
                        //   提交按钮依赖 `editKey`，而 `editKey` 原来**只在输入框拿到焦点时**才设置
                        //   ⇒ 展开卡片后直接点「提交」= 什么都没发生（看着就是按钮坏了）。
                        //   ⇒ 现在**展开文本卡就自动进入编辑态**（缓冲立刻等于当前文本），
                        //     不必先点一下输入框。内置三张没有正文，不参与。
                        if (!wasOpen && c.isText) beginEdit(id, false)
                    },
                    onNav = { onNav(typeNavTarget(c.type)) },
                    onEditStart = { title -> beginEdit(id, title) },
                    onBufChange = { editBuf = it },
                    onCommitEditChanged = { flushEditChanged() },
                    onWithTitle = { v ->
                        c.withTitle = v
                        commit()
                    },
                    onDelete = { pendingDelete = id },
                    onDragStart = {
                        dragId = id
                        dragOff = Offset.Zero
                        dragSlot = bounds[id] ?: Rect.Zero
                    },
                    onDragMove = { dragOff += it },
                    onDragEnd = { drop() },
                    onDragCancel = {
                        dragId = null
                        dragOff = Offset.Zero
                    },
                )
            }

            // ★ 2026-10-10（3.63.1）采纳主人建议：「把卡片设置成最高层级，可以解决一些穿模 bug」。
            //   做法 = **"被拖的那张卡所在的层"整层提到最上**（卡片自己的 zIndex 只管层内），
            //   这样它跨容器/抽屉时永远不会被另一半吃掉或裁掉。
            //   z 值一览（都写在注释里，免得下次又算错）：
            //     内容层 2f（拖动中它在容器里 ⇒ 4f） · 抽屉层 2.5f（拖动中它在抽屉里 ⇒ 4f）
            //     归档图标 200f（页面级，恒在最上，但它落在容器与抽屉之间的空档里，不压卡片）
            //     落点线   210f（页面级，就该盖在卡片上） · 拖动中的卡片 100f（层内）
            val dragInBox = dragId != null && dragId in inBox
            val dragInDrawer = dragId != null && dragId in inDrawer

            Box(
                Modifier
                    .fillMaxSize()
                    .onGloballyPositioned { pagePos = it.positionInRoot() },
            ) {

                /* ── ① 内容区：容器（抽屉拉开时跟着变矮） ── */
                Column(
                    Modifier
                        .fillMaxSize()
                        .padding(bottom = with(density) { (handlePx + live).toDp() })
                        .zIndex(if (dragInBox) 4f else 2f),
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
                        // 拖动中：容器自己亮一层淡蓝（在卡片**下面**，所以不挡卡片）
                        if (dragId != null) {
                            Box(
                                Modifier
                                    .fillMaxSize()
                                    .background(Color(0x262196F3)),
                            )
                        }
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
                                inBox.forEach { id -> CardSlot(id, fromDrawer = false) }
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
                        .zIndex(if (dragInDrawer) 4f else 2.5f)
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
                        ) {
                            // ── 提示 + 左右两列的切换（点标签也能切） ──
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Text(
                                    "卡片 = 提示词的一段 · 长按拖到上面",
                                    style = MaterialTheme.typography.labelMedium,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                    maxLines = 1, overflow = TextOverflow.Ellipsis,
                                    modifier = Modifier.weight(1f),
                                )
                                DrawerTab("内置", colIdx == 0) { colIdx = 0 }
                                Spacer(Modifier.width(4.dp))
                                DrawerTab("自定义", colIdx == 1) { colIdx = 1 }
                            }
                            Box(
                                Modifier
                                    .fillMaxWidth()
                                    .weight(1f)
                                    .pointerInput(colIdx) {
                                        // 横滑**只用来换列**：不跟手、不做连续位移 ⇒ 不可能停在中间
                                        var acc = 0f
                                        detectHorizontalDragGestures(
                                            onDragStart = { acc = 0f },
                                            onDragEnd = {
                                                if (acc < -60f) colIdx = 1
                                                else if (acc > 60f) colIdx = 0
                                                acc = 0f
                                            },
                                            onDragCancel = { acc = 0f },
                                        ) { change, delta ->
                                            acc += delta
                                            change.consume()
                                        }
                                    },
                            ) {
                                // 拖动中 & 这张卡不在抽屉里 ⇒ 整片高亮：松手 = 归档回抽屉
                                if (dragId != null && dragId !in inDrawer) {
                                    Box(
                                        Modifier
                                            .fillMaxSize()
                                            .padding(6.dp)
                                            .clip(RoundedCornerShape(16.dp))
                                            .background(Color(0x222196F3)),
                                        contentAlignment = Alignment.Center,
                                    ) {
                                        Text(
                                            "⤓ 松手 = 归档回抽屉",
                                            style = MaterialTheme.typography.labelMedium,
                                            color = MaterialTheme.colorScheme.primary,
                                        )
                                    }
                                }
                                AnimatedContent(
                                    targetState = colIdx,
                                    transitionSpec = {
                                        if (targetState > initialState) {
                                            (slideInHorizontally { it } + fadeIn()) togetherWith
                                                    (slideOutHorizontally { -it } + fadeOut())
                                        } else {
                                            (slideInHorizontally { -it } + fadeIn()) togetherWith
                                                    (slideOutHorizontally { it } + fadeOut())
                                        }
                                    },
                                    label = "drawerCol",
                                ) { ci ->
                                    if (ci == 0) {
                                        /* ── 左列：内置功能提示词 ── */
                                        Column(
                                            Modifier
                                                .fillMaxSize()
                                                .verticalScroll(rememberScrollState()),
                                            verticalArrangement = Arrangement.spacedBy(8.dp),
                                        ) {
                                            Text(
                                                "内置功能提示词",
                                                style = MaterialTheme.typography.labelSmall,
                                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                            )
                                            val bi = inDrawer.filter { cards[it]?.isBuiltin == true }
                                            if (bi.isEmpty()) {
                                                Text(
                                                    "（都搬到上面了）",
                                                    style = MaterialTheme.typography.bodySmall,
                                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                                )
                                            }
                                            bi.forEach { id -> CardSlot(id, fromDrawer = true) }
                                        }
                                    } else {
                                        /* ── 右列：用户自定义提示词 ── */
                                        Column(
                                            Modifier
                                                .fillMaxSize()
                                                .verticalScroll(rememberScrollState()),
                                            verticalArrangement = Arrangement.spacedBy(8.dp),
                                        ) {
                                            Text(
                                                "自定义提示词（暂存在这儿 · 也能归档回来）",
                                                style = MaterialTheme.typography.labelSmall,
                                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                                maxLines = 1, overflow = TextOverflow.Ellipsis,
                                            )
                                            val cu = inDrawer.filter {
                                                val t = cards[it]?.type
                                                t == T_TEXT || t == T_TEXTSRC
                                            }
                                            if (cu.isEmpty()) {
                                                Text(
                                                    "（这儿是空的）",
                                                    style = MaterialTheme.typography.bodySmall,
                                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                                )
                                            }
                                            cu.forEach { id -> CardSlot(id, fromDrawer = true) }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                /* ── ②.5 「归档」提示：蓝色 + 下载图标 ──
                 *  ★ 2026-10-10（3.63.1）改：**只在"拉住卡片拖"的时候出现**（主人定的）——
                 *    以前是"抽屉收着就一直挂着"，等于屏幕上永远有个淡蓝滤镜，很吵。
                 *  · 蓝底：铺在**容器内部**（卡片在它上面 ⇒ 不压卡片、不穿模），拖动时才亮；
                 *  · 图标：落在**容器与抽屉之间的那条空档**里 ⇒ 既看得见，又不压任何卡片。
                 */
                if (dragId != null) {
                    Icon(
                        Icons.Rounded.Archive, "归档",
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier
                            .align(Alignment.BottomCenter)
                            // ★ offset 向下为正 ⇒ 往上浮要给负值；这里刚好落在"容器底 ~ 抽屉顶"的空档
                            .offset {
                                IntOffset(0, -(live + with(density) { 10.dp.toPx() }).roundToInt())
                            }
                            .size(28.dp)
                            .zIndex(200f),
                    )
                }

                /* ── ②.6 拖动落点：一条线告诉你会插到哪儿（就近插入的反馈） ── */
                val hint = if (dragId != null) dropHint() else null
                if (hint != null) {
                    val rect = if (hint.first === inBox) boxRect else drawerRect
                    Box(
                        Modifier
                            .offset {
                                IntOffset(
                                    (rect.left - pagePos.x).roundToInt(),
                                    (hint.third - pagePos.y - 1.5f).roundToInt(),
                                )
                            }
                            .width(with(density) { rect.width.toDp() })
                            .height(3.dp)
                            .zIndex(210f)
                            .clip(RoundedCornerShape(2.dp))
                            .background(MaterialTheme.colorScheme.primary),
                    )
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

/** 抽屉里的「内置 / 自定义」切换标签（也能横滑切，这个只是给个明确的抓手）。 */
@Composable
private fun DrawerTab(text: String, active: Boolean, onClick: () -> Unit) {
    Box(
        Modifier
            .clip(RoundedCornerShape(50))
            .background(
                if (active) MaterialTheme.colorScheme.secondaryContainer
                else MaterialTheme.colorScheme.surfaceContainerHighest
            )
            .clickable { onClick() }
            .padding(horizontal = 10.dp, vertical = 4.dp),
    ) {
        Text(
            text,
            style = MaterialTheme.typography.labelMedium,
            color = if (active) MaterialTheme.colorScheme.onSecondaryContainer
            else MaterialTheme.colorScheme.onSurfaceVariant,
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
    /** true = 这张卡**不能展开**（抽屉里用：展开会把抽屉挤爆、还会出显示 bug）。 */
    noExpand: Boolean,
    showDelete: Boolean,
    onToggle: () -> Unit,
    onNav: () -> Unit,
    /** 开始编辑：true = 标题，false = 正文（由 ✏ 按钮或输入框拿到焦点时调）。 */
    onEditStart: (Boolean) -> Unit,
    onBufChange: (String) -> Unit,
    /** 提交正在编辑的文本；**返回值 = 这次有没有真的改动**（给按钮做反馈用）。 */
    onCommitEditChanged: () -> Boolean,
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
            .zIndex(if (dragging) 100f else 0f)
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
            .background(MaterialTheme.colorScheme.surfaceContainerLow),
        // ★★ 2026-10-10（3.63.6）修：「卡片下面那个按钮死活点不动」——
        //   长按拖动原来挂在**整张卡**上（连展开区一起罩住）：输入框、开关、提交按钮全在它的手势范围里。
        //   现在把它收窄到**标题行** ⇒ 展开区**没有任何拖动手势**，点哪儿都算数。
        //   （老账 3.51.0：「可拖区域和可点区域别重叠」—— 这次是第二次栽在同一个地方。）
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .height(CardRowH)
                // ★ 点击展开**只在这一行**（展开区里的按钮/输入框不受影响）；
                //   整张卡的点击拿掉了 —— 否则在展开区里点一下就把卡片收起来，很烦。
                .clickable(enabled = !noExpand) { onToggle() }
                // 长按 = 拖这张卡（放在 clickable 之后 ⇒ 拖拽检测在内层、先拿事件；
                // 超过 touch slop 就 consume、点击自动作废；轻点则拖动不 consume、点击照常）
                .pointerInput(card.key) {
                    detectDragGesturesAfterLongPress(
                        onDragStart = { onDragStart() },
                        onDrag = { change, amount -> onDragMove(amount); change.consume() },
                        onDragEnd = { onDragEnd() },
                        onDragCancel = { onDragCancel() },
                    )
                }
                .padding(start = 8.dp, end = 4.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            // ★ 标题左边的「编辑标题」铅笔（只有自定义文本卡需要 —— 内置三张的标题是固定的）
            if (card.isText) {
                IconButton(onClick = { onEditStart(true) }, modifier = Modifier.size(36.dp)) {
                    Icon(
                        Icons.Rounded.Edit, "编辑标题",
                        modifier = Modifier.size(18.dp),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
            Column(Modifier.weight(1f).padding(start = if (card.isText) 0.dp else 8.dp)) {
                if (editing && editingTitle) {
                    // ★ 2026-10-10（3.62.2）修：标题原来"没处可退"（只能靠收起卡片/点别处）——
                    //   现在 **回车（Done）= 保存并退出** · **失焦 = 保存并退出**，并且进来就自动拿焦点。
                    //   `hadFocus` 这道闸是必须的：输入框刚出现在组合里时会先报一次"未聚焦"，
                    //   不加闸就会被当成"失焦"⇒ 一个字都没敲就退出了。
                    val fr = remember(card.key) { FocusRequester() }
                    var hadFocus by remember(card.key) { mutableStateOf(false) }
                    LaunchedEffect(card.key) {
                        try { fr.requestFocus() } catch (t: Throwable) { }
                    }
                    OutlinedTextField(
                        value = editBuf,
                        onValueChange = onBufChange,
                        singleLine = true,
                        label = { Text("标题") },
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 2.dp)
                            .focusRequester(fr)
                            .onFocusChanged { st ->
                                if (st.isFocused) {
                                    hadFocus = true
                                    onEditStart(true)
                                } else if (hadFocus) {
                                    hadFocus = false
                                    onCommitEditChanged()
                                }
                            },
                        keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
                        keyboardActions = KeyboardActions(onDone = { onCommitEditChanged() }),
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
                    // ★ 2026-10-10（3.62.2）：正文同样用**焦点**驱动（拿到焦点=开始编辑，失焦=保存），
                    //   比原来那坨"监听 pointerInput 里有没有按下"干净得多（那版还会漏事件）。
                    var bHadFocus by remember(card.key) { mutableStateOf(false) }
                    OutlinedTextField(
                        value = if (editing && !editingTitle) editBuf else card.text,
                        onValueChange = { onBufChange(it) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .heightIn(min = 72.dp, max = 200.dp)
                            .onFocusChanged { st ->
                                if (st.isFocused) {
                                    bHadFocus = true
                                    onEditStart(false)
                                } else if (bHadFocus) {
                                    bHadFocus = false
                                    onCommitEditChanged()
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
                    // ★ 2026-10-10（3.63.6）：原来点了**屏幕上什么都不会变**
                    //   （正文照样在框里、卡片照样开着）⇒ 看起来就是"点不动"。
                    //   现在点了会明确回一句：提交成功 / 本次没有改动。
                    val ctx2 = LocalContext.current
                    TextButton(onClick = {
                        // ★ 3.63.7：即使"没在编辑"也要给回执 —— 否则主人只会看到"点了没反应"
                        val editingNow = editing
                        val changed = onCommitEditChanged()
                        Toast.makeText(
                            ctx2,
                            when {
                                changed -> "已提交到系统提示词 ✓"
                                editingNow -> "没有改动（内容与已保存的一致）"
                                else -> "没有任何改动需要提交"
                            },
                            Toast.LENGTH_SHORT,
                        ).show()
                    }) { Text("提交到提示词") }
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
