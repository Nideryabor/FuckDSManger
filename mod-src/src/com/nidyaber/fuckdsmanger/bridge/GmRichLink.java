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

    // ─────────────────────── 候选混淆名（2.6.1 实测；升级后重新反查，别猜）───────────────────────

    /** AnnotatedString.Builder —— 字段 a=StringBuilder、c=ArrayList；h(si6)=pushLink */
    private static final String[] CAND_IN  = {"in"};
    /** LinkAnnotation（sealed 父类）—— 抽象 a()Lti6; b()Lcla; */
    private static final String[] CAND_SI6 = {"si6"};
    /** LinkAnnotation.Clickable —— <init>(String tag, cla styles, ti6 listener) */
    private static final String[] CAND_RI6 = {"ri6"};
    /** TextLinkStyles —— <init>(f0a,f0a,f0a,f0a)，四个都可空 */
    private static final String[] CAND_CLA = {"cla"};
    /** LinkInteractionListener —— 接口，唯一方法 a(Lsi6;)V = onClick(link) */
    private static final String[] CAND_TI6 = {"ti6"};

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
                cIn  = load(cl, CAND_IN);
                cSi6 = load(cl, CAND_SI6);
                cRi6 = load(cl, CAND_RI6);
                cCla = load(cl, CAND_CLA);
                cTi6 = load(cl, CAND_TI6);

                if (cIn  == null) return bail("Builder(in) 没找到");
                if (cSi6 == null) return bail("LinkAnnotation(si6) 没找到");
                if (cRi6 == null) return bail("LinkAnnotation.Clickable(ri6) 没找到");
                if (cCla == null) return bail("TextLinkStyles(cla) 没找到");
                if (cTi6 == null) return bail("LinkInteractionListener(ti6) 没找到");

                // ★ 结构自检（防"名字被复用"挂错类）
                if (!cSi6.isAssignableFrom(cRi6)) return bail("ri6 不是 si6 的子类（不像 Clickable）");
                if (!cTi6.isInterface()) return bail("ti6 不是接口（没法动态代理）");

                // ri6 <init>(String, cla, ti6)
                for (Constructor<?> ct : cRi6.getDeclaredConstructors()) {
                    Class<?>[] ps = ct.getParameterTypes();
                    if (ps.length == 3 && ps[0] == String.class && ps[1] == cCla && ps[2] == cTi6) {
                        ctRi6 = ct;
                        break;
                    }
                }
                if (ctRi6 == null) return bail("ri6 的 (String,cla,ti6) 构造器没找到");
                ctRi6.setAccessible(true);

                // cla <init>(SpanStyle×4) —— 参数类型就是 SpanStyle 的混淆名，我们只数个数
                for (Constructor<?> ct : cCla.getDeclaredConstructors()) {
                    if (ct.getParameterCount() == 4) {
                        ctCla = ct;
                        break;
                    }
                }
                if (ctCla == null) return bail("cla 的 4 参构造器没找到");
                ctCla.setAccessible(true);

                // Builder 三件套：h(si6)=pushLink · e(String)=append · f()=pop
                for (Method m : cIn.getDeclaredMethods()) {
                    if (!"h".equals(m.getName())) continue;
                    Class<?>[] ps = m.getParameterTypes();
                    if (ps.length == 1 && ps[0] == cSi6 && m.getReturnType() == int.class) {
                        mPushLink = m;
                        break;
                    }
                }
                if (mPushLink == null) return bail("Builder.h(si6)I（pushLink）没找到");
                mPushLink.setAccessible(true);

                mAppendStr = pick(cIn, "e", String.class);
                mPop = pick(cIn, "f");
                if (mAppendStr == null) return bail("Builder.e(String) 没找到");
                if (mPop == null) return bail("Builder.f()（pop）没找到");

                sWhy = "自检全过（in/si6/ri6/cla/ti6）";
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
