// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

/**
 * GmPrims —— 宿主**原语**的「按签名找」入口 🐲 2026-10-31
 *
 * <h3>为什么另开一个类</h3>
 * 底座的 {@code GmBubble} / {@code GmBubblePaintHook} 里有几处是「把 Modifier 变成一块底色」的调用，
 * 原来写的是 {@code callStaticMethod(cls, "z", {modifier, Long(颜色), shape})}：
 *
 * <pre>
 *   2.5.2 / 2.6.x / 2.7.1   同一个槽位的名字 = z（Element 叫 fi0 / eh0）
 *   2.7.2                   名字变成 t（颜色）/ s（刷子）
 *                           —— 而 z 已被 R8 挪给了 z(View)View（完全另一个函数）
 * </pre>
 *
 * ⇒ 按名字调必然是 {@code NoSuchMethodError}。真机 2026-10-31 的日志就是这么炸的：
 * <pre>
 *   E java.lang.NoSuchMethodError: x98#z[class y6a, class java.lang.Long, class ib9]
 *        at com.nidyaber.fuckdsmanger.gm.GmBubble.wrap
 * </pre>
 * 而且**下次升级还会再炸一次** —— 所以不认名字了。
 *
 * <h3>正确做法：按签名找</h3>
 * 这两个原语在 Compose 侧是 {@code BackgroundKt} 的公开 API，签名**跨版本稳定**：
 *
 * <pre>
 *   background(Modifier, color: long,      shape: Shape)           : Modifier   ← 颜色版
 *   background(Modifier, brush: Brush,     shape: Shape, alpha: int) : Modifier  ← 刷子版
 * </pre>
 *
 * 判据 = 「<b>首参类型 == 返回类型</b>（Modifier 链式）+ 第 3 参是 Shape（用样本实例判定）」。
 *
 * <h3>安全边界</h3>
 * <ul>
 *   <li>找不到 / 不像 ⇒ 返回 {@code null}。调用方把 null 当"没注入"，退回不注入，
 *       <b>绝不影响宿主</b>。</li>
 *   <li>只调宿主自己的静态方法，不往宿主里塞我们自己的类型制造物。</li>
 * </ul>
 */
public final class GmPrims {

    private GmPrims() {
    }

    // ─────────────────────── 缓存（按 ClassLoader 分）───────────────────────

    private static volatile ClassLoader sCl = null;
    private static volatile Method sBgColor = null;   // (Modifier, long, Shape) : Modifier
    private static volatile Method sBgBrush = null;   // (Modifier, Brush, Shape, int) : Modifier
    private static volatile boolean sTried = false;
    private static volatile String sWhy = "未初始化";

    /** 自检结论（给日志看）。 */
    public static String status() {
        return (sBgColor != null || sBgBrush != null ? "可用" : "不可用") + " · " + sWhy
                + " · 颜色=" + (sBgColor == null ? "无" : name(sBgColor))
                + " · 刷子=" + (sBgBrush == null ? "无" : name(sBgBrush));
    }

    private static String name(Method m) {
        return m.getDeclaringClass().getSimpleName() + "." + m.getName();
    }

    // ═══════════════════════════ ① 找原语 ═══════════════════════════

    /**
     * 在「Modifier 扩展桶」里按签名把两个背景原语找出来。
     *
     * <p>桶的位置走 {@link GmRemap#clsAll(String)}（键 {@code uia}）——
     * 2.7.2 它被 R8 拆成了 6 个碎片（{@code x98,qu7,z2c,g83,j37,zi9}），
     * 所以必须**逐个碎片都扫**，不能只看第一个。
     *
     * @param shapeSample 手上现成的一个 Shape 实例（用于实例判定），可为 null
     * @param brushSample 手上现成的一个 Brush 实例，可为 null
     */
    private static void prepare(ClassLoader cl, Object shapeSample, Object brushSample) {
        if (sTried && sCl == cl) return;
        synchronized (GmPrims.class) {
            if (sTried && sCl == cl) return;
            sCl = cl;
            Method foundColor = null, foundBrush = null;
            StringBuilder why = new StringBuilder();
            try {
                String[] buckets = GmRemap.clsAll("uia");
                for (String bn : buckets) {
                    Class<?> c;
                    try {
                        c = Class.forName(bn, false, cl);
                    } catch (Throwable t) {
                        continue;
                    }
                    if (c == null) continue;
                    for (Method m : c.getDeclaredMethods()) {
                        if (!Modifier.isStatic(m.getModifiers())) continue;
                        Class<?> ret = m.getReturnType();
                        Class<?>[] ps = m.getParameterTypes();
                        // ① 颜色版： (ret, long, Shape) : ret
                        if (foundColor == null && ps.length == 3
                                && ps[0] == ret
                                && ps[1] == long.class
                                && isShapeLike(ps[2], shapeSample)) {
                            m.setAccessible(true);
                            foundColor = m;
                        }
                        // ② 刷子版： (ret, Brush, Shape, int) : ret
                        if (foundBrush == null && ps.length == 4
                                && ps[0] == ret
                                && ps[3] == int.class
                                && isShapeLike(ps[2], shapeSample)
                                && (brushSample == null || ps[1].isInstance(brushSample))) {
                            m.setAccessible(true);
                            foundBrush = m;
                        }
                    }
                    if (foundColor != null && foundBrush != null) break;
                }
                why.append("桶=").append(join(buckets));
            } catch (Throwable t) {
                why.append("扫描异常：").append(t);
            }
            sBgColor = foundColor;
            sBgBrush = foundBrush;
            sWhy = why.toString();
            sTried = true;
            try {
                GmUtil.log("【GmPrims】背景原语自检：" + status());
            } catch (Throwable ignore) {
            }
        }
    }

    private static String join(String[] a) {
        if (a == null) return "(null)";
        StringBuilder sb = new StringBuilder();
        for (String s : a) {
            if (sb.length() > 0) sb.append('/');
            sb.append(s);
        }
        return sb.toString();
    }

    /** 判「像不像 Shape」：给了样本就实例判定，没给就认接口。 */
    private static boolean isShapeLike(Class<?> p, Object sample) {
        if (sample != null) return p.isInstance(sample);
        return p.isInterface();
    }

    // ═══════════════════════════ ② 对外的两个入口 ═══════════════════════════

    /**
     * 颜色版 {@code background(modifier, color, shape)}。
     *
     * <p>⚠️ 参数用 {@code Object[]} 而不是分散的形参：底座那边（smali）**已经**把
     * {@code {modifier, Long(颜色), shape}} 拼好了一个数组递进来，直接收最省事，
     * 也免得在 smali 里为 long 排两个寄存器。
     *
     * @param args { Modifier, Long(颜色 packed), Shape }
     * @return 新的 Modifier；找不到原语或参数不对 ⇒ null（调用方必须容忍 null）
     */
    public static Object background(ClassLoader cl, Object[] args) {
        try {
            if (args == null || args.length < 3) return null;
            Object mod = args[0], color = args[1], shape = args[2];
            if (mod == null || shape == null) return null;
            if (!(color instanceof Long)) return null;
            prepare(cl, shape, null);
            Method m = sBgColor;
            if (m == null) return null;
            Class<?>[] ps = m.getParameterTypes();
            if (!ps[0].isInstance(mod) || !ps[2].isInstance(shape)) return null;
            return m.invoke(null, mod, Long.valueOf(((Long) color).longValue()), shape);
        } catch (Throwable t) {
            GmUtil.logOnce("GmPrims.bgColor", "【GmPrims】颜色背景调用失败：" + t);
            return null;
        }
    }

    /**
     * 刷子版 {@code background(modifier, brush, shape, alpha)}。
     *
     * @param args { Modifier, Brush, Shape, Integer(alpha) }
     * @return 新的 Modifier；不可用 ⇒ null
     */
    public static Object backgroundBrush(ClassLoader cl, Object[] args) {
        try {
            if (args == null || args.length < 4) return null;
            Object mod = args[0], brush = args[1], shape = args[2], alpha = args[3];
            if (mod == null || brush == null || shape == null) return null;
            int a = (alpha instanceof Integer) ? ((Integer) alpha).intValue() : 0;
            prepare(cl, shape, brush);
            Method m = sBgBrush;
            if (m == null) return null;
            Class<?>[] ps = m.getParameterTypes();
            if (!ps[0].isInstance(mod) || !ps[1].isInstance(brush) || !ps[2].isInstance(shape)) return null;
            return m.invoke(null, mod, brush, shape, Integer.valueOf(a));
        } catch (Throwable t) {
            GmUtil.logOnce("GmPrims.bgBrush", "【GmPrims】刷子背景调用失败：" + t);
            return null;
        }
    }
}
