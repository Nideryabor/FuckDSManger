// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.util.List;

/**
 * 「回复建议条」的那个 View 🐲 2026-10-31
 *
 * <h3>它长什么样</h3>
 * 一排圆角小片（chip），靠右对齐（跟 AI 气泡一样在右边），内容多了可以横向滑。
 * 整条贴着屏幕底部往上 {@code 120dp}（大致是输入框上沿），**只占自己那一行的高度**，
 * 不挡别处 —— 外层 View 用 WRAP_CONTENT + 靠右，空白区不接事件。
 *
 * <h3>为什么用原生 View 而不是 Compose</h3>
 * <ul>
 *   <li>模块是纯 Java（javac 真编译），<b>写不了 @Composable</b>
 *       （Composable 的调用顺序由 compose 编译器在编译期算好，手写必然破坏 composition）；</li>
 *   <li>更要紧的是：{@code <Suggestion>} 原来那条路（塞进 AnnotatedString 的"可点击链接"）
 *       被 2.7.2 新增的 {@code InlineTextSelection} 手势层压住了 ⇒
 *       <b>必须换一个"摸得到"的载体</b>。我们自己的 View 在窗口里是独立的一层，事件先到它手里。</li>
 * </ul>
 *
 * <h3>保命规矩</h3>
 * 所有方法全 try/catch —— 这是挂在<b>宿主窗口</b>上的 View，抛一次就可能带崩宿主界面。
 */
final class GmSugBarView extends HorizontalScrollView {

    private final Handler ui = new Handler(Looper.getMainLooper());
    private final LinearLayout row;
    private int shownCount = 0;

    GmSugBarView(Context c) {
        super(c);
        setHorizontalScrollBarEnabled(false);
        setOverScrollMode(View.OVER_SCROLL_NEVER);
        setClipToPadding(false);
        setFillViewport(false);

        row = new LinearLayout(c);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        addView(row, new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        setVisibility(GONE);
    }

    boolean shown() {
        return shownCount > 0 && getVisibility() == VISIBLE;
    }

    void scheduleAutoHide(long ms) {
        ui.removeCallbacks(hideTask);
        if (ms > 0) ui.postDelayed(hideTask, ms);
    }

    private final Runnable hideTask = new Runnable() {
        @Override
        public void run() {
            try {
                GmUtil.log("【GmSugBar】超时自动收起（不影响已经发出去的消息）");
                GmSugBar.dismissByUser();
            } catch (Throwable ignore) {
            }
        }
    };

    void clearChips() {
        Runnable r = new Runnable() {
            @Override
            public void run() {
                try {
                    row.removeAllViews();
                    shownCount = 0;
                    setVisibility(GONE);
                } catch (Throwable t) {
                    GmUtil.logFail("【GmSugBar】clearChips", t);
                }
            }
        };
        if (Looper.myLooper() == Looper.getMainLooper()) r.run();
        else ui.post(r);
    }

    /**
     * 换上一组建议。
     *
     * <p>⚠️ 只在<b>主线程</b>动 View；不是主线程就 post 回去
     * （{@link GmRichTextHook} 跑在 Compose 的组合里，但那不保证等于 main looper）。
     */
    void setChips(final List<GmSugBar.Chip> chips) {
        if (chips == null || chips.isEmpty()) {
            clearChips();
            return;
        }
        Runnable r = new Runnable() {
            @Override
            public void run() {
                try {
                    row.removeAllViews();
                    Context c = getContext();
                    for (int i = 0; i < chips.size(); i++) {
                        row.addView(makeChip(c, chips.get(i)));
                    }
                    shownCount = chips.size();
                    setVisibility(VISIBLE);
                } catch (Throwable t) {
                    GmUtil.logFail("【GmSugBar】setChips", t);
                }
            }
        };
        if (Looper.myLooper() == Looper.getMainLooper()) r.run();
        else ui.post(r);
    }

    // ══════════════════════════════ 一个 chip ══════════════════════════════

    private View makeChip(Context c, final GmSugBar.Chip chip) {
        TextView tv = new TextView(c);
        tv.setText(chip.label);
        tv.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f);
        tv.setTextColor(0xFFEDEDED);
        tv.setSingleLine(true);
        tv.setEllipsize(TextUtils.TruncateAt.END);
        tv.setGravity(Gravity.CENTER);
        tv.setMaxWidth(dp(c, 240));

        int padH = dp(c, 14), padV = dp(c, 8);
        tv.setPadding(padH, padV, padH, padV);

        // 圆角底：半透明深色 + 一圈很淡的描边（跟宿主暗色输入区搭得住）
        GradientDrawable bg = new GradientDrawable();
        bg.setShape(GradientDrawable.RECTANGLE);
        bg.setCornerRadius(dp(c, 18));
        bg.setColor(0xE6222226);
        bg.setStroke(Math.max(1, dp(c, 1)), 0x33FFFFFF);
        tv.setBackground(bg);

        // 按下给一点反馈（不用 ripple，避免依赖主题资源）
        tv.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    v.setAlpha(0.55f);
                    v.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                v.setAlpha(1f);
                            } catch (Throwable ignore) {
                            }
                        }
                    }, 90);
                } catch (Throwable ignore) {
                }
                GmSugBar.onTap(chip);
            }
        });

        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.setMargins(dp(c, 5), 0, dp(c, 5), 0);
        tv.setLayoutParams(lp);
        return tv;
    }

    private int dp(Context c, int v) {
        try {
            return (int) (v * c.getResources().getDisplayMetrics().density + 0.5f);
        } catch (Throwable t) {
            return v;
        }
    }
}
