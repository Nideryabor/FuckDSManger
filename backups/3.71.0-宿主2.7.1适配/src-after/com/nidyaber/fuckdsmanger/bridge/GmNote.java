// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import org.json.JSONArray;
import org.json.JSONObject;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 悬浮便签 🐲 —— 贴在**宿主窗口**上的浮层（不需要任何权限）
 *
 * ── 为什么走「注入宿主窗口」而不是系统悬浮窗 ──────────────────────
 *   `TYPE_APPLICATION_OVERLAY` 要「显示在其他应用上层」权限，得用户手动去设置里开，
 *   还要给模块加 Service + 清单改动。而**宿主本来就有一个窗口** —— 我们只是往它的
 *   `decorView` 里塞一个子 View 而已：
 *     · 零权限 ✅   · 零清单改动 ✅   · 宿主关了它也自然消失 ✅
 *   代价：它只在宿主界面上显示（主人要的就是这个）。
 *
 * ── 挂法 ─────────────────────────────────────────────────────
 *   钩 `android.app.Activity`（**框架类，名字永远不变** —— 跟 FdmEntry 的落点同一思路）：
 *     · `onResume` → 用当前 Activity 的 decorView 挂上（先判开关）
 *     · `onPause`  → 摘掉（不泄漏、不串页；回来时 onResume 再挂）
 *
 * ── 保命规矩（跟模块其它钩子一致）─────────────────────────────
 *   全程 try/catch，出任何事只写日志，**绝不连累宿主**。
 *   锚点/窗口拿不到 ⇒ 等于没装。
 */
public final class GmNote {

    // ───────────── 配置键（全 fuckds_note_*）─────────────
    public static final String K_ON    = "fuckds_note_on";
    public static final String K_BG    = "fuckds_note_bg";
    public static final String K_ALPHA = "fuckds_note_alpha";
    public static final String K_SIZE  = "fuckds_note_size";
    /** 便签全部内容的存档（JSON：{idx,min,items:[{t,x,y}]}）—— 内部用，界面一般不动它 */
    public static final String K_DATA  = "fuckds_note_data";
    /** 界面「便签内容」那一框 —— 等价于「当前这张便签的文字」 */
    public static final String K_TEXT  = "fuckds_note_text";

    public static final int DEF_BG    = 0xFFFFF3B0;   // 便签黄
    public static final int DEF_ALPHA = 230;
    public static final int DEF_SIZE  = 14;           // sp

    /** 底座里存「当前 Activity」的是**这个** GmEntry（不是入口那个）—— 见 FdmUiHook 的血泪注释 */
    private static final String BASE_ENTRY = "com.nidyaber.fuckdsmanger.gm.GmEntry";

    private static volatile boolean sInstalled = false;
    /** 「本会话关掉」标记：`✕` 之后本进程不再出现；拨开关 / 重启宿主即恢复（主人 2026-10-06 定的语义） */
    private static volatile boolean sSessionClosed = false;
    private static volatile GmNoteView sView = null;
    private static volatile Context sCtx = null;
    private static volatile JSONObject sState = null;

    private GmNote() {
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
                        if (sSessionClosed || !enabled(a)) {
                            detachAll();
                            return;
                        }
                        attach(a);
                    } catch (Throwable t) {
                        GmUtil.logFail("【GmNote】onResume 处理失败", t);
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
            GmUtil.log("【GmNote】悬浮便签钩子已挂 ✓（activity.onResume/onPause）");
            XposedBridge.log("[FDM] 悬浮便签钩子已挂 ✓");
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】挂载失败（等于没装，宿主不受影响）", t);
            XposedBridge.log("[FDM] GmNote 挂载失败：" + t);
        }
    }

    // ══════════════════════════════ 配置读取 ══════════════════════════════
    //  ★ 一律走 SharedPreferences 的强类型 getter（getBoolean/getInt/getString）——
    //    不走 read2：它的第三参是**类型**不是默认值，返回值形态也不确定（踩过坑，见交接文档）。
    //    类型由写入方（FdmBridge.putInts / GmStore.write）决定，这里按同一套约定读。

    static SharedPreferences sp(Context c) {
        try {
            return GmStore.get(c);
        } catch (Throwable t) {
            return null;
        }
    }

    static boolean enabled(Context c) {
        try {
            SharedPreferences s = sp(c);
            return s != null && s.getBoolean(K_ON, false);
        } catch (Throwable t) {
            return false;
        }
    }

    static int cfgBg(Context c) {
        try {
            SharedPreferences s = sp(c);
            int v = s == null ? DEF_BG : s.getInt(K_BG, DEF_BG);
            return v == 0 ? DEF_BG : v;
        } catch (Throwable t) {
            return DEF_BG;
        }
    }

    static int cfgAlpha(Context c) {
        try {
            SharedPreferences s = sp(c);
            return s == null ? DEF_ALPHA : s.getInt(K_ALPHA, DEF_ALPHA);
        } catch (Throwable t) {
            return DEF_ALPHA;
        }
    }

    static int cfgSize(Context c) {
        try {
            SharedPreferences s = sp(c);
            int v = s == null ? DEF_SIZE : s.getInt(K_SIZE, DEF_SIZE);
            return v <= 0 ? DEF_SIZE : v;
        } catch (Throwable t) {
            return DEF_SIZE;
        }
    }

    // ══════════════════════════════ 状态 ══════════════════════════════

    /** 内存里的便签状态（首次从宿主存储里读；读不出就起一份空的）。 */
    static synchronized JSONObject state() {
        if (sState != null) return sState;
        JSONObject o = null;
        try {
            Context c = sCtx;
            SharedPreferences s = c == null ? null : sp(c);
            String raw = s == null ? null : s.getString(K_DATA, null);
            if (raw != null && raw.length() > 0) o = new JSONObject(raw);
        } catch (Throwable ignore) {
        }
        if (o == null) {
            o = new JSONObject();
            try {
                o.put("idx", 0);
                o.put("min", false);
                o.put("items", new JSONArray());
            } catch (Throwable ignore) {
            }
        }
        // 结构自愈：items 必须是「至少一个 JSONObject」的数组，后面的 curItem 才敢往上写
        try {
            JSONArray a = o.optJSONArray("items");
            if (a == null) {
                a = new JSONArray();
                o.put("items", a);
            }
            if (a.length() == 0) a.put(new JSONObject());
            for (int i = 0; i < a.length(); i++) {
                if (a.optJSONObject(i) == null) a.put(i, new JSONObject());
            }
            int idx = o.optInt("idx", 0);
            if (idx < 0) o.put("idx", 0);
            if (idx >= a.length()) o.put("idx", a.length() - 1);
        } catch (Throwable ignore) {
        }
        sState = o;
        return sState;
    }

    /** 当前正在看的那张便签（**一定是数组里的真身**，写进去才存得住）。 */
    static synchronized JSONObject curItem() {
        JSONObject st = state();
        JSONArray a = st.optJSONArray("items");
        if (a == null || a.length() == 0) return new JSONObject();
        int i = st.optInt("idx", 0);
        if (i < 0) i = 0;
        if (i >= a.length()) i = a.length() - 1;
        JSONObject o = a.optJSONObject(i);
        return o == null ? new JSONObject() : o;
    }

    static synchronized int total() {
        JSONArray a = state().optJSONArray("items");
        return a == null || a.length() == 0 ? 1 : a.length();
    }

    static synchronized int curIdx() {
        int i = state().optInt("idx", 0);
        int n = total();
        if (i < 0) i = 0;
        if (i >= n) i = n - 1;
        return i;
    }

    /** 丢内存缓存（外部改了 K_DATA 时用）。 */
    public static synchronized void invalidate() {
        sState = null;
    }

    // ══════════════════════════════ 对外操作 ══════════════════════════════

    /**
     * 总开关。UI 侧 `cfg_put` → FdmBridge.dispatch → 这里。
     *
     * <p>★ 「拨开关」= 重新出现（清掉 `✕` 的本会话关闭标记，主人 2026-10-06 定的语义）。
     * 而且**当场**在当前前台 Activity 上长出来/收掉，不用等下一次 onResume。
     */
    public static void setOn(Context ctx, boolean on) {
        try {
            sCtx = ctx;
            sSessionClosed = false;
            GmStore.write(ctx, K_ON, String.valueOf(on), "b");
            GmUtil.log("【GmNote】开关 → " + on + "（本会话关闭标记已清）");
            if (!on) {
                detachAll();
                return;
            }
            Activity a = curActivity();
            if (a != null) attach(a);
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】setOn 失败", t);
        }
    }

    /** 宿主真值（`cfg_state` 回传给界面用）。 */
    public static boolean isOn(Context ctx) {
        return enabled(ctx);
    }

    /**
     * 配置动了 ⇒ 让已经挂上的那张便签重读配置重绘。
     * 没挂上时什么都不做（**不会**因为刷新就把 `✕` 关掉的重新拉出来）。
     */
    public static void refresh() {
        final GmNoteView v = sView;
        if (v == null) return;
        try {
            v.post(new Runnable() {
                @Override
                public void run() {
                    try {
                        v.refreshAll();
                    } catch (Throwable ignore) {
                    }
                }
            });
        } catch (Throwable ignore) {
        }
    }

    /** `✕` —— 本会话不再出现（拨开关 / 重启宿主即恢复）。 */
    public static void closeSession() {
        sSessionClosed = true;
        GmUtil.log("【GmNote】本会话关闭（拨开关或重启宿主恢复）");
        detachAll();
    }

    /** 界面「便签内容」那一框 ⇒ 直接改当前这张便签的文字。 */
    public static void setTextFromCfg(Context ctx, String t) {
        try {
            sCtx = ctx;
            setText(t == null ? "" : t);
            GmUtil.log("【GmNote】界面推来的便签内容 → 当前这张（"
                    + (t == null ? 0 : t.length()) + " 字）");
        } catch (Throwable e) {
            GmUtil.logFail("【GmNote】setTextFromCfg 失败", e);
        }
    }

    // ── 便签自身的操作（由 GmNoteView 的按钮调用；每个都「改内存 → 落盘 → 重绘」）──

    static synchronized void addItem() {
        try {
            JSONObject st = state();
            JSONArray a = st.optJSONArray("items");
            if (a == null) {
                a = new JSONArray();
                st.put("items", a);
            }
            a.put(new JSONObject());
            st.put("idx", a.length() - 1);
            save();
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】新建便签失败", t);
        }
    }

    static synchronized void delItem() {
        try {
            JSONObject st = state();
            JSONArray a = st.optJSONArray("items");
            if (a == null || a.length() == 0) return;
            int i = curIdx();
            JSONArray na = new JSONArray();
            for (int k = 0; k < a.length(); k++) {
                if (k != i) na.put(a.optJSONObject(k));
            }
            if (na.length() == 0) na.put(new JSONObject());
            st.put("items", na);
            int ni = i >= na.length() ? na.length() - 1 : i;
            st.put("idx", ni < 0 ? 0 : ni);
            save();
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】删除便签失败", t);
        }
    }

    static synchronized void setIdx(int i) {
        try {
            JSONObject st = state();
            int n = total();
            if (i < 0) i = 0;
            if (i >= n) i = n - 1;
            st.put("idx", i);
            save();
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】切换便签失败", t);
        }
    }

    static synchronized void setText(String t) {
        try {
            curItem().put("t", t == null ? "" : t);
            save();
        } catch (Throwable e) {
            GmUtil.logFail("【GmNote】存文字失败", e);
        }
    }

    static synchronized void setMin(boolean m) {
        try {
            state().put("min", m);
            save();
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】最小化失败", t);
        }
    }

    /** 记位置（dp，左上角；-1 = 还没放过，界面上会自动摆到右侧）。 */
    static synchronized void setPos(int xDp, int yDp) {
        try {
            JSONObject it = curItem();
            it.put("x", xDp);
            it.put("y", yDp);
            save();
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】记位置失败", t);
        }
    }

    private static synchronized void save() {
        try {
            Context c = sCtx;
            if (c == null || sState == null) return;
            GmStore.write(c, K_DATA, sState.toString(), "s");
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】落盘失败", t);
        }
    }

    // ══════════════════════════════ 挂 / 摘 ══════════════════════════════

    private static void attach(Activity a) {
        if (a == null || a.isFinishing()) return;
        try {
            if (android.os.Build.VERSION.SDK_INT >= 17 && a.isDestroyed()) return;
        } catch (Throwable ignore) {
        }

        ViewGroup decor;
        try {
            decor = (ViewGroup) a.getWindow().getDecorView();
        } catch (Throwable t) {
            return;
        }
        if (decor == null) return;

        GmNoteView v = sView;
        if (v != null && v.getParent() == decor) {      // 同一扇窗 ⇒ 只刷新，不重挂
            refresh();
            return;
        }
        detachAll();
        try {
            GmNoteView nv = new GmNoteView(a);
            decor.addView(nv, new FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.WRAP_CONTENT,
                    FrameLayout.LayoutParams.WRAP_CONTENT));
            sView = nv;
            nv.bootstrap();
            GmUtil.log("【GmNote】便签已挂上窗口 " + a.getClass().getName());
        } catch (Throwable t) {
            GmUtil.logFail("【GmNote】挂到窗口失败", t);
        }
    }

    private static void detachAll() {
        final GmNoteView v = sView;
        sView = null;
        if (v == null) return;
        try {
            v.saveNow();                 // ★ 正在编辑的先落盘，别丢字
        } catch (Throwable ignore) {
        }
        try {
            ViewGroup p = (ViewGroup) v.getParent();
            if (p != null) p.removeView(v);
        } catch (Throwable ignore) {
        }
    }

    /** 当前前台 Activity —— 从底座 `gm.GmEntry.sAct` 拿（那是包级私有字段，必须 setAccessible）。 */
    private static Activity curActivity() {
        try {
            Class<?> e = XposedHelpers.findClass(BASE_ENTRY, GmNote.class.getClassLoader());
            java.lang.reflect.Field f = XposedHelpers.findField(e, "sAct");
            f.setAccessible(true);
            Object o = f.get(null);
            if (o instanceof Activity) return (Activity) o;
        } catch (Throwable ignore) {
        }
        return null;
    }

    // ══════════════════════════════ 小工具 ══════════════════════════════

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
