package com.nidyaber.fuckdsmanger.gm;

/**
 * 【编译期桩】真身 = 跟宿主那份"下发配置文本"打交道的工具。
 *
 * `host()` 取宿主当前存的文本；`hostPut(String)` 写回去。
 * `GmModel.setOn` 就是借它把模型配置里的 `"switchable"` 改掉。
 */
public final class GmPrompt {
    private GmPrompt() {
    }

    /** 取宿主当前存的那份文本。 */
    public static String host() { return null; }

    /** 这份文本能不能动（非空 / 格式对）。 */
    public static boolean ok(String s) { return false; }

    /** 写回宿主。 */
    public static boolean hostPut(String s) { return false; }
}
