// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.ActivityOptions;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * 【FdmOpenUi】从前台宿主「代理」拉起我们的 Compose UI 🐲
 *
 * <h3>为什么需要「代理」（2026-11-06 定案，全程真机实证）</h3>
 *
 * 直接拉（宿主进程 {@code startActivity}）失败，原因**不是**包可见性神话，
 * 而是两层完全不同的东西：
 *
 * <pre>
 * ① 解析层：宿主 targetSdk=36 且清单无 &lt;queries&gt; ⇒ PMS 过滤
 *      → ActivityNotFoundException: Unable to find explicit activity class
 *      （`dumpsys package com.deepseek.chat.a` 的 Queries 段可自证：我们不在里面）
 *
 * ② 启动层：就算解析过了，模块进程**在后台** ⇒ BAL 拦截
 *      （Android 10+ 后台启动 Activity 限制）
 *      → 铁证：`appops get &lt;我们&gt; SYSTEM_ALERT_WINDOW` 的
 *        `rejectTime` 与发广播的时刻**分秒对得上**
 * </pre>
 *
 * ⇒ 两层各有一个正规解法，而且必须**同时**满足：
 *
 * <pre>
 * ① PendingIntent 的 **creator 是我们自己** ⇒ 发送时按**我方 uid** 解析
 *    ⇒ 自己的包永远对自己可见 ⇒ 解析层通过 ✓
 * ② 由**处于前台的宿主**去 send，并带 Android 14 的
 *    ActivityOptions#setPendingIntentCreatorBackgroundActivityStartMode(ALLOWED)
 *    ⇒ 系统知道「发送方在前台、且明确允许 creator（我们是后台）启动」
 *    ⇒ 启动层通过 ✓
 * </pre>
 *
 * <p>这就是「以前台方式拉起来」：**宿主在前台，我们借它的手**。
 * 不需要悬浮窗权限（那条路 appops 不放行，实测 `set` 无效、仍是 default）。
 */
public final class FdmOpenUi {

    private static final String TAG = "FDM-OpenUi";

    /** 我们的 Compose UI。 */
    public static final String UI_ACT = "com.nidyaber.fuckdsmanger.MainActivity";
    /** scheme 兜底（清单里 MainActivity 第二张 intent-filter）。 */
    public static final String UI_URI = "fdm://open";

    /** 宿主侧命令名：请把「我给你的 PendingIntent」发出去。 */
    public static final String CMD_PI = "open_ui_pi";
    /** 命令里携带 PendingIntent 的键。 */
    public static final String EX_PI = "pi";
    /** 命令里携带「谁请求的」（诊断用）。 */
    public static final String EX_FROM = "from";

    private FdmOpenUi() {
    }

    // ------------------------------------------------------------------ 拉 UI

    /** 纯 Intent：显式组件，不带任何奇技淫巧（PI 解析时用它）。 */
    public static Intent uiIntent() {
        Intent i = new Intent(Intent.ACTION_VIEW);
        i.setClassName(FdmBridge.MODULE_PKG, UI_ACT);
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                | Intent.FLAG_ACTIVITY_CLEAR_TOP
                | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        return i;
    }

    /**
     * 第一步：**在模块进程**建 PendingIntent，再请前台宿主代发。
     *
     * @return true ＝ 请求已发出（不代表界面起来了，异步）
     */
    public static boolean relayViaHost(Context ctx, String from) {
        if (ctx == null) return false;
        try {
            int flags = PendingIntent.FLAG_UPDATE_CURRENT;
            if (Build.VERSION.SDK_INT >= 23) flags |= PendingIntent.FLAG_IMMUTABLE;
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, uiIntent(), flags);
            if (pi == null) {
                log("建 PendingIntent 返回 null");
                return false;
            }
            Intent cmd = new Intent(FdmPush.ACTION_CMD);
            cmd.putExtra("cmd", CMD_PI);
            cmd.putExtra(EX_PI, pi);
            cmd.putExtra(EX_FROM, from);
            ctx.sendBroadcast(cmd);
            log("已把 PendingIntent 交给宿主代发（from=" + from + "）");
            return true;
        } catch (Throwable t) {
            log("请求宿主代发失败：" + t);
            return false;
        }
    }

    /**
     * 第二步（跑在**宿主进程**）：由前台的宿主把那个 PI 发出去。
     *
     * <p>关键就是 {@code ActivityOptions#setPendingIntentCreatorBackgroundActivityStartMode}：
     *   API 34（Android 14）新增，正是为「creator 在后台、sender 在前台」这种场景准备的。
     *   <ul>
     *     <li>{@code MODE_BACKGROUND_ACTIVITY_START_ALLOWED} = 1</li>
     *     <li>{@code MODE_BACKGROUND_ACTIVITY_START_SYSTEM_DEFAULT} = 0</li>
     *     <li>{@code MODE_BACKGROUND_ACTIVITY_START_DENIED} = 2</li>
     *   </ul>
     * <p>老系统（&lt;34）没有这个 API ⇒ 直接 send（老系统 BAL 规则宽松得多）。
     */
    public static void sendFromHost(Context ctx, PendingIntent pi) {
        if (ctx == null || pi == null) {
            log("sendFromHost：ctx/pi 为空");
            return;
        }
        Bundle opts = makeAllowOpts();
        try {
            pi.send(ctx, 0, null, null, null, null, opts);
            log("✅ PendingIntent.send 已执行（不抛异常 ≠ 一定起来，要看界面）");
        } catch (Throwable t) {
            log("✗ PendingIntent.send 抛异常：" + t);
        }
    }

    /**
     * 造带上 {@code MODE_BACKGROUND_ACTIVITY_START_ALLOWED} 的 ActivityOptions。
     *
     * <p>⚠️ 这里**故意用反射**，而不是直接写
     *   {@code ao.setPendingIntentCreatorBackgroundActivityStartMode(...)}：
     *   <ul>
     *     <li>写死调用点在老系统上是 {@code NoSuchMethodError} ——
     *         而这个方法要在**钩子热路径**上跑，抛一次就可能把宿主带崩；</li>
     *     <li>反射失败只是「退回系统默认」，相当于没这个开关，可接受。</li>
     *   </ul>
     * <p>字段名/常量值都按 API 34 源码：
     *   {@code MODE_BACKGROUND_ACTIVITY_START_ALLOWED = 1}。
     */
    private static Bundle makeAllowOpts() {
        if (Build.VERSION.SDK_INT < 34) {
            log("API " + Build.VERSION.SDK_INT + " < 34 ⇒ 无该开关，直接用系统默认");
            return null;
        }
        try {
            ActivityOptions ao = ActivityOptions.makeBasic();
            Object v = ao.getClass()
                    .getMethod("setPendingIntentCreatorBackgroundActivityStartMode", int.class)
                    .invoke(ao, 1);
            if (v instanceof ActivityOptions) ao = (ActivityOptions) v;
            log("已带 MODE_BACKGROUND_ACTIVITY_START_ALLOWED（API " + Build.VERSION.SDK_INT + "）");
            return ao.toBundle();
        } catch (Throwable t) {
            log("设置 ALLOWED 失败（退回系统默认）：" + t);
            return null;
        }
    }

    /** 兜底：我们自己（后台）直接拉 —— 预期被 BAL 拒，留作对照实验。 */
    public static void tryDirect(Context ctx, String how) {
        if (ctx == null) return;
        try {
            ctx.startActivity(uiIntent());
            log("[" + how + "] 直接 startActivity 未抛异常");
        } catch (Throwable t) {
            log("[" + how + "] 直接 startActivity 抛异常：" + t);
        }
    }

    /**
     * 最后兜底：通知栏。
     *
     * <p>⚠️ targetSdk 34 需要 POST_NOTIFICATIONS 运行时权限（没有就**静默不显示**），
     *   所以这条只是兜底，主力是 {@link #relayViaHost}。
     *   权限可以用 `adb shell pm grant &lt;包&gt; android.permission.POST_NOTIFICATIONS` 补。
     */
    public static void notifyFallback(Context ctx) {
        if (ctx == null) return;
        try {
            android.app.NotificationManager nm =
                    (android.app.NotificationManager) ctx.getSystemService(Context.NOTIFICATION_SERVICE);
            if (nm == null) return;
            String ch = "fdm_open_ui";
            if (Build.VERSION.SDK_INT >= 26) {
                android.app.NotificationChannel c = new android.app.NotificationChannel(
                        ch, "FDM 界面", android.app.NotificationManager.IMPORTANCE_DEFAULT);
                nm.createNotificationChannel(c);
            }
            int flags = PendingIntent.FLAG_UPDATE_CURRENT;
            if (Build.VERSION.SDK_INT >= 23) flags |= PendingIntent.FLAG_IMMUTABLE;
            PendingIntent pi = PendingIntent.getActivity(ctx, 1, uiIntent(), flags);
            android.app.Notification.Builder b = Build.VERSION.SDK_INT >= 26
                    ? new android.app.Notification.Builder(ctx, ch)
                    : new android.app.Notification.Builder(ctx);
            b.setSmallIcon(android.R.drawable.ic_menu_manage)
                    .setContentTitle("FuckDSManger UI")
                    .setContentText("点这里打开（宿主拉不起来时的兜底）")
                    .setContentIntent(pi)
                    .setAutoCancel(true);
            nm.notify(0x46444d, b.build());
            log("已投递兜底通知（若没有 POST_NOTIFICATIONS 会被系统静默丢弃）");
        } catch (Throwable t) {
            log("兜底通知失败：" + t);
        }
    }

    // ------------------------------------------------------------------ 日志

    /**
     * 模块进程**不能用** {@code GmUtil.log} ——
     * 它内部调 {@code XposedBridge}，而我们自己的 App 进程里没有 Xposed API
     * （历史事故：一点就 `NoClassDefFoundError` ⇒ 崩）。
     *
     * <p>所以这里走纯文件日志：{@code /data/data/&lt;包&gt;/files/openui.log}，
     * 尼尼用 `adb shell run-as &lt;包&gt; cat files/openui.log` 就能读（debuggable=true）。
     */
    public static void log(String msg) {
        String line = new SimpleDateFormat("MM-dd HH:mm:ss.SSS", Locale.US)
                .format(new Date()) + " " + msg;
        Log.i(TAG, line);
        try {
            Context c = FdmApp.get();
            if (c == null) return;
            File f = new File(c.getFilesDir(), "openui.log");
            if (f.length() > 128 * 1024) {
                // 简单滚动，别让日志无限长
                File old = new File(c.getFilesDir(), "openui.log.1");
                if (old.exists()) old.delete();
                f.renameTo(old);
            }
            FileOutputStream fo = new FileOutputStream(f, true);
            OutputStreamWriter w = new OutputStreamWriter(fo, "UTF-8");
            w.write(line);
            w.write('\n');
            w.close();
        } catch (Throwable ignore) {
        }
    }
}
