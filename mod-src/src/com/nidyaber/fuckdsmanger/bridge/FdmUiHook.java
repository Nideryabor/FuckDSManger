package com.nidyaber.fuckdsmanger.bridge;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Field;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 入口换乘站：「检查更新」 → Compose UI 🐲
 *
 * ── 为什么要挂这一钩 ─────────────────────────────────────────────
 * 底座（2.22.120）里的 {@code GmEntryHook} 抓住宿主设置页那一行「检查更新」之后，
 * 直接调 {@code GmHomeUi.open()} —— 那是**手写 smali 时代的 View 弹窗**。
 * View 路线已经弃用（UI 全部搬进 Compose，见 {@code fdm-app/}），
 * 但底座 dex 是**二进制成品**（128 类），不想为了改一行调用就重造整个底座。
 *
 * ⇒ 那就把 {@code GmHomeUi.open()} **自己**挂上：
 *   ① 先拉起 Compose 的 {@code MainActivity}；
 *   ② 拉起来了 ⇒ {@code setResult(null)} 把旧弹窗**跳过**；
 *   ③ 拉不起来 ⇒ **原样放行**，旧 View UI 顶上（兜底，绝不会「点了没反应」）。
 *
 * ── 为什么不 hook 宿主那一行 ────────────────────────────────────
 * 宿主那行是**混淆过的**（判据是 `getIntField(thisObject, "a") == 0x14`），
 * 锚点随宿主版本漂移；而 {@code GmHomeUi} 是**我们自己的类**，名字永远不变。
 * ⇒ 挂它最稳，宿主升级也不影响这一钩。
 *
 * 跑在**宿主进程**（由 {@link FdmEntry} 在 handleLoadPackage 里装）。
 */
public final class FdmUiHook {

    /** 底座里那个旧 View 主页（换乘对象）。 */
    private static final String OLD_UI = "com.nidyaber.fuckdsmanger.gm.GmHomeUi";
    /** 底座 dex 里存着「当前宿主 Activity」的那个类。
     *  ⚠️ 注意：底座里有**两个** `GmEntry` ——
     *    · `com.nidyaber.fuckdsmanger.GmEntry`     = 入口（handleLoadPackage）
     *    · `com.nidyaber.fuckdsmanger.gm.GmEntry`  = **存 `sAct` 的是这个**
     *  3.13.0 我写错过一次，日志里是 `NoSuchFieldError`，靠兜底 `ActivityThread.currentApplication()` 才起来。 */
    private static final String BASE_ENTRY = "com.nidyaber.fuckdsmanger.gm.GmEntry";

    /** 我们的 Compose UI。 */
    private static final String UI_ACT = "com.nidyaber.fuckdsmanger.MainActivity";
    /** scheme 兜底通道（清单里 MainActivity 第二张 intent-filter 接的就是它）。 */
    private static final String UI_URI = "fdm://open";

    private static volatile boolean sInstalled = false;

    private FdmUiHook() {
    }

    /**
     * 装上「入口换乘」这一钩。
     *
     * ★ 幂等 + **不误置位**：找不到 {@code GmHomeUi}（＝不在宿主进程 / 底座没这份类）
     *   就直接静默返回，**不把 sInstalled 置真** —— 否则第一次在错进程里空跑一次，
     *   后面真正该装的那次就被自己挡掉了。
     *
     * 任何失败都只记日志，**绝不影响宿主**。
     */
    public static void install(ClassLoader cl) {
        if (sInstalled) return;

        Class<?> oldUi;
        try {
            oldUi = XposedHelpers.findClass(OLD_UI, cl);
        } catch (Throwable t) {
            return;                     // 不在宿主进程 ⇒ 不是错误，静默跳过
        }

        try {
            XposedHelpers.findAndHookMethod(oldUi, "open", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        if (openCompose(FdmUiHook.class.getClassLoader())) {
                            // void 方法 ⇒ 原方法体不再执行 = 旧 View 弹窗被跳过
                            p.setResult(null);
                        }
                    } catch (Throwable t) {
                        GmUtil.logFail("【FdmUiHook】换乘失败（放行旧 UI）", t);
                    }
                }
            });
            sInstalled = true;
            GmUtil.log("【FdmUiHook】已接管「检查更新」→ Compose UI ✓");
            XposedBridge.log("[FDM] 已接管「检查更新」→ Compose UI ✓");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmUiHook】挂载失败（保留旧 View UI）", t);
            XposedBridge.log("[FDM] FdmUiHook 挂载失败（保留旧 View UI）：" + t);
        }
    }

    // ------------------------------------------------------------------ 内部

    /**
     * @return true ＝ Compose UI 已拉起（调用方应当跳过旧弹窗）
     */
    private static boolean openCompose(ClassLoader cl) {
        Context ctx = hostContext(cl);
        if (ctx == null) {
            GmUtil.log("【FdmUiHook】拿不到宿主 Context ⇒ 不换乘，走旧 UI");
            return false;
        }

        // ① 显式 ComponentName —— 最稳
        //    （清单里 <application android:forceQueryable="true"> + MainActivity exported=true
        //      ⇒ 宿主看得见我们这个包，显式拉起是允许的）
        Intent i = new Intent(Intent.ACTION_VIEW);
        i.setComponent(new ComponentName(FdmBridge.MODULE_PKG, UI_ACT));
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        if (start(ctx, i, "显式")) return true;

        // ② scheme trampoline —— 兜底（隐式 + setPackage 收敛到我们包）
        Intent t = new Intent(Intent.ACTION_VIEW, Uri.parse(UI_URI));
        t.setPackage(FdmBridge.MODULE_PKG);
        t.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (start(ctx, t, "scheme")) return true;

        GmUtil.log("【FdmUiHook】两条路都没起来 ⇒ 回退旧 View UI");
        return false;
    }

    private static boolean start(Context ctx, Intent i, String how) {
        try {
            ctx.startActivity(i);
            GmUtil.log("【FdmUiHook】已拉起 Compose UI ✓（" + how + "）");
            return true;
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】" + how + " 拉起失败：" + t);
            return false;
        }
    }

    /**
     * 拿宿主 Context。
     *
     * 首选 {@code GmEntry.sAct}（底座存着「当前 Activity」，最准）；
     * 它是**包级私有**字段 ⇒ 必须 setAccessible（这是踩过的坑：
     * `IllegalAccessError: Field … is inaccessible`）。
     * 兜底走 {@code ActivityThread.currentApplication()}。
     */
    private static Context hostContext(ClassLoader cl) {
        try {
            Class<?> e = XposedHelpers.findClass(BASE_ENTRY, cl);
            Field f = XposedHelpers.findField(e, "sAct");
            f.setAccessible(true);
            Object o = f.get(null);
            if (o instanceof Context) return (Context) o;
        } catch (Throwable t) {
            GmUtil.log("【FdmUiHook】取 GmEntry.sAct 失败：" + t);
        }
        try {
            Object app = XposedHelpers.callStaticMethod(
                    Class.forName("android.app.ActivityThread"), "currentApplication");
            if (app instanceof Context) return (Context) app;
        } catch (Throwable ignore) {
        }
        return null;
    }
}
