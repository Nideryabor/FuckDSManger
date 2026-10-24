// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Shader;

/**
 * 液态玻璃 · **「底色做玻璃」的底图**（A 方案）🐲
 *
 * <h3>为什么不要截图</h3>
 * 主人 2026-09-30 拍板走 A。理由（详见 {@code 专题/液态玻璃-底图方案研究.md}）：
 * <ul>
 *   <li>PixelCopy 有五个毛病：后台失效 / 有延迟 / **连文字一起截** / 正反馈 / <b>可能炸渲染线程</b>
 *       （后者是 Cloudy 源码里写明的：它强迫整棵树重走一遍且没有环检测）；</li>
 *   <li>而<b>宿主的界面大片是纯色</b> —— 在纯色上，截图和"用底色"本来就长得一样
 *       （这正是"改了看不出区别"的真相）；</li>
 *   <li>我们<b>本来就 hook 了每个元素的背景节点</b>，那个颜色是已知的 —— 没必要去截屏。</li>
 * </ul>
 *
 * <h3>兼容我们自己的气泡/背景模块</h3>
 * 颜色取自宿主画底原语 {@code uia.v(Modifier, long 色, Shape)} 的<b>第 2 个参数</b>。
 * 我们自己的「AI 气泡美化 / 用户气泡美化」改色时走的**也是这个入口**
 * ⇒ <b>拿到的就是最终生效的那个颜色</b>，天然不打架。
 *
 * <h3>做出来的"底图"长什么样</h3>
 * 不是纯色板 —— 而是<b>底色 + 一点柔和渐变</b>（上亮下暗）。
 * 纯色是"死"的，折射和色散在纯色上看不见；带一点渐变，边缘一掰弯就有东西可看。
 */
final class GmGlassSolid {

    private GmGlassSolid() {
    }

    /** 合成底图的分辨率（够用就行，反正是渐变）。 */
    private static final int SIZE = 64;

    /** 按颜色缓存 —— 一帧里几十上百个元素，但颜色就那么几种，别每帧 new 一堆位图。 */
    private static final java.util.HashMap<Integer, Bitmap> CACHE =
            new java.util.HashMap<Integer, Bitmap>();

    /**
     * 用元素底色造一张小底图（**带缓存**）。
     *
     * @param color 元素底色（ARGB）
     */
    static Bitmap make(final int color) {
        synchronized (CACHE) {
            Bitmap hit = CACHE.get(color);
            if (hit != null && !hit.isRecycled()) return hit;
            Bitmap b = build(color);
            if (b != null && CACHE.size() < 64) CACHE.put(color, b);
            return b;
        }
    }

    private static Bitmap build(int color) {
        try {
            int a = (color >>> 24) & 0xFF;
            int r = (color >> 16) & 0xFF;
            int g = (color >> 8) & 0xFF;
            int b = color & 0xFF;
            if (a == 0) {                 // 全透明 ⇒ 当成"没有底色"，给个中性灰
                a = 255; r = g = b = 40;
            }
            // 上亮下暗：纯色是死的，带一点渐变边缘折射才看得出来
            int top = argb(a, lift(r, 1.18f), lift(g, 1.18f), lift(b, 1.18f));
            int bottom = argb(a, lift(r, 0.86f), lift(g, 0.86f), lift(b, 0.86f));

            Bitmap bmp = Bitmap.createBitmap(SIZE, SIZE, Bitmap.Config.ARGB_8888);
            Canvas c = new Canvas(bmp);
            Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
            p.setShader(new LinearGradient(0, 0, 0, SIZE, top, bottom, Shader.TileMode.CLAMP));
            c.drawRect(0, 0, SIZE, SIZE, p);
            return bmp;
        } catch (Throwable t) {
            return null;
        }
    }

    private static int lift(int v, float k) {
        int x = Math.round(v * k);
        return x < 0 ? 0 : (x > 255 ? 255 : x);
    }

    private static int argb(int a, int r, int g, int b) {
        return (a << 24) | (r << 16) | (g << 8) | b;
    }
}
