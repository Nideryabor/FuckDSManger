package com.nidyaber.fuckdsmanger.gm;
/** 【桩】诊断日志缓冲（text() 无参；buf() 给的是同一个 StringBuilder）。 */
public final class GmDiag {
    private GmDiag() { }
    public static void log(String s) { }
    public static String text() { return null; }
    public static StringBuilder buf() { return null; }
}
