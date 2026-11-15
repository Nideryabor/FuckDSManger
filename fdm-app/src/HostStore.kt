// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger

import android.content.Context
import android.content.SharedPreferences
import com.nidyaber.fuckdsmanger.bridge.FdmBridge
import java.util.concurrent.ConcurrentHashMap

/**
 * 【HostStore】整页模式下，把 UI 的 `fdm_ui` SharedPreferences **换成宿主存储的直连门** 🐲 2026-11-14
 *
 * <h3>为什么需要这一层（这是整页方案能不能用的分水岭）</h3>
 * 界面里的配置读写有 **32 处**，统统长这样：
 * <pre>
 *   val sp = ctx.getSharedPreferences("fdm_ui", MODE_PRIVATE)
 *   sp.getString("cfg.fuckds_bg_on", null)
 *   sp.edit().putString("cfg.fuckds_bg_alpha", "25").apply()
 * </pre>
 * 在我们自己的进程里，这是读"我们请求过什么"，改完再靠 `FdmPush.push()` 广播给宿主。
 * <b>但整页跑在宿主进程里</b>：`getSharedPreferences("fdm_ui")` 拿到的是
 * **宿主自己的** `fdm_ui.xml` —— 那是另一个空文件 ⇒ 界面会显示一屏默认值，
 * 改了东西也一个都落不到宿主。
 *
 * <h3>为什么选「替换 SharedPreferences」而不是「改 32 处调用点」</h3>
 * 改 32 处 = 每加一个配置项就得记得改；而**换掉 `getSharedPreferences` 的返回值**是
 * 一处收口 —— UI 代码一个字不动。`HostPage.ResCtx` 只接管 `fdm_ui` / `fdm` 两个名字，
 * 其余（宿主自己的 SP）照常转发，不会误伤。
 *
 * <h3>键名与类型：两个必须翻译的东西</h3>
 * <pre>
 *   UI 的键                     →  宿主 MMKV 的键
 *   cfg.fuckds_bg_on            →  fuckds_bg_on            （剥掉 cfg.）
 *   host.fuckds_bg_on           →  fuckds_bg_on            （剥掉 host. —— 我们就在宿主里，真值就是它）
 *   fuckds_bg_on                →  fuckds_bg_on            （原样）
 *   rev / applied_rev / host.at →  （不映射，返回默认值）    ← 这些是我们自己的记账键
 * </pre>
 *
 * <p>⚠️ <b>类型必须自己探</b>：宿主存储是强类型的（`GmStore` 桩里的铁律：
 * 类型不符会静默读回默认值或直接抛），而 `getString("cfg.fuckds_bg_on")` 这种调用
 * **不知道**那个键在宿主里是 `b` 还是 `i`。⇒ 依次试 `b/i/l/f/s`，
 * 哪个不抛就用哪个，**并把结论缓存下来**（同一个键只探一次）。
 *
 * <p>⚠️ `GmStore.read2` 对**不存在**的键返回空串而**不是抛** ⇒ 空串一律按"没这个键"处理，
 * 退回调用方给的默认值。（这一条错了的话，所有开关会显示成"关"。）
 *
 * <h3>写</h3>
 * `edit()` 收下的操作在 `apply()/commit()` 时**逐条**写进宿主
 * （`GmStore.write(ctx, 键, 值, 类型)` —— 注意参数顺序是「键 → 值 → 类型」）。
 * 写成功后把类型记进缓存，下一次读就不用再探。
 */
class HostStore(private val host: Context) : SharedPreferences {

    /** 宿主类型字符：b=布尔 i=整数 l=长整 f=浮点 s=字符串（等价于"其它一律字符串"）。 */
    companion object {
        /** UI 里那几个"我们自己的"记账键 —— 宿主没有，也不该有。 */
        private val LOCAL_ONLY = setOf(
            "rev", "applied_rev", "applied_at",
        )

        /**
         * **界面偏好**键（不带 `fuckds_` 前缀的那几个）→ 宿主里的独立命名空间。
         *
         * <p>★ 2026-11-15（3.108.6）：`NightMode` 用 `"ui_night_mode"`、`Prefs` 用
         * `"toolbox.option"` —— 它们存的是「夜间模式档位 / 工具箱选项」，属于界面偏好。
         * 在模块本体里它们进 `fdm.xml`；可**整页跑在宿主进程里**，
         * `fdm.xml` 是宿主那份（空的）⇒ 读不到（永远"跟随系统"）、改了也存不上。
         *
         * <p>落宿主时必须**换名字**（加 `fuckds_` 前缀）：宿主同一份 MMKV 里也有自己的键，
         * 裸写 `ui_night_mode` 万一撞名就是污染宿主配置。
         */
        private val UI_KEYS = mapOf(
            "ui_night_mode" to "fuckds_ui_night_mode",
            "toolbox.option" to "fuckds_toolbox_option",
        )

        /**
         * **历史遗留键**：住在**另一个 SharedPreferences 文件** `fuckds_gm` 里，
         * 而且名字**不带 `fuckds_` 前缀** 🐲 2026-11-15（3.108.11）
         *
         * <h3>为什么它们必须单独一张表</h3>
         * 主人点出的「账号名称 / 头像」在界面上是 `ui_nick` / `ui_avatar_on` /
         * `ui_uavatar_on` / `ui_db_on`。可它们在模块里**不是普通存储键** ——
         * 走的是底座那几个 getter（反编译 `GmName/GmAvatar/GmUAvatar/GmDb.smali` 逐条读的）：
         * <pre>
         *   GmName.getText()      → SP("fuckds_gm").getString("accname_text", "")
         *   GmAvatar.isOn()       → SP("fuckds_gm").getBoolean("avatar_on", false)
         *   GmUAvatar.isOn()      → SP("fuckds_gm").getBoolean("uavatar_on", false)
         *   GmDb.isOn()           → SP("fuckds_gm").getBoolean("anti_revoke", false)
         * </pre>
         * 真机上的 `shared_prefs/fuckds_gm.xml` 确实是这份内容：
         * <pre>
         *   &lt;boolean name="accname_set"  value="true" /&gt;
         *   &lt;boolean name="anti_revoke"  value="false" /&gt;
         *   &lt;string  name="accname_text"&gt;dxyabab&lt;/string&gt;
         *   &lt;boolean name="uavatar_on"   value="true" /&gt;
         *   &lt;boolean name="avatar_on"    value="true" /&gt;
         * </pre>
         *
         * <p>而 {@link #hostKey} 只认 `cfg.` / `host.` / `fuckds_` 三种前缀 ⇒
         * `ui_nick` 这种**一个都不匹配** ⇒ 返回 null ⇒ 界面永远显示默认值
         * （开关是关的、名字是空的）。这就是「账号名称和头像读不到」的全部原因。
         *
         * <p>映射成 `(SP 文件名, SP 键, 类型)`。**类型是照 getter 写死的**：
         * `getBoolean` 那三个就是 b，`getString` 那个是 s。
         */
        private val LEGACY_SP: Map<String, Triple<String, String, String>> = mapOf(
            "ui_avatar_on" to Triple("fuckds_gm", "avatar_on", "b"),
            "ui_uavatar_on" to Triple("fuckds_gm", "uavatar_on", "b"),
            "ui_db_on" to Triple("fuckds_gm", "anti_revoke", "b"),
            "ui_nick" to Triple("fuckds_gm", "accname_text", "s"),
        )

        /** MMKV 里但**不带 `fuckds_` 前缀**的键（`GmEnv` 那两个）。 */
        private val LEGACY_MMKV: Map<String, Pair<String, String>> = mapOf(
            "ui_env_on" to ("key_env_bypass" to "b"),
            "ui_env_api" to ("key_env_api" to "b"),
        )

        private const val P_CFG = "cfg."
        private const val P_HOST = "host."

        /**
         * **宿主键 → 真实存储类型**（`b`/`i`/`l`/`f`/`s`）🐲 2026-11-15（3.108.10）
         *
         * <h3>为什么必须是**静态表**，不能在运行时探</h3>
         * 我 3.108.6 试过「运行时探测」：`getAll()` 拿真实类型、失败再挨个 getXxx 试。
         * 真机 + 反编译双证据把这条路彻底否了：
         * <pre>
         *   // tmp/h280/com/tencent/mmkv/MMKV.smali:5279
         *   public final getAll()Ljava/util/Map;
         *       throw new UnsupportedOperationException(
         *           "Intentionally Not Supported. Use allKeys() instead,
         *            getAll() not implement because type-erasure inside mmkv")
         * </pre>
         * frida 实测也印证：`getAll()` → `InvocationTargetException`，
         *   `allKeys()` → `NoSuchMethodException`（公开包装被 R8 裁掉了）。
         *
         * <p>而「挨个 getXxx、抛了算类型不对」同样不成立 —— MMKV 的 `getBoolean`
         * 对 int **非零即 true、不抛**（实测 `fuckds_bg_alpha`(25) 读成 `true`）。
         *
         * <p>⇒ **类型只能来自"我们知道这个键是什么"**。这张表就是那个"知道"：
         * 每一条都对着模块侧的**真实读法**（`GmStore.read2(ctx, K_X, "i")`、
         * `GmRichText.boolOf(...)`、`GmGlassCfg.intOf(...)`）逐条核过，
         * 不是按名字猜的。
         *
         * <p>⚠️ 加新键必须同时往这里添一行；漏了会退回 `"s"`，
         * 而"用 s 读 int"在 MMKV 上会静默给默认值 ⇒ 症状是"开关看着对、数字全是默认"。
         */
        private val HOST_TYPES: Map<String, String> = mapOf(
        "fuckds_abubble_bg_alpha" to "i",
        "fuckds_abubble_bg_color" to "i",
        "fuckds_abubble_bg_mode" to "i",
        "fuckds_abubble_bg_on" to "b",
        "fuckds_abubble_img_fit" to "i",
        "fuckds_bar_h" to "i",
        "fuckds_bar_on" to "b",
        "fuckds_bar_w" to "i",
        "fuckds_bg_alpha" to "i",
        "fuckds_bg_cam" to "i",
        "fuckds_bg_crop" to "i",
        "fuckds_bg_dir" to "i",
        "fuckds_bg_grad" to "i",
        "fuckds_bg_mode" to "i",
        "fuckds_bg_on" to "b",
        "fuckds_bg_pos" to "i",
        "fuckds_bg_rot" to "i",
        "fuckds_bubble_alpha" to "i",
        "fuckds_bubble_anchor" to "i",
        "fuckds_bubble_color" to "i",
        "fuckds_bubble_img" to "b",
        "fuckds_bubble_maxz" to "i",
        "fuckds_bubble_on" to "b",
        "fuckds_bubble_radius" to "i",
        "fuckds_dev_ask3" to "b",
        "fuckds_device_id" to "s",
        "fuckds_device_on" to "b",
        "fuckds_dj_off" to "b",
        "fuckds_glass_blur" to "i",
        "fuckds_glass_clean" to "b",
        "fuckds_glass_clean_tol" to "i",
        "fuckds_glass_color" to "i",
        "fuckds_glass_disp" to "i",
        "fuckds_glass_edge" to "i",
        "fuckds_glass_engine" to "i",
        "fuckds_glass_fade" to "i",
        "fuckds_glass_fit" to "b",
        "fuckds_glass_form" to "i",
        "fuckds_glass_impl" to "i",
        "fuckds_glass_on" to "b",
        "fuckds_glass_scope" to "i",
        "fuckds_glass_src" to "i",
        "fuckds_glass_tint" to "i",
        "fuckds_gm" to "b",
        "fuckds_html_light" to "b",
        "fuckds_html_on" to "b",
        "fuckds_localmusic_auto_off" to "b",
        "fuckds_localmusic_sel" to "s",
        "fuckds_model_switch" to "b",
        "fuckds_music_os" to "i",
        "fuckds_note_alpha" to "i",
        "fuckds_note_bg" to "i",
        "fuckds_note_on" to "b",
        "fuckds_note_size" to "i",
        "fuckds_prompt_feature" to "s",
        "fuckds_pvar_lyric" to "b",
        "fuckds_pvar_on" to "b",
        "fuckds_rich_bare" to "b",
        "fuckds_rich_c1" to "i",
        "fuckds_rich_c2" to "i",
        "fuckds_rich_c3" to "i",
        "fuckds_rich_c4" to "i",
        "fuckds_rich_c5" to "i",
        "fuckds_rich_c6" to "i",
        "fuckds_rich_c7" to "i",
        "fuckds_rich_c8" to "i",
        "fuckds_rich_c9" to "i",
        "fuckds_rich_on" to "b",
        "fuckds_rich_tpls" to "s",
        "fuckds_suggest_ai" to "b",
        "fuckds_suggest_count" to "i",
        "fuckds_suggest_on" to "b",
        "fuckds_suggest_text" to "s",
        "fuckds_sysprompt_carrier" to "s",
        "fuckds_sysprompt_head" to "s",
        "fuckds_sysprompt_mode" to "i",
        "fuckds_sysprompt_on" to "b",
        "fuckds_sysprompt_tail" to "s",
        "fuckds_toolbox_option" to "b",
        "fuckds_ububble_bg_alpha" to "i",
        "fuckds_ububble_bg_color" to "i",
        "fuckds_ububble_bg_mode" to "i",
        "fuckds_ububble_bg_on" to "b",
        "fuckds_ububble_color" to "i",
        "fuckds_ububble_img" to "b",
        "fuckds_ububble_img_fit" to "i",
        "fuckds_ububble_on" to "b",
        "fuckds_ububble_radius" to "i",
        "fuckds_ui_night_mode" to "i",
        "fuckds_welcome_msg" to "s",
        )

        /** 取某个宿主键的存储类型；表里没有 ⇒ `"s"`（并会在日志里骂一句）。 */
        fun typeOf(hk: String): String {
            HOST_TYPES[hk]?.let { return it }
            return "s"
        }

        /** 表里有多少条（诊断用）。 */
        fun typeCount(): Int = HOST_TYPES.size
    }

    /** 键（**宿主形**）→ 已经探明的类型字符。只探一次。 */
    private val types = ConcurrentHashMap<String, String>()

    // ────────────────────────── 键名翻译 ──────────────────────────

    /** UI 键 → 宿主键；返回 null = 这个键不该去宿主找。 */
    private fun hostKey(k: String?): String? {
        if (k == null || k.isEmpty()) return null
        if (LOCAL_ONLY.contains(k)) return null
        if (k.startsWith("host.at")) return null
        UI_KEYS[k]?.let { return it }
        LEGACY_MMKV[k]?.let { return it.first }
        // ★ 历史键（住 `fuckds_gm` 的）在没有 cfg./host. 前缀时原样认领
        if (LEGACY_SP.containsKey(k)) return k
        return when {
            k.startsWith(P_CFG) -> k.substring(P_CFG.length)
            k.startsWith(P_HOST) -> k.substring(P_HOST.length)
            k.startsWith("fuckds_") -> k
            else -> null
        }
    }

    // ────────────────────────── 读 ──────────────────────────

    /**
     * 读宿主存储，返回字符串形态（`"true"` / `"25"` / `"你好"`）；
     * **null = 没这个键**（或读不出来）。
     *
     * <h3>★★ 2026-11-15（3.108.10）· 改用**静态类型表**</h3>
     * 历史两版都是错的，两次都被真机否掉：
     * <ol>
     *   <li>3.108.6 之前：「挨个 `hostReadStrict`，抛了算类型不对」——
     *       `GmStore.read2` 的 `.catchall` 把类型不符吞成空串、**永不抛** ⇒ 第一个
     *       `"b"` 恒"成功" ⇒ 整数/字符串/颜色全读默认值。</li>
     *   <li>3.108.8：改用 `getAll()` 拿真实 Java 类型 —— MMKV 的 `getAll()`
     *       是 <b>throw UnsupportedOperationException</b>（反编译 + frida 双证）。</li>
     * </ol>
     * ⇒ 现在：**类型从 {@link HOST_TYPES} 查**（那是对着模块侧真实读法逐条核过的），
     * 只做一件事的兜底 —— 值形态不像就换 `"s"` 再读一次（历史脏值）。
     */
    private fun readHost(hk: String): String? {
        // ★ 历史遗留键（住 `fuckds_gm` 那个 SP 文件里）优先处理 ——
        //   它们压根不在 MMKV 里，走下面那套永远查不到。
        legacySpOf(hk)?.let { (_, spKey, t) ->
            return readLegacySp(hk, spKey, t)
        }
        val t = typeOf(hk)
        val v = runCatching { FdmBridge.hostReadStrict(host, hk, t) }.getOrNull()
        if (v != null && v.isNotEmpty()) return v

        // ① 空串有两种可能：真没这个键 / 存的就是空串
        //    用 contains 分开（`GmStore.read2` 自己也会先 contains，但这里要的是"空串也算有"）
        val exists = runCatching {
            FdmBridge.hostType(host, hk) != null || v != null
        }.getOrDefault(false)
        if (!exists && v == null) return null

        // ② 值形态不像声明的类型 ⇒ 是历史脏值（比如被写成字符串），换 "s" 再读
        if (!fits(hk, t, v)) {
            val s2 = runCatching { FdmBridge.hostReadStrict(host, hk, "s") }.getOrNull()
            if (s2 != null && s2.isNotEmpty()) return s2
            // ③ 反过来：声明是 s 但实际存成了数字/布尔 ⇒ 试 i / b
            if (t == "s") {
                for (alt in arrayOf("i", "b", "f", "l")) {
                    val s3 = runCatching { FdmBridge.hostReadStrict(host, hk, alt) }.getOrNull()
                    if (s3 != null && s3.isNotEmpty()) return s3
                }
            }
        }
        return v
    }

    /** 这个宿主键是不是住在 `fuckds_gm` 里；是则返回 `(SP文件名, SP键, 类型)`。 */
    private fun legacySpOf(hk: String): Triple<String, String, String>? {
        for ((ui, v) in LEGACY_SP) {
            if (v.second == hk || ui == hk) return v
        }
        return null
    }

    /**
     * 读 `fuckds_gm` 里的一项。
     *
     * <p>⚠️ 这里用的是 **宿主真实的 SharedPreferences**（`host.getSharedPreferences`），
     * 不是 MMKV —— 因为底座那几个 getter 就是这么读的。
     * 整页跑在宿主进程里 ⇒ 读到的是同一份文件，天然一致。
     */
    private fun readLegacySp(hk: String, spKey: String, t: String): String? {
        return try {
            val sp = host.getSharedPreferences(hk2sp(hk) ?: "fuckds_gm", Context.MODE_PRIVATE)
            when (t) {
                "b" -> if (sp.contains(spKey)) sp.getBoolean(spKey, false).toString() else null
                "i" -> if (sp.contains(spKey)) sp.getInt(spKey, 0).toString() else null
                "l" -> if (sp.contains(spKey)) sp.getLong(spKey, 0L).toString() else null
                "f" -> if (sp.contains(spKey)) sp.getFloat(spKey, 0f).toString() else null
                else -> sp.getString(spKey, null)
            }
        } catch (e: Throwable) {
            null
        }
    }

    /**
     * 写 `fuckds_gm` 里的一项（**编辑完立刻 commit**）。
     *
     * <p>为什么 commit 而不是 apply：底座的 getter 在同一进程里**立刻**就会被调用
     * （比如关掉头像开关 → 下一次合成头像时读 `GmAvatar.isOn()`），
     * `apply()` 是异步落盘，虽然同进程内可见，但这里数据量极小、次数极少，
     * 用 commit 换"读完立刻可见"，值。
     */
    private fun writeLegacySp(uiKey: String, spKey: String, t: String, v: String) {
        try {
            val sp = host.getSharedPreferences(hk2sp(uiKey) ?: "fuckds_gm", Context.MODE_PRIVATE)
            val ed = sp.edit()
            when (t) {
                "b" -> ed.putBoolean(spKey, v == "true" || v == "1")
                "i" -> ed.putInt(spKey, v.trim().toIntOrNull() ?: 0)
                "l" -> ed.putLong(spKey, v.trim().toLongOrNull() ?: 0L)
                "f" -> ed.putFloat(spKey, v.trim().toFloatOrNull() ?: 0f)
                else -> ed.putString(spKey, v)
            }
            ed.commit()
        } catch (e: Throwable) {
            android.util.Log.w("HostStore", "写 fuckds_gm.$spKey 失败: $e")
        }
    }

    /** 某个 UI 键对应的 SP 文件名（没有则 null）。 */
    private fun hk2sp(uiKey: String): String? = LEGACY_SP[uiKey]?.first

    /** 声明的类型和读回来的值形态对不对得上（只用来发现历史脏值，不参与正常判断）。 */
    private fun fits(hk: String, t: String, v: String?): Boolean {
        if (v == null) return true
        return when (t) {
            "b" -> v == "true" || v == "false" || v == "1" || v == "0"
            "i", "l" -> v.trim().toLongOrNull() != null
            "f" -> v.trim().toFloatOrNull() != null
            else -> true
        }
    }

    override fun getAll(): MutableMap<String, *> {
        // UI 里只有 FdmPush.push() 用 getAll，而整页模式下 push 直接被短路（见 FdmPush）
        // ⇒ 这里返空表是安全的，也避免把宿主几百个键全翻译一遍。
        return HashMap<String, Any>()
    }

    override fun getString(key: String?, defValue: String?): String? {
        val hk = hostKey(key) ?: return defValue
        return readHost(hk) ?: defValue
    }

    @Suppress("UNCHECKED_CAST")
    override fun getStringSet(key: String?, defValues: MutableSet<String>?): MutableSet<String>? {
        // 宿主没有"字符串集合"这种类型（GmStore 只有 b/i/l/f/字符串）
        // ⇒ 不假装支持：返回默认值，调用方走它的降级分支。
        return defValues
    }

    override fun getInt(key: String?, defValue: Int): Int {
        val hk = hostKey(key) ?: return defValue
        return readHost(hk)?.trim()?.toIntOrNull() ?: defValue
    }

    override fun getLong(key: String?, defValue: Long): Long {
        val hk = hostKey(key) ?: return defValue
        return readHost(hk)?.trim()?.toLongOrNull() ?: defValue
    }

    override fun getFloat(key: String?, defValue: Float): Float {
        val hk = hostKey(key) ?: return defValue
        return readHost(hk)?.trim()?.toFloatOrNull() ?: defValue
    }

    override fun getBoolean(key: String?, defValue: Boolean): Boolean {
        val hk = hostKey(key) ?: return defValue
        val v = readHost(hk)?.trim() ?: return defValue
        // 宿主 `String.valueOf(boolean)` 给的是 true/false；但历史上有写 1/0 的，两种都认
        return when {
            v.equals("true", true) || v == "1" -> true
            v.equals("false", true) || v == "0" -> false
            else -> defValue
        }
    }

    override fun contains(key: String?): Boolean {
        val hk = hostKey(key) ?: return false
        return readHost(hk) != null
    }

    override fun edit(): SharedPreferences.Editor = Ed()

    override fun registerOnSharedPreferenceChangeListener(
        listener: SharedPreferences.OnSharedPreferenceChangeListener?,
    ) {
        // 整页里值的变化由 Compose 自己（乐观值 + 重组）反映，不需要这个回调
    }

    override fun unregisterOnSharedPreferenceChangeListener(
        listener: SharedPreferences.OnSharedPreferenceChangeListener?,
    ) {
    }

    // ────────────────────────── 写 ──────────────────────────

    /** 攒着，`apply()/commit()` 时**逐条**写进宿主 MMKV。 */
    inner class Ed : SharedPreferences.Editor {

        private val puts = LinkedHashMap<String, Any?>()
        private val removes = ArrayList<String>()

        override fun putString(key: String, value: String?): SharedPreferences.Editor {
            puts[key] = value
            return this
        }

        override fun putStringSet(
            key: String,
            values: MutableSet<String>?,
        ): SharedPreferences.Editor {
            // 同上：宿主没有集合类型。拼成逗号串反而是**新的错误数据**，宁可不写。
            return this
        }

        override fun putInt(key: String, value: Int): SharedPreferences.Editor {
            puts[key] = value
            return this
        }

        override fun putLong(key: String, value: Long): SharedPreferences.Editor {
            puts[key] = value
            return this
        }

        override fun putFloat(key: String, value: Float): SharedPreferences.Editor {
            puts[key] = value
            return this
        }

        override fun putBoolean(key: String, value: Boolean): SharedPreferences.Editor {
            puts[key] = value
            return this
        }

        override fun remove(key: String): SharedPreferences.Editor {
            removes.add(key)
            return this
        }

        override fun clear(): SharedPreferences.Editor {
            // 整页里"清空配置"= 把宿主那一堆 fuckds_* 全删掉。
            // 这是**破坏性**操作，界面上有独立的「重置」入口走 hostConfigReset 那种专门动作
            // ⇒ 这里绝不默默实现，免得某个"清缓存"按钮把主人的配置全清了。
            return this
        }

        override fun commit(): Boolean {
            flush()
            return true
        }

        override fun apply() {
            flush()
        }

        private fun flush() {
            for ((k, v) in puts) {
                val hk = hostKey(k) ?: continue
                val t: String
                val s: String
                when (v) {
                    is Boolean -> {
                        // ⚠️ 必须 "true"/"false"：底座 `GmStore.write` 用的是
                        //    `Boolean.parseBoolean(s)` —— 传 "1" 会变成 false（血证级别的坑）
                        t = "b"; s = v.toString()
                    }
                    is Int -> {
                        t = "i"; s = v.toString()
                    }
                    is Long -> {
                        t = "l"; s = v.toString()
                    }
                    is Float -> {
                        t = "f"; s = v.toString()
                    }
                    null -> continue
                    else -> {
                        t = "s"; s = v.toString()
                    }
                }
                // ★ 历史键要写进 `fuckds_gm` 那个 SP 文件（不是 MMKV）——
                //   底座 GmAvatar/GmName/GmDb 就是从那儿读的，写错地方等于没写。
                val legacy = legacySpOf(hk)
                if (legacy != null) {
                    writeLegacySp(hk, legacy.second, t, s)
                } else if (FdmBridge.hostWrite(host, hk, s, t)) {
                    types[hk] = t          // 写成功的类型就是真类型
                }
            }
            for (k in removes) {
                val hk = hostKey(k) ?: continue
                FdmBridge.hostRemove(host, hk)
                types.remove(hk)
            }
            puts.clear()
            removes.clear()
        }
    }
}
