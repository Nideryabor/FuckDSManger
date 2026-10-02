package com.nidyaber.fuckdsmanger.glass;

import android.graphics.Bitmap;

/**
 * StackBlur —— 液态玻璃的「糊底」算法 🐲
 *
 * <p>来源：<b>逐字节照抄参照物</b> {@code 底栏液态玻璃_0.2.1}
 * （{@code io.github.liuran001.mmliquidglass.StackBlur}，见
 * {@code 专题/参照物-底栏液态玻璃-实现核实.md}）。
 *
 * <p>为什么不用 {@code RenderEffect.createBlurEffect}（API 31+）或
 * {@code BitmapRenderEffect}：
 * <ul>
 *   <li>宿主 minSdk 23，玻璃要能落到 API 26 的机器上 ⇒ 只能用纯 CPU 路径；</li>
 *   <li>RenderEffect 只能作用在 RenderNode / 硬件画布上，我们这里拿到的是
 *       {@code PixelCopy} 出来的 <b>Bitmap</b>，需要「就地糊」。</li>
 * </ul>
 *
 * <p>算法（Mario Klingemann 的 Stack Blur）：对每个通道做三次「滑动窗口盒式模糊」，
 * 水平和垂直各一趟 ⇒ 近似高斯，但只有 O(w·h)，与半径无关。
 * 与原版一致：<b>α 通道一起糊</b>（参照物也是这么写的，别自作聪明去掉）。
 */
public final class GmGlassBlur {

    private GmGlassBlur() {
    }

    /** 迭代次数（原版写死 3 次，别改）。 */
    private static final int PASSES = 3;

    /**
     * 就地模糊一张 ARGB_8888 位图。
     *
     * @param bmp    目标位图（会被就地改写）
     * @param radius 半径（像素），&lt; 1 直接返回
     */
    public static void blur(Bitmap bmp, int radius) {
        if (bmp == null) return;
        int w = bmp.getWidth();
        int h = bmp.getHeight();
        if (w <= 0 || h <= 0 || radius < 1) return;

        int[] src = new int[w * h];
        int[] dst = new int[w * h];
        try {
            bmp.getPixels(src, 0, w, 0, 0, w, h);
        } catch (Throwable t) {
            return;   // 位图被回收/不可读 ⇒ 静默放弃，绝不能连累宿主
        }

        int div = radius + radius + 1;
        int wm = w - 1;
        int hm = h - 1;

        for (int pass = 0; pass < PASSES; pass++) {
            boxBlurH(src, dst, w, h, radius, wm, div);
            boxBlurV(dst, src, w, h, radius, hm, div);
        }

        try {
            bmp.setPixels(src, 0, w, 0, 0, w, h);
        } catch (Throwable ignore) {
        }
    }

    /** 水平方向滑动窗口盒式模糊。 */
    private static void boxBlurH(int[] src, int[] dst, int w, int h,
                                 int radius, int wm, int div) {
        for (int y = 0; y < h; y++) {
            int ti = y * w;
            int li = ti;
            int ri = ti + radius;
            int fv = src[ti];
            int lv = src[ti + wm];
            int sa = 0, sr = 0, sg = 0, sb = 0;

            for (int j = 0; j < radius; j++) {
                int p = src[ti + Math.min(j, wm)];
                sa += (p >>> 24) & 0xff;
                sr += (p >> 16) & 0xff;
                sg += (p >> 8) & 0xff;
                sb += p & 0xff;
            }
            for (int j = 0; j <= radius; j++) {
                int p = src[ti + Math.min(j, wm)];
                sa += ((p >>> 24) & 0xff) - ((fv >>> 24) & 0xff);
                sr += ((p >> 16) & 0xff) - ((fv >> 16) & 0xff);
                sg += ((p >> 8) & 0xff) - ((fv >> 8) & 0xff);
                sb += (p & 0xff) - (fv & 0xff);

                dst[ti + j] = ((sa / div) << 24) | ((sr / div) << 16)
                        | ((sg / div) << 8) | (sb / div);
            }
            for (int j = radius + 1; j < w - radius; j++) {
                int add = src[ri];
                int sub = src[li];
                sa += ((add >>> 24) & 0xff) - ((sub >>> 24) & 0xff);
                sr += ((add >> 16) & 0xff) - ((sub >> 16) & 0xff);
                sg += ((add >> 8) & 0xff) - ((sub >> 8) & 0xff);
                sb += (add & 0xff) - (sub & 0xff);

                dst[ti + j] = ((sa / div) << 24) | ((sr / div) << 16)
                        | ((sg / div) << 8) | (sb / div);
                ri++;
                li++;
            }
            for (int j = w - radius; j < w; j++) {
                sa += ((lv >>> 24) & 0xff) - ((src[li] >>> 24) & 0xff);
                sr += ((lv >> 16) & 0xff) - ((src[li] >> 16) & 0xff);
                sg += ((lv >> 8) & 0xff) - ((src[li] >> 8) & 0xff);
                sb += (lv & 0xff) - (src[li] & 0xff);

                dst[ti + j] = ((sa / div) << 24) | ((sr / div) << 16)
                        | ((sg / div) << 8) | (sb / div);
                li++;
            }
        }
    }

    /** 垂直方向滑动窗口盒式模糊。 */
    private static void boxBlurV(int[] src, int[] dst, int w, int h,
                                 int radius, int hm, int div) {
        for (int x = 0; x < w; x++) {
            int ti = x;
            int li = ti;
            int ri = ti + radius * w;
            int fv = src[ti];
            int lv = src[ti + hm * w];
            int sa = 0, sr = 0, sg = 0, sb = 0;

            for (int j = 0; j < radius; j++) {
                int p = src[ti + Math.min(j, hm) * w];
                sa += (p >>> 24) & 0xff;
                sr += (p >> 16) & 0xff;
                sg += (p >> 8) & 0xff;
                sb += p & 0xff;
            }
            for (int j = 0; j <= radius; j++) {
                int p = src[ti + Math.min(j, hm) * w];
                sa += ((p >>> 24) & 0xff) - ((fv >>> 24) & 0xff);
                sr += ((p >> 16) & 0xff) - ((fv >> 16) & 0xff);
                sg += ((p >> 8) & 0xff) - ((fv >> 8) & 0xff);
                sb += (p & 0xff) - (fv & 0xff);

                dst[ti + j * w] = ((sa / div) << 24) | ((sr / div) << 16)
                        | ((sg / div) << 8) | (sb / div);
            }
            for (int j = radius + 1; j < h - radius; j++) {
                int add = src[ri];
                int sub = src[li];
                sa += ((add >>> 24) & 0xff) - ((sub >>> 24) & 0xff);
                sr += ((add >> 16) & 0xff) - ((sub >> 16) & 0xff);
                sg += ((add >> 8) & 0xff) - ((sub >> 8) & 0xff);
                sb += (add & 0xff) - (sub & 0xff);

                dst[ti + j * w] = ((sa / div) << 24) | ((sr / div) << 16)
                        | ((sg / div) << 8) | (sb / div);
                ri += w;
                li += w;
            }
            for (int j = h - radius; j < h; j++) {
                sa += ((lv >>> 24) & 0xff) - ((src[li] >>> 24) & 0xff);
                sr += ((lv >> 16) & 0xff) - ((src[li] >> 16) & 0xff);
                sg += ((lv >> 8) & 0xff) - ((src[li] >> 8) & 0xff);
                sb += (lv & 0xff) - (src[li] & 0xff);

                dst[ti + j * w] = ((sa / div) << 24) | ((sr / div) << 16)
                        | ((sg / div) << 8) | (sb / div);
                li += w;
            }
        }
    }
}
