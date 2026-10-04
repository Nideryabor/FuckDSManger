package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

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
 * 底座里那套 {@code GmCallDialog.testSend()/send()} 也<b>原样还在</b>
 * （{@code tmp/base130/sm/com/nidyaber/fuckdsmanger/gm/GmCallDialog.smali}），
 * 但它写死了 2.5.2 的锚点，在 2.6.1 上有两道断点：
 * <ol>
 *   <li><b>{@code ao1} 这个名字被别的类抢了</b> —— 2.6.1 的 {@code ao1} 是个 Dagger 集合绑定类
 *       （{@code implements bx6}、构造器 {@code (String,[Lbx6;)}），<b>没有 I/J 方法</b>
 *       ⇒ {@code hookM("ao1","I")} 抛异常被吞 ⇒ {@code GmCallHook} 从没挂上 ⇒ {@code sAo1}=null；</li>
 *   <li><b>{@code yp1}（输入框状态类）在 2.6.1 未定位</b>（{@code GmRemap} 里 = null）
 *       ⇒ {@code sYp1}=null ⇒ {@code send()} 第一道守卫就 return。</li>
 * </ol>
 *
 * <h3>但发送入口已经锁定了一半</h3>
 * {@code GmRemap} 里 {@code ao1 → gh2}，且实证 {@code gh2.W()Lns;} 与旧 {@code ao1.M()}
 * <b>完全对上</b>（都是"取消息主存储"，{@code wr}→{@code ns}）⇒ <b>{@code gh2} 就是 2.6.1 的会话提供接口</b>。
 * 它的「单参 + void」public 方法只有寥寥几个 ⇒ 全部挂上，让主人手点一次发送按钮，
 * <b>哪个命中，哪个就是 2.6.1 的发送入口</b>；命中那一刻 {@code thisObject}（会话实例）
 * 和 {@code args[0]}（输入框状态）也一并到手。
 *
 * <h3>⚠️ 这一版是探针，不是功能</h3>
 * 所有 hook <b>只读只打日志</b>，不改任何参数、不动返回值。
 * 建议点击也只是打日志 —— 等"发送入口"确认后再接上去。
 */
public final class GmSendProbe {

    /** 2.6.1 的会话提供接口（= 2.5.2 的 ao1）。宿主升级必变，跟 GmRemap 一起重定位。 */
    private static final String[] CAND_GH2 = {"gh2"};

    /** 日志节流：前 N 次打全（含调用栈），之后只静默计数，免得刷屏。 */
    private static final int VERBOSE = 10;

    private static volatile int sHits = 0;
    private static volatile String sLast = "";

    private GmSendProbe() {}

    /** 给 UI/日志看的自检结论。 */
    public static String status() {
        return "命中 " + sHits + " 次" + (sLast.isEmpty() ? "" : "，最近：" + sLast);
    }

    // ═══════════════════════════ ① 安装 ═══════════════════════════

    /**
     * 在宿主进程里装探针。找不到锚点就自己 catch（宿主升级改名 ⇒ 等于没装）。
     */
    public static void install(ClassLoader cl) {
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
                if (m.getParameterCount() != 1) continue;

                m.setAccessible(true);
                final String mn = m.getName();
                final String pn = m.getParameterTypes()[0].getName();
                XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam p) {
                        try {
                            onHit(mn, pn, p);
                        } catch (Throwable ignore) {
                            // 探针里的铁律：绝不让异常漏回宿主
                        }
                    }
                });
                n++;
                GmUtil.log("[发送探针] 已挂 gh2." + mn + "(" + pn + ")V");
            }
            GmUtil.log("[发送探针] 共挂 " + n + " 个候选（单参 void）—— 请在会话里点一次发送按钮");
        } catch (Throwable t) {
            GmUtil.logFail("[发送探针] 安装失败", t);
        }
    }

    private static void onHit(String mn, String pn, XC_MethodHook.MethodHookParam p) {
        sHits++;
        String argCls;
        try {
            Object a0 = (p.args != null && p.args.length > 0) ? p.args[0] : null;
            argCls = a0 == null ? "null" : a0.getClass().getName();
        } catch (Throwable t) {
            argCls = "?";
        }
        sLast = "gh2." + mn + "(" + argCls + ")";

        GmUtil.log("[发送探针] \u2605 命中 gh2." + mn + " 参数=" + argCls + "（第 " + sHits + " 次）");
        if (sHits <= VERBOSE) {
            GmUtil.log("[发送探针]   this=" + cn(p.thisObject) + " caller=" + GmUtil.caller());
            GmUtil.log("[发送探针]   栈=" + GmUtil.stack());
        }
    }

    private static String cn(Object o) {
        return o == null ? "null" : o.getClass().getName();
    }

    // ═══════════════════════════ ② 建议点击的落点 ═══════════════════════════

    /**
     * 用户点了 {@code <Suggestion>} 那个按钮。
     *
     * <p><b>当前（探针版）只打日志</b> —— 目的有两个：
     * <ol>
     *   <li>证明"我们塞进 AnnotatedString 的 listener 真的会被点到"（这是整条路唯一的未验证环节）；</li>
     *   <li>顺便把 {@code payload} 抄进日志，主人一眼能看到"点的是哪句"。</li>
     * </ol>
     * 「发送入口」一旦确认，这里就换成真正的发送（复用底座的 {@code send} 思路）。
     *
     * @param payload 该点一下要"回复"给 AI 的文字
     */
    public static void onSuggestClick(String payload) {
        try {
            GmUtil.log("[建议] \u2605\u2605 可点击验证成功！要回复的内容 = 「" + payload + "」");
            GmUtil.log("[建议] 当前发送入口：" + status());
        } catch (Throwable ignore) {
            // 算了
        }
    }
}
