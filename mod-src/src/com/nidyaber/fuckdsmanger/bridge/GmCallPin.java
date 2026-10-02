package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedHelpers;

/**
 * 「通话页留驻」🐲 尼得亚伯 2026-10-02
 *
 * <h3>要解决的问题</h3>
 * 宿主的通话页（CallPage）由 {@code ChatCallHost}（ChatCallHost.kt:32）渲染，条件是一句：
 * <pre>
 *     if (callPageViewModel.a())  CallPage(...)
 * </pre>
 * 而 {@code a()} 的真身（`Loq1;->a()Z`，反编译实证）是：
 * <pre>
 *     val v = vy0.v0(state)        // state == v01(进行态) 时取出内部标记；w01(空闲态) 时 null
 *     if (v == this.b) return vy0.u0(state)   // 标记匹配 且 标志位为真
 *     return false
 * </pre>
 * ⇒ **服务端一还错误（如 call/start 的 `call mode disabled`），状态回落到 `w01`(空闲)，
 *    `a()` 立刻变 false ⇒ 通话页被摘掉** —— 用户根本来不及看清它长什么样。
 *
 * <h3>怎么留</h3>
 * hook {@code a()} 的**返回值**：开关开着且它想返回 false 时，**改成 true**。
 * ⇒ 通话页就留在那儿了（用户手动返回仍可正常离开 —— 我们不碰导航）。
 *
 * <h3>副作用（已知，可控）</h3>
 * `a()` 还被 `hq`(ChatCallState) / `f82` / `y42` 调用 ⇒ 开着本开关时，
 * **聊天页也可能认为"正在通话中"**（比如多一条通话横幅）。
 * 不会崩，而且**随时可以关开关**回到原样。
 *
 * <h3>安全性</h3>
 * <ul>
 *   <li>锚点找不到（宿主升级改名）⇒ {@code install} 自己 catch 掉 ⇒ 等于没装，**绝不连累宿主**</li>
 *   <li>hook 体全程 try/catch</li>
 *   <li>只改**返回值**，不动任何参数/宿主字段</li>
 * </ul>
 */
public final class GmCallPin {

    /** 我们自己的开关键。 */
    public static final String KEY_ON = "fuckds_call_pin";

    /**
     * ★ 锚点（宿主 2.6.1）：
     *   `Loq1;`  = CallPageViewModel（有 `onAction$app(CallPageAction)` / `close$app(J)`）
     *   `a()Z`   = 「要不要渲染通话页」的闸门
     * ⚠️ 这两个都是**混淆名** —— 宿主升级时必须跟着 `GmRemap` 一起重新定位。
     */
    private static final String CLS_VM = "oq1";
    private static final String M_SHOW = "a";

    /**
     * ★★ 2026-10-02 修（主人实测："杀后台再打开也是通话页"）：
     * 光"恒 true"会把**冷启动**也一起强拉 —— 那时状态是空闲(`w01`)，压根不该有通话页。
     * ⇒ 加一道门：**只有本进程内「通话页真的活跃过」，之后才允许留驻**。
     *   冷启动后 {@code sOpened=false} ⇒ 完全不干预 ⇒ 不会再无中生有一个通话页。
     */
    private static volatile boolean sOpened = false;

    private GmCallPin() {}

    /** 开关状态（默认关）。 */
    public static boolean on(Context ctx) {
        try {
            return "1".equals(GmStore.read2(ctx, KEY_ON, "s"));
        } catch (Throwable t) {
            return false;
        }
    }

    public static void setOn(Context ctx, boolean b) {
        try {
            GmStore.write(ctx, KEY_ON, b ? "1" : "0", "s");
        } catch (Throwable t) {
            GmUtil.logFail("[留驻] setOn 失败", t);
        }
    }

    /** 状态串（给 UI）："1" / "0"。 */
    public static String state(Context ctx) {
        return on(ctx) ? "1" : "0";
    }

    /**
     * 在**宿主进程**里装 hook。由 {@link FdmBridge#onHostReady(Context)} 调用
     * （那里已经有 ClassLoader 和「只跑一次」的保证）。
     */
    public static void install(ClassLoader cl) {
        try {
            Class<?> c = XposedHelpers.findClass(CLS_VM, cl);
            XposedHelpers.findAndHookMethod(c, M_SHOW, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        if (Boolean.TRUE.equals(param.getResult())) {
                            // ★ 通话页**真的活跃**过 ⇒ 记住 ⇒ 本进程内才有"留驻"资格
                            if (!sOpened) {
                                sOpened = true;
                                GmUtil.log("[留驻] 通话页已活跃 ⇒ 本进程内开始留驻");
                            }
                            return;
                        }
                        // ★★ 门：本进程压根没打开过通话页 ⇒ 不干预
                        //    这条就是"杀后台再打开不再冒出通话页"的保证。
                        if (!sOpened) return;
                        Context ctx = GmUtil.app();
                        if (ctx == null) return;
                        if (on(ctx)) {
                            param.setResult(Boolean.TRUE);
                            GmUtil.logOnce("[留驻]",
                                    "通话页 a()=false → 强制 true（通话页留驻中；关开关即还原）");
                        }
                    } catch (Throwable ignore) {
                        // 热路径里的铁律：绝不让异常漏回宿主
                    }
                }
            });
            GmUtil.log("[留驻] 已挂钩子 " + CLS_VM + "." + M_SHOW + "Z（通话页留驻）");
        } catch (Throwable t) {
            // 锚点不在（宿主升级改名 / 不是宿主）⇒ 静默放弃，不打扰宿主
            GmUtil.logFail("[留驻] 钩子安装失败（不影响宿主）", t);
        }
    }
}
