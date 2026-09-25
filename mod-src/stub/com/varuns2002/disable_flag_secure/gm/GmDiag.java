package com.varuns2002.disable_flag_secure.gm;

/** 【编译期桩】真身 = 内存 DIAG 缓冲（模块「调试页」读它）。 */
public final class GmDiag {
    private GmDiag() {}

    public static void log(String s) {}
}
