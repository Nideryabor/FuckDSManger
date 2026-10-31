// maps272.js —— 2.7.2 「包名检测（查 data/app）」实测 + Xposed 四件套 🐲 尼得亚伯 2026-10-31
// 靶子：com.deepseek.chat.a（只 attach，不 spawn）
// 目的：
//   ① 在宿主进程内复刻数美 l111l1111llIl() 的算法，看我们自己的 apk 会不会被扫到
//   ② 复刻它「拿包名 → getApplicationInfo(0x80) → 取 xposedmodule meta-data」这一步
//   ③ 顺带量一下文档里说「必中」的 Xposed 四件套
//   ④ 看数美/Xposed 相关类有没有被加载、能不能 use

'use strict';

function P(s) { console.log(s); }
function J(x) { try { return JSON.stringify(x); } catch (e) { return String(x); } }
function err(e) { return (e && e.message) ? e.message : String(e); }

Java.perform(function () {
    var R = [];

    // ── 取 Context ──────────────────────────────────────────────────
    var app = null;
    try { app = Java.use('android.app.ActivityThread').currentApplication(); } catch (e) { R.push('currentApplication fail: ' + err(e)); }
    var selfPkg = '';
    try { selfPkg = app.getPackageName(); } catch (e) { R.push('getPackageName fail: ' + err(e)); }
    R.push('selfPackageName = ' + selfPkg);

    // ── ① 读 /proc/self/maps（复刻数美，用 Java IO 而不是 frida File）──
    var allLines = 0, daLines = 0, modLines = 0, xpLines = 0;
    var pkgsStrict = {};   // 数美严格算法：indexOf("-", i) 优先
    var pkgsLoose = {};    // 宽松：只取 /data/app/<hash>/<pkg>-<hash>
    var modLinesSample = [];
    try {
        var FIS = Java.use('java.io.FileInputStream');
        var ISR = Java.use('java.io.InputStreamReader');
        var BR = Java.use('java.io.BufferedReader');
        var br = BR.$new(ISR.$new(FIS.$new('/proc/self/maps')));
        var line;
        while ((line = br.readLine()) !== null) {
            allLines++;
            // ★ 注意必须转成 JS 字符串再判断，Java String 的 indexOf 也会被 hook 影响
            var s = String(line);
            if (s.indexOf('little_femaleboy') >= 0) {
                modLines++;
                if (modLinesSample.length < 6) modLinesSample.push(s.substring(0, 160));
            }
            if (s.indexOf('xposedmodule') >= 0) xpLines++;
            var i = s.indexOf('/data/app/');
            if (i < 0) continue;
            daLines++;

            // (a) 严格复刻数美
            var j = s.indexOf('-', i);
            if (j < 0) j = s.indexOf('/', i + 10);
            if (j > i + 10) {
                var p = s.substring(i + 10, j);
                pkgsStrict[p] = (pkgsStrict[p] || 0) + 1;
            }
            // (b) 宽松（人类直觉版）：/data/app/<a>/<b>/... 取 <b> 再去掉 -hash
            var m = s.match(/\/data\/app\/[^\/]+\/([^\/]+)\//);
            if (m) {
                var q = m[1];
                var k = q.lastIndexOf('-');
                if (k > 0) q = q.substring(0, k);
                pkgsLoose[q] = (pkgsLoose[q] || 0) + 1;
            }
        }
        br.close();
    } catch (e) { R.push('maps read fail: ' + err(e)); }

    R.push('');
    R.push('=== /proc/self/maps 统计 ===');
    R.push('总行数              = ' + allLines);
    R.push('含 /data/app/ 行数   = ' + daLines);
    R.push('含 little_femaleboy = ' + modLines + '   ★★ 这一项 >0 就是「中」');
    R.push('含 xposedmodule     = ' + xpLines);
    R.push('严格算法不同包数      = ' + Object.keys(pkgsStrict).length + '  -> ' + J(pkgsStrict));
    R.push('宽松算法不同包数      = ' + Object.keys(pkgsLoose).length + '  -> ' + J(pkgsLoose));
    if (modLinesSample.length) {
        R.push('--- little_femaleboy 命中样本 ---');
        for (var z = 0; z < modLinesSample.length; z++) R.push('  ' + modLinesSample[z]);
    }

    // ── ② 复刻「拿包名 → 查 meta-data」──
    R.push('');
    R.push('=== 复刻 xpApp 上报（getApplicationInfo + meta-data）===');
    var GET_META = 0x80;
    var pm = null;
    try { pm = app.getPackageManager(); } catch (e) { R.push('getPackageManager fail: ' + err(e)); }
    function probePkg(p) {
        try {
            var ai = pm.getApplicationInfo(p, GET_META);
            var md = ai.metaData.value;           // Bundle
            if (md === null) { R.push('   [' + p + '] metaData=null ⇒ 放过'); return; }
            var m = md.get('xposedmodule');
            if (m === null) { R.push('   [' + p + '] 无 xposedmodule ⇒ 放过'); return; }
            var mv = md.get('xposedminversion');
            var d = md.get('xposeddescription');
            R.push('   ★★★ [' + p + '] 命中！上报串 = "' +
                   [p, '<label>', String(m), String(mv), String(d)].join(',') + '"');
        } catch (e) {
            R.push('   [' + p + '] getApplicationInfo 失败: ' + err(e));
        }
    }
    var ks = Object.keys(pkgsStrict);
    for (var a = 0; a < ks.length; a++) probePkg(ks[a]);
    // 无论如何都直接拿我们自己查一遍（证明判据确实是 get()!=null）
    if (selfPkg) probePkg(selfPkg);

    // ── ③ Xposed 四件套 ────────────────────────────────────────────
    R.push('');
    R.push('=== Xposed 侧检测面（文档说「必中」的四条）===');
    function fieldOf(clsName, fname) {
        try {
            var C = Java.use(clsName);
            var f = C.class.getDeclaredField(fname);
            f.setAccessible(true);
            var v = f.get(null);
            return (v === null) ? 'null' : String(v);
        } catch (e) { return 'FAIL: ' + err(e); }
    }
    R.push('[#1] XposedInit.loadedPackagesInProcess = ' + fieldOf('de.robv.android.xposed.XposedInit', 'loadedPackagesInProcess'));
    R.push('[#2] XposedInit.loadedModules          = ' + fieldOf('de.robv.android.xposed.XposedInit', 'loadedModules'));
    R.push('[#4a] XposedHelpers.fieldCache          = ' + fieldOf('de.robv.android.xposed.XposedHelpers', 'fieldCache'));
    R.push('[#4b] XposedHelpers.methodCache         = ' + fieldOf('de.robv.android.xposed.XposedHelpers', 'methodCache'));
    R.push('[#4c] XposedHelpers.constructorCache    = ' + fieldOf('de.robv.android.xposed.XposedHelpers', 'constructorCache'));
    try {
        var XB = Java.use('de.robv.android.xposed.XposedBridge');
        var fields = XB.class.getDeclaredFields();
        var names = [];
        for (var f2 = 0; f2 < fields.length; f2++) names.push(fields[f2].getName());
        R.push('[#3] XposedBridge 字段 = ' + J(names));
        // 数 hook 数量
        try {
            var hf = XB.class.getDeclaredField('sHookedMethodCallbacks');
            hf.setAccessible(true);
            var hs = hf.get(null);
            if (hs !== null) {
                var snap = hs.getSnapshot();
                R.push('[#3] hook 表快照长度 = ' + snap.length + '  ★ 数美会拿这个当异常判据');
            }
        } catch (e) { R.push('[#3] 快照读取失败: ' + err(e)); }
    } catch (e) { R.push('[#3] XposedBridge fail: ' + err(e)); }

    // ── ④ 关键类可用性（顺手验锚点）─────────────────────────────────
    R.push('');
    R.push('=== 2.7.2 锚点类可用性（Java.use 能不能拿到）===');
    var want = ['k27', 'qx6', 'x98', 'qu7', 'cfb', 'a6', 'c6', 'c42', 'wb0', 'ik2',
                'ys', 'xr', 'qaa', 'ng9', 'mj7', 'cx2', 'a46', 'gi7', 'y27', 'h67',
                'lj5', 'ks0', 'yi0', 'k88', 'fp0', 'py9', 'olb', 'jb9', 'tx9', 'qf'];
    var loaded = Java.enumerateLoadedClassesSync();
    var loadedSet = {};
    for (var L = 0; L < loaded.length; L++) loadedSet[loaded[L]] = 1;
    var miss = [];
    for (var w = 0; w < want.length; w++) {
        var c = want[w];
        if (!loadedSet[c]) miss.push(c);
    }
    R.push('已加载的锚点类 = ' + (want.length - miss.length) + '/' + want.length);
    if (miss.length) R.push('尚未加载（正常，用到才加载）= ' + J(miss));

    // ── ⑤ 数美/Xposed 相关类是否在场 ────────────────────────────────
    R.push('');
    R.push('=== 敏感类在场情况 ===');
    var hits = { shumei: [], xposed: [], frida: [], sus: [] };
    for (var T = 0; T < loaded.length; T++) {
        var n = loaded[T];
        if (n.indexOf('com.ishumei') === 0) hits.shumei.push(n);
        else if (n.indexOf('de.robv.android.xposed') === 0) hits.xposed.push(n);
        else if (n.toLowerCase().indexOf('frida') >= 0) hits.frida.push(n);
    }
    R.push('com.ishumei 已加载类数 = ' + hits.shumei.length + (hits.shumei.length ? '  例: ' + hits.shumei.slice(0, 5).join(',') : ''));
    R.push('xposed 已加载类数     = ' + hits.xposed.length + (hits.xposed.length ? '  例: ' + hits.xposed.slice(0, 8).join(',') : ''));
    R.push('frida 相关已加载类    = ' + J(hits.frida));

    R.push('');
    R.push('=== DONE ===');
    P(R.join('\n'));
});
