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

    /**
     * 写入。
     *
     * ⚠️⚠️ **参数顺序是「键 → 值 → 类型」，类型在最后！** ⚠️⚠️
     *   底座真身（反编译 `GmStore.smali` 所见）：
     *       write(Context p0, String key p1, String value p2, String type p3)V
     *           if ("b".equals(p3)) ed.putBoolean(p1, parseBoolean(p2));
     *           ...
     *   铁证是 `bak()` 里的调用：`write(ctx, 备份键, 原值, "s")`。
     *
     *   **这里的 Java 签名（编译器看来都是 (Context,String,String,String)）不变，
     *     但历史上注释写成过「(ctx,key,type,val)」，害得桥把值写成了 "s"（3.24/3.25 的真事故）。
     *     照着参数名调，别再照着旧注释调。**
     *
     * type：`b` / `i` / `l` / `f` / `s`（`s` = string；不是 `t`）
     */
    public static void write(Context ctx, String key, String val, String type) {}
}
