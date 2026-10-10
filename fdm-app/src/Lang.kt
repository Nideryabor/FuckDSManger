// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import com.nidyaber.fuckdsmanger.bridge.FdmPush

/**
 * 「说话方式」🐲（2026-10-10 · 3.67.0 起）—— 关于页连点七下的小彩蛋。
 *
 * <p>主人：「加个小彩蛋：把 FDM 里原本那个图标方块替换成这个图片，连点七下弹出一个语言切换弹窗，
 * 里面可以修改人话或者龙龙语」。
 *
 * <p>实现：一个**纯本地的偏好** `fdm_lang`（存在我们自己的 SharedPreferences，**不推给宿主**）：
 * <ul>
 *   <li>{@link #HUMAN} 人话 —— 正经说话（默认）</li>
 *   <li>{@link #DRAGON} 龙龙语 —— 尼尼的母语（嗷呜咕噜）</li>
 * </ul>
 *
 * <h3>★ 3.68.0：文案全部搬进 resources.arsc</h3>
 * 主人：「我推荐资源文件走 arsc，不然硬编码很难受」。
 * 于是这个文件里**再也没有一行中文文案** —— 只有资源 id：
 * <pre>
 *   Lang.t(ctx, R.string.xxx_human, R.string.xxx_dragon)
 * </pre>
 * 两句都住在 `fdm-app/res/values/strings.xml`（前缀 `fdm_lang_`），由 aapt2 编进
 * resources.arsc ⇒ 想改一句话，改 res 重编即可，或者直接拿 MT 改包里的 arsc。
 *
 * <p><b>加一句新话 = 两步</b>：① strings.xml 加 `xxx_human` / `xxx_dragon` 两个 string；
 * ② 下面的 {@link S} 里加一行。
 */
object Lang {

    const val HUMAN = 0
    const val DRAGON = 1

    /** 偏好键（我们自己的 SP，不推宿主）。 */
    private const val K = "fdm_lang"

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
    }

    /** 「人话」/「龙龙语」这两个**名字**也走资源（弹窗里的单选标题用它）。 */
    fun nameRes(v: Int): Int =
        if (v == DRAGON) R.string.fdm_lang_dragon else R.string.fdm_lang_human

    fun name(ctx: Context, v: Int): String = ctx.getString(nameRes(v))

    /** 弹窗里那一行小字说明（人话版 / 龙龙语版）。 */
    fun subRes(v: Int): Int =
        if (v == DRAGON) R.string.fdm_lang_dragon_sub else R.string.fdm_lang_human_sub

    /** 选完之后弹的那句回执。 */
    fun toastRes(v: Int): Int =
        if (v == DRAGON) R.string.fdm_lang_toast_dragon else R.string.fdm_lang_toast_human

    /**
     * 按当前说话方式挑一句。
     * 两个参数都是 **resources.arsc 里的 String 资源 id**（不是文案本身）。
     */
    fun t(ctx: Context, human: Int, dragon: Int): String =
        ctx.getString(if (current(ctx) == DRAGON) dragon else human)

    /**
     * 已经接进去的句子（集中放在这儿，加一句只改这一处）。
     * 对应的文案在 `res/values/strings.xml` 里，键前缀 `fdm_lang_`。
     */
    object S {
        /** 关于页标语 */
        fun tagline(ctx: Context): String =
            t(ctx, R.string.fdm_lang_tagline_human, R.string.fdm_lang_tagline_dragon)

        /** 系统提示词页的空容器提示 */
        fun emptyBox(ctx: Context): String =
            t(ctx, R.string.fdm_lang_emptybox_human, R.string.fdm_lang_emptybox_dragon)

        /** 「功能原理 & 帮助」入口 */
        fun helpEntry(ctx: Context): String =
            t(ctx, R.string.fdm_lang_help_human, R.string.fdm_lang_help_dragon)
    }
}
