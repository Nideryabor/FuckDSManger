// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
//
// ═══════════════════════════════════════════════════════════════════════════
//  ⚠️ 致谢 / Attribution
//    接口路径、参数名、报文格式、请求头字段全部来自 **NeteaseCloudMusicApi**：
//      · 项目：https://github.com/Binaryify/NeteaseCloudMusicApi
//      · 作者：Binaryify   ·   许可：MIT   ·   版本：4.32.0
//    对应原文件：`util/request.js`（eapi 分支 + header/cookie 组装）、
//               `module/search.js` · `module/song_url_v1.js` · `module/song_detail.js`
//   感谢原作者及所有贡献者。
// ═══════════════════════════════════════════════════════════════════════════
//
//  ★ 同样**刻意不依赖任何 Android API**（纯 java.net / java.util）——
//    这样能在小窝里用 javac 编译 + 真发请求验证（已实测：搜索/播放地址全通）。
package com.nidyaber.fuckdsmanger.music;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

/** 网易云 API 客户端（eapi 通道，免登录即可用）—— NeteaseCloudMusicApi 的 Java 移植。 */
public final class GmMusicApi {

    private static final Charset UTF8 = Charset.forName("UTF-8");

    /** 接口域名（对应 util/config.json 的 APP_CONF.apiDomain）。 */
    public static final String API_DOMAIN = "https://interface.music.163.com";
    /** 网页域名（weapi 用；参考/致谢用）。 */
    public static final String DOMAIN = "https://music.163.com";

    /** eapi 的 os 参数与 UA —— 见上面「客户端伪装」段（三档一致：pc / android / iPhone）。 */

    /** 音质档位（song_url_v1 的 level）。 */
    public static final String L_STANDARD = "standard";
    public static final String L_HIGHER   = "higher";
    public static final String L_EXHIGH   = "exhigh";
    public static final String L_LOSSLESS = "lossless";

    // ══════════════════════════════ 客户端伪装 ══════════════════════════════
    //  2026-10-06 主人：「可能要伪装成客户端？」
    //  库里有三套 os 参数（osMap / userAgentMap），**要求 os 与 UA 一致**才像真客户端：
    //    pc      : os='pc'         UA=NeteaseMusicDesktop/3.0.18.203152 (Windows)
    //    android : os='android'    UA=NeteaseMusic/9.1.65…Dalvik (Android 14)
    //    iphone  : os='iPhone OS'  UA=NeteaseMusic 9.0.90/5038 (iPhone)
    //  尼尼原来写的是 os=pc + UA=iphone ⇒ **自相矛盾**，服务端可能因此降级处理。
    //  现在做成三档一致的，并且可以让用户在设置里切（哪档给完整版就用哪档）。
    public static final int OS_PC = 0;
    public static final int OS_ANDROID = 1;
    public static final int OS_IPHONE = 2;

    private static volatile int sOsMode = OS_IPHONE;   // 默认 iphone（库的默认 UA）

    public static void setOsMode(int m) {
        sOsMode = (m < 0 || m > 2) ? OS_IPHONE : m;
    }

    public static int osMode() {
        return sOsMode;
    }

    private static String osName() {
        switch (sOsMode) {
            case OS_PC:      return "pc";
            case OS_ANDROID: return "android";
            default:         return "iPhone OS";
        }
    }

    private static String osVer() {
        switch (sOsMode) {
            case OS_PC:      return "Microsoft-Windows-10-Professional-build-19045-64bit";
            case OS_ANDROID: return "14";
            default:         return "16.2";
        }
    }

    private static String osAppVer() {
        switch (sOsMode) {
            case OS_PC:      return "3.1.17.204416";
            case OS_ANDROID: return "8.20.20.231215173437";
            default:         return "9.0.90";
        }
    }

    private static String osChannel() {
        switch (sOsMode) {
            case OS_PC:      return "netease";
            case OS_ANDROID: return "xiaomi";
            default:         return "distribution";
        }
    }

    private static String osUa() {
        switch (sOsMode) {
            case OS_PC:
                return "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36"
                        + " (KHTML, like Gecko) Safari/537.36 Chrome/91.0.4472.164"
                        + " NeteaseMusicDesktop/3.0.18.203152";
            case OS_ANDROID:
                return "NeteaseMusic/9.1.65.240927161425(9001065);Dalvik/2.1.0"
                        + " (Linux; U; Android 14; 23013RK75C Build/UKQ1.230804.001)";
            default:
                return "NeteaseMusic 9.0.90/5038 (iPhone; iOS 16.2; zh_CN)";
        }
    }

    /** 日志出口 —— 默认不输出。由调用方注入（**绝不能**直接调 GmUtil：UI 进程没有 Xposed）。 */
    public interface Log {
        void d(String msg);

        void e(String msg, Throwable t);
    }

    private static volatile Log sLog = null;

    public static void setLog(Log l) {
        sLog = l;
    }

    private static void d(String m) {
        Log l = sLog;
        if (l != null) l.d(m);
    }

    private static void e(String m, Throwable t) {
        Log l = sLog;
        if (l != null) l.e(m, t);
    }

    /** 设备 ID：一次进程内固定（对应原库的 generateDeviceId / global.deviceId）。 */
    private static final String DEVICE_ID = UUID.randomUUID().toString().replace("-", "");
    private static final AtomicInteger SEQ = new AtomicInteger(1);

    /** 登录态（先留空；以后接登录就往这儿塞 MUSIC_U）。 */
    private static volatile String sMusicU = "";
    /** 匿名 token（对应原库的 anonymous_token；空串也能用，已实测）。 */
    private static volatile String sMusicA = "";

    public static void setLogin(String musicU) {
        sMusicU = musicU == null ? "" : musicU;
    }

    public static String login() {
        return sMusicU;
    }

    private GmMusicApi() {
    }

    // ══════════════════════════════ 底层 POST ══════════════════════════════

    /**
     * 走 eapi：POST 到 {@code API_DOMAIN/eapi/<uri 去掉 /api/ 前缀>}，body 是 {@code params=<HEX>}。
     *
     * @param uri 形如 {@code /api/search/get}（**带 /api 前缀**，加密时用它）
     * @return 解析后的 JSON（Map）
     */
    public static Map<String, Object> eapiPost(String uri, Map<String, Object> data) throws Exception {
        String json = GmMusicJson.write(data);
        String params = GmMusicCrypto.eapi(uri, json);
        long now = System.currentTimeMillis();
        String requestId = now + "_" + String.format("%04d", SEQ.getAndIncrement() % 10000);

        StringBuilder ck = new StringBuilder();
        ck.append("osver=").append(enc(osVer()));
        ck.append("; deviceId=").append(enc(DEVICE_ID));
        ck.append("; os=").append(enc(osName()));
        ck.append("; appver=").append(enc(osAppVer()));
        ck.append("; versioncode=140");
        ck.append("; mobilename=");
        ck.append("; buildver=").append(enc(String.valueOf(now).substring(0, 10)));
        ck.append("; resolution=1920x1080");
        ck.append("; __csrf=");
        ck.append("; channel=").append(enc(osChannel()));
        ck.append("; requestId=").append(enc(requestId));
        if (sMusicU != null && sMusicU.length() > 0) ck.append("; MUSIC_U=").append(enc(sMusicU));
        if (sMusicA != null && sMusicA.length() > 0) ck.append("; MUSIC_A=").append(enc(sMusicA));

        String tail = uri.startsWith("/api/") ? uri.substring(5) : uri;
        String url = API_DOMAIN + "/eapi/" + tail;

        String raw = post(url, "params=" + params,
                "application/x-www-form-urlencoded", ck.toString(), osUa());
        Map<String, Object> m = GmMusicJson.asObj(GmMusicJson.parse(raw));
        if (m == null) throw new IllegalStateException("响应不是 JSON：" + brief(raw));
        return m;
    }

    // ══════════════════════════════ weapi（登录用） ══════════════════════════════
    //  2026-10-06 加：登录（短信 / 密码 / 邮箱）走的是 **weapi**（不是 eapi）——
    //  见 NeteaseCloudMusicApi 的 `util/request.js` weapi 分支：
    //     POST https://music.163.com/weapi/<uri 去掉 /api/>
    //     body = params=<base64>&encSecKey=<hex>

    /** 保留上一次响应的 Set-Cookie（登录后要从中取 MUSIC_U）。 */
    private static volatile String sLastSetCookie = "";

    public static String lastSetCookie() {
        return sLastSetCookie;
    }

    /** 走 weapi：POST 到 {@code DOMAIN/weapi/<uri 去掉 /api/>}。 */
    public static Map<String, Object> weapiPost(String uri, Map<String, Object> data) throws Exception {
        String json = GmMusicJson.write(data);
        String[] p = GmMusicCrypto.weapi(json);
        String tail = uri.startsWith("/api/") ? uri.substring(5) : uri;
        String url = DOMAIN + "/weapi/" + tail;

        // weapi 的 UA（对应 userAgentMap.weapi.pc）
        String ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
                + " (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0";

        String cookie = "";
        if (sMusicU != null && sMusicU.length() > 0) cookie = "MUSIC_U=" + sMusicU + ";";
        if (sMusicA != null && sMusicA.length() > 0) cookie += " MUSIC_A=" + sMusicA + ";";

        String raw = post(url, "params=" + urlEnc(p[0]) + "&encSecKey=" + urlEnc(p[1]),
                "application/x-www-form-urlencoded", cookie, ua);
        Map<String, Object> m = GmMusicJson.asObj(GmMusicJson.parse(raw));
        if (m == null) throw new IllegalStateException("响应不是 JSON：" + brief(raw));
        return m;
    }

    private static String urlEnc(String s) {
        try {
            return URLEncoder.encode(s, "UTF-8");
        } catch (Throwable t) {
            return s;
        }
    }

    // ══════════════════════════════ 登录接口 ══════════════════════════════
    //  ⚠️ 2026-10-06 主人：「去掉二维码，换成手机或者 cookie 或者密码登录」

    /**
     * ① 发短信验证码。对应 {@code module/captcha_sent.js}（**weapi**）。
     *
     * @return {code, msg}
     */
    public static Map<String, Object> captchaSent(String phone, String ctcode) throws Exception {
        Map<String, Object> d = GmMusicJson.obj(
                "ctcode", ctcode == null || ctcode.length() == 0 ? "86" : ctcode,
                "secrete", "music_middleuser_pclogin",
                "cellphone", phone);
        Map<String, Object> r = weapiPost("/api/sms/captcha/sent", d);
        return result(r);
    }

    /**
     * ② 手机 **验证码** 登录。对应 {@code module/login_cellphone.js}。
     *
     * @return {code, msg, musicianU} —— musicianU 从 Set-Cookie 里抠出来
     */
    public static Map<String, Object> loginByCaptcha(String phone, String captcha, String ctcode)
            throws Exception {
        Map<String, Object> d = GmMusicJson.obj(
                "type", "1",
                "https", "true",
                "phone", phone,
                "countrycode", ctcode == null || ctcode.length() == 0 ? "86" : ctcode,
                "captcha", captcha,
                "remember", "true");
        Map<String, Object> r = weapiPost("/api/w/login/cellphone", d);
        return result(r);
    }

    /**
     * ③ 手机 **密码** 登录（同一接口，用 md5_password 代替 captcha）。
     */
    public static Map<String, Object> loginByPassword(String phone, String md5Password, String ctcode)
            throws Exception {
        Map<String, Object> d = GmMusicJson.obj(
                "type", "1",
                "https", "true",
                "phone", phone,
                "countrycode", ctcode == null || ctcode.length() == 0 ? "86" : ctcode,
                "password", md5Password,
                "remember", "true");
        Map<String, Object> r = weapiPost("/api/w/login/cellphone", d);
        return result(r);
    }

    /**
     * ④ **邮箱** 密码登录。对应 {@code module/login.js}。
     */
    public static Map<String, Object> loginByEmail(String email, String md5Password) throws Exception {
        Map<String, Object> d = GmMusicJson.obj(
                "type", "0",
                "https", "true",
                "username", email,
                "password", md5Password,
                "rememberLogin", "true");
        Map<String, Object> r = weapiPost("/api/w/login", d);
        return result(r);
    }

    /** ⑤ 查询登录状态。对应 {@code module/login_status.js}。 */
    public static Map<String, Object> loginStatus() throws Exception {
        Map<String, Object> r = weapiPost("/api/w/nuser/account/get", GmMusicJson.obj());
        return result(r);
    }

    /** ⑥ 刷新 token。对应 {@code module/login_refresh.js}。 */
    public static Map<String, Object> loginRefresh() throws Exception {
        Map<String, Object> r = weapiPost("/api/login/token/refresh", GmMusicJson.obj());
        return result(r);
    }

    /** 把响应整理成 {code, msg, musicU}。 */
    private static Map<String, Object> result(Map<String, Object> r) {
        Map<String, Object> o = new LinkedHashMap<String, Object>();
        o.put("code", GmMusicJson.lng(r, "code", -1));
        String msg = GmMusicJson.str(r, "message", "");
        if (msg.length() == 0) msg = GmMusicJson.str(r, "msg", "");
        o.put("msg", msg);
        // 从 Set-Cookie 里抠 MUSIC_U（登录成功才有）
        String ck = sLastSetCookie;
        String mu = pickCookie(ck, "MUSIC_U");
        o.put("musicU", mu);
        // ★ 2026-10-06：顺带把**昵称 / uid** 解析出来 —— 界面显示"已登录：某某"，
        //   主人一眼就能确认"登录到底生效了没有"，不用去猜。
        String nick = "";
        String uid = "";
        try {
            Map<String, Object> pf = GmMusicJson.sub(r, "profile");
            if (pf != null) {
                nick = GmMusicJson.str(pf, "nickname", "");
                long u = GmMusicJson.lng(pf, "userId", 0);
                if (u > 0) uid = String.valueOf(u);
            }
            if (uid.length() == 0) {
                Map<String, Object> ac = GmMusicJson.sub(r, "account");
                if (ac != null) {
                    long u = GmMusicJson.lng(ac, "id", 0);
                    if (u > 0) uid = String.valueOf(u);
                }
            }
        } catch (Throwable ignore) {
        }
        o.put("nick", nick);
        o.put("uid", uid);
        o.put("raw", r);
        return o;
    }

    /** 从 `a=1\nb=2` 里挑出某个 cookie 值（我们的 Set-Cookie 是**每条一行**累积的）。 */
    public static String pickCookie(String setCookie, String name) {
        if (setCookie == null || setCookie.length() == 0) return "";
        for (String line : setCookie.split("\n")) {
            for (String seg : line.split(";")) {
                String s = seg.trim();
                int i = s.indexOf('=');
                if (i <= 0) continue;
                if (name.equals(s.substring(0, i).trim())) return s.substring(i + 1).trim();
            }
        }
        return "";
    }

    /** 裸 POST（可复用：以后接登录/别的域名）。 */
    public static String post(String url, String body, String contentType,
                              String cookie, String ua) throws Exception {
        // ★ 2026-10-06 重要修复：**禁用自动重定向 + 手动跟随 + 每跳累积 Set-Cookie**。
        //   为什么：登录接口经常先回 **302**（`Set-Cookie: MUSIC_U=…` 就在那一跳上），
        //   而 HttpURLConnection 默认**自动跟随**重定向 ⇒ 我们只看到最终响应
        //   ⇒ **凭证抓不到**（症状：提示登录成功、其实什么都没存上）。
        StringBuilder collected = new StringBuilder();
        String cur = url;
        String method = "POST";
        String data = body == null ? "" : body;

        for (int hop = 0; hop < 5; hop++) {
            HttpURLConnection conn = null;
            try {
                conn = (HttpURLConnection) new URL(cur).openConnection();
                conn.setInstanceFollowRedirects(false);
                conn.setRequestMethod(method);
                conn.setConnectTimeout(15000);
                conn.setReadTimeout(20000);
                conn.setUseCaches(false);
                conn.setRequestProperty("Content-Type", contentType);
                if (cookie != null && cookie.length() > 0) conn.setRequestProperty("Cookie", cookie);
                if (ua != null && ua.length() > 0) conn.setRequestProperty("User-Agent", ua);
                conn.setRequestProperty("Referer", "https://music.163.com");

                if ("POST".equals(method)) {
                    byte[] b = data.getBytes(UTF8);
                    conn.setDoOutput(true);
                    conn.setFixedLengthStreamingMode(b.length);
                    OutputStream os = conn.getOutputStream();
                    os.write(b);
                    os.flush();
                    os.close();
                }

                int code = conn.getResponseCode();
                // ★ 每一跳都收 Set-Cookie
                try {
                    Map<String, List<String>> h = conn.getHeaderFields();
                    for (Map.Entry<String, List<String>> e : h.entrySet()) {
                        if (e.getKey() == null) continue;
                        if (!"set-cookie".equalsIgnoreCase(e.getKey())) continue;
                        List<String> vs = e.getValue();
                        if (vs == null) continue;
                        for (String v : vs) {
                            if (v == null || v.length() == 0) continue;
                            if (collected.length() > 0) collected.append('\n');
                            collected.append(v);
                        }
                    }
                } catch (Throwable ignore) {
                }

                if (code == 301 || code == 302 || code == 303 || code == 307 || code == 308) {
                    String loc = conn.getHeaderField("Location");
                    d("[MusicApi] 重定向 " + code + " → " + loc);
                    if (loc == null || loc.length() == 0) break;
                    cur = new URL(new URL(cur), loc).toString();
                    if (code == 303) method = "GET";     // 303 语义：改用 GET
                    continue;
                }

                InputStream in = code >= 400 ? conn.getErrorStream() : conn.getInputStream();
                String text = readAll(in);
                d("[MusicApi] " + method + " " + cur + " → " + code
                        + "，正文 " + text.length() + " 字，Set-Cookie " + collected.length() + " 字");
                sLastSetCookie = collected.toString();
                return text;
            } finally {
                if (conn != null) {
                    try {
                        conn.disconnect();
                    } catch (Throwable ignore) {
                    }
                }
            }
        }
        // 跳数用完还没拿到最终响应（或者重定向没 Location）⇒ 至少把收到的 cookie 留下
        sLastSetCookie = collected.toString();
        throw new IllegalStateException("重定向次数过多：" + url);
    }

    private static String readAll(InputStream in) throws Exception {
        if (in == null) return "";
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        byte[] buf = new byte[8192];
        int n;
        while ((n = in.read(buf)) > 0) bos.write(buf, 0, n);
        in.close();
        return new String(bos.toByteArray(), UTF8);
    }

    private static String enc(String s) {
        try {
            // encodeURIComponent 与 URLEncoder 只差一个空格编码，抹平它
            return URLEncoder.encode(s, "UTF-8").replace("+", "%20");
        } catch (Throwable t) {
            return s;
        }
    }

    private static String brief(String s) {
        if (s == null) return "null";
        return s.length() > 200 ? s.substring(0, 200) + "…" : s;
    }

    // ══════════════════════════════ 业务接口 ══════════════════════════════

    /**
     * 搜索单曲。对应 {@code module/search.js} → {@code /api/search/get}
     *
     * @return 歌曲列表（每项已归一化：id / name / artist / album / picUrl / duration）
     */
    public static List<Map<String, Object>> search(String keyword, int limit, int offset)
            throws Exception {
        Map<String, Object> data = GmMusicJson.obj(
                "s", keyword == null ? "" : keyword,
                "type", Integer.valueOf(1),          // 1 = 单曲
                "limit", Integer.valueOf(limit <= 0 ? 30 : limit),
                "offset", Integer.valueOf(offset < 0 ? 0 : offset));
        Map<String, Object> r = eapiPost("/api/search/get", data);
        d("[MusicApi] search code=" + GmMusicJson.lng(r, "code", -1));
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        List<Object> songs = GmMusicJson.arr(GmMusicJson.sub(r, "result"), "songs");
        if (songs == null) {
            // 极少数情况走 cloudsearch 的结构
            songs = GmMusicJson.arr(GmMusicJson.sub(r, "result"), "songs");
        }
        if (songs == null) return out;
        for (Object o : songs) {
            Map<String, Object> s = GmMusicJson.asObj(o);
            if (s == null) continue;
            out.add(normalize(s));
        }

        // ★★ 2026-10-06 真机 bug：**搜索接口不给封面！**
        //   实测 `/api/search/get` 的 `album` 里只有 `picId`，**没有 `picUrl`**
        //   （所以卡片上的封面一直是空的）。而 `/api/v3/song/detail` 给 `picUrl`。
        //   ⇒ 这里补一次：把缺封面的 id 凑成一批，一次 songDetail 全补齐。
        try {
            List<Long> need = new ArrayList<Long>();
            for (Map<String, Object> s : out) {
                String p = (String) s.get("picUrl");
                if (p == null || p.length() == 0) {
                    Object id = s.get("id");
                    if (id instanceof Number && ((Number) id).longValue() > 0) {
                        need.add(Long.valueOf(((Number) id).longValue()));
                    }
                }
            }
            if (!need.isEmpty()) {
                int filled = 0;
                for (Map<String, Object> d : songDetail(need)) {
                    Object ido = d.get("id");
                    String p = (String) d.get("picUrl");
                    if (ido == null || p == null || p.length() == 0) continue;
                    long id = ((Number) ido).longValue();
                    for (Map<String, Object> s : out) {
                        Object sid = s.get("id");
                        if (sid instanceof Number && ((Number) sid).longValue() == id
                                && (((String) s.get("picUrl")) == null
                                    || ((String) s.get("picUrl")).length() == 0)) {
                            s.put("picUrl", p);
                            filled++;
                        }
                    }
                }
                d("[MusicApi] 封面补齐 " + filled + "/" + need.size() + " 首（走 songDetail）");
            }
        } catch (Throwable t) {
            d("[MusicApi] 封面补齐失败（不影响播放）：" + t);
        }
        return out;
    }

    /** 把宿主的歌曲对象归一化成我们自己的一层（字段名跨接口/跨版本不一样，先摊平）。 */
    private static Map<String, Object> normalize(Map<String, Object> s) {
        Map<String, Object> o = new LinkedHashMap<String, Object>();
        o.put("id", GmMusicJson.lng(s, "id", 0));

        // 歌名：search 是 name，detail 是 name
        String name = GmMusicJson.str(s, "name", "");
        if (name.length() == 0) name = GmMusicJson.str(s, "title", "");
        o.put("name", name);

        // 歌手：search 是 ar[]，详情是 ar[]，老接口是 artists[]
        StringBuilder artist = new StringBuilder();
        List<Object> ar = GmMusicJson.arr(s, "ar");
        if (ar == null) ar = GmMusicJson.arr(s, "artists");
        if (ar != null) {
            for (Object a : ar) {
                String n = GmMusicJson.str(a, "name", "");
                if (n.length() > 0) {
                    if (artist.length() > 0) artist.append('/');
                    artist.append(n);
                }
            }
        }
        o.put("artist", artist.toString());

        // 专辑：al / album
        Map<String, Object> al = GmMusicJson.sub(s, "al");
        if (al == null) al = GmMusicJson.sub(s, "album");
        o.put("album", al == null ? "" : GmMusicJson.str(al, "name", ""));
        o.put("picUrl", al == null ? "" : GmMusicJson.str(al, "picUrl", ""));
        if (((String) o.get("picUrl")).length() == 0 && al != null) {
            o.put("picUrl", GmMusicJson.str(al, "blurPicUrl", ""));
        }

        // 时长：dt(毫秒) / duration(毫秒)
        long dt = GmMusicJson.lng(s, "dt", 0);
        if (dt <= 0) dt = GmMusicJson.lng(s, "duration", 0);
        o.put("duration", dt);

        // fee = 版权/收费标记（8/1 等），用于界面上标「VIP」
        o.put("fee", GmMusicJson.lng(s, "fee", 0));
        return o;
    }

    /**
     * 取播放地址（320k 免登录可拿，已实测）。对应 {@code module/song_url_v1.js}。
     *
     * @return {url, br, size, type, level, fee, trial} ；url 为空 = 这首拿不到（无版权/需会员）
     */
    public static Map<String, Object> songUrl(long id, String level) throws Exception {
        Map<String, Object> data = GmMusicJson.obj(
                "ids", "[" + id + "]",
                "level", level == null || level.length() == 0 ? L_EXHIGH : level,
                "encodeType", "flac");
        Map<String, Object> r = eapiPost("/api/song/enhance/player/url/v1", data);
        Map<String, Object> out = new LinkedHashMap<String, Object>();
        out.put("code", GmMusicJson.lng(r, "code", -1));
        List<Object> arr = GmMusicJson.arr(r, "data");
        if (arr != null && arr.size() > 0) {
            Map<String, Object> d0 = GmMusicJson.asObj(arr.get(0));
            if (d0 != null) {
                out.put("id", GmMusicJson.lng(d0, "id", id));
                out.put("url", GmMusicJson.str(d0, "url", ""));
                out.put("br", GmMusicJson.lng(d0, "br", 0));
                out.put("size", GmMusicJson.lng(d0, "size", 0));
                out.put("type", GmMusicJson.str(d0, "type", ""));
                out.put("level", GmMusicJson.str(d0, "level", ""));
                out.put("fee", GmMusicJson.lng(d0, "fee", 0));
                out.put("trial", GmMusicJson.str(d0, "freeTrialInfo", ""));
            }
        }
        if (!out.containsKey("url")) out.put("url", "");
        return out;
    }

    /** 歌曲详情（拿封面/时长/歌手）。对应 {@code /api/v3/song/detail}。 */
    public static List<Map<String, Object>> songDetail(List<Long> ids) throws Exception {
        StringBuilder c = new StringBuilder("[");
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) c.append(',');
            c.append("{\"id\":").append(ids.get(i)).append('}');
        }
        c.append(']');
        Map<String, Object> data = GmMusicJson.obj("c", c.toString());
        Map<String, Object> r = eapiPost("/api/v3/song/detail", data);
        List<Map<String, Object>> out = new ArrayList<Map<String, Object>>();
        List<Object> songs = GmMusicJson.arr(r, "songs");
        if (songs == null) return out;
        for (Object o : songs) {
            Map<String, Object> s = GmMusicJson.asObj(o);
            if (s != null) out.add(normalize(s));
        }
        return out;
    }

    /**
     * 歌词。对应 {@code /api/song/lyric}。
     *
     * @return {lrc, tlrc, code} —— lrc = 原文歌词（LRC 文本），tlrc = 译文（可能空）
     */
    public static Map<String, Object> lyric(long id) throws Exception {
        Map<String, Object> data = GmMusicJson.obj(
                "id", Long.valueOf(id),
                "lv", Integer.valueOf(-1),
                "kv", Integer.valueOf(-1),
                "tv", Integer.valueOf(-1));
        Map<String, Object> r = eapiPost("/api/song/lyric", data);
        Map<String, Object> out = new LinkedHashMap<String, Object>();
        out.put("code", GmMusicJson.lng(r, "code", -1));
        out.put("lrc", GmMusicJson.str(GmMusicJson.sub(r, "lrc"), "lyric", ""));
        out.put("tlrc", GmMusicJson.str(GmMusicJson.sub(r, "tlyric"), "lyric", ""));
        return out;
    }

    // ══════════════════════════════ 预留：登录 ══════════════════════════════
    //  ⚠️ 主人 2026-10-06：「先免登录，但把登录接口预留好」⇒ 这里只放**入口与说明**，
    //     真正实现留到下一版（登录涉及二维码/短信/cookie 导入整条链路）。
    //
    //  预留的三条路（都走 weapi）：
    //    ① 二维码登录： /api/login/qrcode/unikey  →  轮询 /api/login/qrcode/client/login
    //    ② 手机号+密码：/api/login/cellphone（需先 /api/sms/captcha/sent 验证）
    //    ③ cookie 导入：直接把 MUSIC_U 字符串塞进 GmMusicApi.setLogin()（**最省事**，
    //       从浏览器/别的客户端把 MUSIC_U cookie 抠出来即可）
    //
    //  拿到的 MUSIC_U 塞 setLogin() 之后，所有 eapi 请求会自动带上它（见 eapiPost 里那段）。

    /** 登录是否已就绪（界面上显示用）。 */
    public static boolean hasLogin() {
        return sMusicU != null && sMusicU.length() > 0;
    }

    /** 调试用：当前请求头里的 deviceId。 */
    public static String deviceId() {
        return DEVICE_ID;
    }
}
