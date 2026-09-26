package com.nidyaber.fuckdsmanger.gm;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.nidyaber.fuckdsmanger.gm.GmBeautyDialog;
import com.nidyaber.fuckdsmanger.gm.GmChatDialog;
import com.nidyaber.fuckdsmanger.gm.GmDialog;
import com.nidyaber.fuckdsmanger.gm.GmDumpDialog;
import com.nidyaber.fuckdsmanger.gm.GmEntry;
import com.nidyaber.fuckdsmanger.gm.GmEnvDialog;
import com.nidyaber.fuckdsmanger.gm.GmMenuDialog;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

/** 新主页（M3 Expressive 版主菜单）—— 取代 GmMenuDialog 那张脸。 */
public final class GmHomeUi {

    private static Dialog sDlg;

    private GmHomeUi() {}

    /** 入口点。**任何异常都不许漏给调用方** —— GmEntryHook 后面还有 setResult，
     *  这里一抛出去，那一步就跑不到，宿主自己的"检查更新"逻辑就会顶上来。 */
    public static void open() {
        try {
            openInner();
        } catch (Throwable e) {
            report(e);
            try { GmMenuDialog.open(); } catch (Throwable ignore) { }   // 兜底：老菜单
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
        col.addView(GmUi.topBar(act, "FuckDSManger", null));

        col.addView(GmUi.sectionLabel(act, "核心の功能"));
        col.addView(GmUi.listRow(act, "\u270E", "灰度选项管理", "查看宿主隐藏设置(小心封号)",
                true, 0, 1, v -> GmDialog.open()));

        col.addView(GmUi.divider(act));
        col.addView(GmUi.sectionLabel(act, "附加の功能"));

        String[] title = {"聊天", "美化", "过检", "调试"};
        String[] glyph = {"\u2709", "\u263A", "\u2714", "\u2699"};
        String[] sub = {null, null,
                "如果ds压力root设备/发现lsp，点我",
                "如果没bug，里面的东西别乱动"};
        for (int i = 0; i < title.length; i++) {
            final int k = i;
            View row = GmUi.listRow(act, glyph[i], title[i], sub[i], true, i, title.length, v -> {
                switch (k) {
                    case 0: GmChatDialog.open();   break;
                    case 1: GmBeautyDialog.open(); break;
                    case 2: GmEnvDialog.open();    break;
                    default: GmDumpDialog.open();  break;
                }
            });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, GmUtil.dp(act, 72));
            if (i > 0) lp.topMargin = GmUtil.dp(act, 3);
            row.setLayoutParams(lp);
            col.addView(row);
        }

        col.addView(GmUi.space(act, 8));
        col.addView(GmUi.navBar(act, new String[]{"首页", "关于"},
                new String[]{"\u2302", "\u24D8"}, 0, v -> {
                    Object tag = v.getTag();
                    if (tag instanceof Integer && (Integer) tag == 1) GmAboutUi.open();
                }));

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

    /** 出事时：日志 + 一句短吐司 + 完整堆栈写进宿主自己的外部目录（MT 能直接开） */
    static void report(Throwable e) {
        try { GmUtil.logFail("FDM-UI", e); } catch (Throwable ignore) { }
        try {
            Activity act = GmEntry.sAct;
            if (act == null) return;
            StringBuilder sb = new StringBuilder(e.getClass().getName());
            StackTraceElement[] st = e.getStackTrace();
            for (int i = 0; i < Math.min(2, st.length); i++) sb.append("\n").append(st[i]);
            try {
                java.io.File f = new java.io.File(act.getExternalFilesDir(null), "fdm-ui-crash.txt");
                java.io.PrintWriter w = new java.io.PrintWriter(new java.io.FileWriter(f, true));
                w.println("=== " + new java.util.Date() + " ===");
                e.printStackTrace(w);
                w.close();
            } catch (Throwable ignore) { }
            Toast.makeText(act, sb.toString(), Toast.LENGTH_LONG).show();
        } catch (Throwable ignore) { }
    }
}
