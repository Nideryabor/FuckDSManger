// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.glass;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.io.File;

/**
 * 液态玻璃 · **「我的背景图」底图来源**（第三种）🐲
 *
 * <h3>为什么要有它（主人 2026-10-01 一语点醒）</h3>
 * <blockquote>「**糊了就不叫玻璃了……**」</blockquote>
 *
 * 对。iOS 那种「液态玻璃」**不是磨砂** —— 后面的东西**看得清**，
 * 只是边缘被"掰弯"。所以：
 * <ul>
 *   <li><b>糊</b> ⇒ 变成毛玻璃，另一种东西 ✗</li>
 *   <li><b>擦</b> ⇒ 变成花斑（非纯色背景上尤其难看）✗</li>
 * </ul>
 *
 * <p>而且这条还顺手解开了更早那个死结 ——「**看不出区别**」：
 * 我当时查出来的结论是「**折射要有纹理才看得见，而宿主大片是纯色**」。
 * <b>那纹理在哪？在主人自己设的那张背景图上。</b>
 *
 * <h3>做法</h3>
 * 背景模块把图放在 <b>宿主自己的 files 目录</b>：
 * <pre>  /data/data/&lt;宿主包名&gt;/files/fuckds_bg.png</pre>
 * 我们拿它的**元素那一块**当玻璃内容：
 * 清晰（不糊）+ 透明（看到的是壁纸）+ 无叠影（壁纸里没有字）+ 有纹理（折射看得见）✅
 *
 * <h3>回退（主人要求：「如果修改背景开关是关的呢」）</h3>
 * 以下任一情况都**自动退回「元素底色」**：
 * <ol>
 *   <li>背景开关 <b>{@code fuckds_bg_on} = false</b> —— 主人明确点名的这条</li>
 *   <li>文件不存在 / 读不出来 / 解不出图</li>
 * </ol>
 * 退回去之后玻璃**照常显示**（只是不透），不会开天窗。
 */
final class GmGlassWallpaper {

    private GmGlassWallpaper() {
    }

    /** 背景模块放图的位置（宿主自己的 files 目录）。 */
    public static final String FILE_NAME = "fuckds_bg.png";

    /** 背景开关的键名。 */
    private static final String K_BG_ON = "fuckds_bg_on";

    private static Bitmap sRaw;          // 原图缓存
    private static long sRawAt = 0L;     // 原图的 mtime（图换了就重读）
    private static Bitmap sScaled;      // 缩到 1/SCALE 的缓存（对位用）
    private static int sScaledW = 0;
    private static int sScaledH = 0;
    private static volatile boolean sLogged = false;

    /** 背景开关是不是开着（关了就一律回退）。 */
    public static boolean switchOn(Context ctx) {
        try {
            SharedPreferences sp = GmStore.get(ctx);
            if (sp == null) return false;
            return sp.getBoolean(K_BG_ON, false);
        } catch (Throwable t) {
            return false;
        }
    }

    /** 背景图文件（不管开不开，先给出路径，方便打日志）。 */
    public static File file(Context ctx) {
        try {
            return new File(ctx.getFilesDir(), FILE_NAME);
        } catch (Throwable t) {
            return null;
        }
    }

    /**
     * 拿一张**已经缩到 1/{@link GmGlassBackdrop#SCALE}** 的背景图。
     *
     * <p>为什么要缩：现有的裁剪逻辑（`GmGlassGpu.draw` 的非 stretch 分支）
     * 是按「整窗 1/SCALE 缩略图」的约定写的。把壁纸也缩成同样的约定，
     * **下面那套裁剪代码一行都不用改** ✅
     *
     * @param winW 窗口宽（px）；<=0 时按壁纸自身宽度当作窗口
     */
    static Bitmap get(Context ctx, int winW, int winH) {
        if (!switchOn(ctx)) {
            why(ctx, "背景开关是关的 ⇒ 回退「元素底色」");
            return null;
        }
        File f = file(ctx);
        if (f == null || !f.isFile()) {
            why(ctx, "找不到 " + FILE_NAME + " ⇒ 回退「元素底色」");
            return null;
        }
        try {
            long mtime = f.lastModified();
            if (sRaw == null || sRaw.isRecycled() || mtime != sRawAt) {
                Bitmap b = BitmapFactory.decodeFile(f.getAbsolutePath());
                if (b == null) {
                    why(ctx, "解不出图（可能不是图片）⇒ 回退「元素底色」");
                    return null;
                }
                if (sRaw != null && !sRaw.isRecycled()) sRaw.recycle();
                sRaw = b;
                sRawAt = mtime;
                sScaled = null;                     // 原图换了 ⇒ 缩放缓存作废
                GmUtil.log("【GmGlass】背景图已加载 " + b.getWidth() + "x" + b.getHeight()
                        + "（" + (f.length() / 1024) + " KB）");
            }

            int S = GmGlassBackdrop.SCALE;
            int w = Math.max(1, (winW > 0 ? winW : sRaw.getWidth()) / S);
            int h = Math.max(1, (winH > 0 ? winH : sRaw.getHeight()) / S);
            if (sScaled == null || sScaled.isRecycled()
                    || sScaledW != w || sScaledH != h) {
                Bitmap sc = Bitmap.createScaledBitmap(sRaw, w, h, true);
                if (sScaled != null && !sScaled.isRecycled()) sScaled.recycle();
                sScaled = sc;
                sScaledW = w;
                sScaledH = h;
                if (!sLogged) {
                    sLogged = true;
                    GmUtil.log("【GmGlass】背景图已按窗口缩到 " + w + "x" + h + "（1/" + S + "）");
                }
            }
            return sScaled;
        } catch (Throwable t) {
            why(ctx, "读背景图失败：" + t + " ⇒ 回退「元素底色」");
            return null;
        }
    }

    /** 图被换掉时清缓存（界面换背景后调一下）。 */
    static void invalidate() {
        sScaled = null;
        sRaw = null;
        sRawAt = 0L;
    }

    /** 回退原因只打一次 —— 免得每帧刷屏。 */
    private static void why(Context ctx, String msg) {
        GmUtil.logOnce("glass.wallpaper.why", "【GmGlass】背景图底图不可用：" + msg);
    }
}
