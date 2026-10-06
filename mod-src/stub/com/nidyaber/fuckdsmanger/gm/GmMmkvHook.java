// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.gm;
import android.content.Context;
import java.util.List;
/**
 * 【桩】宿主 MMKV 的读拦截器。
 *
 * `handle(key, val)` 在宿主读某个键时被调用 —— 返回替换值（就是"灰度覆盖"生效的地方）。
 * `rows(ctx)` 返回一张**行表**（原 UI 的灰度编辑器很可能就是拿它当数据源 ✅）。
 */
public final class GmMmkvHook {
    private GmMmkvHook() { }
    public static String handle(String key, String val) { return val; }
    public static List<?> rows(Context ctx) { return null; }
}
