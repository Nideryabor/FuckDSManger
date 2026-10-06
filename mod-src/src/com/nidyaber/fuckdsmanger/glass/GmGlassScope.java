// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 液态玻璃 · 「我现在在画一个按钮」作用域 🐲
 *
 * <p>我们只给<b>按钮</b>上玻璃，不给卡片/气泡/页面底色上。可是按钮和卡片走的是
 * <b>同一个画底原语</b>（{@code Luia;->v(Lc76;JLmd8;)Lc76;}）⇒ 必须有个作用域计数器，
 * 在按钮 composable 的<b>方法边界</b>里把它 +1 / −1。
 *
 * <p>这套「作用域计数」是本项目已经用了三轮的老手法（{@code sUDepth} / {@code sUBub}，
 * 见 {@code 版本/2.22.95~2.22.110 用户气泡线 总复盘.md}）—— 这里只是换个名字。
 *
 * <h3>按钮真身（怎么找到的）</h3>
 * 宿主把类名混淆了，但 <b>Compose 的 source-info 字符串没混淆</b>，
 * `dex_string_members` 能直接按字符串定位到<b>方法</b>：
 *
 * <pre>
 *   ── 2.5.2 旧锚 → 2.6.1 新锚（2026-10-02 重定位，同法：source-info 字符串）──
 *   AppButton.kt:298             Luk8.a → xta.a
 *   AppButton.kt:339             Luk8.b → xta.b
 *   AppButton.kt:412             Luk8.c → xta.c        ← AppFullWidthButton
 *   AppIconButton.kt:80          zc.c   → l10.a
 *   AppIconButton.kt:55          zc.d   → l10.b
 *   AppIconButton.kt:228         zc.h   → l10.c        ← AppIconToggleButton
 *   AppIconButton.kt:203         zc.l   → l10.d        ← AppIconToggleButton
 *   AppSelectableChip.kt:68      i52.e  → v91.c
 *   PromptTemplateView.kt:341    yb5.c  → hs7.c        ← PromptFeatureChip（旧 334 行）
 *   PromptTemplateView.kt:309    yb5.d  → hs7.d        ← PromptFeatureSkeletonChip（旧 303 行）
 *   InputModeToggleButton.kt:37  a18.q  → l10.h
 *   ChatInputToggleableToolView.kt:90    zl9.H → k53.f
 *   ChatInputToggleableToolView.kt:206   zl9.Z → k53.o ← ToggleLottieIcon
 * </pre>
 *
 * <p>证据见 {@code 专题/宿主按钮锚点-2.5.2.md}（2.5.2 版）·
 * 2026-10-02 按同法在 2.6.1 重定位（{@code tmp/h261} 树）。宿主升级后这几个方法名会变，
 * 但<b>定位方法不变</b>：拿 source-info 字符串再跑一遍 {@code dex_string_members}。
 */
public final class GmGlassScope {

    private GmGlassScope() {
    }

    /**
     * 按钮锚点：{类名, 方法名}。
     *
     * <p>写死的是<b>混淆名</b>—— 看起来违反「不依赖宿主」的直觉，其实不违反：
     * 铁律禁的是<b>包名</b>（{@code com.deepseek.chat} 那种，改了就静默全灭且没法重定位）。
     * 这里这些混淆名本来就只是「锚点」，和底座那 51 条 hook 用的是同一类东西，
     * 宿主升级时按 {@code 专题/逆向方法-混淆指纹定位.md} 重新定位即可。
     */
    private static final String[][] BTN_ANCHORS = {
            // ── 2026-10-02 重定位（宿主 2.6.1；旧值 uk8/zc/i52/yb5/a18/zl9 见 git 历史）──
            {"xta", "a"}, {"xta", "b"}, {"xta", "c"},          // AppButton / AppFullWidthButton
            {"l10", "a"}, {"l10", "b"}, {"l10", "c"}, {"l10", "d"}, // AppIconButton / Toggle

            // ── 3.30.1 追加：主人点名「深度思考这种可点击有事件的也是按钮」 ──
            //    定位方式同 §「按钮真身」：用 source-info 字符串跑 dex_string_members
            {"v91", "c"},     // AppSelectableChip.kt:68      ← 可选芯片（深度思考/专家模式这一族）
            {"hs7", "c"},     // PromptTemplateView.kt:341    PromptFeatureChip
            {"hs7", "d"},     // PromptTemplateView.kt:309    PromptFeatureSkeletonChip
            {"l10", "h"},     // InputModeToggleButton.kt:37  输入模式开关
            {"k53", "f"},     // ChatInputToggleableToolView.kt:90
            {"k53", "o"},     // ChatInputToggleableToolView.kt:206  ToggleLottieIcon
    };

    /**
     * 是不是一个 @Composable 函数。
     *
     * <p>⚠️ 3.29.0 只判了「名字对 + 返回 void」⇒ 在这两个 <b>R8 合并出来的大杂烩类</b>里
     * 抓了一堆同名的普通方法（2.5.2 的 `Luk8;` 有 127 个方法，一半叫 a/b/c），
     * 作用域计数器被莫名其妙地推高 ⇒ 满屏都可能被当成「按钮里」。
     *
     * <p>Compose 编译出来的签名有很硬的指纹：<b>参数很多（≥8）+ 结尾是 int（change/default 标志）
     * + 中间夹着一个接口参数（{@code Composer}）</b>。拿这个筛，一个都不会误伤。
     */
    private static boolean looksLikeComposable(java.lang.reflect.Method m) {
        if (m.getReturnType() != void.class) return false;
        Class<?>[] p = m.getParameterTypes();
        // ⚠️ 3.30.1：原来卡「≥8 个参数」，结果把 AppSelectableChip(6 参) 这类全漏了。
        //    真正稳的指纹是「**结尾是 int**（change/default 标志）+ 中间夹着接口（Composer）」，
        //    参数个数只要 ≥4 就够区分同名普通方法了。
        if (p.length < 4) return false;
        if (p[p.length - 1] != int.class) return false;
        for (Class<?> t : p) {
            if (t.isInterface()) return true;      // Composer
        }
        return false;
    }

    /** 嵌套深度（按钮里套按钮也不怕）。 */
    private static volatile int sDepth = 0;

    public static boolean inButton() {
        return sDepth > 0;
    }

    public static int depth() {
        return sDepth;
    }

    /** 装上按钮作用域钩子。返回成功挂上的条数。 */
    public static int install(ClassLoader cl) {
        int n = 0;
        for (String[] a : BTN_ANCHORS) {
            try {
                Class<?> c = XposedHelpers.findClass(a[0], cl);
                int before = n;
                for (java.lang.reflect.Method m : c.getDeclaredMethods()) {
                    if (!m.getName().equals(a[1])) continue;
                    if (!looksLikeComposable(m)) continue;
                    XposedBridge.hookMethod(m, new DepthHook());
                    n++;
                }
                if (n == before) {
                    GmUtil.logOnce("glass.btn.miss", "【GmGlass】按钮锚点没挂上：" + a[0] + "->" + a[1]);
                }
            } catch (Throwable t) {
                // 单个锚点丢了不致命：那个按钮没玻璃，别的照常
                GmUtil.logOnce("glass.btn.err." + a[0], "【GmGlass】按钮锚点异常 " + a[0] + "->" + a[1] + "：" + t);
            }
        }
        GmUtil.log("【GmGlass】按钮作用域钩子 " + n + " 条");
        return n;
    }

    /** 进入 = before，退出 = after（用 try/finally 语义保证一定 −1）。 */
    private static final class DepthHook extends XC_MethodHook {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            sDepth++;
        }

        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            if (sDepth > 0) sDepth--;
        }
    }
}
