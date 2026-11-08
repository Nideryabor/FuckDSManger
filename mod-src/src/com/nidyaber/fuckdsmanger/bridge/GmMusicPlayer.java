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
        /**
         * ★ 2026-11-07（3.76.4）· **本地文件**：非空 = 这首来自本地曲库，
         * {@code id} 是 -1 之类的占位（没有网易云 id），播的时候**不走 {@code GmMusicApi.songUrl}**，
         * 直接把这段当数据源给 MediaPlayer。
         *
         * <p>为什么用这个字段区分，而不是"看 id 是不是负数"：
         * 状态栏 / 小卡 / 落盘 JSON 都要能一眼看出「这是本地的」，
         * 而且将来要显示「本地」角标。
         */
        public final String localPath;

        public Track(long id, String name, String artist, String album, long dur) {
            this(id, name, artist, album, dur, null);
        }

        public Track(long id, String name, String artist, String album, long dur, String localPath) {
            this.id = id;
            this.name = name == null ? "" : name;
            this.artist = artist == null ? "" : artist;
            this.album = album == null ? "" : album;
            this.dur = dur;
            this.localPath = localPath == null ? "" : localPath;
        }

        /** 本地曲目？ */
        public boolean isLocal() {
            return localPath != null && localPath.length() > 0;
        }

        public JSONObject toJson() {
            JSONObject o = new JSONObject();
            try {
                o.put("id", id);
                o.put("name", name);
                o.put("artist", artist);
                o.put("album", album);
                o.put("dur", dur);
                if (isLocal()) o.put("local", localPath);
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

    /**
     * ★★★ 2026-11-07 · **不一致自证**：声音与界面是否同源，让代码自己说出来。
     *
     * <p>主人报「播的是一首、歌词封面标题是另一首」，但我看不出哪一行错了 ——
     * 那就让每次 {@code state()} 自己对照三份事实：
     * <pre>
     *   ① mp 有没有在放（MediaPlayer 层）
     *   ② playingTrack / playingId（真正开始出声那首）
     *   ③ index / queue.get(index)（界面以为在放的那首）
     * </pre>
     * 三者只要对不上就**各打一行**（按组合去重，不刷屏）⇒ 复现一次就有铁证。
     */
    private void logStateMismatch(Track cur, long lid) {
        try {
            Track byIndex = index >= 0 && index < queue.size() ? queue.get(index) : null;
            long byIndexId = byIndex == null ? -1L : byIndex.id;
            boolean mpAlive = (mp != null);
            StringBuilder k = new StringBuilder();
            k.append(mpAlive ? 'M' : '-')
                    .append(playingTrack == null ? '-' : 'P')
                    .append(playingId == lid ? '=' : '!')
                    .append(byIndexId == lid ? '=' : '!');
            String key = k.toString();
            if (sMismatchLogged.contains(key)) return;
            sMismatchLogged.add(key);

            StringBuilder b = new StringBuilder("【同步诊断】key=").append(key);
            b.append("\n  mp=").append(mpAlive)
                    .append(" isPlaying=").append(isPlaying())
                    .append(" preparing=").append(preparing);
            b.append("\n  index=").append(index)
                    .append(" queueSize=").append(queue.size())
                    .append(" queue[index]=")
                    .append(byIndex == null ? "null"
                            : (byIndex.name + "/id=" + byIndex.id
                            + "/local=" + (byIndex.isLocal() ? "Y" : "N")));
            b.append("\n  playingTrack=")
                    .append(playingTrack == null ? "null"
                            : (playingTrack.name + "/id=" + playingTrack.id
                            + "/local=" + (playingTrack.isLocal() ? "Y" : "N")));
            b.append("\n  playingId=").append(playingId);
            b.append("\n  state.track=")
                    .append(cur == null ? "null" : (cur.name + "/id=" + cur.id));
            b.append("\n  state.dur=").append(duration()).append(" pos=").append(position());
            GmUtil.log(b.toString());
        } catch (Throwable ignore) {
        }
    }

    /** 已打过的「不一致组合」（去重，别每 0.5 秒刷一遍）。 */
    private static final java.util.Set<String> sMismatchLogged =
            java.util.Collections.synchronizedSet(new java.util.HashSet<String>());

    public State state() {
        State s = new State();
        // ★★ 一套信息必须同源：**在放谁，就显示谁**。
        //   否则会出现"标题 A、时长 B"（主人 11-07 截图：海阔天空的标题 + 3:26 的时长）。
        //   有 playingTrack（已经开始出声）就优先用它；没有才退回 index。
        //  ⚠️ 这里**不能**用 `mp != null` 当门（2026-11-07 真机血证）：
        //     realPlay 里 `mp = p` 是在 prepareAsync() **之前**赋的，
        //     而 onPrepared 回调可能更早到达 ⇒ 存在 `playingTrack 已设、mp 还是 null` 的窗口，
        //     那一刻会退回 queue.get(index)，而 index 可能已被下一次点击改掉
        //     ⇒ 界面显示"上一首的标题 + 这一首的进度"，且**时灵时不灵**
        //     （主人原话：「手动刷新有时候就统一了」）。
        //  ⇒ 只要 playingTrack 有值就以它为准；它只在 onPrepared / stop / 出错时变。
        Track cur = (playingTrack != null)
                ? playingTrack
                : (index >= 0 && index < queue.size() ? queue.get(index) : null);
        s.track = cur;
        s.playing = isPlaying();
        s.preparing = preparing;
        s.error = error;
        s.loop = loop;
        s.index = index;
        s.queueSize = queue.size();
        s.pos = position();
        s.dur = duration();
        s.level = level;
        logStateMismatch(cur, cur == null ? -1L : cur.id);
        return s;
    }

    public List<Track> queue() {
        return new ArrayList<Track>(queue);
    }

    /**
     * ★ 2026-11-07（3.76.4）· **播放一首本地曲目**（插队，立即播）。
     *
     * <p>和 {@link #play} 的区别只有一条，但很关键：**它不联网**。
     * {@code Track.localPath} 非空 ⇒ {@code startCurrent()} 直接跳过
     * {@code GmMusicApi.songUrl}，把路径交给 MediaPlayer。
     *
     * <p>id 用 {@code path.hashCode()} 取负 —— 足够做队列去重，也不会跟网易云的
     * 正数 id 撞车（撞了也只是"当成同一首"，无害）。
     */
    public synchronized String playLocal(GmLocalMusic.Item it) {
        if (it == null) return "没有这首歌";

        // ★★ 2026-11-07（3.78.6）· 「有时候本地歌播放不生效」的真因
        //
        //  旧写法：拿 it.n（序号）去重新 scan 一遍再按序号匹配。
        //  但序号是**每次重新扫**现算的（按 DocumentsContract 返回顺序），
        //  只要目录内容/顺序变一点（新导入一首、删除一首、provider 顺序不同），
        //  n 就错位 ⇒ 匹配到**别的歌**或**匹配不到** ⇒ 表现就是"时灵时不灵"。
        //
        //  ⇒ 改成：① 优先用调用方给的 playUri（它本来就有，不必再扫）
        //          ② 序号只当"兜底线索"，且必须校验名字对得上
        //          ③ 都不行才真去扫一次，按 **名字+歌手** 匹配（比序号稳）
        String src = it.source();
        String name = it.name;
        String artist = it.artist;

        if (src == null || src.isEmpty()) {
            try {
                Context c = sApp;
                for (GmLocalMusic.Item x : GmLocalMusic.scan(c)) {
                    if (x.n == it.n && sameSong(x, it)) {
                        src = x.source();
                        name = x.name;
                        artist = x.artist;
                        break;
                    }
                }
                if (src == null || src.isEmpty()) {
                    // 序号对不上就按名字找（名字比序号稳）
                    GmLocalMusic.Item x = GmLocalMusic.find(sApp, it.name, it.artist);
                    if (x != null) {
                        src = x.source();
                        name = x.name;
                        artist = x.artist;
                    }
                }
            } catch (Throwable t) {
                GmUtil.logFail("【Music】playLocal 重扫", t);
            }
        }
        if (src == null || src.isEmpty()) {
            error = "曲库里找不到这首歌的文件：请点「选择文件夹」重新授权";
            GmUtil.log("【Music】本地曲目没有可用 uri（没授权曲库目录？） → " + it.label());
            notifyState();
            return "找不到文件：" + it.label();
        }

        long lid = localId(src);
        // ★ 登记「id → uri」：之后取歌词/封面只认这张表，不看 curTrack()
        sLocalUri.put(Long.valueOf(lid), src);
        Track t = new Track(lid, name, artist, it.album, it.dur, src);
        int ex = -1;
        for (int i = 0; i < queue.size(); i++) {
            if (queue.get(i).id == t.id) {
                ex = i;
                break;
            }
        }
        if (ex >= 0) {
            // ★★ 判据必须是 **playingId == 这首的 id**，不能只问 isPlaying()。
            //   只问 isPlaying() 会在"正在放 B、点了 A"时误判成"已经在这首"，
            //   于是 index 被改成 A 却不切歌 ⇒ 界面 A、声音 B、永远切不回来。
            boolean sameAsPlaying = (playingId == t.id) && isPlaying() && !preparing;
            index = ex;
            if (sameAsPlaying) {
                GmUtil.log("【Music】这首歌**本来就在放** ⇒ 不重开：" + t.name
                        + "（playingId=" + playingId + "）");
                notifyState();
                return "这首已经在放（没重开）：" + t.name;
            }
            // ★★★ 2026-11-07 · **必须用新对象替换队列里的旧条目**
            //
            //  真 bug（不是猜，看代码就能确认）：
            //    startCurrent() 读的是 `queue.get(index)`，不是我刚构造的 `t`。
            //    走 ex>=0 这条路时 index 指向**队列里的旧 Track**，
            //    而那个旧对象可能是从 state.json 恢复的 —— localPath 为空 / 指向旧授权 uri
            //    ⇒ MediaPlayer 拿到坏 uri ⇒ 播不出来，
            //      再点一次还是走这条分支、还是用坏对象 ⇒ **永远播不出来（切不回来）**。
            //
            //  ⇒ 用这次算出来的 t（带当前有效 uri）覆盖它。
            queue.set(ex, t);
            GmUtil.log("【Music】队列里已有同 id 的旧条目 ⇒ 用新的替换（#"
                    + ex + " uri=" + src + "）");
        } else {
            queue.add(t);
            index = queue.size() - 1;
        }
        GmUtil.log("【Music】本地起播 → " + name + " - " + artist + " @" + src);
        startCurrent();
        return "本地起播：" + name + (artist == null || artist.isEmpty() ? "" : " - " + artist);
    }

    /**
     * ★★★ 2026-11-07 · **这个 uri 现在是不是"正在播"的那首？**
     *
     * <h3>为什么必须要有它（本轮的最终答案）</h3>
     * 主人：「切回海阔天空没声、卡片还显示红色高跟鞋、切后台回来又能放」。
     *
     * 真因是 `GmMusicDj` 的**15 秒去重窗口**：
     * <pre>
     *   第1次 放海阔天空  → 记 L|1|，T0
     *   第2次 切红色高跟鞋 → 记 L|2|（+2s）
     *   第3次 切回海阔天空 → 距 T0 仅 4s，仍在窗口内 ⇒ 直接 return，
     *                        **只返回"♪ 正在给你放"这句文本，播放器一行都没跑**
     * </pre>
     * ⇒ 于是「没声音、卡片不变、切后台（>15s）回来又好了、时灵时不灵」全部吻合。
     *
     * <p>去重本身是为了挡「流式渲染把同一条消息 rebuild 十几次」，
     * 但**不能拿它当"用户又想听这首"的挡箭牌**。
     * 判据：只要当前正在放的不是这一首，就说明这次是**切歌**，必须真的执行。
     */
    public static boolean isPlayingLocalUri(String uri) {
        if (uri == null || uri.isEmpty()) return false;
        GmMusicPlayer p = get();
        if (p == null) return false;
        try {
            return p.playingId == localId(uri) && p.isPlaying() && !p.preparing;
        } catch (Throwable t) {
            return false;
        }
    }

    /** 本地曲目的 id：从 uri 派生，稳定且不会跟网易云的正数 id 撞。 */
    static long localId(String src) {
        return -Math.abs((long) src.hashCode()) - 1L;
    }

    /** 两首歌是不是同一首（名字+歌手都归一后相等）。 */
    private static boolean sameSong(GmLocalMusic.Item a, GmLocalMusic.Item b) {
        if (a == null || b == null) return false;
        return nome(a.name).equals(nome(b.name)) && nome(a.artist).equals(nome(b.artist));
    }

    private static String nome(String s) {
        if (s == null) return "";
        StringBuilder b = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = Character.toLowerCase(s.charAt(i));
            if (Character.isLetterOrDigit(c)) b.append(c);
        }
        return b.toString();
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
        playingId = -1L;
        playingTrack = null;
        try {
            if (audioMgr != null) {
                audioMgr.abandonAudioFocus(focusListener);
                hasFocus = false;
            }
        } catch (Throwable ignore) {
        }
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

    /**
     * 起播当前 index 指向的那首。
     *
     * <p>★★★ 2026-11-07 · **必须串行**（synchronized）
     *
     * <p>frida 证据：模块日志说"起播成功"，但 frida 看不到新实例的
     * {@code setDataSource/prepareAsync} ⇒ 说明 `onPrepared` 是**旧实例**的回调。
     * 根因是 `startCurrent()` 会被**并发重入**（UI 点击 / 协程回调 / 定时器都可能调）：
     * <pre>
     *   T1: ++playGen → 2, 进入 realPlay, 还没建好实例
     *   T2: ++playGen → 3, 也进入 realPlay
     *   ⇒ 两个 MediaPlayer 同时 prepare，回调互相冒充，音频通道打架
     * </pre>
     *
     * <p>串行化之后，任意时刻只有一个 realPlay 在跑，代次语义才成立。
     */
    private synchronized void startCurrent() {
        // ★★★ 2026-11-07 · **入口无条件打一行**
        //
        //  排查到这一步的事实（frida mp3 实测）：
        //    · 第1首：new MediaPlayer → setDataSource → prepareAsync → start ✓
        //    · 第2、3首：**连 new MediaPlayer 都没有**，说明 realPlay 没执行
        //  而日志里「本地起播」在 `startCurrent()` 的**前一行**，
        //  既然它打了，startCurrent 就必然被调 ⇒ **只能是这里静默 return 了**。
        //  原来那句 `if (t == null) return;` 一点痕迹都不留，害我查了几轮。
        final int sz = queue.size();
        final boolean inRange = index >= 0 && index < sz;
        GmUtil.log("【Music】startCurrent 进入：index=" + index + " queueSize=" + sz
                + (inRange ? "" : "  ⚠️index 越界 ⇒ 将静默返回"));
        final Track t = inRange ? queue.get(index) : null;
        if (t == null) {
            GmUtil.log("【Music】⚠️ startCurrent 取不到 track ⇒ 返回（index=" + index + "）");
            return;
        }
        preparing = true;
        error = null;
        // ★ 新歌还没出声 ⇒ 清掉"在出声"的记录；等 onPrepared 再填。
        //   （不清的话，切歌瞬间界面会继续显示上一首的标题+新歌的进度）
        playingId = -1L;
        playingTrack = null;
        // ★★ 代次 +1：之后所有回调都要先核对它，旧播放器的迟到回调一律作废
        final int myGen = ++playGen;
        notifyState();

        // ★★★ 2026-11-07 · **快速连切必须 reset + release**
        //
        //  主人实测：100ms 内切两次 ⇒ 第二首无声（isPlaying 却为 true）。
        //  日志铁证：第一首的 onPrepared **一次都没触发**（被 release 掐掉），
        //  它既没抢焦点也没 start，但音频通道被"半准备"的请求占着。
        //
        //  ⚠️ 为什么必须 reset()：`release()` 只是标记要释放，
        //     对"正在 prepareAsync"的实例不保证立刻回到 idle；
        //     `reset()` 是**同步**的，会立即中止准备并把状态拉回 IDLE。
        try {
            MediaPlayer old = mp;
            if (old != null) {
                try {
                    old.reset();          // ← 同步中止准备（关键）
                } catch (Throwable ignore) {
                }
                old.release();
            }
        } catch (Throwable ignore) {
        }
        mp = null;

        // ★★★ 2026-11-07 · **快速连切**（主人实测：100ms 内切两次）
        //
        //  日志铁证：
        //    17:29:49.825 起播海阔天空 → 17:29:49.997 起播红色高跟鞋
        //    海阔天空的 onPrepared **一次都没触发**（被 release 掐掉了）
        //    ⇒ 它既没 requestAudioFocus、也没 start
        //    ⇒ 后续那首红色高跟鞋虽然拿到了焦点、isPlaying=true，但**没有声音**
        //
        //  原因：`prepareAsync()` 是异步的，release() 不保证取消已排队的回调；
        //        而音频输出通道被上一次"半准备好"的请求占着，新的 start 拿不到通路。
        //
        //  ⇒ 修法：切歌时若上一首**还在 preparing**，先 `reset()` 再 `release()`，
        //    并把 preparing 清掉（确保状态机不会卡在"正在准备"）。
        //    reset() 会同步把 MediaPlayer 打回 idle，比单纯 release 更彻底。
        // （删掉原来那段 `if (preparing)` 诊断 —— 它写在 `preparing = true` 之后，
        //   恒成立、只会误导。真正该判断的是"切换前"的状态，已由 reset 处理。）
        //   不放的话，快速连切会累积多个"已释放但仍占焦点"的会话，
        //   新实例抢不到 ⇒ 无声（而 isPlaying 仍为 true）。
        try {
            if (audioMgr != null) {
                audioMgr.abandonAudioFocus(focusListener);
                hasFocus = false;
            }
        } catch (Throwable ignore) {
        }

        // ★★ 2026-11-07（3.76.4）· **本地曲目直接播，绝不联网**
        //   这一步是「本地 / 在线明确分开」的落点：只要 Track 带 localPath，
        //   就完全绕开 GmMusicApi（不去搜、不去取地址、没有码率档位）。
        //   ⚠️ 也别在这里"失败就回落在线" —— 那正是主人 11-07 报的
        //      「为什么还是在线播放」。本地放不出来就明说，不许偷偷换在线。
        if (t.isLocal()) {
            realPlay(t, t.localPath, myGen);
            return;
        }

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
                        // ★★ 在线曲目要等网络 ⇒ 这段时间用户可能已经切歌了。
                        //   代次变了就**整条丢弃**（否则会用旧 url 覆盖新歌）
                        if (myGen != playGen) {
                            GmUtil.log("【Music】丢弃过期的在线起播结果（gen=" + myGen
                                    + " 当前=" + playGen + "）：" + (t == null ? "?" : t.name));
                            return;
                        }
                        if (fUrl.length() == 0) {
                            preparing = false;
                            error = fMsg;
                            notifyState();
                            saveState();
                            if (queue.size() > 1) next();
                            return;
                        }
                        realPlay(t, fUrl, myGen);
                    }
                });
            }
        });
    }

    /**
     * 真的去开一次文件。
     *
     * @return null = 能读；否则是「为什么打不开」的一句话
     *
     * <p>⚠️ 为什么不用 {@code File.canRead()}：scoped storage 下 FUSE 的 st_mode 是 0，
     * 一律返回 false —— 真机实测过 `canRead=false` 但 `length()` 正常。
     * 只有真开一次才知道答案。
     */
    private static String openTest(File f) {
        java.io.FileInputStream in = null;
        try {
            in = new java.io.FileInputStream(f);
            byte[] head = new byte[16];
            int n = in.read(head);
            return n > 0 ? null : "文件是空的";
        } catch (Throwable t) {
            String m = t.getMessage();
            return (t.getClass().getSimpleName() + (m == null ? "" : ": " + m));
        } finally {
            try {
                if (in != null) in.close();
            } catch (Throwable ignore) {
            }
        }
    }

    /**
     * 用宿主自己的身份开一次 content uri。
     *
     * @return null = 能读；否则是「为什么打不开」
     */
    private static String openTestContent(String uriStr) {
        java.io.InputStream in = null;
        Context c = sApp;
        if (c == null) return "没有 Context";
        try {
            in = c.getContentResolver().openInputStream(android.net.Uri.parse(uriStr));
            if (in == null) return "stream=null";
            byte[] head = new byte[16];
            int n = in.read(head);
            return n > 0 ? null : "文件是空的";
        } catch (Throwable t) {
            String m = t.getMessage();
            return t.getClass().getSimpleName() + (m == null ? "" : ": " + m);
        } finally {
            try {
                if (in != null) in.close();
            } catch (Throwable ignore) {
            }
        }
    }

    /**
     * 真正起播。
     *
     * <p>★★★ 2026-11-07 · **gen 必须由调用方传进来，不能在这里读 playGen**
     *
     * <h3>frida + 模块日志双证据锁定的真 bug</h3>
     * <pre>
     *   17:41:25.759  本地起播 → 海阔天空          （模块：起播了）
     *   17:41:25.945  开始播放 · isPlaying=true     （模块：真的在播）
     *   frida      ：第 2 首之后再无 setDataSource/prepareAsync/start  ← 矛盾！
     * </pre>
     * 唯一解释：**`onPrepared` 是旧实例的回调**，而代次校验没拦住它。
     *
     * <p>为什么没拦住 —— 看旧写法：
     * <pre>
     *   startCurrent(): final int myGen = ++playGen;   // 变成 2
     *                   realPlay(t, ...);
     *   realPlay():     final int myGen = playGen;     // ← 读【当前值】= 2
     * </pre>
     * 如果 `startCurrent()` 在 `realPlay()` 执行前**被重入一次**（变成 3），
     * 或反过来「先 ++ 再被另一个线程 ++」，两次调用就会拿到**同一个 gen**
     * ⇒ 旧回调 `myGen == playGen` 成立 ⇒ 校验失效 ⇒ 用旧实例的 onPrepared
     *   把 `playingTrack`/`playingId` 填成旧歌 ⇒ 界面/声音错位，且**再也不重新起播**。
     *
     * <p>⇒ 现在 gen 由 startCurrent 分配、一路传到这里，所有回调校验的都是**这一拍**。
     */
    private void realPlay(final Track t, String url, final int myGen) {
        GmUtil.log("【Music】realPlay 进入（gen=" + myGen + "/" + playGen + "）");
        // ⚠️ Android 9+ 禁明文 http ⇒ 走 https（实测 CDN 支持）
        // ★ 本地曲目不走这条：uri 不能被当成 http
        String u = url;
        boolean local = t.isLocal();
        if (!local) {
            u = url.startsWith("http://") ? "https://" + url.substring(7) : url;
        }
        try {
            // ★★ 2026-11-07 · 本地曲目**先真开一次**，把"为什么放不了"说清楚。
            //   ⚠️ 别用 File.canRead()：scoped storage 走 FUSE，st_mode 常是 0
            //   ⇒ 一律返回 false，而真正 open 反而可能成功（真机实测过这种假象）。
            //   现在是 content://（SAF 持久授权）⇒ 用 openInputStream 试。
            if (local && u.startsWith("content://")) {
                GmUtil.log("【Music】realPlay：开始 openTestContent 探活");
                String why = openTestContent(u);
                GmUtil.log("【Music】realPlay：探活结果=" + (why == null ? "OK" : why));
                if (why != null) {
                    preparing = false;
                    error = "读不到本地文件（" + why + "）—— 点「选择文件夹」重新授权";
                    GmUtil.log("【Music】本地 uri 打不开 → " + u + " · " + why);
                    notifyState();
                    saveState();
                    return;
                }
            }
            // ★★★ 2026-11-07 · **创建新实例前，把旧实例彻底放干净**
            //
            //  主人现象：「切回本地海阔天空、再切回红色高跟鞋就不能放了；
            //             划到后台回来又能放」。
            //
            //  startCurrent() 里已经 release 了旧 mp，但那条 `mp = null` 之后
            //  本方法可能被**上一次尚未完成的调用**重入（prepareAsync 还在飞），
            //  ⇒ 两个 MediaPlayer 同时存在，旧的那个没 release ⇒ 音频轨打架
            //  ⇒ 新的 start() 成功、isPlaying=true，但**听不到声音**。
            //
            //  ⇒ 这里再兜一次：只要 mp 非空就 release（即使上一行已经做过，也幂等）。
            try {
                MediaPlayer old = mp;
                if (old != null) {
                    old.reset();
                    old.release();
                    GmUtil.log("【Music】清理残留 MediaPlayer 实例");
                }
            } catch (Throwable ignore) {
            }
            mp = null;

            GmUtil.log("【Music】realPlay：即将 new MediaPlayer");
            MediaPlayer p = new MediaPlayer();
            GmUtil.log("【Music】realPlay：已 new（obj="
                    + Integer.toHexString(System.identityHashCode(p)) + "）");
            // ★★ 2026-11-07 · **先登记 mp，再配置**。
            //   原来 `mp = p` 写在 prepareAsync() 之前但配置之后，
            //   而 onPrepared 是异步的 ⇒ 存在 "playingTrack 已设、mp 还是旧值/null" 的窗口。
            //   提前赋值把这个窗口彻底消掉（state() 也不会再看到 mp==null 的中间态）。
            GmUtil.log("【Music】realPlay 开始：src=" + (u.length() > 80 ? u.substring(0, 80) + "…" : u));
            mp = p;
            p.setAudioAttributes(new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build());
            if (local) {
                if (u.startsWith("content://")) {
                    Context c = sApp;
                    if (c == null) throw new IllegalStateException("没有 Context，读不了 content://");
                    p.setDataSource(c, android.net.Uri.parse(u));
                } else {
                    p.setDataSource(u);               // 本地绝对路径
                }
            } else {
                p.setDataSource(u);                       // ★ 流式，不落盘
            }
            p.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer m) {
                    // ★★★ 关键：这是**旧播放器**的迟到回调吗？
                    //   release() 不会取消已排队的回调 ⇒ p1 的 onPrepared 可能在 p2 之后到达
                    //   ⇒ 若不过滤，会把 playingTrack 覆盖成旧歌（卡片乱显示的根因）
                    // ★★★ 2026-11-07 · **双重校验：代次 + 实例身份**
                    //
                    //  只校验 gen 不够 —— 一旦发生重入/时序竞争，两次调用可能拿到同一个 gen，
                    //  旧实例的回调就会"合法"通过，然后：
                    //    · 打印「开始播放 · isPlaying=true」（看着成功）
                    //    · 但那个 MediaPlayer 根本不是当前 mp（甚至已 release）
                    //  ⇒ 声音出不来，而日志一切正常。这正是 frida 看到的矛盾。
                    //
                    //  ⇒ 再加一条**无法伪造**的校验：`m == mp`（这个实例就是当前在用的那个）。
                    if (myGen != playGen || m != mp) {
                        GmUtil.log("【Music】丢弃过期 onPrepared（gen=" + myGen
                                + "/" + playGen + " 实例当前=" + (m == mp) + "）：" + t.name);
                        try {
                            m.release();
                        } catch (Throwable ignore) {
                        }
                        return;
                    }
                    preparing = false;
                    // ★★★ 2026-11-07 · **start() 之前必须先拿到音频焦点**
                    //   没焦点也能 start()、isPlaying 也返回 true，
                    //   但音频轨拿不到输出 ⇒ 静默无声（主人报的"能放但没声音"）。
                    boolean fOk = requestFocus();
                    if (!fOk) {
                        GmUtil.log("【Music】⚠️ 没拿到音频焦点 ⇒ 先强行 start，"
                                + "若无声请检查其他应用是否占用音频");
                    }
                    try {
                        m.start();
                    } catch (Throwable e) {
                        GmUtil.logFail("【Music】start 失败", e);
                    }
                    // ★ 只有这一刻才是"真的在出声" ⇒ 记录真正在放的 曲目 + id
                    playingId = t.id;
                    playingTrack = t;
                    // ★★★ 2026-11-07 · **start() 之后必须回读事实**
                    //   主人报「说开始播放了但没声音」⇒ 不能只信"我们调了 start"，
                    //   要看 MediaPlayer 自己怎么说。这三项任一异常就是真因：
                    //     isPlaying=false   ⇒ start() 没生效（焦点/解码器被占）
                    //     duration<=0       ⇒ 数据源没真读出来（content:// 权限/文件坏）
                    //     position 不动     ⇒ 解码器卡住
                    int dur = -1, pos = -1;
                    boolean play = false;
                    try {
                        dur = m.getDuration();
                    } catch (Throwable ignore) {
                    }
                    try {
                        pos = m.getCurrentPosition();
                    } catch (Throwable ignore) {
                    }
                    try {
                        play = m.isPlaying();
                    } catch (Throwable ignore) {
                    }
                    // ★ 再加一条：**这个 MediaPlayer 内部状态**（能进一步区分
                    //   "逻辑在播但没输出" vs "压根没开始"）
                    String extra = "";
                    try {
                        if (android.os.Build.VERSION.SDK_INT >= 23) {
                            extra = " 状态=" + m.getPlaybackParams().toString();
                        }
                    } catch (Throwable ignore) {
                    }
                    GmUtil.log("【Music】开始播放：" + t.name + " - " + t.artist
                            + " ← " + level + "（playingId=" + playingId + "）"
                            + " · 实测 isPlaying=" + play + " dur=" + dur + " pos=" + pos
                            + extra
                            + (play ? "" : "  ⚠️没在播！"));

                    // ★★★ 2026-11-07 · **音量与静音实测**（主人：「isPlaying=true 但没声音」）
                    //
                    //  isPlaying=true 只说明"逻辑在播"，不代表有输出。三个常见原因：
                    //    ① 该音频流被静音 / 音量为 0
                    //    ② 输出设备不是扬声器（被路由到蓝牙/耳机/USB）
                    //    ③ 音频轨被系统丢掉（旧实例占用）
                    //  这里把 ①② 的实测值打出来，一次就能排除。
                    try {
                        Context c = sApp;
                        if (c != null) {
                            android.media.AudioManager am =
                                    (android.media.AudioManager) c.getSystemService(Context.AUDIO_SERVICE);
                            if (am != null) {
                                int vol = am.getStreamVolume(android.media.AudioManager.STREAM_MUSIC);
                                int max = am.getStreamMaxVolume(android.media.AudioManager.STREAM_MUSIC);
                                boolean mute = am.isStreamMute(android.media.AudioManager.STREAM_MUSIC);
                                String route = "?";
                                try {
                                    if (android.os.Build.VERSION.SDK_INT >= 23) {
                                        android.media.AudioDeviceInfo[] devs =
                                                am.getDevices(android.media.AudioManager.GET_DEVICES_OUTPUTS);
                                        StringBuilder rb = new StringBuilder();
                                        for (android.media.AudioDeviceInfo d : devs) {
                                            if (d.isSink()) {
                                                if (rb.length() > 0) rb.append('|');
                                                rb.append(d.getType());
                                            }
                                        }
                                        route = rb.toString();
                                    }
                                } catch (Throwable ignore) {
                                }
                                GmUtil.log("【Music】音量实测：STREAM_MUSIC=" + vol + "/" + max
                                        + " 静音=" + mute + " · 可用输出设备(type)=" + route);
                            }
                        }
                    } catch (Throwable ignore) {
                    }
                    notifyState();
                    saveState();
                }
            });
            p.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer m) {
                    // ★ 旧播放器的"播完"绝不能带着新歌一起跳下一首
                    //   （这是"自己切到在线歌 / 切不回来"的来源之一）
                    if (myGen != playGen) {
                        GmUtil.log("【Music】忽略过期 onCompletion（gen=" + myGen
                                + " 当前=" + playGen + "）：" + t.name);
                        return;
                    }
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
                    // ★ 同上：旧播放器报错不该污染新歌的状态
                    if (myGen != playGen) {
                        GmUtil.log("【Music】忽略过期 onError（gen=" + myGen
                                + " 当前=" + playGen + "）：" + t.name);
                        return true;
                    }
                    GmUtil.log("【Music】播放错误 what=" + what + " extra=" + extra
                            + (t.isLocal() ? "（本地 " + t.localPath + "）" : ""));
                    preparing = false;
                    // ★ 出错就不算"在放这首"了 ⇒ 用户再点它时应该**重试**
                    playingId = -1L;
                    error = t.isLocal()
                            ? ("本地文件播不了(" + what + "/" + extra + ")：" + t.name)
                            : ("播放出错(" + what + "/" + extra + ")");
                    notifyState();
                    // ★ 本地失败**不自动跳下一首** —— 免得一路连着报错把队列吃空
                    return true;
                }
            });
            // （mp 已在上面提前赋值，这里不要再赋一次）
            GmUtil.log("【Music】即将 prepareAsync（实例="
                    + Integer.toHexString(System.identityHashCode(p)) + "）");
            p.prepareAsync();
            GmUtil.log("【Music】prepareAsync 已调用（等待 onPrepared）");
        } catch (Throwable e) {
            preparing = false;
            error = "播放器初始化失败：" + e;
            // ★ 关键：这里原来只进 DIAG 缓冲，常规日志看不到 ⇒ 我排查了半天
            GmUtil.log("【Music】❌ realPlay 抛出异常：" + e);
            GmUtil.logFail("【Music】初始化失败", e);
            notifyState();
        }
    }

    // ══════════════════════════════ 状态通知 / 落盘 ══════════════════════════════

    /**
     * 通知界面。
     *
     * <p>★ 2026-11-07：仍然用**单个** listener（卡片本来就是唯一的），
     * 但加一条防御：{@code state()} 只算一次、所有订阅者共用同一份快照，
     * 避免不同订阅者拿到不同时刻的数据。
     */
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
    /**
     * 取封面。
     *
     * <p>★★ 2026-11-07（3.78.6）· **本地曲目也走这里**，用「同名图片」当封面。
     *
     * <p>主人的要求：封面跟音频**同目录、同文件名**，只换后缀
     * （`红色高跟鞋-蔡健雅.mp3` ↔ `红色高跟鞋-蔡健雅.jpg`）。
     * 支持的图片后缀见 {@link #COVER_EXT}。
     *
     * <p>优先级：同名图片 → 网易云封面（只有在线曲目有）→ null。
     * 本地曲目**绝不联网**取封面。
     */
    /**
     * 认的封面图片后缀（跟音频同名，只换后缀）。
     *
     * <p>⚠️ 这里列的是 {@code BitmapFactory} 在 Android 26+ 上**真能解**的格式。
     * HEIC 从 API 28 才有内置解码 ⇒ 放进来但解不出来会走 null（不崩）。
     * 想加格式只改这一个数组即可（查找逻辑是遍历它的）。
     */
    private static final String[] COVER_EXT = {
            ".jpg", ".jpeg", ".png", ".webp", ".bmp", ".gif", ".heic", ".heif"
    };

    /**
     * ★★★ 2026-11-07 · 「id → 本地音频 uri」登记表。
     *
     * <h3>为什么必须有它</h3>
     * 之前 {@code cachedLyric(id)} / {@code cover(id)} / {@code localLyric()} 都用
     * {@code curTrack()} 判断"这是不是本地歌" —— 而 {@code applyState} 传进来的是**快照**，
     * {@code index} 可能已经变了，于是 {@code curTrack().id != id}。
     * 对不上时的后果：
     * <pre>
     *   cachedLyric 走 "return v" ⇒ 返回 null（= 未加载）
     *   lyric()      走网易云分支 ⇒ 本地歌 id 是负数，请求必失败
     *   ⇒ 界面**永远**停在「歌词加载中」，换了歌也回不来
     * </pre>
     * 实测症状：全齐的歌 → 没歌词的歌 → 再切回全齐的歌，卡住回不来。
     *
     * <p>⇒ 改用这张表：只要 {@code id} 在表里就是本地曲目，路径直接查得到，
     * <b>与当前播放到第几首完全无关</b>。
     */
    private static final Map<Long, String> sLocalUri = new HashMap<Long, String>();

    /**
     * ★★★ 2026-11-07 · **真正正在放的那一首的 id**（media player 层的事实）。
     *
     * <h3>为什么不能用 isPlaying() 判断「是不是已经在放这首」</h3>
     * 原写法：
     * <pre>
     *   index = ex;                              // 先改 index
     *   if (isPlaying() &amp;&amp; !preparing) return;   // 再问"播放器在放吗"
     * </pre>
     * {@code isPlaying()} 问的是 **MediaPlayer 有没有在出声**，不是"放的是不是这首歌"。
     * 于是：正在放 B 时点 A ⇒ index 被改成 A、isPlaying() 因为 B 在放而返回 true
     * ⇒ 直接 return 不切歌 ⇒ <b>界面显示 A 的封面歌词、扬声器还在放 B</b>，
     * 而且再点还是一样 ⇒ 用户看到的就是「卡在 A 那首切不回来」。
     *
     * <p>⇒ 只有 {@code playingId == 目标 id} 才算"已经在放这首"。
     * 它在 {@code onPrepared} 里设置（那一刻才是真的开始出声）。
     */
    private long playingId = -1L;

    /**
     * ★★★ 2026-11-07 · **真正在出声的那一首**（不只是 id，连元数据一起）。
     *
     * <h3>为什么需要它（主人 11-07 截图铁证）</h3>
     * 截图里：标题「海阔天空 · 黄家驹」，进度条却是 **3:26**（红色高跟鞋的时长）。
     * 原因：{@code state()} 里
     * <pre>
     *   s.track = queue.get(index)   ← 标题/歌手/歌词/封面 都从这里来
     *   s.dur   = duration()         ← 这个读的是 MediaPlayer.getDuration()（真实在放的那首）
     * </pre>
     * 一旦 {@code index} 和 MediaPlayer 不同步（切歌瞬间、切后台回来重建），
     * 界面就会出现「标题是一首、时长/声音是另一首」的分离。
     *
     * <p>⇒ {@code state()} 的 track 改成「{@link #playingTrack} 优先」，
     * 让 **标题/歌手/歌词/封面/进度 全部出自同一首**。
     * 它在 {@code onPrepared} 里设置（那一刻才是真的开始出声）。
     */
    private Track playingTrack = null;

    /**
     * ★★★ 2026-11-07 · **播放代次（generation）** —— 修「卡片显示的歌不是正在放的歌」
     *
     * <h3>真 bug（可从代码直接推出，主人两次截图吻合）</h3>
     * 快速连切时（点歌 → 立刻再点另一首）：
     * <pre>
     *   ① startCurrent(): mp.release(); mp = null;
     *   ② realPlay(t2): 新建 p2, mp = p2, p2.prepareAsync()
     *   ③ 但 **p1 的 onPrepared 可能在 release 之后才回调**（异步，不保证取消）
     *      回调里 `playingTrack = t`（t 是**闭包里的旧歌**）⇒ 把 playingTrack 覆盖成旧歌
     *   ④ 实际出声的是 p2，界面却显示 t（旧歌）
     * </pre>
     *
     * 主人现象完全吻合：
     *   · AI 说「放本地红色高跟鞋」，卡片显示「海阔天空」（前一秒点过的那首）
     *   · 切歌时灵时不灵；「手动刷新有时候就统一了」（取决于回调到达顺序）
     *
     * <h3>修法</h3>
     * 每次 {@code realPlay} / {@code startCurrent} 都 {@code ++gen}，
     * 回调里校验「我的 gen 还是当前的 gen 吗」——不是就**整个忽略**
     * （不设 playingTrack、不 notify、不 next）。
     *
     * <p>⚠️ 这一条同样适用于 {@code onError} / {@code onCompletion}：
     * 旧播放器的错误/播完事件绝不能让新歌跟着跳（那正是"自己切到在线歌"的来源）。
     */
    private volatile int playGen = 0;

    // ══════════════════════════════════════════════════════════════════════
    //  ★★★ 2026-11-07 · **音频焦点**（修「切歌后没声音」）
    //
    //  主人现象：「切回本地海阔天空、再切回红色高跟鞋就不能放了；
    //             划到后台回来又能放」。
    //
    //  这是 Android 上非常典型的**音频焦点**症状：
    //    · 我们从来没 requestAudioFocus ⇒ 播放器能 start()、isPlaying=true，
    //      但**音频轨拿不到输出**（被别的持有焦点的应用占着）
    //    · 切后台时系统会让其他应用释放焦点，回来时我们"碰巧"能出声
    //    · 快速切歌会反复 release + new MediaPlayer，每次都重新抢一次，
    //      抢不到就静默无声 —— 而 isPlaying 仍然是 true（它只是"逻辑在播"）
    //
    //  ⇒ 正确做法：播放前显式请求 AUDIOFOCUS_GAIN，并用 OnAudioFocusChangeListener
    //     处理被抢占（暂停）/重新获得（继续）。
    // ══════════════════════════════════════════════════════════════════════

    private android.media.AudioManager audioMgr;
    private boolean hasFocus = false;

    private final android.media.AudioManager.OnAudioFocusChangeListener focusListener =
            new android.media.AudioManager.OnAudioFocusChangeListener() {
                @Override
                public void onAudioFocusChange(int change) {
                    try {
                        GmUtil.log("【Music】音频焦点变化 → " + change);
                        switch (change) {
                            case android.media.AudioManager.AUDIOFOCUS_LOSS:
                                hasFocus = false;
                                pauseByFocus();
                                break;
                            case android.media.AudioManager.AUDIOFOCUS_LOSS_TRANSIENT:
                            case android.media.AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:
                                pauseByFocus();
                                break;
                            case android.media.AudioManager.AUDIOFOCUS_GAIN:
                                hasFocus = true;
                                resumeByFocus();
                                break;
                            default:
                                break;
                        }
                    } catch (Throwable ignore) {
                    }
                }
            };

    /** 被别的应用抢走焦点 ⇒ 暂停（不 release，等回来继续）。 */
    private void pauseByFocus() {
        try {
            if (mp != null && mp.isPlaying()) {
                mp.pause();
                GmUtil.log("【Music】焦点被抢 ⇒ 已暂停");
                notifyState();
            }
        } catch (Throwable ignore) {
        }
    }

    private void resumeByFocus() {
        try {
            if (mp != null && !mp.isPlaying() && !preparing) {
                mp.start();
                GmUtil.log("【Music】焦点回来 ⇒ 继续播放");
                notifyState();
            }
        } catch (Throwable ignore) {
        }
    }

    /**
     * 请求音频焦点。
     *
     * @return true = 拿到了（可以放心 start）
     */
    private boolean requestFocus() {
        try {
            if (audioMgr == null) {
                Context c = sApp;
                if (c == null) return false;
                audioMgr = (android.media.AudioManager) c.getSystemService(Context.AUDIO_SERVICE);
            }
            if (audioMgr == null) return false;
            int r = audioMgr.requestAudioFocus(focusListener,
                    android.media.AudioManager.STREAM_MUSIC,
                    android.media.AudioManager.AUDIOFOCUS_GAIN);
            hasFocus = (r == android.media.AudioManager.AUDIOFOCUS_REQUEST_GRANTED);
            GmUtil.log("【Music】请求音频焦点 → " + (hasFocus ? "拿到 ✓" : "被拒 ✗")
                    + "（r=" + r + "）");
            return hasFocus;
        } catch (Throwable t) {
            GmUtil.log("【Music】请求焦点异常：" + t);
            return false;
        }
    }

    /** 这个 id 是不是本地曲目？是 ⇒ 返回它的音频 uri（非空）；否 ⇒ null。 */
    public static String localUriOf(long id) {
        try {
            String u = sLocalUri.get(Long.valueOf(id));
            return (u == null || u.isEmpty()) ? null : u;
        } catch (Throwable t) {
            return null;
        }
    }

    /** 按 id 从队列里找曲目（**不看 index**，给"快照里带过来的 id"用）。 */
    public Track trackById(long id) {
        try {
            for (Track t : queue) {
                if (t != null && t.id == id) return t;
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    /** 当前正在放的曲目（可能为 null）。 */
    public Track curTrack() {
        return index >= 0 && index < queue.size() ? queue.get(index) : null;
    }

    /**
     * 找「跟音频同名」的封面图。
     *
     * <p>音频是 {@code content://}（SAF 授权目录）⇒ 不能拼路径，
     * 得用 {@code DocumentsContract} 在**同一个父目录**里按名字找兄弟文档。
     *
     * @return 解码好的 Bitmap；没有同名图 / 解不出来 ⇒ null
     */
    /**
     * 找「跟音频同名」的封面图。
     *
     * <p>音频是 {@code content://}（SAF 授权目录）⇒ 不能拼路径，
     * 得用 {@code DocumentsContract} 在**同一个父目录**里按名字找兄弟文档。
     *
     * <p>★ 2026-11-07 · 后缀**不固定**：遍历 {@link #COVER_EXT}，谁在就用谁
     * （jpg / jpeg / png / webp / bmp / gif / heic / heif 都认）。
     *
     * <p>★ 名字也给两种候选：
     * <ol>
     *   <li><b>文件名</b>（`红色高跟鞋-蔡健雅.mp3` ↔ `红色高跟鞋-蔡健雅.png`）—— 主用法</li>
     *   <li><b>歌名</b>（ID3 里的 title，`红色高跟鞋.png`）—— 兜底，有些人的命名习惯是这样</li>
     * </ol>
     *
     * @return 解码好的 Bitmap；没有同名图 / 解不出来 ⇒ null（**绝不联网**）
     */
    private Bitmap localCover(Track t) {
        if (t == null) return null;
        String audioUri = t.localPath;
        if (audioUri == null || !audioUri.startsWith("content://")) return null;
        // ★ 2026-11-07：**先看用户手动指定的封面**（单曲设置里挑的）
        try {
            GmLocalMusic.Item it = GmLocalMusic.find(sApp, t.name, t.artist);
            if (it != null) {
                String ov = GmLocalMusic.overrideCover(sApp, it.n);
                if (ov != null && ov.length() > 0) {
                    java.io.InputStream in = sApp.getContentResolver()
                            .openInputStream(android.net.Uri.parse(ov));
                    if (in != null) {
                        try {
                            Bitmap b = BitmapFactory.decodeStream(in);
                            if (b != null) {
                                GmUtil.log("【Music】用指定的封面：" + t.name);
                                return b;
                            }
                            GmUtil.log("【Music】指定的封面解不出来：" + ov);
                        } finally {
                            try {
                                in.close();
                            } catch (Throwable ignore) {
                            }
                        }
                    }
                }
            }
        } catch (Throwable ignore) {
        }
        android.net.Uri u = android.net.Uri.parse(audioUri);
        try {
            String docId = android.provider.DocumentsContract.getDocumentId(u);
            int slash = docId.lastIndexOf('/');
            if (slash <= 0) return null;
            String parentId = docId.substring(0, slash);
            String fileName = docId.substring(slash + 1);
            int dot = fileName.lastIndexOf('.');
            String fileBase = dot > 0 ? fileName.substring(0, dot) : fileName;

            // 候选基名（去重、去空）：文件名 → 歌名
            java.util.LinkedHashSet<String> bases = new java.util.LinkedHashSet<String>();
            bases.add(fileBase);
            if (t.name != null && t.name.trim().length() > 0
                    && !t.name.trim().equals(fileBase)) {
                bases.add(t.name.trim());
            }

            String treeId = android.provider.DocumentsContract.getTreeDocumentId(u);
            android.net.Uri treeUri = android.provider.DocumentsContract
                    .buildTreeDocumentUri(u.getAuthority(), treeId);
            android.net.Uri children = android.provider.DocumentsContract
                    .buildChildDocumentsUriUsingTree(treeUri, parentId);

            Context c = sApp;
            if (c == null) return null;
            android.database.Cursor cu = c.getContentResolver().query(children,
                    new String[]{
                            android.provider.DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                            android.provider.DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                    }, null, null, null);
            if (cu == null) {
                GmUtil.log("【Music】列目录失败（封面查不了）：" + children);
                return null;
            }
            StringBuilder seen = new StringBuilder();
            try {
                while (cu.moveToNext()) {
                    String id = cu.getString(0);
                    String name = cu.getString(1);
                    if (id == null || name == null) continue;
                    String lower = name.toLowerCase();
                    if (seen.length() < 200) seen.append(name).append(" | ");
                    // 名字必须**完全等于** 基名 + 某个支持的后缀（不做前缀匹配，
                    // 否则「歌」会误配到「歌 (1).png」这种，用户会觉得"封面不对"）
                    String hitBase = null;
                    String hitExt = null;
                    for (String b : bases) {
                        String bl = b.toLowerCase();
                        if (!lower.startsWith(bl)) continue;
                        String rest = lower.substring(bl.length());
                        for (String e : COVER_EXT) {
                            if (rest.equals(e)) {
                                hitBase = b;
                                hitExt = e;
                                break;
                            }
                        }
                        if (hitExt != null) break;
                    }
                    if (hitExt == null) continue;
                    android.net.Uri doc = android.provider.DocumentsContract
                            .buildDocumentUriUsingTree(treeUri, id);
                    java.io.InputStream in = c.getContentResolver().openInputStream(doc);
                    if (in == null) continue;
                    try {
                        Bitmap b = BitmapFactory.decodeStream(in);
                        if (b != null) {
                            GmUtil.log("【Music】本地封面命中：" + name
                                    + "（基名=" + hitBase + " 后缀=" + hitExt + "）");
                            return b;
                        }
                        GmUtil.log("【Music】封面解不出来：" + name + "（格式可能不支持）");
                    } finally {
                        try {
                            in.close();
                        } catch (Throwable ignore) {
                        }
                    }
                }
            } finally {
                try {
                    cu.close();
                } catch (Throwable ignore) {
                }
            }
            GmUtil.log("【Music】没有同名封面。找过的基名=" + bases
                    + " 后缀=" + java.util.Arrays.toString(COVER_EXT)
                    + " 目录里有：" + seen);
        } catch (Throwable t2) {
            GmUtil.log("【Music】本地封面查找失败：" + t2);
        }
        return null;
    }

    /**
     * 读本地曲目的同名 {@code .lrc}（同目录、同文件名、换后缀）。
     *
     * @return 歌词文本；没有 ⇒ null
     */
    private String localLyric(long id, String audioUri) {
        // ★ 2026-11-07：**先看用户手动指定的 .lrc**（单曲设置里挑的），没有再按同名找
        //
        //  ⚠️ 这里必须用 **id 反查 Track**，不能用 curTrack() ——
        //     卡片的 applyState 拿的是快照，index 可能已经变了，
        //     curTrack() 会跟传入的 id 对不上 ⇒ 覆盖表永远查不到（"指定了没反应"）。
        String doc = null;
        try {
            Track t = trackById(id);
            if (t != null) {
                // 用序号查覆盖表（序号即 UI 上显示的 #N）
                GmLocalMusic.Item it = GmLocalMusic.find(sApp, t.name, t.artist);
                if (it != null) {
                    doc = GmLocalMusic.overrideLrc(sApp, it.n);
                }
            }
        } catch (Throwable ignore) {
        }
        if (doc == null || doc.isEmpty()) doc = findSibling(audioUri, ".lrc");
        if (doc == null) return null;
        java.io.InputStream in = null;
        try {
            Context c = sApp;
            if (c == null) return null;
            in = c.getContentResolver().openInputStream(android.net.Uri.parse(doc));
            if (in == null) return null;
            java.io.ByteArrayOutputStream bo = new java.io.ByteArrayOutputStream();
            byte[] buf = new byte[8192];
            int n;
            while ((n = in.read(buf)) > 0) bo.write(buf, 0, n);
            byte[] raw = bo.toByteArray();
            // LRC 常见 GBK（国内老歌词）⇒ 先试 UTF-8，解出乱码再退 GBK
            String s = new String(raw, "UTF-8");
            if (s.indexOf('\uFFFD') >= 0) {
                try {
                    s = new String(raw, "GBK");
                } catch (Throwable ignore) {
                }
            }
            return s;
        } catch (Throwable t) {
            GmUtil.logOnce("music.localLrc." + Math.abs(audioUri.hashCode()),
                    "读本地 .lrc 失败：" + t);
            return null;
        } finally {
            try {
                if (in != null) in.close();
            } catch (Throwable ignore) {
            }
        }
    }

    /**
     * 在音频**同目录**里找一个「同名、指定后缀」的兄弟文档。
     *
     * @return 该文档的 content uri 字符串；没有 ⇒ null
     */
    private String findSibling(String audioUri, String wantExt) {
        if (audioUri == null || !audioUri.startsWith("content://")) return null;
        try {
            android.net.Uri u = android.net.Uri.parse(audioUri);
            String docId = android.provider.DocumentsContract.getDocumentId(u);
            int slash = docId.lastIndexOf('/');
            if (slash <= 0) return null;
            String parentId = docId.substring(0, slash);
            String fileName = docId.substring(slash + 1);
            int dot = fileName.lastIndexOf('.');
            String base = dot > 0 ? fileName.substring(0, dot) : fileName;
            String want = (base + wantExt).toLowerCase();

            String treeId = android.provider.DocumentsContract.getTreeDocumentId(u);
            android.net.Uri treeUri = android.provider.DocumentsContract
                    .buildTreeDocumentUri(u.getAuthority(), treeId);
            android.net.Uri children = android.provider.DocumentsContract
                    .buildChildDocumentsUriUsingTree(treeUri, parentId);

            Context c = sApp;
            if (c == null) return null;
            android.database.Cursor cu = c.getContentResolver().query(children,
                    new String[]{
                            android.provider.DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                            android.provider.DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                    }, null, null, null);
            if (cu == null) return null;
            try {
                while (cu.moveToNext()) {
                    String id = cu.getString(0);
                    String name = cu.getString(1);
                    if (id == null || name == null) continue;
                    if (!name.toLowerCase().equals(want)) continue;
                    return android.provider.DocumentsContract
                            .buildDocumentUriUsingTree(treeUri, id).toString();
                }
            } finally {
                try {
                    cu.close();
                } catch (Throwable ignore) {
                }
            }
        } catch (Throwable t) {
            GmUtil.logOnce("music.sibling." + Math.abs(audioUri.hashCode()),
                    "找同名文件失败：" + t);
        }
        return null;
    }

    /**
     * 清掉「歌词 / 封面」缓存，让刚在单曲设置里指定的文件**立刻生效**。
     *
     * <p>不清的话：卡片拿的是缓存里的旧 Bitmap/旧歌词，用户会以为"指定了没反应"。
     */
    public void invalidateMediaCache() {
        try {
            sLyricCache.clear();
            sLocalLrcMiss.clear();
            sCoverCache.clear();
            sMediaVer++;
            GmUtil.log("【Music】歌词/封面缓存已清（单曲设置变更后重读，ver="
                    + sMediaVer + "）");
        } catch (Throwable ignore) {
        }
        notifyState();
    }

    /**
     * 「歌词/封面」缓存代次。
     *
     * <p>★ 2026-11-07 加：卡片原来靠「歌词长度变了才重建」判断，
     * 而「恢复默认」常换回一份**长度相同**的不同歌词 ⇒ 永远不重建、显示旧内容。
     * 有了代次，缓存一清卡片就知道「该重读了」。
     */
    private static volatile int sMediaVer = 0;

    public static int mediaVer() {
        return sMediaVer;
    }

    private void putCover(long id, Bitmap b) {
        try {
            if (sCoverCache.size() > 12) sCoverCache.clear();
            sCoverCache.put(Long.valueOf(id), b);
        } catch (Throwable ignore) {
        }
    }

    public void cover(final long id, final Cb<Bitmap> cb) {
        Bitmap cached = sCoverCache.get(Long.valueOf(id));
        if (cached != null && !cached.isRecycled()) {
            cb.on(cached);
            return;
        }
        // ① 先看当前曲目是不是本地、能不能从同名文件拿
        try {
            Track t = trackById(id);
            String luri = localUriOf(id);
            if (t != null && luri != null) {
                Bitmap local = localCover(t);
                if (local != null) {
                    putCover(id, local);
                    cb.on(local);
                    return;
                }
                // 本地没有同名图 ⇒ 直接返回 null，**不要**去联网
                cb.on(null);
                return;
            }
        } catch (Throwable ignore) {
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
        if (cached != null && cached.length() > 0) {
            cb.on(cached);
            return;
        }
        // ★★ 2026-11-07（3.78.6）· **本地曲目读同名 .lrc**
        //
        //  原来 lyric() 只会去网易云要歌词（要 songId）⇒ 本地曲目 id 是负数，
        //  请求必然失败 ⇒ 界面永远「歌词加载中…」/「这首歌没有歌词」。
        //  现在：本地曲目走「同目录同名 .lrc」，读到就缓存，读不到给空串（不联网）。
        try {
            String uri = localUriOf(id);
            if (uri != null) {
                String lrc = localLyric(id, uri);
                if (lrc != null && lrc.length() > 0) {
                    if (sLyricCache.size() > 6) sLyricCache.clear();
                    sLyricCache.put(Long.valueOf(id), lrc);
                    GmUtil.log("【Music】本地歌词命中（" + lrc.length() + " 字）");
                    cb.on(lrc);
                } else {
                    // ★ 关键：**写空串进缓存**，把状态从"未加载"变成"确认没有"
                    if (sLyricCache.size() > 6) sLyricCache.clear();
                    sLyricCache.put(Long.valueOf(id), "");
                    GmUtil.log("【Music】本地曲目没有可用 .lrc ⇒ 暂无歌词（已记入缓存）");
                    cb.on("");
                }
                return;
            }
        } catch (Throwable ignore) {
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

    // ══════════════ ★ 给「提示词变量」用的同步查询（3.57.0）══════════════
    //
    //  为什么单独开一节：下面两个方法是给 GmSysPrompt.inject 用的 —— 那条路是**发消息的热路径**，
    //  纪律比界面严得多：
    //    · **必须同步返回**（不能等网络、不能等回调）
    //    · **绝不联网**：只读 sLyricCache（内存），没命中就交给 GmPromptVars 异步预热
    //    · **绝不落盘**：歌词是版权内容，出这个进程就只能进提示词（且由独立开关把关）
    //
    //  ⚠️ 与 GmMiniBarView.highlight() 用的是**同一套判定**（最后一个 ms[i] <= pos 的行）——
    //     两处若不一致，会出现「卡片高亮这句、提示词说那句」的鬼故事。

    /** 同步取**已经缓存**的歌词（绝不联网、绝不落盘）。null = 还没缓存。 */
    /**
     * 只读缓存（**同步、绝不联网**）—— 给提示词变量这类热路径用。
     *
     * <p>★ 2026-11-07 修：本地曲目的 {@code .lrc} 是**本地文件**，读它既不需要网络
     * 也不需要等待 ⇒ 缓存没有就**当场同步读一次**。
     * 否则第一次 {@code syncLyric} 拿不到、发起的异步回调又没人消费，
     * 就会一直显示「歌词加载中…」（这就是"封面有、歌词没有"的另一半原因）。
     */
    public String cachedLyric(long id) {
        try {
            // ★★ 2026-11-07 修：「歌词一直加载中」的死锁
            //
            //  根因：这里用 "" 同时表示两件事 ——「还没加载」和「确认没有歌词」，
            //  而 GmMiniBarView.syncLyric 看到 len<=0 一律当成"还没加载"
            //  ⇒ 一首真没歌词的歌永远停在「歌词加载中…」，永远settle不下来。
            //
            //  现在的契约（**必须两头一致**）：
            //    · null = 还没加载过（调用方可以再等/再去取）
            //    · ""   = 已经确认没有歌词（调用方要显示「暂无歌词」，别再等）
            //    · 非空 = 歌词正文
            String v = sLyricCache.get(Long.valueOf(id));
            if (v != null) return v;
            // ★ 用登记表判断本地，**不用 curTrack()**（它会跟快照里的 id 对不上）
            String uri = localUriOf(id);
            if (uri != null) {
                String lrc = localLyric(id, uri);
                if (lrc != null && lrc.length() > 0) {
                    if (sLyricCache.size() > 6) sLyricCache.clear();
                    sLyricCache.put(Long.valueOf(id), lrc);
                    GmUtil.log("【Music】本地歌词同步读入（" + lrc.length() + " 字）");
                    return lrc;
                }
                // 确认没有 ⇒ **把空串写进缓存**（这才是 settle），而不是每拍重新算
                if (sLyricCache.size() > 6) sLyricCache.clear();
                sLyricCache.put(Long.valueOf(id), "");
                GmUtil.log("【Music】本地曲目没有可用 .lrc（同名/指定都没有）→ 暂无歌词");
                return "";
            }
            return v;
        } catch (Throwable t) {
            return null;
        }
    }

    /** 记过「这首本地歌没有 .lrc」的 id（避免每 0.5 秒列一次目录）。 */
    private static final java.util.Set<Long> sLocalLrcMiss =
            java.util.Collections.synchronizedSet(new java.util.HashSet<Long>());


    /**
     * 此刻唱到哪一句 —— 返回 {@code {当前, 上一句, 下一句}}，取不到返回 null。
     *
     * <p>前奏（还没唱第一句）时：当前 = 空串，下一句 = 第一句 —— 如实反映「还没开口」，
     * 而不是硬指一句。空串会被 {@code GmPromptVars} 的空值语义处理掉。
     */
    public String[] lyricAround(long id, int pos) {
        String lrc = cachedLyric(id);
        if (lrc == null || lrc.length() == 0) return null;
        Object[] p = parseLrc(lrc);
        if (p == null || p.length < 2) return null;
        long[] ms = (long[]) p[0];
        String[] tx = (String[]) p[1];
        if (ms == null || tx == null || ms.length == 0) return null;

        int idx = -1;
        for (int i = 0; i < ms.length; i++) {
            if (ms[i] <= pos) idx = i;
            else break;
        }
        String cur = idx >= 0 && idx < tx.length ? str(tx[idx]) : "";
        String prev = idx > 0 && idx - 1 < tx.length ? str(tx[idx - 1]) : "";
        String next = idx + 1 < tx.length ? str(tx[idx + 1]) : "";
        if (idx < 0) {                       // 前奏
            prev = "";
            next = tx.length > 0 ? str(tx[0]) : "";
        }
        return new String[]{cur, prev, next};
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
