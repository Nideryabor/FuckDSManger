// maps272d.js —— 最后一击：数美还有没有别的路能看到我们？
// ① ApplicationLoaders.gApplicationLoaders.mLoaders 里有没有 LspModuleClassLoader
// ② 数美的检测方法实测返回什么
// ③ 挂着 hook 看它们到底会不会被调用
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var R = [];

    // ① ApplicationLoaders.mLoaders —— 数美 l11l111l11Il() 想摸的那张表
    R.push('=== ① ApplicationLoaders.gApplicationLoaders.mLoaders ===');
    try {
        var C = Java.use('android.app.ApplicationLoaders');
        var f = C.class.getDeclaredField('gApplicationLoaders');
        f.setAccessible(true);
        var gal = f.get(null);
        R.push('  gApplicationLoaders = ' + (gal === null ? 'null' : gal.getClass().getName()));
        if (gal !== null) {
            var f2 = gal.getClass().getDeclaredField('mLoaders');
            f2.setAccessible(true);
            var map = f2.get(gal);
            R.push('  mLoaders 类型 = ' + map.getClass().getName());
            var M = Java.use('java.util.Map');
            var m2 = Java.cast(map, M);
            var it = m2.entrySet().iterator();
            var cnt = 0, keys = [];
            while (it.hasNext() && cnt < 40) {
                var e = it.next();
                keys.push(String(e.getKey()).substring(0, 130));
                cnt++;
            }
            R.push('  mLoaders 条目数（前40） = ' + cnt);
            for (var i = 0; i < keys.length; i++) {
                var mark = (keys[i].indexOf('LspModule') >= 0 || keys[i].indexOf('little_femaleboy') >= 0) ? '  ★★★ 命中我们' : '';
                R.push('    [' + i + '] ' + keys[i] + mark);
            }
        }
    } catch (e) { R.push('  FAIL: ' + first(e)); }

    // ② 数美"能不能看到 Xposed"的那几个方法，实测返回什么
    R.push('');
    R.push('=== ② 数美反检测方法实测返回（真机值）===');
    var SM = 'com.ishumei.smantifraud.l1111l111111Il';
    var probes = [
        ['l111l11IlIlIl()', 'l111l11IlIlIl', '读 XposedInit.loadedPackagesInProcess'],
        ['l11l111l1lll()', 'l11l111l1lll', '读 XposedInit.loadedModules'],
        ['l111l11111Il()', 'l111l11111Il', '查 XposedBridge hook 表'],
        ['l111l1111l1Il()', 'l111l1111l1Il', '查 XposedHelpers 缓存'],
        ['l111l1111llIl()', 'l111l1111llIl', '读 maps 找 /data/app + xposedmodule'],
        ['l111l11111I1l()', 'l111l11111I1l', '查 XposedBridge.jar'],
        ['l11l1111I11l()', 'l11l1111I11l', '查 XposedHelpers 篡改(含错拼名)'],
        ['l11l111l11Il()', 'l11l111l11Il', '查 EdXposed / ApplicationLoaders']
    ];
    try {
        var K = Java.use(SM);
        for (var p = 0; p < probes.length; p++) {
            var label = probes[p][0], mname = probes[p][1], desc = probes[p][2];
            try {
                var v = K[mname]();
                var sv = (v === null) ? 'null' : String(v);
                if (sv.length > 200) sv = sv.substring(0, 200) + '...';
                R.push('  ' + label + '  ->  ' + sv);
                R.push('        (' + desc + ')');
            } catch (e) { R.push('  ' + label + '  ->  调用失败: ' + first(e)); }
        }
    } catch (e) { R.push('  数美类不可用: ' + first(e)); }

    // ③ 实时观测：数美反检测方法会不会被调用
    R.push('');
    R.push('=== ③ 实时观测：数美反检测方法会不会被调用（挂 15 秒）===');
    var hits = {};
    try {
        var K2 = Java.use(SM);
        for (var q = 0; q < probes.length; q++) {
            (function (mname) {
                try {
                    var ov = K2[mname].overloads;
                    for (var o = 0; o < ov.length; o++) {
                        if (ov[o].argumentTypes.length !== 0) continue;
                        (function (impl) {
                            impl.implementation = function () {
                                hits[mname] = (hits[mname] || 0) + 1;
                                return impl.call(this);
                            };
                        })(ov[o]);
                    }
                } catch (e) { }
            })(probes[q][1]);
        }
        R.push('  hook 已装（8 个无参方法）');
    } catch (e) { R.push('  装 hook 失败: ' + first(e)); }

    setTimeout(function () {
        R.push('  15 秒内调用次数: ' + (Object.keys(hits).length === 0 ? '（一次都没被调用）' : JSON.stringify(hits)));
        R.push('');
        R.push('=== DONE ===');
        P(R.join('\n'));
    }, 15000);
});
