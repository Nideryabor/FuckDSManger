// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;

import java.io.File;
import java.io.FileWriter;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.Map;
import java.util.WeakHashMap;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 气泡背景 · v1（从零重起的第一块）🐲
 *
 * <h3>为什么是这几个点（全部来自 2.7.2 的真实静态分析，不是猜）</h3>
 *
 * <pre>
 * okb.e   = UserChatMessageBubble (UserChatMessageBubble.kt:261)
 *   vcc.B(mod, t82.t)                       ← ★ 气泡专用裁剪形状（全宿主仅 2 处引用）
 *   Leo3.i.a                                ← ★ 主题色里的「气泡色」
 *   x98.t(mod, color, vcc.n)   ⇒ new yi0    ← ★ 背景元素
 *   l23.n(MessageBubbleLayout) → l23.m(ContentLayer)  ⇒ yi0.b() ⇒ new zi0   ← ★ 绘制节点
 *   zi0.<draw>(DrawScope)                   ⇒ 真正画出来
 * </pre>
 *
 * <h3>为什么绘制期改、不改组合期</h3>
 * Compose 的重组判据是编译期常量（{@code zi9.R} 里 {@code if (any(e)) return 同一个)}），
 * 外部替换 Composable 入参不会触发重画 —— 这一条已经实证过不止一次。
 * 而 {@code zi0} 的绘制节点每帧都会走，改它的底色字段必定生效，且**形状/裁剪/圆角全交给宿主自己算**，
 * 我们一个像素都不碰，风险最低。
 *
 * <h3>怎么认出「这就是用户气泡」（唯一且有依据）</h3>
 * {@code t82.t} 这个 Shape 在 2.7.2 全宿主只有 2 处真实引用，都在 UserChatMessageBubble.kt 里。
 * 所以：<b>同一个线程里，clip(t82.t) 之后紧接着 new 出来的 yi0，就是气泡底色</b>。
 * 这个元素再经 {@code yi0.b()} 变成 {@code zi0} 绘制节点 —— 给它打记号，绘制时按记号认人。
 *
 * <h3>日志（重要）</h3>
 * 不写 dsm.log（那个在宿主私有目录，外面读不到）。这里直接写宿主的外部目录：
 * {@code /sdcard/Android/data/<宿主包>/files/fdm-bubble.log} —— adb 能直接 pull。
 */
public final class GmBubbleBg {

    private GmBubbleBg() {
    }

    // ── 2.7.2 宿主里的落点（全部套 try，找不到就安全退出，绝不牵连宿主）──
    /** 背景元素（Modifier.Element）。字段 a=J 颜色 / b=Brush / c=F alpha / d=Shape。 */
    private static final String CLS_ELEM = "yi0";
    /** 绘制节点（Modifier.Node）。字段 o=J 颜色 / p=Brush / q=F alpha / r=Shape。 */
    private static final String CLS_NODE = "zi0";
    /** 绘制节点的基类（Modifier.Node）。用来精确挑 b()/d()，避免误挂 hashCode()。 */
    private static final String CLS_NODEBASE = "xj7";
    /** 气泡专用裁剪 Shape 的常量所在类。 */
    private static final String CLS_SHAPEHOLDER = "t82";
    /** 上面那个 Shape 的字段名。 */
    private static final String FLD_BUBBLE_SHAPE = "t";
    /** clip(Modifier, Shape) 所在类 / 方法。 */
    private static final String CLS_MOD = "vcc";
    private static final String MTH_CLIP = "B";

    // ── 配置键（影子键风格）──
    private static final String K_ON = "fuckds_bubble_bg_on";
    private static final String K_COLOR = "fuckds_bubble_bg_color";
    private static final String K_ALPHA = "fuckds_bubble_bg_alpha";

    // ── 运行时状态 ──
    /** t82.t 那个 Shape 的实例（用于 identity 比对）。 */
    private static volatile Object sClipShape;
    /** 已确认是气泡底色的 yi0 元素。 */
    private static final Map<Object, Boolean> sElem =
            Collections.synchronizedMap(new WeakHashMap<Object, Boolean>());
    /** 已确认是气泡底色的 zi0 绘制节点。 */
    private static final Map<Object, Boolean> sNode =
            Collections.synchronizedMap(new WeakHashMap<Object, Boolean>());
    /** 「刚 clip 完气泡形状，下一个 yi0 就是它」——同线程传递。 */
    private static final ThreadLocal<Boolean> sPending = new ThreadLocal<Boolean>();
    /** 强引用 hook，防被 GC（踩过）。 */
    private static volatile XC_MethodHook sHookClip, sHookCtor, sHookB, sHookD, sHookDraw;

    private static volatile boolean sLogged = false;
    private static volatile int sTagged = 0;
    private static volatile int sPainted = 0;
    private static volatile int sEnter = 0;

    // 日志
    private static final java.util.Set<String> sSeen = new java.util.HashSet<String>();
    private static final int MAX_LINES = 80;

    // ═══════════════════════════ 安装 ═══════════════════════════

    public static void install(ClassLoader cl) {
        try {
            doInstall(cl);
        } catch (Throwable t) {
            log("install 失败: " + t);
        }
    }

    private static void doInstall(ClassLoader cl) {
        log("=== 气泡背景 v1 开始安装 ===");

        // ① 先拿到气泡专用 Shape 的实例（后面靠 identity 认人）
        try {
            Class<?> sh = XposedHelpers.findClass(CLS_SHAPEHOLDER, cl);
            sClipShape = XposedHelpers.getStaticObjectField(sh, FLD_BUBBLE_SHAPE);
            log("① 气泡裁剪 Shape = " + (sClipShape == null ? "null" : sClipShape.getClass().getName()));
        } catch (Throwable t) {
            log("① 拿 Shape 失败（后面会认不出气泡）: " + t);
            return;
        }
        if (sClipShape == null) {
            log("① Shape 是 null，终止");
            return;
        }

        // ② clip(Modifier, Shape)：见到气泡形状就立个「下一个 yi0 是气泡」的旗
        try {
            Class<?> mod = XposedHelpers.findClass(CLS_MOD, cl);
            for (Method m : mod.getDeclaredMethods()) {
                if (!MTH_CLIP.equals(m.getName())) continue;
                Class<?>[] p = m.getParameterTypes();
                if (p.length != 2) continue;
                if (!p[0].isInterface()) continue;      // Modifier
                sHookClip = new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) {
                        try {
                            if (param.args != null && param.args.length == 2
                                    && param.args[1] == sClipShape) {
                                sPending.set(Boolean.TRUE);
                            }
                        } catch (Throwable ignore) {
                        }
                    }
                };
                XposedBridge.hookMethod(m, sHookClip);
                log("② 挂上 clip: " + m.getName() + "(" + p[0].getName() + "," + p[1].getName() + ")");
                break;
            }
        } catch (Throwable t) {
            log("② 挂 clip 失败: " + t);
        }

        // ③ yi0 构造：紧跟在 clip 之后 → 这个元素就是气泡底色
        try {
            Class<?> elem = XposedHelpers.findClass(CLS_ELEM, cl);
            sHookCtor = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        if (sPending.get() == null) return;
                        sPending.remove();
                        Object self = param.thisObject;
                        if (self == null) return;
                        sElem.put(self, Boolean.TRUE);
                        int n = ++sTagged;
                        if (n <= 6) {
                            log("③ 认到气泡元素 #" + n + " @"
                                    + Integer.toHexString(System.identityHashCode(self)));
                        }
                    } catch (Throwable ignore) {
                    }
                }
            };
            XposedBridge.hookAllConstructors(elem, sHookCtor);
            log("③ 挂上 " + CLS_ELEM + " 构造");
        } catch (Throwable t) {
            log("③ 挂 yi0 构造失败: " + t);
        }

        // ④ yi0.b() → 造出 zi0；yi0.d(zi0) → 把配置推给已存在的 zi0
        try {
            Class<?> elem = XposedHelpers.findClass(CLS_ELEM, cl);
            sHookB = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        if (param.thisObject == null || param.getResult() == null) return;
                        if (!sElem.containsKey(param.thisObject)) return;
                        sNode.put(param.getResult(), Boolean.TRUE);
                        if (sTagged <= 6) log("④ 节点已记号");
                    } catch (Throwable ignore) {
                    }
                }
            };
            // 只挂「0 参、返回 Modifier.Node 基类」的那个（= b()）。不许误挂 hashCode()。
            for (Method m : elem.getDeclaredMethods()) {
                if (m.getParameterTypes().length != 0) continue;
                if (!CLS_NODEBASE.equals(m.getReturnType().getName())) continue;
                XposedBridge.hookMethod(m, sHookB);
            }
            sHookD = new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) {
                    try {
                        if (param.thisObject == null) return;
                        if (!sElem.containsKey(param.thisObject)) return;
                        if (param.args == null || param.args.length != 1 || param.args[0] == null) return;
                        sNode.put(param.args[0], Boolean.TRUE);
                    } catch (Throwable ignore) {
                    }
                }
            };
            // 只挂「1 参、void、参数是 Modifier.Node 基类」的那个（= d(xj7)）。
            for (Method m : elem.getDeclaredMethods()) {
                if (m.getParameterTypes().length != 1 || m.getReturnType() != void.class) continue;
                if (!CLS_NODEBASE.equals(m.getParameterTypes()[0].getName())) continue;
                XposedBridge.hookMethod(m, sHookD);
            }
            log("④ 挂上 yi0 的 取节点/推配置");
        } catch (Throwable t) {
            log("④ 挂 yi0 派生失败: " + t);
        }

        // ⑤ zi0 的绘制方法：1 参 + void + 参数像 DrawScope
        try {
            Class<?> node = XposedHelpers.findClass(CLS_NODE, cl);
            int n = 0;
            for (Method m : node.getDeclaredMethods()) {
                if (m.getReturnType() != void.class) continue;
                if (m.getParameterTypes().length != 1) continue;
                Class<?> p0 = m.getParameterTypes()[0];
                if (p0.isPrimitive() || p0.isArray()) continue;
                try {
                    m.setAccessible(true);
                } catch (Throwable ignore) {
                }
                XposedBridge.hookMethod(m, new DrawHook());
                n++;
                log("⑤ 挂上绘制候选: " + m.getName() + "(" + p0.getName() + ")");
            }
            log("⑤ 共 " + n + " 个");
        } catch (Throwable t) {
            log("⑤ 挂绘制失败: " + t);
        }

        log("=== 安装完成 ===");
    }

    // ═══════════════════════════ 绘制期接管 ═══════════════════════════
    //
    // ★ 3.74.3 重写：**不再改 zi0.o（Compose 颜色）**。
    //   3.74.2 直接写 o = 0xFF5B8DEF 让宿主崩了，铁证：
    //     IllegalArgumentException: Invalid ID: 46
    //       at android.graphics.ColorSpace.get
    //       at android.graphics.Paint.setColor
    //       at y1c.c → zi9.a0 → zi0.J0
    //   原因（读宿主 smali 得到）：zi9.Y(J) 里 `if ((value & 0x3F) > 0xF) return value;`
    //   —— Compose 的 Color 把 **colorSpace id 藏在低 6 位**，我瞎编一个 long 就撞进非法 id。
    //
    //   改成：**直接拿 android.graphics.Canvas 自己画**。链路（全部实测自 2.7.2）：
    //     DrawScope(ah6).a:Lco1  →  co1.a:Lbo1  →  bo1.c:Lao1(impl=wc)  →  wc.a:android.graphics.Canvas
    //   而 okb.e 早把 clip(t82.t) 挂在**上层** Modifier 上 ⇒ 这里画整块矩形会被宿主自动裁成气泡形状，
    //   所以连圆角/Path 都不用自己算。

    /** 取 DrawScope 背后的 android Canvas。取不到就 null。 */
    private static Object canvasOf(Object scope) {
        try {
            Object co1 = XposedHelpers.getObjectField(scope, "a");      // co1 = DrawContext
            if (co1 == null) return null;
            Object bo1 = XposedHelpers.getObjectField(co1, "a");        // bo1
            if (bo1 == null) return null;
            Object cv = XposedHelpers.getObjectField(bo1, "c");         // ao1 实现 = wc
            if (cv == null) return null;
            return XposedHelpers.getObjectField(cv, "a");               // ★ android.graphics.Canvas
        } catch (Throwable t) {
            return null;
        }
    }

    /** 取 DrawContext 里的打包 Size（高 32=宽，低 32=高，float 位）。 */
    private static long sizePackOf(Object scope) {
        try {
            Object co1 = XposedHelpers.getObjectField(scope, "a");
            Object bo1 = XposedHelpers.getObjectField(co1, "a");
            return XposedHelpers.getLongField(bo1, "d");
        } catch (Throwable t) {
            return 0L;
        }
    }

    private static final class DrawHook extends XC_MethodHook {
        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            try {
                if (param.thisObject == null) return;
                if (!sNode.containsKey(param.thisObject)) return;
                if (param.args == null || param.args.length != 1) return;
                Object scope = param.args[0];
                if (!looksLikeDrawScope(scope)) return;
                int ent = ++sEnter;
                boolean on = cfgOn();
                long argb = wantColor();
                if (ent <= 6 || on) {
                    long sz = sizePackOf(scope);
                    float w = Float.intBitsToFloat((int) (sz >> 32));
                    float h = Float.intBitsToFloat((int) sz);
                    note(ent, on, w, h, scope);
                }
                if (!on || argb == 0L) return;
                if (sPainted >= PAINT_MAX) {
                    if (!sCapLogged) {
                        sCapLogged = true;
                        log("已画满 " + PAINT_MAX + " 次，停止（防重刷屏）");
                    }
                    return;
                }
                Object canvas = canvasOf(scope);
                if (canvas == null) {
                    if (!sNoCanvasLogged) {
                        sNoCanvasLogged = true;
                        log("✗ 拿不到 Canvas（链路变了），本次不画");
                    }
                    return;
                }
                long sz = sizePackOf(scope);
                float w = Float.intBitsToFloat((int) (sz >> 32));
                float h = Float.intBitsToFloat((int) sz);
                if (w <= 0f || h <= 0f) return;

                android.graphics.Canvas cv = (android.graphics.Canvas) canvas;
                int save = cv.save();
                try {
                    android.graphics.Paint p = sPaint;
                    if (p == null) {
                        p = new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG);
                        p.setStyle(android.graphics.Paint.Style.FILL);
                        sPaint = p;
                    }
                    p.setColor((int) argb);
                    cv.drawRect(0f, 0f, w, h, p);      // 外层的 clip(t82.t) 会把它裁成气泡形状
                    int n = ++sPainted;
                    if (n <= 5) log("✅ 已画 #" + n + "  0x" + Long.toHexString(argb)
                            + "  区域=" + Math.round(w) + "x" + Math.round(h));
                } finally {
                    cv.restoreToCount(save);
                }
            } catch (Throwable t) {
                int f = ++sFail;
                if (f <= 3) log("✗ 绘制异常 #" + f + ": " + t);
            }
        }
    }

    private static volatile android.graphics.Paint sPaint;
    private static final int PAINT_MAX = 4000;
    private static volatile boolean sCapLogged = false;
    private static volatile boolean sNoCanvasLogged = false;
    private static volatile int sFail = 0;

    /** 每次绘制都记一条（去重后最多 MAX_LINES 行）。 */
    private static void note(int ent, boolean on, float w, float h, Object scope) {
        try {
            Object self = null;
            long keyish = System.identityHashCode(scope);
            String wh = Math.round(w) + "x" + Math.round(h);
            String key = wh + "|" + on + "|" + keyish;
            synchronized (sSeen) {
                if (sSeen.size() >= MAX_LINES || !sSeen.add(key)) return;
            }
            log((on ? "★" : "·") + " 气泡绘制#" + ent + " 开关=" + on + " 尺寸=" + wh);
        } catch (Throwable ignore) {
        }
    }

    /** 真·DrawScope 的指纹：0 参返回 long（打包 Size）+ 0 参返回 float（density）。 */
    private static boolean looksLikeDrawScope(Object o) {
        if (o == null) return false;
        boolean size = false, dens = false;
        try {
            for (Method m : o.getClass().getMethods()) {
                if (m.getParameterTypes().length != 0) continue;
                if (m.getReturnType() == long.class) size = true;
                else if (m.getReturnType() == float.class) dens = true;
                if (size && dens) return true;
            }
        } catch (Throwable ignore) {
        }
        return false;
    }

    /** DrawScope 里 0 参返回 long 的那个就是打包的 Size（高 32=宽，低 32=高，都是 float 位）。 */
    private static String sizeOf(Object scope) {
        if (scope == null) return "?";
        try {
            for (Method m : scope.getClass().getMethods()) {
                if (m.getParameterTypes().length != 0) continue;
                if (m.getReturnType() != long.class) continue;
                m.setAccessible(true);
                long v = (Long) m.invoke(scope);
                float w = Float.intBitsToFloat((int) (v >> 32));
                float h = Float.intBitsToFloat((int) v);
                return Math.round(w) + "x" + Math.round(h);
            }
        } catch (Throwable ignore) {
        }
        return "?";
    }

    // ═══════════════════════════ 配置 ═══════════════════════════

    private static boolean cfgOn() {
        try {
            Context c = GmUtil.app();
            if (c == null) return false;
            String v = GmStore.read2(c, K_ON, "b");
            if (v == null) return false;
            v = v.trim();
            return "true".equalsIgnoreCase(v) || "1".equals(v);
        } catch (Throwable t) {
            return false;
        }
    }

    /** 返回 Compose 的 Color long（sRGB：低 32 位就是 ARGB）。0 = 没配。 */
    private static long wantColor() {
        try {
            Context c = GmUtil.app();
            if (c == null) return 0L;
            String sv = GmStore.read2(c, K_COLOR, "i");
            int argb = 0;
            if (sv != null && sv.trim().length() > 0) {
                try {
                    argb = (int) Long.parseLong(sv.trim());
                } catch (Throwable ignore) {
                    argb = 0;
                }
            }
            if (argb == 0) return 0L;
            int alpha = 255;
            String sa = GmStore.read2(c, K_ALPHA, "i");
            if (sa != null && sa.trim().length() > 0) {
                try {
                    int a = Integer.parseInt(sa.trim());
                    alpha = Math.max(0, Math.min(100, a)) * 255 / 100;
                } catch (Throwable ignore) {
                    alpha = 255;
                }
            }
            argb = (argb & 0x00FFFFFF) | (alpha << 24);
            return argb & 0xFFFFFFFFL;
        } catch (Throwable t) {
            return 0L;
        }
    }

    // ═══════════════════════════ 日志（写到 adb 能读的地方）═══════════════════════════

    private static volatile File sLogFile;
    private static volatile boolean sLogInit = false;

    private static void log(String s) {
        // ★ 先走模块老通道（→ XposedBridge.log → logcat tag=FDM）。
        //   安装期 Application 还没建好，getExternalFilesDir 拿不到 Context，
        //   所以这里**绝不能**因为 Context 为 null 就 return —— 那会把安装期的日志全吞掉。
        try {
            GmUtil.log(s);
        } catch (Throwable ignore) {
        }
        // 再尽力写一份到宿主外部目录（adb 可读，方便事后翻）
        try {
            Context c = GmUtil.app();
            if (c == null) return;
            File f = sLogFile;
            if (f == null) {
                if (sLogInit) return;
                sLogInit = true;
                try {
                    File dir = c.getExternalFilesDir(null);
                    if (dir == null) return;
                    if (!dir.exists()) dir.mkdirs();
                    f = new File(dir, "fdm-bubble.log");
                    sLogFile = f;
                } catch (Throwable t) {
                    return;
                }
            }
            FileWriter w = new FileWriter(f, true);
            try {
                w.write(s);
                w.write('\n');
            } finally {
                w.close();
            }
        } catch (Throwable ignore) {
        }
    }
}
