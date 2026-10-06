// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.view.MotionEvent;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * GmSendProbe —— 「发送入口」定位探针 · 兼建议点击的落点 🐲 尼得亚伯 2026-10-05
 *
 * <h3>要解决什么</h3>
 * 2.5.2 时代我们已经跑通过「模块自己发一条消息」（真机验证，见 {@code 专题/音频通话.md} §2.3）：
 * <pre>
 *   Lyp1; input = new Lyp1();       // 输入框状态
 *   input.c("文字");                 // 写文字
 *   Lao1;->I(Lyp1;)V                // ★ 发送（等价于点发送按钮）
 * </pre>
 * 底座里那套 {@code GmCallDialog.testSend()/send()} 也<b>原样还在</b>，
 * 但它写死了 2.5.2 的锚点，在 2.6.1 上有两道断点：
 * <ol>
 *   <li><b>{@code ao1} 这个名字被别的类抢了</b>（2.6.1 的 {@code ao1} 是个 Dagger 集合绑定类，
 *       没有 I/J 方法）⇒ {@code GmCallHook} 早先根本没挂上；</li>
 *   <li><b>{@code yp1}（输入框状态类）在 2.6.1 未定位</b>（{@code GmRemap} 里 = null）
 *       ⇒ {@code sYp1}=null ⇒ {@code send()} 第一道守卫就 return。</li>
 * </ol>
 *
 * <h3>★ v2：为什么改成「触摸窗口聚焦」</h3>
 * v1 把 {@code gh2} 全部「单参 + void」方法挂上、每次命中打一行。
 * 真机日志（2026-10-05）暴露两个问题：
 * <pre>
 *   [发送探针] ★ 命中 gh2.c 参数=b42（第 65 次）
 *   [发送探针] ★ 命中 gh2.O 参数=java.lang.String（第 66 次）
 * </pre>
 * ① {@code c}/{@code O} 是<b>高频</b>调用（90 秒里 30+ 次）⇒ 直接看日志分不出哪次是"发送"；
 * ② 带调用栈的详细日志只打了前 10 次（节流），**真正想看的那次栈刚好没留下**。
 *
 * <p>⇒ v2 换策略：<b>只记「用户刚摸过屏幕 1.5 秒内」的命中</b>。
 * 主人点一次发送按钮 ⇒ 日志里就只有那一小段，<b>每条都带调用栈和参数值</b>，一眼可辨。
 * 窗口外的命中一律静默（只累加计数），窗口打开时才顺便打一行上轮汇总 —— 既不刷屏，也不丢信息。
 *
 * <h3>⚠️ 这一版仍然是探针，不是功能</h3>
 * 所有 hook <b>只读只打日志</b>，不改任何参数、不动返回值。
 */
public final class GmSendProbe {

    /** 2.6.1 的会话提供接口（= 2.5.2 的 ao1）。宿主升级必变，跟 GmRemap 一起重定位。 */
    private static final String[] CAND_GH2 = {"gh2"};

    /** 触摸后的「用户操作窗口」—— 只有这个窗口内的命中才值得记。 */
    private static final long TOUCH_WINDOW = 1500L;
    /** 单窗口内最多打多少条（防滑动时刷屏）。 */
    private static final int WIN_MAX = 24;
    /** 参数是字符串时，最多抄多少字进日志。 */
    private static final int STR_MAX = 60;

    private static volatile long sTouchAt = 0L;
    private static volatile long sWinTouch = 0L;
    private static volatile int sWinCount = 0;

    private static volatile int sHits = 0;
    private static volatile String sLast = "";

    /** 各方法累计命中次数（窗口外也在数，供汇总用）。 */
    private static final HashMap<String, Integer> sPer = new HashMap<String, Integer>();
    private static volatile long sSumAt = 0L;

    private GmSendProbe() {}

    /** 给 UI/日志看的自检结论。 */
    public static String status() {
        return "命中 " + sHits + " 次" + (sLast.isEmpty() ? "" : "，最近：" + sLast);
    }

    // ═══════════════════════════ ① 安装 ═══════════════════════════

    public static void install(ClassLoader cl) {
        installTouch(cl);
        try {
            Class<?> c = null;
            for (String n : CAND_GH2) {
                try {
                    c = Class.forName(n, false, cl);
                    if (c != null) break;
                } catch (Throwable ignore) {
                    // 换下一个候选
                }
            }
            if (c == null) {
                GmUtil.log("[发送探针] gh2 没找到 —— 宿主可能改版了");
                return;
            }

            int n = 0;
            for (Method m : c.getDeclaredMethods()) {
                if (!Modifier.isPublic(m.getModifiers())) continue;
                if (Modifier.isStatic(m.getModifiers())) continue;
                if (m.isSynthetic() || m.isBridge()) continue;
                if (m.getReturnType() != void.class) continue;
                // ★ v2 放宽：不再限定"单参" —— gh2 有 9 个无参 void（A/D/P/Q/j0/k0/l/n/p），
                //   如果发送被重构成「从组件内部读输入框状态」，它就是无参的。
                //   只挂 void 返回是刻意的：getter 多为非 void，而那些在 Composable 重组时
                //   可能每帧被调几十次，挂上去会掉帧。

                m.setAccessible(true);
                final String mn = m.getName();
                final Class<?>[] pts = m.getParameterTypes();
                XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam p) {
                        try {
                            onHit(mn, pts, p);
                        } catch (Throwable ignore) {
                            // 探针里的铁律：绝不让异常漏回宿主
                        }
                    }
                });
                n++;
                GmUtil.log("[发送探针] 已挂 gh2." + mn + sig(pts));
            }
            GmUtil.log("[发送探针] 共挂 " + n + " 个候选（全部 void）"
                    + " —— 请在会话里【输入一句话 → 点发送按钮】，日志会只留那一下");
        } catch (Throwable t) {
            GmUtil.logFail("[发送探针] 安装失败", t);
        }
    }

    /**
     * 挂触摸 —— 只为了给"用户操作窗口"打时间戳。
     *
     * <p>用 {@code Activity.dispatchTouchEvent}（一次点击一次，不像 View 那层会刷屏）。
     * 底座也挂过它，Xposed 允许多钩共存，各跑各的。
     */
    private static void installTouch(ClassLoader cl) {
        try {
            XposedHelpers.findAndHookMethod("android.app.Activity", cl,
                    "dispatchTouchEvent", MotionEvent.class, new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            try {
                                Object a0 = (p.args != null && p.args.length > 0) ? p.args[0] : null;
                                if (!(a0 instanceof MotionEvent)) return;
                                int act = ((MotionEvent) a0).getActionMasked();
                                if (act == MotionEvent.ACTION_DOWN || act == MotionEvent.ACTION_UP) {
                                    sTouchAt = System.currentTimeMillis();
                                }
                            } catch (Throwable ignore) {
                                // 算了
                            }
                        }
                    });
            GmUtil.log("[发送探针] 触摸窗口已挂（Activity.dispatchTouchEvent）");
        } catch (Throwable t) {
            GmUtil.logFail("[发送探针] 触摸窗口挂失败（不影响 gh2 探针）", t);
        }
    }

    // ═══════════════════════════ ② 命中处理 ═══════════════════════════

    private static void onHit(String mn, Class<?>[] pts, XC_MethodHook.MethodHookParam p) {
        sHits++;
        String key = "gh2." + mn;
        synchronized (sPer) {
            Integer v = sPer.get(key);
            sPer.put(key, Integer.valueOf(v == null ? 1 : v.intValue() + 1));
        }

        long now = System.currentTimeMillis();
        long t = sTouchAt;
        boolean inWin = (t > 0L) && (now - t < TOUCH_WINDOW);

        if (!inWin) return;                       // ★ 窗口外一律静默（不写日志 = 不刷屏）

        // 新窗口 ⇒ 重置计数 + 顺便打一行上轮汇总
        if (t != sWinTouch) {
            sWinTouch = t;
            sWinCount = 0;
            if (now - sSumAt > 5000L) {           // 汇总别太频繁
                sSumAt = now;
                GmUtil.log("[发送探针] 累计：" + sumLine());
            }
            GmUtil.log("[发送探针] ══ 用户操作窗口开始（触摸后 " + (now - t) + "ms）══");
        }
        if (sWinCount >= WIN_MAX) return;
        sWinCount++;

        String argDesc = desc(p);
        sLast = "gh2." + mn + sig(pts);
        GmUtil.log("[发送探针] \u2605 gh2." + mn + sig(pts) + " → " + argDesc
                + "  t+" + (now - t) + "ms  this=" + cn(p.thisObject));
        GmUtil.log("[发送探针]    栈=" + GmUtil.stack());
    }

    /** 方法签名，如 {@code (String)V} / {@code ()V}。 */
    private static String sig(Class<?>[] pts) {
        StringBuilder sb = new StringBuilder("(");
        if (pts != null) {
            for (int i = 0; i < pts.length; i++) {
                if (i > 0) sb.append(',');
                sb.append(pts[i].getSimpleName());
            }
        }
        return sb.append(")V").toString();
    }

    /** 把参数描述成人看得懂的样子（字符串就抄内容，其它给类名）。 */
    private static String desc(XC_MethodHook.MethodHookParam p) {
        try {
            if (p.args == null || p.args.length == 0) return "\uFF08\u65E0\u53C2\uFF09";
            StringBuilder sb = new StringBuilder();
            int max = Math.min(p.args.length, 3);
            for (int i = 0; i < max; i++) {
                if (i > 0) sb.append(", ");
                sb.append(one(p.args[i]));
            }
            if (p.args.length > max) sb.append(", \u2026");
            return sb.toString();
        } catch (Throwable t) {
            return "?";
        }
    }

    private static String one(Object a0) {
        if (a0 == null) return "null";
        if (a0 instanceof String) {
            return "\"" + trim((String) a0) + "\"";
        }
        if (a0 instanceof Number || a0 instanceof Boolean) return String.valueOf(a0);
        // ★ v3：对象参数 —— 把它的 String 字段 dump 出来。
        //   实证：gh2 的「统一事件入口」gh2.c(j42) 收到的是 b42，而 b42 唯一字段就是
        //   a:Ljava/lang/String;（事件名，如 "open_session_list"）⇒ 一 dump 就知道动作叫什么。
        return a0.getClass().getSimpleName() + fields(a0);
    }

    /** 反射读对象的 String 字段（最多 4 个）—— 只 dump 字符串，够看出来"这是什么动作"。 */
    private static String fields(Object o) {
        try {
            StringBuilder sb = new StringBuilder();
            int n = 0;
            for (java.lang.reflect.Field f : o.getClass().getDeclaredFields()) {
                if (f.getType() != String.class) continue;
                if (java.lang.reflect.Modifier.isStatic(f.getModifiers())) continue;
                f.setAccessible(true);
                Object v = f.get(o);
                if (!(v instanceof String)) continue;
                if (n > 0) sb.append(' ');
                sb.append(f.getName()).append("=\"").append(trim((String) v)).append('"');
                n++;
                if (n >= 4) break;
            }
            return n == 0 ? "" : "{" + sb + "}";
        } catch (Throwable t) {
            return "";
        }
    }

    private static String trim(String s) {
        if (s == null) return "";
        if (s.length() > STR_MAX) s = s.substring(0, STR_MAX) + "\u2026";
        return s.replace('\n', '\u23CE');
    }

    /** 各方法累计次数，一行打完。 */
    private static String sumLine() {
        StringBuilder sb = new StringBuilder();
        synchronized (sPer) {
            Iterator<Map.Entry<String, Integer>> it = sPer.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<String, Integer> e = it.next();
                if (sb.length() > 0) sb.append(" · ");
                sb.append(e.getKey()).append('=').append(e.getValue());
            }
        }
        return sb.length() == 0 ? "（无）" : sb.toString();
    }

    private static String cn(Object o) {
        return o == null ? "null" : o.getClass().getName();
    }

    // ═══════════════════════════ ③ 建议点击的落点 ═══════════════════════════

    /**
     * 用户点了 {@code <Suggestion>} 那个按钮。
     *
     * <p><b>当前（探针版）只打日志</b> —— 目的有两个：
     * <ol>
     *   <li>证明"我们塞进 AnnotatedString 的 listener 真的会被点到"（整条路唯一的未验证环节）；</li>
     *   <li>顺便把 {@code payload} 抄进日志，主人一眼能看到"点的是哪句"。</li>
     * </ol>
     * 「发送入口」一旦确认，这里就换成真正的发送。
     *
     * @param payload 该点一下要"回复"给 AI 的文字
     */
    public static void onSuggestClick(String payload) {
        try {
            GmUtil.log("[建议] \u2605\u2605 被点了！要回复的内容 = 「" + payload + "」");
            boolean ok = GmSender.send(payload);
            if (ok) {
                GmUtil.log("[建议] \u2605 已替你发出去 ⇒ 等 AI 回答吧");
            } else {
                GmUtil.log("[建议] 发送没成功 —— " + GmSender.status());
            }
        } catch (Throwable t) {
            try {
                GmUtil.logFail("[建议] 点击处理异常", t);
            } catch (Throwable ignore) {
                // 算了
            }
        }
    }
}
