// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;
import android.content.res.Resources;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 【FdmUpdateIntercept】把宿主的「检查更新」**结果吃掉** 🐲 2026-11-13
 *
 * <h3>为什么要有这个类（frida 实证，不是猜）</h3>
 * <pre>
 * 21:46 实测（job=280probe2，抓到的原文）：
 *   [1] ★ e=24 f=0  参数=qjb        ← yg7.y 第 1 次
 *   [4] ★ Context.getString(0x7f0f0275)="当前已是最新版本"
 *   [1] ★ e=23 f=0  参数=qjb        ← 检查更新这条（重入）
 *   [1] ★ e=23 f=1  参数=qjb        ← 恢复
 *   [4] ★ Context.getString(0x7f0f0275)="当前已是最新版本"
 *   [2]  Toast#N                    ← ★ 一次都没有！
 * </pre>
 *
 * <h3>三个关键结论</h3>
 * <ol>
 *   <li><b>宿主不弹 Toast</b>：全程 {@code Toast.show} 命中 0 次。
 *       ⇒ {@link FdmUpdatePopupHook} 挂 Toast/Dialog **根本不在路径上**，
 *         这就是它「装了但从不生效」的真因。</li>
 *   <li><b>真正取文案的点是 {@code Context.getString(int)}</b>，
 *       而且**只取那一个资源** {@code profile_check_for_updates_newest}（0x7f0f0275 = 2131690101）。</li>
 *   <li><b>{@code yg7.y} 的 {@code e} 是 23 / 24</b>，不是代码里写死的 22/23
 *       （{@code FdmUpdateRowHook} 的 CASE 常量已过时）。</li>
 * </ol>
 *
 * <h3>做法：按「资源名」拦，不写死 id</h3>
 * <pre>
 *   id = res.getIdentifier("profile_check_for_updates_newest", "string", pkg)
 *   if (getString(id)) → setResult("")
 * </pre>
 * <b>零 R8 依赖</b>：不碰任何混淆类名；宿主改版只要资源名不变就一直有效。
 * （血证：资源 id 会漂移 —— 2.7.5 是 0x7f0f0267，2.8.0 是 0x7f0f0275，
 *   而 {@code GmResTextHook} 写死的 0x7f0f021f 在 2.8.0 已经跑到「思考时长」上去了。）
 *
 * <h3>顺带：请求路径探针</h3>
 * 同时给 {@code rj5.c(Continuation)}（Ktor 的执行点猜测）和
 * {@code sib} 的 URL 字段挂**只读**探针，把每次请求的 URL 写进日志。
 * 这样跑一次就能确认「检查更新」到底从哪发出去，为「连请求都不发」做准备。
 *
 * <p>⚠️ 热路径纪律：{@code getString} 每秒可能几十次，
 * 第一句必须是「比两个 int 就返回」；而且**绝不做反射拿栈**（除非命中）。
 */
public final class FdmUpdateIntercept {

    /** 宿主「已是最新版本」的**资源名**（不写死 id）。 */
    private static final String RES_NEWEST = "profile_check_for_updates_newest";
    /** 宿主「检查更新」那一行的标题。 */
    private static final String RES_UPDATE = "profile_check_for_updates";

    /** 运行时解析出来的 id（0 = 还没解析 / 解析失败）。 */
    private static volatile int sIdNewest = 0;
    private static volatile int sIdUpdate = 0;
    private static volatile boolean sResolved = false;
    private static volatile String sPkg = null;

    private static volatile boolean sInstalled = false;

    /** 命中计数（自测读取）。 */
    public static volatile int sHitNewest = 0;
    public static volatile int sHitUpdate = 0;
    /** 探针：见过的请求 URL 数量。 */
    public static volatile int sUrlSeen = 0;

    /** 要废掉的请求路径。 */
    private static final String CHECK_UPDATE_PATH = "/api/v0/check_client_update";
    /**
     * 替换成的**整条 URL**：指向本机 1 号端口（绝不会有人监听）。
     *
     * <h3>为什么不能用「同域名的假路径」</h3>
     * 2026-11-13 真机血证（job291）：
     * <pre>
     *   GET https://chat.deepseek.com/__fdm_disabled__/check_client_update?scenario=check_update
     *   → 200 {"code":0,"data":{"biz_data":null}}      ← ★ 服务端照样 200！
     * </pre>
     * ⇒ 换路径**根本不算拦住**：服务端对未知路径返回 200 + 空数据，
     *   宿主收到后仍然认为「检查完成、没有新版本」，请求**照发不误**。
     * ⇒ 必须换**整条 URL 到不可达目标**，让 TCP 层直接失败，这才叫「一包都不发」。
     */
    /** 已弃用：走 sib.b() 抛异常，不再需要占位 URL。保留字段只是为了编译兼容。 */
    private static final String DISABLED_PATH = "";

    /** 请求拦截命中次数。 */
    public static volatile int sHitRequest = 0;

    /** 是否把「已是最新版本」吞成空串。关掉就只观察。 */
    private static volatile boolean sSwallow = true;

    private FdmUpdateIntercept() {
    }

    public static void setSwallow(boolean on) {
        sSwallow = on;
    }

    public static String stats() {
        return "newest=" + sHitNewest + " update=" + sHitUpdate
                + " urls=" + sUrlSeen + " reqBlocked=" + sHitRequest
                + " idNewest=0x" + Integer.toHexString(sIdNewest)
                + " idUpdate=0x" + Integer.toHexString(sIdUpdate)
                + " swallow=" + sSwallow;
    }

    // ══════════════════════════════════════════════════════════════════
    //  安装
    // ══════════════════════════════════════════════════════════════════

    public static void install(ClassLoader cl, Context ctx) {
        if (sInstalled) return;
        sInstalled = true;

        try {
            if (ctx != null) {
                sPkg = ctx.getPackageName();
                Resources r = ctx.getResources();
                sIdNewest = r.getIdentifier(RES_NEWEST, "string", sPkg);
                sIdUpdate = r.getIdentifier(RES_UPDATE, "string", sPkg);
                sResolved = (sIdNewest != 0);
                log("资源解析 ⇒ pkg=" + sPkg
                        + " newest=" + RES_NEWEST + "(0x" + Integer.toHexString(sIdNewest) + ")"
                        + " update=" + RES_UPDATE + "(0x" + Integer.toHexString(sIdUpdate) + ")"
                        + (sResolved ? " ✅" : " ✗ 没找到（本版不拦）"));
            } else {
                log("拿不到 Context ⇒ 无法解析资源名，跳过");
            }
        } catch (Throwable t) {
            log("资源解析失败：" + t);
        }

        hookGetString();
        hookRequestUrl(cl);       // ★ 真正「不发更新请求」的那一层
        hookRequestProbe(cl);
    }

    /** 拦 getString(int)：命中就直接给空串（或改文案）。 */
    private static void hookGetString() {
        // ① Resources.getString(int) —— 底层实现
        try {
            XposedHelpers.findAndHookMethod(Resources.class, "getString", int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            handle(p);
                        }
                    });
            log("✅ 已挂 Resources.getString(int)");
        } catch (Throwable t) {
            log("挂 Resources.getString 失败：" + t);
        }

        // ② Context.getString(int) —— 实际调用点（frida 实证走的就是这条）
        try {
            XposedHelpers.findAndHookMethod(Context.class, "getString", int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            handle(p);
                        }
                    });
            log("✅ 已挂 Context.getString(int)");
        } catch (Throwable t) {
            log("挂 Context.getString 失败：" + t);
        }
    }

    /**
     * 懒解析：install 时拿不到 Context（`handleLoadPackage` 阶段 Application 还没就绪，
     * `GmUtil.app()` 返回 null —— 2026-11-13 真机日志实证「拿不到 Context ⇒ 跳过」）。
     *
     * <p>⇒ 改成**第一次 getString 被调用时**从 {@code p.thisObject} 里拿：
     * <ul>
     *   <li>hook 的是 {@code Context.getString} ⇒ thisObject 是 Context，能拿 getPackageName + getResources</li>
     *   <li>hook 的是 {@code Resources.getString} ⇒ thisObject 是 Resources，包名从已解析的 sPkg 借</li>
     * </ul>
     * 解析成功后永久缓存（只做一次）。
     */
    private static synchronized void tryResolve(Object self) {
        if (sResolved) return;
        try {
            Context ctx = null;
            if (self instanceof Context) {
                ctx = (Context) self;
            } else if (self instanceof Resources && sPkg != null) {
                // 有包名、有 Resources ⇒ 直接解析
                resolveWith(((Resources) self), sPkg);
                return;
            }
            if (ctx != null) {
                sPkg = ctx.getPackageName();
                resolveWith(ctx.getResources(), sPkg);
            }
        } catch (Throwable t) {
            // 失败就下次再试（不缓存失败）
        }
    }

    private static void resolveWith(Resources r, String pkg) {
        int newest = r.getIdentifier(RES_NEWEST, "string", pkg);
        if (newest == 0) return;                 // 还没到能解析的时候
        sIdNewest = newest;
        sIdUpdate = r.getIdentifier(RES_UPDATE, "string", pkg);
        sResolved = true;
        log("资源解析（懒）⇒ pkg=" + pkg
                + " newest=0x" + Integer.toHexString(sIdNewest)
                + " update=0x" + Integer.toHexString(sIdUpdate) + " ✅");
    }

    /** 极热路径：先比 int。 */
    private static void handle(XC_MethodHook.MethodHookParam p) {
        try {
            if (!sResolved) tryResolve(p.thisObject);
            if (!sResolved) return;
            Object a0 = p.args[0];
            if (!(a0 instanceof Integer)) return;
            int id = (Integer) a0;

            if (id == sIdNewest) {
                boolean first = (sHitNewest == 0);
                sHitNewest++;
                if (sSwallow) {
                    // ★ 吃掉：宿主拿到空串 ⇒ 界面上什么都不显示
                    p.setResult("");
                }
                if (first) {
                    log("★ 命中「已是最新版本」(" + RES_NEWEST + ") 第 1 次"
                            + (sSwallow ? " ⇒ 已吞成空串" : " ⇒ 仅观察")
                            + "\n    栈=" + briefStack());
                } else if (sHitNewest % 20 == 0) {
                    log("命中 newest 累计 " + sHitNewest + " 次");
                }
                return;
            }

            if (id == sIdUpdate) {
                if (sHitUpdate == 0) {
                    log("★ 命中「检查更新」标题 (" + RES_UPDATE + ") 第 1 次\n    栈=" + briefStack());
                }
                sHitUpdate++;
                // ★ 2026-11-13 修：**这里不再弹选择页**。
                //   标题串只在首次渲染时取一次 ⇒ 挂这里只会弹一次，后面全无反应。
                //   改由 FdmUpdateRowJumpHook（真正的点击入口）调 showChoiceFromHook。
            }
        } catch (Throwable ignore) {
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  选择页（2026-11-13 · 主人的需求）
    // ══════════════════════════════════════════════════════════════════

    /** 选择页去抖：**同一次点击**会被 getString 命中多次（渲染 + 点击），只弹一次。 */
    private static volatile long sLastChoiceAt = 0L;
    private static volatile boolean sChoiceOn = true;

    public static void setChoiceOn(boolean on) {
        sChoiceOn = on;
    }

    /**
     * 弹「选择页」。
     *
     * <p>⚠️ 这里是在 {@code getString} 的 hook 里，属于**渲染热路径**，
     * 所以：① 先去抖（1.2s 内只弹一次）；② 整段 try/catch；
     * ③ 真正的弹窗动作**扔到主线程**（Compose 必须在主线程建）。
     */
    /**
     * 【外部入口】点「检查更新」时由 {@code FdmUpdateRowJumpHook} 调用。
     *
     * <p>★ 为什么不挂在 getString 上（2026-11-13 真机血证）：
     * 那个标题串**只在设置页首次渲染时取一次**，之后每次点击都不再取
     * ⇒ 选择页只弹过 1 次，后面全"点了没反应"。
     * 点击事件（{@code updatevm.check}）才是可靠触发点。
     */
    public static void showChoiceFromHook(final Context ctx) {
        maybeShowChoice(ctx);
    }

    private static void maybeShowChoice(Object self) {
        if (!sChoiceOn) return;
        final long now = System.currentTimeMillis();
        if (now - sLastChoiceAt < 600L) return;   // 同一次点击会多次进这里，去抖 600ms
        sLastChoiceAt = now;

        final Context ctx;
        try {
            if (self instanceof Context) {
                ctx = (Context) self;
            } else if (self instanceof Resources) {
                // Resources 不是 Context，用它自己的包名反查 Application 太绕
                // ⇒ 交给 FdmComposeDialog 自己从 ActivityThread 捞当前 Activity
                ctx = null;
            } else {
                ctx = null;
            }
        } catch (Throwable t) {
            return;
        }

        Runnable show = new Runnable() {
            @Override
            public void run() {
                try {
                    // ══════════════════════════════════════════════════════════════
                    //  ★★ 2026-11-14 · 选择页升级成**三按钮**（整页正式上入口）
                    //
                    //  主人拍板：
                    //    · 「保留二选一弹窗，只把里面『打开模块』那个按钮改成开整页」
                    //    · 「两条并存：加个开关/两个按钮，让主人自己选」
                    //  ⇒ ①「打开模块 · 整页」= 进程内 HostPage（不受包可见性影响）
                    //     ②「模块本体」      = **老路逐字未改**（抽成 openModuleLegacy 只是
                    //                          为了让「整页装不上」时也能复用它）
                    //     ③「检查宿主更新」  = 原样
                    // ══════════════════════════════════════════════════════════════
                    boolean ok = FdmComposeDialog.tryShowChoice3(
                            ctx,
                            new Runnable() {
                                @Override
                                public void run() {
                                    openFullPage(ctx);
                                }
                            },
                            new Runnable() {
                                @Override
                                public void run() {
                                    openModuleLegacy(ctx);
                                }
                            },
                            new Runnable() {
                                @Override
                                public void run() {
                                    // 点「检查宿主更新」：请求层已被拦（sib.b 抛异常），
                                    // 这里只留个记录 —— 不重放宿主逻辑（重放=又发一次请求）
                                    log("选择页：主人点了「检查宿主更新」（请求已被拦，不重放）");
                                }
                            });
                    log("选择页 ⇒ " + (ok ? "已显示" : "显示失败（看 FdmComposeDlg 日志）"));
                } catch (Throwable t) {
                    log("选择页异常：" + t);
                }
            }
        };

        try {
            android.os.Handler h = new android.os.Handler(android.os.Looper.getMainLooper());
            h.post(show);
        } catch (Throwable t) {
            log("投递主线程失败：" + t);
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  两条路（2026-11-14）
    // ══════════════════════════════════════════════════════════════════

    /**
     * 【老路 · 模块本体】跨进程拉起模块自己的 MainActivity。
     *
     * <p>★ 逻辑与 3.107.4 **逐字一致**，只是从匿名类里搬出来放进方法
     * （唯一的改动是 `return` 变成方法内的 `return`，语义相同）。
     * 主人要求「两条并存」⇒ 这条必须一直是好的，不能被新东西带坏。
     */
    private static void openModuleLegacy(final Context ctx) {
        // ★★ 2026-11-13：「打开模块」= **双路兜底**
        //
        //   路 1（体验更好）：跨进程拉起模块 MainActivity
        //     显式 → scheme → 广播，全程被**包可见性**挡
        //     （宿主 targetSdk=36，清单没有 <queries> 声明我们；
        //       主人还开着「隐藏应用列表」）⇒ 实测 5 次只成 1 次
        //
        //   路 2（一定能开）：**进程内 GmHomeUi.open()**
        //     那是我们自己的类（名字永远不变），在底座 classes.dex 里
        //     早已随宿主加载 ⇒ 普通方法调用，不涉及跨包查询
        //     ⇒ 包可见性管不着 ⇒ 100% 能开
        //
        //   ⇒ 两条都走：先试跨进程，无论成败都补一发旧 UI
        //     （旧 UI 是 View 弹窗，和跨进程 Compose 页不冲突，
        //       观感就是"弹出了一个能用的界面"）
        log("选择页：主人点了「模块本体」（跨进程）");
        boolean started = false;
        try {
            Context c2 = ctx != null ? ctx : com.nidyaber.fuckdsmanger.gm.GmUtil.app();
            if (c2 != null) {
                started = FdmUiHook.launchWithFallback(c2, "选择页·打开模块", null);
            } else {
                log("选择页：拿不到 Context ⇒ 直接走旧 UI 兜底");
            }
        } catch (Throwable t) {
            log("选择页：跨进程拉起异常 " + t);
        }

        // ★ 2026-11-14 修「拉起成功却弹'拉起失败'卡片」：
        //   原来**无条件**往下弹保底，而跨进程拉起常常是**马上成功**的
        //   （真机血证 10:12:40：`已拉起 Compose UI ✓（显式）` 之后 20ms
        //    就弹出了"貌似拉起模块出错了"，屏幕左边卡片、右边界面）。
        //   ⇒ 拉起已发起就交给看门狗判成败，这里不要抢跑。
        if (started) {
            log("选择页：拉起已发起 ⇒ 不在这里弹保底（交给看门狗判成败）");
            return;
        }

        // ★★ 到这里才是**真的失败**：连发起都没发起。
        //   弹那张「貌似拉起模块出错了……」的卡片（FdmFallbackDialog），
        //   它本身就是进程内 Compose/View 弹窗，一定能显示，
        //   而且会把"为什么拉不起来 + 怎么办"一次说明白。
        //
        //   为什么不用 GmHomeUi（旧 View UI）：
        //     那是手写 smali 时代的老界面，功能对不上现在的配置项。
        //     主人要的是"能看到排查指引"，不是"看到一个能点但过时的界面"。
        try {
            Context c3 = ctx != null ? ctx
                    : com.nidyaber.fuckdsmanger.gm.GmUtil.app();
            if (c3 != null) {
                // ★ 用 showForce：先关选择页、清防重入闸，再弹
                //   （普通 show() 会被「已有弹窗在显示」+「2s 窗口」挡住
                //     —— 真机血证 22:43:26：日志打印了，屏幕什么都没有）
                boolean ok2 = FdmFallbackDialog.showForce(c3,
                        "选择页：跨进程拉起模块失败（包可见性 / 隐藏应用列表）");
                log("选择页：保底卡片 ⇒ " + (ok2 ? "已发起" : "失败"));
            } else {
                log("选择页：拿不到 Context ⇒ 保底也弹不了");
            }
        } catch (Throwable t) {
            log("选择页：保底卡片异常 " + t);
        }
    }

    /**
     * 【新路 · 整页】在**宿主进程内**把模块的 Compose 界面画出来（{@code HostPage}）。
     *
     * <h3>三个不够显眼但必须做的事</h3>
     * <ol>
     *   <li><b>先关选择页</b>：{@code FdmComposeDialog} 只有一个 {@code sShowingDlg} 槽，
     *       不先关就整页接管它，之后的 dismiss 会关错对象（待办里"多实例互相覆盖"那条）。</li>
     *   <li><b>下一轮消息再开</b>：Dialog 的 dismiss 要等窗口真正移除；
     *       同帧 show 在部分 ROM 上是 {@code BadTokenException}。</li>
     *   <li><b>装不上要自动退回老路</b>：整页可能因为「模块 Resources 拿不到」返回 false
     *       （见 HostPage 类注释），那种情况主人不该白点一下。</li>
     * </ol>
     *
     * <p>⚠️ 整页内部「点击会跳去模块进程」是本轮**明知未治**的遗留
     * （主人：「先只接入口，内部跳转下一轮再说」）。
     */
    private static void openFullPage(final Context ctx) {
        log("选择页：主人点了「打开模块 · 整页」");
        try {
            FdmComposeDialog.dismissShowing();
        } catch (Throwable ignore) {
        }
        try {
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    boolean okFull = false;
                    try {
                        Context c = ctx != null ? ctx
                                : com.nidyaber.fuckdsmanger.gm.GmUtil.app();
                        okFull = FdmComposeDialog.tryShowFullPage(c, new Runnable() {
                            @Override
                            public void run() {
                                // 整页的收尾（右上角 ✕ / 返回键退到首页）⇒ 关掉承载它的 Dialog
                                log("选择页：整页请求关闭");
                                FdmComposeDialog.dismissShowing();
                            }
                        });
                    } catch (Throwable t) {
                        log("选择页：整页异常 " + t);
                    }
                    log("选择页：整页 ⇒ " + (okFull ? "已显示" : "失败（看 FdmComposeDlg 日志）"));
                    if (!okFull) {
                        log("选择页：整页没装上 ⇒ 自动退回「模块本体」（跨进程）");
                        openModuleLegacy(ctx);
                    }
                }
            }, 90L);
        } catch (Throwable t) {
            log("选择页：投递整页失败 " + t);
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  请求路径探针（只读，为「连请求都不发」做准备）
    // ══════════════════════════════════════════════════════════════════

    /**
     * ★★ 2026-11-13 · **真正拦请求的地方：{@code y37.C(sib, String[])}**
     *
     * <h3>为什么是它</h3>
     * <pre>
     * 反编译铁证（y37.smali:1603）：
     *   .method public static final varargs C(Lsib;[Ljava/lang/String;)V
     *       new ArrayList
     *       :loop
     *         b03.f(3, url)          ← 每个 URL 规范化
     *         list.add(...)
     *       iput-object v0, p0, Lsib;->h:Ljava/util/List;   ← ★ 写进请求对象
     * </pre>
     * <b>全树只有 7 个类调它</b>（c4a / ki / hp9 / sq2 / we2 / uz0 / tz0），
     * 而 {@code sq2} 正是「检查更新」那条协程状态机（{@code check_client_update} 就在它体内）。
     * ⇒ 在这里先把 URL 抠出来判断，命中就把该 URL **整条换成不可达地址**
     *   （{@code https://127.0.0.1:1/...}，本机 1 号端口无人监听）
     *   ⇒ TCP 连接直接失败，**一个字节都发不出去**。
     *
     * <h3>为什么不直接抛异常</h3>
     * 抛异常会让协程走 error 分支，且可能干扰协程状态机。
     * 改 URL 更干净：Ktor 自己发起连接、自己失败、自己走 error 分支，
     * 我们只是"告诉它一个连不上的地址"。宿主对检查更新失败**本来就是静默处理**
     * （网络不好时不弹东西），所以观感上是"点了没反应"——正是要的效果。
     *
     * <h3>效果</h3>
     * 连接 {@code 127.0.0.1:1} 会立刻 {@code ConnectException}，
     * <b>不会产生任何外发流量</b> —— 真正做到「一包都不发」。
     */
    private static void hookRequestUrl(ClassLoader cl) {
        try {
            Class<?> sibCls = XposedHelpers.findClass("sib", cl);
            java.lang.reflect.Method bM = null;
            for (java.lang.reflect.Method m : sibCls.getDeclaredMethods()) {
                if ("b".equals(m.getName()) && m.getParameterTypes().length == 0) {
                    bM = m;
                    break;
                }
            }
            if (bM == null) {
                log("请求拦截：sib.b() 没找到 ⇒ 跳过");
                return;
            }
            log("请求拦截：锚点 = " + bM);
            XposedBridge.hookMethod(bM, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        Object self = p.thisObject;
                        if (self == null) return;
                        // 命中判据：把 URL **算一遍**看是不是检查更新
                        //   · sib.b() 会把 "https://chat.deepseek.com" + sib.a 拼起来
                        //   · 所以这里查的是「sib.a 或 sib.h 里有没有 check_client_update」
                        if (!isCheckUpdate(self)) return;

                        if (sHitRequest == 0) {
                            log("★★ 拦下「检查更新」请求（在 URL 构建阶段直接失败）"
                                    + "\n    栈=" + briefStack());
                        }
                        sHitRequest++;
                        // ★ 抛异常 = URL 构不出来 = Ktor 根本不会发起连接
                        //   ⇒ 真正的「一个包都不发」
                        p.setThrowable(new IllegalStateException("FDM: check-client-update blocked"));
                    } catch (Throwable ignore) {
                    }
                }
            });
            log("✅ 请求拦截已挂（" + CHECK_UPDATE_PATH + " ⇒ 构建阶段抛异常，零外发流量）");
        } catch (Throwable t) {
            log("请求拦截跳过：" + t);
        }
    }

    /**
     * 判断这个 {@code sib} 是不是「检查更新」。
     *
     * <p>为什么不去 {@code y37.C} 改路径：2026-11-13 真机血证（抓包）——
     * <pre>
     *   y37.C 里放 "https://127.0.0.1:1/__blocked__"
     *   ⇒ 实际请求变成 https://chat.deepseek.com/https://127.0.0.1:1/__blocked__
     *      （Ktor 把 baseUrl 拼在了前面！）
     *   ⇒ 请求**照样发到 deepseek**，只是路径变成畸形串
     * </pre>
     * <p>{@code sib.a} 只是**路径**，域名来自 {@code sib.d:Luib}。
     * 所以改路径永远逃不出那个域名 ⇒ 必须在 {@code b()} 里直接失败。
     */
    private static boolean isCheckUpdate(Object sib) {
        try {
            Object a = field(sib, "a");
            if (a instanceof String && ((String) a).contains(CHECK_UPDATE_PATH)) return true;
            Object h = field(sib, "h");
            if (h instanceof java.util.List) {
                for (Object o : (java.util.List<?>) h) {
                    if (o instanceof String && ((String) o).contains("check_client_update")) return true;
                }
            }
        } catch (Throwable ignore) {
        }
        return false;
    }

    private static void hookRequestProbe(ClassLoader cl) {
        // Ktor 的执行点（sj2/rj5 是 R8 合并出来的协程包装）
        try {
            Class<?> rj5 = XposedHelpers.findClass("rj5", cl);
            for (final java.lang.reflect.Method m : rj5.getDeclaredMethods()) {
                String n = m.getName();
                if (!"c".equals(n) && !"d".equals(n)) continue;
                if (m.getParameterTypes().length != 1) continue;
                XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam p) {
                        try {
                            Object self = p.thisObject;
                            Object mi5 = field(self, "a");
                            Object sib = mi5 == null ? null : field(mi5, "a");
                            Object url = sib == null ? null : field(sib, "a");
                            String u = url == null ? "null" : url.toString();
                            sUrlSeen++;
                            if (u.contains("check_client_update") || u.contains("/api/v0/")) {
                                log("【探针】" + m.getName() + " URL=" + u);
                            }
                        } catch (Throwable ignore) {
                        }
                    }
                });
                log("✅ 请求探针已挂 rj5." + n);
            }
        } catch (Throwable t) {
            log("请求探针（rj5）跳过：" + t);
        }
    }

    private static Object field(Object o, String name) {
        try {
            java.lang.reflect.Field f = o.getClass().getDeclaredField(name);
            f.setAccessible(true);
            return f.get(o);
        } catch (Throwable t) {
            return null;
        }
    }

    /** 只在命中时调一次，拿 8 层栈（过滤 Xposed 自己）。 */
    private static String briefStack() {
        try {
            StackTraceElement[] st = new Throwable().getStackTrace();
            StringBuilder b = new StringBuilder();
            int n = 0;
            for (StackTraceElement el : st) {
                String cn = el.getClassName();
                if (cn.startsWith("de.robv") || cn.startsWith("com.nidyaber.")) continue;
                if (n++ >= 8) break;
                b.append("\n      ").append(cn).append('.').append(el.getMethodName())
                        .append(':').append(el.getLineNumber());
            }
            return n == 0 ? "(空)" : b.toString();
        } catch (Throwable t) {
            return "?";
        }
    }

    private static void log(String msg) {
        try {
            GmUtil.log("【FdmUpdateIntercept】" + msg);
        } catch (Throwable ignore) {
        }
        try {
            XposedBridge.log("[FDM][UpdInt] " + msg);
        } catch (Throwable ignore) {
        }
    }
}
