// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.text.InputType;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * 便签的**外观与手感** 🐲（纯代码画出来的 View，零资源依赖）
 *
 * ── 为什么要「纯代码画」────────────────────────────────────────
 *   我们这个 dex 里**没有资源表**（资源全在宿主那边）。所以不能用
 *   `R.drawable.xxx` / layout XML —— 一用就是 `Resources$NotFoundException`。
 *   圆角底 → `GradientDrawable`（代码构造）；图标 → 用**纯几何符号**当文字
 *   （主人 2026-10-06 定的：`＋ ‹ › － ▣ ✕ ≡`，不用 Emoji —— Emoji 各家 ROM 肥瘦不一）。
 *
 * ── 布局 ────────────────────────────────────────────────────
 *   <pre>
 *   ┌──────────────────────────────┐
 *   │ ≡   ＋  ‹ 1/3 ›  －  ▣  ✕     │  ← 顶栏；只有 ≡ 是「拖动把手」
 *   ├──────────────────────────────┤
 *   │  便签正文（点一下就地变输入框）  │
 *   └──────────────────────────────┘
 *   最小化形态 = 一颗圆球（点它回来）
 *   </pre>
 *
 * ── 「拖动把手」为什么不整条顶栏都能拖 ──────────────────────────
 *   整条能拖 ⇒ 点「＋」时手一抖就被判成拖动（Android 的 touch slop），
 *   按钮会时灵时不灵。把拖动**收进 ≡ 那一小块**就没这问题（主人 2026-10-06 拍板）。
 */
final class GmNoteView extends FrameLayout {

    /** 卡片宽（dp）。高度由正文区决定。 */
    private static final int CARD_W = 250;
    private static final int TEXT_H = 150;
    private static final int BALL_D = 54;

    private static final int C_BTN = 0xDD2B2B2B;
    private static final int C_TXT = 0xFF1B1B1B;
    private static final int C_SUB = 0x99_1B1B1B;

    /** Drag 的两种用法：把手（拖完就完）／圆球（拖完还会判「点」= 还原）。 */
    private static final int HANDLE = 0;
    private static final int BALL_IS_BALL = 1;

    private final Activity act;

    private LinearLayout card;
    private TextView ball;
    private TextView counter;
    private EditText edit;

    /** 正在就地编辑？—— 用来挡住 refreshAll 覆盖用户正在敲的字。 */
    private boolean editing = false;

    GmNoteView(Activity act) {
        super(act);
        this.act = act;
        setClipChildren(false);
        setClipToPadding(false);
        buildCard();
        buildBall();
        refreshAll();
    }

    // ══════════════════════════════ 构造 ══════════════════════════════

    private void buildCard() {
        Context c = getContext();
        card = new LinearLayout(c);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(GmNote.dp(c, 8), GmNote.dp(c, 4), GmNote.dp(c, 8), GmNote.dp(c, 8));

        // ── 顶栏 ──
        LinearLayout bar = new LinearLayout(c);
        bar.setOrientation(LinearLayout.HORIZONTAL);
        bar.setGravity(Gravity.CENTER_VERTICAL);

        TextView handle = mkBtn("≡", null);
        handle.setContentDescription("拖动");
        handle.setClickable(true);
        handle.setOnTouchListener(new Drag(HANDLE));       // ★ 只有它是拖动把手
        bar.addView(handle, lp(GmNote.dp(c, 30), GmNote.dp(c, 26)));

        View sp = new View(c);
        bar.addView(sp, new LinearLayout.LayoutParams(0, 1, 1f));

        bar.addView(mkBtn("＋", new Runnable() {
            @Override public void run() { doAdd(); }
        }), lp(GmNote.dp(c, 26), GmNote.dp(c, 26)));

        bar.addView(mkBtn("‹", new Runnable() {
            @Override public void run() { commitEdit(); GmNote.setIdx(GmNote.curIdx() - 1); refreshAll(); }
        }), lp(GmNote.dp(c, 22), GmNote.dp(c, 26)));

        counter = mkBtn("1/1", null);
        counter.setTextSize(TypedValue.COMPLEX_UNIT_SP, 11);
        counter.setTextColor(C_SUB);
        bar.addView(counter, lp(GmNote.dp(c, 34), GmNote.dp(c, 26)));

        bar.addView(mkBtn("›", new Runnable() {
            @Override public void run() { commitEdit(); GmNote.setIdx(GmNote.curIdx() + 1); refreshAll(); }
        }), lp(GmNote.dp(c, 22), GmNote.dp(c, 26)));

        bar.addView(mkBtn("－", new Runnable() {
            @Override public void run() { doDel(); }
        }), lp(GmNote.dp(c, 26), GmNote.dp(c, 26)));

        bar.addView(mkBtn("▣", new Runnable() {
            @Override public void run() { doMin(); }
        }), lp(GmNote.dp(c, 26), GmNote.dp(c, 26)));

        bar.addView(mkBtn("✕", new Runnable() {
            @Override public void run() { GmNote.closeSession(); }
        }), lp(GmNote.dp(c, 26), GmNote.dp(c, 26)));

        card.addView(bar, new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));

        // ── 正文（一个 EditText 走全场：不可编辑 ⇄ 就地编辑）──
        edit = new EditText(c);
        edit.setBackground(null);
        edit.setGravity(Gravity.TOP | Gravity.START);
        edit.setPadding(0, GmNote.dp(c, 6), 0, 0);
        edit.setTextColor(C_TXT);
        edit.setHint("点一下，写点什么…");
        edit.setHintTextColor(C_SUB);
        edit.setInputType(InputType.TYPE_CLASS_TEXT
                | InputType.TYPE_TEXT_FLAG_MULTI_LINE
                | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        edit.setImeOptions(EditorInfo.IME_FLAG_NO_EXTRACT_UI
                | EditorInfo.IME_ACTION_NONE);
        edit.setIncludeFontPadding(true);
        edit.setFocusable(false);
        edit.setFocusableInTouchMode(false);
        edit.setCursorVisible(false);
        edit.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                if (!editing) beginEdit();
            }
        });
        edit.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override public void onFocusChange(View v, boolean has) {
                if (!has) endEdit();
            }
        });
        card.addView(edit, new LinearLayout.LayoutParams(
                GmNote.dp(c, CARD_W - 16), GmNote.dp(c, TEXT_H)));

        addView(card, new LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT));
    }

    private void buildBall() {
        Context c = getContext();
        ball = new TextView(c);
        ball.setText("▤");
        ball.setTextSize(TypedValue.COMPLEX_UNIT_SP, 20);
        ball.setTextColor(C_TXT);
        ball.setGravity(Gravity.CENTER);
        ball.setIncludeFontPadding(false);
        ball.setContentDescription("便签");
        ball.setVisibility(GONE);
        // 圆球：既能拖，也能点（点 = 还原）
        ball.setOnTouchListener(new Drag(BALL_IS_BALL));
        addView(ball, new LayoutParams(GmNote.dp(c, BALL_D), GmNote.dp(c, BALL_D)));
    }

    private LinearLayout.LayoutParams lp(int w, int h) {
        return new LinearLayout.LayoutParams(w, h);
    }

    private TextView mkBtn(String s, final Runnable r) {
        Context c = getContext();
        TextView t = new TextView(c);
        t.setText(s);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15);
        t.setTextColor(C_BTN);
        t.setGravity(Gravity.CENTER);
        t.setSingleLine(true);
        t.setIncludeFontPadding(false);
        if (r != null) {
            t.setPadding(GmNote.dp(c, 2), GmNote.dp(c, 2), GmNote.dp(c, 2), GmNote.dp(c, 2));
            t.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {
                    try {
                        r.run();
                    } catch (Throwable t) {
                        GmUtil.logFail("【GmNote】按钮动作失败", t);
                    }
                }
            });
        }
        return t;
    }

    // ══════════════════════════════ 刷新 ══════════════════════════════

    /** 首次挂上：读位置（没放过就摆到右侧中央偏上）。 */
    void bootstrap() {
        refreshAll();
        post(new Runnable() {
            @Override public void run() {
                try {
                    int x = GmNote.curItem().optInt("x", -1);
                    int y = GmNote.curItem().optInt("y", -1);
                    Context c = getContext();
                    View p = (View) getParent();
                    int pw = p == null ? 0 : p.getWidth();
                    if (x < 0 || y < 0) {
                        setX(pw > 0 ? pw - getWidth() - GmNote.dp(c, 10) : GmNote.dp(c, 10));
                        setY(GmNote.dp(c, 140));
                    } else {
                        setX(GmNote.dp(c, x));
                        setY(GmNote.dp(c, y));
                    }
                    clamp();
                } catch (Throwable ignore) {
                }
            }
        });
    }

    /** 重读状态 + 配置，重画（**正在编辑时不覆盖用户敲的字**）。 */
    void refreshAll() {
        try {
            Context c = getContext();
            JSONObject st = GmNote.state();
            boolean min = st.optBoolean("min", false);
            int idx = GmNote.curIdx();
            int n = GmNote.total();

            counter.setText((idx + 1) + "/" + n);

            JSONObject it = GmNote.curItem();
            String t = it.optString("t", "");
            // ★ 2026-10-06 修：以前是 `!editing && …` —— 编辑中就不刷新。
            //   现在配合「切页前先 commitEdit()」：走到这儿 editing 一定是 false，
            //   所以**每次刷新都把 edit 同步成当前页的内容**，不会再串页。
            if (editing) {
                // 理论上不会进（切页前已落盘）；真进了说明有人漏了 commitEdit，
                // 这里**只记日志不动内容**（别把用户正在敲的字冲掉）
                GmUtil.log("【GmNote】⚠️ 刷新时仍在编辑中（有调用点漏了 commitEdit）");
            } else if (!t.equals(edit.getText().toString())) {
                edit.setText(t);
            }

            applyLook();

            card.setVisibility(min ? GONE : VISIBLE);
            ball.setVisibility(min ? VISIBLE : GONE);

            // 尺寸变了（最小化⇄还原）要重新 requestLayout
            requestLayout();
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】刷新失败", t);
        }
    }

    /** 底色 / 透明度 / 字号。 */
    private void applyLook() {
        Context c = getContext();
        int bg = GmNote.cfgBg(c);
        int alpha = GmNote.cfgAlpha(c);
        if (alpha < 0) alpha = 0;
        if (alpha > 255) alpha = 255;
        int color = (bg & 0x00FFFFFF) | ((alpha & 0xFF) << 24);

        GradientDrawable d = new GradientDrawable();
        d.setShape(GradientDrawable.RECTANGLE);
        d.setColor(color);
        d.setCornerRadius(GmNote.dp(c, 14));
        d.setStroke(GmNote.dp(c, 1), (color & 0x00FFFFFF) | 0x33000000);
        card.setBackground(d);

        GradientDrawable bd = new GradientDrawable();
        bd.setShape(GradientDrawable.OVAL);
        bd.setColor(color);
        bd.setStroke(GmNote.dp(c, 1), (color & 0x00FFFFFF) | 0x33000000);
        ball.setBackground(bd);

        edit.setTextSize(TypedValue.COMPLEX_UNIT_SP, GmNote.cfgSize(c));
    }

    // ══════════════════════════════ 就地编辑 ══════════════════════════════

    /**
     * 把当前编辑中的内容**落盘**（无论是否还在编辑）。
     *
     * <p>★ 2026-10-06 真机 bug 修：主人报
     * <pre>
     *   ① 「第一页的文字会覆盖后面页面的文字」
     *   ② 「保存必须使输入框失去焦点（点对话框）才能保存」
     * </pre>
     * 两个是**同一个根因**：切页/增删时走的是 {@link #refreshAll()}，
     * 而 `refreshAll` 只在 `!editing` 时才把 `edit` 换成新页内容 ——
     * 于是**没落盘的字**留在 `edit` 里，切到下一页再一敲，就落到新页上了。
     *
     * <p>正确姿势：**动当前页之前，先把当前页存了**。
     */
    private void commitEdit() {
        try {
            if (!editing) return;                 // 没在编辑 = 没有未落盘的东西
            editing = false;
            try {
                edit.setFocusable(false);
                edit.setFocusableInTouchMode(false);
                edit.setCursorVisible(false);
            } catch (Throwable ignore) {
            }
            GmNote.setText(edit.getText().toString());   // ★ 关键：先存
            GmUtil.log("【GmNote】落盘当前页（切页/增删前）");
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】落盘失败", t);
        }
    }

    private void beginEdit() {
        try {
            editing = true;
            edit.setFocusableInTouchMode(true);
            edit.setFocusable(true);
            edit.setCursorVisible(true);
            edit.requestFocus();
            int len = edit.getText().length();
            if (len >= 0) edit.setSelection(len);
            InputMethodManager imm = (InputMethodManager)
                    getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm != null) imm.showSoftInput(edit, InputMethodManager.SHOW_IMPLICIT);
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】进编辑失败", t);
        }
    }

    private void endEdit() {
        // 收到焦点就去（和 commitEdit 的区别只在这里：它会收键盘）
        if (!editing) return;
        commitEdit();
        try {
            InputMethodManager imm = (InputMethodManager)
                    getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm != null) imm.hideSoftInputFromWindow(edit.getWindowToken(), 0);
        } catch (Throwable ignore) {
        }
    }

    /**
     * 摘掉之前把没落盘的编辑存了（不然切页面/切 Activity 会丢字）。
     *
     * <p>★ 顺手改成走 {@link #commitEdit()} —— 它会**收键盘**（原来只存不收，
     * 摘掉视图后输入法可能还挂在窗口上）。
     */
    void saveNow() {
        try {
            commitEdit();
            try {
                InputMethodManager imm = (InputMethodManager)
                        getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                if (imm != null) imm.hideSoftInputFromWindow(edit.getWindowToken(), 0);
            } catch (Throwable ignore) {
            }
        } catch (Throwable ignore) {
        }
    }

    // ══════════════════════════════ 按钮动作 ══════════════════════════════

    private void doAdd() {
        commitEdit();                 // ★ 先存当前页，再新建
        GmNote.addItem();
        refreshAll();
        post(new Runnable() {
            @Override public void run() { beginEdit(); }
        });
    }

    private void doDel() {
        commitEdit();                 // ★ 先存当前页，再删
        GmNote.delItem();
        refreshAll();
    }

    private void doMin() {
        commitEdit();                 // ★ 先存（最小化也算"离开当前页"）
        GmNote.setMin(!GmNote.state().optBoolean("min", false));
        refreshAll();
    }

    // ══════════════════════════════ 拖动 / 边界 ══════════════════════════════

    /** 拖动（把手上用；圆球上兼做「点击=还原」）。 */
    private final class Drag implements View.OnTouchListener {
        private final int kind;
        private float rawX, rawY;
        private int startX, startY;
        private boolean moved;

        Drag(int kind) {
            this.kind = kind;
        }

        @Override
        public boolean onTouch(View v, MotionEvent e) {
            try {
                switch (e.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        startX = (int) getX();
                        startY = (int) getY();
                        rawX = e.getRawX();
                        rawY = e.getRawY();
                        moved = false;
                        // 别让宿主的可滑动容器（ViewPager / 侧滑返回）把这一串事件抢走
                        try {
                            ViewGroup par = (ViewGroup) getParent();
                            if (par != null) par.requestDisallowInterceptTouchEvent(true);
                        } catch (Throwable ignore) {
                        }
                        return true;
                    case MotionEvent.ACTION_MOVE: {
                        float nx = startX + (e.getRawX() - rawX);
                        float ny = startY + (e.getRawY() - rawY);
                        setX(nx);
                        setY(ny);
                        if (Math.abs(e.getRawX() - rawX) > GmNote.dp(getContext(), 6)
                                || Math.abs(e.getRawY() - rawY) > GmNote.dp(getContext(), 6)) {
                            moved = true;
                        }
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
                        GmNote.setPos(GmNote.px2dp(getContext(), getX()),
                                GmNote.px2dp(getContext(), getY()));
                        if (kind == BALL_IS_BALL && !moved) {
                            commitEdit();                    // ★ 还原前先存
                            GmNote.setMin(false);            // 点圆球 = 还原
                            refreshAll();
                        }
                        return true;
                    default:
                        return false;
                }
            } catch (Throwable t) {
                GmUtil.logFail("【GmNote】拖动失败", t);
                return false;
            }
        }
    }

    /** 别让它被拖出屏幕外（允许露出一半，够抓回来就行）。 */
    private void clamp() {
        try {
            View p = (View) getParent();
            if (p == null) return;
            int pw = p.getWidth();
            int ph = p.getHeight();
            if (pw <= 0 || ph <= 0) return;
            float w = getWidth();
            float h = getHeight();
            if (w <= 0 || h <= 0) return;
            float x = getX();
            float y = getY();
            float minX = -w * 0.5f;
            float maxX = pw - w * 0.5f;
            float minY = 0f;
            float maxY = ph - h * 0.5f;
            if (maxX < minX) maxX = minX;
            if (maxY < minY) maxY = minY;
            if (x < minX) x = minX;
            if (x > maxX) x = maxX;
            if (y < minY) y = minY;
            if (y > maxY) y = maxY;
            setX(x);
            setY(y);
        } catch (Throwable ignore) {
        }
    }
}
