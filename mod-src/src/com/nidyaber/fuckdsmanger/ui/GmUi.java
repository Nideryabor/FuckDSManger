package com.nidyaber.fuckdsmanger.ui;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.Switch;
import android.widget.TextView;

import com.varuns2002.disable_flag_secure.gm.GmUtil;

/**
 * GmUi —— 模块 UI 的工具箱（**真编译版**）🐲
 *
 * 为什么是"纯代码"而不是 layout 资源：
 *   我们的自造 APK 流水线里没有 aapt2（沙箱是 arm64，Google 只发 x86_64 的 aapt2），
 *   所以 layout / drawable / color 的 XML 编译不了。
 *   好在模块从 1.0.7 起就是**全程序化建 View**，这条路本来就走得通 —— 这里把它系统化。
 *
 * 配色不写死：全部走 GmUtil 的四件套（tx 主文字 / sub 次要 / bg 卡片 / line 分隔），
 * 它们自己会跟着宿主深浅色切换。
 *
 * 用法示例：
 * <pre>
 *   LinearLayout col = GmUi.column(ctx);
 *   col.addView(GmUi.title(ctx, "AI 气泡美化"));
 *   col.addView(GmUi.desc(ctx, "改的是「AI 那一侧」的气泡"));
 *   GmUi.SwitchRow r = GmUi.switchRow(ctx, "启用", on, listener);
 *   col.addView(r.row);
 *   col.addView(GmUi.menu(ctx, "调色板 ›", v -> { ... }));
 *   col.addView(GmUi.button(ctx, "关闭", v -> dlg.dismiss()));
 *   GmUi.attach(dlg, col);          // 自动套竖向滚动
 * </pre>
 */
public final class GmUi {

    /** 品牌强调色（宿主那个蓝），要覆盖按钮/选中态时用。 */
    public static final int ACCENT = 0xFF507BF2;

    private GmUi() {}

    // ------------------------------------------------------------ 基础

    /** 竖排容器：默认 16dp 内边距 + 卡片底色。 */
    public static LinearLayout column(Context c) {
        LinearLayout l = new LinearLayout(c);
        l.setOrientation(LinearLayout.VERTICAL);
        int p = GmUtil.dp(c, 16);
        l.setPadding(p, GmUtil.dp(c, 8), p, GmUtil.dp(c, 8));
        return l;
    }

    /** 圆角填充背景（radiusDp 用 dp，自动换算）。 */
    public static GradientDrawable round(Context c, int fill, int radiusDp) {
        GradientDrawable d = new GradientDrawable();
        d.setColor(fill);
        d.setCornerRadius(GmUtil.dp(c, radiusDp));
        return d;
    }

    /** 圆角 + 描边（"卡片"那种感觉）。 */
    public static GradientDrawable roundStroke(Context c, int fill, int radiusDp, int stroke, int strokeDp) {
        GradientDrawable d = round(c, fill, radiusDp);
        d.setStroke(GmUtil.dp(c, strokeDp), stroke);
        return d;
    }

    /** 按 dp 设置内边距（四边同值）。 */
    public static void pad(View v, Context c, int dp) {
        int p = GmUtil.dp(c, dp);
        v.setPadding(p, p, p, p);
    }

    /** 按 dp 设置外边距。 */
    public static void margin(View v, Context c, int left, int top, int right, int bottom) {
        ViewGroup.LayoutParams lp = v.getLayoutParams();
        if (lp instanceof ViewGroup.MarginLayoutParams) {
            ViewGroup.MarginLayoutParams m = (ViewGroup.MarginLayoutParams) lp;
            m.setMargins(GmUtil.dp(c, left), GmUtil.dp(c, top), GmUtil.dp(c, right), GmUtil.dp(c, bottom));
            v.setLayoutParams(m);
        }
    }

    /** 竖向占位。 */
    public static View space(Context c, int dp) {
        View v = new View(c);
        v.setLayoutParams(new LinearLayout.LayoutParams(1, GmUtil.dp(c, dp)));
        return v;
    }

    // ------------------------------------------------------------ 文字

    /** 页面主标题。 */
    public static TextView title(Context c, String s) {
        TextView t = new TextView(c);
        t.setText(s);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 17f);
        t.setTextColor(GmUtil.tx(c));
        t.getPaint().setFakeBoldText(true);
        t.setPadding(0, GmUtil.dp(c, 10), 0, GmUtil.dp(c, 4));
        return t;
    }

    /** 说明/次要文字。 */
    public static TextView desc(Context c, String s) {
        TextView t = new TextView(c);
        t.setText(s);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f);
        t.setTextColor(GmUtil.sub(c));
        t.setPadding(0, 0, 0, GmUtil.dp(c, 6));
        return t;
    }

    /** 纯文本行（不改色、不点击）—— 给日志那种长文本用。 */
    public static TextView text(Context c, String s) {
        TextView t = new TextView(c);
        t.setText(s);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f);
        t.setTextColor(GmUtil.tx(c));
        t.setTextIsSelectable(true);
        return t;
    }

    /** 一行分隔线。 */
    public static View divider(Context c) {
        View v = new View(c);
        v.setBackgroundColor(GmUtil.line(c));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, Math.max(1, GmUtil.dp(c, 1)));
        lp.topMargin = GmUtil.dp(c, 6);
        lp.bottomMargin = GmUtil.dp(c, 6);
        v.setLayoutParams(lp);
        return v;
    }

    // ------------------------------------------------------------ 交互行

    /** 二级菜单行：文字 + 右侧「›」，点了就进去（不是开关！）。 */
    public static TextView menu(Context c, String s, View.OnClickListener l) {
        TextView t = new TextView(c);
        t.setText(s + "   ›");
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f);
        t.setTextColor(GmUtil.tx(c));
        t.setPadding(GmUtil.dp(c, 4), GmUtil.dp(c, 14), GmUtil.dp(c, 4), GmUtil.dp(c, 14));
        t.setBackground(round(c, GmUtil.bg(c), 12));
        t.setOnClickListener(l);
        return t;
    }

    /** 开关行（带真 Switch 控件 —— 项目里"开关"是有形状的，别拿「›」冒充）。 */
    public static SwitchRow switchRow(Context c, String label, boolean checked,
                                      CompoundButton.OnCheckedChangeListener l) {
        LinearLayout row = new LinearLayout(c);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(GmUtil.dp(c, 4), GmUtil.dp(c, 6), GmUtil.dp(c, 4), GmUtil.dp(c, 6));

        TextView t = new TextView(c);
        t.setText(label);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f);
        t.setTextColor(GmUtil.tx(c));
        t.setLayoutParams(new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        row.addView(t);

        Switch sw = new Switch(c);
        sw.setChecked(checked);              // ← 先 setChecked，再挂监听（不然一进页面会自己触发一下）
        if (l != null) sw.setOnCheckedChangeListener(l);
        row.addView(sw);

        return new SwitchRow(row, sw);
    }

    /** 开关行的返回值：row 拿去 addView，sw 拿去读/写状态。 */
    public static final class SwitchRow {
        public final LinearLayout row;
        public final Switch sw;

        SwitchRow(LinearLayout row, Switch sw) {
            this.row = row;
            this.sw = sw;
        }
    }

    /** 普通按钮（圆角 + 强调色文字）。 */
    public static Button button(Context c, String s, View.OnClickListener l) {
        Button b = new Button(c);
        b.setText(s);
        b.setAllCaps(false);
        b.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f);
        b.setTextColor(ACCENT);
        b.setBackground(roundStroke(c, GmUtil.bg(c), 12, GmUtil.line(c), 1));
        b.setOnClickListener(l);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.topMargin = GmUtil.dp(c, 6);
        b.setLayoutParams(lp);
        return b;
    }

    /** 色块（调色板用）：选中的那个描一圈强调色。 */
    public static View chip(Context c, int color, boolean selected, View.OnClickListener l) {
        View v = new View(c);
        int size = GmUtil.dp(c, 34);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(size, size);
        lp.rightMargin = GmUtil.dp(c, 8);
        v.setLayoutParams(lp);
        v.setBackground(selected ? roundStroke(c, color, 10, ACCENT, 3) : round(c, color, 10));
        v.setOnClickListener(l);
        return v;
    }

    // ------------------------------------------------------------ 对话框

    /** 把内容塞进 Dialog 并套上竖向滚动（等价 GmUtil.sc 的语义，写清楚意图）。 */
    public static void attach(Dialog d, View content) {
        GmUtil.sc(d, content);
    }
}
