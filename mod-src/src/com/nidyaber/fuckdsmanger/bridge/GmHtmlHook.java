// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.webkit.WebView;

import com.nidyaber.fuckdsmanger.gm.GmHtml;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * GmHtmlHook —— 让 AI 气泡渲染**任意 HTML** 🐲 2026-10-03 · 尼得亚伯
 *
 * <h3>整条思路（为什么能成）</h3>
 * Compose 里"自己塞一个控件"对我们**封死**了（{@code AndroidView} 是 @Composable，
 * 而 Composable 的 Composer 状态机由 Kotlin+compose 编译器在编译期算好，
 * 纯 javac 手写必崩）。<b>但宿主自己有条现成通道</b>：
 *
 * <pre>
 *   ```mermaid 代码块
 *     └─ o01（MarkdownCodeKt）里：v7a.M(代码块语言, "mermaid", true)Z   ★ 语言闸门
 *         └─ MarkdownMermaidDiagram（nu6）→ xz6（协程）→ wz6（持有）
 *             └─ new MermaidViewerWebView(Context, "dark"|"light")      ← 真名没混淆！
 *                 └─ a(String 源码)  → evaluateJavascript(requestRenderMermaid(源码))  ★ 内容闸门
 * </pre>
 *
 * <b>我们只做两件事</b>：
 * <ol>
 *   <li><b>语言闸门</b>：让 {@code ```html} 也被判定成 mermaid ⇒ 宿主替我们建一个 WebView；</li>
 *   <li><b>内容闸门</b>：在它要把"源码"喂给 mermaid.js 的那一刻，
 *       改成 {@code loadDataWithBaseURL(null, 我们拼好的页面, "text/html", ...)} —— 直接渲染 HTML。</li>
 * </ol>
 *
 * 于是位置、尺寸、回收、滚动**全由宿主自己管**，我们一行 Compose 代码都不用写。
 *
 * <h3>⚠️ 两条纪律</h3>
 * <ul>
 *   <li><b>两个闸门必须一起成功</b>才启用 —— 只改语言闸门而不改内容闸门，
 *       结果是 ```html 被塞进 mermaid.js ⇒ 界面上显示"渲染失败"，比不做还糟。</li>
 *   <li>判据用 <b>内容特征</b>（{@code GmHtml.looksLikeHtml}）而不是语言名 ——
 *       到内容闸门那一刻语言名已经丢了。好在 mermaid 与 HTML 形态天然分得开。</li>
 * </ul>
 */
public final class GmHtmlHook extends XC_MethodHook {

    // ─────────────────────── 候选混淆名 ───────────────────────

    /** 语言判断工具（R8 合并类）—— 2.6.1 实测 `v7a`，里面的 `M(String,String,boolean)Z` */
    private static final String[] CAND_LANG = {"v7a"};

    /**
     * 「持有 mermaid WebView」的那个混淆类 —— 从它身上<b>伸手拿</b> WebView 子类的 Class。
     *
     * <p>★ <b>为什么不直接写那个全名</b>：铁律「不依赖宿主包名」
     * （见 {@code 专题/铁律-不依赖宿主包名.md}）—— mermaid 渲染器的全名里
     * 那段应用前缀就是**宿主应用 id**，分身/换包名时会整段变；
     * 出包自检会扫 dex 里的这个字符串并直接拒绝出包（本轮就被拦了一次，拦得对）。
     *
     * <p>所以改成从**混淆短名**里读：{@code wz6} 是 R8 改的短名（跟 {@code fz2}/{@code kn}
     * 一个性质，不含宿主包名），它的字段类型里就带着那个 WebView 子类 ⇒
     * 反射读一个字段类型即可，<b>全程不出现宿主包名字面量</b>。
     *
     * <p>2.6.1 实测：{@code wz6.d} 的类型就是 mermaid 的查看器 WebView。
     */
    private static final String[] CAND_HOLDER = {"wz6"};

    /** 兜底用的最小 mermaid 源码（换掉真源码后，宿主自己那段 JS 就不会报错） */
    private static final String SAFE_MERMAID = "graph TD;A[.]";

    /**
     * 已经替换过的 WebView 实例 —— <b>这道闸是防死循环的</b>。
     *
     * <p>为什么必须有：{@code a(String)} 是在 {@code onPageFinished} 之后被调的，
     * 而我们的 {@code loadDataWithBaseURL} 会**再触发一次 onPageFinished**
     * ⇒ 宿主又调 {@code a(html)} ⇒ 我们又替换 ⇒ <b>无限重载</b> ——
     * 表现就是"一直转圈，最后渲染失败"（真机实测症状）。
     *
     * <p>用 {@link java.util.WeakHashMap} 是为了不拦住 WebView 的回收
     * （条目被回收后，键自动消失）。
     */
    private static final java.util.Map<WebView, Boolean> sSwapped =
            java.util.Collections.synchronizedMap(
                    new java.util.WeakHashMap<WebView, Boolean>());

    private static volatile boolean sReady = false;
    private static volatile String sWhy = "未初始化";
    private static volatile int sHits = 0;

    public static int hits() {
        return sHits;
    }

    public static String status() {
        return (sReady ? "已就绪" : "未就绪") + " · " + sWhy + "（替换 " + sHits + " 次）";
    }

    // ═══════════════════════════ 诊断（只走 logcat / DIAG）═══════════════════════════
    //
    //  ⚠️ 2026-10-04 主人明确否决：「不允许往外部存储写文件」—— 那条路我实现过又撤了。
    //  确实不该：外部私有目录虽然 adb 读得到，但它同时是**任何能读 SD 卡的东西**都读得到的，
    //  而且"模块往存储里写日志"本身就是个风控特征。
    //  ⇒ 诊断只走 logcat + DIAG 两个既有通道；现场抓不到就用 frida 插桩补。
    //
    // ═══════════════════════════════════════════════════════════════════════════════

    /**
     * ★★ 最终落点：{@code WebView.evaluateJavascript(String, ValueCallback)}。
     *
     * <p><b>为什么换到这儿</b>：内联渲染走的不是查看器那一支（真机日志里
     * {@code MermaidViewerWebView.a(String)} 一次都没被调用）—— 光靠"猜是哪个类"
     * 会一轮一轮地试错。而不管上游是查看器、生成器还是别的什么，
     * <b>最后都得经过这句</b>：
     * <pre>
     *   evaluateJavascript("if (window.JSBridge &amp;&amp; …) requestRenderMermaid(源码, 0);")
     * </pre>
     * 挂在这里 ⇒ <b>一次覆盖全部入口</b>，再也不用猜类名。
     *
     * <p>判据只用一条：JS 里出现 {@code requestRenderMermaid} 才继续
     * （一次 {@code indexOf}，别的 WebView 调用零开销）。
     */
    private static final class EvalHook extends XC_MethodHook {

        private static volatile int sProbe = 0;
        /** 无条件统计：前几次 evaluateJavascript 调用都记下来（回答"hook 本身生效了吗"） */
        private static volatile int sAll = 0;

        @Override
        protected void beforeHookedMethod(MethodHookParam p) {
            try {
                if (!(p.thisObject instanceof WebView)) return;
                if (p.args == null || p.args.length < 1) return;
                Object a0 = p.args[0];
                if (!(a0 instanceof String)) return;
                String js = (String) a0;

                // ★★ 无条件探针（前 8 次）—— 先回答最根本的那个问题：
                //    「WebView.evaluateJavascript 这个钩子到底生效了没」。
                //    连它都不打 ⇒ 钩子没生效（或者宿主压根不经过它）；
                //    打了但不含 mermaid ⇒ 宿主用的是别的投递方式。
                if (sAll < 8) {
                    sAll++;
                    String h = js.length() > 100 ? js.substring(0, 100) : js;
                    GmUtil.log("【HTML探针】evaluateJavascript #" + sAll
                            + " len=" + js.length()
                            + " 含mermaid=" + (js.indexOf("requestRenderMermaid") >= 0)
                            + " 头=" + h.replace('\n', ' ').replace('\r', ' '));
                }

                // 两套命名都认：内联是 window.generateMermaid，全屏预览是 requestRenderMermaid
                int k = js.indexOf("generateMermaid");
                if (k < 0) k = js.indexOf("requestRenderMermaid");
                if (k < 0) return;

                String src = firstStringArg(js, k);
                if (sProbe < 6) {
                    sProbe++;
                    String m = "投递源码 长度=" + (src == null ? -1 : src.length())
                            + " 开关=" + GmHtml.on()
                            + " 像HTML=" + (src != null && GmHtml.looksLikeHtml(src))
                            + " 头=" + head(src);
                    GmUtil.log("【HTML探针】" + m);
                }
                // ★ 这里**不再做替换** —— 页面已经在 LoadUrlHook 里被换成我们自己的了，
                //   宿主这句 JS 会命中我们页面里的 generateMermaid（它自己负责渲染 + 回执）。
                //   早先版本在这里 loadDataWithBaseURL 重载页面，反而造成"重载死循环 + 回执丢失"，
                //   真机症状就是「一直卡在生成中」。
            } catch (Throwable t) {
                GmUtil.logFail("htmlHook.eval", t);
            }
        }
    }

    /** 从 {@code requestRenderMermaid("…", 0)} 里把第一个字符串参数原样取出来（走过去 JSON 转义） */
    private static String firstStringArg(String js, int from) {
        try {
            int i = js.indexOf('(', from);
            if (i < 0) return null;
            i++;
            while (i < js.length() && Character.isWhitespace(js.charAt(i))) i++;
            if (i >= js.length()) return null;
            char c = js.charAt(i);
            if (c != '"' && c != '\'') return null;
            if (c == '\'') {
                // 单引号：自己扫一遍（JSONTokener 不认）
                StringBuilder sb = new StringBuilder();
                for (int j = i + 1; j < js.length(); j++) {
                    char ch = js.charAt(j);
                    if (ch == '\\' && j + 1 < js.length()) {
                        sb.append(js.charAt(++j));
                        continue;
                    }
                    if (ch == '\'') return sb.toString();
                    sb.append(ch);
                }
                return null;
            }
            Object o = new org.json.JSONTokener(js.substring(i)).nextValue();
            return (o instanceof String) ? (String) o : null;
        } catch (Throwable t) {
            return null;
        }
    }

    private static String head(String s) {
        if (s == null) return "(null)";
        String t = s.replace('\n', ' ').replace('\r', ' ').trim();
        return t.length() > 80 ? t.substring(0, 80) : t;
    }

    /**
     * ★ 无条件探针：盯住 {@code WebView} 的**每一次构造**。
     *
     * <p>目的只有一个 —— 回答「宿主到底用了哪些 WebView 子类」。
     * 之前两轮我都栽在"猜是哪个类"上：Viewer 的探针一条没打，
     * 说明内联渲染走的根本不是它。与其继续猜，不如让宿主自己报出来。
     *
     * <p>只记录、不改行为。WebView 创建不频繁，开销可忽略。
     */
    private static final class WebViewCtorProbe extends XC_MethodHook {
        private static volatile int sN = 0;

        @Override
        protected void afterHookedMethod(MethodHookParam p) {
            try {
                if (sN >= 12) return;
                sN++;
                Object o = p.thisObject;
                if (o == null) return;
                Class<?> c = o.getClass();
                // ★ 连裸 WebView 也记 —— 之前这里过滤掉了 WebView.class 本身，
                //   而"谁在用它"恰恰是我们要回答的问题
                GmUtil.log("【HTML探针】WebView 构造 #" + sN + " = " + c.getName());
            } catch (Throwable ignore) {
                // 探针而已
            }
        }
    }

    /** 只做"报信"用的构造器钩子 —— 确认 WebView 到底有没有被创建（不改任何行为） */
    private static final class CtorProbe extends XC_MethodHook {
        private static volatile int sN = 0;

        @Override
        protected void afterHookedMethod(MethodHookParam p) {
            try {
                if (sN >= 4) return;
                sN++;
                GmUtil.log("【HTML探针】WebView 已创建 #" + sN
                        + " cls=" + p.thisObject.getClass().getName()
                        + " 开关=" + GmHtml.on());
            } catch (Throwable ignore) {
                // 探针而已
            }
        }
    }

    /** 挂在 {@code MermaidViewerWebView.a(String)} / {@code b(String,Continuation)} 上 */
    private static final class SrcHook extends XC_MethodHook {

        /** 探针计数 —— 只打前几次，既能看到现场又不会刷屏 */
        private static volatile int sProbe = 0;

        @Override
        protected void beforeHookedMethod(MethodHookParam p) {
            try {
                if (p.args == null || p.args.length < 1) return;
                Object a0 = p.args[0];
                if (!(a0 instanceof String)) return;
                String src = (String) a0;

                // ★ 探针：先无条件记录前 6 次现场 ——
                //   要回答的是「宿主到底走 a 还是 b」「内容到底长什么样」「判据认不认」，
                //   这三个问题不落地，后面所有推断都是瞎猜。
                if (sProbe < 6) {
                    sProbe++;
                    String head = src.length() > 90 ? src.substring(0, 90) : src;
                    GmUtil.log("【HTML探针】#" + sProbe
                            + " 方法=" + p.method.getName()
                            + " len=" + src.length()
                            + " 开关=" + GmHtml.on()
                            + " 像HTML=" + GmHtml.looksLikeHtml(src)
                            + " 头=" + head.replace('\n', ' ').replace('\r', ' '));
                }

                // ★ 这里只做探针 —— "替换页面"那件事已经交给 LoadUrlHook
                //   （它换的是 generator.html，页面由宿主自己这次 loadUrl 加载，
                //    时序天然正确）。在渲染方法里再动手重载，会造成
                //    "onPageFinished → 又调 a() → 又重载" 的死循环，
                //    真机症状就是「一直卡在生成中」。
            } catch (Throwable t) {
                GmUtil.logFail("htmlHook.src", t);
            }
        }
    }

    // ═══════════════════════════ ② 语言闸门 ═══════════════════════════

    /** 挂在 `v7a.M(String,String,boolean)Z` 上 —— 让 "html" 也走 mermaid 那条路 */
    private static final class LangHook extends XC_MethodHook {
        @Override
        protected void beforeHookedMethod(MethodHookParam p) {
            try {
                if (!GmHtml.on()) return;
                if (p.args == null || p.args.length < 2) return;
                Object lang = p.args[0];
                Object target = p.args[1];
                // ★ 只认这一个组合：判据目标是 "mermaid"，而当前语言是 "html"
                //   —— v7a 是 R8 合并类，M 会被别处调用，判据必须收得很紧
                if (!(lang instanceof String) || !(target instanceof String)) return;
                if (!"mermaid".equals(target)) return;
                String l = ((String) lang).trim().toLowerCase();
                if (!"html".equals(l) && !"htm".equals(l)) return;
                p.setResult(Boolean.TRUE);
            } catch (Throwable t) {
                GmUtil.logFail("htmlHook.lang", t);
            }
        }
    }

    // ═══════════════════════════ ③ 安装 ═══════════════════════════

    /**
     * 装钩。三处落点，**主落点根本不用猜类名**：
     * <ol>
     *   <li><b>WebView.evaluateJavascript</b>（★ 主）—— 任何入口最后都得过这一句；</li>
     *   <li><b>v7a.M 语言闸门</b>（前提）—— 没有它 ```html 压根不会走 WebView；</li>
     *   <li>查看器的 a/b（补充）—— 万一有条路不经 evaluateJavascript。</li>
     * </ol>
     * 语言闸门拿不到 ⇒ <b>整体不启用</b>（只有装载落点而语言闸门不在，
     * 等于谁也碰不到，白装；反过来更糟，界面上会顶着"渲染失败"）。
     */
    public static int install(ClassLoader cl) {
        int n = 0;

        // ① ★ 主落点
        if (hookEval(cl) > 0) n++;

        // ② 语言闸门（前提）
        int langHooked = hookLang(cl);

        // ③ 补充落点
        Class<?> viewer = findViewerClass(cl);
        if (viewer != null) n += hookViewer(viewer);

        if (n == 0) {
            sWhy = "一个可用的装载落点都没找到";
            GmUtil.log("hookM FAIL html → " + sWhy);
            return 0;
        }
        if (langHooked == 0) {
            // ★ 关键取舍：装载落点在、语言闸门不在 ⇒ **整体不启用**。
            //   ```html 根本走不到 WebView 那条路，装了也没人调用；
            //   而装一半（语言闸门在、装载不在）会让界面顶着"mermaid 渲染失败"——比不做还糟。
            sWhy = "语言闸门 v7a.M(String,String,boolean) 没找到（装载落点已就绪但不启用）";
            GmUtil.log("hookM FAIL html → " + sWhy);
            return 0;
        }

        sReady = true;
        sWhy = "语言闸门 + " + n + " 个装载落点";
        return n + langHooked;
    }

    /**
     * ★ 主落点：{@code WebView.evaluateJavascript} + {@code loadUrl} + 构造器探针。
     *
     * <p>⚠️ <b>必须用宿主的 ClassLoader 按类名取 WebView</b>，不能写 {@code WebView.class} ——
     * 模块编译时链的是 android.jar 的 stub，而运行期这个引用由**模块自己的** ClassLoader
     * 解析，未必等于宿主真正在用的那个 WebView 类 ⇒ 钩子"装上了"却永远不触发
     * （这正是前几轮探针一条都不打的最可能原因）。
     */
    private static int hookEval(ClassLoader cl) {
        int n = 0;
        Class<?> wv = null;
        try {
            wv = XposedHelpers.findClass("android.webkit.WebView", cl);
        } catch (Throwable t) {
            GmUtil.logFail("htmlHook.findWebView", t);
        }
        if (wv == null) {
            GmUtil.log("hookM html → android.webkit.WebView 找不到");
            return 0;
        }
        GmUtil.log("hookM html WebView 类=" + wv.getName()
                + " loader=" + wv.getClassLoader());

        // ① 构造器探针：任何 WebView 子类被 new 出来都会报名字
        try {
            int c = 0;
            java.lang.reflect.Constructor<?>[] cts = wv.getDeclaredConstructors();
            for (int i = 0; i < cts.length; i++) {
                java.lang.reflect.Constructor<?> ct = cts[i];
                Class<?>[] ps = ct.getParameterTypes();
                if (ps.length >= 1 && ps[0] == android.content.Context.class) {
                    try {
                        ct.setAccessible(true);
                        XposedBridge.hookMethod(ct, new WebViewCtorProbe());
                        c++;
                    } catch (Throwable ignore) {
                        // 这个重载挂不上就算
                    }
                }
            }
            GmUtil.log("hookM html 探针 WebView 构造器已挂 " + c + " 个");
            n += c;
        } catch (Throwable t) {
            GmUtil.logFail("htmlHook.webviewCtor", t);
        }

        // ② loadUrl 探针：直接看谁在加载 viewer.html / generator.html
        try {
            Method[] ms = wv.getDeclaredMethods();
            for (int i = 0; i < ms.length; i++) {
                Method m = ms[i];
                if (!"loadUrl".equals(m.getName())) continue;
                Class<?>[] ps = m.getParameterTypes();
                if (ps.length == 1 && ps[0] == String.class) {
                    m.setAccessible(true);
                    XposedBridge.hookMethod(m, new LoadUrlHook());
                    n++;
                    GmUtil.log("hookM html count=1 cls=android.webkit.WebView.loadUrl(String)");
                }
            }
        } catch (Throwable t) {
            GmUtil.logFail("htmlHook.loadUrl", t);
        }

        // ③ 主落点：evaluateJavascript
        try {
            Method ev = null;
            Method[] ms = wv.getDeclaredMethods();
            for (int i = 0; i < ms.length; i++) {
                Method m = ms[i];
                if (!"evaluateJavascript".equals(m.getName())) continue;
                Class<?>[] ps = m.getParameterTypes();
                if (ps.length == 2 && ps[0] == String.class) {
                    ev = m;
                    break;
                }
            }
            if (ev == null) {
                GmUtil.log("hookM html → evaluateJavascript 没找到");
                return n;
            }
            ev.setAccessible(true);
            XposedBridge.hookMethod(ev, new EvalHook());
            GmUtil.log("hookM html count=1 cls=android.webkit.WebView.evaluateJavascript(String,ValueCallback)");
            return n + 1;
        } catch (Throwable t) {
            GmUtil.logFail("htmlHook.hookEval", t);
            return n;
        }
    }

    /**
     * ★ 真正的落点：把 {@code generator.html} 这个 URL 换成我们自己那份页。
     *
     * <p>证据链（真机探针）：宿主 new 出 {@code MermaidGeneratorWebView} →
     * {@code loadUrl("file:///android_asset/generator.html")} →
     * {@code evaluateJavascript("… window.generateMermaid("<table", "dark") …")}。
     * 也就是说这块代码最终是被<b>那个页面</b>渲染的，我们只要把页面换掉就能接管。
     *
     * <p><b>只换 generator，不碰 viewer</b>：viewer 是"点图表全屏预览"那条路，
     * 用的回执是 {@code NativeBridge.onMermaidRendered} + SVG，跟这里不是一套；
     * 原样留着，点开预览还是宿主自己的 mermaid 渲染。
     *
     * <p>做法：把 {@code args[0]}（URL 字符串）改成我们那个 {@code file://} 路径。
     * 页面由宿主自己这次 {@code loadUrl} 加载 ⇒ 时序天然正确，不用我们操心。
     */
    private static final class LoadUrlHook extends XC_MethodHook {
        private static volatile int sN = 0;

        @Override
        protected void beforeHookedMethod(MethodHookParam p) {
            try {
                if (p.args == null || p.args.length < 1) return;
                Object a0 = p.args[0];
                if (!(a0 instanceof String)) return;
                String url = (String) a0;
                if (url.indexOf("generator.html") < 0 && url.indexOf("viewer.html") < 0) return;

                if (sN < 6) {
                    sN++;
                    Object self0 = p.thisObject;
                    String m = "loadUrl #" + sN + " url=" + url
                            + " 实例类=" + (self0 == null ? "?" : self0.getClass().getName())
                            + " 开关=" + GmHtml.on();
                    GmUtil.log("【HTML探针】" + m);
                }

                if (!GmHtml.on()) return;
                // ★ 两个内置页都接管：
                //   generator.html → 内联渲染（回 PNG 给 AndroidBridge）
                //   viewer.html    → 点「全屏」预览（回 FINISHED 给 NativeBridge）
                //   我们的页面两套接口都实现了，所以只换页面、不用管上游是谁。
                //   早先只换 generator ⇒ 点全屏时 viewer 还在渲染 mermaid ⇒ 黑屏。

                Object self = p.thisObject;
                if (!(self instanceof WebView)) return;
                // ★ 用 data URL 而不是 file:// —— targetSdk >= 30 时 WebView 默认禁 file 访问，
                //   "写文件 + file:// 加载"会得到 title=「网页无法打开」（frida 实测抓到的）
                String mine = GmHtml.pageDataUrl();
                if (mine == null) {
                    GmUtil.log("【HTML】自建页生成失败 ⇒ 放行原逻辑");
                    return;
                }

                p.args[0] = mine;
                GmUtil.logOnce("htmlHook.swap", "【HTML】已把 generator.html 换成自建页：" + mine);
            } catch (Throwable t) {
                GmUtil.logFail("htmlHook.loadUrl", t);
            }
        }
    }

    /** 语言闸门：让 ```html 也被当成 mermaid ⇒ 宿主替我们建 WebView */
    private static int hookLang(ClassLoader cl) {
        int hooked = 0;
        for (String name : CAND_LANG) {
            try {
                Class<?> c = Class.forName(name, false, cl);
                Method[] ms = c.getDeclaredMethods();
                for (int i = 0; i < ms.length; i++) {
                    Method m = ms[i];
                    if (!"M".equals(m.getName())) continue;
                    if (!Modifier.isStatic(m.getModifiers())) continue;
                    if (m.getReturnType() != boolean.class) continue;
                    Class<?>[] ps = m.getParameterTypes();
                    if (ps.length != 3) continue;
                    if (ps[0] != String.class || ps[1] != String.class || ps[2] != boolean.class) continue;
                    m.setAccessible(true);
                    XposedBridge.hookMethod(m, new LangHook());
                    hooked++;
                    GmUtil.log("hookM html count=1 cls=" + name + ".M(String,String,boolean)");
                    break;
                }
            } catch (Throwable t) {
                GmUtil.logFail("htmlHook.install/lang/" + name, t);
            }
        }
        return hooked;
    }

    /** 补充落点：查看器自己的装载方法 + 只报信的构造器探针 */
    private static int hookViewer(Class<?> c) {
        int n = 0;
        try {
            try {
                java.lang.reflect.Constructor<?> ct = c.getDeclaredConstructor(
                        android.content.Context.class, String.class);
                ct.setAccessible(true);
                XposedBridge.hookMethod(ct, new CtorProbe());
                GmUtil.log("hookM html 探针 cls=" + c.getName() + ".<init>(Context,String)");
            } catch (Throwable ignore) {
                GmUtil.log("hookM html 探针：构造器( Context,String )没找到，跳过（不影响功能）");
            }
            Method[] ms = c.getDeclaredMethods();
            for (int i = 0; i < ms.length; i++) {
                Method m = ms[i];
                Class<?>[] ps = m.getParameterTypes();
                if (m.getReturnType() == void.class
                        && ps.length == 1 && ps[0] == String.class) {
                    m.setAccessible(true);
                    XposedBridge.hookMethod(m, new SrcHook());
                    n++;
                    GmUtil.log("hookM html count=1 cls=" + c.getName() + "." + m.getName() + "(String)");
                } else if (ps.length == 2 && ps[0] == String.class && !ps[1].isPrimitive()) {
                    // suspend 版：(String, Continuation)
                    m.setAccessible(true);
                    XposedBridge.hookMethod(m, new SrcHook());
                    n++;
                    GmUtil.log("hookM html count=1 cls=" + c.getName() + "." + m.getName() + "(String,Cont)");
                }
            }
        } catch (Throwable t) {
            GmUtil.logFail("htmlHook.hookViewer", t);
        }
        return n;
    }

    /**
     * 从「持有者」混淆类里伸手拿 WebView 子类的 Class。
     *
     * <p>为什么不直接 {@code Class.forName(全名)}：那要写死宿主应用 id 前缀，
     * 违反铁律「不依赖宿主包名」，而且出包自检会扫 dex 字符串直接拒绝
     * （见 {@link #CAND_HOLDER} 的注释）。
     */
    private static Class<?> findViewerClass(ClassLoader cl) {
        for (String n : CAND_HOLDER) {
            try {
                Class<?> holder = Class.forName(n, false, cl);
                for (Field f : holder.getDeclaredFields()) {
                    Class<?> t = f.getType();
                    // 要的是「WebView 的子类」，不是 WebView 自己
                    if (t != WebView.class && WebView.class.isAssignableFrom(t)) {
                        return t;
                    }
                }
            } catch (Throwable ignore) {
                // 换下一个候选
            }
        }
        return null;
    }}
