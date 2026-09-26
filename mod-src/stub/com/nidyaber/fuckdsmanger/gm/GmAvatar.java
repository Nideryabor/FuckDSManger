package com.nidyaber.fuckdsmanger.gm;
import android.content.Context;
import android.net.Uri;
/** 【桩】助手图片（共用 fuckds_gm ⇒ 必须走 setOn）。 */
public final class GmAvatar {
    private GmAvatar() { }
    public static boolean isOn(Context c) { return false; }
    public static void setOn(Context c, boolean on) { }
    public static boolean hasImage(Context c) { return false; }
    public static boolean saveImage(Context c, Uri u) { return false; }
}
