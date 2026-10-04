package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmRichText;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.List;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

/**
 * GmRichTextHook —— 「AI 气泡富文本」的落点 🐲 2026-10-03 · 尼得亚伯
 *
 * <h3>★ 挂在哪 / 为什么挂那</h3>
 * 宿主（2.6.1）的 markdown 渲染链（逐层实证，见 {@code 专题/AI气泡富文本-锚点勘察.md}）：
 * <pre>
 *   AI 文本 → svb.c（AssistantTextItem）
 *           → eu6.c（Markdown 入口）
 *           → v91.m(String)
 *               ├─ new in            （AnnotatedString.Builder）
 *               ├─ or6.w(builder, md)（buildMarkdownAnnotatedString）
 *               ├─ in.k()            → kn（成品 AnnotatedString）
 *               └─ fz2.p(kn, …)      ★★★ 我们挂这里
 *                   └─ w2b           （MarkdownBasicText）→ 绘制
 * </pre>
 * <b>选 {@code fz2.p} 的理由</b>：它是「成品 AnnotatedString」的<b>唯一汇流点</b>
 * —— thinking / 引用预览 / 分享预览各走各的入口，最后都得从这儿过。
 * 挂它一个 ≈ 全覆盖，而且拿到的是**已经带好 markdown 样式**的串。
 *
 * <h3>★ 怎么换掉它</h3>
 * 不自己拼样式，而是用宿主<b>自己的</b> {@code AnnotatedString.Builder}：
 * <pre>
 *   nb = new Builder()
 *   原文段   → nb.append(origKn, start, end)   ← ★ 样式自动跟着走（位置映射问题直接消失）
 *   标记段   → nb.pushStyle(style) + nb.append(text) + nb.pop()
 *   args[0] = nb.toAnnotatedString()
 * </pre>
 *
 * <h3>⚠️ 混淆名纪律</h3>
 * {@code kn/in/f0a/ko4/io4/dia/fz2} 全是 R8 改的名字，宿主升级必变。
 * 所以这里做两件事：<b>候选名 → 结构自检 → 才挂</b>；
 * 自检不过就<b>整条不启用并回报日志</b>（宁可不干活，也不要挂到错的类上咬宿主）。
 * 自检项：{@code kn} 必须 implements CharSequence 且有 {@code b:String} 字段、
 * {@code f0a} 必须有 15 参构造器且字段数 ≥14、{@code fz2.p} 必须 7 参且首参是 {@code kn}……
 *
 * <h3>⚠️ 热路径纪律</h3>
 * {@code fz2.p} 是 <b>@Composable</b>，会随每一帧重组重入 ⇒
 * ① 第一道闸 {@code text.indexOf("⟦FDM:") < 0} 直接 return（99.9% 的调用在这一行结束）；
 * ② 样式实例全缓存（颜色/背景按 Long 缓存，粗斜删下划线单例）；
 * ③ 整个 before 包 {@code try/catch(Throwable)}，异常只记日志、<b>绝不放行到宿主</b>。
 */
public final class GmRichTextHook extends XC_MethodHook {

    // ─────────────────────── 候选混淆名（升级后重新反查，别猜）───────────────────────

    /** AnnotatedString —— implements CharSequence，字段 b=text */
    private static final String[] CAND_KN = {"kn"};
    /** AnnotatedString.Builder —— 字段 a=StringBuilder、b=ArrayList；k()=toAnnotatedString */
    private static final String[] CAND_IN = {"in"};
    /** SpanStyle —— toString "SpanStyle(color="，15 参构造器 */
    private static final String[] CAND_SPAN = {"f0a"};
    /** FontWeight —— 字段 a:I */
    private static final String[] CAND_WEIGHT = {"ko4"};
    /** FontStyle —— 字段 a:I（0=Normal 1=Italic） */
    private static final String[] CAND_STYLE = {"io4"};
    /** TextDecoration —— 字段 a:I（0=None 1=Underline 2=LineThrough） */
    private static final String[] CAND_DECO = {"dia"};
    /** MarkdownTextKt（R8 合并类）—— 里面那个 `p(AnnotatedString,Modifier,Colors,Config,Composer,II)` */
    private static final String[] CAND_MT = {"fz2"};

    // ─────────────────────── 宿主类句柄 ───────────────────────

    private static Class<?> cKn;
    private static Class<?> cIn;
    private static Class<?> cSpan;
    private static Class<?> cWeight;
    private static Class<?> cStyle;
    private static Class<?> cDeco;

    private static Field fText;                    // kn.b : String

    private static Constructor<?> ctInNew;         // in()
    private static Method mAppendKn;               // in.c(kn, int, int)  ← ★ append(AnnotatedString,start,end)
    private static Method mAppendStr;              // in.e(String)
    private static Method mPush;                   // in.j(SpanStyle) : int
    private static Method mPop;                    // in.f()
    private static Method mToKn;                   // in.k() : kn

    private static Constructor<?> ctSpan;          // f0a(…15 参数…, int mask)
    private static Constructor<?> ctWeight;        // ko4(int)
    private static Constructor<?> ctStyle;         // io4(int)
    private static Constructor<?> ctDeco;          // dia(int)

    // ─────────────────────── 状态 ───────────────────────

    private static volatile boolean sTried = false;
    private static volatile boolean sReady = false;
    private static volatile String sWhy = "未初始化";
    private static volatile int sHits = 0;
    private static volatile int sRenders = 0;

    /** 样式实例缓存 —— 热路径上绝不重复造对象 */
    private static final Object LOCK = new Object();
    private static Object sBold, sItalic, sUline, sStrike;
    private static final HashMap<Long, Object> sColorCache = new HashMap<Long, Object>();
    private static final HashMap<Long, Object> sBgCache = new HashMap<Long, Object>();

    public static int hits() {
        return sHits;
    }

    /** 给设置页/日志看的自检结论 */
    public static String status() {
        return (sReady ? "已就绪" : "未就绪") + " · " + sWhy
                + "（渲染 " + sRenders + " 次 / 替换 " + sHits + " 次）"
                + " · 链接：" + GmRichLink.status();
    }

    // ═══════════════════════════ ① hook 主体 ═══════════════════════════

    @Override
    protected void beforeHookedMethod(MethodHookParam p) {
        try {
            if (!sReady) return;
            if (p.args == null || p.args.length < 1) return;

            Object orig = p.args[0];
            if (orig == null || !cKn.isInstance(orig)) return;

            String text = (String) fText.get(orig);
            if (text == null || text.isEmpty()) return;

            // ★ 第一道闸：绝大多数调用（以及同一帧的反复重入）在这一行就结束
            if (!mayRender(text)) return;
            sRenders++;

            Object nb = rebuild(orig, text);
            if (nb != null) {
                p.args[0] = nb;
                sHits++;
                GmUtil.logOnce("richHook.hit",
                        "富文本已渲染：原文 " + text.length() + " 字符 → 替换后 "
                                + ((String) fText.get(nb)).length() + " 字符");
            }
        } catch (Throwable t) {
            // ★ 热路径：异常绝不放行（放行 = 带崩宿主渲染）
            try {
                GmUtil.logFail("richHook", t);
            } catch (Throwable ignore) {
                // 连日志都失败 ⇒ 只能算了
            }
        }
    }

    // ─────────────────────── 热路径判据 ───────────────────────

    private static volatile boolean sBare = true;
    private static volatile long sBareAt = 0L;

    /**
     * 第一道闸 —— 这条文本有没有可能被渲染？
     *
     * <p>三种可能：模板标记 {@code ⟦FDM:}、匿名包裹 {@code ⟦FDM⟧}、裸标签 {@code <b>}…
     * 全是 {@code indexOf} / 一次短扫描，慢路径（读配置、建对象）一个都不碰。
     */
    private static boolean mayRender(String s) {
        if (s == null || s.isEmpty()) return false;
        if (s.indexOf(GmRichText.OPEN) >= 0) return true;        // ⟦FDM:name|args⟧
        if (s.indexOf(GmRichText.ANON_OPEN) >= 0) return true;   // ⟦FDM⟧…⟦/FDM⟧
        if (GmRichText.hasSuggest(s)) return true;               // ★ <Suggestion>…</Suggestion>
        return bareCached() && GmRichText.hasBareTag(s);
    }

    /**
     * 裸标签开关的缓存 —— <b>500ms 才回读一次存储</b>。
     *
     * <p>为什么必须缓存：{@code fz2.p} 是每帧都过的 @Composable，
     * 在里面直接 {@code GmStore.read2} 等于每帧都去翻 MMKV —— 那是会卡到掉帧的。
     * 代价是"改了开关最多半秒生效"，完全可接受。
     */
    private static boolean bareCached() {
        long now = System.currentTimeMillis();
        if (now - sBareAt > 500L || sBareAt == 0L) {
            sBare = GmRichText.bareOn();
            sBareAt = now;
        }
        return sBare;
    }

    // ═══════════════════════════ ② 重建 AnnotatedString ═══════════════════════════

    private static Object rebuild(Object orig, String text) throws Exception {
        boolean bare = bareCached();
        List<GmRichText.Seg> segs = GmRichText.scan(text);
        boolean hasPlainTag = bare && GmRichText.hasBareTag(text);
        if (segs.isEmpty() && !hasPlainTag) return null;

        if (!GmRichText.on()) {
            GmUtil.logOnce("richHook.off", "富文本开关是关的（fuckds_rich_on）—— 只报一次");
            return null;
        }

        // 一次解析模板池（同一条消息里可能有多个标记，别每个都去读一次存储）
        java.util.LinkedHashMap<String, String> pool = GmRichText.tplMap();

        Object nb = ctInNew.newInstance();
        boolean changed = false;
        int cur = 0;
        for (GmRichText.Seg s : segs) {
            if (s.start > cur) {
                if (emitPlain(nb, orig, text, cur, s.start, bare)) changed = true;
            }
            if (s.suggest) {
                // ★ 建议按钮：渲染成"可点击"，点一下 = 把 payload 当消息回复给 AI
                emitSuggest(nb, s);
                changed = true;
            } else if (s.anonymous) {
                emitAnon(nb, s, text);
                changed = true;
            } else {
                emit(nb, s, pool);
                changed = true;
            }
            cur = s.end;
        }
        if (cur < text.length()) {
            if (emitPlain(nb, orig, text, cur, text.length(), bare)) changed = true;
        }

        // ★ 一个字都没动（例如整条只是 "a < b" 这种误命中）⇒ 返回 null，
        //   别白白造一个新 AnnotatedString 去顶替原来的
        if (!changed) return null;
        return mToKn.invoke(nb);
    }

    /**
     * 普通文字段（不含 {@code ⟦FDM:…⟧} 的那部分）。
     *
     * <p><b>裸标签模式关</b>：整段原样搬过去（{@code in.c(orig,a,b)}）—— 一个字节都不动。
     * <b>开</b>：在段内扫白名单标签，把段切成「纯文本子段 + 开/关标签」——
     * <b>纯文本子段仍然走 {@code in.c}</b>，所以宿主 markdown 自己的粗体/链接样式全都保住，
     * 我们只是额外插进 `<b>`/`<c1>` 这些标签的 push/pop。
     *
     * @return 这一段里<b>有没有真的动过样式</b>（决定要不要换掉整个 AnnotatedString）
     */
    private static boolean emitPlain(Object nb, Object orig, String text,
                                    int from, int to, boolean bare) throws Exception {
        if (from >= to) return false;
        if (!bare) {
            mAppendKn.invoke(nb, orig, Integer.valueOf(from), Integer.valueOf(to));
            return false;
        }

        boolean changed = false;
        List<String> stack = new java.util.ArrayList<String>();
        int i = from;
        int plain = from;
        while (i < to) {
            if (text.charAt(i) != '<') {
                i++;
                continue;
            }
            int e = text.indexOf('>', i);
            // 标签不能太长（>16）—— 挡掉 "a < b and c > d" 这类误命中
            if (e < 0 || e >= to || (e - i) > 16) {
                i++;
                continue;
            }
            String raw = text.substring(i + 1, e).trim();
            if (raw.isEmpty()) {
                i++;
                continue;
            }
            boolean closing = raw.charAt(0) == '/';
            String nm = closing ? raw.substring(1).trim() : raw;
            String t = GmRichText.normTag(nm);
            if (t == null && closing) {
                // <c1>…</c> / <bg1>…</bg> —— 关闭时只写了前缀，normTag 认不出来，这里补一手
                if ("c".equals(nm)) t = "c";
                else if ("bg".equals(nm)) t = "bg";
            }
            if (t == null) {         // 白名单外 ⇒ 当普通文本，继续往后扫
                i++;
                continue;
            }

            appendText(nb, orig, text, plain, i, !stack.isEmpty());

            if (closing) {
                int at = matchTop(stack, t);
                if (at >= 0) {
                    while (stack.size() > at) {
                        stack.remove(stack.size() - 1);
                        mPop.invoke(nb);
                    }
                    changed = true;
                }
            } else if ("br".equals(t)) {
                mAppendStr.invoke(nb, "\n");
                changed = true;
            } else {
                Object st = styleFor(t);
                if (st != null) {
                    mPush.invoke(nb, st);
                    stack.add(t);
                    changed = true;
                }
            }
            i = e + 1;
            plain = i;
        }
        appendText(nb, orig, text, plain, to, !stack.isEmpty());
        while (!stack.isEmpty()) {      // 兑账：开多少关多少
            stack.remove(stack.size() - 1);
            mPop.invoke(nb);
        }
        return changed;
    }

    /**
     * 追加一段**原文**到 Builder。
     *
     * <p>★ 这里是"文字颜色不显示"的真凶所在：
     * <ul>
     *   <li>{@code in.c(orig, from, to)}（= {@code append(AnnotatedString,start,end)}）
     *       会<b>把 orig 里覆盖该区间的 span 一起搬进来</b>（见 {@code pn.a} 的裁剪逻辑）；</li>
     *   <li>而我们把宿主的 span 搬进来的时机，是在 <b>pushStyle 之后</b>
     *       ⇒ 它排在<b>我们后面</b>；</li>
     *   <li>Compose 合并重叠 span 的规则是<b>后加的赢</b>
     *       ⇒ 宿主那条 {@code color=浅灰白}（正文色）<b>盖掉了我们的颜色</b>。</li>
     * </ul>
     * 而 {@code background} 为什么没事 —— 因为宿主<b>从不设</b> background
     * （255 个 SpanStyle 实例全是 {@code background=Color(0,0,0,0)}），没人跟我们抢。
     *
     * <p><b>修法</b>：当我们自己压着样式（{@code styled=true}）时，改用
     * {@code append(String)} 纯文本 —— 不带任何原串样式，我们的颜色就保得住。
     * 代价是那段文字会丢掉原文的 markdown 样式，但标记段本来就是我们接管的部分，
     * 要粗体可以自己写 {@code <b>}。
     */
    private static void appendText(Object nb, Object orig, String text,
                                  int from, int to, boolean styled) throws Exception {
        if (to <= from) return;
        if (styled) {
            mAppendStr.invoke(nb, text.substring(from, to));
        } else {
            mAppendKn.invoke(nb, orig, Integer.valueOf(from), Integer.valueOf(to));
        }
    }

    /** 找一个能配对的开标签（{@code </c>} 配任意 {@code c1/c#…}） */
    private static int matchTop(List<String> stack, String t) {
        for (int k = stack.size() - 1; k >= 0; k--) {
            String h = stack.get(k);
            if (h.equals(t)) return k;
            if ("c".equals(t) && h.charAt(0) == 'c') return k;
            if ("bg".equals(t) && h.startsWith("bg")) return k;
        }
        return -1;
    }

    /**
     * 匿名包裹 {@code ⟦FDM⟧…⟦/FDM⟧} —— 里面的东西<b>原样当 HTML 渲染</b>。
     *
     * <p>模型从系统提示词的定界符学样，会主动写这种形态（真机截图里就是），
     * 所以必须收编：不然整段连标签带括号一起露在界面上。
     */
    private static void emitAnon(Object nb, GmRichText.Seg s, String text) throws Exception {
        int a = s.start + GmRichText.ANON_OPEN.length();
        int b = s.end - GmRichText.ANON_CLOSE.length();
        if (b <= a) return;
        String content = text.substring(a, b);
        List<GmRichText.Ev> evs = GmRichText.parseHtml(content);
        int pushed = 0;
        for (GmRichText.Ev ev : evs) {
            if (ev.kind == GmRichText.EV_TEXT) {
                if (ev.text != null && !ev.text.isEmpty()) mAppendStr.invoke(nb, ev.text);
            } else if (ev.kind == GmRichText.EV_PUSH) {
                Object st = styleFor(ev.tag);
                if (st != null) {
                    mPush.invoke(nb, st);
                    pushed++;
                }
            } else {
                if (pushed > 0) {
                    mPop.invoke(nb);
                    pushed--;
                }
            }
        }
        while (pushed-- > 0) mPop.invoke(nb);
    }

    /**
     * 建议按钮（{@code <Suggestion>显示|回复</Suggestion>}）—— ★ 2026-10-05 加。
     *
     * <p>不套模板、不走 SpanStyle，而是用宿主的 {@code pushLink} 出一段
     * <b>真正可点击</b>的文字（机制与两道"活的下来"的证明见 {@link GmRichLink}）。
     *
     * <p>链接能力没就绪时降级：<b>只把标签剥掉</b>（显示文字照旧留着），
     * 绝不让 {@code <Suggestion>} 这一串露在界面上（那比不渲染更难看）。
     */
    private static void emitSuggest(Object nb, GmRichText.Seg s) throws Exception {
        if (GmRichLink.ready()) {
            GmRichLink.emitLink(nb, "fdm_sug", s.sugLabel, s.sugPayload);
            GmUtil.logOnce("richHook.sug." + s.sugPayload.hashCode(),
                    "建议已渲染成可点击：「" + s.sugLabel + "」→ 回复「" + s.sugPayload + "」");
        } else {
            mAppendStr.invoke(nb, s.sugLabel);
            GmUtil.logOnce("richHook.sug.nolink",
                    "建议链接能力未就绪（" + GmRichLink.why() + "）⇒ 只剥标签");
        }
    }

    /** 把一段标记渲染进 Builder */
    private static void emit(Object nb, GmRichText.Seg s,
                            java.util.LinkedHashMap<String, String> pool) throws Exception {
        String tpl = pool == null ? null : pool.get(s.name);
        if (tpl == null) tpl = "";
        if (tpl.isEmpty()) {
            // 没配这个模板 ⇒ 露个温和的占位，别让 ⟦FDM:xxx⟧ 挂在界面上
            mAppendStr.invoke(nb, "\u3014" + s.name + "\u3015");
            GmUtil.logOnce("richHook.noTpl." + s.name, "模板「" + s.name + "」没配过 —— 显示占位符");
            return;
        }

        String filled = GmRichText.fill(tpl, s.args);
        List<GmRichText.Ev> evs = GmRichText.parseHtml(filled);

        int pushed = 0;
        for (GmRichText.Ev ev : evs) {
            if (ev.kind == GmRichText.EV_TEXT) {
                if (ev.text != null && !ev.text.isEmpty()) mAppendStr.invoke(nb, ev.text);
            } else if (ev.kind == GmRichText.EV_PUSH) {
                Object st = styleFor(ev.tag);
                if (st != null) {
                    mPush.invoke(nb, st);
                    pushed++;
                }
                // 认不出的样式 ⇒ 不 push；后面 POP 那边会自己兑账
            } else {
                if (pushed > 0) {
                    mPop.invoke(nb);
                    pushed--;
                }
            }
        }
        while (pushed-- > 0) mPop.invoke(nb);      // 兑账：开多少关多少
    }

    // ═══════════════════════════ ③ 标签 → SpanStyle ═══════════════════════════

    private static Object styleFor(String tag) {
        try {
            if (tag == null || tag.isEmpty()) return null;
            if ("b".equals(tag)) return bold();
            if ("i".equals(tag)) return italic();
            if ("u".equals(tag)) return underline();
            if ("s".equals(tag)) return strike();
            if (tag.startsWith("bg")) return bgStyle(colorOf(tag.substring(2)));
            if (tag.charAt(0) == 'c') return colorStyle(colorOf(tag.substring(1)));
        } catch (Throwable t) {
            GmUtil.logOnce("richHook.style." + tag, "样式构造失败 tag=" + tag + " → " + t);
        }
        return null;
    }

    /**
     * 色号 → Compose Color 的 packed long。
     *
     * <p>{@code gx2.d(J)F}（= Color.red）实证：{@code value >>> 56 and 0xff}、
     * 低 6 位是 colorSpace id（sRGB = 0） ⇒ <b>packed = argb.toLong() shl 32</b>。
     */
    private static Long colorOf(String spec) {
        if (spec == null || spec.isEmpty()) return null;
        char c0 = spec.charAt(0);
        if (c0 >= '1' && c0 <= '9' && spec.length() == 1) {
            // 色板编号 1..9（UI 里是 ARGB int）
            int argb = GmRichText.palette(c0 - '0');
            return Long.valueOf((argb & 0xFFFFFFFFL) << 32);
        }
        String hex;
        if (c0 == '#') {
            hex = spec.substring(1).trim();
        } else {
            return null;
        }
        if (hex.length() == 3) {
            // #abc → #aabbcc
            hex = "" + hex.charAt(0) + hex.charAt(0)
                    + hex.charAt(1) + hex.charAt(1)
                    + hex.charAt(2) + hex.charAt(2);
        }
        if (hex.length() == 6) hex = "FF" + hex;
        if (hex.length() != 8) return null;
        try {
            long argb = Long.parseLong(hex, 16) & 0xFFFFFFFFL;
            return Long.valueOf(argb << 32);
        } catch (Throwable t) {
            return null;
        }
    }

    private static Object colorStyle(Long packed) {
        if (packed == null) return null;
        synchronized (LOCK) {
            Object v = sColorCache.get(packed);
            if (v != null) return v;
            v = spanOf(packed, null, null, null, null);
            if (v != null) {
                // ★ 自检：读回构造出来的 SpanStyle 里的 color ——
                //   用来区分「构造没把颜色设进去」和「设进去了但渲染时被覆盖」
                //   这两条完全不同的路（真机症状：bg 生效、c 不生效）。
                selfCheckColor(v, packed.longValue());
                sColorCache.put(packed, v);
            }
            return v;
        }
    }

    /**
     * 读回 {@code SpanStyle} 的 color 字段，和"我们想设的值"对比。
     *
     * <p>{@code SpanStyle.color} 在 smali 里是<b>装箱</b>的（字段 {@code a:Lfka;}），
     * 取回 packed long 的办法是找它那个 <b>无参返回 long</b> 的方法（即 {@code unbox-impl}）。
     */
    private static void selfCheckColor(Object span, long want) {
        try {
            if (cSpan == null) return;
            Field fa = cSpan.getDeclaredField("a");
            fa.setAccessible(true);
            long got = unboxColor(fa.get(span));
            GmUtil.logOnce("richHook.chk." + want,
                    "自检 color want=0x" + Long.toHexString(want) + " got=0x" + Long.toHexString(got)
                            + (want == got ? " ✓ 一致 ⇒ 问题在渲染层" : " ✗ 不一致 ⇒ 构造没进去"));
        } catch (Throwable t) {
            GmUtil.logOnce("richHook.chkfail", "自检失败：" + t);
        }
    }

    /** Color 装箱对象 → packed long；取不到返回 -1 */
    private static long unboxColor(Object boxed) {
        if (boxed == null) return -1L;
        try {
            Method[] ms = boxed.getClass().getMethods();
            for (int i = 0; i < ms.length; i++) {
                Method m = ms[i];
                if (m.getParameterCount() == 0 && m.getReturnType() == long.class) {
                    Object r = m.invoke(boxed);
                    if (r instanceof Long) return ((Long) r).longValue();
                }
            }
        } catch (Throwable ignore) {
            // 取不到就算了
        }
        return -1L;
    }

    private static Object bgStyle(Long packed) {
        if (packed == null) return null;
        synchronized (LOCK) {
            Object v = sBgCache.get(packed);
            if (v != null) return v;
            v = spanOf(null, packed, null, null, null);
            if (v != null) sBgCache.put(packed, v);
            return v;
        }
    }

    private static Object bold() {
        synchronized (LOCK) {
            if (sBold == null) sBold = spanOf(null, null, newWeight(700), null, null);
            return sBold;
        }
    }

    private static Object italic() {
        synchronized (LOCK) {
            if (sItalic == null) sItalic = spanOf(null, null, null, newStyle(1), null);
            return sItalic;
        }
    }

    private static Object underline() {
        synchronized (LOCK) {
            if (sUline == null) sUline = spanOf(null, null, null, null, newDeco(1));
            return sUline;
        }
    }

    private static Object strike() {
        synchronized (LOCK) {
            if (sStrike == null) sStrike = spanOf(null, null, null, null, newDeco(2));
            return sStrike;
        }
    }

    private static Object newWeight(int w) {
        try {
            return ctWeight.newInstance(Integer.valueOf(w));
        } catch (Throwable t) {
            return null;
        }
    }

    private static Object newStyle(int s) {
        try {
            return ctStyle.newInstance(Integer.valueOf(s));
        } catch (Throwable t) {
            return null;
        }
    }

    private static Object newDeco(int d) {
        try {
            return ctDeco.newInstance(Integer.valueOf(d));
        } catch (Throwable t) {
            return null;
        }
    }

    /**
     * 造一个 SpanStyle —— <b>只设我们关心的那几个字段，其余全让 mask 落默认</b>。
     *
     * <p>mask 语义实证：{@code f0a.a(Lf0a;JI)Lf0a;}（= copy(color) 的 default 桥）
     * 里是 {@code and-int/lit8 v, mask, 0x1} ⇒ <b>bit N 置位 = 第 N 个参数取默认值</b>。
     * 参数位序（从 smali 的 15 参构造器抄的）：
     * <pre>
     *   0 color | 1 fontSize | 2 fontWeight | 3 fontStyle | 4 fontSynthesis | 5 fontFamily
     *   6 fontFeatureSettings | 7 letterSpacing | 8 baselineShift | 9 textGeometricTransform
     *   10 localeList | 11 background | 12 textDecoration | 13 shadow | 14 mask
     * </pre>
     * ⇒ 只给 color 时 mask = {@code 0x3FFF & ~(1<<0)}，其余位全置 ⇒ 不回传的值一律走默认，
     * 所以传 {@code null} / {@code 0L} 是安全的（Kotlin 的 default 分支会直接覆盖掉）。
     */
    private static Object spanOf(Long color, Long bg, Object fw, Object fs, Object deco) {
        try {
            int mask = 0x3FFF;                     // 低 14 位；置位 = 用默认值
            Object[] a = new Object[15];
            a[0] = Long.valueOf(color == null ? 0L : color.longValue());
            a[1] = Long.valueOf(0L);               // fontSize   → 默认
            a[2] = fw;                             // fontWeight
            a[3] = fs;                             // fontStyle
            a[4] = null;                           // fontSynthesis
            a[5] = null;                           // fontFamily
            a[6] = null;                           // fontFeatureSettings
            a[7] = Long.valueOf(0L);               // letterSpacing → 默认
            a[8] = null;                           // baselineShift
            a[9] = null;                           // textGeometricTransform
            a[10] = null;                          // localeList
            a[11] = Long.valueOf(bg == null ? 0L : bg.longValue());
            a[12] = deco;                          // textDecoration
            a[13] = null;                          // shadow

            if (color != null) mask &= ~(1 << 0);
            if (fw != null) mask &= ~(1 << 2);
            if (fs != null) mask &= ~(1 << 3);
            if (bg != null) mask &= ~(1 << 11);
            if (deco != null) mask &= ~(1 << 12);
            a[14] = Integer.valueOf(mask);

            return ctSpan.newInstance(a);
        } catch (Throwable t) {
            GmUtil.logOnce("richHook.spanFail", "SpanStyle 构造失败：s=" + t);
            return null;
        }
    }

    // ═══════════════════════════ ④ 安装 ═══════════════════════════

    /**
     * 装钩。策略：<b>候选名 → 结构自检 → 才挂</b>。
     *
     * @return 装上的钩子数（0 = 没找到 / 自检不过 ⇒ 功能整体不启用，宿主毫发无损）
     */
    public static int install(ClassLoader cl) {
        if (!prepare(cl)) {
            GmUtil.log("hookM FAIL richText → " + sWhy);
            return 0;
        }
        for (String name : CAND_MT) {
            try {
                Class<?> c = Class.forName(name, false, cl);
                Method target = null;
                for (Method m : c.getDeclaredMethods()) {
                    if (!"p".equals(m.getName())) continue;
                    if (!Modifier.isStatic(m.getModifiers())) continue;
                    if (m.getReturnType() != void.class) continue;
                    Class<?>[] ps = m.getParameterTypes();
                    if (ps.length != 7) continue;
                    if (ps[0] != cKn) continue;        // ★ 首参必须是 AnnotatedString
                    target = m;
                    break;
                }
                if (target == null) {
                    GmUtil.log("hookM FAIL richText → " + name
                            + " 类在，但没有 p(AnnotatedString,…) 这个方法（名字被复用？该重新反查了）");
                    continue;
                }
                target.setAccessible(true);
                XposedBridge.hookMethod(target, new GmRichTextHook());
                GmUtil.log("hookM richText count=1 cls=" + name + ".p 签名=" + sig(target));
                return 1;
            } catch (Throwable t) {
                GmUtil.logFail("richTextHook.install/" + name, t);
            }
        }
        GmUtil.log("hookM FAIL richText → 全部候选未命中，宿主可能已改版");
        return 0;
    }

    private static String sig(Method m) {
        StringBuilder sb = new StringBuilder("(");
        for (Class<?> p : m.getParameterTypes()) sb.append(p.getSimpleName()).append(',');
        return sb.append(')').toString();
    }

    /** 结构自检 —— 全过才算就绪。任何一步不过 ⇒ 记原因、整体不启用 */
    private static boolean prepare(ClassLoader cl) {
        if (sTried) return sReady;
        synchronized (GmRichTextHook.class) {
            if (sTried) return sReady;
            try {
                // ① SpanStyle
                cSpan = load(cl, CAND_SPAN);
                if (cSpan == null) return bail("SpanStyle 没找到");
                if (cSpan.getDeclaredFields().length < 14) return bail("f0a 字段数不足，不像 SpanStyle");
                for (Constructor<?> ct : cSpan.getDeclaredConstructors()) {
                    Class<?>[] ps = ct.getParameterTypes();
                    if (ps.length == 15 && ps[0] == long.class && ps[1] == long.class
                            && ps[14] == int.class) {
                        ctSpan = ct;
                        break;
                    }
                }
                if (ctSpan == null) return bail("SpanStyle 15 参构造器没找到（mask 版）");
                ctSpan.setAccessible(true);

                // ② AnnotatedString
                cKn = load(cl, CAND_KN);
                if (cKn == null) return bail("AnnotatedString 没找到");
                if (!CharSequence.class.isAssignableFrom(cKn)) return bail("kn 不是 CharSequence");
                fText = cKn.getDeclaredField("b");
                fText.setAccessible(true);
                if (fText.getType() != String.class) return bail("kn.b 不是 String");
                cKn.getDeclaredConstructor(String.class, List.class);   // 自检：得有 (String,List) 构造

                // ③ Builder
                cIn = load(cl, CAND_IN);
                if (cIn == null) return bail("AnnotatedString.Builder 没找到");
                ctInNew = cIn.getDeclaredConstructor();
                ctInNew.setAccessible(true);
                mAppendKn = pick(cIn, "c", cKn, int.class, int.class);
                mAppendStr = pick(cIn, "e", String.class);
                mPush = pick(cIn, "j", cSpan);
                mPop = pick(cIn, "f");
                mToKn = pick(cIn, "k");
                if (mAppendKn == null || mAppendStr == null || mPush == null
                        || mPop == null || mToKn == null) {
                    return bail("Builder 的 append/pushStyle/pop/toAnnotatedString 有缺");
                }
                if (mToKn.getReturnType() != cKn) return bail("in.k() 返回的不是 AnnotatedString");
                if (mPush.getReturnType() != int.class) return bail("in.j(…) 返回的不是 int（不像是 pushStyle）");

                // ④ FontWeight / FontStyle / TextDecoration
                cWeight = load(cl, CAND_WEIGHT);
                if (cWeight == null) return bail("FontWeight 没找到");
                if (cWeight.getDeclaredField("a").getType() != int.class) return bail("ko4.a 不是 int");
                ctWeight = pickCtor(cWeight);

                cStyle = load(cl, CAND_STYLE);
                if (cStyle == null) return bail("FontStyle 没找到");
                if (cStyle.getDeclaredField("a").getType() != int.class) return bail("io4.a 不是 int");
                ctStyle = pickCtor(cStyle);

                cDeco = load(cl, CAND_DECO);
                if (cDeco == null) return bail("TextDecoration 没找到");
                if (cDeco.getDeclaredField("a").getType() != int.class) return bail("dia.a 不是 int");
                ctDeco = pickCtor(cDeco);

                if (ctWeight == null || ctStyle == null || ctDeco == null) {
                    return bail("FontWeight/FontStyle/TextDecoration 有缺 (int) 构造器");
                }

                sWhy = "自检全过（kn/in/f0a/ko4/io4/dia）";
                sReady = true;
                // ★ 顺带把"可点击"那套（<Suggestion> 要用）也自检了 —— 见 GmRichLink
                GmRichLink.prepare(cl);
                GmUtil.log("richText 自检 OK：" + sWhy + " · 链接：" + GmRichLink.status());
                return true;
            } catch (Throwable t) {
                sWhy = "自检抛异常：" + t;
                try {
                    GmUtil.logFail("richText.prepare", t);
                } catch (Throwable ignore) {
                    // 日志都失败就算了
                }
                sTried = true;
                sReady = false;
                return false;
            } finally {
                sTried = true;
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

    /** 按 (参数类型…) 精确取方法；取不到返回 null（不抛） */
    private static Method pick(Class<?> c, String name, Class<?>... ps) {
        try {
            Method m = c.getDeclaredMethod(name, ps);
            m.setAccessible(true);
            return m;
        } catch (Throwable t) {
            return null;
        }
    }

    /** 取唯一的 {@code (int)} 构造器（FontStyle 那个是 synthetic，遍历更稳） */
    private static Constructor<?> pickCtor(Class<?> c) {
        for (Constructor<?> ct : c.getDeclaredConstructors()) {
            Class<?>[] ps = ct.getParameterTypes();
            if (ps.length == 1 && ps[0] == int.class) {
                ct.setAccessible(true);
                return ct;
            }
        }
        return null;
    }
}
