// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import java.lang.reflect.Field;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedHelpers;

/**
 * 【FdmUpdateRowHook】设置页「检查更新」那一行的**点击** 🐲
 *
 * <h3>为什么非要有它（主人一句话点破）</h3>
 * <pre>
 *   「如果你挂了修改文字的 hook 但没挂/挂错这个按钮点击逻辑的 hook，
 *     你怎么改模块 UI 都起不来」
 * </pre>
 * 完全正确。之前的状态是：
 * <ul>
 *   <li>{@code GmResTextHook} 把 {@code profile_check_for_updates} 的**字符串**
 *       换成了「FuckDSManger 插件列表」⇒ 界面上字变了</li>
 *   <li>{@code GmEntryHook} 挂的是 {@code m5/t5/z5}（设置行 → **路由桶**），
 *       那 29 个 case 全是「批量管理 / 语言 / 外观」这种**有路由键**的行；
 *       「检查更新」**不在这张 switch 里**</li>
 * </ul>
 * ⇒ 点击走的还是宿主原逻辑 ⇒ 永远弹「当前已是最新版本」。
 * <b>改文案和接管点击是两条完全不同的路。</b>
 *
 * <h3>真身在哪儿（frida 实测，不是猜）</h3>
 * <pre>
 *   Context.getString(0x7f0f0267 「当前已是最新版本」)
 *     ← ol2.j(:121)                 通用 lambda 分发器
 *     ← pg7.z(:428)  ★★★★★         点击逻辑本体
 *     ← sj0.h(:5)                   协程 ContinuationImpl.resumeWith
 *     ← wy3.run ← Handler.post
 * </pre>
 * 且 {@code pg7.z} 里 {@code this.e}（R8 把一堆 suspend lambda 合并进一个类，
 * {@code e:I} 是 switch 索引）= <b>22 / 23</b>：
 * 两次点击分别落 23 / 22，都直通同一句「当前已是最新版本」⇒ 同一功能、同一条路。
 *
 * <h3>本类做什么</h3>
 * 只在 {@code e ∈ {22, 23}} 时动作（其它 case 一律原样放行，**不碰**）：
 * <ol>
 *   <li>请宿主代发 PendingIntent 拉起 Compose UI（{@link FdmOpenUi}）</li>
 *   <li>{@code setResult(Unit)} 跳过宿主那段"检查版本"逻辑 ——
 *       这样就不会再弹「当前已是最新版本」，点击语义变成「打开管理器」</li>
 * </ol>
 *
 * <p>⚠️ 热路径铁律：**任何异常都不许外抛**（宿主拿到假情报后的越界在我们 catch 之外）。
 */
public final class FdmUpdateRowHook extends XC_MethodHook {

    /** {@code pg7.z} 里「检查更新」的两个 lambda 索引。 */
    private static final int CASE_UPDATE_A = 22;
    private static final int CASE_UPDATE_B = 23;

    /** Kotlin {@code Unit} 的实例类名 —— 用来把返回值伪装成"协程正常结束"。 */
    private static final String UNIT_CLS = "kotlin.Unit";

    private static volatile boolean sInstalled = false;
    private static volatile int sHits = 0;

    /** 上一次点击的时间戳（去抖：连点不重复拉）。 */
    private static volatile long sLastOpen = 0L;

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        // ⚠️ MTH 表的键是 **"类.方法" 拼起来的完整键**（见 GmRemap.method 里的
        //    `String k = oldCls + "." + oldMth`）⇒ 这里的 oldMth 必须是真方法名。
        //    我第一版写成 clsFor("settings.row.update","settings.row.update")，
        //    拼出 "settings.row.update.settings.row.update" ⇒ 永远命中不了 ⇒
        //    静默走到 findClass("settings.row.update") 失败。**这类错不许再静默**，
        //    所以下面每一步都双通道打日志（XposedBridge + 文件）。
        final String KEY = "settings.row.update";
        final String MTH = "z";
        String clsName = GmRemap.clsFor(KEY, MTH);
        String mthName = GmRemap.method(KEY, MTH);
        log("install：解析 " + KEY + "." + MTH + " ⇒ 类=" + clsName + " 方法=" + mthName);
        if (clsName == null || mthName == null || clsName.equals(KEY)) {
            // clsAll 查不到时**原样返回旧键**（GmRemap.clsAll 最后一行 `return new String[]{old}`）
            // ⇒ 类名等于键本身就说明"没命中表"，别拿它去 findClass。
            log("✗ 未定位（Remap 没命中）⇒ 不挂");
            return;
        }
        try {
            Class<?> c = XposedHelpers.findClass(clsName, cl);
            XposedHelpers.findAndHookMethod(c, mthName, Object.class, new FdmUpdateRowHook());
            sInstalled = true;
            log("✅ 已挂「检查更新」点击 → " + clsName + "." + mthName + "（e=22/23）");
        } catch (Throwable t) {
            log("✗ 挂载失败 " + clsName + "." + mthName + "：" + t);
        }
    }

    @Override
    protected void beforeHookedMethod(MethodHookParam p) {
        try {
            int e = caseOf(p.thisObject);
            if (e != CASE_UPDATE_A && e != CASE_UPDATE_B) return;   // 别人的 lambda ⇒ 原样放行

            sHits++;
            long now = System.currentTimeMillis();
            if (now - sLastOpen < 800L) {                            // 连点去抖
                p.setResult(unitOf(p.thisObject));
                return;
            }
            sLastOpen = now;

            android.content.Context ctx = contextOf(p.thisObject);
            log("★ 命中「检查更新」点击 e=" + e + "（第 " + sHits + " 次）");

            boolean ok = false;
            if (ctx != null) {
                ok = FdmUiHook.openComposeFromHook(ctx);
            }
            log("   拉起 Compose UI → " + ok);

            // 跳过宿主的「检查版本」逻辑：给协程一个正常的结束值。
            //   取不到 Unit 就**不 setResult**（宁可让它照旧弹提示，也不要把协程搞坏）。
            Object u = unitOf(p.thisObject);
            if (u != null) {
                p.setResult(u);
                log("   已跳过宿主原逻辑（setResult=Unit）");
            } else {
                log("   取不到 kotlin.Unit ⇒ 原逻辑放行（不阻断，避免协程异常）");
            }
        } catch (Throwable t) {
            // 热路径：绝不许外抛。
            log("hook 内异常（已吞）：" + t);
        }
    }

    // ------------------------------------------------------------------ 内部

    /** 读 {@code this.e}（R8 合并 lambda 的 switch 索引）。读不到返回 -1。 */
    private static int caseOf(Object self) {
        if (self == null) return -1;
        try {
            Field f = self.getClass().getDeclaredField("e");
            f.setAccessible(true);
            return f.getInt(self);
        } catch (Throwable t) {
            return -1;
        }
    }

    /**
     * 从 lambda 的 {@code this.g} / {@code this.i} 里找 Context。
     *
     * <p>R8 把外部捕获变量塞进 {@code g}/{@code h}/{@code i} 这类 {@code Object} 字段；
     * 不同 lambda 捕获的东西不同 ⇒ **逐个试，谁像 Context 就用谁**。
     * 顺带支持 {@code Activity}/{@code ContextWrapper}（都是 Context 子类）。
     */
    private static android.content.Context contextOf(Object self) {
        if (self == null) return null;
        for (String name : new String[]{"g", "i", "h"}) {
            try {
                Field f = self.getClass().getDeclaredField(name);
                f.setAccessible(true);
                Object v = f.get(self);
                if (v instanceof android.content.Context) return (android.content.Context) v;
            } catch (Throwable ignore) {
            }
        }
        // 兜底：宿主的 Application（走框架类，名字永远不变）
        try {
            Object app = XposedHelpers.callStaticMethod(
                    Class.forName("android.app.ActivityThread"), "currentApplication");
            if (app instanceof android.content.Context) return (android.content.Context) app;
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** Kotlin {@code Unit} 单例（协程正常结束的返回值）。 */
    private static Object unitOf(Object self) {
        ClassLoader cl = (self != null) ? self.getClass().getClassLoader() : null;
        try {
            Class<?> c = Class.forName(UNIT_CLS, false, cl);
            Field inst = c.getDeclaredField("INSTANCE");
            inst.setAccessible(true);
            return inst.get(null);
        } catch (Throwable ignore) {
        }
        return null;
    }

    private static void log(String msg) {
        // 双通道：文件（GmUtil.log）+ LSPosed（XposedBridge.log）。
        //   为什么要两条：本 hook 的价值全在"到底挂没挂上"，而历史上
        //   已经因为"日志只走一条、那条恰好不通"白查过好几轮。
        String line = "【FdmUpdateRow】" + msg;
        try {
            GmUtil.log(line);
        } catch (Throwable ignore) {
        }
        try {
            de.robv.android.xposed.XposedBridge.log("[FDM] " + line);
        } catch (Throwable ignore) {
        }
    }
}
