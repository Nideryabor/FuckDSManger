// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import android.content.res.Configuration
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.setValue
import com.nidyaber.fuckdsmanger.bridge.FdmPush
import java.util.Locale

/**
 * 「说话方式」🐲（2026-10-10 · 3.67.0 起）—— 关于页连点七下的小彩蛋。
 *
 * <p>主人：「加个小彩蛋：连点七下弹出一个语言切换弹窗，里面可以修改**人话或者龙龙语**」。
 *
 * <h3>机制（3.68.0 定型）：伪 locale + 资源变体，而不是"一句两个 key"</h3>
 *
 * 主人后来又说「**全部接上!!!!**」—— 要把整个界面的文案都跟着说话方式变。
 * 如果按"一句两个 key"（`xxx_human` / `xxx_dragon`）来做，那每加一句话都要
 * **改调用点的类型**，几百条文案就是几百次改动 ⇒ 不可维护 ✗
 *
 * 改用 Android 原生的资源变体（实测可行）：
 * <pre>
 *   res/values/strings.xml      ← 人话（默认）
 *   res/values-zz/strings.xml   ← 龙龙语（**zz** 是 BCP47 保留码，真机不会被设成它）
 * </pre>
 * 同一个 key 在两个目录里各写一份，运行时用 {@link #wrap} 换一个带 zz locale 的
 * Configuration ⇒ 系统自己去挑 `values-zz` 的那份。
 *
 * <p><b>两个大好处</b>：
 * <ol>
 *   <li>调用点**永远是同一句话**：`ctx.getString(R.string.xxx)` —— 它自动是当前说话方式的版本，
 *       加新文案不需要动 Kotlin；</li>
 *   <li>`values-zz` **不用写满**：没写的 key 自动回落到人话版（Android 的资源 fallback）
 *       ⇒ 龙龙语可以**一句一句慢慢加**，永远处于"能用的中间状态"。</li>
 * </ol>
 *
 * <p>{@link #version} 是个 Compose state：换说话方式时 +1，顶层据此重建 ctx，
 * 整棵树跟着换语言（**不用重启 Activity**，也就不会闪）。
 *
 * <p>偏好键 `fdm_lang` 存在我们自己的 SharedPreferences，**不推给宿主**。
 */
object Lang {

    const val HUMAN = 0
    const val DRAGON = 1

    /** 偏好键（我们自己的 SP，不推宿主）。 */
    private const val K = "fdm_lang"

    /**
     * 龙龙语用的**伪 locale**。
     *
     * `zz` 是 BCP47 里"保留/未定义"的两位语言码 ⇒ 真机不会被设成它，
     * 我们拿它当一个只属于自己的"语言"来挂 `values-zz/`。
     */
    @Suppress("DEPRECATION")
    private val DRAGON_LOCALE: Locale = Locale("zz")

    /**
     * 说话方式的「版本号」：{@link #set} 一次就 +1。
     *
     * <p>顶层 `FdmApp` 读它 ⇒ 换说话方式时整棵树重组、ctx 换成新语言的。
     * 用 state（而不是让弹窗去回调）是为了**不让彩蛋的开关穿越大半棵组件树**。
     */
    var version by mutableIntStateOf(0)
        private set

    fun current(ctx: Context): Int = try {
        FdmPush.sp(ctx).getInt(K, HUMAN)
    } catch (t: Throwable) {
        HUMAN
    }

    fun set(ctx: Context, v: Int) {
        try {
            FdmPush.sp(ctx).edit().putInt(K, if (v == DRAGON) DRAGON else HUMAN).apply()
        } catch (t: Throwable) {
            // 存不上就算了 —— 彩蛋不该把页面搞崩
        }
        version += 1          // ★ 无论存没存上，都让界面按新选择重画一次
    }

    /**
     * 造一个"按当前说话方式说话"的 Context。
     *
     * <p>人话 ⇒ 原样返回；龙龙语 ⇒ `createConfigurationContext`（带 zz locale）。
     * 任何异常都**静默降级**回原 ctx —— 彩蛋不该把界面搞崩。
     */
    fun wrap(base: Context, v: Int): Context {
        if (v != DRAGON) return base
        return try {
            val cfg = Configuration(base.resources.configuration)
            cfg.setLocale(DRAGON_LOCALE)
            base.createConfigurationContext(cfg)
        } catch (t: Throwable) {
            base
        }
    }

    /* ────────────────── 弹窗自己的那几句 ──────────────────
     *
     * 注意：弹窗里要**同时**显示「人话」「龙龙语」两个选项名，所以这几个不能
     * 依赖"当前的 ctx 是哪国话" ⇒ 老老实实用两个独立 key（**不往 values-zz 里写**，
     * 让它们在任何说话方式下都显示成中文，免得主人自己都认不出在选什么）。
     */

    fun nameRes(v: Int): Int =
        if (v == DRAGON) R.string.fdm_lang_dragon else R.string.fdm_lang_human

    fun name(ctx: Context, v: Int): String = ctx.getString(nameRes(v))

    /** 选项下面那行小字（人话版 / 龙龙语版）。 */
    fun subRes(v: Int): Int =
        if (v == DRAGON) R.string.fdm_lang_dragon_sub else R.string.fdm_lang_human_sub

    /** 选完之后弹的那句回执 —— 用**刚选的那种话**说，所以也是两个 key。 */
    fun toastRes(v: Int): Int =
        if (v == DRAGON) R.string.fdm_lang_toast_dragon else R.string.fdm_lang_toast_human

    /**
     * 已经接进去的句子。
     *
     * <p>★ 3.68.0 起它们都只有**一个 key** —— 龙龙语版住在 `res/values-zz/strings.xml`，
     * 由 {@link #wrap} 出来的 ctx 自动挑。**加一句 = 两个目录各写一条**（龙龙语可以先不写，
     * 那就自动是人话）。
     */
    object S {
        /** 关于页标语 */
        fun tagline(ctx: Context): String = ctx.getString(R.string.fdm_lang_tagline)

        /** 系统提示词页的空容器提示 */
        fun emptyBox(ctx: Context): String = ctx.getString(R.string.fdm_lang_emptybox)

        /** 「功能原理 & 帮助」入口 */
        fun helpEntry(ctx: Context): String = ctx.getString(R.string.fdm_lang_help)
    }
}
