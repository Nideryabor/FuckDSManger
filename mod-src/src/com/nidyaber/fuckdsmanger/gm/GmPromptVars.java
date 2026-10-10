// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;

import com.nidyaber.fuckdsmanger.bridge.GmMusicPlayer;

/**
 * GmPromptVars —— 系统提示词里的「动态变量」🐲（2026-10-07 · 3.57.0 · 尼得亚伯）
 *
 * <h3>它解决什么问题</h3>
 * 「系统提示词」是**静态**的：写进去什么样，发出去就什么样。
 * 但有些信息是**时变**的 —— 最典型的就是「我现在正在听哪首歌、听到哪一句」。
 * 主人 2026-10-07 的要求原话：把当前播放的**歌曲 / 歌手 / 歌词**塞进提示词，
 * 「这样模型就知道我们在听哪里了」。
 *
 * <p>⇒ 本类提供一组 <b>{变量}</b> 占位符，在
 * {@link GmSysPrompt#inject}（= 宿主要发一条 completion 请求的那一刻）**当场替换**。
 * 因为替换发生在「发消息」这个时刻，所以歌词行与播放进度**天然是实时的**，
 * 不需要任何轮询/广播。
 *
 * <h3>变量表</h3>
 * <table border="1">
 *   <tr><td>{@code {music}}</td><td>一句话摘要：{@code 《歌名》 - 歌手 (1:23/3:42)}</td></tr>
 *   <tr><td>{@code {music_or_none}}</td><td>同上；**开关开着但真没在听** ⇒ {@code 没有在听歌}（见下）</td></tr>
 *   <tr><td>{@code {song}} {@code {artist}} {@code {album}}</td><td>歌名 / 歌手 / 专辑</td></tr>
 *   <tr><td>{@code {music_pos}} {@code {music_dur}} {@code {music_left}}</td><td>已听 / 总长 / 剩余（mm:ss）</td></tr>
 *   <tr><td>{@code {music_state}}</td><td>{@code playing} / {@code paused}</td></tr>
 *   <tr><td>{@code {lyric}} {@code {lyric_prev}} {@code {lyric_next}}</td><td>当前唱到的这一句 / 上一句 / 下一句</td></tr>
 * </table>
 *
 * <h3>★★ 「空」是有歧义的 —— 这一版最重要的修正（3.57.1 · 主人 2026-10-07 指出）</h3>
 *
 * 主人原话：「系统提示词里面写『没有播放就是没在放歌』，但是如果我放歌把总开关关掉了呢」。
 *
 * <p><b>这是本功能第一版的真漏洞</b>：一个变量变空，至少有 <b>三种</b>原因 ——
 * <ol>
 *   <li>总开关关着（功能不生效）</li>
 *   <li>真没在放歌</li>
 *   <li>歌词开关关着 / 歌词还没缓存到（只影响 {@code {lyric}} 系列）</li>
 * </ol>
 * 模型看到的却只是「空」。而第一版的示例文案里还写着「没在放歌时下面两行整体消失」——
 * <b>等于我们主动替模型做了一个可能不准的断言</b>：主人关掉开关听歌时，
 * 模型看到空 ⇒ 信了那句话 ⇒ 以为主人没在听。**这不是文案问题，是把「空」当成了唯一语义。**
 *
 * <p>⇒ 两条修正：
 * <ol>
 *   <li><b>示例文案不再做任何「空 = 什么」的断言</b> —— 只给变量，让模型自己看着办。
 *       别让提示词替我们撒一个可能不准的谎。</li>
 *   <li><b>新增 {@code {music_or_none}}</b>：开关**开着**但真没在听 ⇒ 明确输出 {@code 没有在听歌}；
 *       开关**关着** ⇒ 仍然是空串（功能不存在 ⇒ 不留痕迹）。
 *       <b>想「不让模型猜」就用它；想「没听就整句别出现」就用 {@code {music}} + {@code [[ ]]}。</b>
 *       两种诉求各有一个正确的工具，不再混为一谈。</li>
 * </ol>
 *
 * <h3>空值语义（主人 2026-10-07 拍板）</h3>
 * <ul>
 *   <li>没在放歌 ⇒ 变量替换成 <b>空字符串</b>（把该信息的缺失如实表达给模型，
 *       而不是编一句「未在播放」占位）</li>
 *   <li>配套的「糖」：{@code [[ … ]]} 包起来的整块，<b>块内有我们的变量、且块内所有变量都为空</b>
 *       时，<b>连块带括号一起删掉</b> ⇒ 句子里那句「正在听：{music}」在有歌时才出现，
 *       没歌时整行消失，不会留一条「正在听：」的断尾巴。
 *       <p>注意：<b>只认一层</b>（不支持嵌套），且块内必须至少有一个变量 ——
 *       {@code [[普通方括号内容]]} 会被原样保留（脱壳都不脱），避免误伤正常文本。</li>
 * </ul>
 *
 * <h3>⚠️ 三条纪律</h3>
 * <ol>
 *   <li><b>热路径零异常</b>：本方法的调用点在「每次发消息」的构造器 hook 里，
 *       任何异常都必须被吞掉并原样放行（教训 255）。</li>
 *   <li><b>绝不联网、绝不阻塞</b>：只读 {@link GmMusicPlayer} 的**内存**状态与歌词缓存。
 *       歌词缓存没命中时，只做一次<b>异步预热</b>（失败无所谓），
 *       绝不在发消息的线程上等网络。</li>
 *   <li><b>版权</b>：歌词只在内存（项目铁律，见 {@code GmMusicPlayer} 文件头）。
 *       歌词变量**独立开关、默认关** —— 因为它一旦被塞进提示词，
 *       就会**上传给服务器并留在对话历史里**，这是和「内存里显示给自己看」完全不同量级的事。
 *       歌名/歌手/专辑属于事实性元数据，风险与歌词不同，故与歌词共用总开关但不受歌词开关限制。</li>
 * </ol>
 */
public final class GmPromptVars {

    /** 总开关（音乐变量；默认关） */
    public static final String K_ON = "fuckds_pvar_on";

    /** 歌词变量开关（⚠️ 版权：默认关，开启意味着歌词会上传给服务端） */
    public static final String K_LYRIC = "fuckds_pvar_lyric";

    /** 灌进系统提示词那段的特征串 —— 幂等判据（同 GmRichText.SPEC_TAG 的套路） */
    public static final String SPEC_TAG = "【音乐变量】";

    /**
     * 变量名表。每个都是 {@code {name}} 精确匹配 ⇒ 用户提示词里别的花括号不会被误伤。
     */
    public static final String[] NAMES = {
            "music", "music_or_none",
            "song", "artist", "album",
            "music_pos", "music_dur", "music_left", "music_state",
            "lyric", "lyric_prev", "lyric_next",
    };

    /** 歌词预热的节流（同一首 60 秒内只试一次，别把接口刷爆） */
    private static volatile long sWarmId = 0L;
    private static volatile long sWarmAt = 0L;

    private GmPromptVars() {}

    // ─────────────────────────── 开关读写 ───────────────────────────

    public static boolean on() {
        Context ctx = GmUtil.app();
        if (ctx == null) return false;
        try {
            return GmSysPrompt.boolOf(ctx, K_ON, false);
        } catch (Throwable t) {
            return false;
        }
    }

    public static void setOn(boolean v) {
        Context ctx = GmUtil.app();
        if (ctx == null) return;
        try {
            GmStore.write(ctx, K_ON, v ? "true" : "false", "b");   // ★ 类型 "b"
        } catch (Throwable t) {
            GmUtil.logFail("pvar.setOn", t);
        }
    }

    public static boolean lyricOn() {
        Context ctx = GmUtil.app();
        if (ctx == null) return false;
        try {
            return GmSysPrompt.boolOf(ctx, K_LYRIC, false);
        } catch (Throwable t) {
            return false;
        }
    }

    public static void setLyricOn(boolean v) {
        Context ctx = GmUtil.app();
        if (ctx == null) return;
        try {
            GmStore.write(ctx, K_LYRIC, v ? "true" : "false", "b");
        } catch (Throwable t) {
            GmUtil.logFail("pvar.setLyricOn", t);
        }
    }

    // ─────────────────────────── 替换 ───────────────────────────

    /**
     * 这段文本里有没有我们的音乐变量 —— 给 inject 做**快判据**用。
     *
     * <p>为什么要这个：{@link GmSysPrompt#inject} 决定「这一轮要不要注入」时，
     * 得先知道正文里到底有没有时变内容 —— 有 ⇒ 必须每轮注入（见 GmSysPrompt 里的说明）。
     * 用 {@code indexOf} 而不是正则，热路径上更省。
     */
    public static boolean hasAny(String s) {
        if (s == null || s.isEmpty()) return false;
        for (int i = 0; i < NAMES.length; i++) {
            if (s.indexOf('{' + NAMES[i] + '}') >= 0) return true;
        }
        return false;
    }

    /**
     * ★ 入口：把一段文本里的全部音乐变量替换成**此刻**的真值。
     *
     * @return 替换后的文本；没在放歌 / 开关关着 / 出异常 ⇒ 变量变空串或原文
     */
    public static String resolve(String s) {
        if (s == null || s.isEmpty()) return s;
        try {
            Snap sn = snap();
            String out = collapse(s, sn);
            for (int i = 0; i < NAMES.length; i++) {
                out = out.replace("{" + NAMES[i] + "}", value(NAMES[i], sn));
            }
            return out;
        } catch (Throwable t) {
            GmUtil.logFail("pvar.resolve", t);
            return s;                                   // ★ 异常一律原样放行
        }
    }

    /** 单个变量的值（空值 = ""） */
    private static String value(String n, Snap s) {
        if ("music_or_none".equals(n)) {
            // ★ 3.57.1：**只有它**会在「开关开着但真没在听」时说话。
            //   总开关关着 ⇒ snap() 返回 null ⇒ 落到最后那个 return "" ⇒ 仍然空（功能不存在 ⇒ 不留痕迹）。
            if (s == null) return "";
            String sum = s.summary();
            return sum.isEmpty() ? "没有在听歌" : sum;
        }
        if (s == null) return "";
        if ("song".equals(n)) return s.name;
        if ("artist".equals(n)) return s.artist;
        if ("album".equals(n)) return s.album;
        if ("music".equals(n)) return s.summary();
        if ("music_pos".equals(n)) return fmt(s.pos);
        if ("music_dur".equals(n)) return fmt(s.dur);
        if ("music_left".equals(n)) return s.dur > 0 ? fmt(Math.max(0, s.dur - s.pos)) : "";
        if ("music_state".equals(n)) return s.playing ? "playing" : "paused";
        if ("lyric".equals(n)) return lyr(s, 0);
        if ("lyric_prev".equals(n)) return lyr(s, 1);
        if ("lyric_next".equals(n)) return lyr(s, 2);
        return "";
    }

    private static String lyr(Snap s, int which) {
        if (!lyricOn()) return "";                      // ★ 版权闸门：独立开关，默认关
        if (s == null || s.around == null) return "";
        return which == 0 ? s.around[0] : (which == 1 ? s.around[1] : s.around[2]);
    }

    /**
     * {@code [[ … ]]} 的「有内容才出现」处理。
     *
     * <p>规则（只一层，不嵌套）：块内**至少有一个**我们的变量，且这些变量**全部为空**
     * ⇒ 整块消失；否则只脱掉 {@code [[} {@code ]]} 两层壳，里面的字原样留着。
     */
    private static String collapse(String s, Snap sn) {
        if (s == null || s.indexOf("[[") < 0) return s;
        StringBuilder out = new StringBuilder(s.length());
        int from = 0;
        while (true) {
            int a = s.indexOf("[[", from);
            if (a < 0) {
                out.append(s, from, s.length());
                break;
            }
            int b = s.indexOf("]]", a + 2);
            if (b < 0) {                                // 不闭合 ⇒ 剩下的原样留着
                out.append(s, from, s.length());
                break;
            }
            out.append(s, from, a);
            String inner = s.substring(a + 2, b);
            boolean hasVar = false;
            boolean allEmpty = true;
            for (int i = 0; i < NAMES.length && allEmpty; i++) {
                if (inner.indexOf('{' + NAMES[i] + '}') >= 0) {
                    hasVar = true;
                    if (!value(NAMES[i], sn).isEmpty()) allEmpty = false;
                }
            }
            if (!(hasVar && allEmpty)) out.append(inner);   // 有内容 ⇒ 脱壳保留
            from = b + 2;
        }
        return out.toString();
    }

    // ─────────────────────────── 取快照 ───────────────────────────

    /** 此刻的播放快照；null = 没在放歌（或总开关关着 / 播放器不在这个进程）。 */
    private static Snap snap() {
        if (!on()) return null;                         // 开关关 ⇒ 全部按空处理
        GmMusicPlayer p = GmMusicPlayer.get();
        if (p == null) return null;
        GmMusicPlayer.State st;
        try {
            st = p.state();
        } catch (Throwable t) {
            return null;
        }
        if (st == null || st.track == null) return null;

        Snap s = new Snap();
        s.name = str(st.track.name);
        s.artist = str(st.track.artist);
        s.album = str(st.track.album);
        s.id = st.track.id;
        s.pos = st.pos;
        s.dur = st.dur;
        s.playing = st.playing;

        // 歌词：**只读内存缓存**；没命中就异步预热一次（下次发消息就有了）
        if (lyricOn() && s.id > 0) {
            try {
                s.around = p.lyricAround(s.id, s.pos);
            } catch (Throwable ignore) {
                s.around = null;
            }
            if (s.around == null) warm(s.id);
        }
        return s;
    }

    /**
     * 歌词**预热** —— 缓存没命中时踢一脚异步加载。
     *
     * <p>为什么要预热：歌词只有「迷你卡/歌词页显示过」才会进内存缓存。
     * 主人没开迷你卡时直接发消息 ⇒ 第一次 {@code {lyric}} 必然是空的。
     * 这里顺手拉一把，代价是一次后台请求，不阻塞发消息。
     * <p>节流：同一首 60 秒内只试一次（失败也不刷屏）。
     */
    private static void warm(final long id) {
        long now = System.currentTimeMillis();
        if (sWarmId == id && now - sWarmAt < 60000L) return;
        sWarmId = id;
        sWarmAt = now;
        try {
            final GmMusicPlayer p = GmMusicPlayer.get();
            if (p == null) return;
            p.lyric(id, new GmMusicPlayer.Cb<String>() {
                @Override
                public void on(String v) {
                    GmUtil.logOnce("pvar.warm",
                            "歌词预热完成 id=" + id + " len=" + (v == null ? 0 : v.length()));
                }
            });
        } catch (Throwable ignore) {
            // 预热失败不影响本次替换
        }
    }

    // ─────────────────────────── 灌进系统提示词 ───────────────────────────

    /**
     * 用法说明段（追加进系统提示词的正文；给模型读，也给主人当模板改）。
     *
     * <p>★ 3.57.1 改：**一个字都不解释「空是什么」**。
     * 第一版这里写着「没在放歌时下面两行整体消失」—— 那是个**可能不准的断言**
     * （开关一关，变量也是空的，模型就会以为主人没在听），见类头「空是有歧义的」那一节。
     * 现在的口径：只把变量摆出来，模型看得到具体的歌就用，看不到就不提。
     */
    public static String spec() {
        return SPEC_TAG + "下面两行是发消息那一刻我在听的歌：\n"
                + "[[正在听：{music}]]\n"
                + "[[当前唱到：{lyric}]]";
    }

    /**
     * 「一键把音乐变量示例写进提示词」—— ★ <b>更新语义</b>（3.57.1 改）。
     *
     * <p>与 {@code GmRichText.mergeSpec}（幂等、有过就不动）**故意不同**：
     * 那几段约定是主人的内容，动它就是不礼貌；而这段示例是**我们代码的产物**，
     * 会随版本演进（3.57.0 → 3.57.1 文案就变了）。
     * 若沿用"有过就不加"，主人在 3.57.0 灌过的旧文案会**永远留在提示词里**，
     * 而按钮还回一句「已经有了」—— 典型的"看着没事、其实没更新"。
     *
     * <p>⇒ 先把旧的同特征段落整段摘掉（{@link #cutParagraph}），再追加新的。
     * <b>主人自己写的正文一个字都不动。</b>
     */
    public static String mergeIntoSystemPrompt() {
        try {
            String cur = GmSysPrompt.text();
            if (cur == null) cur = "";
            boolean had = cur.indexOf(SPEC_TAG) >= 0;
            String out = had ? tidy(cutParagraph(cur, SPEC_TAG)) : cur;
            String nv = out.isEmpty() ? spec() : (out + "\n\n" + spec());
            GmSysPrompt.setText(nv);
            return (had ? "已更新" : "已写进")
                    + "系统提示词（" + cur.length() + " 字 → " + nv.length() + " 字）"
                    + (had ? "；旧的那段被换成新版，你自己写的内容没动" : "");
        } catch (Throwable t) {
            return "写提示词失败：" + t;
        }
    }

    /**
     * 只把【音乐变量】那一段摘掉 🐲 —— 新版界面：「音乐」卡片被拖回抽屉 ⇒ 清空。
     *
     * <p>与 {@link #mergeIntoSystemPrompt()} 对称：同样按特征串 {@link #SPEC_TAG} 定位段落、
     * 整段剪掉，<b>主人自己写的正文一个字不动。</b>
     * （{@code GmRichText.removeSpecs()} 摘的是富文本那两段，跟这一段是两回事。）
     */
    public static String removeSpec() {
        try {
            String cur = GmSysPrompt.text();
            if (cur == null || cur.isEmpty()) return "系统提示词本来是空的，没什么可清";
            if (cur.indexOf(SPEC_TAG) < 0) return "系统提示词里没有【音乐变量】这一段（可能本来就没灌）";

            int before = cur.length();
            String out = tidy(cutParagraph(cur, SPEC_TAG));
            GmSysPrompt.setText(out);
            return "已清空音乐变量示例（" + before + " 字 → " + out.length() + " 字）"
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
        while (out.contains("\n\n\n")) out = out.replace("\n\n\n", "\n\n");
        return out;
    }

    // ─────────────────────────── 小工具 ───────────────────────────

    private static String str(Object o) {
        return o == null ? "" : String.valueOf(o).trim();
    }

    /** 毫秒 → {@code m:ss}（0 或负数 ⇒ 0:00） */
    private static String fmt(int ms) {
        if (ms <= 0) return "0:00";
        int s = ms / 1000;
        return (s / 60) + ":" + (s % 60 < 10 ? "0" : "") + (s % 60);
    }

    private static final class Snap {
        String name = "";
        String artist = "";
        String album = "";
        long id = 0L;
        int pos = 0;
        int dur = 0;
        boolean playing = false;
        String[] around = null;     // {当前, 上一句, 下一句}

        String summary() {
            StringBuilder b = new StringBuilder();
            if (!name.isEmpty()) b.append('\u300A').append(name).append('\u300B');
            if (!artist.isEmpty()) {
                if (b.length() > 0) b.append(" - ");
                b.append(artist);
            }
            if (b.length() == 0) return "";
            b.append(" (").append(fmt(pos));
            if (dur > 0) b.append('/').append(fmt(dur));
            b.append(')');
            return b.toString();
        }
    }
}
