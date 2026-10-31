// hunt.js --- 挖死数美：长驻 hook，抓「启动/上报那一刻」的检测
// 策略：不追 attach 的那一瞬，而是把 hook 挂住，等它下一次被调用
// 记录：调用次数 + 真实返回值 + 调用栈前 10 层 + xpApp 实际塞了什么
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

var LOG = [];
function rec(s) { LOG.push(s); }

Java.perform(function () {
    var SM = 'com.ishumei.smantifraud.l1111l111111Il';
    var BAG = 'com.ishumei.smantifraud.l11l1111lIIl';
    var hits = {};

    function stack() {
        var out = [];
        try {
            var T = Java.use('java.lang.Throwable').$new();
            var st = T.getStackTrace();
            var n = 0;
            for (var i = 0; i < st.length && n < 6; i++) {
                var f = String(st[i].toString());
                if (f.indexOf('com.ishumei') >= 0) continue;
                if (f.indexOf('frida') >= 0) continue;
                if (f.indexOf('java.lang.Throwable') >= 0) continue;
                out.push('        ' + f);
                n++;
            }
        } catch (e) { out.push('        <stack fail: ' + first(e) + '>'); }
        return out;
    }

    var probes = [
        ['l111l11IlIlIl', 'loadedPackagesInProcess'],
        ['l11l111l1lll', 'loadedModules'],
        ['l111l11111Il', 'XposedBridge hooktable'],
        ['l111l1111l1Il', 'XposedHelpers cache'],
        ['l111l1111llIl', 'maps scan data/app + xposedmodule  == xpApp'],
        ['l111l11111I1l', 'XposedBridge.jar'],
        ['l11l1111I11l', 'XposedHelpers tamper robvf'],
        ['l11l111l11Il', 'EdXposed / ApplicationLoaders']
    ];
    var K = Java.use(SM);
    for (var p = 0; p < probes.length; p++) {
        (function (mname, desc) {
            try {
                var ov = K[mname].overloads;
                for (var o = 0; o < ov.length; o++) {
                    if (ov[o].argumentTypes.length !== 0) continue;
                    (function (impl) {
                        impl.implementation = function () {
                            var t0 = Date.now();
                            var ret = impl.call(this);
                            var dt = Date.now() - t0;
                            hits[mname] = (hits[mname] || 0) + 1;
                            var sv = '?';
                            try {
                                sv = String(ret);
                                if (sv === '[object Object]') {
                                    var done = false;
                                    try { sv = 'Map size=' + Java.cast(ret, Java.use('java.util.Map')).size(); done = true; } catch (e2) { }
                                    if (!done) { try { sv = 'Set size=' + Java.cast(ret, Java.use('java.util.Set')).size(); done = true; } catch (e3) { } }
                                    if (!done) { try { sv = 'List size=' + Java.cast(ret, Java.use('java.util.List')).size(); done = true; } catch (e4) { } }
                                    if (!done) sv = '[object Object]';
                                }
                                if (sv.length > 150) sv = sv.substring(0, 150) + '...';
                            } catch (e) { }
                            rec('  *** CALLED #' + hits[mname] + '  ' + mname + '()  [' + desc + ']');
                            rec('      return = ' + sv + '   took ' + dt + 'ms');
                            rec(stack().join('\n'));
                            return ret;
                        };
                    })(ov[o]);
                }
            } catch (e) { }
        })(probes[p][0], probes[p][1]);
    }

    try {
        var B = Java.use(BAG);
        var ov2 = B['l111l1111lIl'].overloads;
        for (var q = 0; q < ov2.length; q++) {
            if (ov2[q].argumentTypes.length !== 1) continue;
            if (String(ov2[q].argumentTypes[0].className) !== 'java.util.List') continue;
            (function (impl2) {
                impl2.implementation = function (list) {
                    var items = [];
                    try {
                        var it = list.iterator(); var n = 0;
                        while (it.hasNext() && n < 20) { items.push(String(it.next())); n++; }
                    } catch (e) { items.push('<read fail: ' + first(e) + '>'); }
                    rec('  ### xpApp WRITE! l11l1111lIIl->l111l1111lIl(List)  items=' + items.length);
                    rec('      content = ' + JSON.stringify(items));
                    rec(stack().join('\n'));
                    return impl2.call(this, list);
                };
            })(ov2[q]);
        }
    } catch (e) { rec('  [xpApp setter hook fail] ' + first(e)); }

    try {
        var L = Java.use('com.ishumei.smantifraud.l111l1111llIl');
        var ov3 = L['l1111l111111Il'].overloads;
        for (var r = 0; r < ov3.length; r++) {
            (function (impl3, sig) {
                impl3.implementation = function () {
                    rec('  >>> COLLECTOR START (' + sig + ')');
                    rec(stack().join('\n'));
                    var ret = impl3.apply(this, arguments);
                    rec('  <<< COLLECTOR END');
                    return ret;
                };
            })(ov3[r], ov3[r].argumentTypes.length + ' args');
        }
    } catch (e) { rec('  [collector hook fail] ' + first(e)); }

    rec('');
    rec('=== hooks installed, waiting (heartbeat every 10s) ===');

    var beat = 0;
    var iv = setInterval(function () {
        beat++;
        rec('  ... beat ' + (beat * 10) + 's   captured: ' + (Object.keys(hits).length ? JSON.stringify(hits) : '(none yet)'));
        if (beat >= 12) {
            clearInterval(iv);
            rec('');
            rec('=== FINAL STATS ===');
            rec(Object.keys(hits).length ? JSON.stringify(hits, null, 2) : '*** NEVER CALLED IN WHOLE WINDOW');
            rec('');
            rec('=== FULL LOG ===');
            P(LOG.join('\n'));
        }
    }, 10000);
});
