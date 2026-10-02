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

    /**
     * 「是不是宿主」的判据 —— **看锚点在不在，不看它叫什么包**。
     *
     * 这些是宿主自己的（混淆）类名，本来就是我们整套 hook 的锚点；
     * 宿主升级时它们跟其它锚点一起重新定位 ⇒ **不额外引入脆弱点**。
     * 而包名判据（旧写法 `packageName.startsWith("com.deepseek.chat")`）坏起来是**静默**的：
     * 宿主改个包名 ⇒ 一条钩子都不挂，连日志都进不去。
     *
     * 取名依据：`kf5` / `uia` / `fh6` 都是底座第一梯队挂的宿主类（见 `GmEntry.handleLoadPackage`）。
     */
    private static final String[] HOST_ANCHORS = {"kh7", "qk7", "w2b"};   // 2.6.1 重定位（旧名 kf5/uia/fh6 在新宿主里是【别的类】）

    /** 任一锚点能找到 ⇒ 这就是宿主。名字无关；全找不到才判非宿主。 */
    private static boolean isHost(ClassLoader cl) {
        for (String a : HOST_ANCHORS) {
            try {
                XposedHelpers.findClass(a, cl);
                return true;
            } catch (Throwable ignore) {
                // 试下一个锚点
            }
        }
        return false;
    }

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lp) {
        XposedBridge.log("[FDM] FdmEntry.handleLoadPackage pkg=" + lp.packageName);

        if (isHost(lp.classLoader)) {
            // ★ 落点用**框架类**：`android.app.Application` 的名字永远不变。
            //   旧写法锚的是 `com.deepseek.chat.MainActivity`，宿主一换包名/类名就静默哑掉。
            //   顺带一个好处：Application.onCreate **只跑一次** ⇒ 拿 Context 比逐 Activity 更早、更省。
            try {
                XposedHelpers.findAndHookMethod("android.app.Application", lp.classLoader,
                        "onCreate", new FdmHostReadyHook());
                XposedBridge.log("[FDM] 探桥钩子已挂（Application.onCreate）");
            } catch (Throwable t) {
                // 类名永不变的框架类都挂不上，那就退到 Activity（同样是框架类，多一层保险）
                XposedBridge.log("[FDM] 探桥钩子（Application）挂载失败，退到 Activity：" + t);
                try {
                    XposedHelpers.findAndHookMethod("android.app.Activity", lp.classLoader,
                            "onCreate", Bundle.class, new FdmHostReadyHook());
                    XposedBridge.log("[FDM] 探桥备用钩子已挂（Activity.onCreate）");
                } catch (Throwable t2) {
                    XposedBridge.log("[FDM] 探桥备用钩子挂载失败：" + t2);
                }
            }
        } else {
            XposedBridge.log("[FDM] 锚点不在 ⇒ 不是宿主，跳过探桥（pkg=" + lp.packageName + "）");
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

        // ④.5 运行时自证探针（临时，找 2.6.1 的设置行锚点用）
        if (isHost(lp.classLoader)) {
            try {
                GmProbe.install(lp.classLoader);
                XposedBridge.log("[FDM] GmProbe 已安装");
            } catch (Throwable t) {
                XposedBridge.log("[FDM] GmProbe 安装失败：" + t);
            }
        }

        // ④.6 通话页留驻（2026-10-02）：hook CallPageViewModel 的「要不要渲染通话页」闸门。
        //      放在这里是因为**只有这里能拿到 lp.classLoader（宿主自己的 ClassLoader）**，
        //      用桥的 loader 去 findClass("oq1") 不一定找得到。
        //      锚点找不到就自己 catch（宿主升级改名 ⇒ 等于没装，绝不连累宿主）。
        if (isHost(lp.classLoader)) {
            try {
                GmCallPin.install(lp.classLoader);
            } catch (Throwable t) {
                XposedBridge.log("[FDM] GmCallPin.install 抛了（不影响其它钩子）：" + t);
            }
        }

        // ④ 液态玻璃（2026-09-30）：给宿主所有按钮上玻璃。
        //    只在宿主进程装（isHost 判过）；里面全是 try/catch，坏也坏不到宿主身上。
        if (isHost(lp.classLoader)) {
            try {
                com.nidyaber.fuckdsmanger.glass.GmGlassInstall.install(lp.classLoader);
                XposedBridge.log("[FDM] 液态玻璃已安装");
            } catch (Throwable t) {
                XposedBridge.log("[FDM] 液态玻璃安装失败（不影响其它钩子）：" + t);
            }
        }
    }
}
