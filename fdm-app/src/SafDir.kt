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

    /** 授权还在吗（用户可能去系统设置里撤销）。 */
    fun granted(ctx: Context): Boolean {
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
