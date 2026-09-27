package com.nidyaber.fuckdsmanger.gm

import android.app.Activity
import com.nidyaber.fuckdsmanger.gm.GmEntry
import android.content.ContextWrapper
import android.content.res.AssetManager
import android.content.res.Resources
import android.view.ViewGroup
import android.widget.Toast
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.lifecycle.setViewTreeViewModelStoreOwner
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistryController
import androidx.savedstate.SavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import java.io.File
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.background
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.nidyaber.fuckdsmanger.R

/**
 * 把 Compose UI 挂进宿主 Activity。
 * 关键：宿主的 resources 是【宿主自己的表】，我们的资源 ID 在自己那份里
 * ⇒ 用 addAssetPath 加载模块 APK 的资源，包一层 ContextWrapper 喂给 Compose。
 */
object HostMount {

    /** 历史包名都列上：早期模块的 applicationId 是 whale 那个，后来才改的 */
    /** 由 GmZygote.initZygote 写入（Xposed 给的模块 APK 路径，最靠谱） */
    @JvmStatic
    var modulePath: String? = null

    private val CANDIDATES = arrayOf(
        "com.nidyaber.fuckdsmanger",
        "com.little_femaleboy.cannot_show.the_big_won_whale"
    )

    /** 拿模块自己 APK 的路径：① 类自己的 code source ② 挨个试候选包名 */
    private fun moduleApk(act: Activity): String? {
        // ⓪ Xposed 亲口告诉我们的路径（优先级最高）
        try {
            val p = modulePath
            if (p != null && File(p).exists()) return p
        } catch (_: Throwable) {}
        try {
            val loc = HostMount::class.java.protectionDomain?.codeSource?.location
            if (loc != null) {
                val p = if (loc.protocol == "file") File(loc.toURI()).absolutePath else loc.path
                if (p != null && File(p).exists()) return p
            }
        } catch (_: Throwable) {}
        // ④ 经典 trick：BaseDexClassLoader.toString() 里就含 "zip file \"/data/app/....apk\""
        try {
            val t = HostMount::class.java.classLoader?.toString() ?: ""
            val m = Regex("\\[?([^\\[\\]\"]+\\.apk)").find(t)
                ?: Regex("(/[^\\[\\]\"]+\\.apk)").find(t)
            if (m != null) {
                val p = m.groupValues[1]
                if (File(p).exists()) return p
            }
        } catch (_: Throwable) {}
        for (pkg in CANDIDATES) {
            try {
                val ai = act.packageManager.getApplicationInfo(pkg, 0)
                if (ai?.sourceDir != null) return ai.sourceDir
            } catch (_: Throwable) {}
        }
        return null
    }

    /** 无参入口：自己从 GmEntry.sAct 取当前 Activity。
     *  同包（gm）⇒ 能直接读那个【包级私有】字段（当初跨包栽过一次）。 */
    private fun logLine(act: Activity, msg: String) {
        try {
            File(act.getExternalFilesDir(null), "fdm-ui-crash.txt").appendText(msg + "\n")
        } catch (_: Throwable) {}
    }

    @JvmStatic
    fun open() {
        val act = GmEntry.sAct ?: return
        try {
            open(act)
        } catch (t: Throwable) {
            // ① 模块自己的日志（主人要的）：完整堆栈 ⇒ 进 dsm.log / DIAG
            try { GmUtil.logFail("FDM-UI", t) } catch (_: Throwable) {}
            // ② 写文件（跟之前 v115 那套同一个位置，主人熟悉）
            try {
                val f = File(act.getExternalFilesDir(null), "fdm-ui-crash.txt")
                f.appendText("\n=== " + java.text.SimpleDateFormat("MM-dd HH:mm:ss").format(java.util.Date()) +
                        " ===\n" + android.util.Log.getStackTraceString(t) + "\n")
            } catch (_: Throwable) {}
            // ② 吐司（短：类名 + 前两帧）
            try {
                val st = t.stackTrace
                val head = if (st.isEmpty()) "" else " @ " + st[0].toString()
                Toast.makeText(act, "FDM-UI: " + t.javaClass.simpleName + ": " + (t.message ?: "") + head, Toast.LENGTH_LONG).show()
            } catch (_: Throwable) {}
        }
    }

    @JvmStatic
    fun open(act: Activity) {
        val apk = moduleApk(act)
            ?: throw IllegalStateException("moduleApk not found (codeSource + " + CANDIDATES.joinToString("/") + ")")
        logLine(act, "moduleApk = " + apk)
        try { GmUtil.logOnce("FDM-UI", "moduleApk = " + apk) } catch (_: Throwable) {}
        val am = AssetManager::class.java.newInstance()
        AssetManager::class.java.getMethod("addAssetPath", String::class.java).invoke(am, apk)
        val res = Resources(am, act.resources.displayMetrics, act.resources.configuration)
        val ctx = object : ContextWrapper(act) {
            override fun getResources(): Resources = res
            override fun getAssets(): AssetManager = am
        }
        // ★ 宿主不是 Compose 的 ComponentActivity ⇒ 自己造三件套塞进视图树
        val lo = FdmLifecycleOwner()
        val vo = FdmViewModelStoreOwner()
        val so = FdmSavedStateOwner(lo.lifecycle)
        val cv = ComposeView(ctx)
        cv.setViewTreeLifecycleOwner(lo)
        cv.setViewTreeViewModelStoreOwner(vo)
        cv.setViewTreeSavedStateRegistryOwner(so)
        lo.registry.currentState = Lifecycle.State.RESUMED   // 让组合真正跑起来
        cv.setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnDetachedFromWindow)
        cv.setContent { FdmApp() }
        (act.window.decorView as ViewGroup).addView(cv, ViewGroup.LayoutParams(-1, -1))
    }
}

@Composable
fun FdmApp() {
    MaterialTheme {
        Surface(Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.surface) {
            Column(Modifier.fillMaxSize().padding(24.dp)) {
                Text("FuckDSManger", fontSize = 26.sp, fontWeight = FontWeight.Bold,
                     color = MaterialTheme.colorScheme.onSurface)
                Text("Compose 进宿主 · 第一次点亮", fontSize = 13.sp,
                     color = MaterialTheme.colorScheme.onSurfaceVariant)
                Spacer(Modifier.height(20.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(painterResource(R.drawable.ic_edit_note), null, Modifier.size(24.dp),
                         tint = MaterialTheme.colorScheme.primary)
                    Spacer(Modifier.width(12.dp))
                    Text("图标来自 Material Symbols 矢量图", fontSize = 15.sp)
                }
                Spacer(Modifier.height(12.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(painterResource(R.drawable.ic_settings), null, Modifier.size(24.dp),
                         tint = MaterialTheme.colorScheme.primary)
                    Spacer(Modifier.width(12.dp))
                    Text("R.id / R.drawable 走我们自己的资源表", fontSize = 15.sp)
                }
            }
        }
    }
}

/** 自己造的三个 owner：宿主 Activity 不提供 ViewTree 那套，ComposeView 就起不来 */
private class FdmLifecycleOwner : LifecycleOwner {
    val registry = LifecycleRegistry(this)
    override val lifecycle: Lifecycle get() = registry
}

private class FdmViewModelStoreOwner : ViewModelStoreOwner {
    override val viewModelStore = ViewModelStore()
}

private class FdmSavedStateOwner(override val lifecycle: Lifecycle) : SavedStateRegistryOwner {
    private val controller = SavedStateRegistryController.create(this).also { it.performRestore(null) }
    override val savedStateRegistry: SavedStateRegistry get() = controller.savedStateRegistry
}
