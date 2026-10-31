// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

import android.graphics.Bitmap;
import android.graphics.Canvas;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

/**
 * 液态玻璃 · **对外桥**🐲 2026-10-25
 *
 * <h3>为什么要有这个类</h3>
 * {@link GmGlassGpu} / {@link GmGlassBlur} 都是 **package-private** ——
 * 它们只为宿主按钮服务，从 {@code bridge} 包（比如迷你播放卡）够不到。
 *
 * <p>所以这里开一个**只有一个方法**的 public 口子：
 * 一块「<b>纯装饰</b>的液态玻璃」——不掺 {@link GmGlassCfg} 的开关和配色，
 * 参数全由调用方给。零副作用，不改任何全局状态。
 *
 * <h3>它在哪用</h3>
 * {@code bridge/GmMiniBarView}（悬浮迷你播放卡）。
 * 主人 2026-10-25：「毛玻璃还是丑不拉几的，试试看改成液态玻璃？」
 *
 * <h3>两条硬约束（沿自 {@link GmGlassGpu}）</h3>
 * <ul>
 *   <li><b>必须硬件画布</b> —— {@code Canvas.drawRenderNode} 在软件画布上直接抛
 *       「Software rendering doesn't support drawRenderNode」。所以：
 *       <b>自拍永远看不到效果</b>（自拍是软件画布），只有真实屏幕有。</li>
 *   <li><b>API 33+</b>（{@code createRuntimeShaderEffect}）。低了就返回 false，
 *       调用方自己退回普通底色。</li>
 * </ul>
 */
public final class GmGlassPanel {

    private GmGlassPanel() {
    }

    /** 引擎：0 = HAZE（Haze 2.0 那套折射）/ 1 = CLOUDY / 2 = RIPPLE。 */
    public static final int ENGINE_HAZE = 0;
    public static final int ENGINE_CLOUDY = 1;
    public static final int ENGINE_RIPPLE = 2;

    /** 能不能走 GPU 管线（调用方拿它决定要不要准备"重"的东西）。 */
    public static boolean available() {
        return GmGlassGpu.available();
    }

    /**
     * 在画布上画一块液态玻璃。
     *
     * <p>调用方约定：{@code c} 已经处在**该元素自己的局部坐标系**里（原点 = 元素左上角），
     * 且元素已被裁成圆角（或者由 shader 自己按圆角画）。
     *
     * @param c          目标画布（**必须硬件加速**）
     * @param back       底图（这块元素"身下"的内容）。{@code stretch=true} 时直接拉伸铺满，
     *                   所以尺寸不必和元素一致 —— 给一张「元素区域的小图」就行。
     * @param w,h        元素宽高（px）
     * @param radius     圆角（px）
     * @param blurPx     模糊半径（px）。注意这是**真实像素**，一般 = dp 值 × density × 0.5
     * @param tintArgb   染色（ARGB；alpha = 浓度，0 = 全透只剩折射，255 = 全不透）
     * @param dispersion 色散强度（0~6，越大边缘彩虹越明显）。Haze 默认 1.2
     * @param engine     引擎（见 {@link #ENGINE_HAZE} 等）
     * @param fadeAmt    边缘淡出强度 0~1
     * @param fadePx     边缘淡出宽度（px）
     * @return 是否真的画了（false ⇒ 调用方自己画底色兜底）
     */
    public static boolean draw(Canvas c, Bitmap back,
                               float w, float h, float radius,
                               float blurPx, int tintArgb, float dispersion,
                               int engine, float fadeAmt, float fadePx) {
        return drawAt(c, back, 0, 0, w, h, radius, blurPx, tintArgb,
                dispersion, engine, fadeAmt, fadePx);
    }

    /**
     * 画一块液态玻璃 —— **按窗口坐标从底图裁切**（推荐用这个）。
     *
     * <p>为什么推荐这个：底图是「整窗 1/{@link GmGlassBackdrop#SCALE} 缩略图」，
     * 画的时候只按 {@code (ox,oy,w,h)} 去裁那一小块采样。
     * ⇒ <b>元素移动/缩放时只要传新的 ox/oy，背景就自动跟着变</b>，
     * <b>完全不用重新抓图 ⇒ 零闪烁</b>。
     *
     * <p>（对照：{@code stretch=true} 的版本是把底图拉伸铺满元素，元素一动内容就错位。）
     *
     * @param ox,oy 元素左上角在**窗口**里的位置（px），不是屏幕、不是父容器
     */
    public static boolean drawAt(Canvas c, Bitmap back, int ox, int oy,
                                 float w, float h, float radius,
                                 float blurPx, int tintArgb, float dispersion,
                                 int engine, float fadeAmt, float fadePx) {
        if (c == null || back == null || back.isRecycled()) return false;
        if (w < 2f || h < 2f) return false;
        try {
            // 外扩留白：折射要采元素**外面**的像素，否则边缘只是硬切
            float pad = Math.max(2f, Math.min(20f, Math.min(w, h) * 0.18f));
            return GmGlassGpu.draw(c, back, ox, oy, w, h, radius, pad,
                    Math.max(0.5f, blurPx), 255,
                    dispersion, tintArgb, engine,
                    false, 0f,                 /* clean=false：别擦内容（那是给按钮用的） */
                    false,                     /* stretch=false：★ 按窗口坐标裁切 ⇒ 移动免重抓 */
                    fadeAmt, fadePx);
        } catch (Throwable t) {
            GmUtil.logOnce("minibar.glass.err", "【GmMiniBar】液态玻璃绘制失败（退回底色）：" + t);
            return false;
        }
    }

    /** 底图降采样倍数（= {@link GmGlassBackdrop#SCALE}，两处必须一致）。 */
    public static int backdropScale() {
        return GmGlassBackdrop.SCALE;
    }

    /**
     * CPU 兜底模糊（GPU 不可用时用）。
     *
     * <p>复用 {@link GmGlassBlur}，它本来就是「缩略图 + 三趟盒式」。
     *
     * @return 模糊后的**新**位图（调用方负责 recycle），失败返回 null
     */
    public static Bitmap blurCpu(Bitmap src, int radius) {
        if (src == null || src.isRecycled()) return null;
        try {
            Bitmap copy = src.copy(Bitmap.Config.ARGB_8888, true);
            if (copy == null) return null;
            GmGlassBlur.blur(copy, Math.max(1, radius));
            return copy;
        } catch (Throwable t) {
            return null;
        }
    }
}
