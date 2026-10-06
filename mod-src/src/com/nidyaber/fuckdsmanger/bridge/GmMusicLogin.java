// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmUtil;
import com.nidyaber.fuckdsmanger.music.GmMusicApi;
import com.nidyaber.fuckdsmanger.music.GmMusicJson;

import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.charset.Charset;
import java.util.Map;

/**
 * 网易云**登录态的存取** 🐲 —— 跑在宿主进程
 *
 * <p>为什么放宿主私有目录：登录凭证（`MUSIC_U`）是**敏感数据**。
 * 宿主私有目录（`/data/data/&lt;宿主&gt;/files/FDMmusic/login.json`）**只有宿主自己能读**，
 * 别的 App 拿不到（除非 root / 被备份出去）。
 *
 * <p>⚠️⚠️ **明文存储** —— 主人 2026-10-06 明确要求"告诉用户"：
 * 本文件是**明文的**（没有加密）。root 用户 / 拿到备份的人可以直接读到凭证，
 * 进而用你的账号。请自行注意隐私安全，别把它分享、别上传到任何地方。
 *
 * <p>照 {@code DSMlogs} 那个套路（宿主 files 子目录，adb/MT 一拉就能看）。
 */
public final class GmMusicLogin {

    private static final String DIR = "FDMmusic";
    private static final String FILE = "login.json";
    private static final Charset UTF8 = Charset.forName("UTF-8");

    /** 最近一次用到的 Context（异步验证昵称时要写文件，得有个 Context）。 */
    private static volatile Context sApp = null;

    public static void setApp(Context c) {
        if (c != null) sApp = c.getApplicationContext();
    }

    private GmMusicLogin() {
    }

    private static File dir(Context c) {
        File d = new File(c.getFilesDir(), DIR);
        if (!d.exists()) d.mkdirs();
        return d;
    }

    public static File file(Context c) {
        return new File(dir(c), FILE);
    }

    // ══════════════════════════════ 读 / 写 ══════════════════════════════

    /**
     * 存一份登录态（并立刻注入到 {@link GmMusicApi}，后续请求自动带上）。
     *
     * @param musicU 凭证（从登录响应的 Set-Cookie 里抠出来的）
     * @param uid    用户 id（可空）
     * @param nick   昵称（可空，仅用于界面显示）
     */
    /**
     * 上次操作的结果（给诊断用）—— 尼尼踩过的坑：`save()` 以前对**空凭证直接 return，
     * 连日志都不打** ⇒ 症状是"登录提示成功、实际什么都没发生"，查起来像见鬼。
     */
    private static volatile String sLastOp = "";

    public static String lastOp() {
        return sLastOp;
    }

    public static boolean save(Context c, String musicU, String uid, String nick) {
        if (c == null) {
            sLastOp = "失败：Context 为空";
            GmUtil.log("【MusicLogin】⚠️ 保存失败：Context 为空");
            return false;
        }
        setApp(c);
        if (musicU == null || musicU.length() == 0) {
            sLastOp = "失败：凭证是空的（UI 那边没抓到 MUSIC_U）";
            GmUtil.log("【MusicLogin】⚠️ 保存失败：**凭证是空的** —— "
                    + "多半是 Set-Cookie 里没抠到 MUSIC_U（登录没成功 / 接口变了）");
            return false;
        }
        try {
            JSONObject o = new JSONObject();
            o.put("musicU", musicU);
            o.put("uid", uid == null ? "" : uid);
            o.put("nick", nick == null ? "" : nick);
            o.put("at", System.currentTimeMillis());
            o.put("_warn", "⚠️ 本文件为【明文存储】，内含登录凭证（MUSIC_U）。"
                    + "请勿分享、勿上传；root 环境下请注意隐私安全。");
            FileOutputStream fo = new FileOutputStream(file(c));
            fo.write(o.toString(1).getBytes(UTF8));
            fo.flush();
            fo.close();

            GmMusicApi.setLogin(musicU);
            sLastOp = "成功：凭证 " + musicU.length() + " 字";
            GmUtil.log("【MusicLogin】✅ 已保存登录态（凭证 " + musicU.length() + " 字，uid=" + uid
                    + "）—— ⚠️ 明文存储于 " + file(c).getAbsolutePath());
            return true;
        } catch (Throwable t) {
            sLastOp = "失败：" + t;
            GmUtil.logFail("【MusicLogin】保存失败", t);
            return false;
        }
    }

    /** 只清登录态（删文件 + 清内存）。 */
    public static boolean clear(Context c) {
        try {
            if (c != null) {
                File f = file(c);
                if (f.exists()) f.delete();
            }
            GmMusicApi.setLogin("");
            GmUtil.log("【MusicLogin】已清除登录态");
            return true;
        } catch (Throwable t) {
            GmUtil.logFail("【MusicLogin】清除失败", t);
            return false;
        }
    }

    /**
     * 宿主起来时调一次：**从文件把登录态读出来注入**（这样重启宿主也还是登录状态）。
     */
    public static void apply(Context c) {
        if (c == null) return;
        setApp(c);
        try {
            File f = file(c);
            if (!f.isFile()) {
                GmUtil.log("【MusicLogin】没有登录文件（未登录）");
                return;
            }
            String txt = read(f);
            if (txt == null || txt.trim().length() == 0) return;
            JSONObject o = new JSONObject(txt);
            String mu = o.optString("musicU", "");
            if (mu.length() == 0) return;
            GmMusicApi.setLogin(mu);
            GmUtil.log("【MusicLogin】✅ 已从文件读回登录态（uid=" + o.optString("uid", "")
                    + " nick=" + o.optString("nick", "") + "）");

            // ★ 2026-10-06：异步**验证一次 + 补昵称**
            //   为什么：光看"内存里有凭证"不能说明服务端还认它；
            //   而且旧版本存的昵称是空的 ⇒ 界面只能显示"已登录 "（后面空着），
            //   主人分不清到底成了没。这里顺便把昵称/uid 补进文件。
            if (o.optString("nick", "").length() == 0) {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            Map<String, Object> r = GmMusicApi.loginStatus();
                            long code = r.get("code") instanceof Number
                                    ? ((Number) r.get("code")).longValue() : -1L;
                            if (code == 200) {
                                Object nick = r.get("nick");
                                // loginStatus 不解析 profile ⇒ 直接翻 raw
                                Map<String, Object> raw = GmMusicJson.asObj(r.get("raw"));
                                String nk = "";
                                String ui = "";
                                try {
                                    Map<String, Object> pf = GmMusicJson.sub(raw, "profile");
                                    if (pf != null) {
                                        nk = GmMusicJson.str(pf, "nickname", "");
                                        long u = GmMusicJson.lng(pf, "userId", 0);
                                        if (u > 0) ui = String.valueOf(u);
                                    }
                                } catch (Throwable ignore) {
                                }
                                GmUtil.log("【MusicLogin】凭证有效 ✓ 昵称=[" + nk + "] uid=[" + ui + "]");
                                if (nk.length() > 0 || ui.length() > 0) {
                                    GmMusicLogin.save(sApp, GmMusicApi.login(), ui, nk);
                                }
                            } else {
                                GmUtil.log("【MusicLogin】⚠️ 凭证可能已失效（code=" + code
                                        + " msg=" + r.get("msg") + "）");
                            }
                        } catch (Throwable t) {
                            GmUtil.log("【MusicLogin】验证凭证失败：" + t);
                        }
                    }
                }).start();
            }
        } catch (Throwable t) {
            GmUtil.logFail("【MusicLogin】读回登录态失败", t);
        }
    }

    /** 是否已登录。 */
    public static boolean loggedIn() {
        return GmMusicApi.hasLogin();
    }

    /** 给界面看的摘要（**不返回完整凭证** —— 只给前后各 4 位，避免日志/界面泄露）。 */
    public static String summary(Context c) {        try {
            File f = file(c);
            if (!f.isFile()) return "";
            String txt = read(f);
            if (txt == null) return "";
            JSONObject o = new JSONObject(txt);
            String nick = o.optString("nick", "");
            String uid = o.optString("uid", "");
            StringBuilder sb = new StringBuilder();
            if (nick.length() > 0) sb.append(nick);
            if (uid.length() > 0) {
                if (sb.length() > 0) sb.append(" · ");
                sb.append("uid=").append(uid);
            }
            return sb.toString();
        } catch (Throwable t) {
            return "";
        }
    }

    /**
     * 诊断字符串（真机排查用）—— 说清"到底存在哪一步"。
     * 不泄露凭证内容，只说长短。
     */
    public static String diag(Context c) {
        StringBuilder sb = new StringBuilder();
        try {
            File f = file(c);
            sb.append("文件：").append(f.isFile() ? ("有 " + f.length() + "B") : "无");
        } catch (Throwable t) {
            sb.append("文件：读失败");
        }
        try {
            String mu = GmMusicApi.login();
            sb.append("　内存：").append(mu == null ? 0 : mu.length()).append("字");
        } catch (Throwable t) {
            sb.append("　内存：读失败");
        }
        String op = sLastOp;
        if (op != null && op.length() > 0) {
            sb.append("　上次保存：").append(op);
        }
        return sb.toString();
    }

    private static String read(File f) {
        FileInputStream in = null;
        try {
            in = new FileInputStream(f);
            byte[] buf = new byte[(int) Math.min(f.length(), 1 << 20)];
            int n = in.read(buf);
            return n <= 0 ? "" : new String(buf, 0, n, UTF8);
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
