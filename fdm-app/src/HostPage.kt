// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger

import android.content.Context
import android.content.ContextWrapper
import android.content.SharedPreferences
import android.content.res.AssetManager
import android.content.res.Configuration
import android.content.res.Resources
import android.view.View
import android.widget.Toast
import androidx.activity.OnBackPressedDispatcher
import androidx.activity.OnBackPressedDispatcherOwner
import androidx.activity.compose.LocalActivityResultRegistryOwner
import androidx.activity.compose.LocalOnBackPressedDispatcherOwner
import androidx.activity.result.ActivityResultRegistry
import androidx.activity.result.ActivityResultRegistryOwner
import androidx.activity.result.contract.ActivityResultContract
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalResources
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.app.ActivityOptionsCompat
import androidx.lifecycle.Lifecycle
import com.nidyaber.fuckdsmanger.bridge.FdmBridge

/**
 * 【HostPage】把**整个模块设置界面**塞进宿主进程 🐲 2026-11-14
 *
 * <h3>为什么要它（`专题/待办与遗留.md` 开头那条大方向）</h3>
 * 现状：点「打开模块」要**跨进程**拉起我们自己的 MainActivity，而宿主
 * `targetSdk=36`、清单里 `<queries>` 只声明了微信/GMS（主人还开着「隐藏应用列表」）
 * ⇒ 显式组件 / scheme / 显式广播**三条路全灭**（2026-11-14 真机日志逐条 ANFE）。
 * 唯一的根治办法：**根本不要跨进程** —— 界面就在宿主进程里画。
 *
 * <h3>和「保底弹窗 / 选择页 / 整页探针」的关系</h3>
 * 那三个都在用 `FdmComposeDialog` 那套挂载逻辑（三件套 owner + 手工 recomposer），
 * 本类只负责**内容**，挂载仍然交给 bridge 侧。区别只有两个：
 * <pre>
 *   ① 内容是**真的** FdmApp（Home/About/所有 TreePage），不再是占位卡片
 *   ② 配置读写必须**直连宿主存储**（见下），不能再用广播
 * </pre>
 *
 * <h3>★ 三个必须在这里解决的新问题（弹窗不用管，整页要管）</h3>
 *
 * <p><b>① 模块的 Resources 在宿主进程里拿不到</b>
 * 我们和宿主是**两个 APK**，资源表各自独立；`createPackageContext` 被包可见性挡死
 * （3.75.x 的教训）。而 `FdmApp` 里全是 `R.string.*` / `stringResource(...)` ⇒
 * 不给它模块的 Resources，界面就是一屏**宿主的**错文案。
 * ⇒ 自己造一份：从 ClassLoader 反射出**模块 APK 的真实路径**，
 *   `AssetManager.addAssetPath(...)` + `Resources(am, dm, cfg)`。
 *   判据用「这个 APK 里有没有 `c_back` 这个 string」—— 宿主绝对没有同名资源。
 *
 * <p><b>② `BackHandler` / `rememberLauncherForActivityResult` 需要 Activity owner</b>
 * 宿主 Activity 实现的是**宿主 loader** 的 `OnBackPressedDispatcherOwner`，
 * 和我们 Compose 看到的**不是同一个 Class**（`FallbackLifecycle` 的注释里
 * 有一整张"连崩 4 次"的表，讲的就是这件事）⇒ 永远挂不上、只能用我们自己的。
 * ⇒ 这里现造两个：
 *   · [HostBackOwner]：自己一个 `OnBackPressedDispatcher`，`FdmApp` 的返回键照常工作
 *   · [HostResultOwner]：**降级版** registry —— 整页里"选图片 / 选文件夹"拉不起系统
 *     选择器（那需要真 Activity 的 `startActivityForResult`），所以只提示一句
 *     "这项功能要到模块里操作"。**关键是它不能崩**：`rememberLauncherForActivityResult`
 *     在组合期就会 `checkNotNull` 这个 local。
 *
 * <p><b>③ 配置从哪来</b>
 * `Bridge` 原本读的是**我们自己 App** 的 SharedPreferences（`fdm`），
 * 在宿主进程里 `getSharedPreferences("fdm")` 拿到的是**宿主的**那份 ⇒ 全错位。
 * ⇒ `FdmBridge.inHost()` 为真时走**直连**：`GmStore.read2/write` 直接读写宿主 MMKV。
 *   （改在 `Bridge.kt` 里分流，本类不管。）
 *
 * <h3>关不掉怎么办</h3>
 * 右上角有个悬浮圆钮（压在 TopAppBar 下方，不挡它的「更多/保存」），
 * 另外 `FdmApp` 的返回栈空时按返回键 = 关闭（`onClose`）。
 * 关闭动作由 bridge 侧传进来的 [Runnable] 负责（它持有 Dialog 引用）。
 */
object HostPage {

    /**
     * 模块 APK 的**安装包名**（= 清单里 `package=`）。
     *
     * <p>⚠️⚠️ 这里坑过一次：`com.nidyaber.fuckdsmanger` 是 **Java 包名**，
     * 而 APK 安装后用的是 `FdmBridge.MODULE_PKG` 那个
     * `com.little_femaleboy.cannot_show.the_big_won_whale`（做包时会改）。
     * `Resources.getIdentifier(name, type, pkg)` 的 `pkg` 要匹配**资源表里记录的**
     * 那个包名 ⇒ 传错就恒返回 0，看起来像"资源没找到"。
     * ⇒ 现在两处都不写死：优先传 `null`（搜索所有已挂载的包），
     *   再拿 bridge 的常量兜底试一次。
     */
    private const val MODULE_PKG = com.nidyaber.fuckdsmanger.bridge.FdmBridge.MODULE_PKG

    /** `createPackageContext` 用：要带上 code（否则 assets 不完整）。 */
    private const val CONTEXT_INCLUDE_CODE = 0x1

    /** 模块 APK 里一定有的 string（宿主没有同名资源）⇒ 拿它当"这是我们的 APK"的判据。 */
    private const val PROBE_STR = "c_back"

    /** 最近一次装载的诊断（bridge 侧读它写日志，省得猜）。 */
    @JvmStatic
    var diag: String = ""
        private set

    /**
     * 把整页装进 `cv`。
     *
     * @param cv       bridge 侧造好的 ComposeView
     * @param onClose  点关闭 / 返回栈空时按返回键
     * @return true ＝ 内容已填上；false ＝ **调用方必须退回保底**（别显示半成品）
     */
    @JvmStatic
    fun install(cv: View, onClose: Runnable?): Boolean {
        val compose = cv as? ComposeView
        if (compose == null) {
            diag = "不是 ComposeView"
            return false
        }
        val host = compose.context
        appCtx = host
        // ★ 3.108.3：如果 bridge 已经用 `wrapContext` 包过（整页的正常路径），
        //   就复用它的资源表，别重复 addAssetPath。
        val pre = host as? ResCtx
        val res = pre?.moduleRes ?: moduleResources(host)
        if (res == null) {
            // 宁可退回保底卡片，也不让主人看到一屏宿主的错文案
            diag = "拿不到模块 Resources（模块 APK 路径没找到 / addAssetPath 失败）"
            return false
        }
        val uiCtx = pre ?: ResCtx(host, res, HostStore(host))
        // ★ 把模块资源表登记到 HostRes：这样 UI 里那 ~700 处 `ctx.fdmStr(R.string.x)`
        //   才能查到**我们自己的**文案（Material3 内部仍走宿主表，互不影响）。
        HostRes.installModuleRes(res)
        val back = HostBackOwner()
        val results = HostResultOwner(uiCtx)

        compose.setContent {
            HostPageRoot(uiCtx, res, back, results, onClose)
        }
        diag = "就绪 · probe=" + probeRes(res)
        return true
    }

    /** 关闭按钮要不要显示（探针里不显示）。 */
    /**
     * 【给 bridge 用】把宿主 Activity 包成一个「认两张表」的 Context。
     *
     * <h3>为什么必须在**建 ComposeView 时**就用它（3.108.3 修）</h3>
     * 3.108.2 把 `getResources()` 换成了 [BridgeRes]，主界面（灰度/音乐/过检）全好了 ——
     * 但**彩蛋弹 AlertDialog 照样炸**：
     * <pre>
     *   Resources$NotFoundException: String resource ID #0x7f0a017a   ← m3c_dialog（我们编的）
     *     at android.content.res.Resources.getText                        ← **不是** BridgeRes
     *     at material3.internal.Strings_androidKt.getString
     *     at DefaultBasicAlertDialogOverride$BasicAlertDialog$1.invoke
     *     at AndroidDialog_androidKt.DialogLayout
     *     at ComposeViewContext.ProvideCompositionLocals$ui               ← ★ 这里
     * </pre>
     * `ProvideCompositionLocals$ui` 会用 **View 自己的 context** 覆盖 `LocalContext` /
     * `LocalResources`；而 Compose 的 `Dialog` 是**独立 window**，它内部
     * `DialogWrapper.setContent` 会 `new ComposeView(dialog.context)`，
     * 而那个 context 追根溯源是**根 ComposeView 的 context** = 宿主 Activity。
     * ⇒ 只 provide 一个 `LocalContext` **管不到 Dialog 里新建的 View 树**。
     *
     * <h3>所以</h3>
     * bridge 在建根 ComposeView 时先问这里要一个包好的 Context：
     * <pre>
     *   ComposeView.context = ResCtx(act)          ← getResources() = BridgeRes
     *     ⇒ Dialog 里的 ComposeView 也继承它
     *     ⇒ Material3 任何内部文案都查得到
     * </pre>
     * 拿不到模块 Resources 时**原样返回 act**（宁可少一层兜底，也不能在这里抛）。
     */
    @JvmStatic
    fun wrapContext(act: Context): Context {
        if (act is ResCtx) return act          // 已经包过就别套第二层
        return try {
            val r = moduleResources(act) ?: return act
            ResCtx(act, r, HostStore(act))
        } catch (_: Throwable) {
            act
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  内容
    // ══════════════════════════════════════════════════════════════════

    @Composable
    private fun HostPageRoot(
        uiCtx: Context,
        res: Resources,
        back: HostBackOwner,
        results: HostResultOwner,
        onClose: Runnable?,
    ) {
        // ★ `onClose` 是 Java 侧传进来的 `Runnable`（关掉承载整页的 Dialog）。
        //   包成 lambda 给 Compose 用：顶栏关闭钮和「返回栈空时按返回」共用同一个动作。
        val closeAction: () -> Unit = { onClose?.run() }

        CompositionLocalProvider(
            // ★ LocalContext 换成 ResCtx —— 它的 `getResources()` 现在返回 BridgeRes
            //   （模块表优先、查不到回落宿主表），所以 Material3 和我们的 `R.string` 两边都查得到。
            LocalContext provides uiCtx,
            // ★ LocalResources 换成**模块**（我们的 stringResource / painterResource 走它）
            LocalResources provides res,
            LocalOnBackPressedDispatcherOwner provides back,
            LocalActivityResultRegistryOwner provides results,
            // ★★ 2026-11-14（3.108.2）· 关闭钮进顶栏
            //   主人：「关闭按钮应该在菜单栏」。原来是悬浮圆钮，压在顶栏下方飘着。
            //   `FdmTopBar` 有 5 个调用点，所以走 CompositionLocal（和 LocalNight 同一招）
            //   ⇒ 不管当前在哪一页，顶栏右上角都自动带上关闭钮。
            LocalClose provides closeAction,
        ) {
            // 深色跟随宿主系统设置（整页里不给夜间切换钮：那是要写配置的操作，
            // 而整页的唯一职责是"让人能进模块改东西"，先不做第二件容易出错的事）
            val dark = isSystemInDarkTheme()

            FdmTheme(if (dark) FdmSchemeDark else FdmScheme) {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.surface,
                ) {
                    // ★ 2026-11-14（3.108.2）· 悬浮圆钮删掉了
                    //   主人：「关闭按钮应该在菜单栏」。它现在活在 `FdmTopBar` 的
                    //   actions 里（由上面 provide 的 `LocalClose` 驱动），
                    //   所以这里不再需要额外的 Box/CloseDot。
                    FdmApp(onClose = closeAction)
                }
            }
        }
    }

    /**
     * 【已废弃】右上角悬浮圆钮。
     *
     * <p>3.108.0 的写法，位置是「状态栏 + 68dp」——算得很小心，但主人一眼看出不对：
     * 它悬在顶栏**下面**飘着，既不像顶栏按钮，又压住了首页第一张卡片的上沿。
     * ⇒ 3.108.2 改成顶栏 action（见 `FdmTopBar` 里的 `LocalClose`）。
     *
     * <p>留这份注释是为了记住那条教训：**「算得准」不等于「放得对」** ——
     * 位置算得再精，语义上它也不属于那个位置。
     */
    /**
     * 那行过期的 `moduleResources` 头部注释（兜底顺序还是 3.108.0 的老两行）
     * 在 3.108.1 已经扩成四级链，见下面那个函数自己的注释。
     */

    /**
     * 造一份**指向模块 APK** 的 Resources。
     *
     * <p><b>路径从哪来（这条链 3.108.1 重做过，别再按旧图想）</b>：
     * <pre>
     *   ① 主路 · LSPosed 白送
     *      core/XposedInit.initModule → param.modulePath = apk
     *                                → FdmEntry.initZygote(param)
     *      （每进程必调、早于 handleLoadPackage；不依赖模块本体跑过）
     *   ② 备路 · ClassLoader.getResource("AndroidManifest.xml")
     *      从自己的 loader 里截出 jar:file:…/base.apk!（纯公开 API）
     *   ③ 备路 · 宿主存储里模块上报的那条（老路，兼容）
     *   ④ 备路 · 反射 BaseDexClassLoader.pathList（最后兜底）
     *   ⑤ 备路 · createPackageContext（包可见性允许时）
     * </pre>
     * 宿主侧只用到**公开 API**（`addAssetPath` 是标准做法），
     * 不查 `PackageManager`、不扫 `/proc/self/maps`、不反射别人的 loader。
     *
     * <p>判据：用新 Resources 查 `string/c_back`，非 0 才算成功
     * （宿主没有同名资源，撞不上）。
     */
    private fun moduleResources(host: Context): Resources? {
        val dm = host.resources.displayMetrics
        val cfg = Configuration(host.resources.configuration)
        val tried = StringBuilder()

        // ── 主路：**框架白送的**模块 APK 路径（`IXposedHookZygoteInit.initZygote`）
        //   LSPosed 每个目标进程都会调一次、且早于 handleLoadPackage ⇒ 一定会先有它。
        //   这条路彻底断掉旧方案的**循环依赖**（旧方案：模块本体跑过才有路径）。
        val fromZygote = try {
            FdmBridge.moduleApkFromZygote()
        } catch (_: Throwable) {
            ""
        }
        if (fromZygote.isNotEmpty()) {
            loadFromApk(fromZygote, dm, cfg)?.let {
                remember(fromZygote, "zygote")
                return it
            }
            tried.append("zygote=空挂 ")
        } else {
            tried.append("zygote=无 ")
        }

        // ── 备路 1：问**自己的 ClassLoader** 要 APK 路径（纯公开 API）
        //   我们的类就活在这个 APK 里 ⇒ `getResource("AndroidManifest.xml")`
        //   会返回 `jar:file:/data/app/…/base.apk!/AndroidManifest.xml`，
        //   截掉 `jar:file:` 和 `!/…` 就是路径。
        //   ⚠️ 这条路不碰任何 Xposed API、不反射私有字段、不扫 /proc。
        val fromCl = apkFromOwnClassLoader()
        if (fromCl.isNotEmpty()) {
            loadFromApk(fromCl, dm, cfg)?.let {
                remember(fromCl, "classloader")
                return it
            }
            tried.append("classloader=空挂 ")
        } else {
            tried.append("classloader=无 ")
        }

        // ── 备路 2：宿主存储里那条（模块进程跑过才有的，最慢但兼容旧版本）
        val reported = try {
            FdmBridge.moduleApkPath(host)
        } catch (_: Throwable) {
            ""
        }
        if (reported.isNotEmpty()) {
            loadFromApk(reported, dm, cfg)?.let { return it }
            tried.append("store=空挂 ")
        } else {
            tried.append("store=无 ")
        }

        // ── 备路 3：反射 pathList（最后的兜底；隐藏应用列表开着时前面可能全空）
        for (p in apkFromPathList()) {
            val hit = loadFromApk(p, dm, cfg)
            if (hit != null) {
                remember(p, "pathlist")
                return hit
            }
        }
        tried.append("pathlist=空挂 or 无 ")

        // ── 备路 4：包可见性允许时直接问系统要（隐藏应用列表开着会失败）
        try {
            val modCtx = host.createPackageContext(MODULE_PKG, CONTEXT_INCLUDE_CODE)
            val r = modCtx.resources
            if (r != null && probeRes(r) != 0) {
                return r
            }
        } catch (_: Throwable) {
        }
        tried.append("pkgctx=无")

        diag = "四条路都没拿到模块 Resources：$tried"
        return null
    }

    /**
     * 把「哪条路成功了」写进日志，并把路径**回存**到宿主存储 ——
     * 下次模块本体推配置时不必再猜，也方便真机排查时一眼看出走的哪条。
     */
    private fun remember(apk: String, via: String) {
        try {
            FdmBridge.hostWrite(appCtx, FdmBridge.KEY_MOD_APK, apk, "s")
        } catch (_: Throwable) {
        }
        android.util.Log.i("FDM-HostPage", "模块 Resources 已装载（via=$via）：$apk")
    }

    /** 由 install 时记下，`remember` 写存储要用。 */
    private var appCtx: Context? = null

    /**
     * 问自己的 ClassLoader：「我住在哪个 APK 里？」
     *
     * <h3>原理</h3>
     * `PathClassLoader.getResource("AndroidManifest.xml")` 会走 `URLClassPath`，
     * 对 APK 条目返回 `jar:file:/data/app/~~xx==/pkg-yy==/base.apk!/AndroidManifest.xml`。
     * 截出中间那段就是 APK 绝对路径。
     *
     * <h3>为什么这条路最稳</h3>
     * <ul>
     *   <li>**公开 API**（`ClassLoader.getResource`）—— 不反射、不碰隐藏字段</li>
     *   <li>**不依赖框架**（`initZygote` 万一没被调也不影响）</li>
     *   <li>**不依赖模块本体跑过**（旧方案的循环依赖就在这里断掉）</li>
     *   <li>**不需要任何权限**（我们本来就能读自己 APK）</li>
     * </ul>
     *
     * <h3>顺序为什么不是先 ClassLoader</h3>
     * `initZygote` 给的是框架已经打开过的那个路径，最准（多用户 / 双开时尤其）；
     * ClassLoader 这条当作它失效时的后手。
     */
    private fun apkFromOwnClassLoader(): String {
        for (name in arrayOf("AndroidManifest.xml", "assets/xposed_init", "classes.dex")) {
            try {
                val u = javaClass.classLoader?.getResource(name)?.toString() ?: continue
                // jar:file:/data/app/xx/base.apk!/AndroidManifest.xml
                if (!u.startsWith("jar:file:")) continue
                var p = u.substring("jar:file:".length)
                val bang = p.indexOf("!/")
                if (bang > 0) p = p.substring(0, bang)
                if (p.startsWith("/") && p.endsWith(".apk")) return p
            } catch (_: Throwable) {
            }
        }
        return ""
    }

    /**
     * 反射 `BaseDexClassLoader.pathList` → `DexPathList.pathElements[].path`。
     *
     * <p>⚠️ 属于**私有字段**，所以放在最后一位当兜底（前两条都拿不到才用）。
     * 只读、只找 `.apk`、不修改任何东西。
     */
    private fun apkFromPathList(): List<String> {
        val out = ArrayList<String>()
        try {
            var cl: ClassLoader? = javaClass.classLoader
            while (cl != null) {
                try {
                    val pl = Class.forName("dalvik.system.BaseDexClassLoader", false, cl)
                            .getField("pathList")
                    pl.isAccessible = true
                    val pathList = pl.get(cl) ?: break
                    val elements = pathList.javaClass.getDeclaredField("dexElements")
                    elements.isAccessible = true
                    val arr = elements.get(pathList) as? Array<*> ?: break
                    for (e in arr) {
                        if (e == null) continue
                        try {
                            val f = e.javaClass.getDeclaredField("path")
                            f.isAccessible = true
                            val p = f.get(e) as? String ?: continue
                            if (p.endsWith(".apk")) out.add(p)
                        } catch (_: Throwable) {
                        }
                    }
                } catch (_: Throwable) {
                }
                cl = cl.parent
            }
        } catch (_: Throwable) {
        }
        return out
    }

    /**
     * 查「这是不是我们那张资源表」——`string/c_back` 在不在。
     *
     * <p>⚠️ 这里踩过坑：`getIdentifier(name, type, pkg)` 的 `pkg` 必须匹配
     * **资源表里记录的**那个包名。而我们有两层包名：
     * <pre>
     *   Java 包名（aapt2 link 时）  = com.nidyaber.fuckdsmanger      ← 资源表里的
     *   安装包名（做包时改清单）    = com.little_femaleboy.…whale
     * </pre>
     * 传错就恒返回 0，看起来像"资源没找到"，其实名字对不上。
     * ⇒ 先传 `null`（搜索所有已挂载的包），再按两个候选各试一次。
     */
    private fun probeRes(r: Resources): Int {
        val byNull = r.getIdentifier(PROBE_STR, "string", null)
        if (byNull != 0) return byNull
        val byJava = r.getIdentifier(PROBE_STR, "string", "com.nidyaber.fuckdsmanger")
        if (byJava != 0) return byJava
        return r.getIdentifier(PROBE_STR, "string", MODULE_PKG)
    }

    /** 把某个 APK 挂成一份 Resources；判据不过就返回 null。 */
    private fun loadFromApk(apk: String, dm: android.util.DisplayMetrics, cfg: Configuration): Resources? {
        try {
            val am = AssetManager::class.java.getDeclaredConstructor().newInstance()
            val add = AssetManager::class.java.getDeclaredMethod("addAssetPath", String::class.java)
            add.isAccessible = true
            val cookie = add.invoke(am, apk) as? Int ?: 0
            if (cookie == 0) return null
            val r = Resources(am, dm, cfg)
            // ★ 判据：只有**模块** APK 里才有 string/c_back
            return if (probeRes(r) != 0) r else null
        } catch (_: Throwable) {
            return null
        }
    }

    /**
     * 只把该换的换掉：
     * <pre>
     *   getSharedPreferences("fdm_ui"/"fdm")  → {@link HostStore}（直连宿主 MMKV）
     *   getString / getText                   → **模块**资源表（我们自己的文案）
     *   getResources()/getAssets()            → **不动，保持宿主**
     * </pre>
     *
     * <h3>★★★ 为什么 `getResources()` 绝对不能覆盖（2026-11-14 血证：宿主崩溃）</h3>
     * 一开始我把 `getResources()` 整个换成模块那份，看起来"文案全对了"，但点彩蛋时
     * 宿主**直接崩**：
     * <pre>
     *   Resources$NotFoundException: String resource ID #0x7f0a0179
     *     at Resources.getText
     *     at androidx.compose.material3.internal.Strings_androidKt.getString
     *     at DefaultBasicAlertDialogOverride$BasicAlertDialog$1.invoke
     * </pre>
     * 真因：宿主进程里 `androidx.compose.material3.*` 实际解析到的是**宿主自己那份**
     * （宿主也是 Compose App，父委派让它先被加载）⇒ Material3 内部的资源 id
     * 属于**宿主的资源表**；而我们给的 Resources 是模块的 ⇒ 查不到 ⇒ 崩。
     *
     * <h3>第二次血证：只换 LocalResources 也不够</h3>
     * 改成"只给 `LocalResources` 注入模块资源"之后，`stringResource(...)` 正常了，
     * 但点「关于」又崩：
     * <pre>
     *   Resources$NotFoundException: String resource ID #0x7f0a0066
     *     at Context.getString
     *     at com.nidyaber.fuckdsmanger.Lang$S.tagline(Lang.kt:132)
     *     at AboutScreen(Screens.kt:140)
     * </pre>
     * 因为 UI 里还有 **746 处** `ctx.getString(R.string.xxx)` —— 它们走
     * `Context.getResources()`，而那条路我们"不敢"换（换了 Material3 就崩）。
     *
     * <h3>最终解法：**不动 Context，只给"我们自己的取值"开专用通道**</h3>
     * 覆盖 `getString` 这条路**编译期就死了** —— 它在 `Context` 里是 `final`：
     * <pre>
     *   error: 'getString' in 'Context' is final and cannot be overridden.
     * </pre>
     * ⇒ 改成扩展函数 [`Context.fdmStr`]（见 `HostRes.kt`）：
     * <pre>
     *   我们自己的 UI   → ctx.fdmStr(R.string.x)     ← 先查模块表、查不到回落宿主表
     *   stringResource  → LocalResources             ← 已注入模块表
     *   Material3 内部  → LocalContext.getResources() ← **原样宿主** ⇒ 查宿主表 ⇒ 正常
     * </pre>
     * 全 UI 那 ~700 处 `ctx.getString(` 已经机械替换成 `ctx.fdmStr(`。
     * 本类因此**只干两件事**：换 Resources（给 HostRes / LocalResources 用）、
     * 换 SharedPreferences（给 HostStore 用）。
     */
    private class ResCtx(
        base: Context,
        private val res: Resources,
        private val store: HostStore,
    ) : ContextWrapper(base) {

        /** 让 `install` 能复用已经算好的模块资源表（别重复 addAssetPath）。 */
        val moduleRes: Resources get() = res

        /**
         * ★★ 2026-11-14（3.108.2）· **`getResources()` 终于可以接管了**
         *
         * <p>3.107.0 在这里得出过一条结论：「`getResources()` 绝对不能覆盖」——
         * 依据是真机两次崩溃（换模块表 ⇒ Material3 找不到宿主 id）。那句话在当时是对的，
         * 但**结论下早了**：真正的约束不是「一份 Resources 只能认一张表」，
         * 而是「不能**只**给它一张表」。
         *
         * <p>这次的崩溃（`0x7f0a0059` = 我们编出来的 `default_error_message`，
         * 走 `LocalContext.getResources()` 去宿主表查 ⇒ `NotFoundException`）
         * 恰恰是同一个问题的**镜像面**：连「我们自己的 Material3」都查不到自己的文案。
         *
         * <p>⇒ 改成返回 [BridgeRes]：**先模块表、查不到回落宿主表**，两边都认。
         * `assets`/密度/配置仍然全部来自宿主，所以宿主自己的解析逻辑一点没动。
         *
         * <p>⚠️ `getAssets()` 仍然原样返回宿主的 —— 那是 `Context` 里少数几个
         * 真正 `final` 的东西，也是宿主拿原生 asset 的通道，绝不能碰。
         */
        override fun getResources(): Resources {
            bridge?.let { return it }
            val b: Resources = try {
                BridgeRes(super.getResources(), res)
            } catch (_: Throwable) {
                // 造不出来就退回宿主原表（宁可少一层兜底，也不能在这里抛）
                super.getResources()
            }
            bridge = b
            return b
        }

        /** 缓存一份（`BridgeRes` 构造要读 assets/密度，不必每次新建）。 */
        private var bridge: Resources? = null

        /**
         * ⚠️ 只接管 UI 的两个配置文件名（`fdm_ui` 是主力，`fdm` 是 Prefs 那个极简持久化），
         * 别的名字一律转发 —— 宿主自己的 SharedPreferences 一个都不能碰。
         */
        override fun getSharedPreferences(name: String?, mode: Int): SharedPreferences {
            return if (name == "fdm_ui" || name == "fdm") store
            else super.getSharedPreferences(name, mode)
        }
    }

    // ══════════════════════════════════════════════════════════════════
    //  ② 两个 owner（模块 loader 里造，类型才和我们的 Compose 兼容）
    // ══════════════════════════════════════════════════════════════════

    /**
     * `BackHandler` 要的那个 owner。
     *
     * <p>⚠️ **不能借宿主的**：宿主 Activity 实现的 `OnBackPressedDispatcherOwner`
     * 是宿主 loader 的那份 Class，`LocalOnBackPressedDispatcherOwner provides it`
     * 在组合期就会因为类型不同而炸（`FallbackLifecycle` 注释里那张表）。
     */
    private class HostBackOwner : OnBackPressedDispatcherOwner {
        override val onBackPressedDispatcher: OnBackPressedDispatcher =
            OnBackPressedDispatcher()

        // ⚠️ `OnBackPressedDispatcherOwner` 在 activity 1.13 **继承 LifecycleOwner**
        //   （`javap` 实证：`extends androidx.lifecycle.LifecycleOwner`）
        //   ⇒ 必须一起给出 lifecycle，否则编译期就过不去。
        //   借 `FallbackLifecycle` 的那份就行：它本来就是**模块 loader** 的、
        //   已经推到 RESUMED，而且和我们的 Compose 是同一份 Class。
        override val lifecycle: Lifecycle
            get() = FallbackLifecycle.lifecycle
    }

    /**
     * `rememberLauncherForActivityResult` 要的那个 owner —— **降级版**。
     *
     * <p>为什么不真做：真正的实现要拿宿主 Activity 的 `startActivityForResult`
     * 和 `onActivityResult`，而那是**宿主 loader** 的 Activity 类；
     * 跨 loader 接回执做不到（我们能 hook 到，但把结果塞回模块 loader 的
     * `ActivityResultRegistry` 还得再反注册一遍，收益不抵风险）。
     *
     * <p>所以：**注册照常成功**（界面不崩），`launch()` 只提示一句。
     * 需要选图/选文件夹的功能，请在模块本体里操作 —— 或者等后续版本
     * 用「模块 APK 自己当 provider + 宿主 SAF 授权」那条路补上。
     */
    private class HostResultOwner(private val ctx: Context) : ActivityResultRegistryOwner {
        override val activityResultRegistry: ActivityResultRegistry =
            object : ActivityResultRegistry() {
                override fun <I, O> onLaunch(
                    requestCode: Int,
                    contract: ActivityResultContract<I, O>,
                    input: I,
                    options: ActivityOptionsCompat?,
                ) {
                    try {
                        Toast.makeText(
                            ctx,
                            "这项功能需要选文件，请在模块本体里操作",
                            Toast.LENGTH_LONG,
                        ).show()
                    } catch (_: Throwable) {
                    }
                }
            }
    }

    // ══════════════════════════════════════════════════════════════════
    //  给 bridge 的诊断
    // ══════════════════════════════════════════════════════════════════

    /** 一句人能读的状态（写进 dsm.log）。 */
    @JvmStatic
    fun stats(): String = diag + " · inHost=" + FdmBridge.inHost()
}
