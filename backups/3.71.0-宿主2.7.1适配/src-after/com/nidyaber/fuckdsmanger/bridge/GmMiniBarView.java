// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.GradientDrawable;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.SeekBar;
import android.widget.TextView;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * 迷你播放卡 🐲（纯代码画，零资源依赖）
 *
 * <p>**两个页面**（♪ 按钮来回切）：
 * <pre>
 *  ① 播放页                        ② 搜索页
 *  ┌───────────┬──────────────┐    ┌──────────────────────────┐
 *  │           │ ≡ 曲名&歌手 ✕ │    │ [搜点什么…        ] [搜] │
 *  │   封面     ├──────────────┤    ├──────────────────────────┤
 *  │           │              │    │ 结果 / 队列（可滚动）      │
 *  ├───────────┤    歌词       │    │ ▶ 稻香 · 周杰伦           │
 *  │0:00[━●━]0:00│            │    │ ▶ 晴天 · 周杰伦           │
 *  │♪ ◀◀ ▶ ▶▶ ↻│              │    │ …                        │
 *  └───────────┴──────────────┘    └──────────────────────────┘
 * </pre>
 *
 * <p>每一块都是**圆角矩形**（主人给的图）。
 * <p>它跟播放器（{@link GmMusicPlayer}）**同一个进程** ⇒ 直接读状态、直接调方法，
 * 不用广播。封面与歌词都由播放器去联网，**只在内存**（版权要求，见 GmMusicPlayer 文件头）。
 */
final class GmMiniBarView extends FrameLayout {

    private static final int C_CARD = 0xF218181C;
    private static final int C_PANEL = 0x26FFFFFF;
    private static final int C_TXT = 0xFFF2F2F2;
    private static final int C_SUB = 0x99FFFFFF;
    private static final int C_ACC = 0xFF8AB4F8;

    private static final int PANEL_R = 12;
    private static final int CARD_R = 16;

    static final int MIN_W = 190;
    static final int MIN_H = 120;
    static final int MAX_W = 640;
    static final int MAX_H = 720;
    static final int DEF_W = 330;
    static final int DEF_H = 210;

    private static final int[] CORNER_SYM = {'\u25E4', '\u25E5', '\u25E3', '\u25E2'};
    private static final int HANDLE = 0;

    private final Activity act;

    // ── 页容器 ──
    private FrameLayout pagePlay, pageSearch;

    // ── 播放页 ──
    private TextView vTitle, vArtist, vPos, vDur, vBtnPlay, vBtnLoop, vBtnNote;
    private ImageView vCover;
    private SeekBar vSeek;
    private ScrollView vLyricScroll;
    private LinearLayout vLyricBox;

    // ── 搜索页 ──
    private EditText vKw;
    private LinearLayout vListBox;
    private TextView vListTitle;
    private ScrollView vListScroll;
    private boolean showQueue = false;
    private List<GmMusicPlayer.Track> results = new ArrayList<GmMusicPlayer.Track>();
    private boolean searching = false;

    // ── 歌词状态 ──
    private long lrcId = -1L;
    private final List<Long> lrcMs = new ArrayList<Long>();
    private final List<TextView> lrcViews = new ArrayList<TextView>();
    private int curLine = -1;
    private long coverWanted = -1L;
    private int curDur = 0;
    private boolean seekTouching = false;

    GmMiniBarView(Activity act) {
        super(act);
        this.act = act;
        build();
    }

    // ══════════════════════════════ 小工具 ══════════════════════════════

    private FrameLayout panel() {
        FrameLayout f = new FrameLayout(getContext());
        f.setBackground(round(C_PANEL, PANEL_R));
        return f;
    }

    private GradientDrawable round(int color, int rDp) {
        GradientDrawable d = new GradientDrawable();
        d.setShape(GradientDrawable.RECTANGLE);
        d.setColor(color);
        d.setCornerRadius(GmMiniBar.dp(getContext(), rDp));
        return d;
    }

    private TextView tv(String s, float sp, int color) {
        TextView t = new TextView(getContext());
        t.setText(s);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, sp);
        t.setTextColor(color);
        t.setIncludeFontPadding(false);
        return t;
    }

    /** 按钮的**点击区域**要够大 —— 太小的话手指总点不中（主人报过"按钮不生效"）。 */
    private static final int BTN_H = 38;

    private TextView btn(String s, float sp, final String tag, final Runnable r) {
        TextView t = tv(s, sp, C_TXT);
        t.setGravity(Gravity.CENTER);
        t.setSingleLine(true);
        // ★ 撑大点击区：左右各 4dp 内边距 + 固定高度
        int p = GmMiniBar.dp(getContext(), 4);
        t.setPadding(p, 0, p, 0);
        t.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    GmUtil.log("【GmMiniBar】👆 点了 " + tag);
                    r.run();
                } catch (Throwable e) {
                    GmUtil.logFail("【GmMiniBar】按钮失败 " + tag, e);
                }
            }
        });
        return t;
    }

    /** 老签名的快捷方式（不需要单独的日志 tag）。 */
    private TextView btn(String s, float sp, final Runnable r) {
        return btn(s, sp, s, r);
    }

    /** 包裹权重：宽度按权重分，**高度固定**（免得点击区被挤成一行字）。 */
    private LinearLayout.LayoutParams w(LinearLayout.LayoutParams p, float weight) {
        p.width = 0;
        p.weight = weight;
        p.height = GmMiniBar.dp(getContext(), BTN_H);
        p.topMargin = GmMiniBar.dp(getContext(), 2);
        p.bottomMargin = GmMiniBar.dp(getContext(), 2);
        return p;
    }

    private static GmMusicPlayer pl() {
        return GmMusicPlayer.get();
    }

    // ══════════════════════════════ 构造 ══════════════════════════════

    private void build() {
        Context c = getContext();
        GradientDrawable card = round(C_CARD, CARD_R);
        card.setStroke(GmMiniBar.dp(c, 1), 0x33FFFFFF);
        setBackground(card);
        setClipToPadding(false);

        // ★★ 2026-10-06 修「按钮不生效」：
        //   ① 根布局 setClickable(true) —— 让卡片是个**实体**，
        //      落在卡片上的触摸不会穿透到下面宿主的界面
        //   ② setFilterTouchesWhenObscured(false) —— 免得某些情况下
        //      系统认为"被遮挡"而把触摸吞掉
        setClickable(true);
        setFocusable(true);
        try {
            setFilterTouchesWhenObscured(false);
        } catch (Throwable ignore) {
        }

        pagePlay = new FrameLayout(c);
        buildPlayPage(pagePlay);
        addView(pagePlay, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));

        pageSearch = new FrameLayout(c);
        buildSearchPage(pageSearch);
        pageSearch.setVisibility(GONE);
        addView(pageSearch, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));

        // 四角拉伸
        for (int i = 0; i < 4; i++) {
            TextView h = tv(String.valueOf((char) CORNER_SYM[i]), 9, 0x66FFFFFF);
            h.setGravity(Gravity.CENTER);
            h.setOnTouchListener(new Resize(i));
            FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                    GmMiniBar.dp(c, 26), GmMiniBar.dp(c, 26));
            switch (i) {
                case 0: lp.gravity = Gravity.TOP | Gravity.START; break;
                case 1: lp.gravity = Gravity.TOP | Gravity.END; break;
                case 2: lp.gravity = Gravity.BOTTOM | Gravity.START; break;
                default: lp.gravity = Gravity.BOTTOM | Gravity.END; break;
            }
            addView(h, lp);
        }
    }

    // ───────────── 播放页 ─────────────

    private void buildPlayPage(FrameLayout root) {
        Context c = getContext();
        int gap = GmMiniBar.dp(c, 6);

        LinearLayout content = new LinearLayout(c);
        content.setOrientation(LinearLayout.HORIZONTAL);
        content.setPadding(gap, gap, gap, gap);

        // 左列：封面 / UI控件
        LinearLayout left = new LinearLayout(c);
        left.setOrientation(LinearLayout.VERTICAL);

        FrameLayout pCover = panel();
        vCover = new ImageView(c);
        vCover.setScaleType(ImageView.ScaleType.CENTER_CROP);
        vCover.setBackground(round(C_PANEL, PANEL_R));
        try {
            vCover.setClipToOutline(true);
        } catch (Throwable ignore) {
        }
        pCover.addView(vCover, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        LinearLayout.LayoutParams lpCover =
                new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1.15f);
        lpCover.bottomMargin = gap;
        left.addView(pCover, lpCover);

        FrameLayout pCtl = panel();
        LinearLayout ctl = new LinearLayout(c);
        ctl.setOrientation(LinearLayout.VERTICAL);
        ctl.setPadding(GmMiniBar.dp(c, 6), GmMiniBar.dp(c, 6), GmMiniBar.dp(c, 6), GmMiniBar.dp(c, 4));

        LinearLayout rowSeek = new LinearLayout(c);
        rowSeek.setOrientation(LinearLayout.HORIZONTAL);
        rowSeek.setGravity(Gravity.CENTER_VERTICAL);
        vPos = tv("0:00", 9, C_SUB);
        rowSeek.addView(vPos);
        vSeek = new SeekBar(c);
        vSeek.setMax(1000);
        vSeek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar sb, int prog, boolean fromUser) {
                if (fromUser && curDur > 0) vPos.setText(fmt(curDur * prog / 1000));
            }

            @Override
            public void onStartTrackingTouch(SeekBar sb) {
                seekTouching = true;
            }

            @Override
            public void onStopTrackingTouch(SeekBar sb) {
                seekTouching = false;
                if (curDur > 0 && pl() != null) pl().seekTo(curDur * sb.getProgress() / 1000);
            }
        });
        rowSeek.addView(vSeek, new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        vDur = tv("0:00", 9, C_SUB);
        rowSeek.addView(vDur);
        ctl.addView(rowSeek);

        LinearLayout rowBtn = new LinearLayout(c);
        rowBtn.setOrientation(LinearLayout.HORIZONTAL);
        rowBtn.setGravity(Gravity.CENTER_VERTICAL);

        vBtnNote = btn("\u266A", 13, new Runnable() {         // ♪ → 切到搜索页
            @Override
            public void run() {
                showSearchPage(true);
            }
        });
        vBtnNote.setTextColor(C_ACC);
        rowBtn.addView(vBtnNote, w(new LinearLayout.LayoutParams(0, 26), 1f));

        rowBtn.addView(btn("\u25C0\u25C0", 11, new Runnable() {
            @Override
            public void run() {
                if (pl() != null) pl().prev();
            }
        }), w(new LinearLayout.LayoutParams(0, 26), 1f));

        vBtnPlay = btn("\u25B6", 14, new Runnable() {
            @Override
            public void run() {
                if (pl() != null) pl().toggle();
            }
        });
        rowBtn.addView(vBtnPlay, w(new LinearLayout.LayoutParams(0, 26), 1f));

        rowBtn.addView(btn("\u25B6\u25B6", 11, new Runnable() {
            @Override
            public void run() {
                if (pl() != null) pl().next();
            }
        }), w(new LinearLayout.LayoutParams(0, 26), 1f));

        vBtnLoop = btn("\u21BB", 12, new Runnable() {
            @Override
            public void run() {
                if (pl() != null) pl().setLoop((pl().state().loop + 1) % 3);
            }
        });
        rowBtn.addView(vBtnLoop, w(new LinearLayout.LayoutParams(0, 26), 1f));

        ctl.addView(rowBtn);
        pCtl.addView(ctl, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        left.addView(pCtl, new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 0, 1.0f));

        content.addView(left, new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.MATCH_PARENT, 1f));

        // 右列：曲名&歌手 / 歌词
        LinearLayout right = new LinearLayout(c);
        right.setOrientation(LinearLayout.VERTICAL);

        FrameLayout pInfo = panel();
        LinearLayout info = new LinearLayout(c);
        info.setOrientation(LinearLayout.HORIZONTAL);
        info.setGravity(Gravity.CENTER_VERTICAL);
        info.setPadding(GmMiniBar.dp(c, 6), GmMiniBar.dp(c, 4), GmMiniBar.dp(c, 6), GmMiniBar.dp(c, 4));

        TextView handle = tv("\u2261", 13, C_SUB);
        handle.setGravity(Gravity.CENTER);
        handle.setClickable(true);
        handle.setOnTouchListener(new Drag());
        info.addView(handle, new LinearLayout.LayoutParams(GmMiniBar.dp(c, 30),
                LinearLayout.LayoutParams.MATCH_PARENT));

        LinearLayout tbox = new LinearLayout(c);
        tbox.setOrientation(LinearLayout.VERTICAL);
        tbox.setGravity(Gravity.CENTER_VERTICAL);
        vTitle = tv("未在播放", 12, C_TXT);
        vTitle.setSingleLine(true);
        vTitle.setEllipsize(TextUtils.TruncateAt.END);
        vArtist = tv("点 ♪ 去选歌", 9, C_SUB);
        vArtist.setSingleLine(true);
        vArtist.setEllipsize(TextUtils.TruncateAt.END);
        tbox.addView(vTitle);
        tbox.addView(vArtist);
        LinearLayout.LayoutParams lpBox = new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.WRAP_CONTENT, 1f);
        lpBox.leftMargin = GmMiniBar.dp(c, 2);
        info.addView(tbox, lpBox);

        TextView close = tv("\u2715", 11, C_SUB);
        close.setGravity(Gravity.CENTER);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                GmMiniBar.closeSession();
            }
        });
        info.addView(close, new LinearLayout.LayoutParams(GmMiniBar.dp(c, 34),
                LinearLayout.LayoutParams.MATCH_PARENT));

        pInfo.addView(info, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        LinearLayout.LayoutParams lpInfo = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, GmMiniBar.dp(c, 46));
        lpInfo.bottomMargin = gap;
        right.addView(pInfo, lpInfo);

        FrameLayout pLrc = panel();
        vLyricScroll = new ScrollView(c);
        vLyricBox = new LinearLayout(c);
        vLyricBox.setOrientation(LinearLayout.VERTICAL);
        vLyricBox.setPadding(GmMiniBar.dp(c, 8), GmMiniBar.dp(c, 6),
                GmMiniBar.dp(c, 8), GmMiniBar.dp(c, 6));
        vLyricScroll.addView(vLyricBox);
        pLrc.addView(vLyricScroll, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        right.addView(pLrc, new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 0, 1.0f));

        content.addView(right, new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.MATCH_PARENT, 1f));

        root.addView(content, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));

        setLyricHint("——");
    }

    // ───────────── 搜索页 ─────────────

    private void buildSearchPage(FrameLayout root) {
        Context c = getContext();
        int gap = GmMiniBar.dp(c, 6);

        LinearLayout col = new LinearLayout(c);
        col.setOrientation(LinearLayout.VERTICAL);
        col.setPadding(gap, gap, gap, gap);

        // 第一行：输入框 + 搜 + 返回
        LinearLayout row = new LinearLayout(c);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);

        vKw = new EditText(c);
        vKw.setHint("搜歌 / 歌手");
        vKw.setHintTextColor(C_SUB);
        vKw.setTextColor(C_TXT);
        vKw.setTextSize(TypedValue.COMPLEX_UNIT_SP, 11);
        vKw.setSingleLine(true);
        vKw.setBackground(round(C_PANEL, PANEL_R));
        vKw.setPadding(GmMiniBar.dp(c, 8), GmMiniBar.dp(c, 6),
                GmMiniBar.dp(c, 8), GmMiniBar.dp(c, 6));
        vKw.setImeOptions(EditorInfo.IME_ACTION_SEARCH);
        vKw.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, android.view.KeyEvent e) {
                doSearch();
                return true;
            }
        });
        row.addView(vKw, new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.WRAP_CONTENT, 1f));

        row.addView(btn("搜", 12, new Runnable() {
            @Override
            public void run() {
                doSearch();
            }
        }), lpDp(c, 34, 30));

        row.addView(btn("\u2715", 11, new Runnable() {
            @Override
            public void run() {
                showSearchPage(false);
            }
        }), lpDp(c, 30, 30));
        col.addView(row);

        // 列表标题（搜索 / 队列 切换）
        LinearLayout rowTitle = new LinearLayout(c);
        rowTitle.setOrientation(LinearLayout.HORIZONTAL);
        rowTitle.setGravity(Gravity.CENTER_VERTICAL);
        vListTitle = tv("搜索结果", 10, C_SUB);
        rowTitle.addView(vListTitle, new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        rowTitle.addView(btn("\u21C4 队列", 10, new Runnable() {
            @Override
            public void run() {
                showQueue = !showQueue;
                refreshList();
            }
        }));
        LinearLayout.LayoutParams lpTitle = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lpTitle.topMargin = GmMiniBar.dp(c, 4);
        col.addView(rowTitle, lpTitle);

        // 列表
        FrameLayout pList = panel();
        vListScroll = new ScrollView(c);
        vListBox = new LinearLayout(c);
        vListBox.setOrientation(LinearLayout.VERTICAL);
        vListBox.setPadding(GmMiniBar.dp(c, 6), GmMiniBar.dp(c, 4),
                GmMiniBar.dp(c, 6), GmMiniBar.dp(c, 4));
        vListScroll.addView(vListBox);
        pList.addView(vListScroll, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        LinearLayout.LayoutParams lpList = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f);
        lpList.topMargin = GmMiniBar.dp(c, 4);
        col.addView(pList, lpList);

        root.addView(col, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
    }

    private LinearLayout.LayoutParams lpDp(Context c, int wDp, int hDp) {
        LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(
                GmMiniBar.dp(c, wDp), GmMiniBar.dp(c, BTN_H));
        p.leftMargin = GmMiniBar.dp(c, 4);
        return p;
    }

    /** ★ 触摸到达卡片的证据（限流：2 秒最多一条）——定位"按钮不生效"用。 */
    private long lastTouchLog = 0L;

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        try {
            if (ev.getActionMasked() == MotionEvent.ACTION_DOWN) {
                long now = System.currentTimeMillis();
                if (now - lastTouchLog > 2000) {
                    lastTouchLog = now;
                    GmUtil.log("【GmMiniBar】👋 触摸到达卡片 ("
                            + (int) ev.getX() + "," + (int) ev.getY() + ")"
                            + " 位置=(" + GmMiniBar.px2dp(getContext(), getX())
                            + "," + GmMiniBar.px2dp(getContext(), getY()) + ")dp"
                            + " 尺寸=" + GmMiniBar.px2dp(getContext(), getWidth())
                            + "×" + GmMiniBar.px2dp(getContext(), getHeight()) + "dp");
                }
            }
        } catch (Throwable ignore) {
        }
        return super.dispatchTouchEvent(ev);
    }

    private void showSearchPage(boolean search) {
        try {
            pagePlay.setVisibility(search ? GONE : VISIBLE);
            pageSearch.setVisibility(search ? VISIBLE : GONE);
            if (search) {
                refreshList();
                vKw.requestFocus();
                InputMethodManager imm = (InputMethodManager)
                        getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                if (imm != null) imm.showSoftInput(vKw, InputMethodManager.SHOW_IMPLICIT);
            } else {
                InputMethodManager imm = (InputMethodManager)
                        getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                if (imm != null) imm.hideSoftInputFromWindow(vKw.getWindowToken(), 0);
            }
        } catch (Throwable t) {
            GmUtil.logFail("【GmMiniBar】切页失败", t);
        }
    }

    private void doSearch() {
        final String kw = vKw.getText().toString().trim();
        if (kw.length() == 0 || searching) return;
        if (pl() == null) return;
        searching = true;
        vListTitle.setText("搜索中…");
        pl().search(kw, 20, new GmMusicPlayer.Cb<List<GmMusicPlayer.Track>>() {
            @Override
            public void on(List<GmMusicPlayer.Track> v) {
                searching = false;
                results = v == null ? new ArrayList<GmMusicPlayer.Track>() : v;
                showQueue = false;
                refreshList();
            }
        });
    }

    private void refreshList() {
        try {
            vListBox.removeAllViews();
            Context c = getContext();
            if (showQueue) {
                List<GmMusicPlayer.Track> q = pl() == null
                        ? new ArrayList<GmMusicPlayer.Track>() : pl().queue();
                vListTitle.setText("播放队列（" + q.size() + "）");
                if (q.isEmpty()) {
                    vListBox.addView(hintRow("队列是空的"));
                    return;
                }
                for (int i = 0; i < q.size(); i++) {
                    final int ii = i;
                    vListBox.addView(row(q.get(i), String.valueOf(i + 1), new Runnable() {
                        @Override
                        public void run() {
                            if (pl() != null) pl().playAt(ii);
                        }
                    }, new Runnable() {
                        @Override
                        public void run() {
                            if (pl() != null) pl().removeAt(ii);
                            refreshList();
                        }
                    }, c));
                }
            } else {
                vListTitle.setText(results.isEmpty() ? "搜索结果" : "搜索结果（" + results.size() + "）");
                if (results.isEmpty()) {
                    vListBox.addView(hintRow(searching ? "搜着呢…" : "搜一首吧"));
                    return;
                }
                for (GmMusicPlayer.Track t : results) {
                    vListBox.addView(row(t, "\u25B6", new Runnable() {
                        @Override
                        public void run() {
                        }
                    }, null, c));
                }
                // 上面那个是占位，重新逐行绑（要捕获 track）
                vListBox.removeAllViews();
                for (final GmMusicPlayer.Track t : results) {
                    vListBox.addView(row(t, "\u25B6", new Runnable() {
                        @Override
                        public void run() {
                            if (pl() != null) pl().play(t);   // 点一下就开始放
                            showSearchPage(false);
                        }
                    }, new Runnable() {
                        @Override
                        public void run() {
                            if (pl() != null) pl().enqueue(t);   // ＋ 入队
                            refreshList();
                        }
                    }, c));
                }
            }
        } catch (Throwable t) {
            GmUtil.logFail("【GmMiniBar】刷新列表失败", t);
        }
    }

    private TextView hintRow(String s) {
        TextView t = tv(s, 10, C_SUB);
        t.setPadding(0, GmMiniBar.dp(getContext(), 6), 0, 0);
        return t;
    }

    /** 列表一行：符号 + 歌名/歌手 + 右侧动作。 */
    private LinearLayout row(final GmMusicPlayer.Track t, String sym,
                             final Runnable onClick, final Runnable onRight, Context c) {
        LinearLayout r = new LinearLayout(c);
        r.setOrientation(LinearLayout.HORIZONTAL);
        r.setGravity(Gravity.CENTER_VERTICAL);
        int p = GmMiniBar.dp(c, 3);
        r.setPadding(p, p, p, p);
        r.setBackground(round(0x14FFFFFF, 8));

        TextView s = tv(sym, 10, C_ACC);
        s.setGravity(Gravity.CENTER);
        r.addView(s, new LinearLayout.LayoutParams(GmMiniBar.dp(c, 18),
                LinearLayout.LayoutParams.WRAP_CONTENT));

        LinearLayout box = new LinearLayout(c);
        box.setOrientation(LinearLayout.VERTICAL);
        TextView n = tv(t.name, 11, C_TXT);
        n.setSingleLine(true);
        n.setEllipsize(TextUtils.TruncateAt.END);
        TextView a = tv(t.artist, 9, C_SUB);
        a.setSingleLine(true);
        a.setEllipsize(TextUtils.TruncateAt.END);
        box.addView(n);
        box.addView(a);
        LinearLayout.LayoutParams lb = new LinearLayout.LayoutParams(0,
                LinearLayout.LayoutParams.WRAP_CONTENT, 1f);
        lb.leftMargin = GmMiniBar.dp(c, 4);
        r.addView(box, lb);

        if (onRight != null) {
            TextView plus = tv("\uFF0B", 12, C_ACC);
            plus.setGravity(Gravity.CENTER);
            plus.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try {
                        onRight.run();
                    } catch (Throwable ignore) {
                    }
                }
            });
            r.addView(plus, new LinearLayout.LayoutParams(GmMiniBar.dp(c, 34),
                    GmMiniBar.dp(c, BTN_H)));
        }

        if (onClick != null) {
            r.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try {
                        onClick.run();
                    } catch (Throwable ignore) {
                    }
                }
            });
        }
        return r;
    }

    // ══════════════════════════════ 状态刷新（播放器直接回调） ══════════════════════════════

    void applyState(GmMusicPlayer.State s) {
        try {
            if (s == null) return;
            GmMusicPlayer.Track t = s.track;
            boolean has = t != null;
            vTitle.setText(has ? t.name : "未在播放");
            vArtist.setText(has ? (t.artist.length() == 0 ? "—" : t.artist)
                    : (s.preparing ? "加载中…" : "点 ♪ 去选歌"));
            if (s.error != null && s.error.length() > 0) vArtist.setText(s.error);

            vBtnLoop.setText(s.loop == GmMusicPlayer.LOOP_ONE ? "\u2460"
                    : (s.loop == GmMusicPlayer.LOOP_SHUFFLE ? "\u2936" : "\u21BB"));
            vBtnPlay.setText(s.playing ? "\u275A\u275A" : "\u25B6");

            curDur = s.dur;
            vDur.setText(fmt(s.dur));
            if (!seekTouching) {
                vPos.setText(fmt(s.pos));
                try {
                    vSeek.setProgress(s.dur > 0 ? (int) (1000L * s.pos / s.dur) : 0);
                } catch (Throwable ignore) {
                }
            }

            // 封面（由播放器联网，只在内存）
            if (has) ensureCover(t.id);
            else {
                coverWanted = -1L;
                vCover.setImageBitmap(null);
            }

            // 歌词（同上）
            if (has) ensureLyric(t.id);
            else {
                lrcId = -1L;
                setLyricHint("——");
            }

            highlight(s.pos);
        } catch (Throwable e) {
            GmUtil.logFail("【GmMiniBar】刷新失败", e);
        }
    }

    private void ensureCover(final long id) {
        if (coverWanted == id) return;
        coverWanted = id;
        vCover.setImageBitmap(null);
        GmMusicPlayer p = pl();
        if (p == null) return;
        p.cover(id, new GmMusicPlayer.Cb<Bitmap>() {
            @Override
            public void on(Bitmap b) {
                try {
                    if (coverWanted == id && b != null && vCover != null) {
                        vCover.setImageBitmap(b);
                    }
                } catch (Throwable ignore) {
                }
            }
        });
    }

    private void ensureLyric(final long id) {
        if (lrcId == id) return;
        lrcId = id;
        setLyricHint("歌词加载中…");
        GmMusicPlayer p = pl();
        if (p == null) return;
        p.lyric(id, new GmMusicPlayer.Cb<String>() {
            @Override
            public void on(String lrc) {
                try {
                    if (lrcId != id) return;
                    if (lrc == null || lrc.length() == 0) {
                        setLyricHint("这首歌没有歌词");
                    } else {
                        buildLyric(lrc);
                    }
                } catch (Throwable ignore) {
                }
            }
        });
    }

    private static String fmt(int ms) {
        if (ms <= 0) return "0:00";
        int s = ms / 1000;
        return String.format("%d:%02d", s / 60, s % 60);
    }

    private void setLyricHint(String s) {
        try {
            vLyricBox.removeAllViews();
            lrcViews.clear();
            lrcMs.clear();
            curLine = -1;
            TextView t = tv(s, 10, C_SUB);
            t.setGravity(Gravity.CENTER);
            t.setPadding(0, GmMiniBar.dp(getContext(), 12), 0, 0);
            vLyricBox.addView(t);
        } catch (Throwable ignore) {
        }
    }

    private void buildLyric(String src) {
        try {
            vLyricBox.removeAllViews();
            lrcViews.clear();
            lrcMs.clear();
            curLine = -1;
            Object[] p = GmMusicPlayer.parseLrc(src);
            long[] ms = (long[]) p[0];
            String[] tx = (String[]) p[1];
            if (ms.length == 0) {
                setLyricHint("这首歌没有歌词");
                return;
            }
            int dp2 = GmMiniBar.dp(getContext(), 2);
            for (int i = 0; i < ms.length; i++) {
                final long at = ms[i];
                TextView t = tv(tx[i], 10, C_SUB);
                t.setPadding(0, dp2, 0, dp2);
                t.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        GmMusicPlayer pp = pl();
                        if (pp != null) pp.seekTo((int) at);      // 点歌词 = 跳过去
                    }
                });
                vLyricBox.addView(t, new LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT));
                lrcViews.add(t);
                lrcMs.add(Long.valueOf(at));
            }
        } catch (Throwable t) {
            GmUtil.logFail("【GmMiniBar】铺歌词失败", t);
        }
    }

    private void highlight(int pos) {
        if (lrcMs.isEmpty()) return;
        int idx = -1;
        for (int i = 0; i < lrcMs.size(); i++) {
            if (lrcMs.get(i).longValue() <= pos) idx = i;
            else break;
        }
        if (idx == curLine) return;
        curLine = idx;
        try {
            for (int i = 0; i < lrcViews.size(); i++) {
                TextView t = lrcViews.get(i);
                boolean on = (i == idx);
                t.setTextColor(on ? C_ACC : C_SUB);
                t.setTextSize(TypedValue.COMPLEX_UNIT_SP, on ? 11.5f : 10f);
            }
            if (idx >= 0 && idx < lrcViews.size()) {
                final int top = lrcViews.get(idx).getTop();
                final View tv2 = lrcViews.get(idx);
                vLyricScroll.post(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            int h = vLyricScroll.getHeight();
                            int th = tv2.getHeight();
                            vLyricScroll.smoothScrollTo(0, Math.max(0, top - h / 2 + th / 2));
                        } catch (Throwable ignore) {
                        }
                    }
                });
            }
        } catch (Throwable ignore) {
        }
    }

    // ══════════════════════════════ 初始摆放 ══════════════════════════════

    void bootstrap() {
        post(new Runnable() {
            @Override
            public void run() {
                try {
                    Context c = getContext();
                    View p = (View) getParent();
                    int ph = p == null ? 0 : p.getHeight();
                    int y = GmMiniBar.loadY(-1);
                    if (y < 0) {
                        // ★★ 2026-10-06 修「按钮不生效」：
                        //   原来贴底只留 24dp ⇒ **按钮行正好落在系统手势导航区里**，
                        //   触摸被系统接走（看着就像按钮坏了）。
                        //   改成**上抬 96dp**，稳稳避开手势区。
                        setY(ph > 0 ? Math.max(0, ph - getHeight() - GmMiniBar.dp(c, 96))
                                : GmMiniBar.dp(c, 360));
                    } else {
                        setY(GmMiniBar.dp(c, y));
                    }
                    int x = GmMiniBar.loadX(-1);
                    setX(x < 0 ? GmMiniBar.dp(c, 10) : GmMiniBar.dp(c, x));
                    clamp();
                    post(new Runnable() {
                        @Override
                        public void run() {
                            clamp();
                        }
                    });
                } catch (Throwable ignore) {
                }
            }
        });
    }

    private void clamp() {
        try {
            View p = (View) getParent();
            if (p == null) return;
            int pw = p.getWidth(), ph = p.getHeight();
            if (pw <= 0 || ph <= 0) return;
            float x = getX(), y = getY(), w = getWidth(), h = getHeight();
            float maxX = Math.max(0, pw - w), maxY = Math.max(0, ph - h);
            if (x < 0) x = 0;
            if (x > maxX) x = maxX;
            if (y < 0) y = 0;
            if (y > maxY) y = maxY;
            setX(x);
            setY(y);
        } catch (Throwable ignore) {
        }
    }

    // ══════════════════════════════ 拖动 ══════════════════════════════

    private final class Drag implements View.OnTouchListener {
        private float rx, ry;
        private int sx, sy;

        @Override
        public boolean onTouch(View v, MotionEvent e) {
            try {
                switch (e.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        sx = (int) getX();
                        sy = (int) getY();
                        rx = e.getRawX();
                        ry = e.getRawY();
                        try {
                            ViewGroup par = (ViewGroup) getParent();
                            if (par != null) par.requestDisallowInterceptTouchEvent(true);
                        } catch (Throwable ignore) {
                        }
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        setX(sx + (e.getRawX() - rx));      // 横竖都能拖
                        setY(sy + (e.getRawY() - ry));
                        return true;
                    case MotionEvent.ACTION_UP:
                    case MotionEvent.ACTION_CANCEL:
                        try {
                            ViewGroup par = (ViewGroup) getParent();
                            if (par != null) par.requestDisallowInterceptTouchEvent(false);
                        } catch (Throwable ignore) {
                        }
                        clamp();
                        GmMiniBar.savePos(GmMiniBar.px2dp(getContext(), getX()),
                                GmMiniBar.px2dp(getContext(), getY()));
                        return true;
                    default:
                        return false;
                }
            } catch (Throwable t) {
                GmUtil.logFail("【GmMiniBar】拖动失败", t);
                return false;
            }
        }
    }

    // ══════════════════════════════ 拉伸 ══════════════════════════════

    private final class Resize implements View.OnTouchListener {
        private final int corner;
        private float rx, ry;
        private int sx, sy, sw, sh;

        Resize(int corner) {
            this.corner = corner;
        }

        @Override
        public boolean onTouch(View v, MotionEvent e) {
            try {
                Context c = getContext();
                switch (e.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        rx = e.getRawX();
                        ry = e.getRawY();
                        sx = (int) getX();
                        sy = (int) getY();
                        sw = getWidth();
                        sh = getHeight();
                        try {
                            ViewGroup par = (ViewGroup) getParent();
                            if (par != null) par.requestDisallowInterceptTouchEvent(true);
                        } catch (Throwable ignore) {
                        }
                        return true;
                    case MotionEvent.ACTION_MOVE: {
                        float dx = e.getRawX() - rx, dy = e.getRawY() - ry;
                        boolean left = (corner == 0 || corner == 2);
                        boolean top = (corner == 0 || corner == 1);
                        int nw = (int) (left ? sw - dx : sw + dx);
                        int nh = (int) (top ? sh - dy : sh + dy);
                        int nx = sx, ny = sy;
                        int minW = GmMiniBar.dp(c, MIN_W), minH = GmMiniBar.dp(c, MIN_H);
                        int maxW = GmMiniBar.dp(c, MAX_W), maxH = GmMiniBar.dp(c, MAX_H);
                        if (nw < minW) {
                            if (left) nx = sx + (sw - minW);
                            nw = minW;
                        }
                        if (nh < minH) {
                            if (top) ny = sy + (sh - minH);
                            nh = minH;
                        }
                        if (nw > maxW) nw = maxW;
                        if (nh > maxH) nh = maxH;
                        setX(nx);
                        setY(ny);
                        ViewGroup.LayoutParams lp = getLayoutParams();
                        lp.width = nw;
                        lp.height = nh;
                        setLayoutParams(lp);
                        return true;
                    }
                    case MotionEvent.ACTION_UP:
                    case MotionEvent.ACTION_CANCEL:
                        try {
                            ViewGroup par = (ViewGroup) getParent();
                            if (par != null) par.requestDisallowInterceptTouchEvent(false);
                        } catch (Throwable ignore) {
                        }
                        clamp();
                        GmMiniBar.saveSize(GmMiniBar.px2dp(c, getWidth()),
                                GmMiniBar.px2dp(c, getHeight()),
                                GmMiniBar.px2dp(c, getX()), GmMiniBar.px2dp(c, getY()));
                        return true;
                    default:
                        return false;
                }
            } catch (Throwable t) {
                GmUtil.logFail("【GmMiniBar】拉伸失败", t);
                return false;
            }
        }
    }
}
