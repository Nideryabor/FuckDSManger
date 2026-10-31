// abdec2.js --- IN 是 gzip(1f8b08)，直接解压拿明文
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var MAX = 6, n = 0;

    function hex(b, lim) {
        var s = '', L = Math.min(b.length, lim || 20);
        for (var i = 0; i < L; i++) { var v = b[i] & 0xff; s += (v<16?'0':'') + v.toString(16); }
        return s;
    }
    // 用 Java 的 GZIPInputStream 解压
    function gunzip(b) {
        try {
            var BAIS = Java.use('java.io.ByteArrayInputStream');
            var GZIS = Java.use('java.util.zip.GZIPInputStream');
            var BAOS = Java.use('java.io.ByteArrayOutputStream');
            var is = GZIS.$new(BAIS.$new(b));
            var out = BAOS.$new();
            var buf = Java.array('byte', new Array(4096).join('0').split('').map(function(){return 0;}));
            var r;
            var total = 0;
            while ((r = is.read(buf)) > 0) {
                out.write(buf, 0, r);
                total += r;
                if (total > 200000) break;
            }
            is.close();
            var res = out.toByteArray();
            return Java.array('byte', res);
        } catch (e) { return null; }
    }
    function toStr(b) {
        try {
            return Java.use('java.lang.String').$new(b, 'UTF-8');
        } catch (e) {
            var s = '';
            for (var i = 0; i < b.length; i++) { var v = b[i] & 0xff; s += (v>=32&&v<127)?String.fromCharCode(v):'.'; }
            return s;
        }
    }

    try {
        var EU = Java.use('com.bytedance.applog.encryptor.EncryptorUtil');
        var ov = EU.a.overloads;
        for (var i = 0; i < ov.length; i++) {
            var at = ov[i].argumentTypes;
            if (at.length !== 2 || String(at[1].className) !== '[B') continue;
            (function (impl) {
                impl.implementation = function (sz, data) {
                    if (n >= MAX) return impl.call(this, sz, data);
                    n++;
                    try {
                        if (data !== null) {
                            var b = Java.array('byte', data);
                            var magic = (b.length > 3) ? ((b[0]&0xff)===0x1f && (b[1]&0xff)===0x8b) : false;
                            P('');
                            P('=== #' + n + ' size=' + sz + ' len=' + b.length + ' gzip=' + magic + ' head=' + hex(b, 12));
                            if (magic) {
                                var un = gunzip(b);
                                if (un !== null) {
                                    var s = toStr(un);
                                    P('  >>> 解压成功 ' + un.length + ' 字节');
                                    P('  >>> 明文: ' + String(s).substring(0, 1400));
                                } else {
                                    P('  >>> 解压失败');
                                }
                            }
                        }
                    } catch (e) { P('dump失败: ' + first(e)); }
                    return impl.call(this, sz, data);
                };
            })(ov[i]);
        }
        P('=== hook ok ===');
    } catch (e) { P('hook 失败: ' + first(e)); }

    var beat = 0;
    setInterval(function () {
        beat++;
        P('  ... t=' + (beat*10) + 's  n=' + n);
        if (beat >= 10) { P('=== DONE (' + n + ') ==='); }
    }, 10000);
});
