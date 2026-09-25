package com.varuns2002.disable_flag_secure.gm;

import android.content.Context;

/**
 * 【编译期桩】不是真实现，只提供签名，供 javac 类型检查用。
 * 桩只挂在 -classpath 上，绝不进 dex。
 *
 * 签名来源：模块 smali 里实际出现的调用（`grep -ho 'GmUtil;->...'`），
 * 以及入口类 DisableFlagSecure.handleLoadPackage 里的 envSafe。
 */
public final class GmUtil {
    private GmUtil() {}

    public static void log(String s) {}

    public static void logE(Throwable t) {}

    public static void logFail(String s, Throwable t) {}

    public static void logOnce(String tag, String msg) {}

    public static void envSafe(ClassLoader cl) {}

    public static int dp(Context ctx, int v) { return 0; }

    public static void toast(Context ctx, String s) {}
}
