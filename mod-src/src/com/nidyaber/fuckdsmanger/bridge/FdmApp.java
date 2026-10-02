package com.nidyaber.fuckdsmanger.bridge;

import android.app.Application;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.os.Build;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.Charset;

/**
 * 我们 App 进程的 Application 🐲
 *
 * 干两件事：
 *   ① **自证**：把 PackageManager 眼里的安装事实写下来（包/版本/声明的 provider 有没有、exported 是什么）
 *      —— `full.log` 是系统向、LSPosed 日志只收 XposedBridge，App 自己不打出来就没人看得见
 *   ② **桥的 UI 侧**：注册「宿主索要配置」和「宿主回执」两个监听，并在启动时推一次配置
 */
public final class FdmApp extends Application {

    private static final String TAG = "FDM-DIAG";

    @Override
    public void onCreate() {
        super.onCreate();

        StringBuilder sb = new StringBuilder();
        try {
            dump(sb);
        } catch (Throwable t) {
            sb.append("自检自己抛了异常：").append(t).append('\n');
        }
        Log.e(TAG, sb.toString());
        write(new File(getFilesDir(), "fdm-diag.txt"), sb);
        File ext = getExternalFilesDir(null);
        if (ext != null) write(new File(ext, "fdm-diag.txt"), sb);

        try {
            regReceivers(this);
            FdmPush.push(this);
        } catch (Throwable t) {
            Log.e(TAG, "桥初始化失败", t);
        }
    }

    private void regReceivers(Context ctx) {
        BroadcastReceiver req = new BroadcastReceiver() {
            @Override
            public void onReceive(Context c, Intent it) {
                Log.e(TAG, "宿主索要配置 ⇒ 推送");
                FdmPush.push(c);
            }
        };
        BroadcastReceiver ack = new BroadcastReceiver() {
            @Override
            public void onReceive(Context c, Intent it) {
                int rev = it == null ? -1 : it.getIntExtra("rev", -1);
                int cnt = it == null ? -1 : it.getIntExtra("count", -1);
                Log.e(TAG, "✅ 宿主回执：已应用 rev=" + rev + " 共 " + cnt + " 项");
                try {
                    FdmPush.sp(c).edit()
                            .putInt("applied_rev", rev)
                            .putLong("applied_at", System.currentTimeMillis())
                            .apply();
                } catch (Throwable ignore) {
                }
            }
        };
        // 宿主回读来的"真值"—— 界面要显示的就是它
        BroadcastReceiver state = new BroadcastReceiver() {
            @Override
            public void onReceive(Context c, Intent it) {
                String json = it == null ? null : it.getStringExtra("json");
                if (json != null) FdmPush.saveHostState(c, json);
            }
        };
        reg(ctx, req, FdmPush.ACTION_REQ);
        reg(ctx, ack, FdmPush.ACTION_APPLIED);
        reg(ctx, state, FdmPush.ACTION_STATE);
        // ★ 动作接收器**不能**挂在这里：本类是"我们 App"的 Application，
        //   宿主进程里根本不会实例化它 ⇒ 挂在这儿等于没人接（实测：点按钮没反应）。
        //   正确位置 = FdmBridge.installReceiver()（宿主侧）。
        if (FdmBridge.inHost(ctx)) {
            Log.e(TAG, "（宿主进程）动作接收器由 FdmBridge 负责 ✓");
        } else {
            Log.e(TAG, "本地进程（UI）：只监听回执/真值，不接动作 ✓");
        }
        // 把动作结果存下来给界面显示
        BroadcastReceiver result = new BroadcastReceiver() {
            @Override
            public void onReceive(Context c, Intent it) {
                String t = it == null ? null : it.getStringExtra("text");
                String cmd = it == null ? null : it.getStringExtra("cmd");
                String data = it == null ? null : it.getStringExtra("data");
                if (t != null) {
                    android.content.SharedPreferences.Editor ed = FdmPush.sp(c).edit()
                            .putString("last_result", t)
                            .putLong("last_result_at", System.currentTimeMillis());
                    // ★ 数据（灰度 JSON / 日志全文）存到 cmd.<动作名> 下，界面自己去取
                    if (data != null && cmd != null) ed.putString("cmd." + cmd, data);
                    // ★ cfg_put 的回执是结构化的 ⇒ 按 key 落到 cfg.<key>，让**那一行**去重绘
                    if (data != null && "cfg_put".equals(cmd)) {
                        try {
                            org.json.JSONObject o = new org.json.JSONObject(data);
                            String k = o.optString("key", "");
                            if (!k.isEmpty()) {
                                // ⚠️ 2026-10-01 修：**回执里没有 value 时不要写空**！
                                //    原来无条件 `putString("cfg."+k, optString("value",""))`，
                                //    回执缺 value 就把 `cfg.<key>` **抹成空字符串** ⇒
                                //    界面读到空 → 退回旧格式顶层键 → 显示**残留的老值**
                                //    （主人症状：「切回模块会变回 47 和 20」「浓度死活改不了」）。
                                String val = o.has("value") ? o.optString("value", "") : null;
                                if (val != null && !val.isEmpty()) {
                                    ed.putString("cfg." + k, val);
                                }
                                ed.putBoolean("cfg." + k + ".ok", o.optBoolean("ok", false));
                                ed.putLong("cfg." + k + ".at", System.currentTimeMillis());
                            }
                        } catch (Throwable ignore) {
                        }
                    }
                    ed.apply();
                    Log.e(TAG, "← 动作结果：" + t + (data != null ? "（数据 " + data.length() + " 字）" : ""));
                }
            }
        };
        reg(ctx, result, FdmPush.ACTION_RESULT);
        Log.e(TAG, "已注册「索要配置」「宿主回执」「宿主真值」（动作仅宿主持有）✓");
    }

    private static void reg(Context ctx, BroadcastReceiver r, String action) {
        IntentFilter f = new IntentFilter(action);
        if (Build.VERSION.SDK_INT >= 33) {
            ctx.registerReceiver(r, f, Context.RECEIVER_EXPORTED);
        } else {
            ctx.registerReceiver(r, f);
        }
    }

    private void dump(StringBuilder sb) throws Throwable {
        PackageManager pm = getPackageManager();
        String pkg = getPackageName();
        sb.append("=== FDM 自检（PackageManager 眼里的事实）===\n");
        sb.append("pkg        = ").append(pkg).append('\n');

        PackageInfo base = pm.getPackageInfo(pkg, 0);
        sb.append("version    = ").append(base.versionName).append(" (").append(base.versionCode).append(")\n");
        sb.append("apk        = ").append(getApplicationInfo().sourceDir).append('\n');
        try {
            sb.append("apkSize    = ").append(new File(getApplicationInfo().sourceDir).length()).append('\n');
        } catch (Throwable ignore) {
        }

        PackageInfo withProv = pm.getPackageInfo(pkg, PackageManager.GET_PROVIDERS);
        ProviderInfo[] provs = withProv.providers;
        sb.append("providers  = ").append(provs == null ? "null" : String.valueOf(provs.length)).append('\n');
        if (provs != null) {
            for (ProviderInfo p : provs) {
                sb.append("   · name=").append(p.name)
                        .append(" authority=").append(p.authority)
                        .append(" exported=").append(p.exported)
                        .append(" enabled=").append(p.enabled)
                        .append('\n');
            }
        }

        PackageInfo withAct = pm.getPackageInfo(pkg, PackageManager.GET_ACTIVITIES);
        sb.append("activities = ").append(withAct.activities == null ? "null" : String.valueOf(withAct.activities.length)).append('\n');
        if (withAct.activities != null) {
            for (android.content.pm.ActivityInfo a : withAct.activities) {
                sb.append("   · ").append(a.name).append('\n');
                sb.append("       exported=").append(a.exported)
                        .append(" enabled=").append(a.enabled)
                        .append(" labelRes=0x").append(Integer.toHexString(a.labelRes))
                        .append(" nonLocalizedLabel=").append(a.nonLocalizedLabel)
                        .append(" icon=0x").append(Integer.toHexString(a.icon))
                        .append('\n');
            }
        }

        // ★ 关键自证：**已安装的那份 AndroidManifest.xml 的 sha256**
        //   跟我出包时的清单对一下 —— 一样 ⇒ 清单没被改写，是平台解析不认；
        //   不一样 ⇒ 装的时候被谁改过。
        sb.append("清单sha256 = ").append(manifestHash(getApplicationInfo().sourceDir)).append('\n');

        File ext = getExternalFilesDir(null);
        sb.append("外部目录   = ").append(ext).append('\n');
        sb.append("配置(可选) = ").append(ext == null ? "?" : new File(ext, "fdm-config.json").getAbsolutePath()).append('\n');
        sb.append("==========================================\n");
    }

    private static String manifestHash(String apk) {
        java.util.zip.ZipFile zf = null;
        java.io.InputStream in = null;
        try {
            zf = new java.util.zip.ZipFile(apk);
            java.util.zip.ZipEntry ze = zf.getEntry("AndroidManifest.xml");
            if (ze == null) return "APK 里没有 AndroidManifest.xml";
            in = zf.getInputStream(ze);
            java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
            byte[] buf = new byte[8192];
            int n;
            while ((n = in.read(buf)) > 0) bos.write(buf, 0, n);
            byte[] all = bos.toByteArray();
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] h = md.digest(all);
            StringBuilder sb = new StringBuilder();
            for (byte b : h) {
                String s = Integer.toHexString(b & 0xff);
                if (s.length() == 1) sb.append('0');
                sb.append(s);
            }
            return all.length + " B  sha256=" + sb;
        } catch (Throwable t) {
            return "算不出：" + t;
        } finally {
            try {
                if (in != null) in.close();
            } catch (Throwable ignore) {
            }
            try {
                if (zf != null) zf.close();
            } catch (Throwable ignore) {
            }
        }
    }

    private static void write(File f, StringBuilder sb) {
        FileOutputStream out = null;
        try {
            out = new FileOutputStream(f, false);
            out.write(sb.toString().getBytes(Charset.forName("UTF-8")));
        } catch (Throwable ignore) {
        } finally {
            try {
                if (out != null) out.close();
            } catch (Throwable ignore) {
            }
        }
    }
}
