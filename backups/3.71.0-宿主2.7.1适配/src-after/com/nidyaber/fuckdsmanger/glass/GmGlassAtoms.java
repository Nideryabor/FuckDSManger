// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

import android.graphics.Canvas;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Method;

/**
 * 液态玻璃 · 坐标小工具 🐲
 *
 * <p>要在玻璃里「采样底图」，就得知道<b>眼前这次绘制在窗口的哪个位置</b>。
 * 在 Compose 的 {@code DrawScope} 里画东西用的是<b>局部坐标</b>（(0,0) = 这个节点的左上角），
 * 所以我们得把局部原点换算到窗口坐标。
 *
 * <h3>怎么换</h3>
 * 走 {@code DrawScope → drawContext → transform → currentTransform → values()}：
 * Compose 的 {@code Matrix} 是 4×4（列主序），第 12 / 13 个 float 就是<b>平移分量</b>，
 * 也就是这个节点在绘制根（= ComposeView）里的位置。再叠上 ComposeView 在窗口里的位置，
 * 就是窗口坐标。
 *
 * <h3>拿不到怎么办</h3>
 * <b>优雅降级</b>：返回 (0,0)。上层看到偏移是 0 且没有底图时，就只画半透明玻璃
 * ——<b>效果差一档，但功能不会坏</b>。这条路符合本项目一贯的「能退就退」纪律。
 */
public final class GmGlassAtoms {

    private GmGlassAtoms() {
    }

    /** ComposeView 在窗口里的位置（由 {@link GmGlassInstall} 填）。 */
    private static volatile int sRootX = 0;
    private static volatile int sRootY = 0;

    public static void setRootOffset(int x, int y) {
        sRootX = x;
        sRootY = y;
    }

    /** 一次性诊断，别刷屏。 */
    private static volatile boolean sLogged = false;

    /**
     * 从 DrawScope 反推它在窗口里的左上角。
     *
     * @return int[2]{x, y}；拿不到返回 {0,0}
     */
    public static int[] windowOrigin(Object drawScope) {
        int x = 0, y = 0;
        String how = "无";
        // ① 试 Compose 的 DrawContext.transform（按「返回类型名含 DrawContext」找 —— 混淆下多半找不到）
        try {
            Object ctx = zeroArg(drawScope, "DrawContext");
            if (ctx != null) {
                Object tf = zeroArg(ctx, "DrawTransform");
                if (tf != null) {
                    Object mx = zeroArg(tf, "Matrix");
                    float[] v = mx == null ? null : floats(mx);
                    if (v != null && v.length >= 14) {
                        x = Math.round(v[12]);
                        y = Math.round(v[13]);
                        how = "DrawContext.transform";
                    }
                }
            }
        } catch (Throwable ignore) {
        }
        if (!sLogged) {
            sLogged = true;
            GmUtil.log("【GmGlass】坐标反推[" + how + "]：节点(" + x + "," + y
                    + ") + 根(" + sRootX + "," + sRootY + ")");
        }
        return new int[]{x + sRootX, y + sRootY};
    }

    /**
     * 从 DrawScope 的**对象图**里把变换矩阵掏出来（字段级广度优先，目标类型 {@code float[16]}）。
     *
     * <p><b>为什么要走字段</b>：{@code canvas.getMatrix()} 在 Compose 里是**单位阵**
     * —— 真机实测打出
     * <pre>1.0,0.0,0.0 | 0.0,1.0,0.0 | 0.0,0.0,1.0</pre>
     * 因为 {@code RecordingCanvas} 把 {@code translate()} 当**命令记下来**了，不更新自身矩阵。
     * 而 Compose 把当前变换放在 {@code DrawContext.transform}（一个 4×4，列主序第 12/13 位是平移）
     * ⇒ 只能顺着字段爬。
     *
     * <p>只读字段，**不调用任何方法**（无副作用）。深度 ≤4、最多 300 个对象。
     */
    public static int[] matrixFromFields(Object root) {
        try {
            java.util.ArrayDeque<Object> q = new java.util.ArrayDeque<Object>();
            java.util.IdentityHashMap<Object, Integer> seen =
                    new java.util.IdentityHashMap<Object, Integer>();
            q.add(root);
            seen.put(root, 0);
            int visited = 0;
            while (!q.isEmpty() && visited < 300) {
                Object o = q.poll();
                int d = seen.get(o);
                visited++;
                if (o instanceof float[] && ((float[]) o).length >= 16) {
                    float[] v = (float[]) o;
                    int x = Math.round(v[12]), y = Math.round(v[13]);
                    if (!sMatLogged) {
                        sMatLogged = true;
                        GmUtil.log("【GmGlass】字段找到变换矩阵：平移(" + x + "," + y + ")");
                    }
                    return new int[]{x + sRootX, y + sRootY};
                }
                if (d >= 4) continue;
                for (java.lang.reflect.Field f : o.getClass().getDeclaredFields()) {
                    Class<?> t = f.getType();
                    if (t.isPrimitive() || t == String.class || t == Class.class) continue;
                    try {
                        f.setAccessible(true);
                        Object v = f.get(o);
                        if (v == null || seen.containsKey(v)) continue;
                        seen.put(v, d + 1);
                        q.add(v);
                    } catch (Throwable ignore) {
                    }
                }
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    private static volatile boolean sMatLogged = false;

    /**
     * 从原生画布的变换矩阵里取平移（更可靠的一条路）。
     *
     * <p>Compose 在调 {@code draw} 之前，已经把「这个节点在窗口里的位置」压进了画布变换
     * ⇒ {@code android.graphics.Canvas.getMatrix()} 的 {@code MTRANS_X/Y} 就是答案
     * （前提是 RecordingCanvas 老实返回它）。
     */
    public static int[] originFromCanvas(Object canvas) {
        if (canvas == null) return null;
        try {
            Method gm = Canvas.class.getMethod("getMatrix");
            Object m = gm.invoke(canvas);
            if (m == null) return null;
            Method gv = m.getClass().getMethod("getValues", float[].class);
            float[] v = new float[9];
            gv.invoke(m, v);
            // ★ 必须校验：只接受「纯平移」的矩阵。
            //   如果缩放/斜切不是 1/0，说明这不是我们要的那个变换
            //   （真机上见过单位阵、也见过带缩放的矩阵）⇒ 宁可不画，别采错地方。
            boolean pureTranslate = Math.abs(v[0] - 1f) < 1e-3 && Math.abs(v[4] - 1f) < 1e-3
                    && Math.abs(v[1]) < 1e-3 && Math.abs(v[3]) < 1e-3;
            if (!sLogged2) {
                sLogged2 = true;
                GmUtil.log("【GmGlass】画布矩阵：" + v[0] + "," + v[1] + "," + v[2]
                        + " | " + v[3] + "," + v[4] + "," + v[5]
                        + " | 纯平移=" + pureTranslate);
            }
            if (!pureTranslate) return null;
            int x = Math.round(v[2]) + sRootX;
            int y = Math.round(v[5]) + sRootY;
            return new int[]{x, y};
        } catch (Throwable t) {
            if (!sLogged2) {
                sLogged2 = true;
                GmUtil.log("【GmGlass】画布矩阵取不到：" + t);
            }
            return null;
        }
    }

    private static volatile boolean sLogged2 = false;

    /** 取一个「无参、返回某个对象」的方法（按返回类型的名字粗筛）。 */
    private static Object zeroArg(Object o, String typeHint) {
        try {
            for (Method m : o.getClass().getMethods()) {
                if (m.getParameterCount() != 0) continue;
                Class<?> r = m.getReturnType();
                if (r.isPrimitive() || r == void.class) continue;
                if (r == String.class) continue;
                if (!r.getName().toLowerCase().contains(typeHint.toLowerCase())) continue;
                return m.invoke(o);
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** 从 Compose 的 Matrix 里掏 float[]（inline class，被擦成 float[] 或有一个 values()）。 */
    private static float[] floats(Object matrix) {
        try {
            for (Method m : matrix.getClass().getMethods()) {
                if (m.getParameterCount() == 0 && m.getReturnType() == float[].class) {
                    return (float[]) m.invoke(matrix);
                }
            }
        } catch (Throwable ignore) {
        }
        return null;
    }
}
