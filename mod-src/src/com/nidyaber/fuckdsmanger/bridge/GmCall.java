package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

/**
 * 「通话功能」开关（宿主 2.6.1）🐲 尼得亚伯 2026-10-02
 *
 * <h3>原理（实测，见 专题/宿主语音通话-域测绘与hook影响.md 三·六）</h3>
 * <pre>
 *   宿主通话入口的判据 = ChatPageTopBar.kt:105
 *        callFeature = config.call_feature
 *        callFeature == null  ⇒ 不画「打电话」图标
 *        callFeature != null  ⇒ 画
 *
 *   而 call_feature 藏在 model_configs 里（与 tts_feature / file_feature 同级），
 *   类型是 ModelConfig$CallFeature —— 一个 **零字段的空标记对象**
 *   ⇒ 存在即开启、不下发即 null
 * </pre>
 *
 * ⇒ 我们只需要往 {@code kv_remote_settings_model_configs_v1} 的每个 model 里
 *   补一个 {@code "call_feature":{}}。这就是 {@code GmTts}（补 tts_feature）的同构版本，
 *   基建（GmStore.bak/write/restore）全部复用。
 *
 * <h3>安全边界（宿主进程里的铁律）</h3>
 * <ul>
 *   <li>只在开关打开时动；关掉时**先确认备份存在**再从备份还原（restore 没备份会删键！）</li>
 *   <li>改动前必先 {@code bak}，原值留底</li>
 *   <li>**幂等**：已含 call_feature 直接返回原串，绝不叠加</li>
 *   <li>全程 try/catch，**绝不外抛**</li>
 * </ul>
 */
public final class GmCall {

    /** 宿主存 model_configs 的键（= GmTts 用的同一个键）。 */
    public static final String KEY_MODEL = "kv_remote_settings_model_configs_v1";

    /** 我们自己的开关键。 */
    public static final String KEY_ON = "fuckds_call_on";

    /** 备份键（bak 自动生成的命名）。 */
    private static final String BAK_MODEL = "fuckds_bak_" + KEY_MODEL;

    private GmCall() {}

    /**
     * 幂等补 {@code call_feature}。
     *
     * <p>锚点用 {@code "model_type":"} —— 它是每个 model 的**第一个字段**：
     * 稳定、唯一，且**不与 GmTts 的锚点**（{@code "search_feature":{}} / {@code "think_feature":{}}）撞车。
     * JSON 字段顺序对 kotlinx 反序列化无影响，所以插在 model 开头是安全的。
     *
     * @return 改好的串；无变化时返回**原串**（便于调用方比对）
     */
    public static String fix(String json) {
        if (json == null) return null;
        if (json.contains("call_feature")) return json;              // ★ 幂等
        return json.replace("\"model_type\":\"", "\"call_feature\":{},\"model_type\":\"");
    }

    /**
     * 这个串像不像能用的 JSON（**不依赖底座的 {@code GmPrompt.ok}** —— 它是包内可见，
     * 桥在另一个包，直接调会 IllegalAccessError）。
     */
    private static boolean looksJson(String s) {
        if (s == null) return false;
        String t = s.trim();
        return t.length() > 2 && (t.charAt(0) == '[' || t.charAt(0) == '{');
    }

    /** 开关状态（默认关）。 */
    public static boolean on(Context ctx) {
        try {
            return "1".equals(GmStore.read2(ctx, KEY_ON, "s"));
        } catch (Throwable t) {
            return false;
        }
    }

    /**
     * 常驻入口：开关开着就把 model_configs 补上。
     *
     * <p>由 {@link FdmBridge#onHostReady(Context)} 在**宿主每次冷启动**时调一次
     * ⇒ 哪怕被服务端下发覆盖，重启宿主就自动补回。
     */
    public static void ensure(Context ctx) {
        try {
            if (ctx == null || !on(ctx)) return;
            String v = GmStore.read2(ctx, KEY_MODEL, "s");
            if (!looksJson(v)) return;
            String n = fix(v);
            if (n == null || n.equals(v)) return;                    // 没变化 ⇒ 不动手
            GmStore.bak(ctx, KEY_MODEL, "s");                        // ★ 先留底
            GmStore.write(ctx, KEY_MODEL, n, "s");
            GmUtil.log("【通话】已补 call_feature（" + v.length() + " → " + n.length() + " 字）");
        } catch (Throwable t) {
            GmUtil.logFail("【通话】ensure 失败（不影响宿主）", t);
        }
    }

    /**
     * 开关：置位 + 立刻生效。
     *
     * <p>⚠️ 关的时候**必须先确认备份存在** —— {@code GmStore.restore} 在**没有备份**时
     * 会把原键 **remove 掉**（看它 smali：{@code if (bak 为空) remove(key)}），
     * 那就等于把宿主的 model_configs 删了 ⇒ 宿主拿不到模型配置。绝不冒这个险。
     */
    public static void setOn(Context ctx, boolean b) {
        try {
            if (ctx == null) return;
            GmStore.write(ctx, KEY_ON, b ? "1" : "0", "s");
            if (b) {
                ensure(ctx);
            } else if (GmStore.read2(ctx, BAK_MODEL, "s") != null) {
                GmStore.restore(ctx, KEY_MODEL, "s");
                GmUtil.log("【通话】已关闭，model_configs 已从备份还原");
            } else {
                GmUtil.log("【通话】已关闭（无备份 ⇒ 不动宿主存储）");
            }
        } catch (Throwable t) {
            GmUtil.logFail("【通话】setOn 失败", t);
        }
    }

    /**
     * 状态串（给 UI 显示）：{@code 开关|已生效}，例如 {@code "1|1"}。
     *
     * <ul>
     *   <li>前一位 = 我们的开关（{@link #KEY_ON}）</li>
     *   <li>后一位 = **宿主存储里的真值**（model_configs 现在到底有没有 call_feature）</li>
     * </ul>
     * 两位不一致就说明"开了但没生效"（比如 model_configs 还没被宿主写过）。
     */
    public static String state(Context ctx) {
        int on = 0;
        int feat = 0;
        try {
            if (on(ctx)) on = 1;
            String v = GmStore.read2(ctx, KEY_MODEL, "s");
            if (v != null && v.contains("call_feature")) feat = 1;
        } catch (Throwable t) {
            // 保持 0|0
        }
        return on + "|" + feat;
    }
}
