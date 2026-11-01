// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import android.content.Context;

import com.nidyaber.fuckdsmanger.gm.GmStore;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Method;
import java.security.AlgorithmParameters;
import java.security.Key;
import java.security.spec.AlgorithmParameterSpec;
import java.util.ArrayList;
import java.util.List;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.IvParameterSpec;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

/**
 * GmCryptoProbe —— 「把宿主自己的 AES 解密结果掏出来」🐲 2026-11-01
 *
 * <h3>为什么需要它（静态分析已经走到头了）</h3>
 * 目标：拿到火山引擎 AB 配置（{@code tab.volces.com/service/2/abtest_config/}）
 * 的<b>明文</b>。抓包拿到的响应是 <b>3456 字节、熵 7.94</b> 的密文，确认是应用层加密。
 *
 * <p>静态结论（都验过，不是猜）：
 * <ul>
 *   <li>{@code libEncryptorP.so} 只注册了 {@code com/bytedance/applog/encryptor/EncryptorUtil}
 *       + {@code ttEncrypt} —— <b>只有上传加密，没有解密</b>（strings 铁证）</li>
 *   <li>{@code EncryptorUtil.a(I,[B)[B} 也只是长度校验后转调 {@code ttEncrypt}</li>
 *   <li>全宿主 {@code javax.crypto.Cipher} 里跟火山相关的只有 {@code gw3.a(String,String)}：
 *       {@code AES/CBC/PKCS5Padding} + <b>全零 IV</b> + 单参数当密钥</li>
 *   <li>但那个密钥是运行时塞进 {@code gw3.c(AtomicReference)} 的，<b>不是常量</b>
 *       ⇒ 静态拿不到</li>
 * </ul>
 *
 * <h3>所以：在 Cipher 这一层截</h3>
 * 不去追「哪个类解密」，直接挂 JDK 的 {@link Cipher}：
 * <ul>
 *   <li>{@code init(int, Key)} / {@code init(int, Key, AlgorithmParameterSpec)}：
 *       记下 opmode / 算法 / 密钥字节 / IV</li>
 *   <li>{@code doFinal(byte[])} / {@code doFinal(byte[], int, int)}：
 *       <b>解密模式（opmode == DECRYPT_MODE == 2）</b>且输入够长时，
 *       把「密钥 + IV + 密文hex + 明文预览」一起打到日志</li>
 * </ul>
 * 这样不论宿主换多少个混淆类名，只要它用标准 JCE 解密，就一定被逮到。
 *
 * <h3>⚠️ 开关（默认关）</h3>
 * 键 {@code fuckds_crypto_probe}。关着时<b>一个钩子都不挂</b>。
 * 这东西只用于取证，正式包不该开（日志会带密钥材料）。
 *
 * <h3>⚠️ 热路径纪律</h3>
 * 解密在宿主里可能很频繁 ⇒ 只记**前 MAX 条**且只记长度 &gt; 32 的，
 * 每条日志都 try/catch，异常绝不放回宿主。
 */
public final class GmCryptoProbe {

    /** 开关（默认关）。 */
    public static final String K_ON = "fuckds_crypto_probe";

    /** 最多记多少条（防刷屏）。 */
    private static final int MAX = 40;

    /** 单条日志里 hex 最多打多少字节。 */
    private static final int HEX_MAX = 96;

    private static volatile boolean sInstalled = false;
    private static volatile int sCount = 0;

    private GmCryptoProbe() {
    }

    /** 开关状态。 */
    public static boolean enabled() {
        try {
            Context c = GmUtil.app();
            if (c == null) return false;
            String v = GmStore.read2(c, K_ON, "b");
            if (v == null) return false;
            v = v.trim();
            return "true".equalsIgnoreCase(v) || "1".equals(v);
        } catch (Throwable t) {
            return false;
        }
    }

    public static String status() {
        return (enabled() ? "开" : "关") + " · 已记录 " + sCount + " 条";
    }

    // ═══════════════════════════ 安装 ═══════════════════════════

    public static void install(ClassLoader cl) {
        if (sInstalled) return;
        synchronized (GmCryptoProbe.class) {
            if (sInstalled) return;
            sInstalled = true;
        }
        if (!enabled()) {
            GmUtil.log("[crypto] 探针未开启（" + K_ON + "=false）⇒ 不挂任何钩子");
            return;
        }
        try {
            hookInit();
            hookDoFinal();
            GmUtil.log("[crypto] ✅ 探针已挂（Cipher.init / doFinal）");
        } catch (Throwable t) {
            GmUtil.logFail("[crypto] 安装失败", t);
        }
    }

    private static void hookInit() {
        for (Method m : Cipher.class.getDeclaredMethods()) {
            if (!"init".equals(m.getName())) continue;
            Class<?>[] ps = m.getParameterTypes();
            // 只要 (int, Key) 和 (int, Key, AlgorithmParameterSpec)
            boolean two = ps.length == 2 && ps[0] == int.class && Key.class.isAssignableFrom(ps[1]);
            boolean three = ps.length == 3 && ps[0] == int.class
                    && Key.class.isAssignableFrom(ps[1])
                    && !ps[2].isPrimitive();
            if (!two && !three) continue;
            XposedBridge.hookMethod(m, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    try {
                        if (!enabled()) return;
                        int mode = (Integer) p.args[0];
                        Key key = (Key) p.args[1];
                        Cipher self = (Cipher) p.thisObject;
                        byte[] iv = null;
                        if (p.args.length == 3 && p.args[2] instanceof AlgorithmParameterSpec) {
                            iv = ivOf((AlgorithmParameterSpec) p.args[2]);
                        }
                        sLastMode = mode;
                        sLastAlg = self == null ? "?" : self.getAlgorithm();
                        sLastKey = key == null ? null : key.getEncoded();
                        sLastIv = iv;
                    } catch (Throwable ignore) {
                    }
                }
            });
        }
    }

    private static void hookDoFinal() {
        for (Method m : Cipher.class.getDeclaredMethods()) {
            if (!"doFinal".equals(m.getName())) continue;
            if (m.getReturnType() != byte[].class) continue;
            Class<?>[] ps = m.getParameterTypes();
            boolean one = ps.length == 1 && ps[0] == byte[].class;
            boolean three = ps.length == 3 && ps[0] == byte[].class;
            if (!one && !three) continue;
            XposedBridge.hookMethod(m, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    try {
                        if (!enabled()) return;
                        if (sLastMode != Cipher.DECRYPT_MODE) return;   // 只要解密方向
                        Object res = p.getResult();
                        if (!(res instanceof byte[])) return;
                        byte[] out = (byte[]) res;
                        byte[] in = (byte[]) p.args[0];
                        if (in == null || in.length <= 32) return;       // 太短的不要
                        int n = ++sCount;
                        if (n > MAX) return;
                        Cipher self = (Cipher) p.thisObject;
                        GmUtil.log("[crypto] #" + n + " 算法=" + (self == null ? "?" : self.getAlgorithm())
                                + " 算法缓存=" + sLastAlg
                                + " 密钥=" + hex(sLastKey)
                                + " IV=" + hex(sLastIv)
                                + " 密文长=" + in.length + " 密文头=" + hex(in, HEX_MAX)
                                + " 明文长=" + out.length
                                + " 明文头=" + new String(out, 0, Math.min(out.length, 400),
                                        java.nio.charset.Charset.forName("UTF-8"))
                                        .replace('\n', ' '));
                    } catch (Throwable ignore) {
                    }
                }
            });
        }
    }

    // ── 上次 init 的状态（解密前的上下文）──
    private static volatile int sLastMode = -1;
    private static volatile String sLastAlg = "?";
    private static volatile byte[] sLastKey;
    private static volatile byte[] sLastIv;

    private static byte[] ivOf(AlgorithmParameterSpec spec) {
        try {
            if (spec instanceof IvParameterSpec) return ((IvParameterSpec) spec).getIV();
            if (spec instanceof GCMParameterSpec) return ((GCMParameterSpec) spec).getIV();
        } catch (Throwable ignore) {
        }
        return null;
    }

    private static String hex(byte[] b) {
        if (b == null) return "-";
        return hex(b, Math.min(b.length, HEX_MAX)) + (b.length > HEX_MAX ? "..(" + b.length + ")" : "");
    }

    private static String hex(byte[] b, int max) {
        if (b == null) return "-";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < b.length && i < max; i++) {
            sb.append(String.format("%02x", b[i] & 0xFF));
        }
        return sb.toString();
    }

    /** 把日志里那些「算法/IV」之外的候选也算一遍（诊断用，主流程不调）。 */
    public static List<String> candidates() {
        return new ArrayList<String>();
    }
}
