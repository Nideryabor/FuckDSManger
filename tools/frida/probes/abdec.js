// abdec.js --- 抓 AB 配置 / AppLog 的 ttEncrypt 明文（保守版）
// 安全第一：只做 byte[] 转字符，不做反射，限制次数
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var MAX = 24;
    var MAXB = 300;
    var n = 0;

    function hex(b, lim) {
        var s = '';
        var L = Math.min(b.length, lim || 40);
        for (var i = 0; i < L; i++) {
            var v = b[i] & 0xff;
            s += (v < 16 ? '0' : '') + v.toString(16);
        }
        return s;
    }
    function txt(b) {
        var L = Math.min(b.length, MAXB);
        var out = '';
        for (var i = 0; i < L; i++) {
            var v = b[i] & 0xff;
            if (v >= 32 && v < 127) out += String.fromCharCode(v);
            else out += '.';
        }
        return out;
    }
    function looksJson(s) {
        var t = s.replace(/^[.\s]+/, '');
        if (t.charAt(0) === '{' || t.charAt(0) === '[') return true;
        if (s.indexOf('ab_version') >= 0) return true;
        if (s.indexOf('device_id') >= 0) return true;
        if (s.indexOf('abtest') >= 0) return true;
        return false;
    }

    try {
        var EU = Java.use('com.bytedance.applog.encryptor.EncryptorUtil');
        var ov = EU.a.overloads;
        P('=== EncryptorUtil.a 重载数: ' + ov.length);
        for (var i = 0; i < ov.length; i++) {
            var at = ov[i].argumentTypes;
            if (at.length !== 2) continue;
            if (String(at[1].className) !== '[B') continue;
            (function (impl, sig) {
                impl.implementation = function (sz, data) {
                    if (n >= MAX) return impl.call(this, sz, data);
                    n++;
                    try {
                        P('');
                        P('=== #' + n + ' (' + sig + ') size=' + sz);
                        if (data !== null) {
                            var b = Java.array('byte', data);
                            var s = txt(b);
                            P('  IN  len=' + b.length + ' hex=' + hex(b, 40));
                            P('  IN  txt=' + s);
                            if (looksJson(s)) P('  *** IN 看起来是明文');
                        } else {
                            P('  IN data=null');
                        }
                    } catch (e) { P('  IN dump失败: ' + first(e)); }
                    var ret = impl.call(this, sz, data);
                    try {
                        if (ret !== null) {
                            var rb = Java.array('byte', ret);
                            var rs = txt(rb);
                            P('  OUT len=' + rb.length + ' hex=' + hex(rb, 40));
                            P('  OUT txt=' + rs);
                            if (looksJson(rs)) P('  *** OUT 看起来是明文');
                        } else { P('  OUT null'); }
                    } catch (e2) { P('  OUT dump失败: ' + first(e2)); }
                    return ret;
                };
            })(ov[i], at.length + 'args');
            P('  已 hook 一个重载');
        }
    } catch (e) { P('hook 失败: ' + first(e)); }

    P('');
    P('=== 等触发 ===');
    var beat = 0;
    setInterval(function () {
        beat++;
        P('  ... t=' + (beat * 10) + 's  已捕获 ' + n);
        if (beat >= 11) {
            P('');
            P('=== 共 ' + n + ' 次 ===');
            P('=== DONE ===');
        }
    }, 10000);
});
