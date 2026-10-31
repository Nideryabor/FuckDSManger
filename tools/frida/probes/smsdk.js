// smsdk.js --- 数美 SDK 到底启没启动？
// ① libsmsdk.so 有没有被 dlopen
// ② 数美全部已加载类（完整列表）
// ③ 主入口 SmAntiFraud 能不能 use、静态状态如何
// ④ 谁在加载数美类（hook ClassLoader.loadClass）
// ⑤ 数美有没有写过持久化（smid 缓存）
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var R = [];
    function out(s) { R.push(s); P(s); }

    // ① maps 里搜数美的 so
    out('=== 1) maps 里的数美 native ===');
    var want = ['libsmsdk', 'libEncryptorP', 'librscrypto', 'libmmkv', 'libWCDB'];
    var cnt = {};
    var total = 0;
    try {
        var FIS = Java.use('java.io.FileInputStream');
        var ISR = Java.use('java.io.InputStreamReader');
        var BR = Java.use('java.io.BufferedReader');
        var br = BR.$new(ISR.$new(FIS.$new('/proc/self/maps')));
        var line;
        while ((line = br.readLine()) !== null) {
            total++;
            var s = String(line);
            for (var i = 0; i < want.length; i++) {
                if (s.indexOf(want[i]) >= 0) {
                    cnt[want[i]] = (cnt[want[i]] || 0) + 1;
                }
            }
        }
        br.close();
    } catch (e) { out('  maps 读失败: ' + first(e)); }
    out('  maps 总行数 = ' + total);
    for (var w = 0; w < want.length; w++) {
        var k = want[w];
        out('  ' + k + ' : ' + (cnt[k] || 0) + ' 行  ' + (cnt[k] ? '★ 已加载' : '✗ 没加载'));
    }

    // ② 数美全部已加载类
    out('');
    out('=== 2) 数美已加载类（全部）===');
    try {
        var all = Java.enumerateLoadedClassesSync();
        var sm = [];
        for (var z = 0; z < all.length; z++) if (all[z].indexOf('com.ishumei') === 0) sm.push(all[z]);
        out('  共 ' + sm.length + ' 个:');
        for (var y = 0; y < sm.length; y++) out('    ' + sm[y]);
    } catch (e) { out('  ' + first(e)); }

    // ③ 主入口 SmAntiFraud
    out('');
    out('=== 3) 主入口类探活 ===');
    var entries = ['com.ishumei.smantifraud.SmAntiFraud',
                   'com.ishumei.smantifraud.l11l111l11Il',
                   'com.ishumei.smantifraud.l11l11l111Il',
                   'com.ishumei.sdk.captcha.SmCaptchaWebView'];
    for (var e2 = 0; e2 < entries.length; e2++) {
        var nm = entries[e2];
        try {
            var C = Java.use(nm);
            out('  ' + nm + '  → 可用');
            try {
                var fs = C.class.getDeclaredFields();
                var fnames = [];
                for (var fi = 0; fi < fs.length && fi < 12; fi++) {
                    var f = fs[fi];
                    fnames.push(f.getName() + ':' + f.getType().getName());
                }
                out('     字段: ' + fnames.join(', '));
            } catch (ex) { }
        } catch (ex) {
            out('  ' + nm + '  → 不可用: ' + first(ex).substring(0, 80));
        }
    }

    // ④ 谁在加载数美类
    out('');
    out('=== 4) hook ClassLoader.loadClass 抓加载者（10 秒）===');
    var loaders = {};
    try {
        var CL = Java.use('java.lang.ClassLoader');
        var lo = CL.loadClass.overloads;
        for (var oi = 0; oi < lo.length; oi++) {
            if (lo[oi].argumentTypes.length !== 1) continue;
            (function (impl) {
                impl.implementation = function (name) {
                    var r = impl.call(this, name);
                    if (name && name.indexOf('com.ishumei') === 0) {
                        var key = name;
                        if (!loaders[key]) {
                            var st = [];
                            try {
                                var T = Java.use('java.lang.Throwable').$new();
                                var ss = T.getStackTrace();
                                for (var si = 0; si < ss.length && st.length < 4; si++) {
                                    var f = String(ss[si].toString());
                                    if (f.indexOf('ClassLoader') >= 0 || f.indexOf('java.lang.Throwable') >= 0) continue;
                                    st.push(f);
                                }
                            } catch (e) { }
                            loaders[key] = st;
                        }
                    }
                    return r;
                };
            })(lo[oi]);
        }
        out('  hook 已装（' + lo.length + ' 个重载）');
    } catch (e) { out('  hook 失败: ' + first(e)); }

    // ⑤ 数美的持久化痕迹
    out('');
    out('=== 5) 数美持久化痕迹 ===');
    try {
        var app = Java.use('android.app.ActivityThread').currentApplication();
        var ctx = app.getApplicationContext();
        var dir = ctx.getFilesDir().getParent();  // /data/user/0/<pkg>
        out('  数据目录 = ' + String(dir));
        var F = Java.use('java.io.File');
        var f = F.$new(String(dir) + '/shared_prefs');
        var list = f.list();
        if (list === null) {
            out('  shared_prefs 不存在');
        } else {
            for (var li = 0; li < list.length; li++) {
                var n = String(list[li]);
                if (n.toLowerCase().indexOf('shumei') >= 0 || n.toLowerCase().indexOf('sm') === 0 || n.toLowerCase().indexOf('smsdk') >= 0) {
                    out('  ★ 相关 SP: ' + n);
                }
            }
            out('  shared_prefs 共 ' + list.length + ' 个文件');
        }
    } catch (e) { out('  读目录失败: ' + first(e)); }

    setTimeout(function () {
        out('');
        out('=== 4b) 10 秒内加载的数美类（带加载者栈）===');
        var ks = Object.keys(loaders);
        if (ks.length === 0) out('  （没有新的数美类被加载）');
        for (var k2 = 0; k2 < ks.length; k2++) {
            out('  ' + ks[k2]);
            var st2 = loaders[ks[k2]];
            for (var s2 = 0; s2 < st2.length; s2++) out('      ' + st2[s2]);
        }
        out('');
        out('=== DONE ===');
    }, 10000);
});
