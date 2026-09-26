package com.nidyaber.fuckdsmanger.gm;
import android.content.Context;
/** 【桩】设备身份伪装。reset() 无参、返回新 id。 */
public final class GmDevice {
    private GmDevice() { }
    public static boolean isOn() { return false; }
    public static void setOn(Context ctx, boolean on) { }
    public static String reset() { return null; }
}
