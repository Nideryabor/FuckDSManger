package com.nidyaber.fuckdsmanger.gm;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.nidyaber.fuckdsmanger.gm.GmEntry;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

/** 「关于」页：两个容器框 + 致谢。 */
public final class GmAboutUi {

    private static Dialog sDlg;

    private GmAboutUi() {}

    public static void open() {
        try {
            openInner();
        } catch (Throwable e) {
            GmHomeUi.report(e);
        }
    }

    private static void openInner() throws Throwable {
        Activity act = GmEntry.sAct;
        if (act == null) return;
        close();
        Dialog d = new Dialog(act);
        d.requestWindowFeature(Window.FEATURE_NO_TITLE);

        LinearLayout col = GmUi.column(act);
        col.setBackground(GmUi.round(act, GmUtil.bg(act), 28));
        col.addView(GmUi.topBar(act, "关于", v -> close()));

        LinearLayout box1 = GmUi.box(act, 368, GmUi.ACCENT_SOFT, 28);
        View pic = new View(act);
        pic.setBackground(GmUi.round(act, GmUtil.bg(act), 20));
        int side = GmUtil.dp(act, 200);
        LinearLayout.LayoutParams plp = new LinearLayout.LayoutParams(side, side);
        plp.gravity = Gravity.CENTER_HORIZONTAL;
        plp.topMargin = GmUtil.dp(act, 56);
        pic.setLayoutParams(plp);
        box1.addView(pic);
        TextView t = new TextView(act);
        t.setText("FDM-100%由DS鬼脑发动的神秘模块");
        t.setTextSize(22f);
        t.setTypeface(Typeface.DEFAULT_BOLD);
        t.setTextColor(GmUi.ACCENT_DARK);
        t.setGravity(Gravity.CENTER);
        t.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));
        t.setPadding(GmUtil.dp(act, 16), 0, GmUtil.dp(act, 16), GmUtil.dp(act, 24));
        box1.addView(t);
        col.addView(box1);
        col.addView(GmUi.space(act, 24));

        LinearLayout box2 = GmUi.box(act, 316, GmUtil.bg(act), 28);
        TextView credit = new TextView(act);
        credit.setText("致谢\n\n"
                + "尼得亚伯(DS驱动版)：所有的核心代码都是Ta写的\n"
                + "lsposed：提供了 hook 及注入\n"
                + "token：许多都被尼得亚伯当夜宵了\n"
                + "m3e-canvas（本项目的 UI 设计/实现参考）\n"
                + "项目地址：https://github.com/lnkiai/m3e-canvas\n"
                + "deekseep 1.7.4（com.dsmod.probe）：为我们提供了新版思路\n"
                + "■神：我也不知道怎么会有这个。");
        credit.setTextSize(13f);
        credit.setTextColor(GmUtil.sub(act));
        credit.setLineSpacing(0f, 1.4f);
        credit.setPadding(GmUtil.dp(act, 16), GmUtil.dp(act, 16), GmUtil.dp(act, 16), GmUtil.dp(act, 16));
        box2.addView(credit);
        col.addView(box2);
        col.addView(GmUi.space(act, 16));

        GmUtil.sc(d, col);
        /* ★ 定尺寸必须在 setContentView【之后】—— 之前设会被它重置掉（上一版就栽在这）。
           setMinimumWidth 再兜一层：万一窗口尺寸没生效，内容也能自己把宽度撑起来。 */
        col.setMinimumWidth(GmUtil.dp(act, 300));
        android.util.DisplayMetrics dm = act.getResources().getDisplayMetrics();
        android.view.Window win = d.getWindow();
        win.setBackgroundDrawable(new ColorDrawable(0x00000000));
        win.setLayout((int) (dm.widthPixels * 0.92f), (int) (dm.heightPixels * 0.86f));
        d.show();
        sDlg = d;
    }

    public static void close() {
        try { if (sDlg != null) sDlg.dismiss(); } catch (Throwable ignore) { }
        sDlg = null;
    }
}
