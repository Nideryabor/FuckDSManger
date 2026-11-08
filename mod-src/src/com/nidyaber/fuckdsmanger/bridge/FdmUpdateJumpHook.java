// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 【FdmUpdateJumpHook】宿主更新弹窗里「立即更新」→ 我们的模块 🐲
 *
 * <h3>为什么这次落在这一点（和之前四次失败的方案根本不同）</h3>
 *
 * 之前所有尝试都挂在**「设置页里检查更新那一行」**上，判据是 `pg7.z` 里的 switch 索引
 * （`this.e ∈ {22,23}`）—— 而那个索引是 R8 合并出来的**路由桶下标，不承载任何语义**：
 * 复制 / 删除对话 / 重新生成 / 检查更新 **四家共用同一个桶**。
 * ⇒ 无论怎么调，硬拦都必然误伤另外三个（2026-11-07 一天内四次误伤后叫停）。
 *
 * <p>2026-11-07 从零静态重扫 2.7.5，找到**语义唯一**的那个点：
 *
 * <pre>
 *   设置页 / 自动检查 → /api/v0/check_client_update → Loib(弹窗状态)
 *     → UpdateDialog 里「立即更新」按钮 onClick = Ln4.w() case #0x19
 *         → Lzi.a(oib.c)        ← ★ 唯一落点，全 dex xref **只有这一处**
 *             → Uri.parse → Intent(ACTION_VIEW) → Context.startActivity
 *                 → 被浏览器接走，宿主**没有任何能力**跳我们自己
 * </pre>
 *
 * `Lzi`（本表语义键 {@code openlink}）**只有**一个 `Context` 字段、**只有**一个
 * `(String)V` 方法，全 dex 没有第二个调用者 ⇒ 拦它不可能误伤任何别的功能。
 *
 * <h3>这一钩同时解决两件事</h3>
 * <ol>
 *   <li><b>跳我们的模块</b>（宿主自己做不到）；</li>
 *   <li><b>「点了没反应」</b>—— 更新直链可能是空串（`alt_app.android_app_link` 与
 *       远端 kv `android_apk_link` 都空时），此时宿主 `Uri.parse("")` → ANFE 被自己的
 *       catch 吞掉 ⇒ 弹窗消失、什么都没发生。我们**不依赖 url 非空**。</li>
 * </ol>
 *
 * <h3>拉起怎么做：**借既有换乘链，不复制第二份**</h3>
 * 直接调 {@link FdmUiHook#launchWithFallback}（显式 → scheme → 广播请前台宿主代发
 * PendingIntent，外加 1.5s 看门狗 + {@link FdmFallbackDialog} 可见保底）。
 *
 * <p>为什么不自己写一套：本项目已经因为「同一个功能两处各写一遍」栽过
 * （两处各读一次开关 ⇒ 行为漂移）。**同一件事只能有一个出口。**
 *
 * <h3>吞掉原逻辑之后宿主会怎样</h3>
 * `Ln4.w()` 那段 smali 是 `try { zi.a(url) } catch (ANFE) {}` 后面紧跟
 * 「关弹窗 + 埋点」公共代码（catch 块在 try_end 之后，没有 goto）
 * ⇒ 我们吞掉 `zi.a` = try 正常结束 ⇒ **弹窗照样关、埋点照样发**，正是要的。
 *
 * <p>⚠️ 全程 try/catch，**绝不外抛**。特征不符 ⇒ 一条钩子都不挂，静默跳过。
 */
public final class FdmUpdateJumpHook {

    /** GmRemap 语义键：宿主「打开更新链接」那个类。 */
    private static final String CLS_KEY = "openlink";
    /** 那个类里唯一的方法名（2.7.5 = `a`）。 */
    private static final String MTH = "a";

    private static volatile boolean sInstalled = false;
    private static volatile ClassLoader sCl = null;

    /** 命中次数 / 最近一次 url —— 自测时读它。 */
    public static volatile int sHits = 0;
    public static volatile String sLastUrl = "";

    private FdmUpdateJumpHook() {
    }

    // ══════════════════════════════════════════════════════════════════
    //  安装
    // ══════════════════════════════════════════════════════════════════

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        sCl = cl;

        String cn = GmRemap.cls(CLS_KEY);
        Class<?> c;
        try {
            c = XposedHelpers.findClass(cn, cl);
        } catch (Throwable t) {
            // 不是错误：宿主换版 / 不在宿主进程 ⇒ 这一钩不装
            log("找不到「打开链接」类 " + cn + " ⇒ 本版不接管（不影响宿主）");
            return;
        }

        // ── 特征校验：宁可挂不上，也不要挂到错误的类上乱咬宿主 ──
        if (!looksLike(c)) {
            log("类 " + c.getName() + " 特征不符（不是「打开链接」）⇒ 放弃接管");
            return;
        }

        try {
            XposedHelpers.findAndHookMethod(c, MTH, String.class, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    onOpenLink(p);
                }
            });
            sInstalled = true;
            log("✅ 已接管宿主「立即更新」→ 模块（" + c.getName() + "." + MTH + "(String)V）");

            // ★ 顺手把「UI 真的起来了」接收器装上。
            //   为什么必须在这里装（2026-11-07 血证）：
            //     FdmUiHook.install() 的前置门槛是「能找到 GmHomeUi」——
            //     那是我们**自己的**类，只有模块进程里有 ⇒ 宿主进程永远走不到
            //     它里面那行 installUiOpenedReceiver ⇒ 看门狗永远误判「没收到
            //     UI_OPENED」⇒ 界面明明起来了还弹保底。
            //   本钩子在宿主进程里一定跑得到，正好借这里补上。
            try {
                FdmUiHook.ensureUiOpenedReceiver(cl);
            } catch (Throwable t) {
                log("装 UI_OPENED 接收器失败（只影响保底判定）：" + t);
            }
        } catch (Throwable t) {
            log("挂 " + c.getName() + "." + MTH + " 失败 ⇒ 本版不接管：" + t);
        }
    }

    /**
     * 形状校验（只看反射出来的形状，不读字节码）：
     * <ul>
     *   <li>含有 {@link Context} 类型的字段（宿主里那份是唯一字段 `a:Landroid/content/Context;`）</li>
     *   <li>有一个 `(String)V` 方法</li>
     * </ul>
     * 这两条一起，在本版全 dex 唯一。
     */
    private static boolean looksLike(Class<?> c) {
        try {
            boolean hasCtx = false;
            for (Field f : c.getDeclaredFields()) {
                if (Context.class.isAssignableFrom(f.getType())) {
                    hasCtx = true;
                    break;
                }
            }
            if (!hasCtx) return false;
            c.getDeclaredMethod(MTH, String.class);
            return true;
        } catch (Throwable t) {
            return false;
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  钩子体
    // ══════════════════════════════════════════════════════════════════

    private static void onOpenLink(XC_MethodHook.MethodHookParam p) {
        try {
            sHits++;
            Context ctx = contextOf(p.thisObject);
            String url = "";
            if (p.args != null && p.args.length > 0 && p.args[0] != null) {
                url = String.valueOf(p.args[0]);
            }
            sLastUrl = url;

            // ★ url 可能是**空串**（宿主拿不到直链时的真实形态）—— 这正是「点了没反应」的根因。
            //   我们**不以 url 非空为前提**。
            log("拦截：宿主请求打开更新链接 url=[" + url + "]"
                    + (url.isEmpty() ? "（空！宿主原本 ANFE 被吞 ⇒ 什么都不发生）" : "（非空）"));

            if (ctx == null) {
                log("拿不到 Context ⇒ 放行原逻辑（至少进浏览器）");
                return;
            }

            // 借既有换乘链：显式 → scheme → 广播请前台宿主代发 PI
            // + 1.5s 看门狗 + 可见保底弹窗（FdmFallbackDialog）
            FdmUiHook.launchWithFallback(ctx, "更新弹窗·立即更新", null);

            // 不管拉起链内部第几级，只要**已经发起**就把宿主那次 ACTION_VIEW 吞掉：
            //   · 成功 ⇒ 模块 UI 起来，正确；
            //   · 失败 ⇒ 保底弹窗会给出可见反馈（含「拉起模块 UI」重试），
            //            比莫名其妙跳进浏览器更像"这个按钮是我们的"。
            p.setResult(null);
            log("✅ 已改道（原 ACTION_VIEW 已吞）· hits=" + sHits);
        } catch (Throwable t) {
            log("钩子内异常 ⇒ 放行原逻辑：" + t);
        }
    }

    /** `thisObject` 上那个 Context 字段。 */
    private static Context contextOf(Object thisObj) {
        if (thisObj == null) return null;
        try {
            for (Field f : thisObj.getClass().getDeclaredFields()) {
                if (!Context.class.isAssignableFrom(f.getType())) continue;
                f.setAccessible(true);
                Object v = f.get(thisObj);
                if (v instanceof Context) return (Context) v;
            }
        } catch (Throwable t) {
            log("取 Context 失败：" + t);
        }
        return null;
    }

    // ══════════════════════════════════════════════════════════════════
    //  自测（不用等宿主真弹更新窗）
    // ══════════════════════════════════════════════════════════════════

    /**
     * 自己造一个「打开链接」实例，喂一个假 url 进去 —— 等价于宿主点了「立即更新」。
     *
     * <p>为什么要它：真实更新弹窗要**服务端返回新版本**才出现
     * （抓包记录：`biz_data:null` ⇒ 只弹「已是最新版本」的 Toast），测试时造不出来。
     * 有这条，一条广播就能验证整条 hook 通不通：
     * <pre>
     *   adb shell am broadcast -a com.little_femaleboy.fdm.CMD --es cmd update_jump_test
     * </pre>
     */
    public static String selfTest(Context ctx) {
        try {
            ClassLoader cl = sCl != null ? sCl : FdmUpdateJumpHook.class.getClassLoader();
            Class<?> c = XposedHelpers.findClass(GmRemap.cls(CLS_KEY), cl);
            Object inst = XposedHelpers.newInstance(c, ctx);
            Method m = c.getDeclaredMethod(MTH, String.class);
            m.setAccessible(true);
            int before = sHits;
            m.invoke(inst, "https://example.com/fdm-selftest.apk");
            return (sHits > before)
                    ? "✅ 钩子命中（hits " + before + " → " + sHits + "）"
                    : "⚠️ 钩子没命中（hits 还是 " + sHits + "）⇒ 看 install 日志";
        } catch (Throwable t) {
            return "自测失败：" + t;
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  日志
    // ══════════════════════════════════════════════════════════════════

    private static void log(String msg) {
        try {
            GmUtil.log("【FdmUpdateJump】" + msg);
        } catch (Throwable ignore) {
        }
        try {
            XposedBridge.log("[FDM][UpdateJump] " + msg);
        } catch (Throwable ignore) {
        }
    }
}
