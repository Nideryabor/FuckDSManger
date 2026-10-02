package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;

/**
 * 「把配置推给宿主」这一件事 🐲（UI 进程侧）
 *
 * 配置有三个来源，按优先级叠加（后面的覆盖前面的）：
 *   ① `fdm_ui` SharedPreferences 里的 `fuckds_*` 键   ← **UI 开关写这里**（设置页也用这个）
 *   ② 外部文件 `<外部文件目录>/fdm-config.json`        ← 备用（不改 APK 也能塞配置）
 *   ③ 都没有 ⇒ 推空配置，宿主什么都不改
 *
 * 推过去的形式：{"rev":n,"bools":{…},"ints":{…},"longs":{…},"floats":{…},"strings":{…}}
 */
public final class FdmPush {

    public static final String ACTION_PUSH = "com.little_femaleboy.fdm.CONFIG_PUSH";
    public static final String ACTION_REQ = "com.little_femaleboy.fdm.CONFIG_REQ";
    public static final String ACTION_APPLIED = "com.little_femaleboy.fdm.CONFIG_APPLIED";
    /** 宿主进程 → UI 进程：宿主**实际存着**的配置（回读）。 */
    public static final String ACTION_STATE = "com.little_femaleboy.fdm.CONFIG_STATE";

    private static final String TAG = "FDM-DIAG";
    /** UI → 宿主：执行一个动作（走模块自己的入口，而不是裸写键）。 */
    public static final String ACTION_CMD = "com.little_femaleboy.fdm.CMD";
    /** 宿主 → UI：动作结果文本。 */
    public static final String ACTION_RESULT = "com.little_femaleboy.fdm.CMD_RESULT";
    private static final String SP = "fdm_ui";

    /** 让宿主执行一个动作。arg 可为 null / Boolean / Integer / String。 */
    public static void sendCmd(Context ctx, String cmd, Object arg) {
        try {
            Intent i = new Intent(ACTION_CMD);
            i.putExtra("cmd", cmd);
            if (arg instanceof Boolean) {
                i.putExtra("arg", (Boolean) arg);
            } else if (arg instanceof Integer) {
                i.putExtra("arg", (Integer) arg);
            } else {
                i.putExtra("arg", arg == null ? null : String.valueOf(arg));
            }
            i.putExtra("pkg", ctx.getPackageName());
            ctx.sendBroadcast(i);
            Log.e(TAG, "→ 动作 " + cmd + " arg=" + arg);
        } catch (Throwable t) {
            Log.e(TAG, "发动作失败", t);
        }
    }
    /** 宿主真值在 UI 这边的存储前缀（`host.` + 键）—— 界面上要显示"宿主真有什么"。 */
    public static final String HOST_PREFIX = "host.";

    private FdmPush() {
    }

    /** 把宿主回读来的状态存进 UI 的 SP（前缀 host.），供界面显示。 */
    public static int saveHostState(Context ctx, String json) {
        int n = 0;
        try {
            JSONObject j = new JSONObject(json);
            SharedPreferences.Editor ed = sp(ctx).edit();
            for (Iterator<String> it = j.keys(); it.hasNext(); ) {
                String k = it.next();
                ed.putString(HOST_PREFIX + k, String.valueOf(j.opt(k)));
                n++;
            }
            ed.putLong("host.at", System.currentTimeMillis()).apply();
            Log.e(TAG, "已记下宿主真值 " + n + " 个键");
        } catch (Throwable t) {
            Log.e(TAG, "解析宿主状态失败", t);
        }
        return n;
    }

    /** 读宿主真值（界面上显示用）。没有就返回 def。 */
    public static String hostValue(Context ctx, String key, String def) {
        return sp(ctx).getString(HOST_PREFIX + key, def);
    }

    /** 写一项配置并立刻推给宿主。 */
    public static void set(Context ctx, String key, Object value) {
        SharedPreferences.Editor ed = sp(ctx).edit();
        if (value instanceof Boolean) {
            ed.putBoolean(key, (Boolean) value);
        } else if (value instanceof Integer) {
            ed.putInt(key, (Integer) value);
        } else if (value instanceof Long) {
            ed.putLong(key, (Long) value);
        } else if (value instanceof Float) {
            ed.putFloat(key, (Float) value);
        } else {
            ed.putString(key, String.valueOf(value));
        }
        ed.apply();
        push(ctx);
    }

    public static SharedPreferences sp(Context ctx) {
        return ctx.getSharedPreferences(SP, Context.MODE_PRIVATE);
    }

    /** 打包当前配置并广播给宿主。返回推出去的项数。 */
    public static int push(Context ctx) {
        try {
            JSONObject bools = new JSONObject(), ints = new JSONObject(), longs = new JSONObject();
            JSONObject floats = new JSONObject(), strings = new JSONObject();

            SharedPreferences sp = sp(ctx);
            int n = 0;

            // ═══════════════════════════════════════════════════════════════════
            //  ★★ 2026-10-01 重大修复：UI 存了**两套格式**，我们只读了旧的那套 ★★
            //
            //  现象：主人开着的「用户气泡」在宿主侧永远是 false，颜色/图片全不生效。
            //        （宿主日志铁证：`fuckds_ububble_on=false → GmBubble.setUOn`）
            //
            //  真因：UI 的 SharedPreferences 里同一个键存了两份 ——
            //        · 【旧格式】顶层 `<boolean name="fuckds_ububble_on" value="false"/>` ← 残留
            //        · 【新格式】`<string name="cfg.fuckds_ububble_on">1</string>` + `.at` + `.ok`
            //        而下面那个循环**只认顶层 fuckds_***，于是永远读到旧格式的残留值。
            //
            //  修法：**新格式优先**（cfg.<key>），旧格式只用来"兜底"和推断类型。
            // ═══════════════════════════════════════════════════════════════════
            Map<String, Object> legacy = new HashMap<String, Object>();
            for (Map.Entry<String, ?> e : sp.getAll().entrySet()) {
                String k = e.getKey();
                if (k != null && k.startsWith("fuckds_")) legacy.put(k, e.getValue());
            }

            java.util.Set<String> taken = new HashSet<String>();
            for (Map.Entry<String, ?> e : sp.getAll().entrySet()) {
                String k = e.getKey();
                if (k == null || !k.startsWith("cfg.fuckds_")) continue;
                String key = k.substring(4);                 // 去掉 "cfg."
                if (key.endsWith(".at") || key.endsWith(".ok")) continue;
                Object v = e.getValue();
                if (!(v instanceof String)) continue;
                String s = (String) v;
                if (s.length() == 0) { taken.add(key); continue; }   // 空 = 没设过
                Object hint = legacy.get(key);               // 旧格式的原类型用来定类型
                n += putTyped(bools, ints, longs, floats, strings, key, s, hint);
                taken.add(key);
            }

            // 旧格式兜底：只补新格式**没有**的键（这样残留的 false 不会再盖住新值）
            for (Map.Entry<String, Object> e : legacy.entrySet()) {
                if (taken.contains(e.getKey())) continue;
                n += putAuto(bools, ints, longs, floats, strings, e.getKey(), e.getValue());
            }

            // ★★ 自愈：把「迁移遗留」的旧格式键清掉 ★★
            //
            //  主人 2026-10-01：「没想到迁移个 UI 会有这么多 bug」—— 一针见血。
            //  UI 从"顶层 fuckds_xxx"迁到"cfg.fuckds_xxx"之后，**旧键留在 SP 里发霉**，
            //  而任何还按旧格式读的代码都会拿到**残留值**（今晚的用户气泡就是这么废的）。
            //
            //  与其等下一个坑冒头，不如：**只要新格式有值，就把旧键删掉**。
            //  删掉之后，旧读取路径自然读到"没有" ⇒ 走默认值 ⇒ 也不会再盖住新值。
            //  这是幂等的：第二次跑就没有可删的了。
            try {
                SharedPreferences.Editor ed0 = null;
                int cleaned = 0;
                for (String k : taken) {
                    if (legacy.containsKey(k)) {
                        if (ed0 == null) ed0 = sp.edit();
                        ed0.remove(k);
                        cleaned++;
                    }
                }
                if (ed0 != null) {
                    ed0.apply();
                    Log.i(TAG, "🧹 清理迁移遗留的旧格式键 " + cleaned + " 个（新格式已有值）");
                }
            } catch (Throwable t) {
                Log.e(TAG, "清理旧格式键失败（不影响推送）", t);
            }

            File ext = ctx.getExternalFilesDir(null);
            File cfg = ext == null ? null : new File(ext, "fdm-config.json");
            if (cfg != null && cfg.isFile()) {
                String txt = readText(cfg);
                Log.e(TAG, "读到外部配置 " + cfg + "（" + (txt == null ? 0 : txt.length()) + " 字符）");
                if (txt != null && txt.trim().length() > 0) {
                    JSONObject j = new JSONObject(txt);
                    if (j.has("bools") || j.has("ints") || j.has("longs")
                            || j.has("floats") || j.has("strings")) {
                        n += copyInto(bools, j.optJSONObject("bools"));
                        n += copyInto(ints, j.optJSONObject("ints"));
                        n += copyInto(longs, j.optJSONObject("longs"));
                        n += copyInto(floats, j.optJSONObject("floats"));
                        n += copyInto(strings, j.optJSONObject("strings"));
                    } else {
                        for (Iterator<String> it = j.keys(); it.hasNext(); ) {
                            String k = it.next();
                            n += putAuto(bools, ints, longs, floats, strings, k, j.opt(k));
                        }
                    }
                }
            }

            JSONObject payload = new JSONObject();
            payload.put("rev", sp.getInt("rev", 1));
            payload.put("bools", bools);
            payload.put("ints", ints);
            payload.put("longs", longs);
            payload.put("floats", floats);
            payload.put("strings", strings);

            Intent it = new Intent(ACTION_PUSH);
            it.putExtra("rev", sp.getInt("rev", 1));
            it.putExtra("json", payload.toString());
            // ★ 桥的握手令牌（判据不看包名，看它 —— 见 ConfigProvider.callerAllowed）
            it.putExtra(ConfigProvider.KEY_TOKEN, ConfigProvider.ensureToken(ctx));
            ctx.sendBroadcast(it);
            Log.e(TAG, "已推送配置（" + n + " 项）：" + payload);
            return n;
        } catch (Throwable t) {
            Log.e(TAG, "推送配置失败", t);
            return -1;
        }
    }

    /** 按 Java 值类型丢进对应的 JSON 分组。
     *
     * ★ 只认 `fuckds_` 前缀 —— 我们自己的记账键（`rev` / `applied_rev` / `applied_at`）
     *   绝不能推给宿主（实测漏过一次：宿主存储里多出 `applied_rev`、`applied_at` 这种垃圾键）。
     */
    /**
     * 按【字符串值 + 旧格式的类型提示】放进对应的 JSON 组。
     *
     * <p>UI 的 `cfg.<key>` 一律存成字符串（"true" / "-27787" / "你好"），
     * 所以类型得靠两件事推：① 旧格式那份的 Java 类型；② 字符串本身的样子。
     * 类型错了宿主会**静默读回默认值**（底座桩里写明的铁律）—— 所以这一步必须准。
     */
    private static int putTyped(JSONObject bools, JSONObject ints, JSONObject longs,
                                JSONObject floats, JSONObject strings,
                                String k, String s, Object hint) throws Exception {
        String t = s.trim();
        try {
            if (hint instanceof Boolean) {
                bools.put(k, Boolean.parseBoolean(t) || "1".equals(t)); return 1;
            }
            if (hint instanceof Long)    { longs.put(k, Long.parseLong(t)); return 1; }
            if (hint instanceof Float || hint instanceof Double) {
                floats.put(k, Float.parseFloat(t)); return 1;
            }
            if (hint instanceof Integer) { ints.put(k, Integer.parseInt(t)); return 1; }

            // 没有类型提示 ⇒ 照字符串的样子猜
            if ("true".equalsIgnoreCase(t))  { bools.put(k, true);  return 1; }
            if ("false".equalsIgnoreCase(t)) { bools.put(k, false); return 1; }
            Long l = Long.parseLong(t);      // 会抛 ⇒ 说明不是数字
            if (l >= Integer.MIN_VALUE && l <= Integer.MAX_VALUE) ints.put(k, l.intValue());
            else longs.put(k, l);
            return 1;
        } catch (Throwable notNumber) {
            strings.put(k, s);
            return 1;
        }
    }

    private static int putAuto(JSONObject bools, JSONObject ints, JSONObject longs,
                               JSONObject floats, JSONObject strings,
                               String k, Object v) throws Exception {
        if (k == null || !k.startsWith("fuckds_") || v == null) return 0;
        if (v instanceof Boolean) {
            bools.put(k, (Boolean) v);
        } else if (v instanceof Integer) {
            ints.put(k, (Integer) v);
        } else if (v instanceof Long) {
            longs.put(k, (Long) v);
        } else if (v instanceof Float) {
            floats.put(k, (Float) v);
        } else if (v instanceof String) {
            strings.put(k, (String) v);
        } else {
            return 0;
        }
        return 1;
    }

    private static int copyInto(JSONObject dst, JSONObject src) throws Exception {
        if (src == null) return 0;
        int n = 0;
        for (Iterator<String> it = src.keys(); it.hasNext(); ) {
            String k = it.next();
            dst.put(k, src.opt(k));
            n++;
        }
        return n;
    }

    private static String readText(File f) {
        FileInputStream in = null;
        try {
            in = new FileInputStream(f);
            byte[] buf = new byte[(int) Math.min(f.length(), 1 << 20)];
            int len = in.read(buf);
            return len <= 0 ? "" : new String(buf, 0, len, Charset.forName("UTF-8"));
        } catch (Throwable t) {
            return null;
        } finally {
            try {
                if (in != null) in.close();
            } catch (Throwable ignore) {
            }
        }
    }
}
