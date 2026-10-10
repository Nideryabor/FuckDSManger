// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import com.nidyaber.fuckdsmanger.bridge.FdmPush

/**
 * 「说话方式」🐲（2026-10-10 · 3.67.0）
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
 * <p>用 {@link #t} 挑句子：`Lang.t(ctx, "人话版", "龙龙语版")`。
 * 现在接进去的地方还不多（关于页标语 / v2 空容器提示 / 帮助入口），**要加哪一句跟我说**。
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

    fun name(v: Int): String = if (v == DRAGON) "龙龙语" else "人话"

    /** 按当前说话方式挑一句。 */
    fun t(ctx: Context, human: String, dragon: String): String =
        if (current(ctx) == DRAGON) dragon else human

    /** 已经接进去的那几句（集中放在这儿，改文案只改这一处）。 */
    object S {
        fun tagline(ctx: Context): String = t(
            ctx,
            "FDM-100%由DS鬼脑发动的神秘模块",
            "FDM-100%由龙龙脑瓜发动の神秘模块，嗷呜！"
        )

        fun emptyBox(ctx: Context): String = t(
            ctx,
            "（空白容器 · 把抽屉里的卡片拖上来）",
            "（空空的窝 · 把卡片叼上来嗷）"
        )

        fun helpEntry(ctx: Context): String = t(
            ctx,
            "功能原理 & 帮助",
            "嗷呜·原理与帮助"
        )
    }
}
