// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.util.ArrayList;
import java.util.List;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedHelpers;

/**
 * GmSugBar —— 「回复建议条」：把 {@code <Suggestion>} 那几条**从气泡里拿出来，自己画**🐲 2026-10-31
 *
 * <h3>为什么要另画（主人的 iOS 思路）</h3>
 * 2.7.2 里我们塞进 {@code AnnotatedString} 的「可点击链接」被点了没反应。
 * 链路本身是通的（{@link GmRichLink} 已经把 2.7.2 的新混淆名对上），
 * 但 2.7.2 新增的 {@code ui.markdown.selection.InlineTextSelection} 在**文字节点之上**
 * 又铺了一层选中手势层 —— 单次 tap 落在那层上，链接的 listener 收不到。
 *
 * <p>主人 2026-10-31 给的方案（iOS 那边本来就这么干的）：
 * <b>「hook AI 类，把气泡里的回复建议内容抹掉，单独几个气泡以最后一条 AI 气泡为基准跟在后面」</b>
 * ⇒ 不再依赖"文字里的链接"，改成**自己的 View**：它整块是我们创建的，
 * 触摸事件直接到我们手里，宿主那层选中手势**碰不到它**。
 *
 * <h3>⚠️ 这是**旁路**，不是替代品（默认关）</h3>
 * 开关 {@code fuckds_sugbar_on} 默认 <b>false</b>：
 * <ul>
 *   <li>关着 ⇒ 一切照旧（气泡里渲染成可点击链接，见 {@link GmRichLink}）</li>
 *   <li>开着 ⇒ 气泡里**只留白**（标记被吃掉，不留痕迹），建议改在这条上显示</li>
 * </ul>
 * 换句话说：这条是用来<b>对照验证</b>的 —— 链接真能点就用链接（更省事、跟气泡滚在一起），
 * 点不动就切到这条。两条路都在，谁好用留谁。
 *
 * <h3>保命规矩</h3>
 * 全程 try/catch；任何一步失败只写日志，<b>绝不连累宿主</b>（连 View 都挂不上就当没这功能）。
 */
public final class GmSugBar {

    /** 总开关（默认关 —— 见上面的"旁路"说明） */
    public static final String K_ON = "fuckds_sugbar_on";
    /** 距屏幕底边多高（dp）。默认 120：大致就是输入框上沿 */
    public static final String K_H = "fuckds_sugbar_h";
    /** 建议条自己消失的时间（秒）。0 = 不自动消失 */
    public static final String K_TTL = "fuckds_sugbar_ttl";

    public static final int DEF_H = 120;
    public static final int DEF_TTL = 180;

    private static volatile boolean sInstalled = false;
    private static volatile GmSugBarView sView = null;
    private static volatile ViewGroup sDecor = null;
    private static volatile Context sCtx = null;

    /** 最近一次送进来的那组建议（签名 + 时间）：同一条消息反复重组时用来去重 */
    private static volatile String sSig = "";
    private static volatile long sSigAt = 0L;

    private GmSugBar() {
    }

    // ══════════════════════════════ 安装 ══════════════════════════════

    /**
     * 挂 {@code Activity.onResume / onPause} —— 跟迷你卡同一套路数（宿主窗口里零权限子 View）。
     *
     * <p>⚠️ 只在开关打开时才真的 {@code addView}，关着的时候这条链上一个 View 都不建。
     */
    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        try {
            XposedHelpers.findAndHookMethod("android.app.Activity", cl, "onResume", new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    try {
                        Object o = p.thisObject;
                        if (!(o instanceof Activity)) return;
                        Activity a = (Activity) o;
                        sCtx = a.getApplicationContext();
                        if (!enabled(sCtx)) {
                            detachAll();
                            return;
                        }
                        attach(a);
                    } catch (Throwable t) {
                        GmUtil.logFail("【GmSugBar】onResume 处理失败", t);
                    }
                }
            });
            XposedHelpers.findAndHookMethod("android.app.Activity", cl, "onPause", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        detachAll();
                    } catch (Throwable ignore) {
                    }
                }
            });
            sInstalled = true;
            GmUtil.log("【GmSugBar】建议条钩子已挂 ✓（默认关）");
        } catch (Throwable t) {
            GmUtil.logFail("【GmSugBar】挂载失败（等于没装）", t);
        }
    }

    // ══════════════════════════════ 开关 ══════════════════════════════

    public static boolean enabled(Context c) {
        try {
            SharedPreferences s = sp(c);
            return s != null && s.getBoolean(K_ON, false);
        } catch (Throwable t) {
            return false;
        }
    }

    public static void setOn(Context ctx, boolean on) {
        try {
            sCtx = ctx;
            GmStore.write(ctx, K_ON, String.valueOf(on), "b");
            GmUtil.log("【GmSugBar】开关 → " + on
                    + (on ? "（气泡里的建议将被抹掉，改由这条显示）" : "（回到气泡内链接）"));
            if (!on) {
                detachAll();
                clear();
                return;
            }
            Activity a = curActivity();
            if (a != null) attach(a);
        } catch (Throwable t) {
            GmUtil.logFail("【GmSugBar】setOn 失败", t);
        }
    }

    public static int offsetDp(Context c) {
        int v = loadInt(c, K_H, DEF_H);
        if (v < 0) v = 0;
        if (v > 600) v = 600;
        return v;
    }

    public static int ttlSec(Context c) {
        int v = loadInt(c, K_TTL, DEF_TTL);
        if (v < 0) v = 0;
        return v;
    }

    // ══════════════════════════════ 数据入口 ══════════════════════════════

    /**
     * 一条建议。
     *
     * <p>{@code label} = 屏幕上那行字；{@code payload} = 点下去真正回给 AI 的话
     * （{@code <Suggestion>显示|回复</Suggestion>} 的两种写法都支持，见 {@code GmRichText}）。
     */
    public static final class Chip {
        public final String label;
        public final String payload;

        public Chip(String label, String payload) {
            this.label = label == null ? "" : label;
            this.payload = (payload == null || payload.isEmpty()) ? this.label : payload;
        }
    }

    /**
     * 收下「这一条 AI 消息里的全部建议」。
     *
     * <p>调用方：{@link GmRichTextHook}（每渲染一条带 {@code <Suggestion>} 的消息调一次）。
     *
     * <p><b>去重逻辑</b>：同一条消息会随重组被反复重建，签名（payload 拼起来）相同就当作
     * "同一条"，只在<b>超过 3 秒</b>没再刷时才真正刷新界面 —— 免得每帧都重建 View。
     *
     * @param chips 建议列表（空 ⇒ 清空并藏起来）
     */
    public static void publish(List<Chip> chips) {
        try {
            if (chips == null || chips.isEmpty()) {
                clear();
                return;
            }
            StringBuilder sb = new StringBuilder();
            for (Chip c : chips) {
                sb.append(c.payload).append('\u001f');
            }
            String sig = sb.toString();
            long now = System.currentTimeMillis();
            if (sig.equals(sSuppressed) && !sig.isEmpty()) return;   // 这条用过/收过了 ⇒ 别再冒出来
            boolean same = sig.equals(sSig);
            sSig = sig;
            sSigAt = now;
            if (same && sView != null && sView.shown()) return;      // 连着重组的同一组 ⇒ 不动

            if (sView != null) {
                sView.setChips(chips);
            } else {
                // 界面还没挂上（比如刚启动、onResume 还没轮到）⇒ 先存着，attach 时会取
                sPending = chips;
                Activity a = curActivity();
                if (a != null) attach(a);
            }
            GmUtil.log("【GmSugBar】建议 " + chips.size() + " 条 → " + (sView != null ? "已上屏" : "等窗口"));
        } catch (Throwable t) {
            GmUtil.logFail("【GmSugBar】publish 失败", t);
        }
    }

    private static volatile List<Chip> sPending = null;

    /** 清空并藏起来（换会话 / 关了开关 / 超时）。 */
    public static void clear() {
        sSig = "";
        sSigAt = 0L;
        sPending = null;
        GmSugBarView v = sView;
        if (v != null) {
            try {
                v.clearChips();
            } catch (Throwable ignore) {
            }
        }
    }

    /**
     * 用户自己收起的（点了一条 / 超时）—— 这里要**记住"这条消息已经用过了"**。
     *
     * <p>为什么必须有它：宿主每重组一次就会把这条消息的文本重新过一遍 {@code rebuild}，
     * 于是 {@code <Suggestion>} 又被解析、又调 {@code publish} ⇒ 建议条会**刚发完就又冒出来**。
     * 记住签名后，同一条消息的后续 publish 直接丢弃；等**另一条**消息的建议进来才换。
     */
    static void dismissByUser() {
        sSuppressed = sSig;
        clear();
        sSig = sSuppressed;              // clear() 把 sSig 清了，这里补回去（否则下一帧又对比不上）
    }

    /** 已经用过的签名（用户点过 / 超时收起）—— 同一条消息不再弹。 */
    private static volatile String sSuppressed = "";

    /** 用户点了一条 —— 发出去，然后整条收起。 */
    static void onTap(Chip c) {
        try {
            if (c == null) return;
            GmUtil.log("【GmSugBar】★ 点到了：「" + c.label + "」→ 回复「" + c.payload + "」");
            dismissByUser();
            GmSendProbe.onSuggestClick(c.payload);
        } catch (Throwable t) {
            GmUtil.logFail("【GmSugBar】onTap 失败", t);
        }
    }

    // ══════════════════════════════ 挂 / 摘 ══════════════════════════════

    private static void attach(Activity a) {
        if (a == null || a.isFinishing()) return;
        try {
            if (Build.VERSION.SDK_INT >= 17 && a.isDestroyed()) return;
        } catch (Throwable ignore) {
        }
        ViewGroup decor;
        try {
            decor = (ViewGroup) a.getWindow().getDecorView();
        } catch (Throwable t) {
            return;
        }
        if (decor == null) return;

        GmSugBarView v = sView;
        if (v != null && decor != sDecor) {
            detachAll();                       // 换窗口 ⇒ 摘旧挂新（防残影）
            v = null;
        }
        if (v != null) return;

        try {
            GmSugBarView nv = new GmSugBarView(a);
            FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            lp.gravity = Gravity.BOTTOM | Gravity.END;
            lp.bottomMargin = dp(a, offsetDp(a));
            lp.rightMargin = dp(a, 12);
            decor.addView(nv, lp);
            sView = nv;
            sDecor = decor;

            List<Chip> pend = sPending;
            if (pend != null && !pend.isEmpty()) nv.setChips(pend);
            else nv.clearChips();

            int ttl = ttlSec(a);
            if (ttl > 0) nv.scheduleAutoHide(ttl * 1000L);
            GmUtil.log("【GmSugBar】已挂到宿主窗口（离底 " + offsetDp(a) + "dp）");
        } catch (Throwable t) {
            GmUtil.logFail("【GmSugBar】attach 失败", t);
        }
    }

    private static void detachAll() {
        GmSugBarView v = sView;
        ViewGroup d = sDecor;
        sView = null;
        sDecor = null;
        if (v == null || d == null) return;
        try {
            d.removeView(v);
        } catch (Throwable ignore) {
        }
    }

    // ══════════════════════════════ 小工具 ══════════════════════════════

    private static Activity curActivity() {
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Object cur = XposedHelpers.callStaticMethod(at, "currentActivityThread");
            Object acts = XposedHelpers.callMethod(cur, "getActivities");
            // 拿不到就返回 null —— 不硬来
            if (acts instanceof Object[]) {
                Object[] arr = (Object[]) acts;
                for (int i = arr.length - 1; i >= 0; i--) {
                    if (arr[i] instanceof Activity) return (Activity) arr[i];
                }
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    private static SharedPreferences sp(Context c) {
        try {
            return GmStore.get(c);
        } catch (Throwable t) {
            return null;
        }
    }

    private static int loadInt(Context c, String k, int def) {
        try {
            SharedPreferences s = sp(c);
            if (s == null) return def;
            String v = s.getString(k, null);
            if (v == null) return def;
            return Integer.parseInt(v.trim());
        } catch (Throwable t) {
            return def;
        }
    }

    static int dp(Context c, int v) {
        try {
            return (int) (v * c.getResources().getDisplayMetrics().density + 0.5f);
        } catch (Throwable t) {
            return v;
        }
    }
}
