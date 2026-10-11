// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;
import android.os.SystemClock;

import com.nidyaber.fuckdsmanger.gm.GmRichText;
import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;
import com.nidyaber.fuckdsmanger.music.GmMusicApi;

import java.util.List;

/**
 * 点歌 · 让**模型**给用户放歌 🐲 2026-10-11 · 3.69.0
 *
 * <p>主人：「在系统提示词的音乐里面加个开关，让模型能给用户点歌
 * （以**歌曲-歌手**的模式，**搜不到歌曲默认结果第一个**）」。
 *
 * <h3>链路</h3>
 * <pre>
 *   ① 开关开（{@link #on()}，读 {@link #K_OFF} 的反面）⇒ {@link com.nidyaber.fuckdsmanger.gm.GmSysPrompt}
 *      会在系统提示词里补一段「点歌约定」（{@link #promptSection()}）
 *   ② 模型照约定在回复里写 {@code ⟦DJ:晴天-周杰伦⟧}
 *   ③ {@link GmRichText#scan} 认出这一族 ⇒ {@link GmRichTextHook} 调 {@link #handle}
 *   ④ 这里：搜 → 选 → 放；并把**要给用户看的那一行**（或 null）还给渲染器
 * </pre>
 *
 * <h3>为什么"选择"和"渲染"是分开的</h3>
 * 渲染是**同步**的（要立刻拼出 AnnotatedString），而搜索是**异步**的（网络）。
 * ⇒ 气泡里那一行用**模型写的原话**同步拼出来（不剧透、不等网络）；
 * 真正放哪一首（精确命中 / 兜底第一条 / 一首都没搜到）走异步回调，
 * 差别用 **toast** 补一刀告诉用户。
 *
 * <p>⚠️ 版权：与音乐页同规矩 —— **只在线放，不落盘、不下载**。
 */
public final class GmMusicDj {

    /**
     * 开关的宿主键（宿主 MMKV，类型 b）—— ★ 是「**关**」的那一侧。
     *
     * <p>为什么不用 `_on`：看真身 —— {@code GmStore.read2} 对**没写过的键返回空串 ""**
     * （`if (!sp.contains(key)) return "";`），于是 {@code GmRichText.boolOf} 的
     * 类型探测（"true"/"1"/"false"/"0"）**一个都不匹配** ⇒
     * 一路落到它自己的 {@code def} 参数上。
     *
     * <p>⇒ 用 `_on` + `def=false` 的话："没写过"读出来是 false ⇒ **永远关**（用户拨了才开）。
     * 用「关」键 + `def=false` 才是我们要的：没写过 ⇒ false ⇒ **没关** ⇒ **开**（默认开）。
     *
     * <p>界面侧（{@code Music.kt}）拨动时写的也是这个键，值是**取反**后的。
     */
    public static final String K_OFF = "fuckds_dj_off";

    /** 旗标：{@code |hidden} ⇒ 连「♪ 正在给你放…」都不显示（悄悄放）。 */
    private static final String FLAG_HIDDEN = "hidden";

    /**
     * ★★★ 3.69.5 去重（主人实测：「多次搜索，然后播放器多次播放，吐司一大堆」）。
     *
     * <p><b>为什么会被重复调用</b>：{@code handle()} 挂在 {@code GmRichTextHook.rebuild()} 里 ——
     * 而**每次重绘都会 rebuild**：流式输出（一段一段长）、滚动、重组……
     * 真机日志里同一条 {@code ⟦DJ:红色高跟鞋-蔡健雅⟧} 被处理了 **18 次**
     * ⇒ 搜 18 次、播 18 次（每次 {@code play()} 都 {@code startCurrent()} ⇒ 歌一直从头重开）、
     * 吐司弹 18 次。
     *
     * <p>⇒ 按「歌名|歌手|hidden」记一个时间窗：窗内同一条**只处理一次**。
     * 之所以带时间窗而不是永久去重：用户过一会儿**再点同一首**是合理需求，得放行。
     *
     * <p>窗口取 15 秒 —— 够覆盖一条消息的整个流式渲染过程，又不至于拦掉"再点一次"。
     */
    private static final long DEDUP_MS = 15000L;
    private static final Object DEDUP_LOCK = new Object();
    private static final java.util.HashMap<String, Long> DEDUP = new java.util.HashMap<String, Long>();

    /**
     * ★★★ 3.69.6 接口报错后的冷却（真机实测 网易云 返回 code=405）。
     *
     * <p>为什么要有：接口拒绝时**继续重试只会越打越狠**（我们之前就因为重复执行打了 189 次，
     * 很可能就是这么进的限流）。⇒ 一旦发现 code != 200，20 秒内**不再发搜索**，
     * 并且这段窗口里只提示**一次**（不然吐司又刷屏）。
     */
    private static final long API_COOLDOWN_MS = 20000L;
    private static volatile long sApiErrAt = 0L;

    /** 还在冷却中吗？（冷却中就别发请求） */
    private static boolean apiCooling() {
        return SystemClock.uptimeMillis() - sApiErrAt < API_COOLDOWN_MS;
    }

    /**
     * 记一次"接口拒绝"。
     *
     * @return true = 这次**要提示用户**（每个冷却窗口只提示一次）
     */
    private static boolean noteApiError(int code) {
        long now = SystemClock.uptimeMillis();
        boolean first = now - sApiErrAt >= API_COOLDOWN_MS;
        sApiErrAt = now;
        GmUtil.log("【DJ】搜索被接口拒绝：code=" + code + "（进入 " + (API_COOLDOWN_MS / 1000) + "s 冷却）");
        return first;
    }

    /** true = 这条点歌最近刚处理过（跳过：不搜、不播、不吐司）。 */
    private static boolean recentlyHandled(String key) {
        long now = SystemClock.uptimeMillis();
        synchronized (DEDUP_LOCK) {
            java.util.Iterator<java.util.Map.Entry<String, Long>> it = DEDUP.entrySet().iterator();
            while (it.hasNext()) {                       // 顺手清过期项
                if (now - it.next().getValue() > DEDUP_MS) it.remove();
            }
            Long t = DEDUP.get(key);
            if (t != null && now - t < DEDUP_MS) return true;
            DEDUP.put(key, now);
            return false;
        }
    }

    private GmMusicDj() {}

    /**
     * 开关开着吗？（宿主里跑 ⇒ 读同一个 MMKV）
     *
     * <p>★★ 3.69.2 修了一个**双重 bug**（主人实测：模型压根不知道能点歌）：
     * <ol>
     *   <li>原来读的是 {@code fuckds_dj_on} —— 而 UI 从来只写 {@code fuckds_dj_off}
     *       ⇒ 没写过 ⇒ {@code boolOf} 落到 def=false ⇒ **永远"关"** ✗</li>
     *   <li>同时 {@code GmSysPrompt} 那边把 {@code _off} 的 def 写成了 {@code true}
     *       ⇒ 没写过 ⇒ 读成"已关" ⇒ **约定永远不补** ✗</li>
     * </ol>
     * 现在两处**只认这一个方法**（约定注入也走它）⇒ 不可能再各读各的。
     */
    public static boolean on() {
        Context ctx = GmUtil.app();
        if (ctx == null) return false;
        try {
            // ★ 读「关」键，def=false：没写过 ⇒ false ⇒ 没关 ⇒ 开（默认开）
            return !GmRichText.boolOf(ctx, K_OFF, false);
        } catch (Throwable t) {
            return false;                 // 真出错时：宁愿"关"（不往提示词里塞东西）
        }
    }

    /**
     * 写进系统提示词的那段「点歌约定」。
     *
     * <p>要点：**只说怎么做，不解释内部机制**（模型不需要知道我们有 hook）；
     * 标记写法要短、要能一眼抄对（所以给了例子 + 明确"不要写在代码块里"）。
     */
    public static String promptSection() {
        return "\n\n【点歌】你想给用户放首歌的时候，在回复里**另起一行**写：\n"
                + "\u27E6DJ:歌名-歌手\u27E7\n"
                + "例如：\u27E6DJ:晴天-周杰伦\u27E7 或 \u27E6DJ:海阔天空-Beyond\u27E7"
                + "（只知道歌名、不确定歌手时，只写歌名也行）。\n"
                + "这一行**不会显示给用户看**，会变成「♪ 正在给你放：歌名 - 歌手」；"
                + "若想连这行提示都不要（悄悄放），写成 \u27E6DJ:歌名-歌手|hidden\u27E7。\n"
                + "⚠️ 只在**用户明确想听歌**时用；不要把它写进代码块/引号里，也不要解释这个标记。\n";
    }

    /**
     * 处理一个点歌标记。
     *
     * @param body 标记里的原文（{@code 歌名-歌手} 或 {@code 歌名-歌手|hidden}）
     * @return 要在气泡里显示的那一行；{@code null} = 什么都不显示
     */
    public static String handle(String body) {
        try {
            if (body == null) return null;
            // ── ① 拆旗标 ──
            String spec = body.trim();
            boolean hidden = false;
            int bar = body.indexOf('|');
            if (bar >= 0) {
                spec = body.substring(0, bar).trim();
                for (String f : body.substring(bar + 1).split("\\|")) {
                    if (FLAG_HIDDEN.equalsIgnoreCase(f.trim())) hidden = true;
                }
            }
            if (spec.isEmpty()) return null;

            Context ctx = GmUtil.app();
            if (ctx == null) return null;
            if (!on()) {
                // 开关关着（模型可能从旧对话里学样）⇒ 别放歌，也**别把标记漏出去**
                GmUtil.logOnce("dj.off", "收到点歌标记但开关是关的（" + K_OFF + "）—— 已吞掉");
                return null;
            }

            // ── ② 拆「歌名-歌手」：取**第一个**分隔符 ──
            //   歌名里可能带横线（如 Love-Story），但"歌名-歌手"的约定下第一个最像分界；
            //   找不到分隔符 ⇒ 整串当关键词搜。
            String song = spec;
            String artist = "";
            int sep = firstSep(spec);
            if (sep > 0) {
                song = spec.substring(0, sep).trim();
                artist = spec.substring(sep + 1).trim();
            }
            if (song.isEmpty()) return null;

            final String fSong = song;
            final String fArtist = artist;
            final String kw = artist.isEmpty() ? song : (song + " " + artist);

            // ── ③ 先给气泡一行字（同步、不等网络）──
            String show = hidden ? null
                    : ("♪ 正在给你放：" + (artist.isEmpty() ? song : song + " - " + artist));

            // ── ③.5 ★ 去重：同一条点歌在"一次渲染过程"里只处理一次 ──
            //   （流式/滚动会让同一条消息 rebuild 很多次，见 DEDUP_MS 的说明）
            final String dedupKey = (hidden ? "H|" : "") + song + "|" + artist;
            if (recentlyHandled(dedupKey)) {
                GmUtil.logOnce("dj.dup." + Math.abs(dedupKey.hashCode()),
                        "同一条点歌被重复渲染 ⇒ 跳过（不重复搜/放/吐司）：" + dedupKey);
                return show;
            }

            // ── ④ 搜 → 选 → 放（回调在主线程）──
            GmMusicPlayer pl = GmMusicPlayer.get();
            if (pl == null) return show;
            // ★ 3.69.6：接口刚拒绝过 ⇒ 冷却期内不发请求（免得把风控越打越死）
            if (apiCooling()) {
                GmUtil.logOnce("dj.api.cool", "接口刚拒绝过 ⇒ 跳过本次点歌（冷却中）");
                return show;
            }
            // ★ 3.69.5：组合关键词（"歌名 歌手"）零结果时，**退回纯歌名**再搜一次。
            //   真机实测：`迷宫 王若琳` 有时搜不到，而纯歌名能搜到 ⇒ 多一次机会。
            pl.search(kw, 20, new GmMusicPlayer.Cb<List<GmMusicPlayer.Track>>() {
                @Override
                public void on(List<GmMusicPlayer.Track> list) {
                    // ★★ 3.69.6：先分清「接口拒绝」和「真没搜到」——
                    //    以前都当成"没搜到"，提示误导（歌明明有，是接口不给）
                    int code = GmMusicApi.lastCode();
                    if ((list == null || list.isEmpty()) && code != 200 && code != -1) {
                        if (noteApiError(code)) {
                            GmUtil.toast(GmUtil.app(), "♪ 网易云拒绝了搜索（code=" + code
                                    + "）—— 可能被限流，稍后再试；一直不行就去音乐页重新登录");
                        }
                        return;                       // ★ 不做兜底搜索（别再打接口）
                    }
                    if ((list == null || list.isEmpty()) && !fArtist.isEmpty()) {
                        GmMusicPlayer p2 = GmMusicPlayer.get();
                        if (p2 != null) {
                            GmUtil.log("【DJ】组合词没结果，退回纯歌名再搜：" + fSong);
                            p2.search(fSong, 20, new GmMusicPlayer.Cb<List<GmMusicPlayer.Track>>() {
                                @Override
                                public void on(List<GmMusicPlayer.Track> l2) {
                                    doPick(l2, fSong, fArtist);
                                }
                            });
                            return;
                        }
                    }
                    doPick(list, fSong, fArtist);
                }
            });
            return show;
        } catch (Throwable t) {
            GmUtil.logFail("dj.handle", t);
            return null;                       // 出岔子也别把标记漏到界面上
        }
    }

    /**
     * 从搜索结果里挑一首并起播（★ 3.69.5 从 handle 里抽出来，好给"纯歌名兜底搜索"复用）。
     *
     * @param list   搜索结果（可能为 null / 空）
     * @param fSong  歌名
     * @param fArtist 歌手（可能为空）
     */
    private static void doPick(List<GmMusicPlayer.Track> list, String fSong, String fArtist) {
        try {
            GmMusicPlayer p = GmMusicPlayer.get();
            if (p == null) return;

            GmMusicPlayer.Track pick = null;
            boolean exact = false;
            if (list != null) {
                for (GmMusicPlayer.Track t : list) {
                    if (t == null) continue;
                    boolean nameOk = t.name != null && t.name.contains(fSong);
                    boolean artOk = fArtist.isEmpty()
                            || (t.artist != null && t.artist.contains(fArtist));
                    if (nameOk && artOk) {
                        pick = t;
                        exact = true;
                        break;
                    }
                }
                // ★ 主人：「搜不到歌曲默认结果第一个」
                if (pick == null && !list.isEmpty()) pick = list.get(0);
            }
            if (pick == null) {
                int code = GmMusicApi.lastCode();
                if (code != 200 && code != -1) {
                    if (noteApiError(code)) {
                        GmUtil.toast(GmUtil.app(), "♪ 网易云拒绝了搜索（code=" + code
                                + "）—— 可能被限流，稍后再试；一直不行就去音乐页重新登录");
                    }
                    return;
                }
                GmUtil.toast(GmUtil.app(), "♪ 没搜到「" + fSong + "」");
                GmUtil.log("【DJ】点歌失败（零结果）：" + fSong + " - " + fArtist);
                return;
            }
            p.play(pick);
            GmUtil.log("【DJ】点歌 " + fSong + " - " + fArtist
                    + " ⇒ 放了 " + pick.name + " - " + pick.artist
                    + (exact ? "（精确命中）" : "（兜底第一条）"));
            if (!exact) {
                // 兜底/替换要**说出来** —— 否则用户以为放错了、或以为歌名匹配上了
                GmUtil.toast(GmUtil.app(), "♪ 没找到「" + fSong
                        + "」，给你放了：" + pick.name + " - " + pick.artist);
            }
        } catch (Throwable t) {
            GmUtil.logFail("dj.play", t);
        }
    }

    /** 找「歌名-歌手」的分隔符：半角/全角连字符、破折号、减号都认。 */
    private static int firstSep(String s) {
        for (int i = 1; i < s.length(); i++) {          // 从 1 开始：开头的 '-' 不算分隔
            char c = s.charAt(i);
            if (c == '-' || c == '\uFF0D' || c == '\u2014' || c == '\u2013' || c == '\u2212') {
                return i;
            }
        }
        return -1;
    }

    /** 给设置页用的一句话状态。 */
    public static String describe() {
        Context ctx = GmUtil.app();
        if (ctx == null) return "宿主没起";
        try {
            return on() ? "已开启" : "已关闭";
        } catch (Throwable t) {
            return "未知";
        }
    }

    /** 让 UI 侧读一眼真值（调试用）。 */
    public static String raw() {
        Context ctx = GmUtil.app();
        if (ctx == null) return null;
        try {
            return GmStore.read2(ctx, K_OFF, "b");
        } catch (Throwable t) {
            return null;
        }
    }
}
