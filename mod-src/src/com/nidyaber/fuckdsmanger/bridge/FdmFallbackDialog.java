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
    private static final int C_WARN = 0xFFFF8A65;

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
                toast(ctx, "模块已注入，但界面拉不起来（" + reason + "）"
                        + "\n请检查隐藏应用列表是否排除了模块主包");
                return;
            }
            act.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        build(act, reason, onTryLaunch, onHostUpdate).show();
                    } catch (Throwable t) {
                        log("弹窗构造失败：" + t);
                        toast(ctx, "模块已注入，但界面拉不起来（" + reason + "）");
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

        TextView title = text(act, "FuckDSManger", 17, C_TITLE, true);
        card.addView(title);

        final TextView body = text(act, bodyOf(reason), 13, C_BODY, false);
        LinearLayout.LayoutParams blp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        blp.topMargin = dp(act, 10);
        card.addView(body, blp);

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
                // 先把「为什么失败 + 怎么自查」摊开给主人看，再去重试。
                //   顺序很重要：先给信息，再动作 —— 万一重试又把进程搞没了，
                //   至少这句话已经显示出来了。
                body.setText(HINT);
                body.setTextColor(C_WARN);
                body.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12);
                GmUtil.log("【FdmFallback】点「拉起模块 UI」⇒ 先展示自查指引，再重试");
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

    /** 那句排查指引 —— 主人原话，一字不改。 */
    private static final String HINT =
            "你能看到这里说明模块成功注入但是拉不起来，"
            + "请检查隐藏应用列表是否排除了模块主包";

    private static String bodyOf(String reason) {
        return "模块已注入，但界面没能拉起来。"
                + (reason == null || reason.length() == 0 ? "" : "\n（" + reason + "）");
    }

    /** 供 Compose 版登记「当前有一个弹窗在显示」—— 保证全局唯一。 */
    static void markShowing(Dialog d) {
        sShowing = d;
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
