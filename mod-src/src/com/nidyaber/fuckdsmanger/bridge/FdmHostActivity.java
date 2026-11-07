// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;

import de.robv.android.xposed.XposedHelpers;

/**
 * 【FdmHostActivity】拿「当前 Activity」🐲
 *
 * <h3>为什么需要它</h3>
 * 弹 {@code Dialog} **必须**有 Activity（给 Application 会抛
 * {@code BadTokenException: Unable to add window -- token null is not for an application}）。
 * 但我们手里那些 Context 经常**指不到** Activity：
 * <pre>
 *   · 广播接收器给的 Context = ContextImpl（它的 base 是 Application，不是 Activity）
 *   · lambda 捕获的 Context   = 通常是 Application
 * </pre>
 * 血证（2026-11-07）：{@code 【FdmComposeDlg】拿不到 Activity ⇒ 不用 Compose 版}
 * —— 而当时屏幕上明明就开着宿主的设置页。
 *
 * <h3>怎么拿</h3>
 * 走 {@code ActivityThread.currentActivityThread().mActivities} —— 这是 framework 的
 * 字段名，**永远不变**（不像宿主的混淆名会漂）。优先挑 {@code mResumed == true} 的，
 * 没有就挑第一个非空的。
 *
 * <p>⚠️ 只用反射，任何异常都返回 null —— 这个方法在弹窗路径上，不许抛。
 */
public final class FdmHostActivity {

    private FdmHostActivity() {
    }

    /** 当前 Activity；拿不到返回 null。 */
    public static Activity current() {
        try {
            Object thread = XposedHelpers.callStaticMethod(
                    Class.forName("android.app.ActivityThread"), "currentActivityThread");
            if (thread == null) return null;
            Object map = XposedHelpers.getObjectField(thread, "mActivities");
            if (!(map instanceof java.util.Map)) return null;

            Activity first = null;
            for (Object rec : ((java.util.Map<?, ?>) map).values()) {
                if (rec == null) continue;
                Object a;
                try {
                    a = XposedHelpers.getObjectField(rec, "activity");
                } catch (Throwable t) {
                    continue;
                }
                if (!(a instanceof Activity)) continue;
                if (first == null) first = (Activity) a;
                try {
                    Object resumed = XposedHelpers.getObjectField(rec, "mResumed");
                    if (resumed instanceof Boolean && (Boolean) resumed) {
                        return (Activity) a;      // 正在前台的那个，最合适
                    }
                } catch (Throwable ignore) {
                }
            }
            return first;
        } catch (Throwable t) {
            return null;
        }
    }
}
