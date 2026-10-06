// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 宿主里的**迷你播放卡** 🐲 —— 挂在宿主窗口上（跟悬浮便签同一套路数）
 *
 * ── 2026-10-06 重大改版：播放器搬进宿主 ──────────────────────────
 *   之前播放器跑在**模块进程**（独立 Service），靠广播跟卡片通信 ⇒ 一堆麻烦：
 *   划掉模块就断、跨进程广播还要绕 setPackage 的坑、状态有延迟。
 *   现在（主人拍板）**播放器就在宿主进程里**（{@link GmMusicPlayer}）：
 *     · 划掉模块不再影响播放
 *     · 卡片跟播放器**同进程** ⇒ 直接读状态、直接调方法（零延迟、零广播）
 *     · 封面/歌词由宿主自己联网取，**只放内存**
 *
 *   代价（主人已知并接受）：**没有通知栏播放控制**；**划掉 DeepSeek 就停**。
 *
 * ── 常驻（主人 2026-10-06 要求）─────────────────────────────────
 *   开关一开**每个页面都挂着它**（没歌时显示「未在播放 / 点 ♪ 去选歌」）。
 *
 * ── 保命规矩 ────────────────────────────────────────────────
 *   全程 try/catch，出任何事只写日志，绝不连累宿主。
 */
public final class GmMiniBar {

    public static final String K_ON = "fuckds_bar_on";
    public static final String K_X = "fuckds_bar_x";
    public static final String K_Y = "fuckds_bar_y";
    public static final String K_W = "fuckds_bar_w";
    public static final String K_H = "fuckds_bar_h";

    private static volatile boolean sInstalled = false;
    /** 「本会话收起」（`✕`）：拨开关 / 重启宿主即恢复 —— 跟便签同一套语义。 */
    private static volatile boolean sSessionClosed = false;
    private static volatile GmMiniBarView sView = null;
    private static volatile Context sCtx = null;
    private static volatile ViewGroup sDecor = null;

    private GmMiniBar() {
    }

    // ══════════════════════════════ 安装 ══════════════════════════════

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        try {
            XposedHelpers.findAndHookMethod("android.app.Activity", cl, "onResume", new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    try {
                        Object o = p.thisObject;
                        if (!(o instanceof Activity)) return;
                        Activity a = (Activity) o;
                        sCtx = a.getApplicationContext();
                        // 播放器就绪（宿主进程里）
                        GmMusicPlayer.install(sCtx);
                        if (sSessionClosed || !enabled(sCtx)) {
                            detachAll();
                            return;
                        }
                        attach(a);
                    } catch (Throwable t) {
                        GmUtil.logFail("【GmMiniBar】onResume 处理失败", t);
                    }
                }
            });
            XposedHelpers.findAndHookMethod("android.app.Activity", cl, "onPause", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        detachAll();
                    } catch (Throwable ignore) {
                    }
                }
            });
            sInstalled = true;
            GmUtil.log("【GmMiniBar】迷你卡钩子已挂 ✓（常驻）");
            XposedBridge.log("[FDM] 迷你卡钩子已挂 ✓");
        } catch (Throwable t) {
            GmUtil.logFail("【GmMiniBar】挂载失败（等于没装）", t);
            XposedBridge.log("[FDM] GmMiniBar 挂载失败：" + t);
        }
    }

    // ══════════════════════════════ 开关 ══════════════════════════════

    public static void setOn(Context ctx, boolean on) {
        try {
            sCtx = ctx;
            sSessionClosed = false;              // ★ 拨开关 = 重新出现（主人定的语义）
            GmStore.write(ctx, K_ON, String.valueOf(on), "b");
            GmUtil.log("【GmMiniBar】开关 → " + on);
            if (!on) {
                detachAll();
                return;
            }
            GmMusicPlayer.install(ctx);
            Activity a = curActivity();
            if (a != null) attach(a);
        } catch (Throwable t) {
            GmUtil.logFail("【GmMiniBar】setOn 失败", t);
        }
    }

    public static boolean isOn(Context ctx) {
        return enabled(ctx);
    }

    static boolean enabled(Context c) {
        try {
            SharedPreferences s = sp(c);
            return s != null && s.getBoolean(K_ON, false);
        } catch (Throwable t) {
            return false;
        }
    }

    static SharedPreferences sp(Context c) {
        try {
            return GmStore.get(c);
        } catch (Throwable t) {
            return null;
        }
    }

    /** `✕` —— 本会话收起（拨开关 / 重启宿主即恢复）。 */
    static void closeSession() {
        sSessionClosed = true;
        GmUtil.log("【GmMiniBar】本会话收起（拨开关或重启宿主恢复）");
        detachAll();
    }

    // ── 位置 / 尺寸（都按 dp）──

    static void savePos(int xDp, int yDp) {
        writeInt(K_X, xDp);
        writeInt(K_Y, yDp);
    }

    static void saveSize(int wDp, int hDp, int xDp, int yDp) {
        writeInt(K_W, wDp);
        writeInt(K_H, hDp);
        writeInt(K_X, xDp);
        writeInt(K_Y, yDp);
    }

    private static void writeInt(String k, int v) {
        try {
            Context c = sCtx;
            if (c == null) return;
            GmStore.write(c, k, String.valueOf(v), "i");
        } catch (Throwable ignore) {
        }
    }

    static int loadInt(String k, int def) {
        try {
            SharedPreferences s = sp(sCtx);
            return s == null ? def : s.getInt(k, def);
        } catch (Throwable t) {
            return def;
        }
    }

    static int loadY(int def) {
        return loadInt(K_Y, def);
    }

    static int loadX(int def) {
        return loadInt(K_X, def);
    }

    // ══════════════════════════════ 挂 / 摘 ══════════════════════════════

    private static void attach(Activity a) {
        if (a == null || a.isFinishing()) return;
        try {
            if (Build.VERSION.SDK_INT >= 17 && a.isDestroyed()) return;
        } catch (Throwable ignore) {
        }
        ViewGroup decor;
        try {
            decor = (ViewGroup) a.getWindow().getDecorView();
        } catch (Throwable t) {
            return;
        }
        if (decor == null) return;

        // ★ 换窗口 ⇒ 摘旧挂新（防残影）
        GmMiniBarView v = sView;
        if (v != null && decor != sDecor) {
            detachAll();
            v = null;
        }
        if (v != null) return;

        Context c = a;
        int wDp = loadInt(K_W, GmMiniBarView.DEF_W);
        int hDp = loadInt(K_H, GmMiniBarView.DEF_H);
        if (wDp < GmMiniBarView.MIN_W) wDp = GmMiniBarView.DEF_W;
        if (hDp < GmMiniBarView.MIN_H) hDp = GmMiniBarView.DEF_H;

        try {
            final GmMiniBarView nv = new GmMiniBarView(a);
            FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                    dp(c, wDp), dp(c, hDp));
            lp.gravity = Gravity.TOP | Gravity.START;
            decor.addView(nv, lp);
            sView = nv;
            sDecor = decor;
            nv.bootstrap();

            // ★ 直接监听播放器（同进程，零延迟）
            GmMusicPlayer p = GmMusicPlayer.get();
            if (p != null) {
                p.setListener(new GmMusicPlayer.Listener() {
                    @Override
                    public void onState(GmMusicPlayer.State s) {
                        if (nv != sView) return;          // 已经被换掉了
                        nv.applyState(s);
                    }
                });
                nv.applyState(p.state());                 // 先来一帧
            }
            GmUtil.log("【GmMiniBar】迷你卡已挂上 " + a.getClass().getSimpleName()
                    + "（" + wDp + "×" + hDp + "dp）");
        } catch (Throwable t) {
            GmUtil.logFail("【GmMiniBar】挂到窗口失败", t);
        }
    }

    private static void detachAll() {
        final GmMiniBarView v = sView;
        sView = null;
        sDecor = null;
        try {
            GmMusicPlayer p = GmMusicPlayer.get();
            if (p != null) p.setListener(null);
        } catch (Throwable ignore) {
        }
        if (v == null) return;
        try {
            ViewGroup par = (ViewGroup) v.getParent();
            if (par != null) par.removeView(v);
        } catch (Throwable ignore) {
        }
    }

    private static Activity curActivity() {
        try {
            Class<?> e = XposedHelpers.findClass("com.nidyaber.fuckdsmanger.gm.GmEntry",
                    GmMiniBar.class.getClassLoader());
            java.lang.reflect.Field f = XposedHelpers.findField(e, "sAct");
            f.setAccessible(true);
            Object o = f.get(null);
            if (o instanceof Activity) return (Activity) o;
        } catch (Throwable ignore) {
        }
        return null;
    }

    static int dp(Context c, float v) {
        try {
            return (int) (v * c.getResources().getDisplayMetrics().density + 0.5f);
        } catch (Throwable t) {
            return (int) v;
        }
    }

    static int px2dp(Context c, float v) {
        try {
            return (int) (v / c.getResources().getDisplayMetrics().density + 0.5f);
        } catch (Throwable t) {
            return (int) v;
        }
    }
}
