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
        private val TYPES = arrayOf("b", "i", "l", "f", "s")
        /** UI 里那几个"我们自己的"记账键 —— 宿主没有，也不该有。 */
        private val LOCAL_ONLY = setOf(
            "rev", "applied_rev", "applied_at",
        )
        private const val P_CFG = "cfg."
        private const val P_HOST = "host."
    }

    /** 键（**宿主形**）→ 已经探明的类型字符。只探一次。 */
    private val types = ConcurrentHashMap<String, String>()

    // ────────────────────────── 键名翻译 ──────────────────────────

    /** UI 键 → 宿主键；返回 null = 这个键不该去宿主找。 */
    private fun hostKey(k: String?): String? {
        if (k == null || k.isEmpty()) return null
        if (LOCAL_ONLY.contains(k)) return null
        if (k.startsWith("host.at")) return null
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
     */
    private fun readHost(hk: String): String? {
        // ① 已知类型：直接读，抛了就作废重探（宿主可能在别处改过类型）
        types[hk]?.let { t ->
            val r = runCatching { FdmBridge.hostReadStrict(host, hk, t) }
            if (r.isSuccess) {
                val v = r.getOrNull()
                return if (v.isNullOrEmpty()) null else v
            }
            types.remove(hk)
        }
        // ② 未知类型：挨个试。`read2` 对"没这个键"返回空串（不抛），
        //    对"类型不符"抛 ⇒ 用"抛不抛"来分辨。
        for (t in TYPES) {
            val r = runCatching { FdmBridge.hostReadStrict(host, hk, t) }
            if (!r.isSuccess) continue
            types[hk] = t
            val v = r.getOrNull()
            return if (v.isNullOrEmpty()) null else v
        }
        return null
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
                if (FdmBridge.hostWrite(host, hk, s, t)) {
                    types[hk] = t          // 写成功的类型就是真类型 ⇒ 下次读不用再探
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
