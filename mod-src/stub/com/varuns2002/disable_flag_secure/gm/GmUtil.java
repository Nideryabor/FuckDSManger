package com.varuns2002.disable_flag_secure.gm;

import android.app.Dialog;
import android.content.Context;
import android.view.View;

/**
 * 【编译期桩】真身在模块 dex 里。签名是从 2.22.110 的 dex 逐个抄下来的（17 个方法）。
 *
 * 配色四件套都是「夜色自适应」的：
 *   tx()   主文字色      sub()  次要文字色
 *   bg()   背景/卡片色   line() 分隔线色
 */
public final class GmUtil {
    private GmUtil() {}

    /** 反射 ActivityThread.currentApplication 拿全局 Context（环境不提供 AndroidAppHelper 时的兜底）。 */
    public static Context app() { return null; }

    public static int bg(Context ctx) { return 0; }

    public static String caller() { return null; }

    public static int dp(Context ctx, int v) { return 0; }

    public static void envSafe(ClassLoader cl) {}

    public static boolean isNight(Context ctx) { return false; }

    public static int line(Context ctx) { return 0; }

    public static void log(String s) {}

    public static void logE(Throwable t) {}

    public static void logFail(String s, Throwable t) {}

    public static void logOnce(String tag, String msg) {}

    /** 给 Dialog 套一层竖向 ScrollView（2.22.24 那套，修「功能被压到下面点不到」）。 */
    public static void sc(Dialog d, View content) {}

    public static String stack() { return null; }

    public static int sub(Context ctx) { return 0; }

    public static void toast(Context ctx, String s) {}

    public static int tx(Context ctx) { return 0; }
}
