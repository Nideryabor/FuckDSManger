// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

import android.app.Activity;
import android.graphics.Bitmap;
import android.view.PixelCopy;
import android.view.View;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

/**
 * 液态玻璃 · 底图（被折射/模糊的那一层）🐲
 *
 * <h3>踩过的两条路</h3>
 * <ol>
 *   <li><b>{@code PixelCopy.request(Window, …)}</b> —— 真机直接抛
 *       {@code IllegalArgumentException: Window doesn't have a backing surface!}
 *       ⇒ 底图永远 null ⇒「模糊度」怎么调都没区别（主人真机反馈）。
 *       而且 {@code PixelCopy} 根本没有 {@code View} 重载，只有 Window / SurfaceView / Surface。</li>
 *   <li><b>把视图树重画进一张位图</b>（就是参照物 {@code LiquidGlassPanel} 的做法）——
 *       现在是这条。<b>不需要 surface</b>，纯 CPU。</li>
 * </ol>
 *
 * <h3>防自反馈</h3>
 * 重画时会把「我们自己画的玻璃」也画进去 ⇒ 越糊越黑的正反馈。
 * 所以抓图期间置 {@link #capturing()} = true，{@link GmGlassSink} 看到就**跳过玻璃绘制**
 * ⇒ 抄到的永远是「没有玻璃的原始画面」，这才是正确的底图。
 *
 * <p>三条纪律不变：<b>降采样</b>（1/{@value SCALE}）· <b>限流</b>（{@value MIN_GAP_MS} ms）· <b>失败就退</b>。
 */
public final class GmGlassBackdrop {

    private GmGlassBackdrop() {
    }

    /** 两张底图之间的最小间隔。 */
    private static final long MIN_GAP_MS = 260;
    /** 降采样倍数（底图 = 窗口的 1/{@value SCALE}）。 */
    public static final int SCALE = 4;

    private static volatile Bitmap sBack;
    private static volatile long sAt = 0;
    private static volatile boolean sBusy = false;
    /** 正在抓图（抓图期间不许画玻璃，否则自反馈）。 */
    private static volatile boolean sCapturing = false;
    private static volatile boolean sErrLogged = false;

    private static Activity sAct;

    /** 抓图进行中？—— 玻璃绘制必须让路。 */
    public static boolean capturing() {
        return sCapturing;
    }

    /** 当前可用的底图（可能是 null —— 调用方必须能忍）。 */
    /** 窗口尺寸（拿不到返回 0）—— 给「背景图」底图对位用。 */
    public static int winW() {
        try {
            View d = sAct == null || sAct.getWindow() == null
                    ? null : sAct.getWindow().getDecorView();
            return d == null ? 0 : d.getWidth();
        } catch (Throwable t) {
            return 0;
        }
    }

    public static int winH() {
        try {
            View d = sAct == null || sAct.getWindow() == null
                    ? null : sAct.getWindow().getDecorView();
            return d == null ? 0 : d.getHeight();
        } catch (Throwable t) {
            return 0;
        }
    }

    public static Bitmap get() {
        if (!GmGlassCfg.on()) return null;
        Bitmap b = sBack;
        return (b == null || b.isRecycled()) ? null : b;
    }

    public static void bind(Activity a) {
        if (a == null) return;
        if (sAct != a) sAt = 0;
        sAct = a;
    }

    /** 出口诊断：每个理由打**前 3 次**（logOnce 会去重到只剩一条，看不到"后来好了没"）。 */
    private static final java.util.HashMap<String, Integer> sRCount = new java.util.HashMap<String, Integer>();

    private static void rwhy(String k, String msg) {
        synchronized (sRCount) {
            Integer n = sRCount.get(k);
            int c = n == null ? 0 : n;
            if (c >= 3) return;
            sRCount.put(k, c + 1);
        }
        GmUtil.log("【GmGlass】底图没抓(" + (k) + ")：" + msg);
    }

    /** 需要的话重抓一张（异步、限流、重入保护）。 */
    public static void request() {
        requestInternal(false);
    }

    /**
     * 强制抓一张（**绕过限流**）。
     *
     * <p>给"自拍"用的：自拍只画一瞬间，而**界面静止时 Compose 根本不重绘**
     * ⇒ 正常限流路径永远排不上队（真机实测就是这个死结）。
     */
    public static void requestForce() {
        requestInternal(true);
    }

    /** 看门狗：卡住超过这个时间就强制解卡。 */
    private static final long STUCK_MS = 2500;
    private static volatile long sBusyAt = 0L;

    private static void requestInternal(boolean force) {
        final Activity a = sAct;
        if (a == null) { rwhy("noact", "没有 Activity（宿主没 resume 过？）"); return; }
        if (!GmGlassCfg.on()) { rwhy("off", "玻璃开关是关的"); return; }

        // ★ 看门狗（2026-09-30 真机踩的）：
        //   PixelCopy 的回调**有可能不回来**，而我们把 sBusy=false 写在回调里
        //   ⇒ 一旦不回来就**永久卡住**，之后所有底图请求全被拒 ⇒ 没底图 ⇒ GPU 管线永远不走。
        //   真机日志：`底图没抓(busy)：上一张还在抓（sBusy 卡住了？）`
        long nowMs = System.currentTimeMillis();
        if (sBusy && sBusyAt > 0 && nowMs - sBusyAt > STUCK_MS) {
            rwhy("unstuck", "sBusy 卡了 " + (nowMs - sBusyAt) + "ms，强制解卡");
            sBusy = false;
            sCapturing = false;
        }
        if (sBusy) { rwhy("busy", "上一张还在抓"); return; }
        if (sCapturing) { rwhy("capturing", "正在抓图"); return; }

        View decor;
        try {
            decor = a.getWindow() == null ? null : a.getWindow().getDecorView();
        } catch (Throwable ignore) {
            decor = null;
        }
        if (decor == null) { rwhy("nodecor", "拿不到 decorView"); return; }
        if (decor.getWidth() <= 0 || decor.getHeight() <= 0) {
            // ⚠️ 这里**不能**更新 sAt —— 否则"尺寸还没好"会把后面 260ms 的窗口一起吃掉，
            //    而界面静止时根本没有"后面的窗口"（真机踩过：永远排不上队）
            rwhy("zero", "decor 尺寸 " + decor.getWidth() + "x" + decor.getHeight());
            return;
        }

        long now = System.currentTimeMillis();
        if (!force && now - sAt < MIN_GAP_MS) { rwhy("gap", "距上次不到 " + MIN_GAP_MS + "ms"); return; }
        sAt = now;
        sBusy = true;
        sBusyAt = nowMs;

        final View d = decor;
        // ★ 必须 post 出去：不能在 Compose 的绘制回调里**同步**重画一遍视图树
        //   （重入 + 可能死循环）。post 到下一帧之外执行。
        boolean queued = d.post(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!sRunLogged) {
                        sRunLogged = true;
                        GmUtil.log("【GmGlass】抓图任务开始执行");
                    }
                    capture(sAct, d);
                } catch (Throwable t) {
                    if (!sErrLogged) {
                        sErrLogged = true;
                        GmUtil.log("【GmGlass】底图截取失败（将退化为不折射）：" + t);
                    }
                    sBusy = false;
                    sCapturing = false;
                }
            }
        });
        if (!queued && !sQueueLogged) {
            sQueueLogged = true;
            GmUtil.log("【GmGlass】抓图任务排队失败（post 返回 false）");
        }
    }

    private static volatile boolean sRunLogged = false;
    private static volatile boolean sQueueLogged = false;
    private static volatile boolean sStepLogged = false;
    private static volatile boolean sStep2Logged = false;
    private static volatile boolean sStep3Logged = false;

    /**
     * 抓一张底图。
     *
     * <h3>为什么不用「重画视图树」（参照物那招）</h3>
     * 参照物是 <b>View 宿主</b>（微信 tab 栏），重画兄弟 View 没问题。
     * 我们宿主是 <b>Compose</b>：真机实测 {@code decor.draw(softwareCanvas)} **直接卡死不返回**
     * （日志停在「抓图①开始重画视图树」，② 永远等不到）。
     * ⇒ 改用 {@link PixelCopy}：**异步、不重画**，只在目标表面就绪时抄一份像素。
     *
     * <p>代价：抓到的画面**含上一帧的玻璃**（正反馈）。因为玻璃本身大半是透出底图的，
     * 所以会收敛到一个稳定态，不会无限糊下去 —— 可以接受。
     */
    private static void capture(Activity act, View decor) {
        int dw = decor.getWidth(), dh = decor.getHeight();
        final int w = Math.max(1, dw / SCALE), h = Math.max(1, dh / SCALE);
        final Bitmap bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        if (!sStepLogged) {
            sStepLogged = true;
            GmUtil.log("【GmGlass】抓图开始（PixelCopy）" + w + "x" + h);
        }

        sCapturing = true;
        try {
            PixelCopy.request(act.getWindow(), bmp, new PixelCopy.OnPixelCopyFinishedListener() {
                @Override
                public void onPixelCopyFinished(int result) {
                    try {
                        sCapturing = false;
                        if (result != PixelCopy.SUCCESS) {
                            if (!bmp.isRecycled()) bmp.recycle();
                            if (!sErrLogged) {
                                sErrLogged = true;
                                GmUtil.log("【GmGlass】PixelCopy 失败 result=" + result
                                        + "（将退化为不折射）");
                            }
                            return;
                        }
                        // ★ 走 GPU 管线就**不糊** —— 交给 RenderEffect 在画的时候糊，
                        //   底图保持清晰（糊两次会糊成一坨）
                        //   但**强制 CPU** 时必须在这儿糊好（CPU 版没法在绘制时做 GPU 模糊）
                        if (GmGlassCfg.needCpuBlur()) {
                            GmGlassBlur.blur(bmp, Math.max(1, GmGlassCfg.get().blur / SCALE));
                        }
                        Bitmap old = sBack;
                        sBack = bmp;
                        if (old != null && old != bmp && !old.isRecycled()) old.recycle();
                        if (!sOkLogged) {
                            sOkLogged = true;
                            GmUtil.log("【GmGlass】底图 OK " + w + "x" + h
                                    + " · 模糊半径=" + Math.max(1, GmGlassCfg.get().blur / SCALE));
                        }
                    } catch (Throwable t) {
                        if (!sErrLogged) {
                            sErrLogged = true;
                            GmUtil.log("【GmGlass】底图处理失败：" + t);
                        }
                    } finally {
                        sBusy = false;
                    }
                }
            }, new android.os.Handler(android.os.Looper.getMainLooper()));
        } catch (Throwable t) {
            sCapturing = false;
            sBusy = false;
            if (!sErrLogged) {
                sErrLogged = true;
                GmUtil.log("【GmGlass】PixelCopy 请求失败（将退化为不折射）：" + t);
            }
        }
    }

    private static volatile boolean sOkLogged = false;

    public static void drop() {
        Bitmap b = sBack;
        sBack = null;
        if (b != null && !b.isRecycled()) {
            try {
                b.recycle();
            } catch (Throwable ignore) {
            }
        }
    }
}
