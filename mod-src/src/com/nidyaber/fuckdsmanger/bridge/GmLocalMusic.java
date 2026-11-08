// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.UriPermission;
import android.database.Cursor;
import android.net.Uri;
import android.provider.DocumentsContract;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 本地曲库（宿主进程侧）🐲 2026-11-07
 *
 * <h2>★ 这条路是怎么走通的（三轮真机取证）</h2>
 *
 * <p><b>第一轮</b>：按绝对路径播 {@code /sdcard/DCIM/fdm/*.mp3}
 * → {@code FileNotFoundException: open failed: EACCES (Permission denied)}。
 * 真因：宿主清单**没有 {@code READ_MEDIA_AUDIO}**（系统连「音乐和音频」权限项都不显示给它），
 * 而且我们不能往别人的清单里加权限 ⇒ <b>这条路在机制上不可能通</b>。
 *
 * <p><b>第二轮</b>：我们自己的 provider 借 fd（{@code content://…config/local/<b64>}）
 * → {@code No content provider}，{@code resolveContentProvider = null}。
 * 真因：<b>Android 11+ 包可见性</b>让宿主看不见我们的 provider
 * （这就是 3.75.x「新 Compose UI 打不开」同一个坑，与权限无关）。
 *
 * <p><b>第三轮（当前）</b>：★ 主人一句话点破 ——「宿主本地是能选图的」。
 * 能选图 ⇒ <b>SAF 那条路对宿主是通的</b>。
 * ⇒ 让宿主自己 {@code ACTION_OPEN_DOCUMENT_TREE} 选一个文件夹，
 * 拿 {@code FLAG_GRANT_READ_URI_PERMISSION} + {@code takePersistableUriPermission}，
 * 之后**重启也还在**，宿主就能用 ContentResolver 读那个目录里的任意文件
 * —— 零权限、不碰 provider、不受包可见性影响。
 *
 * <h2>为什么曲库 = 用户选的文件夹</h2>
 * 把目录写死（{@code /sdcard/DCIM/fdm}）只能靠"能不能按路径读"，而那条路已经死了。
 * 改成**用户自己选**之后，语义反而更直白：你授权的那个文件夹就是曲库。
 */
public final class GmLocalMusic {

    /** 曲库 JSON（UI 推来的那份，给「唱名/歌手」显示与提示词用） */
    public static final String K_JSON = "fuckds_localmusic_json";
    /** 提示词文本（**由宿主自己生成**，因为它才看得见授权目录） */
    public static final String K_TEXT = "fuckds_localmusic_text";
    /** 哪些序号进提示词（JSON 数组如 [1,3]；没写过 = 全选） */
    public static final String K_SEL = "fuckds_localmusic_sel";
    /** ★ 用户通过系统选择器授权的**曲库目录** uri（持久授权，重启还在） */
    public static final String K_TREE = "fuckds_localmusic_tree";

    /** 选目录的 requestCode（跟气泡选图的 0x435b 岔开） */
    public static final int RC_PICK_TREE = 0x4C4D;   // "LM"
    /** 选**多个文件导入**的 requestCode */
    public static final int RC_IMPORT = 0x4C4E;      // "LN"

    private static final String TAG = "【本地音乐】";

    /** 一首本地歌（只读，够播放 + 显示用） */
    public static final class Item {
        public int n;
        public String name = "";
        public String artist = "";
        public String album = "";
        public int dur;
        /** 原始绝对路径（UI 扫出来的；<b>宿主读不了</b>，只当"这是同一首"的键） */
        public String path = "";
        public String uri = "";
        public boolean lrc;
        /**
         * ★ 真正拿去播的 uri：曲库目录（tree）下的 {@code DocumentsContract} 子文档 uri。
         * 只有它才是「宿主有持久读权限」的东西。
         */
        public String playUri = "";

        /** 「歌名 - 歌手」；没有歌手就只有歌名。 */
        public String label() {
            return artist == null || artist.isEmpty() ? name : (name + " - " + artist);
        }

        /** 给 MediaPlayer 用的数据源。 */
        public String source() {
            if (playUri != null && playUri.length() > 0) return playUri;
            return uri == null ? "" : uri;
        }
    }

    private GmLocalMusic() {
    }

    // ══════════════════════════════ 曲库目录（SAF） ══════════════════════════════

    /**
     * 当前曲库目录的**人话版**（给界面显示用）。
     *
     * <p>⚠️ 这一条是踩过坑加的：主人选了个**空文件夹**（`/sdcard/FDM`），
     * 页面显示「0 首」而没显示"曲库是哪个目录" ⇒ 看着像程序坏了。
     * 现在把「扫的是哪个目录」明明白白写出来。
     */
    public static String treeDisplay(Context ctx) {
        String t = tree(ctx);
        if (t == null || t.isEmpty()) return "曲库目录：还没选（点下面的按钮选一个放歌的文件夹）";
        String show = t;
        try {
            String id = DocumentsContract.getTreeDocumentId(Uri.parse(t));
            if (id != null) show = id;
        } catch (Throwable ignore) {
        }
        return "曲库目录：" + show + (treeGranted(ctx, t) ? " ✓" : "（授权已失效，请重选）");
    }

    /** 已经授权的曲库目录；没有 ⇒ 空串。 */
    public static String tree(Context ctx) {
        if (ctx == null) return "";
        try {
            String s = GmStore.read2(ctx, K_TREE, "s");
            return s == null ? "" : s.trim();
        } catch (Throwable t) {
            return "";
        }
    }

    /** 这个 tree uri 还在持久授权里吗？（用户可能去系统设置里撤销） */
    public static boolean treeGranted(Context ctx, String treeUri) {
        if (ctx == null || treeUri == null || treeUri.isEmpty()) return false;
        try {
            Uri u = Uri.parse(treeUri);
            for (UriPermission p : ctx.getContentResolver().getPersistedUriPermissions()) {
                if (p.isReadPermission() && p.getUri().equals(u)) return true;
            }
        } catch (Throwable t) {
            GmUtil.logFail("local.treeGranted", t);
        }
        return false;
    }

    /** 拉起系统选择器，选一个文件夹当曲库。 */
    public static String pickTree(Context ctx) {
        Activity a = currentActivity();
        if (a == null) {
            // 拿不到 Activity 就没法 startActivityForResult —— 老实说，别装成功
            return "拿不到当前 Activity（宿主界面没在前台？）";
        }
        try {
            Intent i = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
            // ★ 读 + **写**都要：读是为了播，写是为了「导入文件」往里放
            i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                    | Intent.FLAG_GRANT_PREFIX_URI_PERMISSION);
            a.startActivityForResult(i, RC_PICK_TREE);
            GmUtil.log("【本地音乐】已拉起「选择文件夹」（requestCode="
                    + RC_PICK_TREE + "）");
            return "已拉起系统选择器，选完就生效";
        } catch (Throwable t) {
            GmUtil.logFail("local.pickTree", t);
            return "拉起选择器失败：" + t;
        }
    }

    /**
     * 拉起「导入文件」（多选，可同时选音频和 .lrc）。
     *
     * <p>⚠️ 必须由**宿主**拉起：回调给的临时读权限挂在**发起者 uid** 上。
     * UI 进程选完文件，宿主依旧读不到（它的 uid 没那个权限）。
     * 这就是「路径写死 + UI 侧导入」那套方案不成立的根因。
     */
    public static String pickImport(Context ctx) {
        if (tree(ctx).isEmpty()) {
            return "先选一个曲库文件夹，再导入文件（不然没地方放）";
        }
        Activity a = currentActivity();
        if (a == null) return "拿不到当前 Activity（宿主界面没在前台？）";
        try {
            Intent i = new Intent(Intent.ACTION_OPEN_DOCUMENT);
            i.addCategory(Intent.CATEGORY_OPENABLE);
            i.setType("*/*");
            i.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
            i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            a.startActivityForResult(i, RC_IMPORT);
            GmUtil.log("【本地音乐】已拉起「导入文件」（多选）");
            return "已拉起文件选择器，选完自动拷进曲库";
        } catch (Throwable t) {
            GmUtil.logFail("local.pickImport", t);
            return "拉起文件选择器失败：" + t;
        }
    }

    /**
     * 把选中的文件**拷进曲库目录**（宿主自己有写权限）。
     *
     * @return 「成功 N / 跳过 M」这种给人看的一句话
     */
    private static String copyInto(Context ctx, List<Uri> srcs) {
        String tree = tree(ctx);
        if (tree.isEmpty()) return "曲库目录还没选";
        Uri treeUri = Uri.parse(tree);
        // tree 根目录的 documentId 就是 authority:path（DocumentsContract 自己拆）
        String rootId = DocumentsContract.getTreeDocumentId(treeUri);
        int ok = 0;
        int skip = 0;
        StringBuilder why = new StringBuilder();
        for (Uri src : srcs) {
            String name = displayName(ctx, src);
            if (name == null || name.isEmpty()) {
                skip++;
                continue;
            }
            String lower = name.toLowerCase();
            boolean isAudio = isAudio(name);
            boolean isLrc = lower.endsWith(".lrc");
            if (!isAudio && !isLrc) {
                skip++;
                if (why.length() < 120) why.append(name).append(" 不是音频/歌词；");
                continue;
            }
            java.io.InputStream in = null;
            java.io.OutputStream out = null;
            try {
                // 目标：在曲库根目录**新建**同名文档
                Uri dst = DocumentsContract.createDocument(
                        ctx.getContentResolver(), treeUri,
                        isLrc ? "text/plain" : "audio/mpeg", name);
                if (dst == null) {
                    skip++;
                    continue;
                }
                in = ctx.getContentResolver().openInputStream(src);
                out = ctx.getContentResolver().openOutputStream(dst);
                if (in == null || out == null) {
                    skip++;
                    continue;
                }
                byte[] buf = new byte[64 * 1024];
                int n;
                long total = 0;
                while ((n = in.read(buf)) > 0) {
                    out.write(buf, 0, n);
                    total += n;
                }
                ok++;
                GmUtil.log("【本地音乐】导入 ✓ " + name + " (" + total + " B)");
            } catch (Throwable t) {
                skip++;
                GmUtil.logFail("local.copyIn/" + name, t);
            } finally {
                try {
                    if (in != null) in.close();
                } catch (Throwable ignore) {
                }
                try {
                    if (out != null) out.close();
                } catch (Throwable ignore) {
                }
            }
        }
        GmUtil.log("【本地音乐】导入结束：成功 " + ok + " / 跳过 " + skip);
        return "导入完成：成功 " + ok + " 个"
                + (skip > 0 ? ("，跳过 " + skip + " 个" + (why.length() > 0 ? "（" + why + "）" : "")) : "");
    }

    /** 取文件名（SAF 的 DISPLAY_NAME 列）。 */
    private static String displayName(Context ctx, Uri u) {
        Cursor c = null;
        try {
            c = ctx.getContentResolver().query(u,
                    new String[]{android.provider.OpenableColumns.DISPLAY_NAME},
                    null, null, null);
            if (c != null && c.moveToFirst()) return c.getString(0);
        } catch (Throwable ignore) {
        } finally {
            try {
                if (c != null) c.close();
            } catch (Throwable ignore) {
            }
        }
        return u == null ? null : u.getLastPathSegment();
    }

    /**
     * 处理选择器回调。
     *
     * @return true = 是我们的事（调用方别再把 result 传下去）
     */
    public static boolean onPickResult(Context ctx, int requestCode, int resultCode, Intent data) {
        if (requestCode != RC_PICK_TREE && requestCode != RC_IMPORT
                && requestCode != RC_PICK_LRC && requestCode != RC_PICK_COVER) {
            return false;
        }

        // ── ③ 单曲设置：给某首挑歌词 / 封面 ──
        if (requestCode == RC_PICK_LRC || requestCode == RC_PICK_COVER) {
            boolean lrc = (requestCode == RC_PICK_LRC);
            int n = sPickFor;
            sPickFor = -1;
            if (resultCode != Activity.RESULT_OK || data == null || data.getData() == null) {
                GmUtil.log("【本地音乐】" + (lrc ? "歌词" : "封面") + "选择被取消");
                return true;
            }
            Uri u = data.getData();
            // ★ 持久化读权限：不然重启后那个 uri 又读不了了
            try {
                ctx.getContentResolver().takePersistableUriPermission(
                        u, Intent.FLAG_GRANT_READ_URI_PERMISSION);
            } catch (Throwable t) {
                GmUtil.log("【本地音乐】takePersistable(单曲) 失败（不影响本次）：" + t);
            }
            putOverride(ctx, n, lrc ? "lrc" : "cover", u.toString());
            String r = "#" + n + " " + (lrc ? "歌词" : "封面") + " 已指定：" + u;
            GmUtil.log("【本地音乐】" + r);
            try {
                GmStore.write(ctx, "fuckds_localmusic_last", r, "s");
            } catch (Throwable ignore) {
            }
            // 让它立刻重读（清缓存，下一拍重新取）
            GmMusicPlayer.get().invalidateMediaCache();
            return true;
        }

        // ── ① 导入文件（多选） ──
        if (requestCode == RC_IMPORT) {
            if (resultCode != Activity.RESULT_OK || data == null) {
                GmUtil.log("【本地音乐】导入被取消");
                return true;
            }
            List<Uri> srcs = new ArrayList<Uri>();
            // 多选：getClipData；单选：getData
            android.content.ClipData clip = data.getClipData();
            if (clip != null) {
                for (int i = 0; i < clip.getItemCount(); i++) {
                    Uri u = clip.getItemAt(i).getUri();
                    if (u != null) srcs.add(u);
                }
            } else if (data.getData() != null) {
                srcs.add(data.getData());
            }
            GmUtil.log("【本地音乐】待导入 " + srcs.size() + " 个文件");
            String r = copyInto(ctx, srcs);
            GmUtil.log("【本地音乐】" + r);
            try {
                GmStore.write(ctx, "fuckds_localmusic_last", r, "s");
            } catch (Throwable ignore) {
            }
            return true;
        }

        // ── ② 选曲库目录 ──
        if (resultCode != Activity.RESULT_OK || data == null || data.getData() == null) {
            GmUtil.log("【本地音乐】选择文件夹被取消");
            return true;
        }
        Uri tree = data.getData();
        int flags = data.getFlags()
                & (Intent.FLAG_GRANT_READ_URI_PERMISSION
                | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        try {
            // ★ 读 + 写都要持久化（写是为了「导入文件」往里放）
            ctx.getContentResolver().takePersistableUriPermission(tree, flags);
            GmUtil.log("【本地音乐】✅ 已拿到持久授权（读+写 flags=" + flags + "）：" + tree);
        } catch (Throwable t) {
            GmUtil.logFail("local.takePersist", t);
        }
        try {
            GmStore.write(ctx, K_TREE, tree.toString(), "s");
        } catch (Throwable t) {
            GmUtil.logFail("local.saveTree", t);
        }
        List<Item> list = scan(ctx);
        GmUtil.log("【本地音乐】曲库目录已设定，扫到 " + list.size() + " 首");
        return true;
    }

    // ══════════════════════════════ 扫描（走 ContentResolver） ══════════════════════════════

    /**
     * 扫曲库目录（递归子目录）—— <b>这是曲库的唯一真源</b>。
     *
     * <p>为什么扫描必须在宿主做：SAF 的持久授权记在**宿主的 uid** 上，
     * 我们自己的 UI 进程根本用不了那个授权（它连文件都读不到）。
     *
     * <p>顺手把 ID3 也读了（{@code MediaMetadataRetriever(Context, Uri)} 吃 content uri），
     * 读不到就退回文件名。
     */
    public static List<Item> scan(Context ctx) {
        List<Item> out = new ArrayList<Item>();
        String tree = tree(ctx);
        if (tree.isEmpty() || !treeGranted(ctx, tree)) {
            GmUtil.logOnce("local.noTree",
                    "曲库目录还没授权（或授权被撤销）⇒ 先点「选择文件夹」");
            return out;
        }
        LinkedHashMapUri found = new LinkedHashMapUri();
        // ★ 第一层用 **getTreeDocumentId**（tree uri 只能这么取 id）
        String rootId;
        try {
            rootId = DocumentsContract.getTreeDocumentId(Uri.parse(tree));
        } catch (Throwable t) {
            GmUtil.log("【本地音乐】取 tree documentId 失败：" + t);
            return out;
        }
        collect(ctx, Uri.parse(tree), rootId, found, 0);
        int n = 0;
        for (java.util.Map.Entry<Uri, String> e : found.entrySet()) {
            Item it = new Item();
            it.n = ++n;
            it.playUri = e.getKey().toString();
            it.uri = it.playUri;
            String disp = e.getValue();
            it.name = disp == null ? "" : disp;
            readTags(ctx, it, disp);              // 读 ID3（读不到就只用文件名）
            out.add(it);
        }
        GmUtil.logOnce("local.treeScan",
                "曲库目录扫到 " + out.size() + " 首（tree=" + tree + "）");
        return out;
    }

    /** 小工具：保持插入顺序的 Uri→名字表。 */
    private static final class LinkedHashMapUri
            extends java.util.LinkedHashMap<Uri, String> {
    }

    /**
     * 读 ID3：歌名 / 歌手 / 专辑 / 时长。
     *
     * <p>必须用 {@code setDataSource(Context, Uri)} —— 只有这个重载能吃 content uri。
     */
    private static void readTags(Context ctx, Item it, String dispName) {
        String fallback = dispName == null ? "" : dispName;
        int dot = fallback.lastIndexOf('.');
        if (dot > 0) fallback = fallback.substring(0, dot);
        it.name = fallback;
        android.media.MediaMetadataRetriever m = new android.media.MediaMetadataRetriever();
        try {
            m.setDataSource(ctx, Uri.parse(it.playUri));
            String t = m.extractMetadata(
                    android.media.MediaMetadataRetriever.METADATA_KEY_TITLE);
            String a = m.extractMetadata(
                    android.media.MediaMetadataRetriever.METADATA_KEY_ARTIST);
            String al = m.extractMetadata(
                    android.media.MediaMetadataRetriever.METADATA_KEY_ALBUM);
            String d = m.extractMetadata(
                    android.media.MediaMetadataRetriever.METADATA_KEY_DURATION);
            if (t != null && t.trim().length() > 0) it.name = t.trim();
            if (a != null && a.trim().length() > 0 && !"<unknown>".equals(a)) {
                it.artist = a.trim();
            }
            if (al != null && al.trim().length() > 0 && !"<unknown>".equals(al)) {
                it.album = al.trim();
            }
            if (d != null) {
                try {
                    it.dur = Integer.parseInt(d.trim());
                } catch (Throwable ignore) {
                }
            }
        } catch (Throwable t) {
            // 元数据读不出来不是错误（有的文件就没标签）⇒ 只用文件名
            GmUtil.logOnce("local.tagFail." + Math.abs(it.playUri.hashCode()),
                    "读标签失败（退回文件名）：" + it.playUri + " · " + t);
        } finally {
            try {
                m.release();
            } catch (Throwable ignore) {
            }
        }
    }

    /**
     * 递归收集目录下的音频文件（最多 4 层，防炸）。
     *
     * <p>⚠️⚠️ 这里踩过一个很隐蔽的坑（3.78.4 修）：
     * 第一层传进来的 {@code dir} 是 **tree uri**（`.../tree/primary%3ADCIM%2Ffdm`），
     * 而 {@code DocumentsContract.getDocumentId(treeUri)} 会**直接抛**
     * {@code IllegalArgumentException: Invalid URI} —— tree uri 上没有 document id，
     * 要用 {@link DocumentsContract#getTreeDocumentId}。
     * 结果就是：query 明明能返回 4 行，但因为第一行就抛异常、被 logFail 吞掉，
     * 一个文件都没加进去 ⇒ 界面永远显示 0 首。
     *
     * @param dir   可以是 tree uri（第一层），也可以是普通 document uri（递归层）
     * @param docId 这一层对应的 document id（由调用方算好，别再自己猜）
     */
    private static void collect(Context ctx, Uri dir, String docId,
                                LinkedHashMapUri out, int depth) {
        if (depth > 4 || out.size() > 2000) return;
        Cursor c = null;
        try {
            Uri children = DocumentsContract.buildChildDocumentsUriUsingTree(dir, docId);
            c = ctx.getContentResolver().query(children,
                    new String[]{
                            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                            DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                            DocumentsContract.Document.COLUMN_MIME_TYPE,
                    }, null, null, null);
            if (c == null) {
                GmUtil.log("【本地音乐】query 返回 null（" + children + "）");
                return;
            }
            while (c.moveToNext()) {
                String id = c.getString(0);
                String name = c.getString(1);
                String mime = c.getString(2);
                if (id == null || name == null) continue;
                if (DocumentsContract.Document.MIME_TYPE_DIR.equals(mime)) {
                    // ★ 递归：docId 用子目录自己的 id（不是 dir 的！）
                    collect(ctx, dir, id, out, depth + 1);
                } else if (isAudio(name)) {
                    Uri u = DocumentsContract.buildDocumentUriUsingTree(dir, id);
                    if (!out.containsKey(u)) out.put(u, name);
                }
            }
        } catch (Throwable t) {
            // ⚠️ 第一版这里只 logFail ⇒ 异常被吞、界面永远 0 首。
            //   现在**必须**在常规日志里留一行（logFail 只进 DIAG 缓冲）。
            GmUtil.log("【本地音乐】collect 失败 depth=" + depth + " docId=" + docId
                    + " · " + t);
        } finally {
            try {
                if (c != null) c.close();
            } catch (Throwable ignore) {
            }
        }
    }

    private static boolean isAudio(String name) {
        String n = name.toLowerCase();
        return n.endsWith(".mp3") || n.endsWith(".flac") || n.endsWith(".m4a")
                || n.endsWith(".aac") || n.endsWith(".ogg") || n.endsWith(".opus")
                || n.endsWith(".wav") || n.endsWith(".wma") || n.endsWith(".ape")
                || n.endsWith(".alac");
    }

    /**
     * 诊断：把扫描的**每一步**都打出来（不受 logOnce 限制，每次都打）。
     *
     * <p>为什么需要它：`collect()` 里任何异常都被 {@code logFail} 吞进 DIAG 缓冲，
     * 而树扫描用的是 {@code logOnce}（只打第一次）⇒
     * 「选什么都是 0 首」这种情况在日志里**什么都看不到**，只能靠这个探针。
     */
    public static String diag(Context ctx) {
        StringBuilder b = new StringBuilder();
        b.append("uid=").append(android.os.Process.myUid());
        String t = tree(ctx);
        b.append("\ntree=").append(t == null || t.isEmpty() ? "（空）" : t);
        if (t == null || t.isEmpty()) {
            b.append("\n⇒ 还没选目录");
            return b.toString();
        }
        Uri treeUri = Uri.parse(t);
        b.append("\n授权在=").append(treeGranted(ctx, t));
        try {
            b.append("\ngetTreeDocumentId=").append(DocumentsContract.getTreeDocumentId(treeUri));
        } catch (Throwable e) {
            b.append("\ngetTreeDocumentId 抛：").append(err(e));
        }
        try {
            b.append("\ngetDocumentId=").append(DocumentsContract.getDocumentId(treeUri));
        } catch (Throwable e) {
            b.append("\ngetDocumentId 抛：").append(err(e));
        }
        // 直接 query 一次子项（不打 logOnce）
        try {
            String id = DocumentsContract.getTreeDocumentId(treeUri);
            Uri children = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, id);
            b.append("\nchildrenUri=").append(children);
            Cursor c = ctx.getContentResolver().query(children, new String[]{
                    DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                    DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                    DocumentsContract.Document.COLUMN_MIME_TYPE,
                    DocumentsContract.Document.COLUMN_SIZE,
            }, null, null, null);
            if (c == null) {
                b.append("\nquery → null（provider 没给 cursor）");
            } else {
                int n = c.getCount();
                b.append("\nquery → ").append(n).append(" 行");
                int k = 0;
                while (c.moveToNext() && k < 12) {
                    b.append("\n  [").append(k).append("] ")
                            .append(c.getString(1)).append(" · ")
                            .append(c.getString(2)).append(" · ")
                            .append(c.isNull(3) ? "?" : c.getLong(3));
                    k++;
                }
                c.close();
            }
        } catch (Throwable e) {
            b.append("\nquery 抛：").append(err(e));
        }
        // 用 MediaStore 的方式再探一次（同目录，按路径）
        try {
            String id = DocumentsContract.getTreeDocumentId(treeUri);
            String path = "/storage/emulated/0/" + id.substring(id.indexOf(':') + 1);
            File f = new File(path);
            b.append("\n路径猜测=").append(path).append(" exists=").append(f.exists())
                    .append(" isDir=").append(f.isDirectory());
            if (f.isDirectory()) {
                String[] names = f.list();
                b.append(" list=").append(names == null ? "null" : String.valueOf(names.length));
            }
        } catch (Throwable e) {
            b.append("\n路径猜测抛：").append(err(e));
        }
        return b.toString();
    }

    private static String err(Throwable t) {
        String m = t.getMessage();
        return t.getClass().getSimpleName() + (m == null ? "" : ": " + m);
    }

    // ══════════════════════════════ 读骨架 / 挑选 ══════════════════════════════

    /** 读 UI 推来的曲库骨架（不含 playUri）。 */
    public static List<Item> all(Context ctx) {
        List<Item> out = new ArrayList<Item>();
        if (ctx == null) return out;
        String raw;
        try {
            raw = GmStore.read2(ctx, K_JSON, "s");
        } catch (Throwable t) {
            GmUtil.logFail("local.all", t);
            return out;
        }
        if (raw == null || raw.trim().isEmpty()) return out;
        try {
            JSONArray a = new JSONArray(raw);
            for (int i = 0; i < a.length(); i++) {
                JSONObject o = a.optJSONObject(i);
                if (o == null) continue;
                Item it = new Item();
                it.n = o.optInt("n", i + 1);
                it.name = o.optString("name", "");
                it.artist = o.optString("artist", "");
                it.album = o.optString("album", "");
                it.dur = o.optInt("dur", 0);
                it.path = o.optString("path", "");
                it.uri = o.optString("uri", "");
                it.lrc = o.optBoolean("lrc", false);
                if (it.name.isEmpty() && it.path.isEmpty()) continue;
                out.add(it);
            }
        } catch (Throwable t) {
            GmUtil.logFail("local.all/parse(len=" + raw.length() + ")", t);
        }
        return out;
    }

    /**
     * 按 spec 挑一首：纯序号优先，否则「歌名-歌手」匹配。
     *
     * <p>序号容忍 {@code 3} / {@code #3} / {@code 3.}（模型常这么写）。
     */
    public static Item pick(Context ctx, String spec) {
        if (spec == null || spec.trim().isEmpty()) return null;
        String s = spec.trim();
        List<Item> list = scan(ctx);              // ★ 以扫出来的为准（它才带 playUri）
        if (list.isEmpty()) return null;

        String digits = s.replaceAll("[^0-9]", "");
        boolean looksLikeIndex = digits.length() > 0 && digits.length() <= 4
                && s.replaceAll("[0-9#.\\s]", "").isEmpty();
        if (looksLikeIndex) {
            int n = -1;
            try {
                n = Integer.parseInt(digits);
            } catch (Throwable ignore) {
            }
            for (Item it : list) {
                if (it.n == n) return it;
            }
        }

        String song = s;
        String artist = "";
        int sep = firstSep(s);
        if (sep > 0) {
            song = s.substring(0, sep).trim();
            artist = s.substring(sep + 1).trim();
        }
        Item hit = find(ctx, song, artist);
        return hit != null ? hit : find(ctx, s, "");
    }

    /** 按「歌名（+ 歌手）」找。先严后松，命中即返回。 */
    public static Item find(Context ctx, String song, String artist) {
        if (song == null || song.trim().isEmpty()) return null;
        String s = norm(song);
        String a = norm(artist);
        if (s.isEmpty()) return null;
        List<Item> list = scan(ctx);

        for (Item it : list) {
            if (!norm(it.name).equals(s)) continue;
            if (a.isEmpty()) return it;
            String ia = norm(it.artist);
            if (!ia.isEmpty() && (ia.contains(a) || a.contains(ia))) return it;
        }
        for (Item it : list) {
            if (norm(it.name).equals(s)) return it;
        }
        for (Item it : list) {
            String n = norm(it.name);
            if (n.isEmpty()) continue;
            if (!(n.contains(s) || s.contains(n))) continue;
            if (a.isEmpty()) return it;
            String ia = norm(it.artist);
            if (!ia.isEmpty() && (ia.contains(a) || a.contains(ia))) return it;
        }
        return null;
    }

    /** 分隔符：`-`（含全角/长短横）、`|` 里最靠前的那个。 */
    private static int firstSep(String s) {
        int best = -1;
        for (char c : new char[]{'-', '\u2013', '\u2014', '\uFF0D', '|'}) {
            int i = s.indexOf(c);
            if (i > 0 && (best < 0 || i < best)) best = i;
        }
        return best;
    }

    /** 归一化：小写 + 只留字母数字（空白、括号、逗号、点、横线全去掉）。 */
    private static String norm(String s) {
        if (s == null) return "";
        StringBuilder b = new StringBuilder(s.length());
        for (int i = 0; i < s.length(); i++) {
            char c = Character.toLowerCase(s.charAt(i));
            if (Character.isLetterOrDigit(c)) b.append(c);
        }
        return b.toString();
    }

    // ══════════════════════════════ 提示词文本（宿主生成） ══════════════════════════════

    /** 读「哪些序号进提示词」；没写过 / 解析失败 ⇒ 空集（= 全选）。 */
    private static java.util.HashSet<Integer> selSet(Context ctx) {
        java.util.HashSet<Integer> out = new java.util.HashSet<Integer>();
        if (ctx == null) return out;
        try {
            String raw = GmStore.read2(ctx, K_SEL, "s");
            if (raw == null || raw.trim().isEmpty()) return out;
            JSONArray a = new JSONArray(raw);
            for (int i = 0; i < a.length(); i++) out.add(a.optInt(i, -1));
        } catch (Throwable ignore) {
        }
        return out;
    }

    /**
     * 生成「本地歌单」那段提示词（带序号）。
     *
     * <p>⚠️ 序号 = <b>扫出来的顺序 ∩ 勾选</b>，和 {@link #pick} 用的是同一套编号
     * —— 否则界面显示的 #N 和模型写的 N 对不上，点播就会放错歌。
     *
     * @return 空串 = 没有歌 / 没勾任何一首
     */
    public static String promptText(Context ctx) {
        List<Item> list = scan(ctx);
        java.util.HashSet<Integer> sel = selSet(ctx);
        boolean hasSel = !sel.isEmpty();
        List<Item> chosen = new ArrayList<Item>();
        for (Item it : list) {
            if (!hasSel || sel.contains(it.n)) chosen.add(it);
        }
        if (chosen.isEmpty()) return "";
        StringBuilder b = new StringBuilder();
        b.append("本地歌单（共 ").append(chosen.size()).append(" 首，序号可直接引用）：\n");
        for (int i = 0; i < chosen.size(); i++) {
            Item it = chosen.get(i);
            b.append(i + 1).append(". ").append(it.name);
            if (it.artist != null && it.artist.length() > 0) {
                b.append(" - ").append(it.artist);
            }
            b.append('\n');
        }
        return b.toString().trim();
    }

    /** 把曲库写成 JSON（给 UI 显示用；不含敏感路径，只有序号/名字/时长/是否有歌词）。 */
    public static String listJson(Context ctx) {
        List<Item> list = scan(ctx);
        JSONArray a = new JSONArray();
        for (Item it : list) {
            try {
                JSONObject o = new JSONObject();
                o.put("n", it.n);
                o.put("name", it.name);
                o.put("artist", it.artist);
                o.put("album", it.album);
                o.put("dur", it.dur);
                o.put("uri", it.playUri);
                o.put("lrc", false);          // .lrc 这一版还没做（下一轮）
                a.put(o);
            } catch (Throwable ignore) {
            }
        }
        return a.toString();
    }

    /** UI 送来勾选（JSON 数组，如 [1,3]），并顺手把提示词文本重算一遍。 */
    public static String setSel(Context ctx, String jsonArray) {
        try {
            GmStore.write(ctx, K_SEL, jsonArray == null ? "[]" : jsonArray, "s");
        } catch (Throwable t) {
            GmUtil.logFail("local.setSel", t);
        }
        String text = promptText(ctx);
        try {
            GmStore.write(ctx, K_TEXT, text, "s");
        } catch (Throwable ignore) {
        }
        GmUtil.log("【本地音乐】勾选已更新 → " + jsonArray + "，提示词 " + text.length() + " 字");
        return text;
    }

    // ══════════════════════════════ ★ 单曲设置（歌词/封面指定） ══════════════════════════════
    //
    //  主人 2026-11-07：「点击列表对应项目打开对应歌曲单独设置（歌词文件在哪里，封面在哪里）」
    //
    //  设计：
    //    · 默认按「同名文件」自动配对（.lrc / 图片）
    //    · 用户可以手动指定任意文件 ⇒ 记在 K_OVERRIDE（序号 → {lrc: uri, cover: uri}）
    //    · 一切 uri 都由**宿主**拉起选择器获取（授权记在宿主 uid 上，UI 拉起没用）

    /** 手动指定的覆盖表（JSON：{"3":{"lrc":"content://...","cover":"content://..."}}） */
    public static final String K_OVERRIDE = "fuckds_localmusic_override";
    /** 选歌词文件的 requestCode */
    public static final int RC_PICK_LRC = 0x4C4F;
    /** 选封面图片的 requestCode */
    public static final int RC_PICK_COVER = 0x4C50;

    /** 读覆盖表。 */
    private static JSONObject overrides(Context ctx) {
        if (ctx == null) return new JSONObject();
        try {
            String raw = GmStore.read2(ctx, K_OVERRIDE, "s");
            if (raw == null || raw.trim().isEmpty()) return new JSONObject();
            return new JSONObject(raw);
        } catch (Throwable t) {
            return new JSONObject();
        }
    }

    /** 取某首的覆盖（没有 ⇒ 空对象）。 */
    private static JSONObject overrideOf(Context ctx, int n) {
        JSONObject all = overrides(ctx);
        JSONObject o = all.optJSONObject(String.valueOf(n));
        return o == null ? new JSONObject() : o;
    }

    /** 这首手动指定的 .lrc uri（没有 ⇒ 空串）。 */
    public static String overrideLrc(Context ctx, int n) {
        return overrideOf(ctx, n).optString("lrc", "");
    }

    /** 这首手动指定的封面 uri（没有 ⇒ 空串）。 */
    public static String overrideCover(Context ctx, int n) {
        return overrideOf(ctx, n).optString("cover", "");
    }

    /** 写一条覆盖（lrc 或 cover）。 */
    private static void putOverride(Context ctx, int n, String key, String uri) {
        try {
            JSONObject all = overrides(ctx);
            JSONObject o = all.optJSONObject(String.valueOf(n));
            if (o == null) o = new JSONObject();
            if (uri == null || uri.isEmpty()) o.remove(key);
            else o.put(key, uri);
            all.put(String.valueOf(n), o);
            GmStore.write(ctx, K_OVERRIDE, all.toString(), "s");
        } catch (Throwable t) {
            GmUtil.logFail("local.putOverride", t);
        }
    }

    /**
     * 单曲设置里显示的「现在用的是什么」。
     *
     * @param spec 序号 / 歌名-歌手
     */
    public static String meta(Context ctx, String spec) {
        Item it = pick(ctx, spec);
        if (it == null) return "曲库里没有这首歌：" + spec;
        StringBuilder b = new StringBuilder();
        b.append("#").append(it.n).append(' ').append(it.label());
        b.append("\nlrc_override=").append(overrideLrc(ctx, it.n).isEmpty()
                ? "无（用同名）" : overrideLrc(ctx, it.n));
        b.append("\ncover_override=").append(overrideCover(ctx, it.n).isEmpty()
                ? "无（用同名）" : overrideCover(ctx, it.n));
        b.append("\n自动配对的 .lrc=").append(hasSibling(ctx, it.playUri, ".lrc")
                ? "有" : "无");
        b.append("\n自动配对的封面=").append(autoCoverName(ctx, it.playUri));
        return b.toString();
    }

    /** 指定歌词/封面：arg = "序号|uri"（uri 空 = 清除，回到同名自动配对） */
    public static String setOverride(Context ctx, String arg, boolean lrc) {
        if (arg == null) return "参数为空";
        int bar = arg.indexOf('|');
        String no = bar < 0 ? arg : arg.substring(0, bar);
        String uri = bar < 0 ? "" : arg.substring(bar + 1).trim();
        int n;
        try {
            n = Integer.parseInt(no.trim());
        } catch (Throwable t) {
            return "序号不对：" + no;
        }
        putOverride(ctx, n, lrc ? "lrc" : "cover", uri);
        return (lrc ? "歌词" : "封面") + (uri.isEmpty()
                ? "已恢复为同名自动配对" : "已指定");
    }

    /** 拉起选择器给某首挑文件（lrc=true 挑歌词，否则挑图片）。 */
    public static String pickFileFor(Context ctx, String spec, boolean lrc) {
        Item it = pick(ctx, spec);
        if (it == null) return "曲库里没有这首歌：" + spec;
        Activity a = currentActivity();
        if (a == null) return "拿不到当前 Activity（宿主界面没在前台？）";
        sPickFor = it.n;
        sPickIsLrc = lrc;
        try {
            Intent i = new Intent(Intent.ACTION_OPEN_DOCUMENT);
            i.addCategory(Intent.CATEGORY_OPENABLE);
            i.setType(lrc ? "*/*" : "image/*");
            i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION
                    | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
            a.startActivityForResult(i, lrc ? RC_PICK_LRC : RC_PICK_COVER);
            GmUtil.log("【本地音乐】已拉起" + (lrc ? "歌词" : "封面")
                    + "选择器（# " + it.n + "）");
            return "已拉起选择器，选完即生效";
        } catch (Throwable t) {
            GmUtil.logFail("local.pickFileFor", t);
            return "拉起失败：" + t;
        }
    }

    /** 正在等哪个文件（-1 = 没在等） */
    private static int sPickFor = -1;
    private static boolean sPickIsLrc = false;

    /**
     * 音频同目录里有没有「同名 + 指定后缀」的兄弟文件。
     *
     * <p>⚠️ 音频是 content://（SAF 授权目录）⇒ 不能拼路径，
     * 必须用 DocumentsContract 在**同一个父目录**里按名字找。
     */
    public static boolean hasSibling(Context ctx, String audioUri, String wantExt) {
        return findSiblingUri(ctx, audioUri, wantExt) != null;
    }

    /** 找同名兄弟文件，返回它的 content uri；没有 ⇒ null。 */
    public static String findSiblingUri(Context ctx, String audioUri, String wantExt) {
        if (ctx == null || audioUri == null || !audioUri.startsWith("content://")) return null;
        try {
            Uri u = Uri.parse(audioUri);
            String docId = DocumentsContract.getDocumentId(u);
            int slash = docId.lastIndexOf('/');
            if (slash <= 0) return null;
            String parentId = docId.substring(0, slash);
            String fileName = docId.substring(slash + 1);
            int dot = fileName.lastIndexOf('.');
            String base = dot > 0 ? fileName.substring(0, dot) : fileName;
            String want = (base + wantExt).toLowerCase();

            String treeId = DocumentsContract.getTreeDocumentId(u);
            Uri treeUri = DocumentsContract.buildTreeDocumentUri(u.getAuthority(), treeId);
            Uri children = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, parentId);
            Cursor c = ctx.getContentResolver().query(children, new String[]{
                    DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                    DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            }, null, null, null);
            if (c == null) return null;
            try {
                while (c.moveToNext()) {
                    String id = c.getString(0);
                    String name = c.getString(1);
                    if (id == null || name == null) continue;
                    if (!name.toLowerCase().equals(want)) continue;
                    return DocumentsContract.buildDocumentUriUsingTree(treeUri, id).toString();
                }
            } finally {
                try {
                    c.close();
                } catch (Throwable ignore) {
                }
            }
        } catch (Throwable t) {
            GmUtil.logOnce("local.sibling." + Math.abs(audioUri.hashCode()),
                    "找同名文件失败：" + t);
        }
        return null;
    }

    /** 认的封面图片后缀（跟 GmMusicPlayer.COVER_EXT 保持一致） */
    private static final String[] COVER_EXT = {
            ".jpg", ".jpeg", ".png", ".webp", ".bmp", ".gif", ".heic", ".heif"
    };

    /**
     * 自动配对到的封面**文件名**（给单曲设置页显示"现在用的是哪个"）。
     *
     * @return 找到 ⇒ 文件名；没有 ⇒ "无"
     */
    public static String autoCoverName(Context ctx, String audioUri) {
        for (String e : COVER_EXT) {
            String u = findSiblingUri(ctx, audioUri, e);
            if (u != null) {
                // 从 uri 里取显示名（最后一段解码）
                try {
                    return Uri.decode(u.substring(u.lastIndexOf('/') + 1))
                            + "（" + e + "）";
                } catch (Throwable ignore) {
                    return e;
                }
            }
        }
        return "无";
    }

    // ══════════════════════════════ 诊断 ══════════════════════════════

    /** 真机探针：授权在不在、目录里有多少首、第一首能不能真开。 */
    public static String probe(Context ctx) {
        StringBuilder b = new StringBuilder();
        b.append("uid=").append(android.os.Process.myUid());
        String tree = tree(ctx);
        b.append("\n曲库目录=").append(tree.isEmpty() ? "（未设置）" : tree);
        if (!tree.isEmpty()) {
            b.append("\n  授权还在=").append(treeGranted(ctx, tree));
        }
        List<Item> raw = all(ctx);
        b.append("\nUI 推来的歌=").append(raw.size()).append(" 首");

        List<Item> list = scan(ctx);
        int playable = 0;
        for (Item it : list) {
            boolean ok = it.playUri != null && !it.playUri.isEmpty();
            if (ok) playable++;
            b.append("\n  #").append(it.n).append(' ').append(it.label())
                    .append(" → ").append(ok ? "有播放uri" : "目录里找不到这个文件");
            if (ok) {
                String why = tryOpen(ctx, it.playUri);
                b.append(why == null ? " · 真开✓" : (" · 真开✗ " + why));
            }
        }
        b.append("\n可播 ").append(playable).append('/').append(list.size());
        return b.toString();
    }

    /** 用宿主身份真开一次 uri；null = 能读。 */
    private static String tryOpen(Context ctx, String uriStr) {
        java.io.InputStream in = null;
        try {
            in = ctx.getContentResolver().openInputStream(Uri.parse(uriStr));
            if (in == null) return "stream=null";
            byte[] head = new byte[16];
            int n = in.read(head);
            return n > 0 ? null : "空文件";
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
     * 当前前台 Activity。
     *
     * <p>先找**底座**那个 `com.nidyaber.fuckdsmanger.gm.GmEntry.sAct`
     * （包级私有 ⇒ 必须 setAccessible，这是踩过的坑：
     * {@code IllegalAccessError: Field … is inaccessible}）；
     * 找不到再找桥自己的 {@code bridge.FdmEntry}（如果有同名缓存）。
     */
    private static Activity currentActivity() {
        // ① 底座 GmEntry.sAct
        try {
            Class<?> e = Class.forName("com.nidyaber.fuckdsmanger.gm.GmEntry",
                    false, GmLocalMusic.class.getClassLoader());
            java.lang.reflect.Field f = e.getDeclaredField("sAct");
            f.setAccessible(true);
            Object o = f.get(null);
            if (o instanceof Activity) return (Activity) o;
        } catch (Throwable t) {
            GmUtil.logOnce("local.noAct", "取底座 GmEntry.sAct 失败（换个来源再试）：" + t);
        }
        // ② ActivityThread 里当前 resume 的 Activity（不需要知道任何混淆名）
        try {
            Class<?> at = Class.forName("android.app.ActivityThread");
            Object cur = at.getMethod("currentActivityThread").invoke(null);
            java.lang.reflect.Field f = at.getDeclaredField("mActivities");
            f.setAccessible(true);
            Object map = f.get(cur);
            if (map instanceof java.util.Map) {
                for (Object rec : ((java.util.Map<?, ?>) map).values()) {
                    if (rec == null) continue;
                    java.lang.reflect.Field af = rec.getClass().getDeclaredField("activity");
                    af.setAccessible(true);
                    Object a = af.get(rec);
                    if (a instanceof Activity) return (Activity) a;
                }
            }
        } catch (Throwable ignore) {
        }
        return null;
    }
}
