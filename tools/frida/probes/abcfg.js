// abcfg.js --- 读 AB 配置（AppLog 的 IKVStore + 内存缓存），并挂请求钩子等重拉
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var R = [];
    function out(s) { R.push(s); P(s); }

    out('=== 1) htc（AB 配置持有者）静态/实例字段 ===');
    try {
        var H = Java.use('htc');
        var fs = H.class.getDeclaredFields();
        for (var i = 0; i < fs.length; i++) {
            out('  ' + fs[i].getName() + ' : ' + fs[i].getType().getName());
        }
    } catch (e) { out('  ' + first(e)); }

    out('');
    out('=== 2) 找已存在的 htc 实例（扫堆）===');
    var inst = null;
    try {
        Java.choose('htc', {
            onMatch: function (o) { if (inst === null) inst = o; },
            onComplete: function () { }
        });
        out('  实例: ' + (inst === null ? '（没找到）' : '找到'));
    } catch (e) { out('  choose 失败: ' + first(e)); }

    if (inst !== null) {
        out('');
        out('=== 3) 调它的方法 ===');
        var ms = ['a', 'c', 'd', 'e'];
        for (var k = 0; k < ms.length; k++) {
            try {
                var v = inst[ms[k]]();
                out('  htc.' + ms[k] + '() = ' + String(v).substring(0, 800));
            } catch (e) { out('  htc.' + ms[k] + '() 失败: ' + first(e)); }
        }
        for (var b = 0; b < 2; b++) {
            var mb = b === 0 ? 'b' : 'f';
            if (mb === 'b') continue;
            try { out('  htc.f() = ' + inst['f']()); } catch (e) { out('  htc.f() 失败: ' + first(e)); }
            try { out('  htc.g() = ' + inst['g']()); } catch (e) { out('  htc.g() 失败: ' + first(e)); }
        }
        // 直接读 KVStore 里的键
        out('');
        out('=== 4) 直读 AppLog IKVStore ===');
        try {
            var f2 = H.class.getDeclaredField('f');
            f2.setAccessible(true);
            var kv = f2.get(inst);
            out('  IKVStore 实现类: ' + kv.getClass().getName());
            var keys = ['ab_configure', 'ab_version', 'external_ab_version', 'abtest_fetch_interval',
                        'app_alert_config', 'bav2b_config'];
            for (var q = 0; q < keys.length; q++) {
                try {
                    var s = kv.getString(keys[q], '');
                    out('  ' + keys[q] + ' = ' + (s === null ? 'null' : String(s).substring(0, 900)));
                } catch (e2) { out('  ' + keys[q] + ' 读失败: ' + first(e2)); }
            }
            try {
                var lv = kv.getLong('abtest_fetch_interval', -1);
                out('  abtest_fetch_interval(long) = ' + lv);
            } catch (e3) { out('  interval 读失败: ' + first(e3)); }
        } catch (e) { out('  读 KVStore 失败: ' + first(e)); }
    }

    out('');
    out('=== 5) 挂 EncryptorUtil.a 等 AB 请求（60s）===');
    var n = 0;
    try {
        var EU = Java.use('com.bytedance.applog.encryptor.EncryptorUtil');
        var ov = EU.a.overloads;
        for (var z = 0; z < ov.length; z++) {
            var at = ov[z].argumentTypes;
            if (at.length !== 2 || String(at[1].className) !== '[B') continue;
            (function (impl) {
                impl.implementation = function (sz, data) {
                    n++;
                    try {
                        if (data !== null && n <= 12) {
                            var b = Java.array('byte', data);
                            if (b.length > 3 && (b[0] & 0xff) === 0x1f && (b[1] & 0xff) === 0x8b) {
                                var A = Java.use('android.util.Base64');
                                var L = Math.min(b.length, 6000);
                                var sub = Java.array('byte', Array.prototype.slice.call(b, 0, L));
                                out('###BLOB' + n + ' len=' + b.length + ' gz=1');
                                out('B64' + n + ':' + String(A.encodeToString(sub, 2)));
                            } else {
                                out('###BLOB' + n + ' len=' + b.length + ' gz=0 (不是gzip，可能是AB响应?)');
                            }
                        }
                    } catch (e) { }
                    return impl.call(this, sz, data);
                };
            })(ov[z]);
        }
        out('  hook ok');
    } catch (e) { out('  hook 失败: ' + first(e)); }

    var beat = 0;
    setInterval(function () {
        beat++;
        out('  ... t=' + (beat * 10) + 's  n=' + n);
        if (beat >= 5) { out('=== DONE ==='); }
    }, 10000);
});
