// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * GmRichLink —— 「让富文本里的字变成可点击」🐲 尼得亚伯 2026-10-05
 *
 * <h3>★ 为什么是这条路（全链实证，不是猜的）</h3>
 * Compose 里"我们自己塞一个控件"对我们封死（{@code AndroidView} 是 {@code @Composable}，
 * Composable 的调用顺序是 compose 编译器在编译期算好的，纯 javac 手写必然破坏 composition）。
 * 但宿主<b>自己的 markdown 链接</b>是可点的 —— 它走的就是 Compose 1.7 的原生机制：
 *
 * <pre>
 *   // 宿主 or6.smali（= AnnotatedStringExtKt，markdown 的 appendLabelLink 那条路）逐字：
 *   new-instance v3, Lri6;                          // LinkAnnotation.Clickable
 *   invoke-direct {v3, v2, v0, v8}, Lri6;->&lt;init&gt;(Ljava/lang/String;Lcla;Lti6;)V
 *   invoke-virtual {p0, v3}, Lin;->h(Lsi6;)I        // ★ Builder.pushLink(link)
 *   invoke-virtual {p0, v1}, Lin;->e(Ljava/lang/String;)V   // append(显示文字)
 *   invoke-virtual {p0},     Lin;->f()V             // pop
 * </pre>
 *
 * ⇒ <b>我们只要照抄这个姿势，就能把任意一段文字变成"宿主自己认可的可点击链接"。</b>
 * 点击的回调是 {@code ti6}(LinkInteractionListener) —— 是个<b>接口</b>，
 * 所以在纯 Java 侧用 {@link Proxy} 动态代理就能实现，<b>不需要编译期看到宿主类</b>
 * （这正是"铁律：模块不依赖宿主类"允许的做法）。
 *
 * <h3>★ 活的下来的两道证明（都已扒过字节码）</h3>
 * <ol>
 *   <li>{@code in.k()} 出的 AnnotatedString 会保留 annotation ——
 *       {@code kn(String,List)} 构造器<b>直接转调</b> {@code kn(List,String)}，
 *       而后者把<b>原始整个 List 存在字段 a</b>（{@code kn.a(I)} = getLinkAnnotations 就是筛这个字段）。</li>
 *   <li>{@code fz2.p} 里<b>没有任何 new kn</b>，只读 {@code kn.b}（文本）⇒ 我们换掉的 args[0]
 *       原样流到绘制层，annotation 不会被中途吃掉。</li>
 * </ol>
 *
 * <h3>⚠️ 混淆名纪律</h3>
 * 这一整套（{@code si6/ri6/cla/ti6/in.h}）全是 R8 改的名字。所以：
 * <b>候选名 → 结构自检 → 才启用</b>；自检不过 ⇒ {@link #ready()} 为 false，
 * 调用方降级（只把标签剥掉，不让 {@code <Suggestion>} 露在界面上），<b>绝不连累宿主</b>。
 *
 * <h3>⚠️ 热路径纪律</h3>
 * 每次渲染都会 new 一个 Proxy listener + 一个 TextLinkStyles。这条路只在
 * "文本里真的出现 {@code <Suggestion>}" 时才走到（见 {@code GmRichTextHook.mayRender} 的第一道闸），
 * 所以频率可控；但 listener 里仍然<b>全 try/catch</b>，异常绝不放回宿主。
 */
public final class GmRichLink {

    // ─────────────────────── 候选混淆名（升级后重新反查，别猜）───────────────────────

    /** AnnotatedString.Builder —— 字段 a=StringBuilder、b/c=ArrayList；h(link)=pushLink
     *  <p>2.5.2 `in` · 2.6.x `jn` → `kn` · 2.7.1 `kn` · **2.7.2 `qn`**
     *  <p>★ 2026-10-31：`qn` 逐条对上了 —— `implements Appendable` / `a:StringBuilder`
     *  / `b:ArrayList` / `h(Lho6;)I`（pushLink）/ `e(String)`（append）/ `f()`（pop）/ `k()Lsn;` */
    private static final String[] CAND_IN  = {"rn", "qn", "kn", "jn", "in"};
    // ★ 2026-11-07（3.76.0）· 2.7.5 = **rn**（Appendable + a:StringBuilder + h(Lno6;)I + e/f/k）
    /** LinkAnnotation.Clickable —— <init>(String tag, styles, listener)
     *  <p>2.6.2 `wi6` · 2.7.1 `em6` · 2.7.2 `fo6` · **2.7.5 `lo6`**
     *  <p>⚠️ 2.7.5 里 `lo6`(Clickable) 与 `mo6`(Url) **构造器签名逐位相同**
     *  `(String, nxa=TextLinkStyles, oo6=Listener)`、同父 `no6` ⇒ 结构上分不开，
     *  只能靠类里的 toString 常量：lo6 有 "LinkAnnotation.Clickable(tag="、
     *  mo6 有 "LinkAnnotation.Url(url=" ⇒ **顺序必须先 Clickable**，别按字母排。 */
    private static final String[] CAND_RI6 = {"lo6", "fo6", "em6", "wi6", "xi6"};

    // ★★ 2026-10-31 大改：**只猜两个名字，其余全部结构派生**
    //
    //   原来五个类各自拿候选名硬撞（kn/gm6/em6/tra/hm6），升级后只要有一个名字被 R8
    //   复用给别的类，就会「找得到类、结构却不对」⇒ 自检失败 ⇒ 建议按钮降级成死文字。
    //   2.7.1 的 `yi6` 就这么坑过一次，2.7.2 又轮到整串（五个全换）⇒ 主人报「点不动」。
    //
    //   现在的做法：**只认 Builder**（它的指纹最硬：pushLink 是唯一的 `(X)I` 单参返回 int），
    //   然后从 `h(X)I` 的**参数类型**反推出 LinkAnnotation 父类 `X`，
    //   再从 Clickable 的构造器 `(String, Y, Z)` 推出 `Y`=TextLinkStyles、`Z`=Listener。
    //   **一个名字变了只影响一条候选**，其余自己是算出来的。

    // ─────────────────────── 宿主类句柄 ───────────────────────

    private static Class<?> cIn;
    private static Class<?> cSi6;
    private static Class<?> cRi6;
    private static Class<?> cCla;
    private static Class<?> cTi6;

    private static Constructor<?> ctRi6;
    private static Constructor<?> ctCla;

    private static Method mPushLink;      // in.h(si6) : int    ← pushLink
    private static Method mAppendStr;     // in.e(String) : void ← append(纯文本)
    private static Method mPop;           // in.f() : void      ← pop

    // ─────────────────────── 状态 ───────────────────────

    private static volatile boolean sTried = false;
    private static volatile boolean sReady = false;
    private static volatile String sWhy = "未初始化";
    private static volatile int sLinks = 0;

    private GmRichLink() {}

    /** 链接能力是否就绪；没就绪时调用方要自己降级。 */
    public static boolean ready() {
        return sReady;
    }

    /** 没就绪的原因（给日志/UI 看）。 */
    public static String why() {
        return sWhy;
    }

    /** 自检结论串（给 FdmEntry 日志用）。 */
    public static String status() {
        return (sReady ? "已就绪" : "未就绪") + " · " + sWhy + "（已出 " + sLinks + " 个可点击）";
    }

    // ═══════════════════════════ ① 自检 ═══════════════════════════

    /**
     * 结构自检 —— 全过才算就绪。任何一步不过 ⇒ 记原因、整体不启用。
     *
     * @return 就绪为 true；false 时调用方必须降级
     */
    public static boolean prepare(ClassLoader cl) {
        if (sTried) return sReady;
        synchronized (GmRichLink.class) {
            if (sTried) return sReady;
            sTried = true;
            try {
                // ① Builder —— 唯一需要"猜名字"的地方，但要过结构自检才认
                cIn = null;
                for (String n : CAND_IN) {
                    Class<?> c = load(cl, new String[]{n});
                    if (c != null && isBuilder(c)) {
                        cIn = c;
                        break;
                    }
                }
                if (cIn == null) return bail("Builder 没找到（候选 " + join(CAND_IN) + " 都不像）");

                // ② LinkAnnotation 父类 ← pushLink 的**参数类型**（不猜名字）
                Method push = findPushLink(cIn);
                if (push == null) return bail("Builder 里没有 h(X)I（pushLink）");
                cSi6 = push.getParameterTypes()[0];

                // ③ Clickable ← 候选名里唯一「是 cSi6 子类 + 有 (String,?,?) 构造器」的
                cRi6 = null;
                for (String n : CAND_RI6) {
                    Class<?> c = load(cl, new String[]{n});
                    if (c == null || !cSi6.isAssignableFrom(c)) continue;
                    Constructor<?> ct = pickCtor(c, cSi6);
                    if (ct != null) {
                        cRi6 = c;
                        ctRi6 = ct;
                        break;
                    }
                }
                if (cRi6 == null) return bail("Clickable 没找到（候选 " + join(CAND_RI6) + " 都对不上）");
                ctRi6.setAccessible(true);

                // ④ TextLinkStyles / Listener ← 直接从构造器参数推出来
                Class<?>[] ps = ctRi6.getParameterTypes();       // (String, styles, listener)
                cCla = ps[1];
                cTi6 = ps[2];
                if (!cTi6.isInterface()) return bail("listener 位不是接口（没法动态代理）：" + cTi6.getName());

                ctCla = null;
                for (Constructor<?> ct : cCla.getDeclaredConstructors()) {
                    if (ct.getParameterCount() == 4) {
                        ctCla = ct;
                        break;
                    }
                }
                if (ctCla == null) return bail("TextLinkStyles 的 4 参构造器没找到");
                ctCla.setAccessible(true);

                // ⑤ Builder 三件套
                mPushLink = push;
                mPushLink.setAccessible(true);
                mAppendStr = pick(cIn, "e", String.class);
                mPop = pick(cIn, "f");
                if (mAppendStr == null) return bail("Builder.e(String) 没找到");
                if (mPop == null) return bail("Builder.f()（pop）没找到");

                sWhy = "自检全过（Builder=" + cIn.getSimpleName()
                        + " · Link=" + cSi6.getSimpleName()
                        + " · Clickable=" + cRi6.getSimpleName()
                        + " · Styles=" + cCla.getSimpleName()
                        + " · Listener=" + cTi6.getSimpleName() + "）";
                sReady = true;
                GmUtil.log("richLink 自检 OK：" + sWhy);
                return true;
            } catch (Throwable t) {
                try {
                    GmUtil.logFail("richLink.prepare", t);
                } catch (Throwable ignore) {
                    // 日志都失败就算了
                }
                sWhy = "自检抛异常：" + t;
                sReady = false;
                return false;
            }
        }
    }

    private static String join(String[] a) {
        StringBuilder sb = new StringBuilder();
        for (String s : a) {
            if (sb.length() > 0) sb.append('/');
            sb.append(s);
        }
        return sb.toString();
    }

    /**
     * Builder 指纹 —— 三样都要对：
     * <ol>
     *   <li>{@code implements Appendable}（AnnotatedString.Builder 就是 Appendable）</li>
     *   <li>有 {@code a:StringBuilder} 字段（内容就在这里长出来）</li>
     *   <li>有 {@code h(X)I} 单参返回 int 的方法（唯一 = pushLink）</li>
     * </ol>
     * 只对上名字、对不上指纹的 ⇒ **不认**（R8 会把名字挪给别的类，2.7.1 的 {@code yi6} 就坑过）。
     */
    private static boolean isBuilder(Class<?> c) {
        try {
            if (!Appendable.class.isAssignableFrom(c)) return false;
        } catch (Throwable t) {
            return false;
        }
        boolean hasSb = false;
        try {
            hasSb = c.getDeclaredField("a").getType() == StringBuilder.class;
        } catch (Throwable ignore) {
        }
        if (!hasSb) return false;
        return findPushLink(c) != null;
    }

    /** 找 {@code h(X)I}：单参、返回 int。2.7.1/2.7.2 都叫 h；变了名字也能认出来。 */
    private static Method findPushLink(Class<?> c) {
        for (Method m : c.getDeclaredMethods()) {
            if (m.getParameterCount() != 1) continue;
            if (m.getReturnType() != int.class) continue;
            Class<?> p = m.getParameterTypes()[0];
            if (p.isPrimitive() || p == String.class) continue;
            if (p.getName().startsWith("java.")) continue;
            if (!"h".equals(m.getName())) continue;      // 名字先按 h 认（两代都没改）
            return m;
        }
        return null;
    }

    /** 找 {@code (String, styles, listener)} 构造器，且 listener 是接口、styles 不是接口。 */
    private static Constructor<?> pickCtor(Class<?> c, Class<?> linkSuper) {
        for (Constructor<?> ct : c.getDeclaredConstructors()) {
            Class<?>[] ps = ct.getParameterTypes();
            if (ps.length != 3) continue;
            if (ps[0] != String.class) continue;
            if (!ps[2].isInterface()) continue;
            if (ps[1].isInterface()) continue;
            return ct;
        }
        return null;
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

    private static Method pick(Class<?> c, String name, Class<?>... ps) {
        try {
            Method m = c.getDeclaredMethod(name, ps);
            m.setAccessible(true);
            return m;
        } catch (Throwable t) {
            return null;
        }
    }

    // ═══════════════════════════ ② 出链接 ═══════════════════════════

    /**
     * 往 Builder 里压一段「可点击的文字」。
     *
     * <p>姿势与宿主 {@code or6} 完全一致：<b>pushLink → append(文字) → pop</b>。
     * 文字的<b>样式</b>由宿主的默认链接样式决定（主题色 + 下划线）——
     * 这一版先不自定义 {@code TextLinkStyles}（最小变量原则：先确认"能不能点"），
     * 样式留到确认后再说。
     *
     * @param nb      AnnotatedString.Builder（宿主实例）
     * @param tag     链接标识（Kotlin 侧要求非空；我们只用来做日志区分）
     * @param label   屏幕上显示的文字
     * @param payload 被点击时要"回复"给 AI 的文字
     */
    public static void emitLink(Object nb, String tag, String label, String payload) throws Exception {
        if (!sReady) throw new IllegalStateException("richLink 未就绪：" + sWhy);
        if (nb == null) return;
        if (label == null || label.isEmpty()) label = "\u25B8";
        Object link = newLink(tag, label, payload);
        mPushLink.invoke(nb, link);          // ★ Builder.pushLink(link)
        mAppendStr.invoke(nb, label);        // ★ 文字落进 link 区间
        mPop.invoke(nb);                     // ★ pop
        sLinks++;
    }

    /**
     * 造一个 {@code LinkAnnotation.Clickable}：
     * <b>listener 用 {@link Proxy} 实现宿主接口 —— 这是"模块不依赖宿主类"的正解。</b>
     *
     * <p>点击时宿主（Compose 的 TextLinkScope）会调 listener 的 {@code a(Lsi6;)V}，
     * 我们的 InvocationHandler 就在那一刻接手 —— 闭包里直接带着 payload，
     * <b>不需要通过 tag 反查</b>（每个建议各自捕获自己那句话）。
     */
    private static Object newLink(final String tag, final String label, final String payload) throws Exception {
        final String tagF = (tag == null || tag.isEmpty()) ? "fdm_sug" : tag;

        InvocationHandler h = new InvocationHandler() {
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                try {
                    String n = method.getName();
                    // Object 的三件套要正确返回，否则 Compose 内部做比较时可能炸
                    if ("toString".equals(n)) return "FdmRichLink(" + label + ")";
                    if ("hashCode".equals(n)) return Integer.valueOf(System.identityHashCode(proxy));
                    if ("equals".equals(n)) {
                        return Boolean.valueOf(args != null && args.length > 0 && proxy == args[0]);
                    }
                    // ★ 被点到了！
                    GmUtil.log("[建议] \u2605 点到了！label=" + label + " payload=" + payload);
                    GmSendProbe.onSuggestClick(payload);
                } catch (Throwable t) {
                    // ★ 点击回调里的铁律：绝不让异常漏回宿主
                    try {
                        GmUtil.logFail("[建议] 点击回调异常", t);
                    } catch (Throwable ignore) {
                        // 算了
                    }
                }
                return null;
            }
        };

        Object listener = Proxy.newProxyInstance(cTi6.getClassLoader(),
                new Class<?>[]{cTi6}, h);

        // 四个样式全 null ⇒ 用宿主自己的默认链接样式（主题色 + 下划线）
        Object styles = ctCla.newInstance(null, null, null, null);

        return ctRi6.newInstance(tagF, styles, listener);
    }
}
