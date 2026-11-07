// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedHelpers;

/**
 * 【FdmUpdateRowHook】设置页「检查更新」那一行的**点击** 🐲
 *
 * <h3>真身在哪儿（frida 实测调用栈，不是猜）</h3>
 * <pre>
 *   Context.getString(0x7f0f0267 「当前已是最新版本」)
 *     ← ol2.j(:121)                 通用 lambda 分发器
 *     ← pg7.z(:428)                 ★ 点击逻辑本体（R8 把一堆 suspend lambda 合并进 pg7，
 *                                    用 this.e:I 作 switch 索引 ⇒ "检查更新" = e 22/23）
 *     ← sj0.h(:5)                   ★ 协程 ContinuationImpl.resumeWith
 *     ← wy3.run ← Handler.post
 * </pre>
 *
 * <h3>为什么挂 {@code sj0.h} 而不是 {@code pg7.z}（两次血证换来的）</h3>
 * <ol>
 *   <li><b>挂 z 且 setResult 会死循环</b>（主人：「点了宿主按钮会一直有个当前是最新版本弹窗」）。
 *       {@code sj0.h} 是这样一个循环：
 *       <pre>
 *         :goto_0
 *           invoke-virtual {p0, p1}, Lsj0;->z(...)          ← 我原来拦这里
 *           sget-object v1, Lhd3;->a      (COROUTINE_SUSPENDED)
 *           if-ne p1, v1, :cond_14
 *           return-void                   （挂起 ⇒ 正常返回）
 *         :cond_14
 *           invoke-virtual {p0}, Lsj0;->A()
 *           ... 回到 :goto_0
 *       </pre>
 *       我给 z 塞 {@code kotlin.Unit}（≠ SUSPENDED）⇒ 被判定「没挂起、立刻返回」
 *       ⇒ 回头再调一次 z ⇒ 又 setResult ⇒ **无限循环 + Toast 刷屏**。
 *       <br>⇒ <b>绝不许伪造 suspend lambda 的返回值</b>（协程协议的一部分）。</li>
 *   <li><b>挂 z 且不 setResult 会照常跑宿主逻辑</b>（主人：「点击宿主的按钮还是先检查更新」）。
 *       不拦截 ⇒ z 跑完 ⇒ 弹「当前已是最新版本」。</li>
 * </ol>
 * ⇒ 唯一干净的位置是**外层** {@code sj0.h}：在那里 {@code setResult(null)}
 *   **吞掉整个 resume** ⇒ z 根本不会被调用 ⇒ 宿主逻辑**一行都不跑**
 *   ⇒ 既不弹宿主 Toast、也不会死循环。
 *
 * <h3>只吞「第一次」</h3>
 * {@code pg7} 的状态机：{@code this.f:I} 是协程 stage。
 * <ul>
 *   <li>{@code f == 0} ⇒ 这是**启动**（点击刚发生）⇒ 我们吞掉，改拉起自己的 UI</li>
 *   <li>{@code f != 0} ⇒ 协程**被 resume**（比如网络回来了）⇒ 一律放行，
 *       绝不能吞 —— 否则真正的异步流程会被我们挂死</li>
 * </ul>
 *
 * <p>⚠️ 热路径铁律：{@code sj0.h} 是**所有**协程 resume 的公共入口，
 * 每次调用都过这里 ⇒ 第一件事必须是"极快地把不相干的筛掉"，
 * 并且**任何异常都不许外抛**（否则整宿主所有协程一起崩）。
 */
public final class FdmUpdateRowHook extends XC_MethodHook {

    /** {@code pg7.z} 里「检查更新」的两个 lambda 索引（{@code this.e}）。 */
    private static final int CASE_UPDATE_A = 22;
    private static final int CASE_UPDATE_B = 23;

    /** 「检查更新」lambda 所在的 R8 合并类（2.7.5）。 */
    private static final String LAMBDA_CLS = "pg7";

    private static volatile boolean sInstalled = false;
    private static volatile int sHits = 0;
    private static volatile long sLastOpen = 0L;

    /**
     * 被我们「吞掉」的那次调用的现场 —— 供我们弹窗的「检查更新」**原样重放**。
     *
     * <p>为什么这次能成（之前失败过，原因已想清）：
     * 我们在 {@code sj0.h} 的 <b>before</b> 阶段 {@code setResult(null)}，
     * 方法体**一行都没跑** ⇒ 状态机字段 {@code f} 还停在 0（没被推进）。
     * 所以重放时 {@code z()} 里 {@code if-eqz f} 判定"这是启动"，
     * 走的是和第一次点击**完全相同**的分支。
     * <br>（上一版失败是因为我多此一举把 {@code f} 手动复位成 0，
     *   反而让 {@code this.g/this.i} 的语义错位 —— 别动它才是对的。）
     */
    private static volatile java.lang.reflect.Member sSwallowedMethod = null;
    private static volatile Object sSwallowedSelf = null;
    private static volatile Object[] sSwallowedArgs = null;


    /** Field 缓存（热路径每次 getDeclaredField 太慢）。 */
    private static final Map<String, Field> FIELDS = new HashMap<String, Field>();
    /** 已知"没有这个字段"的 {@code 类名#字段名}（缓存，避免反复抛异常）。 */
    private static final java.util.Set<String> NO_FIELD =
            java.util.Collections.synchronizedSet(new java.util.HashSet<String>());

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        final String KEY = "cont.impl.h";
        final String MTH = "h";
        String clsName = GmRemap.clsFor(KEY, MTH);
        String mthName = GmRemap.method(KEY, MTH);
        log("install：解析 " + KEY + "." + MTH + " ⇒ 类=" + clsName + " 方法=" + mthName);
        // ★★ 先问一句"表里到底有没有这个键"。
        //   血证（两次，都是键少写了一截）：
        //     3.75.28 `settings.row.update`（少 .z）
        //     3.75.38 `cont.impl.h`（少 .h）
        //   症状：ClassNotFoundException: xxx$yyy —— 看着像类名错，其实是键没命中。
        //   `clsAll` 没命中时会**原样返回旧类名**，调用方根本分不清，所以必须显式问。
        if (!GmRemap.hit(KEY, MTH)) {
            log("✗ MTH 表里没有键 \"" + KEY + "." + MTH + "\" ⇒ 不挂（键必须是 旧类名.旧方法名 拼成的完整串）");
            return;
        }
        if (clsName == null || mthName == null) {
            log("✗ 未定位（Remap 没命中）⇒ 不挂");
            return;
        }
        try {
            Class<?> c = XposedHelpers.findClass(clsName, cl);
            XposedHelpers.findAndHookMethod(c, mthName, Object.class, new FdmUpdateRowHook());
            sInstalled = true;
            log("✅ 已挂「检查更新」点击 → " + clsName + "." + mthName
                    + "（吞 resume；e=22/23 且 f=0 才动）");
        } catch (Throwable t) {
            log("✗ 挂载失败 " + clsName + "." + mthName + "：" + t);
        }
    }

    @Override
    protected void beforeHookedMethod(MethodHookParam p) {
        try {
            final Object self = p.thisObject;
            if (self == null) return;

            // ① 极快筛选：先认**类名**，再认字段。
            //
            //   ⛔ 血证（2026-11-07）：只按 `e` 字段筛 ⇒ 命中 **137 次**！
            //      `sj0` 是**所有**协程 continuation 的基类，别的一堆 lambda 类
            //      也有 `e:I` 而且值恰好是 22/23 ⇒ 全被我们当成"检查更新"吞掉
            //      ⇒ 会破坏大量无关的异步流程。
            //   ⇒ 必须先钉死类名（pg7），再谈 e/f。
            if (!LAMBDA_CLS.equals(self.getClass().getName())) return;

            // ② 只认装了 e/f 两个 int 字段的那个 lambda 状态机
            Integer eBox = intField(self, "e");
            if (eBox == null) return;
            final int e = eBox;
            if (e != CASE_UPDATE_A && e != CASE_UPDATE_B) return;

            // ③ 只吞「启动」（f == 0）。
            //    f != 0 说明协程被 resume（异步回来了）⇒ 放行，绝不能吞。
            Integer fBox = intField(self, "f");
            if (fBox == null || fBox != 0) return;

            sHits++;
            long now = System.currentTimeMillis();
            if (now - sLastOpen < 800L) {
                // 连点去抖：**什么也不做**（既不再拉一次，也不吞 —— 让宿主自己处理）
                return;
            }
            sLastOpen = now;

            final android.content.Context ctx = FdmHostActivity.current();
            log("★ 命中「检查更新」启动 e=" + e + " f=0（第 " + sHits + " 次）");

            Runnable doHostUpdate = new Runnable() {
                @Override
                public void run() {
                    // 把被我们吞掉的那次调用**原样重放**（否则按钮就是死的）
                    runHostOriginal();
                }
            };

            boolean ok = false;
            if (ctx != null) {
                ok = FdmUiHook.launchWithFallback(
                        ctx, "拉起模块界面失败（隐藏应用列表 / 包可见性 / ROM 拦截）", doHostUpdate);
            } else {
                log("✗ 拿不到 Activity ⇒ 无法拉起，也无法弹保底");
            }

            // ③ 吞掉整个 resume ⇒ pg7.z 不执行 ⇒ 宿主「检查更新」一行都不跑
            //    （所以不会再弹「当前已是最新版本」，也不会死循环）。
            // 先记现场（供我们弹窗的「检查更新」重放）
            sSwallowedMethod = p.method;
            sSwallowedSelf = p.thisObject;
            sSwallowedArgs = p.args;

            p.setResult(null);
            log("   已吞掉本次 resume（拉起已发起=" + ok + "）⇒ 宿主原逻辑不执行");

        } catch (Throwable t) {
            // 热路径：**绝不许外抛**。这里一抛，宿主所有协程都会看到。
            log("hook 内异常（已吞）：" + t);
        }
    }

    /**
     * 【保底弹窗 → 「检查宿主更新」】以前是"重放宿主原逻辑"，现在改成**直接回一句**。
     *
     * <h3>为什么弃掉重放（2026-11-07 主人拍板）</h3>
     * 重放试了三个版本都"点了没反应"，而且证据很硬：
     * <pre>
     *   重放① 完成，返回=null      ← 调用正常结束，但屏幕上什么也没有
     * </pre>
     * 原因是 {@code pg7.z} 是**协程状态机**：
     * 我们当初 `setResult(null)` 把那次 resume 吞了，但状态机字段
     * {@code this.f}（stage）已经被推过 ⇒ 重放时走的是"恢复"分支，
     * 而那个分支里**没有** {@code getString(0x7f0f0267)} 这一步
     * ⇒ 当然不会弹「当前已是最新版本」。
     * （复位 {@code f=0} 也救不回来 —— {@code this.g/this.i} 里的上下文也变了。）
     *
     * <p>⇒ 现在的做法：<b>登记放行一次</b>（让宿主弹窗能过）
     * + <b>原样重放</b>那次被吞的调用。因为吞的是方法体执行**之前**，
     * 状态机字段没被推进，所以重放等价于"第一次点击"。
     */
    public static void runHostOriginal() {
        // ① 先登记放行：让宿主接下来弹的「最新版本 / 发现新版本」**正常出现**
        //    （否则会被 FdmUpdatePopupHook 又拦一次 —— 那就真的"点了没反应"了）
        try {
            FdmUpdatePopupHook.allowOnce();
        } catch (Throwable ignore) {
        }

        // ② 把被我们吞掉的那次调用**原样重放**
        final java.lang.reflect.Member m = sSwallowedMethod;
        final Object self = sSwallowedSelf;
        final Object[] args = sSwallowedArgs;

        if (m == null || self == null) {
            log("「检查更新」：没有可重放的现场 ⇒ 直接弹一句提示");
            try {
                android.app.Activity a = FdmHostActivity.current();
                if (a != null) GmUtil.toast(a, "请回到设置页重新点一次「FuckDSManger 插件列表」");
            } catch (Throwable ignore) {
            }
            return;
        }

        // ⚠️ 重放前**不要**动 state 字段（f/g/i）——
        //    我们在 before 阶段就吞了，方法体没跑过 ⇒ f 本来就是 0。
        //    手动复位反而会错位（上一版就是这么失败的）。
        // 诊断：重放前后把 e/f 值打出来（这是判断"走没走到检查更新分支"的唯一依据）
        log("   重放前：e=" + intField(self, "e") + " f=" + intField(self, "f")
                + " args=" + (args == null ? "null" : args.length + "个:" + describe(args)));
        try {
            log("→ 重放宿主「检查更新」（invokeOriginalMethod）");
            Object r = de.robv.android.xposed.XposedBridge.invokeOriginalMethod(m, self, args);
            log("   重放返回=" + r + "（=COROUTINE_SUSPENDED 才是正常的挂起）");
            log("   重放后：e=" + intField(self, "e") + " f=" + intField(self, "f"));
        } catch (Throwable t) {
            log("✗ 重放失败：" + t);
            // 兜底：至少告诉主人一声，别让按钮彻底没反应
            try {
                android.app.Activity a = FdmHostActivity.current();
                if (a != null) GmUtil.toast(a, "重放失败：" + t);
            } catch (Throwable ignore) {
            }
        }
    }

    // ------------------------------------------------------------------ 内部

    /** 给日志用：把参数数组简短描述一下（只取类名，不打内容）。 */
    private static String describe(Object[] args) {
        if (args == null) return "null";
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < args.length; i++) {
            if (i > 0) sb.append(", ");
            Object a = args[i];
            sb.append(a == null ? "null" : a.getClass().getSimpleName());
        }
        return sb.append(']').toString();
    }

    /** 读 int 字段（带 Field 缓存）；字段不存在返回 null（= 不是我们要的类）。 */
    private static Integer intField(Object self, String name) {
        try {
            Class<?> c = self.getClass();
            String k = c.getName() + "#" + name;
            if (NO_FIELD.contains(k)) return null;
            Field fld = FIELDS.get(k);
            if (fld == null) {
                try {
                    fld = c.getDeclaredField(name);
                    fld.setAccessible(true);
                } catch (NoSuchFieldException nsf) {
                    // 缓存"没有这个字段"（存 null 作标记），避免每次都再抛一次异常
                    //   ⚠️ 别用"随便找个 Field 当占位符" —— 那要在 static 块里
                    //      getDeclaredField，类加载阶段就抛 ⇒ 整个类起不来
                    //      （2026-11-07 真机血证：FdmUpdateRowHook 加载失败，
                    //       连带后面所有 hook 都没装上 ⇒ 「view 都没了」）
                    NO_FIELD.add(k);
                    return null;
                }
                FIELDS.put(k, fld);
            }
            if (fld == null) return null;
            return fld.getInt(self);
        } catch (Throwable t) {
            return null;
        }
    }

    private static void log(String msg) {
        // 双通道：文件（GmUtil.log）+ LSPosed（XposedBridge.log）。
        String line = "【FdmUpdateRow】" + msg;
        try {
            GmUtil.log(line);
        } catch (Throwable ignore) {
        }
        try {
            android.util.Log.e("FDM-Row", line);
        } catch (Throwable ignore) {
        }
        try {
            de.robv.android.xposed.XposedBridge.log("[FDM] " + line);
        } catch (Throwable ignore) {
        }
    }
}
