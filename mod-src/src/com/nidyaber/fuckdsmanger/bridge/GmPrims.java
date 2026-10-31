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
            if (args == null || args.length < 3) {
                GmUtil.logOnce("GmPrims.bgColor.argc", "【GmPrims】颜色背景：参数个数不对（" + (args == null ? "null" : String.valueOf(args.length)) + "，要 3）");
                return null;
            }
            Object mod = args[0], color = args[1], shape = args[2];
            if (mod == null || shape == null) {
                GmUtil.logOnce("GmPrims.bgColor.null",
                        "【GmPrims】颜色背景：有参数是 null → mod=" + tn(mod) + " shape=" + tn(shape));
                return null;
            }
            if (!(color instanceof Long)) {
                GmUtil.logOnce("GmPrims.bgColor.color", "【GmPrims】颜色背景：颜色不是 Long（" + tn(color) + "）");
                return null;
            }
            prepare(cl, shape, null);
            Method m = sBgColor;
            if (m == null) {
                GmUtil.logOnce("GmPrims.bgColor.nom", "【GmPrims】颜色背景：没找到原语（候选见自检日志）");
                return null;
            }
            Class<?>[] ps = m.getParameterTypes();
            boolean ok0 = ps[0].isInstance(mod);
            boolean ok2 = ps[2].isInstance(shape);
            if (!ok0 || !ok2) {
                GmUtil.logOnce("GmPrims.bgColor.type",
                        "【GmPrims】颜色背景：参数类型不匹配 —— "
                                + "ps0=" + ps[0].getSimpleName() + " vs mod(" + tn(mod) + ")=" + ok0 + " · "
                                + "ps2=" + ps[2].getSimpleName() + " vs shape(" + tn(shape) + ")=" + ok2
                                + " · 方法=" + name(m));
                return null;
            }
            Object r = m.invoke(null, mod, Long.valueOf(((Long) color).longValue()), shape);
            GmUtil.logOnce("GmPrims.bgColor.ok", "【GmPrims】颜色背景 OK（" + name(m) + " → " + tn(r) + "）");
            return r;
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
            if (args == null || args.length < 4) {
                GmUtil.logOnce("GmPrims.bgBrush.argc", "【GmPrims】刷子背景：参数个数不对（" + (args == null ? "null" : String.valueOf(args.length)) + "，要 4）");
                return null;
            }
            Object mod = args[0], brush = args[1], shape = args[2], alpha = args[3];
            int a = (alpha instanceof Integer) ? ((Integer) alpha).intValue() : 0;
            if (mod == null || brush == null || shape == null) {
                GmUtil.logOnce("GmPrims.bgBrush.null",
                        "【GmPrims】刷子背景：有参数是 null → mod=" + tn(mod) + " brush=" + tn(brush) + " shape=" + tn(shape));
                return null;
            }
            prepare(cl, shape, brush);
            Method m = sBgBrush;
            if (m == null) {
                GmUtil.logOnce("GmPrims.bgBrush.nom",
                        "【GmPrims】刷子背景：没找到原语（候选见自检日志）");
                return null;
            }
            Class<?>[] ps = m.getParameterTypes();
            boolean ok0 = ps[0].isInstance(mod);
            boolean ok1 = ps[1].isInstance(brush);
            boolean ok2 = ps[2].isInstance(shape);
            if (!ok0 || !ok1 || !ok2) {
                GmUtil.logOnce("GmPrims.bgBrush.type",
                        "【GmPrims】刷子背景：参数类型不匹配 —— "
                                + "ps0=" + ps[0].getSimpleName() + " vs mod(" + tn(mod) + ")=" + ok0 + " · "
                                + "ps1=" + ps[1].getSimpleName() + " vs brush(" + tn(brush) + ")=" + ok1 + " · "
                                + "ps2=" + ps[2].getSimpleName() + " vs shape(" + tn(shape) + ")=" + ok2
                                + " · 方法=" + name(m));
                return null;
            }
            Object r = m.invoke(null, mod, brush, shape, Integer.valueOf(a));
            GmUtil.logOnce("GmPrims.bgBrush.ok", "【GmPrims】刷子背景 OK（" + name(m) + " → " + tn(r) + "）");
            return r;
        } catch (Throwable t) {
            GmUtil.logOnce("GmPrims.bgBrush", "【GmPrims】刷子背景调用失败：" + t);
            return null;
        }
    }

    /** 类型名（诊断用）：把实例写成 `全名(简名)` 或 null。 */
    private static String tn(Object o) {
        if (o == null) return "null";
        try {
            Class<?> c = o.getClass();
            return c.getSimpleName();
        } catch (Throwable t) {
            return "?";
        }
    }

    // ═══════════════════════════ ③ 全自动入口（smali 侧只传两个参数）═══════════════════════════
    //
    //  ★ 2026-10-31（3.73.6）为什么要有这一层：
    //    上一版我在 GmBubble 的 catch 处理器里重建 {modifier, color, shape} 数组，
    //    用的寄存器（v2/v4）在**异常路径上可能没赋值** ⇒ ART 校验器直接判 Undefined
    //    ⇒ `VerifyError: Verifier rejected class GmBubble` ⇒ **整个类不加载**
    //    ⇒ 所有气泡逻辑（含老代码）一起死，表现成"背景没了、用户气泡不显示"。
    //
    //    教训：**smali 的 catch 处理器里只能碰"一定已定义"的寄存器**——
    //    在这里就是形参 p0/p1。所以把 color/shape/brush 的重建全部搬到 Java，
    //    smali 侧退化成「p0 + p1 进，结果出」，没有寄存器可踩。

    /**
     * 反射入口：{@code GmBubble} 里的 public static。
     *
     * <p>为什么必须反射：{@code GmBubble} 在底座（classes.dex，包 {@code gm}），
     * 本类在桥（classes2.dex，包 {@code bridge}）—— 跨包 + 可能跨 ClassLoader，
     * 直连会 {@code IllegalAccessError} / {@code NoClassDefFoundError}。
     *
     * <p>**两个 loader 都试**（先宿主这份，再自己这份）—— 哪份能看见 {@code GmBubble} 用哪份。
     */
    private static Object callGm(ClassLoader cl, String m, Class<?>[] sig, Object[] args) {
        ClassLoader[] tries = new ClassLoader[]{cl, GmPrims.class.getClassLoader()};
        for (ClassLoader l : tries) {
            if (l == null) continue;
            try {
                Class<?> c = Class.forName("com.nidyaber.fuckdsmanger.gm.GmBubble", true, l);
                Method mm = c.getDeclaredMethod(m, sig);
                mm.setAccessible(true);
                return mm.invoke(null, args);
            } catch (Throwable ignore) {
                // 换下一个 loader
            }
        }
        GmUtil.logOnce("GmPrims.callGm." + m, "【GmPrims】反射调 GmBubble." + m + " 失败（两个 ClassLoader 都没成）");
        return null;
    }

    /**
     * 颜色版背景 —— **只给 ClassLoader 和 Modifier**，颜色/形状自己去 GmBubble 取。
     *
     * @return 新的 Modifier；任何一步不行 ⇒ null（调用方必须容忍）
     */
    public static Object backgroundAutoColor(ClassLoader cl, Object mod) {
        try {
            if (mod == null) return null;
            Object shape = callGm(cl, "shape", new Class<?>[]{ClassLoader.class}, new Object[]{cl});
            if (shape == null) {
                GmUtil.logOnce("GmPrims.autoColor.shape", "【GmPrims】颜色底：GmBubble.shape 拿到 null");
                return null;
            }
            Object colorObj = callGm(cl, "colorLong", new Class<?>[]{}, new Object[]{});
            long color = (colorObj instanceof Long) ? ((Long) colorObj).longValue() : 0L;
            // 顺手把"底色到底是多少"记下来（排查时最有用的一条）
            GmUtil.logOnce("GmPrims.autoColor.dbg",
                    "【GmPrims】颜色底：color=0x" + Long.toHexString(color)
                            + " shape=" + tn(shape) + " mod=" + tn(mod));
            return background(cl, new Object[]{mod, Long.valueOf(color), shape});
        } catch (Throwable t) {
            GmUtil.logOnce("GmPrims.autoColor", "【GmPrims】颜色底自动入口失败：" + t);
            return null;
        }
    }

    /**
     * 刷子版背景 —— **只给 ClassLoader 和 Modifier**，Brush/形状自己去 GmBubble 取。
     *
     * @return 新的 Modifier；任何一步不行 ⇒ null
     */
    public static Object backgroundAutoBrush(ClassLoader cl, Object mod) {
        try {
            if (mod == null) return null;
            Object shape = callGm(cl, "shape", new Class<?>[]{ClassLoader.class}, new Object[]{cl});
            Object brush = callGm(cl, "imgBrush", new Class<?>[]{ClassLoader.class}, new Object[]{cl});
            if (shape == null || brush == null) {
                GmUtil.logOnce("GmPrims.autoBrush.dep",
                        "【GmPrims】图片底：依赖没就绪 → shape=" + tn(shape) + " brush=" + tn(brush));
                return null;
            }
            GmUtil.logOnce("GmPrims.autoBrush.dbg",
                    "【GmPrims】图片底：shape=" + tn(shape) + " brush=" + tn(brush) + " mod=" + tn(mod));
            return backgroundBrush(cl, new Object[]{mod, brush, shape, Integer.valueOf(0)});
        } catch (Throwable t) {
            GmUtil.logOnce("GmPrims.autoBrush", "【GmPrims】图片底自动入口失败：" + t);
            return null;
        }
    }
}
