package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmSysPrompt;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Collection;
import java.util.IdentityHashMap;
import java.util.Map;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * GmSysPromptHideHook —— 「明文承载」的显示侧：把 ⟦FDM⟧…⟦/FDM⟧ 从气泡里抹掉 🐲 2026-10-03
 *
 * <p>实测样例（主人真机）：
 * <pre>⟦FDM⟧这是一条模拟系统提示词测试，如果你看见了，大大方方承认即可⟦/FDM⟧你好</pre>
 * 用户应该只看到「你好」。
 *
 * <h3>★ 为什么铺这么多个点（第三版）</h3>
 * 前两版都"挂上了但没命中"，而真机日志窗口太短（几分钟就轮转），抓不到现场参数 ——
 * 于是放弃"先定位再动手"，改成<b>把可能的路径一次铺满</b>，哪条路都躲得掉：
 *
 * <table border="1">
 *   <tr><th>挂点</th><th>形态</th><th>作用</th></tr>
 *   <tr><td>{@code i93.i}（气泡单元）</td><td>参数扫描</td><td>渲染参数里直接带着文本</td></tr>
 *   <tr><td>{@code d12.a}（消息列表）</td><td>参数扫描</td><td>整条列表的数据对象</td></tr>
 *   <tr><td>{@code i93} 的所有 String 方法</td><td><b>返回值改写</b></td><td>文本由某个 getter 取出</td></tr>
 *   <tr><td>{@code mr}（消息基类）的所有 String 方法</td><td><b>返回值改写</b></td><td>消息对象自己吐文本</td></tr>
 *   <tr><td>{@code AnnotatedString} 构造器</td><td>参数扫描</td><td>Compose 文本的最后一道门</td></tr>
 * </table>
 *
 * <p><b>安全性论证</b>：判定条件只有一个 —— 字符串里含 {@code ⟦FDM⟧}。
 * 这个标记**只可能出现在我们自己注入的文本里**（用户不可能碰巧打出 U+27E6 包着的 "FDM"），
 * 所以「见到就换掉」不会误伤宿主任何正常数据。而且注入发生在<b>请求构造那一刻</b>
 * （{@code wrap()} 每次都会重新加定界符），所以即便把某个历史数据对象里的定界段删了，
 * <b>也不影响下次发送时的注入</b>。
 *
 * <h3>纪律</h3>
 * 渲染热路径，<b>全 try/catch，绝不让异常逃出去</b>（教训 255）。
 */
public final class GmSysPromptHideHook extends XC_MethodHook {

    private static final int MAX_DEPTH = 4;
    private static final int MAX_FIELDS = 40;
    private static final int MAX_ITEMS = 60;
    private static final int MAX_ARGS = 16;

    private static final String[] SKIP_PKG = {
            "java.", "javax.", "kotlin.", "kotlinx.coroutines", "android.", "dalvik.", "sun.",
            "androidx.compose.runtime.", "androidx.compose.ui.node.", "androidx.compose.ui.platform.",
            "androidx.collection.", "androidx.compose.foundation.layout."
    };

    /** Compose 文本基础类的候选真名（不确定有没有被 R8 改名 ⇒ 挨个试，找不到就跳过） */
    private static final String[] ANNOTATED_STRING_CANDS = {
            "androidx.compose.ui.text.AnnotatedString",
            "androidx.compose.ui.text.AnnotatedStringKt",
    };

    // ─────────────────────────── ① 参数扫描（渲染入口）───────────────────────────

    @Override
    protected void beforeHookedMethod(MethodHookParam p) {
        try {
            if (GmSysPrompt.carrier() != GmSysPrompt.CARRIER_PLAIN) return;
            GmUtil.logOnce("syspromptHide.alive", "hide hook 已命中渲染路径（before 被调用）");

            Object[] a = p.args;
            if (a == null) return;

            Map<Object, Boolean> seen = new IdentityHashMap<Object, Boolean>();
            seen.put(p.thisObject, Boolean.TRUE);

            int lim = Math.min(a.length, MAX_ARGS);
            for (int i = 0; i < lim; i++) {
                Object o = a[i];
                if (o == null) continue;
                if (o instanceof String) {
                    String s = (String) o;
                    if (GmSysPrompt.hasPlainMark(s)) {
                        String stripped = GmSysPrompt.strip(s);
                        a[i] = stripped;
                        hit("arg" + i, s.length(), stripped.length());
                    }
                    continue;
                }
                if (o instanceof CharSequence) continue;
                scrub(o, MAX_DEPTH, seen);
            }
        } catch (Throwable t) {
            try {
                GmUtil.logFail("syspromptHide", t);
            } catch (Throwable ignore) {
            }
        }
    }

    // ─────────────────────────── ② 返回值改写（getter 路径）───────────────────────────

    /** 专门改「String 返回值」的 hook —— 挂到消息基类/渲染类的所有 String getter 上 */
    private static final class RetHook extends XC_MethodHook {
        @Override
        protected void afterHookedMethod(MethodHookParam p) {
            try {
                if (GmSysPrompt.carrier() != GmSysPrompt.CARRIER_PLAIN) return;
                Object r = p.getResult();
                if (!(r instanceof String)) return;
                String s = (String) r;
                if (!GmSysPrompt.hasPlainMark(s)) return;
                String stripped = GmSysPrompt.strip(s);
                p.setResult(stripped);
                hit("ret:" + p.method.getName(), s.length(), stripped.length());
            } catch (Throwable ignore) {
                // 热路径：静默
            }
        }
    }

    // ─────────────────────────── 递归扫描 ───────────────────────────

    @SuppressWarnings("unchecked")
    private static void scrub(Object o, int depth, Map<Object, Boolean> seen) {
        if (o == null || depth <= 0) return;
        Class<?> c = o.getClass();
        if (c.isPrimitive()) return;
        String cn = c.getName();
        for (String skip : SKIP_PKG) {
            if (cn.startsWith(skip)) return;
        }
        if (seen.containsKey(o)) return;
        seen.put(o, Boolean.TRUE);

        try {
            if (o instanceof Collection) {
                Collection<Object> col = (Collection<Object>) o;
                int n = 0;
                for (Object el : col) {
                    if (++n > MAX_ITEMS) break;
                    if (el instanceof String) {
                        String s = (String) el;
                        if (GmSysPrompt.hasPlainMark(s)) {
                            String stripped = GmSysPrompt.strip(s);
                            try {
                                col.remove(el);
                                col.add(stripped);
                                hit("collection", s.length(), stripped.length());
                            } catch (Throwable ignore) {
                            }
                        }
                    } else {
                        scrub(el, depth - 1, seen);
                    }
                }
                return;
            }
            if (o instanceof Map) {
                Map<Object, Object> m = (Map<Object, Object>) o;
                int n = 0;
                for (Map.Entry<Object, Object> e : m.entrySet()) {
                    if (++n > MAX_ITEMS) break;
                    Object v = e.getValue();
                    if (v instanceof String) {
                        String s = (String) v;
                        if (GmSysPrompt.hasPlainMark(s)) {
                            String stripped = GmSysPrompt.strip(s);
                            try {
                                e.setValue(stripped);
                                hit("map", s.length(), stripped.length());
                            } catch (Throwable ignore) {
                            }
                        }
                    } else {
                        scrub(v, depth - 1, seen);
                    }
                }
                return;
            }
            if (o instanceof Object[]) {
                Object[] arr = (Object[]) o;
                int lim = Math.min(arr.length, MAX_ITEMS);
                for (int i = 0; i < lim; i++) {
                    Object el = arr[i];
                    if (el instanceof String) {
                        String s = (String) el;
                        if (GmSysPrompt.hasPlainMark(s)) {
                            String stripped = GmSysPrompt.strip(s);
                            arr[i] = stripped;
                            hit("array", s.length(), stripped.length());
                        }
                    } else {
                        scrub(el, depth - 1, seen);
                    }
                }
                return;
            }
        } catch (Throwable ignore) {
            // 集合访问失败 ⇒ 继续尝试字段扫描
        }

        try {
            Field[] fs = c.getDeclaredFields();
            int lim = Math.min(fs.length, MAX_FIELDS);
            for (int i = 0; i < lim; i++) {
                Field f = fs[i];
                if (java.lang.reflect.Modifier.isStatic(f.getModifiers())) continue;
                try {
                    f.setAccessible(true);
                    Object v = f.get(o);
                    if (v == null) continue;
                    if (v instanceof String) {
                        String s = (String) v;
                        if (GmSysPrompt.hasPlainMark(s)) {
                            String stripped = GmSysPrompt.strip(s);
                            f.set(o, stripped);
                            hit(cn + "." + f.getName(), s.length(), stripped.length());
                        }
                    } else {
                        scrub(v, depth - 1, seen);
                    }
                } catch (Throwable ignore) {
                }
            }
        } catch (Throwable ignore) {
        }
    }

    private static void hit(String where, int before, int after) {
        try {
            GmUtil.logOnce("syspromptHide.hit." + where,
                    "抹掉定界段 → " + where + "（" + before + " → " + after + " 字符）");
        } catch (Throwable ignore) {
        }
    }

    // ─────────────────────────── 安装 ───────────────────────────

    public static void install(ClassLoader cl) {
        // ① 渲染入口的参数扫描
        hookArgs(cl, "pn9", "c", "unit");   // 气泡单元 Composable  → i93.i
        hookArgs(cl, "h91", "a", "list");   // 消息列表 Composable  → d12.a

        // ② String getter 返回值改写（键：文本是从某个方法里取出来的）
        hookStringGetters(cl, "pn9", "i93");   // 气泡单元自己的 getter
        hookStringGetters(cl, "vq", "mr");     // 消息基类（2.5.2 的 vq → 2.6.1 的 mr）

        // ③ Compose 文本的最后一道门（找不到就静默跳过）
        hookAnnotatedString(cl);
    }

    /** 挂某个方法的所有重载，走「参数扫描」逻辑 */
    private static void hookArgs(ClassLoader cl, String oldCls, String oldM, String tag) {
        try {
            String cls = GmRemap.cls(oldCls);
            String mth = GmRemap.method(oldCls, oldM);
            Class<?> c = XposedHelpers.findClass(cls, cl);
            XposedBridge.hookAllMethods(c, mth, new GmSysPromptHideHook());
            GmUtil.log("hookM syspromptHide/" + tag + " count=1 cls=" + cls + "." + mth);
        } catch (Throwable t) {
            GmUtil.log("hookM FAIL syspromptHide/" + tag + " (" + oldCls + "." + oldM + ") → " + t);
        }
    }

    /** 挂某个类里**所有返回 String 的方法**，走「返回值改写」逻辑 */
    private static void hookStringGetters(ClassLoader cl, String oldCls, String tag) {
        try {
            String cls = GmRemap.cls(oldCls);
            Class<?> c = XposedHelpers.findClass(cls, cl);
            int n = 0;
            for (Method m : c.getDeclaredMethods()) {
                if (m.getReturnType() != String.class) continue;
                try {
                    XposedBridge.hookMethod(m, new RetHook());
                    n++;
                } catch (Throwable ignore) {
                }
            }
            GmUtil.log("hookM syspromptHide/ret-" + tag + " count=" + n + " cls=" + cls);
        } catch (Throwable t) {
            GmUtil.log("hookM FAIL syspromptHide/ret-" + tag + " (" + oldCls + ") → " + t);
        }
    }

    /** 挂 Compose 文本基础类的构造器（类名没被混淆才有效 —— 试不到就跳过） */
    private static void hookAnnotatedString(ClassLoader cl) {
        for (String cn : ANNOTATED_STRING_CANDS) {
            Class<?> c = XposedHelpers.findClassIfExists(cn, cl);
            if (c == null) continue;
            int n = 0;
            for (Constructor<?> ct : c.getDeclaredConstructors()) {
                try {
                    XposedBridge.hookMethod(ct, new GmSysPromptHideHook());
                    n++;
                } catch (Throwable ignore) {
                }
            }
            GmUtil.log("hookM syspromptHide/annStr count=" + n + " cls=" + cn);
            return;
        }
        GmUtil.log("hookM syspromptHide/annStr → 类没找到（大概被 R8 改名了），跳过");
    }
}
