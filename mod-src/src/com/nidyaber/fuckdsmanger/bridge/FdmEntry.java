package com.nidyaber.fuckdsmanger.bridge;

import android.os.Bundle;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 单包的 Xposed 入口（薄壳）🐲
 *
 * 它只做三件事：
 *   ① 装「宿主活了」的钩子 ⇒ 给 FdmBridge 一次拿到 Context 的机会（探桥）
 *   ② 把 handleLoadPackage **反射转发**给底座 dex 里那个真入口
 *      `com.nidyaber.fuckdsmanger.GmEntry`（51 条 hook 注册全在它那儿）
 *   ③ 装「检查更新」换乘钩（{@link FdmUiHook}）：底座那个 View 弹窗 → Compose UI
 *
 * ── 为什么不直接把 GmEntry 当入口 ──────────────────────────────
 * 底座 dex（2.22.120）里**已经有一个 `com.nidyaber.fuckdsmanger.GmEntry`**。
 * 如果我们再把同名类编进自己的 dex，就会出现「两个 dex 定义同一个类」——
 * 谁被加载取决于 dex 顺序 ⇒ **看起来能跑、行为随机**，是排查起来最恶心的那类隐患。
 * 所以这里换一个全新的类名，用反射去拿底座那个。**一个类都不重复。**
 *
 * ── 为什么入口要分两层 ────────────────────────────────────────
 * 底座 dex 是**二进制成品**（手写 smali 时代留下的），不能改。
 * 桥（这一层）是我们能自由编译的部分 —— 所以就长在入口外面。
 */
public final class FdmEntry implements IXposedHookLoadPackage {

    /** 底座 dex 里的真入口。 */
    private static final String BASE_ENTRY = "com.nidyaber.fuckdsmanger.GmEntry";

    private static final String HOST = "com.deepseek.chat";

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lp) {
        XposedBridge.log("[FDM] FdmEntry.handleLoadPackage pkg=" + lp.packageName);

        if (lp.packageName != null && lp.packageName.startsWith(HOST)) {
            // 主锚点：宿主的入口 Activity
            try {
                XposedHelpers.findAndHookMethod("com.deepseek.chat.MainActivity", lp.classLoader,
                        "onCreate", Bundle.class, new FdmHostReadyHook());
                XposedBridge.log("[FDM] 探桥钩子已挂（MainActivity.onCreate）");
            } catch (Throwable t) {
                XposedBridge.log("[FDM] 探桥钩子（MainActivity）挂载失败：" + t);
            }
            // 备用锚点：所有 Activity —— 宿主要是换了入口类，靠这个也能拿到 Context。
            // （FdmBridge 内部只做一次，所以这里多挂一个几乎零成本）
            try {
                XposedHelpers.findAndHookMethod("android.app.Activity", lp.classLoader,
                        "onCreate", Bundle.class, new FdmHostReadyHook());
                XposedBridge.log("[FDM] 探桥备用钩子已挂（Activity.onCreate）");
            } catch (Throwable t) {
                XposedBridge.log("[FDM] 探桥备用钩子挂载失败：" + t);
            }
        }

        try {
            Class<?> c = Class.forName(BASE_ENTRY, true, FdmEntry.class.getClassLoader());
            Object o = c.getDeclaredConstructor().newInstance();
            c.getMethod("handleLoadPackage", XC_LoadPackage.LoadPackageParam.class).invoke(o, lp);
            XposedBridge.log("[FDM] 已转发给底座入口 " + BASE_ENTRY + " ✓");
        } catch (Throwable t) {
            XposedBridge.log("[FDM] ❌ 转发底座入口失败：" + t);
        }

        // ③ 「检查更新」换乘：底座的 View 弹窗（GmHomeUi）→ 我们的 Compose UI
        //    放在转发【之后】：底座那 51 条钩子先注册完，我们再往 GHomeUi.open 上补一钩。
        //    （install 内部自己判断在不在宿主进程 —— 找不到 GmHomeUi 就静默跳过）
        try {
            FdmUiHook.install(FdmEntry.class.getClassLoader());
        } catch (Throwable t) {
            XposedBridge.log("[FDM] FdmUiHook.install 抛了（不影响其它钩子）：" + t);
        }
    }
}
