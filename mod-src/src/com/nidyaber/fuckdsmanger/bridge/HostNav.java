// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.os.Bundle;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 【HostNav】从模块 UI 导航到**宿主自己的** Compose 页面 🐲 2026-11-14（3.108.4）
 *
 * <h3>要解决什么</h3>
 * 整页（{@code HostPage}）已经能画在宿主进程里了。但主人还想「从我们这儿点一下，
 * 直接跳进宿主自己的某个页面」——比如设置页、字号页、账号管理页。
 *
 * <h3>⚠️ 2.5.2 的方案 A 在 2.8.0 已经失效（别再照抄旧文档）</h3>
 * 旧文档（`专题/界面导航管理器-宿主对照.md` §4 方案 A）的结论是：
 * 因为 destination id 和 route 串都只由 {@code serialName} 决定，
 * 所以我们**造一个带同样 {@code @SerialName} 的伪对象**喂给
 * {@code navController.navigate(obj)} 就能命中。
 *
 * <p>**2.8.0 上那条路没了**（在 {@code tmp/h280} 真反编译树上逐条验过）：
 * <pre>
 *   2.5.2  Lld6;->n(Ljava/lang/Object;Lrd6;)V              ← navigate(route: Any, extras)
 *   2.8.0  Lms7;->n(Lss7;Landroid/os/Bundle;Lgt7;)V        ← navigate(NavDestination, Bundle, NavOptions)
 *                                                             **没有 (Object) 重载了**
 * </pre>
 * 而长得很像的 {@code Lms7;->o(Ljava/lang/Object;Lgt7;)V} 读方法体后确认**不是**导航：
 * <pre>
 *     f(Object)String   → 拿 route 串
 *     l()               → 取当前节点状态
 *     m(String,Z,NavGraph) → matchRoute
 *     … 然后直接 return，**没有任何入栈**
 * </pre>
 * ⇒ 它是 popBackStack 家族的成员。往它上面挂「导航」会静默什么都不发生。
 *
 * <h3>本类走的是「方案 C · 全程字符串」</h3>
 * <pre>
 *   graph = ms7.j()                              // getGraph()（串 "You must call setGraph() before…"）
 *   match = vs7.m(routeStr, true, graph)         // matchRoute ← **第二参收 String！**
 *   dest  = rs7.a                                // NavDestination
 *   args  = rs7.b                                // Bundle
 *   ms7.n(dest, args, navOptions)                // 入栈
 * </pre>
 * 好处：**不需要我们造路由对象**，也就不碰「宿主的 kotlinx 实例能不能反查模块 ClassLoader 里的类」
 * 这个高危问题（旧文档 §4.5 把它列为「未评估的真风险」）。
 *
 * <p>代价：绑死四个混淆名（{@code ms7/vs7/rs7/ss7}）。但它们都在 {@link GmRemap} 里，
 * 宿主升级时按「串 + 形状」重定位即可（判据见类底部注释）。
 *
 * <h3>NavController 实例怎么拿</h3>
 * 在 {@code zs7.<init>(Context)} 之后取 {@code this.b} ——
 * 那是全 dex **唯一** {@code new ms7} 的地方（{@code zs7.smali:36}），
 * 而 {@code zs7} 的构造点只有一个（{@code g37:10596}，即 {@code rememberNavController()}）。
 *
 * <p>⚠️ 字段名 {@code b} 是 2.8.0 写死的，所以取不到时会退化成
 * 「按 ms7 类型扫字段」—— 多一层保险。
 */
public final class HostNav {

    /** 当前拿到的 NavController（每个进程一份；宿主重建时会被覆盖）。 */
    private static volatile Object sCtrl = null;
    /** 拿到它的时间（诊断用）。 */
    private static volatile long sAt = 0L;
    /** 装了几次（防重复 hook）。 */
    private static volatile boolean sInstalled = false;

    private HostNav() {
    }

    // ══════════════════════════════════════════════════════════════════
    //  安装
    // ══════════════════════════════════════════════════════════════════

    /**
     * 挂 {@code zs7.<init>} 抓 NavController。只在宿主进程里调用。
     *
     * <p>失败不抛 —— 导航器是**附加功能**，挂了不该影响别的钩子。
     */
    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        String K = "hostnav.holder";
        if (!GmRemap.hit(K, "init")) {
            log("✗ 锚点键写错（应为 hostnav.holder.init）⇒ 导航器不可用");
            return;
        }
        String cn = GmRemap.clsFor(K, "init");
        String mn = GmRemap.method(K, "init");
        try {
            Class<?> c = XposedHelpers.findClass(cn, cl);
            XposedBridge.hookAllConstructors(c, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    try {
                        Object self = p.thisObject;
                        if (self == null) return;
                        Object ctrl = fieldOfCtrl(self);
                        if (ctrl == null) {
                            log("✗ zs7 里找不到 ms7 类型字段 ⇒ 导航器拿不到 NavController");
                            return;
                        }
                        sCtrl = ctrl;
                        sAt = System.currentTimeMillis();
                        log("✅ 已抓到 NavController（" + ctrl.getClass().getName()
                                + "）⇒ 宿主页面导航可用");
                    } catch (Throwable t) {
                        log("抓 NavController 抛了：" + t);
                    }
                }
            });
            sInstalled = true;
            log("已挂 " + cn + " 的构造器（" + mn + "）");
            installSampler(cl);
        } catch (Throwable t) {
            log("挂 zs7.<init> 失败 ⇒ 导航器不可用：" + t);
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  参数样本：偷宿主自己的 navigate 实参
    //  ──────────────────────────────────────────────────────────────────
    //  为什么这是**必要**的（不是锦上添花）：
    //    2.8.0 的 `NavArgument`（`Lds7;`）只有 Type/Nullable/hasDefault 三个信息，
    //    **默认值本身被 R8 省掉了**（`ds7.toString()` 里那句 " DefaultValue: null" 是硬编码）。
    //    所以「带参页面」我们没法凭空造出一个能让宿主页面正常渲染的值。
    //    但宿主自己跳这些页面时**手里一定有值** ⇒ 在 `ms7.n(dest,bundle,opts)` 上搭个耳朵，
    //    把 (route → 参数字典) 记在内存里。下次从导航器点同一条路由时：
    //      ① 有样本 ⇒ 直接能用（连点都不用填）
    //      ② 没样本 ⇒ UI 弹出参数表单，让人填
    //
    //  只记「小、能转成字符串」的值：Bundle 里可能有 Parcelable/大数组，
    //  照抄下来会把内存撑爆，而且那些参数本来也不是我们能喂的。
    // ══════════════════════════════════════════════════════════════════

    /** route → `k=v` 列表（值已经转成字符串，最多 {@link #SAMPLE_MAX_KEYS} 个）。 */
    private static final java.util.Map<String, java.util.Map<String, String>> sSamples =
            new java.util.concurrent.ConcurrentHashMap<String, java.util.Map<String, String>>();

    /** 最多记多少条路由的样本（防止宿主长跑把内存吃光）。 */
    private static final int SAMPLE_MAX_ROUTES = 64;
    /** 单条路由最多记几个参数。 */
    private static final int SAMPLE_MAX_KEYS = 8;
    /** 单个值最长多少字符（再长就不是"能填回表单"的东西了）。 */
    private static final int SAMPLE_MAX_LEN = 200;

    private static void installSampler(ClassLoader cl) {
        String cn = GmRemap.cls("hostnav.ctrl");
        String mn = GmRemap.method("hostnav.ctrl", "navigate");
        if (GmRemap.isGone(cn) || GmRemap.isGone(mn)) return;
        try {
            Class<?> c = XposedHelpers.findClass(cn, cl);
            // 先找本类声明的，再补继承来的（`ms7` 可能继承 BaseNavController，方法不一定在自己身上）
            java.util.LinkedHashSet<Method> cand = new java.util.LinkedHashSet<Method>();
            for (Method m : c.getDeclaredMethods()) cand.add(m);
            for (Method m : c.getMethods()) cand.add(m);
            int n = 0;
            for (Method m : cand) {
                if (!m.getName().equals(mn)) continue;
                Class<?>[] p = m.getParameterTypes();
                if (p.length != 3) continue;
                XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam hp) {
                        try {
                            if (hp.args == null || hp.args.length < 2) return;
                            Object dest = hp.args[0];
                            Object arg = hp.args[1];
                            if (!(arg instanceof Bundle)) return;
                            String route = routeOf(dest);
                            if (route == null || route.length() == 0) return;
                            Bundle b = (Bundle) arg;
                            if (b.isEmpty()) return;
                            java.util.Map<String, String> kv = toSample(b);
                            if (kv.isEmpty()) return;
                            if (sSamples.size() > SAMPLE_MAX_ROUTES && !sSamples.containsKey(route)) {
                                // 简单粗暴：满了就不再收新的（不 LRU —— 记不全比记错好）
                                return;
                            }
                            java.util.Map<String, String> old = sSamples.get(route);
                            if (old == null || !old.equals(kv)) {
                                sSamples.put(route, kv);
                                log("📥 采样到参数样本：" + shortName(route) + " · " + kv.keySet());
                            }
                        } catch (Throwable ignore) {
                        }
                    }
                });
                n++;
            }
            log("参数采样器已挂：" + cn + "." + mn + " × " + n);
        } catch (Throwable t) {
            log("挂参数采样器失败（不影响导航）：" + t);
        }
    }

    /** Bundle → 只保留「能变成字符串」的小值。 */
    private static java.util.Map<String, String> toSample(Bundle b) {
        java.util.Map<String, String> kv = new java.util.LinkedHashMap<String, String>();
        for (String k : b.keySet()) {
            if (kv.size() >= SAMPLE_MAX_KEYS) break;
            try {
                Object v = b.get(k);
                if (v == null) continue;
                String s;
                if (v instanceof String || v instanceof CharSequence
                        || v instanceof Number || v instanceof Boolean) {
                    s = String.valueOf(v);
                } else if (v instanceof String[]) {
                    String[] a = (String[]) v;
                    s = a.length == 0 ? "" : a[0];
                } else {
                    continue;          // Parcelable / 数组 / 集合 ⇒ 不抄
                }
                if (s.length() > SAMPLE_MAX_LEN) continue;
                kv.put(k, s);
            } catch (Throwable ignore) {
            }
        }
        return kv;
    }

    /**
     * 从 {@code zs7} 里取 NavController：先按名 {@code b}，取不到就按类型扫。
     *
     * <p>为什么要有第二条：字段名是混淆的，宿主一升级就可能变；
     * 而「类型是 ms7」这件事**在同一个版本里一定成立**。
     */
    private static Object fieldOfCtrl(Object holder) {
        String ctrlCls = GmRemap.cls("hostnav.ctrl");
        try {
            return XposedHelpers.getObjectField(holder, "b");
        } catch (Throwable ignore) {
        }
        for (Class<?> k = holder.getClass(); k != null && k != Object.class; k = k.getSuperclass()) {
            for (Field f : k.getDeclaredFields()) {
                if (!f.getType().getName().equals(ctrlCls)) continue;
                try {
                    f.setAccessible(true);
                    return f.get(holder);
                } catch (Throwable ignore) {
                }
            }
        }
        return null;
    }

    // ══════════════════════════════════════════════════════════════════
    //  导航
    // ══════════════════════════════════════════════════════════════════

    /** 拿到了没有（UI 侧判断导航器能不能用）。 */
    public static boolean ready() {
        return sCtrl != null;
    }

    /** 一句人能读的状态。 */
    public static String stats() {
        if (sCtrl == null) return "NavController 未就绪";
        return "NavController 就绪 · " + sCtrl.getClass().getName()
                + " · 取得于 " + sAt;
    }

    /**
     * 导航到一条宿主路由（**不带参数**）。
     *
     * <p>有样本（宿主自己跳这条路由时用过参数）就自动带上样本；
     * 没有就只跳 pattern —— {@code {name}} 那种占位符会原样留在串里，
     * 宿主页面可能空白。要填值请用 {@link #go(String, String[], String[])}。
     *
     * @param route **完整** serialName，例如
     *              {@code com.deepseek.chat.ui.pages.SettingsNestedGraph.FontSizeRoute}
     * @return {@code null} ＝ 成功；否则是失败原因（给界面显示 / 写日志）
     *
     * <p>⚠️ 必须在**主线程**调用（Navigation-Compose 的要求）。
     * 整页里点按钮天然就在主线程，但别在协程的 IO 调度器上调。
     */
    public static String go(String route) {
        return go(route, null, null);
    }

    /**
     * 导航到一条宿主路由，**带参数** 🐲 2026-11-15（3.108.6）
     *
     * <h3>为什么必须补这个</h3>
     * 3.108.4/3.108.5 只有 {@code go(pattern)}。真机上点
     * {@code …AuthNestedGraph.MobileVerificationRoute/{signature}} 时，日志写
     * 「✅ 已导航」，但 `{signature}` 原样进了 route 串、Bundle 里一个参数都没有
     * ⇒ 宿主那个页面拿不到参数（空白 / 报错 / 自己弹回）。
     *
     * <h3>现在的走法</h3>
     * <pre>
     * ① pattern 先 matchRoute 一次 → 拿 dest → 从 dest.c() 读参数 schema
     * ② 值 = 样本（宿主自己用过） ← 用户填的覆盖样本
     * ③ 把 route 里的 {name} 用值替换（Uri.encode）→ effective
     * ④ effective 再 matchRoute 一次 → 这次的 Bundle 里**已经带 path 参数**
     * ⑤ 再按 schema 把其余值 put 进去（用 NavType.parseValue 转成正确类型）
     * ⑥ navigate(dest, bundle, opts)
     * </pre>
     *
     * <p>参数名/类型全部是**运行时**从宿主导航图里读的（`ss7.c()` → `Map<String,NavArgument>`），
     * 不在 dex 里写死任何宿主 route 或参数名 —— 项目铁律那条自检扫的就是字节。
     *
     * @param keys 参数名（可为 null）；与 {@code vals} 一一对应
     * @param vals 参数值（字符串形态；内部按宿主 schema 转类型）
     */
    public static String go(String route, String[] keys, String[] vals) {
        if (route == null || route.length() == 0) return "route 为空";
        final Object ctrl = sCtrl;
        if (ctrl == null) return "还没抓到 NavController（宿主可能还没建图）";

        try {
            // ① graph = ctrl.j()   ← getGraph()
            Object graph = graphOf(ctrl);
            if (graph == null) return "getGraph() 返回 null（图还没装好）";

            // ② pattern 先匹配一次：拿 dest（参数 schema 只能从 dest 上读）
            Object dm0 = matchRoute(ctrl, graph, route);
            if (dm0 == null) {
                return "宿主图里没有这条路由（" + route + "）—— 可能这版删了或改了名";
            }
            Object dest0 = XposedHelpers.getObjectField(dm0, "a");

            // ③ 合并取值：样本打底，用户填的覆盖
            java.util.Map<String, String> argVals = new java.util.LinkedHashMap<String, String>();
            java.util.Map<String, String> sample = sSamples.get(route);
            if (sample != null) argVals.putAll(sample);
            if (keys != null) {
                for (int i = 0; i < keys.length; i++) {
                    String k = keys[i];
                    if (k == null || k.length() == 0) continue;
                    String v = (vals != null && i < vals.length) ? vals[i] : null;
                    if (v == null) continue;
                    argVals.put(k, v);
                }
            }

            // ④ 把 {name} 填掉，得到能真正匹配的 route
            String eff = fillRoute(route, argVals);
            Object dm = eff.equals(route) ? dm0 : matchRoute(ctrl, graph, eff);
            if (dm == null) return "按填好的参数匹配失败（" + eff + "）";
            Object dest = XposedHelpers.getObjectField(dm, "a");

            // ⑤ Bundle：先吃 matchRoute 解析出来的 path 参数，再按 schema 塞其余的
            Bundle bundle = bundleOf(dm);
            java.util.Map<?, ?> schema = argumentsOf(dest0);
            if (schema == null || schema.isEmpty()) schema = argumentsOf(dest);
            for (java.util.Map.Entry<String, String> e : argVals.entrySet()) {
                Object navArg = schema == null ? null : schema.get(e.getKey());
                Object v = navArg != null ? parseValue(navArg, e.getValue()) : e.getValue();
                put(bundle, e.getKey(), v);
            }

            // ⑥ navOptions：gt7 是 NavOptions，n() 里直接 iget 不判空 ⇒ 必须给实例
            Class<?> ctrlCls = ctrl.getClass();
            Object opts = newNavOptions(ctrlCls.getClassLoader());
            String nMth = GmRemap.method("hostnav.ctrl", "navigate");
            if (GmRemap.isGone(nMth)) return "锚点升级失效（navigate）";
            Class<?> destCls = Class.forName(GmRemap.cls("hostnav.dest"), false,
                    ctrlCls.getClassLoader());
            Method nav = null;
            for (Method m : ctrlCls.getMethods()) {
                if (!m.getName().equals(nMth)) continue;
                Class<?>[] p = m.getParameterTypes();
                if (p.length == 3 && p[0].isAssignableFrom(destCls) && p[1] == Bundle.class) {
                    nav = m;
                    break;
                }
            }
            if (nav == null) return "找不到 navigate(" + nMth + ")";
            nav.invoke(ctrl, dest, bundle, opts);

            log("✅ 已导航 → " + eff
                    + (argVals.isEmpty() ? "" : " · 参数 " + argVals.keySet()));
            return null;
        } catch (Throwable t) {
            Throwable c = (t instanceof java.lang.reflect.InvocationTargetException
                    && t.getCause() != null) ? t.getCause() : t;
            log("✗ 导航失败 " + route + "：" + c);
            return String.valueOf(c);
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  导航的零件
    // ══════════════════════════════════════════════════════════════════

    /** {@code ctrl.j()} → NavGraph。 */
    private static Object graphOf(Object ctrl) throws Exception {
        String gm = GmRemap.method("hostnav.ctrl", "getGraph");
        if (GmRemap.isGone(gm)) throw new NoSuchMethodException("锚点升级失效（getGraph）");
        return ctrl.getClass().getMethod(gm).invoke(ctrl);
    }

    /**
     * {@code graph.m(route, true, graph)} → DeepLinkMatch。
     *
     * <p>第二参传 {@code true} = 「允许匹配到 pattern」，这正是我们要的：
     * 先用 pattern 拿 schema，再用填好的 route 拿 Bundle。
     */
    private static Object matchRoute(Object ctrl, Object graph, String route) throws Exception {
        String mm = GmRemap.method("hostnav.graph", "matchRoute");
        if (GmRemap.isGone(mm)) throw new NoSuchMethodException("锚点升级失效（matchRoute）");
        Method match = null;
        for (Method m : graph.getClass().getMethods()) {
            if (!m.getName().equals(mm)) continue;
            Class<?>[] p = m.getParameterTypes();
            if (p.length == 3 && p[0] == String.class && p[1] == boolean.class) {
                match = m;
                break;
            }
        }
        if (match == null) throw new NoSuchMethodException("找不到 matchRoute(" + mm + ")");
        return match.invoke(graph, route, true, graph);
    }

    /** DeepLinkMatch.b → 可写 Bundle（复制一份，别改宿主内部那个）。 */
    private static Bundle bundleOf(Object dm) {
        Bundle out = new Bundle();
        try {
            Object b = XposedHelpers.getObjectField(dm, "b");
            if (b instanceof Bundle) out.putAll((Bundle) b);
        } catch (Throwable ignore) {
        }
        return out;
    }

    /**
     * {@code dest.c()} → {@code Map<String, NavArgument>}。
     *
     * <p>⚠️ 2.8.0 的 NavArgument（`Lds7;`）里**没有默认值** —— R8 把 defaultValue 字段省了
     * （`toString()` 里 " DefaultValue: null" 是硬编码字符串）。
     * ⇒ 「能自动填的默认值」不存在，只能靠样本 / 用户输入。
     */
    private static java.util.Map<?, ?> argumentsOf(Object dest) {
        if (dest == null) return null;
        String am = GmRemap.method("hostnav.dest", "arguments");
        if (GmRemap.isGone(am)) return null;
        try {
            for (Method m : dest.getClass().getMethods()) {
                if (!m.getName().equals(am)) continue;
                if (m.getParameterTypes().length != 0) continue;
                Object r = m.invoke(dest);
                return (r instanceof java.util.Map) ? (java.util.Map<?, ?>) r : null;
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** NavArgument → 参数名（Map 的 key 就是，但取不到时返回空）。 */
    private static String argName(Object entryKey) {
        return entryKey instanceof String ? (String) entryKey : null;
    }

    /** NavArgument.a → NavType → {@code b()} 的类型名（"integer"/"string"…）。 */
    private static String typeNameOf(Object navArg) {
        try {
            Object t = XposedHelpers.getObjectField(navArg, "a");
            return typeName(t);
        } catch (Throwable ignore) {
            return "string";
        }
    }

    private static String typeName(Object navType) {
        String nm = GmRemap.method("hostnav.type", "name");
        if (GmRemap.isGone(nm)) return "string";
        try {
            Object r = XposedHelpers.callMethod(navType, nm);
            if (r instanceof String) return (String) r;
        } catch (Throwable ignore) {
        }
        return "string";
    }

    /**
     * 字符串 → 正确类型的值。
     *
     * <p>首选宿主自己的 {@code NavType.d(String)}（= parseValue）——
     * 它对 "int"/"integer" 这类命名差异、以及 string[] 的解析最准。
     * 拿不到（某些抽象实现会抛 UnsupportedOperationException）才按类型名自己来。
     */
    private static Object parseValue(Object navArg, String s) {
        try {
            Object t = XposedHelpers.getObjectField(navArg, "a");
            String pm = GmRemap.method("hostnav.type", "parse");
            if (!GmRemap.isGone(pm)) {
                try {
                    Object v = XposedHelpers.callMethod(t, pm, s);
                    if (v != null) return v;
                } catch (Throwable ignore) {
                }
            }
            String tn = typeName(t);
            if ("bool".equals(tn) || "boolean".equals(tn)) {
                return Boolean.valueOf("true".equalsIgnoreCase(s) || "1".equals(s));
            }
            if ("int".equals(tn) || "integer".equals(tn)) return Integer.valueOf(s.trim());
            if ("long".equals(tn)) return Long.valueOf(s.trim());
            if ("float".equals(tn)) return Float.valueOf(s.trim());
            return s;
        } catch (Throwable ignore) {
            return s;
        }
    }

    /** 按运行时类型 put（Bundle 的 put 是强类型的，塞错会害宿主读不到）。 */
    private static void put(Bundle b, String k, Object v) {
        if (b == null || k == null || v == null) return;
        if (v instanceof Boolean) b.putBoolean(k, (Boolean) v);
        else if (v instanceof Integer) b.putInt(k, (Integer) v);
        else if (v instanceof Long) b.putLong(k, (Long) v);
        else if (v instanceof Float) b.putFloat(k, (Float) v);
        else if (v instanceof Double) b.putDouble(k, (Double) v);
        else if (v instanceof String[]) b.putStringArray(k, (String[]) v);
        else if (v instanceof java.util.List) {
            java.util.ArrayList<String> a = new java.util.ArrayList<String>();
            for (Object o : (java.util.List<?>) v) a.add(String.valueOf(o));
            b.putStringArrayList(k, a);
        } else b.putString(k, String.valueOf(v));
    }

    /**
     * 把 route 里的 `{name}` 用值替换掉（URL 编码 —— route 匹配走 Uri 解析）。
     *
     * <p>★★ 2026-11-15（3.108.6）· **`?` 之后的 query 参数要整项删，不是留占位符**：
     * 真机上有这么一条（截图里一行被撑爆的那条）：
     * <pre>
     *   …/SearchResultWebViewRoute/{url}?queries={queries}&amp;chatSessionId={chatSessionId}&amp;…
     * </pre>
     * 若某个 query 项没值却把 `queries={queries}` 原样留着，
     * Uri 解析出来的 `queries` 字面值就是 `"{queries}"` —— 宿主页面收到一个
     * 看起来非空、其实是垃圾的参数（比缺参数更难查）。
     * 而 **path 段不能删**（`/{signature}` 删了整条 route 就匹配不上了）⇒ 保留占位符，
     * 这样调用方还能从"跳不动"里看出到底缺哪个。
     */
    private static String fillRoute(String route, java.util.Map<String, String> vals) {
        if (route == null) return null;
        if (vals == null || vals.isEmpty()) return route;

        // ① path 段（`?` 之前）
        int q = route.indexOf('?');
        String head = q >= 0 ? route.substring(0, q) : route;
        StringBuilder hb = new StringBuilder(head.length() + 32);
        int i = 0;
        while (i < head.length()) {
            char ch = head.charAt(i);
            if (ch == '{') {
                int j = head.indexOf('}', i + 1);
                if (j > i + 1) {
                    String name = head.substring(i + 1, j);
                    String v = vals.get(name);
                    if (v != null && v.length() > 0) {
                        hb.append(android.net.Uri.encode(v));
                        i = j + 1;
                        continue;
                    }
                }
            }
            hb.append(ch);
            i++;
        }
        if (q < 0) return hb.toString();

        // ② query 段：`k=v` 逐项处理，值为空 ⇒ **整项丢掉**
        StringBuilder qb = new StringBuilder();
        String query = route.substring(q + 1);
        for (String part : query.split("&")) {
            if (part.length() == 0) continue;
            String k = part;
            String v = null;
            int eq = part.indexOf('=');
            if (eq >= 0) {
                k = part.substring(0, eq);
                v = part.substring(eq + 1);
            }
            // 值本身可能是个占位符 `{queries}`
            String filled = null;
            if (v != null) {
                int a = v.indexOf('{'), b = v.indexOf('}');
                if (a == 0 && b > 1) {
                    filled = vals.get(v.substring(1, b));
                } else {
                    filled = v;          // 字面值，原样留
                }
            }
            if (filled == null || filled.length() == 0) {
                // key 本身就是占位符形式（`{queries}`）时也查一次
                String kk = k;
                int a = kk.indexOf('{'), b = kk.indexOf('}');
                if (a == 0 && b > 1) filled = vals.get(kk.substring(1, b));
            }
            if (filled == null || filled.length() == 0) continue;   // 没值 ⇒ 丢掉
            if (qb.length() > 0) qb.append('&');
            qb.append(k);
            if (v != null) qb.append('=').append(android.net.Uri.encode(filled));
        }
        return qb.length() == 0 ? hb.toString() : hb + "?" + qb;
    }

    /** route 里所有 `{name}` 的名字（顺序去重）。 */
    private static java.util.List<String> placeholdersOf(String route) {
        java.util.List<String> out = new java.util.ArrayList<String>();
        if (route == null) return out;
        int i = 0;
        while (i < route.length()) {
            int a = route.indexOf('{', i);
            if (a < 0) break;
            int b = route.indexOf('}', a + 1);
            if (b < 0) break;
            String n = route.substring(a + 1, b);
            if (n.length() > 0 && !out.contains(n)) out.add(n);
            i = b + 1;
        }
        return out;
    }

    /**
     * 造一个「什么都不改变」的 NavOptions。
     *
     * <p>{@code gt7.<init>(ZZIZZII)} —— 7 个参数，按 NavOptions 的常规语义给默认值：
     * <pre>
     *   false, false, -1, false, false, -1, -1
     *                 ↑ popUpToId = -1 ⇒ 不 pop 任何东西
     * </pre>
     *
     * <p>⚠️ 不能传 {@code null}：{@code ms7.n()} 里对第三参是**直接 iget** 读字段的
     * （`iget v2, v9, Lgt7;->c:I`），没有判空 ⇒ 传 null 必 NPE。
     */
    private static Object newNavOptions(ClassLoader cl) throws Exception {
        Class<?> c = Class.forName(GmRemap.cls("hostnav.opts"), true, cl);
        for (Constructor<?> k : c.getDeclaredConstructors()) {
            Class<?>[] p = k.getParameterTypes();
            if (p.length != 7) continue;
            k.setAccessible(true);
            return k.newInstance(false, false, -1, false, false, -1, -1);
        }
        throw new NoSuchMethodException("NavOptions 没有 7 参构造器");
    }

    // ══════════════════════════════════════════════════════════════════
    //  路由清单 —— **运行时从宿主的导航图里遍历出来**
    //
    //  为什么不在代码里写死那 25 条串：
    //    ① 项目铁律「不依赖宿主包名」—— 那些串全是 `com.deepseek.chat.ui.pages.*`，
    //       写进 dex 会直接被 `build_single.py` 的 ⑫ 自检拦下（真的被拦过一次）。
    //       而这条铁律的实质是「别拿宿主包名当**判据**」，路由串虽然只是数据，
    //       但既然能动态拿到，就没理由写死。
    //    ② 写死就**必然过时**：2.5.2 是 22 条、2.8.0 是 25 条（多了
    //       GuardianMobile / HistoryExport / LoginDevicesManagement）。
    //       动态遍历 ⇒ 宿主新增页面**自动出现**，不用改一行代码。
    //
    //  怎么遍历（h280 实证）：
    //    `Lvs7;`(=NavGraph) **implements Iterable**，`iterator()` 存在；
    //    `Lss7;`(=NavDestination，抽象) 的 `a:Ljava/lang/String;` 就是 route。
    //    NavGraph 本身也是 NavDestination ⇒ 递归它的 children 即可。
    // ══════════════════════════════════════════════════════════════════

    /** 递归深度上限（防宿主图里出现环或意外深嵌套）。 */
    private static final int MAX_DEPTH = 6;

    /**
     * 列出宿主导航图里的全部 destination。
     *
     * @return 每个元素 **7 列**（3.108.6 起）：
     * <pre>
     *   [0] 完整 route（可能是 pattern，例如 …Route/{signature}）
     *   [1] 短名（最后一个 `.` 之后、去掉 Route 后缀）
     *   [2] "1"/"0" 是不是 nested graph
     *   [3] "1"/"0" 要不要参数
     *   [4] 参数 schema：`name|type|nullable|hasDefault` 项间 \u0001
     *   [5] 参数样本：`name=value` 项间 \u0001（宿主自己 navigate 时抓的）
     *   [6] route 里的占位符名：`name` 项间 \u0001（`{signature}` 这种）
     * </pre>
     * 拿不到图就返回空数组（界面会显示诊断，而不是假装有空清单）。
     */
    public static String[][] routes() {
        Object ctrl = sCtrl;
        if (ctrl == null) return new String[0][];
        try {
            Object graph = graphOf(ctrl);
            if (graph == null) return new String[0][];

            java.util.List<String[]> out = new java.util.ArrayList<String[]>();
            walk(graph, out, 0, Class.forName(GmRemap.cls("hostnav.graph"), false,
                    ctrl.getClass().getClassLoader()));
            return out.toArray(new String[0][]);
        } catch (Throwable t) {
            log("遍历导航图失败：" + t);
            return new String[0][];
        }
    }

    /** 列分隔符（`\u0001`）与字段分隔符（`|`）—— route/参数名里都不会出现控制字符。 */
    private static final String SEP = "\u0001";

    private static void walk(Object node, java.util.List<String[]> out, int depth,
                              Class<?> graphCls) {
        if (node == null || depth > MAX_DEPTH) return;
        try {
            // ★★ 2026-11-14（3.108.4）· route 到底在哪
            //
            //   第一版读的是 `Lss7;->a:Ljava/lang/String;` —— **错的**，
            //   那是 **className**：构造器里 `R0(Class)String` 塞进去的
            //   （Navigation-Compose 给每个 composable() 生成的匿名类都叫 "composable"）
            //   ⇒ 真机上一屏 24 行全是 `composable`（主人截图）。
            //
            //   真身在 `ss7.b`（`Lnt` 这个数据持有者）的 `e` 字段 —— 判据来自
            //   `ss7.toString()` 那一段（它就是按这个顺序打印的）：
            //   <pre>
            //     iget-object p0, p0, Lss7;->b:Lnt;
            //     iget v1, p0, Lnt;->a:I                 ← id
            //     const-string v1, " route="
            //     iget-object p0, p0, Lnt;->e:Ljava/lang/Object;   ← ★ route 串
            //     invoke-static {v1}, Lama;->d0(Ljava/lang/CharSequence;)Z  ← 判非空
            //   </pre>
            //   `Lnt` 字段：a:I(id) · b/c/d/e/f:Object（e = route，f = 状态持有者）
            String route = routeOf(node);
            // 兜底：老字段（className）—— 只在拿不到 route 时用，好歹有个东西显示
            if (route == null || route.length() == 0) {
                try {
                    Object v = XposedHelpers.getObjectField(node, "a");
                    if (v instanceof String) route = (String) v;
                } catch (Throwable ignore) {
                }
            }

            boolean isGraph = graphCls.isInstance(node);

            // ★★ 2026-11-15（3.108.6）· 参数 schema
            //   旧代码判的是 `ss7.d` —— 那是 `Lrea;`（SparseArrayCompat）不是 Map
            //   ⇒ `instanceof Map` 恒 false ⇒ 「需要参数」永远标不出来，
            //   只能靠 UI 里那张硬编码名单凑数。
            //   真身是 `ss7.c()`：`nt.d`（LinkedHashMap）→ `Map<String,NavArgument>`。
            StringBuilder params = new StringBuilder();
            int argCount = 0;
            java.util.Map<?, ?> args = argumentsOf(node);
            if (args != null) {
                for (java.util.Map.Entry<?, ?> e : args.entrySet()) {
                    String name = argName(e.getKey());
                    if (name == null) continue;
                    Object na = e.getValue();
                    String tn = typeNameOf(na);
                    boolean nullable = boolField(na, "b");
                    boolean hasDef = boolField(na, "c");
                    if (argCount > 0) params.append(SEP);
                    params.append(name).append('|').append(tn).append('|')
                            .append(nullable ? '1' : '0').append('|')
                            .append(hasDef ? '1' : '0');
                    argCount++;
                }
            }

            java.util.List<String> ph = placeholdersOf(route);
            boolean hasArgs = argCount > 0 || !ph.isEmpty();

            if (route != null && route.length() > 0) {
                out.add(new String[]{
                        route, shortName(route), isGraph ? "1" : "0",
                        hasArgs ? "1" : "0",
                        params.toString(),
                        sampleOf(route),
                        join(ph),
                });
            }
            if (!isGraph) return;
            if (!(node instanceof Iterable)) return;
            for (Object child : (Iterable<?>) node) {
                walk(child, out, depth + 1, graphCls);
            }
        } catch (Throwable ignore) {
        }
    }

    /** `ss7.b`（`nt`）→ `nt.e` = route 串。 */
    private static String routeOf(Object dest) {
        try {
            Object h = XposedHelpers.getObjectField(dest, "b");
            Object r = XposedHelpers.getObjectField(h, "e");
            return (r instanceof String) ? (String) r : null;
        } catch (Throwable ignore) {
            return null;
        }
    }

    /** NavArgument 的布尔字段（b = nullable · c = hasDefaultValue）。 */
    private static boolean boolField(Object o, String name) {
        try {
            return XposedHelpers.getBooleanField(o, name);
        } catch (Throwable ignore) {
            return false;
        }
    }

    private static String join(java.util.List<String> xs) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < xs.size(); i++) {
            if (i > 0) sb.append(SEP);
            sb.append(xs.get(i));
        }
        return sb.toString();
    }

    /** 样本 → `k=v` 拼接（route 上没有样本就返回空串）。 */
    private static String sampleOf(String route) {
        java.util.Map<String, String> kv = sSamples.get(route);
        if (kv == null || kv.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (java.util.Map.Entry<String, String> e : kv.entrySet()) {
            if (sb.length() > 0) sb.append(SEP);
            sb.append(e.getKey()).append('=').append(e.getValue());
        }
        return sb.toString();
    }

    /**
     * `…SettingsNestedGraph.FontSizeRoute` → `FontSize`
     *
     * <p>只按 `.` 切分取最后一段再去掉 `Route` 后缀 —— **不检查任何前缀**，
     * 这样 dex 里不会出现宿主包名字面量（铁律那条自检扫的就是字节）。
     * 人话翻译在 UI 侧做（按短名匹配，同样不含包名）。
     *
     * <p>★★ 2026-11-15（3.108.6）· **必须先把 path / query 切掉**。
     * 真机截图里的反例（3.108.6 第一版）：
     * <pre>
     *   真 route : …AuthNestedGraph.MobileVerificationRoute/{signature}
     *   旧短名   : MobileVerificationRoute/{signature}     ← `Route` 后缀没剥掉
     *   ⇒ 人话表（"MobileVerification" → "手机验证"）匹配不上，界面显示英文原文
     *
     *   真 route : …SearchNestedGraph.SearchResultWebViewRoute/{url}?queries={queries}&amp;…
     *   旧短名   : SearchResultWebViewRoute/{url}?queries={queries}&amp;…   ← 一整坨把行撑爆
     * </pre>
     * 所以顺序是：先切 `?`、再切 `/`、然后按 `.` 取最后一段、最后剥 `Route` 后缀。
     * **不碰 `{…}` 本身**（占位符信息别处还要用）。
     */
    private static String shortName(String route) {
        if (route == null) return "";
        String s = route;
        int q = s.indexOf('?');
        if (q > 0) s = s.substring(0, q);        // 切掉 query
        int sl = s.indexOf('/');
        if (sl > 0) s = s.substring(0, sl);      // 切掉 path（/{signature} 这种）
        int i = s.lastIndexOf('.');
        if (i >= 0) s = s.substring(i + 1);
        if (s.endsWith("Route")) s = s.substring(0, s.length() - 5);
        return s;
    }

    // ══════════════════════════════════════════════════════════════════
    //  dump —— 给「不占屏」的远程验证用 🐲 2026-11-15（3.108.6）
    //
    //  为什么要有它：导航图里的东西（route / 参数名 / 类型 / 样本）全是**运行时**才知道的，
    //  光看源码一个字都验不出来。而伸手去点主人的手机是要抢屏的
    //  ⇒ 让宿主自己 dump 到日志，`adb shell am broadcast … --es cmd nav_dump` 一条就够。
    // ══════════════════════════════════════════════════════════════════

    /**
     * 导航图 + 参数 schema + 样本 → 多行文本（**每行一条**，方便 grep）。
     *
     * <p>格式：
     * <pre>
     *   ready=true ctrl=ms7 routes=26 samples=3
     *   [G] SettingsNestedGraph   route=…SettingsNestedGraph  args=0   ⋯
     *   [P] FontSize              route=…FontSizeRoute        args=0
     *   [P] MobileVerification    route=…MobileVerificationRoute/{signature}  args=1
     *       · signature  string  nullable=0 default=0  sample=&lt;无&gt;
     * </pre>
     */
    public static String dump() {
        StringBuilder sb = new StringBuilder(4096);
        Object ctrl = sCtrl;
        sb.append("ready=").append(ctrl != null);
        sb.append(" ctrl=").append(ctrl == null ? "-" : ctrl.getClass().getName());
        sb.append(" samples=").append(sSamples.size()).append('\n');
        String[][] rs = routes();
        int leaves = 0, withArgs = 0, withSample = 0;
        for (String[] r : rs) {
            boolean graph = "1".equals(r[2]);
            boolean need = "1".equals(r[3]);
            if (!graph) leaves++;
            if (need) withArgs++;
            if (r[5] != null && r[5].length() > 0) withSample++;
            sb.append(graph ? "[G] " : "[P] ")
                    .append(r[1]).append("  route=").append(r[0])
                    .append("  args=").append(need ? "1" : "0");
            if (r[4] != null && r[4].length() > 0) {
                sb.append("  schema=").append(r[4].replace("\u0001", "; "));
            }
            if (r[5] != null && r[5].length() > 0) {
                sb.append("  sample=").append(r[5].replace("\u0001", "; "));
            }
            if (r[6] != null && r[6].length() > 0) {
                sb.append("  ph=").append(r[6].replace("\u0001", ","));
            }
            sb.append('\n');
        }
        sb.append("合计：页面 ").append(leaves)
                .append(" · 分组 ").append(rs.length - leaves)
                .append(" · 要参数 ").append(withArgs)
                .append(" · 有样本 ").append(withSample).append('\n');
        return sb.toString();
    }

    // ══════════════════════════════════════════════════════════════════
    //  日志
    // ══════════════════════════════════════════════════════════════════

    private static void log(String msg) {
        try {
            com.nidyaber.fuckdsmanger.gm.GmUtil.log("【HostNav】" + msg);
        } catch (Throwable ignore) {
        }
        try {
            XposedBridge.log("[FDM] 【HostNav】" + msg);
        } catch (Throwable ignore) {
        }
    }
}
