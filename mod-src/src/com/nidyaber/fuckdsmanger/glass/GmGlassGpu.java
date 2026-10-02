package com.nidyaber.fuckdsmanger.glass;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RenderEffect;
import android.graphics.RenderNode;
import android.graphics.RuntimeShader;
import android.graphics.Shader;
import android.os.Build;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

/**
 * 液态玻璃 · **GPU 管线**（RenderNode + RenderEffect）🐲
 *
 * <h3>这跟「用第三方库」是什么关系</h3>
 * 主人问过三次「真的不能搞第三方库吗」。准确的答案是：
 * <b>库用不了，但库的"内脏"能全部直接用。</b>
 *
 * <p>Haze 2.0 干的事就是下面这条链，而那全是 <b>平台 API</b>，不是库的私有东西：
 * <pre>
 *   RenderNode
 *     ├ content : 底图（裁到元素区域，外扩一段好让折射有东西可采）
 *     └ renderEffect = RenderEffect.createChainEffect(
 *           createBlurEffect(r, r, CLAMP),                    ← GPU 模糊
 *           createRuntimeShaderEffect(LENS, "content")        ← AGSL 折射
 *       )
 *   → canvas.drawRenderNode(node)
 * </pre>
 *
 * <p>为什么库本身不能用：宿主把 Compose 全混淆了（`Modifier` = `Lc76;`），
 * 库的每一行都在引用 `androidx.compose.ui.*` 这种真名 ⇒ 第一行就 `NoClassDefFoundError`。
 * 而上面这些是 `android.graphics.*`，**名字永远不会变**。
 *
 * <h3>比 CPU 版好在哪</h3>
 * <ul>
 *   <li>模糊走 GPU（之前是手搓 StackBlur，1/4 缩略图 + 三趟盒式，又糊又费 CPU）；</li>
 *   <li>底图可以留<b>高分辨率</b>（不再需要为省 CPU 而降采样）；</li>
 *   <li>`content` 输入由框架自动喂 —— 不用自己造 `BitmapShader` 和算对位矩阵。</li>
 * </ul>
 *
 * <h3>兼容</h3>
 * {@code createRuntimeShaderEffect} 要 <b>API 33+</b>。
 * 所有引用都关在本类里，由 {@link #available()} 在**进这个类之前**拦住。
 */
final class GmGlassGpu {

    private GmGlassGpu() {
    }

    /**
     * ⚠️⚠️ <b>绝对不要复用 RenderNode！</b>
     *
     * <p>硬件画布上的 {@code Canvas.drawRenderNode(node)} 是**延迟绘制**的 ——
     * 它只往显示列表里记一个「待会儿画这个 node」的引用。
     * 如果在同一帧里把这个 node 改了又改（我们一帧要画几十上百个元素），
     * 那**所有引用最后都指向同一个、被改烂的 node**
     * ⇒ 每个玻璃元素都渲染出同一块内容。
     *
     * <p>真机症状（主人原话）：「把对话内所有的东西全部渲染出来了」——
     * 就是这个。所以这里<b>每次新建</b>。
     *
     * <p>{@link RuntimeShader} 同理不能瞎共享（uniform 会被后面的覆盖），
     * 但**同尺寸的元素 uniform 完全一样**，所以可以按「尺寸参数」缓存。
     */
    private static final java.util.HashMap<String, RuntimeShader> SH_CACHE =
            new java.util.HashMap<String, RuntimeShader>();
    private static volatile boolean sErrLogged = false;

    static boolean available() {
        return Build.VERSION.SDK_INT >= 33;
    }

    /**
     * 用 GPU 管画画一块玻璃。
     *
     * @param c       目标画布（**已经**处在元素的局部坐标系里，原点 = 元素左上角）
     * @param back    底图（整窗截图）
     * @param ox,oy   元素在窗口里的位置（底图对位用）
     * @param w,h     元素尺寸
     * @param r       圆角
     * @param pad     外扩留白（折射要采元素外面的像素）
     * @param blurPx  模糊半径（px）
     * @param outAlpha 最终 alpha（浓度）
     * @return 是否真的画了
     */
    static boolean draw(Canvas c, Bitmap back, int ox, int oy,
                        float w, float h, float r, float pad,
                        float blurPx, int outAlpha, float dispersion, int tintArgb,
                        int engine, boolean clean, float cleanTol, boolean stretch) {
        if (back == null || back.isRecycled()) return false;
        if (w < 2f || h < 2f) return false;
        // ★ 软件画布不支持 drawRenderNode（真机报过 "Software rendering doesn't support
        //   drawRenderNode"）—— 我们的**自拍**就是软件画布，所以自拍永远看不到 GPU 效果。
        //   这里直接判掉，别再白试一遍（真实屏幕是硬件画布，会正常走 GPU）。
        if (!c.isHardwareAccelerated()) return false;
        try {
            // 「擦掉内容」：从元素**边缘**估背景色（边缘基本是纯背景，不会踩到文字）
            final int cleanArgb = clean ? estimateBg(back, ox, oy, w, h) : 0xFFFFFFFF;
            final int nw = Math.round(w + pad * 2f);
            final int nh = Math.round(h + pad * 2f);

            // ★ 每次新建（理由见字段注释：延迟绘制 + 复用 = 全渲染成同一块）
            RenderNode node = new RenderNode("fdm-glass");
            // 外扩部分画到元素外面去，靠调用方的裁剪收回
            // （这版 SDK 只有 setPosition(IIII) 一个重载）
            {
                int p0 = Math.round(-pad);
                node.setPosition(p0, p0, p0 + nw, p0 + nh);
            }
            node.setAlpha(outAlpha / 255f);

            // ① 录内容：把底图铺满整个 node
            Rect src;
            if (stretch) {
                // 「底色做玻璃」（A 方案）：底图是一张小尺寸的合成图 ⇒ **直接拉伸铺满**
                // （它没有"窗口坐标"的含义，别用裁切那套）
                src = new Rect(0, 0, back.getWidth(), back.getHeight());
            } else {
                // 「屏幕截图」模式：底图是整窗 1/SCALE 缩略图 ⇒ 按元素窗口位置裁切
                int S = GmGlassBackdrop.SCALE;
                src = new Rect(
                        Math.max(0, (ox - (int) pad) / S),
                        Math.max(0, (oy - (int) pad) / S),
                        0, 0);
                src.right = Math.min(back.getWidth(), (ox + (int) w + (int) pad) / S);
                src.bottom = Math.min(back.getHeight(), (oy + (int) h + (int) pad) / S);
            }
            if (src.width() < 2 || src.height() < 2) return false;

            android.graphics.RecordingCanvas rc = node.beginRecording(nw, nh);
            Paint p = sRecPaint;
            p.setFilterBitmap(true);
            rc.drawBitmap(back, src, new Rect(0, 0, nw, nh), p);
            node.endRecording();

            // ② 渲染效果 = GPU 模糊 → AGSL 折射（链式）
            // shader 按参数缓存：同尺寸同参数的多个元素 uniform 一致 ⇒ 可以共享
            // （Haze 的坐标模型：sampleSize / materialOrigin / materialSize）
            String key = engine + ":" + Math.round(w) + ":" + Math.round(h) + ":" + Math.round(r)
                    + ":" + Math.round(pad) + ":" + Math.round(dispersion * 100)
                    + ":" + Integer.toHexString(tintArgb);
            RuntimeShader rs;
            synchronized (SH_CACHE) {
                rs = SH_CACHE.get(key);
                if (rs == null) {
                    rs = new RuntimeShader(GmGlassLens.sourceOf(engine));
                    // sampleSize = 采样源(node)尺寸；materialOrigin/Size = 玻璃本体在其中的位置与大小
                    GmGlassLens.setUniforms(rs, engine, nw, nh, pad, pad, w, h, r, pad,
                            dispersion, tintArgb, clean, cleanTol, cleanArgb);
                    if (SH_CACHE.size() < 96) SH_CACHE.put(key, rs);
                }
            }

            RenderEffect blur = RenderEffect.createBlurEffect(
                    blurPx, blurPx, Shader.TileMode.CLAMP);
            RenderEffect lens = RenderEffect.createRuntimeShaderEffect(rs, "content");
            node.setRenderEffect(RenderEffect.createChainEffect(blur, lens));

            // ③ 落笔
            c.drawRenderNode(node);

            if (!sOkLogged) {
                sOkLogged = true;
                GmUtil.log("【GmGlass】GPU 管线生效（" + nw + "x" + nh
                        + " · 模糊=" + Math.round(blurPx) + "px）");
            }
            return true;
        } catch (Throwable t) {
            if (!sErrLogged) {
                sErrLogged = true;
                GmUtil.log("【GmGlass】GPU 管线失败（退回 CPU 版）：" + t);
            }
            return false;
        }
    }

    /**
     * 从元素**边缘**估背景色。
     *
     * <p>为什么采边缘：元素的四条边基本是纯背景（文字/图标都在中间），
     * 采这里最不容易踩到内容 ⇒ 估出来的就是"这块东西的底色"。
     * 拿它去 gate 正文像素，就把文字从折射底图里**擦掉了**。
     */
    private static int estimateBg(Bitmap back, int ox, int oy, float w, float h) {
        try {
            int S = GmGlassBackdrop.SCALE;
            int bw = back.getWidth(), bh = back.getHeight();
            // 边缘内缩 6%（既避开圆角，又避开边框）
            float[] fx = {0.06f, 0.5f, 0.94f, 0.06f, 0.94f, 0.06f, 0.5f, 0.94f};
            float[] fy = {0.06f, 0.06f, 0.06f, 0.5f, 0.5f, 0.94f, 0.94f, 0.94f};
            long r = 0, g = 0, b = 0;
            int n = 0;
            for (int i = 0; i < fx.length; i++) {
                int px = (ox + (int) (w * fx[i])) / S;
                int py = (oy + (int) (h * fy[i])) / S;
                if (px < 0 || py < 0 || px >= bw || py >= bh) continue;
                int c = back.getPixel(px, py);
                r += (c >> 16) & 0xFF;
                g += (c >> 8) & 0xFF;
                b += c & 0xFF;
                n++;
            }
            if (n == 0) return 0xFFFFFFFF;
            return 0xFF000000 | (((int) (r / n)) << 16) | (((int) (g / n)) << 8) | ((int) (b / n));
        } catch (Throwable ignore) {
            return 0xFFFFFFFF;
        }
    }

    private static final Paint sRecPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private static volatile boolean sOkLogged = false;
}
