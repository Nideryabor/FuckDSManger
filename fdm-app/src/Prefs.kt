package com.nidyaber.fuckdsmanger

import android.content.Context

/** 极简持久化：SharedPreferences（重启后仍在）。真实数据，不是内存里的假状态。 */
object Prefs {
    private const val FILE = "fdm"
    private const val K_TOOLBOX_OPTION = "toolbox.option"

    private fun sp(c: Context) = c.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    /** 「灰度工具箱 › 选项」——规范要求初始为开 */
    fun toolboxOption(c: Context): Boolean = sp(c).getBoolean(K_TOOLBOX_OPTION, true)
    fun setToolboxOption(c: Context, v: Boolean) {
        sp(c).edit().putBoolean(K_TOOLBOX_OPTION, v).apply()
    }
}
