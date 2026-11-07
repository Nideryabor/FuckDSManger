// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Field;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 入口换乘站：「检查更新」 → Compose UI 🐲
 *
 * ── 为什么要挂这一钩 ─────────────────────────────────────────────
 * 底座（2.22.120）里的 {@code GmEntryHook} 抓住宿主设置页那一行「检查更新」之后，
 * 直接调 {@code GmHomeUi.open()} —— 那是**手写 smali 时代的 View 弹窗**。
 * View 路线已经弃用（UI 全部搬进 Compose，见 {@code fdm-app/}），
 * 但底座 dex 是**二进制成品**（128 类），不想为了改一行调用就重造整个底座。
 *
 * ⇒ 那就把 {@code GmHomeUi.open()} **自己**挂上：
 *   ① 先拉起 Compose 的 {@code MainActivity}；
 *   ② 拉起来了 ⇒ {@code setResult(null)} 把旧弹窗**跳过**；
 *   ③ 拉不起来 ⇒ **原样放行**，旧 View UI 顶上（兜底，绝不会「点了没反应」）。
 *
 * ── 为什么不 hook 宿主那一行 ────────────────────────────────────
 * 宿主那行是**混淆过的**（判据是 `getIntField(thisObject, "a") == 0x14`），
 * 锚点随宿主版本漂移；而 {@code GmHomeUi} 是**我们自己的类**，名字永远不变。
 * ⇒ 挂它最稳，宿主升级也不影响这一钩。
 *
 * 跑在**宿主进程**（由 {@link FdmEntry} 在 handleLoadPackage 里装）。
 */
public final class FdmUiHook {

    /** 底座里那个旧 View 主页（换乘对象）。 */
    private static final String OLD_UI = "com.nidyaber.fuckdsmanger.gm.GmHomeUi";
    /** 底座 dex 里存着「当前宿主 Activity」的那个类。
     *  ⚠️ 注意：底座里有**两个** `GmEntry` ——
     *    · `com.nidyaber.fuckdsmanger.GmEntry`     = 入口（handleLoadPackage）
     *    · `com.nidyaber.fuckdsmanger.gm.GmEntry`  = **存 `sAct` 的是这个**
     *  3.13.0 我写错过一次，日志里是 `NoSuchFieldError`，靠兜底 `ActivityThread.currentApplication()` 才起来。 */
    private static final String BASE_ENTRY = "com.nidyaber.fuckdsmanger.gm.GmEntry";

    /** 我们的 Compose UI。 */
    private static final String UI_ACT = "com.nidyaber.fuckdsmanger.MainActivity";
    /** 模块侧的「自拉起」广播接收器（清单里静态声明）。 */
    private static final String OPEN_UI_RCVR = "com.nidyaber.fuckdsmanger.bridge.FdmOpenUiReceiver";
    /** 宿主 → 模块：请把 Compose UI 拉起来。 */
    public static final String ACTION_OPEN_UI = FdmOpenUiReceiver.ACTION_OPEN_UI;
    /** scheme 兜底通道（清单里 MainActivity 第二张 intent-filter 接的就是它）。 */
    private static final String UI_URI = "fdm://open";

    private static volatile boolean sInstalled = false;

    private FdmUiHook() {
    }

    /**
     * 装上「入口换乘」这一钩。
     *
     * ★ 幂等 + **不误置位**：找不到 {@code GmHomeUi}（＝不在宿主进程 / 底座没这份类）
     *   就直接静默返回，**不把 sInstalled 置真** —— 否则第一次在错进程里空跑一次，
     *   后面真正该装的那次就被自己挡掉了。
     *
     * 任何失败都只记日志，**绝不影响宿主**。
     */
    public static void install(ClassLoader cl) {
        if (sInstalled) return;

        Class<?> oldUi;
        try {
            oldUi = XposedHelpers.findClass(OLD_UI, cl);
        } catch (Throwable t) {
            return;                     // 不在宿主进程 ⇒ 不是错误，静默跳过
        }

        try {
            XposedHelpers.findAndHookMethod(oldUi, "open", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        if (openCompose(FdmUiHook.class.getClassLoader())) {
                            // void 方法 ⇒ 原方法体不再执行 = 旧 View 弹窗被跳过
                            p.setResult(null);
                        }
                    } catch (Throwable t) {
                        GmUtil.logFail("【FdmUiHook】换乘失败（放行旧 UI）", t);
                    }
                }
            });
            sInstalled = true;
            GmUtil.log("【FdmUiHook】已接管「检查更新」→ Compose UI ✓");
            XposedBridge.log("[FDM] 已接管「检查更新」→ Compose UI ✓");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmUiHook】挂载失败（保留旧 View UI）", t);
            XposedBridge.log("[FDM] FdmUiHook 挂载失败（保留旧 View UI）：" + t);
        }
    }

    // ------------------------------------------------------------------ 内部

    /**
     * @return true ＝ Compose UI 已拉起（调用方应当跳过旧弹窗）
     */
    private static boolean openCompose(ClassLoader cl) {
        Context ctx = hostContext(cl);
        if (ctx == null) {
            GmUtil.log("【FdmUiHook】拿不到宿主 Context ⇒ 不换乘，走旧 UI");
            return false;
        }
        return openComposeImpl(ctx);
    }

    /**
     * 诊断入口：宿主进程里由 CMD {@code open_ui} 调用（尼尼自己用 adb 触发，
     * 不用求主人去点「检查更新」）。
     *
     * <p>先打三条「宿主视角的事实」，再走一遍完整换乘链 —— 这样一次就能分清
     * 「包看不见」是事实还是我上次的误判。
     */
    public static void probeFromCmd(Context ctx) {
        try {
            GmUtil.log("【FdmUiHook】=== probe 开始 ===");
            try {
                android.content.pm.PackageInfo pi = ctx.getPackageManager()
                        .getPackageInfo(FdmBridge.MODULE_PKG, 0);
                GmUtil.log("【FdmUiHook】probe PM.getPackageInfo ✓ " + pi.versionName
                        + "(" + pi.versionCode + ")");
            } catch (Throwable t) {
                GmUtil.log("【FdmUiHook】probe PM.getPackageInfo ✗ " + t);
            }
            try {
                android.content.pm.ActivityInfo ai = ctx.getPackageManager().getActivityInfo(
                        new ComponentName(FdmBridge.MODULE_PKG, UI_ACT), 0);
                GmUtil.log("【FdmUiHook】probe PM.getActivityInfo ✓ exported=" + ai.exported);
            } catch (Throwable t) {
                GmUtil.log("【FdmUiHook】probe PM.getActivityInfo ✗ " + t);
            }
            try {
                Intent li = ctx.getPackageManager().getLaunchIntentForPackage(FdmBridge.MODULE_PKG);
                GmUtil.log("【FdmUiHook】probe getLaunchIntentForPackage = " + li);
            } catch (Throwable t) {
                GmUtil.log("【FdmUiHook】probe getLaunchIntentForPackage ✗ " + t);
            }
            boolean ok = openComposeImpl(ctx);
            GmUtil.log("【FdmUiHook】=== probe 结束：链尾返回 " + ok + " ===");
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】probe 崩了：" + t);
        }
    }

    /**
     * 公开入口：**在宿主的钩子里**（有 Context）拉起 Compose UI。
     *
     * <p>为什么要有这个薄壳：{@link FdmUpdateRowHook} 也要用同一条换乘链，
     * 而 {@code openComposeImpl} 是 private。留一个 public 门，别复制粘贴第二份链路
     * （复制就会漂移 —— 本项目已经因为"两处各读一次开关"栽过）。
     */
    public static boolean openComposeFromHook(Context ctx) {
        try {
            return openComposeImpl(ctx);
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】openComposeFromHook 异常：" + t);
            return false;
        }
    }

    /**
     * 换乘链本体（有 Context 就能跑 ⇒ 可以脱离 hook 单独诊断）。
     */
    private static boolean openComposeImpl(Context ctx) {

        // ① 显式 ComponentName —— 最稳
        //    （清单里 <application android:forceQueryable="true"> + MainActivity exported=true
        //      ⇒ 宿主看得见我们这个包，显式拉起是允许的）
        Intent i = new Intent(Intent.ACTION_VIEW);
        i.setComponent(new ComponentName(FdmBridge.MODULE_PKG, UI_ACT));
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        if (start(ctx, i, "显式")) return true;

        // ② scheme trampoline —— 兜底（隐式 + setPackage 收敛到我们包）
        Intent t = new Intent(Intent.ACTION_VIEW, Uri.parse(UI_URI));
        t.setPackage(FdmBridge.MODULE_PKG);
        t.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (start(ctx, t, "scheme")) return true;

        // ③ 广播换乘（显式组件）⇒ 模块侧建 PendingIntent，请**前台的宿主**代发
        //
        //   为什么需要它（2026-11-06 全程真机实证，两层原因互不相干）：
        //     ① 解析层：宿主 targetSdk=36 且清单无 <queries> ⇒ PMS 过滤
        //          probe PM.getPackageInfo / getActivityInfo → NameNotFoundException
        //          getLaunchIntentForPackage → null
        //        （主人后来在「隐藏应用列表」里放行，这一层才通）
        //     ② 启动层：模块进程在后台 ⇒ BAL 拦截
        //          铁证 = 我们自己包 SYSTEM_ALERT_WINDOW 的 rejectTime
        //          与发请求的时刻分秒对得上
        //   而 PendingIntent 的 creator 是我们 ⇒ 解析走我方 uid（自己的包永远可见），
        //   sender 是前台宿主 + MODE_BACKGROUND_ACTIVITY_START_ALLOWED ⇒ 两层同时过。
        //
        //   ⚠️ 3.75.22 那次「广播无效」是误判：真因是 build_single.py 里那段
        //      receiver 插入被注释掉了（还没写得对），清单里根本没声明 ⇒
        //      `dumpsys` 自然查不到、`am broadcast` 自然 result=0。
        //      后来又发现 `<receiver>` 用 new_elem() 写会把 intent-filter 变成兄弟节点，
        //      PMS 直接丢掉 ⇒ 已加 check_manifest_tree() 机械闸门。
        GmUtil.log("【FdmUiHook】显式/scheme 都没通 ⇒ 走广播，请前台宿主代发 PendingIntent");
        boolean asked = askModuleToOpen(ctx);
        if (asked) {
            // ★ 乐观跳过旧 UI —— 但**必须**有看门狗：
            //   广播是异步的，`sendBroadcast` 不抛异常 ≠ 接收器跑了 ≠ UI 起来了。
            //   3.75.22 就是「发出去就当成功」⇒ 旧 UI 被吞掉、新 UI 又没起来 ⇒
            //   表现成「点了没反应」（比弹旧 UI 更糟）。
            //   兜底判据：1.2 秒后看**我们模块的进程还在不在** ——
            //     进程都没起 ⇒ 广播根本没送到 ⇒ 老老实实补弹旧 UI。
            //     （进程在 = 接收器至少跑了；若进程在但被 BAL 拦，模块侧的
            //       openui.log 会留下痕迹，尼尼事后能查。）
            watchdogFallback(ctx);
        }
        return asked;
    }

    /**
     * 1.2 秒后复查：模块进程没起来就补弹旧 UI，绝不留「点了没反应」。
     *
     * <p>为什么不用「同步等回执」：回执广播由接收器投递，而接收器要跑在
     * **主线程 Looper** 上；这里本身就阻塞住主线程，等回执必然死等到超时。
     * ⇒ 只能异步看门狗。
     */
    private static void watchdogFallback(final Context ctx) {
        try {
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    try {
                        if (moduleAlive(ctx)) {
                            GmUtil.log("【FdmUiHook】看门狗：模块进程在 ✓ 不补弹旧 UI");
                            return;
                        }
                        GmUtil.log("【FdmUiHook】看门狗：模块进程没起 ⇒ 补弹旧 View UI");
                        XposedHelpers.callStaticMethod(
                                XposedHelpers.findClass(
                                        "com.nidyaber.fuckdsmanger.gm.GmMenuDialog",
                                        FdmUiHook.class.getClassLoader()),
                                "open");
                    } catch (Throwable t) {
                        GmUtil.log("【FdmUiHook】看门狗补弹失败：" + t);
                    }
                }
            }, 1200L);
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】看门狗没装上：" + t);
        }
    }

    /** 我们模块的进程在不在（不需要任何权限，只查自己的 uid 名）。 */
    private static boolean moduleAlive(Context ctx) {
        try {
            android.app.ActivityManager am = (android.app.ActivityManager)
                    ctx.getSystemService(Context.ACTIVITY_SERVICE);
            if (am == null) return true;      // 查不了 ⇒ 别误判，宁可相信它活着
            java.util.List<android.app.ActivityManager.RunningAppProcessInfo> ps =
                    am.getRunningAppProcesses();
            if (ps == null) return true;
            for (android.app.ActivityManager.RunningAppProcessInfo p : ps) {
                if (FdmBridge.MODULE_PKG.equals(p.processName)) return true;
            }
            return false;
        } catch (Throwable t) {
            return true;                       // 异常 ⇒ 不误伤
        }
    }

    /**
     * 广播给模块侧的 {@link FdmOpenUiReceiver}，由它自己 startActivity。
     *
     * <p>⚠️ 用 {@code sendBroadcast} 不带 package 限定也能到（静态注册 + exported），
     *   但显式 {@code setPackage} 更稳、也避免别的应用收到。
     * <p>⚠️ **必须带 {@link Intent#FLAG_INCLUDE_STOPPED_PACKAGES}**：
     *   模块如果处于 stopped 状态（长时间没跑 / 被系统或厂商管家清过），
     *   默认的广播会被系统直接丢弃，静态 receiver 根本收不到 ——
     *   这正是「广播发了 4 次、模块进程一次都没起」的根因。
     * <p>⚠️ 返回值只代表「广播已发出」，**不代表 UI 起来了**（异步）。
     */
    private static boolean askModuleToOpen(Context ctx) {
        try {
            Intent b = new Intent(ACTION_OPEN_UI);
            // ★ 显式组件比 setPackage 更硬：不经过 intent-filter 解析，
            //   也绝不可能被别的应用的同名 action 抢走。
            b.setComponent(new ComponentName(FdmBridge.MODULE_PKG, OPEN_UI_RCVR));
            b.addFlags(Intent.FLAG_INCLUDE_STOPPED_PACKAGES
                    | Intent.FLAG_RECEIVER_FOREGROUND);
            ctx.sendBroadcast(b);
            GmUtil.log("【FdmUiHook】已广播（显式组件）请求模块侧拉起 UI ⇒ " + OPEN_UI_RCVR);
            return true;
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】广播失败：" + t);
            return false;
        }
    }

    private static boolean start(Context ctx, Intent i, String how) {
        try {
            ctx.startActivity(i);
            GmUtil.log("【FdmUiHook】已拉起 Compose UI ✓（" + how + "）");
            return true;
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】" + how + " 拉起失败：" + t);
            return false;
        }
    }

    /**
     * 拿宿主 Context。
     *
     * 首选 {@code GmEntry.sAct}（底座存着「当前 Activity」，最准）；
     * 它是**包级私有**字段 ⇒ 必须 setAccessible（这是踩过的坑：
     * `IllegalAccessError: Field … is inaccessible`）。
     * 兜底走 {@code ActivityThread.currentApplication()}。
     */
    private static Context hostContext(ClassLoader cl) {
        try {
            Class<?> e = XposedHelpers.findClass(BASE_ENTRY, cl);
            Field f = XposedHelpers.findField(e, "sAct");
            f.setAccessible(true);
            Object o = f.get(null);
            if (o instanceof Context) return (Context) o;
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】取 GmEntry.sAct 失败：" + t);
        }
        try {
            Object app = XposedHelpers.callStaticMethod(
                    Class.forName("android.app.ActivityThread"), "currentApplication");
            if (app instanceof Context) return (Context) app;
        } catch (Throwable ignore) {
        }
        return null;
    }
}
