package com.nidyaber.fuckdsmanger.glass;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 液态玻璃 · 画布劫持 🐲 —— 整个功能的「心脏」
 *
 * <h3>为什么劫它</h3>
 * 宿主画底色的<b>唯一原语</b>：
 *
 * <pre>
 *   Luia;->v(Lc76;JLmd8;)Lc76;        （2.5.2）
 *   Lqk7;->D(Lx97;JLgn9;)Lx97;        （2.6.1 · 2026-10-02 重定位）
 *        ↑Modifier  ↑ARGB  ↑Shape
 * </pre>
 *
 * 它就是「{@code Modifier.background(色, 形状)}」的宿主包装 —— 按钮、卡片、气泡、页面底色
 * <b>全走它</b>。我们把它造出来的<b>背景元素</b>的 {@code draw(DrawScope)} 劫掉，改画玻璃。
 *
 * <h3>为什么劫 draw，而不是在 uia.v / qk7.D 里换个 Modifier</h3>
 * 要自己 {@code new} 一个 Compose 的 {@code Modifier.Element} / {@code DrawModifier}，
 * 就得 {@code implements} <b>混淆接口</b> —— 编译期根本写不出来。
 * 劫 {@code draw} 只要一个 {@code Class} + 方法名（运行时找得到），
 * 而且画的时候手里有 {@code DrawScope} ⇒ <b>玻璃画在按钮文字下面，字不会被糊掉</b>。
 *
 * <h3>怎么在混淆里找到「背景元素」类（3.29.1 修正）</h3>
 * <ol>
 *   <li>从被钩方法的<b>形参类型</b>直接拿 {@code Modifier} 接口的 Class（第 0 个参数）；</li>
 *   <li>在它上面找 {@code foldIn/foldOut} —— 判据不是「两个参数就行」，而是
 *       <b>第 2 个参数必须是接口</b>（{@code kotlin.jvm.functions.Function2}）。
 *       ⚠️ 3.29.0 就是栽在这儿：随便挑了个 {@code (Object, Object)} 的方法，
 *       {@code Proxy.newProxyInstance} 直接抛 {@code IllegalArgumentException: java.lang.Object is not an interface}
 *       ⇒ 后面整条链全没跑起来，玻璃一笔没画。</li>
 *   <li>用 {@link Proxy} 仿一个 {@code Function2} 塞进去当 operation ⇒
 *       Compose 把链上<b>每个元素</b>喂给我们（foldIn 是 (累加器, 元素)，foldOut 是 (元素, 累加器)
 *       —— 两个位置都当候选，反正后面还要筛）；</li>
 *   <li>元素类里找 {@code draw(DrawScope)}：判据是 <b>「1 个参数、返回 void、
 *       且那个参数是接口」</b>。⚠️ 3.29.0 漏了「是接口」这一条 ⇒ 会把
 *       {@code onAttach(Node)} / {@code onDetach(Node)} / {@code update(Node)} 一起钩掉
 *       并把它们 {@code setResult} 掉 ⇒ <b>节点挂不上，界面就真渲染不出来了</b>。
 *       {@code DrawScope} 是接口，{@code Node} 是类 —— 这一条就能把它们分开。</li>
 * </ol>
 */
public final class GmGlassSink {

    private GmGlassSink() {
    }

    /** 画底原语的宿主类/方法（锚点）。2.5.2 = uia.v ⇒ 2.6.1 = qk7.D（2026-10-02 重定位）。 */
    private static final String BG_CLS = "qk7";
    private static final String BG_METHOD = "D";

    private static final Set<Class<?>> sHooked = new HashSet<Class<?>>();
    private static final List<Class<?>> sElements = new ArrayList<Class<?>>();

    /**
     * 「这件背景是按钮画的」——<b>元素对象</b>级别。
     *
     * <p>为什么必须这么记：{@code GmGlassScope} 的计数只在<b>组合期</b>有效，
     * 而 {@code draw} 发生在<b>绘制期</b>（那时计数早归零）
     * ⇒ 想在绘制期认出「这是按钮的背景」，就得把<b>组合期造出来的那个元素对象</b>留个记号。
     */
    private static final Set<Object> sBtnElements =
            java.util.Collections.newSetFromMap(new java.util.WeakHashMap<Object, Boolean>());
    /** 再由 create() 把记号从「元素」传递到「Node」。 */
    private static final Set<Object> sBtnNodes =
            java.util.Collections.newSetFromMap(new java.util.WeakHashMap<Object, Boolean>());

    // ─────────── 「底色做玻璃」（A 方案）的颜色接力 ───────────
    //
    //  颜色从哪来：宿主画底原语 `uia.v / qk7.D (Modifier, long 色, Shape)` 的**第 2 个参数**。
    //  ⚠️ 兼容性关键：我们自己的「AI/用户气泡美化」改色走的**也是这个入口**
    //     ⇒ 这里拿到的就是**最终生效的那个颜色**，两套功能天然不打架。
    //
    //  接力：uia.v / qk7.D 的实参 → 元素对象 → Node → 绘制期取用
    private static volatile long sPendingColor = 0L;
    private static final java.util.Map<Object, Integer> sElementColor =
            java.util.Collections.synchronizedMap(new java.util.WeakHashMap<Object, Integer>());
    private static final java.util.Map<Object, Integer> sNodeColor =
            java.util.Collections.synchronizedMap(new java.util.WeakHashMap<Object, Integer>());

    // ─────────── 「元素轮廓」接力（2026-10-02 · 主人「都要」的 A/B/C 档）───────────
    //
    //  形状从哪来：画底原语 `qk7.D` 的**第 3 个参数**就是元素的 Shape
    //  （实测：芯片传的是 RoundedCornerShape(24,24,4,4)）；
    //  元素（eh0）把它存进字段（如 d:Lgn9）⇒ 构造完成后从字段里读，随「元素→Node」接力。
    //
    //  绘制期：Shape → createOutline(尺寸, 方向, 密度) → Outline → android.graphics.Path
    //    · 贴合（A）：玻璃按真实轮廓裁切/绘制（圆角/胶囊/异形都行）；
    //    · 仅边缘（C）：外轮廓 ∖ 内缩轮廓 = 边缘带，只在带里画玻璃。
    private static volatile Class<?> sShapeCls = null;          // gn9（Shape 接口）
    private static volatile Object sPendingShape = null;
    private static final java.util.Map<Object, Object> sElementShape =
            java.util.Collections.synchronizedMap(new java.util.WeakHashMap<Object, Object>());
    private static final java.util.Map<Object, Object> sNodeShape =
            java.util.Collections.synchronizedMap(new java.util.WeakHashMap<Object, Object>());
    /** 轮廓→路径 的配方缓存（按 Outline 类）：[包着 android Path 的字段, 它的 android Path 字段]。 */
    private static final java.util.Map<Class<?>, Object[]> sRecipe =
            java.util.Collections.synchronizedMap(new java.util.HashMap<Class<?>, Object[]>());
    /** 贴合路径缓存：node → [w, h, Path outer, Path inner]（尺寸不变就复用，别每帧算）。 */
    private static final java.util.Map<Object, Object[]> sNodeFit =
            java.util.Collections.synchronizedMap(new java.util.WeakHashMap<Object, Object[]>());
    private static volatile Method sOutlineM = null;            // gn9.a(J,Lwa6,Lpq3;)Lwv7;
    private static volatile Class<?> sOutlineCls = null;        // wv7（Outline）
    private static volatile Method sOutlineA = null;            // wv7.a()Lrr8;（边界/矩形兜底）
    private static volatile boolean sFitLogged = false;
    private static volatile boolean sFitFail = false;

    private static volatile int sPaintCount = 0;
    private static volatile int sFailStreak = 0;
    private static volatile boolean sAutoOff = false;

    public static int paintCount() {
        return sPaintCount;
    }

    /** 诊断用：挂了几个类 / 记了几个按钮 Node / 画了几次。 */
    public static String stats() {
        int el, nd;
        synchronized (sBtnElements) {
            el = sBtnElements.size();
        }
        synchronized (sBtnNodes) {
            nd = sBtnNodes.size();
        }
        return "已钩类=" + sHooked.size() + " 按钮元素=" + el
                + " 按钮Node=" + nd + " 绘制次数=" + sPaintCount;
    }

    public static void install(ClassLoader cl) {
        try {
            Class<?> bg = XposedHelpers.findClass(BG_CLS, cl);
            int n = 0;
            for (Method m : bg.getDeclaredMethods()) {
                if (!BG_METHOD.equals(m.getName())) continue;
                Class<?>[] p = m.getParameterTypes();
                if (p.length != 3) continue;
                if (p[1] != long.class) continue;         // 颜色
                if (!p[0].isInterface()) continue;        // Modifier 是接口
                if (sShapeCls == null) sShapeCls = p[2];  // ★ Shape 接口（第 3 参）——「贴合形状」的源头
                XposedBridge.hookMethod(m, new PrimitiveHook(p[0]));
                n++;
            }
            if (n == 0) {
                GmUtil.logFail("【GmGlass】没找到画底原语 " + BG_CLS + "->" + BG_METHOD, null);
                return;
            }
            GmUtil.log("【GmGlass】画底原语已挂（" + BG_CLS + "->" + BG_METHOD + " × " + n + "）");
        } catch (Throwable t) {
            GmUtil.logFail("【GmGlass】画底原语挂载失败", t);
        }
    }

    // ══════════════════════ ① 摸出「背景元素」类 ══════════════════════

    private static final class PrimitiveHook extends XC_MethodHook {
        private final Class<?> modifierCls;
        private volatile boolean tried = false;

        PrimitiveHook(Class<?> modifierCls) {
            this.modifierCls = modifierCls;
        }

        private volatile int attempts = 0;

        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            // ★ 组合期：先于元素构造，把这次画底的「颜色 / 形状」记下来（构造钩子随后会读）
            try {
                Object[] args = param.args;
                if (args != null) {
                    for (Object a : args) {
                        if (a instanceof Long) {
                            sPendingColor = (Long) a;
                        } else if (sShapeCls != null && sShapeCls.isInstance(a)) {
                            sPendingShape = a;
                        }
                    }
                }
            } catch (Throwable ignore) {
            }
        }

        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            Object ret = param.getResult();
            if (ret == null) return;

            // ★ 组合期：这个背景是按钮里面画的 ⇒ 把刚造出来的那个「元素对象」打上记号。
            //   （这一步必须在组合期做，绘制期再来认已经晚了）
            if (GmGlassScope.inButton()) {
                try {
                    Object el = lastElement(modifierCls, ret);
                    if (el != null) {
                        synchronized (sBtnElements) {
                            sBtnElements.add(el);
                        }
                    }
                } catch (Throwable ignore) {
                }
            }

            if (tried) return;
            // 一次没挖到就再试几次（不同页面/不同链上的元素类可能不一样）
            if (++attempts > 40) {
                tried = true;
                return;
            }
            try {
                discover(modifierCls, ret);
                if (!sHooked.isEmpty()) tried = true;
            } catch (Throwable t) {
                GmUtil.logFail("【GmGlass】扒背景元素失败", t);
            }
        }
    }

    /**
     * 从 Modifier 链上把<b>最后一个元素</b>掏出来。
     *
     * <p>为什么取最后一个：{@code uia.v} 的实现是
     * {@code mod.then(new se0(...))} ⇒ 新造的那个元素一定在链尾
     * （{@code CombinedModifier} 的 foldIn 是先 a 后 b）。
     */
    private static Object lastElement(Class<?> modifierCls, Object modifier) {
        for (Method m : modifierCls.getMethods()) {
            Class<?>[] p = m.getParameterTypes();
            if (p.length != 2) continue;
            if (m.getReturnType() == void.class) continue;
            int pi = -1;
            for (int k = 0; k < 2; k++) {
                if (p[k].isInterface() && p[k] != modifierCls) {
                    pi = k;
                    break;
                }
            }
            if (pi < 0) continue;
            try {
                m.setAccessible(true);
                final Object[] holder = new Object[1];
                Object proxy = Proxy.newProxyInstance(modifierCls.getClassLoader(),
                        new Class<?>[]{p[pi]}, new InvocationHandler() {
                            @Override
                            public Object invoke(Object proxy, Method method, Object[] args) {
                                if (args != null) {
                                    for (Object a : args) {
                                        if (a != null && !(a instanceof Long) && !(a instanceof Integer)) {
                                            holder[0] = a;      // 一路覆盖 ⇒ 最后留下的就是链尾
                                        }
                                    }
                                }
                                return args != null && args.length > 0 ? args[0] : null;
                            }
                        });
                Object[] args = new Object[2];
                args[pi] = proxy;
                m.invoke(modifier, args);
                return holder[0];
            } catch (Throwable ignore) {
            }
        }
        return null;
    }

    /**
     * 找折叠方法（{@code foldIn}），用假 {@code Function2} 把链上每个元素掏出来。
     *
     * <p>⚠️ <b>3.29.1 的坑</b>：宿主里 {@code Modifier} 只剩 3 个方法，
     * <pre>
     *   F0(Lsv3;)Z                                   any(谓词)
     *   X(Lwv3;Ljava/lang/Object;)Ljava/lang/Object;  foldIn
     *   r(Lc76;)Lc76;                                 then
     * </pre>
     * 而 <b>R8 全模式会把参数顺序调换</b>（{@code (initial, operation)} → {@code (operation, initial)}）
     * ⇒ 3.29.1 里「第 0 个参数必须是 Object」那条判据把它滤掉了（日志：`试了 0 个折叠方法`）。
     * 现在改成：<b>只挑「有一个接口参数、且那个接口不是 Modifier 自己」的两参方法</b>，
     * 接口参数位置上塞 Proxy，另一个位置塞 null。位置自己找，不依赖顺序。
     */
    private static void discover(Class<?> modifierCls, Object modifier) {
        int tried = 0;
        StringBuilder dump = new StringBuilder();
        for (Method m : modifierCls.getMethods()) {
            Class<?>[] p = m.getParameterTypes();
            if (p.length != 2) continue;
            if (m.getReturnType() == void.class) continue;
            int pi = -1;
            for (int k = 0; k < 2; k++) {
                if (p[k].isInterface() && p[k] != modifierCls) {
                    pi = k;
                    break;
                }
            }
            if (pi < 0) continue;
            try {
                Method im = m;
                im.setAccessible(true);
                Object proxy = Proxy.newProxyInstance(modifierCls.getClassLoader(),
                        new Class<?>[]{p[pi]}, new Collector());
                Object[] args = new Object[2];
                args[pi] = proxy;
                im.invoke(modifier, args);
                tried++;
                if (dump.length() < 300) {
                    dump.append(m.getName()).append("(proxy@").append(pi).append(") ");
                }
            } catch (Throwable t) {
                GmUtil.logOnce("glass.fold.err", "【GmGlass】" + m.getName() + " 挖元素失败：" + t);
            }
        }
        GmUtil.log("【GmGlass】挖元素：试了 " + tried + " 个折叠方法[" + dump + "]· 元素类 "
                + sElements.size() + " 个 · 挂上绘制 " + sHooked.size() + " 个");

        // 一个都没挂上 ⇒ 说清楚为什么（下次照着这条查）
        if (sHooked.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            for (Class<?> c : sElements) {
                sb.append(c.getName()).append(' ');
            }
            GmUtil.logFail("【GmGlass】一个绘制方法都没挂上！候选元素类=" + sb, null);
        }
    }

    private static final class Collector implements InvocationHandler {
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) {
            try {
                if (args != null) {
                    for (Object a : args) {
                        if (a == null || a instanceof Long || a instanceof Integer) continue;
                        hookIfElement(a.getClass());
                    }
                }
            } catch (Throwable ignore) {
            }
            return args != null && args.length > 0 ? args[0] : null;
        }
    }

    /**
     * 只钩「画底」的那个方法；一个类只钩一次。
     *
     * <p>两条路都要覆盖（Compose 两代写法）：
     * <ol>
     *   <li><b>老式</b>：元素自己就是 {@code DrawModifier} ⇒ 元素类上有 {@code draw(DrawScope)}；</li>
     *   <li><b>新式（Node 体系）</b>：元素只有 {@code create()}，返回一个 Node，
     *       <b>Node 上才有 {@code draw(DrawScope)}</b> ⇒ 顺藤摸到 create() 的返回类型再钩。</li>
     * </ol>
     *
     * <p>判据统一是：<b>1 个参数 + 返回 void + 那个参数是接口</b>。
     * {@code DrawScope} 是接口，而 {@code Node} / {@code onAttach(Node)} 那类收的是类
     * ⇒ 自动出局（3.29.0 就是漏了这一条，把 {@code onAttach} 也劫了）。
     */
    private static void hookIfElement(Class<?> c) {
        synchronized (sElements) {
            if (!sElements.contains(c)) sElements.add(c);
            if (sHooked.contains(c)) return;
        }
        int n = 0;
        try {
            // ⓿ 钩构造器：把「这次画底用的颜色」绑到元素实例上（颜色接力第一棒）
            for (java.lang.reflect.Constructor<?> ctor : c.getDeclaredConstructors()) {
                try {
                    ctor.setAccessible(true);
                } catch (Throwable ignore) {
                }
                XposedBridge.hookMethod(ctor, new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam p) {
                        try {
                            Object el = p.thisObject;
                            int col = (int) sPendingColor;
                            Object shp = null;
                            boolean hasShape = false, hasLong = false;
                            // ★ 直接从元素字段读（比 pending 更准）：
                            //   · long 字段 = 颜色（eh0.a:J）
                            //   · Shape 接口类型的字段 = 形状（eh0.d:Lgn9）
                            for (Field f : el.getClass().getDeclaredFields()) {
                                try {
                                    f.setAccessible(true);
                                    if (f.getType() == long.class) {
                                        col = (int) f.getLong(el);
                                        hasLong = true;
                                    } else if (sShapeCls != null && f.getType() == sShapeCls) {
                                        Object v = f.get(el);
                                        if (v != null) {
                                            shp = v;
                                            hasShape = true;
                                        }
                                    }
                                } catch (Throwable ignore) {
                                }
                            }
                            if (!hasShape && hasLong) shp = sPendingShape;   // 兜底：构造函数带出来的形状
                            sElementColor.put(el, col);
                            if (shp != null) sElementShape.put(el, shp);
                        } catch (Throwable ignore) {
                        }
                    }
                });
            }
            // ① 老式：元素自己就是 DrawModifier
            n += hookDrawLike(c);
            // ② 新式：元素是 ModifierNodeElement，只有 create()，Node 上才有 draw。
            //    ⚠️ 宿主里 `se0.b()` 的**声明返回类型是 Node 基类 Lb76;**，
            //       真身（BackgroundNode）是 R8 生成的**子类** ⇒ 静态扫不到，
            //       只能钩住 create()，等实例出来再看它到底是哪个类。
            for (Method m : c.getDeclaredMethods()) {
                if (m.getParameterCount() != 0) continue;
                Class<?> r = m.getReturnType();
                if (r.isPrimitive() || r == void.class) continue;
                if (r == String.class || r.isArray() || r.isInterface()) continue;
                if (r.getName().startsWith("java.") || r.getName().startsWith("android.")) continue;
                try {
                    m.setAccessible(true);
                } catch (Throwable ignore) {
                }
                XposedBridge.hookMethod(m, new NodeFactoryHook());
                n++;
            }
        } catch (Throwable t) {
            GmUtil.logOnce("glass.hook.err", "【GmGlass】钩 " + c.getName() + " 失败：" + t);
        }
        if (n > 0) {
            synchronized (sHooked) {
                sHooked.add(c);
            }
            GmUtil.log("【GmGlass】✅ " + c.getName() + " → 挂上 " + n + " 个绘制方法");
        }
    }

    /** 钩 create()：实例出来后，把**真身那个子类**的 draw 挂上。 */
    private static final class NodeFactoryHook extends XC_MethodHook {
        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            try {
                Object node = param.getResult();
                if (node == null) return;

                // ★ 记号接力：组合期被打过记号的「元素」⇒ 它造出来的 Node 也打记号
                if (sBtnElements.contains(param.thisObject)) {
                    synchronized (sBtnNodes) {
                        sBtnNodes.add(node);
                    }
                    if (!sBtnNodeLogged) {
                        sBtnNodeLogged = true;
                        GmUtil.log("【GmGlass】按钮 Node 记号已建立（" + node.getClass().getName() + "）");
                    }
                }

                // ★ 颜色接力（A 方案）：元素 → Node
                Integer col = sElementColor.get(param.thisObject);
                if (col != null) {
                    sNodeColor.put(node, col);
                }

                // ★ 形状接力（贴合形状 A 档）：元素 → Node
                Object shp = sElementShape.get(param.thisObject);
                if (shp != null) {
                    sNodeShape.put(node, shp);
                }

                Class<?> nc = node.getClass();
                synchronized (sHooked) {
                    if (sHooked.contains(nc)) return;
                }
                int k = hookDrawLike(nc);
                if (k > 0) {
                    synchronized (sHooked) {
                        sHooked.add(nc);
                    }
                    GmUtil.log("【GmGlass】✅ Node 真身 " + nc.getName() + " → 挂上 " + k + " 个绘制方法");
                }
            } catch (Throwable ignore) {
            }
        }
    }

    /**
     * 在某个类上挂「1 参 + void」的方法，返回挂上的条数。
     *
     * <p>⚠️ 宿主里 {@code draw} 的参数类型 {@code Lda5;} <b>是个类不是接口</b>
     * （Compose 的 DrawScope 实现），所以不能再要求「参数是接口」——
     * 改成<b>运行时判据</b> {@link #looksLikeDrawScope}：
     * 真的 DrawScope 一定有「0 参返回 long」（size）和「0 参返回 float」（density）。
     * 这样 {@code onAttach(Node)} / {@code applySemantics(config)} 之类会被自然挡掉，
     * 既不会漏掉 draw，也不会误伤生命周期。
     */
    private static int hookDrawLike(Class<?> c) {
        int n = 0;
        for (Method m : c.getDeclaredMethods()) {
            if (m.getReturnType() != void.class) continue;
            if (m.getParameterCount() != 1) continue;
            Class<?> p = m.getParameterTypes()[0];
            if (p.isPrimitive() || p == String.class || p.isArray()) continue;
            try {
                m.setAccessible(true);
            } catch (Throwable ignore) {
            }
            XposedBridge.hookMethod(m, new GlassDrawHook());
            n++;
        }
        return n;
    }

    /** 真·DrawScope 的指纹：0 参返回 long（size）+ 0 参返回 float（density）。 */
    private static boolean looksLikeDrawScope(Object o) {
        if (o == null) return false;
        boolean size = false, dens = false;
        for (Method m : o.getClass().getMethods()) {
            if (m.getParameterCount() != 0) continue;
            if (m.getReturnType() == long.class) size = true;
            else if (m.getReturnType() == float.class) dens = true;
            if (size && dens) return true;
        }
        return false;
    }

    // ══════════════════════ ② 劫绘制 ══════════════════════

    private static volatile int sDrawEnters = 0;
    private static volatile boolean sBtnNodeLogged = false;
    private static volatile boolean sColorLogged = false;
    private static volatile boolean sWallBackLogged = false;

    /** 上玻璃的元素的「尺寸清单」—— 只记前 12 种，看到底涂了哪些东西。 */
    private static final java.util.LinkedHashSet<String> sSizes =
            new java.util.LinkedHashSet<String>();

    private static void logSizeOnce(float w, float h) {
        synchronized (sSizes) {
            if (sSizes.size() >= 12) return;
            String k = Math.round(w) + "x" + Math.round(h);
            if (sSizes.add(k)) {
                GmUtil.log("【GmGlass】上玻璃的尺寸#" + sSizes.size() + "：" + k
                        + "（" + (w >= 1400 ? "整幅宽横条" : (w >= 600 ? "宽块" : "小控件"))
                        + "）");
            }
        }
    }

    /** 每次「为什么没画」都单独打一条（用不同 tag，不被 logOnce 吃掉）。 */
    private static void why(String k, String msg) {
        GmUtil.logOnce("glass.why." + k, "【GmGlass】没画：" + msg);
    }

    private static final class GlassDrawHook extends XC_MethodHook {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            int ent = ++sDrawEnters;
            try {
                if (ent <= 3 || ent == 300 || ent == 3000) {
                    GmUtil.logOnce("glass.enter" + ent,
                            "【GmGlass】绘制钩子第 " + ent + " 次进入 · 类="
                                    + (param.thisObject == null ? "?" : param.thisObject.getClass().getName()));
                }
                if (sAutoOff) { why("autoff", "自动停用了"); return; }
                if (!GmGlassCfg.on()) { why("off", "开关是关的"); return; }
                if (param.args == null || param.args.length == 0) { why("noarg", "没有参数"); return; }
                Object scope = param.args[0];
                if (scope == null) { why("nullscope", "scope 是 null"); return; }
                if (!looksLikeDrawScope(scope)) return;   // 不是 DrawScope（生命周期/语义那类）⇒ 放行
                // ★ 只给「打了按钮记号」的 Node 上玻璃。
                //   组合期记的记号，绘制期才认得出 —— 这是 3.30.0 的关键一步。
                if (GmGlassCfg.get().scope == GmGlassCfg.SCOPE_BUTTONS_ONLY
                        && !sBtnNodes.contains(param.thisObject)) {
                    return;
                }

                if (!paintGlass(scope, param.thisObject)) return;   // 没把握就放行原绘制

                param.setResult(null);                              // ★ 实心底不画了，让位给玻璃
                sFailStreak = 0;
                int n = ++sPaintCount;
                // ⚠️ 这里**不能**用 logOnce —— 它按 tag 去重，只会打第一条，
                //    结果「换掉绘制 #1」永远不变，让人误以为只画了一次（3.30.1 的教训）。
                if (n == 1) {
                    GmUtil.log("【GmGlass】换掉绘制 #1（开始）");
                } else if (n == 50 || n == 200 || n == 1000 || n % 2000 == 0) {
                    GmUtil.log("【GmGlass】换掉绘制 #" + n);
                }
            } catch (Throwable t) {
                // 玻璃是装饰：出错就放行原绘制，连续出错还自动关掉自己
                if (++sFailStreak > 30 && !sAutoOff) {
                    sAutoOff = true;
                    GmUtil.logFail("【GmGlass】连续出错，自动停用玻璃（宿主不受影响）", t);
                }
            }
        }
    }

    // ══════════════════════ ③ 画玻璃 ══════════════════════

    private static final Paint sLensPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private static volatile boolean sLensLogged = false;
    private static final Paint sFill = new Paint(Paint.ANTI_ALIAS_FLAG);
    private static final Paint sSheen = new Paint(Paint.ANTI_ALIAS_FLAG);
    private static final Paint sRim = new Paint(Paint.ANTI_ALIAS_FLAG);
    private static final Paint sBitmapPaint = new Paint(Paint.ANTI_ALIAS_FLAG | Paint.FILTER_BITMAP_FLAG);
    private static final Path sPath = new Path();
    private static final RectF sRect = new RectF();
    private static final Rect sClip = new Rect();

    static {
        sRim.setStyle(Paint.Style.STROKE);
        sBitmapPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_OVER));
    }

    private static boolean paintGlass(Object drawScope, Object element) {
        // 正在抓底图 ⇒ 玻璃让路（否则底图会把玻璃自己抄进去，越糊越黑）
        if (GmGlassBackdrop.capturing()) return false;

        float w = dim(drawScope, 0);
        float h = dim(drawScope, 1);
        if (w <= 1f || h <= 1f) {
            why("size", "取不到尺寸 w=" + w + " h=" + h
                    + " · scopeCls=" + drawScope.getClass().getName());
            return false;
        }

        logSizeOnce(w, h);      // 尺寸清单：看看到底涂了哪些东西

        final GmGlassCfg.S cfg = GmGlassCfg.get();

        // ★ 作用范围（3.29.1）：0 = 所有可点元素（默认，排除整页背景）/ 1 = 仅标准按钮
        if (cfg.scope == GmGlassCfg.SCOPE_BUTTONS_ONLY && !GmGlassScope.inButton()) return false;
        // ★ 主人 2026-09-30：「界面上可能有个**主 node** 被液态玻璃了导致整个页面会偏白」
        //   ⇒ 把「真正的整页根节点」排除掉（只排根，别的全留）。
        //   判据收紧到 0.97：只抓 1440x3168 那种满屏根，不误伤大卡片。
        if (GmGlassInstall.isFullPage(w, h)) {
            why("rootpage", "整页根节点（涂它会让全屏偏白）" + (int) w + "x" + (int) h);
            return false;
        }

        float r = cfg.radiusDp * GmGlassInstall.density();
        r = Math.min(r, Math.min(w, h) / 2f);

        // ── 「形态」与「贴合形状」（2026-10-02 · 主人「都要」的 A/B/C 档）──────
        //   B 镂空 = 不画玻璃（把元素填充掏空；内容照画）——
        //   直接返回 true ⇒ GlassDrawHook 会把原绘制 setResult 掉 ⇒ 背景就空了。
        if (cfg.form == GmGlassCfg.FORM_HOLLOW) {
            drawContentOf(drawScope);
            return true;
        }

        //   A 贴合 / C 仅边缘：拿「元素轮廓」（Shape 接力 → createOutline → Path）
        //   ★ v3（2026-10-02 夜，主人：「你是往元素外面套一层玻璃……改成元素内部边缘绘制边框，
        //     过渡是向里一点点减去颜色」）：
        //     仅边缘**不再"硬挖内圈"**——改成"从元素内边缘往里，颜色/折射按距离淡出、直到减到 0"
        //     （由 shader 的 fdmFadeFac(sd) 完成；整个边缘不存在任何硬边界）。
        Path fit = null;
        float band = 0f;
        final boolean edge = (cfg.form == GmGlassCfg.FORM_EDGE);
        if (edge) {
            // 化开深度：从内边缘往里的距离（px）——随元素大小限幅，别把元素吞掉
            band = Math.max(1f, cfg.edge * GmGlassInstall.density());
            float lim = Math.min(w, h) * 0.34f;
            if (lim < 1f) lim = 1f;
            if (band > lim) band = lim;
        }
        if (cfg.fit || edge) {
            Object shape = sNodeShape.get(element);
            Object[] cc = sNodeFit.get(element);
            boolean fresh = cc != null
                    && ((Float) cc[0]).floatValue() == w && ((Float) cc[1]).floatValue() == h
                    && (cc[2] != null || !cfg.fit);
            if (fresh) {
                fit = (Path) cc[2];
            } else {
                if ((cfg.fit || edge) && shape != null) fit = fitPathFrom(shape, drawScope, w, h);
                if (fit != null) {
                    // ★ 轮廓体检：退化的路径（空/太小）宁可当"拿不到"——
                    //   否则裁剪会剪出各种怪相（"玻璃跑外面 / 元素变空白"都属于这一类）。
                    RectF fb = new RectF();
                    fit.computeBounds(fb, true);
                    if (fb.width() < w * 0.55f || fb.height() < h * 0.55f) {
                        why("fit.bad", "轮廓路径异常(" + (int) fb.width() + "x" + (int) fb.height()
                                + " vs 元素 " + (int) w + "x" + (int) h + ") ⇒ 当拿不到处理");
                        fit = null;
                    }
                }
                sNodeFit.put(element, new Object[]{w, h, fit});
            }
        }

        // ★「仅边缘」的硬前提：拿得到元素轮廓才画。
        //   没有轮廓就只能按兜底圆角矩形画 —— 而"兜底圆角"和元素真实形状不一致时，
        //   看起来就是"玻璃套在元素外面"。⇒ **宁可不动（放行原绘制），也不画错**
        //   （和"底色模式拿不到颜色就不画"同一条纪律）。
        if (edge && fit == null) {
            why("edge.nofit", "仅边缘：拿不到元素轮廓 ⇒ 不画（避免跑到元素外面）");
            return false;
        }

        // 「边缘过渡」：
        //   · 「正常」：颜色向中心柔化的程度（滑杆；0 = 旧平铺样）
        //   · 「仅边缘」：**固定完全化开** —— 从内边缘往"边缘宽度"深处减到 0（主人的"一点点减去颜色"）
        final float fadeAmt = edge ? 1f : Math.max(0f, Math.min(1f, cfg.fade / 100f));
        final float fadePx = edge ? Math.max(1f, band) : Math.max(1f, Math.min(w, h) * 0.45f);

        // 画布：先看本帧截获的，其次走方法链
        catchCanvas(drawScope.getClass());
        Canvas c = sCurCanvas.get();
        if (c == null) c = canvasOf(drawScope);
        if (c == null) return false;

        // ── 位置 ─────────────────────────────────────────────────────
        // 主人 2026-09-30 反馈：「会抓取页面全部部分用来做渲染参考，导致会出现文字」
        // ⇒ 采样位置错了。原来我把 matrixFromFields（在对象图里瞎找 float[16]）排在第一位，
        //   它可能摸到**任意一个矩阵**（颜色矩阵 / shader 矩阵 …）⇒ 采到页面别的区域 ⇒ 把别处的文字抓进来。
        //   现在改规矩：
        //     ① **只认画布矩阵**（Compose 已经把节点位置压进去了，语义明确）；
        //     ② 拿不到就**不画**（宁可不涂，也不涂错）。
        // ── 底图来源（A 方案 / 截图模式）────────────────────────────────
        //  A：用**元素自己的底色**合成一张小图 ⇒ **完全不截图**
        //     ⇒ 后台可用、零延迟、无文字叠影、无正反馈、也没有 PixelCopy 的爆栈风险
        //  截图：老路径，留作"高保真模式"（想要"透出背后内容"时切过去）
        final boolean useSolid = (cfg.src == 0);
        final boolean useWallpaper = (cfg.src == 2);
        Bitmap back;
        boolean stretch = useSolid;
        int ox = 0, oy = 0;

        if (useWallpaper) {
            // ★ 第三种来源（主人 2026-10-01）：「我自己设的背景图」
            //   主旨 —— 「**糊了就不叫玻璃了**」：玻璃要的是**看清 + 边缘掰弯**，
            //   不是糊。而壁纸正好提供了"清晰 + 有纹理（折射看得见）"的内容。
            //
            //   ★ 回退（主人点名要的）：**背景开关关了 / 图不在 / 解不出** ⇒ 退回「元素底色」。
            android.content.Context app = GmUtil.app();
            Bitmap wp = app == null ? null
                    : GmGlassWallpaper.get(app, GmGlassBackdrop.winW(), GmGlassBackdrop.winH());
            if (wp != null && !wp.isRecycled()) {
                back = wp;
                stretch = false;                 // 和截图一样是"整窗缩略图"，走裁剪
            } else {
                Integer base0 = sNodeColor.get(element);
                if (base0 == null) {
                    why("wallback", "背景图不可用且拿不到元素底色 ⇒ 这一帧不画");
                    return false;
                }
                back = GmGlassSolid.make(base0);
                stretch = true;
                if (!sWallBackLogged) {
                    sWallBackLogged = true;
                    GmUtil.log("【GmGlass】背景图不可用 ⇒ 已回退「元素底色」（玻璃照常显示）");
                }
            }
        } else if (useSolid) {
            Integer base = sNodeColor.get(element);
            if (base == null) {
                // ★ 2026-10-01 修（主人报：「消息列表**第一次打开是显背景的**，
                //   但是**切后台一次又会变成液态玻璃色**」）：
                //
                //   原来这里"拿不到底色就退回截图模式" ⇒
                //   · 首次进入：颜色缓存还是空的（组合期刚跑）⇒ 走截图 ⇒ **显示的是背景** ✗
                //   · 切一次后台：缓存好了 ⇒ 走底色 ⇒ **变成玻璃色** ✗
                //   ⇒ 同一块地方**前后长得不一样**，看起来像"随机变脸"。
                //
                //   现在改成：**底色模式拿不到颜色就不画**（保持元素原样），
                //   等颜色到位了再上玻璃 —— 宁可晚一帧，也不要前后不一致。
                why("nocolor", "底色模式但还没拿到元素颜色 ⇒ 这一帧不画（避免前后不一致）");
                return false;
            } else {
                back = GmGlassSolid.make(base);
                if (!sColorLogged) {
                    sColorLogged = true;
                    GmUtil.log("【GmGlass】底色接力 ✓ 拿到 #" + Integer.toHexString(base)
                            + "（" + sNodeColor.size() + " 个元素有底色）");
                }
            }
        } else {
            back = GmGlassBackdrop.get();
            if (back == null) GmGlassBackdrop.request();
        }

        if (!stretch) {
            // 截图模式才需要"元素在窗口里的位置"，并且要做越界校验（宁可不涂，也不涂错）
            int[] org = GmGlassAtoms.originFromCanvas(c);
            if (org == null) {
                why("noorigin", "拿不到元素位置 ⇒ 跳过（不涂错地方）");
                return false;
            }
            int winW = back == null ? 0 : back.getWidth() * GmGlassBackdrop.SCALE;
            int winH = back == null ? 0 : back.getHeight() * GmGlassBackdrop.SCALE;
            if (back != null && (org[0] < 0 || org[1] < 0
                    || org[0] + w > winW + 1 || org[1] + h > winH + 1)) {
                why("outofrange", "采样区越界 ⇒ 跳过 org=(" + org[0] + "," + org[1] + ") "
                        + (int) w + "x" + (int) h + " 窗口=" + winW + "x" + winH);
                return false;
            }
            ox = org[0];
            oy = org[1];
        }

        // ① 画玻璃（这时候按钮的文字/图标还没画）
        new Painter(cfg, w, h, r, ox, oy, back, stretch, fit, fadeAmt, fadePx).paint(c);

        // ② ★★ 把内容画回去 ★★
        //    3.30.2 之前漏了这一步 ⇒ 文字/矢量图标全部消失。
        //    Compose 的 DrawModifierNode.draw() 语义是「我画完要自己调 drawContent()」，
        //    我们整个方法替换掉却没调 ⇒ 内容直接从绘制链上被摘掉了。
        //    实测：这步必须在玻璃【之后】调，否则玻璃会盖住内容。
        drawContentOf(drawScope);
        return true;
    }

    private static volatile boolean sDrawContentLogged = false;

    /**
     * 调用 {@code ContentDrawScope.drawContent()} —— 让按钮的文字/图标画在我们的玻璃上面。
     *
     * <p>方法名是混淆的（宿主实测 = {@code Lda5;->a()V}），所以判据是
     * 「**本类（不含 Object）声明的、0 参数、返回 void、非 static** 的方法」。
     * {@code Lda5;} 上正好只有一个，直接调；多于一个就只挑名字最短的那个并打日志点名。
     */
    private static void drawContentOf(Object scope) {
        try {
            Method pick = null;
            for (Class<?> c = scope.getClass(); c != null && c != Object.class; c = c.getSuperclass()) {
                for (Method m : c.getDeclaredMethods()) {
                    if (m.getParameterCount() != 0) continue;
                    if (m.getReturnType() != void.class) continue;
                    if (java.lang.reflect.Modifier.isStatic(m.getModifiers())) continue;
                    if (pick == null || m.getName().length() < pick.getName().length()) pick = m;
                }
            }
            if (pick == null) {
                why("nocontent", "找不到 drawContent（0 参 void 方法）· scopeCls="
                        + scope.getClass().getName());
                return;
            }
            pick.setAccessible(true);
            pick.invoke(scope);
            if (!sDrawContentLogged) {
                sDrawContentLogged = true;
                GmUtil.log("【GmGlass】drawContent 已接回：" + scope.getClass().getName()
                        + "." + pick.getName() + "()");
            }
        } catch (Throwable t) {
            // ★ 别只打 InvocationTargetException —— 真因在 cause 里
            Throwable c = (t instanceof java.lang.reflect.InvocationTargetException
                    && t.getCause() != null) ? t.getCause() : t;
            why("contenterr", "drawContent 调用失败：" + c
                    + " @" + (c.getStackTrace().length > 0 ? c.getStackTrace()[0] : "?"));
        }
    }

    private static final class Painter implements NativePainter {
        private final GmGlassCfg.S cfg;
        private final float w, h, r;
        private final int ox, oy;
        private final Bitmap back;
        /** true = 底图是"合成小图"，直接拉伸铺满（A 方案）。 */
        private final boolean stretch;
        /** 贴合形状（A 档）：元素真实轮廓路径；null = 退回圆角矩形。 */
        private final Path fit;
        /** 「边缘过渡」强度 0..1 与距离 px（颜色从边缘往里柔和衰减，减到 0 为止）。 */
        private final float fadeAmt, fadePx;

        Painter(GmGlassCfg.S cfg, float w, float h, float r, int ox, int oy, Bitmap back,
                boolean stretch, Path fit, float fadeAmt, float fadePx) {
            this.cfg = cfg;
            this.w = w;
            this.h = h;
            this.r = r;
            this.ox = ox;
            this.oy = oy;
            this.back = back;
            this.stretch = stretch;
            this.fit = fit;
            this.fadeAmt = fadeAmt;
            this.fadePx = fadePx;
        }

        @Override
        public void paint(Canvas c) {
            // 尺寸用 DrawScope 报的（可靠）；不再拿 clipBounds 去猜（那是父级的裁剪，会偏大）
            float cw = w, ch = h;

            sRect.set(0, 0, cw, ch);
            sPath.reset();
            sPath.addRoundRect(sRect, r, r, Path.Direction.CW);
            // ★ 贴合（A 档）：有真实轮廓就用它（圆角/胶囊/异形都贴合），没有就退回圆角矩形
            final Path outer = (fit != null) ? fit : sPath;

            int save = c.save();

            // ★ Q 弹：围着中心做一个弹簧缩放（按下压、松手过冲再稳）
            double sc = GmGlassSpring.tick();
            if (Math.abs(sc - 1.0) > 0.001) {
                float k = (float) sc;
                c.scale(k, k, cw / 2f, ch / 2f);
            }

            // ★ 双保险（v3）：先裁「节点矩形」——矩形裁剪永远可靠；
            //   哪怕形状路径裁剪因任何原因失效，也绝不可能画出节点矩形之外去
            //   （对付「往元素外面套一层玻璃」的最终兜底）。
            c.clipRect(0f, 0f, cw, ch);
            c.clipPath(outer);
            // ★ v3：不再"硬挖内圈"——「仅边缘」完全交给 shader 的 fdmFadeFac(sd)：
            //   从内边缘往里、按距离把颜色/折射一点点减到 0（没有任何硬边界）。

            // ── 玻璃的「透」怎么来 ──────────────────────────────
            //   0 浓度 = 全透（只剩高光边）；100 = 全不透。
            //   底图和蒙层**都**按浓度给 alpha —— 这才叫玻璃，
            //   3.29.x 把底图 setAlpha(255) 画上去，那是「贴纸」不是玻璃。
            // ★ 2026-10-02 主人：「颜色选择器里调的透明度没区别」——
            //   颜色自带的 alpha 现在**乘进**浓度里（默认 255 = 不变；调低即更透）。
            int colA = (cfg.color >>> 24) & 0xFF;
            int a = Math.round(cfg.tint * 2.55f * (colA / 255f));
            if (a < 0) a = 0;
            if (a > 255) a = 255;

            // ⚠️ 3.30.7 真机实测（关/开两张自拍逐像素对比）：
            //     顶部栏 98% 像素、底部输入区 93~99% 像素被"刷白"（亮度 15→112 / 36→170）
            //     ⇒ 那不是玻璃，是**白色涂料**。真玻璃的主体必须是「透出模糊背景」，
            //     白只占薄薄一层 + 一条亮边。下面全按这个原则重调。

            // ① ★ 真折射（API 33+）★ —— "像不像玻璃"就靠这一步
            //    AGSL 把底图按「圆角矩形距离场 + 边缘折射」重新采样，
            //    边缘会**把背景掰弯**，这是磨砂贴片给不出的观感。
            boolean lensed = false;

            // ★★ 首选：GPU 管线（RenderNode + RenderEffect.createChainEffect）
            //    这就是 Haze 2.0 那条链 —— 库用不了，但它的内脏是平台 API，直接用。
            // 着色参数（Haze 模型）：tint 的 alpha = 浓度；色散来自独立旋钮
            final int tintArgb = (a << 24) | (cfg.color & 0x00FFFFFF);
            final float dispersion = cfg.disp / 10f;
            final float pad = Math.max(2f, Math.min(24f * GmGlassInstall.density(),
                    Math.min(cw, ch) * 0.5f));

            // 实现方式：自动 / 强制 GPU / 强制 CPU（CPU 版走下面那条 BitmapShader 路）
            if (GmGlassCfg.wantGpu() && back != null && !back.isRecycled()
                    && ox >= 0 && oy >= 0) {
                float blurPx = Math.max(1f, cfg.blur * GmGlassInstall.density() * 0.5f);
                lensed = GmGlassGpu.draw(c, back, ox, oy, cw, ch, r, pad, blurPx, 255,
                        dispersion, tintArgb, cfg.engine, cfg.clean, cfg.cleanTol / 100f, stretch,
                        fadeAmt, fadePx);
            }

            if (!lensed && back != null && !back.isRecycled()
                    && (stretch || (ox >= 0 && oy >= 0))
                    && android.os.Build.VERSION.SDK_INT >= 33) {
                Shader lens = GmGlassLens.make(back, ox, oy, cw, ch, r, pad, dispersion, tintArgb,
                        cfg.engine, cfg.clean, cfg.cleanTol / 100f, 0xFFFFFFFF, stretch,
                        fadeAmt, fadePx);
                if (lens != null) {
                    try {
                        sLensPaint.setShader(lens);
                        sLensPaint.setAlpha(255);
                        c.drawPath(outer, sLensPaint);      // ★ 按轮廓画（贴合 A 档同一条路）
                        lensed = true;
                        if (!sLensLogged) {
                            sLensLogged = true;
                            GmUtil.log("【GmGlass】折射已生效（" + (int) cw + "x" + (int) ch + "）");
                        }
                    } catch (Throwable ignore) {
                    } finally {
                        sLensPaint.setShader(null);
                    }
                }
            }

            if (!lensed) {
                why("nolens", "折射没用上 · sdk=" + android.os.Build.VERSION.SDK_INT
                        + " · 底图=" + (back == null ? "null" : "有")
                        + " · 原点=(" + ox + "," + oy + ")");
            }

            // ①' 没折射就退回：把底图贴上来（磨砂版）
            if (!lensed && back != null && !back.isRecycled() && (stretch || (ox >= 0 && oy >= 0))) {
                int s = stretch ? 1 : GmGlassBackdrop.SCALE;
                int bx = stretch ? 0 : ox;
                int by = stretch ? 0 : oy;
                Rect src = new Rect(
                        bx / s, by / s,
                        Math.min(back.getWidth(), bx / s + Math.max(1, (int) cw / s)),
                        Math.min(back.getHeight(), by / s + Math.max(1, (int) ch / s)));
                Rect dst = new Rect(0, 0, (int) cw, (int) ch);
                if (src.width() > 1 && src.height() > 1) {
                    try {
                        sBitmapPaint.setAlpha(235);
                        c.drawBitmap(back, src, dst, sBitmapPaint);
                    } catch (Throwable ignore) {
                    }
                }
            }

            // ② 着色 —— **已经在 shader 里做完了**（Haze 的 over 合成：
            //    out = tint.rgb*tint.a + content.rgb*(1-tint.a)）。
            //    2026-09-30 主人拍板：「把圆角高光去了，只保留液态玻璃和可自定义玻璃颜色本身」
            //    ⇒ 圆角/亮边/斜向高光/水滴 全部拆掉，这里**不再额外叠任何东西**。

            c.restoreToCount(save);
        }
    }

    // ══════════════════════ ③.5 「形状 → 路径」 ══════════════════════
    //
    //  Shape(gn9) → createOutline(尺寸, 方向, 密度) → Outline(wv7) → android.graphics.Path
    //
    //  宿主真身（2026-10-02 静态核实）：
    //    · 接口 gn9 全身上下只有 1 个方法：a(J,Lwa6,Lpq3;)Lwv7;（= createOutline）——
    //      J 是打包的 Size（高 32 位宽、低 32 位高）；wa6 是枚举（a=Ltr / b=Rtl）；
    //      pq3 = Density（DrawScope 本身就实现了它）。
    //    · Outline 子类：vv7（圆角，字段 b:Lag 里就是 android Path）/ tv7（任意路径，a:Lag）
    //      / uv7（矩形，a:rr8 四个 float）—— Lag 的真身字段 a 就是 android.graphics.Path。
    //    · ⚠️ 路径可能是宿主"池化复用"的对象 ⇒ 一律拷一份带走（new Path(src)）。

    private static Path fitPathFrom(Object shape, Object scope, float w, float h) {
        try {
            Method m = sOutlineM;
            if (m == null) {
                if (sShapeCls == null) return null;
                for (Method c : sShapeCls.getMethods()) {
                    Class<?>[] pp = c.getParameterTypes();
                    if (pp.length == 3 && pp[0] == long.class && c.getReturnType() != void.class) {
                        m = c;
                        break;
                    }
                }
                if (m == null) return null;
                sOutlineM = m;
                sOutlineCls = m.getReturnType();
            }
            m.setAccessible(true);
            Class<?>[] pp = m.getParameterTypes();
            long packed = (((long) Float.floatToRawIntBits(w)) << 32)
                    | (Float.floatToRawIntBits(h) & 0xffffffffL);
            Object ld = layoutDirOf(scope, pp[1]);
            Object dens = pp[2].isInstance(scope) ? scope : null;
            if (dens == null) dens = densityOf(scope, pp[2]);
            if (dens == null) dens = densityProxy(pp[2]);   // 最后兜底：给接口造个"假人"
            if (dens == null) dens = scope;
            Object outline = m.invoke(shape, packed, ld, dens);
            if (outline == null) return null;
            Path got = androidPathOf(outline);
            if (got == null) return null;
            if (!sFitLogged) {
                sFitLogged = true;
                GmUtil.log("【GmGlass】轮廓接力 ✓（createOutline → Path，贴合形状已就绪）");
            }
            return new Path(got);
        } catch (Throwable t) {
            if (!sFitFail) {
                sFitFail = true;
                Throwable c = (t instanceof java.lang.reflect.InvocationTargetException
                        && t.getCause() != null) ? t.getCause() : t;
                GmUtil.logFail("【GmGlass】贴合形状失败（已自动跳过，玻璃照常）", c);
            }
            return null;
        }
    }

    /** LayoutDirection：先问 DrawScope 要（尊重 RTL），退回枚举第一项。 */
    private static Object layoutDirOf(Object scope, Class<?> ldCls) {
        try {
            for (Method sm : scope.getClass().getMethods()) {
                if (sm.getParameterCount() != 0) continue;
                if (sm.getReturnType() != ldCls) continue;
                sm.setAccessible(true);
                Object v = sm.invoke(scope);
                if (v != null) return v;
            }
        } catch (Throwable ignore) {
        }
        try {
            if (ldCls.isEnum()) {
                Object[] vs = ldCls.getEnumConstants();
                if (vs != null && vs.length > 0) return vs[0];
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** Density：先找 DrawScope 里的 getter，再退回 null（调用处会兜 scope 自己）。 */
    private static Object densityOf(Object scope, Class<?> densCls) {
        try {
            for (Method sm : scope.getClass().getMethods()) {
                if (sm.getParameterCount() != 0) continue;
                if (sm.getReturnType() != densCls) continue;
                sm.setAccessible(true);
                Object v = sm.invoke(scope);
                if (v != null) return v;
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** 最后兜底：Density 是个接口 ⇒ 用 Proxy 造一个"什么都能答"的假人（数值只影响 dp 换算精度）。 */
    private static Object densityProxy(Class<?> densCls) {
        try {
            if (!densCls.isInterface()) return null;
            final float d = GmGlassInstall.density();
            return Proxy.newProxyInstance(densCls.getClassLoader(), new Class<?>[]{densCls},
                    new InvocationHandler() {
                        @Override
                        public Object invoke(Object proxy, Method method, Object[] args) {
                            Class<?> rt = method.getReturnType();
                            if (rt == float.class) return d;
                            if (rt == long.class) return 0L;
                            if (rt == int.class) return 0;
                            if (rt == boolean.class) return false;
                            return null;
                        }
                    });
        } catch (Throwable ignore) {
            return null;
        }
    }

    /** Outline → android.graphics.Path：① 扫"包着 android Path 的字段"（vv7.b / tv7.a）；
     *  ② 退回边界矩形（Outline.a() → 4 个 float 的 Rect）。返回的对象调用方自行拷贝。 */
    private static Path androidPathOf(Object outline) {
        try {
            Class<?> oc = outline.getClass();
            Object[] rec = sRecipe.get(oc);
            if (rec == null) {
                Object[] r = recipeFor(oc);
                rec = (r == null) ? new Object[0] : r;
                sRecipe.put(oc, rec);
            }
            if (rec.length == 2) {
                Field wrapF = (Field) rec[0];
                Field apF = (Field) rec[1];
                wrapF.setAccessible(true);
                apF.setAccessible(true);
                Object wrap = wrapF.get(outline);
                if (wrap != null) {
                    Object ap = apF.get(wrap);
                    if (ap instanceof Path) return (Path) ap;
                }
            }
        } catch (Throwable ignore) {
        }
        try {
            Method am = sOutlineA;
            if (am == null && sOutlineCls != null) {
                for (Method c : sOutlineCls.getMethods()) {
                    if (c.getParameterCount() != 0) continue;
                    if (c.getReturnType() == void.class) continue;
                    if (Modifier.isStatic(c.getModifiers())) continue;
                    am = c;
                    break;
                }
                sOutlineA = am;
            }
            if (am != null) {
                am.setAccessible(true);
                Object rect = am.invoke(outline);
                if (rect != null) {
                    float[] f = fourFloatsOf(rect);
                    if (f != null) {
                        Path p = new Path();
                        p.addRect(f[0], f[1], f[2], f[3], Path.Direction.CW);
                        return p;
                    }
                }
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** 配方：在 outline 类（含父类）里找 [包装字段, 其类型上的 android Path 字段]。 */
    private static Object[] recipeFor(Class<?> outlineCls) {
        for (Class<?> k = outlineCls; k != null && k != Object.class; k = k.getSuperclass()) {
            for (Field f : k.getDeclaredFields()) {
                if (Modifier.isStatic(f.getModifiers())) continue;
                Class<?> ft = f.getType();
                if (ft.isPrimitive() || ft.isArray() || ft == String.class) continue;
                Field ap = androidPathFieldOf(ft);
                if (ap != null) return new Object[]{f, ap};
            }
        }
        return null;
    }

    private static Field androidPathFieldOf(Class<?> c) {
        for (Class<?> k = c; k != null && k != Object.class; k = k.getSuperclass()) {
            for (Field f : k.getDeclaredFields()) {
                if (f.getType() == Path.class) return f;
            }
        }
        return null;
    }

    /** 从对象里读 4 个 float（按字段声明序）—— 用作矩形兜底（a,b,c,d = l,t,r,b）。 */
    private static float[] fourFloatsOf(Object o) {
        float[] out = new float[4];
        int i = 0;
        outer:
        for (Class<?> k = o.getClass(); k != null && k != Object.class; k = k.getSuperclass()) {
            for (Field f : k.getDeclaredFields()) {
                if (f.getType() != float.class) continue;
                if (i >= 4) break outer;
                try {
                    f.setAccessible(true);
                    out[i++] = f.getFloat(o);
                } catch (Throwable ignore) {
                }
            }
        }
        return i == 4 ? out : null;
    }

    // ══════════════════════ ④ 反射小工具 ══════════════════════

    /**
     * DrawScope 的宽/高：which=0 → 宽，1 → 高。
     *
     * <p>宿主里就是 {@code Lda5;->b()J}（Compose 的 {@code Size} 是 inline class，擦成 long，
     * 高 32 位 = width，低 32 位 = height）。判据只认「0 参 + 返回 long」，不认名字。
     */
    static float dim(Object scope, int which) {
        for (Method m : scope.getClass().getMethods()) {
            if (m.getParameterCount() != 0) continue;
            if (m.getReturnType() != long.class) continue;
            try {
                long packed = (Long) m.invoke(scope);
                float a = Float.intBitsToFloat((int) (packed >> 32));
                float b = Float.intBitsToFloat((int) (packed & 0xffffffffL));
                if (a > 1f && b > 1f) {
                    if (!sDimLogged) {
                        sDimLogged = true;
                        GmUtil.log("【GmGlass】尺寸拿法：" + m.getName() + "()J → "
                                + (int) a + " x " + (int) b);
                    }
                    return which == 0 ? a : b;
                }
            } catch (Throwable ignore) {
            }
        }
        return -1f;
    }

    private static volatile boolean sDimLogged = false;

    // ─────────── 原生画布：不猜名字，按「0 参 getter → 返回类型」逐跳找 ───────────

    /** 解析出来的「怎么从 DrawScope 走到 android.graphics.Canvas」这条链。 */
    private static volatile Method[] sChain = null;
    private static volatile String sChainText = null;

    /**
     * 「这一帧的画布」——在每个绘制线程里传。
     *
     * <p>关键发现（宿主 dex 实测）：Compose 的画布类是 {@code Lk59;}
     * （{@code AndroidCanvas}），它<b>同时</b>有
     * <pre>
     *   .field public a:Landroid/graphics/Canvas;
     *   .method public final a()Landroid/graphics/Canvas;
     * </pre>
     * 而这个画布是<b>每次绘制当参数传进 DrawScope 的</b>（不在字段里爬得到），
     * 所以：在 DrawScope 实现的<b>入口方法</b>上挂一脚，把「谁的参数里有原生画布」截下来。
     * Compose 的绘制是单线程一帧一帧跑的 ⇒ ThreadLocal 天然对齐。
     */
    private static final ThreadLocal<Canvas> sCurCanvas = new ThreadLocal<Canvas>();
    private static volatile boolean sCanvasHooked = false;
    private static volatile boolean sCanvasLogged = false;

    /** 从一个对象上把 android.graphics.Canvas 抠出来（0 参方法 or 字段）。 */
    private static Canvas nativeOf(Object o) {
        if (o == null) return null;
        try {
            for (Method m : o.getClass().getMethods()) {
                if (m.getParameterCount() != 0) continue;
                if (m.getReturnType() != Canvas.class) continue;
                Object v = invokeQuiet(m, o);
                if (v instanceof Canvas) return (Canvas) v;
            }
        } catch (Throwable ignore) {
        }
        try {
            for (java.lang.reflect.Field f : o.getClass().getDeclaredFields()) {
                if (f.getType() != Canvas.class) continue;
                f.setAccessible(true);
                Object v = f.get(o);
                if (v instanceof Canvas) return (Canvas) v;
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    /**
     * 在 DrawScope 实现类上挂「画布截获」钩子：任何方法的任何一个实参里带原生画布，
     * 就记进 {@link #sCurCanvas}。
     */
    private static void catchCanvas(Class<?> scopeCls) {
        if (sCanvasHooked) return;
        sCanvasHooked = true;
        int n = 0;
        try {
            for (Method m : scopeCls.getDeclaredMethods()) {
                int pc = m.getParameterCount();
                if (pc < 1 || pc > 8) continue;
                if (m.getReturnType() != void.class) continue;
                try {
                    m.setAccessible(true);
                } catch (Throwable ignore) {
                }
                XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) {
                        try {
                            if (param.args == null) return;
                            for (Object a : param.args) {
                                if (a == null) continue;
                                Canvas c = nativeOf(a);
                                if (c != null) {
                                    sCurCanvas.set(c);
                                    if (!sCanvasLogged) {
                                        sCanvasLogged = true;
                                        GmUtil.log("【GmGlass】画布截获 ✓ 来自 "
                                                + a.getClass().getName() + " @ "
                                                + param.method.getName());
                                    }
                                    return;
                                }
                            }
                        } catch (Throwable ignore) {
                        }
                    }
                });
                n++;
            }
        } catch (Throwable t) {
            GmUtil.logOnce("glass.catch.err", "【GmGlass】画布截获挂载失败：" + t);
        }
        GmUtil.log("【GmGlass】画布截获钩子 " + n + " 条（" + scopeCls.getName() + "）");
    }

    /**
     * 拿到宿主 DrawScope 的原生 {@code android.graphics.Canvas}。
     *
     * <p>Compose 里这条路是
     * {@code DrawScope.getDrawContext()} → {@code DrawContext.getCanvas()}（Compose Canvas）
     * → {@code Canvas.getNativeCanvas()}（android Canvas）。
     * 三跳的方法名在宿主里全是混淆的，所以<b>只看「0 参数」+「返回类型」</b>，
     * 逐跳试，第一条走通的链缓存下来。
     */
    private static Canvas canvasOf(Object drawScope) {
        Method[] chain = sChain;
        if (chain != null) {
            try {
                Object o = drawScope;
                for (Method m : chain) o = m.invoke(o);
                if (o instanceof Canvas) return (Canvas) o;
            } catch (Throwable ignore) {
            }
            sChain = null;
        }
        StringBuilder path = new StringBuilder();
        try {
            for (Method m1 : drawScope.getClass().getMethods()) {
                if (m1.getParameterCount() != 0) continue;
                Class<?> r1 = m1.getReturnType();
                if (r1.isPrimitive() || r1 == String.class || r1.isArray()) continue;
                Object a = invokeQuiet(m1, drawScope);
                if (a == null) continue;
                for (Method m2 : a.getClass().getMethods()) {
                    if (m2.getParameterCount() != 0) continue;
                    Class<?> r2 = m2.getReturnType();
                    if (r2 == Canvas.class) {
                        sChain = new Method[]{m1, m2};
                        sChainText = m1.getName() + "→" + m2.getName();
                        GmUtil.log("【GmGlass】画布链：" + sChainText);
                        return (Canvas) invokeQuiet(m2, a);
                    }
                    if (r2.isPrimitive() || r2 == String.class || r2.isArray()) continue;
                    Object b = invokeQuiet(m2, a);
                    if (b == null) continue;
                    for (Method m3 : b.getClass().getMethods()) {
                        if (m3.getParameterCount() != 0) continue;
                        if (m3.getReturnType() != Canvas.class) continue;
                        Object c = invokeQuiet(m3, b);
                        if (c instanceof Canvas) {
                            sChain = new Method[]{m1, m2, m3};
                            sChainText = m1.getName() + "→" + m2.getName() + "→" + m3.getName();
                            GmUtil.log("【GmGlass】画布链：" + sChainText);
                            return (Canvas) c;
                        }
                    }
                }
            }
        } catch (Throwable t) {
            path.append("err=").append(t);
        }
        // ② 方法链摸不到 ⇒ 改**按字段走**。
        //    宿主里画布是藏在对象字段里的（`Lda5;->a:Lxv0;` 这层），而字段名全混淆、
        //    也没有 getter ⇒ 只能顺着字段爬。读字段**没有副作用**，比乱调方法安全得多。
        Canvas byField = canvasByFields(drawScope);
        if (byField != null) return byField;

        if (sChainText == null) {
            why("nochain", "找不到原生画布 · scopeCls=" + drawScope.getClass().getName()
                    + " · 探查=" + dumpScope(drawScope));
        }
        return null;
    }

    /**
     * 顺着「非基本类型字段」广度优先爬，找哪个对象有「0 参 → android.graphics.Canvas」的方法。
     *
     * <p>不做任何可能带副作用的调用：只读字段 + 最多打一次 0 参 getter 拿 Canvas。
     */
    private static Canvas canvasByFields(Object root) {
        try {
            java.util.ArrayDeque<Object> q = new java.util.ArrayDeque<Object>();
            java.util.IdentityHashMap<Object, Integer> seen = new java.util.IdentityHashMap<Object, Integer>();
            q.add(root);
            seen.put(root, 0);
            int visited = 0;
            while (!q.isEmpty() && visited < 400) {
                Object o = q.poll();
                int d = seen.get(o);
                visited++;
                // 这个对象有没有直接吐 android.graphics.Canvas 的 0 参方法？
                for (Method m : o.getClass().getMethods()) {
                    if (m.getParameterCount() != 0) continue;
                    if (m.getReturnType() != Canvas.class) continue;
                    Object v = invokeQuiet(m, o);
                    if (v instanceof Canvas) {
                        sChainText = "field:" + o.getClass().getName() + "." + m.getName();
                        GmUtil.log("【GmGlass】画布链：" + sChainText);
                        return (Canvas) v;
                    }
                }
                if (d >= 4) continue;
                for (java.lang.reflect.Field f : o.getClass().getDeclaredFields()) {
                    Class<?> t = f.getType();
                    if (t.isPrimitive() || t == String.class || t.isArray()) continue;
                    if (t == Class.class || t.getName().startsWith("java.")) continue;
                    try {
                        f.setAccessible(true);
                        Object v = f.get(o);
                        if (v == null || seen.containsKey(v)) continue;
                        seen.put(v, d + 1);
                        q.add(v);
                    } catch (Throwable ignore) {
                    }
                }
            }
            GmUtil.log("【GmGlass】字段爬行没找到画布（走了 " + visited + " 个对象）");
        } catch (Throwable t) {
            GmUtil.logOnce("glass.field.err", "【GmGlass】字段爬行出错：" + t);
        }
        return null;
    }

    /** 一次性诊断：把 DrawScope 的「0 参 → 对象」getter 和它们返回的类名列出来。 */
    private static String dumpScope(Object o) {
        StringBuilder sb = new StringBuilder();
        int n = 0;
        try {
            for (Method m : o.getClass().getMethods()) {
                if (m.getParameterCount() != 0) continue;
                Class<?> r = m.getReturnType();
                if (r.isPrimitive() || r == String.class || r.isArray()) continue;
                if (n >= 8) break;
                Object v = invokeQuiet(m, o);
                sb.append(m.getName()).append("->")
                        .append(v == null ? "null" : v.getClass().getName()).append(' ');
                n++;
                if (v == null) continue;
                // 再看一层：这个对象里有没有「0 参 → android.graphics.Canvas」
                for (Method m2 : v.getClass().getMethods()) {
                    if (m2.getParameterCount() != 0) continue;
                    if (m2.getReturnType() != Canvas.class) continue;
                    sb.append("[Canvas via ").append(m2.getName()).append("!] ");
                }
                // 第三层
                for (Method m2 : v.getClass().getMethods()) {
                    if (m2.getParameterCount() != 0) continue;
                    Class<?> r2 = m2.getReturnType();
                    if (r2.isPrimitive() || r2 == String.class || r2.isArray()) continue;
                    Object w = invokeQuiet(m2, v);
                    if (w == null) continue;
                    for (Method m3 : w.getClass().getMethods()) {
                        if (m3.getParameterCount() == 0 && m3.getReturnType() == Canvas.class) {
                            sb.append("{").append(m.getName()).append(".").append(m2.getName())
                                    .append(".").append(m3.getName()).append("=Canvas}");
                        }
                    }
                }
            }
        } catch (Throwable t) {
            sb.append("err=").append(t);
        }
        return sb.toString();
    }

    private static Object invokeQuiet(Method m, Object o) {
        try {
            m.setAccessible(true);
            return m.invoke(o);
        } catch (Throwable ignore) {
            return null;
        }
    }

    interface NativePainter {
        void paint(Canvas c);
    }
}
