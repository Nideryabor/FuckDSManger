// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.AlertDialog;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 【FdmUpdatePopupHook】拦「检查更新」的两个**弹窗** 🐲
 *
 * <h3>为什么拦弹窗，而不是拦业务（三圈血证换来的）</h3>
 * 追了一整晚，宿主那条链是这样的：
 * <pre>
 *   点击 → lq2.z（协程）→ wh5.c（协程，首行 instance-of Luh5）
 *        → fy2.a（协程，Lec3 参数）→ dx9.z（协程）→ …
 * </pre>
 * <b>每一层都是 Kotlin 协程状态机</b> —— 这是编译器把整条业务链编成状态机的
 * 结果，「非协程的本体」在结构上**不存在**。而在协程里动手脚，我踩了三次坑：
 * <ol>
 *   <li>在 lambda 体 {@code setResult(Unit)} ⇒ 调用者 {@code sj0.h} 判定
 *       "没挂起" ⇒ <b>无限循环</b>，Toast 一直弹；</li>
 *   <li>在外层 {@code sj0.h} 吞掉 resume ⇒ 宿主逻辑确实不跑，但
 *       <b>状态机字段已被推进</b>，想重放时走"恢复"分支 ⇒ 什么都不弹；</li>
 *   <li>复位 stage 再重放 ⇒ {@code this.g/this.i} 里的上下文也变了，救不回来。</li>
 * </ol>
 *
 * <h3>于是换到「效果层」</h3>
 * 抓包（{@code 抓包/ProxyPin11-7_09_44_03.har}）已证明：
 * <pre>
 *   GET /api/v0/check_client_update?scenario=check_update
 *   响应 {"biz_data": null}      ← 没新版 ⇒ 弹 Toast「当前已是最新版本」
 *   响应 biz_data 带版本          ← 有新版 ⇒ 弹「发现新版本，是否立即更新？」
 * </pre>
 * 主人要的语义：「<b>点宿主那行 ⇒ 拦住更新弹窗；点我们弹窗里的检查更新 ⇒ 放行</b>」
 * ⇒ 直接拦这两个**弹窗**：跟协程毫无关系，不会碰任何状态机。
 *
 * <h3>实现</h3>
 * <ul>
 *   <li>{@code Toast.show()} —— 文案含「已是最新版本」就吞掉；</li>
 *   <li>{@code Dialog.show()} —— AlertDialog 的标题/正文含「发现新版本」就 dismiss；</li>
 *   <li>放行额度 {@link #allowOnce()}：我们自己的弹窗点了「检查更新」时登记一次，
 *       让<b>下一次</b>弹窗正常出现。</li>
 * </ul>
 *
 * <p>⚠️ 热路径：两个 hook 都套 try/catch，<b>绝不许外抛</b>。
 */
public final class FdmUpdatePopupHook {

    private static volatile boolean sInstalled = false;

    /**
     * 放行截止时刻（毫秒时间戳）。{@code > now} 表示"现在处于放行窗口内"。
     *
     * <p>★ 2026-11-07 从「计数」改成「时间窗」——frida 栈血证：
     * 重放确实跑通了（{@code runHostOriginal → sj0.h → pg7.z → ol2.j → getString}），
     * 而且 `pg7.z e=22 f=0 → 挂起 → f=1 恢复 → e=23 f=0 取到字符串` 说明
     * <b>网络请求真跑完了</b>。那一整段要好几秒，而按次数的额度早被别的
     * Toast 消耗掉了 ⇒ 宿主真正那句提示反被我们自己拦掉 ⇒「没有吐司」。
     *
     * <p>⇒ 改成时间窗：点一次「检查更新」，接下来 20 秒内**所有**更新弹窗一律放行。
     * 网络慢一点、宿主多弹一次，都不会再被误杀。
     */
    private static volatile long sAllowUntil = 0L;

    /** 打开放行窗口（我们弹窗里点「检查更新」时调用）。 */
    public static void allowForAWhile() {
        sAllowUntil = System.currentTimeMillis() + 20_000L;
        log("已打开放行窗口 20s（宿主接下来的提示都会正常显示）");
    }

    /** 兼容旧调用名。 */
    public static void allowOnce() {
        allowForAWhile();
    }

    // ------------------------------------------------------------------ 判据

    /** Toast 文案是不是「当前已是最新版本」。 */
    private static boolean isUpToDateToast(CharSequence t) {
        if (t == null) return false;
        return t.toString().contains("最新版本");
    }

    /** 对话框标题/正文是不是「发现新版本」。 */
    private static boolean isNewVersionDialog(CharSequence... parts) {
        for (CharSequence p : parts) {
            if (p == null) continue;
            String s = p.toString();
            if (s.contains("发现新版本") || s.contains("立即更新")) return true;
        }
        return false;
    }

    /** 当前是否处于放行窗口内（是 ⇒ 这次弹窗放过去）。 */
    private static boolean inAllowWindow() {
        return System.currentTimeMillis() < sAllowUntil;
    }

    // ------------------------------------------------------------------ 安装

    public static void install(ClassLoader cl) {
        log("install 进入（sInstalled=" + sInstalled + " cl=" + cl + "）");
        if (sInstalled) return;
        hookToast(cl);
        hookDialog(cl);
        sInstalled = true;
        log("install 结束（sInstalled=" + sInstalled + "）");
    }

    /** 拦 Toast「当前已是最新版本」。 */
    private static void hookToast(ClassLoader cl) {
        try {
            Class<?> toast = XposedHelpers.findClass("android.widget.Toast", cl);
            XposedHelpers.findAndHookMethod(toast, "show", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        CharSequence t = null;
                        try {
                            Object o = XposedHelpers.callMethod(p.thisObject, "getText");
                            if (o instanceof CharSequence) t = (CharSequence) o;
                        } catch (Throwable ignore) {
                        }
                        if (!isUpToDateToast(t)) return;
                        if (inAllowWindow()) {
                            log("放行「" + t + "」（窗口内）");
                            return;
                        }
                        p.setResult(null);      // show() 是 void
                        log("已拦下宿主 Toast：「" + t + "」");
                    } catch (Throwable ignore) {
                    }
                }
            });
            log("✅ 已挂 Toast.show（拦「已是最新版本」）");
        } catch (Throwable t) {
            log("✗ Toast hook 失败：" + t);
        }
    }

    /** 拦「发现新版本，是否立即更新？」对话框。 */
    private static void hookDialog(ClassLoader cl) {
        try {
            Class<?> dlg = XposedHelpers.findClass("android.app.Dialog", cl);
            XposedHelpers.findAndHookMethod(dlg, "show", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        Object self = p.thisObject;
                        if (!(self instanceof AlertDialog)) return;   // 只管 AlertDialog
                        final AlertDialog ad = (AlertDialog) self;
                        // ⚠️ 不能用 android.R.id.alertTitle —— 编译用的 android.jar
                        //    里没有这个常量（它是内部 id）。
                        //    ⇒ 直接把 DecorView 里所有 TextView 的文案拼起来扫一遍，
                        //      既稳又不依赖任何资源 id。
                        StringBuilder sb = new StringBuilder();
                        try {
                            android.view.Window w = ad.getWindow();
                            if (w != null) collectText(w.getDecorView(), sb);
                        } catch (Throwable ignore) {
                        }
                        if (!isNewVersionDialog(sb.toString())) return;
                        if (inAllowWindow()) {
                            log("放行「发现新版本」对话框（窗口内）");
                            return;
                        }
                        p.setResult(null);
                        try {
                            ad.dismiss();
                        } catch (Throwable ignore) {
                        }
                        log("已拦下「发现新版本」对话框（文案=" + sb + "）");
                    } catch (Throwable ignore) {
                    }
                }
            });
            log("✅ 已挂 Dialog.show（拦「发现新版本」）");
        } catch (Throwable t) {
            log("✗ Dialog hook 失败：" + t);
        }
    }

    /** 递归收集 View 树里所有 TextView 的文案（判据用，不修改任何东西）。 */
    private static void collectText(android.view.View v, StringBuilder out) {
        if (v == null || out.length() > 512) return;
        if (v instanceof android.widget.TextView) {
            CharSequence t = ((android.widget.TextView) v).getText();
            if (t != null && t.length() > 0) out.append(t).append('\u0001');
        }
        if (v instanceof android.view.ViewGroup) {
            android.view.ViewGroup g = (android.view.ViewGroup) v;
            for (int i = 0; i < g.getChildCount(); i++) collectText(g.getChildAt(i), out);
        }
    }

    private static void log(String msg) {
        String line = "【FdmUpdatePopup】" + msg;
        try {
            GmUtil.log(line);
        } catch (Throwable ignore) {
        }
        try {
            android.util.Log.e("FDM-Popup", line);
        } catch (Throwable ignore) {
        }
        try {
            XposedBridge.log("[FDM] " + line);
        } catch (Throwable ignore) {
        }
    }
}
