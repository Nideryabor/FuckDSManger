package com.nidyaber.fuckdsmanger.bridge;

import android.graphics.Bitmap;
import android.util.Log;

import java.lang.reflect.Field;

/**
 * GmFitProbe —— 「AI 气泡图片底缩放」侦察探针 🐲（2026-10-03，**定位完就拆**）
 *
 * <p>★ 2026-10-03 主人定规：**日志走 adb logcat**；私有目录不许写文件。
 * ⇒ 本文档把所有诊断输出改成 {@code android.util.Log}（tag = {@code GMFIT}），
 * 原来那套"写宿主外部文件"的代码**整段删除**。
 *
 * <p>读法（我这边）：
 * <pre>adb shell logcat -d | grep GMFIT</pre>
 * 关键三问：① 钩子进没进（ENTER）；② 认没认出我们这张图（MISS / APPLY）；③ 最终 scale 多少（OK）。
 */
public final class GmFitProbe {

    private static final String TAG = "GMFIT";

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

    /** 进钩子：brush 类 / d 类 / tag。 */
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

    /** 两把钥匙都没配上（⇒ 放行、不缩放）。 */
    public static void miss() {
        line("MISS 两把钥匙都没配上 ⇒ 放行（不缩放）");
    }

    /** 第一通道走到最后：bmp 尺寸 / scale / zoom（配置倍率）/ 目标尺寸。 */
    public static void ok(Bitmap bmp, float scale, float zoom, float tw, float th) {
        try {
            line("OK bmp=" + (bmp == null ? "?" : bmp.getWidth() + "x" + bmp.getHeight())
                    + " scale=" + scale + " zoom=" + zoom + " target=" + tw + "x" + th
                    + " => 最终=" + (scale * zf(zoom)));
        } catch (Throwable ignore) {
        }
    }

    /** 第二通道（im9.a）真正生效：贴上了铺满矩阵。 */
    public static void applied(float scale, int tw, int th, Bitmap bmp) {
        line("APPLY im9.a 生效 scale=" + scale + " target=" + tw + "x" + th
                + " bmp=" + (bmp == null ? "?" : bmp.getWidth() + "x" + bmp.getHeight()));
    }

    /** 第二通道认出了图，但找不到"输入 BitmapShader"。 */
    public static void appliedNoInput(float scale) {
        line("APPLY 认出图但没找到输入 BitmapShader（scale=" + scale + "）");
    }

    private static int sNotOurs = 0;

    /** 第二通道：进了钩子但认不出是我们这张图（限 5 条，防刷屏）。 */
    public static void notOurs(Object d) {
        if (sNotOurs >= 5) {
            return;
        }
        sNotOurs++;
        line("NOTOURS im9.a 里 brush.d=" + (d == null ? "null" : d.getClass().getSimpleName())
                + " 认不出（第 " + sNotOurs + " 条）");
    }

    /** 倍率钳位：zoomF() 已是 1.0 = 100%；防 0/负数。 */
    public static float zf(float z) {
        return (z <= 0.05f) ? 1f : z;
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
