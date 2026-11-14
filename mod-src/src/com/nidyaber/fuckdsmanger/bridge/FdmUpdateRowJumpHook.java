// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 【FdmUpdateRowJumpHook】设置页「检查更新」那一行 → 我们的模块 🐲
 *
 * <h3>为什么不用旧的 {@link FdmUpdateRowHook}（挂 pg7.z / sj0.h）</h3>
 * 那一版挂的是 <b>R8 合并出来的路由桶</b>：
 * <pre>
 *   pg7.z(:428)  switch(this.e)   ← this.e 只是 lambda 在合并类里的**下标**
 *      e=22 → 「检查更新」
 *      e=23 → 「检查更新」（第二个 lambda）
 *      但「复制 / 删除对话 / 重新生成」**也落在这个桶里**
 * </pre>
 * `sj0.h` 更糟 —— 它是**所有协程 resume 的公共入口**。
 * ⇒ 无论怎么调判据，硬拦都必然误伤另外三个功能（2026-11-07 一天内四次误伤后叫停）。
 *
 * <h3>新落点：{@code fy2.a(Lec3)Object}</h3>
 * 2.7.5 的 `fy2` 是 UpdateViewModel，它有两个入口：
 * <ul>
 *   <li>{@code a(Lec3)} —— 方法体里**写死** {@code "check_update"} ⇒ <b>手动检查（就它）</b></li>
 *   <li>{@code b(String, long, Lec3)} —— scenario 由参数传入（{@code "conversation"} 等）自动检查</li>
 * </ul>
 * 而 {@code a()} 的 xref 全 dex 只有 2 处，且**都是它自己的协程状态机**
 * （{@code cy2.z} = lambda 的 invokeSuspend、{@code dx9.z} = 设置页那一行的调用点）。
 * ⇒ 语义唯一：拦它只可能影响「手动检查更新」这一件事。
 *
 * <h3>★ 为什么**不** setResult（这是本轮最重要的决定）</h3>
 * 它是 {@code suspend} 函数。给 suspend 函数伪造返回值 = 破坏协程协议，历史血证：
 * <pre>
 *   给 lambda 体塞 kotlin.Unit（≠ COROUTINE_SUSPENDED）
 *     ⇒ sj0.h 判定"没挂起、立刻返回" ⇒ 回头再调一次 ⇒ **无限循环 + Toast 刷屏**
 * </pre>
 * 所以本类**只在 before 里做一件事**：把我们的 UI 拉起来，然后<b>原样放行</b>。
 * 宿主那次检查更新照跑（一次网络请求，无害），但它的**效果**已经被
 * {@link FdmUpdatePopupHook} 拦着了（「已是最新版本」Toast / 「发现新版本」Dialog）。
 *
 * <p>主人的观感因此是：<b>点「检查更新」→ 我们的模块界面起来，宿主不弹东西</b>。
 *
 * <p>⚠️ 全程 try/catch、不在主线程做重活、不阻塞协程调度线程。
 */
public final class FdmUpdateRowJumpHook {

    /** GmRemap 语义键：UpdateViewModel 的「手动检查更新」入口。 */
    private static final String CLS_KEY = "updatevm";
    private static final String MTH_KEY = "check";

    /** 防抖：同一个 ViewModel 实例 1.5s 内只拉一次 UI（协程可能重入）。 */
    private static volatile long sLastOpenAt = 0L;
    private static volatile int sHits = 0;

    private static volatile boolean sInstalled = false;
    private static volatile ClassLoader sCl = null;

    private FdmUpdateRowJumpHook() {
    }

    public static int hits() {
        return sHits;
    }

    // ══════════════════════════════════════════════════════════════════
    //  安装
    // ══════════════════════════════════════════════════════════════════

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        sCl = cl;

        String cn = GmRemap.clsFor(CLS_KEY, MTH_KEY);
        String mn = GmRemap.method(CLS_KEY, MTH_KEY);

        Class<?> c;
        try {
            c = XposedHelpers.findClass(cn, cl);
        } catch (Throwable t) {
            log("找不到 UpdateViewModel 类 " + cn + " ⇒ 本版不接管「检查更新」那一行");
            return;
        }

        Method target = findTarget(c, mn);
        if (target == null) {
            log("类 " + c.getName() + " 里没有符合形状的 " + mn
                    + "(单参 → Object) 方法 ⇒ 本版不接管");
            return;
        }

        try {
            XposedBridge.hookMethod(target, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    onCheckUpdate(p);
                }
            });
            sInstalled = true;
            log("✅ 已接管设置页「检查更新」→ 模块（"
                    + c.getName() + "." + target.getName() + "("
                    + simple(target.getParameterTypes()[0]) + ")Object）");
        } catch (Throwable t) {
            log("挂 " + c.getName() + "." + mn + " 失败 ⇒ 本版不接管：" + t);
        }
    }

    /**
     * 找那个 suspend 入口。
     *
     * <p>形状判据（不靠字节码，只靠反射）：
     * <ul>
     *   <li>名字对得上（2.7.5 = {@code a}）</li>
     *   <li><b>恰好 1 个参数</b>（那个参数就是 {@code Continuation}，宿主里叫 {@code Lec3}）</li>
     *   <li>返回 {@code Object}（suspend 函数的固定返回类型）</li>
     *   <li>非 static（它要用 ViewModel 实例字段）</li>
     * </ul>
     * {@code b(String,long,Lec3)} 是 3 个参数 ⇒ 天然被排除。
     */
    private static Method findTarget(Class<?> c, String name) {
        try {
            for (Method m : c.getDeclaredMethods()) {
                if (!name.equals(m.getName())) continue;
                if (Modifier.isStatic(m.getModifiers())) continue;
                if (m.getParameterTypes().length != 1) continue;
                if (m.getReturnType() != Object.class) continue;
                log("形状命中：" + m);
                return m;
            }
        } catch (Throwable t) {
            log("枚举方法失败：" + t);
        }
        return null;
    }

    // ══════════════════════════════════════════════════════════════════
    //  钩子体
    // ══════════════════════════════════════════════════════════════════

    private static void onCheckUpdate(XC_MethodHook.MethodHookParam p) {
        try {
            sHits++;
            long now = System.currentTimeMillis();
            if (now - sLastOpenAt < 1500L) {
                log("1.5s 内已拉起过（" + (now - sLastOpenAt) + "ms）⇒ 本次只计数");
                return;
            }
            sLastOpenAt = now;

            Context ctx = hostContext();
            if (ctx == null) {
                log("拿不到宿主 Context ⇒ 只放行（宿主照常检查更新）");
                return;
            }

            // ★★ 2026-11-13 改：**不再在这里拉起模块**。
            //
            //   血证（真机日志 22:27:57~22:28:02，一次点击弹两个窗）：
            //     22:27:57.178  【选择页】内容已填 / 已显示        ← FdmUpdateIntercept 负责
            //     22:27:58.462  【本类】被点 ⇒ 改道我们的模块       ← ★ 晚 1.26s，抢跑
            //     22:27:58.467  显式拉起失败 → 广播 → 1.5s 看门狗
            //     22:27:59.498  ✅ 保底弹窗已显示                  ← ★ 多出来的第二个窗
            //
            //   根因：选择页是**进程内 Compose**，弹出来只要 24ms；
            //        而宿主的点击事件要等 Composition 重绘后才到，晚了 1.26 秒。
            //        两个入口各弹各的 ⇒ 叠窗。
            //
            //   ⇒ 分工：**本类只做「知道被点了」**（写日志 / 计数），
            //           **弹窗一律交给 FdmUpdateIntercept 的选择页**。
            //     而选择页里的「打开模块」按钮才真正调 launchWithFallback。
            log("设置页「检查更新」被点（hits=" + sHits + "）");

            // ★★ 2026-11-13 修：**在这里弹选择页**
            //
            //   血证（真机日志）：原以为「getString(标题)」被调用 = 那一行被点，
            //   结果那个字符串**只在设置页首次渲染时取一次**（22:31:07），
            //   之后每次点击都不会再取 ⇒ 选择页只弹过 1 次，后面全"点了没反应"。
            //   ⇒ **点击事件**才是可靠的触发点，而本类的 beforeHookedMethod
            //     就是宿主「检查更新」点击逻辑的入口（updatevm.check）。
            FdmUpdateIntercept.showChoiceFromHook(ctx);

            // ★ 不动 result —— suspend 函数绝不能伪造返回值（见类注释）。
            //   宿主那次检查更新照跑，它的 Toast/Dialog 由 FdmUpdatePopupHook 拦。
        } catch (Throwable t) {
            log("钩子内异常 ⇒ 放行：：" + t);
        }
    }

    /** 宿主进程的 Application Context（拿不到就 null，绝不上抛）。 */
    private static Context hostContext() {
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Method m = at.getDeclaredMethod("currentApplication");
            m.setAccessible(true);
            Object app = m.invoke(null);
            if (app instanceof Context) return (Context) app;
        } catch (Throwable ignore) {
        }
        try {
            // 退路：当前 Activity 本身也是 Context
            android.app.Activity a = FdmHostActivity.current();
            if (a != null) return a;
        } catch (Throwable ignore) {
        }
        return null;
    }

    private static String simple(Class<?> c) {
        try {
            return c == null ? "?" : c.getName();
        } catch (Throwable t) {
            return "?";
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  日志
    // ══════════════════════════════════════════════════════════════════

    private static void log(String msg) {
        try {
            GmUtil.log("【FdmUpdateRowJump】" + msg);
        } catch (Throwable ignore) {
        }
        try {
            XposedBridge.log("[FDM][UpdateRow] " + msg);
        } catch (Throwable ignore) {
        }
    }
}
