package com.nidyaber.fuckdsmanger;

import com.nidyaber.fuckdsmanger.gm.*;
import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

import java.util.Map;

/**
 * FuckDSManger 入口（真编译版）🐲
 *
 * 本类 = 原 `com.varuns2002.disable_flag_secure.DisableFlagSecure` 的等价移植：
 * 那个类是模板（Disable-FLAG_SECURE）带过来的包名，这里换成我们自己的包。
 * 逻辑逐条对齐（含调用顺序、日志文案、异常吞并点），只修了一处已知 bug（见 hkAdd）。
 *
 * 为什么值得真编译：
 *   · 648 行手写 smali → 现在 javac 出寄存器 / 校验 / 分支，不可能再有 if-eqz 极性错
 *   · 5 个助手方法（hookM/hookM2/hookC2/hookPickAll/hkAdd）的类型由编译器盯
 *   · 以后加一条 hook = 加一行，不用再数 .registers
 */
public final class GmEntry implements IXposedHookLoadPackage {

    /** gm 包前缀（javac 会把 "GM + 类名" 折叠成单个 const-string，和原来的手写字面量一模一样）。 */
    private static final String GM = "com.nidyaber.fuckdsmanger.gm.";

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lp) {
        XposedBridge.log("FuckDSManger NL 2.22.112 handleLoadPackage ENTER");
        GmCrashHook.install();

        String pkg = lp.packageName;
        GmUtil.log("pkg=" + pkg);
        if (!pkg.startsWith("com.deepseek.chat")) return;

        GmUtil.log("===== NL 2.22.112 启动 | 日志：logcat+DIAG+文件 三通道 · 轮转256KB · 可读时间戳 =====");

        ClassLoader cl = lp.classLoader;
        GmUtil.envSafe(cl);

        // —— 早期 hook（画/图标/矢量）——
        hookM(cl, "kf5", "K", GM + "GmPainterHook");
        hookM(cl, "fh6", "N", GM + "GmPaintModHook");
        hookM(cl, "me4", "a", GM + "GmIconHook");
        GmDiag.log("GmPaintModHook registered (fh6.N identity filter)");
        hookM(cl, "android.content.res.Resources", "getValue", GM + "GmVectorHook");
        GmDiag.log("early hooks registered");

        try {
            XposedHelpers.findAndHookMethod("com.deepseek.chat.MainActivity", cl, "onResume", new GmResumeHook());
            GmUtil.log("hooked MainActivity.onResume OK");
        } catch (Throwable t) {
            GmUtil.logFail("hook onResume FAIL", t);
        }

        // —— 🐲 单包双层：桥的第一次尝试（等宿主第一个 Activity.onCreate 拿到 Context）——
        try {
            XposedHelpers.findAndHookMethod("com.deepseek.chat.MainActivity", cl, "onCreate",
                    android.os.Bundle.class, new com.nidyaber.fuckdsmanger.bridge.FdmHostReadyHook());
            GmUtil.log("hooked MainActivity.onCreate (FdmBridge 探桥) OK");
        } catch (Throwable t) {
            GmUtil.logFail("hook FdmHostReadyHook FAIL", t);
        }

        // —— 资源 / MMKV / 触摸 ——
        hookM(cl, "android.content.res.Resources", "getString", GM + "GmResTextHook");
        hookM(cl, "android.content.res.Resources", "getText", GM + "GmResTextHook");
        hookM(cl, "com.tencent.mmkv.MMKV", "q", GM + "GmMmkvHook");
        GmCrashHook.install();
        hookM(cl, "com.tencent.mmkv.MMKV", "k", GM + "GmMmkvHook");
        hookM(cl, "android.app.Activity", "dispatchTouchEvent", GM + "GmTouchHook");
        hookM(cl, "android.view.ViewGroup", "dispatchTouchEvent", GM + "GmTouchHook");
        hookM(cl, "android.view.View", "dispatchTouchEvent", GM + "GmTouchHook");

        // —— 入口 / 撤回 / 头像 ——
        hookM(cl, "m5", "v", GM + "GmEntryHook");
        hookM(cl, "h91", "a", GM + "GmRevokeHook");
        hookM(cl, "android.content.res.Resources", "getDrawable", GM + "GmAvatarHook");
        hookM(cl, "p5", "v", GM + "GmUAvatarHook");

        // —— 气泡（AI / 用户）——
        hookM(cl, "pn9", "c", GM + "GmBubbleCellHook");
        hookM(cl, "ls9", "f", GM + "GmUBubbleHook");
        hookM(cl, "uia", "v", GM + "GmBubblePaintHook");
        hookM(cl, "uia", "u", GM + "GmBubblePaintHook");
        hookM(cl, "tn0", "b", GM + "GmBubbleFitHook");
        hookC2(cl, "jd8", GM + "GmShadowHook");
        hookC2(cl, "se0", GM + "GmAlphaHook");
        hookM(cl, "se0", "c", GM + "GmAlphaHook");
        hookM(cl, "zc", "s", GM + "GmPageHook");
        GmUtil.log("[气泡] AI 气泡 hook 注册完毕（pn9.c / uia.v / uia.u / tn0.b / jd8 / se0 / zc.s）");

        // —— 账号名 / 选图 ——
        hookM(cl, "s5", "v", GM + "GmNameHook");
        hookPickAll(cl);

        // —— 服务端下发 ——
        hookM(cl, "p66", "h", GM + "GmDsHook");
        hookM(cl, "h02", "u", GM + "GmDsHook");

        // —— 通话 ——
        hookM(cl, "ao1", "I", GM + "GmCallHook");
        hookM(cl, "ao1", "J", GM + "GmCallHook");
        try {
            Class<?> c = XposedHelpers.findClass("ao1", cl);
            XposedBridge.hookAllConstructors(c, new GmCallCtorHook());
            GmUtil.log("hook ctor ao1 OK");
        } catch (Throwable t) {
            GmUtil.log("hook ctor ao1 FAIL");
        }
        try {
            Class<?> c = XposedHelpers.findClass("h91", cl);
            XposedBridge.hookAllMethods(c, "a", new GmCallSeeHook());
            GmUtil.log("hook h91.a (see ao1) OK");

            Class<?> yp = XposedHelpers.findClass("yp1", cl);
            XposedBridge.hookAllConstructors(yp, new GmCallYpHook());
            GmUtil.log("hook ctor yp1 (pair) OK");
        } catch (Throwable t) {
            GmUtil.log("hook ctor yp1 (pair) FAIL");
        }

        // —— ASR / TTS（两条探针已停用，日志留档）——
        hookM(cl, "yp1", "c", GM + "GmAsrHook");
        GmUtil.log("已停用 AudioRecord 探针（状态改由 PTT 自行设置，教训 591）");
        GmUtil.log("ASR 探针已挂（yp1.c + AudioRecord）");
        GmUtil.log("已停用 MediaPlayer/rj9 探针（教训 591）");
        GmUtil.log("TTS 播放探针已挂（MediaPlayer + 完成回调）");
        GmUtil.log("已跳过 nn1.A 钩子（它会打断发送协程，教训 577）");
        GmUtil.log("已移除 vq.S 钩子（会弄坏宿主消息列表，教训 581）；改用轮询");

        // —— 下发 / 建议 ——
        hookM(cl, "bx4", "get", GM + "GmDsHook2");
        try {
            XposedHelpers.findAndHookConstructor("bx4", cl, Map.class, new GmDsHook3());
            GmDiag.log("hooked bx4 init Map");
        } catch (Throwable t) {
            GmUtil.logFail("hook bx4 init FAIL", t);
        }
        hookM(cl, "yb5", "e", GM + "GmSuggestHook");
        hookM(cl, "yb5", "f", GM + "GmSuggestHook2");
        hookM(cl, "pd5", "I", GM + "GmPromptTextHook");
        hookM(cl, "pd5", "H", GM + "GmPromptTextHook");
        hookM(cl, "hp8", "isEmpty", GM + "GmGateListHook");
        try {
            Class<?> yp = XposedHelpers.findClass("yp1", cl);
            XposedBridge.hookAllConstructors(yp, new GmGateHook());
            GmDiag.log("hooked yp1 ctor (gate)");
        } catch (Throwable t) {
            GmUtil.logFail("hook yp1 ctor FAIL", t);
        }
        hookM(cl, "yp1", "b", GM + "GmSeeHook");
        hookM(cl, "android.content.res.Resources", "getString", GM + "GmResIdHook");
        hookM(cl, "android.content.res.Resources", "getText", GM + "GmResIdHook");
        hookM(cl, "wr", "x", GM + "GmSuggestAi");
        hookM(cl, "wr", "z", GM + "GmSuggestAi");
        hookM(cl, "h91", "a", GM + "GmSuggestAi");
        hookM(cl, "ao1", "M", GM + "GmSuggestAi");
        try {
            Class<?> c = XposedHelpers.findClass("wr", cl);
            XposedBridge.hookAllConstructors(c, new GmSuggestAi());
            GmDiag.log("hooked wr ctor (message container)");
        } catch (Throwable t) {
            GmUtil.logFail("hook wr ctor FAIL", t);
        }
        GmDiag.log("suggest hooks registered (稳定基线：无 MMKV 接管、无配置 dump)");
        GmDiag.log("handleLoadPackage done");
    }

    // ======================= 助手 =======================

    /** 按「类名 + 方法名」批量 hook（hook 类按名字 newInstance，所以能免疫宿主改名后的落空）。 */
    private static void hookM(ClassLoader cl, String cls, String method, String hookCls) {
        try {
            Class<?> c = XposedHelpers.findClass(cls, cl);
            XC_MethodHook h = (XC_MethodHook) Class.forName(hookCls).newInstance();
            int n = XposedBridge.hookAllMethods(c, method, h).size();
            String msg = "hookM " + cls + "." + method + " count=" + n;
            GmUtil.log(msg);
            GmDiag.log(msg);
        } catch (Throwable t) {
            String msg = "hookM FAIL " + cls + "." + method;
            GmUtil.logFail(msg, t);
            GmDiag.log(msg);
        }
    }

    /** 同 hookM，但把命中数记进 GmCallDialog 的自检串（当前入口未调用，保留给后续使用）。 */
    private static void hookM2(ClassLoader cl, String cls, String method, String hookCls) {
        try {
            Class<?> c = XposedHelpers.findClass(cls, cl);
            XC_MethodHook h = (XC_MethodHook) Class.forName(hookCls).newInstance();
            int n = XposedBridge.hookAllMethods(c, method, h).size();
            hkAdd(cls, method, n);
            GmUtil.log("hookM2 " + cls + "." + method + " count=" + n);
        } catch (Throwable t) {
            GmUtil.log("hookM2 FAIL " + cls + "." + method);
            hkAdd(cls, method, -1);
        }
    }

    /** hook「所有构造器」。 */
    private static void hookC2(ClassLoader cl, String cls, String hookCls) {
        try {
            Class<?> c = XposedHelpers.findClass(cls, cl);
            XC_MethodHook h = (XC_MethodHook) Class.forName(hookCls).newInstance();
            int n = XposedBridge.hookAllConstructors(c, h).size();
            hkAdd(cls, "<init>", n);
            GmUtil.log("hookC2 " + cls + ".<init> count=" + n);
        } catch (Throwable t) {
            hkAdd(cls, "<init>", -1);
        }
    }

    /** 沿继承链一路 hook onActivityResult（宿主 androidx 被混淆过，写死一个类不稳）。 */
    private static void hookPickAll(ClassLoader cl) {
        try {
            Class<?> c = XposedHelpers.findClass("com.deepseek.chat.MainActivity", cl);
            int n = 0;
            while (c != null) {
                n += XposedBridge.hookAllMethods(c, "onActivityResult", new GmPickHook()).size();
                c = c.getSuperclass();
            }
            GmUtil.log("FuckDSManger: pick hooks dynamic total=" + n);
        } catch (Throwable t) {
            GmUtil.logFail("FuckDSManger: pick hooks dynamic FAIL", t);
        }
    }

    /**
     * 往「通话诊断对话框」的自检串里追加一条 `类.方法=命中数 | `。
     *
     * 🐛 修 bug：原 smali 的分支是 `if-nez v1, :cond_c`（非空才跳过 append）
     *    ⇒ append 只在 sHookInfo == null 时执行 ⇒ 第一次调用会把字面量 "null" 拼进去
     *    （自检串变成 `nullcom.ao1.I=3 | ...`）。这里改成「非空才 append」。
     */
    private static void hkAdd(String cls, String method, int n) {
        try {
            StringBuilder sb = new StringBuilder();
            String cur = GmCallDialog.sHookInfo;
            if (cur != null) sb.append(cur);
            sb.append(cls).append(".").append(method).append("=").append(n).append(" | ");
            GmCallDialog.sHookInfo = sb.toString();
        } catch (Throwable t) {
            // 诊断串而已，坏了也不影响功能（对齐原 smali 的空 catch）
        }
    }
}
