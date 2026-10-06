// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 「宿主活了」的一次性钩子 🐲
 *
 * hook 层在 handleLoadPackage 阶段**拿不到 Context**（本环境没有 AndroidAppHelper，教训 88），
 * 所以桥不能在那时候就打通。这里挂在宿主的 Activity.onCreate 上，
 * 等它第一次跑到就把 Context 交给 FdmBridge —— 只做一次（FdmBridge 内部有置位）。
 */
public final class FdmHostReadyHook extends XC_MethodHook {

    @Override
    protected void afterHookedMethod(MethodHookParam param) {
        try {
            Object self = param.thisObject;
            if (self instanceof Context) {
                FdmBridge.onHostReady((Context) self);
            }
        } catch (Throwable ignore) {
            // 桥的事绝不能连累宿主
        }
    }
}
