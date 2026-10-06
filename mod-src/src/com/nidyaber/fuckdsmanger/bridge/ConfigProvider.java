// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Binder;
import android.os.Bundle;
import android.os.Process;
import android.util.Log;

/**
 * 桥的【UI 侧端点】🐲
 *
 * 本类跑在**我们自己的进程**里（UI 层）。hook 层（跑在宿主进程里的 GmEntry/FdmBridge）
 * 用 `ContentResolver.call(content://<我们的包名>.config, method, null, extras)` 来跟它说话。
 *
 * 为什么必须这样：
 *   hook 层的 uid 是宿主的 uid，**读不到**我们 App 私有目录里的 SharedPreferences
 *   （Linux 权限就不允许）⇒ 只能走 Android 官方的跨进程通道。
 *
 * 安全：每个敏感方法都校验 `Binder.getCallingUid()`。
 *      ⚠️ 判据**不看调用者的包名**（铁律：模块功能不许依赖宿主包名 ——
 *      宿主清单包名已经从 `com.deepseek.chat` 变成过 `com.deepseek.chat.a`）。
 *      改成**握手令牌**：UI 进程生成一个随机 token，随 `CONFIG_PUSH` 广播交给 hook 层；
 *      hook 层调我们时把它放在 extras 里。token 对了才认，并且**认下第一个 uid 之后只认它**。
 */
public final class ConfigProvider extends ContentProvider {

    public static final String AUTHORITY_SUFFIX = ".config";

    /** 配置存在这里（UI 层自己的 SP）。 */
    public static final String PREFS = "fdm_ui";
    public static final String KEY_REV = "rev";
    public static final String KEY_JSON = "json";
    public static final String KEY_HOST_AT = "host_at";
    public static final String KEY_HOST_VER = "host_ver";
    public static final String KEY_APPLIED_REV = "applied_rev";
    /** 桥的握手令牌（UI 生成 → 随广播给 hook 层 → hook 层回调时带回来）。 */
    public static final String KEY_TOKEN = "bridge_token";
    /** 首次用**正确令牌**进来的 uid；认下之后只认它。 */
    public static final String KEY_TRUSTED_UID = "trusted_uid";

    private static final String TAG = "FdmConfig";

    public static Uri uriOf(Context ctx) {
        return Uri.parse("content://" + ctx.getPackageName() + AUTHORITY_SUFFIX);
    }

    /** 没有就造一个（32 位十六进制随机串）。UI 侧与 hook 侧共用同一个值。 */
    public static String ensureToken(Context ctx) {
        SharedPreferences sp = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        String t = sp.getString(KEY_TOKEN, null);
        if (t == null || t.isEmpty()) {
            t = java.util.UUID.randomUUID().toString().replace("-", "");
            sp.edit().putString(KEY_TOKEN, t).apply();
        }
        return t;
    }

    /**
     * 握手判据：**token + uid**，与包名无关。
     *
     * ① 自己进程 / root / system 直接放行（调试用）
     * ② 其余：extras 里必须带**我们发出去的那个 token**
     * ③ 认下第一个用对 token 的 uid 之后，必须是**同一个 uid**
     *    （token 万一被别的 app 嗅到，它也换不了 uid 来调）
     */
    private boolean callerAllowed(Bundle extras) {
        final int uid = Binder.getCallingUid();
        if (uid == Process.myUid()) return true;      // 自己进程（UI 自测）
        if (uid == 0 || uid == 1000) return true;     // root / system（调试用）
        Context ctx = getContext();
        if (ctx == null) return false;
        SharedPreferences sp = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        String mine = sp.getString(KEY_TOKEN, null);
        if (mine == null || mine.isEmpty()) return false;      // 还没发过令牌 ⇒ 谁都别进
        String given = extras == null ? null : extras.getString(KEY_TOKEN);
        if (!mine.equals(given)) return false;
        int trusted = sp.getInt(KEY_TRUSTED_UID, -1);
        if (trusted == -1) {
            sp.edit().putInt(KEY_TRUSTED_UID, uid).apply();
            Log.i(TAG, "trusted uid recorded = " + uid);
            return true;
        }
        return trusted == uid;
    }

    @Override
    public boolean onCreate() {
        Log.i(TAG, "ConfigProvider.onCreate ✅ authority="
                + (getContext() == null ? "?" : uriOf(getContext())));
        return true;
    }

    @Override
    public Bundle call(String method, String arg, Bundle extras) {
        Bundle out = new Bundle();
        if (!callerAllowed(extras)) {
            out.putBoolean("ok", false);
            out.putString("error", "caller not trusted: uid=" + Binder.getCallingUid());
            Log.w(TAG, "rejected " + method + " from uid=" + Binder.getCallingUid());
            return out;
        }

        Context ctx = getContext();
        if (ctx == null) {
            out.putBoolean("ok", false);
            out.putString("error", "no context");
            return out;
        }
        SharedPreferences sp = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE);

        if ("getConfig".equals(method)) {
            out.putBoolean("ok", true);
            out.putInt(KEY_REV, sp.getInt(KEY_REV, 0));
            out.putString(KEY_JSON, sp.getString(KEY_JSON, "{}"));
        } else if ("heartbeat".equals(method)) {
            sp.edit()
              .putLong(KEY_HOST_AT, System.currentTimeMillis())
              .putString(KEY_HOST_VER, extras == null ? "?" : extras.getString("version", "?"))
              .apply();
            out.putBoolean("ok", true);
        } else if ("applied".equals(method)) {
            int rev = extras == null ? -1 : extras.getInt(KEY_REV, -1);
            sp.edit().putInt(KEY_APPLIED_REV, rev).apply();
            out.putBoolean("ok", true);
            Log.i(TAG, "applied rev=" + rev);
        } else {
            out.putBoolean("ok", false);
            out.putString("error", "unknown method: " + method);
        }
        Log.i(TAG, "call " + method + " → " + out);
        return out;
    }

    // ---------- 其余 API 全是空壳：这个 provider 只走 call() ----------

    @Override
    public Cursor query(Uri uri, String[] projection, String sel, String[] selArgs, String sort) {
        return null;
    }

    @Override
    public String getType(Uri uri) {
        return null;
    }

    @Override
    public Uri insert(Uri uri, ContentValues values) {
        return null;
    }

    @Override
    public int delete(Uri uri, String sel, String[] selArgs) {
        return 0;
    }

    @Override
    public int update(Uri uri, ContentValues values, String sel, String[] selArgs) {
        return 0;
    }
}
