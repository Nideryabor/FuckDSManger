// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger

import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistryController
import androidx.savedstate.SavedStateRegistryOwner

/**
 * 宿主内嵌 Compose（保底弹窗 / 整页探针）专用的 **三件套 owner** 🐲
 *
 * <h3>为什么一次要三个</h3>
 * Compose 1.12.1 的 `AbstractComposeView.resolveComposeViewContext()` 会**逐个 require**：
 * ```
 * ViewTreeLifecycleOwner.get(view)          ?: error("...doesn't propagate ViewTreeLifecycleOwner!")
 * ViewTreeSavedStateRegistryOwner.get(view) ?: error("...doesn't propagate ViewTreeSavedStateRegistryOwner!")
 * ViewTreeViewModelStoreOwner.get(view)     ?: error(...)
 * ```
 * 三个错误全部抛在 `attachedToWindow → ViewRootImpl.performTraversals` ⇒ **下一帧**才炸，
 * 调用方的 try/catch 根本接不住 ⇒ **宿主直接崩**。
 *
 * <h3>初始化顺序是硬约束（反编译 savedstate-android 1.3.1 所得）</h3>
 * <pre>
 * SavedStateRegistryImpl.performAttach():
 *     require(lifecycle.currentState == INITIALIZED)
 *         else "Restarter must be created only during owner's initialization stage"
 * SavedStateRegistryImpl.performRestore():
 *     require(!lifecycle.currentState.isAtLeast(STARTED))
 *         else "performRestore cannot be called when owner is ..."
 *     → 这一步才会把 isRestored 置 true
 * SavedStateRegistryImpl.consumeRestoredStateForKey():
 *     require(isRestored)
 *         else "You can 'consumeRestoredStateForKey' only after the corresponding
 *               component has moved to the 'CREATED' state"
 * </pre>
 * ⇒ 必须严格按 **attach → restore → 推进生命周期** 的顺序，一步都不能提前。
 *
 * <h3>真机连崩记录（每一步都是这么试出来的）</h3>
 * | 版本 | 现象 | 真因 |
 * |---|---|---|
 * | 3.99.4 | `argument 2 has type LifecycleOwner, got MainActivity` | 宿主的 owner 与我们是**两个 loader 里的两个 Class**，永远挂不上 |
 * | 3.99.5 | `ViewTreeLifecycleOwner not found` | 挂不上就跳过 ⇒ attach 时现找 ⇒ 炸在 traversal |
 * | 3.99.6 | `ViewTreeSavedStateRegistryOwner!` | 只挂了 Lifecycle，另外两个也是**必需**的 |
 * | 3.99.7 | `consumeRestoredStateForKey ... 'CREATED' state` | 三个都挂上了，但 **performRestore 没调** ⇒ isRestored=false |
 *
 * <h3>设计要点</h3>
 * · **全部在 module loader 里**（fdm-app 编译）⇒ 与 ComposeView 看到同一个 Class 对象
 *   ⇒ `set()` 的类型检查必过。**绝不借宿主的 owner。**
 * · `LifecycleRegistry.createUnsafe`：不做主线程检查（钩子可能在任意线程进来）；
 *   拿不到就退回普通版。
 * · **不 save/restore 任何业务状态**：纯展示的临时 owner，restore 传 null 即可。
 * · `ViewModelStore` 空实现：万一 Compose 内部用了 `viewModel()` 也不会抛。
 */
object FallbackLifecycle :
    LifecycleOwner,
    SavedStateRegistryOwner,
    ViewModelStoreOwner {

    // ── ① Lifecycle（此刻必须是 INITIALIZED —— 后面两步依赖它）────
    private val reg: LifecycleRegistry = try {
        LifecycleRegistry.createUnsafe(this)
    } catch (t: Throwable) {
        LifecycleRegistry(this)
    }

    // ── ② SavedStateRegistry ───────────────────────────────────
    private val ssController: SavedStateRegistryController =
        SavedStateRegistryController.create(this)

    private val vmStore = ViewModelStore()

    /**
     * ⚠️ 顺序是硬约束：attach（要 INITIALIZED）→ restore（要 < STARTED）→ 推进到 RESUMED。
     *
     * <p>任何一步失败都**不应该**继续往下走 —— 因为继续下去 ComposeView 一定会崩在下一帧。
     * 但这里也不能抛（object 初始化抛异常会把整个 FdmComposeDialog 拖死），
     * 所以记一个 `ready` 标志，由 bridge 侧检查：**ready=false 就根本不 show**。
     */
    @Volatile
    var ready: Boolean = false
        private set

    init {
        var ok = true
        try {
            ssController.performAttach()          // 要求 currentState == INITIALIZED
        } catch (t: Throwable) {
            ok = false
        }
        if (ok) {
            try {
                ssController.performRestore(null) // 要求 !isAtLeast(STARTED)，置 isRestored
            } catch (t: Throwable) {
                ok = false
            }
        }
        if (ok) {
            try {
                reg.currentState = Lifecycle.State.RESUMED
            } catch (t: Throwable) {
                // 设不上不算致命：Compose 会在 resume 时自己补，最多晚一帧合成
            }
        }
        ready = ok
    }

    override val lifecycle: Lifecycle
        get() = reg

    override val savedStateRegistry: SavedStateRegistry
        get() = ssController.savedStateRegistry

    override val viewModelStore: ViewModelStore
        get() = vmStore

    // ── 给 Java（bridge 侧反射）用的门 ───────────────────────────
    @JvmStatic
    fun life(): Lifecycle = reg

    @JvmStatic
    fun savedState(): SavedStateRegistry = ssController.savedStateRegistry

    @JvmStatic
    fun vmStore(): ViewModelStore = vmStore

    /** 是否三件套都准备好了（bridge 侧 show 之前必须问这一句）。 */
    @JvmStatic
    fun isReady(): Boolean = ready

    /** 弹窗关掉时清 VM 缓存（不调也不会崩）。 */
    @JvmStatic
    fun clear() {
        try {
            vmStore.clear()
        } catch (t: Throwable) {
            // 忽略
        }
    }
}
