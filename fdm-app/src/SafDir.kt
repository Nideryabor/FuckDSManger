// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import android.util.Log
import com.nidyaber.fuckdsmanger.bridge.FdmPush

/**
 * UI 侧的 SAF 目录授权 🐲 2026-11-07
 *
 * <h3>为什么 UI 这边也要授权一次</h3>
 * SAF（Storage Access Framework）的持久授权是**记在 uid 上**的 ——
 * 宿主（`com.deepseek.chat.a`）和我们模块（`com.little_femaleboy.…`）是两个 uid，
 * 所以**宿主拿到授权 ≠ 我们拿到授权**。
 *
 * 而好几件事必须由 UI 侧读文件：
 * <pre>
 *   · 美化策略的**图片预览**（宿主把图写成 PNG 放进那个目录，我们读回来看）
 *   · 一键导出的**备份包**（宿主写好，我们读出来给你另存）
 *   · 一键导入（你选一个 zip，我们读出来交给宿主）
 * </pre>
 *
 * <h3>为什么要"选同一个文件夹"</h3>
 * 宿主写在那儿（{@code DCIM/fdm}，音乐曲库那个），我们要读它 ⇒ 必须指向同一个目录。
 *
 * <h3>为什么不用 MANAGE_EXTERNAL_STORAGE</h3>
 * 那个是"所有文件访问权限"，要跳系统设置页手动开、还要过审，
 * 而我们已经有一个用户能理解、能撤销的正规通路（SAF）⇒ 不该为它多要一个重权限。
 */
object SafDir {

    private const val TAG = "FdmSaf"
    private const val KEY = "ui_saf_tree"

    // ══════════════════════════════════════════════════════════════════
    //  ★★ 2026-11-14（3.108.2）· 整页（宿主进程）分流
    //
    //  真机现象（主人截图）：宿主 + 模块两边都授权过了，
    //  整页首页仍然显示「还没授权」「本应用还没授权」。
    //
    //  根因有两条，**都是 uid 惹的**：
    //    ① 我们自己的授权记在**模块 uid** 上，而整页跑在宿主进程 ⇒
    //       `persistedUriPermissions` 只能看到宿主的，看不到我们自己的；
    //       而 `sp(ctx).getString("ui_saf_tree")` 在整页里拿到的是 HostStore
    //       （= 宿主那张表）⇒ 我们自己那条 `ui_saf_tree` 也读不到。
    //    ② 宿主自己那条（`treeText`）走广播 + `delay(400)` 往返，
    //       在整页里既慢又容易踩空。
    //
    //  ⇒ 分流：
    //     · 整页里：模块的授权状态读宿主存储里模块上报的那两个键；
    //       宿主的授权状态**直接查**（我们就在宿主进程里，查的就是宿主 uid）
    //     · 模块本体里：一个字不动（老路径原样）
    // ══════════════════════════════════════════════════════════════════

    /** true ＝ 跑在宿主进程里（整页模式）。 */
    fun inHost(): Boolean = try {
        com.nidyaber.fuckdsmanger.bridge.FdmBridge.inHost()
    } catch (e: Throwable) {
        false
    }

    /**
     * 供 UI 判断「现在是不是整页模式」—— 包一层是为了让 `Pages.kt` 不用直接
     * import bridge（那里的代码要在模块自己的进程里也能跑）。
     */
    @JvmStatic
    fun hostMode(): Boolean = inHost()

    /** 模块上报到宿主存储里的键（宿主侧写、整页侧读）。 */
    private const val KEY_MOD_SAF_OK = "fuckdsmanger_mod_saf_ok"
    private const val KEY_MOD_SAF_NAME = "fuckdsmanger_mod_saf_name"

    /** 模块上报的授权状态（**只在整页里有意义**）。 */
    private fun modSafOk(ctx: Context): Boolean = try {
        com.nidyaber.fuckdsmanger.bridge.FdmBridge
            .hostRead(ctx, KEY_MOD_SAF_OK, "b").trim().equals("true", ignoreCase = true)
    } catch (e: Throwable) {
        false
    }

    private fun modSafName(ctx: Context): String = try {
        com.nidyaber.fuckdsmanger.bridge.FdmBridge.hostRead(ctx, KEY_MOD_SAF_NAME, "s")
    } catch (e: Throwable) {
        ""
    }

    /**
     * 【宿主自己的 SAF 授权】—— 只有**在宿主进程里**才问得准。
     *
     * <p>为什么整页能直接查：SAF 持久授权记在 uid 上，整页就活在宿主 uid 里
     * ⇒ `persistedUriPermissions` 返回的正是宿主那份。
     * 这也顺手干掉了老路径那个 `delay(400)` 广播往返的竞态。
     *
     * @return `DCIM/fdm` 这种短名；没授权返回空串
     */
    fun hostTreeDisplay(ctx: Context): String {
        try {
            val perms = ctx.contentResolver.persistedUriPermissions
            if (perms.isNullOrEmpty()) return ""
            // 优先挑「看起来像我们那个目录」的（DCIM/fdm / Music/fdm）；
            // 都没有就取最后一个（最近授权的那个）。
            var best: Uri? = null
            for (p in perms) {
                if (!p.isReadPermission) continue
                val d = displayOf(p.uri)
                if (d.contains("/fdm", ignoreCase = true) || d.equals("fdm", ignoreCase = true)) {
                    best = p.uri
                    break
                }
                best = p.uri
            }
            return best?.let { displayOf(it) } ?: ""
        } catch (e: Throwable) {
            return ""
        }
    }

    /** 从 tree uri 里截出 `DCIM/fdm` 这种短名。 */
    private fun displayOf(u: Uri): String = try {
        val id = DocumentsContract.getTreeDocumentId(u)   // "primary:DCIM/fdm"
        val name = id.substringAfter(':', id)
        if (name.isEmpty()) "（存储根目录）" else name
    } catch (e: Throwable) {
        u.toString()
    }

    /** 记住的目录 uri（没有 = 还没授权）。 */
    fun tree(ctx: Context): Uri? {
        val s = FdmPush.sp(ctx).getString(KEY, null)
        if (s.isNullOrEmpty()) return null
        return try {
            Uri.parse(s)
        } catch (e: Throwable) {
            null
        }
    }

    /**
     * 授权还在吗（用户可能去系统设置里撤销）。
     *
     * <p>★ 整页里不能走下面那套：那是**模块 uid** 的授权，宿主进程里查不到，
     * 而且 `sp(ctx)` 拿到的是 HostStore ⇒ 恒 false（= 主人截图里那句"还没授权"）。
     */
    fun granted(ctx: Context): Boolean {
        if (inHost()) return modSafOk(ctx)
        val u = tree(ctx) ?: return false
        return try {
            ctx.contentResolver.persistedUriPermissions.any {
                it.isReadPermission && it.uri == u
            }
        } catch (e: Throwable) {
            false
        }
    }

    /** 显示用：`DCIM/fdm` 这种短名。 */
    fun display(ctx: Context): String {
        if (inHost()) return modSafName(ctx)
        val u = tree(ctx) ?: return ""
        return try {
            val id = DocumentsContract.getTreeDocumentId(u)   // "primary:DCIM/fdm"
            val name = id.substringAfter(':', id)
            if (name.isEmpty()) "（存储根目录）" else name
        } catch (e: Throwable) {
            u.toString()
        }
    }

    /** 选完之后调它：把授权持久化下来。 */
    fun save(ctx: Context, uri: Uri) {
        try {
            // ★ ACTION_OPEN_DOCUMENT_TREE 回来时固定给读写这两个 ——
            //   拿不到原始 flags（ActivityResultContracts 不透传），而这两个正是我们要的。
            val flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            ctx.contentResolver.takePersistableUriPermission(uri, flags)
            FdmPush.sp(ctx).edit().putString(KEY, uri.toString()).apply()
            Log.e(TAG, "SAF 目录已授权：$uri（flags=$flags）")
        } catch (e: Throwable) {
            Log.e(TAG, "保存 SAF 授权失败", e)
        }
    }

    /** 拉起系统选择器时用的 intent 标志（交给 rememberLauncherForActivityResult 不够用）。 */
    fun pickerFlags(): Int =
        Intent.FLAG_GRANT_READ_URI_PERMISSION or
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                Intent.FLAG_GRANT_PREFIX_URI_PERMISSION

    /**
     * 在授权目录里找**根目录下**指定名字的文件，读成字节。没有就 null。
     *
     * <p>⚠️ SF 给的是 content uri，**不是 File** —— 别想着拼路径。
     */
    fun readRootFile(ctx: Context, fileName: String): ByteArray? {
        val treeUri = tree(ctx) ?: return null
        if (!granted(ctx)) return null
        try {
            val rootId = DocumentsContract.getTreeDocumentId(treeUri)
            val children = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, rootId)
            val cur = ctx.contentResolver.query(
                children,
                arrayOf(
                    DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                    DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                ), null, null, null,
            ) ?: return null
            try {
                while (cur.moveToNext()) {
                    val id = cur.getString(0) ?: continue
                    val name = cur.getString(1) ?: continue
                    if (name != fileName) continue
                    val fileUri = DocumentsContract.buildDocumentUriUsingTree(treeUri, id)
                    return ctx.contentResolver.openInputStream(fileUri)?.use { it.readBytes() }
                }
            } finally {
                try {
                    cur.close()
                } catch (e: Throwable) {
                }
            }
        } catch (e: Throwable) {
            Log.e(TAG, "读 SAF 文件失败：$fileName", e)
        }
        return null
    }


    /**
     * 列出授权目录根下所有 zip（给「导入」选文件用）。按名字倒序（新的在前）。
     *
     * <p>⚠️ 只查根目录，不递归 —— 备份包本来就写在根。
     */
    fun listZips(ctx: Context): List<String> {
        val treeUri = tree(ctx) ?: return emptyList()
        if (!granted(ctx)) return emptyList()
        val out = ArrayList<String>()
        try {
            val rootId = DocumentsContract.getTreeDocumentId(treeUri)
            val children = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, rootId)
            val cur = ctx.contentResolver.query(
                children,
                arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
                null, null, null,
            ) ?: return emptyList()
            try {
                while (cur.moveToNext()) {
                    val n = cur.getString(0) ?: continue
                    if (n.endsWith(".zip", ignoreCase = true)) out.add(n)
                }
            } finally {
                try {
                    cur.close()
                } catch (e: Throwable) {
                }
            }
        } catch (e: Throwable) {
            Log.e(TAG, "列 SAF zip 失败", e)
        }
        return out.sortedDescending()
    }

    /** 允许的外部导入：选任意 zip（用 SAF 打开文件，不依赖我们自己的目录授权）。 */
    fun readUriBytes(ctx: Context, uri: Uri): ByteArray? {
        return try {
            ctx.contentResolver.openInputStream(uri)?.use { it.readBytes() }
        } catch (e: Throwable) {
            Log.e(TAG, "读外部 zip 失败", e)
            null
        }
    }

    /** 授权目录里有没有这个文件（只判存在，不读内容）。 */
    fun exists(ctx: Context, fileName: String): Boolean {
        val treeUri = tree(ctx) ?: return false
        if (!granted(ctx)) return false
        try {
            val rootId = DocumentsContract.getTreeDocumentId(treeUri)
            val children = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, rootId)
            val cur = ctx.contentResolver.query(
                children,
                arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
                null, null, null,
            ) ?: return false
            try {
                while (cur.moveToNext()) {
                    if (cur.getString(0) == fileName) return true
                }
            } finally {
                try {
                    cur.close()
                } catch (e: Throwable) {
                }
            }
        } catch (e: Throwable) {
            Log.e(TAG, "查 SAF 文件失败：$fileName", e)
        }
        return false
    }
}
