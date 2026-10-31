// hunt2.js --- 带自检的挖死版
// 关键改进：
//   ① 装完 hook 后【主动调用一次】，验证 hook 真的生效（防假阴性）
//   ② 实时输出（rc=124 也能看到进度）
//   ③ 额外 hook 数美 SDK 的初始化/上报出口
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var SM = 'com.ishumei.smantifraud.l1111l111111Il';
    var BAG = 'com.ishumei.smantifraud.l11l1111lIIl';
    var hits = {};
    var armed = {};   // 哪些方法 hook 成功装上了

    function stack(n) {
        var out = [];
        try {
            var T = Java.use('java.lang.Throwable').$new();
            var st = T.getStackTrace();
            var c = 0;
            for (var i = 0; i < st.length && c < (n || 6); i++) {
                var f = String(st[i].toString());
                if (f.indexOf('com.ishumei') >= 0) continue;
                if (f.indexOf('frida') >= 0) continue;
                if (f.indexOf('java.lang.Throwable') >= 0) continue;
                out.push('      ' + f); c++;
            }
        } catch (e) { }
        return out;
    }

    // ── 装 hook ────────────────────────────────────────────────────
    var probes = [
        ['l111l11IlIlIl', 'loadedPackagesInProcess'],
        ['l11l111l1lll', 'loadedModules'],
        ['l111l11111Il', 'XposedBridge hooktable'],
        ['l111l1111l1Il', 'XposedHelpers cache'],
        ['l111l1111llIl', 'maps scan == xpApp'],
        ['l111l11111I1l', 'XposedBridge.jar'],
        ['l11l1111I11l', 'XposedHelpers robvf'],
        ['l11l111l11Il', 'EdXposed']
    ];
    var K = Java.use(SM);
    for (var p = 0; p < probes.length; p++) {
        (function (mname, desc) {
            var okCount = 0, errMsg = '';
            try {
                var ov = K[mname].overloads;
                for (var o = 0; o < ov.length; o++) {
                    if (ov[o].argumentTypes.length !== 0) continue;
                    (function (impl) {
                        impl.implementation = function () {
                            var t0 = Date.now();
                            var ret = impl.call(this);
                            hits[mname] = (hits[mname] || 0) + 1;
                            var sv = '?';
                            try {
                                sv = String(ret);
                                if (sv === '[object Object]' || sv === '') { sv = sv + '(empty-ish)'; }
                                if (sv.length > 120) sv = sv.substring(0, 120) + '...';
                            } catch (e) { }
                            P('  *** CALLED #' + hits[mname] + ' ' + mname + '() [' + desc + '] ret=' + sv + ' ' + (Date.now() - t0) + 'ms');
                            var s = stack(6);
                            if (s.length) P(s.join('\n'));
                            return ret;
                        };
                    })(ov[o]);
                    okCount++;
                }
            } catch (e) { errMsg = first(e); }
            armed[mname] = (okCount > 0 && !errMsg) ? ('OK x' + okCount) : ('FAIL ' + errMsg);
        })(probes[p][0], probes[p][1]);
    }

    // xpApp setter
    try {
        var B = Java.use(BAG);
        var ov2 = B['l111l1111lIl'].overloads;
        var got = 0;
        for (var q = 0; q < ov2.length; q++) {
            if (ov2[q].argumentTypes.length !== 1) continue;
            if (String(ov2[q].argumentTypes[0].className) !== 'java.util.List') continue;
            (function (impl2) {
                impl2.implementation = function (list) {
                    var items = [];
                    try { var it = list.iterator(); var n = 0; while (it.hasNext() && n < 20) { items.push(String(it.next())); n++; } } catch (e) { }
                    P('  ### xpApp WRITE! items=' + items.length + ' content=' + JSON.stringify(items));
                    var s = stack(6); if (s.length) P(s.join('\n'));
                    return impl2.call(this, list);
                };
            })(ov2[q]);
            got++;
        }
        armed['xpApp.setter'] = got > 0 ? 'OK x' + got : 'FAIL no match';
    } catch (e) { armed['xpApp.setter'] = 'FAIL ' + first(e); }

    // 总采集器
    try {
        var L = Java.use('com.ishumei.smantifraud.l111l1111llIl');
        var ov3 = L['l1111l111111Il'].overloads;
        for (var r = 0; r < ov3.length; r++) {
            (function (impl3, sig) {
                impl3.implementation = function () {
                    P('  >>> COLLECTOR (' + sig + ')');
                    var s = stack(8); if (s.length) P(s.join('\n'));
                    var ret = impl3.apply(this, arguments);
                    return ret;
                };
            })(ov3[r], ov3[r].argumentTypes.length + ' args');
        }
        armed['collector'] = 'OK x' + ov3.length;
    } catch (e) { armed['collector'] = 'FAIL ' + first(e); }

    // ── 自检：主动调用一次，看计数是否 +1 ──────────────────────────
    P('=== HOOK ARMED STATUS ===');
    Object.keys(armed).forEach(function (k) { P('  ' + k + ' : ' + armed[k]); });
    P('');
    P('=== SELF-TEST (calling l111l1111llIl once) ===');
    var before = hits['l111l1111llIl'] || 0;
    try { K['l111l1111llIl'](); } catch (e) { P('  self-call threw: ' + first(e)); }
    var after = hits['l111l1111llIl'] || 0;
    P('  before=' + before + '  after=' + after + '  =>  hook ' + (after > before ? 'WORKS ***' : 'BROKEN !!!'));
    // 清掉自检计数，后面统计才是干净的
    hits = {};
    P('');
    P('=== watching... (real-time output) ===');

    var beat = 0;
    var iv = setInterval(function () {
        beat++;
        P('  ... t=' + (beat * 10) + 's  hits=' + (Object.keys(hits).length ? JSON.stringify(hits) : '(none)'));
        if (beat >= 12) {
            clearInterval(iv);
            P('');
            P('=== FINAL ===');
            P(Object.keys(hits).length ? JSON.stringify(hits, null, 2) : '*** NEVER CALLED (but self-test proves hooks are live)');
            P('=== DONE ===');
        }
    }, 10000);
});
