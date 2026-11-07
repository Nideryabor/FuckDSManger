// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/**
 * 【FdmOpenUiReceiver】—— 模块侧的「拉界面」入口 🐲
 *
 * <h3>为什么需要它</h3>
 * 宿主进程直接 {@code startActivity} 我们拉不起来，**两层**原因（2026-11-06 真机实证）：
 * <ol>
 *   <li><b>解析层</b>：宿主 targetSdk=36 且清单无 &lt;queries&gt; ⇒ PMS 过滤
 *       ⇒ {@code ActivityNotFoundException}</li>
 *   <li><b>启动层</b>：模块进程在后台 ⇒ BAL（后台启动 Activity）拦截
 *       ⇒ 铁证是我们自己包 {@code SYSTEM_ALERT_WINDOW} 的 {@code rejectTime}
 *         与发广播的时刻分秒对得上</li>
 * </ol>
 *
 * <h3>本类的做法</h3>
 * 收到广播后**不自己拉**，而是：① 在**自己进程**里建 PendingIntent
 * （creator = 我们 ⇒ 解析时用自己的 uid ⇒ 自己的包永远可见 ⇒ 解析层过），
 * ② 把 PI 交给**处于前台的宿主**去 send（启动层过，见 {@link FdmOpenUi#sendFromHost}）。
 *
 * <p>⚠️ 必须走**静态注册**（清单里声明），因为模块进程平时可能根本没起来。
 * <p>⚠️ 本进程**没有 Xposed API** ⇒ 日志走 {@link FdmOpenUi#log}（纯文件），
 *    绝不能用 {@code GmUtil.log}（历史事故：NoClassDefFoundError 直接崩）。
 */
public final class FdmOpenUiReceiver extends BroadcastReceiver {

    /** 宿主 → 模块：请把 Compose UI 拉起来。 */
    public static final String ACTION_OPEN_UI = "com.little_femaleboy.fdm.OPEN_UI";

    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            if (context == null) return;
            String act = intent == null ? null : intent.getAction();
            if (act != null && !ACTION_OPEN_UI.equals(act)) return;

            FdmOpenUi.log("收到 OPEN_UI 广播 ⇒ 走「前台宿主代发 PendingIntent」");
            // ① 主力：请前台宿主代发 PI
            boolean asked = FdmOpenUi.relayViaHost(context, "broadcast");
            // ② 兜底：通知栏（没 POST_NOTIFICATIONS 会被系统静默丢弃，不算失败）
            if (!asked) {
                FdmOpenUi.log("代发没发出去 ⇒ 投兜底通知");
                FdmOpenUi.notifyFallback(context);
            }
        } catch (Throwable t) {
            // 绝不让接收器抛异常（否则 ANR 广播队列）
            FdmOpenUi.log("接收器异常：" + t);
        }
    }
}
