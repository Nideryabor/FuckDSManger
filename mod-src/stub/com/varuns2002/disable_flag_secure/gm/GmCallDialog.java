package com.varuns2002.disable_flag_secure.gm;

/**
 * 【编译期桩】@ 只用到 sHookInfo 这一个字段。
 */
public class GmCallDialog {

    /** hook 自检串（hkAdd 往这里累加）。注意：非 final，模块运行期会写它。 */
    public static String sHookInfo;
}
