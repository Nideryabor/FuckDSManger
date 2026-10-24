// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
//
// ═══════════════════════════════════════════════════════════════════════════
//  ⚠️ 致谢 / Attribution
//
//  本文件的加密算法是 **NeteaseCloudMusicApi** 的 Java 移植版：
//      · 项目：NeteaseCloudMusicApi  (https://github.com/Binaryify/NeteaseCloudMusicApi)
//      · 作者：Binaryify
//      · 许可：MIT License
//      · 版本：4.32.0
//  原实现见该项目的 `util/crypto.js`（weapi / linuxapi / eapi）。
//  本移植仅保留「加密」这一件事（Node 运行时塞不进 Xposed 模块），
//  算法参数、常量、报文格式逐字对齐，未做任何修改。
//  感谢 Binaryify 及所有贡献者。
// ═══════════════════════════════════════════════════════════════════════════
//
//  ★ 这个类**刻意不依赖任何 Android API**（连 org.json 都不用）——
//    因为它要能在小窝里用 javac 直接编译 + 跑对比测试（跟 node 对答案）。
//    实测证明：同样的输入 ⇒ 与 node 版**逐字符一致**。
package com.nidyaber.fuckdsmanger.music;

import java.nio.charset.Charset;
import java.security.KeyFactory;
import java.security.MessageDigest;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/** 网易云 API 的加密层（weapi / eapi / linuxapi）—— NeteaseCloudMusicApi 的 Java 移植。 */
public final class GmMusicCrypto {

    private static final Charset UTF8 = Charset.forName("UTF-8");

    // ── 常量（与 util/crypto.js 逐字一致）──
    private static final String IV          = "0102030405060708";
    private static final String PRESET_KEY  = "0CoJUm6Qyw8W8jud";
    private static final String LINUX_KEY   = "rFgB&h#%2?^eDg:Q";
    private static final String EAPI_KEY    = "e82ckenh8dichen8";
    private static final String BASE62      = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    /** eapi 报文的固定分隔符（不是随手编的，服务端按它切三段）。 */
    private static final String EAPI_SEP    = "-36cd479b6b5-";
    /** RSA 公钥（1024-bit，来自 util/crypto.js 的 publicKey）。 */
    private static final String RSA_PUB_B64 =
            "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7cl"
          + "FSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMld"
          + "czhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB";

    private static final Random RND = new Random();

    private GmMusicCrypto() {
    }

    // ══════════════════════════════ eapi ══════════════════════════════
    //  报文 = AES-128-ECB(key=e82ckenh8dichen8, PKCS7) of
    //         `${uri}-36cd479b6b5-${json}-36cd479b6b5-${md5("nobody"+uri+"use"+json+"md5forencrypt")}`
    //  输出：**大写 HEX**

    /** @param uri 形如 `/api/search/get`（注意：是**原始 uri**，不是 `/eapi/…` 那个） */
    public static String eapi(String uri, String json) {
        String text = json == null ? "" : json;
        String digest = md5Hex("nobody" + uri + "use" + text + "md5forencrypt");
        String data = uri + EAPI_SEP + text + EAPI_SEP + digest;
        return aesHexUpper(data, EAPI_KEY, null, "ECB");
    }

    // ══════════════════════════════ weapi ══════════════════════════════
    //  两次 AES-128-CBC(presetKey ⇒ 随机 secretKey) + RSA(反转的 secretKey)
    //  返回 {params, encSecKey}

    public static String[] weapi(String json) {
        String text = json == null ? "" : json;
        StringBuilder sk = new StringBuilder(16);
        for (int i = 0; i < 16; i++) {
            sk.append(BASE62.charAt((int) Math.round(RND.nextDouble() * 61)));
        }
        String secretKey = sk.toString();

        String inner = aesBase64(text, PRESET_KEY, IV, "CBC");
        String params = aesBase64(inner, secretKey, IV, "CBC");

        String reversed = new StringBuilder(secretKey).reverse().toString();
        String encSecKey = rsaRawHex(reversed);

        return new String[]{params, encSecKey};
    }

    // ══════════════════════════════ linuxapi ══════════════════════════════

    public static String linuxapi(String json) {
        return aesHexUpper(json == null ? "" : json, LINUX_KEY, null, "ECB");
    }

    // ══════════════════════════════ 基础原语 ══════════════════════════════

    /** AES，输出 **大写 HEX**（对应 CryptoJS 的 `ciphertext.toString().toUpperCase()`）。 */
    public static String aesHexUpper(String text, String key, String iv, String mode) {
        try {
            byte[] out = aesRaw(bytes(text), bytes(key), iv == null ? null : bytes(iv), mode);
            return hexUpper(out);
        } catch (Throwable t) {
            throw new RuntimeException("aesHexUpper 失败: " + t, t);
        }
    }

    /** AES，输出 **Base64**（对应 CryptoJS 的 `encrypted.toString()`）。 */
    public static String aesBase64(String text, String key, String iv, String mode) {
        try {
            byte[] out = aesRaw(bytes(text), bytes(key), iv == null ? null : bytes(iv), mode);
            return Base64.getEncoder().encodeToString(out);
        } catch (Throwable t) {
            throw new RuntimeException("aesBase64 失败: " + t, t);
        }
    }

    private static byte[] aesRaw(byte[] data, byte[] key, byte[] iv, String mode) throws Exception {
        // ★ PKCS5Padding 在 AES（16 字节块）上**就是** PKCS7 —— 与 CryptoJS 的 pad.Pkcs7 一致
        Cipher c = "CBC".equalsIgnoreCase(mode)
                ? Cipher.getInstance("AES/CBC/PKCS5Padding")
                : Cipher.getInstance("AES/ECB/PKCS5Padding");
        SecretKeySpec ks = new SecretKeySpec(key, "AES");
        if ("CBC".equalsIgnoreCase(mode)) {
            c.init(Cipher.ENCRYPT_MODE, ks, new IvParameterSpec(iv));
        } else {
            c.init(Cipher.ENCRYPT_MODE, ks);
        }
        return c.doFinal(data);
    }

    /**
     * 裸 RSA（无填充）—— 对应 node-forge 的 {@code publicKey.encrypt(str, 'NONE')}：
     * 整数幂模，不做任何 padding。输入 16 字节 ⇒ 输出 128 字节 ⇒ 256 个 hex 字符。
     */
    public static String rsaRawHex(String text) {
        try {
            PublicKey pub = KeyFactory.getInstance("RSA")
                    .generatePublic(new X509EncodedKeySpec(Base64.getDecoder().decode(RSA_PUB_B64)));
            Cipher c = Cipher.getInstance("RSA/ECB/NoPadding");
            c.init(Cipher.ENCRYPT_MODE, pub);
            return hexUpper(c.doFinal(bytes(text)));
        } catch (Throwable t) {
            throw new RuntimeException("rsaRawHex 失败: " + t, t);
        }
    }

    /** MD5 → **小写** hex（对应 CryptoJS 的 `MD5().toString()`）。 */
    public static String md5Hex(String s) {
        try {
            byte[] d = MessageDigest.getInstance("MD5").digest(bytes(s));
            StringBuilder sb = new StringBuilder(d.length * 2);
            for (byte b : d) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Throwable t) {
            throw new RuntimeException("md5 失败: " + t, t);
        }
    }

    private static byte[] bytes(String s) {
        return s.getBytes(UTF8);
    }

    private static String hexUpper(byte[] b) {
        StringBuilder sb = new StringBuilder(b.length * 2);
        for (byte x : b) sb.append(String.format("%02X", x));
        return sb.toString();
    }
}
