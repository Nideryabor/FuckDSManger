// abdec3.js --- dump IN 的完整 gzip（base64），小窝里解压
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var MAX = 8, n = 0, MAXB = 4000;

    function b64(b, lim) {
        try {
            var A = Java.use('android.util.Base64');
            var L = Math.min(b.length, lim);
            var sub = Java.array('byte', Array.prototype.slice.call(b, 0, L));
            return String(A.encodeToString(sub, 2));
        } catch (e) { return 'B64FAIL:' + first(e); }
    }
    function head(b) {
        var s = '';
        for (var i = 0; i < Math.min(b.length, 10); i++) { var v=b[i]&0xff; s += (v<16?'0':'')+v.toString(16); }
        return s;
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
                            var isGz = (b.length > 3 && (b[0]&0xff)===0x1f && (b[1]&0xff)===0x8b);
                            P('');
                            P('###BLOB' + n + ' len=' + b.length + ' gz=' + isGz + ' head=' + head(b));
                            if (isGz) {
                                P('B64' + n + ':' + b64(b, MAXB));
                            }
                        }
                    } catch (e) { P('dump fail: ' + first(e)); }
                    return impl.call(this, sz, data);
                };
            })(ov[i]);
        }
        P('=== hook ok ===');
    } catch (e) { P('hook fail: ' + first(e)); }

    var beat = 0;
    setInterval(function () {
        beat++;
        P('  t=' + (beat*10) + 's n=' + n);
        if (beat >= 9) P('=== DONE ===');
    }, 10000);
});
