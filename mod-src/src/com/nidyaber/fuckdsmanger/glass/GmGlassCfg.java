package com.nidyaber.fuckdsmanger.glass;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmStore;

/**
 * 液态玻璃 · 配置 🐲
 *
 * <p>存储位置和别的美化功能<b>完全一样</b>：宿主的 MMKV（经模块自己的访问器
 * {@code GmStore}）。UI 那边走广播 {@code CONFIG_PUSH / cfg_put} 推过来，
 * 宿主这边直接 {@code read2} 读 —— 两边看的是同一份值，不需要再同步。
 *
 * <p>键名一律 {@code fuckds_glass_*}（影子键风格，见 {@code 专题/配置键总表.md}）。
 * 铁律：<b>不依赖宿主包名</b>，这里也没有。
 */
public final class GmGlassCfg {

    private GmGlassCfg() {
    }

    /** 总开关。 */
    public static final String K_ON = "fuckds_glass_on";
    /** 玻璃浓度（0–100，越大越不透明）。 */
    public static final String K_TINT = "fuckds_glass_tint";
    /** 圆角（dp）。 */
    public static final String K_RADIUS = "fuckds_glass_radius";
    /** 模糊度（0–40，StackBlur 半径）。 */
    public static final String K_BLUR = "fuckds_glass_blur";
    /** 水滴高光开关。 */
    public static final String K_DROP = "fuckds_glass_drop";
    /** 作用范围（0 = 所有可点元素 / 1 = 仅标准按钮）。 */
    public static final String K_SCOPE = "fuckds_glass_scope";
    /**
     * 玻璃**颜色**（ARGB int）—— 2026-09-30 主人要的：
     * 「只保留液态玻璃和可自定义玻璃颜色本身」。
     * 之前写死白/黑（还按深色主题切换），现在交给主人自己选。
     */
    public static final String K_COLOR = "fuckds_glass_color";
    /**
     * 色散（chromatic aberration）×10 —— 边缘按 R/B 通道分离采样，**"液态玻璃"最像的那一下**。
     * 0 = 关；10 = 1.0px；30 = 3.0px。（照 Haze 的 {@code chromaticAberrationStrength} 来的）
     */
    public static final String K_DISP = "fuckds_glass_disp";
    /**
     * **方案**（0 = Haze 式 / 1 = Cloudy 式 / 2 = Nadeem 轻量式）——
     * 主人 2026-09-30 拍板「再疯一点：多方案切换」，让用户切着试。
     */
    public static final String K_ENGINE = "fuckds_glass_engine";
    /**
     * **擦掉内容**（只让"背景色"参与折射）——
     * 主人 2026-09-30：「还是会抓到别的文字……加个开关，打开只把特定颜色做折射背景」。
     * 底图是整屏截图，**连文字一起截进来了** ⇒ 玻璃里糊出字，和上层清晰的字叠影。
     * 打开后：从元素边缘自动估背景色，把离它太远的像素（文字/图标）替换成背景色。
     */
    public static final String K_CLEAN = "fuckds_glass_clean";
    /** 擦除容差 ×0.01（0~60）——越大擦得越狠（可能连浅色图标一起擦）。 */
    public static final String K_CLEAN_TOL = "fuckds_glass_clean_tol";
    /**
     * **底图来源**（0 = 底色 / 1 = 屏幕截图）——
     * 主人 2026-09-30 拍板走「底色做玻璃」（详见 {@code 专题/液态玻璃-底图方案研究.md}）：
     * 不截图 ⇒ 后台可用、无延迟、无文字叠影、无正反馈、也没有 PixelCopy 那个爆栈风险。
     * 屏幕截图保留成"高保真模式"，想要"透出背后内容"时可以切过去。
     */
    public static final String K_SRC = "fuckds_glass_src";
    /**
     * **实现方式**（0 = 自动 / 1 = 强制 GPU / 2 = 强制 CPU）——
     * 主人 2026-10-01：「顺便实现方式加一个 cpu 模拟做备用」。
     *
     * <p>为什么要有 CPU 备胎：
     * <ul>
     *   <li>GPU 链走的是 `RenderNode + RenderEffect`，**只在硬件画布上成立**；
     *       某些场景（自拍、软件层、将来的低端机）会静默退化成"没玻璃"；</li>
     *   <li>出问题时能<b>一键切 CPU</b>，立刻能分清"是 GPU 的问题还是效果本身的问题"；</li>
     *   <li>CPU 版是**纯 Canvas 绘制**（BitmapShader + Paint 的 shader），
     *       连 API 33 的 `RuntimeShader` 都能用，兼容面更宽。</li>
     * </ul>
     */
    public static final String K_IMPL = "fuckds_glass_impl";
    /**
     * **贴合元素形状**（2026-10-02 主人「都要」的 A 档）——
     * 玻璃按元素的<b>真实形状</b>绘制（圆角/胶囊/异形都贴合），而不是统一拿圆角矩形硬套。
     *
     * <p>形状从画底原语的<b>第 3 个参数</b>接力：Shape → 元素 → Node → 绘制期
     * ⇒ {@code createOutline(尺寸,…) → Outline → Path} ⇒ 按 Path 裁切/绘制。
     */
    public static final String K_FIT = "fuckds_glass_fit";
    /**
     * **玻璃形态**（2026-10-02 主人「都要」的 B/C 档）——
     * <ul>
     *   <li>{@link #FORM_FULL}（0）正常：满铺玻璃；</li>
     *   <li>{@link #FORM_HOLLOW}（1）镂空：填充全透（只留元素自己的边框/内容）；</li>
     *   <li>{@link #FORM_EDGE}（2）仅边缘：只在边缘一圈做折射/高光、中间透明。</li>
     * </ul>
     */
    public static final String K_FORM = "fuckds_glass_form";
    /** 「仅边缘」的边缘带宽（dp）。 */
    public static final String K_EDGE = "fuckds_glass_edge";

    // ─────────── 默认值（与 fdm-app/src/Conf.kt 一一对应，改一边记得改另一边）───────────
    public static final boolean D_ON = false;
    public static final int D_TINT = 45;
    public static final int D_RADIUS = 22;
    public static final int D_BLUR = 14;
    public static final boolean D_DROP = true;
    /**
     * 作用范围 0：**所有画了底的东西**（= 所有可点元素），只排除「整页背景」。
     *
     * <p>3.29.0 只认 AppButton / AppIconButton / AppTextButton 三个类，
     * 主人纠正：「深度思考这种可点击有事件的也是按钮」⇒ 默认改成<b>不按类筛</b>，
     * 按「有没有画底 + 是不是整页」筛。
     */
    public static final int D_SCOPE = 1;
    /** 默认玻璃色：白。浓度（tint）当它的 alpha 用。 */
    public static final int D_COLOR = 0xFFFFFFFF;
    /** 默认色散 ×10 = 12（1.2px）—— 轻微泛彩，太强会糊边。 */
    public static final int D_DISP = 12;
    /**
     * 只给标准按钮上玻璃（AppButton / AppIconButton / AppTextButton + Toggle）。
     *
     * <p>⚠️ 3.29.x 试过「全部」，<b>把宿主界面画糊了</b>：作用域计数只在组合期有效，
     * 而 draw 在绘制期 ⇒ 当时没有可靠判据，只能硬上 ⇒ 图标/文字底/装饰全被换成玻璃。
     * 3.30.0 有了「元素→Node 记号接力」才谈得上精确，所以默认先回到<b>仅按钮</b>。
     */
    public static final int SCOPE_ALL = 0;
    public static final int SCOPE_BUTTONS_ONLY = 1;

    /** 生效中的配置快照。整块换，避免读到半新半旧。 */
    public static final class S {
        public final boolean on;
        public final int tint;
        public final int radiusDp;
        public final int blur;
        public final boolean drop;
        public final int scope;
        /** 玻璃颜色（ARGB）。浓度当它的 alpha。 */
        public final int color;
        /** 色散 ×10。 */
        public final int disp;
        /** 方案 0/1/2。 */
        public final int engine;
        /** 擦掉内容（只留背景色参与折射）。 */
        public final boolean clean;
        /** 擦除容差 ×0.01。 */
        public final int cleanTol;
        /** 底图来源 0=底色 / 1=屏幕截图。 */
        public final int src;
        /** 实现方式 0=自动 / 1=强制GPU / 2=强制CPU。 */
        public final int impl;
        /** 贴合元素真实形状（A 档）。 */
        public final boolean fit;
        /** 形态：0 正常 / 1 镂空 / 2 仅边缘（B/C 档）。 */
        public final int form;
        /** 「仅边缘」带宽（dp）。 */
        public final int edge;

        S(boolean on, int tint, int radiusDp, int blur, boolean drop, int scope, int color,
          int disp, int engine, boolean clean, int cleanTol, int src, int impl,
          boolean fit, int form, int edge) {
            this.fit = fit;
            this.form = form;
            this.edge = edge;
            this.impl = impl;
            this.src = src;
            this.clean = clean;
            this.cleanTol = cleanTol;
            this.engine = engine;
            this.disp = disp;
            this.on = on;
            this.tint = tint;
            this.radiusDp = radiusDp;
            this.blur = blur;
            this.drop = drop;
            this.scope = scope;
            this.color = color;
        }

        @Override
        public String toString() {
            return "glass{on=" + on + " tint=" + tint + " r=" + radiusDp
                    + " blur=" + blur + " drop=" + drop
                    + " color=#" + Integer.toHexString(color)
                    + " disp=" + disp + " engine=" + engine
                    + " clean=" + clean + "/" + cleanTol
                    + " src=" + (src == 0 ? "底色" : (src == 1 ? "截图" : "背景图"))
                    + " impl=" + (impl == 0 ? "自动" : (impl == 1 ? "GPU" : "CPU"))
                    + " scope=" + (scope == SCOPE_ALL ? "全部" : "仅按钮")
                    + " fit=" + fit
                    + " form=" + (form == FORM_HOLLOW ? "镂空" : (form == FORM_EDGE ? "仅边缘" : "正常"))
                    + "/" + edge + "}";
        }
    }

    /** 默认方案 0 = Haze 式。 */
    public static final int D_ENGINE = 0;

    /** 默认：擦内容**关**（先让用户看到原样，觉得有叠影再打开）。 */
    public static final boolean D_CLEAN = false;
    /** 默认容差 ×0.01 = 12（0.12）。 */
    public static final int D_CLEAN_TOL = 12;

    /** 默认底图来源 = 0（**底色**）。 */
    public static final int D_SRC = 0;

    /** 默认实现方式 = 0（自动）。 */
    public static final int D_IMPL = 0;

    /** 默认贴合元素形状 = 开（本身就是纯改进）。 */
    public static final boolean D_FIT = true;
    /** 默认形态 = 正常（满铺）。 */
    public static final int D_FORM = 0;
    /** 默认边缘宽度 = 20dp（要盖得住折射带 pad）。 */
    public static final int D_EDGE = 20;
    /** 形态：正常（满铺玻璃）。 */
    public static final int FORM_FULL = 0;
    /** 形态：镂空（填充全透，只留元素自己的边框/内容）。 */
    public static final int FORM_HOLLOW = 1;
    /** 形态：仅边缘（边缘一圈折射/高光，中间透明）。 */
    public static final int FORM_EDGE = 2;

    /** 该不该走 GPU 管线（按实现方式 + 可用性判断）。 */
    public static boolean wantGpu() {
        int i = sCur.impl;
        if (i == 2) return false;                       // 强制 CPU
        if (i == 1) return GmGlassGpu.available();      // 强制 GPU（不可用则退回）
        return GmGlassGpu.available();                  // 自动
    }

    /** CPU 版是否需要我们自己先把底图糊掉（GPU 版是在绘制时糊的）。 */
    public static boolean needCpuBlur() {
        return !wantGpu();
    }

    private static volatile S sCur = new S(D_ON, D_TINT, D_RADIUS, D_BLUR, D_DROP, D_SCOPE,
            D_COLOR, D_DISP, D_ENGINE, D_CLEAN, D_CLEAN_TOL, D_SRC, D_IMPL, D_FIT, D_FORM, D_EDGE);

    public static S get() {
        return sCur;
    }

    public static boolean on() {
        return sCur.on;
    }

    /** 从宿主 MMKV 重新读一遍（配置变了 / 每次 apply 前调）。 */
    public static S reload(Context ctx) {
        boolean on = D_ON;
        int tint = D_TINT, radius = D_RADIUS, blur = D_BLUR;
        boolean drop = D_DROP;
        int scope = D_SCOPE;
        int color = D_COLOR;
        int disp = D_DISP;
        int engine = D_ENGINE;
        boolean clean = D_CLEAN;
        int cleanTol = D_CLEAN_TOL;
        int src = D_SRC;
        int impl = D_IMPL;
        boolean fit = D_FIT;
        int form = D_FORM, edge = D_EDGE;
        try {
            on = bool(ctx, K_ON, D_ON);
            tint = clamp(intOf(ctx, K_TINT, D_TINT), 0, 100);
            radius = clamp(intOf(ctx, K_RADIUS, D_RADIUS), 0, 64);
            blur = clamp(intOf(ctx, K_BLUR, D_BLUR), 0, 40);
            drop = bool(ctx, K_DROP, D_DROP);
            scope = clamp(intOf(ctx, K_SCOPE, D_SCOPE), 0, 1);
            color = (int) longOf(ctx, K_COLOR, D_COLOR & 0xFFFFFFFFL);
            disp = clamp(intOf(ctx, K_DISP, D_DISP), 0, 60);
            engine = clamp(intOf(ctx, K_ENGINE, D_ENGINE), 0, 2);
            clean = bool(ctx, K_CLEAN, D_CLEAN);
            cleanTol = clamp(intOf(ctx, K_CLEAN_TOL, D_CLEAN_TOL), 0, 60);
            src = clamp(intOf(ctx, K_SRC, D_SRC), 0, 2);
            impl = clamp(intOf(ctx, K_IMPL, D_IMPL), 0, 2);
            fit = bool(ctx, K_FIT, D_FIT);
            form = clamp(intOf(ctx, K_FORM, D_FORM), 0, 2);
            edge = clamp(intOf(ctx, K_EDGE, D_EDGE), 0, 60);
        } catch (Throwable ignore) {
            // 读不到就用默认 —— 绝不能因为配置问题把宿主的绘制卡住
        }
        sCur = new S(on, tint, radius, blur, drop, scope, color, disp, engine, clean, cleanTol,
                src, impl, fit, form, edge);
        return sCur;
    }

    /** 颜色是 unsigned int，用 long 读再截断（避免负数被 read2 的 int 读法搞坏）。 */
    private static long longOf(Context ctx, String key, long def) {
        String v = GmStore.read2(ctx, key, "i");
        if (v == null) return def;
        v = v.trim();
        if (v.isEmpty()) return def;
        try {
            return Long.parseLong(v);
        } catch (Throwable ignore) {
            return def;
        }
    }

    // ───────────────────────── 工具 ─────────────────────────

    private static int clamp(int v, int lo, int hi) {
        return v < lo ? lo : (v > hi ? hi : v);
    }

    /**
     * 读 boolean。
     *
     * <p>⚠️⚠️ <b>3.29.3 的坑（血的教训）</b>：{@code GmStore.read2(ctx, key, 第三参)} 的
     * <b>第三参是「类型」不是「默认值」</b>！反编译真身（{@code GmStore.smali}）：
     * <pre>
     *   read2(ctx, key, type):
     *       键不存在 → 返回 ""
     *       "b" → String.valueOf(getBoolean(key,false))
     *       "i" → String.valueOf(getInt(key,0))
     *       ...
     * </pre>
     * 3.29.1 我按「默认值」传了 {@code "1"} / {@code "0"} ⇒ 类型既不是 b/i/l/f/s
     * ⇒ 一律走不到任何分支 ⇒ 永远读到空 ⇒ 永远用默认值
     * ⇒ <b>开关拨了等于没拨</b>（真机日志铁证：UI 推 {@code fuckds_glass_on:true}，
     * 宿主侧仍然打出 {@code on=false}）。
     */
    private static boolean bool(Context ctx, String key, boolean def) {
        String v = GmStore.read2(ctx, key, "b");
        if (v == null) return def;
        v = v.trim();
        if (v.isEmpty()) return def;                 // "" = 键不存在
        if ("true".equalsIgnoreCase(v) || "1".equals(v)) return true;
        if ("false".equalsIgnoreCase(v) || "0".equals(v)) return false;
        return def;
    }

    private static int intOf(Context ctx, String key, int def) {
        String v = GmStore.read2(ctx, key, "i");
        if (v == null) return def;
        v = v.trim();
        if (v.isEmpty()) return def;
        try {
            return Integer.parseInt(v);
        } catch (Throwable ignore) {
            return def;
        }
    }
}
