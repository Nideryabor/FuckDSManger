package com.nidyaber.fuckdsmanger.bridge;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * GmProbe —— 运行时「自证探针」🐲 尼得亚伯 2026-10-01
 *
 * 用途：宿主 2.6.1 把设置页的**行号表**换了（旧锚点 `m5.v()` 判 `a == 0x14` 已经不适用），
 *       而"点检查更新行"到底走哪个类/方法，静态推断很吃力。
 *       ⇒ 干脆 hook「更新检查 VM」（2.6.1 里是 `xu2`，含串 `check_update`），
 *         点一下那行，把 **Java 调用栈**打出来 —— 调用链里那个桶就是新的入口锚点。
 *
 * 纪律：
 *   · 全部包在 try/catch 里 —— 探针坏掉不许连累宿主（铁律 255/577）
 *   · 只在宿主进程装（外面已经 isHost 判过）
 */
public final class GmProbe {

    /** 探针开关：正式包请保持 false。 */
    public static final boolean ENABLED = true;

    /** 要挂的宿主类（2.6.1 实测：更新检查相关）。 */
    private static final String[] TARGETS = {
            "xu2", "uu2", "wu2", "tu2", "vu2",
    };

    private GmProbe() {}

    public static void install(ClassLoader cl) {
        if (!ENABLED) return;
        for (final String name : TARGETS) {
            try {
                Class<?> c = XposedHelpers.findClass(name, cl);
                XposedBridge.hookAllMethods(c, "a", new ProbeHook(name));
                XposedBridge.hookAllMethods(c, "b", new ProbeHook(name));
                XposedBridge.log("[GmProbe] 已挂 " + name);
            } catch (Throwable t) {
                // 找不到就算了，不影响别的
            }
        }
    }

    private static final class ProbeHook extends XC_MethodHook {
        private final String cls;
        ProbeHook(String cls) { this.cls = cls; }

        @Override
        protected void beforeHookedMethod(MethodHookParam p) {
            try {
                StringBuilder sb = new StringBuilder("[GmProbe] HIT " + cls + "." + p.method.getName() + " argc=" + p.args.length);
                // 顺带把 thisObject 上那个 int 字段 a 打出来（桶的 case 号）
                try {
                    Object self = p.thisObject;
                    if (self != null) {
                        java.lang.reflect.Field f = self.getClass().getDeclaredField("a");
                        f.setAccessible(true);
                        Object v = f.get(self);
                        sb.append("  a=").append(v);
                    }
                } catch (Throwable ignore) { }
                sb.append("\n");
                for (StackTraceElement e : new Throwable().getStackTrace()) {
                    String cn = e.getClassName();
                    if (cn.startsWith("de.robv") || cn.startsWith("com.nidyaber")
                            || cn.startsWith("java.lang.Thread")) continue;
                    sb.append("    at ").append(cn).append(".").append(e.getMethodName())
                      .append("(").append(e.getFileName()).append(":").append(e.getLineNumber()).append(")\n");
                    if (sb.length() > 6000) break;
                }
                XposedBridge.log(sb.toString());
            } catch (Throwable ignore) { }
        }
    }
}
