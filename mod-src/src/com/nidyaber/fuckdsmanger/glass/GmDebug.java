// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

/**
 * 调试代码总闸 🐲
 *
 * <h3>为什么要有这个文件</h3>
 * 液态玻璃这一轮我加了一堆**只为自己调试用**的东西：
 * <ul>
 *   <li>{@code glass_snap} → 让宿主把自己当前画面写进自己 files 目录（我的"眼睛"）</li>
 *   <li>各种一次性诊断日志</li>
 * </ul>
 * 主人 2026-09-30 交代：「**出正式包记得把自拍删掉**」。
 * 靠人记着不可靠 ⇒ 做成**机械闸门**：
 *
 * <ol>
 *   <li>开关在<b>这个文件</b>里，只有一行；</li>
 *   <li>默认 {@code false}（安全）—— 要用的时候我手动打开，用完关掉；</li>
 *   <li>{@code 做包.sh} <b>会检查它</b>：只要它是 {@code true}，正式包<b>直接拒绝构建</b>
 *       （除非显式加 {@code dev} 参数）。</li>
 * </ol>
 *
 * ⚠️ 改这里的值之前，先想清楚这版是**自己调**还是**要发**。
 */
public final class GmDebug {

    private GmDebug() {
    }

    /**
     * 调试功能总开关。
     *
     * <p>{@code true}  = 自己调：自拍 + 细日志全开
     * <p>{@code false} = 要发：自拍入口直接短路，`glass_snap` 动作不干活
     */
    public static final boolean ENABLED = false;

    /** 出包前自检读的那一行（别改格式，做包.sh 靠它判断）。 */
    public static final String MARKER = "GmDebug.ENABLED";
}
