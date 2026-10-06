// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 液态玻璃 · 安装器 🐲
 *
 * <p>三件事：
 * <ol>
 *   <li><b>钩按钮作用域</b>（{@link GmGlassScope}）；</li>
 *   <li><b>钩画底原语</b>（{@link GmGlassSink}）；</li>
 *   <li><b>盯 Activity 生命周期</b>：resume 时把当前 Activity / ComposeView 位置记下来，
 *       并催一张底图。底图是给「折射」用的，没有它玻璃只是半透明 —— 但绝不会崩。</li>
 * </ol>
 *
 * <p>落点全是<b>框架类</b>（{@code android.app.Activity} / {@code android.view.ViewGroup}），
 * 名字永远不会变 ⇒ 不依赖宿主包名、也不依赖宿主类名（铁律见
 * {@code 专题/铁律-不依赖宿主包名.md}）。
 */
public final class GmGlassInstall {

    private GmGlassInstall() {
    }

    private static volatile boolean sInstalled = false;
    private static volatile Activity sAct;

    public static Activity act() {
        return sAct;
    }

    /** 装。可以在宿主每次启动时调，重复调是安全的。 */
    public static void install(final ClassLoader cl) {
        if (sInstalled) return;
        sInstalled = true;
        try {
            int btns = GmGlassScope.install(cl);
            GmGlassSink.install(cl);
            hookResume(cl);
            hookTouch(cl);
            GmUtil.log("【GmGlass】安装完成：按钮锚 " + btns + " 条 · 画底原语已挂");
        } catch (Throwable t) {
            GmUtil.logFail("【GmGlass】安装失败", t);
        }
    }

    /** resume = 换页/回前台 ⇒ 重新读配置 + 绑 Activity + 催底图。 */
    private static void hookResume(final ClassLoader cl) {
        try {
            XposedHelpers.findAndHookMethod("android.app.Activity", cl, "onResume",
                    new XC_MethodHook() {
                        @Override
                        protected void afterHookedMethod(MethodHookParam param) {
                            try {
                                Object o = param.thisObject;
                                if (!(o instanceof Activity)) return;
                                Activity a = (Activity) o;
                                sAct = a;
                                GmGlassBackdrop.bind(a);
                                GmGlassCfg.reload(a);
                                GmGlassAtoms.setRootOffset(0, 0);
                                if (GmGlassCfg.on()) {
                                    GmGlassBackdrop.request();
                                }
                                GmUtil.log("【GmGlass】onResume 已绑定："
                                        + a.getClass().getName() + " · " + GmGlassCfg.get()
                                        + " · " + GmGlassSink.stats());
                            } catch (Throwable ignore) {
                            }
                        }
                    });
        } catch (Throwable t) {
            GmUtil.logFail("【GmGlass】onResume 钩子挂载失败", t);
        }
    }

    // ───────────── Q 弹：触摸 → 弹簧 → 逐帧重绘 ─────────────

    private static volatile boolean sAnimating = false;

    /**
     * 钩 {@code Activity.dispatchTouchEvent}（框架类，名字永不变）。
     *
     * <p>按下 ⇒ 弹簧收缩；松手 ⇒ 弹回并过冲。同时**主动逐帧请求重绘** ——
     * 不然 Compose 不知道我们的弹簧在动，画面就卡在第一帧（"不 Q 弹"的另一半原因）。
     */
    private static void hookTouch(final ClassLoader cl) {
        try {
            XposedHelpers.findAndHookMethod("android.app.Activity", cl, "dispatchTouchEvent",
                    android.view.MotionEvent.class, new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) {
                            try {
                                if (!GmGlassCfg.on()) return;
                                Object o = param.args.length > 0 ? param.args[0] : null;
                                if (!(o instanceof android.view.MotionEvent)) return;
                                int act = ((android.view.MotionEvent) o).getActionMasked();
                                if (act == android.view.MotionEvent.ACTION_DOWN) {
                                    GmGlassSpring.onDown();
                                    startAnim();
                                } else if (act == android.view.MotionEvent.ACTION_UP
                                        || act == android.view.MotionEvent.ACTION_CANCEL) {
                                    GmGlassSpring.onUp();
                                    startAnim();
                                }
                            } catch (Throwable ignore) {
                            }
                        }
                    });
            GmUtil.log("【GmGlass】触摸钩子已挂（Q 弹驱动）");
        } catch (Throwable t) {
            GmUtil.logFail("【GmGlass】触摸钩子挂载失败", t);
        }
    }

    /** 弹簧还在动 ⇒ 逐帧 invalidate，最多跑 1.2 秒。 */
    private static void startAnim() {
        if (sAnimating) return;
        sAnimating = true;
        final android.view.Choreographer ch = android.view.Choreographer.getInstance();
        ch.postFrameCallback(new android.view.Choreographer.FrameCallback() {
            long t0 = System.currentTimeMillis();

            @Override
            public void doFrame(long frameTimeNanos) {
                try {
                    Activity a = sAct;
                    View decor = a == null || a.getWindow() == null
                            ? null : a.getWindow().getDecorView();
                    if (decor != null) decor.postInvalidateOnAnimation();
                    if (System.currentTimeMillis() - t0 < 1200 && GmGlassSpring.moving()) {
                        ch.postFrameCallback(this);
                        return;
                    }
                } catch (Throwable ignore) {
                }
                sAnimating = false;
            }
        });
    }

    /**
     * 配置变了（UI 推了 CONFIG_PUSH / cfg_put 过来）⇒ 立刻生效。
     *
     * <p>不需要「重启宿主」：玻璃是<b>每帧现画</b>的，配置一改下一帧就是新样子。
     * 这也正好绕开了本项目历史上踩过的「模块代码在宿主启动时加载 ⇒ 不重启还是旧的」那类坑。
     */
    public static void refresh(Context ctx) {
        try {
            GmGlassCfg.S s = GmGlassCfg.reload(ctx);
            GmGlassBackdrop.drop();
            GmGlassAtoms.setRootOffset(0, 0);
            if (s.on) {
                GmGlassBackdrop.bind(sAct);
                GmGlassBackdrop.request();
            }
            GmUtil.log("【GmGlass】配置刷新 " + s);
        } catch (Throwable t) {
            GmUtil.logFail("【GmGlass】配置刷新失败", t);
        }
    }

    // ───────────── 自拍：让宿主把自己当前的画面写进自己的目录 ─────────────
    //
    //  为什么需要它：调试这一路最大的障碍是**截图截不到宿主**（前台总被别的 App 抢走），
    //  于是只能盲改。这个功能让宿主进程自己 `decor.draw()` 一张原图写进
    //  `getFilesDir()/fdm-snap.png`，外面用 root `adb pull` 就能拿到
    //  —— 绕过一切前台竞争，而且**带玻璃**。

    private static volatile boolean sSnapping = false;

    /** 触发一次自拍（post 到主线程，画完再写盘）。 */
    public static void snap() {
        // ★ 调试总闸（GmDebug.ENABLED）：正式包里这里是 false，自拍直接短路
        if (!GmDebug.ENABLED) {
            GmUtil.log("【GmGlass】自拍已关闭（正式包不带调试功能）");
            return;
        }
        final Activity a = sAct;
        if (a == null) {
            GmUtil.log("【GmGlass】自拍失败：没有 Activity");
            return;
        }
        if (sSnapping) return;
        sSnapping = true;
        try {
            final View dv = a.getWindow().getDecorView();
            // ★ 先强制抓一张底图（绕过限流），等它落地再自拍
            //   否则自拍出来的是"没有折射"的版本（真机踩过）
            GmGlassBackdrop.requestForce();
            dv.postDelayed(new Runnable() {
                @Override
                public void run() {
                    try {
                        View d = a.getWindow().getDecorView();
                        int w = d.getWidth(), h = d.getHeight();
                        if (w <= 0 || h <= 0) {
                            GmUtil.log("【GmGlass】自拍失败：尺寸 " + w + "x" + h);
                            return;
                        }
                        Bitmap b = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
                        d.draw(new Canvas(b));
                        java.io.File f = new java.io.File(a.getFilesDir(), "fdm-snap.png");
                        java.io.FileOutputStream fo = new java.io.FileOutputStream(f);
                        b.compress(Bitmap.CompressFormat.PNG, 100, fo);
                        fo.flush();
                        fo.close();
                        b.recycle();
                        GmUtil.log("【GmGlass】自拍 OK " + w + "x" + h + " → " + f.getAbsolutePath()
                                + " (" + f.length() + " B)");
                    } catch (Throwable t) {
                        GmUtil.logFail("【GmGlass】自拍失败", t);
                    } finally {
                        sSnapping = false;
                    }
                }
            }, 1200);   // ← 等底图落地（抓图是异步的）
        } catch (Throwable t) {
            sSnapping = false;
            GmUtil.logFail("【GmGlass】自拍调度失败", t);
        }
    }

    // ───────────── 绘制要用到的三个环境量 ─────────────

    /** 屏幕密度（dp → px）。拿不到就按 3 算。 */
    public static float density() {
        Activity a = sAct;
        if (a != null) {
            try {
                float d = a.getResources().getDisplayMetrics().density;
                if (d > 0.1f) return d;
            } catch (Throwable ignore) {
            }
        }
        return 3f;
    }

    /** 当前是不是深色主题（玻璃的浓度蒙层分黑白）。 */
    public static boolean isNight() {
        Activity a = sAct;
        if (a != null) {
            try {
                int m = a.getResources().getConfiguration().uiMode
                        & android.content.res.Configuration.UI_MODE_NIGHT_MASK;
                return m == android.content.res.Configuration.UI_MODE_NIGHT_YES;
            } catch (Throwable ignore) {
            }
        }
        return false;
    }

    /**
     * 这次画的底是不是「整页背景」。
     *
     * <p>整页背景<b>不该</b>上玻璃（那是墙纸，不是按钮）——
     * 这也是 3.29.1 把作用范围从「认按钮类」改成「不认类、只排整页」之后唯一的筛子。
     */
    public static boolean isFullPage(float w, float h) {
        Activity a = sAct;
        if (a == null) return false;
        try {
            View decor = a.getWindow().getDecorView();
            float dw = decor.getWidth(), dh = decor.getHeight();
            if (dw <= 0 || dh <= 0) return false;
            // 0.97：只抓「满屏根节点」。0.94 会误伤大卡片（主人反馈整页偏白就是它）
            return w >= dw * 0.97f && h >= dh * 0.97f;
        } catch (Throwable ignore) {
            return false;
        }
    }

    // ───────────── 备用：万一 DrawScope 那条路被宿主版本打断，还能量一下 ComposeView 的位置 ─────────────

    /** 找 ComposeView 在窗口里的偏移（诊断/兜底用，目前只在日志里出现）。 */
    public static int[] rootOffset() {
        Activity a = sAct;
        if (a == null) return new int[]{0, 0};
        View decor = a.getWindow() == null ? null : a.getWindow().getDecorView();
        if (!(decor instanceof ViewGroup)) return new int[]{0, 0};
        View compose = findComposeView((ViewGroup) decor);
        if (compose == null) return new int[]{0, 0};
        int[] loc = new int[2];
        compose.getLocationInWindow(loc);
        return loc;
    }

    /**
     * 按<b>结构</b>（不是名字）找 ComposeView：谁的类上有 {@code getSemanticsOwner()} 就是它。
     *
     * <p>依据：宿主 dex 里 {@code Landroidx/compose/ui/platform/AndroidComposeView;->getSemanticsOwner()}
     * <b>没被混淆</b>（Compose 的 consumer keep 规则保住了它）—— 见
     * {@code 专题/宿主按钮锚点-2.5.2.md}。
     */
    private static View findComposeView(ViewGroup g) {
        for (int i = 0; i < g.getChildCount(); i++) {
            View c = g.getChildAt(i);
            if (hasSemanticsOwner(c)) return c;
            if (c instanceof ViewGroup) {
                View r = findComposeView((ViewGroup) c);
                if (r != null) return r;
            }
        }
        return null;
    }

    private static boolean hasSemanticsOwner(View v) {
        try {
            v.getClass().getMethod("getSemanticsOwner");
            return true;
        } catch (Throwable ignore) {
            return false;
        }
    }

    /** 让 onCreate 也能早点把 Activity 记下来（有些页面 onResume 之前就要用）。 */
    public static void watchActivity(Activity a) {
        if (a == null) return;
        sAct = a;
        try {
            int[] loc = rootOffset();
            GmGlassAtoms.setRootOffset(loc[0], loc[1]);
        } catch (Throwable ignore) {
        }
    }

    static {
        // 占位：Bundle 引用（避免 import 被删）；真正的 onCreate 钩子在需要时再加
        Bundle.class.getName();
    }
}
