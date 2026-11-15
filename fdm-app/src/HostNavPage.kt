// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * 【宿主页面导航器】🐲 2026-11-15（3.108.6）
 *
 * <h3>干什么</h3>
 * 列出宿主**自己的** Compose 路由，点一下就用 {@code HostNav.go(...)}
 * **在宿主进程内**导航过去。
 *
 * <h3>★ 清单是「运行时从宿主导航图里遍历」出来的，不是写死的</h3>
 * 2.5.2 是 22 条、2.8.0 是 25 条（多了 GuardianMobile / HistoryExport /
 * LoginDevicesManagement）⇒ 写死必然过时。
 * 现在由 {@code HostNav.routes()} 递归 {@code NavGraph.iterator()} +
 * 每个 destination 的 {@code nt.e} 读出来，**宿主新增页面会自动出现**。
 * 顺带还守住了项目铁律「不依赖宿主包名」—— 那些 route 串
 * （{@code com.deepseek.chat.ui.pages.*}）一个都不进 dex，
 * 否则会被 {@code build_single.py} 的 ⑫ 自检直接拦下（真被拦过一次）。
 *
 * <h3>3.108.6 的两处硬改动</h3>
 * <ol>
 *   <li><b>带参页面真能跳了</b>：以前点 {@code …MobileVerificationRoute/{signature}}
 *       日志写「成功」，但 `{signature}` 原样留在 route 里、Bundle 空 ⇒ 宿主页面
 *       拿不到参数。现在参数 schema 从 {@code dest.c()} 读（名/类型/可空），
 *       值由「样本 → 用户填」两级提供。</li>
 *   <li><b>样本</b>：宿主自己导航时（`ms7.n(dest,bundle,opts)`）把实参记在内存里。
 *       有样本 ⇒ 表单预填、直接可跳（NavArgument 里没有默认值，这是唯一可靠来源）。</li>
 * </ol>
 *
 * <h3>⚠️ 这个页面只有「整页模式」下才有意义</h3>
 * 导航靠的是 hook 住宿主 {@code NavHostController} 构造器抓到的实例 ——
 * 那个钩子只挂在**宿主进程**里。
 * 在模块本体（我们自己的进程）里打开这一页，{@code HostNav.ready()} 恒为 false，
 * 界面会明说「请从整页里进」，而不是让人点了没反应。
 *
 * <h3>为什么点完要关掉整页</h3>
 * 整页本身是个 {@code Dialog}（盖在宿主 Activity 上面）。导航只改了宿主那边
 * 的返回栈，我们的 Dialog 还在最前面挡着 ⇒ **不关掉就什么都看不见**。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HostNavPage(onBack: () -> Unit, onDone: () -> Unit) {
    val ctx = LocalContext.current
    var msg by remember { mutableStateOf<String?>(null) }
    var msgOk by remember { mutableStateOf(false) }
    // ★ 3.108.6：路由表可刷新（宿主可能在整页打开后才把图建好 / 改过栈）
    var routes by remember { mutableStateOf(HostNavBridge.routes()) }
    var stats by remember { mutableStateOf(HostNavBridge.stats()) }
    val ready = remember { HostNavBridge.ready() }

    // 正在填参数的那一条（null = 没在填）
    var editing by remember { mutableStateOf<HostNavBridge.R?>(null) }
    var vals by remember { mutableStateOf<Map<String, String>>(emptyMap()) }

    fun fire(r: HostNavBridge.R, v: Map<String, String>) {
        if (!ready) {
            msgOk = false
            msg = ctx.fdmStr(R.string.nav_004)
            return
        }
        val keys = r.allKeys()
        val err = HostNavBridge.go(
            r.route,
            keys.toTypedArray(),
            keys.map { v[it] ?: "" }.toTypedArray(),
        )
        if (err == null) {
            msgOk = true
            msg = ctx.fdmStr(R.string.nav_009) + r.label
            Toast.makeText(ctx, msg, Toast.LENGTH_SHORT).show()
            editing = null
            onDone()
        } else {
            msgOk = false
            msg = "${r.label} 失败：$err"
            editing = null
        }
    }

    Scaffold(
        topBar = { FdmTopBar(stringResource(R.string.nav_001), onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier
                .fillMaxSize()
                .padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 14.dp, vertical = 8.dp),
        ) {
            // ── 诊断卡 ──
            Column(
                Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(14.dp))
                    .background(MaterialTheme.colorScheme.surfaceContainer)
                    .padding(14.dp),
            ) {
                Row(
                    Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                ) {
                    Text(
                        if (ready) stringResource(R.string.nav_002) else stringResource(R.string.nav_003),
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Bold,
                        color = if (ready) MaterialTheme.colorScheme.primary
                        else MaterialTheme.colorScheme.error,
                        modifier = Modifier.weight(1f),
                    )
                    TextButton(onClick = {
                        routes = HostNavBridge.routes()
                        stats = HostNavBridge.stats()
                    }) {
                        Text(stringResource(R.string.rb_003), fontSize = 12.sp)
                    }
                }
                Spacer(Modifier.height(4.dp))
                Text(
                    stats,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    fontSize = 11.sp,
                )
                if (ready) {
                    Spacer(Modifier.height(4.dp))
                    Text(
                        "宿主图里共 ${routes.count { !it.isGraph }} 个页面 / ${routes.count { it.isGraph }} 个分组" +
                            " · 其中 ${routes.count { it.needArgs }} 个要参数",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontSize = 11.sp,
                    )
                }
            }

            Spacer(Modifier.height(10.dp))

            // ── 参数表单（**内联**，不开新 window）──
            //   ⚠️ 为什么不用 AlertDialog：整页本身就是一个 Dialog，
            //   再套一个 Dialog 会另建 window + 另建 ComposeView（`dialog.context` 追根到宿主
            //   Activity）—— 3.108.3 修「彩蛋弹窗崩」时踩的就是这条路。
            //   内联在同一个 ComposeView 里 ⇒ 资源 / CompositionLocal / 生命周期全都现成。
            editing?.let { r ->
                val fields = r.allKeys().map { k -> k to (r.params.firstOrNull { it.name == k }) }
                Column(
                    Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(14.dp))
                        .background(MaterialTheme.colorScheme.secondaryContainer)
                        .padding(14.dp),
                ) {
                    Text(
                        "${r.label} · " + stringResource(R.string.nav_005),
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSecondaryContainer,
                    )
                    if (r.sample.isNotEmpty()) {
                        Spacer(Modifier.height(4.dp))
                        Text(
                            stringResource(R.string.nav_007),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.tertiary,
                        )
                    }
                    Spacer(Modifier.height(8.dp))
                    fields.forEach { (name, p) ->
                        OutlinedTextField(
                            value = vals[name] ?: "",
                            onValueChange = { v -> vals = vals + (name to v) },
                            label = {
                                Text(
                                    if (p != null) "$name · ${HostNavBridge.prettyType(p.type)}" else name,
                                    fontSize = 12.sp,
                                )
                            },
                            singleLine = true,
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 3.dp),
                        )
                    }
                    if (fields.isEmpty()) {
                        Text(
                            "这条路由说要参数，但 schema 一个都没读出来 —— 可能只是纯 path 参数，" +
                                "可以直接跳试试。",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            fontSize = 11.sp,
                        )
                    }
                    Row(
                        Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End,
                    ) {
                        TextButton(onClick = { editing = null }) {
                            Text(stringResource(R.string.fdm_lang_cancel))
                        }
                        TextButton(onClick = {
                            val missing = fields
                                .filter { (n, p) -> (vals[n] ?: "").isBlank() && p?.nullable != true }
                                .map { it.first }
                            if (missing.isNotEmpty()) {
                                msgOk = false
                                msg = ctx.fdmStr(R.string.nav_008) + missing.joinToString(", ")
                                editing = null
                            } else {
                                fire(r, vals)
                            }
                        }) {
                            Text(stringResource(R.string.nav_006))
                        }
                    }
                }
                Spacer(Modifier.height(10.dp))
            }
            // ── 上一次的结果（成功就关了，所以这里主要是失败）──
            msg?.let { m ->
                Column(
                    Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(
                            if (msgOk) MaterialTheme.colorScheme.primaryContainer
                            else MaterialTheme.colorScheme.errorContainer
                        )
                        .padding(12.dp),
                ) {
                    Text(
                        m,
                        style = MaterialTheme.typography.bodySmall,
                        color = if (msgOk) MaterialTheme.colorScheme.onPrimaryContainer
                        else MaterialTheme.colorScheme.onErrorContainer,
                    )
                }
                Spacer(Modifier.height(10.dp))
            }

            // ── 分组列表：graph 当分组标题，叶子当条目 ──
            var curGroup = ""
            routes.forEach { r ->
                if (r.isGraph) {
                    // nested graph 本身也能点（进它的默认入口），但先只当标题用
                    curGroup = r.label
                    Spacer(Modifier.height(8.dp))
                    Text(
                        humanGroup(curGroup),
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.padding(start = 4.dp, bottom = 4.dp),
                    )
                    return@forEach
                }
                val label = humanLabel(r.label)
                Row(
                    Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(MaterialTheme.colorScheme.surfaceContainerLow)
                        .clickable {
                            if (!ready) {
                                msgOk = false
                                msg = ctx.fdmStr(R.string.nav_004)
                                return@clickable
                            }
                            // ★ 3.108.6：省得起的参数就直接跳（不然每条都弹表单太烦）
                            //   省不起（有必填）才弹；样本已预填，点「跳转」即可
                            if (r.needArgs && !r.canSkip()) {
                                editing = r
                                vals = r.seedValues()
                            } else {
                                fire(r, r.seedValues())
                            }
                        }
                        .padding(horizontal = 14.dp, vertical = 11.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                ) {
                    Column(Modifier.weight(1f)) {
                        Text(
                            label,
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurface,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis,
                        )
                        Text(
                            r.label,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            fontSize = 10.sp,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis,
                        )
                        if (r.needArgs) {
                            Text(
                                (if (r.canSkip()) "· " else "⚠️ ") + r.argSummary(),
                                style = MaterialTheme.typography.bodySmall,
                                color = if (r.canSkip()) MaterialTheme.colorScheme.onSurfaceVariant
                                else MaterialTheme.colorScheme.error,
                                fontSize = 10.sp,
                                maxLines = 2,
                                overflow = TextOverflow.Ellipsis,
                            )
                        }
                        if (r.sample.isNotEmpty()) {
                            Text(
                                "📥 " + r.sample.entries.joinToString(" · ") { "${it.key}=${it.value}" },
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.tertiary,
                                fontSize = 10.sp,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                            )
                        }
                    }
                    Text(
                        "›",
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontSize = 18.sp,
                    )
                }
                Spacer(Modifier.height(3.dp))
            }

            if (ready && routes.isEmpty()) {
                Spacer(Modifier.height(10.dp))
                Text(
                    "拿到 NavController 了，但图里一条 destination 都没遍历出来 ——" +
                        "可能是这版宿主把 NavGraph 的 iterator 改了，看日志 `【HostNav】`。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.error,
                    fontSize = 11.sp,
                )
            }

            Spacer(Modifier.height(16.dp))
            Text(
                "ℹ️ 带「需要参数」的页面会在点开时弹表单。如果那一条显示 📥 样本，" +
                    "说明宿主自己跳过它、值已经预填好了 —— 直接点「跳转」就行。",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                fontSize = 11.sp,
            )
            Spacer(Modifier.height(24.dp))
        }
    }

}

/** 短名 → 人话（按短名匹配，**不含宿主包名**，所以不破铁律）。 */
private val LABELS = mapOf(
    "Settings" to "设置",
    "FontSize" to "字号",
    "AccountManagement" to "账号管理",
    "AccountDeletion" to "账号注销",
    "DataControlsSettings" to "数据控制",
    "Personalization" to "个性化",
    "ShareLinksManagement" to "分享链接管理",
    "TermsOfService" to "服务条款",
    "HistoryExport" to "历史导出",
    "LoginDevicesManagement" to "登录设备管理",
    "MinorModeBirthdayModify" to "未成年生日修改",
    "MainEntry" to "登录入口",
    "SmsLogin" to "短信登录",
    "Register" to "注册",
    "PasswordLogin" to "密码登录",
    "ResetPassword" to "重置密码",
    "MobileRebind" to "手机换绑",
    "MobileVerification" to "手机验证",
    "Chat" to "聊天页",
    "Welcome" to "欢迎页",
    "GuardianMobile" to "监护人手机",
    "WebView" to "网页面",
    "SearchResultWebView" to "搜索网页",
    "Table" to "表格预览",
    "AgeScreen" to "年龄页",
)

private fun humanLabel(short: String): String = LABELS[short] ?: short

private fun humanGroup(graph: String): String = when {
    graph.contains("Settings", ignoreCase = true) -> "设置簇"
    graph.contains("Auth", ignoreCase = true) -> "登录簇"
    else -> "宿主页面"
}

/**
 * 到 `HostNav`（bridge/Java）的薄桥。
 *
 * <p>为什么包一层：模块本体进程里 `HostNav` 虽然类在，但 `sCtrl` 恒为 null；
 * 而且 `routes()` 返回的是 `String[][]`，Kotlin 侧转成 data class 更好用。
 * 统一在这里 catch —— 这一页不该因为反射/类加载炸掉。
 */
object HostNavBridge {

    /** 一个参数（名字 / 类型名 / 可空 / 有默认值）。 */
    data class P(val name: String, val type: String, val nullable: Boolean, val hasDef: Boolean) {
        /**
         * 能**猜**出来的起始值（null = 猜不出来，得人填）。
         *
         * <p>只猜「宿主管线本来就会给的值」：布尔 → false、列表 → 空。
         * 这两类如果硬要人填，体验是"每条都弹表单"，而填错的可能性反而更大
         * （宿主的 composable 对 boolean 参数就是 `false` 起步）。
         * <b>字符串一律不猜</b> —— signature / ticket / url 猜错比不填更危险。
         */
        val suggested: String?
            get() = when {
                prettyType(type).equals("bool", true) -> "false"
                prettyType(type).equals("boolean", true) -> "false"
                type.startsWith("List") -> ""
                else -> null
            }
    }

    /**
     * 一条 destination。
     *
     * @param params {@code dest.c()} 里的参数 schema（宿主自己声明的）
     * @param sample 宿主自己 navigate 时抓到的实参（可能为空）
     * @param placeholders route 串里的 `{name}`（可能和 params 重合）
     */
    data class R(
        val route: String,
        val label: String,
        val isGraph: Boolean,
        val needArgs: Boolean,
        val params: List<P>,
        val sample: Map<String, String>,
        val placeholders: List<String>,
    ) {
        /** 真正要填的键：schema + 占位符，去重保序。 */
        fun allKeys(): List<String> {
            val out = ArrayList<String>()
            params.forEach { if (!out.contains(it.name)) out.add(it.name) }
            placeholders.forEach { if (!out.contains(it)) out.add(it) }
            return out
        }

        /**
         * 起始值 = 样本（宿主自己用过）→ 被 suggested（布尔/列表）补空位。
         * 样本优先：它是宿主**真实运行过**的值，比我们猜的可靠。
         */
        fun seedValues(): Map<String, String> {
            val out = LinkedHashMap<String, String>()
            out.putAll(sample)
            allKeys().forEach { k ->
                if (out[k] == null) {
                    val sg = params.firstOrNull { it.name == k }?.suggested
                    if (sg != null) out[k] = sg
                }
            }
            return out
        }

        /** 列表里那行提示（名字 · 类型，最多 2 个，多了写 +N）。 */
        fun argSummary(): String {
            val keys = allKeys()
            val head = keys.take(2).joinToString(" · ") { k ->
                val p = params.firstOrNull { it.name == k }
                if (p == null) k else "$k:${prettyType(p.type)}"
            }
            return if (keys.size > 2) "$head  +${keys.size - 2}" else head
        }

        /**
         * 所有参数都能省（可空 / 有默认值 / 是 List）⇒ 不填也能跳。
         *
         * <p>为什么要这个：NavArgument 里的布尔/列表参数宿主管线天然有默认，
         * 逼人填反而是门槛。UI 上给一句「可直接跳」，点条目就直连，
         * 只有真有必填项时才弹表单。
         */
        fun canSkip(): Boolean = allKeys().all { k ->
            val p = params.firstOrNull { it.name == k }
            // schema 里查不到（纯 path 占位符）⇒ 按必填处理，不敢省
            p != null && (p.nullable || p.hasDef || p.suggested != null || sample.containsKey(k))
        }
    }

    /**
     * 宿主 NavType 的自报名 → 人话。
     *
     * <p>真机截图里出现过 `string_non_nullable`（NavType 的名字带可空性后缀），
     * 直接展示又长又难懂；而**是否可空**我们已经单独有一列 `nullable` 了
     * ⇒ 这里只留类型本体。
     */
    fun prettyType(t: String): String = when {
        t == null || t.isEmpty() -> "?"
        t.startsWith("List<") -> "list"
        else -> t.removeSuffix("_non_nullable").removeSuffix("_nullable")
    }

    fun ready(): Boolean = try {
        com.nidyaber.fuckdsmanger.bridge.HostNav.ready()
    } catch (e: Throwable) {
        false
    }

    fun stats(): String = try {
        com.nidyaber.fuckdsmanger.bridge.HostNav.stats()
    } catch (e: Throwable) {
        "HostNav 不可用：$e"
    }

    /**
     * `[route, 短名, 是图, 要参数, 参数schema, 样本, 占位符]` → data class；拿不到就空表。
     *
     * <p>分隔符是 `\u0001`（Java 侧写的常量），字段之间 `|`。
     */
    fun routes(): List<R> = try {
        com.nidyaber.fuckdsmanger.bridge.HostNav.routes().mapNotNull { a ->
            if (a.size < 7) null
            else R(
                route = a[0],
                label = a[1],
                isGraph = a[2] == "1",
                needArgs = a[3] == "1",
                params = parseParams(a[4]),
                sample = parseSample(a[5]),
                placeholders = parseList(a[6]),
            )
        }
    } catch (e: Throwable) {
        emptyList()
    }

    /** @return null = 成功；否则失败原因 */
    fun go(route: String, keys: Array<String>, vals: Array<String>): String? = try {
        com.nidyaber.fuckdsmanger.bridge.HostNav.go(route, keys, vals)
    } catch (e: Throwable) {
        e.toString()
    }

    private fun parseList(s: String): List<String> =
        if (s.isEmpty()) emptyList() else s.split('\u0001').filter { it.isNotEmpty() }

    private fun parseParams(s: String): List<P> = parseList(s).mapNotNull { one ->
        val f = one.split('|')
        if (f.size < 4) null
        else P(f[0], f[1], f[2] == "1", f[3] == "1")
    }

    private fun parseSample(s: String): Map<String, String> {
        val out = LinkedHashMap<String, String>()
        parseList(s).forEach { one ->
            val i = one.indexOf('=')
            if (i > 0) out[one.substring(0, i)] = one.substring(i + 1)
        }
        return out
    }
}
