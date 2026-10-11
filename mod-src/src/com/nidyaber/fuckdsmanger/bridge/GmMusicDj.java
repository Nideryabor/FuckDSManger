// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmRichText;
import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.util.List;

/**
 * 点歌 · 让**模型**给用户放歌 🐲 2026-10-11 · 3.69.0
 *
 * <p>主人：「在系统提示词的音乐里面加个开关，让模型能给用户点歌
 * （以**歌曲-歌手**的模式，**搜不到歌曲默认结果第一个**）」。
 *
 * <h3>链路</h3>
 * <pre>
 *   ① 开关开（{@code fuckds_dj_on}）⇒ {@link com.nidyaber.fuckdsmanger.gm.GmSysPrompt}
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

    /** 开关键（宿主 MMKV，类型 b）。UI 在「系统提示词 › 音乐卡展开」里写它。 */
    public static final String K_ON = "fuckds_dj_on";

    /** 旗标：{@code |hidden} ⇒ 连「♪ 正在给你放…」都不显示（悄悄放）。 */
    private static final String FLAG_HIDDEN = "hidden";

    private GmMusicDj() {}

    /** 开关开着吗？（宿主里跑 ⇒ 读同一个 MMKV） */
    public static boolean on() {
        Context ctx = GmUtil.app();
        if (ctx == null) return false;
        try {
            return GmRichText.boolOf(ctx, K_ON, false);
        } catch (Throwable t) {
            return false;
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
                GmUtil.logOnce("dj.off", "收到点歌标记但开关是关的（" + K_ON + "）—— 已吞掉");
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

            // ── ④ 搜 → 选 → 放（回调在主线程）──
            GmMusicPlayer pl = GmMusicPlayer.get();
            if (pl == null) return show;
            pl.search(kw, 20, new GmMusicPlayer.Cb<List<GmMusicPlayer.Track>>() {
                @Override
                public void on(List<GmMusicPlayer.Track> list) {
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
            });
            return show;
        } catch (Throwable t) {
            GmUtil.logFail("dj.handle", t);
            return null;                       // 出岔子也别把标记漏到界面上
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
            return GmStore.read2(ctx, K_ON, "b");
        } catch (Throwable t) {
            return null;
        }
    }
}
