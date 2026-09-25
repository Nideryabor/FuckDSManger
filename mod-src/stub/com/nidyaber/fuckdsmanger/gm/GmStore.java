package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * 【编译期桩】真身 = 往宿主同一个 MMKV 实例里读写 kv_settings_<key>（本地覆盖层）。
 *
 * 线上铁律：
 *   · 类型必须与宿主读法一致（b=boolean / i=int / l=long / f=float / t=string），
 *     类型不符会**静默读回默认值**
 *   · 拦截下发要用影子键 fuckds_pin_<key>（write/remove 自动镜像），空 = 不干预
 */
public final class GmStore {
    private GmStore() {}

    /** 备份一个键的原值到 fuckds_bak_<key>。 */
    public static void bak(Context ctx, String key, String type) {}

    /** 把所有 kv_ 键 dump 成文本（调试页用）。 */
    public static String dumpAll(Context ctx) { return null; }

    /** 拿到宿主的 MMKV SharedPreferences 实例。 */
    public static SharedPreferences get(Context ctx) { return null; }

    public static String read(Context ctx, String key, String def) { return def; }

    public static String read2(Context ctx, String key, String def) { return def; }

    public static void remove(Context ctx, String key) {}

    public static void restore(Context ctx, String key, String type) {}

    /** 写入。type：b / i / l / f / t */
    public static void write(Context ctx, String key, String type, String val) {}
}
