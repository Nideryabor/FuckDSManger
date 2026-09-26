package com.nidyaber.fuckdsmanger.bridge;

import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import com.nidyaber.fuckdsmanger.gm.GmAvatar;
import com.nidyaber.fuckdsmanger.gm.GmDb;
import com.nidyaber.fuckdsmanger.gm.GmDevice;
import com.nidyaber.fuckdsmanger.gm.GmDiag;
import com.nidyaber.fuckdsmanger.gm.GmProbe;
import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import org.json.JSONObject;

import java.util.Iterator;

import de.robv.android.xposed.XposedHelpers;

/**
 * 桥的【hook 侧客户端】🐲 —— 跑在宿主进程里（由 LSPosed 注入）
 *
 * 两个通道：
 *   ① **广播**（首选，已验证可用）：UI 进程推 `CONFIG_PUSH` 过来 ⇒ 我们写进宿主配置
 *      —— 发送广播不受**包可见性**过滤，接收器是动态注册的（清单里不需要声明任何东西）
 *   ② provider（备用/已废）：宿主"看不见我们"（实测 `NameNotFoundException`），调不到
 *
 * 写配置为什么用 `GmStore`：那是**模块自己的**访问器，真身往宿主同一个 MMKV 实例读写
 * ⇒ 不用猜键名、不用碰 MMKV 内部、类型也照它的规矩来。
 */
public final class FdmBridge {

    /** 我们模块自己的包名（= UI 那个包）。 */
    public static final String MODULE_PKG = "com.little_femaleboy.cannot_show.the_big_won_whale";

    /** UI 进程 → 宿主进程：把配置推过来。 */
    public static final String ACTION_PUSH = "com.little_femaleboy.fdm.CONFIG_PUSH";
    /** 宿主进程 → UI 进程：请把配置推一次。 */
    public static final String ACTION_REQ = "com.little_femaleboy.fdm.CONFIG_REQ";
    /** 宿主进程 → UI 进程：已应用，rev=N。 */
    public static final String ACTION_APPLIED = "com.little_femaleboy.fdm.CONFIG_APPLIED";
    /** 宿主进程 → UI 进程：宿主**实际存着**的配置（回读）。 */
    public static final String ACTION_STATE = "com.little_femaleboy.fdm.CONFIG_STATE";

    private static volatile boolean sTried = false;
    private static volatile boolean sRecvInstalled = false;
    private static volatile boolean sGotConfig = false;
    /**
     * 桥的握手令牌 🐲
     *
     * UI 进程生成、随 `CONFIG_PUSH` 广播送到宿主进程；我们回调 provider 时带回去。
     * 判据从「调用者包名是不是 com.deepseek.chat」改成「令牌对不对」——
     * 宿主换个包名不再影响这条通道（铁律：见 `专题/铁律-不依赖宿主包名.md`）。
     */
    private static volatile String sToken = null;
    private static BroadcastReceiver sRecv;

    private FdmBridge() {
    }

    /** 宿主第一次有 Context 时调用（由 GmEntry 挂的 onCreate 钩子触发）。 */
    public static void onHostReady(Context ctx) {
        if (sTried) return;
        sTried = true;
        try {
            probe(ctx);
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】桥失败（不影响宿主）", t);
        }
    }

    private static void probe(Context ctx) throws Throwable {
        String hostPkg = ctx.getPackageName();

        // ★ 宿主一启动就把存储里的影子键灌进内存 pin 表 ——
        //   不能只依赖"收到 UI 推送"（UI 可能一直没起来），否则重启后 pin 表是空的。
        syncPins(ctx);

        // ★ 通道①：动态广播接收器（主用）
        installReceiver(ctx);

        // ★ 通道②：provider（保留当对照/诊断）
        try {
            PackageManager pm = ctx.getPackageManager();
            PackageInfo pi = pm.getPackageInfo(MODULE_PKG, PackageManager.GET_PROVIDERS);
            ProviderInfo[] provs = pi.providers;
            GmUtil.log("【FdmBridge】宿主侧 PackageManager：可见本包 ✓ providers="
                    + (provs == null ? "null" : String.valueOf(provs.length)));
            if (provs != null) {
                for (ProviderInfo p : provs) {
                    GmUtil.log("【FdmBridge】   · authority=" + p.authority + " exported=" + p.exported);
                }
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】宿主侧 PackageManager：看不到本包 ✗ " + t
                    + "（⇒ provider 那条路走不通，走广播）");
        }

        String ver = "?";
        try {
            PackageInfo pi = ctx.getPackageManager().getPackageInfo(hostPkg, 0);
            ver = pi.versionName + "(" + pi.versionCode + ")";
        } catch (Throwable ignore) {
        }

        Uri uri = Uri.parse("content://" + MODULE_PKG + ConfigProvider.AUTHORITY_SUFFIX);
        ContentResolver cr = ctx.getContentResolver();
        GmUtil.log("【FdmBridge】开始探桥 → " + uri + "  host=" + hostPkg + " " + ver);
        try {
            String tok = sToken;
            Bundle hb = new Bundle();
            hb.putString("version", ver);
            if (tok != null) hb.putString(ConfigProvider.KEY_TOKEN, tok);
            GmUtil.log("【FdmBridge】heartbeat → " + cr.call(uri, "heartbeat", null, hb));
            Bundle cb = new Bundle();
            if (tok != null) cb.putString(ConfigProvider.KEY_TOKEN, tok);
            GmUtil.log("【FdmBridge】provider getConfig → " + cr.call(uri, "getConfig", null, cb));
            if (tok == null) {
                GmUtil.log("【FdmBridge】（还没拿到令牌 ⇒ provider 会拒；等 UI 推一次配置就会补上）");
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】provider 那条路没通：" + t);
        }
    }

    // ---------------------------------------------------------------- 广播通道

    private static void installReceiver(Context ctx) {
        if (sRecvInstalled) return;
        sRecvInstalled = true;
        try {
            sRecv = new BroadcastReceiver() {
                @Override
                public void onReceive(Context c, Intent it) {
                    try {
                        applyPushed(c, it);
                    } catch (Throwable t) {
                        GmUtil.logFail("【FdmBridge】应用配置失败", t);
                    }
                }
            };
            IntentFilter f = new IntentFilter(ACTION_PUSH);
            if (Build.VERSION.SDK_INT >= 33) {
                ctx.registerReceiver(sRecv, f, Context.RECEIVER_EXPORTED);
            } else {
                ctx.registerReceiver(sRecv, f);
            }
            GmUtil.log("【FdmBridge】✅ 配置接收器已挂（" + ACTION_PUSH + "）");

            // ★ 动作接收器也挂在这里（**宿主进程**）——
            //   之前我把它挂在 FdmApp（那只是我们 App 的 Application 类，宿主里根本不存在）
            //   ⇒ 宿主没人接动作 ⇒ 界面点按钮没反应、灰度值也回不来。
            BroadcastReceiver cmds = new BroadcastReceiver() {
                @Override
                public void onReceive(Context c, Intent it) {
                    try {
                        onCmd(c, it);
                    } catch (Throwable t) {
                        GmUtil.logFail("【FdmBridge】动作执行失败", t);
                    }
                }
            };
            IntentFilter f2 = new IntentFilter(FdmPush.ACTION_CMD);
            if (Build.VERSION.SDK_INT >= 33) {
                ctx.registerReceiver(cmds, f2, Context.RECEIVER_EXPORTED);
            } else {
                ctx.registerReceiver(cmds, f2);
            }
            GmUtil.log("【FdmBridge】✅ 动作接收器已挂（" + FdmPush.ACTION_CMD + "）");

            startReask(ctx);
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】配置接收器挂载失败", t);
        }
    }

    /**
     * 反复索要配置，直到有人应答（最多 30 次 / 2 分钟）。
     *
     * 为什么要这样：UI 进程**不是常驻**的。宿主启动时 UI 可能根本没在跑，
     * 一次索要没人应答就永远拿不到配置（实测栽过一次：先开设置页推、再开宿主 ⇒ 收到 0）。
     * 改成周期性重问之后，**主人什么时候打开设置页都能把配置补上**，
     * 不需要记"先开哪个"。
     */
    private static void startReask(final Context ctx) {
        final android.os.Handler h = new android.os.Handler(android.os.Looper.getMainLooper());
        final int[] n = {0};
        h.postDelayed(new Runnable() {
            @Override
            public void run() {
                // ★ 每次顺手推进一次 pin 表同步 ——
                //   宿主调用 MMKV.initialize() 比 Application.onCreate 晚，
                //   所以 probe() 那一次注定拿不到存储（详见 syncPins 的注释）。
                boolean pinsOk = syncPins(ctx);
                if (pinsOk && sGotConfig) {
                    GmUtil.log("【FdmBridge】配置已到手 · pin 表已同步 ⇒ 停止周期任务");
                    return;
                }
                if (n[0]++ >= 30) {
                    GmUtil.log("【FdmBridge】周期任务收摊（配置=" + sGotConfig + " · pin 表=" + pinsOk + "）");
                    return;
                }
                try {
                    ctx.sendBroadcast(new Intent(ACTION_REQ));
                } catch (Throwable ignore) {
                }
                h.postDelayed(this, 4000);
            }
        }, 3000);
        GmUtil.log("【FdmBridge】开始周期任务（每 4 秒一次：索要配置 + 推进 pin 表同步，最多 30 次）");
    }

    /**
     * 把 UI 推来的配置**写进宿主自己的配置**（宿主 MMKV 里的 `fuckds_*` 键）。
     *
     * 格式：
     *   {"rev":1,
     *    "bools":  {"fuckds_bubble_on": false},
     *    "ints":   {"fuckds_bg_alpha": 128},
     *    "longs":  {}, "floats": {}, "strings": {}}
     *
     * 写完之后：128 类里只有 `GmBubble` 缓存了读取结果（`sRead`）⇒ 清掉它即可立刻生效；
     * 其余功能都是**每次现读**，不用做任何事。
     */
    private static void applyPushed(Context ctx, Intent it) throws Exception {
        if (!inHost(ctx)) {          // 只可能由宿主执行（本地执行会撞上 XposedBridge 缺失）
            android.util.Log.e("FDM-DIAG", "（本地进程收到配置推送，忽略）");
            return;
        }
        String raw = it == null ? null : it.getStringExtra(ConfigProvider.KEY_JSON);
        int rev = it == null ? -1 : it.getIntExtra(ConfigProvider.KEY_REV, -1);
        // 🔑 顺手接下令牌（判据不看包名，看它）
        String tok = it == null ? null : it.getStringExtra(ConfigProvider.KEY_TOKEN);
        if (tok != null && !tok.isEmpty()) {
            if (sToken == null) {
                GmUtil.log("【FdmBridge】🔑 收到桥的握手令牌（以后调 provider 带着它）");
            }
            sToken = tok;
        }
        // ★ 顺手把已有的影子键全量同步进内存 pin 表（宿主重启后内存表是空的）
        syncPins(ctx);
        GmUtil.log("【FdmBridge】📨 收到 UI 推来的配置：rev=" + rev + " json=" + raw);
        if (raw == null || raw.length() == 0 || "{}".equals(raw.trim())) {
            GmUtil.log("【FdmBridge】配置是空的，跳过（不改宿主任何东西）");
            return;
        }

        JSONObject j = new JSONObject(raw);
        SharedPreferences.Editor ed = GmStore.get(ctx).edit();
        int n = 0;

        JSONObject bools = j.optJSONObject("bools");

        // ★★★ 开关型配置：**先走功能自己的入口**，走不通再退回裸写。
        //
        // 为什么不能一律裸写（今天连栽两次）：
        //   ① 缓存 —— GmBubble 内部有「读过了」标志（sRead/sURead/sReadCfg），
        //      裸写存储 ⇒ 它照旧用缓存里的值（症状：用户气泡拨了不生效）
        //   ② 副作用 —— GmModel.setOn 还会把宿主自己的模型配置 JSON 改写掉，
        //      裸写存储 ⇒ 宿主保持原状（症状：模型切换拨了没反应）
        //   `setOn` / `setUOn` 自己就把这两件事都做了，而且它是模块的原生路径。
        JSONObject action = new JSONObject();
        if (bools != null) {
            java.util.List<String> keys = new java.util.ArrayList<String>();
            for (java.util.Iterator<String> kk = bools.keys(); kk.hasNext(); ) {
                keys.add(kk.next());
            }
            StringBuilder done = new StringBuilder();
            for (String k : keys) {
                if (dispatch(ctx, k, bools.optBoolean(k, false))) {
                    action.put(k, true);
                    bools.remove(k);              // 已经处理，别再裸写一遍
                    done.append(k).append(' ');
                }
            }
            if (done.length() > 0) {
                GmUtil.log("【FdmBridge】走专用入口的开关：" + done.toString().trim());
            }
        }

        n += putBools(ed, bools);
        n += putInts(ed, j.optJSONObject("ints"));
        n += putLongs(ed, j.optJSONObject("longs"));
        n += putFloats(ed, j.optJSONObject("floats"));
        n += putStrings(ed, j.optJSONObject("strings"));

        if (n == 0) {
            GmUtil.log("【FdmBridge】没认出任何配置项，跳过（格式见 FdmBridge 注释）");
            sGotConfig = true;          // UI 应答了，就不用再问了
            return;
        }
        boolean ok = ed.commit();
        GmUtil.log("【FdmBridge】✅ 已写入宿主配置 " + n + " 项（commit=" + ok + "）");
        sGotConfig = true;

        // GmBubble 缓存了读取结果（实测有三个：sRead=AI气泡开关、sURead=用户气泡开关、
        // sReadCfg=颜色/圆角/图片/透明度那一堆）⇒ 全清掉，让它下次现读。
        // 不写死字段名：扫所有「静态 boolean 且名字带 read」的，将来它再加缓存也自动覆盖。
        try {
            Class<?> c = XposedHelpers.findClass("com.nidyaber.fuckdsmanger.gm.GmBubble",
                    FdmBridge.class.getClassLoader());
            int cleared = 0;
            StringBuilder names = new StringBuilder();
            for (java.lang.reflect.Field f : c.getDeclaredFields()) {
                if (java.lang.reflect.Modifier.isStatic(f.getModifiers())
                        && f.getType() == boolean.class
                        && f.getName().toLowerCase().contains("read")) {
                    try {
                        f.setAccessible(true);
                        f.setBoolean(null, false);
                        cleared++;
                        names.append(f.getName()).append(' ');
                    } catch (Throwable ignore) {
                    }
                }
            }
            GmUtil.log("【FdmBridge】已清 GmBubble 读取缓存 " + cleared + " 个（" + names.toString().trim()
                    + "）⇒ 气泡配置下次现读");
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】清缓存失败（不影响其它功能）：" + t);
        }

        try {
            Intent ack = new Intent(ACTION_APPLIED);
            ack.putExtra(ConfigProvider.KEY_REV, rev);
            ack.putExtra("count", n);
            ctx.sendBroadcast(ack);
        } catch (Throwable ignore) {
        }

        // ★ 回读：把宿主**实际存着**的配置全部广播回 UI。
        //   为什么必须做：UI 进程读不到宿主的存储（不同 uid）——
        //   不回读的话，界面上显示的只能是"我们请求了什么"，而不是"宿主真有什么"。
        //   那正是教训 106 的反面：**显示真实状态，不做内存里的假状态**。
        try {
            // ★ 不用 allKeys()（MMKV 的 SharedPreferences 包装类上反射不到 ⇒ 实测回读 0 个键）
            //   改成**已知键清单**逐个读：我们的 fuckds_* + 宿主那 83 个灰度键 —— 确定性最高。
            JSONObject st = new JSONObject();
            SharedPreferences sp = GmStore.get(ctx);
            java.util.List<String> keys = new java.util.ArrayList<String>();
            for (String k : OUR_KEYS) keys.add(k);
            for (String[] g : GRAY) keys.add(g[0]);
            int nRead = 0;
            for (String k : keys) {
                try {
                    Object v = anyValue(sp, k);
                    if (v == null) continue;
                    String sv = String.valueOf(v);
                    if (sv.isEmpty()) continue;                 // 没设过的就不报（免得界面一堆空）
                    st.put(k, sv);
                    nRead++;
                } catch (Throwable ignore) {
                }
            }
            Intent s = new Intent(ACTION_STATE);
            s.putExtra("json", st.toString());
            ctx.sendBroadcast(s);
            GmUtil.log("【FdmBridge】已回读宿主配置 " + nRead + " 个键并广播给 UI（清单 " + keys.size() + " 个）");
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】回读宿主配置失败：" + t);
        }
    }

    /**
     * 读一个灰度键。现场（su 抓的 MMKV）实测三种位置：
     *   `fuckds_pin_kv_remote_settings_<名>`  ← 影子覆盖（优先）
     *   `kv_remote_settings_<名>`             ← 宿主下发值（大多数住这）
     *   `kv_settings_<名>`                    ← 少数功能住这（如 hide_assistant_avatar）
     */
    private static String grayRead(Context ctx, String bare, String hostKey) {
        SharedPreferences sp = GmStore.get(ctx);
        String[] ks = {
                "fuckds_pin_" + hostKey,
                hostKey,
                "kv_settings_" + bare,
                "fuckds_pin_kv_settings_" + bare,
        };
        for (String k : ks) {
            try {
                // ★ 必须按类型挨个试：MMKV 强类型，值存成 int/long 时 getString() 会抛，
                //   只 try-catch String 会**把数字型全读成空**（实测：字符串键有值、数字键全空）
                Object v = anyValue(sp, k);
                if (v == null) continue;
                String s = String.valueOf(v);
                if (!s.isEmpty()) return s;
            } catch (Throwable ignore) {
            }
        }
        return "";
    }

    /**
     * 写一个灰度键：**备份原值 + 写影子键**。
     *
     * ★ 影子键（`fuckds_pin_…`）是模块自己的机制：宿主读 MMKV 时 `GmMmkvHook` 会把值替换掉
     *   ⇒ 既生效、又**不动宿主自己的存储**（"全部恢复"只要撤掉影子即可）。
     */
    private static void grayWrite(Context ctx, String bare, String type, String val) {
        SharedPreferences sp = GmStore.get(ctx);
        String full = "kv_remote_settings_" + bare;
        String loc = "kv_settings_" + bare;
        try {
            String cur = sp.getString(full, null);
            if (cur == null) cur = sp.getString(loc, null);
            if (cur != null && !cur.isEmpty()) {
                sp.edit().putString("fuckds_bak_" + full, cur).apply();
            }
        } catch (Throwable ignore) {
        }
        // ★ 影子键：**三种键形都写一份**
        //   底座的读侧替换是"拿宿主读的 key 去查 pin 表" ⇒ 我们不知道宿主读哪个形式，
        //   那就三种全写（`kv_settings_` / `kv_remote_settings_` / 裸名）。
        //   2.5.2 实测：63 项走 kv_settings_ · 18 项走 kv_remote_settings_ · 2 项走裸名。
        sp.edit().putString("fuckds_pin_" + full, val)
          .putString("fuckds_pin_" + loc, val)
          .putString("fuckds_pin_" + bare, val)
          .apply();
        // ★★ 同时塞进**内存 pin 表**（底座读侧替换就是查它）
        try {
            java.util.HashMap<String, String> m = pins();
            m.put(full, val);
            m.put(loc, val);
            m.put(bare, val);
            GmUtil.log("【FdmBridge】pin 表 +3（" + bare + " = " + val + "）");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】pin 表写入失败（只靠影子键了）", t);
        }
    }

    /** pin 表是否已经从存储里全量同步过（幂等标记）。 */
    private static volatile boolean sPinsSynced = false;

    /** 内存 pin 表（**同一个实例**交给底座 `GmMmkvHook.setPins`，之后 put 立刻可见）。 */
    private static volatile java.util.HashMap<String, String> sPins = null;

    private static java.util.HashMap<String, String> pins() {
        if (sPins != null) return sPins;
        java.util.HashMap<String, String> m = new java.util.HashMap<String, String>();
        try {
            Class<?> c = XposedHelpers.findClass("com.nidyaber.fuckdsmanger.gm.GmMmkvHook",
                    FdmBridge.class.getClassLoader());
            // 反射调用：桥在 `bridge` 包、`GmMmkvHook` 在 `gm` 包，直接调会 IllegalAccessError
            XposedHelpers.callStaticMethod(c, "setPins", m);
            GmUtil.log("【FdmBridge】🔗 pin 表已交给底座（读侧替换生效）");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】pin 表注册失败（退回只写影子键）", t);
        }
        sPins = m;
        return m;
    }

    /**
     * 把**已经存在的影子键**全量同步进内存表。
     *
     * ⚠️ **必须容忍"宿主的存储还没就绪"**：
     *   本方法最早由 `probe()`（挂在 `Application.onCreate` 之后）调用，
     *   而宿主**调用 `MMKV.initialize()` 比那更晚** ——
     *   实测这时 `GmStore.get()` 返回 null，对着它调 `getAll()` 直接
     *   `NullPointerException: 'SharedPreferences.getAll()' on a null object reference`
     *   （3.16.0 真机就是这么失败的：表注册上了，但**一条都没灌进去**⇒表是空的⇒永远不命中）。
     *   ⇒ 返回 false，交给"每 4 秒一次"的周期任务**重试**。
     *
     * @return true = 已经同步过（或本次同步成功）
     */
    private static boolean syncPins(Context ctx) {
        if (sPinsSynced) return true;
        try {
            SharedPreferences sp = GmStore.get(ctx);
            if (sp == null) {
                GmUtil.log("【FdmBridge】pin 表同步：宿主存储还没就绪（MMKV 未初始化）⇒ 稍后重试");
                return false;
            }
            java.util.HashMap<String, String> m = pins();
            int n = 0;
            for (java.util.Map.Entry<String, ?> e : sp.getAll().entrySet()) {
                String k = e.getKey();
                if (k == null || !k.startsWith("fuckds_pin_") || e.getValue() == null) continue;
                m.put(k.substring("fuckds_pin_".length()), String.valueOf(e.getValue()));
                n++;
            }
            sPinsSynced = true;
            GmUtil.log("【FdmBridge】pin 表全量同步 " + n + " 条（内存表共 " + m.size() + "）");
            return true;
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】pin 表同步失败", t);
            return false;
        }
    }

    /**
     * 挨个类型试（MMKV 里存的是什么类型只有试了才知道）。
     *
     * ★ 关键：不能只看"有没有抛异常" —— MMKV 的包装类对类型不符**可能直接返回默认值** ✗
     *   （实测：`getString` 对 int 存放的键返回 ""，于是被空串短路 ⇒ 数字键永远读成空 ✗）。
     *   ⇒ 用**不可能出现的哨兵默认值**来判断：返回了别的值，就说明这个类型真的存在 ✅
     */
    /**
     * ★ 统一取值：**每一项都问模块自己的 getter**（而不是拿我编的键去存储里翻 ✗）。
     *
     * 为什么必须这样：有些项根本不是"一个键"——
     *   · 账号名   → `GmName.setText/getText`
     *   · 助手图片 → `GmAvatar.setOn/isOn`（跟别的功能**共用** `fuckds_gm` ✗）
     *   · 账号头像 → `GmUAvatar.setOn/isOn`
     *   · 防撤回   → `GmDb.setOn/isOn`
     * 我先前拿"猜的键"去读写，结果就是"点了没反应、回读还是空" ✗（实测被主人抓到）
     */
    private static final String GM = "com.nidyaber.fuckdsmanger.gm.";

    /** 键名别名（界面上两种写法都见过：ui_nick / fuckds_nick）——统一成一种 */
    private static String alias(String key) {
        if ("ui_nick".equals(key) || "fuckds_nick".equals(key) || "ui_name".equals(key)) return "fuckds_nick";
        return key;
    }

    private static String uiGet(Context ctx, String key) {
        key = alias(key);
        try {
            if ("ui_avatar_on".equals(key)) {
                return String.valueOf(callGm(GM + "GmAvatar", "isOn",
                        new Class<?>[]{Context.class}, new Object[]{ctx}));
            }
            if ("ui_uavatar_on".equals(key)) {
                return String.valueOf(callGm(GM + "GmUAvatar", "isOn",
                        new Class<?>[]{Context.class}, new Object[]{ctx}));
            }
            if ("ui_db_on".equals(key)) {
                return String.valueOf(callGm(GM + "GmDb", "isOn",
                        new Class<?>[]{Context.class}, new Object[]{ctx}));
            }
            if ("fuckds_nick".equals(key)) {
                Object v = callGm(GM + "GmName", "getText",
                        new Class<?>[]{Context.class}, new Object[]{ctx});
                return v == null ? "" : String.valueOf(v);
            }
            if ("ui_db_info".equals(key)) {
                return "共 " + callGm(GM + "GmDb", "count", new Class<?>[]{Context.class}, new Object[]{ctx})
                        + " 条 · " + callGm(GM + "GmDb", "sizeKb", new Class<?>[]{Context.class}, new Object[]{ctx}) + " KB";
            }
            if ("ui_env_on".equals(key)) {
                return String.valueOf(callGm(GM + "GmEnv", "isOn",
                        new Class<?>[]{Context.class}, new Object[]{ctx}));
            }
            if ("ui_env_api".equals(key)) {
                return String.valueOf(callGm(GM + "GmEnv", "isApi",
                        new Class<?>[]{Context.class}, new Object[]{ctx}));
            }
            if ("ui_probe_on".equals(key)) {
                return String.valueOf(callGm(GM + "GmProbe", "shown", new Class<?>[]{}, new Object[]{}));
            }
        } catch (Throwable t) {
            return "取不到:" + t.getClass().getSimpleName();
        }
        return null;                       // 不是"模块接口项" ⇒ 交给普通键逻辑
    }

    /** 统一写值：能走模块 setter 的走 setter，返回 true。 */
    private static boolean uiSet(Context ctx, String key, String val) {
        key = alias(key);
        boolean b = "true".equals(val) || "1".equals(val);
        try {
            if ("ui_avatar_on".equals(key)) {
                callGm(GM + "GmAvatar", "setOn", new Class<?>[]{Context.class, boolean.class},
                        new Object[]{ctx, b});
                return true;
            }
            if ("ui_uavatar_on".equals(key)) {
                callGm(GM + "GmUAvatar", "setOn", new Class<?>[]{Context.class, boolean.class},
                        new Object[]{ctx, b});
                return true;
            }
            if ("ui_db_on".equals(key)) {
                callGm(GM + "GmDb", "setOn", new Class<?>[]{Context.class, boolean.class},
                        new Object[]{ctx, b});
                return true;
            }
            if ("fuckds_nick".equals(key)) {
                callGm(GM + "GmName", "setText", new Class<?>[]{Context.class, String.class},
                        new Object[]{ctx, val});
                return true;
            }
            if ("ui_env_api".equals(key)) {
                callGm(GM + "GmEnv", "setApi", new Class<?>[]{Context.class, boolean.class},
                        new Object[]{ctx, b});
                return true;
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】uiSet " + key + " 失败：" + t);
            return false;
        }
        return false;
    }

    /** 调模块里的**包内可见**方法（反射 + setAccessible）。
     *
     * 为什么必须这样：模块的类和原 UI 都在 `com.nidyaber.fuckdsmanger.gm` 包，
     * 它们的 `rows()` / `handle()` 是**包内可见** ✗ —— 我们在 `bridge` 包直接调会
     * `IllegalAccessError: ... is inaccessible to class FdmBridge`（实测 ✗，这也正是
     * "原 UI 能抓到值、我们的 UI 抓不到"的确切原因）。同进程同类加载器，反射 setAccessible 就能过 ✅
     */
    private static Object callGm(String cls, String method, Class<?>[] sig, Object[] args)
            throws Exception {
        Class<?> c = Class.forName(cls, true, FdmBridge.class.getClassLoader());
        java.lang.reflect.Method m = null;
        try {
            m = c.getDeclaredMethod(method, sig);
        } catch (NoSuchMethodException e) {
            // ★ 签名猜错是常态（实测 `GmEnv.isOn` 就不是 (Context) ✗）——
            //   按方法名找，再按"参数能不能塞进去"挑一个（Context 可省、boolean/int/String 可换）
            for (java.lang.reflect.Method cand : c.getDeclaredMethods()) {
                if (!cand.getName().equals(method)) continue;
                Class<?>[] ps = cand.getParameterTypes();
                if (ps.length > args.length) continue;
                boolean ok = true;
                for (int i = 0; i < ps.length; i++) {
                    Object a = args[i];
                    if (a == null) continue;
                    if (!boxed(ps[i]).isAssignableFrom(a.getClass())) {
                        ok = false;
                        break;
                    }
                }
                if (ok) {
                    m = cand;
                    Object[] sub = new Object[ps.length];
                    System.arraycopy(args, 0, sub, 0, ps.length);
                    args = sub;
                    break;
                }
            }
            if (m == null) throw e;
        }
        m.setAccessible(true);
        return m.invoke(null, args);
    }

    private static Class<?> boxed(Class<?> c) {
        if (c == boolean.class) return Boolean.class;
        if (c == int.class) return Integer.class;
        if (c == long.class) return Long.class;
        if (c == float.class) return Float.class;
        return c;
    }

    private static Object anyValue(SharedPreferences sp, String k) {
        final String SENT_S = "\u0001__none__";
        try {
            String v = sp.getString(k, SENT_S);
            if (!SENT_S.equals(v)) return v;
        } catch (Throwable ignore) {
        }
        final int SENT_I = Integer.MIN_VALUE + 7;
        try {
            int v = sp.getInt(k, SENT_I);
            if (v != SENT_I) return v;
        } catch (Throwable ignore) {
        }
        final long SENT_L = Long.MIN_VALUE + 7;
        try {
            long v = sp.getLong(k, SENT_L);
            if (v != SENT_L) return v;
        } catch (Throwable ignore) {
        }
        final float SENT_F = -1.2345e-30f;
        try {
            float v = sp.getFloat(k, SENT_F);
            if (v != SENT_F) return v;
        } catch (Throwable ignore) {
        }
        try {
            if (sp.contains(k)) return sp.getBoolean(k, false);
        } catch (Throwable ignore) {
        }
        return null;
    }

    /**
     * 开关型配置 → **走功能自己的入口**。
     *
     * 表里每一条都是**对着 smali 验过的**（setOn/setUOn 里写的键 == 我们的键），不是猜的。
     * 不在表里的键返回 false ⇒ 调用方退回裸写（并靠清缓存兜底）。
     */
    private static boolean dispatch(Context ctx, String key, boolean v) {
        try {
            if ("fuckds_bubble_on".equals(key)) {
                com.nidyaber.fuckdsmanger.gm.GmBubble.setOn(ctx, v);
                GmUtil.log("【FdmBridge】" + key + "=" + v + " → GmBubble.setOn");
                return true;
            }
            if ("fuckds_ububble_on".equals(key)) {
                com.nidyaber.fuckdsmanger.gm.GmBubble.setUOn(ctx, v);
                GmUtil.log("【FdmBridge】" + key + "=" + v + " → GmBubble.setUOn");
                return true;
            }
            if ("fuckds_model_switch".equals(key)) {
                boolean r = com.nidyaber.fuckdsmanger.gm.GmModel.setOn(ctx, v);
                GmUtil.log("【FdmBridge】" + key + "=" + v + " → GmModel.setOn → " + r);
                // 自证：写完立刻**回读宿主那份 JSON**，看 "switchable" 到底成了什么。
                // （setOn 返回 true 只代表"它自己那几步没抛异常"，不代表宿主真的读到了新值）
                try {
                    String h = com.nidyaber.fuckdsmanger.gm.GmPrompt.host();
                    boolean hasFalse = h != null && h.contains("\"switchable\":false");
                    boolean hasTrue = h != null && h.contains("\"switchable\":true");
                    int idx = h == null ? -1 : h.indexOf("switchable");
                    String frag = (idx < 0) ? "（找不到 switchable）"
                            : h.substring(Math.max(0, idx - 24), Math.min(h.length(), idx + 32));
                    GmUtil.log("【FdmBridge】回读宿主配置：len=" + (h == null ? -1 : h.length())
                            + " 含switchable:false=" + hasFalse + " 含switchable:true=" + hasTrue
                            + " 片段=[" + frag + "]");
                } catch (Throwable t) {
                    GmUtil.log("【FdmBridge】回读宿主配置失败：" + t);
                }
                return true;
            }
            if ("fuckds_device_on".equals(key)) {
                com.nidyaber.fuckdsmanger.gm.GmDevice.setOn(ctx, v);
                GmUtil.log("【FdmBridge】" + key + "=" + v + " → GmDevice.setOn");
                return true;
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】" + key + " 专用入口失败（退回裸写）：" + t);
        }
        return false;
    }

    /** 动作要回传给 UI 的**数据**（JSON/长文本）—— 用广播，不能写本进程的 SP。 */
    private static String lastData = null;

    /** 我们现在是在**宿主进程**里吗（只有那里才有 Xposed API 与模块的 gm.* 真身）。 */
    public static boolean inHost(Context ctx) {
        try {
            return ctx != null && !"com.little_femaleboy.cannot_show.the_big_won_whale"
                    .equals(ctx.getPackageName());
        } catch (Throwable t) {
            return false;
        }
    }

    /**
     * 宿主侧：执行 UI 请求的动作。
     *
     * ★★ 必须只在宿主进程执行：
     *   模块的 `GmUtil.log()` 会调 `XposedBridge` —— 我们 App 进程里**没有 Xposed API**，
     *   一旦在我们进程里跑到就 `NoClassDefFoundError: de.robv.android.xposed.XposedBridge` 直接崩
     *   （实测：灰度页/日志页一点就崩，就是这个）。
     */
    public static void onCmd(Context ctx, Intent it) {
        if (!inHost(ctx)) {
            android.util.Log.e("FDM-DIAG", "（本地进程收到动作，忽略；等宿主来执行）");
            return;
        }
        String cmd = it == null ? null : it.getStringExtra("cmd");
        lastData = null;
        Object arg = (it == null || it.getExtras() == null) ? null : it.getExtras().get("arg");
        String back = "?";
        try {
            if ("avatar_img".equals(cmd)) {
                boolean ok2 = GmAvatar.saveImage(ctx, android.net.Uri.parse(String.valueOf(arg)));
                GmAvatar.setOn(ctx, true);
                back = "助手图片已保存：" + ok2;
            } else if ("bubble_img".equals(cmd)) {
                com.nidyaber.fuckdsmanger.gm.GmBubble.saveImage(
                        ctx, android.net.Uri.parse(String.valueOf(arg)));
                back = "气泡图已保存";
            } else if ("ui_step".equals(cmd)) {
                // ★ 界面把关键步骤发过来，由宿主写日志 ——
                //   因为 ColorOS 会把应用进程的 log，我看不到界面侧 ✗
                GmUtil.log("【FDM-UI】" + arg);
                back = "记下了";
            } else if ("img_path".equals(cmd)) {
                // ★★ 传**路径**不传字节（主人的主意 ✅）：界面把原图写进**宿主自己的外部目录**
                //    ⇒ 宿主用自己的权限读自己的文件 ⇒ 零权限问题、不受大小限制
                String[] a = String.valueOf(arg).split("\\|", -1);
                String kind = a[0];
                java.io.File src = new java.io.File(a[1]);
                if (!src.canRead()) {
                    back = "宿主读不到那个文件（" + a[1] + "）⇒ 改用分块字节";
                    GmUtil.log("【FdmBridge】" + back);
                } else {
                    // ★ 优先交给**模块自己的 saveImage**：它才知道内部路径和原文件名 ✅
                    //   （主人明确要求落到 /data/user/0/<宿主>/files/ 下的原文件名 ✅）
                    String cls2 = "avatar".equals(kind) ? "GmAvatar"
                            : ("uavatar".equals(kind) ? "GmUAvatar"
                            : ("bg".equals(kind) ? "GmBg" : "GmBubble"));
                    Object r2 = null;
                    try {
                        r2 = callGm(GM + cls2, "saveImage",
                                new Class<?>[]{Context.class, android.net.Uri.class},
                                new Object[]{ctx, android.net.Uri.fromFile(src)});
                    } catch (Throwable t3) {
                        GmUtil.log("【FdmBridge】" + cls2 + ".saveImage 失败：" + t3);
                    }
                    String tip = cls2 + ".saveImage → " + r2;
                    // 开关一并打开
                    if ("avatar".equals(kind) || "uavatar".equals(kind)) {
                        try {
                            callGm(GM + cls2, "setOn",
                                    new Class<?>[]{Context.class, boolean.class},
                                    new Object[]{ctx, true});
                        } catch (Throwable ignore) {
                        }
                    }
                    // 兜底：saveImage 没成（返回 false）就自己拷到 file() 指的位置
                    if (!(r2 instanceof Boolean) || !((Boolean) r2)) {
                        try {
                            Object f = callGm(GM + cls2, "file",
                                    new Class<?>[]{Context.class}, new Object[]{ctx});
                            if (f instanceof java.io.File) {
                                copyFile(src, (java.io.File) f);
                                tip += " ｜兜底拷到 " + ((java.io.File) f).getAbsolutePath();
                            }
                        } catch (Throwable ignore) {
                        }
                    }
                    back = "图片已就位（" + src.length() + " 字节）→ " + tip;
                    GmUtil.log("【FdmBridge】" + back);
                }
            } else if ("img_begin".equals(cmd)) {
                // ★ 大图**不压缩**：界面分块发字节，宿主拼成本地文件再交给模块自己的接口
                String[] a = String.valueOf(arg).split("\\|", -1);
                java.io.File f = new java.io.File(ctx.getCacheDir(), "fdm_in_" + a[0]);
                if (f.exists()) f.delete();
                back = "开始接收 " + a[0] + "（" + a[1] + " 字节）";
            } else if ("img_chunk".equals(cmd)) {
                String[] a = String.valueOf(arg).split("\\|", -1);
                byte[] b = android.util.Base64.decode(a[2], android.util.Base64.DEFAULT);
                java.io.File f = new java.io.File(ctx.getCacheDir(), "fdm_in_" + a[0]);
                java.io.FileOutputStream fo = new java.io.FileOutputStream(f, true);
                fo.write(b);
                fo.close();
                back = "收到块 " + a[1] + "（" + b.length + " 字节）";
            } else if ("img_end".equals(cmd)) {
                String kind = String.valueOf(arg);
                java.io.File src = new java.io.File(ctx.getCacheDir(), "fdm_in_" + kind);
                long n = src.length();
                String target = null;
                if ("avatar".equals(kind) || "uavatar".equals(kind)) {
                    String cls = "avatar".equals(kind) ? "GmAvatar" : "GmUAvatar";
                    Object f = callGm(GM + cls, "file", new Class<?>[]{Context.class}, new Object[]{ctx});
                    if (f instanceof java.io.File) {
                        copyFile(src, (java.io.File) f);
                        callGm(GM + cls, "setOn", new Class<?>[]{Context.class, boolean.class},
                                new Object[]{ctx, true});
                        target = ((java.io.File) f).getAbsolutePath();
                    }
                } else if ("bg".equals(kind)) {
                    Object f = callGm(GM + "GmBg", "file", new Class<?>[]{Context.class}, new Object[]{ctx});
                    if (f instanceof java.io.File) {
                        copyFile(src, (java.io.File) f);
                        target = ((java.io.File) f).getAbsolutePath();
                    }
                } else {
                    Object r = callGm(GM + "GmBubble", "saveImage",
                            new Class<?>[]{Context.class, android.net.Uri.class},
                            new Object[]{ctx, android.net.Uri.fromFile(src)});
                    target = "saveImage→" + r;
                }
                back = "图片已收（" + n + " 字节）→ " + target;
                GmUtil.log("【FdmBridge】" + back);
            } else if ("pick_avatar".equals(cmd) || "pick_uavatar".equals(cmd)
                    || "pick_bubble".equals(cmd)) {
                // ★★ 图片走**宿主自己弹选择器**（原 UI 就是这么干的 ✅）——
                //    这样图**一步都不出宿主进程** ✗，也就没有"跨进程读不到 URI"和"压缩糊掉"的问题 ✅
                String cls = "pick_avatar".equals(cmd) ? "GmAvatar"
                        : ("pick_uavatar".equals(cmd) ? "GmUAvatar" : "GmBubble");
                String mth = "GmBubble".equals(cls) ? "armPick" : "pick";
                callGm(GM + cls, mth, new Class<?>[]{}, new Object[]{});
                back = "已让宿主弹选择器（" + cls + "." + mth + "）——去宿主界面上选图即可";
                GmUtil.log("【FdmBridge】" + back);
            } else if ("img_bytes".equals(cmd)) {
                // ★ 界面把图**压缩后按字节发过来**（不是 URI ✗）——
                //   因为 SAF 选的图是第三方 provider 的 URI，跨进程授权不可靠（实测宿主读不到 ✗）
                String[] p2 = String.valueOf(arg).split("\u001f", -1);
                String kind = p2[0];
                byte[] bytes = android.util.Base64.decode(p2[1], android.util.Base64.DEFAULT);
                java.io.File target = null;
                if ("avatar".equals(kind)) {
                    Object f = callGm(GM + "GmAvatar", "file",
                            new Class<?>[]{Context.class}, new Object[]{ctx});
                    if (f instanceof java.io.File) target = (java.io.File) f;
                }
                if (target != null) {
                    java.io.FileOutputStream fo = new java.io.FileOutputStream(target);
                    fo.write(bytes);
                    fo.close();
                    callGm(GM + "GmAvatar", "setOn", new Class<?>[]{Context.class, boolean.class},
                            new Object[]{ctx, true});
                    back = "助手图片已写入：" + target.getName() + "（" + bytes.length + " 字节）";
                } else {
                    // 气泡图：先落临时文件，再交给模块自己的 saveImage
                    java.io.File tmp = new java.io.File(ctx.getCacheDir(), "fdm_img_" + kind);
                    java.io.FileOutputStream fo = new java.io.FileOutputStream(tmp);
                    fo.write(bytes);
                    fo.close();
                    Object r = callGm(GM + "GmBubble", "saveImage",
                            new Class<?>[]{Context.class, android.net.Uri.class},
                            new Object[]{ctx, android.net.Uri.fromFile(tmp)});
                    back = "气泡图已交给宿主：" + r + "（" + bytes.length + " 字节）";
                }
                GmUtil.log("【FdmBridge】" + back);
            } else if ("uavatar_on".equals(cmd)) {
                callGm(GM + "GmUAvatar", "setOn", new Class<?>[]{Context.class, boolean.class},
                        new Object[]{ctx, asBool(arg)});
                back = "账号头像：" + (asBool(arg) ? "已开启" : "已关闭");
            } else if ("avatar_on".equals(cmd)) {
                callGm(GM + "GmAvatar", "setOn", new Class<?>[]{Context.class, boolean.class}, new Object[]{ctx, asBool(arg)});
                back = "助手图片：" + (asBool(arg) ? "已开启" : "已关闭")
                        + "（有没有图：" + GmAvatar.hasImage(ctx) + "）";
            } else if ("db_on".equals(cmd)) {
                callGm(GM + "GmDb", "setOn", new Class<?>[]{Context.class, boolean.class}, new Object[]{ctx, asBool(arg)});
                back = "防撤回：" + (asBool(arg) ? "已开启" : "已关闭");
            } else if ("db_info".equals(cmd)) {
                back = "共 " + GmDb.count(ctx) + " 条备份 · 占用 " + GmDb.sizeKb(ctx) + " KB";
            } else if ("db_clear".equals(cmd)) {
                GmDb.clear(ctx);
                back = "本地数据库已清空（现存 " + GmDb.count(ctx) + " 条）";
            } else if ("dev_reset".equals(cmd)) {
                String id = GmDevice.reset();
                back = "已换新设备身份：" + id + "（重启宿主后生效）";
            } else if ("probe_toggle".equals(cmd)) {
                GmProbe.toggle(ctx);
                back = "元素捕获器：" + (GmProbe.shown() ? "已挂上" : "已取下");
            } else if ("gray_put".equals(cmd)) {
                // arg = "键(裸名/全名)\x1ftype\x1fvalue"
                String[] p = String.valueOf(arg).split("\u001f", -1);
                String bare = p[0].startsWith("kv_remote_settings_")
                        ? p[0].substring("kv_remote_settings_".length()) : p[0];
                String type = p[1];
                String val = p.length > 2 ? p[2] : "";
                grayWrite(ctx, bare, type, val);
                back = "已写 " + bare + " = " + val + "（原值已备份，宿主读时生效）";
            } else if ("state_all".equals(cmd)) {
                // ★ 把"模块接口项"的真值一次全部报回来（界面拿它当开关的当前态）
                JSONObject o = new JSONObject();
                for (String k : new String[]{"ui_avatar_on", "ui_uavatar_on", "ui_db_on",
                        "fuckds_nick", "ui_nick", "ui_db_info", "ui_env_on", "ui_env_api",
                        "ui_probe_on"}) {
                    String v = uiGet(ctx, k);
                    if (v != null) o.put(k, v);
                }
                lastData = o.toString();
                back = "状态回读 " + o.length() + " 项";
                GmUtil.log("【FdmBridge】state_all：" + o);
            } else if ("cfg_put".equals(cmd)) {
                // arg = "键\x1ftype\x1f值" —— **所有控件都走这里**：
                //   宿主优先调模块自己的 setter（跟原 UI 一模一样），没有对应入口才退回写存储。
                String[] p = String.valueOf(arg).split("\u001f", -1);
                String key = alias(p[0]);
                String type = p[1];
                String val = p.length > 2 ? p[2] : "";
                boolean viaSetting = false;
                if ("b".equals(type)) {
                    viaSetting = dispatch(ctx, key, "true".equals(val) || "1".equals(val));
                }
                // ★ 模块接口项（账号名/助手图片/头像/防撤回…）：走它们**自己的 setter**
                if (!viaSetting) {
                    viaSetting = uiSet(ctx, key, val);
                }
                if (!viaSetting) {
                    try {
                        GmStore.bak(ctx, key, type);
                        GmStore.write(ctx, key, val, type);
                    } catch (Throwable t) {
                        GmUtil.log("【FdmBridge】cfg_put 写存储失败 " + key + "：" + t);
                    }
                }
                // 气泡那几项有读取缓存，改完要清（不然宿主还用旧值）
                try {
                    Class<?> c = XposedHelpers.findClass("com.nidyaber.fuckdsmanger.gm.GmBubble",
                            FdmBridge.class.getClassLoader());
                    for (java.lang.reflect.Field f : c.getDeclaredFields()) {
                        if (java.lang.reflect.Modifier.isStatic(f.getModifiers())
                                && f.getType() == boolean.class
                                && f.getName().toLowerCase().contains("read")) {
                            f.setAccessible(true);
                            f.setBoolean(null, false);
                        }
                    }
                } catch (Throwable ignore) {
                }
                back = key + " = " + val + (viaSetting ? "（走模块入口）" : "（写存储）");
                // ★ "三次握手"的第三拍：**回读真值**并结构化回传，界面据此只重绘这一项
                String now;
                String uiNow = uiGet(ctx, key);
                if (uiNow != null) {
                    now = uiNow;
                } else {
                    Object v = anyValue(GmStore.get(ctx), key);
                    now = v == null ? "" : String.valueOf(v);
                }
                lastData = "{\"key\":\"" + key + "\",\"ok\":true,\"value\":\"" + now + "\"}";
            } else if ("cfg_state".equals(cmd)) {
                // ★ 状态通道：把**模块自己 getter 的当前值**回传（界面照着显示，而不是读我编的键）
                JSONObject o = new JSONObject();
                try { o.put("avatar_on", GmAvatar.isOn(ctx)); } catch (Throwable ignore) { }
                try { o.put("avatar_img", GmAvatar.hasImage(ctx)); } catch (Throwable ignore) { }
                try { o.put("db_on", GmDb.isOn(ctx)); } catch (Throwable ignore) { }
                try { o.put("db_count", GmDb.count(ctx)); } catch (Throwable ignore) { }
                try { o.put("device_on", GmDevice.isOn()); } catch (Throwable ignore) { }
                try { o.put("probe_on", GmProbe.shown()); } catch (Throwable ignore) { }
                try { o.put("bubble_on", callGm("com.nidyaber.fuckdsmanger.gm.GmBubble", "on",
                        new Class<?>[]{}, new Object[]{})); } catch (Throwable ignore) { }
                try { o.put("ububble_on", callGm("com.nidyaber.fuckdsmanger.gm.GmBubble", "uOn",
                        new Class<?>[]{}, new Object[]{})); } catch (Throwable ignore) { }
                try { o.put("bubble_img", callGm("com.nidyaber.fuckdsmanger.gm.GmBubble", "imgOn",
                        new Class<?>[]{}, new Object[]{})); } catch (Throwable ignore) { }
                try { o.put("ububble_img", callGm("com.nidyaber.fuckdsmanger.gm.GmBubble", "uImgOn",
                        new Class<?>[]{}, new Object[]{})); } catch (Throwable ignore) { }
                try { o.put("name", callGm("com.nidyaber.fuckdsmanger.gm.GmName", "getText",
                        new Class<?>[]{Context.class}, new Object[]{ctx})); } catch (Throwable ignore) { }
                try { o.put("env_on", callGm("com.nidyaber.fuckdsmanger.gm.GmEnv", "isOn",
                        new Class<?>[]{Context.class}, new Object[]{ctx})); } catch (Throwable ignore) { }
                try { o.put("env_api", callGm("com.nidyaber.fuckdsmanger.gm.GmEnv", "isApi",
                        new Class<?>[]{Context.class}, new Object[]{ctx})); } catch (Throwable ignore) { }
                try { o.put("model_switch", callGm("com.nidyaber.fuckdsmanger.gm.GmModel", "isOn",
                        new Class<?>[]{Context.class}, new Object[]{ctx})); } catch (Throwable ignore) { }
                try { o.put("uavatar_on", callGm("com.nidyaber.fuckdsmanger.gm.GmUAvatar", "isOn",
                        new Class<?>[]{Context.class}, new Object[]{ctx})); } catch (Throwable ignore) { }
                lastData = o.toString();
                back = "状态 " + o.length() + " 项";
            } else if ("name_put".equals(cmd)) {
                callGm("com.nidyaber.fuckdsmanger.gm.GmName", "setText",
                        new Class<?>[]{Context.class, String.class}, new Object[]{ctx, String.valueOf(arg)});
                back = "账号名已写入模块（" + String.valueOf(arg).length() + " 字）";
            } else if ("name_clear".equals(cmd)) {
                callGm("com.nidyaber.fuckdsmanger.gm.GmName", "clear",
                        new Class<?>[]{Context.class}, new Object[]{ctx});
                back = "账号名已清空（跟随宿主）";
            } else if ("uavatar_img".equals(cmd)) {
                callGm("com.nidyaber.fuckdsmanger.gm.GmUAvatar", "saveImage",
                        new Class<?>[]{Context.class, android.net.Uri.class},
                        new Object[]{ctx, android.net.Uri.parse(String.valueOf(arg))});
                callGm("com.nidyaber.fuckdsmanger.gm.GmUAvatar", "setOn",
                        new Class<?>[]{Context.class, boolean.class}, new Object[]{ctx, true});
                back = "账号头像已保存";
            } else if ("rows_dump".equals(cmd)) {
                // ★ 关键诊断：原 UI 和 GmMmkvHook **在同一个包**（gm），那些方法包内可见
                //   ⇒ 我们在 bridge 包**直接调会 IllegalAccessError** ✗ ⇒ 必须反射 + setAccessible
                StringBuilder sb = new StringBuilder();
                try {
                    Object rows = callGm("com.nidyaber.fuckdsmanger.gm.GmMmkvHook", "rows",
                            new Class<?>[]{Context.class}, new Object[]{ctx});
                    if (rows instanceof java.util.List) {
                        java.util.List<?> l = (java.util.List<?>) rows;
                        sb.append("rows() size=").append(l.size()).append("\n");
                        int i = 0;
                        for (Object o : l) {
                            if (i++ > 120) break;
                            sb.append("  ").append(o instanceof Object[]
                                    ? java.util.Arrays.deepToString((Object[]) o) : String.valueOf(o))
                                    .append("\n");
                        }
                    } else {
                        sb.append("rows() = ").append(rows).append("\n");
                    }
                } catch (Throwable t) {
                    sb.append("rows() 失败：").append(t).append("\n");
                }
                for (String k : new String[]{"kv_remote_settings_opus_bitrate",
                        "kv_remote_settings_voice_input_enabled",
                        "kv_remote_settings_picture_compress_format",
                        "kv_settings_hide_assistant_avatar"}) {
                    Object direct = null;
                    String viaHook = null;
                    try {
                        direct = anyValue(GmStore.get(ctx), k);
                    } catch (Throwable t) {
                        direct = "直读失败:" + t;
                    }
                    try {
                        Object h = callGm("com.nidyaber.fuckdsmanger.gm.GmMmkvHook", "handle",
                                new Class<?>[]{String.class, String.class}, new Object[]{k, ""});
                        viaHook = String.valueOf(h);
                    } catch (Throwable t) {
                        viaHook = "hook失败:" + t;
                    }
                    sb.append("  ").append(k.replace("kv_remote_settings_", "").replace("kv_settings_", ""))
                            .append(" : 直读=").append(direct).append("  hook=").append(viaHook).append("\n");
                }
                lastData = sb.toString();
                back = "rows_dump 完成（" + sb.length() + " 字）";
                GmUtil.log("【FdmBridge】rows_dump：" + sb.substring(0, Math.min(600, sb.length())));
            } else if ("store_dump".equals(cmd)) {
                // ★ 诊断用：把宿主存储整个倒出来（键名+值）——
                //   一眼就能看出"灰度键到底叫什么、有没有值"
                String d = GmStore.dumpAll(ctx);
                lastData = d == null ? "(dumpAll 返回 null)" : d;
                back = "已倒出宿主存储 " + (d == null ? 0 : d.length()) + " 字";
                GmUtil.log("【FdmBridge】存储倒出前 600 字：" + (d == null ? "null"
                        : d.substring(0, Math.min(600, d.length()))));
            } else if ("gray_all".equals(cmd)) {
                JSONObject o = new JSONObject();
                StringBuilder sample = new StringBuilder();
                for (String[] g : GRAY) {
                    String hostKey = g[0];                        // kv_remote_settings_xxx
                    String bare = hostKey.startsWith("kv_remote_settings_")
                            ? hostKey.substring("kv_remote_settings_".length()) : hostKey;
                    String v = grayRead(ctx, bare, hostKey);
                    o.put(bare, v);
                    if (sample.length() < 220 && (bare.contains("voice_input") || bare.contains("opus")
                            || bare.contains("hide_assistant")
                            || bare.contains("picture_compress") || bare.contains("model_configs"))) {
                        sample.append(bare).append("=[").append(v).append("] ");
                    }
                }
                lastData = o.toString();
                back = "已回读 " + o.length() + " 个灰度值";
                GmUtil.log("【FdmBridge】灰度样例：" + sample);
            } else if ("gray_restore_all".equals(cmd)) {
                // 撤掉全部影子覆盖（原值就没被动过，撤了即还原）
                SharedPreferences sp = GmStore.get(ctx);
                SharedPreferences.Editor ed = sp.edit();
                int n = 0;
                for (String[] g : GRAY) {
                    String bare = g[0].startsWith("kv_remote_settings_")
                            ? g[0].substring("kv_remote_settings_".length()) : g[0];
                    ed.remove("fuckds_pin_kv_remote_settings_" + bare);
                    ed.remove("fuckds_pin_kv_settings_" + bare);
                    n++;
                }
                ed.apply();
                back = "已全部恢复灰度（撤掉 " + n + " 项覆盖）";
            } else if ("dump_text".equals(cmd)) {
                StringBuilder sb = new StringBuilder();
                try {
                    sb.append("===== DIAG =====\n").append(GmDiag.text());
                } catch (Throwable t2) {
                    sb.append("(DIAG 读取失败：").append(t2).append(")\n");
                }
                try {
                    sb.append("\n===== DS DATA（服务器下发）=====\n").append(GmStore.dumpAll(ctx));
                } catch (Throwable t2) {
                    sb.append("\n(DS DATA 读取失败：").append(t2).append(")\n");
                }
                String all = sb.toString();
                lastData = all.length() > 200000 ? all.substring(0, 200000) : all;
                back = "已回读日志 + 下发数据 " + all.length() + " 字";
            } else if ("dump_clear".equals(cmd)) {
                StringBuilder b = GmDiag.buf();
                if (b != null) b.setLength(0);
                back = "日志缓冲已清空";
            } else if ("avatar_status".equals(cmd)) {
                back = "助手图片=" + GmAvatar.isOn(ctx) + "/有图=" + GmAvatar.hasImage(ctx)
                        + " · 防撤回=" + GmDb.isOn(ctx) + "/" + GmDb.count(ctx) + "条"
                        + " · 设备伪装=" + GmDevice.isOn() + " · 捕获器=" + GmProbe.shown();
            } else {
                back = "（该动作暂未接通）" + cmd;
            }
        } catch (Throwable t) {
            back = "动作 " + cmd + " 失败：" + t;
            GmUtil.log("【FdmBridge】" + back);
        }
        GmUtil.log("【FdmBridge】动作 " + cmd + " → " + (back != null && back.length() > 120
                ? back.substring(0, 120) + "…" : back));
        try {
            Intent r = new Intent(FdmPush.ACTION_RESULT);
            r.putExtra("cmd", cmd);
            r.putExtra("text", back);
            // ★ 数据要**用广播发回去**：宿主写自己的 fdm_ui 我们读不到（不同进程不同文件）
            r.putExtra("data", lastData);
            ctx.sendBroadcast(r);
        } catch (Throwable ignore) {
        }
    }

    /** 我们自己的配置键（回读清单用；不做 allKeys，因为 MMKV 的包装类反射不到它） */
    private static final String[] OUR_KEYS = {
            "fuckds_gm", "fuckds_bubble_on", "fuckds_ububble_on", "fuckds_bubble_color",
            "fuckds_bubble_radius", "fuckds_bubble_alpha", "fuckds_bubble_maxz",
            "fuckds_bubble_img", "fuckds_ububble_color", "fuckds_ububble_radius",
            "fuckds_ububble_img", "fuckds_bg_on", "fuckds_bg_mode", "fuckds_bg_alpha",
            "fuckds_bg_grad", "fuckds_bg_crop", "fuckds_bg_pos", "fuckds_bg_dir",
            "fuckds_bg_rot", "fuckds_bg_cam", "fuckds_model_switch", "fuckds_suggest_on",
            "fuckds_suggest_ai", "fuckds_suggest_count", "fuckds_suggest_text",
            "fuckds_device_on", "fuckds_device_id", "fuckds_dev_ask3",
            "fuckds_prompt_feature", "fuckds_welcome_msg",
    };

    /** 宿主灰度开关表（= 原 UI 的「灰度选项管理」页）：{键, 类型}。由生成器产出，别手改。 */
    private static final String[][] GRAY = {
            {"kv_remote_settings_voice_input_enabled", "b"},
            {"kv_remote_settings_input_default_voice", "b"},
            {"kv_remote_settings_input_view_voice_gesture_duration_ms", "i"},
            {"kv_remote_settings_record_empty_detect_time_ms", "i"},
            {"kv_remote_settings_record_stop_delay_ms", "i"},
            {"kv_remote_settings_max_duration_ms", "i"},
            {"kv_remote_settings_opus_bitrate", "i"},
            {"kv_remote_settings_deep_think_button_suffix", "s"},
            {"kv_remote_settings_conversation_search_enabled", "b"},
            {"kv_remote_settings_search_state_on_login", "s"},
            {"kv_remote_settings_search_state_on_launch", "s"},
            {"kv_remote_settings_allow_parallel_streams", "b"},
            {"kv_remote_settings_interrupt_and_send_enabled", "b"},
            {"kv_remote_settings_allow_file_with_search", "b"},
            {"kv_remote_settings_sse_smooth_follow", "b"},
            {"kv_remote_settings_normal_history_and_file_token_limit", "i"},
            {"kv_remote_settings_r1_history_and_file_token_limit", "i"},
            {"kv_remote_settings_completion_request_timeout_ms", "i"},
            {"kv_remote_settings_regenerate_request_timeout_ms", "i"},
            {"kv_remote_settings_hif_max_retry_interval_secs", "i"},
            {"kv_remote_settings_hcaptcha_enabled", "b"},
            {"kv_remote_settings_enable_google_sign_in_captcha", "b"},
            {"kv_remote_settings_one_tap_login_enabled", "b"},
            {"kv_remote_settings_hide_assistant_avatar", "b"},
            {"kv_remote_settings_select_text_without_markdown_syntax", "b"},
            {"kv_remote_settings_enable_webview_content_report", "b"},
            {"kv_remote_settings_picture_compress_format", "s"},
            {"kv_remote_settings_support_center_url", "s"},
            {"kv_remote_settings_query_files_time_interval", "i"},
            {"kv_remote_settings_markdown_top_level_node_limit", "i"},
            {"kv_remote_settings_pow_prefetch_count", "i"},
            {"kv_remote_settings_session_prefetch_count", "i"},
            {"kv_remote_settings_pow_prefetch", "b"},
            {"kv_remote_settings_session_prefetch", "b"},
            {"kv_remote_settings_continue_request_timeout_ms", "i"},
            {"kv_remote_settings_resume_request_timeout_ms", "i"},
            {"kv_remote_settings_edit_request_timeout_ms", "i"},
            {"kv_remote_settings_auto_resume_request_timeout_ms", "i"},
            {"kv_remote_settings_auto_resume_max_time_ms", "i"},
            {"kv_remote_settings_auto_resume_interval_ms", "i"},
            {"kv_remote_settings_launch_clean_session_interval_seconds", "i"},
            {"kv_remote_settings_pinned_session_limit", "i"},
            {"kv_remote_settings_max_upload_file_size", "i"},
            {"kv_remote_settings_max_input_file_count", "i"},
            {"kv_remote_settings_sse_auto_scroll_one_screen", "b"},
            {"kv_remote_settings_sse_auto_scroll_smooth_stiffness", "i"},
            {"kv_remote_settings_optimize_markdown", "b"},
            {"kv_remote_settings_disable_single_dollar_latex", "b"},
            {"kv_remote_settings_show_new_chat_button_above_input", "b"},
            {"kv_remote_settings_copy_text_without_markdown_syntax", "b"},
            {"kv_remote_settings_search_state_on_manually_created_chat", "s"},
            {"kv_remote_settings_search_state_on_automatically_created_chat", "s"},
            {"kv_remote_settings_should_use_sm_device_id", "b"},
            {"kv_remote_settings_dead_link_detection", "b"},
            {"kv_remote_settings_gcy_enabled", "b"},
            {"kv_remote_settings_ds_settings_enabled", "b"},
            {"kv_remote_settings_volcengine_enabled", "s"},
            {"kv_remote_settings_sm_pass_code_type", "s"},
            {"kv_remote_settings_edit_menu_item_config", "i"},
            {"kv_remote_settings_files_host", "s"},
            {"kv_remote_settings_sm_sdk_host", "s"},
            {"kv_remote_settings_android_apk_link", "s"},
            {"support_chat_file_exts", "s"},
            {"pow_header_paths", "s"},
            {"authed_pow_functions", "s"},
            {"image_cache_invalidate_before", "l"},
            {"camera_compress_ratio", "i"},
            {"photo_picker_compress_ratio", "i"},
            {"search_state_trigger", "s"},
            {"model_configs_v1", "s"},
            {"kv_remote_settings_tts_connect_timeout_ms", "i"},
            {"kv_remote_settings_tts_prebuffer_ms", "i"},
            {"kv_remote_settings_tts_resume_buffer_ms", "i"},
            {"kv_remote_settings_tts_resume_max_times", "i"},
            {"kv_remote_settings_tts_resume_max_time_ms", "i"},
            {"kv_remote_settings_tts_resume_interval_ms", "i"},
            {"kv_remote_settings_tts_underrun_timeout_ms", "i"},
            {"kv_remote_settings_thinking_auto_fold_enabled", "b"},
            {"report_http_failure_paths", "s"},
            {"alert", "s"},
            {"banner", "s"},
            {"kv_remote_settings_key_auto_tts_enabled", "b"},
            {"kv_remote_settings_key_tts_voice_id", "s"},
    };

    private static void copyFile(java.io.File src, java.io.File dst) throws Exception {
        java.io.FileInputStream in = new java.io.FileInputStream(src);
        java.io.FileOutputStream out = new java.io.FileOutputStream(dst);
        byte[] buf = new byte[65536];
        int n;
        while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
        in.close();
        out.close();
    }

    private static boolean asBool(Object o) {
        return o instanceof Boolean ? (Boolean) o
                : "true".equals(String.valueOf(o)) || "1".equals(String.valueOf(o));
    }

    private static int putBools(SharedPreferences.Editor ed, JSONObject o) {
        if (o == null) return 0;
        int n = 0;
        for (Iterator<String> it = o.keys(); it.hasNext(); ) {
            String k = it.next();
            ed.putBoolean(k, o.optBoolean(k, false));
            n++;
        }
        return n;
    }

    private static int putInts(SharedPreferences.Editor ed, JSONObject o) {
        if (o == null) return 0;
        int n = 0;
        for (Iterator<String> it = o.keys(); it.hasNext(); ) {
            String k = it.next();
            ed.putInt(k, o.optInt(k, 0));
            n++;
        }
        return n;
    }

    private static int putLongs(SharedPreferences.Editor ed, JSONObject o) {
        if (o == null) return 0;
        int n = 0;
        for (Iterator<String> it = o.keys(); it.hasNext(); ) {
            String k = it.next();
            ed.putLong(k, o.optLong(k, 0L));
            n++;
        }
        return n;
    }

    private static int putFloats(SharedPreferences.Editor ed, JSONObject o) {
        if (o == null) return 0;
        int n = 0;
        for (Iterator<String> it = o.keys(); it.hasNext(); ) {
            String k = it.next();
            ed.putFloat(k, (float) o.optDouble(k, 0d));
            n++;
        }
        return n;
    }

    private static int putStrings(SharedPreferences.Editor ed, JSONObject o) {
        if (o == null) return 0;
        int n = 0;
        for (Iterator<String> it = o.keys(); it.hasNext(); ) {
            String k = it.next();
            ed.putString(k, o.optString(k, ""));
            n++;
        }
        return n;
    }
}
