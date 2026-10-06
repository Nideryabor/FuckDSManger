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
import com.nidyaber.fuckdsmanger.gm.GmBubble;
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
        // ★ 2026-10-02：通话开关常驻。
        //   宿主每次冷启动补一次 model_configs 里的 "call_feature":{} ——
        //   哪怕被服务端下发覆盖，重启宿主也能自动补回（= 源头接管，教训 253）。
        //   由 GmCall.on(ctx) 自己判断开关，关着时这里是空转。
        try {
            GmCall.ensure(ctx);
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】GmCall.ensure 失败（不影响宿主）", t);
        }
    }

    /**
     * 把存储里的气泡开关**喂进底座的静态缓存**。
     *
     * <p>★ 2026-10-01 真凶（主人报「用户气泡颜色不生效」）：
     * <pre>
     *   GmBubble.uOn():
     *       if (!sURead) { sURead = true; return store.getBoolean("fuckds_ububble_on", true); }
     *       return sUOn;            // ← 第二次以后返回【静态缓存】sUOn，**默认 false**
     *   sUOn 只有 setUOn() 被调用过才更新 —— 而模块 UI 不一定推这个键
     *   ⇒ 第一次读对、之后全是 false ⇒ 用户气泡「拨了没反应」。
     * </pre>
     *
     * <p>修法：宿主一起来就用**存储里的真值**喂一次 setter（顺带把 sRead/sURead 置位）。
     * 键不存在时用底座自己的默认值（两个气泡开关默认都是<b>开</b>）。
     */
    private static void syncBubbleCache(Context ctx) {
        try {
            SharedPreferences sp = GmStore.get(ctx);
            if (sp == null) return;
            // ⚠️ 直接读 boolean，不走 read2 —— read2 的类型不符会**静默读回默认值**
            //    （底座桩里写明了这条铁律），拿错值再写回去就会把人家设置覆盖掉。
            boolean ub = sp.getBoolean("fuckds_ububble_on", true);
            boolean ab = sp.getBoolean("fuckds_bubble_on", true);

            Class<?> c = XposedHelpers.findClass(
                    "com.nidyaber.fuckdsmanger.gm.GmBubble",
                    FdmBridge.class.getClassLoader());
            // ★★ 只改【内存里的静态缓存】，**绝不碰存储、绝不调 setUOn/setOn** ★★
            //    为什么：setXxx() 除了写缓存还会**写存储** ——
            //    我们上次就是"读到一个错值 → 无条件写回去"，
            //    把主人开着的 AI 气泡覆盖成 false（主人报：「AI 气泡又出 bug，图片颜色都不行」）。
            XposedHelpers.setStaticBooleanField(c, "sUOn", ub);
            XposedHelpers.setStaticBooleanField(c, "sOn", ab);
            XposedHelpers.setStaticBooleanField(c, "sURead", true);
            XposedHelpers.setStaticBooleanField(c, "sRead", true);

            if (!sBubbleCacheLogged) {
                sBubbleCacheLogged = true;
                GmUtil.log("【FdmBridge】气泡开关内存缓存已对齐（只改内存，不写存储）：用户="
                        + ub + " AI=" + ab);
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】对齐气泡缓存失败（不影响其它）：" + t);
        }
    }

    private static volatile boolean sBubbleCacheLogged = false;

    private static void probe(Context ctx) throws Throwable {
        String hostPkg = ctx.getPackageName();

        // ★ 消掉 GmTouchHook 的异常噪声（2026-10-01 主人：「来都来了，GmTouchHook 给他干掉吧」）
        //
        //  现象：每次触摸都刷一条
        //      W/LSPosedFramework  Exception in hooker
        //        at ...GmTouchHook.beforeHookedMethod(Unknown Source:67)
        //  它是**预编译进底座 APK** 的钩子，要真删就得重建底座（工程量大、底座有 11 道自检，风险高）。
        //
        //  但看反编译出来的 smali：那条方法的**前一半没有 try/catch**，
        //  里面有两处 `GmProbe.sInst.setText(...)` —— 而它们**前面就有 null 检查**。
        //  ⇒ 把 sInst 置空，这两处直接被跳过；方法后半段的 UI 调用本来就有 catchall 兜着。
        //  副作用：探针不显示"按/放"了（那是调试用的，无所谓）。
        //  ⚠️ 试过一条"便宜刀"：把 GmProbe.sInst 置空，指望那两处 setText 被 null 检查跳过。
        //      **没用，已撤掉** —— 因为真正的异常发生在那之前的**读字段指令**上：
        //          IllegalAccessError: Field 'GmProbe.sInst' is inaccessible to class 'GmTouchHook'
        //          (declaration of 'GmTouchHook' appears in Anonymous-DexFile@…)
        //      ⇒ GmProbe 和 GmTouchHook 被分到了**不同的 dex/类加载器**，
        //        包级私有字段的跨包访问在**字节码层面**就抛，根本到不了 null 检查。
        //
        //  ⇒ 结论：**这个钩子早就死了**（从那条指令起就抛，后面的 sTouchOn/sTouchMs 全没执行），
        //    它现在唯一的贡献就是刷日志。**要真干掉它，只能改底座 smali 重建底座。**

        // ★ 对齐气泡开关的【内存缓存】（不写存储）——
        //   底座陷阱：`uOn()` 第一次读存储、之后返回静态缓存 sUOn（**默认 false**）
        //   ⇒ 用户气泡会「拨了不生效 / 干脆没了」。
        //   上次我用 setUOn/setOn 去修，结果它们会**写存储**，把一个错值覆盖进去 ⇒
        //   主人的 AI 气泡当场报废。这次只动内存。
        syncBubbleCache(ctx);

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

        // ★ 真凶日志（2026-10-01）：主人报「用户气泡颜色不生效」，查出来是**开关被改成了 false**
        //   但改它的人不明（UI 的 push 理论上只带 fuckds_ 前缀、且不带这个键）。
        //   ⇒ 谁把这两个气泡开关写成什么值，都记一笔，下次一看就知道。
        try {
            SharedPreferences spNow = GmStore.get(ctx);
            GmUtil.log("【FdmBridge】气泡开关现状：AI=" + GmStore.read2(ctx, "fuckds_bubble_on", "b")
                    + " 用户=" + GmStore.read2(ctx, "fuckds_ububble_on", "b")
                    + "（本次推送里的 bools 含 ububble_on=" + bools.has("fuckds_ububble_on")
                    + " / bubble_on=" + bools.has("fuckds_bubble_on") + "）");
        } catch (Throwable ignore) {
        }
        sGotConfig = true;

        // ★ 2026-09-30 · 液态玻璃：**整包推送**这条路也要刷新它。
        //   3.29.0 只挂了 cfg_put（单项改动）那条 ⇒ UI 走 CONFIG_PUSH 整体推时
        //   宿主侧的 GmGlassCfg 还是旧值（日志铁证：推送里 glass_on=true，宿主仍 on=false）。
        try {
            com.nidyaber.fuckdsmanger.glass.GmGlassInstall.refresh(ctx);
        } catch (Throwable ignore) {
        }

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
        // ★ 2026-10-02 修（Bug D）：`key_*` 是宿主的**本地键**（本来就不带 kv_ 前缀）——
        //   原样写就行。原来无脑拼成 `kv_settings_key_auto_tts_enabled` ⇒ 写错地方
        //   （靠 pin 表侥幸兜住，但不干净）。
        boolean bareKey = bare.startsWith("key_");
        String full = bareKey ? bare : "kv_remote_settings_" + bare;
        String loc = bareKey ? bare : "kv_settings_" + bare;

        // ★★★ 3.23.0 · 主通道：写宿主的【真实键】 ★★★
        //
        //   旧 UI 走的就是这条路（底座 `GmStore.write` ⇒ `ed.putXxx(真键)` ⇒ `ed.apply()`），
        //   宿主读自己的键当然读得到 ⇒ **立刻生效**。
        //
        //   影子键（`fuckds_pin_…`）是"另一条更优雅的路"，但它依赖底座的「读侧替换」，
        //   而那个钩子只挂在了 MMKV 的**写**方法（`q` = `encodeString`）上，
        //   宿主真正的读路径（`c/d/e/g/i/j/k` → 直连 native `decodeXxx`）**一个都没挂**
        //   ⇒ 影子键永远没人来取。详见 `专题/pin机制-为什么没生效.md`。
        //
        //   ① 先探「宿主本来用哪个键形」：
        //      `contains` 是 SharedPreferences 的**接口方法，R8 改不掉它的名字**，
        //      所以这个探针在任何宿主版本上都有效。
        //   ② 三个都不存在 ⇒ 默认落在 `kv_remote_settings_`（模块本来就管这一族）。
        // ★ 3.24.0 · 【本地覆盖层】才是正主
        //
        //   反编译宿主 `qa5.smali` 拿到的真实读取优先级：
        //     ① `kv_settings_<bare>`        ← 最高！有就直接返回（宿主的「本地覆盖层」）
        //     ② 内存 ConcurrentHashMap      ← 本次会话读过的值（所以要重启宿主）
        //     ③ `kv_remote_settings_<bare>` ← 服务器下发的缓存，最低
        //
        //   3.23.0 写的 key 探针把 ③ 排在前面，一探到存在就写那儿了
        //   ⇒ 永远被 ① 压住 ⇒ 这就是"怎么写都没效果"的原因。
        //
        //   现在：**主写 ①**（不存在就创建 —— 宿主用 `contains` 判断，创建即生效）。
        String realKey = loc;
        // 顺带把 ③ 也更新一份（万一还有别的读取路径直接看它）
        String cacheKey = full;

        // 备份原值 —— "全部恢复"就是靠它写回去
        // ★★ 2026-10-02 修（Bug A2 三件套）：
        //   ① 原用 `sp.getString(k)` 读 ⇒ int/bool/long/float 型**抛 ClassCastException**，
        //      被 catch 静默吞掉 ⇒ 35I + 26B = **61 个键从没备份上**。改用 anyValue()（不抛）。
        //   ② 原来无条件覆盖备份 ⇒ 改 3 次后备份是"第 2 次改的值"，**回不到最初**。
        //      改成"只在第一次改这个键时备份"。
        //   ③ 原来"空值/键不存在"就不备 ⇒ 恢复时无从判断，会留下残值。
        //      改成**总写**，用 BAK_NONE 哨兵表示"原本压根没这个键"。
        for (String k : new String[]{loc, full}) {
            try {
                if (sp.contains("fuckds_bak_" + k)) continue;              // ② 已备过就别动
                Object cur = anyValue(sp, k);
                sp.edit().putString("fuckds_bak_" + k,
                        cur == null ? BAK_NONE : String.valueOf(cur)).apply();  // ③
            } catch (Throwable ignore) {
            }
        }

        // ★★ 主写：本地覆盖层（最高优先级）
        //     底座按 type 选 putBoolean / putInt / putFloat / putLong / putString
        try {
            GmStore.write(ctx, realKey, val, type);   // ★ 参数顺序：值在前、类型在后（跟底座真身）
            GmUtil.log("【FdmBridge】✅ 已写宿主覆盖层 " + realKey
                    + " = " + val + "（type=" + type + "）");
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】写宿主覆盖层失败 " + realKey, t);
        }

        // 副写：缓存层（本来存在才动它，避免凭空多出无意义的键）
        try {
            if (sp.contains(cacheKey)) {
                GmStore.write(ctx, cacheKey, val, type);   // ★ 同上，值在前、类型在后
                GmUtil.log("【FdmBridge】✅ 已写宿主缓存层 " + cacheKey + " = " + val);
            }
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】写宿主缓存层失败 " + cacheKey, t);
        }
        // ★ 影子键：**三种键形都写一份**
        //   底座的读侧替换是"拿宿主读的 key 去查 pin 表" ⇒ 我们不知道宿主读哪个形式，
        //   那就三种全写（`kv_settings_` / `kv_remote_settings_` / 裸名）。
        //   2.5.2 实测：63 项走 kv_settings_ · 18 项走 kv_remote_settings_ · 2 项走裸名。
        try {
            sp.edit().putString("fuckds_pin_" + full, val)
              .putString("fuckds_pin_" + loc, val)
              .putString("fuckds_pin_" + bare, val)
              .apply();
        } catch (Throwable t) {
            GmUtil.logFail("【FdmBridge】写影子键失败（主通道已写真实键，不影响生效）", t);
        }
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
     * ★ 3.18.0：MMKV 的"时机"问题已经被 3.17.0 修好了，但**读出第二颗雷** ——
     *   宿主的存储是 MMKV，它把 `getAll()` 实现成**故意抛异常**：
     *
     *       java.lang.UnsupportedOperationException:
     *         Intentionally Not Supported. Use allKeys() instead,
     *         getAll() not implement because type-erasure inside mmkv
     *
     *   ⇒ 读键一律走 {@link #allKeysOf(SharedPreferences)}
     *     （先反射 MMKV 自己的 allKeys()，不是 MMKV 才退回 getAll()）。
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
            java.util.List<String> ks = allKeysOf(sp);
            GmUtil.log("【FdmBridge】syncPins：宿主存储里共 " + ks.size() + " 个键，开始筛 fuckds_pin_");
            for (String k : ks) {
                if (k == null || !k.startsWith("fuckds_pin_")) continue;
                String v = sp.getString(k, null);   // 影子键全是 putString 写的
                if (v == null) continue;
                m.put(k.substring("fuckds_pin_".length()), v);
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
     * 列出宿主存储里的**所有键**。
     *
     * ★ 绝不能直接用 `getAll()`：宿主的存储是 MMKV，它把 `getAll()` 实现成
     *   **故意抛异常**（因为 mmkv 内部做了类型擦除，怕你按 Map 取值踩类型）：
     *
     *       UnsupportedOperationException:
     *         "Intentionally Not Supported. Use allKeys() instead,
     *          getAll() not implement because type-erasure inside mmkv"
     *
     *   （3.17.0 真机就死在这一步：MMKV 时机修好了、pin 表也注册上了，
     *     结果卡在**读键**上 ⇒ 表始终是空的 ⇒ 永远不可能命中。）
     *
     *   所以分两步走：
     *     ① 反射试 MMKV 自己的 `allKeys()`（返回 String[]）
     *     ② 不是 MMKV（普通 SharedPreferences）⇒ 老老实实 `getAll()`
     */
    static java.util.List<String> allKeysOf(SharedPreferences sp) {
        if (sp == null) {
            GmUtil.log("【FdmBridge】allKeysOf：sp == null");
            return java.util.Collections.emptyList();
        }

        // ①' ★★★ 真身在这里 ★★★
        //     反编译宿主（R8 过）看到的 MMKV 是这样的：
        //         .field  private final nativeHandle:J
        //         .method private native allKeys(JZ)[Ljava/lang/String;
        //
        //     · native 方法**改不了名**（JNI 按名字绑定）⇒ 它一直叫 allKeys，没被混淆
        //     · 但它被 R8 从 public 压成了 **private**
        //     · 而 MMKV 原本那个 `public String[] allKeys()`（无参包装）因为
        //       全类**没有任何调用点**（只剩 getAll() 里那句字符串常量提到它），
        //       被 R8 **整段删掉了**
        //     ⇒ 所以 getMethod("allKeys") / getMethods() 全找不到它。
        //     只能 getDeclaredMethod 把 private 挖出来。
        try {
            java.lang.reflect.Field hf = findNativeHandle(sp.getClass());
            if (hf == null) {
                GmUtil.log("【FdmBridge】allKeysOf：找不到 nativeHandle 字段");
            } else {
                long handle = hf.getLong(sp);
                java.lang.reflect.Method am = sp.getClass()
                        .getDeclaredMethod("allKeys", long.class, boolean.class);
                am.setAccessible(true);
                Object r = am.invoke(sp, Long.valueOf(handle), Boolean.TRUE);
                java.util.List<String> out = asStrList(r);
                if (out != null) {
                    GmUtil.log("【FdmBridge】allKeysOf：走 private allKeys(handle, true) ⇒ "
                            + out.size() + " 个键"
                            + (out.isEmpty() ? "" : " · 例：" + sample(out)));
                    return out;
                }
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】allKeysOf：private allKeys 这条路不通 ⇒ " + t);
        }

        // ① MMKV：优先按名字找 allKeys()
        java.lang.reflect.Method m = null;
        try {
            m = sp.getClass().getMethod("allKeys");
        } catch (Throwable ignore) {
            // 名字找不到 ⇒ 走 ② 按签名找
        }

        java.lang.reflect.Method[] ms;
        try {
            ms = sp.getClass().getMethods();
        } catch (Throwable t) {
            ms = new java.lang.reflect.Method[0];
            GmUtil.log("【FdmBridge】allKeysOf：getMethods() 失败 ⇒ " + t);
        }

        // ② ★ 按【签名】捞（宿主跑过 R8，MMKV 的 allKeys 被改名了）
        //    · SharedPreferences 的接口方法不能改名 ⇒ getAll() 还点得到、还会报那句话
        //    · allKeys 是普通方法 ⇒ 名字被换掉了，但**签名换不掉**
        if (m == null) {
            // ②a 无参 → String[]
            for (java.lang.reflect.Method m2 : ms) {
                if (m2.getParameterTypes().length != 0) continue;
                if (m2.getReturnType() != String[].class) continue;
                if (java.lang.reflect.Modifier.isStatic(m2.getModifiers())) continue;
                m = m2; break;
            }
        }
        if (m == null) {
            // ②b 一个 int/long 参数 → String[]（MMKV 的 allKeys(int flags)）⇒ 直接喂 0
            for (java.lang.reflect.Method m2 : ms) {
                Class<?>[] ps = m2.getParameterTypes();
                if (ps.length != 1 || m2.getReturnType() != String[].class) continue;
                if (java.lang.reflect.Modifier.isStatic(m2.getModifiers())) continue;
                if (ps[0] != int.class && ps[0] != long.class) continue;
                try {
                    Object r = m2.invoke(sp, ps[0] == int.class
                            ? (Object) Integer.valueOf(0) : (Object) Long.valueOf(0L));
                    java.util.List<String> out = asStrList(r);
                    if (out != null) {
                        GmUtil.log("【FdmBridge】allKeysOf：走 " + sig(m2) + " ⇒ " + out.size() + " 个键"
                                + (out.isEmpty() ? "" : " · 例：" + sample(out)));
                        return out;
                    }
                } catch (Throwable t) {
                    GmUtil.log("【FdmBridge】allKeysOf：试 " + sig(m2) + " 失败 ⇒ " + t);
                }
            }
        }

        // ②c 还找不到 ⇒ 把候选方法全摊开（给下一轮定位）
        if (m == null) {
            GmUtil.log("【FdmBridge】allKeysOf：MMKV 公开方法共 " + ms.length + " 个 · 返回 String[] 的：");
            int c = 0;
            for (java.lang.reflect.Method m2 : ms) {
                if (m2.getReturnType() != String[].class) continue;
                GmUtil.log("     · " + sig(m2));
                c++;
            }
            if (c == 0) GmUtil.log("     ·（一个都没有）");
            GmUtil.log("【FdmBridge】allKeysOf：无参 · 返回 String/Collection/Map 的：");
            c = 0;
            for (java.lang.reflect.Method m2 : ms) {
                if (m2.getParameterTypes().length != 0) continue;
                Class<?> rt = m2.getReturnType();
                if (rt == String.class
                        || java.util.Collection.class.isAssignableFrom(rt)
                        || java.util.Map.class.isAssignableFrom(rt)) {
                    GmUtil.log("     · " + sig(m2));
                    c++;
                }
            }
            if (c == 0) GmUtil.log("     ·（一个都没有）");
        }

        if (m != null) {
            try {
                Object r = m.invoke(sp);
                java.util.List<String> out = asStrList(r);
                if (out != null) {
                    GmUtil.log("【FdmBridge】allKeysOf：走 " + m.getName() + "() ⇒ " + out.size() + " 个键"
                            + (out.isEmpty() ? "" : " · 例：" + sample(out)));
                    return out;
                }
            } catch (Throwable t) {
                GmUtil.log("【FdmBridge】allKeysOf：调用 " + m.getName() + "() 失败 ⇒ " + t);
            }
        }

        // ③ 普通 SharedPreferences
        try {
            java.util.Map<String, ?> all = sp.getAll();
            if (all != null) {
                GmUtil.log("【FdmBridge】allKeysOf：走 getAll() ⇒ " + all.size() + " 个键");
                return new java.util.ArrayList<String>(all.keySet());
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】allKeysOf：getAll() 也不可用 ⇒ " + t);
        }

        GmUtil.log("【FdmBridge】allKeysOf：⚠️ 三条路都不通，返回空表");
        return java.util.Collections.emptyList();
    }

    /** 把 allKeys() 的返回值（String[] / Object[] / Collection）转成 List&lt;String&gt;；类型不认识返回 null。 */
    private static java.util.List<String> asStrList(Object r) {
        java.util.List<String> out = new java.util.ArrayList<String>();
        if (r instanceof String[]) {
            for (String k : (String[]) r) if (k != null) out.add(k);
            return out;
        }
        if (r instanceof Object[]) {
            for (Object k : (Object[]) r) if (k != null) out.add(String.valueOf(k));
            return out;
        }
        if (r instanceof java.util.Collection) {
            for (Object k : (java.util.Collection<?>) r) if (k != null) out.add(String.valueOf(k));
            return out;
        }
        return null;
    }

    /** 取样几个键名，只用于日志。 */
    private static String sample(java.util.List<String> ks) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ks.size() && i < 4; i++) {
            if (i > 0) sb.append(" | ");
            sb.append(ks.get(i));
        }
        return sb.toString();
    }

    /**
     * 把宿主存储 dump 成文本（界面里的「DS DATA · 服务器下发」那一块）。
     *
     * ★★★ 不能用底座的 `GmStore.dumpAll()` ★★★
     *   它是这么写的（反编译所见）：先 `callMethod(sp, "allKeys")`（空参 —— 宿主里的
     *   `allKeys` 是 `private native allKeys(long, boolean)`，点不到、抛），
     *   然后退回 `sp.getAll()` —— MMKV 把它实现成**故意抛异常**。
     *   ⇒ **这条路的产物永远是空的**（界面里 DS DATA 一片空白就是这个原因）。
     *
     *   这里改走桥自己那条**已经真机验通**的路：private native `allKeys(handle, true)`。
     */
    private static String dumpHostStore(Context ctx) {
        StringBuilder sb = new StringBuilder();
        try {
            SharedPreferences sp = GmStore.get(ctx);
            if (sp == null) return "（宿主存储还没就绪）\n";

            java.util.List<String> ks = allKeysOf(sp);
            // 排序输出，跟界面上的阅读习惯一致
            java.util.TreeSet<String> sorted = new java.util.TreeSet<String>(ks);

            int nAll = 0, nOut = 0;
            StringBuilder body = new StringBuilder();
            for (String k : sorted) {
                if (k == null) continue;
                if (k.startsWith("fuckds_pin_") || k.startsWith("fuckds_bak_")) continue; // 我们自己的影子/备份，不混进来
                nAll++;
                String v;
                try {
                    v = sp.getString(k, null);   // getString 是 SharedPreferences 接口方法，R8 改不掉名
                } catch (Throwable t) {
                    v = null;
                }
                if (v == null) continue;         // 非字符串类型的键（bool/int/…）在这里取不到，跳过
                if (v.length() > 500) v = v.substring(0, 500) + "…（共 " + v.length() + " 字）";
                body.append(k).append(" = ").append(v).append('\n');
                nOut++;
            }
            sb.append("宿主存储共 ").append(ks.size()).append(" 个键")
              .append("，其中字符串型 ").append(nOut).append(" 条（已排除 fuckds_pin_/fuckds_bak_）\n")
              .append("----\n").append(body);
        } catch (Throwable t) {
            sb.append("(DS DATA 读取失败：").append(t).append(")\n");
        }
        return sb.toString();
    }

    /** 把反射方法排成可读签名：返回值 名字(参数…)。 */
    private static String sig(java.lang.reflect.Method m) {
        StringBuilder sb = new StringBuilder();
        sb.append(m.getReturnType().getSimpleName()).append(' ').append(m.getName()).append('(');
        Class<?>[] ps = m.getParameterTypes();
        for (int i = 0; i < ps.length; i++) {
            if (i > 0) sb.append(", ");
            sb.append(ps[i].getSimpleName());
        }
        sb.append(')');
        return sb.toString();
    }

    /**
     * 找 MMKV 里那个存 native 指针的 long 实例字段。
     *
     * 反编译宿主看到它叫 `nativeHandle`（没被混淆）；
     * 万一哪天改了名，就退而求其次找「唯一的 long 实例字段」；
     * 若不止一个 long 字段（不敢猜哪个是），返回 null。
     */
    private static java.lang.reflect.Field findNativeHandle(Class<?> c) {
        try {
            java.lang.reflect.Field f = c.getDeclaredField("nativeHandle");
            f.setAccessible(true);
            return f;
        } catch (Throwable ignore) {
            // 名字变了 ⇒ 按类型猜
        }
        java.lang.reflect.Field cand = null;
        for (java.lang.reflect.Field f : c.getDeclaredFields()) {
            if (f.getType() != long.class) continue;
            if (java.lang.reflect.Modifier.isStatic(f.getModifiers())) continue;
            if (cand != null) return null;   // 多个 long ⇒ 不猜
            cand = f;
        }
        if (cand != null) cand.setAccessible(true);
        return cand;
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

    /** ★ 2026-09-30：把招呼语的 JSON（{"messages":[{id,text}…]}）摊成"每行一条"给界面。 */
    private static String helloLines(Context ctx) {
        try {
            String raw = null;
            try {
                Object v = callGm(GM + "GmHello", "get",
                        new Class<?>[]{Context.class}, new Object[]{ctx});
                if (v != null) raw = String.valueOf(v);
            } catch (Throwable t) {
                GmUtil.log("【FdmBridge】helloLines get 失败：" + t);
            }
            if (raw == null || raw.trim().isEmpty()) {
                // 兜底：直接读宿主那个键（免得 GmHello.get 因某些原因拿不到）
                Object v2 = callGm(GM + "GmStore", "read2",
                        new Class<?>[]{Context.class, String.class, String.class},
                        new Object[]{ctx, "kv_remote_settings_welcome_msg", "s"});
                if (v2 != null) raw = String.valueOf(v2);
                GmUtil.log("【FdmBridge】helloLines 兜底：raw=" + (raw == null ? "null" : raw.length() + " 字"));
            }
            if (raw == null) return "";
            org.json.JSONArray arr = new org.json.JSONObject(String.valueOf(raw)).optJSONArray("messages");
            if (arr == null) return "";
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < arr.length(); i++) {
                org.json.JSONObject jo = arr.optJSONObject(i);
                String t = jo == null ? "" : jo.optString("text", "");
                if (t.isEmpty()) continue;
                if (sb.length() > 0) sb.append("\n");
                sb.append(t);
            }
            return sb.toString();
        } catch (Throwable t) {
            return "";
        }
    }

    /** ★ 2026-09-30：提示词 JSON（[{id,scene,content}…]）→ "场景|内容" 每行一条。 */
    private static String promptLines(Context ctx) {
        try {
            Object v = callGm(GM + "GmPrompt", "get",
                    new Class<?>[]{Context.class}, new Object[]{ctx});
            if (v == null) return "";
            org.json.JSONArray arr = new org.json.JSONArray(String.valueOf(v));
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < arr.length(); i++) {
                org.json.JSONObject jo = arr.optJSONObject(i);
                if (jo == null) continue;
                String sc = jo.optString("scene", "");
                String ct = jo.optString("content", "");
                if (ct.isEmpty()) continue;
                if (sb.length() > 0) sb.append("\n");
                sb.append(sc).append("|").append(ct);
            }
            return sb.toString();
        } catch (Throwable t) {
            return "";
        }
    }

    /**
     * ★ 2026-09-30：把"真换行"和"字面 \n"都当行分隔。
     *   为什么要两种：UI 的老手写 JSON 解析器不还原转义 ⇒ 用户保存回去的就是 `\n` 两个字符的一坨；
     *   这里做一次归一化，历史脏数据也能自愈。
     */
    private static java.util.List<String> splitLines(String s) {
        java.util.List<String> out = new java.util.ArrayList<String>();
        for (String line : String.valueOf(s).split("\\r?\\n|\\\\n")) {
            if (!line.trim().isEmpty()) out.add(line.trim());
        }
        return out;
    }

    /** 把行拼回"真换行"的文本（存储形态）。 */
    private static String joinLines(java.util.List<String> lines) {
        StringBuilder sb = new StringBuilder();
        for (String ln : lines) {
            if (sb.length() > 0) sb.append("\n");
            sb.append(ln);
        }
        return sb.toString();
    }

    /**
     * ★ 2026-09-30：文本键 → 模块自己的入口（**老 UI 的存法**）。
     *
     * 为什么不能裸写存储：招呼语的存储值是 `{"messages":[{"id":0,"text":"…"}]}`、
     * 提示词是 `[{"id":0,"scene":"…","content":"…"}]` —— 都要用 `build(List<String[]>)` 组装。
     * 而 UI 以前发的类型是 `i`（整数）⇒ `Integer.parseInt("你好")` 抛异常 ⇒ 一个字都写不进去。
     */
    private static boolean dispatchText(Context ctx, String key, String val) {
        try {
            if ("fuckds_welcome_msg".equals(key)) {
                java.util.List<String> lines = splitLines(val);
                // ★ 2026-09-30：**尽量沿用原条目的 id** —— 宿主是按 id 分时段挑招呼语的
                //   （默认 8 条：早上/白天/深夜各几条），随便重新编号会让它挑不到 ⇒ 回落到默认。
                java.util.List<Integer> ids = new java.util.ArrayList<Integer>();
                try {
                    Object cur = callGm(GM + "GmHello", "get",
                            new Class<?>[]{Context.class}, new Object[]{ctx});
                    org.json.JSONArray arr = cur == null ? null
                            : new org.json.JSONObject(String.valueOf(cur)).optJSONArray("messages");
                    if (arr != null) {
                        for (int i = 0; i < arr.length(); i++) {
                            org.json.JSONObject jo = arr.optJSONObject(i);
                            if (jo != null) ids.add(jo.optInt("id", i));
                        }
                    }
                } catch (Throwable ignore) {
                }
                java.util.List<String[]> rows = new java.util.ArrayList<>();
                for (int i = 0; i < lines.size(); i++) {
                    int id = i < ids.size() ? ids.get(i) : i;
                    rows.add(new String[]{String.valueOf(id), lines.get(i)});
                }
                String json = (String) callGm(GM + "GmHello", "build",
                        new Class<?>[]{java.util.List.class}, new Object[]{rows});
                callGm(GM + "GmHello", "put", new Class<?>[]{Context.class, String.class},
                        new Object[]{ctx, json});
                callGm(GM + "GmHello", "apply", new Class<?>[]{Context.class, String.class},
                        new Object[]{ctx, json});
                GmUtil.log("【FdmBridge】招呼语 → build+put+apply（" + rows.size() + " 条）");
                return true;
            }
            if ("fuckds_suggest_text".equals(key)) {
                callGm(GM + "GmSuggest", "setText", new Class<?>[]{Context.class, String.class},
                        new Object[]{ctx, joinLines(splitLines(val))});
                GmUtil.log("【FdmBridge】回复建议 → GmSuggest.setText（已归一化换行，"
                        + splitLines(val).size() + " 条）");
                return true;
            }
            if ("fuckds_prompt_feature".equals(key)) {
                java.util.List<String[]> rows = new java.util.ArrayList<>();
                int id = 0;
                for (String line : splitLines(val)) {
                    String[] seg = line.split("\\|", -1);
                    if (seg.length < 2) continue;
                    rows.add(new String[]{String.valueOf(id++), seg[0], seg[1]});
                }
                String json = (String) callGm(GM + "GmPrompt", "build",
                        new Class<?>[]{java.util.List.class}, new Object[]{rows});
                callGm(GM + "GmPrompt", "put", new Class<?>[]{Context.class, String.class},
                        new Object[]{ctx, json});
                callGm(GM + "GmPrompt", "apply", new Class<?>[]{Context.class}, new Object[]{ctx});
                GmUtil.log("【FdmBridge】提示词内容 → build+put+apply（" + rows.size() + " 条）");
                return true;
            }
        } catch (Throwable t) {
            GmUtil.log("【FdmBridge】dispatchText " + key + " 失败（退回裸写）：" + t);
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
                } else if (!isDecodableImage(src)) {
                    // ★ 2026-09-30：**先验源图能不能解码**（只读文件头，不耗内存）。
                    //   实测踩过：中继文件是一坨 4041 字节的 0 ⇒ 写进去以后宿主解不出图
                    //   ⇒ 头像那条链直接崩（VectorDrawable→BitmapDrawable 强转）。
                    back = "源图不可解码（" + src.length() + " 字节 ⇒ 空文件/云图/坏图）⇒ 没有改动任何文件";
                    GmUtil.log("【FdmBridge】" + back);
                } else if ("bubble".equals(kind) || "ububble".equals(kind) || "bg".equals(kind)
                        || "avatar".equals(kind) || "uavatar".equals(kind)) {
                    // ★ 2026-09-30 修：图片**直接按字节拷进模块自己的 internal 文件**。
                    //   不再走 saveImage：它用 ContentResolver.openInputStream()/loadThumbnail()，
                    //   而 file:// URI 没有 content provider ⇒ FileNotFoundException: No content provider
                    //   （症状：选了图没反应 / 背景退回渐变 / 甚至写错文件把别的功能覆盖掉）
                    try {
                        if ("bg".equals(kind)) {
                            java.io.File dst = new java.io.File(ctx.getFilesDir(), "fuckds_bg.png");
                            copyFile(src, dst);
                            callGm(GM + "GmBg", "setOn",
                                    new Class<?>[]{Context.class, boolean.class}, new Object[]{ctx, true});
                            callGm(GM + "GmBg", "setMode",
                                    new Class<?>[]{Context.class, int.class}, new Object[]{ctx, 0});
                            back = "背景图已就地写入 " + dst.getAbsolutePath() + "（" + dst.length()
                                    + " 字节）· 已开背景 + 切「图片」档";
                        } else if ("avatar".equals(kind) || "uavatar".equals(kind)) {
                            // ★ 头像也改直拷：老路 GmAvatar.saveImage 在 file:// 下会"返回 true 但写出坏文件"
                            String cls = "avatar".equals(kind) ? "GmAvatar" : "GmUAvatar";
                            Object f = callGm(GM + cls, "file",
                                    new Class<?>[]{Context.class}, new Object[]{ctx});
                            if (f instanceof java.io.File) {
                                copyFile(src, (java.io.File) f);
                                callGm(GM + cls, "setOn",
                                        new Class<?>[]{Context.class, boolean.class},
                                        new Object[]{ctx, true});
                                back = "头像图已就地写入 " + ((java.io.File) f).getAbsolutePath()
                                        + "（" + ((java.io.File) f).length() + " 字节）";
                            } else {
                                back = cls + ".file() 拿不到目标文件 ⇒ 未写入";
                            }
                        } else {
                            String name = "ububble".equals(kind) ? "fuckds_ububble.png" : "fuckds_bubble.png";
                            java.io.File dst = new java.io.File(ctx.getFilesDir(), name);
                            copyFile(src, dst);
                            clearBubbleCache();
                            try {
                                callGm(GM + "GmBubble", "ububble".equals(kind) ? "setUImgOn" : "setImgOn",
                                        new Class<?>[]{Context.class, boolean.class}, new Object[]{ctx, true});
                            } catch (Throwable ignore) {
                            }
                            back = "气泡图已就地写入 " + dst.getAbsolutePath() + "（" + dst.length() + " 字节）";
                        }
                    } catch (Throwable t) {
                        back = "图片直拷失败：" + t;
                    }
                    GmUtil.log("【FdmBridge】" + back);
                } else {
                    // ★ 优先交给**模块自己的 saveImage**：它才知道内部路径和原文件名 ✅
                    //   （主人明确要求落到 /data/user/0/<宿主>/files/ 下的原文件名 ✅）
                    // ★ 选图前先把 sImgName 设对 —— saveImage()/imgBrush() 都看这个全局字段，
                    //   不设的话「给 AI 选图」会被上一个用过的值带跑（实测：写进 fuckds_ububble.png）。
                    try {
                        Class<?> gb = XposedHelpers.findClass(GM + "GmBubble",
                                FdmBridge.class.getClassLoader());
                        if ("ububble".equals(kind)) {
                            XposedHelpers.callStaticMethod(gb, "useUImgName");
                        } else if ("bubble".equals(kind)) {
                            XposedHelpers.setStaticObjectField(gb, "sImgName", "fuckds_bubble.png");
                        }
                    } catch (Throwable ignore) {
                    }
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
                } else if ("bubble".equals(kind) || "ububble".equals(kind)) {
                    // ★ 同上：分块路径也直拷（原来是 Uri.fromFile + saveImage ⇒ 必然 FileNotFoundException）
                    String name = "ububble".equals(kind) ? "fuckds_ububble.png" : "fuckds_bubble.png";
                    java.io.File dst = new java.io.File(ctx.getFilesDir(), name);
                    copyFile(src, dst);
                    clearBubbleCache();
                    target = dst.getAbsolutePath();
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
                back = "已写 " + bare + " = " + val + "（原值已备份 · 已直接写入宿主真实键）";
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
            } else if ("glass_snap".equals(cmd)) {
                // ★ 调试用：让宿主把自己当前画面写进自己的 files 目录
                //   （外面用 root 拉出来 —— 绕过"截不到宿主前台"的老大难）
                //   用法：am broadcast -a …CMD --es cmd glass_snap
                try {
                    Class<?> dbg = XposedHelpers.findClass(
                            "com.nidyaber.fuckdsmanger.glass.GmDebug",
                            FdmBridge.class.getClassLoader());
                    Object on = XposedHelpers.getStaticObjectField(dbg, "ENABLED");
                    if (Boolean.FALSE.equals(on)) {
                        back = "自拍功能未收录（这是正式包）";
                    } else {
                        com.nidyaber.fuckdsmanger.glass.GmGlassInstall.snap();
                        back = "已触发自拍，稍后看 【GmGlass】自拍 OK";
                    }
                } catch (Throwable t) {
                    back = "自拍失败 " + t;
                }
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
                // ★ 2026-09-30：文本类键（招呼语/回复建议/提示词）也走**模块自己的入口** ——
                //   它们的值不是"裸文本"（招呼语/提示词要 build 成 JSON），老 UI 就是这么存的。
                if (!viaSetting && "s".equals(type)) {
                    viaSetting = dispatchText(ctx, key, val);
                }
                if (!viaSetting) {
                    try {
                        GmStore.bak(ctx, key, type);
                        GmStore.write(ctx, key, val, type);
                    } catch (Throwable t) {
                        GmUtil.log("【FdmBridge】cfg_put 写存储失败 " + key + "：" + t);
                    }
                }
                // ★ 2026-09-30 · 液态玻璃：玻璃是【每帧现画】的，改完不用重启宿主，
                //   下一帧就是新样子 ⇒ 这里直接刷一遍配置 + 重截底图。
                try {
                    if (key != null && key.startsWith("fuckds_glass_")) {
                        com.nidyaber.fuckdsmanger.glass.GmGlassInstall.refresh(ctx);
                    }
                } catch (Throwable ignore) {
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
                // ★ 2026-09-30：这三项也要能"读出来"（原来没报 ⇒ 界面上永远是空框）
                try { o.put("welcome", helloLines(ctx)); } catch (Throwable ignore) { }
                try { o.put("suggest_text", callGm("com.nidyaber.fuckdsmanger.gm.GmSuggest", "text",
                        new Class<?>[]{Context.class}, new Object[]{ctx})); } catch (Throwable ignore) { }
                try { o.put("prompt", promptLines(ctx)); } catch (Throwable ignore) { }
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
            } else if ("hello_reset".equals(cmd)) {
                // ★ 2026-09-30：UI 一直有这个动作，但桥里没人接 ⇒ 点了没反应。
                //   restore = 从备份键还原（那一刻宿主的真值）；reapply = 推回宿主。
                callGm(GM + "GmHello", "restore", new Class<?>[]{Context.class}, new Object[]{ctx});
                Object r = callGm(GM + "GmHello", "reapply", new Class<?>[]{Context.class}, new Object[]{ctx});
                back = "招呼语已恢复默认（从备份还原）· reapply=" + r;
            } else if ("suggest_reset".equals(cmd)) {
                callGm(GM + "GmSuggest", "restore", new Class<?>[]{Context.class}, new Object[]{ctx});
                back = "回复建议已恢复默认";
            } else if ("rich_spec".equals(cmd)) {
                // ★ AI 气泡富文本：把「格式约定」灌进系统提示词。
                //   模型不会凭空知道我们自定义了一套标记 ⇒ 不告诉它，它永远只吐普通 markdown
                //   ⇒ 功能看上去"没效果"。这一步就是把这个坑堵上。
                //   ⚠️ **追加，不覆盖**（GmRichText.mergeSpec 里是 cur + "\n\n" + add），且幂等。
                back = com.nidyaber.fuckdsmanger.gm.GmRichText.mergeIntoSystemPrompt();
            } else if ("suggest_spec".equals(cmd)) {
                // ★ 回复建议：把「追问建议（<Suggestion>）」约定灌进系统提示词。
                //   同一个道理 —— 不告诉模型，它永远不会写这个标记。
                //   与 rich_spec 各灌各的（两段约定互相独立），同样是**追加 + 幂等**。
                back = com.nidyaber.fuckdsmanger.gm.GmRichText.mergeSuggestIntoSystemPrompt();
            } else if ("specs_clear".equals(cmd)) {
                // ★ 清空灌入的约定（回答排版 + 追问建议两段一起摘）。
                //   按段落摘 —— 你自己写的提示词一个字都不动。
                back = com.nidyaber.fuckdsmanger.gm.GmRichText.removeSpecs();
            } else if ("rich_demo".equals(cmd)) {
                // 一键灌开箱示例模板（主人改乱了想重来的时候用）
                com.nidyaber.fuckdsmanger.gm.GmStore.write(ctx,
                        com.nidyaber.fuckdsmanger.gm.GmRichText.K_TPLS,
                        com.nidyaber.fuckdsmanger.gm.GmRichText.DEMO_TPLS, "s");
                back = "已灌入开箱示例模板（"
                        + com.nidyaber.fuckdsmanger.gm.GmRichText.names().size() + " 条）";
            } else if ("prompt_reset".equals(cmd)) {
                callGm(GM + "GmPrompt", "restore", new Class<?>[]{Context.class}, new Object[]{ctx});
                callGm(GM + "GmPrompt", "apply", new Class<?>[]{Context.class}, new Object[]{ctx});
                back = "提示词内容已恢复默认";
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
                // ★★ 2026-10-02 重写（Bug A1）：
                //   旧写法只撤 `fuckds_pin_*` 影子键，注释还写着「原值就没被动过」——
                //   可 `grayWrite` 从 3.24.0 起**主写的是宿主真实键**（`kv_settings_<bare>`）
                //   ⇒ 真实键的改动永远回不去，这个按钮等于**假的**。
                //   现在三件事一起做：① 撤影子键 ② 把备份写回真实键 ③ 清内存 pin 表。
                SharedPreferences sp = GmStore.get(ctx);
                SharedPreferences.Editor ed = sp.edit();
                int n = 0;
                int rest = 0;
                for (String[] g : GRAY) {
                    String bare = g[0].startsWith("kv_remote_settings_")
                            ? g[0].substring("kv_remote_settings_".length()) : g[0];
                    String type = g.length > 1 ? g[1] : "s";
                    boolean bareKey = bare.startsWith("key_");        // 宿主本地键（不带前缀）
                    // ① 撤影子键（三种键形都撤）
                    ed.remove("fuckds_pin_kv_remote_settings_" + bare);
                    ed.remove("fuckds_pin_kv_settings_" + bare);
                    ed.remove("fuckds_pin_" + bare);
                    // ② 还原真实键（从备份；**没备过就跳过** —— 绝不动手）
                    //    ⚠️ 备份恒是**字符串**（grayWrite 存的就是 String）⇒ getString 安全；
                    //    「原本压根没这个键」用 BAK_NONE 哨兵表示 ⇒ 这里 remove 回去
                    for (String real : bareKey ? new String[]{bare}
                            : new String[]{"kv_settings_" + bare, "kv_remote_settings_" + bare}) {
                        String bak = sp.getString("fuckds_bak_" + real, null);
                        if (bak == null) continue;
                        try {
                            if (BAK_NONE.equals(bak)) {
                                GmStore.remove(ctx, real);            // 原本没有 ⇒ 删回去
                            } else {
                                // ★ 参数顺序：键 → 值 → 类型（跟底座真身一致）
                                GmStore.write(ctx, real, bak, type);
                            }
                            rest++;
                        } catch (Throwable ignore) {
                        }
                    }
                    n++;
                }
                ed.apply();
                // ③ 清空内存 pin 表（否则底座的读侧替换还活着）
                try {
                    java.util.HashMap<String, String> m = pins();
                    m.clear();
                } catch (Throwable ignore) {
                }
                back = "已恢复灰度 " + n + " 项：撤影 " + n + " · 还原真值 " + rest;
            } else if ("call_state".equals(cmd)) {
                // ★ 通话开关（宿主 2.6.1）：ModelConfig.call_feature 空标记对象
                //   返回 "开关|已生效"，例如 "1|1"
                lastData = GmCall.state(ctx);
                back = "通话开关：" + lastData;
            } else if ("call_set".equals(cmd)) {
                boolean want = "1".equals(String.valueOf(arg));
                GmCall.setOn(ctx, want);
                lastData = GmCall.state(ctx);
                back = "通话功能已" + (want ? "开启" : "关闭") + "（" + lastData + "）";
            } else if ("call_pin_state".equals(cmd)) {
                // ★ 通话页留驻（2026-10-02）：hook CallPageViewModel.a() → 强制 true
                lastData = GmCallPin.state(ctx);
                back = "通话页留驻：" + lastData;
            } else if ("call_pin_set".equals(cmd)) {
                boolean want = "1".equals(String.valueOf(arg));
                GmCallPin.setOn(ctx, want);
                lastData = GmCallPin.state(ctx);
                back = "通话页留驻已" + (want ? "开启" : "关闭") + "（" + lastData + "）";
            } else if ("dump_text".equals(cmd)) {
                StringBuilder sb = new StringBuilder();
                try {
                    sb.append("===== DIAG =====\n").append(GmDiag.text());
                } catch (Throwable t2) {
                    sb.append("(DIAG 读取失败：").append(t2).append(")\n");
                }
                try {
                    sb.append("\n===== DS DATA（服务器下发）=====\n").append(dumpHostStore(ctx));
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
    /** 备份哨兵：表示「原本压根没有这个键」—— 恢复时要 `remove` 回去，而不是写空串
     *  （宿主大量用 `contains` 判断，留个空串等于留了个"存在但空"的坑）。 */
    private static final String BAK_NONE = "\u0000__gm_none__";

    private static final String[][] GRAY = {
            // ★ 2026-10-02 新增：语音输入的**真闸门**
            //   宿主 `pn5.<init>` 是这么判的：
            //       voiceAvailable = MMKV.d("key_voice_available", ★false★)
            //       if (contains("kv_settings_voice_input_enabled")) voiceInput = MMKV.c(那个键)
            //   ⇒ **两个都要真**麦克风才出来；而 `key_voice_available` 默认 **false**（从没被设过）
            //   ⇒ "只在设置里开了语音输入"是不够的（主人实测踩到）。
            //   注意它是**裸键**（不带 kv_ 前缀）—— `grayWrite` 对 `key_` 开头的不加前缀。
            {"key_voice_available", "b"},
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

    /** ★ 2026-09-30：只读文件头，判断"这是不是一张能解码的图"（零内存代价）。 */
    private static boolean isDecodableImage(java.io.File f) {
        try {
            android.graphics.BitmapFactory.Options o = new android.graphics.BitmapFactory.Options();
            o.inJustDecodeBounds = true;
            android.graphics.BitmapFactory.decodeFile(f.getAbsolutePath(), o);
            return o.outWidth > 0 && o.outHeight > 0;
        } catch (Throwable t) {
            return false;
        }
    }

    /** ★ 2026-09-30：图片文件被重写 ⇒ 把模块的"原图解码缓存"清掉（否则还是旧图）。 */
    private static void clearBubbleCache() {
        try {
            Class<?> gb = XposedHelpers.findClass(GM + "GmBubble",
                    FdmBridge.class.getClassLoader());
            XposedHelpers.setStaticObjectField(gb, "sBmpCache", null);
        } catch (Throwable ignore) {
        }
    }

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
