// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

/**
 * 【FdmFallbackDialog】拉起失败的**保底弹窗** 🐲
 *
 * <h3>为什么需要它（主人 2026-11-07）</h3>
 * <pre>
 *   「加一个保底吧，我刚刚重开了应用列表又变成当前是最新版本」
 * </pre>
 * 「隐藏应用列表」这类系统/框架级设置一旦重置，宿主就**看不见我们包**
 * ⇒ 显式 startActivity / 广播 / PendingIntent 全部可能静默失败
 * ⇒ 用户点那一行**什么都没发生**（最糟的体验：没有反馈就无法自查）。
 *
 * <p>保底要做的事只有一件：**让「失败」变成看得见、点得动的东西**。
 *
 * <h3>为什么是纯 View，不是 Compose</h3>
 * 宿主里其实**有** Compose（`androidx/compose/ui/platform/ComposeView.smali`
 * 是真实类定义，R8 没混淆 AndroidX，因为编译器插件依赖固定签名）。
 * 但要在宿主进程里弹 Compose，有三个绕不过去的坎：
 * <ol>
 *   <li>宿主的 <b>Lifecycle / SavedStateRegistry 被混淆了</b>，
 *       而 {@code ComposeView} 强制要求 {@code ViewTreeLifecycleOwner}；</li>
 *   <li>我们的 Composable 是用**我们自己那份** Compose 编的，和宿主运行时的
 *       版本不一定对得上 —— 一旦不兼容，**连保底自己都会崩**；</li>
 *   <li>保底的意义就是「别的东西都不可靠时才用它」。
 *       ⇒ 它**不应该**再依赖任何三方库，只用 framework 类。</li>
 * </ol>
 * 所以这里用 {@link Dialog} + 纯 View 手绘一张深色圆角卡片，
 * 观感和「极简 Compose 弹窗」一致，但依赖面为零。
 *
 * <h3>两个按钮</h3>
 * <ul>
 *   <li><b>拉起模块 UI</b> —— 重试一次；仍在失败就把正文换成那句排查指引：
 *       「你能看到这里说明模块成功注入但是拉不起来，
 *         请检查隐藏应用列表是否排除了模块主包」</li>
 *   <li>~~检查宿主更新~~ —— <b>2026-11-07 已删</b>。
 *       本来想"重放宿主原逻辑"，frida 已证明重放确实跑通了
 *       （{@code runHostOriginal → sj0.h → pg7.z → ol2.j → getString}），
 *       但宿主最终那句 Toast 死活不显示（协程状态机 + 我们自己的弹窗拦截互相打架）。
 *       主人拍板：<b>删掉，别留个点了没反应的按钮</b>。</li>
 * </ul>
 *
 * <p>⚠️ Dialog 必须用 **Activity** 作 Context（Application 会抛
 * {@code BadTokenException}）；拿不到 Activity 就退化成 Toast，绝不再抛异常。
 */
public final class FdmFallbackDialog {

    /** 同一时刻只允许一个保底弹窗（连点不叠）。 */
    private static volatile Dialog sShowing = null;
    /** 上次弹窗时刻 —— 用来挡住"一次点击两条路各弹一个"。 */
    private static volatile long sLastShowAt = 0L;

    private static final int C_CARD = 0xFF1E1E22;
    private static final int C_TITLE = 0xFFFFFFFF;
    private static final int C_BODY = 0xFFB0B0B8;
    private static final int C_PRIMARY = 0xFF3D7EFF;
    private static final int C_SECONDARY = 0xFF33333A;
    /** 橙：root 用户（隐藏应用列表那条）。 */
    private static final int C_WARN = 0xFFFF8A65;
    /** 绿：npatch 用户（暂时找不到原因）。 */
    private static final int C_GREEN = 0xFF6BCB77;
    /** 青：行动指引。 */
    private static final int C_CYAN = 0xFF4DD0E1;

    // ══════════════════════════════════════════════════════════════════
    //  文案（2026-11-07 主人定稿：**两个弹窗合并成一个**）
    //
    //  旧形态是「先显示一句含糊的失败说明 → 点了按钮才换成排查指引」，
    //  问题是：主人第一次看到时**什么有用信息都没有**，必须点一下才知道该查什么；
    //  而点一下又正好会重试拉起（把状态搅得更乱）。
    //  ⇒ 现在**一次全摊开**，点按钮就只是重试。
    // ══════════════════════════════════════════════════════════════════
    /** 标题行。 */
    private static final String T_TITLE = "貌似拉起模块出错了……";
    /** 橙：root 用户的排查方向（隐藏应用列表策略）。 */
    private static final String T_ROOT =
            "root用户请单独看看是不是隐藏应用列表把模块排除了，"
            + "尽量选择对宿主隐藏模块，这样数美启动最多探测到有隐藏应用列表，不会上报包名";
    /** 绿：npatch 用户的现状。 */
    private static final String T_NPATCH = "修补(npatch)用户暂时找不到可能的原因";
    /** 青：行动指引。 */
    private static final String T_ACT = "点击下面的按钮重试";

    private FdmFallbackDialog() {
    }

    /**
     * 弹保底。
     *
     * @param ctx         宿主侧 Context（尽量传 Activity）
     * @param reason      一句话说明为什么没起来（写进正文，便于自查）
     * @param onTryLaunch 点「拉起模块 UI」时重试拉起
     * @param onHostUpdate 已废弃（第二个按钮已删），保留形参只为不改调用方
     */
    public static void show(final Context ctx, final String reason,
                            final Runnable onTryLaunch, final Runnable onHostUpdate) {
        // ★★ 2026-11-07：**一次点击只许弹一个**
        //
        //   主人现象：「现在会弹两个保底弹窗」。
        //   原因：一次点击会走**两条**路 ——
        //     ① 我新挂的 {@code FdmUpdateRowHook}（pg7.z）
        //     ② 底座原有的 {@code GmHomeUi.open()}（被 FdmUiHook 拦住，也会拉 UI 失败）
        //   两边各自触发保底 ⇒ 叠两个。
        //
        //   这跟"两个兜底不能并存"是同一条教训（264）：**同一件事只能有一个出口**。
        //   这里用一个时间窗闸住 —— 2 秒内只认第一次。
        // 硬唯一：已经有一个在显示 ⇒ 绝不弹第二个（时间窗只是辅助）
        try {
            if (sShowing != null && sShowing.isShowing()) {
                log("已有弹窗在显示 ⇒ 本次不重复弹");
                return;
            }
        } catch (Throwable ignore) {
        }
        final long now = System.currentTimeMillis();
        if (now - sLastShowAt < 2000L) {
            log("2s 内已经弹过（" + (now - sLastShowAt) + "ms）⇒ 本次不重复弹");
            return;
        }
        sLastShowAt = now;
        try {
            // ★ 第一层：Compose 版（主人：「试试看 compose 嘛」）
            //   探针已证实宿主进程里能跑我们自己的 Compose（见 FdmComposeDialog 注释）。
            //   失败就往下掉，绝不因为它而丢掉保底能力。
            if (FdmComposeDialog.tryShow(ctx, reason, onTryLaunch, onHostUpdate)) {
                log("保底走的是 Compose 版");
                return;
            }
            // ★ 第二层：纯 View 版（零三方依赖，几乎不可能失败）
            log("保底走的是 View 版");
            showView(ctx, reason, onTryLaunch, onHostUpdate);
        } catch (Throwable t) {
            log("show 失败：" + t);
        }
    }

    /** 第二层：纯 View 版（原实现，一行没动）。 */
    private static void showView(final Context ctx, final String reason,
                                 final Runnable onTryLaunch, final Runnable onHostUpdate) {
        try {
            final Activity act = asActivity(ctx);
            if (act == null) {
                // 没有 Activity 就没法弹 Dialog（Android 硬约束）
                // ⇒ 退化成 Toast：**只留最短的一句**（toast 装不下三段说明）
                toast(ctx, T_TITLE + "\n" + T_ACT);
                return;
            }
            act.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        build(act, reason, onTryLaunch, onHostUpdate).show();
                    } catch (Throwable t) {
                        log("弹窗构造失败：" + t);
                        toast(ctx, T_TITLE + "\n" + T_ACT);
                    }
                }
            });
        } catch (Throwable t) {
            log("showView 失败：" + t);
        }
    }

    // ------------------------------------------------------------------ 内部

    private static Dialog build(final Activity act, final String reason,
                                final Runnable onTryLaunch, final Runnable onHostUpdate) {
        final Dialog d = new Dialog(act, android.R.style.Theme_DeviceDefault_Dialog_NoActionBar);
        d.requestWindowFeature(Window.FEATURE_NO_TITLE);

        // ---- 卡片 ----
        LinearLayout card = new LinearLayout(act);
        card.setOrientation(LinearLayout.VERTICAL);
        int p = dp(act, 22);
        card.setPadding(p, dp(act, 20), p, dp(act, 16));
        card.setBackground(round(C_CARD, dp(act, 20)));

        TextView title = text(act, T_TITLE, 17, C_TITLE, true);
        card.addView(title);

        // ── 三段说明（一次全摊开，不再"点一下才显示"）──
        //   间距都挂在**每个段落自己的 topMargin** 上，避免用 Spacer 这类
        //   需要额外 View 的写法（保底弹窗必须零依赖、能少一个 View 就少一个）。
        final TextView tRoot = text(act, T_ROOT, 13, C_WARN, false);
        LinearLayout.LayoutParams pRoot = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        pRoot.topMargin = dp(act, 12);
        card.addView(tRoot, pRoot);

        final TextView tNpatch = text(act, T_NPATCH, 13, C_GREEN, false);
        LinearLayout.LayoutParams pNpatch = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        pNpatch.topMargin = dp(act, 10);
        card.addView(tNpatch, pNpatch);

        final TextView tAct = text(act, T_ACT, 13, C_CYAN, false);
        LinearLayout.LayoutParams pAct = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        pAct.topMargin = dp(act, 10);
        card.addView(tAct, pAct);

        // ---- 按钮行 ----
        LinearLayout row = new LinearLayout(act);
        row.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout.LayoutParams rlp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        rlp.topMargin = dp(act, 18);
        card.addView(row, rlp);

        // ① 拉起模块 UI
        final TextView btnLaunch = button(act, "拉起模块 UI", C_PRIMARY);
        LinearLayout.LayoutParams b1 = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        row.addView(btnLaunch, b1);

        // ---- 行为 ----
        btnLaunch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // 2026-11-07 改：指引**一开始就全摊开**了，按钮不再切换文字，
                //   只做一件事 —— 重试拉起。
                GmUtil.log("【FdmFallback】点「拉起模块 UI」⇒ 重试");
                if (onTryLaunch != null) {
                    try {
                        onTryLaunch.run();
                    } catch (Throwable t) {
                        log("重试拉起失败：" + t);
                    }
                }
            }
        });

        d.setContentView(card);
        Window w = d.getWindow();
        if (w != null) {
            w.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            // 别占满屏，两侧留白让它像张卡片
            w.setLayout(dp(act, 280), ViewGroup.LayoutParams.WRAP_CONTENT);
        }
        d.setCanceledOnTouchOutside(true);
        sShowing = d;
        GmUtil.log("【FdmFallback】保底弹窗已显示（reason=" + reason + "）");
        return d;
    }

    /** 供 Compose 版登记「当前有一个弹窗在显示」—— 保证全局唯一。 */
    static void markShowing(Dialog d) {
        sShowing = d;
    }

    /**
     * 外部主动关掉保底弹窗（**带检测的自动收回**用）。
     *
     * <p>场景：弹窗已经显示，但几秒后模块自己起来了（网络慢 / 冷启动慢）
     * ⇒ 这张「拉起失败了」的卡片就不该再留在屏幕上。
     *
     * <p>⚠️ 必须在主线程调用（Dialog.dismiss 的要求），调用方用 Handler 投过来。
     */
    public static void dismissIfShowing() {
        try {
            Dialog d = sShowing;
            if (d == null) return;
            if (!d.isShowing()) {
                sShowing = null;
                return;
            }
            d.dismiss();
            sShowing = null;
            log("已自动关闭保底弹窗（模块其实起来了）");
        } catch (Throwable t) {
            log("dismissIfShowing 失败：" + t);
        }
    }

    private static void dismiss() {
        try {
            if (sShowing != null) sShowing.dismiss();
        } catch (Throwable ignore) {
        }
        sShowing = null;
    }

    private static TextView text(Context c, String s, int sp, int color, boolean bold) {
        TextView t = new TextView(c);
        t.setText(s);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, sp);
        t.setTextColor(color);
        t.setLineSpacing(dp(c, 3), 1f);
        if (bold) t.setTypeface(t.getTypeface(), android.graphics.Typeface.BOLD);
        return t;
    }

    /** 手绘圆角"按钮"（不用 Button 控件 —— 免得被宿主主题改成奇怪样式）。 */
    private static TextView button(Context c, String label, int bgColor) {
        TextView t = new TextView(c);
        t.setText(label);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
        t.setTextColor(0xFFFFFFFF);
        t.setGravity(Gravity.CENTER);
        int v = dp(c, 10), h = dp(c, 6);
        t.setPadding(h, v, h, v);
        t.setBackground(round(bgColor, dp(c, 12)));
        t.setClickable(true);
        t.setFocusable(true);
        return t;
    }

    private static GradientDrawable round(int color, int radius) {
        GradientDrawable g = new GradientDrawable();
        g.setColor(color);
        g.setCornerRadius(radius);
        return g;
    }

    private static int dp(Context c, int v) {
        try {
            return GmUtil.dp(c, v);
        } catch (Throwable t) {
            return (int) (v * (c == null ? 3f : c.getResources().getDisplayMetrics().density) + 0.5f);
        }
    }

    /** 顺着 ContextWrapper 链找 Activity（Dialog 必须要它）。 */
    private static Activity asActivity(Context c) {
        while (c instanceof ContextWrapper) {
            if (c instanceof Activity) return (Activity) c;
            c = ((ContextWrapper) c).getBaseContext();
        }
        if (c instanceof Activity) return (Activity) c;
        // ★ 兜底：手里是 ContextImpl（receiver / Application）时，去 ActivityThread 里捞
        return FdmHostActivity.current();
    }

    private static void toast(Context c, String s) {
        try {
            GmUtil.toast(c, s);
        } catch (Throwable ignore) {
        }
    }

    private static void log(String msg) {
        try {
            GmUtil.log("【FdmFallback】" + msg);
        } catch (Throwable ignore) {
        }
        try {
            de.robv.android.xposed.XposedBridge.log("[FDM] 【FdmFallback】" + msg);
        } catch (Throwable ignore) {
        }
    }
}
