package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * GmRichText —— 「AI 气泡富文本」的核心工具 🐲 2026-10-03 · 尼得亚伯
 *
 * <h3>它解决什么</h3>
 * 3.45.0 的显示侧是「把 {@code ⟦FDM⟧…⟦/FDM⟧} 从气泡里<b>删掉</b>」；
 * 这一版反过来 —— AI 回复里出现 {@code ⟦FDM:模板名|参数…⟧} 时，
 * 把<b>标记包着的那一段</b>换成用户配好的富文本，<b>前后的普通文字照旧</b>。
 *
 * <h3>标记语法</h3>
 * <pre>
 *   ⟦FDM:card⟧              → 渲染模板 card（无参）
 *   ⟦FDM:card|晴|26℃⟧       → 渲染模板 card，模板里 {1}=晴  {2}=26℃
 * </pre>
 * 定界符刻意选成 {@code ⟦FDM:}（U+27E6 数学白方括号 + 冒号），
 * 与系统提示词那条 {@code ⟦FDM⟧} <b>不同前缀</b> ⇒ 两边判定互不干扰
 * （{@code ⟦FDM:card⟧} 里不含子串 {@code ⟦FDM⟧}，反之亦然）。
 *
 * <h3>模板 = HTML 子集</h3>
 * <pre>
 *   &lt;b&gt;粗&lt;/b&gt;   &lt;i&gt;斜&lt;/i&gt;   &lt;u&gt;下划线&lt;/u&gt;   &lt;s&gt;删除线&lt;/s&gt;（&lt;del&gt; 同义）
 *   &lt;c1&gt;色板1&lt;/c1&gt;        &lt;c#FF0000&gt;直给色&lt;/c&gt;
 *   &lt;bg1&gt;背景色板1&lt;/bg1&gt;   &lt;bg#FFFF00&gt;直给背景&lt;/bg&gt;
 *   &lt;br&gt;                 换行
 * </pre>
 * 嵌套随便套（Builder 的 pushStyle 会自动合并）；不认识的标签<b>整段丢掉</b>，不会漏出尖括号。
 *
 * <h3>⚠️ 配置读写纪律（3.45.0 踩过的坑，别再踩）</h3>
 * {@code GmStore.read2(ctx,key,x)} 的第三参是<b>类型</b>（{@code "b"/"i"/"l"/"f"/其它=string}），
 * <b>不是默认值</b>；{@code write} 的类型也只能是 {@code b/i/l/f/s}。
 * 写 {@code "boolean"} / {@code "String"} 会掉进 else ⇒ {@code putString} ⇒ 类型写脏。
 *
 * <h3>本类不碰反射</h3>
 * 只做「配置 + 解析 + 模板 + 标记扫描」，全是纯逻辑 ⇒ 可以脱离宿主单测。
 * 真正把结果变成 Compose 样式的是 {@code GmRichTextHook}。
 */
public final class GmRichText {

    // ─────────────────────────── 配置键 ───────────────────────────

    /** 总开关 */
    public static final String K_ON = "fuckds_rich_on";

    /**
     * 裸标签开关 —— <b>不用包标记，AI 直接写 {@code <b>} {@code <c1>} {@code <br>} 就生效</b>。
     *
     * <p>为什么默认开：模型天生爱写 HTML，你管不住它包不包 {@code ⟦FDM:…⟧}。
     * 关掉它，AI 写的标签就全露在界面上（真机实测过）。
     *
     * <p>安全性靠<b>白名单</b>：只认 {@code b/i/u/s/br/c1-9/bg1-9/c#RRGGBB/bg#RRGGBB}
     * 这几种形态 —— 代码块里的 {@code <div>}、数学里的 {@code a < b} 一律原样留着。
     */
    public static final String K_BARE = "fuckds_rich_bare";

    /**
     * 模板池 —— <b>每行一条：{@code 名字|HTML}</b>。
     *
     * <p>为什么做成"一个池"而不是"每模板一个键"：UI 那边只要一个多行文本框，
     * 跟「回复建议」「文件快捷选项」一个路子 —— 主人想加就加、想删就删，
     * 不用为「新增/删除模板」专门做一套动态界面。
     * 代价是模板里不能带真换行，换行请用 {@code <br>}。
     * {@code #} 开头的行当注释，方便主人自己写备忘。
     */
    public static final String K_TPLS = "fuckds_rich_tpls";

    /** 色板前缀，完整键 = {@code K_C + 1..9}；值与 UI 的 {@code K.CO} 一致（ARGB int） */
    public static final String K_C = "fuckds_rich_c";

    /** 开箱默认色板（键不存在时才用；主人一改就落库，之后不再回默认） */
    public static final int[] DEF_COLORS = {
            0,                   // 0 占位，不用
            (int) 0xFFFF5252L,   // 1 红
            (int) 0xFFFFB300L,   // 2 橙
            (int) 0xFFFFD600L,   // 3 黄
            (int) 0xFF4CAF50L,   // 4 绿
            (int) 0xFF26A69AL,   // 5 青
            (int) 0xFF42A5F5L,   // 6 蓝
            (int) 0xFF7E57C2L,   // 7 紫
            (int) 0xFFEC407AL,   // 8 粉
            (int) 0xFF9E9E9EL,   // 9 灰
    };

    /**
     * 开箱示例模板 —— 「填充示例」按钮用它灌进模板池，同时也是<b>格式说明书</b>：
     * 主人一眼就能看出怎么写、AI 一眼就知道该怎么用。
     */
    public static final String DEMO_TPLS =
            "# 每行一条：名字|富文本（HTML 子集，换行用 <br>）\n"
                    + "demo|<b>✦ {1}</b> {2}\n"
                    + "tip|<c6>▸ {1}</c>\n"
                    + "warn|<bg3><c#000000> ⚠ {1} </c></bg>\n"
                    + "card|<c7>┌ {1}</c><br><c7>└</c> {2}\n"
                    + "hi|<b><c4>你好，{1}</c></b> 今天{c2}很好</c>！";

    // ─────────────────────────── 标记定界 ───────────────────────────

    /** 开标记：{@code ⟦FDM:}（带冒号 ⇒ 模板模式） */
    public static final String OPEN = "\u27E6FDM:";
    /** 闭标记：{@code ⟧} */
    public static final String CLOSE = "\u27E7";

    /**
     * 匿名包裹开：{@code ⟦FDM⟧} —— ★ 2026-10-03 加。
     *
     * <p>为什么必须有它：模型从系统提示词里的定界符 {@code ⟦FDM⟧…⟦/FDM⟧} 学样，
     * 会主动写「包裹式」的标记（真机截图里就是这么写的），而不是我们规定的
     * {@code ⟦FDM:名字|参数⟧}。识别不了 ⇒ 整段原样露出 ⇒ 功能看着"只成功一半"。
     *
     * <p>语义：<b>包着的东西原样当 HTML 渲染</b>（不套模板、不需要参数）。
     */
    public static final String ANON_OPEN = "\u27E6FDM\u27E7";
    /** 匿名包裹闭：{@code ⟦/FDM⟧} */
    public static final String ANON_CLOSE = "\u27E6/FDM\u27E7";

    /**
     * 建议按钮开：{@code <Suggestion>} —— ★ 2026-10-05 加。
     *
     * <p>用途：AI 在回复末尾写一行 {@code <Suggestion>▸ 帮我再展开讲讲</Suggestion>}，
     * 我们**不把它当文字显示**，而是渲染成一个<b>可点击的链接</b>；
     * 用户点一下 ⇒ 把那句话当消息发给 AI（等价于自己打字+发送）。
     *
     * <p>语法两种形态：
     * <pre>
     *   &lt;Suggestion&gt;显示文字&lt;/Suggestion&gt;              显示与回复同一句
     *   &lt;Suggestion&gt;显示文字|真正回复的话&lt;/Suggestion&gt;  分开（显示短、回复长）
     * </pre>
     *
     * <p>⚠️ 与 {@code ⟦FDM:⟧} 同族但形态不同：这是<b>裸 HTML 标签</b>，
     * 走的是另一条路径（{@code GmRichLink} 的 pushLink），判定时先看 OPEN/ANON_OPEN。
     */
    public static final String SUG_OPEN = "<Suggestion>";
    /** 建议按钮闭：{@code </Suggestion>} */
    public static final String SUG_CLOSE = "</Suggestion>";

    /**
     * 建议按钮 · <b>保险写法</b>：{@code ⟦SUG⟧显示|回复⟦/SUG⟧}。
     *
     * <p>为什么要有它：{@code <Suggestion>} 是尖括号形态，<b>理论上可能被宿主的 markdown
     * 解析器当 HTML 标签吃掉</b>（那样标签在到达我们挂的 {@code fz2.p} 之前就没了）；
     * 而 {@code ⟦FDM:…⟧} 用的定界符已经实证能穿过宿主解析。
     * ⇒ 两种形态都认，哪一种活下来用哪一种（AI 侧提示词里两个都可以写）。
     */
    public static final String SUG2_OPEN = "\u27E6SUG\u27E7";
    /** 保险写法闭：{@code ⟦/SUG⟧} */
    public static final String SUG2_CLOSE = "\u27E6/SUG\u27E7";

    // ─────────────────────────── 事件种类 ───────────────────────────

    public static final int EV_TEXT = 0;
    public static final int EV_PUSH = 1;
    public static final int EV_POP = 2;

    private static final String[] EMPTY_ARGS = new String[0];

    private GmRichText() {}

    // ═══════════════════════════ ① 配置读写 ═══════════════════════════

    /**
     * 宽容读 boolean —— <b>三档兜底：b → s → i</b>。
     *
     * <p>★ 为什么必须有 `"i"` 那一档：UI 的开关控件在推送时可能把值塞进 JSON 的
     * {@code ints} 而不是 {@code bools} ⇒ 宿主存储里是 **int 类型**。
     * 而 {@code GmStore.read2(ctx,key,"b")} 去读一个 int 键会**抛异常并被它自己的
     * catchall 吞掉 ⇒ 返回 ""** ⇒ 判据恒 false ⇒ **开关怎么点都不生效**
     * （真机实测：`"ints":{"fuckds_html_on":1}` 而功能完全没反应）。
     *
     * <p>{@code GmRichText} 那边有这一档、{@code GmHtml} 一开始漏了 —— 症状就是
     * "开关是开的、日志里却一条都没有"。
     */
    public static boolean boolOf(Context ctx, String key, boolean def) {
        if (ctx == null) return def;
        try {
            String s = GmStore.read2(ctx, key, "b");
            if ("true".equals(s) || "1".equals(s)) return true;
            if ("false".equals(s) || "0".equals(s)) return false;
            s = GmStore.read2(ctx, key, "s");
            if ("true".equals(s) || "1".equals(s)) return true;
            if ("false".equals(s) || "0".equals(s)) return false;
            s = GmStore.read2(ctx, key, "i");            // ★ 漏了这一档就永远读不到
            if ("1".equals(s)) return true;
            if ("0".equals(s)) return false;
        } catch (Throwable ignore) {
            // 读不到 ⇒ 默认
        }
        return def;
    }

    /** 读文本：**分清「没设置」与「设置成空」**（SharedPreferences.contains 探手） */
    private static String textOr(Context ctx, String key, String def) {
        try {
            SharedPreferences sp = GmStore.get(ctx);
            if (sp != null && !sp.contains(key)) return def;
        } catch (Throwable ignore) {
            // 探不到 ⇒ 当没设置
        }
        try {
            String s = GmStore.read2(ctx, key, "s");
            return s == null ? def : s;
        } catch (Throwable ignore) {
            return def;
        }
    }

    public static boolean on() {
        Context ctx = GmUtil.app();
        if (ctx == null) return false;
        try {
            return boolOf(ctx, K_ON, false);
        } catch (Throwable t) {
            return false;
        }
    }

    public static void setOn(boolean v) {
        Context ctx = GmUtil.app();
        if (ctx == null) return;
        try {
            GmStore.write(ctx, K_ON, v ? "true" : "false", "b");    // ★ 类型 "b"
        } catch (Throwable t) {
            GmUtil.logFail("richText.setOn", t);
        }
    }

    /** 裸标签开关 —— 默认 <b>开</b>（模型天生爱写 HTML，关了它标签就全露出来） */
    public static boolean bareOn() {
        Context ctx = GmUtil.app();
        if (ctx == null) return true;
        try {
            return boolOf(ctx, K_BARE, true);
        } catch (Throwable t) {
            return true;
        }
    }

    public static void setBare(boolean v) {
        Context ctx = GmUtil.app();
        if (ctx == null) return;
        try {
            GmStore.write(ctx, K_BARE, v ? "true" : "false", "b");
        } catch (Throwable t) {
            GmUtil.logFail("richText.setBare", t);
        }
    }

    /** 模板名合法？—— 只允许字母/数字/下划线/连字符（中文也算 Letter ⇒ 放行） */
    public static boolean nameOk(String n) {
        if (n == null || n.isEmpty() || n.length() > 24) return false;
        for (int i = 0; i < n.length(); i++) {
            char c = n.charAt(i);
            if (Character.isLetterOrDigit(c) || c == '_' || c == '-') continue;
            return false;
        }
        return true;
    }

    /**
     * 解析模板池 —— 名字 → HTML（保持主人书写的顺序，LinkedHashMap）。
     *
     * <p>解析规则（宽容优先，写歪了不炸）：
     * <ul>
     *   <li>{@code #} 开头的行当注释；</li>
     *   <li>没有 {@code |} 的行整行忽略；</li>
     *   <li>名字不合法（含空格/标点）整行忽略；</li>
     *   <li>HTML 为空整行忽略。</li>
     * </ul>
     */
    public static LinkedHashMap<String, String> tplMap() {
        LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
        String s = "";
        Context ctx = GmUtil.app();
        if (ctx != null) {
            try {
                String v = GmStore.read2(ctx, K_TPLS, "s");         // ★ 类型 "s"
                if (v != null) s = v;
            } catch (Throwable t) {
                GmUtil.logFail("richText.tplMap", t);
            }
        }
        parsePool(s, map);
        if (map.isEmpty()) {
            // ★ 主人还没配过 ⇒ 用开箱示例兜底（装机即能用，方便一眼验证链路通没通）
            parsePool(DEMO_TPLS, map);
            GmUtil.logOnce("richHook.demo", "模板池是空的 ⇒ 用开箱示例模板（" + map.keySet() + "）");
        }
        return map;
    }

    private static void parsePool(String s, LinkedHashMap<String, String> map) {
        if (s == null || s.isEmpty()) return;
        String[] lines = s.split("\n");
        for (int i = 0; i < lines.length; i++) {
            String one = lines[i] == null ? "" : lines[i].trim();
            if (one.isEmpty() || one.charAt(0) == '#') continue;
            int bar = one.indexOf('|');
            if (bar <= 0) continue;
            String n = one.substring(0, bar).trim();
            String h = one.substring(bar + 1).trim();
            if (!nameOk(n) || h.isEmpty()) continue;
            map.put(n, h);
        }
    }

    /** 模板名清单（保持池里的顺序） */
    public static List<String> names() {
        return new ArrayList<String>(tplMap().keySet());
    }

    /** 读一个模板；没配过 ⇒ "" */
    public static String tpl(String name) {
        if (!nameOk(name)) return "";
        String h = tplMap().get(name);
        return h == null ? "" : h;
    }

    /** 读色板 1..9（ARGB int）；键不存在 ⇒ 用开箱默认 */
    public static int palette(int i) {
        if (i < 1 || i > 9) return 0;
        Context ctx = GmUtil.app();
        if (ctx != null) {
            try {
                SharedPreferences sp = GmStore.get(ctx);
                if (sp != null && sp.contains(K_C + i)) {
                    String s = GmStore.read2(ctx, K_C + i, "i");    // ★ 类型 "i"
                    if (s != null && !s.isEmpty()) return Integer.parseInt(s.trim());
                }
            } catch (Throwable ignore) {
                // 读不到 ⇒ 落默认色
            }
        }
        return DEF_COLORS[i];
    }

    /** 写色板 1..9（UI 一般走宿主 cfg_put 直写，这个是给"恢复默认"之类的动作留的口子） */
    public static void setPalette(int i, int argb) {
        if (i < 1 || i > 9) return;
        Context ctx = GmUtil.app();
        if (ctx == null) return;
        try {
            GmStore.write(ctx, K_C + i, String.valueOf(argb), "i");  // ★ 类型 "i"
        } catch (Throwable t) {
            GmUtil.logFail("richText.setPalette", t);
        }
    }

    // ═══════════════════════════ ② 标记扫描 ═══════════════════════════

    /** 快速判据（热路径第一道闸，避免每条消息都做完整扫描） */
    public static boolean hasMark(String s) {
        return s != null && s.indexOf(OPEN) >= 0;
    }

    /** 一段标记（原文里的区间 + 解析出来的模板名与参数） */
    public static final class Seg {
        public int start;         // 含 OPEN
        public int end;           // 不含（已越过 CLOSE）
        public String name;       // 模板名（匿名包裹时为空）
        public String[] args;     // 参数（可能为空数组）
        /** ★ 匿名包裹 {@code ⟦FDM⟧…⟦/FDM⟧} —— 内容原样当 HTML 渲染，不套模板 */
        public boolean anonymous;

        /** ★ 建议按钮段 {@code <Suggestion>显示|回复</Suggestion>}（2026-10-05 加） */
        public boolean suggest;
        /** 建议按钮上显示的文字 */
        public String sugLabel;
        /** 点击后要"回复"给 AI 的文字（缺省 = 显示文字） */
        public String sugPayload;

        public String raw(String text) {
            return text.substring(start, end);
        }
    }

    /**
     * 扫出文本里所有标记段 —— <b>两种形态都认</b>：
     * <pre>
     *   ⟦FDM:名字|参数⟧…⟧        模板模式（name 有值）
     *   ⟦FDM⟧ &lt;b&gt;x&lt;/b&gt; ⟦/FDM⟧      匿名包裹（anonymous=true，内容原样当 HTML）
     * </pre>
     *
     * <p>容错：**没闭合的（流式中途被截断）直接忽略** —— 宁可这一帧不渲染，
     * 也绝不能把半截标记吃进结果里（那会让人看到 {@code ⟦FDM:car}）。
     */
    public static List<Seg> scan(String s) {
        List<Seg> out = new ArrayList<Seg>();
        if (s == null || s.isEmpty()) return out;
        int from = 0;
        int n = s.length();
        while (from < n) {
            int a1 = s.indexOf(OPEN, from);           // ⟦FDM:
            int a2 = s.indexOf(ANON_OPEN, from);      // ⟦FDM⟧
            int a3 = s.indexOf(SUG_OPEN, from);       // <Suggestion>
            int a4 = s.indexOf(SUG2_OPEN, from);      // ⟦SUG⟧（保险写法）
            if (a1 < 0 && a2 < 0 && a3 < 0 && a4 < 0) break;

            // ★ 四选一：谁最靠前就先处理谁（2026-10-05 加 <Suggestion> 与 ⟦SUG⟧）
            int a = -1;
            int kind = 0;                             // 0=模板 1=匿名 2=建议 3=建议(⟦SUG⟧)
            if (a1 >= 0) { a = a1; kind = 0; }
            if (a2 >= 0 && (a < 0 || a2 < a)) { a = a2; kind = 1; }
            if (a3 >= 0 && (a < 0 || a3 < a)) { a = a3; kind = 2; }
            if (a4 >= 0 && (a < 0 || a4 < a)) { a = a4; kind = 3; }

            if (kind == 2 || kind == 3) {
                // ★ 建议按钮：不闭合（流式中途被截断）就原地不动，宁可这一帧不渲染
                String op = (kind == 2) ? SUG_OPEN : SUG2_OPEN;
                String cl = (kind == 2) ? SUG_CLOSE : SUG2_CLOSE;
                int b = s.indexOf(cl, a + op.length());
                if (b < 0) break;
                String body = s.substring(a + op.length(), b);
                Seg sg = new Seg();
                sg.start = a;
                sg.end = b + cl.length();
                sg.suggest = true;
                sg.name = "";
                sg.args = EMPTY_ARGS;
                int bar = body.indexOf('|');
                if (bar < 0) {
                    sg.sugLabel = body.trim();
                } else {
                    sg.sugLabel = body.substring(0, bar).trim();
                    sg.sugPayload = body.substring(bar + 1).trim();
                }
                if (sg.sugLabel.isEmpty()) sg.sugLabel = "\u25B8 \u8FFD\u95EE";
                if (sg.sugPayload == null || sg.sugPayload.isEmpty()) sg.sugPayload = sg.sugLabel;
                out.add(sg);
                from = sg.end;
                continue;
            }

            boolean anon = (kind == 1);
            if (anon) {
                int b = s.indexOf(ANON_CLOSE, a + ANON_OPEN.length());
                if (b < 0) break;                     // 没闭合 ⇒ 放弃剩下的
                Seg seg = new Seg();
                seg.start = a;
                seg.end = b + ANON_CLOSE.length();
                seg.anonymous = true;
                seg.name = "";
                seg.args = EMPTY_ARGS;
                out.add(seg);
                from = seg.end;
                continue;
            }

            int b = s.indexOf(CLOSE, a + OPEN.length());
            if (b < 0) break;                         // 没闭合 ⇒ 放弃剩下的
            String body = s.substring(a + OPEN.length(), b);
            Seg seg = new Seg();
            seg.start = a;
            seg.end = b + CLOSE.length();

            int bar = body.indexOf('|');
            if (bar < 0) {
                seg.name = body.trim();
                seg.args = EMPTY_ARGS;
            } else {
                seg.name = body.substring(0, bar).trim();
                String[] parts = body.substring(bar + 1).split("\\|", -1);
                for (int i = 0; i < parts.length; i++) parts[i] = parts[i].trim();
                seg.args = parts;
            }

            from = seg.end;
            if (!nameOk(seg.name)) continue;           // 名字不合法 ⇒ 当它不存在（原样留着）
            out.add(seg);
        }
        return out;
    }

    /**
     * 快速判据：文本里像不像有<b>裸 HTML 标签</b>（裸标签模式的第二道闸）。
     *
     * <p>故意宽松（只看 {@code <} 后面第一个字母）—— 误判的代价只是"多做一次全解析"，
     * 真正的把关在 {@link #normTag} 的白名单里。宁可多做，不可漏掉。
     */
    /**
     * 快速判据：文本里有没有建议标记 {@code <Suggestion>}。
     *
     * <p>热路径上就一个 {@code indexOf} —— 与 {@link #hasBareTag} 并列使用，
     * 让 {@code GmRichTextHook} 的第一道闸能"便宜地"决定要不要走重活。
     */
    public static boolean hasSuggest(String s) {
        return s != null && (s.indexOf(SUG_OPEN) >= 0 || s.indexOf(SUG2_OPEN) >= 0);
    }

    public static boolean hasBareTag(String s) {
        if (s == null || s.length() < 3) return false;
        int i = -1;
        while ((i = s.indexOf('<', i + 1)) >= 0) {
            if (i + 1 >= s.length()) return false;
            char c = s.charAt(i + 1);
            if (c == 'b' || c == 'B' || c == 'i' || c == 'I' || c == 'u' || c == 'U'
                    || c == 's' || c == 'S' || c == 'c' || c == 'C'
                    || c == 'd' || c == 'D' || c == 'e' || c == 'E' || c == '/') {
                return true;
            }
        }
        return false;
    }

    // ═══════════════════════════ ③ 模板填充 ═══════════════════════════

    /**
     * 把 {@code {1}} {@code {2}} … 换成参数（<b>1 基</b>，标了 {0} 或越界 ⇒ 空串）。
     * 认不出来的一律原样留着（不让模板手滑就丢内容）。
     */
    public static String fill(String tpl, String[] args) {
        if (tpl == null || tpl.isEmpty()) return "";
        if (args == null) args = EMPTY_ARGS;
        StringBuilder sb = new StringBuilder(tpl.length() + 32);
        int n = tpl.length();
        for (int i = 0; i < n; i++) {
            char c = tpl.charAt(i);
            if (c != '{') {
                sb.append(c);
                continue;
            }
            int e = tpl.indexOf('}', i + 1);
            if (e < 0) {
                sb.append(c);
                continue;
            }
            String idx = tpl.substring(i + 1, e).trim();
            int k = -1;
            try {
                k = Integer.parseInt(idx);
            } catch (Throwable ignore) {
                // 不是数字 ⇒ 原样留着
            }
            if (k <= 0) {
                sb.append('{').append(idx).append('}');
                i = e;
                continue;
            }
            if (k <= args.length) {
                String v = args[k - 1];
                if (v != null) sb.append(v);
            }
            i = e;
        }
        return sb.toString();
    }

    // ═══════════════════════════ ④ HTML 子集 → 事件流 ═══════════════════════════

    /** 事件流里的一条：TEXT 用 {@link #text}，PUSH 用 {@link #tag}，POP 两个都不用 */
    public static final class Ev {
        public final int kind;
        public final String text;
        public final String tag;

        Ev(int k, String t, String g) {
            kind = k;
            text = t;
            tag = g;
        }
    }

    /**
     * 归一化标签名。认识的留下（统一成 b/i/u/s/br/c?/bg?），不认识的返回 {@code null}。
     *
     * <p>为什么把 {@code <strong>}{@code <em>}{@code <del>}{@code <strike>} 收进来：
     * 模型写 HTML 的习惯很杂，收编比报错用户体验好。
     *
     * <p><b>白名单就是安全边界</b> —— 这里放行的，{@code GmRichTextHook} 才会去动样式；
     * 代码块里的 {@code <div>}、数学里的 {@code a < b}、别的任何 {@code <xxx>} 都返回 null
     * ⇒ 原样留在界面上，绝不误伤。
     */
    public static String normTag(String t) {
        if (t == null) return null;
        String s = t.trim().toLowerCase();
        if (s.isEmpty()) return null;
        // 容忍 <c=#ff0000> 这种多打一个等号的写法
        if (s.indexOf('=') >= 0) s = s.replace("=", "");
        if (s.indexOf(' ') >= 0) s = s.substring(0, s.indexOf(' '));   // 容忍 <b style=...> 的尾巴

        if ("b".equals(s) || "strong".equals(s)) return "b";
        if ("i".equals(s) || "em".equals(s)) return "i";
        if ("u".equals(s)) return "u";
        if ("s".equals(s) || "del".equals(s) || "strike".equals(s)) return "s";
        if ("br".equals(s)) return "br";

        if (s.length() > 1 && s.charAt(0) == 'c') {
            String v = s.substring(1);
            char v0 = v.charAt(0);
            if (v0 == '#' || (v.length() == 1 && v0 >= '1' && v0 <= '9')) return "c" + v;
        }
        if (s.length() > 2 && s.startsWith("bg")) {
            String v = s.substring(2);
            char v0 = v.charAt(0);
            if (v0 == '#' || (v.length() == 1 && v0 >= '1' && v0 <= '9')) return "bg" + v;
        }
        return null;
    }

    /**
     * 把模板正文解析成事件流。
     *
     * <p><b>容错三条</b>（都是为了让"AI 写歪了"和"流式中途"都不出洋相）：
     * <ol>
     *   <li>不认识的标签：整段吞掉，<b>不显示尖括号</b>；</li>
     *   <li>闭合标签找不到对应开标签：当没看见；</li>
     *   <li>走到结尾还有没闭合的：<b>自动补齐 POP</b>（否则 Hook 那边的 push 栈会漏账）。</li>
     * </ol>
     */
    public static List<Ev> parseHtml(String html) {
        List<Ev> out = new ArrayList<Ev>();
        if (html == null || html.isEmpty()) return out;

        List<String> stack = new ArrayList<String>();      // 用 List 当栈（短，够用）
        StringBuilder buf = new StringBuilder();
        int i = 0;
        int n = html.length();

        while (i < n) {
            char ch = html.charAt(i);
            if (ch != '<') {
                buf.append(ch);
                i++;
                continue;
            }
            int e = html.indexOf('>', i);
            if (e < 0) {
                // 没闭合的尖括号 ⇒ 剩下全当文本
                buf.append(html, i, n);
                break;
            }
            String raw = html.substring(i + 1, e);
            i = e + 1;

            // 冲掉缓冲文本
            if (buf.length() > 0) {
                out.add(new Ev(EV_TEXT, buf.toString(), null));
                buf.setLength(0);
            }
            if (raw.isEmpty()) continue;

            if (raw.charAt(0) == '/') {
                String nm = raw.substring(1).trim();
                if (nm.isEmpty()) {
                    // </> ⇒ 关最近一个
                    if (!stack.isEmpty()) {
                        stack.remove(stack.size() - 1);
                        out.add(new Ev(EV_POP, null, null));
                    }
                } else {
                    String t = normTag(nm);
                    if (t == null) {
                        // ★ 2026-10-03 修的真 BUG：**前缀式关闭**
                        //   `<c1>红</c>` ← 结束标签只写了 `c`，而 normTag 要求后面跟 #/数字
                        //   ⇒ 返回 null ⇒ 原来这里直接 continue ⇒ **<c1> 一直开着没关**
                        //   ⇒ 后面整段都被染上颜色（真机症状：「模板里第二个参数也发紫」）。
                        //   同理 `</bg>`。修法是把它归一到前缀，再按前缀去栈里找配对。
                        if ("c".equals(nm)) t = "c";
                        else if ("bg".equals(nm)) t = "bg";
                    }
                    if (t == null) continue;
                    int at = -1;
                    for (int k = stack.size() - 1; k >= 0; k--) {
                        String h = stack.get(k);
                        if (h.equals(t)) { at = k; break; }
                        if ("c".equals(t) && h.charAt(0) == 'c') { at = k; break; }
                        if ("bg".equals(t) && h.startsWith("bg")) { at = k; break; }
                    }
                    if (at < 0) continue;                        // 找不到配对 ⇒ 当没看见
                    while (stack.size() > at) {                  // 顺便把中间没关的补上
                        stack.remove(stack.size() - 1);
                        out.add(new Ev(EV_POP, null, null));
                    }
                }
            } else {
                String t = normTag(raw);
                if (t == null) continue;                        // 不认识的标签 ⇒ 丢掉
                if ("br".equals(t)) {
                    out.add(new Ev(EV_TEXT, "\n", null));
                    continue;
                }
                stack.add(t);
                out.add(new Ev(EV_PUSH, null, t));
            }
        }

        if (buf.length() > 0) out.add(new Ev(EV_TEXT, buf.toString(), null));
        while (!stack.isEmpty()) {                              // 自动补齐
            stack.remove(stack.size() - 1);
            out.add(new Ev(EV_POP, null, null));
        }
        return out;
    }

    // ═══════════════════════════ ⑤ 给 AI 的格式约定 ═══════════════════════════

    /**
     * 拼一段「格式说明」，让主人一键灌进系统提示词 ——
     * 模型得先知道有这个标记，才会吐出来（见 {@code 专题/系统提示词-不留痕投递.md}）。
     */
    /** 新版格式约定的特征串 —— 用来判断"灌过没有"（定界符不行，旧版也有） */
    public static final String SPEC_TAG = "【回答排版】";

    public static String spec() {
        List<String> ns = names();
        StringBuilder sb = new StringBuilder();
        sb.append("【回答排版】以下是可用的富文本标签，写上就会被渲染成真正的样式，"
                + "请适当使用来让回答更清楚：\n");
        sb.append("  <b>粗体</b>  <i>斜体</i>  <u>下划线</u>  <s>删除线</s>\n");
        sb.append("  <c1>文字</c1> … <c9>文字</c9>：九种颜色（结束标签写 </c> 也行）\n");
        sb.append("  <c#FF0000>红色</c>：直接指定颜色，用六位十六进制\n");
        sb.append("  <bg1>文字</bg1> … <bg9>文字</bg9>：九种背景高亮；<bg#FFFF00>高亮</bg> 同理\n");
        sb.append("  <br>：换行\n");
        sb.append("★ 直接写就行，不要再用别的符号把标签包起来。"
                + "在代码块里不要使用这些标签。\n");
        if (ns.isEmpty()) {
            sb.append("（当前还没有配置任何排版模板。）\n");
        } else {
            sb.append("另外还有几个现成的排版模板，用 ⟦FDM:名字|参数1|参数2⟧ 调用：\n");
            for (String n : ns) {
                sb.append("  ").append(n).append(" → ").append(oneLine(tpl(n))).append('\n');
            }
        }
        return sb.toString();
    }

    private static String oneLine(String s) {
        if (s == null) return "";
        String t = s.replace('\n', ' ').replace('\r', ' ').trim();
        return t.length() > 60 ? t.substring(0, 60) + "…" : t;
    }

    /**
     * 把格式约定灌进「系统提示词」—— <b>幂等</b>：里面已经有 {@code ⟦FDM:} 就不再重复加。
     *
     * <p>为什么必须做这一步：模型不会凭空知道你自定义了一套标记。
     * 不把约定告诉它，它永远只会输出普通 markdown ⇒ 这功能看上去"没效果"。
     * （投递通道复用 3.45.0 那套，见 {@code 专题/系统提示词-不留痕投递.md}。）
     */
    public static String mergeIntoSystemPrompt() {
        return mergeSpec(spec(), SPEC_TAG);
    }

    /**
     * 「追问建议」约定的特征串 —— 用来判断"灌过没有"。
     *
     * <p>与 {@link #SPEC_TAG} 分开：两段约定是<b>独立</b>的，各灌各的、互不干扰
     * （模型可能只要排版、也可能只要追问建议）。
     */
    public static final String SUG_SPEC_TAG = "【追问建议】";

    /**
     * 「追问建议」的格式约定 —— 灌给模型的文案。
     *
     * <p>为什么不告诉它就不行：模型不会凭空知道我们支持 {@code <Suggestion>} 这个标记，
     * 不写进提示词，它就永远只吐普通 markdown ⇒ 功能看着"没效果"。
     */
    public static String suggestSpec() {
        return "【追问建议】当你想让用户继续追问、或想引导对话方向时，"
                + "在回复的最后另起一行输出：\n"
                + "  <Suggestion>▸ 你的建议问题</Suggestion>\n"
                + "可以写多行，每行一条建议，界面会渲染成可点击的按钮。\n"
                + "★ 想「显示短一点、实际发的内容长一点」时，用竖线分开：\n"
                + "  <Suggestion>▸ 说说看|请从原理上详细解释一下</Suggestion>\n"
                + "★ 直接写就行，不要在代码块里写，也不要再用别的符号把它包起来。\n";
    }

    /** 把「追问建议」约定灌进系统提示词（幂等）。 */
    public static String mergeSuggestIntoSystemPrompt() {
        return mergeSpec(suggestSpec(), SUG_SPEC_TAG);
    }

    /**
     * 把我们灌进去的约定段落**摘掉**（用户自己写的原样保留）—— 给"清空灌入"用。
     *
     * <p>做法是**按段落摘**而不是按文本匹配：{@code spec()} 的内容会随模板池变，
     * 直接 replace 会匹配不上。所以从特征串定位，向前往回找到段落头（{@code \n\n} 之后），
     * 向后找到段落尾（下一个 {@code \n\n} 之前），整段剪掉。
     */
    public static String removeSpecs() {
        try {
            String cur = GmSysPrompt.text();
            if (cur == null || cur.isEmpty()) return "系统提示词本来就是空的，没什么可清";

            int before = cur.length();
            String out = cutParagraph(cur, SPEC_TAG);
            out = cutParagraph(out, SUG_SPEC_TAG);
            out = tidy(out);

            if (out.length() == before) {
                return "没找到我们灌进去的约定（可能本来就没灌，或被手动删过）";
            }
            GmSysPrompt.setText(out);
            return "已清空灌入的约定（" + before + " 字 → " + out.length() + " 字）"
                    + "；你自己写的内容原样保留";
        } catch (Throwable t) {
            return "清空失败：" + t;
        }
    }

    /** 从 {@code tag} 所在段落整段剪掉（段落 = 前后各一个 {@code \n\n} 的区间）。 */
    private static String cutParagraph(String s, String tag) {
        if (s == null) return "";
        int i = s.indexOf(tag);
        if (i < 0) return s;

        int start = 0;
        int p = s.lastIndexOf("\n\n", i);
        if (p >= 0) start = p + 2;

        int q = s.indexOf("\n\n", i);
        int end = (q < 0) ? s.length() : q;

        return s.substring(0, start) + s.substring(end);
    }

    /** 收拾一下：去掉首尾空白 + 连续三个以上换行压成两个。 */
    private static String tidy(String s) {
        if (s == null) return "";
        String out = s.trim();
        while (out.contains("\n\n\n")) {
            out = out.replace("\n\n\n", "\n\n");
        }
        return out;
    }

    /**
     * 通用的「把一段约定追加进系统提示词」—— <b>追加，绝不覆盖</b>。
     *
     * <p>幂等判据用<b>内容特征串</b>而不是定界符：定界符在旧版约定里也可能出现，
     * 换了新版就点不动了（白折腾一轮）。
     */
    private static String mergeSpec(String add, String tag) {
        try {
            String cur = GmSysPrompt.text();
            if (cur != null && cur.indexOf(tag) >= 0) {
                return "系统提示词里已经有这段约定了，没重复加";
            }
            String nv = (cur == null || cur.isEmpty()) ? add : (cur + "\n\n" + add);
            GmSysPrompt.setText(nv);
            return "已写进系统提示词（原文 " + (cur == null ? 0 : cur.length())
                    + " 字 → 现在 " + nv.length() + " 字，追加 " + add.length() + " 字）";
        } catch (Throwable t) {
            return "写提示词失败：" + t;
        }
    }
}
