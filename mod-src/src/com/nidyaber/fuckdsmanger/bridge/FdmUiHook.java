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

    /** 这次 GmHomeUi.open 是不是底座 GmEntryHook 调的？（栈里有它就说明是） */
    private static boolean fromBaseHook() {
        try {
            StackTraceElement[] st = new Throwable().getStackTrace();
            for (StackTraceElement el : st) {
                String cn = el.getClassName();
                if (cn.contains("GmEntryHook")) return true;
            }
        } catch (Throwable ignore) {
        }
        return false;
    }

    private static volatile boolean sToastFiltered = false;

    /**
     * 压掉底座 GmEntryHook 那句「FDS: check-update row hit」吐司。
     *
     * <p>它和 GmHomeUi.open 是成对的：判据失效 ⇒ 吐司和弹窗都是误触发，两个都得拦。
     * 只拦弹窗的话，用户会看到一句莫名其妙的英文吐司。
     */
    private static void installToastFilter(ClassLoader cl) {
        if (sToastFiltered) return;
        try {
            Class<?> u = XposedHelpers.findClass("com.nidyaber.fuckdsmanger.gm.GmUtil", cl);
            // ★★★ 2026-11-08 修「FDS: check-update row hit 吐司还在」：
            //
            //  报错铁证（lspd 日志）：
            //    NoSuchMethodError: GmUtil#toast[Context, CharSequence]#exact
            //  而底座真实签名是：
            //    .method public static toast(Landroid/content/Context;Ljava/lang/String;)V
            //  ⇒ 参数类型差一个（String vs CharSequence）就 NoSuchMethodError。
            //    Xposed 的 findAndHookMethod 是**精确匹配**，不会自动挑"兼容"的重载。
            //
            //  修法：**先按 String 挂**；万一将来底座改成 CharSequence，
            //  再退一步按 CharSequence 挂（两个都试，谁成算谁）。
            XC_MethodHook filter = new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        Object a = (p.args == null || p.args.length < 2) ? null : p.args[1];
                        String str = a == null ? "" : String.valueOf(a);
                        if (str.contains("check-update row hit")) {
                            GmUtil.log("【FdmUiHook】压掉底座误触发吐司：" + str);
                            p.setResult(null);
                        }
                    } catch (Throwable ignore) {
                    }
                }
            };
            boolean hooked = false;
            try {
                XposedHelpers.findAndHookMethod(u, "toast",
                        android.content.Context.class, String.class, filter);
                hooked = true;
            } catch (Throwable t1) {
                try {
                    XposedHelpers.findAndHookMethod(u, "toast",
                            android.content.Context.class, CharSequence.class, filter);
                    hooked = true;
                } catch (Throwable t2) {
                    GmUtil.log("【FdmUiHook】toast 两种重载都挂不上：String=" + t1 + " / CharSequence=" + t2);
                }
            }
            if (!hooked) {
                sToastFiltered = false;
                return;
            }
            sToastFiltered = true;
            GmUtil.log("【FdmUiHook】底座误触发吐司已过滤（重载="
                    + (hooked ? "ok" : "?") + "）");
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】吐司过滤装不上（不影响主流程）：" + t);
        }
    }

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
                        // ★★★ 2026-11-07 · **误触发诊断（决定要不要继续换乘）**
                        //
                        //  底座 `GmEntryHook` 挂 `m5.v`，判据是 `getIntField(obj,"a") == 0x14`，
                        //  命中就 toast + `GmHomeUi.open()`。
                        //  但 2.7.5 上 `m5` → `lp9`，而 `lp9.j` 的 case 0x14 = `list.add(...)`
                        //  ⇒ 复制 / 重新生成 / 删除对话（任何走 add 的）都会跳到这里。
                        //
                        //  这里把「谁调进来的」完整栈打出来：如果栈里有 GmEntryHook，
                        //  就说明是底座在误触发，而不是用户真的点了「检查更新」。
                        try {
                            StackTraceElement[] st = new Throwable().getStackTrace();
                            StringBuilder b = new StringBuilder();
                            boolean fromBaseHook = false;
                            int n = 0;
                            for (StackTraceElement el : st) {
                                String cn = el.getClassName();
                                if (cn.startsWith("de.robv")) continue;
                                if (cn.contains("GmEntryHook")) fromBaseHook = true;
                                b.append(" <- ").append(cn).append('.').append(el.getMethodName());
                                if (++n >= 10) break;
                            }
                            if (fromBaseHook) {
                                GmUtil.log("【FdmUiHook】⚠️ GmHomeUi.open 来自底座 GmEntryHook 误触发"
                                        + "（不是用户点了检查更新）栈=" + b);
                            }
                        } catch (Throwable ignore) {
                        }
                        // ★★★ 2026-11-07 · **误触发就彻底吞掉，两边都不弹**
                        //
                        //  底座 GmEntryHook 的判据 `getIntField(obj,"a")==0x14` 在 2.7.5 已失效
                        //  （lp9.j case 0x14 = `list.add`）⇒ 复制/重新生成/删除对话都会进来。
                        //  这时如果还去 openCompose ⇒ 跳到模块页（主人报的 bug）；
                        //  如果放行 ⇒ 弹手写 smali 时代的旧 View UI（更糟）。
                        //  ⇒ 正确做法：**识别出"来自底座误触发"就什么都不做**，
                        //     并且 setResult 让旧 UI 也不执行。
                        if (fromBaseHook()) {
                            GmUtil.log("【FdmUiHook】底座 GmEntryHook 误触发（a==0x14 已失效）"
                                    + " ⇒ 吞掉，不弹任何 UI");
                            p.setResult(null);
                            return;
                        }
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
            installUiOpenedReceiver(cl);
            installToastFilter(cl);
        } catch (Throwable t) {
            GmUtil.logFail("【FdmUiHook】挂载失败（保留旧 View UI）", t);
            XposedBridge.log("[FDM] FdmUiHook 挂载失败（保留旧 View UI）：" + t);
        }
    }

    // ------------------------------------------------------------------ UI 开了没

    /** 我们的 MainActivity 已经 resume 过（本进程内看到的）。 */
    private static volatile boolean sUiOpened = false;
    /** 最近一次收到 UI_OPENED 的时刻（配合 sUiOpened 做时间窗判定）。 */
    private static volatile long sUiOpenedAt = 0L;
    /** 上次"发起拉起"的时刻（挡重复触发）。 */
    private static volatile long sLastLaunchAt = 0L;
    private static volatile boolean sRecvInstalled = false;

    /**
     * 装「UI 真的起来了」的回报接收器（**宿主进程**侧）。
     *
     * <p>判据来源：模块进程的 {@code FdmApp} 注册了 ActivityLifecycleCallbacks，
     * 我们的 MainActivity 一 resume 就发 {@link FdmPush#ACTION_UI_OPENED}。
     *
     * <p>为什么不能用"没抛异常"当判据：{@code startActivity} /
     * {@code sendBroadcast} / {@code PendingIntent.send} **全都不抛异常**，
     * 而界面可能根本不在屏幕上（BAL / 包可见性 / ROM 静默拦截）。
     * 那种"静默失败"对主人来说就是「点了没反应」—— 最没法自查的一种。
     */
    private static void installUiOpenedReceiver(ClassLoader cl) {
        if (sRecvInstalled) return;
        try {
            Context ctx = hostContext(cl);
            if (ctx == null) {
                // ★ 2026-11-07 修：宿主进程里拿不到 Context 也**不能默默放弃** ——
                //   之前这里 `return;` 而 sRecvInstalled 仍是 false，下一次进来还会再试，
                //   但**如果整个进程生命周期都拿不到**，看门狗就永远收不到 UI_OPENED
                //   ⇒ 界面明明起来了还弹保底（真机日志：模块 19:34:41.492 回报，
                //     宿主 19:34:42.958 判"没收到"）。留一行日志，至少查得到。
                XposedBridge.log("[FDM] UI_OPENED 接收器：暂时拿不到 Context ⇒ 等下次 install 机会");
                return;
            }
            // ★★ 关键：ContextImpl 必须换成 **Application** 去注册。
            //
            //   血证（2026-11-07）：`【FdmUiHook】已接管「检查更新」` 这条日志**只出现在
            //   模块进程（16766）**，宿主进程（16358）一次都没有 —— 因为
            //   `FdmEntry` 里那条 `FdmUiHook.install` 调用**包在 `if (isHost(...))` 里面**，
            //   而 `install()` 自身又以"能不能找到 GmHomeUi"为门槛（GmHomeUi 是我们
            //   自己的类，宿主进程里**没有**）。
            //   ⇒ 于是宿主侧的 UI_OPENED 接收器**从来没有注册过**，
            //     `sUiOpened` 恒为 false，看门狗必然误判、必然误弹保底。
            //   现在 installUiOpenedReceiver 由 FdmUpdateJumpHook 单独调用（不带门槛），
            //   且用 Application 注册（生命周期最长，不会随某个 Activity 死掉）。
            Context reg = ctx.getApplicationContext();
            if (reg == null) reg = ctx;
            android.content.BroadcastReceiver r = new android.content.BroadcastReceiver() {
                @Override
                public void onReceive(Context c, Intent it) {
                    sUiOpened = true;
                    sUiOpenedAt = System.currentTimeMillis();
                    GmUtil.log("【FdmUiHook】收到 UI_OPENED ⇒ 界面确实起来了 ✓");
                }
            };
            android.content.IntentFilter f = new android.content.IntentFilter(FdmPush.ACTION_UI_OPENED);
            if (android.os.Build.VERSION.SDK_INT >= 33) {
                reg.registerReceiver(r, f, Context.RECEIVER_EXPORTED);
            } else {
                reg.registerReceiver(r, f);
            }
            sRecvInstalled = true;
            GmUtil.log("【FdmUiHook】UI_OPENED 接收器已挂（宿主侧，看门狗从此可靠）");
            XposedBridge.log("[FDM] UI_OPENED 接收器已挂（宿主侧）");
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】UI_OPENED 接收器挂载失败：" + t);
            XposedBridge.log("[FDM] UI_OPENED 接收器挂载失败：" + t);
        }
    }

    /**
     * 供其他钩子调用：**无条件**把「UI 真的起来了」接收器装上（不依赖 GmHomeUi 是否存在）。
     *
     * <p>为什么要单独开门：{@link #install} 的前置条件是"能找到 GmHomeUi"
     * （那是我们自己的类，只在**模块进程**里有）⇒ 宿主进程永远走不到那一行，
     * 接收器永远不注册。这条 public 门让 {@code FdmUpdateJumpHook} 在宿主进程里
     * 单独把接收器装上。
     */
    public static void ensureUiOpenedReceiver(ClassLoader cl) {
        installUiOpenedReceiver(cl);
    }

    /** 我们的 UI 是否**已经**在屏幕上（最近 3 秒内收到过 UI_OPENED）。 */
    public static boolean uiJustOpened() {
        return sUiOpened
                && (System.currentTimeMillis() - sUiOpenedAt) < 3000L;
    }

    // ══════════════════════════════════════════════════════════════════
    //  「宿主是不是被顶到后台了」—— 拉起成败的**主判据**
    //
    //  主人 2026-11-07 提的判据（比查进程可靠得多）：
    //      拉起 1 秒后**宿主还在前台** ⇒ 模块 UI 没把宿主挤下去 ⇒ 拉起失败
    //      拉起 1 秒后**宿主已在后台** ⇒ 有东西顶到前面来了     ⇒ 按成功处理
    //
    //  为什么这个判据比"查模块进程在不在"强：
    //    · 模块进程"在"≠ 界面在屏幕上（进程只是被广播唤醒，UI 可能压根没起来）
    //    · 反过来说，界面起来了，模块进程当然也在 —— 所以"进程在"这个条件几乎
    //      永远成立 ⇒ 它作为判据等于**恒真**，保底弹窗会被吞掉（实测就是这样：
    //      `保底看门狗：1.5s 内没收到 UI_OPENED ⇒ 走带检测的保底` 之后**什么都没弹**）。
    //    · 而"宿主被顶到后台"这件事**只可能**由「真的有 Activity 启动」导致
    //      ⇒ 它是拉起成功的**充分佐证**，且不需要任何权限、不依赖时序假设。
    //
    //  实现：宿主自己 Activity 的 onPause 时置真（FdmHostActivity 已经存了当前
    //  Activity，这里直接注册 ActivityLifecycleCallbacks）。**零权限、零反射。**
    // ══════════════════════════════════════════════════════════════════

    /** 宿主的某个 Activity 进入 onPause（说明有东西盖到它上面 / 它切后台了）。 */
    private static volatile boolean sHostPaused = false;
    /** 最近一次 onPause 的时刻。 */
    private static volatile long sHostPausedAt = 0L;
    private static volatile boolean sLifecycleHooked = false;

    /**
     * 装「宿主 Activity 生命周期」监听（拿 onPause 当"被顶下去"的信号）。
     *
     * <p><b>必须尽早装</b>：要在**拉起之前**就能收到 onPause 回调。
     *
     * <h3>为什么这里要"重试"而不是一次就放弃（2026-11-07 实测踩的）</h3>
     * 本方法由 `FdmEntry.handleLoadPackage` 在**很早期**调用，
     * 那一刻宿主的 `Application` 可能还没 `attachBaseContext` 完
     * ⇒ `hostContext()` 返回 null ⇒ 如果就此 `return`，
     * **整个进程生命周期再也不会重装** ⇒ `sHostPaused` 恒为 false
     * ⇒ 判据永远认为"宿主还在前台" ⇒ 每次都误弹保底。
     *
     * <p>所以：拿不到 Context 就挂一个 `Activity.onResume` 的钩子，
     * **第一次有 Activity resume 时自己补装**（那时 Application 必然已就绪）。
     * 整条路幂等，重复调用无副作用。
     */
    public static void installHostLifecycleWatch(final ClassLoader cl) {
        if (sLifecycleHooked) return;
        try {
            Context ctx = hostContext(cl);
            if (ctx == null) {
                registerRetryOnResume(cl);
                return;
            }
            if (tryHookApplication(cl, ctx)) return;
            registerRetryOnResume(cl);
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】宿主生命周期监听挂载失败（退回旧判据）：" + t);
            registerRetryOnResume(cl);
        }
    }

    /** 真正去挂 Application 的生命周期回调；成功返回 true。 */
    private static boolean tryHookApplication(final ClassLoader cl, Context ctx) {
        try {
            Context app = ctx.getApplicationContext();
            if (app == null) app = ctx;

            Class<?> appCls = Class.forName("android.app.Application", false, cl);
            if (!appCls.isInstance(app)) return false;

            final Class<?> cbCls = Class.forName(
                    "android.app.Application$ActivityLifecycleCallbacks", false, cl);
            Object cb = java.lang.reflect.Proxy.newProxyInstance(
                    cl, new Class<?>[]{cbCls}, new java.lang.reflect.InvocationHandler() {
                        @Override
                        public Object invoke(Object proxy, java.lang.reflect.Method m, Object[] a) {
                            try {
                                String n = m.getName();
                                if ("onActivityPaused".equals(n)) {
                                    // ★ 关键信号：宿主的 Activity 被盖住了
                                    sHostPaused = true;
                                    sHostPausedAt = System.currentTimeMillis();
                                } else if ("onActivityResumed".equals(n)) {
                                    sHostPaused = false;
                                }
                            } catch (Throwable ignore) {
                            }
                            return null;    // 所有回调都是 void
                        }
                    });
            appCls.getMethod("registerActivityLifecycleCallbacks", cbCls).invoke(app, cb);
            sLifecycleHooked = true;
            GmUtil.log("【FdmUiHook】宿主 Activity 生命周期监听已挂（onPause = 被顶下去）");
            XposedBridge.log("[FDM] 宿主生命周期监听已挂");
            return true;
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】tryHookApplication 失败：" + t);
            return false;
        }
    }

    /**
     * 拿不到 Context 时的补救：挂 `Activity.onResume`，第一次 resume 时补装。
     *
     * <p>为什么选 onResume：它是**框架类**（`android.app.Activity`，名字永不变），
     * 一定挂得上；而且第一次 resume 时 `Application` 必然已经 attach 完。
     */
    private static void registerRetryOnResume(final ClassLoader cl) {
        if (sRetryHooked) return;
        try {
            XposedHelpers.findAndHookMethod("android.app.Activity", cl, "onResume",
                    new XC_MethodHook() {
                        @Override
                        protected void afterHookedMethod(MethodHookParam p) {
                            if (sLifecycleHooked) return;
                            try {
                                Object act = p.thisObject;
                                if (act instanceof Context) {
                                    if (tryHookApplication(cl, (Context) act)) return;
                                }
                            } catch (Throwable ignore) {
                            }
                        }
                    });
            sRetryHooked = true;
            GmUtil.log("【FdmUiHook】生命周期监听：已排队（等第一次 Activity.onResume 补装）");
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】onResume 补装卸载失败：" + t);
        }
    }

    /** onResume 补装只装一次。 */
    private static volatile boolean sRetryHooked = false;

    /** 宿主是否**被顶到后台/被盖住**过（最近 5 秒内有过 onPause 且之后没再 resume）。 */
    public static boolean hostWasPushedBack() {
        if (!sHostPaused) return false;
        return (System.currentTimeMillis() - sHostPausedAt) < 5000L;
    }

    /**
     * 保底决策（**主人 2026-11-07 定的判据**）。
     *
     * <p>在"拉起后延迟 1 秒"的时刻调用：
     * <pre>
     *   宿主被顶到后台（或收到过 UI_OPENED）  ⇒ 拉起成功 ⇒ **不弹**
     *   宿主还在前台                          ⇒ 拉起失败 ⇒ 弹
     * </pre>
     *
     * @return true ＝ 应当弹保底
     */
    public static boolean shouldShowFallback(Context ctx) {
        try {
            if (uiJustOpened()) {
                GmUtil.log("【FdmUiHook】判据：收到 UI_OPENED ⇒ 拉起成功，不弹");
                return false;
            }
            if (hostWasPushedBack()) {
                GmUtil.log("【FdmUiHook】判据：宿主已被顶到后台（"
                        + (System.currentTimeMillis() - sHostPausedAt) + "ms 前 onPause）"
                        + " ⇒ 按拉起成功处理，不弹");
                return false;
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】判据异常（按\"失败\"处理）：" + t);
        }
        GmUtil.log("【FdmUiHook】判据：宿主仍在前台、也没收到 UI_OPENED ⇒ 拉起失败，弹保底");
        return true;
    }

    /**
     * 【兼容旧调用】== {@code shouldShowFallback(ctx)}，只是名字反过来。
     *
     * <p>⛔ 旧的 {@code moduleAlive(ctx)} 判据已**废弃**：模块进程只要被广播唤醒过就是"在"，
     * 而保底弹窗恰恰是在"进程刚被唤醒、UI 还没画出来"时触发的
     * ⇒ 那个判据在实战里等于**恒真**，保底会被永久吞掉
     * （实测：`保底看门狗：1.5s 内没收到 UI_OPENED ⇒ 走带检测的保底` 之后什么都没弹）。
     * <p>新判据见 {@link #shouldShowFallback}：**看宿主有没有被顶到后台**。
     */
    public static boolean moduleLooksAbsent(Context ctx) {
        return shouldShowFallback(ctx);
    }

    /**
     * 弹保底（带检测）。所有调用点都应该走这里，而不是直接 {@code FdmFallbackDialog.show}。
     *
     * <p>两层保护：
     * <ul>
     *   <li><b>弹之前</b>：{@link #moduleLooksAbsent} 说模块在 ⇒ 直接跳过；</li>
     *   <li><b>弹之后</b>：起一个 6 秒的哨兵，期间只要收到 UI_OPENED 就**自动关掉**弹窗
     *       （用户看到的观感是「模块起来了，那个错弹的卡片自己消失」）。</li>
     * </ul>
     */
    public static void showFallbackIfNeeded(final Context ctx, final String reason,
                                            final Runnable onHostUpdate) {
        if (!shouldShowFallback(ctx)) {
            GmUtil.log("【FdmUiHook】判据说拉起成功 ⇒ 不弹保底（reason=" + reason + "）");
            return;
        }
        FdmFallbackDialog.show(ctx, reason, retryRunnable(ctx), onHostUpdate);
        // ★ 弹完再看 6 秒：万一它其实正在起来（网络慢 / 冷启动慢），就自己收回去
        try {
            final long shownAt = System.currentTimeMillis();
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(
                    new Runnable() {
                        @Override
                        public void run() {
                            try {
                                if (sUiOpened && sUiOpenedAt >= shownAt) {
                                    GmUtil.log("【FdmUiHook】保底弹窗显示后模块起来了 ⇒ 自动关掉");
                                    FdmFallbackDialog.dismissIfShowing();
                                }
                            } catch (Throwable t) {
                                GmUtil.log("【FdmUiHook】保底自动收哨兵异常：" + t);
                            }
                        }
                    }, 6000L);
        } catch (Throwable ignore) {
        }
    }

    /**
     * 【统一入口】拉起 Compose UI；**没起来就弹保底**。
     *
     * @param ctx         宿主 Context
     * @param reason      失败原因（写进保底弹窗，便于自查）
     * @param onHostUpdate 保底弹窗里点「检查宿主更新」时要执行的动作（宿主原逻辑）
     * @return true ＝ 已发起拉起（**不代表成功**，成败由回调判定）
     */
    public static boolean launchWithFallback(final Context ctx, final String reason,
                                             final Runnable onHostUpdate) {
        // ★ 一次点击只跑一次。血证：主人「现在会弹两个保底弹窗」——
        //   一次点击会走两条路（我新挂的 pg7.z + 底座原有的 GmHomeUi.open）。
        final long now = System.currentTimeMillis();
        if (now - sLastLaunchAt < 1500L) {
            GmUtil.log("【FdmUiHook】1.5s 内已发起过拉起 ⇒ 本次跳过");
            return true;
        }
        sLastLaunchAt = now;
        sUiOpened = false;
        boolean asked = false;
        try {
            asked = openComposeImpl(ctx);
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】拉起抛异常：" + t);
        }
        if (!asked) {
            // 连"发起"都失败了（比如广播都发不出去）⇒ 不用等，立刻弹
            GmUtil.log("【FdmUiHook】发起阶段就失败 ⇒ 走带检测的保底");
            showFallbackIfNeeded(ctx, reason, onHostUpdate);
            return false;
        }
        // 发起了 ⇒ **延迟 1 秒**再判成败（主人 2026-11-07 定的）：
        //   宿主被顶到后台 ⇒ 拉起成功 ⇒ 不弹
        //   宿主还在前台   ⇒ 拉起失败 ⇒ 弹
        //   （1 秒是主人的取值：Activity 启动的转场在半秒级，1 秒足够它把宿主 pause 掉；
        //     而真实失败时用户也就等 1 秒，不会觉得"点了没反应"。）
        try {
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(
                    new Runnable() {
                        @Override
                        public void run() {
                            showFallbackIfNeeded(ctx, reason, onHostUpdate);
                        }
                    }, 1000L);
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】保底看门狗没装上：" + t);
        }
        return true;
    }

    /** 保底弹窗里「拉起模块 UI」的重试动作。 */
    private static Runnable retryRunnable(final Context ctx) {
        return new Runnable() {
            @Override
            public void run() {
                sUiOpened = false;
                sUiOpenedAt = 0L;
                openComposeImpl(ctx);
                // ★ 重试成功的话把这张卡片收掉 —— 否则用户会看到
                //   "界面起来了，但那张说失败了的卡片还压在上面"。
                try {
                    new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(
                            new Runnable() {
                                @Override
                                public void run() {
                                    if (sUiOpened) {
                                        GmUtil.log("【FdmUiHook】重试成功 ⇒ 关掉保底弹窗");
                                        FdmFallbackDialog.dismissIfShowing();
                                    }
                                }
                            }, 2500L);
                } catch (Throwable ignore) {
                }
            }
        };
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
     * （已停用）1.2 秒后补弹旧 View UI。
     *
     * <h3>⛔ 2026-11-07 停用 —— 主人实测的现象链</h3>
     * 点一下「检查更新」，屏幕上依次出现**三个**东西：
     * <pre>
     *   0.0s  宿主原 Toast「当前已是最新版本」
     *   1.2s  这段看门狗补弹的 GmMenuDialog  ← 主人原话："非常旧的屎山模块设置 viewUI"
     *   1.5s  FdmFallbackDialog 保底弹窗      ← 真正该出现的那个
     * </pre>
     * 三个弹窗叠着弹，比"点了没反应"更难受。
     *
     * <p>旧逻辑的用意是「拉不起 Compose UI 时至少弹个能用的东西」，
     * 但现在这件事已经由 {@link FdmFallbackDialog} 接手（而且它信息更多、
     * 还能重试 / 走宿主原逻辑）。**两个兜底不能并存** —— 这正是教训 264
     * 「源头接管与末端接管不能并存」的同族：**同一件事只能有一个兜底**。
     *
     * <p>所以这里改成**什么都不做**，只留一行日志（便于事后确认"当时的判断是模块进程没起"）。
     */
    private static void watchdogFallback(final Context ctx) {
        try {
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    try {
                        if (moduleAlive(ctx)) {
                            GmUtil.log("【FdmUiHook】看门狗：模块进程在 ✓");
                        } else {
                            // ⛔ 不再补弹 GmMenuDialog（会和保底弹窗叠着弹）
                            GmUtil.log("【FdmUiHook】看门狗：模块进程没起 ⇒ 交给保底弹窗，"
                                    + "不补弹旧 View UI");
                        }
                    } catch (Throwable t) {
                        GmUtil.log("【FdmUiHook】看门狗异常：" + t);
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
