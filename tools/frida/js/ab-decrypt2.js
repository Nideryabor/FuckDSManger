/*
 * ab-decrypt2.js —— 版本 2：主动触发 + 抓解密 🐲 2026-11-01
 *
 * v1 的教训：探针挂上了，但 25 秒窗口里宿主**没有做任何 AES 解密**
 * （`rc=124`，output 里只有 6 条 hook 记录）。
 * 原因：AB 配置是**进程启动时**拉的，attach 上去时早拉完了。
 *
 * v2 改法：挂上钩子之后，自己**主动催一次** AB 配置刷新：
 *   ① 反射扫已加载的类，找 bytedance applog / AB 配置的管理器
 *   ② 优先调「强制刷新 / 拉配置」这类方法（名字带 fetch/update/refresh/load）
 *   ③ 顺便把 AB 配置的**当前内存缓存**直接 dump 出来（有的话根本不用解密）
 *
 * 另外全程记录**所有** Cipher 动作（不只 DECRYPT、不只 >32 字节），
 * 这样就算没抓到 AB，也能看清宿主到底用 AES 干什么。
 */

Java.perform(function () {
    var Cipher = Java.use('javax.crypto.Cipher');
    var IvParameterSpec = Java.use('javax.crypto.spec.IvParameterSpec');
    var GCMParameterSpec = Java.use('javax.crypto.spec.GCMParameterSpec');
    var JavaString = Java.use('java.lang.String');

    var MAX = 80;
    var count = 0;

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

    function bytesToText(arr, max) {
        try {
            if (!arr || arr.length === 0) return '';
            var s = JavaString.$new(arr, "UTF-8");
            var t = s.toString();
            return t.length > max ? t.substring(0, max) : t;
        } catch (e) { return '<文本失败:' + e + '>'; }
    }

    var last = { mode: -1, alg: '?', key: null, iv: null };

    function ivOf(spec) {
        try {
            if (spec === null) return null;
            var cn = spec.$className || '';
            if (cn.indexOf('IvParameterSpec') >= 0) return Java.cast(spec, IvParameterSpec).getIV();
            if (cn.indexOf('GCMParameterSpec') >= 0) return Java.cast(spec, GCMParameterSpec).getIV();
        } catch (e) { }
        return null;
    }

    // ── init ──
    Cipher.init.overloads.forEach(function (ov) {
        ov.implementation = function () {
            var r = ov.apply(this, arguments);
            try {
                last.mode = arguments[0];
                last.alg = this.getAlgorithm();
                try { last.key = arguments[1] === null ? null : arguments[1].getEncoded(); } catch (e) { last.key = null; }
                last.iv = (arguments.length > 2) ? ivOf(arguments[2]) : null;
            } catch (e) { }
            return r;
        };
    });

    // ── doFinal（全部记，不再过滤）──
    Cipher.doFinal.overloads.forEach(function (ov) {
        var params = ov.argumentTypes.map(function (t) { return t.className; });
        if (params[0] !== '[B') return;
        ov.implementation = function () {
            var r = ov.apply(this, arguments);
            try {
                var inBytes = arguments[0];
                if (inBytes === null) return r;
                count++;
                if (count > MAX) return r;
                var isDec = (last.mode === 2);
                var outLen = (r === null ? -1 : r.length);
                var preview = '';
                if (r !== null && r.length > 0) {
                    preview = (isDec ? bytesToText(r, 300) : '(' + outLen + 'B 加密输出)');
                }
                console.log('[AB] #' + count
                    + ' ' + (isDec ? 'DEC' : 'ENC')
                    + ' alg=' + last.alg
                    + ' key=' + hex(last.key, 64)
                    + ' iv=' + hex(last.iv, 32)
                    + ' in=' + inBytes.length
                    + ' out=' + outLen
                    + (isDec ? ' 明文=' + JSON.stringify(preview).substring(0, 420) : ''));
            } catch (e) { }
            return r;
        };
    });

    console.log('[AB] 钩子就绪（v2：记录全部 AES 动作）');

    // ── 主动扫 AB 相关的类，找「强制刷新」入口 ──
    setTimeout(function () {
        try {
            var hits = [];
            Java.enumerateLoadedClassesSync().forEach(function (name) {
                var n = name.toLowerCase();
                if (n.indexOf('abtest') >= 0 || n.indexOf('applog') >= 0
                    || n.indexOf('appconfig') >= 0 || n.indexOf('volc') >= 0) {
                    hits.push(name);
                }
            });
            console.log('[AB] 相关类 ' + hits.length + ' 个: ' + hits.slice(0, 60).join(', '));
        } catch (e) {
            console.log('[AB] 枚举类失败 ' + e);
        }
    }, 500);

    // ── 找 AB 配置的内存缓存（有的话直接拿，不用解密）──
    setTimeout(function () {
        try {
            var names = Java.enumerateLoadedClassesSync();
            var tried = 0;
            names.forEach(function (name) {
                var n = name.toLowerCase();
                if (n.indexOf('abtest') < 0 && n.indexOf('appconfig') < 0
                    && n.indexOf('configmanager') < 0) return;
                if (tried > 40) return;
                tried++;
                try {
                    var C = Java.use(name);
                    var fields = C.class.getDeclaredFields();
                    var out = [];
                    fields.forEach(function (f) {
                        try {
                            var t = f.getType().getName();
                            if (t.indexOf('Map') >= 0 || t.indexOf('List') >= 0) {
                                f.setAccessible(true);
                                var v = f.get(null);
                                if (v !== null) {
                                    var s = v.toString();
                                    if (s.length > 2) out.push(f.getName() + '=' + s.substring(0, 300));
                                }
                            }
                        } catch (e) { }
                    });
                    if (out.length > 0) {
                        console.log('[AB] 静态字段 ' + name + ': ' + out.join(' | '));
                    }
                } catch (e) { }
            });
            console.log('[AB] 静态字段扫描完成，试过 ' + tried + ' 个类');
        } catch (e) {
            console.log('[AB] 扫字段失败 ' + e);
        }
    }, 1200);
});
