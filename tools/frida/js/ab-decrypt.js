/*
 * ab-decrypt.js —— 抓火山引擎 AB 配置的解密材料 🐲 2026-11-01
 *
 * 目标：`tab.volces.com/service/2/abtest_config/` 的响应是 3456 字节密文
 *      （熵 7.94，gzip/zlib 都不行 ⇒ 应用层加密）。
 * 做法：在 JDK 的 javax.crypto.Cipher 上挂钩子 —— 不管宿主换多少个混淆类名，
 *      只要它用标准 JCE 解密就一定路过这里。
 *
 * 产出：每条「解密」都打一行
 *      [AB] alg=... key=<hex> iv=<hex> in=<len> out=<明文预览>
 *      拿到 key+iv 就能在本地用 Python 把 HAR 里那段密文自己解出来。
 *
 * 用法：
 *      frida -U -f com.deepseek.chat.a -l ab-decrypt.js --no-pause
 *  或挂到已经在跑的进程：
 *      frida -U com.deepseek.chat.a -l ab-decrypt.js
 */

Java.perform(function () {
    var Cipher = Java.use('javax.crypto.Cipher');
    var IvParameterSpec = Java.use('javax.crypto.spec.IvParameterSpec');
    var GCMParameterSpec = Java.use('javax.crypto.spec.GCMParameterSpec');

    var MAX = 60;
    var count = 0;

    // ── 小工具 ──
    function hex(bytes, max) {
        if (bytes === null) return '-';
        var n = Math.min(bytes.length, max || 48);
        var s = '';
        for (var i = 0; i < n; i++) {
            var b = (bytes[i] & 0xff).toString(16);
            s += (b.length === 1 ? '0' : '') + b;
        }
        return s + (bytes.length > n ? '..(' + bytes.length + ')' : '');
    }

    function ivOf(spec) {
        try {
            if (spec === null) return null;
            if (spec.$className.indexOf('IvParameterSpec') >= 0) {
                return Java.cast(spec, IvParameterSpec).getIV();
            }
            if (spec.$className.indexOf('GCMParameterSpec') >= 0) {
                return Java.cast(spec, GCMParameterSpec).getIV();
            }
        } catch (e) { }
        return null;
    }

    function keyOf(k) {
        try { return k === null ? null : k.getEncoded(); } catch (e) { return null; }
    }

    // ── 记录上次 init 的上下文（密钥/IV 在 init 时给，doFinal 时才用）──
    var last = { mode: -1, alg: '?', key: null, iv: null };

    var initOverloads = Cipher.init.overloads;
    initOverloads.forEach(function (ov) {
        var params = ov.argumentTypes.map(function (t) { return t.className; });
        // 只要 (int, Key) / (int, Key, AlgorithmParameterSpec)
        if (params.length < 2) return;
        if (params[0] !== 'int') return;
        if (params[1].indexOf('java.security.Key') < 0 &&
            params[1].indexOf('SecretKey') < 0 &&
            params[1].indexOf('PublicKey') < 0 &&
            params[1].indexOf('PrivateKey') < 0) return;
        if (params.length === 2 && params[1].indexOf('AlgorithmParameterSpec') >= 0) return;

        ov.implementation = function () {
            var r = ov.apply(this, arguments);
            try {
                last.mode = arguments[0];
                last.alg = this.getAlgorithm();
                last.key = keyOf(arguments[1]);
                last.iv = (arguments.length > 2) ? ivOf(arguments[2]) : null;
            } catch (e) { }
            return r;
        };
        console.log('[AB] hook init(' + params.join(',') + ')');
    });

    var dfOverloads = Cipher.doFinal.overloads;
    dfOverloads.forEach(function (ov) {
        var params = ov.argumentTypes.map(function (t) { return t.className; });
        if (params[0] !== '[B') return;

        ov.implementation = function () {
            var r = ov.apply(this, arguments);
            try {
                if (last.mode !== 2) return r;          // 2 = DECRYPT_MODE
                if (r === null || r.length === 0) return r;
                var inBytes = arguments[0];
                if (inBytes === null || inBytes.length <= 32) return r;
                count++;
                if (count > MAX) return r;
                var txt = '';
                try {
                    var n = Math.min(r.length, 320);
                    txt = Java.array('byte', Java.array('byte', r).slice(0, n));
                    txt = String.fromCharCode.apply(null,
                        Array.prototype.slice.call(new Uint8Array(
                            Java.array('byte', r).slice(0, n).map(function (x) { return x & 0xff; })
                        ))
                    );
                } catch (e) { txt = '<取文本失败>'; }
                console.log('[AB] #' + count
                    + ' alg=' + last.alg
                    + ' key=' + hex(last.key, 64)
                    + ' iv=' + hex(last.iv, 32)
                    + ' in=' + inBytes.length
                    + ' out=' + r.length
                    + ' 明文=' + JSON.stringify(txt).slice(0, 400));
            } catch (e) {
                console.log('[AB] 打印异常 ' + e);
            }
            return r;
        };
    });

    console.log('[AB] 探针就绪 · 等宿主做一次 AB 配置解密（重启宿主 / 等它拉配置即可）');
});
