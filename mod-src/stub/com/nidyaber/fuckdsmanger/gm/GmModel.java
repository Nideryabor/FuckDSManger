package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;

/**
 * 【编译期桩】真身 = 模型切换开关。
 *
 * 关键点：`setOn()` **不只是写标志 kv**，它还要把宿主自己的模型配置
 * （`kv_remote_settings_model_configs_v1`）里的 `"switchable"` 改掉、再写回宿主。
 * ⇒ 改这个开关**必须走 setOn**，只往存储里写 `fuckds_model_switch` 是没用的。
 */
public final class GmModel {
    private GmModel() {
    }

    public static boolean isOn(Context ctx) { return false; }

    /** 开/关模型切换（内部：写标志 + 改写宿主模型配置 JSON）。返回是否成功。 */
    public static boolean setOn(Context ctx, boolean on) { return false; }

    /** 按当前标志把模型配置重新应用一遍。 */
    public static boolean reapply(Context ctx) { return false; }
}
