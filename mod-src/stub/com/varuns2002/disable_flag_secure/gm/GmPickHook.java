package com.varuns2002.disable_flag_secure.gm;

import de.robv.android.xposed.XC_MethodHook;

/** 【编译期桩】真身在模块 dex 里；这里只给签名。 */
public final class GmPickHook extends XC_MethodHook {
    public GmPickHook() {}
}
