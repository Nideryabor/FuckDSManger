// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

/**
 * 桥的**设置页**（纯 Java + 框架控件，不用 Compose）🐲
 *
 * 为什么先用框架控件：Compose 那条构建链（kotlinc + R8 + 资源合并）还没补完，
 * 但**闭环不该卡在这上面** —— 用 `Switch` 就能把"UI 上的开关 → 跨进程 → 宿主配置"整条路走通。
 * 等 Compose 链补完，这一页会被正式的 Compose 页面替换掉，桥的部分一行都不用改。
 *
 * 没有任何资源依赖（不碰 R 类），所以也不需要在构建链里加资源。
 */
public final class FdmSettingsActivity extends Activity {

    /** 开关：{配置键, 显示名, 默认值} */
    private static final String[][] SWITCHES = {
            {"fuckds_bubble_on", "气泡美化（AI 气泡）", "true"},
            {"fuckds_ububble_on", "气泡美化（我的气泡）", "true"},
            {"fuckds_bg_on", "修改背景", "true"},
            {"fuckds_suggest_on", "回复建议", "true"},
            {"fuckds_device_on", "设备身份伪装", "true"},
            {"fuckds_model_switch", "模型切换", "true"},
    };

    private LinearLayout col;
    private TextView status;

    @Override
    protected void onCreate(Bundle b) {
        super.onCreate(b);

        ScrollView scroll = new ScrollView(this);
        scroll.setBackgroundColor(0xFF121212);
        col = new LinearLayout(this);
        col.setOrientation(LinearLayout.VERTICAL);
        int p = dp(16);
        col.setPadding(p, p, p, p);
        scroll.addView(col, new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        col.addView(title("FDM 桥设置"));
        // ★ 身份信息：桌面上有多个同名/同图标的应用时，点开这页就能确认自己在哪个包里
        col.addView(note("本包 = " + getPackageName()));
        col.addView(note("版本 = " + versionName()));
        col.addView(note("改完立刻推给宿主。宿主那边重启一次后完全生效。"));
        col.addView(note("配置走广播通道 —— 不需要包可见性、不需要 root。"));

        for (String[] s : SWITCHES) {
            col.addView(row(s[0], s[1], "true".equalsIgnoreCase(s[2])));
        }

        Button push = new Button(this);
        push.setText("再推一次");
        push.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int n = FdmPush.push(FdmSettingsActivity.this);
                toast("已推送 " + n + " 项");
                refresh("已手动推送 " + n + " 项");
            }
        });
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.topMargin = dp(12);
        col.addView(push, lp);

        status = note("");
        col.addView(status);

        col.addView(note("— 状态来自宿主回执 —"));
        setContentView(scroll);
        refresh(null);
    }

    @Override
    protected void onResume() {
        super.onResume();
        // 每次回到前台都推一次（**不用真去拨开关**）
        // —— 宿主那边会周期性索要配置，这样"什么时候打开这一页"都能把配置补上
        try {
            int n = FdmPush.push(this);
            Log.e("FDM-DIAG", "设置页 onResume ⇒ 已推送 " + n + " 项");
        } catch (Throwable t) {
            Log.e("FDM-DIAG", "设置页 onResume 推送失败", t);
        }
        refresh("（回到前台，已推一次）");
    }

    private View row(final String key, String label, boolean def) {
        LinearLayout r = new LinearLayout(this);
        r.setOrientation(LinearLayout.HORIZONTAL);
        r.setGravity(Gravity.CENTER_VERTICAL);
        r.setPadding(0, dp(6), 0, dp(6));

        TextView t = new TextView(this);
        t.setText(label);
        t.setTextColor(0xFFE0E0E0);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f);
        t.setLayoutParams(new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        r.addView(t);

        final SharedPreferences sp = FdmPush.sp(this);
        boolean val = sp.getBoolean(key, def);
        Switch sw = new Switch(this);
        sw.setChecked(val);
        sw.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton v, boolean isChecked) {
                sp.edit().putBoolean(key, isChecked).apply();
                int n = FdmPush.push(FdmSettingsActivity.this);
                toast(key + " = " + isChecked + "（已推 " + n + " 项）");
                refresh("刚改： " + key + " = " + isChecked);
            }
        });
        r.addView(sw);
        return r;
    }

    private TextView title(String s) {
        TextView t = new TextView(this);
        t.setText(s);
        t.setTextColor(Color.WHITE);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 22f);
        t.setPadding(0, 0, 0, dp(8));
        return t;
    }

    private TextView note(String s) {
        TextView t = new TextView(this);
        t.setText(s);
        t.setTextColor(0xFF9E9E9E);
        t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13f);
        t.setPadding(0, dp(2), 0, dp(2));
        return t;
    }

    private void refresh(String extra) {
        SharedPreferences sp = FdmPush.sp(this);
        StringBuilder sb = new StringBuilder();
        if (extra != null) sb.append(extra).append('\n');
        sb.append("rev = ").append(sp.getInt("rev", 1)).append('\n');
        sb.append("宿主已应用 rev = ").append(sp.getInt("applied_rev", -1)).append('\n');
        long at = sp.getLong("applied_at", 0);
        sb.append("最近回执 = ").append(at == 0 ? "（还没收到）" : new java.util.Date(at).toString());
        if (status != null) status.setText(sb.toString());
    }

    private void toast(String s) {
        Toast.makeText(this, s, Toast.LENGTH_SHORT).show();
    }

    private String versionName() {
        try {
            return getPackageManager().getPackageInfo(getPackageName(), 0).versionName
                    + " (" + getPackageManager().getPackageInfo(getPackageName(), 0).versionCode + ")";
        } catch (Throwable t) {
            return "?";
        }
    }

    private int dp(int v) {
        return (int) (v * getResources().getDisplayMetrics().density + 0.5f);
    }
}
