// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.ref.WeakReference;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

/**
 * GmSender —— 「模块自己发一条消息」🐲 尼得亚伯 2026-10-05
 *
 * <h3>★ 怎么摸出来的（frida 实证，见 {@code 专题/发送链路-gh2.S-2026-10-05.md}）</h3>
 * 2.5.2 的老路子（{@code new cn1(text,mask)} + {@code ao1.J(cmd)}）在 2.6.1 **全废**
 * （{@code cn1}/{@code yp1} 在 GmRemap 里都是 null，{@code ao1} 这名字还被 Dagger 类抢了）。
 *
 * <p>真正能用的是这条（**逐字抄自 2.5.2 底座 {@code GmCallDialog.hostSend()} 的思路**）：
 * <pre>
 *   gh2.h0(gh2, 文本, [], [], "", m1a, ns, false, false, false, false)
 *                                    ↑   ↑
 *                                 m1a 目标会话 —— ★ 就是它决定「发到哪个会话」
 * </pre>
 * 底座老代码里那段注释是钥匙：
 * <pre>
 *   "发送：用有会话的 component（sid 非空）"
 *   "发送：兜底（没有候选带会话 ⇒ 可能新开）"      ← ★ 踩过这个坑
 * </pre>
 *
 * <h3>★★★ 两个必须知道的坑（都真机踩过）</h3>
 * <ol>
 *   <li><b>别用 {@code gh2.S(...)}</b> —— 它不带会话参数，走的是"兜底"逻辑，
 *       <b>每发一次就开一个新会话</b>（尼尼连开 5 个空会话的教训）。</li>
 *   <li><b>必须挑「当前会话」的那个 {@code gh2} 实例</b> ——
 *       宿主进程里同时存在多个 {@code gh2}（每个打开过的会话一个），
 *       判据 = <b>{@code gh2.W().a}（会话 id）非空，且 {@code W().f}（消息表）最大</b>。
 *       拿错了（比如拿到 {@code sid=""} 的那个）就会开新会话。</li>
 * </ol>
 *
 * <h3>⚠️ 混淆名纪律</h3>
 * {@code gh2} / {@code ns} / {@code m1a} / {@code W} / {@code h0} 全是 R8 改的名字，
 * 宿主升级必变 ⇒ <b>候选名 → 结构自检 → 才启用</b>；自检不过就整条不干活，
 * 调用方降级（只打日志），<b>绝不连累宿主</b>。
 */
public final class GmSender {

    // ─────────────────────── 候选混淆名（2.6.1 实测）───────────────────────

    /** 会话组件（= 2.5.2 的 ao1） */
    private static final String[] CAND_GH2 = {"gh2"};
    /** 消息主存储（= 2.5.2 的 wr）—— 字段 a=会话id、f=LinkedHashMap 消息表 */
    private static final String[] CAND_NS  = {"ns"};
    /** 发送目标标识 —— <init>(long, String) */
    private static final String[] CAND_M1A = {"m1a"};

    /** 发送方法名（静态） */
    private static final String M_SEND = "h0";
    /** 取消息存储的方法名（实例） */
    private static final String M_NS = "W";

    // ─────────────────────── 句柄 ───────────────────────

    private static Class<?> cGh2;
    private static Class<?> cNs;
    private static Class<?> cM1a;

    private static Method mNs;          // gh2.W() : ns
    private static Method mSend;        // gh2.h0(gh2,String,List,List,String,m1a,ns,Z,Z,Z,Z) : void
    private static Field fSid;          // ns.a : String（会话 id）
    private static Field fMsgs;         // ns.f : LinkedHashMap（消息表）
    private static Constructor<?> ctM1a;// m1a(long, String)

    // ─────────────────────── 状态 ───────────────────────

    private static volatile boolean sTried = false;
    private static volatile boolean sReady = false;
    private static volatile String sWhy = "未初始化";
    private static volatile int sSent = 0;

    /** 收集到的 gh2 实例（弱引用，随 GC 自动清理） */
    private static final ArrayList<WeakReference<Object>> sInst = new ArrayList<WeakReference<Object>>();

    /**
     * ★★★ 「最近活跃」的 gh2 —— <b>这是选会话最可信的依据</b>。
     *
     * <p>为什么必须有它（2026-10-05 真机 bug）：只靠"消息数最多"会选错 ——
     * 主人点了一下建议，消息**发到了另一个对话**（那个会话消息更多）。
     *
     * <p>正解：<b>当前正在显示的那个会话，它的 gh2 会被 UI 持续调用</b>（渲染/状态更新）。
     * 所以 hook {@link #M_NS}（{@code W()}，取消息存储，被调得最频繁的那个）
     * —— 每次被调就把 {@code thisObject} 记下来。<b>只赋一个引用，零日志，开销可忽略。</b>
     */
    private static volatile Object sRecent = null;
    /** sRecent 最后一次被刷新的时刻（用于判断它还新不新） */
    private static volatile long sRecentAt = 0L;
    /** 多久没用过就不信它（毫秒） */
    private static final long RECENT_TTL = 15000L;

    private GmSender() {}

    public static boolean ready() { return sReady; }
    public static String why() { return sWhy; }
    public static int sent() { return sSent; }

    public static String status() {
        return (sReady ? "已就绪" : "未就绪") + " · " + sWhy
                + "（实例 " + sInst.size() + " 个 / 已发 " + sSent + " 条）";
    }

    // ═══════════════════════════ ① 自检 ═══════════════════════════

    public static boolean prepare(ClassLoader cl) {
        if (sTried) return sReady;
        synchronized (GmSender.class) {
            if (sTried) return sReady;
            sTried = true;
            try {
                cGh2 = load(cl, CAND_GH2);
                cNs  = load(cl, CAND_NS);
                cM1a = load(cl, CAND_M1A);
                if (cGh2 == null) return bail("会话组件(gh2) 没找到");
                if (cNs == null)  return bail("消息存储(ns) 没找到");
                if (cM1a == null) return bail("m1a 没找到");

                // gh2.W() : ns
                mNs = cGh2.getDeclaredMethod(M_NS);
                mNs.setAccessible(true);
                if (mNs.getReturnType() != cNs) return bail("gh2.W() 返回的不是 ns");

                // ns.a : String（会话 id） · ns.f : Map（消息表）
                fSid = cNs.getDeclaredField("a");
                fSid.setAccessible(true);
                if (fSid.getType() != String.class) return bail("ns.a 不是 String");
                fMsgs = cNs.getDeclaredField("f");
                fMsgs.setAccessible(true);
                if (!Map.class.isAssignableFrom(fMsgs.getType())) return bail("ns.f 不是 Map");

                // m1a(long, String)
                for (Constructor<?> ct : cM1a.getDeclaredConstructors()) {
                    Class<?>[] ps = ct.getParameterTypes();
                    if (ps.length == 2 && ps[0] == long.class && ps[1] == String.class) {
                        ctM1a = ct;
                        break;
                    }
                }
                if (ctM1a == null) return bail("m1a(long,String) 构造器没找到");
                ctM1a.setAccessible(true);

                // ★ 发送方法：static h0(gh2, String, List, List, String, m1a, ns, Z, Z, Z, Z)
                Class<?>[] ps = {
                        cGh2, String.class, List.class, List.class, String.class,
                        cM1a, cNs,
                        boolean.class, boolean.class, boolean.class, boolean.class
                };
                mSend = cGh2.getDeclaredMethod(M_SEND, ps);
                mSend.setAccessible(true);
                if (!Modifier.isStatic(mSend.getModifiers())) return bail("h0 不是静态方法（签名变了？）");

                sWhy = "自检全过（gh2.W()/ns.a/ns.f/m1a/h0）";
                sReady = true;
                GmUtil.log("gmSender 自检 OK：" + sWhy);
                return true;
            } catch (Throwable t) {
                try {
                    GmUtil.logFail("gmSender.prepare", t);
                } catch (Throwable ignore) {
                    // 算了
                }
                sWhy = "自检抛异常：" + t;
                sReady = false;
                return false;
            }
        }
    }

    private static boolean bail(String why) {
        sWhy = why;
        return false;
    }

    private static Class<?> load(ClassLoader cl, String[] cands) {
        for (String n : cands) {
            try {
                Class<?> c = Class.forName(n, false, cl);
                if (c != null) return c;
            } catch (Throwable ignore) {
                // 换下一个候选
            }
        }
        return null;
    }

    // ═══════════════════════════ ② 收集 gh2 实例 ═══════════════════════════

    /**
     * 装钩子 —— <b>hook gh2 的构造器</b>，把每个新建的实例收进弱引用表。
     *
     * <p>为什么必须收集：宿主进程里同时活着<b>多个</b> gh2（每个打开过的会话一个），
     * 而"发到哪儿"取决于用哪一个（见类注释的坑 #2）。
     */
    public static void install(ClassLoader cl) {
        if (!sReady) return;
        try {
            int n = 0;
            for (Constructor<?> ct : cGh2.getDeclaredConstructors()) {
                try {
                    ct.setAccessible(true);
                    XposedBridge.hookMethod(ct, new XC_MethodHook() {
                        @Override
                        protected void afterHookedMethod(MethodHookParam p) {
                            try {
                                Object x = p.thisObject;
                                if (x == null) return;
                                synchronized (sInst) {
                                    // 去重（同一个实例别塞两次）
                                    Iterator<WeakReference<Object>> it = sInst.iterator();
                                    while (it.hasNext()) {
                                        if (it.next().get() == x) return;
                                    }
                                    sInst.add(new WeakReference<Object>(x));
                                    if (sInst.size() > 16) {
                                        // 防膨胀：清掉已被 GC 的
                                        Iterator<WeakReference<Object>> it2 = sInst.iterator();
                                        while (it2.hasNext()) {
                                            if (it2.next().get() == null) it2.remove();
                                        }
                                    }
                                }
                            } catch (Throwable ignore) {
                                // 钩子里的铁律：绝不让异常漏回宿主
                            }
                        }
                    });
                    n++;
                } catch (Throwable ignore) {
                    // 某个构造器挂不上就算了
                }
            }
            GmUtil.log("gmSender 已挂 " + n + " 个 gh2 构造器（收集实例用）");
        } catch (Throwable t) {
            GmUtil.logFail("gmSender.install", t);
        }

        // ★★★ 关键：hook W()（取消息存储）—— 谁被调，谁就是「正在显示的那个会话」
        //   开销：一次赋值。收益：发送永远不会选错会话。
        try {
            XposedBridge.hookMethod(mNs, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    try {
                        Object x = p.thisObject;
                        if (x != null) {
                            sRecent = x;
                            sRecentAt = System.currentTimeMillis();
                        }
                    } catch (Throwable ignore) {
                        // 算了
                    }
                }
            });
            GmUtil.log("gmSender 已挂 gh2.W()（最近活跃标记 ⇒ 发送永不选错会话）");
        } catch (Throwable t) {
            GmUtil.logFail("gmSender.install/W", t);
        }
    }

    // ═══════════════════════════ ③ 发送 ═══════════════════════════

    /**
     * 挑出「当前会话」的 gh2。
     *
     * <p><b>① 首选「最近活跃」</b>（见 {@link #sRecent}）：正在显示的那个会话，
     * 它的 {@code W()} 一定刚被 UI 调过 ⇒ 这就是最可信的判据。
     *
     * <p><b>② 回退「消息数最多」</b>：只有在最近活跃不可用时才用。
     * ⚠️ 这个判据本身**不够准** —— 别的会话消息更多时就会选错（真机踩过：
     * 点建议结果发到了另一个对话）⇒ 它现在只是兜底。
     */
    private static Object pickCurrent() {
        long now = System.currentTimeMillis();

        // ① 最近活跃优先
        Object r = sRecent;
        if (r != null && (now - sRecentAt) < RECENT_TTL && hasSession(r)) {
            return r;
        }

        // ② 兜底：实例表里挑「sid 非空 + 消息数最多」
        Object best = null;
        int bestSize = -1;
        synchronized (sInst) {
            Iterator<WeakReference<Object>> it = sInst.iterator();
            while (it.hasNext()) {
                Object x = it.next().get();
                if (x == null) { it.remove(); continue; }
                try {
                    Object ns = mNs.invoke(x);
                    if (ns == null) continue;
                    String sid = (String) fSid.get(ns);
                    if (sid == null || sid.length() == 0) continue;   // ★ 空会话跳过
                    Map<?, ?> m = (Map<?, ?>) fMsgs.get(ns);
                    int sz = m == null ? 0 : m.size();
                    if (sz > bestSize) {
                        bestSize = sz;
                        best = x;
                    }
                } catch (Throwable ignore) {
                    // 这个实例读不出来就跳过
                }
            }
        }
        if (best != null) {
            GmUtil.logOnce("gmSender.pick.fallback",
                    "[发送] ⚠ 最近活跃不可用，回退到「消息数最多」的会话 —— 可能不准，请留意");
        }
        return best;
    }

    /** 这个 gh2 带不带会话（{@code W().a} 非空） */
    private static boolean hasSession(Object gh) {
        try {
            Object ns = mNs.invoke(gh);
            if (ns == null) return false;
            String sid = (String) fSid.get(ns);
            return sid != null && sid.length() > 0;
        } catch (Throwable t) {
            return false;
        }
    }

    /**
     * 把一段文本**发到当前会话**（等价于用户自己打字 + 点发送）。
     *
     * @param text 要发的文字
     * @return 成功发起为 true；没找到可用会话 / 锚点没就绪为 false（调用方自己决定要不要提示）
     */
    public static boolean send(String text) {
        if (!sReady) {
            GmUtil.logOnce("gmSender.notReady", "发送不可用（" + sWhy + "）");
            return false;
        }
        if (text == null || text.isEmpty()) return false;

        try {
            Object gh = pickCurrent();
            if (gh == null) {
                GmUtil.logOnce("gmSender.noSession",
                        "没找到「带会话」的 gh2 实例（实例表 " + sInst.size() + " 个）—— 请先进一个会话");
                return false;
            }
            Object ns = mNs.invoke(gh);
            String sid = (String) fSid.get(ns);

            // m1a：跟宿主自己的默认行为一致（随机 id + 开机时刻）
            Object m1a = ctM1a.newInstance(
                    Long.valueOf(android.os.SystemClock.elapsedRealtime()),
                    UUID.randomUUID().toString());

            mSend.invoke(null, gh, text,
                    new ArrayList<Object>(), new ArrayList<Object>(), "",
                    m1a, ns,
                    Boolean.FALSE, Boolean.FALSE, Boolean.FALSE, Boolean.FALSE);

            sSent++;
            GmUtil.log("[发送] \u2605 已发到会话 " + sid + "：「" + text + "」（第 " + sSent + " 条）");
            return true;
        } catch (Throwable t) {
            GmUtil.logFail("[发送] 失败", t);
            return false;
        }
    }
}
