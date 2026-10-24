// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.graphics.Bitmap;
import android.util.Log;

import java.lang.reflect.Field;

/**
 * GmFitProbe —— 「AI 气泡图片底缩放」侦察探针 🐲（2026-10-03）
 *
 * <p>★ 主人定规（2026-10-03）：**日志走 adb logcat**，不许往私有目录写文件；
 * 探针**保留**——"以后调试说不定有用"（它这轮一次抓出两个真凶：
 * `jq0.b` 的 VerifyError、`im9.a` 的 Size 位模式解码）。
 *
 * <p>读法（我这边）：
 * <pre>adb shell logcat -d -b all | grep -a GMFIT</pre>
 * 三问：① 钩子进没进（ENTER）；② 认没认出我们这张图（MISS / NOTOURS）；③ 缩放多少（APPLY/OK）。
 */
public final class GmFitProbe {

    private static final String TAG = "GMFIT";
    private static int sNotOurs = 0;

    private GmFitProbe() {
    }

    /** 自证①：装钩时写一条 —— 证明「新模块在跑」。 */
    public static void alive() {
        line("ALIVE probe 已装载（装钩时写入）");
    }

    /** 自证②：imgBrush 建图刷子时写一条 —— 证明"我们这张图"这条链在跑。 */
    public static void imgBrush() {
        try {
            Object bmp = staticField("com.nidyaber.fuckdsmanger.gm.GmBubble", "sBmp");
            line("IMGBRUSH sBmp=" + (bmp instanceof Bitmap
                    ? ((Bitmap) bmp).getWidth() + "x" + ((Bitmap) bmp).getHeight() : String.valueOf(bmp)));
        } catch (Throwable t) {
            line("IMGBRUSH ERR " + t);
        }
    }

    /** 进钩子：brush 类 / d 类 / tag（第一通道 jq0.b 用；现已停用但保留）。 */
    public static void enter(Object brush) {
        try {
            StringBuilder sb = new StringBuilder("ENTER brush=");
            sb.append(brush == null ? "null" : brush.getClass().getSimpleName());
            Object d = field(brush, "d");
            sb.append(" d=").append(d == null ? "null" : d.getClass().getSimpleName());
            sb.append(" tag=").append(field(brush, "c"));
            line(sb.toString());
        } catch (Throwable ignore) {
        }
    }

    /** 两把钥匙都没配上（第一通道）。 */
    public static void miss() {
        line("MISS 两把钥匙都没配上 ⇒ 放行（不缩放）");
    }

    /** 第一通道走到最后：bmp / scale / zoom / 目标尺寸。 */
    public static void ok(Bitmap bmp, float scale, float zoom, float tw, float th) {
        try {
            line("OK bmp=" + (bmp == null ? "?" : bmp.getWidth() + "x" + bmp.getHeight())
                    + " scale=" + scale + " zoom=" + zoom + " target=" + tw + "x" + th
                    + " => 最终=" + (scale * zf(zoom)));
        } catch (Throwable ignore) {
        }
    }

    /** 第二通道（im9.a）生效（旧签名，保留）。 */
    public static void applied(float scale, int tw, int th, Bitmap bmp) {
        line("APPLY im9.a 生效 scale=" + scale + " target=" + tw + "x" + th
                + " bmp=" + (bmp == null ? "?" : bmp.getWidth() + "x" + bmp.getHeight()));
    }

    /** 第二通道生效（带锚点 + 调用链 → 一眼分辨"哪次画的是气泡"）。 */
    public static void appliedCtx(float scale, int tw, int th, Bitmap bmp, int anchor) {
        line("APPLY scale=" + scale + " target=" + tw + "x" + th
                + " bmp=" + (bmp == null ? "?" : bmp.getWidth() + "x" + bmp.getHeight())
                + " a=" + anchor + " via" + stackHint());
    }

    /** 第二通道认出了图，但不是 RuntimeShader（没法写制服）。 */
    public static void appliedNoInput(float scale) {
        line("APPLY 认出图但不是 RuntimeShader（scale=" + scale + "）");
    }

    /** 第二通道：进了钩子但认不出是我们这张图（限 5 条，防刷屏）。 */
    public static void notOurs(Object d) {
        if (sNotOurs >= 5) {
            return;
        }
        sNotOurs++;
        line("NOTOURS im9.a 里 brush.d=" + (d == null ? "null" : d.getClass().getSimpleName())
                + " 认不出（第 " + sNotOurs + " 条）");
    }

    /** 倍率钳位：zoomF() 已是 1.0 = 100%；防 0 / 负数。 */
    public static float zf(float z) {
        return (z <= 0.05f) ? 1f : z;
    }

    /** 抓调用链里"宿主那一层"的几帧（跳过 Xposed / 我们自己的帧）。 */
    private static String stackHint() {
        try {
            StackTraceElement[] st = new Throwable().getStackTrace();
            StringBuilder sb = new StringBuilder();
            int n = 0;
            for (StackTraceElement e : st) {
                String c = e.getClassName();
                if (c.startsWith("de.robv") || c.startsWith("com.nidyaber")
                        || c.startsWith("java.lang") || c.startsWith("android.util")) {
                    continue;
                }
                sb.append('|').append(c).append('.').append(e.getMethodName());
                if (++n >= 3) {
                    break;
                }
            }
            return sb.toString();
        } catch (Throwable ignore) {
            return "";
        }
    }

    private static Object staticField(String cls, String name) {
        try {
            Class<?> c = Class.forName(cls);
            Field f = c.getField(name);
            f.setAccessible(true);
            return f.get(null);
        } catch (Throwable ignore) {
            return null;
        }
    }

    private static Object field(Object o, String name) {
        try {
            if (o == null) {
                return null;
            }
            for (Class<?> k = o.getClass(); k != null && k != Object.class; k = k.getSuperclass()) {
                for (Field f : k.getDeclaredFields()) {
                    if (f.getName().equals(name)) {
                        f.setAccessible(true);
                        return f.get(o);
                    }
                }
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    private static void line(String s) {
        try {
            Log.i(TAG, s);
        } catch (Throwable ignore) {
        }
    }
}
