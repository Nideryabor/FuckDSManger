package com.nidyaber.fuckdsmanger.bridge;

import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.Shader;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;

import de.robv.android.xposed.XC_MethodHook;

/**
 * GmFitApplyHook —— 「图片底铺满/缩放」的**第二条通道** 🐲（2026-10-03）
 *
 * <h3>为什么要第二条</h3>
 * 原通道钩的是 `jq0.b(J)`（ShaderBrush.createShader）。静态链条全对——
 * 类名对（jq0）、方法在（`b(J)`）、调用方在（`im9.a` 里 `invoke-virtual … b(J)`）、
 * 底座也回灌了——可主人的图片**就是不见缩放**。既然"该响的铃"不响，
 * 那就再挂一个**必然被走到**的地方：
 * <pre>
 *   draw 路径 → im9.a(F J Lsf;)V   ← ShaderBrush.applyTo（final，所有 ShaderBrush 共用）
 *                └─ 内部才去调 this.b(J)
 * </pre>
 * `im9.a` 的参数里**就带着目标尺寸**（J = 打包的 Size：高 32 位 = 宽，低 32 位 = 高），
 * 而且它是 `final` 具体方法 ⇒ 钩它不依赖子类、不依赖虚分派是否落到我们那个类上。
 *
 * <h3>这一条怎么生效</h3>
 * 不替换宿主结果（不 setResult，风险最小），只在**调用前**把"铺满矩阵"
 * 贴到**真正被采样的那个输入 BitmapShader** 上
 * （`GmBubble.sInShaderMap`：RuntimeShader → 输入 BitmapShader）。
 * 于是 RuntimeShader 里 `img.eval(p)` 采到的就是缩放后的图。
 *
 * <p>只认"我们自己的图"：必须能在 GmBubble 的身份表里对上号；对不上 ⇒ 一个字都不动。
 * 缩放倍率 = 配置「缩放」/100（100% = 按宽度铺满；<100 更小、边缘色延伸；>100 裁更狠）。
 */
public final class GmFitApplyHook extends XC_MethodHook {

    @Override
    protected void beforeHookedMethod(MethodHookParam p) {
        try {
            Object brush = p.thisObject;
            if (brush == null || p.args == null || p.args.length < 1) {
                return;
            }
            Object d = field(brush, "d");
            if (!(d instanceof Shader)) {
                return;                                  // 不是 shader 类 brush ⇒ 放行
            }
            // ★ 2026-10-03 修正：签名是 a(F J Lsf;)V —— **浮点在前、尺寸是第 2 个参数**！
            //   原来读 args[0]（浮点）⇒ instanceof Long 永远 false ⇒ 静默放行
            //   ⇒ 装了钩也永远不动（真机 IMGBRUSH 有了、APPLY 一条没有，就是这行害的）
            Object size = null;
            for (int i = 0; i < p.args.length && i < 3; i++) {
                if (p.args[i] instanceof Long) {
                    size = p.args[i];
                    break;
                }
            }
            if (size == null) {
                return;
            }
            long j = (Long) size;
            // ★ 2026-10-03 二修：这是 **Size 的打包**（高 32 位=宽的浮点位模式，低 32 位=高）
            //   真机实测：1440.0f 的位模式 = 1152647168 —— 当整数读就会算出 1.7e6 倍的鬼缩放
            float tw = Float.intBitsToFloat((int) (j >>> 32));
            float th = Float.intBitsToFloat((int) j);
            if (!(tw > 1f && th > 1f)) {
                return;
            }

            // ① 认图：RuntimeShader → 图（sBmpShaderMap）；或 brush 实例 → 图（sBmpMap）
            Bitmap bmp = (Bitmap) mapGet(staticMap("sBmpShaderMap"), d);
            if (bmp == null) {
                bmp = (Bitmap) mapGet(staticMap("sBmpMap"), brush);
            }
            if (bmp == null) {
                GmFitProbe.notOurs(d);                   // 记一条（限次）便于定位
                return;                                  // 不是我们的刷子 ⇒ 一个字都不动
            }

            // ② 铺满矩阵（与旧版 FitHook 同一套数学：按宽度铺满、水平居中、顶部对齐）
            float scale = tw / (float) bmp.getWidth() * zf(zoomF());
            Matrix m = new Matrix();
            m.setScale(scale, scale);
            m.postTranslate(-((float) bmp.getWidth() * scale - tw) / 2f, 0f);

            // ③ 贴到真正被采样的"输入 BitmapShader"上
            Shader input = (Shader) mapGet(staticMap("sInShaderMap"), d);
            if (input != null) {
                input.setLocalMatrix(m);
                GmFitProbe.applied(scale, (int) tw, (int) th, bmp);
            } else if (bmp != null) {
                GmFitProbe.appliedNoInput(scale);
            }
        } catch (Throwable ignore) {
        }
    }

    // ───────────────────────── 反射小工具 ─────────────────────────

    private static Field findField(Class<?> c, String name) {
        for (Class<?> k = c; k != null && k != Object.class; k = k.getSuperclass()) {
            for (Field f : k.getDeclaredFields()) {
                if (f.getName().equals(name)) {
                    return f;
                }
            }
        }
        return null;
    }

    private static Object field(Object o, String name) {
        try {
            Field f = findField(o.getClass(), name);
            if (f == null) {
                return null;
            }
            f.setAccessible(true);
            return f.get(o);
        } catch (Throwable ignore) {
            return null;
        }
    }

    private static Map<?, ?> staticMap(String name) {
        try {
            Class<?> c = Class.forName("com.nidyaber.fuckdsmanger.gm.GmBubble");
            Field f = c.getField(name);
            f.setAccessible(true);
            Object v = f.get(null);
            return (v instanceof Map) ? (Map<?, ?>) v : null;
        } catch (Throwable ignore) {
            return null;
        }
    }

    private static Object mapGet(Map<?, ?> m, Object key) {
        try {
            return (m == null || key == null) ? null : m.get(key);
        } catch (Throwable ignore) {
            return null;
        }
    }

    private static float zoomF() {
        try {
            Class<?> c = Class.forName("com.nidyaber.fuckdsmanger.gm.GmBubble");
            Method m = c.getMethod("zoomF");
            Object v = m.invoke(null);
            return (v instanceof Float) ? (Float) v : 1f;
        } catch (Throwable ignore) {
            return 1f;
        }
    }

    /** 倍率钳位（与 GmFitProbe.zf 同义）。 */
    private static float zf(float z) {
        return (z <= 0.05f) ? 1f : z;
    }
}
