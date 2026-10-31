// maps272c.js —— 追查：为什么 enumerateLoadedClasses 里有 30 个 xposed 类，
//                但 Java.use / Class.forName 却 ClassNotFoundException？
// 核心问题：**数美自己的 forName("de.robv...XposedInit") 到底会不会成功**
'use strict';
function P(s) { console.log(s); }
function err(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var R = [];

    // ① app 的 ClassLoader 链
    var appLoader = null;
    try {
        var app = Java.use('android.app.ActivityThread').currentApplication();
        appLoader = app.getClassLoader();
        R.push('=== app ClassLoader 链 ===');
        var cl = appLoader, d = 0;
        while (cl !== null && d < 8) {
            R.push('  [' + d + '] ' + cl.getClass().getName() + '  -> ' + cl.toString().substring(0, Math.min(150, String(cl.toString()).length)));
            cl = cl.getParent(); d++;
        }
    } catch (e) { R.push('app loader fail: ' + err(e)); }

    // ② ★ 关键：用 app 的 loader 做 Class.forName（= 数美会走的路径）
    R.push('');
    R.push('=== ★ 用 app ClassLoader 做 Class.forName（复刻数美）===');
    var names = ['de.robv.android.xposed.XposedInit',
                 'de.robv.android.xposed.XposedHelpers',
                 'de.robv.android.xposed.XposedBridge',
                 'de.robv.android.xposed.IXposedHookZygoteInit'];
    for (var i = 0; i < names.length; i++) {
        var n = names[i];
        // (a) 带 loader 的（frida 的 Java.classFactory 风格，等价于数美在 app 上下文里 forName）
        var ra = 'FAIL';
        try { var c1 = Java.classFactory.use(n); ra = 'OK → ' + c1.class.getName(); } catch (e) { ra = 'FAIL: ' + err(e).substring(0, 90); }
        // (b) 真·Java 反射 forName(name, initialize, loader)
        var rb = 'FAIL';
        try {
            var C = Java.use('java.lang.Class');
            var r = C.forName(n, false, appLoader);
            rb = 'OK → ' + r.getName() + ' loader=' + r.getClassLoader();
        } catch (e) { rb = 'FAIL: ' + err(e).substring(0, 90); }
        // (c) 裸 forName(name) —— 数美最爱用的单参版（用「当前类的 ClassLoader」）
        var rc = 'FAIL';
        try {
            var C2 = Java.use('java.lang.Class');
            var r2 = C2.forName(n);
            rc = 'OK → ' + r2.getName();
        } catch (e) { rc = 'FAIL: ' + err(e).substring(0, 90); }
        R.push('  [' + n.split('.').pop() + ']');
        R.push('      a) Java.classFactory.use → ' + ra);
        R.push('      b) Class.forName(n,false,appLoader) → ' + rb);
        R.push('      c) Class.forName(n)  → ' + rc);
    }

    // ③ ★ 从数美自己的视角试一遍：数美类的 ClassLoader 和 app 的一样吗？
    R.push('');
    R.push('=== 数美类的 ClassLoader ===');
    try {
        var SM = Java.use('com.ishumei.smantifraud.l1111l111111Il');
        var sml = SM.class.getClassLoader();
        R.push('  数美类 loader = ' + (sml === null ? 'null(boot)' : sml.toString().substring(0, 150)));
        R.push('  与 app loader 同一个？ ' + (sml === appLoader ? 'YES' : 'NO'));
        // 用数美自己的 loader 去 forName（最贴近真实）
        try {
            var C3 = Java.use('java.lang.Class');
            var r3 = C3.forName('de.robv.android.xposed.XposedInit', false, sml);
            R.push('  ★ 用数美 loader forName XposedInit → OK → ' + r3.getName());
        } catch (e) { R.push('  ★ 用数美 loader forName XposedInit → FAIL: ' + err(e).substring(0, 120)); }
    } catch (e) { R.push('  数美类没加载 / 拿不到: ' + err(e)); }

    // ④ 反查：那 30 个 xposed 类到底在谁的 loader 里？
    R.push('');
    R.push('=== 那些 xposed 类实际所在的 ClassLoader ===');
    try {
        var found = {};
        Java.enumerateClassLoadersSync().forEach(function (ldr) {
            try {
                var c = ldr.loadClass('de.robv.android.xposed.XposedInit');
                if (c !== null) found[ldr.toString()] = c.getName();
            } catch (e) { /* ignore */ }
        });
        var ks = Object.keys(found);
        if (ks.length === 0) R.push('  （没有任何 ClassLoader 能 loadClass 到它）');
        for (var k = 0; k < ks.length; k++) R.push('  loader = ' + String(ks[k]).substring(0, 200));
    } catch (e) { R.push('  enumerateClassLoaders fail: ' + err(e)); }

    // ⑤ app loader 的 dexElements 里到底有什么（看模块 dex 有没有被插进来）
    R.push('');
    R.push('=== app PathClassLoader.dexElements 清单（前 15 条）===');
    try {
        var base = appLoader;
        while (base !== null && base.getClass().getName().indexOf('PathClassLoader') < 0) base = base.getParent();
        if (base === null) {
            R.push('  找不到 PathClassLoader');
        } else {
            var f = base.getClass().getSuperclass().getDeclaredField('pathList');
            f.setAccessible(true);
            var pl = f.get(base);
            var f2 = pl.getClass().getDeclaredField('dexElements');
            f2.setAccessible(true);
            var els = f2.get(pl);
            var len = Java.array('java.lang.Object', els).length;
            R.push('  dexElements 数量 = ' + len);
            for (var d2 = 0; d2 < Math.min(15, len); d2++) {
                var el = Java.array('java.lang.Object', els)[d2];
                R.push('    [' + d2 + '] ' + String(el.toString()).substring(0, 180));
            }
        }
    } catch (e) { R.push('  dexElements 读失败: ' + err(e).substring(0, 150)); }

    // ⑥ 数美是否已经开始采集（看那几个采集类的静态状态）
    R.push('');
    R.push('=== 数美运行状态 ===');
    try {
        var all = Java.enumerateLoadedClassesSync();
        var sm = [];
        for (var z = 0; z < all.length; z++) if (all[z].indexOf('com.ishumei') === 0) sm.push(all[z]);
        R.push('  已加载数美类 ' + sm.length + ' 个: ' + sm.join(', '));
    } catch (e) { R.push('  ' + err(e)); }

    R.push('');
    R.push('=== DONE ===');
    P(R.join('\n'));
});
