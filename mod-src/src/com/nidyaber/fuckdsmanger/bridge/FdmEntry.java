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

        // ⑤ 系统提示词注入（2026-10-03）：hook `ChatFullCompletionRequest` 的构造器，
        //    把用户填的「系统提示词」用 Unicode Tag 隐形字符（U+E0000–E007F）塞进 prompt。
        //    模型读得到、人眼看不见 —— 这是 DeepSeek 官方通道下唯一可行的形态
        //    （协议层没有 system 位，已穷举证明，见 专题/系统提示词-不留痕投递.md）。
        //    锚点找不到就自己 catch（宿主升级改名 ⇒ 等于没装，绝不连累宿主）。
        if (isHost(lp.classLoader)) {
            try {
                GmSysPromptHook.install(lp.classLoader);
                XposedBridge.log("[FDM] 系统提示词注入已安装");
            } catch (Throwable t) {
                XposedBridge.log("[FDM] 系统提示词注入安装失败（不影响其它钩子）：" + t);
            }
        }

        // ⑥ 文件卡片定位探针（2026-10-03）—— ★ **默认不注册**。
        //    它当初是为「系统提示词当附件发」定位文件卡片用的；最终形态改用
        //    「明文承载 + 渲染抹显示」（见 GmSysPromptHideHook），探针使命结束。
        //    代码留着是因为**宿主升级后重新定位渲染点**时还能用上 —— 要用就把下面那段注释打开。
        // if (isHost(lp.classLoader)) {
        //     try {
        //         GmFileCardProbe.install(lp.classLoader);
        //     } catch (Throwable t) {
        //         XposedBridge.log("[FDM] 文件卡片探针安装失败：" + t);
        //     }
        // }

        // ⑦ 系统提示词 · 显示侧隐藏（2026-10-03）
        //    明文承载的一半：prompt 里带着 ⟦FDM⟧提示词⟦/FDM⟧ 明文发出去（模型零风险），
        //    但要在渲染前把这一段从气泡里**删掉** —— 用户看到的就只是他自己写的那句话。
        //    做法是"宽容版"：不问它在哪个字段，渲染参数里只要出现过定界标记就地换掉。
        if (isHost(lp.classLoader)) {
            try {
                GmSysPromptHideHook.install(lp.classLoader);
                XposedBridge.log("[FDM] 提示词显示侧隐藏已安装");
            } catch (Throwable t) {
                XposedBridge.log("[FDM] 提示词显示侧隐藏安装失败：" + t);
            }
        }

        // ⑧ AI 气泡富文本（2026-10-03）
        //    AI 回复里出现 ⟦FDM:模板名|参数⟧ 时，把**这一段**换成主人配好的富文本
        //    （标记前后的普通文字照旧）。落点选 fz2.p —— 成品 AnnotatedString 的
        //    唯一汇流点（thinking/引用预览/分享预览各走各的入口，最后都得从这儿过）。
        //    做法是用**宿主自己的** AnnotatedString.Builder 重建：
        //      原文段 → in.c(orig, start, end)   ← 样式自动跟着走，位置映射问题直接消失
        //      标记段 → in.j(style) + in.e(text) + in.f()
        //    锚点/自检任何一步不过 ⇒ 整条不启用，宿主毫发无损。
        //    详见 专题/AI气泡富文本-锚点勘察.md。
        if (isHost(lp.classLoader)) {
            try {
                GmRichTextHook.install(lp.classLoader);
                XposedBridge.log("[FDM] AI气泡富文本：" + GmRichTextHook.status());
            } catch (Throwable t) {
                XposedBridge.log("[FDM] AI气泡富文本安装失败（不影响其它钩子）：" + t);
            }
        }

        // ⑨' 建议点击 + 发送入口探针（2026-10-05）
        //   两件事一起验：
        //     ⓐ <Suggestion> 渲染成的链接，点击时我们的 listener 到底会不会被调到
        //        （整条路唯一的未验证环节 —— pushLink 机制与宿主链接可点都已实证）
        //     ⓑ 2.6.1 的"发送"入口在 gh2 的哪个方法上
        //        （2.5.2 的 ao1.I / yp1 在 2.6.1 已失效，见 GmSendProbe 头注释）
        //   本版**只打日志、不改行为** —— 主人点一次建议、点一次发送按钮，看日志即可。
        if (isHost(lp.classLoader)) {
            try {
                GmSendProbe.install(lp.classLoader);
                XposedBridge.log("[FDM] 发送探针：" + GmSendProbe.status());
            } catch (Throwable t) {
                XposedBridge.log("[FDM] 发送探针安装失败（不影响其它钩子）：" + t);
            }
        }

        // ⑨ AI 气泡渲染任意 HTML（2026-10-03）
        //    Compose 里"自己塞控件"对我们封死（AndroidView 是 @Composable，纯 javac 写不了），
        //    所以**搭宿主自己的车**：宿主用 WebView 渲染 ```mermaid 代码块，我们
        //      ① 让 ```html 也走那条语言闸门（v7a.M）
        //      ② 在 MermaidViewerWebView 要把源码喂给 mermaid.js 的那一刻，
        //         改成 loadDataWithBaseURL 装载 AI 的 HTML
        //    ⇒ 位置/尺寸/回收/滚动全由宿主自己管。
        //    ⚠️ 两个闸门必须一起成功才启用（只改一个会导致界面显示"渲染失败"）。
        if (isHost(lp.classLoader)) {
            try {
                GmHtmlHook.install(lp.classLoader);
                XposedBridge.log("[FDM] HTML 渲染：" + GmHtmlHook.status());
            } catch (Throwable t) {
                XposedBridge.log("[FDM] HTML 渲染安装失败（不影响其它钩子）：" + t);
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
