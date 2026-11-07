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
    private static final String FALLBACK_HOST = "com.nidyaber.fuckdsmanger.FallbackHost";

    private FdmComposeDialog() {
    }

    /**
     * 试着弹 Compose 版保底。
     *
     * @return true ＝ Compose 版已经弹出来了；false ＝ 调用方应当退回 View 版
     */
    public static boolean tryShow(final Context ctx, final String reason,
                                  final Runnable onLaunch, final Runnable onHost) {
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

            // ② 拿 ViewTreeLifecycleOwner —— ⚠️ 必须和 ComposeView **同一个 loader**
            //
            //   坑（2026-11-07 血证）：
            //     `ClassNotFoundException: androidx.lifecycle.ViewTreeLifecycleOwner`
            //   我用 `act.getClassLoader()`（宿主 loader）去找 —— 找不到。
            //   因为 R8 对宿主做了 **class merging**（把 androidx 的辅助类内联进
            //   别的类），所以这个类**在宿主里根本不存在**，只能在**我们模块的
            //   loader**（LspModuleClassLoader，里面有完整 Compose + lifecycle）里找到。
            //   ⇒ 关键点：ComposeView 是我们 loader 里的那份，它内部找
            //     ViewTreeLifecycleOwner 也走同一个 loader ⇒ 必须用 modCl。
            Class<?> vtl = Class.forName(VTL, false, modCl);
            Class<?> lo = Class.forName("androidx.lifecycle.LifecycleOwner", false, modCl);
            vtl.getMethod("set", View.class, lo).invoke(null, cv, act);
            log("已把 Activity 挂成 ViewTreeLifecycleOwner（模块 loader）");

            // ③ 让 UI dex 里的 @Composable 接手填内容
            Class<?> host = Class.forName(FALLBACK_HOST, true, modCl);
            host.getMethod("install", View.class, String.class, Runnable.class, Runnable.class)
                    .invoke(null, cv, reason, onLaunch, onHost);

            final Dialog d = new Dialog(act,
                    android.R.style.Theme_DeviceDefault_Dialog_NoActionBar);
            d.requestWindowFeature(Window.FEATURE_NO_TITLE);
            d.setContentView((View) cv);
            Window w = d.getWindow();
            if (w != null) {
                w.setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0x00000000));
            }
            d.setCanceledOnTouchOutside(true);
            d.show();
            FdmFallbackDialog.markShowing(d);
            log("✅ Compose 版保底弹窗已显示");
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
