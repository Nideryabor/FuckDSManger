package com.nidyaber.fuckdsmanger.glass;

import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Matrix;
import android.graphics.RuntimeShader;
import android.graphics.Shader;
import android.os.Build;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

/**
 * 液态玻璃 · **折射着色器**（AGSL）🐲
 *
 * <h3>2026-09-30 重写：照 <b>Haze</b> 的真源码来</h3>
 * 之前那份是照另一个参照物（`底栏液态玻璃`）抄的，能用但坐标模型绕、且缺关键的"液态感"。
 * 主人要求「把库拉下来看他怎么实现，然后针对宿主重写一套核心」⇒ 读了
 * <pre>
 *   haze-glass/src/commonMain/kotlin/dev/chrisbanes/haze/glass/GlassShaders.kt
 *   haze-blur/src/androidMain/kotlin/dev/chrisbanes/haze/blur/BlurRenderEffect.android.kt
 * </pre>
 * 学到并采纳的三条：
 * <ol>
 *   <li><b>坐标模型</b>：Haze 用 {@code sampleSize / materialOrigin / materialSize} ——
 *       「采样源多大 · 玻璃在源里的位置 · 玻璃多大」。
 *       比之前的 {@code size + offset} 清晰得多，而且折射天然在**采样源坐标系**里算。</li>
 *   <li><b>着色是 over 合成</b>，不是"盖一层半透明矩形"：
 *       <pre>out = tint.rgb * tint.a + content.rgb * (1 - tint.a)</pre></li>
 *   <li><b>色散（chromatic aberration）</b>：边缘按 R/B 通道**分离采样**——
 *       这是"液态玻璃"最像的那一下（边缘泛彩），之前完全没有。</li>
 * </ol>
 *
 * <p>契约：{@code content} 是**采样源**（整个 node 的位图，含玻璃外面的留白），
 * 玻璃本体位于采样源坐标的 {@code [materialOrigin, materialOrigin + materialSize]}。
 *
 * <p>API 33+ 才走；低版本由调用方在进本类之前拦掉。
 */
final class GmGlassLens {

    private GmGlassLens() {
    }

    /** 方案常量（与 {@code fuckds_glass_engine} 对应）。 */
    static final int ENGINE_HAZE = 0;
    static final int ENGINE_CLOUDY = 1;
    static final int ENGINE_RIPPLE = 2;

    /** 按方案取 shader 源码（正文由 {@code tools/gen_glass_shaders.py} 从 .agsl 逐字生成）。 */
    static String sourceOf(int engine) {
        switch (engine) {
            case ENGINE_CLOUDY: return GmGlassShaders.CLOUDY;
            case ENGINE_RIPPLE: return GmGlassShaders.RIPPLE;
            default:            return GmGlassShaders.HAZE;
        }
    }

    /**
     * 按方案设 uniform。
     *
     * <p>三家的坐标/参数模型完全不一样，所以这里是**分派器**：
     * <ul>
     *   <li><b>HAZE</b>：sampleSize / materialOrigin / materialSize（我们最熟的一套）；</li>
     *   <li><b>CLOUDY</b>：resolution / lensCenter / lensSize + 四重镜面高光的一堆旋钮；</li>
     *   <li><b>RIPPLE</b>：size / strength（最轻）。</li>
     * </ul>
     */
    static void setUniforms(RuntimeShader rs, int engine,
                            float sw, float sh,
                            float mx, float my, float mw, float mh,
                            float r, float pad, float disp, int tintArgb,
                            boolean clean, float cleanTol, int cleanArgb,
                            float fadeAmt, float fadePx) {
        // 「擦掉内容，只留背景」的三件套（前奏里声明，所有方案共用）
        rs.setFloatUniform("fdmCleanOn", clean ? 1f : 0f);
        rs.setFloatUniform("fdmCleanTol", cleanTol);
        rs.setFloatUniform("fdmCleanColor",
                ((cleanArgb >> 16) & 0xFF) / 255f,
                ((cleanArgb >> 8) & 0xFF) / 255f,
                (cleanArgb & 0xFF) / 255f,
                1f);
        // 「边缘过渡」（2026-10-02 · 主人：「颜色没有过渡也很生硬」）
        //   ⚠️ 个别方案（如 RIPPLE）没用到它 —— AGSL 可能把未用 uniform 裁掉，
        //   那样 setFloatUniform 会抛 ⇒ 单独兜住，别拖垮整个 shader。
        try {
            rs.setFloatUniform("fdmFade", fadeAmt);
            rs.setFloatUniform("fdmFadePx", fadePx);
        } catch (Throwable ignore) {
        }
        setUniforms(rs, engine, sw, sh, mx, my, mw, mh, r, pad, disp, tintArgb);
    }

    static void setUniforms(RuntimeShader rs, int engine,
                            float sw, float sh,
                            float mx, float my, float mw, float mh,
                            float r, float pad, float disp, int tintArgb) {
        float a = ((tintArgb >>> 24) & 0xFF) / 255f;
        float tr = ((tintArgb >> 16) & 0xFF) / 255f;
        float tg = ((tintArgb >> 8) & 0xFF) / 255f;
        float tb = (tintArgb & 0xFF) / 255f;

        if (engine == ENGINE_CLOUDY) {
            rs.setFloatUniform("resolution", sw, sh);
            rs.setFloatUniform("lensCenter", mx + mw * 0.5f, my + mh * 0.5f);
            rs.setFloatUniform("lensSize", mw, mh);
            rs.setFloatUniform("cornerRadius", r);
            rs.setFloatUniform("refraction", pad * 0.5f);
            rs.setFloatUniform("curve", 1.0f);
            rs.setFloatUniform("dispersion", disp);
            rs.setFloatUniform("saturation", 1.0f);
            rs.setFloatUniform("contrast", 1.0f);
            rs.setFloatUniform("tint", tr, tg, tb, a);
            rs.setFloatUniform("edge", 1.0f);
            rs.setFloatUniform("lightDir", 0.0f, -1.0f);
            rs.setFloatUniform("specStrength", 0.75f);
            rs.setFloatUniform("specPower", 24.0f);
            rs.setFloatUniform("specRimMix", 0.5f);
            rs.setFloatUniform("specWidthPx", 6.0f);
            rs.setFloatUniform("specLightZ", 0.6f);
            rs.setFloatUniform("specDomeFrac", 0.35f);
            rs.setFloatUniform("specBodyPower", 2.0f);
            rs.setFloatUniform("specBodyGain", 0.25f);
            rs.setFloatUniform("specFocalK", 0.6f);
            rs.setFloatUniform("specPoolFrac", 0.5f);
            rs.setFloatUniform("specPoolGain", 1.2f);
            return;
        }
        if (engine == ENGINE_RIPPLE) {
            rs.setFloatUniform("size", sw, sh);
            rs.setFloatUniform("strength", Math.min(1f, disp / 20f));
            return;
        }
        // HAZE（默认）
        rs.setFloatUniform("sampleSize", sw, sh);
        rs.setFloatUniform("materialOrigin", mx, my);
        rs.setFloatUniform("materialSize", mw, mh);
        rs.setFloatUniform("cornerRadii", r, r, r, r);
        rs.setFloatUniform("refractionHeight", pad);
        rs.setFloatUniform("refractionAmount", pad * 0.55f);
        rs.setFloatUniform("depthEffect", DEPTH_EFFECT);
        rs.setFloatUniform("dispersion", disp);
        rs.setFloatUniform("tintColor", tr, tg, tb, a);
    }

    /** 旧的 HAZE 源码（保留给 CPU 回退路径复用；正文以 .agsl 为准）。 */
    private static final String SOURCE =
            "uniform shader content;\n"
            + "uniform float2 sampleSize;\n"
            + "uniform float2 materialOrigin;\n"
            + "uniform float2 materialSize;\n"
            + "uniform float4 cornerRadii;\n"
            + "uniform float refractionHeight;\n"
            + "uniform float refractionAmount;\n"
            + "uniform float depthEffect;\n"
            + "uniform float dispersion;\n"
            + "uniform float4 tintColor;\n"
            + "float radiusAt(float2 coord, float4 radii) {\n"
            + "    if (coord.x >= 0.0) {\n"
            + "        if (coord.y <= 0.0) return radii.y; else return radii.z;\n"
            + "    } else {\n"
            + "        if (coord.y <= 0.0) return radii.x; else return radii.w;\n"
            + "    }\n"
            + "}\n"
            + "float sdRoundedRect(float2 coord, float2 halfSize, float radius) {\n"
            + "    float2 cornerCoord = abs(coord) - (halfSize - float2(radius));\n"
            + "    float outside = length(max(cornerCoord, 0.0)) - radius;\n"
            + "    float inside = min(max(cornerCoord.x, cornerCoord.y), 0.0);\n"
            + "    return outside + inside;\n"
            + "}\n"
            + "float2 gradSdRoundedRect(float2 coord, float2 halfSize, float radius) {\n"
            + "    float2 cornerCoord = abs(coord) - (halfSize - float2(radius));\n"
            + "    if (cornerCoord.x >= 0.0 || cornerCoord.y >= 0.0) {\n"
            + "        return sign(coord) * normalize(max(cornerCoord, 0.0) + float2(0.0001));\n"
            + "    } else {\n"
            + "        float gradX = step(cornerCoord.y, cornerCoord.x);\n"
            + "        return sign(coord) * float2(gradX, 1.0 - gradX);\n"
            + "    }\n"
            + "}\n"
            + "float circleMap(float x) { return 1.0 - sqrt(max(1.0 - x * x, 0.0)); }\n"
            + "float2 clampSample(float2 c) {\n"
            + "    return clamp(c, float2(0.5), sampleSize - float2(0.5));\n"
            + "}\n"
            + "half4 main(float2 coord) {\n"
            + "    float2 matCoord = coord - materialOrigin;\n"
            + "    float2 halfSize = materialSize * 0.5;\n"
            + "    float2 centeredCoord = matCoord - halfSize;\n"
            + "    float radius = radiusAt(matCoord, cornerRadii);\n"
            + "    float sd = sdRoundedRect(centeredCoord, halfSize, radius);\n"
            + "    float gradRadius = min(radius * 1.5, min(halfSize.x, halfSize.y));\n"
            + "    float2 grad = normalize(\n"
            + "            gradSdRoundedRect(centeredCoord, halfSize, gradRadius)\n"
            + "            + depthEffect * normalize(centeredCoord + float2(0.0001)));\n"
            + "    float d = 0.0;\n"
            + "    if (sd < 0.0) {\n"
            + "        float t = clamp(1.0 + sd / max(refractionHeight, 0.001), 0.0, 1.0);\n"
            + "        d = circleMap(t) * refractionAmount;\n"
            + "    }\n"
            + "    float2 base = coord + d * grad;\n"
            + "    half4 cr = content.eval(clampSample(base + dispersion * grad));\n"
            + "    half4 cg = content.eval(clampSample(base));\n"
            + "    half4 cb = content.eval(clampSample(base - dispersion * grad));\n"
            + "    float3 rgb = float3(float(cr.r), float(cg.g), float(cb.b));\n"
            + "    float3 outRgb = tintColor.rgb * tintColor.a + rgb * (1.0 - tintColor.a);\n"
            + "    return half4(half(outRgb.r), half(outRgb.g), half(outRgb.b), half(1.0));\n"
            + "}\n";

    /** 折射作用的高度（dp）—— 参照物是 24dp。 */
    private static final float REFRACTION_DP = 24f;
    /** 厚度感，0~1。 */
    private static final float DEPTH_EFFECT = 0.6f;

    /** 能不能用（API 33+）。调用方**必须先问这个**再进本类。 */
    static boolean available() {
        return Build.VERSION.SDK_INT >= 33;
    }

    /** 把新模型的 uniform 一次设好（GPU 路径与 CPU 回退路径共用）。 */
    static void setUniforms(RuntimeShader rs, float sw, float sh,
                            float ox, float oy, float mw, float mh,
                            float r, float pad, float dispersion, int tintArgb) {
        float a = ((tintArgb >>> 24) & 0xFF) / 255f;
        float tr = ((tintArgb >> 16) & 0xFF) / 255f;
        float tg = ((tintArgb >> 8) & 0xFF) / 255f;
        float tb = (tintArgb & 0xFF) / 255f;
        rs.setFloatUniform("sampleSize", sw, sh);
        rs.setFloatUniform("materialOrigin", ox, oy);
        rs.setFloatUniform("materialSize", mw, mh);
        rs.setFloatUniform("cornerRadii", r, r, r, r);
        rs.setFloatUniform("refractionHeight", pad);
        rs.setFloatUniform("refractionAmount", pad * 0.55f);
        rs.setFloatUniform("depthEffect", DEPTH_EFFECT);
        rs.setFloatUniform("dispersion", dispersion);
        rs.setFloatUniform("tintColor", tr, tg, tb, a);
    }

    /**
     * CPU 回退路径用的 shader（把底图做成 BitmapShader 喂进 {@code content}）。
     *
     * <p>只有 API 33+ 但没有硬件画布时才会走到（例如我们的"自拍"）。
     */
    static Shader make(Bitmap back, int ox, int oy, float w, float h, float r,
                       float pad, float dispersion, int tintArgb, int engine,
                       boolean clean, float cleanTol, int cleanArgb, boolean stretch,
                       float fadeAmt, float fadePx) {
        if (back == null || back.isRecycled()) return null;
        if (w < 2f || h < 2f) return null;
        try {
            BitmapShader content = new BitmapShader(back, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
            content.setFilterMode(BitmapShader.FILTER_MODE_LINEAR);

            Matrix m = new Matrix();
            if (stretch) {
                // A 方案：底图是"合成小图"，直接拉伸铺满 node（局部坐标 0..nw）
                float nw = w + pad * 2f, nh = h + pad * 2f;
                m.setScale(nw / back.getWidth(), nh / back.getHeight());
                m.postTranslate(-pad, -pad);
            } else {
                // 截图模式：底图是整窗 1/SCALE 缩略图，按窗口坐标对位
                m.setScale(GmGlassBackdrop.SCALE, GmGlassBackdrop.SCALE);
                m.postTranslate(-(ox - (int) pad), -(oy - (int) pad));
            }
            content.setLocalMatrix(m);

            RuntimeShader rs = new RuntimeShader(sourceOf(engine));
            rs.setInputBuffer("content", content);
            setUniforms(rs, engine, w + pad * 2f, h + pad * 2f, pad, pad, w, h, r, pad,
                    dispersion, tintArgb, clean, cleanTol, cleanArgb, fadeAmt, fadePx);
            return rs;
        } catch (Throwable t) {
            GmUtil.logOnce("glass.lens.err", "【GmGlass】折射 shader 造失败（退化为磨砂）：" + t);
            return null;
        }
    }
}
