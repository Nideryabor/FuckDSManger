// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Intent;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 「选文件夹」的回调接收 🐲 2026-11-07
 *
 * <h3>为什么需要它</h3>
 * 本地曲库改成「用户用系统选择器挑一个文件夹」之后，必须**接住那条回调**
 * 才能 {@code takePersistableUriPermission}（否则重启就丢授权）。
 *
 * <h3>为什么挂在框架类上</h3>
 * 挂 {@code android.app.Activity.onActivityResult} —— 名字永远不变。
 * 之前的教训：锚宿主混淆名会静默失效（3.75.x 那一串）。
 *
 * <h3>为什么不跟底座的 GmPickHook 抢</h3>
 * 它只认自己那个 requestCode（{@code 0x435b}，气泡选图）就直接 setResult 吃掉，
 * 别的码原样放行 ⇒ 我们这里只处理 {@link GmLocalMusic#RC_PICK_TREE}，互不影响。
 */
public final class FdmPickResultHook extends XC_MethodHook {

    /** 只装一次 */
    private static volatile boolean sInstalled = false;

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        try {
            XposedHelpers.findAndHookMethod("android.app.Activity", cl,
                    "onActivityResult", int.class, int.class, Intent.class,
                    new FdmPickResultHook());
            sInstalled = true;
            XposedBridge.log("[FDM] 选文件夹回调钩子已挂（Activity.onActivityResult）");
        } catch (Throwable t) {
            XposedBridge.log("[FDM] 选文件夹回调钩子挂载失败：" + t);
        }
    }

    @Override
    protected void beforeHookedMethod(MethodHookParam p) {
        try {
            if (p.args == null || p.args.length < 3) return;
            Object rc = p.args[0];
            Object code = p.args[1];
            Object data = p.args[2];
            if (!(rc instanceof Integer) || !(code instanceof Integer)) return;
            int requestCode = (Integer) rc;
            // ★ 2026-11-07：三个码都要接（选目录 / 导入 / 单曲设置里挑歌词·封面）
            if (requestCode != GmLocalMusic.RC_PICK_TREE
                    && requestCode != GmLocalMusic.RC_IMPORT
                    && requestCode != GmLocalMusic.RC_PICK_LRC
                    && requestCode != GmLocalMusic.RC_PICK_COVER) {
                return;   // 不是我们的事 ⇒ 放行
            }

            Object self = p.thisObject;
            if (!(self instanceof Activity)) return;
            Activity a = (Activity) self;

            boolean handled = GmLocalMusic.onPickResult(a,
                    requestCode, (Integer) code,
                    data instanceof Intent ? (Intent) data : null);
            if (handled) {
                // 我们已经处理完 ⇒ 不让宿主再走它自己的分支（它不认识这个码）
                p.setResult(null);
            }
        } catch (Throwable t) {
            XposedBridge.log("[FDM] 选文件夹回调出错：" + t);
        }
    }
}
