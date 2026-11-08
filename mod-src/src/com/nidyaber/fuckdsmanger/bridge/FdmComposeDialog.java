// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Method;

/**
 * 【FdmComposeDialog】保底弹窗的 **Compose 版** 🐲
 *
 * <h3>为什么会有这个类（主人：「试试看 compose 嘛」）</h3>
 * 原来的保底是纯 View（{@link FdmFallbackDialog}），能用但丑。
 * 主人提议试 Compose，于是先做了探针（{@code am broadcast … --es cmd compose_probe}），
 * 在**宿主进程内**实测到三件决定性的事：
 * <pre>
 *   ① androidx.compose.ui.platform.ComposeView ✓
 *      setContent[interface kotlin.jvm.functions.Function2]
 *   ② com.nidyaber.fuckdsmanger.Conf / MainActivity ✓   ← 都在 LspModuleClassLoader
 *   ③ androidx.compose.runtime.Composer ✓ · LifecycleOwner ✓
 * </pre>
 * <b>结论</b>：LSPosed 把我们**整个模块 APK**（含 Compose runtime + 我们编好的
 * @Composable 函数）都塞进了宿主进程的 classpath ⇒ 我们能在宿主里跑自己的 Compose。
 *
 * <h3>为什么不是直接 setContentView(ComposeView)</h3>
 * {@code ComposeView} 需要 {@code ViewTreeLifecycleOwner} 才能重组
 * （没有就在 attach 时抛 {@code IllegalStateException: ViewTreeLifecycleOwner not found}）。
 * 宿主的 {@code androidx.lifecycle} 是**混淆**的，但 AndroidX 类名没被改
 * （Compose 编译器插件依赖固定签名）—— 所以宿主**自己**那份
 * {@code ViewTreeLifecycleOwner} 就在它的 classloader 里。
 * ⇒ 本类用**宿主 loader** 拿到那个类，再反射调 {@code set(view, owner)}
 *    把当前 Activity 挂成 lifecycle owner。
 *
 * <h3>失败策略：三层兜底，绝不"为了好看"把保底搞坏</h3>
 * <pre>
 *   ① Compose 版（本类）
 *   ② 任何一步失败（类找不到 / 版本不匹配 / NoSuchMethod / IllegalState）⇒ View 版
 *   ③ View 版也失败 ⇒ Toast
 * </pre>
 */
public final class FdmComposeDialog {

    private static final String CV = "androidx.compose.ui.platform.ComposeView";
    private static final String VTL = "androidx.lifecycle.ViewTreeLifecycleOwner";
    private static final String WR_KT = "androidx.compose.ui.platform.WindowRecomposer_androidKt";
    private static final String FALLBACK_HOST = "com.nidyaber.fuckdsmanger.FallbackHost";

    /** {@code WindowRecomposer_androidKt} 的 Class（Kotlin 顶层函数都长在它身上）。 */
    private static Class<?> wrKt(ClassLoader modCl) throws ClassNotFoundException {
        return Class.forName(WR_KT, false, modCl);
    }

    private FdmComposeDialog() {
    }

    /**
     * 试着弹 Compose 版保底。
     *
     * @return true ＝ Compose 版已经弹出来了；false ＝ 调用方应当退回 View 版
     */
    public static boolean tryShow(final Context ctx, final String reason,
                                  final Runnable onLaunch, final Runnable onHost) {
        return show(ctx, reason, onLaunch, onHost, null, false);
    }

    /**
     * 「整页」探针：把一个**全屏**的 Compose 页面塞进宿主 Activity。
     *
     * <p>它走的是和保底弹窗**完全相同**的挂载路径（三件套 owner + 手工 recomposer），
     * 唯一区别是：① 窗口给到全屏；② 内容换成带 IME / LazyColumn / 状态的完整页面。
     * <p>⇒ 它能跑通，就说明「整个 Compose 页面进宿主」这条路可行。
     *
     * @return true ＝ 已经显示
     */
    public static boolean tryShowPage(final Context ctx) {
        return show(ctx, "页面探针", null, null, PROBE_HOST, true);
    }

    /** UI dex 里那个「整页探针」的内容宿主（fdm-app/src/HostPageProbe.kt）。 */
    private static final String PROBE_HOST = "com.nidyaber.fuckdsmanger.HostPageProbe";

    private static boolean show(final Context ctx, final String reason,
                                final Runnable onLaunch, final Runnable onHost,
                                final String hostClass, final boolean fullScreen) {
        try {
            final Activity act = asActivity(ctx);
            if (act == null) {
                log("拿不到 Activity ⇒ 不用 Compose 版");
                return false;
            }

            // ① 先用**模块 loader** 拿 ComposeView（我们自己的 Compose 版本一致）
            ClassLoader modCl = FdmComposeDialog.class.getClassLoader();
            Class<?> cvCls = Class.forName(CV, false, modCl);
            Object cv = cvCls.getConstructor(Context.class).newInstance(act);

            // ② owner + recomposer：**必须都在模块 loader 里造**（见下）
            //
            //   血证（2026-11-07 · 宿主连崩 4 次）：
            //     `IllegalStateException: ViewTreeLifecycleOwner not found from ComposeView`
            //     抛在 `AbstractComposeView.attachedToWindow → ViewRootImpl.performTraversals`
            //     —— **下一帧**才炸，我们的 try/catch 根本抓不到，宿主直接死。
            //
            //   根因两层：
            //     ① 宿主 Activity 实现的 `LifecycleOwner` 是**宿主 loader** 的那份 Class，
            //        而 `ViewTreeLifecycleOwner.set(view, owner)` 的形参是**模块 loader**
            //        的那份 ⇒ `IllegalArgumentException：argument 2 has type ... got MainActivity`，
            //        也就是说**永远挂不上**；
            //     ② 挂不上以后，ComposeView 在 attach 时才去现找 owner
            //        （`createLifecycleAwareWindowRecomposer` 里的 requireNotNull）
            //        ⇒ 抛在 traversal 里，无处可接。
            //
            //   修法：**别借宿主的对象**。
            //     · `FallbackLifecycle`（fdm-app 编的 object）本身就是模块 loader 的
            //       LifecycleOwner ⇒ 类型天然兼容，挂得上；
            //     · 再按系统原样**提前**把 recomposer 建好并挂到 View 上
            //       （`createLifecycleAwareWindowRecomposer` + `setCompositionContext`），
            //       attach 时就命中缓存，不会再走那条会抛异常的路径。
            //     · 最后**验证**：`getCompositionContext(cv)` 拿不到就**不许 show**
            //       —— 这是唯一能在"炸在下一帧"之前把错误挡住的检查。
            Class<?> vtl = Class.forName(VTL, false, modCl);
            Class<?> lo = Class.forName("androidx.lifecycle.LifecycleOwner", false, modCl);
            Class<?> lcCls = Class.forName("androidx.lifecycle.Lifecycle", false, modCl);

            Class<?> flCls = Class.forName("com.nidyaber.fuckdsmanger.FallbackLifecycle", true, modCl);
            Object owner = flCls.getField("INSTANCE").get(null);
            // ★ 先问 ready：attach/restore 任一步失败就别 show —— 否则必崩在下一帧
            Object ready = flCls.getMethod("isReady").invoke(null);
            if (!Boolean.TRUE.equals(ready)) {
                log("FallbackLifecycle 未就绪（attach/restore 失败）⇒ 不敢 show，退回 View 版");
                return false;
            }
            Object life = flCls.getMethod("life").invoke(null);
            if (owner == null || life == null || !lo.isInstance(owner) || !lcCls.isInstance(life)) {
                log("FallbackLifecycle 形状不符 ⇒ 不用 Compose 版");
                return false;
            }
            vtl.getMethod("set", View.class, lo).invoke(null, cv, owner);
            log("已把 FallbackLifecycle 挂成 ViewTreeLifecycleOwner（模块 loader，类型兼容）");

            // ②b 另外两个 owner —— **同样是必需的**，缺一个就炸在下一帧。
            //   3.99.6 真机血证：
            //     IllegalStateException: Composed into the View which doesn't
            //     propagate ViewTreeSavedStateRegistryOwner!
            //   反编译 `AbstractComposeView.resolveComposeViewContext` 看到它逐个 require：
            //     ViewTreeLifecycleOwner        → "...doesn't propagate ViewTreeLifecycleOwner!"
            //     ViewTreeSavedStateRegistryOwner→ "...doesn't propagate ViewTreeSavedStateRegistryOwner!"
            //     ViewTreeViewModelStoreOwner   → （前两个先炸，这个还没轮到）
            try {
                Class<?> ssrCls = Class.forName("androidx.savedstate.SavedStateRegistryOwner", false, modCl);
                Class<?> ssrKt = Class.forName("androidx.savedstate.ViewTreeSavedStateRegistryOwner", false, modCl);
                if (ssrCls.isInstance(owner)) {
                    ssrKt.getMethod("set", View.class, ssrCls).invoke(null, cv, owner);
                    log("已挂 ViewTreeSavedStateRegistryOwner");
                } else {
                    log("FallbackLifecycle 没实现 SavedStateRegistryOwner ⇒ 不用 Compose 版");
                    return false;
                }
            } catch (Throwable t) {
                log("挂 SavedStateRegistryOwner 失败 ⇒ 不用 Compose 版：" + t);
                return false;
            }

            try {
                Class<?> vmsCls = Class.forName("androidx.lifecycle.ViewModelStoreOwner", false, modCl);
                Class<?> vmsKt = Class.forName("androidx.lifecycle.ViewTreeViewModelStoreOwner", false, modCl);
                if (vmsCls.isInstance(owner)) {
                    vmsKt.getMethod("set", View.class, vmsCls).invoke(null, cv, owner);
                    log("已挂 ViewTreeViewModelStoreOwner");
                } else {
                    log("FallbackLifecycle 没实现 ViewModelStoreOwner ⇒ 不用 Compose 版");
                    return false;
                }
            } catch (Throwable t) {
                log("挂 ViewModelStoreOwner 失败 ⇒ 不用 Compose 版：" + t);
                return false;
            }

            // recomposer：照 WindowRecomposerPolicy 的做法手工装一遍
            Object emptyCtx = Class.forName("kotlin.coroutines.EmptyCoroutineContext", true, modCl)
                    .getField("INSTANCE").get(null);
            Class<?> ccCls = Class.forName("kotlin.coroutines.CoroutineContext", false, modCl);
            Method make = wrKt(modCl).getMethod("createLifecycleAwareWindowRecomposer",
                    View.class, ccCls, lcCls);
            Object recomposer = make.invoke(null, cv, emptyCtx, life);
            if (recomposer == null) {
                log("recomposer 建不出来 ⇒ 不用 Compose 版");
                return false;
            }
            Class<?> compCtx = Class.forName("androidx.compose.runtime.CompositionContext", false, modCl);
            wrKt(modCl).getMethod("setCompositionContext", View.class, compCtx)
                    .invoke(null, cv, recomposer);

            // ★★ 硬验证：这一步过了才允许 show —— 否则 attach 时必炸在下一帧
            Object got = wrKt(modCl).getMethod("getCompositionContext", View.class).invoke(null, cv);
            if (got == null) {
                log("✗ setCompositionContext 之后再取还是 null ⇒ 不敢 show（show 就会崩宿主）");
                return false;
            }
            log("recomposer 已挂上 View（attach 时会命中缓存，不再现找 owner）");

            // ③ 让 UI dex 里的 @Composable 接手填内容
            if (hostClass != null) {
                // 「整页」探针：只调 install(View) 一个参数
                Class<?> host = Class.forName(hostClass, true, modCl);
                host.getMethod("install", View.class).invoke(null, cv);
            } else {
                Class<?> host = Class.forName(FALLBACK_HOST, true, modCl);
                host.getMethod("install", View.class, String.class, Runnable.class, Runnable.class)
                        .invoke(null, cv, reason, onLaunch, onHost);
            }

            final Dialog d;
            if (fullScreen) {
                // 全屏：用没有标题栏、铺满的主题；窗口尺寸交给系统
                d = new Dialog(act, android.R.style.Theme_DeviceDefault_NoActionBar);
            } else {
                d = new Dialog(act, android.R.style.Theme_DeviceDefault_Dialog_NoActionBar);
            }
            d.requestWindowFeature(Window.FEATURE_NO_TITLE);
            d.setContentView((View) cv);
            Window w = d.getWindow();
            if (w != null) {
                w.setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0x00000000));
                if (fullScreen) {
                    // 铺满可用区域（Dialog 默认会留边距）
                    w.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,
                            ViewGroup.LayoutParams.MATCH_PARENT);
                }
            }
            d.setCanceledOnTouchOutside(!fullScreen);
            d.show();
            FdmFallbackDialog.markShowing(d);
            log(fullScreen ? "✅ Compose 整页已塞进宿主（探针）" : "✅ Compose 版保底弹窗已显示");
            return true;
        } catch (Throwable t) {
            // 任何一步都可能失败：NoClassDefFoundError / NoSuchMethodError /
            // IllegalStateException(ViewTreeLifecycleOwner) / 版本不匹配…
            // ⇒ 一律退回 View 版，**不许抛给调用方**。
            log("✗ Compose 版不可用，退回 View 版：" + t);
            try {
                android.util.Log.w("FDM-ComposeDlg", "fallback to view", t);
            } catch (Throwable ignore) {
            }
            return false;
        }
    }

    // ------------------------------------------------------------------ 内部

    private static Activity asActivity(Context c) {
        // ① 顺着 ContextWrapper 链找（Activity 自己 / 它的 base 是 ContextImpl）
        while (c instanceof ContextWrapper) {
            if (c instanceof Activity) return (Activity) c;
            c = ((ContextWrapper) c).getBaseContext();
        }
        if (c instanceof Activity) return (Activity) c;
        // ② ★ 2026-11-07：ContextWrapper 链走不通时（receiver / Application 给的都是
        //    ContextImpl，里层没有 Activity）⇒ 去 ActivityThread 里捞**当前 Activity**。
        //    血证：`【FdmComposeDlg】拿不到 Activity ⇒ 不用 Compose 版`
        //    —— 明明屏幕上就有 Activity，只是我们手里那个 Context 指不到它。
        return FdmHostActivity.current();
    }

    private static void log(String msg) {
        try {
            GmUtil.log("【FdmComposeDlg】" + msg);
        } catch (Throwable ignore) {
        }
        try {
            de.robv.android.xposed.XposedBridge.log("[FDM] 【FdmComposeDlg】" + msg);
        } catch (Throwable ignore) {
        }
    }
}
