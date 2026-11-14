// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger

import android.content.Context
import android.content.res.Resources

/**
 * 【HostRes】整页模式下，让 `ctx.getString(R.string.xxx)` 也能查到**我们自己的**资源表 🐲 2026-11-14
 *
 * <h3>为什么需要它（两次真机崩溃换来的）</h3>
 * 整页跑在宿主进程里，我们和宿主是**两个 APK**，资源 id **都是 `0x7f`**
 * ⇒ 一份 `Resources` 只能认一张表，"两张表共存"在 id 层面就是不可能的。
 * 而三条取值路径分属两个表：
 * <pre>
 *   ① stringResource(R.string.x)        → LocalResources              ← 我们已注入模块表 ✅
 *   ② Material3 内部 getString(id)      → LocalContext.getResources() ← 宿主表，必须让它查宿主 ✅
 *   ③ ctx.getString(R.string.x)         → LocalContext.getResources() ← 宿主表 ❌ 查不到我们的 id
 * </pre>
 * ①② 都已经正好了；**③ 是唯一还坏的**，而全 UI 有 ~500 处这种调用。
 *
 * <h3>为什么不能用「把 LocalContext 换成模块 Context」解决</h3>
 * 那样 ② 就会跟着坏 —— Material3 内部文案的 id 属于**宿主**表，换掉就
 * `Resources$NotFoundException`（真机崩过：彩蛋弹 AlertDialog）。
 * 两条路径共用同一个 Context，**没法只给其中一条换表**。
 *
 * <h3>所以：给 ③ 开一条专用通道</h3>
 * 本文件提供 [fdmStr]：**先查模块表，查不到才回落宿主表**。
 * 然后把 UI 里那些"本来想查我们自己文案"的 `ctx.getString(` 机械替换成 `ctx.fdmStr(`。
 * <ul>
 *   <li>Material3 **完全不受影响**（它不走这个扩展函数）</li>
 *   <li>`getResources()` **一个字都不用动**</li>
 *   <li>在**我们自己的进程**里（模块 UI 正常启动时）[uiRes] 为 null ⇒ 直接走原 `getString`，
 *       行为与改之前**相同**（这就是为什么这个改动对旧路径几乎零风险）</li>
 * </ul>
 */
object HostRes {

    /**
     * 整页模式下那份"指向模块 APK"的 Resources；模块自己进程里恒为 null。
     *
     * <p>由 [HostPage] 在装载时设置。用 `@Volatile` 是因为整页可能在主线程装、
     * 而 Compose 组合/工具函数可能在别的线程读。
     */
    @Volatile
    private var uiRes: Resources? = null

    /** 供 [HostPage] 调用：整页装载成功后把模块资源表交进来。 */
    @JvmStatic
    fun installModuleRes(r: Resources?) {
        uiRes = r
    }

    /** 当前是否处于"整页模式"（有模块资源表可用）。 */
    @JvmStatic
    fun active(): Boolean = uiRes != null

    /**
     * 取一条文案：**模块表优先，回落宿主表**。
     *
     * @param ctx 任意 Context（整页里是 `ResCtx`，它包着的宿主 Context 也够用来回落）
     * @param id  资源 id（我们自己的 `R.string.xxx`）
     */
    fun str(ctx: Context, id: Int, vararg args: Any): String {
        val r = uiRes
        if (r != null) {
            try {
                return if (args.isEmpty()) r.getString(id) else r.getString(id, *args)
            } catch (_: Throwable) {
                // 这个 id 不在模块表里（比如库自己的 R）⇒ 落到宿主表
            }
        }
        return if (args.isEmpty()) ctx.getString(id) else ctx.getString(id, *args)
    }
}

/**
 * 【BridgeRes】一份**同时认得两张表**的 Resources 🐲 2026-11-14（3.108.2）
 *
 * <h3>为什么必须加它（真机崩溃，堆栈见下）</h3>
 * <pre>
 *   Resources$NotFoundException: String resource ID #0x7f0a0059
 *     at Resources.getText
 *     at material3.internal.Strings_androidKt.getString-2EP1pXo
 *     at material3.OutlinedTextFieldKt$OutlinedTextField$3.invoke   ← **我们自己编的** Material3
 *     at RowsKt.SettingText → PagesKt.GrayRow                       ← 我们的灰度行
 * </pre>
 * `0x7f0a0059` 在我们模块的资源表里是 `default_error_message`
 * —— 也就是说这个 id 是**我们 aapt2 编出来的**（来自 material3 依赖的 strings）。
 * 而 `Material3` 取文案走 `LocalContext.getResources()`，
 * 那份 Resources 认的是**宿主的**资源表 ⇒ 同一个数字在宿主表里是别的资源（或不存在）
 * ⇒ `NotFoundException` ⇒ 宿主整个进程崩掉。
 *
 * <h3>为什么以前修不了</h3>
 * 3.107.0 试过「把 `getResources()` 整个换成模块表」→ 崩（宿主的 id 找不到）；
 * 也试过「只换 `LocalResources`」→ 崩（`ctx.getString` 还是宿主表）。
 * 当时得出的结论是「一份 Resources 只能认一张表」—— **这句话只在"
 * 要么全给模块、要么全给宿主"的前提下成立**。
 *
 * <h3>真正的解法：一次查不到就换另一张表</h3>
 * 这次 `javap android.content.res.Resources` 看清了一件事 ——
 * **`getText` / `getString` / `getDrawable` / `getColor` 全都不是 `final`**
 * （只有 `newTheme` / `getAssets` 是）。3.107.0 卡住的是 `Context.getString`
 * （那个确实 `final`），不是这里。
 * ⇒ 造一个子类，**先查模块表、查不到再查宿主表**：
 * <pre>
 *   Material3 的 id（我们编的）  → 模块表命中  ✅ 不再崩
 *   宿主/Library 的 id           → 模块表抛 ⇒ 回落宿主  ✅ 老功能不变
 *   我们自己的 R.string          → 模块表命中  ✅
 * </pre>
 *
 * <h3>⚠️ 两个必须守住的东西</h3>
 * <ol>
 *   <li>**`assets` / `displayMetrics` / `configuration` 全部来自宿主**
 *       （`super(base.assets, …)`）⇒ `super.getXxx()` 查的一定是宿主表，
 *       宿主自己的资源解析、主题、密度全都不受影响。</li>
 *   <li>**只有"模块表抛 NotFoundException"才回落**。别的异常（OOM 之类）原样抛出去，
 *       绝不吞 —— 吞掉会把「真的坏了」伪装成「找不到资源」（教训 807）。</li>
 * </ol>
 *
 * <h3>性能</h3>
 * 常态是**模块表直接命中**（不抛异常）。只有库/宿主的 id 才会走一次 catch，
 * 而那种调用集中在文案上，不在绘制热路径里（教训 328 说的是每帧反射，不是这个）。
 */
class BridgeRes(
    base: Resources,
    private val mod: Resources,
) : Resources(base.assets, base.displayMetrics, base.configuration) {

    // ── 文案 ──────────────────────────────────────────────────────────

    override fun getText(id: Int): CharSequence {
        try {
            return mod.getText(id)
        } catch (e: Resources.NotFoundException) {
            return super.getText(id)
        }
    }

    override fun getText(id: Int, def: CharSequence?): CharSequence {
        try {
            return mod.getText(id)
        } catch (_: Resources.NotFoundException) {
            return super.getText(id, def)
        }
    }

    override fun getString(id: Int): String {
        try {
            return mod.getString(id)
        } catch (e: Resources.NotFoundException) {
            return super.getString(id)
        }
    }

    override fun getString(id: Int, vararg formatArgs: Any?): String {
        try {
            return mod.getString(id, *formatArgs)
        } catch (_: Resources.NotFoundException) {
            return super.getString(id, *formatArgs)
        }
    }

    // ── 图片 / 颜色 ───────────────────────────────────────────────────

    override fun getDrawable(id: Int): android.graphics.drawable.Drawable? {
        try {
            return mod.getDrawable(id)
        } catch (_: Resources.NotFoundException) {
            return super.getDrawable(id)
        }
    }

    override fun getDrawable(id: Int, theme: Resources.Theme?): android.graphics.drawable.Drawable? {
        try {
            return mod.getDrawable(id, theme)
        } catch (_: Resources.NotFoundException) {
            return super.getDrawable(id, theme)
        }
    }

    override fun getColor(id: Int): Int {
        try {
            return mod.getColor(id)
        } catch (_: Resources.NotFoundException) {
            return super.getColor(id)
        }
    }

    override fun getColor(id: Int, theme: Resources.Theme?): Int {
        try {
            return mod.getColor(id, theme)
        } catch (_: Resources.NotFoundException) {
            return super.getColor(id, theme)
        }
    }

    override fun getColorStateList(id: Int): android.content.res.ColorStateList {
        try {
            return mod.getColorStateList(id)
        } catch (_: Resources.NotFoundException) {
            return super.getColorStateList(id)
        }
    }

    override fun getColorStateList(
        id: Int,
        theme: Resources.Theme?,
    ): android.content.res.ColorStateList {
        try {
            return mod.getColorStateList(id, theme)
        } catch (_: Resources.NotFoundException) {
            return super.getColorStateList(id, theme)
        }
    }

    // ── 数组 ──────────────────────────────────────────────────────────

    override fun getTextArray(id: Int): Array<CharSequence> {
        try {
            return mod.getTextArray(id)
        } catch (_: Resources.NotFoundException) {
            return super.getTextArray(id)
        }
    }

    override fun getStringArray(id: Int): Array<String> {
        try {
            return mod.getStringArray(id)
        } catch (_: Resources.NotFoundException) {
            return super.getStringArray(id)
        }
    }

    override fun getIntArray(id: Int): IntArray {
        try {
            return mod.getIntArray(id)
        } catch (_: Resources.NotFoundException) {
            return super.getIntArray(id)
        }
    }
}

/**
 * `ctx.getString(...)` 的替代品：**模块表优先**。
 *
 * <p>用法同 `getString`，改法就是把 `ctx.getString(` 换成 `ctx.fdmStr(`。
 */
fun Context.fdmStr(id: Int): String = HostRes.str(this, id)

/** 带格式参数的版本。 */
fun Context.fdmStr(id: Int, vararg args: Any): String = HostRes.str(this, id, *args)
