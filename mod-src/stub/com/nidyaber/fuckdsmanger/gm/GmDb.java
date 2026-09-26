package com.nidyaber.fuckdsmanger.gm;
import android.content.Context;
/** 【桩】本地防撤回数据库。 */
public final class GmDb {
    private GmDb() { }
    public static boolean isOn(Context c) { return false; }
    public static void setOn(Context c, boolean on) { }
    public static int count(Context c) { return 0; }
    public static long sizeKb(Context c) { return 0L; }
    public static void clear(Context c) { }
}
