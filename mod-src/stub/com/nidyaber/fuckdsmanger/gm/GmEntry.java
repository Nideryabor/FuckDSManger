// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.gm;

import android.app.Activity;

/** 【桩】真身：悬浮条入口，里面存着当前 Activity。
 *  ⚠️ 真身里 sAct 是【包级私有】(`.field static sAct`) —— 桩必须照抄，
 *  否则编译器不会拦你跨包访问，运行期才炸 IllegalAccessError（教训）。 */
public final class GmEntry {
    static Activity sAct;
}
