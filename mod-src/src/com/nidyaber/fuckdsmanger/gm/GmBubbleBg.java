// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;

import com.nidyaber.fuckdsmanger.bridge.GmRemap;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;

import java.io.File;
import java.io.FileWriter;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.Map;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 气泡背景 · v2 —— <b>用户气泡 + 助手(AI)气泡，各自「纯色 / 图片」两档</b>🐲 2026-11-01
 *
 * <h3>为什么是 v2（v1 到哪一步了）</h3>
 * v1（3.74.3）只做了<b>用户气泡纯色</b>：靠 {@code t82.t} 认出气泡 → 拿 Canvas 自己画矩形
 * → 宿主的 {@code clip} 自动裁成气泡形状。真机通过。
 *
 * <p>这一版在同一个引擎上加两件东西：
 * <ol>
 *   <li><b>图片背景</b>（同一个 draw 位置，把 drawRect 换成 drawBitmap 铺满）</li>
 *   <li><b>助手气泡</b>（宿主<b>没有</b>气泡容器 ⇒ 必须自己造一个绘制节点，见下）</li>
 * </ol>
 *
 * <h3>★ 助手气泡怎么拿到「绘制节点」（这一版唯一的新机制）</h3>
 * 宿主 2.7.2 里助手消息<b>真的没有气泡底色</b> —— {@code e40.a}（AssistantChatMessageCell.kt:130）
 * 里实测<b>没有任何</b> {@code x98}（background）调用，也没有 {@code l23}（MessageBubbleLayout）。
 * 所以没有现成的节点可以改。做法：
 *
 * <pre>
 * e40.a(...) 的参数里第 11 个就是 Modifier（yj7）     ← 实测 e40.smali:38
 *   ⇒ before 里把 args[11] 换成 x98.t(mod, 透明色, 气泡圆角形状)
 *   ⇒ 宿主自己 new 出 yi0（background 元素）⇒ yi0.b() ⇒ zi0（绘制节点）
 *   ⇒ 我们的 draw hook 就认得它了
 * </pre>
 *
 * 注入的颜色取<b>完全透明</b>：宿主画什么都看不见，真正的底色由我们在 draw 里画。
 * 这样做的好处是<b>一个像素的宿主数据都不改</b>（v1 的教训：碰 Compose 的 Color 编码会崩）。
 *
 * <p>⚠️ 这套依赖 {@code e40}/{@code x98}/{@code yj7} 三个 R8 短名，所以全部
 * <b>结构校验 + 失败就整体不启用</b>（找不到就当没这功能，绝不连累宿主）。
 *
 * <h3>画在 after 而不是 before（踩过）</h3>
 * 绘制节点自己会先画一次底色。画在 before ⇒ 被它盖掉。所以必须 after：
 * <b>宿主画完，我们覆盖上去</b>。
 *
 * <h3>日志</h3>
 * 先走 {@link GmUtil#log}（→ logcat，tag=FDM），再尽力写
 * {@code /sdcard/Android/data/<宿主>/files/fdm-bubble.log}。
 */
public final class GmBubbleBg {

    private GmBubbleBg() {
    }

    // ═══════════════════════════ 两类气泡 ═══════════════════════════

    /** 用户气泡（宿主有容器：{@code okb.e} → {@code x98.t} → {@code clip(t82.t)}） */
    public static final int KIND_USER = 1;
    /** 助手/AI 气泡（宿主<b>没有</b>容器，靠注入 Modifier 造出来） */
    public static final int KIND_ASSIST = 2;

    // ── 2.7.2 宿主里的落点（全部套 try，找不到就安全退出，绝不牵连宿主）──
    // ★★ 2026-11-06（3.75.18 · 宿主 2.7.5）—— 这一整块原来**写死 2.7.2 的短名**，
    //   一次 GmRemap 都没走 ⇒ 宿主一升级，气泡全集静默失效（日志：
    //     `① 拿 Shape 失败: NoSuchFieldError: t82#t`
    //     `⑥ Modifier 不是接口 ⇒ 不注入助手背景`）
    //   ⇒ 全部改成**每次现查 GmRemap**（表是唯一的真相源，加一代就自动跟着走）。
    //
    //   2.7.2 → 2.7.5 的实测映射（都在 GmRemap 的 CLS6 里登记）：
    //     yi0 → zi0   背景 Element
    //     zi0 → ?     绘制节点（见 CLS_NODE() 注释）
    //     t82 → y82   气泡 Shape 容器 ★ 35 个字段全同（t:Lib9;→Lpb9;、n:Lk78;→Lq78;）
    //     vcc → ?     clip 所在类
    //     yj7 → fk7   Modifier 接口
    //     x98 → da8   background 扩展

    /** 背景元素（Modifier.Element）。字段 a=J 颜色 / b=Brush / c=F alpha / d=Shape。 */
    private static String CLS_ELEM() { return GmRemap.cls("yi0"); }
    /** 绘制节点（Modifier.Node）。字段 o=J 颜色 / p=Brush / q=F alpha / r=Shape。 */
    private static String CLS_NODE() { return GmRemap.cls("nod"); }
    /** 绘制节点的基类（Modifier.Node）。用来精确挑 b()/d()，避免误挂 hashCode()。 */
    private static String CLS_NODEBASE() { return GmRemap.cls("nodbase"); }
    /** 气泡专用裁剪 Shape 的常量所在类（用户气泡的身份指纹：全宿主仅 2 处引用）。 */
    private static String CLS_SHAPEHOLDER() { return GmRemap.cls("shapeholder"); }
    /** 上面那个 Shape 的字段名。 */
    private static final String FLD_BUBBLE_SHAPE = "t";
    /** clip(Modifier, Shape) 所在类 / 方法。 */
    private static String CLS_MOD() { return GmRemap.cls("clipmod"); }
    private static String MTH_CLIP() { return GmRemap.method("clipmod", "clip"); }
    /** 圆角 Shape 的常量（{@code vcc.n}，{@code Lkc5;}）—— 只在拿不到气泡 Shape 时兜底。 */
    private static final String FLD_ROUND_SHAPE = "n";

    // ── 助手气泡注入用（全部要过结构校验）──
    /** Compose 的 Modifier 接口（唯一方法 F = then）。 */
    private static String CLS_MODIFIER() { return GmRemap.cls("yj7"); }
    /** background 扩展所在类；{@code t(Modifier, long color, Shape) : Modifier}。 */
    private static String CLS_BG_KT() { return GmRemap.clsFor("clipmod", "bg"); }
    private static String MTH_BG_COLOR() { return GmRemap.method("clipmod", "bg"); }
    /** 助手<b>单条消息</b>的 composable 容器；参数里恰好有一个 Modifier。
     *  <p>2.7.2：{@code e40.a} = AssistantChatMessageCell (AssistantChatMessageCell.kt:130)
     *  <p>★ 实测尺寸 1440x1526 = <b>整屏宽 + 这条消息的完整高度</b>（主人要的就是这个范围）。
     *  <p>⚠️ 别用 {@code ru7.c}（AssistantChatMessageContent.kt:100）—— 实测宽 1146，
     *  比留言区窄一截（主人 2026-11-01：「太窄了，真正的范围应该是……带黑色区域」）。
     *  <p>⚠️ 形状要用 {@code vcc.n}：它自带内缩，正好把背景从头像右边开始画；
     *  用气泡裁剪形状 {@code t82.t} 反而更窄（同上实测）。 */
    private static String CLS_ASSIST() { return GmRemap.cls("assistcell"); }
    private static final String MTH_ASSIST = "a";
    /** 备用候选（Cell 找不到才退回内容层 —— 窄一点，但总比没有强）。 */
    private static String CLS_ASSIST2() { return GmRemap.cls("assistbody"); }
    private static final String MTH_ASSIST2 = "c";

    // ── 配置键（影子键风格：模块自己存一份，不覆盖宿主原键）──
    //   ★ 键名与模块 UI 的「美化 › 气泡 › AI / 用户」两页**逐字对齐**（Tree.kt）。
    //     为什么不沿用旧键 `fuckds_bubble_on`：`FdmBridge.dispatch()` 会把它转给
    //     3.73.x 的旧实现 `GmBubble.setOn`，值就落不到 MMKV ⇒ 这边永远读不到。
    //     新键不在 dispatch 表里 ⇒ 走 cfg_put 的裸写分支，直接进宿主 MMKV ✅
    //   用户气泡
    private static final String K_U_ON = "fuckds_ububble_bg_on";
    private static final String K_U_MODE = "fuckds_ububble_bg_mode";
    private static final String K_U_COLOR = "fuckds_ububble_bg_color";
    private static final String K_U_ALPHA = "fuckds_ububble_bg_alpha";
    //   助手/AI 气泡
    private static final String K_A_ON = "fuckds_abubble_bg_on";
    private static final String K_A_MODE = "fuckds_abubble_bg_mode";
    private static final String K_A_COLOR = "fuckds_abubble_bg_color";
    private static final String K_A_ALPHA = "fuckds_abubble_bg_alpha";
    //   图片铺法（0 等比裁切 / 1 拉伸 / 2 等比适应 / 3 平铺）
    private static final String K_U_FIT = "fuckds_ububble_img_fit";
    private static final String K_A_FIT = "fuckds_abubble_img_fit";

    /** 模式：0 = 纯色，1 = 图片。 */
    public static final int MODE_COLOR = 0;
    public static final int MODE_IMAGE = 1;

    // ── 图片铺法（主人：「做成开关多个单点，让用户选」）──
    /** 等比裁切铺满（不变形，会裁掉边角）—— 默认。 */
    public static final int FIT_CROP = 0;
    /** 拉伸铺满（会把图压扁/拉长）。 */
    public static final int FIT_STRETCH = 1;
    /** 等比适应（完整显示，可能留空边）。 */
    public static final int FIT_FIT = 2;
    /** 平铺（原尺寸重复）。 */
    public static final int FIT_TILE = 3;

    /** 图片文件名（沿用 v1/旧 UI 的约定：u 前缀 = 用户）。 */
    private static final String IMG_USER = "fuckds_ububble.png";
    private static final String IMG_ASSIST = "fuckds_bubble.png";

    // ── 运行时状态 ──
    /** t82.t 那个 Shape 的实例（用于 identity 比对）。 */
    private static volatile Object sClipShape;
    /** 圆角 Shape（助手气泡注入时当形状用）。 */
    private static volatile Object sRoundShape;
    /** 已确认是气泡底色的 yi0 元素 → 属于哪一类。
     *  <p>★ 2026-11-01：用 {@link java.util.IdentityHashMap}（按引用比），不用 WeakHashMap ——
     *  Compose 的 {@code Modifier.Element} 是 <b>data class（实现了 equals）</b>，
     *  两个不同元素只要字段相等就会被当成同一个 key ⇒ 标记互相覆盖（AI 的变成用户的）。
     *  代价是强引用，所以配了 {@link #MAP_MAX} 上限；元素本身数量有限（每条消息一个）。 */
    private static final Map<Object, Integer> sElem =
            Collections.synchronizedMap(new java.util.IdentityHashMap<Object, Integer>());
    /** 已确认是气泡底色的 zi0 绘制节点 → 属于哪一类（同样按引用比）。 */
    private static final Map<Object, Integer> sNode =
            Collections.synchronizedMap(new java.util.IdentityHashMap<Object, Integer>());
    /** 两张表的上限（防内存泄漏）。 */
    private static final int MAP_MAX = 4000;
    /** 「刚 clip 完气泡形状，下一个 yi0 就是它」——同线程传递（用户气泡）。 */
    private static final ThreadLocal<Boolean> sPending = new ThreadLocal<Boolean>();
    /** 「刚注入了助手气泡的 background，下一个 yi0 就是它」——同线程传递。 */
    private static final ThreadLocal<Boolean> sAssistPending = new ThreadLocal<Boolean>();
    /** 强引用 hook，防被 GC（踩过）。 */
    private static volatile XC_MethodHook sHookClip, sHookCtor, sHookB, sHookD, sHookDraw, sHookAssist;

    private static volatile boolean sLogged = false;
    private static volatile int sTagged = 0;
    private static volatile int sPainted = 0;
    private static volatile int sEnter = 0;
    private static volatile int sFail = 0;
    private static volatile int sStamped = 0;

    /** 助手注入自检是否通过（没通过就完全不碰 e40）。 */
    private static volatile boolean sAssistReady = false;
    /** 助手 composable 被调用次数（防重组死循环的观察窗）。 */
    private static volatile int sAssistCalls = 0;
    /** 注入次数上限保护：超过它就不再注入（宁可没背景，也不能把宿主拖死）。 */
    private static final int ASSIST_INJECT_MAX = 4000;

    // 日志
    private static final java.util.Set<String> sSeen = new java.util.HashSet<String>();
    private static final int MAX_LINES = 90;

    // ═══════════════════════════ 安装 ═══════════════════════════

    public static void install(ClassLoader cl) {
        try {
            doInstall(cl);
        } catch (Throwable t) {
            log("install 失败: " + t);
        }
    }

    private static void doInstall(ClassLoader cl) {
        log("=== 气泡背景 v2 开始安装（用户 + 助手 · 色/图）===");

        // ① 先拿到气泡专用 Shape 的实例（用户气泡靠 identity 认人）
        try {
            Class<?> sh = XposedHelpers.findClass(CLS_SHAPEHOLDER(), cl);
            sClipShape = XposedHelpers.getStaticObjectField(sh, FLD_BUBBLE_SHAPE);
            log("① 气泡裁剪 Shape = " + (sClipShape == null ? "null" : sClipShape.getClass().getName()));
        } catch (Throwable t) {
            log("① 拿 Shape 失败（用户气泡会认不出）: " + t);
        }

        // ①b 形状选择（助手注入时当形状用）
        //   ★ 2026-11-01 主人实测两轮定下来的：
        //     · `vcc.n`（圆角 Shape，自带内缩）⇒ 背景正好从**头像右边**开始、右侧留出自然边距，
        //       宽度符合主人预期（「真正的范围应该是……带黑色区域」）。
        //     · `t82.t`（气泡裁剪 Shape）⇒ 更窄 ⇒ 主人：「太窄了」。
        //   ⇒ 所以这里**优先 vcc.n**，拿不到才退用 t82.t。
        //   ★★ 2026-11-06（3.75.21）修正：**不要再去读 `vcc.n` 这个字段**
        //     血证：3.75.20 日志 `✗ 助手注入异常: method da8.q argument 3 has type yy9,
        //            got java.lang.Object`
        //     原因：2.7.5 的 `dec.n` 是 **`new Object()` 空壳**（R8 把真实形状内联掉了），
        //           拿去当 Shape 传参会被 ART 的类型检查直接拒。
        //     2.7.2 的 `vcc.n` 实际是 `new kc5(2)`；2.7.5 对应 **`oc5`**
        //       （行号 10/12/16/20/63/104/695 全同、`<init>(I)V` synthetic、
        //         `toString()` 都返回 "RectangleShape"）。
        //   ⇒ 直接 `new oc5(2)`，和宿主自己造的一模一样。
        try {
            Class<?> cRound = XposedHelpers.findClass(GmRemap.cls("clipmod.round"), cl);
            sRoundShape = XposedHelpers.newInstance(cRound, 2);
            log("①b 助手气泡形状 = new " + cRound.getName() + "(2) → "
                    + sRoundShape.getClass().getName());
        } catch (Throwable t) {
            log("①b new 圆角 Shape 失败: " + t);
        }
        // 兜底：真拿不到就退回「气泡裁剪 Shape」（窄一点，但至少是合法 Shape）
        // ⚠️ 形状接口的类型**从 da8.q 的签名里现查**，不写死 "yy9"
        //    （写死就又是同一类坑：宿主一改版就静默失效）
        if (sRoundShape != null) {
            try {
                Class<?> cBg = XposedHelpers.findClass(CLS_BG_KT(), cl);
                Class<?> shapeIface = null;
                for (Method m : cBg.getDeclaredMethods()) {
                    if (!MTH_BG_COLOR().equals(m.getName())) continue;
                    Class<?>[] p = m.getParameterTypes();
                    if (p.length == 3 && p[0] == XposedHelpers.findClass(CLS_MODIFIER(), cl)
                            && p[1] == long.class) {
                        shapeIface = p[2];      // ★ 第 3 参就是 Shape 接口
                        break;
                    }
                }
                if (shapeIface != null && !shapeIface.isInstance(sRoundShape)) {
                    log("①b ⚠️ 形状不是 " + shapeIface.getName() + " 实例 ⇒ 丢弃");
                    sRoundShape = null;
                } else if (shapeIface != null) {
                    log("①b 形状类型校验通过（" + shapeIface.getName() + "）");
                }
            } catch (Throwable ignore) {
            }
        }
        if (sRoundShape == null && sClipShape != null) {
            sRoundShape = sClipShape;      // 兜底
            log("①b 退用气泡裁剪 Shape " + sClipShape.getClass().getName());
        }
        if (sRoundShape == null) {
            log("①b 两种形状都拿不到 ⇒ 助手气泡不会注入");
        }

        // ② clip(Modifier, Shape)：见到气泡形状就立「下一个 yi0 是用户气泡」的旗
        if (sClipShape != null) {
            try {
                Class<?> mod = XposedHelpers.findClass(CLS_MOD(), cl);
                for (Method m : mod.getDeclaredMethods()) {
                    if (!MTH_CLIP().equals(m.getName())) continue;
                    Class<?>[] p = m.getParameterTypes();
                    if (p.length != 2) continue;
                    if (!p[0].isInterface()) continue;
                    sHookClip = new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) {
                            try {
                                if (param.args != null && param.args.length == 2
                                        && param.args[1] == sClipShape) {
                                    sPending.set(Boolean.TRUE);
                                }
                            } catch (Throwable ignore) {
                            }
                        }
                    };
                    XposedBridge.hookMethod(m, sHookClip);
                    log("② 挂上 clip: " + m.getName() + "(" + p[0].getName() + "," + p[1].getName() + ")");
                    break;
                }
            } catch (Throwable t) {
                log("② 挂 clip 失败: " + t);
            }
        }

        // ③ yi0 构造：紧跟在 clip（或助手注入）之后 → 这个元素就是气泡底色
        try {
            Class<?> elem = XposedHelpers.findClass(CLS_ELEM(), cl);
            sHookCtor = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        // ★ 助手优先：这是我们自己刚注入出来的那个
                        if (sAssistPending.get() != null) {
                            sAssistPending.remove();
                            Object self = param.thisObject;
                            if (self == null) return;
                            sElem.put(self, KIND_ASSIST);
                            int n = ++sTagged;
                            if (n <= 8) {
                                log("③ 认到【AI气泡】元素 #" + n + " @"
                                        + Integer.toHexString(System.identityHashCode(self)));
                            }
                            return;
                        }
                        // 用户气泡：clip(t82.t) 之后那一个
                        if (sPending.get() == null) return;
                        sPending.remove();
                        Object self = param.thisObject;
                        if (self == null) return;
                        sElem.put(self, KIND_USER);
                        int n = ++sTagged;
                        if (n <= 8) {
                            log("③ 认到【用户气泡】元素 #" + n + " @"
                                    + Integer.toHexString(System.identityHashCode(self)));
                        }
                    } catch (Throwable ignore) {
                    }
                }
            };
            XposedBridge.hookAllConstructors(elem, sHookCtor);
            log("③ 挂上 " + CLS_ELEM() + " 构造");
        } catch (Throwable t) {
            log("③ 挂 yi0 构造失败: " + t);
        }

        // ④ yi0.b() → 造出 zi0；yi0.d(zi0) → 把配置推给已存在的 zi0
        //   ★★ 2026-11-01 主人实测：「换色成功了，但因为是懒加载很多需要长按消息刷新」
        //     ⇒ 真因：原来只在 **绘制那一刻** 改 o 再改回去，而 Compose 会把绘制结果缓存成
        //       图层 ⇒ 滚进屏幕时用的是**缓存里的旧颜色**，只有元素更新（长按触发重组）才会重建。
        //     ⇒ 改法：在 **节点生成 / 更新** 这两处直接把颜色**写死在节点上**，不再恢复。
        //       这样图层第一次被画出来时就已经是我们的颜色，跟懒加载无关。
        try {
            Class<?> elem = XposedHelpers.findClass(CLS_ELEM(), cl);
            sHookB = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        if (param.thisObject == null || param.getResult() == null) return;
                        Integer kind = sElem.get(param.thisObject);
                        if (kind == null) return;
                        Object node = param.getResult();
                        sNode.put(node, kind);
                        stamp(node, kind.intValue());        // ★ 建出来就带上颜色
                        if (sTagged <= 8) log("④ 节点已记号 kind=" + kind);
                    } catch (Throwable ignore) {
                    }
                }
            };
            // 只挂「0 参、返回 Modifier.Node 基类」的那个（= b()）。不许误挂 hashCode()。
            for (Method m : elem.getDeclaredMethods()) {
                if (m.getParameterTypes().length != 0) continue;
                if (!CLS_NODEBASE().equals(m.getReturnType().getName())) continue;
                XposedBridge.hookMethod(m, sHookB);
            }
            sHookD = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        if (param.thisObject == null) return;
                        Integer kind = sElem.get(param.thisObject);
                        if (kind == null) return;
                        if (param.args == null || param.args.length != 1 || param.args[0] == null) return;
                        Object node = param.args[0];
                        sNode.put(node, kind);
                        // ★ after：宿主刚把元素字段推给节点，我们随后覆盖 ⇒ 图层的下一次重建即是新色
                        stamp(node, kind.intValue());
                    } catch (Throwable ignore) {
                    }
                }
            };
            // 只挂「1 参、void、参数是 Modifier.Node 基类」的那个（= d(xj7)）。
            for (Method m : elem.getDeclaredMethods()) {
                if (m.getParameterTypes().length != 1 || m.getReturnType() != void.class) continue;
                if (!CLS_NODEBASE().equals(m.getParameterTypes()[0].getName())) continue;
                XposedBridge.hookMethod(m, sHookD);
            }
            log("④ 挂上 yi0 的 取节点/推配置");
        } catch (Throwable t) {
            log("④ 挂 yi0 派生失败: " + t);
        }

        // ⑤ zi0 的绘制方法：1 参 + void + 参数像 DrawScope
        try {
            Class<?> node = XposedHelpers.findClass(CLS_NODE(), cl);
            int n = 0;
            for (Method m : node.getDeclaredMethods()) {
                if (m.getReturnType() != void.class) continue;
                if (m.getParameterTypes().length != 1) continue;
                Class<?> p0 = m.getParameterTypes()[0];
                if (p0.isPrimitive() || p0.isArray()) continue;
                try {
                    m.setAccessible(true);
                } catch (Throwable ignore) {
                }
                XposedBridge.hookMethod(m, new DrawHook());
                n++;
                log("⑤ 挂上绘制候选: " + m.getName() + "(" + p0.getName() + ")");
            }
            log("⑤ 共 " + n + " 个");
        } catch (Throwable t) {
            log("⑤ 挂绘制失败: " + t);
        }

        // ⑥ ★ 新：助手消息注入背景（造出可用的绘制节点）
        installAssist(cl);

        log("=== 安装完成（助手注入=" + (sAssistReady ? "已启用" : "未启用") + "）===");
    }

    /**
     * 给助手消息注入一个「透明背景」⇒ 造出绘制节点。
     *
     * <p>结构校验（全过才启用）：
     * <ol>
     *   <li>{@code e40} 里有一个 void 方法，参数里<b>恰好一个</b> {@code yj7}（Modifier）</li>
     *   <li>{@code x98.t(Modifier, long, Shape)} 存在且静态</li>
     *   <li>圆角 Shape 拿得到</li>
     * </ol>
     */
    private static void installAssist(ClassLoader cl) {
        try {
            final Class<?> cMod = XposedHelpers.findClass(CLS_MODIFIER(), cl);
            if (!cMod.isInterface()) {
                log("⑥ Modifier 不是接口 ⇒ 不注入助手背景");
                return;
            }
            Class<?> cBg = XposedHelpers.findClass(CLS_BG_KT(), cl);
            Method mBg = null;
            for (Method m : cBg.getDeclaredMethods()) {
                if (!MTH_BG_COLOR().equals(m.getName())) continue;
                Class<?>[] p = m.getParameterTypes();
                if (p.length != 3) continue;
                if (p[0] != cMod) continue;
                if (p[1] != long.class) continue;
                if (p[2].isPrimitive()) continue;
                mBg = m;
                break;
            }
            if (mBg == null) {
                log("⑥ x98.t(Modifier,long,Shape) 没找到 ⇒ 不注入助手背景");
                return;
            }
            mBg.setAccessible(true);
            if (sRoundShape == null) {
                log("⑥ 没有圆角 Shape ⇒ 不注入助手背景");
                return;
            }
            final Method fBg = mBg;

            // ★ 先试「单条消息内容层」，结构不过才退回「整个 Cell」。
            sAssistReady = hookAssistCell(cl, cMod, fBg, CLS_ASSIST(), MTH_ASSIST);
            if (!sAssistReady) {
                sAssistReady = hookAssistCell(cl, cMod, fBg, CLS_ASSIST2(), MTH_ASSIST2);
            }
        } catch (Throwable t) {
            log("⑥ 助手背景注入安装失败: " + t);
            sAssistReady = false;
        }
    }

    /**
     * 在指定类的指定 composable 上挂「注入透明背景」的钩子。
     *
     * <p>结构判据：方法 void + 参数里<b>恰好一个</b> Modifier。
     *
     * @return 挂上了为 true
     */
    private static boolean hookAssistCell(ClassLoader cl, final Class<?> cMod,
                                          final Method fBg, String clsName, String mthName) {
        try {
            Class<?> cCell = XposedHelpers.findClass(clsName, cl);
            int hooked = 0;
            for (Method m : cCell.getDeclaredMethods()) {
                if (!mthName.equals(m.getName())) continue;
                if (m.getReturnType() != void.class) continue;
                Class<?>[] ps = m.getParameterTypes();
                int idx = -1, cnt = 0;
                for (int i = 0; i < ps.length; i++) {
                    if (ps[i] == cMod) {
                        idx = i;
                        cnt++;
                    }
                }
                if (cnt != 1) continue;
                final int modIdx = idx;
                final String tag = clsName + "." + m.getName();
                sHookAssist = new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) {
                        try {
                            int n = ++sAssistCalls;
                            if (n == 1 || n == 10 || n == 100 || n == 1000 || n == 5000) {
                                log("⑥ 助手组合调用 #" + n + "（" + tag + "）");
                            }
                            if (n > ASSIST_INJECT_MAX) return;
                            if (param.args == null || param.args.length <= modIdx) return;
                            Object orig = param.args[modIdx];
                            if (orig == null || !cMod.isInstance(orig)) return;
                            // ★ 先立旗：宿主紧接着会 new 出那个 yi0（中间不会有别的 yi0）
                            sAssistPending.set(Boolean.TRUE);
                            try {
                                // 完全透明的颜色 = 0（纯色模式由 DrawHook 改字段，图片模式我们自己画）
                                Object merged = fBg.invoke(null, orig, Long.valueOf(0L), sRoundShape);
                                if (merged != null) {
                                    param.args[modIdx] = merged;
                                } else {
                                    sAssistPending.remove();
                                }
                            } catch (Throwable t) {
                                sAssistPending.remove();
                                throw t;
                            }
                        } catch (Throwable t) {
                            int f = ++sFail;
                            if (f <= 3) log("✗ 助手注入异常 #" + f + ": " + t);
                        }
                    }
                };
                XposedBridge.hookMethod(m, sHookAssist);
                hooked++;
                log("⑥ 挂上助手 composable: " + tag + "(" + ps.length + " 参) Modifier@args["
                        + modIdx + "]");
            }
            if (hooked == 0) {
                log("⑥ " + clsName + "." + mthName + " 里没有「参数含唯一 Modifier」的 void 方法");
            }
            return hooked > 0;
        } catch (Throwable t) {
            log("⑥ 挂 " + clsName + "." + mthName + " 失败: " + t);
            return false;
        }
    }

    // ═══════════════════════════ 绘制期接管 ═══════════════════════════

    /** 取 DrawScope 背后的 android Canvas。取不到就 null。 */
    private static Object canvasOf(Object scope) {
        try {
            Object co1 = XposedHelpers.getObjectField(scope, "a");      // co1 = DrawContext
            if (co1 == null) return null;
            Object bo1 = XposedHelpers.getObjectField(co1, "a");        // bo1
            if (bo1 == null) return null;
            Object cv = XposedHelpers.getObjectField(bo1, "c");         // ao1 实现 = wc
            if (cv == null) return null;
            return XposedHelpers.getObjectField(cv, "a");               // ★ android.graphics.Canvas
        } catch (Throwable t) {
            return null;
        }
    }

    /** 取 DrawContext 里的打包 Size（高 32=宽，低 32=高，float 位）。 */
    private static long sizePackOf(Object scope) {
        try {
            Object co1 = XposedHelpers.getObjectField(scope, "a");
            Object bo1 = XposedHelpers.getObjectField(co1, "a");
            return XposedHelpers.getLongField(bo1, "d");
        } catch (Throwable t) {
            return 0L;
        }
    }

    /**
     * 绘制钩子 —— ★★ <b>这次不用自己画（纯色时）</b>。
     *
     * <h3>为什么改成「改字段」而不是「自己画」（2026-11-01 主人实测打脸）</h3>
     * 上一版（after 里 drawRect）两个毛病：
     * <ul>
     *   <li><b>文字全没了</b> —— 主人原话「只要有蓝色就是没文字」。after 画的覆盖在内容之上。</li>
     *   <li>用户气泡也中招（日志 `✅ 已画【用户气泡】区域=761x161` 那个蓝块就是没字的气泡）</li>
     * </ul>
     *
     * <h3>现在的分工</h3>
     * <ul>
     *   <li><b>纯色</b>：只把 {@code zi0.o} 换成我们的颜色（{@code (argb<<32)}，与宿主编码一致），
     *       <b>让宿主自己画</b>。⇒ 文字、圆角、裁剪、阴影，一个都不用管，天然正确。</li>
     *   <li><b>图片</b>：{@code o} 设成完全透明（0），然后在 <b>before</b> 里 drawBitmap
     *       —— before 在宿主内容<b>之前</b>，绝不会盖字。</li>
     * </ul>
     *
     * <p>两种模式都会在 after 里把 {@code o} 恢复，不留痕迹。
     *
     * <h3>⚠️ o 的编码（v1 用血换来的）</h3>
     * {@code Compose Color} = <b>{@code (argb << 32) | colorSpaceId}</b>。
     * v1 直接写 {@code 0xFF5B8DEF} 就崩了：{@code Invalid ID: 46}（宿主 {@code zi9.Y} 只放行 id ≤ 0xF）。
     */
    private static final class DrawHook extends XC_MethodHook {
        private long oldColor;
        private boolean touched;

        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            touched = false;
            try {
                if (param.thisObject == null) return;
                Integer kindObj = sNode.get(param.thisObject);
                if (kindObj == null) return;
                final int kind = kindObj.intValue();
                if (param.args == null || param.args.length != 1) return;
                Object scope = param.args[0];
                if (!looksLikeDrawScope(scope)) return;

                int ent = ++sEnter;
                boolean on = cfgOn(kind);
                int mode = cfgMode(kind);
                if (ent <= 4 || (on && sPainted < 3)) {
                    long sz0 = sizePackOf(scope);
                    note(kind, ent, on, mode, Float.intBitsToFloat((int) (sz0 >> 32)),
                            Float.intBitsToFloat((int) sz0), scope);
                }
                if (!on) return;

                Object self = param.thisObject;
                long old = XposedHelpers.getLongField(self, "o");

                if (mode == MODE_IMAGE) {
                    // 图片：宿主那层压成完全透明，我们的图画在它下面（before）
                    Bitmap bmp = imgOf(kind);
                    if (bmp == null) {
                        if (!sNoImgLogged) {
                            sNoImgLogged = true;
                            log("· 图片模式但没读到图（" + imgName(kind) + "）⇒ 本次跳过");
                        }
                        return;
                    }
                    Object canvasObj = canvasOf(scope);
                    if (canvasObj == null) {
                        if (!sNoCanvasLogged) {
                            sNoCanvasLogged = true;
                            log("✗ 拿不到 Canvas（链路变了），本次不画图");
                        }
                        return;
                    }
                    long sz = sizePackOf(scope);
                    float w = Float.intBitsToFloat((int) (sz >> 32));
                    float h = Float.intBitsToFloat((int) sz);
                    if (w <= 0f || h <= 0f) return;

                    oldColor = old;
                    XposedHelpers.setLongField(self, "o", 0L);
                    touched = true;

                    Canvas cv = (Canvas) canvasObj;
                    int save = cv.save();
                    try {
                        // ★★ 2026-11-01 主人实测：「图片模式怎么还带拉伸」
                        //   ⇒ 原来用 drawBitmap(bmp, null, dst) **硬铺满**（X/Y 各自缩放）
                        //     ⇒ 又高又窄的气泡就把图拉成了面条。
                        //   ⇒ 默认改 centerCrop，并把**填充方式做成可选项**（主人：「做成开关多个单点，让用户选」）。
                        Paint p = paint();
                        p.setAlpha(alphaOf(kind));
                        p.setShader(shaderFor(kind, bmp, w, h, imgFit(kind)));
                        cv.drawRect(0f, 0f, w, h, p);
                    } finally {
                        cv.restoreToCount(save);
                    }
                    int n = ++sPainted;
                    if (n <= 5) {
                        log("✅ 已画" + label(kind) + " #" + n + " 模式=图 区域="
                                + Math.round(w) + "x" + Math.round(h));
                    }
                    return;
                }

                // ── 纯色：字段已经在 stamp() 里写死了，这里只做兜底（不恢复，让它留住）──
                int argb = colorOf(kind);
                if (argb == 0) return;
                oldColor = old;
                XposedHelpers.setLongField(self, "o", composeColor(argb));
                touched = false;      // ★ 不恢复：懒加载时靠这个兜底也让颜色留下
                int n = ++sPainted;
                if (n <= 5) {
                    log("✅ 已换色" + label(kind) + " #" + n + " 0x" + Long.toHexString(argb)
                            + "（原 0x" + Long.toHexString(old) + "）");
                }
            } catch (Throwable t) {
                int f = ++sFail;
                if (f <= 3) log("✗ 绘制异常 #" + f + ": " + t);
            }
        }

        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            if (!touched) return;
            touched = false;
            try {
                XposedHelpers.setLongField(param.thisObject, "o", oldColor);
            } catch (Throwable ignore) {
            }
        }
    }

    private static String label(int kind) {
        return kind == KIND_ASSIST ? "【AI气泡】" : "【用户气泡】";
    }

    /**
     * 把颜色<b>写死在绘制节点上</b>（节点字段 {@code o}）。
     *
     * <p>为什么必须在「节点生成/更新」时写、而不是绘制时临时写：
     * Compose 会把绘制结果缓存成图层，滚进屏幕时直接用缓存 ⇒ 绘制期改的值进不去缓存。
     * 只有元素更新（重组）才会重建图层 —— 这就是主人说的
     * 「换色成功了，但因为是懒加载很多需要长按消息刷新」。
     *
     * <p>图片模式除外（那边要让宿主那层透明，见 {@link DrawHook}）。
     */
    private static void stamp(Object node, int kind) {
        try {
            if (node == null) return;
            if (!cfgOn(kind)) return;
            if (cfgMode(kind) == MODE_IMAGE) {
                XposedHelpers.setLongField(node, "o", 0L);   // 图片：宿主那层全透明
                return;
            }
            int argb = colorOf(kind);
            if (argb == 0) return;
            XposedHelpers.setLongField(node, "o", composeColor(argb));
            if (sStamped < 5) {
                sStamped++;
                log("🖌 颜色已写进节点" + label(kind) + " 0x" + Integer.toHexString(argb));
            }
        } catch (Throwable ignore) {
        }
    }

    /** 把 ARGB int 打成 Compose 的 Color long（高 32=ARGB，低 32=colorSpaceId=0）。 */
    private static long composeColor(int argb) {
        return ((long) argb & 0xFFFFFFFFL) << 32;
    }

    private static final RectF sDst = new RectF();
    private static volatile Paint sPaint;
    private static volatile boolean sNoCanvasLogged = false;
    private static volatile boolean sNoImgLogged = false;

    // ── centerCrop 用：shader + 尺寸缓存 ──
    private static volatile android.graphics.BitmapShader sShader;
    private static volatile Bitmap sShaderBmp;
    private static volatile float sShaderW, sShaderH;
    private static volatile int sShaderKind;
    private static volatile int sShaderFit;

    /**
     * 给「铺图」造一个 shader。四种方式由 {@link #imgFit(int)} 决定：
     *
     * <table border="1">
     *   <tr><th>值</th><th>含义</th><th>算法</th></tr>
     *   <tr><td>0</td><td>等比裁切（默认，不变形）</td><td>scale=max(w/bw,h/bh)，居中</td></tr>
     *   <tr><td>1</td><td>拉伸铺满（会变形）</td><td>scaleX=w/bw，scaleY=h/bh</td></tr>
     *   <tr><td>2</td><td>等比适应（可能留边）</td><td>scale=min(w/bw,h/bh)，居中</td></tr>
     *   <tr><td>3</td><td>平铺（原尺寸重复）</td><td>scale=1，REPEAT</td></tr>
     * </table>
     *
     * <p>尺寸/图/方式都没变就复用（绘制每帧都跑，不能每次都 new）。
     */
    private static android.graphics.BitmapShader shaderFor(int kind, Bitmap bmp,
                                                           float w, float h, int fit) {
        android.graphics.BitmapShader sh = sShader;
        if (sh != null && sShaderBmp == bmp && sShaderKind == kind && sShaderFit == fit
                && Math.abs(sShaderW - w) < 0.5f && Math.abs(sShaderH - h) < 0.5f) {
            return sh;
        }
        int bw = bmp.getWidth(), bh = bmp.getHeight();
        if (bw <= 0 || bh <= 0) return null;
        android.graphics.Matrix m = new android.graphics.Matrix();
        android.graphics.Shader.TileMode tx = android.graphics.Shader.TileMode.CLAMP;
        android.graphics.Shader.TileMode ty = android.graphics.Shader.TileMode.CLAMP;
        if (fit == FIT_TILE) {
            tx = android.graphics.Shader.TileMode.REPEAT;
            ty = android.graphics.Shader.TileMode.REPEAT;
        } else {
            float sx = w / bw, sy = h / bh;
            if (fit == FIT_STRETCH) {
                m.setScale(sx, sy);
            } else {
                float scale = (fit == FIT_FIT) ? Math.min(sx, sy) : Math.max(sx, sy);
                m.setScale(scale, scale);
                m.postTranslate((w - bw * scale) / 2f, (h - bh * scale) / 2f);
            }
        }
        sh = new android.graphics.BitmapShader(bmp, tx, ty);
        sh.setLocalMatrix(m);
        sShader = sh;
        sShaderBmp = bmp;
        sShaderW = w;
        sShaderH = h;
        sShaderKind = kind;
        sShaderFit = fit;
        return sh;
    }

    private static Paint paint() {
        Paint p = sPaint;
        if (p == null) {
            p = new Paint(Paint.ANTI_ALIAS_FLAG | Paint.FILTER_BITMAP_FLAG);
            p.setStyle(Paint.Style.FILL);
            sPaint = p;
        }
        return p;
    }

    /** 每次绘制都记一条（去重后最多 MAX_LINES 行）。 */
    private static void note(int kind, int ent, boolean on, int mode, float w, float h, Object scope) {
        try {
            String wh = Math.round(w) + "x" + Math.round(h);
            String key = kind + "|" + wh + "|" + on + "|" + mode + "|" + System.identityHashCode(scope);
            synchronized (sSeen) {
                if (sSeen.size() >= MAX_LINES || !sSeen.add(key)) return;
            }
            log((on ? "★" : "·") + (kind == KIND_ASSIST ? "AI" : "用户") + " 气泡绘制#" + ent
                    + " 开关=" + on + " 模式=" + mode + " 尺寸=" + wh);
        } catch (Throwable ignore) {
        }
    }

    /** 真·DrawScope 的指纹：0 参返回 long（打包 Size）+ 0 参返回 float（density）。 */
    private static boolean looksLikeDrawScope(Object o) {
        if (o == null) return false;
        boolean size = false, dens = false;
        try {
            for (Method m : o.getClass().getMethods()) {
                if (m.getParameterTypes().length != 0) continue;
                if (m.getReturnType() == long.class) size = true;
                else if (m.getReturnType() == float.class) dens = true;
                if (size && dens) return true;
            }
        } catch (Throwable ignore) {
        }
        return false;
    }

    // ═══════════════════════════ 配置 ═══════════════════════════

    private static String kOn(int kind) {
        return kind == KIND_ASSIST ? K_A_ON : K_U_ON;
    }

    private static String kMode(int kind) {
        return kind == KIND_ASSIST ? K_A_MODE : K_U_MODE;
    }

    private static String kColor(int kind) {
        return kind == KIND_ASSIST ? K_A_COLOR : K_U_COLOR;
    }

    private static String kAlpha(int kind) {
        return kind == KIND_ASSIST ? K_A_ALPHA : K_U_ALPHA;
    }

    /** 图片文件名（u 前缀 = 用户）。 */
    public static String imgName(int kind) {
        return kind == KIND_ASSIST ? IMG_ASSIST : IMG_USER;
    }

    private static boolean cfgOn(int kind) {
        try {
            Context c = GmUtil.app();
            if (c == null) return false;
            String v = GmStore.read2(c, kOn(kind), "b");
            if (v == null) return false;
            v = v.trim();
            return "true".equalsIgnoreCase(v) || "1".equals(v);
        } catch (Throwable t) {
            return false;
        }
    }

    private static int cfgMode(int kind) {
        try {
            Context c = GmUtil.app();
            if (c == null) return MODE_COLOR;
            String v = GmStore.read2(c, kMode(kind), "i");
            if (v == null || v.trim().length() == 0) return MODE_COLOR;
            int m = Integer.parseInt(v.trim());
            return m == MODE_IMAGE ? MODE_IMAGE : MODE_COLOR;
        } catch (Throwable t) {
            return MODE_COLOR;
        }
    }

    /** 图片铺法（0~3，见 FIT_*）。 */
    private static int imgFit(int kind) {
        try {
            Context c = GmUtil.app();
            if (c == null) return FIT_CROP;
            String v = GmStore.read2(c, kFit(kind), "i");
            if (v == null || v.trim().length() == 0) return FIT_CROP;
            int f = Integer.parseInt(v.trim());
            if (f < FIT_CROP || f > FIT_TILE) return FIT_CROP;
            return f;
        } catch (Throwable t) {
            return FIT_CROP;
        }
    }

    private static String kFit(int kind) {
        return kind == KIND_ASSIST ? K_A_FIT : K_U_FIT;
    }

    /** 返回带 alpha 的 ARGB；0 = 没配。 */
    private static int colorOf(int kind) {
        try {
            Context c = GmUtil.app();
            if (c == null) return 0;
            String sv = GmStore.read2(c, kColor(kind), "i");
            int argb = 0;
            if (sv != null && sv.trim().length() > 0) {
                try {
                    argb = (int) Long.parseLong(sv.trim());
                } catch (Throwable ignore) {
                    argb = 0;
                }
            }
            if ((argb & 0x00FFFFFF) == 0) return 0;
            return (argb & 0x00FFFFFF) | (alphaOf(kind) << 24);
        } catch (Throwable t) {
            return 0;
        }
    }

    /** 0~255 的 alpha。 */
    private static int alphaOf(int kind) {
        try {
            Context c = GmUtil.app();
            if (c == null) return 255;
            String sa = GmStore.read2(c, kAlpha(kind), "i");
            if (sa == null || sa.trim().length() == 0) return 255;
            int a = Integer.parseInt(sa.trim());
            if (a < 0) a = 0;
            if (a > 100) a = 100;
            return a * 255 / 100;
        } catch (Throwable t) {
            return 255;
        }
    }

    // ── 图片（按 mtime 缓存，选图后不用重启宿主）──

    private static volatile Bitmap sBmpU, sBmpA;
    private static volatile long sBmpUAt, sBmpAAt;
    private static volatile long sBmpUMt, sBmpAMt;

    /**
     * 气泡图文件的<b>查找顺序</b>：
     * <ol>
     *   <li>模块私有目录 {@code filesDir/<name>}（{@code img_path} 通道正规落点，首选）</li>
     *   <li>宿主<b>外部</b>目录 {@code getExternalFilesDir/<name>}（兜底：
     *       私有目录写不进去时还能用；也方便没有 root 的机器手工放图调试）</li>
     * </ol>
     * 两个位置都按 {@code lastModified} 认新鲜度 ⇒ 换图不用重启宿主。
     */
    private static File[] imgCandidates(Context ctx, int kind) {
        File a = new File(ctx.getFilesDir(), imgName(kind));
        File ext = null;
        try {
            File dir = ctx.getExternalFilesDir(null);
            if (dir != null) ext = new File(dir, imgName(kind));
        } catch (Throwable ignore) {
        }
        return ext == null ? new File[]{a} : new File[]{a, ext};
    }

    /** 首选落点（{@code FdmBridge} 往这里写；也作为 {@code imgFile} 的兼容入口）。 */
    public static File imgFile(Context ctx, int kind) {
        return new File(ctx.getFilesDir(), imgName(kind));
    }

    /** 真正拿来解码的那个文件（按「先私有、再外部」找一个存在且可读的）。 */
    public static File imgFileResolved(Context ctx, int kind) {
        for (File f : imgCandidates(ctx, kind)) {
            try {
                if (f != null && f.isFile() && f.length() > 0) return f;
            } catch (Throwable ignore) {
            }
        }
        return imgFile(ctx, kind);
    }

    private static Bitmap imgOf(int kind) {
        try {
            Context c = GmUtil.app();
            if (c == null) return null;
            File f = imgFileResolved(c, kind);
            if (f == null || !f.exists()) return null;
            long mt = f.lastModified();
            long now = System.currentTimeMillis();
            if (kind == KIND_ASSIST) {
                if (sBmpA != null && sBmpAMt == mt) return sBmpA;
                if (sBmpA != null && now - sBmpAAt < 2000L) return sBmpA;   // 2 秒内不重复解码
                Bitmap b = BitmapFactory.decodeFile(f.getAbsolutePath());
                if (b != null) {
                    sBmpA = b;
                    sBmpAMt = mt;
                    sBmpAAt = now;
                    log("🖼 AI 气泡图已加载 " + b.getWidth() + "x" + b.getHeight()
                            + "（" + f.length() + " 字节 · " + f.getAbsolutePath() + "）");
                }
                return sBmpA;
            }
            if (sBmpU != null && sBmpUMt == mt) return sBmpU;
            if (sBmpU != null && now - sBmpUAt < 2000L) return sBmpU;
            Bitmap b = BitmapFactory.decodeFile(f.getAbsolutePath());
            if (b != null) {
                sBmpU = b;
                sBmpUMt = mt;
                sBmpUAt = now;
                log("🖼 用户气泡图已加载 " + b.getWidth() + "x" + b.getHeight()
                        + "（" + f.length() + " 字节 · " + f.getAbsolutePath() + "）");
            }
            return sBmpU;
        } catch (Throwable t) {
            return null;
        }
    }

    /** 选完图后清缓存（FdmBridge 会调）。 */
    public static void clearImg(int kind) {
        if (kind == KIND_ASSIST) {
            sBmpA = null;
            sBmpAMt = 0;
        } else {
            sBmpU = null;
            sBmpUMt = 0;
        }
    }

    /** 状态串（给 FdmBridge 的 cfg_state 回读用）。 */
    public static String status() {
        return "用户气泡=" + (cfgOn(KIND_USER) ? "开" : "关")
                + "/" + (cfgMode(KIND_USER) == MODE_IMAGE ? "图" : "色")
                + " · AI气泡=" + (cfgOn(KIND_ASSIST) ? "开" : "关")
                + "/" + (cfgMode(KIND_ASSIST) == MODE_IMAGE ? "图" : "色")
                + " · 助手注入=" + (sAssistReady ? "已启用" : "未启用")
                + " · 已画 " + sPainted + " 次";
    }

    // ═══════════════════════════ 日志（写到 adb 能读的地方）═══════════════════════════

    private static volatile File sLogFile;
    private static volatile boolean sLogInit = false;

    private static void log(String s) {
        // ★ 先走模块老通道（→ XposedBridge.log → logcat tag=FDM）。
        //   安装期 Application 还没建好，getExternalFilesDir 拿不到 Context，
        //   所以这里**绝不能**因为 Context 为 null 就 return —— 那会把安装期的日志全吞掉。
        try {
            GmUtil.log(s);
        } catch (Throwable ignore) {
        }
        // 再尽力写一份到宿主外部目录（adb 可读，方便事后翻）
        try {
            Context c = GmUtil.app();
            if (c == null) return;
            File f = sLogFile;
            if (f == null) {
                if (sLogInit) return;
                sLogInit = true;
                try {
                    File dir = c.getExternalFilesDir(null);
                    if (dir == null) return;
                    if (!dir.exists()) dir.mkdirs();
                    f = new File(dir, "fdm-bubble.log");
                    sLogFile = f;
                } catch (Throwable t) {
                    return;
                }
            }
            FileWriter w = new FileWriter(f, true);
            try {
                w.write(s);
                w.write('\n');
            } finally {
                w.close();
            }
        } catch (Throwable ignore) {
        }
    }
}
