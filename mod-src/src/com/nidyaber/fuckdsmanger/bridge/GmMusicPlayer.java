// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
//
//  ⚠️ 致谢：接口与加密来自 NeteaseCloudMusicApi（作者 Binaryify，MIT）——
//     见同包 music/GmMusicApi.java、music/GmMusicCrypto.java 的文件头。
//
//  ══════════════════════════════════════════════════════════════════════════
//  版权声明（2026-10-06 主人明确要求，务必遵守）
//
//   * **音频**：只在 `MediaPlayer` 里**流式播放** CDN 链接 —— **永不下载、永不落盘**
//   * **封面**：由宿主自己联网取回，**只放内存**（`sCoverCache`）—— **永不落盘**
//   * **歌词**：由宿主自己联网取回，**只放内存**（`sLyricCache`）—— **永不落盘**
//   * **状态文件**：`files/FDMmusic/state.json` 里**只有事实性元数据**
//     （id / 歌名 / 歌手 / 进度 / 时长 / 播放态 / 循环 / 队列下标）
//     —— 不含任何受版权保护的内容
//  ══════════════════════════════════════════════════════════════════════════
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.AudioAttributes;
import android.media.MediaPlayer;
import android.os.Handler;
import android.os.Looper;

import com.nidyaber.fuckdsmanger.gm.GmUtil;
import com.nidyaber.fuckdsmanger.music.GmMusicApi;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 音乐播放器 🐲 —— **跑在宿主进程里**（2026-10-06 主人拍板：播放交给宿主）
 *
 * <p>为什么搬进宿主（相比之前跑在模块进程）：
 * <ul>
 *   <li>「从最近任务里划掉模块」不再影响播放（宿主进程不受牵连）</li>
 *   <li>迷你卡跟播放器**同一个进程** ⇒ 状态零延迟、直接读内存，不用广播</li>
 *   <li>宿主自己有网络权限，封面/歌词都由它自己拉</li>
 * </ul>
 *
 * <p>代价（主人已知并接受）：<b>没有通知栏播放控制</b>（宿主清单改不了，声明不了前台服务）；
 * <b>划掉 DeepSeek 就停</b>（宿主进程没了）。
 */
public final class GmMusicPlayer {

    public static final String TAG = "FDM-Music";

    public static final int LOOP_LIST = 0;
    public static final int LOOP_ONE = 1;
    public static final int LOOP_SHUFFLE = 2;

    public static final String DEF_LEVEL = "exhigh";     // 320k（免登录实测可拿）

    // ══════════════════════════════ 数据 ══════════════════════════════

    /** 一首歌（只装**事实性信息**：id/名字/歌手/专辑/时长 —— 没有封面没有音频）。 */
    public static final class Track {
        public final long id;
        public final String name;
        public final String artist;
        public final String album;
        public final long dur;

        public Track(long id, String name, String artist, String album, long dur) {
            this.id = id;
            this.name = name == null ? "" : name;
            this.artist = artist == null ? "" : artist;
            this.album = album == null ? "" : album;
            this.dur = dur;
        }

        public JSONObject toJson() {
            JSONObject o = new JSONObject();
            try {
                o.put("id", id);
                o.put("name", name);
                o.put("artist", artist);
                o.put("album", album);
                o.put("dur", dur);
            } catch (Throwable ignore) {
            }
            return o;
        }
    }

    /** 给界面看的快照。 */
    public static final class State {
        public Track track;
        public boolean playing;
        public boolean preparing;
        public String error;
        public int loop = LOOP_LIST;
        public int index = -1;
        public int queueSize;
        public int pos;
        public int dur;
        public String level = DEF_LEVEL;
    }

    public interface Listener {
        void onState(State s);
    }

    /** 通用回调（主线程）。 */
    public interface Cb<T> {
        void on(T v);
    }

    // ══════════════════════════════ 单例 ══════════════════════════════

    private static volatile GmMusicPlayer sInst;
    private static volatile Context sApp;

    public static GmMusicPlayer get() {
        return sInst;
    }

    /** 宿主起来了就调一次（幂等）。 */
    public static void install(Context ctx) {
        if (ctx == null) return;
        sApp = ctx.getApplicationContext();
        if (sInst != null) {
            applyOsMode(ctx);
            return;
        }
        synchronized (GmMusicPlayer.class) {
            if (sInst != null) return;
            try {
                GmMusicApi.setLog(new GmMusicApi.Log() {
                    @Override
                    public void d(String msg) {
                        GmUtil.log("【Music】" + msg);
                    }

                    @Override
                    public void e(String msg, Throwable t) {
                        GmUtil.logFail("【Music】" + msg, t);
                    }
                });
            } catch (Throwable ignore) {
            }
            sInst = new GmMusicPlayer();
            applyOsMode(sApp);
            GmUtil.log("【Music】播放器已就绪（宿主进程）");
        }
    }

    /** ★ 2026-10-06 · 客户端伪装：从配置读「伪装成」哪一档（pc / android / iPhone）。 */
    private static void applyOsMode(Context c) {
        try {
            int m = GmMiniBar.loadInt("fuckds_music_os", GmMusicApi.OS_IPHONE);
            GmMusicApi.setOsMode(m);
        } catch (Throwable ignore) {
        }
    }

    // ══════════════════════════════ 实例 ══════════════════════════════

    private MediaPlayer mp;
    private final ExecutorService io = Executors.newSingleThreadExecutor();
    private final Handler ui = new Handler(Looper.getMainLooper());

    private final List<Track> queue = new ArrayList<Track>();
    private int index = -1;
    private int loop = LOOP_LIST;
    private String level = DEF_LEVEL;
    private boolean preparing;
    private String error;

    /** 界面监听（迷你卡）。 */
    private volatile Listener listener;

    /** 封面/歌词：**只在内存**（版权要求，绝不落盘）。 */
    private static final Map<Long, Bitmap> sCoverCache = new HashMap<Long, Bitmap>();
    private static final Map<Long, String> sLyricCache = new HashMap<Long, String>();

    private long posTickAt = 0;

    private GmMusicPlayer() {
        // 500ms 心跳：把进度推给界面（界面上歌词要高亮、进度条要动）
        ui.post(new Runnable() {
            @Override
            public void run() {
                try {
                    if (mp != null) notifyState();
                } catch (Throwable ignore) {
                }
                ui.postDelayed(this, 500);
            }
        });
    }

    public void setListener(Listener l) {
        listener = l;
    }

    // ══════════════════════════════ 对外操作 ══════════════════════════════

    public State state() {
        State s = new State();
        s.track = index >= 0 && index < queue.size() ? queue.get(index) : null;
        s.playing = isPlaying();
        s.preparing = preparing;
        s.error = error;
        s.loop = loop;
        s.index = index;
        s.queueSize = queue.size();
        s.pos = position();
        s.dur = duration();
        s.level = level;
        return s;
    }

    public List<Track> queue() {
        return new ArrayList<Track>(queue);
    }

    /** 点歌即播（插队）。 */
    public void play(Track t) {
        if (t == null) return;
        int ex = -1;
        for (int i = 0; i < queue.size(); i++) {
            if (queue.get(i).id == t.id) {
                ex = i;
                break;
            }
        }
        if (ex >= 0) index = ex;
        else {
            queue.add(t);
            index = queue.size() - 1;
        }
        startCurrent();
    }

    /** 加到队列末尾（不打断当前）。 */
    public void enqueue(Track t) {
        if (t == null) return;
        for (Track x : queue) if (x.id == t.id) return;
        queue.add(t);
        notifyState();
        saveState();
    }

    public void playAt(int i) {
        if (i < 0 || i >= queue.size()) return;
        index = i;
        startCurrent();
    }

    public void removeAt(int i) {
        if (i < 0 || i >= queue.size()) return;
        queue.remove(i);
        if (i < index) index--;
        if (i == index) {
            if (queue.isEmpty()) {
                stop();
                index = -1;
            } else {
                if (index >= queue.size()) index = 0;
                if (index < 0) index = 0;
                startCurrent();
            }
        }
        notifyState();
        saveState();
    }

    public void clearQueue() {
        stop();
        queue.clear();
        index = -1;
        notifyState();
        saveState();
    }

    public void toggle() {
        if (mp == null) {
            if (!queue.isEmpty()) startCurrent();
            return;
        }
        try {
            if (mp.isPlaying()) mp.pause();
            else mp.start();
        } catch (Throwable t) {
            GmUtil.logFail("【Music】toggle 失败", t);
        }
        notifyState();
        saveState();
    }

    public void next() {
        if (queue.isEmpty()) return;
        index = loop == LOOP_SHUFFLE
                ? (int) (Math.random() * queue.size())
                : (index + 1) % queue.size();
        startCurrent();
    }

    public void prev() {
        if (queue.isEmpty()) return;
        index = loop == LOOP_SHUFFLE
                ? (int) (Math.random() * queue.size())
                : (index <= 0 ? queue.size() - 1 : index - 1);
        startCurrent();
    }

    public void setLoop(int m) {
        loop = ((m % 3) + 3) % 3;
        notifyState();
        saveState();
    }

    public void seekTo(int ms) {
        try {
            if (mp != null) mp.seekTo(Math.max(0, ms));
        } catch (Throwable t) {
            GmUtil.logFail("【Music】seek 失败", t);
        }
        notifyState();
    }

    public int position() {
        try {
            return mp == null ? 0 : mp.getCurrentPosition();
        } catch (Throwable t) {
            return 0;
        }
    }

    public int duration() {
        try {
            int d = mp == null ? -1 : mp.getDuration();
            if (d > 0) return d;
        } catch (Throwable ignore) {
        }
        Track t = index >= 0 && index < queue.size() ? queue.get(index) : null;
        return t == null ? 0 : (int) t.dur;
    }

    public boolean isPlaying() {
        try {
            return mp != null && mp.isPlaying();
        } catch (Throwable t) {
            return false;
        }
    }

    public void stop() {
        preparing = false;
        try {
            if (mp != null) {
                mp.stop();
                mp.release();
            }
        } catch (Throwable ignore) {
        }
        mp = null;
        notifyState();
        saveState();
    }

    // ══════════════════════════════ 真正开播 ══════════════════════════════

    private void startCurrent() {
        final Track t = index >= 0 && index < queue.size() ? queue.get(index) : null;
        if (t == null) return;
        preparing = true;
        error = null;
        notifyState();

        try {
            if (mp != null) {
                mp.release();
            }
        } catch (Throwable ignore) {
        }
        mp = null;

        io.execute(new Runnable() {
            @Override
            public void run() {
                String url = "";
                String msg = null;
                try {
                    Map<String, Object> m = GmMusicApi.songUrl(t.id, level);
                    Object u = m.get("url");
                    url = u == null ? "" : String.valueOf(u);
                    if (url.length() == 0) msg = "这首拿不到播放地址（无版权 / 需要会员）";
                } catch (Throwable e) {
                    msg = "取播放地址失败：" + (e.getMessage() == null ? e.toString() : e.getMessage());
                    GmUtil.logFail("【Music】取地址失败", e);
                }

                final String fUrl = url;
                final String fMsg = msg;
                ui.post(new Runnable() {
                    @Override
                    public void run() {
                        if (fUrl.length() == 0) {
                            preparing = false;
                            error = fMsg;
                            notifyState();
                            saveState();
                            if (queue.size() > 1) next();
                            return;
                        }
                        realPlay(t, fUrl);
                    }
                });
            }
        });
    }

    private void realPlay(final Track t, String url) {
        // ⚠️ Android 9+ 禁明文 http ⇒ 走 https（实测 CDN 支持）
        String u = url.startsWith("http://") ? "https://" + url.substring(7) : url;
        try {
            MediaPlayer p = new MediaPlayer();
            p.setAudioAttributes(new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build());
            p.setDataSource(u);                       // ★ 流式，不落盘
            p.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer m) {
                    preparing = false;
                    try {
                        m.start();
                    } catch (Throwable e) {
                        GmUtil.logFail("【Music】start 失败", e);
                    }
                    GmUtil.log("【Music】开始播放：" + t.name + " - " + t.artist + " ← " + level);
                    notifyState();
                    saveState();
                }
            });
            p.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer m) {
                    if (loop == LOOP_ONE) {
                        try {
                            m.seekTo(0);
                            m.start();
                        } catch (Throwable ignore) {
                        }
                    } else {
                        next();
                    }
                }
            });
            p.setOnErrorListener(new MediaPlayer.OnErrorListener() {
                @Override
                public boolean onError(MediaPlayer m, int what, int extra) {
                    GmUtil.log("【Music】播放错误 what=" + what + " extra=" + extra);
                    preparing = false;
                    error = "播放出错(" + what + "/" + extra + ")";
                    notifyState();
                    return true;
                }
            });
            mp = p;
            p.prepareAsync();
        } catch (Throwable e) {
            preparing = false;
            error = "播放器初始化失败：" + e;
            GmUtil.logFail("【Music】初始化失败", e);
            notifyState();
        }
    }

    // ══════════════════════════════ 状态通知 / 落盘 ══════════════════════════════

    private void notifyState() {
        Listener l = listener;
        if (l == null) return;
        try {
            l.onState(state());
        } catch (Throwable t) {
            GmUtil.logFail("【Music】回调界面失败", t);
        }
    }

    /**
     * 把状态写进宿主私有目录（`files/FDMmusic/state.json`）—— 照 `DSMlogs` 那个套路，
     * root / MT管理器一拉就能看，便于排查。
     *
     * <p>★ **版权**：这里只写**事实性元数据**。封面、歌词、音频一律不写（主人 2026-10-06 明确要求）。
     */
    private void saveState() {
        Context c = sApp;
        if (c == null) return;
        long now = System.currentTimeMillis();
        if (now - posTickAt < 1000) return;      // 1 秒最多写一次（进度会一直变）
        posTickAt = now;
        try {
            State s = state();
            JSONObject o = new JSONObject();
            o.put("at", now);
            o.put("playing", s.playing);
            o.put("preparing", s.preparing);
            o.put("loop", s.loop);
            o.put("index", s.index);
            o.put("queueSize", s.queueSize);
            o.put("pos", s.pos);
            o.put("dur", s.dur);
            o.put("level", s.level);
            if (s.error != null) o.put("error", s.error);
            if (s.track != null) {
                JSONObject t = new JSONObject();
                t.put("id", s.track.id);
                t.put("name", s.track.name);
                t.put("artist", s.track.artist);
                o.put("track", t);
            }
            JSONArray q = new JSONArray();
            for (Track t : queue) q.put(t.toJson());
            o.put("queue", q);
            o.put("_note", "只有事实性元数据；封面/歌词/音频一律不在本文件里（版权）");

            File dir = new File(c.getFilesDir(), "FDMmusic");
            if (!dir.exists()) dir.mkdirs();
            File f = new File(dir, "state.json");
            FileOutputStream fo = new FileOutputStream(f);
            fo.write(o.toString(1).getBytes("UTF-8"));
            fo.flush();
            fo.close();
        } catch (Throwable t) {
            // 落盘失败不影响播放
        }
    }

    // ══════════════════════════════ 网络：搜索 / 封面 / 歌词 ══════════════════════════════

    /** 搜索（后台线程 → 主线程回调）。 */
    public void search(final String kw, final int limit, final Cb<List<Track>> cb) {
        io.execute(new Runnable() {
            @Override
            public void run() {
                final List<Track> out = new ArrayList<Track>();
                try {
                    for (Map<String, Object> m : GmMusicApi.search(kw, limit, 0)) {
                        out.add(new Track(
                                num(m.get("id")),
                                str(m.get("name")),
                                str(m.get("artist")),
                                str(m.get("album")),
                                num(m.get("duration"))));
                    }
                } catch (Throwable t) {
                    GmUtil.logFail("【Music】搜索失败：" + kw, t);
                }
                ui.post(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            cb.on(out);
                        } catch (Throwable ignore) {
                        }
                    }
                });
            }
        });
    }

    /**
     * 取封面 —— **只放内存**（版权要求绝不落盘）。
     *
     * <p>搜索接口不给 `picUrl`（只有 `picId`）⇒ 走 `songDetail` 拿；宿主自己有网。
     */
    public void cover(final long id, final Cb<Bitmap> cb) {
        Bitmap cached = sCoverCache.get(Long.valueOf(id));
        if (cached != null && !cached.isRecycled()) {
            cb.on(cached);
            return;
        }
        io.execute(new Runnable() {
            @Override
            public void run() {
                Bitmap bmp = null;
                try {
                    String pic = "";
                    List<Map<String, Object>> d = GmMusicApi.songDetail(
                            java.util.Collections.singletonList(Long.valueOf(id)));
                    if (!d.isEmpty()) pic = str(d.get(0).get("picUrl"));
                    if (pic.length() > 0) {
                        String u = pic.indexOf('?') >= 0 ? pic : pic + "?param=300y300";
                        if (u.startsWith("http://")) u = "https://" + u.substring(7);
                        HttpURLConnection cn = (HttpURLConnection) new URL(u).openConnection();
                        cn.setConnectTimeout(10000);
                        cn.setReadTimeout(15000);
                        cn.setRequestProperty("User-Agent", "Mozilla/5.0");
                        InputStream in = cn.getInputStream();
                        bmp = BitmapFactory.decodeStream(in);
                        try {
                            in.close();
                        } catch (Throwable ignore) {
                        }
                        cn.disconnect();
                    }
                } catch (Throwable t) {
                    GmUtil.log("【Music】封面加载失败：" + t);
                }
                final Bitmap fb = bmp;
                if (fb != null) {
                    // 只留最近 3 张，别把内存顶爆
                    try {
                        if (sCoverCache.size() > 3) sCoverCache.clear();
                        sCoverCache.put(Long.valueOf(id), fb);
                    } catch (Throwable ignore) {
                    }
                }
                ui.post(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            cb.on(fb);
                        } catch (Throwable ignore) {
                        }
                    }
                });
            }
        });
    }

    /** 取歌词 —— **只放内存**（版权要求绝不落盘）。 */
    public void lyric(final long id, final Cb<String> cb) {
        String cached = sLyricCache.get(Long.valueOf(id));
        if (cached != null) {
            cb.on(cached);
            return;
        }
        io.execute(new Runnable() {
            @Override
            public void run() {
                String lrc = "";
                try {
                    Map<String, Object> m = GmMusicApi.lyric(id);
                    Object v = m.get("lrc");
                    lrc = v == null ? "" : String.valueOf(v);
                } catch (Throwable t) {
                    GmUtil.logFail("【Music】歌词加载失败", t);
                }
                if (lrc.length() > 0) {
                    try {
                        if (sLyricCache.size() > 6) sLyricCache.clear();
                        sLyricCache.put(Long.valueOf(id), lrc);
                    } catch (Throwable ignore) {
                    }
                }
                final String f = lrc;
                ui.post(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            cb.on(f);
                        } catch (Throwable ignore) {
                        }
                    }
                });
            }
        });
    }

    // ══════════════════════════════ 小工具 ══════════════════════════════

    private static String str(Object o) {
        return o == null ? "" : String.valueOf(o);
    }

    private static long num(Object o) {
        return o instanceof Number ? ((Number) o).longValue() : 0L;
    }

    /**
     * LRC 解析：[00:29.190]歌词 → (毫秒, 句子)。给迷你卡用。
     *
     * @return 排列好的 [毫秒数组, 文本数组]
     */
    public static Object[] parseLrc(String src) {
        List<Long> ms = new ArrayList<Long>();
        List<String> tx = new ArrayList<String>();
        if (src == null) return new Object[]{new long[0], new String[0]};
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(
                "\\[(\\d{1,2}):(\\d{1,2})(?:[.:](\\d{1,3}))?\\]");
        for (String line : src.split("\n")) {
            java.util.regex.Matcher m = p.matcher(line);
            long last = -1;
            int end = 0;
            while (m.find()) {
                long mm = parse(m.group(1));
                long ss = parse(m.group(2));
                String f = m.group(3);
                long frac = 0;
                if (f != null && f.length() > 0) {
                    if (f.length() == 1) frac = parse(f) * 100;
                    else if (f.length() == 2) frac = parse(f) * 10;
                    else frac = parse(f.substring(0, 3));
                }
                last = mm * 60000 + ss * 1000 + frac;
                end = m.end();
            }
            if (last < 0) continue;
            String s = line.substring(Math.min(end, line.length())).trim();
            if (s.length() == 0) continue;
            ms.add(Long.valueOf(last));
            tx.add(s);
        }
        // 按时间排（有些 LRC 一行多个时间标签）
        Integer[] idx = new Integer[ms.size()];
        for (int i = 0; i < idx.length; i++) idx[i] = i;
        final List<Long> fms = ms;
        java.util.Arrays.sort(idx, new java.util.Comparator<Integer>() {
            @Override
            public int compare(Integer a, Integer b) {
                return fms.get(a).compareTo(fms.get(b));
            }
        });
        long[] rms = new long[idx.length];
        String[] rtx = new String[idx.length];
        for (int i = 0; i < idx.length; i++) {
            rms[i] = fms.get(idx[i]).longValue();
            rtx[i] = tx.get(idx[i]);
        }
        return new Object[]{rms, rtx};
    }

    private static long parse(String s) {
        try {
            return Long.parseLong(s);
        } catch (Throwable t) {
            return 0;
        }
    }
}
