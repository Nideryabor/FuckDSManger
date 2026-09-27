package com.nidyaber.fuckdsmanger.gm

import de.robv.android.xposed.IXposedHookZygoteInit

/**
 * 专门用来【记下模块 APK 的路径】。
 * 为什么需要它：LSPosed 把模块 dex 从内存加载（Anonymous-DexFile），
 * 所以 HostMount 那边既拿不到 codeSource、也读不到 classLoader 的路径、
 * 宿主 PM 又因包可见性看不见我们 ⇒ 只能靠 Xposed 自己的 StartupParam.modulePath。
 * 注意：xposed_init 支持多行，本类只是"第二个入口"，不影响原来的 GmEntry。
 */
class GmZygote : IXposedHookZygoteInit {
    override fun initZygote(startupParam: IXposedHookZygoteInit.StartupParam) {
        HostMount.modulePath = startupParam.modulePath
    }
}
