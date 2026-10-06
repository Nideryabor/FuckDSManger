// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmUtil;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * GmFileCardProbe —— 「文件卡片在哪」定位探针 🐲 2026-10-03 · 尼得亚伯
 *
 * <h3>要解决什么</h3>
 * 新形态：把「系统提示词」当<b>附件</b>发出去（模型读得到、不触发反注入），
 * 然后 <b>hook 渲染把那张文件卡片藏掉</b>（主人拍板：只藏特定的卡片，不是整条消息）。
 *
 * <h3>挂哪三个点（全部经 {@link GmRemap} 映射，不写死 2.6.1 的名字）</h3>
 * <ul>
 *   <li>{@code h91.a} → 2.6.1 的 {@code d12.a} —— <b>消息列表 Composable</b>（数据层，首选过滤点）</li>
 *   <li>{@code pn9.c} → 2.6.1 的 {@code i93.i} —— <b>气泡单元 Composable</b>（可 setResult 跳过渲染）</li>
 *   <li>{@code hp8}    → 2.6.1 的 {@code dz9}   —— <b>渲染列表</b></li>
 * </ul>
 *
 * <h3>探针设计</h3>
 * 只打前 {@link #MAX_PER_TAG} 次调用，且**把含文件特征的参数标星**（{@code file-} / {@code .txt} /
 * {@code is_image}），所以一眼就能看出：
 * <ul>
 *   <li>有 ★ ⇒ 文件数据就在这个点的参数里 ⇒ 直接在这过滤</li>
 *   <li>全无 ★ ⇒ 文件数据在更下层（列表项自己的字段里）⇒ 换点/换字段</li>
 * </ul>
 *
 * <h3>纪律</h3>
 * 热路径，全 try/catch，绝不让异常逃出去（教训 255）。
 * <b>这是探针，定位完就该删掉或关掉</b>（别把日志噪声留在正式包里）。
 */
public final class GmFileCardProbe {

    private GmFileCardProbe() {}

    /** 每个点最多打几条日志（列表 Composable 每帧都可能调，不限制会淹掉 logcat） */
    private static final int MAX_PER_TAG = 15;

    /** 一眼看出这是不是文件 —— 命中就在日志里标 ★ */
    private static final String[] FILE_HINTS = {
            "file-",      // file_id 前缀
            ".txt", ".pdf", ".docx", ".md",
            "is_image", "file_name", "signed_path", "fetch_files"
    };

    public static void install(ClassLoader cl) {
        hook(cl, "h91", "a", "[FP/list]");    // 消息列表 Composable  → d12.a
        hook(cl, "pn9", "c", "[FP/unit]");    // 气泡单元 Composable  → i93.i
        hook(cl, "hp8", "isEmpty", "[FP/render]"); // 渲染列表      → dz9.isEmpty
    }

    private static void hook(ClassLoader cl, String oldCls, String oldM, final String tag) {
        try {
            final String cls = GmRemap.cls(oldCls);
            final String mth = GmRemap.method(oldCls, oldM);
            Class<?> c = XposedHelpers.findClass(cls, cl);

            final int[] n = new int[]{0};
            XposedBridge.hookAllMethods(c, mth, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    try {
                        if (n[0] >= MAX_PER_TAG) return;
                        n[0]++;
                        GmUtil.log(tag + " #" + n[0] + " " + dump(p.args));
                    } catch (Throwable ignore) {
                        // 探针自己绝不外抛
                    }
                }
            });
            GmUtil.log("probe OK " + tag + " → " + cls + "." + mth);
        } catch (Throwable t) {
            // 未定位/改名的锚点 ⇒ 干净失败（铁律：宁可不挂，也不乱咬宿主）
            GmUtil.log("probe FAIL " + tag + " (" + oldCls + "." + oldM + ") → " + t);
        }
    }

    /** 把参数表压成一行：类型 + 前 150 字，含文件特征的标 ★ */
    private static String dump(Object[] args) {
        if (args == null) return "args=null";
        StringBuilder sb = new StringBuilder("n=").append(args.length);
        int lim = Math.min(args.length, 8);
        for (int i = 0; i < lim; i++) {
            Object o = args[i];
            sb.append(" |").append(i).append("=");
            if (o == null) {
                sb.append("null");
                continue;
            }
            sb.append(o.getClass().getName());
            String s;
            try {
                s = String.valueOf(o);
            } catch (Throwable t) {
                s = "<toString 抛了>";
            }
            if (s.length() > 150) s = s.substring(0, 150) + "…";
            s = s.replace('\n', ' ').replace('\r', ' ');
            boolean hit = false;
            for (String h : FILE_HINTS) {
                if (s.contains(h)) {
                    hit = true;
                    break;
                }
            }
            sb.append(hit ? " ★" : " ").append("{").append(s).append("}");
        }
        if (args.length > lim) sb.append(" ...(还有 ").append(args.length - lim).append(" 个参数)");
        return sb.toString();
    }
}
