// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;

import com.nidyaber.fuckdsmanger.glass.GmGlassBackdrop;
import com.nidyaber.fuckdsmanger.glass.GmGlassCfg;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Map;

import de.robv.android.xposed.XposedHelpers;

/**
 * 「迟到绑定」补丁 —— 治「重启后背景/玻璃不生效，必须回 UI 再开关一次」🐲
 *
 * <h3>病根（2026-10-24 真机实测，不是猜的）</h3>
 * 冷启动时 **宿主的第一次 {@code Activity.onResume} 跑在模块钩子生效之前**：
 *
 * <pre>
 * 14:53:56.861  hookM ...                        ← 我们的钩子在这时才开始挂
 * 14:53:56.9xx  （宿主 MainActivity 已经 resume 完了）
 * ...
 * 14:54:17      [CELL] 总项数 = 5                 ← 界面在渲染，但 resume 那一下没人接
 * </pre>
 *
 * 而「背景 View 的挂载」和「玻璃的底图绑定」**只在 onResume 里做**
 * （{@code GmResumeHook.afterHookedMethod} → {@code GmBg.ensure()} / {@code GmGlassBackdrop.bind()}）
 * ⇒ 冷启动这一下被漏掉 ⇒ 什么都不显示；等到下一次 resume（回 UI 再回宿主）
 * 才补上 ⇒ 主人看到的就是「必须重新开关一次」。
 *
 * 实测证据（同进程第二次 resume，无条件探针）：
 * <pre>
 * 【GmResumeHook】onResume fired: com.deepseek.chat.MainActivity
 * 【GmBg】ensure isOn=true sView=true      ← 配置本来是对的，只是没人来装
 * </pre>
 *
 * <h3>治法</h3>
 * 初始化结束后，在主线程上**轮询几次**，用 {@code ActivityThread.mActivities}
 * 找当前活着的 Activity，找到就手工跑一遍那条 resume 链（幂等，重复跑无害）。
 * 找不到（还没进界面）就下次再试，最多 {@link #MAX_ATTEMPTS} 次后安静退出。
 *
 * ★ 只补「漏掉的那一次」，**不改变任何既有逻辑**：正常 resume 时本类什么都不做
 *   （它只在初始化后的一小段时间窗口内活动，且成功后立即停）。
 */
public final class GmCatchUp {

    /** 最多试几次（每 {@link #INTERVAL_MS} 一次 ⇒ 约 6 秒覆盖启动期）。 */
    private static final int MAX_ATTEMPTS = 24;

    /** 间隔。太短没意义（界面还没建），太长会撞上正常的 onResume。 */
    private static final long INTERVAL_MS = 250L;

    private static boolean sDone = false;

    private GmCatchUp() {
    }

    /** 只在宿主进程里调；重复调安全。 */
    public static void install(final ClassLoader cl) {
        final Handler h = new Handler(Looper.getMainLooper());
        h.postDelayed(new Runnable() {
            int n = 0;

            @Override
            public void run() {
                if (sDone) return;
                n++;
                Activity a = currentActivity();
                if (a != null) {
                    sDone = true;
                    bind(a, cl, n);
                    return;
                }
                if (n >= MAX_ATTEMPTS) {
                    sDone = true;
                    GmUtil.log("【FDM】迟到绑定：试了 " + n + " 次仍没找到活着的 Activity ⇒ 放弃"
                            + "（下次 resume 会照常补上）");
                    return;
                }
                h.postDelayed(this, INTERVAL_MS);
            }
        }, INTERVAL_MS);
    }

    /** 手工跑一遍「resume 该做的事」。全部 try 住 —— 任何一步失败都不许连累宿主。 */
    private static void bind(Activity a, ClassLoader cl, int attempt) {
        StringBuilder sb = new StringBuilder("【FDM】迟到绑定 ✓ ");
        sb.append(a.getClass().getName()).append("（第 ").append(attempt).append(" 次探测命中）");

        // ① 玻璃：底下那张底图 + 配置（GmGlassInstall 的 onResume 做的三件事）
        try {
            GmGlassBackdrop.bind(a);
            GmGlassCfg.reload(a);
            if (GmGlassCfg.on()) {
                GmGlassBackdrop.request();
            }
            sb.append(" · 玻璃✓");
        } catch (Throwable t) {
            sb.append(" · 玻璃✗(").append(t.getClass().getSimpleName()).append(")");
        }

        // ② 背景 View 的挂载：底座里的 GmBg.ensure(Context)（反射调，避免编译期依赖）
        //   ★ 2026-10-24 修正：GmBg 在**我们自己 dex** 里，必须用模块的 ClassLoader
        //     （第一次写成宿主的 lp.classLoader ⇒ XposedHelpers$ClassNotFoundError）
        try {
            Class<?> bg = XposedHelpers.findClass("com.nidyaber.fuckdsmanger.gm.GmBg",
                    GmCatchUp.class.getClassLoader());
            XposedHelpers.callStaticMethod(bg, "ensure", a);
            sb.append(" · 背景✓");
        } catch (Throwable t) {
            sb.append(" · 背景✗(").append(t.getClass().getSimpleName()).append(")");
        }

        GmUtil.log(sb.toString());
    }

    /**
     * 找当前「活着且可见」的 Activity。
     *
     * <p>为什么不 hook：钩子正是被漏掉的那个东西 —— 这里要的是**事后的状态**，
     * 不是事件。{@code ActivityThread.mActivities} 是 ArrayMap&lt;IBinder, ActivityClientRecord&gt;，
     * 里面每个 record 的 {@code activity} 字段就是实例（AOSP 十几年没改过名）。
     */
    private static Activity currentActivity() {
        try {
            Class<?> atCls = Class.forName("android.app.ActivityThread");
            Object at = XposedHelpers.callStaticMethod(atCls, "currentActivityThread");
            if (at == null) return null;

            Field f = atCls.getDeclaredField("mActivities");
            f.setAccessible(true);
            Object acts = f.get(at);
            if (!(acts instanceof Map)) return null;

            Collection<?> recs = ((Map<?, ?>) acts).values();
            Activity fallback = null;
            for (Object rec : recs) {
                if (rec == null) continue;
                Object o = XposedHelpers.getObjectField(rec, "activity");
                if (!(o instanceof Activity)) continue;
                Activity act = (Activity) o;
                if (act.isFinishing() || act.isDestroyed()) continue;
                if (act.getWindow() != null && act.getWindow().getDecorView().isShown()) {
                    return act;          // 可见的那一个最优先
                }
                if (fallback == null) fallback = act;
            }
            return fallback;
        } catch (Throwable t) {
            GmUtil.log("【FDM】迟到绑定：取当前 Activity 失败 " + t);
            return null;
        }
    }

    /** 调试用：给别的模块部分看看有没有跑完（目前没有调用点，留着无害）。 */
    public static boolean done() {
        return sDone;
    }
}
