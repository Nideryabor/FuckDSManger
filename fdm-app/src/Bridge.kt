// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import com.nidyaber.fuckdsmanger.bridge.FdmPush

/**
 * 桥的 **UI 侧封装** 🐲
 *
 * 界面只跟它打交道，不直接碰 SharedPreferences / 广播 / 键名。
 *
 * 三种值要分清（很重要）：
 *   · **我们的值** `get*()`      —— 我们请求过什么（存在 `fdm_ui`）
 *   · **宿主真值** `host()`      —— 宿主那边**实际**是什么（由宿主回读广播回来）
 *   · 界面显示的应该是**宿主真值**（拿不到时才退回我们的值并标注）
 */
object Bridge {
    /** 把当前配置推给宿主（宿主会走功能自己的入口写入）。 */
    fun push(ctx: Context): Int = FdmPush.push(ctx)

    /** 写一项并立刻推。 */
    fun set(ctx: Context, key: String, value: Any) = FdmPush.set(ctx, key, value)

    // —— 我们的值 ——
    private fun sp(ctx: Context) = FdmPush.sp(ctx)
    fun getBool(ctx: Context, key: String, def: Boolean) = sp(ctx).getBoolean(key, def)
    fun getInt(ctx: Context, key: String, def: Int) = sp(ctx).getInt(key, def)
    fun getStr(ctx: Context, key: String, def: String) = sp(ctx).getString(key, def) ?: def

    // —— 宿主真值（宿主回读广播回来的）——
    fun host(ctx: Context, key: String, def: String = "—") =
        sp(ctx).getString(FdmPush.HOST_PREFIX + key, def) ?: def

    fun hostAt(ctx: Context) = sp(ctx).getLong("host.at", 0L)
    fun appliedRev(ctx: Context) = sp(ctx).getInt("applied_rev", -1)
    fun appliedAt(ctx: Context) = sp(ctx).getLong("applied_at", 0L)
}
