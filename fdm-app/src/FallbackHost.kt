// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger

import android.view.View
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.Alignment
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * 保底弹窗的 **Compose 版**（跑在**宿主进程**里）🐲
 *
 * ── 为什么不写在 bridge（Java）里 ────────────────────────────────
 * Compose 的 content lambda 必须由 **Compose 编译器插件**生成
 * （里面有 `startRestartGroup` / `changed` flags 那一套协议），
 * 手写 Java 几乎不可能对。而 bridge 是 `javac` 编的、不带这个插件。
 * ⇒ 所以这一份放在 **fdm-app（Kotlin + Compose 编译）** 里，
 *    bridge 侧只负责**反射调用** {@link #install}。
 *
 * ── 为什么能在宿主进程里跑到 ──────────────────────────────────
 * 2026-11-07 实测（`compose_probe` 命令，宿主进程内）：
 * <pre>
 *   ① androidx.compose.ui.platform.ComposeView ✓
 *      setContent[interface kotlin.jvm.functions.Function2]
 *   ② com.nidyaber.fuckdsmanger.Conf / MainActivity ✓  ← 都在 LspModuleClassLoader
 *   ③ androidx.compose.runtime.Composer ✓ · androidx.lifecycle.LifecycleOwner ✓
 * </pre>
 * 关键结论：LSPosed 把我们**整个模块 APK**（含 Compose runtime）都塞进了
 * 宿主的 classpath ⇒ 我们编好的 Composable **能**在宿主进程里跑。
 *
 * ── 但它只是"锦上添花" ────────────────────────────────────────
 * 保底**必须**是最后一道防线。所以 bridge 侧的策略是：
 *   先试本类 —— 任何一步（类找不到 / 版本不匹配 / NoSuchMethodError /
 *   IllegalStateException: ViewTreeLifecycleOwner not found）
 *   **立刻退回纯 View 版** {@code FdmFallbackDialog}。
 * 绝不允许"为了好看"把保底本身变成新的失败点。
 */
object FallbackHost {

    private val C_CARD = Color(0xFF1E1E22)
    private val C_TITLE = Color(0xFFFFFFFF)
    private val C_PRIMARY = Color(0xFF3D7EFF)
    private val C_SECOND = Color(0xFF33333A)
    /** 橙：root 用户（隐藏应用列表那条）。 */
    private val C_WARN = Color(0xFFFF8A65)
    /** 绿：npatch 用户（暂时找不到原因）。 */
    private val C_GREEN = Color(0xFF6BCB77)
    /** 青：行动指引。 */
    private val C_CYAN = Color(0xFF4DD0E1)

    // ══════════════════════════════════════════════════════════════════
    //  文案（2026-11-07 主人定稿：**两个弹窗合并成一个**）
    //
    //  旧形态是「先显示一句含糊的失败说明 → 点了按钮才换成排查指引」，
    //  问题是：主人第一次看到时**什么有用信息都没有**，必须点一下才知道该查什么，
    //  而点一下又正好会重试拉起（把状态搅得更乱）。
    //  ⇒ 现在**一次全摊开**，点按钮就只是重试。
    //
    //  ⚠️ 这三段必须和 FdmFallbackDialog 里的 T_* 常量**逐字一致**
    //     （两份实现 = 两条渲染路径，但只能有一份文案）。
    // ══════════════════════════════════════════════════════════════════
    private const val T_TITLE = "貌似拉起模块出错了……"
    private const val T_ROOT =
        "root用户请单独看看是不是隐藏应用列表把模块排除了，尽量选择对宿主隐藏模块，" +
            "这样数美启动最多探测到有隐藏应用列表，不会上报包名"
    private const val T_NPATCH = "修补(npatch)用户暂时找不到可能的原因"
    private const val T_ACT = "点击下面的按钮重试"

    /**
     * 把 Compose 内容装进 {@code cv}。
     *
     * @param cv       必须是一个 {@link ComposeView}（由 bridge 侧反射创建）
     * @param reason   失败原因（一句话，写进正文便于自查）
     * @param onLaunch 点「拉起模块 UI」
     * @param onHost   点「检查宿主更新」（宿主原本的逻辑）
     */
    @JvmStatic
    fun install(cv: View, reason: String?, onLaunch: Runnable?, onHost: Runnable?) {
        val compose = cv as ComposeView
        compose.setContent {
            FallbackCard(reason = reason, onLaunch = onLaunch, onHost = onHost)
        }
    }

    @Composable
    private fun FallbackCard(reason: String?, onLaunch: Runnable?, onHost: Runnable?) {
        Column(
            Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(20.dp))
                .background(C_CARD)
                .padding(horizontal = 22.dp, vertical = 20.dp)
        ) {
            Text(
                text = T_TITLE,
                color = C_TITLE,
                fontSize = 17.sp,
                fontWeight = FontWeight.Bold
            )

            // ── 三段说明（一次全摊开，不再"点一下才显示"）──
            Note(T_ROOT, C_WARN)
            Note(T_NPATCH, C_GREEN)
            Note(T_ACT, C_CYAN)

            Spacer(Modifier.height(18.dp))

            Row(
                Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                Btn(
                    label = "拉起模块 UI",
                    bg = C_PRIMARY,
                    modifier = Modifier.weight(1f)
                ) {
                    // 文案已经一次摊开了 ⇒ 按钮只做重试这一件事
                    onLaunch?.run()
                }
            }
        }
    }

    /** 一段带颜色的说明（段落间距靠 padding 而不是 Spacer，省一层布局）。 */
    @Composable
    private fun Note(text: String, color: Color) {
        Text(
            text = text,
            color = color,
            fontSize = 13.sp,
            lineHeight = 19.sp,
            modifier = Modifier.padding(top = 12.dp)
        )
    }

    @Composable
    private fun Btn(
        label: String,
        bg: Color,
        modifier: Modifier = Modifier,
        onClick: () -> Unit
    ) {
        Box(
            modifier
                .clip(RoundedCornerShape(12.dp))
                .background(bg)
                .clickable(onClick = onClick)
                .padding(vertical = 10.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = label,
                color = Color.White,
                fontSize = 13.sp,
                modifier = modifier
            )
        }
    }
}
