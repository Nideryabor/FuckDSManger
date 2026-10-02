package com.nidyaber.fuckdsmanger.bridge;

import android.graphics.Bitmap;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * GmFitProbe —— 「AI 气泡图片底缩放」侦察探针 🐲（2026-10-03，**定位完就拆**）
 *
 * <p>目的：搞清三件事——① 钩子到底有没有进；② 两把钥匙有没有命中；③ 最终 scale 是多少。
 * 光靠猜已经耗了两轮（"钩子名字 tn0→jq0"看着像凶手，其实是"改没进包"），
 * 这轮不猜了：让它自己说话。
 *
 * <p>落点：**宿主外部文件目录** `files/fdm_fit_diag.txt`
 * （adb uid 2000 属 `ext_data_rw` 组，**免 root 可读**；已实测）。
 * 上限 60 条，超了就砍一半只留最近的。
 */
public final class GmFitProbe {

    private static final Object LOCK = new Object();
    private static final StringBuilder BUF = new StringBuilder();
    private static int N = 0;
    private static int PENDING = 0;

    private GmFitProbe() {
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

    /** 自证①：装钩时写一条 —— 证明「新模块在跑 + 写盘通」。 */
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

    /** 走到最后：bmp 尺寸 / scale / zoom（配置倍率）/ 目标尺寸。 */
    public static void ok(Bitmap bmp, float scale, float zoom, int tw, int th) {
        try {
            line("OK bmp=" + (bmp == null ? "?" : bmp.getWidth() + "x" + bmp.getHeight())
                    + " scale=" + scale + " zoom=" + zoom + " target=" + tw + "x" + th
                    + " => 最终=" + (scale * zf(zoom)));
        } catch (Throwable ignore) {
        }
    }

    /** 倍率钳位：zoomF() 已是 1.0 = 100%；防 0/负数。 */
    public static float zf(float z) {
        return (z <= 0.05f) ? 1f : z;
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
        synchronized (LOCK) {
            try {
                android.content.Context app = context();
                if (app == null) {
                    return;
                }
                File dir = app.getExternalFilesDir(null);
                if (dir == null) {
                    return;
                }
                if (N >= 60) {
                    int cut = BUF.indexOf("\n", BUF.length() / 2);
                    if (cut > 0) {
                        BUF.delete(0, cut + 1);
                    }
                    N = 30;
                }
                BUF.append(++N).append(' ').append(s).append('\n');
                if (++PENDING >= 5) {
                    flush(dir);
                }
            } catch (Throwable ignore) {
            }
        }
    }

    private static void flush(File dir) {
        PENDING = 0;
        try {
            FileOutputStream fo = new FileOutputStream(new File(dir, "fdm_fit_diag.txt"));
            fo.write(BUF.toString().getBytes("UTF-8"));
            fo.close();
        } catch (Throwable ignore) {
        }
    }

    /** 宿主 Context（只为拿外部目录）。
     *
     * <p>★ 2026-10-03：原来只走 {@code ActivityThread.currentApplication()} —— 结果文件一直不出现
     * （探针"哑"了，白白浪费一轮）。现在**先走底座自己的 {@code GmUtil.app()}**
     * （玻璃黑匣子验证过这条路能写、能读），再兜 ActivityThread，最后兜静态 ActivityThread 字段。 */
    private static android.content.Context context() {
        // ① 底座 GmUtil.app()（已验证）
        try {
            Class<?> u = Class.forName("com.nidyaber.fuckdsmanger.gm.GmUtil");
            Object app = u.getMethod("app").invoke(null);
            if (app instanceof android.content.Context) {
                return (android.content.Context) app;
            }
        } catch (Throwable ignore) {
        }
        // ② ActivityThread.currentApplication()
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Object app = at.getMethod("currentApplication").invoke(null);
            if (app instanceof android.content.Context) {
                return (android.content.Context) app;
            }
        } catch (Throwable ignore) {
        }
        // ③ ActivityThread 静态字段 mInitialApplication
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            for (Field f : at.getDeclaredFields()) {
                if (android.content.Context.class.isAssignableFrom(f.getType())) {
                    f.setAccessible(true);
                    Object app = f.get(null);
                    if (app instanceof android.content.Context) {
                        return (android.content.Context) app;
                    }
                }
            }
        } catch (Throwable ignore) {
        }
        return null;
    }
}
