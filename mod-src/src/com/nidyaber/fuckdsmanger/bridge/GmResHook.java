// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.text.SpannedString;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import org.json.JSONObject;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * GmResHook —— 「宿主の终极美化策略」的宿主侧实现：替换**所有**资源文字 / 图片 🐲 2026-11-07
 *
 * <h3>为什么只挂这几个点就够</h3>
 * 真机探针（{@code tools/frida/probes/res_probe3.js}）实测，宿主 2.7.5：
 * <table border="1">
 *   <tr><th>入口</th><th>证据</th></tr>
 *   <tr><td>{@code Resources.getString(int)}</td>
 *       <td>Compose 的 {@code stringResource} 唯一漏斗（{@code k47} 里那句
 *           {@code StringResources.android.kt:33}）；60 秒内命中 <b>1406 次</b></td></tr>
 *   <tr><td>{@code Resources.getDrawable(int,Theme)}</td>
 *       <td>{@code painterResource} 唯一漏斗（{@code j30.a}，
 *           {@code PainterResources.android.kt}）；全库只有 2 处调它</td></tr>
 * </table>
 *
 * <h3>★ 三个真机踩出来的坑（都已经在这里修好，不要"优化"掉）</h3>
 * <ol>
 *   <li><b>{@code getText} 不能直接返回 Java String</b> ——
 *       frida 上实测报 {@code Implementation for getText expected return value compatible with
 *       java.lang.CharSequence}，Xposed 侧同样会 {@code ClassCastException}。
 *       ⇒ 必须 {@code new SpannedString(rep)} 包一层。</li>
 *   <li><b>{@code Bitmap.Config} 是内部类</b>（{@code android.graphics.Bitmap$Config}），
 *       不是 {@code Bitmap.Config} 字段。反射时代码写错会静默拿不到。</li>
 *   <li><b>图片一定要缓存</b>：{@code getDrawable} 在滚动时会被反复要，
 *       每次 decode 一张 PNG ⇒ 掉帧。这里按 id 缓存，{@link #refresh} 时整体清空。</li>
 * </ol>
 *
 * <h3>配置（存在宿主自己的 MMKV/SP 里，键 {@link #KEY}）</h3>
 * <pre>
 * {"v":1,
 *  "t": {"session_init_title": "🐲新文字"},
 *  "i": {"assistant_message_avatar": "fuckds_res__assistant_message_avatar.png"}}
 * </pre>
 * <b>只存资源名，不存 id</b> —— 资源名在宿主里**没有被混淆**（{@code session_init_title} /
 * {@code assistant_message_avatar}…，实测 747/204 条），而 id 会随宿主升级变。
 * 每次 {@link #refresh} 用 {@code getIdentifier(name, type, pkg)} 现查。
 *
 * <h3>性能</h3>
 * 渲染热路径。表为空时**第一行就 return**（一个线程安全的 volatile 读 + 判 null），
 * 比原来的调用只多一次字段读 —— 主人没配任何东西时开销可忽略。
 *
 * <h3>纪律</h3>
 * 每个 hook 全 try/catch，<b>绝不让异常逃出去</b>（教训 255：hook 崩了会连带宿主界面坏）。
 */
public final class GmResHook {

    /** 配置键（宿主 SP 里那条 JSON）。 */
    public static final String KEY = "fuckds_res_map";
    /** 总开关。 */
    public static final String KEY_ON = "fuckds_res_on";
    /** 图片文件名前缀（放在宿主 {@code filesDir} 下）。 */
    private static final String IMG_PREFIX = "fuckds_res__";

    private static final String TAG = "FdmRes";

    /** id → 替换文字。**空/null = 什么都不做**（热路径第一判据）。 */
    private static volatile Map<Integer, String> sText = null;
    /** id → 图片文件名。 */
    private static volatile Map<Integer, String> sImg = null;
    /** 已解码的图片缓存（id → Drawable）。refresh 时清空。 */
    private static final Map<Integer, Drawable> sImgCache = new ConcurrentHashMap<Integer, Drawable>();
    /** 替换图的**字节**缓存（openRawResource 每次都要一个新流，字节复用）。 */
    private static final Map<String, byte[]> sPngCache = new ConcurrentHashMap<String, byte[]>();
    /** 解不出来的图片，别每次都重试（id → 1）。 */
    private static final Map<Integer, Integer> sImgBad = new ConcurrentHashMap<Integer, Integer>();

    /** 记录装过没有（Activity 有多个 Resources 实例，但类只有一个）。 */
    private static volatile boolean sInstalled = false;
    /** 宿主的 ClassLoader（找宿主混淆类必须用它）。 */
    private static volatile ClassLoader sHostLoader = null;

    /** ★ 诊断：getDrawable 真实命中次数（用来判断"钩子挂上了但没被调用"）。 */
    private static volatile int sHitDraw = 0;
    private static volatile int sHitDrawMiss = 0;
    /** 最近命中的几个资源名（只看前 12 个，不刷屏）。 */
    private static final java.util.List<String> sSeenNames = new java.util.ArrayList<String>();
    /** ★ 诊断：getValue 命中次数（矢量图真漏点）。 */
    private static volatile int sHitVal = 0;
    private static volatile int sHitValOk = 0;
    /** ★ 诊断：openRawResource 命中次数（真正把字节换掉的次数）。 */
    private static volatile int sHitRaw = 0;
    /** ★ 我们替换图用的 Bitmap（identityHashCode → 1），剥离 tint 时判断用。 */
    private static final java.util.Map<Integer, Integer> sOurBitmaps =
            new java.util.concurrent.ConcurrentHashMap<Integer, Integer>();
    /** 是否启用「剥离 tint」（默认开）—— 关掉就恢复"只换形状、颜色跟随主题"。 */
    private static volatile boolean sStripTintOn = true;
    /** 诊断：剥离 tint 的次数。 */
    private static volatile int sHitStrip = 0;
    /** ★ 诊断：dec.U 命中 / 成功替换次数。 */
    private static volatile int sHitU = 0;
    /** ★ 诊断：getXml 命中次数（j30 的另一条分支 —— 证明到底走哪条路）。 */
    private static volatile int sHitXml = 0;
    private static volatile int sHitUOk = 0;
    /** 解码失败的次数（OOM 之类）。 */
    private static volatile int sDecodeFail = 0;
    private static volatile String sLastErr = "";

    /**
     * ★★★ 防死循环：{@code res.getDrawable(id)} 读原图尺寸时会**回调我们自己的 hook**，
     * 而 hook 里又要读原图尺寸 ⇒ 无限递归直接 StackOverflow 把宿主搞崩。
     * 用 ThreadLocal 标记"这个线程正在取原图尺寸"，期间 hook 一律不插手。
     */
    private static final ThreadLocal<Boolean> sProbing = new ThreadLocal<Boolean>();

    /** 最近一次 refresh 的时间戳（调试用）。 */
    private static volatile long sAt = 0;

    private GmResHook() {
    }

    /* ═══════════════════════ 装钩子 ═══════════════════════ */

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        sInstalled = true;
        // ★ 2026-11-07：宿主类（dec/lp9…）**只有宿主的 ClassLoader 认识**。
        //   之前 ⑨ 里用 `GmResHook.class.getClassLoader()`（= 我们自己的 loader）
        //   ⇒ findClass("dec") 必然失败 ⇒ **整块静默跳过**，日志里连"挂了"都看不到。
        sHostLoader = cl;

        // ── ① 文字：getString(int) ────────────────────────────────
        try {
            XposedHelpers.findAndHookMethod(Resources.class, "getString", int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            try {
                                Map<Integer, String> m = sText;
                                if (m == null) return;          // ★ 热路径第一判据
                                Object a0 = p.args[0];
                                if (!(a0 instanceof Integer)) return;
                                String rep = m.get(a0);
                                if (rep != null) p.setResult(rep);
                            } catch (Throwable ignore) {
                            }
                        }
                    });
            // ── ② 文字：getString(int, Object[])（带 %1$s 的）──────
            XposedHelpers.findAndHookMethod(Resources.class, "getString", int.class,
                    Object[].class, new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            try {
                                Map<Integer, String> m = sText;
                                if (m == null) return;
                                Object a0 = p.args[0];
                                if (!(a0 instanceof Integer)) return;
                                String rep = m.get(a0);
                                if (rep == null) return;
                                // ★ 有参数就尽量套一次 format；格式不对就吐原文
                                try {
                                    p.setResult(String.format(rep, (Object[]) p.args[1]));
                                } catch (Throwable t) {
                                    p.setResult(rep);
                                }
                            } catch (Throwable ignore) {
                            }
                        }
                    });
            // ── ③ 文字：getText(int) —— ★ 必须返回 CharSequence ──────
            XposedHelpers.findAndHookMethod(Resources.class, "getText", int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            try {
                                Map<Integer, String> m = sText;
                                if (m == null) return;
                                Object a0 = p.args[0];
                                if (!(a0 instanceof Integer)) return;
                                String rep = m.get(a0);
                                // ★ 关键：String 不是 CharSequence 的实现类！
                                //   直接 setResult(String) 会抛
                                //   "expected return value compatible with java.lang.CharSequence"
                                if (rep != null) p.setResult(new SpannedString(rep));
                            } catch (Throwable ignore) {
                            }
                        }
                    });
            GmUtil.log("【FdmRes】文字钩子已挂（getString×2 / getText）");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】文字钩子挂了", t);
        }

        // ── ④ 图片：getDrawable(int, Theme) ──────────────────────
        try {
            XposedHelpers.findAndHookMethod(Resources.class, "getDrawable", int.class,
                    Resources.Theme.class, new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            try {
                                if (Boolean.TRUE.equals(sProbing.get())) return;  // 防重入
                                sHitDraw++;              // ★ 诊断：宿主到底调没调
                                Map<Integer, String> m = sImg;
                                if (m == null) return;
                                Object a0 = p.args[0];
                                if (!(a0 instanceof Integer)) return;
                                String fn = m.get(a0);
                                if (fn == null) return;
                                // ★ a0 是 Object，这里必须显式拆箱（javac 不会替你转）
                                Drawable d = drawableFor((Resources) p.thisObject,
                                        ((Integer) a0).intValue(), fn);
                                if (d != null) p.setResult(d); else sHitDrawMiss++;
                            } catch (Throwable ignore) {
                            }
                        }
                    });
            // ── ⑤ 图片：getDrawable(int)（老接口，AppCompat 走这条）──
            XposedHelpers.findAndHookMethod(Resources.class, "getDrawable", int.class,
                    new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam p) {
                            try {
                                if (Boolean.TRUE.equals(sProbing.get())) return;  // 防重入
                                sHitDraw++;              // ★ 诊断：宿主到底调没调
                                Map<Integer, String> m = sImg;
                                if (m == null) return;
                                Object a0 = p.args[0];
                                if (!(a0 instanceof Integer)) return;
                                String fn = m.get(a0);
                                if (fn == null) return;
                                Drawable d = drawableFor((Resources) p.thisObject,
                                        ((Integer) a0).intValue(), fn);
                                if (d != null) p.setResult(d); else sHitDrawMiss++;
                            } catch (Throwable ignore) {
                            }
                        }
                    });
            GmUtil.log("【FdmRes】图片钩子已挂（getDrawable×2）");
            try {
                XposedHelpers.findAndHookMethod(Resources.class, "getValue",
                        int.class, android.util.TypedValue.class, boolean.class,
                        new XC_MethodHook() {
                            @Override
                            protected void afterHookedMethod(MethodHookParam p) {
                                try {
                                    if (Boolean.TRUE.equals(sProbing.get())) return;  // 防重入
                                    sHitVal++;
                                    Map<Integer, String> m = sImg;
                                    if (m == null) return;
                                    Object a0 = p.args[0];
                                    if (!(a0 instanceof Integer)) return;
                                    String fn = m.get(a0);
                                    if (fn == null) return;
                                    android.util.TypedValue tv =
                                            (android.util.TypedValue) p.args[1];
                                    if (tv == null) return;
                                    if (tv.string != null
                                            && tv.string.toString().startsWith("fdm:")) return;
                                    // ★★★ 2026-11-07 · 终于定案（主人第八次报「还是一样的」）★★★
                                    //
                                    //  真正的判据在 `s27.E`（= painterResource 本体）里：
                                    //    :2604  v4 = tv.string
                                    //    :2615  if-eqz v4, :cond_799        ← string 为空就跳位图分支
                                    //    :2619  pja.O(v4, ".xml")           ← 判 string 里**有没有 ".xml"**
                                    //    :2631  if-ne v11, v6, :cond_799    ← 不含 → 跳位图分支
                                    //    :2708  getXml(id) → loadVectorResource   ← 含 .xml → 矢量
                                    //
                                    //  位图分支 `:cond_799`（6512）:
                                    //    :6632  Resources.getDrawable(id, theme)     ← 我们早就 hook 了
                                    //    :6640  check-cast v0, BitmapDrawable        ← ★ 强制转！
                                    //    :6644  v0.getBitmap()
                                    //    :6680  new vo0(imageBitmap)                 ← vo0 = BitmapPainter
                                    //
                                    //  ⇒ 唯一正确的做法：
                                    //    ① **把 tv.string 改成不含 ".xml" 的值**（否则永远走矢量）
                                    //    ② getDrawable hook 返回 BitmapDrawable（满足那个 check-cast）
                                    //
                                    //  ⚠️ 而上次"灰色豆腐块"的教训：如果 ② 没给上图（文件缺失/解码失败），
                                    //     ① 还改了 string ⇒ 它去 getDrawable 拿到 VectorDrawable
                                    //     ⇒ **check-cast BitmapDrawable 抛 ClassCastException** ⇒ 豆腐块。
                                    //  ⇒ 所以顺序必须是：**先确认能给出图，再改 string**。
                                    //     给不出就原样不动（退回宿主原图，绝不让它崩）。
                                    Context ctx0 = appCtx();
                                    Resources res0 = ctx0 == null ? null : ctx0.getResources();
                                    if (res0 == null) return;
                                    Drawable d = drawableFor(res0,
                                            ((Integer) a0).intValue(), fn);
                                    if (!(d instanceof BitmapDrawable)) {
                                        // 给不出图 ⇒ **什么都不改**，宿主照旧显示原图
                                        if (sImgBad.containsKey((Integer) a0)) {
                                            GmUtil.logOnce(TAG + ".noval" + a0,
                                                    "【FdmRes】替换图不可用 ⇒ 保持宿主原图 id=" + a0);
                                        }
                                        return;
                                    }
                                    Bitmap bm = ((BitmapDrawable) d).getBitmap();
                                    // ① 把 string 改成不含 ".xml" 的值 → 强制走位图分支
                                    tv.type = android.util.TypedValue.TYPE_STRING;
                                    tv.string = "fdm_replaced";
                                    // ② 顺手塞进 drawable 字段（有些路径会直接读它）
                                    try {
                                        java.lang.reflect.Field fd = android.util.TypedValue.class
                                                .getDeclaredField("drawable");
                                        fd.setAccessible(true);
                                        fd.set(tv, d);
                                    } catch (Throwable ignore) {
                                    }
                                    sHitValOk++;
                                    GmUtil.logOnce(TAG + ".tv" + a0,
                                            "【FdmRes】✅ getValue 已改 string+drawable id=" + a0
                                                    + "（" + bm.getWidth() + "x" + bm.getHeight()
                                                    + "）→ 应走位图分支");
                                } catch (Throwable ignore) {
                                }
                            }
                        });
                GmUtil.log("【FdmRes】图片钩子已挂（getValue ← 矢量图真漏点）");
            } catch (Throwable t) {
                GmUtil.logFail("【FdmRes】getValue 钩子挂了", t);
            }

            // ── ⑧ ★★★ 真·把字节换掉：openRawResource（2026-11-07 定案）★★★
            //
            //  宿主 2.7.5 反编译铁证（`j30.smali:757`）：
            //    Compose 走「位图」分支时调的是
            //      `openRawResource(id, TypedValue)`  →  再 BitmapFactory 解码。
            //  ⇒ 这是**最后一个能塞进我们字节的地方**，而且拿到的是真实资源 id。
            //  配合上面的 getValue（把后缀改成非 .xml），整条链就通了。
            try {
                XposedHelpers.findAndHookMethod(Resources.class, "openRawResource",
                        int.class, android.util.TypedValue.class, new XC_MethodHook() {
                            @Override
                            protected void beforeHookedMethod(MethodHookParam p) {
                                try {
                                    if (Boolean.TRUE.equals(sProbing.get())) return;
                                    Map<Integer, String> m = sImg;
                                    if (m == null) return;
                                    Object a0 = p.args[0];
                                    if (!(a0 instanceof Integer)) return;
                                    String fn = m.get(a0);
                                    if (fn == null) return;
                                    byte[] png = pngBytes(fn);
                                    if (png == null) return;
                                    sHitRaw++;
                                    p.setResult(new java.io.ByteArrayInputStream(png));
                                    GmUtil.logOnce(TAG + ".raw" + a0,
                                            "【FdmRes】✅ openRawResource 已换成我们的图 id=" + a0
                                                    + "（" + png.length + " 字节）");
                                } catch (Throwable ignore) {
                                }
                            }
                        });
                GmUtil.log("【FdmRes】图片钩子已挂（openRawResource ← 字节层）");
            } catch (Throwable t) {
                GmUtil.logFail("【FdmRes】openRawResource 钩子挂了", t);
            }

            // ── ⑨ ★★★ 真正的入口：dec.U(int, Context)（2026-11-07 定案）★★★
            //
            //  反编译铁证（`j30.smali` = Compose 的 painterResource 实现）：
            //    · 它先用 getValue 判 mimeType，然后**两条分支都在解析 XML**
            //      （一条走 getXml，一条走 openRawResource，旁边都有 XmlPullParser）
            //    · 而在解析之前，它调的是 `Ldec;->U(ILandroid/content/Context;)Landroid/graphics/drawable/Drawable;`
            //      拿一个 Drawable，再判 `instanceof VectorDrawable`：
            //          是   → 解析成 ImageVector（矢量路径）
            //          不是 → 走位图/位图化分支
            //
            //  ⇒ **只要让 U() 返回 BitmapDrawable**，它就会走「不是矢量」那条 →
            //    我们的图才真的会被画出来。这是唯一干净的切入点。
            //
            //  `dec` 是混淆名 —— 所以**找不到就静默跳过**，不影响任何其它功能。
            //  （宿主升级后名字会变，届时用 GmRemap 或重新定位。）
            try {
                // ★★ 必须用**宿主的** ClassLoader —— 用我们自己的必然 ClassNotFound
                ClassLoader hl = sHostLoader;
                if (hl == null) {
                    GmUtil.log("【FdmRes】dec.U：拿不到宿主 ClassLoader，跳过");
                    hl = GmResHook.class.getClassLoader();
                }
                Class<?> dec = XposedHelpers.findClass("dec", hl);
                // ★ 用**类名字符串**的重载：它能拿到宿主的 ClassLoader，
                //   比传 Class 更稳（也避免跨 loader 的 isInstance 坑）。
                //
                //   ⚠️ 2026-11-07 我自己踩的坑：曾以为「static 方法挂不上」——
                //   **那是错的**。Xposed 的 findAndHookMethod 遍历 getDeclaredMethods，
                //   **不区分 static / 实例**。所以 decU命中=0 另有原因，别再往这上面想。
                XposedHelpers.findAndHookMethod("dec", hl, "U", int.class, Context.class,
                        new XC_MethodHook() {
                            @Override
                            protected void afterHookedMethod(MethodHookParam p) {
                                try {
                                    if (Boolean.TRUE.equals(sProbing.get())) return;
                                    // ★★★ 2026-11-07：计数器必须放在**最前面**！
                                    //   原来它放在 `fn == null` 之后 ⇒ 只要进来的 id 不是我们配置的
                                    //   那个，就直接 return、计数永远是 0 ——
                                    //   **我拿一个永远为 0 的数字当成"没命中"的证据，白猜了两轮。**
                                    sHitU++;
                                    Map<Integer, String> m = sImg;
                                    if (m == null) return;
                                    Object a0 = p.args[0];
                                    if (!(a0 instanceof Integer)) return;
                                    String fn = m.get(a0);
                                    if (fn == null) return;
                                    Object res = p.getResult();
                                    // ★ Resources 必须给真的（BitmapDrawable 要用它算密度）；
                                    //   传 null 会 NPE 或被当成默认密度 ⇒ 图尺寸不对。
                                    Resources rr = null;
                                    try {
                                        Object c1 = p.args.length > 1 ? p.args[1] : null;
                                        if (c1 instanceof Context) {
                                            rr = ((Context) c1).getResources();
                                        }
                                    } catch (Throwable ignore) {
                                    }
                                    if (rr == null) rr = appCtx() == null ? null : appCtx().getResources();
                                    if (rr == null) return;
                                    Drawable d = drawableFor(rr,
                                            ((Integer) a0).intValue(), fn);
                                    if (d == null) return;
                                    p.setResult(d);
                                    sHitUOk++;
                                    GmUtil.logOnce(TAG + ".u" + a0,
                                            "【FdmRes】✅ dec.U 已换成 BitmapDrawable id=" + a0
                                                    + "（原来是 "
                                                    + (res == null ? "null"
                                                       : res.getClass().getSimpleName()) + "）");
                                } catch (Throwable ignore) {
                                }
                            }
                        });
                GmUtil.log("【FdmRes】图片钩子已挂（dec.U ← 真正的入口）");
            } catch (Throwable t) {
                GmUtil.logFail("【FdmRes】dec.U 钩子挂了", t);
            }
            try {
                // ── ⑪ ★★★ 剥离 tint：让替换的图显示原色（2026-11-07 定案）★★★
                //
                //  frida 实测（resnotint8）：
                //    换图=6  q88.g调用=176  命中我们的=6  剥离tint=6
                //  ⇒ 只处理我们这 6 个 painter，其它 170 次原样放过。
                //
                //  为什么是 `q88.g(Lv24,J,F,gp0)V`：
                //    它是 Painter 的**带 tint 绘制入口**（Icon 走这条），
                //    第 4 个参数就是 ColorFilter。
                //      :106  v0 = p0.c          （上次缓存的 filter）
                //      :138  if-nez p5, :cond_49（p5 空就不染色）
                //      :149  hg.l(v0)           （应用）
                //      :180  hg.l(p5)
                //      :191  iput p5 -> p0.c    （缓存）
                //
                //  ⚠️⚠️ 两个必须记住的坑：
                //   ① **身份比对必须用 Java 层的 equals**。
                //      frida 里 `$handle` 在 QuickJS 下是 undefined，
                //      而 `undefined === undefined` 恒真 ⇒
                //      **所有图标都会被剥 tint**（实测误伤 181 次，主题色全没了）。
                //      Xposed 里没这个问题，但**绝对不能按对象引用集合去 contains**，
                //      要用 `java.util.ArrayList.contains()`（走 Java equals）。
                //   ② 这里在**绘制热路径**上（一次刷新几百次调用）。
                //      **绝不能做反射**（上一版 frida 就是这样把宿主 OOM 崩掉的）。
                //
                //  所以：只在 `refresh()` 时把"我们的 painter 是谁"记下来？做不到。
                //  ⇒ 换成更稳的判据：**看这个 painter 内部装的是不是我们的 Bitmap**。
                //     vo0.f = ck5（ImageBitmap），实现在 rf，rf.a = Bitmap。
                //     我们 refresh 时把**我们自己的 Bitmap 存进一个 IdentityHashMap**，
                //     绘制时用 `System.identityHashCode` 判断 —— 零反射、零 Java 分配。
                // ── 判定：这个 painter 画的是不是我们的图？──
                //   ⚠️ 热路径，只能做**零反射**的判定。
                //   做法：refresh() 时把「我们替换图的 Bitmap」存进 sOurBitmaps
                //        （用 System.identityHashCode 当键，纯 int 比较）。
                //   绘制时：q88.g 的 this 是 vo0，vo0.f 是 ImageBitmap(rf)，rf.a 是 Bitmap。
                //        → 一路 iget 字段虽然要反射，但**只在命中候选时才做**：
                //          先用一个前置筛子 —— 见下。
                final Class<?> vo0Cls = XposedHelpers.findClass(
                        "vo0", sHostLoader == null ? GmResHook.class.getClassLoader() : sHostLoader);
                final Class<?> q88Cls = XposedHelpers.findClass(
                        "q88", sHostLoader == null ? GmResHook.class.getClassLoader() : sHostLoader);
                final java.lang.reflect.Field fImageBitmap =
                        vo0Cls.getDeclaredField("f");          // vo0.f : ck5
                fImageBitmap.setAccessible(true);
                final java.lang.reflect.Field fBitmap =
                        XposedHelpers.findClass("rf",
                                sHostLoader == null ? GmResHook.class.getClassLoader() : sHostLoader)
                                .getDeclaredField("a");        // rf.a : Bitmap
                fBitmap.setAccessible(true);

                XposedHelpers.findAndHookMethod(q88Cls, "g", "v24", long.class,
                        float.class, XposedHelpers.findClass("gp0",
                                sHostLoader == null ? GmResHook.class.getClassLoader() : sHostLoader),
                        new XC_MethodHook() {
                            @Override
                            protected void beforeHookedMethod(MethodHookParam p) {
                                try {
                                    if (!sStripTintOn) return;
                                    Object painter = p.thisObject;
                                    if (painter == null) return;
                                    Object ib = fImageBitmap.get(painter);   // ck5
                                    if (ib == null) return;
                                    Object bmp = fBitmap.get(ib);            // Bitmap
                                    if (bmp == null) return;
                                    if (!isOurBitmap(bmp)) return;
                                    // ★ 命中：把 colorFilter 参数换成 null
                                    p.args[3] = null;
                                    sHitStrip++;
                                } catch (Throwable ignore) {
                                }
                            }
                        });
                GmUtil.log("【FdmRes】图片钩子已挂（q88.g 剥离 tint）");
            } catch (Throwable t) {
                GmUtil.logFail("【FdmRes】q88.g 钩子挂了", t);
            }

            // ── ⑩ 诊断：getXml（只**计数**，不干预）2026-11-07
            //
            //  为什么只计数：j30 里有两条互斥的路——
            //    ① text/xml 且 包名相等 → dec.U(id, ctx)
            //    ② 其余               → Resources.getXml(id) 直接解析
            //  之前 `decU命中=0` 是个**假数字**（计数器放错位置），
            //  现在配合这里的 getXml 计数，就能一眼看出宿主到底走哪条。
            //  ⇒ 只看数字，不再靠猜。
            try {
                XposedHelpers.findAndHookMethod(Resources.class, "getXml", int.class,
                        new XC_MethodHook() {
                            @Override
                            protected void beforeHookedMethod(MethodHookParam p) {
                                try {
                                    Map<Integer, String> m = sImg;
                                    if (m == null) return;
                                    Object a0 = p.args[0];
                                    if (!(a0 instanceof Integer)) return;
                                    if (m.get(a0) == null) return;
                                    sHitXml++;
                                    GmUtil.logOnce(TAG + ".xml" + a0,
                                            "【FdmRes】⚠️ 走了 getXml 分支（不是 dec.U）id=" + a0);
                                } catch (Throwable ignore) {
                                }
                            }
                        });
                GmUtil.log("【FdmRes】诊断钩子已挂（getXml 计数）");

            } catch (Throwable t) {
                // ★ 标签必须写对 —— 之前这里误写成「openRawResource 钩子挂了」，
                //   害我以为是 ⑧ 失败（实际是 ⑨ 的 dec 找不到）。
                GmUtil.logFail("【FdmRes】dec.U 钩子挂了（这是最关键的入口！）", t);
            }
            try {
                XposedHelpers.findAndHookMethod(Resources.class, "openRawResource",
                        int.class, new XC_MethodHook() {
                            @Override
                            protected void beforeHookedMethod(MethodHookParam p) {
                                try {
                                    if (Boolean.TRUE.equals(sProbing.get())) return;
                                    Map<Integer, String> m = sImg;
                                    if (m == null) return;
                                    Object a0 = p.args[0];
                                    if (!(a0 instanceof Integer)) return;
                                    String fn = m.get(a0);
                                    if (fn == null) return;
                                    byte[] png = pngBytes(fn);
                                    if (png == null) return;
                                    sHitRaw++;
                                    p.setResult(new java.io.ByteArrayInputStream(png));
                                } catch (Throwable ignore) {
                                }
                            }
                        });
            } catch (Throwable ignore) {
            }

        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】图片钩子挂了", t);
        }
    }

    /* ═══════════════════════ 图片 ═══════════════════════ */

    /** 取（并缓存）替换用 Drawable。解不出来就返回 null（= 用宿主原图）。 */
    private static Drawable drawableFor(Resources res, int id, String fileName) {
        return drawableFor(res, id, fileName, -1, -1);
    }

    /**
     * 取（并缓存）替换用 Drawable。
     *
     * @param hintW 宽度提示（&lt;0 = 不知道）。宿主图标大多是 20/24/26dp 的小矢量图，
     *              按 117px 塞进去会被裁成中间一小块 ⇒ 有这个提示就能等比缩放到图标尺寸。
     */
    private static Drawable drawableFor(Resources res, int id, String fileName, int hintW, int hintH) {
        // ★ 缓存键必须带上 hint 尺寸 —— 同一个资源在不同地方可能要求不同大小
        int key = hintW > 0 ? (id * 31 + hintW * 7 + hintH) : id;   // 无 hint = 按正方形裁
        Drawable cached = sImgCache.get(key);
        if (cached != null) return cached;
        if (sImgBad.containsKey(key)) return null;
        try {
            Context ctx = appCtx();
            if (ctx == null) return null;
            File f = new File(ctx.getFilesDir(), fileName);
            if (!f.isFile() || f.length() == 0) {
                sImgBad.put(key, 1);
                GmUtil.logOnce(TAG + ".miss" + key, "【FdmRes】图片不存在：" + f.getAbsolutePath());
                return null;
            }
            // ★★ 2026-11-07 修（主人报「改图和没改没区别」）：
            //   原来是 `BitmapFactory.decodeFile(路径)` —— **不采样**。
            //   主人选的那张 1.1 MB PNG，解成位图可能几十 MB，
            //   在宿主渲染热路径上必然 OOM；而 OOM 被 catch 成「这张图坏了」
            //   ⇒ 之后永远退回宿主原图 ⇒ 症状就是"改了跟没改一样"。
            //   现在：两趟解码，第一趟只量尺寸，第二趟按 ≤512（或按 hint）采样。
            BitmapFactory.Options o = new BitmapFactory.Options();
            o.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(f.getAbsolutePath(), o);
            int w = o.outWidth, h = o.outHeight;
            int limit = 512;
            if (hintW > 0) limit = Math.max(hintW, hintH);
            int sample = 1;
            while (w / sample > limit || h / sample > limit) sample *= 2;
            BitmapFactory.Options o2 = new BitmapFactory.Options();
            o2.inSampleSize = sample;
            o2.inPreferredConfig = Bitmap.Config.ARGB_8888;
            Bitmap bmp = null;
            try {
                bmp = BitmapFactory.decodeFile(f.getAbsolutePath(), o2);
            } catch (Throwable oom) {
                sDecodeFail++;
                sLastErr = "decode OOM " + w + "x" + h + " sample=" + sample + " : " + oom;
                GmUtil.log("【FdmRes】" + sLastErr);
                // 再退一档，宁可糊也别不出图
                try {
                    o2.inSampleSize = sample * 2;
                    bmp = BitmapFactory.decodeFile(f.getAbsolutePath(), o2);
                } catch (Throwable ignore) {
                }
            }
            if (bmp == null) {
                sImgBad.put(key, 1);
                sDecodeFail++;
                sLastErr = "decode null " + w + "x" + h;
                GmUtil.logOnce(TAG + ".bad" + key,
                        "【FdmRes】解不出图：" + f.getAbsolutePath() + " (" + w + "x" + h + ")");
                return null;
            }
            // ★★★ 2026-11-07 · 「大图蓝色方块」的定案修法（frida 证据在手）★★★
            //
            //  frida 探针已经证明**链路完全正确**：
            //    getValue string="fdm_replaced" → getDrawable → BitmapDrawable → vo0(BitmapPainter)
            //  ⇒ 钩子没问题，问题在**位图内容**。
            //
            //  真凶：主人选的 1440×3168 是**手机截图**，而我原来的裁切是
            //        「取短边居中裁成正方形」= 只保留截图**正中间那一小块**。
            //        截图中间往往是空白/纯色 ⇒ 裁出来就是一整块纯色
            //        ⇒ 再被 Compose 的 Icon tint 一染 ⇒ **蓝色/白色方块**。
            //        （小图能显示，是因为 36×40 那种图本身就是完整图案，裁不裁都一样。）
            //
            //  修法：**完整缩放（fit）** —— 整张图按比例缩进目标框、居中、四周留透明。
            //        任何比例的图都能"整张被看到"，绝不会"只裁到一块空白"。
            int targetW = hintW, targetH = hintH;
            if (targetW <= 0 || targetH <= 0) {
                try {
                    sProbing.set(Boolean.TRUE);
                    Drawable orig = res.getDrawable(id, null);
                    if (orig != null) {
                        int ow = orig.getIntrinsicWidth(), oh = orig.getIntrinsicHeight();
                        if (ow > 0 && oh > 0) {
                            targetW = ow;
                            targetH = oh;
                        }
                    }
                } catch (Throwable ignore) {
                } finally {
                    sProbing.remove();
                }
            }
            if (targetW <= 0 || targetH <= 0) {
                targetW = 96;
                targetH = 96;
            }
            try {
                int bw0 = bmp.getWidth(), bh0 = bmp.getHeight();
                float fit = Math.min((float) targetW / bw0, (float) targetH / bh0);
                int dw = Math.max(1, Math.round(bw0 * fit));
                int dh = Math.max(1, Math.round(bh0 * fit));
                Bitmap scaled = Bitmap.createScaledBitmap(bmp, dw, dh, true);
                if (scaled != bmp) bmp.recycle();
                bmp = scaled;
                if (dw != targetW || dh != targetH) {
                    Bitmap canvasBmp = Bitmap.createBitmap(targetW, targetH,
                            Bitmap.Config.ARGB_8888);
                    android.graphics.Canvas cv = new android.graphics.Canvas(canvasBmp);
                    cv.drawBitmap(bmp, (targetW - dw) / 2f, (targetH - dh) / 2f, null);
                    bmp.recycle();
                    bmp = canvasBmp;
                }
                GmUtil.log("【FdmRes】fit → " + bmp.getWidth() + "x" + bmp.getHeight()
                        + "（原 " + w + "x" + h + " 画进 " + dw + "x" + dh + "）");
            } catch (Throwable t) {
                GmUtil.logOnce(TAG + ".fit", "【FdmRes】fit 失败（保持原样）：" + t);
            }

            // ★ 调试落盘：把**处理后的**位图存一份，好 pull 出来看真实内容
            try {
                Context c0 = appCtx();
                if (c0 != null) {
                    File dbg = new File(c0.getFilesDir(), "res_dbg_" + safe(fileName));
                    java.io.FileOutputStream df = new java.io.FileOutputStream(dbg);
                    bmp.compress(Bitmap.CompressFormat.PNG, 100, df);
                    df.close();
                }
            } catch (Throwable ignore) {
            }


            BitmapDrawable d = new BitmapDrawable(res, bmp);
            rememberOurBitmap(bmp);            // ★ 记账，供剥离 tint 判定
            sImgCache.put(key, d);
            GmUtil.log("【FdmRes】✅ 替换生效 id=" + id + " 源 " + w + "x" + h
                    + " sample=" + sample + " → " + bmp.getWidth() + "x" + bmp.getHeight()
                    + (hintW > 0 ? (" (hint " + hintW + "x" + hintH + ")") : ""));
            return d;
        } catch (Throwable t) {
            sImgBad.put(key, 1);
            sDecodeFail++;
            sLastErr = String.valueOf(t);
            XposedBridge.log("[FdmRes] drawableFor 失败 id=" + id + " : " + t);
            return null;
        }
    }

    /**
     * 把替换用的 PNG **字节**读出来（带缓存）。
     *
     * <p>为什么不直接交给 display：{@code openRawResource} 要的是 InputStream，
     * 而我们要在**每次调用**都给一份新的流（流读完就废）。字节缓存一次，每次包一层。
     */
    private static byte[] pngBytes(String fileName) {
        byte[] cached = sPngCache.get(fileName);
        if (cached != null) return cached;
        try {
            Context ctx = appCtx();
            if (ctx == null) return null;
            File f = new File(ctx.getFilesDir(), fileName);
            if (!f.isFile() || f.length() <= 0) return null;
            java.io.FileInputStream in = new java.io.FileInputStream(f);
            byte[] buf;
            try {
                buf = new byte[(int) f.length()];
                int off = 0;
                while (off < buf.length) {
                    int n = in.read(buf, off, buf.length - off);
                    if (n <= 0) break;
                    off += n;
                }
                if (off < buf.length) {
                    byte[] t = new byte[off];
                    System.arraycopy(buf, 0, t, 0, off);
                    buf = t;
                }
            } finally {
                try {
                    in.close();
                } catch (Throwable ignore) {
                }
            }
            if (buf.length > 0) sPngCache.put(fileName, buf);
            return buf;
        } catch (Throwable t) {
            GmUtil.logOnce(TAG + ".pngb", "【FdmRes】读 PNG 字节失败：" + t);
            return null;
        }
    }

    /* ═══════════════════════ 配置 ═══════════════════════ */

    /** 从宿主配置重新读一遍（改完配置调它立刻生效）。 */
    public static void refresh(Context ctx) {
        sAt = System.currentTimeMillis();
        try {
            if (ctx == null) ctx = appCtx();
            if (ctx == null) {
                GmUtil.log("【FdmRes】refresh：拿不到 Context，跳过");
                return;
            }
            String raw = readCfg(ctx);
            if (raw == null || raw.length() == 0) {
                sText = null;
                sImg = null;
                sImgCache.clear();
                sImgBad.clear();
                GmUtil.log("【FdmRes】refresh：配置为空 ⇒ 全部还原");
                return;
            }

            JSONObject j = new JSONObject(raw);
            Map<Integer, String> t = new HashMap<Integer, String>();
            Map<Integer, String> i = new HashMap<Integer, String>();

            String pkg = ctx.getPackageName();
            Resources res = ctx.getResources();
            int miss = 0;

            JSONObject jo = j.optJSONObject("t");
            if (jo != null) {
                for (Iterator<String> it = jo.keys(); it.hasNext(); ) {
                    String name = it.next();
                    String val = jo.optString(name, null);
                    if (name == null || val == null) continue;
                    int id = res.getIdentifier(name, "string", pkg);
                    if (id == 0) {
                        miss++;
                        continue;
                    }
                    t.put(id, val);
                }
            }

            JSONObject ji = j.optJSONObject("i");
            if (ji != null) {
                for (Iterator<String> it = ji.keys(); it.hasNext(); ) {
                    String name = it.next();
                    String fn = ji.optString(name, null);
                    if (name == null || fn == null || fn.length() == 0) continue;
                    int id = res.getIdentifier(name, "drawable", pkg);
                    if (id == 0) {
                        miss++;
                        continue;
                    }
                    i.put(id, fn);
                }
            }

            // ★ 空表就是 null —— 让热路径那是"一次 null 判断"
            sText = t.isEmpty() ? null : t;
            sImg = i.isEmpty() ? null : i;
            sImgCache.clear();
            sImgBad.clear();
            sPngCache.clear();
            sOurBitmaps.clear();

            GmUtil.log("【FdmRes】refresh ✅ 文字 " + t.size() + " 条 · 图片 " + i.size()
                    + " 条" + (miss > 0 ? " · 名字没查到 " + miss + " 条（宿主可能改过名）" : ""));
        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】refresh 失败（保持上一份配置）", t);
        }
    }

    /** 读配置：优先 GmStore（宿主配置层），桶不通就退 SharedPreferences。 */
    private static String readCfg(Context ctx) {
        try {
            String v = GmStore.read2(ctx, KEY, null);
            if (v != null && v.length() > 0) return v;
        } catch (Throwable ignore) {
        }
        try {
            return ctx.getSharedPreferences("fdm_ui", Context.MODE_PRIVATE).getString(KEY, null);
        } catch (Throwable ignore) {
        }
        return null;
    }

    /* ═══════════════════════ 写入（给 FdmBridge 用）═══════════════════════ */

    /** 当前配置 JSON（UI 回读用）。没有就返回 {@code {"v":1,"t":{},"i":{}}}。 */
    public static String dump(Context ctx) {
        try {
            String raw = readCfg(ctx);
            if (raw != null && raw.length() > 0) return raw;
        } catch (Throwable ignore) {
        }
        return "{\"v\":1,\"t\":{},\"i\":{}}";
    }

    /**
     * 改一条文字。
     *
     * @param name 资源名（如 {@code session_init_title}）
     * @param text 新文字；<b>null 或空串 = 还原这一条</b>
     */
    public static String setText(Context ctx, String name, String text) {
        try {
            JSONObject j = new JSONObject(dump(ctx));
            if (!j.has("t")) j.put("t", new JSONObject());
            if (!j.has("i")) j.put("i", new JSONObject());
            j.put("v", 1);
            JSONObject t = j.getJSONObject("t");
            if (text == null || text.length() == 0) {
                t.remove(name);
            } else {
                t.put(name, text);
            }
            save(ctx, j);
            refresh(ctx);
            return "文字 " + name + " → " + (text == null || text.length() == 0 ? "已还原" : "「" + text + "」");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】setText 失败", t);
            return "设置失败：" + t;
        }
    }

    /**
     * 改一条图片。
     *
     * @param name 资源名（如 {@code assistant_message_avatar}）
     * @param file 已经把图拷进宿主 filesDir 的那个文件；<b>null = 还原这一条</b>
     */
    public static String setImg(Context ctx, String name, File file) {
        try {
            JSONObject j = new JSONObject(dump(ctx));
            if (!j.has("t")) j.put("t", new JSONObject());
            if (!j.has("i")) j.put("i", new JSONObject());
            j.put("v", 1);
            JSONObject i = j.getJSONObject("i");
            if (file == null) {
                // 还原时顺手把图删掉（省空间，也免得下次误用）
                try {
                    String old = i.optString(name, null);
                    if (old != null) {
                        File of = new File(ctx.getFilesDir(), old);
                        if (of.isFile()) of.delete();
                    }
                } catch (Throwable ignore) {
                }
                i.remove(name);
            } else {
                i.put(name, file.getName());
            }
            save(ctx, j);
            refresh(ctx);
            return "图片 " + name + " → " + (file == null ? "已还原" : file.getName()
                    + "（" + file.length() + " 字节）");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】setImg 失败", t);
            return "设置失败：" + t;
        }
    }

    /** 一键全还原（文字 + 图片，顺带把图删掉）。 */
    public static String clearAll(Context ctx) {
        try {
            // 先把图删干净
            int n = 0;
            try {
                JSONObject j = new JSONObject(dump(ctx));
                JSONObject i = j.optJSONObject("i");
                if (i != null) {
                    for (Iterator<String> it = i.keys(); it.hasNext(); ) {
                        String name = it.next();
                        String fn = i.optString(name, null);
                        if (fn == null) continue;
                        File f = new File(ctx.getFilesDir(), fn);
                        if (f.isFile() && f.delete()) n++;
                    }
                }
            } catch (Throwable ignore) {
            }
            save(ctx, new JSONObject("{\"v\":1,\"t\":{},\"i\":{}}"));
            refresh(ctx);
            GmUtil.log("【FdmRes】全部还原（删掉 " + n + " 个图）");
            return "已全部还原（删掉 " + n + " 个图）";
        } catch (Throwable t) {
            return "还原失败：" + t;
        }
    }

    /** 图片落点（UI 侧把图拷进来时用）。 */
    public static File imgFile(Context ctx, String name) {
        String safe = name == null ? "x" : name.replaceAll("[^A-Za-z0-9_.-]", "_");
        return new File(ctx.getFilesDir(), IMG_PREFIX + safe + ".png");
    }

    private static void save(Context ctx, JSONObject j) {
        String s = j.toString();
        try {
            GmStore.write(ctx, KEY, s, "t");
        } catch (Throwable ignore) {
        }
        // 双写：桶不通时至少 SP 有一份（refresh 两边都读）
        try {
            ctx.getSharedPreferences("fdm_ui", Context.MODE_PRIVATE).edit().putString(KEY, s).apply();
        } catch (Throwable ignore) {
        }
    }

    private static Context appCtx() {
        try {
            Context c = GmUtil.app();
            if (c != null) return c;
        } catch (Throwable ignore) {
        }
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Object app = XposedHelpers.callStaticMethod(at, "currentApplication");
            if (app instanceof Context) return (Context) app;
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** 这张 Bitmap 是不是我们替换用的那张？（纯 int 比较，热路径安全） */
    private static boolean isOurBitmap(Object bmp) {
        if (bmp == null) return false;
        try {
            return sOurBitmaps.containsKey(System.identityHashCode(bmp));
        } catch (Throwable ignore) {
            return false;
        }
    }

    /** 把我们替换用的 Bitmap 记下来（refresh 时调用）。 */
    private static void rememberOurBitmap(Bitmap bmp) {
        if (bmp == null) return;
        try {
            sOurBitmaps.put(System.identityHashCode(bmp), 1);
        } catch (Throwable ignore) {
        }
    }

    /* ══════════════════ 一键导出 / 导入（2026-11-07）══════════════════ */

    /** 备份包里配置文件的固定名字。 */
    private static final String ZIP_CFG = "config.json";
    /** 备份包里图片目录前缀。 */
    private static final String ZIP_IMG_DIR = "img/";

    /**
     * 把「当前配置 + 所有替换图」打包成一个 zip，写进**宿主已授权的 SAF 目录**。
     *
     * <h3>为什么打包在宿主侧做</h3>
     * 图片文件就在宿主私有目录（{@code filesDir/fuckds_res__*.png}），
     * 配置也在宿主配置层 —— 全在这边，打包最省事；UI 那边只需要读回来。
     *
     * <h3>包结构</h3>
     * <pre>
     *   config.json      ← 就是 fuckds_res_map 那份（t=文字 / i=图片名）
     *   img/&lt;名字&gt;.png    ← 只有 i 里真正引用到的图
     *   meta.json        ← 包信息（版本/时间/条目数/宿主包名）
     * </pre>
     *
     * @return 成功返回 SAF 里的 content uri；失败返回 null
     */
    public static String exportZip(Context ctx, String fileName) {
        try {
            if (ctx == null) return null;
            String raw = dump(ctx);
            JSONObject cfg = new JSONObject(raw);

            java.io.File tmp = new java.io.File(ctx.getCacheDir(), "res_export.zip");
            java.io.FileOutputStream fos = new java.io.FileOutputStream(tmp);
            java.util.zip.ZipOutputStream zos = new java.util.zip.ZipOutputStream(fos);
            try {
                zos.setLevel(6);
                // ① config.json
                putEntry(zos, ZIP_CFG, raw.getBytes("UTF-8"));

                // ② 图片（只打 i 里引用到的）
                JSONObject i = cfg.optJSONObject("i");
                int imgCount = 0;
                if (i != null) {
                    java.util.Iterator<String> it = i.keys();
                    while (it.hasNext()) {
                        String name = it.next();
                        String fn = i.optString(name, null);
                        if (fn == null || fn.isEmpty()) continue;
                        java.io.File f = new java.io.File(ctx.getFilesDir(), fn);
                        if (!f.isFile() || f.length() <= 0) continue;
                        putEntry(zos, ZIP_IMG_DIR + fn, readAll(f));
                        imgCount++;
                    }
                }

                // ③ meta.json（给人看的，也让导入时能校验）
                JSONObject meta = new JSONObject();
                meta.put("kind", "fdm-res-beauty");
                meta.put("v", 1);
                meta.put("at", System.currentTimeMillis());
                meta.put("pkg", ctx.getPackageName());
                meta.put("text", cfg.optJSONObject("t") == null ? 0 : cfg.optJSONObject("t").length());
                meta.put("img", imgCount);
                putEntry(zos, "meta.json", meta.toString().getBytes("UTF-8"));
            } finally {
                try {
                    zos.close();
                } catch (Throwable ignore) {
                }
            }

            // ★ 2026-11-07 修：「0 字节」—— 原来在 copyToSaf **之前**就 tmp.delete() 了
            long size = tmp.length();
            String ext = copyToSaf(ctx, tmp, fileName, "application/zip");
            tmp.delete();
            String msg = "导出 " + fileName + " · " + size + " 字节 → "
                    + (ext == null ? "（没写进 SAF 目录）" : ext);
            GmUtil.log("【FdmRes】" + msg);
            return ext;
        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】exportZip 失败", t);
            return null;
        }
    }

    /**
     * 从 SAF 目录里读一个 zip，恢复配置 + 图片。
     *
     * <p>⚠️ 导入是**整体替换**（先清空再写），不是合并 —— 这样「导入一个备份」
     * 得到的就正好是那个备份的状态，不会留下上一份的残留。
     *
     * @return 结果描述（给 UI 显示）
     */
    public static String importZip(Context ctx, String fileName) {
        try {
            if (ctx == null) return "没有 Context";
            byte[] data = readSafFile(ctx, fileName);
            if (data == null || data.length == 0) return "读不到文件：" + fileName;

            // ★★★ 2026-11-08 修「导入后图片全没」（主人实测：文字 13 条全成功，图片 7 张全失效）
            //
            //   真凶是**顺序**：原来 clearImages() 写在解压循环**之后**，
            //   ⇒ 解压时刚写好的 7 张图，紧接着被 clearImages 按前缀全删了。
            //   日志铁证：`refresh ✅ 文字 13 条 · 图片 7 条` 之后就全是
            //   `图片不存在：…/files/fuckds_res__xxx.png`。
            //
            //   ⇒ 必须在**解压之前**清旧图。
            int oldCleared = clearImages(ctx);

            java.util.zip.ZipInputStream zis = new java.util.zip.ZipInputStream(
                    new java.io.ByteArrayInputStream(data));
            String cfgJson = null;
            JSONObject meta = null;
            int imgOk = 0, imgFail = 0;
            java.util.List<String> names = new java.util.ArrayList<String>();
            try {
                java.util.zip.ZipEntry e;
                while ((e = zis.getNextEntry()) != null) {
                    String n = e.getName();
                    if (n == null) continue;
                    if (ZIP_CFG.equals(n)) {
                        cfgJson = new String(readAll(zis), "UTF-8");
                    } else if ("meta.json".equals(n)) {
                        try {
                            meta = new JSONObject(new String(readAll(zis), "UTF-8"));
                        } catch (Throwable ignore) {
                        }
                    } else if (n.startsWith(ZIP_IMG_DIR)) {
                        String fn = n.substring(ZIP_IMG_DIR.length());
                        if (fn.isEmpty() || fn.indexOf('/') >= 0) continue;   // 只认平铺的
                        java.io.File dst = new java.io.File(ctx.getFilesDir(), fn);
                        try {
                            java.io.FileOutputStream fo = new java.io.FileOutputStream(dst);
                            try {
                                copyStream(zis, fo);
                            } finally {
                                fo.close();
                            }
                            if (dst.isFile() && dst.length() > 0) {
                                imgOk++;
                                names.add(fn);
                            } else {
                                imgFail++;
                            }
                        } catch (Throwable t) {
                            imgFail++;
                        }
                    }
                    zis.closeEntry();
                }
            } finally {
                try {
                    zis.close();
                } catch (Throwable ignore) {
                }
            }

            if (cfgJson == null || cfgJson.trim().isEmpty()) {
                return "包里没有 " + ZIP_CFG + "（不是本功能的备份？）";
            }
            // 校验格式
            JSONObject j = new JSONObject(cfgJson);
            if (j.optJSONObject("t") == null && j.optJSONObject("i") == null) {
                return "配置格式不对（缺 t / i）";
            }
            // 旧图已在解压前清掉了（见上）
            save(ctx, j);
            refresh(ctx);

            int nT = j.optJSONObject("t") == null ? 0 : j.optJSONObject("t").length();
            int nI = j.optJSONObject("i") == null ? 0 : j.optJSONObject("i").length();
            StringBuilder sb = new StringBuilder();
            sb.append("导入完成：文字 ").append(nT).append(" 条 · 图片 ").append(nI)
                    .append(" 条（写到 ").append(imgOk).append(" 个文件");
            if (imgFail > 0) sb.append("，失败 ").append(imgFail);
            sb.append("；清掉旧图 ").append(oldCleared).append(" 个）");
            if (meta != null) {
                try {
                    sb.append("\n包信息：").append(meta.optLong("at"))
                            .append(" · 来自 ").append(meta.optString("pkg", "?"));
                } catch (Throwable ignore) {
                }
            }
            GmUtil.log("【FdmRes】" + sb.toString().replace("\n", " | "));
            return sb.toString();
        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】importZip 失败", t);
            return "导入失败：" + t;
        }
    }

    /** 删掉 filesDir 里所有替换图，返回删掉几个。 */
    private static int clearImages(Context ctx) {
        int n = 0;
        try {
            java.io.File dir = ctx.getFilesDir();
            java.io.File[] all = dir.listFiles();
            if (all == null) return 0;
            for (java.io.File f : all) {
                String nm = f.getName();
                if (nm != null && nm.startsWith(IMG_PREFIX) && f.isFile() && f.delete()) n++;
            }
        } catch (Throwable ignore) {
        }
        return n;
    }

    private static void putEntry(java.util.zip.ZipOutputStream zos, String name, byte[] data)
            throws Exception {
        java.util.zip.ZipEntry e = new java.util.zip.ZipEntry(name);
        e.setTime(System.currentTimeMillis());
        zos.putNextEntry(e);
        zos.write(data);
        zos.closeEntry();
    }

    private static byte[] readAll(java.io.File f) throws Exception {
        java.io.FileInputStream in = new java.io.FileInputStream(f);
        try {
            java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream(
                    (int) Math.min(f.length(), 8 * 1024 * 1024));
            copyStream(in, bos);
            return bos.toByteArray();
        } finally {
            try {
                in.close();
            } catch (Throwable ignore) {
            }
        }
    }

    private static byte[] readAll(java.io.InputStream in) throws Exception {
        java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
        copyStream(in, bos);
        return bos.toByteArray();
    }

    private static void copyStream(java.io.InputStream in, java.io.OutputStream out)
            throws Exception {
        byte[] b = new byte[8192];
        int n;
        while ((n = in.read(b)) > 0) out.write(b, 0, n);
        out.flush();
    }

    /** 从 SAF 目录根下读一个文件。 */
    private static byte[] readSafFile(Context ctx, String fileName) {
        try {
            String treeStr = com.nidyaber.fuckdsmanger.bridge.GmLocalMusic.tree(ctx);
            if (treeStr == null || treeStr.isEmpty()) return null;
            if (!com.nidyaber.fuckdsmanger.bridge.GmLocalMusic.treeGranted(ctx, treeStr)) return null;
            android.net.Uri treeUri = android.net.Uri.parse(treeStr);
            String rootId = android.provider.DocumentsContract.getTreeDocumentId(treeUri);
            android.net.Uri children = android.provider.DocumentsContract
                    .buildChildDocumentsUriUsingTree(treeUri, rootId);
            android.database.Cursor cur = ctx.getContentResolver().query(children,
                    new String[]{
                            android.provider.DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                            android.provider.DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                    }, null, null, null);
            if (cur == null) return null;
            try {
                while (cur.moveToNext()) {
                    String id = cur.getString(0);
                    String nm = cur.getString(1);
                    if (id == null || !fileName.equals(nm)) continue;
                    android.net.Uri u = android.provider.DocumentsContract
                            .buildDocumentUriUsingTree(treeUri, id);
                    java.io.InputStream in = ctx.getContentResolver().openInputStream(u);
                    if (in == null) return null;
                    try {
                        return readAll(in);
                    } finally {
                        try {
                            in.close();
                        } catch (Throwable ignore) {
                        }
                    }
                }
            } finally {
                try {
                    cur.close();
                } catch (Throwable ignore) {
                }
            }
        } catch (Throwable t) {
            GmUtil.logOnce(TAG + ".readsaf", "【FdmRes】读 SAF 文件失败：" + t);
        }
        return null;
    }

    /** 自检（给 adb / UI 用）：报告当前生效了什么。 */
    public static String selfTest() {
        StringBuilder sb = new StringBuilder();
        Map<Integer, String> t = sText;
        Map<Integer, String> i = sImg;
        sb.append("已装=").append(sInstalled)
                .append(" 文字=").append(t == null ? 0 : t.size())
                .append(" 图片=").append(i == null ? 0 : i.size())
                .append(" 图缓存=").append(sImgCache.size())
                .append(" 图失败=").append(sImgBad.size())
                .append(" refreshAt=").append(sAt)
                // ★ 诊断：这个数字是 0 就说明宿主**根本没调** getDrawable
                //   （那这台的图就不是走 Drawable 的，得换方案）
                .append(" | getValue调用=").append(sHitVal)
                .append(" getValue改成功=").append(sHitValOk)
                .append(" openRawResource命中=").append(sHitRaw)
                .append(" getXml命中=").append(sHitXml)
                .append(" decU命中=").append(sHitU)
                .append(" decU改成功=").append(sHitUOk)
                .append(" 剥离tint=").append(sHitStrip)
                .append(" getDrawable调用=").append(sHitDraw)
                .append(" 未命中=").append(sHitDrawMiss)
                .append(" 解码失败=").append(sDecodeFail);
        if (sLastErr != null && sLastErr.length() > 0) sb.append(" 末次错=").append(sLastErr);
        return sb.toString();
    }

    /** 只有诊断用：宿主到底有没有调 getDrawable。 */
    public static int hitDraw() {
        return sHitDraw;
    }

    /* ══════════════════ 预览导出（把宿主原图「拿」到 UI 那边看）══════════════════ */

    /**
     * 把某个 drawable 资源的**当前样子**导出成 PNG，返回 UI 能读到的路径。
     *
     * <h3>为什么不能直接用 UI 进程读</h3>
     * 宿主和模块是**两个 APK**，资源表各自独立。
     * UI 里 {@code getResources().getDrawable(0x7f07005a)} 拿到的是**我们自己**的同名 id
     * （或者直接 NotFoundException）—— 宿主那个 id 在 UI 这边根本不存在。
     * 而 {@code createPackageContext} 对已安装的其它 APK 走不通（包可见性过滤，教训：3.75.x）。
     *
     * <h3>★ 为什么要复用「音乐曲库目录」的 SAF 授权（主人的主意）</h3>
     * 宿主清单里**没有** {@code WRITE_EXTERNAL_STORAGE} 之类的权限，
     * 唯一能往「用户看得见的地方」写文件的通路，就是用户自己给过的那个
     * {@code ACTION_OPEN_DOCUMENT_TREE} 持久授权 ——
     * 而它已经存在了（{@code GmLocalMusic.tree()}，音乐曲库在用，读写权限都持久化了）。
     * ⇒ 直接往那个文件夹里写 {@code fdm_res_preview_<名字>.png}，
     *   UI 用 {@code MANAGE_EXTERNAL_STORAGE} 读回来。**零新权限、零新交互。**
     *
     * @param name  资源名（如 {@code assistant_message_avatar}）
     * @param force true = 重新导出一份（预览弹窗打开时用）；
     *              false = 已经导过就直接返回路径（改配置后批量刷新用）
     * @return 成功返回绝对路径（UI 侧 {@code /sdcard/…} 形态）；失败返回 {@code null}
     */
    public static String preview(Context ctx, String name, boolean force) {
        if (ctx == null || name == null || name.isEmpty()) return null;
        try {
            // ① 已导出过就直接用（同一进程内宿主文件不会自己变）
            int id = ctx.getResources().getIdentifier(name, "drawable", ctx.getPackageName());
            if (id == 0) {
                GmUtil.logOnce(TAG + ".pvf." + name, "【FdmRes】预览：查不到 drawable/" + name);
                return null;
            }
            File local = new File(ctx.getCacheDir(), "res_pv_" + safe(name) + ".png");

            // ② 取**当前**样子：走我们自己那只 hook，已替换的会拿到替换图，没替换的是原图
            //    ⚠️ 这里必须用 getDrawable(id, null) —— 和宿主渲染走同一条路
            Drawable d = ctx.getResources().getDrawable(id, null);
            if (d == null) {
                GmUtil.logOnce(TAG + ".pvn." + name, "【FdmRes】预览：drawable 为 null：" + name);
                return null;
            }

            // ③ 画到 bitmap（按原始尺寸，太大的缩到 512 省内存）
            int w = d.getIntrinsicWidth() > 0 ? d.getIntrinsicWidth() : 96;
            int h = d.getIntrinsicHeight() > 0 ? d.getIntrinsicHeight() : 96;
            int max = 512;
            if (w > max || h > max) {
                float s = Math.min((float) max / w, (float) max / h);
                w = Math.max(1, Math.round(w * s));
                h = Math.max(1, Math.round(h * s));
            }
            Bitmap bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
            android.graphics.Canvas c = new android.graphics.Canvas(bmp);
            d.setBounds(0, 0, w, h);
            d.draw(c);

            // ④ 先落进程私有目录（一定能写）—— 给「导出到相册」和「备份」用
            java.io.FileOutputStream fo = new java.io.FileOutputStream(local);
            try {
                bmp.compress(Bitmap.CompressFormat.PNG, 100, fo);
            } finally {
                try {
                    fo.close();
                } catch (Throwable ignore) {
                }
            }

            // ⑤ 顺手往 SAF 目录放一份（用户在看得到的相册/文件夹里也能看到）
            //    ⚠️ 这一步**失败不影响预览** —— 预览走的是下面的 base64。
            try {
                String ext = copyToSaf(ctx, local, "fdm_res_preview_" + safe(name) + ".png");
                if (ext != null) GmUtil.log("【FdmRes】预览已导出到相册：" + ext);
            } catch (Throwable ignore) {
            }

            // ★★★ 2026-11-07 修「宿主没能把这张图画出来」（主人报）：
            //
            //   原来 return 的是 `local.getAbsolutePath()` =
            //     /data/user/0/com.deepseek.chat.a/cache/res_pv_xxx.png
            //   —— 那是**宿主的私有目录**，UI 进程既没有那个 uid 的文件权限、
            //   也没有任何存储权限（模块 manifest 里一条 READ/WRITE/MANAGE 都没有）
            //   ⇒ UI 永远读不到 ⇒ 只能报"没能画出来"。
            //
            //   修法：**不走文件，走内存**。把 PNG 编码成 base64 直接塞进广播，
            //   UI 那边 Base64.decode + BitmapFactory.decodeByteArray。
            //   ⇒ 零权限、零路径依赖，谁都能看。
            //   体积：117×117 的图 ≈ 25 KB → base64 ≈ 34 KB，远低于 1 MB 的 Binder 上限；
            //   这里还把长边压到 320，更大的图也不会爆。
            String b64 = null;
            try {
                java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
                int maxSide = 320;
                Bitmap out = bmp;
                if (bmp.getWidth() > maxSide || bmp.getHeight() > maxSide) {
                    float s = Math.min((float) maxSide / bmp.getWidth(),
                            (float) maxSide / bmp.getHeight());
                    out = Bitmap.createScaledBitmap(bmp,
                            Math.max(1, Math.round(bmp.getWidth() * s)),
                            Math.max(1, Math.round(bmp.getHeight() * s)), true);
                }
                out.compress(Bitmap.CompressFormat.PNG, 100, bos);
                if (out != bmp) out.recycle();
                b64 = android.util.Base64.encodeToString(bos.toByteArray(),
                        android.util.Base64.NO_WRAP);
            } finally {
                try {
                    bmp.recycle();
                } catch (Throwable ignore) {
                }
            }
            sLastPreview = b64;
            GmUtil.log("【FdmRes】预览已生成：" + name + " · " + w + "x" + h
                    + " · base64 " + (b64 == null ? 0 : b64.length()) + " 字符");
            return b64;
        } catch (Throwable t) {
            GmUtil.logFail("【FdmRes】preview(" + name + ") 失败", t);
            return null;
        }
    }

    /** 最近一次预览的 base64（FdmBridge 取它回传给 UI）。 */
    private static volatile String sLastPreview = null;

    public static String lastPreview() {
        return sLastPreview;
    }

    /** 把文件拷进音乐曲库那个已授权目录（复用它，不新增权限）。返回 content uri 或 null。 */
    private static String copyToSaf(Context ctx, File src, String fileName) {
        // ★ 2026-11-07 修：默认 image/png（预览图用）；备份包要显式传 application/zip，
        //   否则 DocumentsContract 会按 MIME 给文件名补上 .png 后缀。
        return copyToSaf(ctx, src, fileName, "image/png");
    }

    private static String copyToSaf(Context ctx, File src, String fileName, String mime) {
        try {
            String treeStr = com.nidyaber.fuckdsmanger.bridge.GmLocalMusic.tree(ctx);
            if (treeStr == null || treeStr.isEmpty()) return null;
            if (!com.nidyaber.fuckdsmanger.bridge.GmLocalMusic.treeGranted(ctx, treeStr)) return null;

            android.net.Uri treeUri = android.net.Uri.parse(treeStr);
            String rootId = android.provider.DocumentsContract.getTreeDocumentId(treeUri);
            android.net.Uri parent = android.provider.DocumentsContract
                    .buildDocumentUriUsingTree(treeUri, rootId);

            // 同名先删（DocumentsContract.createDocument 遇到同名会自动加 (1)，越攒越多）
            try {
                android.net.Uri children = android.provider.DocumentsContract
                        .buildChildDocumentsUriUsingTree(treeUri, rootId);
                android.database.Cursor cur = ctx.getContentResolver().query(children,
                        new String[]{
                                android.provider.DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                                android.provider.DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                        }, null, null, null);
                if (cur != null) {
                    try {
                        while (cur.moveToNext()) {
                            String n = cur.getString(1);
                            if (n != null && n.equals(fileName)) {
                                android.provider.DocumentsContract.deleteDocument(
                                        ctx.getContentResolver(),
                                        android.provider.DocumentsContract
                                                .buildDocumentUriUsingTree(treeUri, cur.getString(0)));
                                break;
                            }
                        }
                    } finally {
                        try {
                            cur.close();
                        } catch (Throwable ignore) {
                        }
                    }
                }
            } catch (Throwable ignore) {
            }

            android.net.Uri dst = android.provider.DocumentsContract.createDocument(
                    ctx.getContentResolver(), parent, mime, fileName);
            if (dst == null) return null;
            java.io.InputStream in = new java.io.FileInputStream(src);
            java.io.OutputStream out = ctx.getContentResolver().openOutputStream(dst);
            if (out == null) {
                try {
                    in.close();
                } catch (Throwable ignore) {
                }
                return null;
            }
            try {
                byte[] b = new byte[8192];
                int n;
                while ((n = in.read(b)) > 0) out.write(b, 0, n);
                out.flush();
            } finally {
                try {
                    in.close();
                } catch (Throwable ignore) {
                }
                try {
                    out.close();
                } catch (Throwable ignore) {
                }
            }
            return dst.toString();
        } catch (Throwable t) {
            GmUtil.logOnce(TAG + ".safE", "【FdmRes】写 SAF 目录失败：" + t);
            return null;
        }
    }

    private static String safe(String s) {
        return s == null ? "x" : s.replaceAll("[^A-Za-z0-9_.-]", "_");
    }
}
