package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;

/**
 * 【编译期桩】真身 = 气泡配置。
 *
 * ★ 改开关**一定要走这两个 setter**，不要裸写存储：
 *   它们除了写值，还会把内部的「读过了」缓存标志（sRead / sURead）设成已读，
 *   裸写存储只会让缓存里的旧值一直生效（实测栽过：用户气泡拨了不生效）。
 */
public final class GmBubble {
    private GmBubble() {
    }

    /** AI 气泡开关（写 fuckds_bubble_on）。 */
    public static void setOn(Context ctx, boolean on) { }

    /** 用户气泡开关（写 fuckds_ububble_on）。 */
    public static void setUOn(Context ctx, boolean on) { }

    /** 气泡图片保存（宿主侧读我们授权过的 URI）。 */
    public static boolean saveImage(Context ctx, android.net.Uri uri) { return false; }
}
