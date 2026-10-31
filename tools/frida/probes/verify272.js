// verify272.js --- 验证 3.72.0 在宿主 2.7.2 上的实际生效情况
// ① GmRemap.stats() —— 表版本对不对
// ② 每个锚点类能否在宿主里 findClass（走 GmRemap.cls）
// ③ XposedBridge hook 表里能不能看到我们的钩子
// ④ 数美引擎有没有被吵醒（顺手监控）
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var R = [];
    function out(s) { R.push(s); P(s); }

    // ① GmRemap 表
    out('=== 1) GmRemap 表状态 ===');
    try {
        var G = Java.use('com.nidyaber.fuckdsmanger.bridge.GmRemap');
        out('  stats() = ' + G.stats());
    } catch (e) { out('  ✗ GmRemap 不可用: ' + first(e)); }

    // ② 关键锚点 findClass 验证
    out('');
    out('=== 2) 锚点类在宿主里是否真实存在（cls按老名字走表）===');
    var app = null;
    try { app = Java.use('android.app.ActivityThread').currentApplication(); } catch (e) { }
    var cl = null;
    try { cl = app.getClassLoader(); } catch (e) { }
    if (!cl) { out('  ✗ 拿不到 ClassLoader'); return; }

    var G2 = null;
    try { G2 = Java.use('com.nidyaber.fuckdsmanger.bridge.GmRemap'); } catch (e) { }

    // 用 2.5.2 的老键名测（证明多代键生效）
    var oldKeys = ['kf5', 'fh6', 'me4', 'm5', 'h91', 'p5', 'pn9', 'ls9', 'uia', 'tn0',
                   'jd8', 'se0', 'zc', 's5', 'p66', 'h02', 'ao1', 'bx4', 'yb5', 'pd5',
                   'hp8', 'wr', 'sr9', 'lp9', 'le', 'ok0', 'ku6', 'vq', 'c76', 'ey3',
                   'sn0', 'dd8', 'md8', 'we5', 'vk0', 'gz3', 'it9', 'u19', 'g56'];
    var okCnt = 0, badList = [];
    for (var i = 0; i < oldKeys.length; i++) {
        var k = oldKeys[i];
        try {
            var mapped = G2.cls(k);
            var cls = cl.loadClass(mapped);
            if (cls !== null) { okCnt++; }
            else { badList.push(k + '->' + mapped + '(null)'); }
        } catch (e) {
            badList.push(k + '->' + (function () { try { return G2.cls(k); } catch (x) { return '?'; } })());
        }
    }
    out('  ✅ 存在 ' + okCnt + ' / ' + oldKeys.length);
    if (badList.length) out('  ✗ 找不到: ' + badList.join(', '));

    // ③ 方法级验证（clsFor + method）
    out('');
    out('=== 3) 方法落点验证（clsFor + method）===');
    var probes = [
        ['kf5', 'K'], ['fh6', 'N'], ['m5', 'v'], ['p5', 'v'], ['s5', 'v'],
        ['h91', 'a'], ['pn9', 'c'], ['ls9', 'f'], ['zc', 's'], ['tn0', 'b'],
        ['se0', 'c'], ['uia', 'u'], ['uia', 'v'], ['p66', 'h'], ['h02', 'u'],
        ['ao1', 'I'], ['ao1', 'J'], ['ao1', 'M'], ['bx4', 'get'], ['yb5', 'e'],
        ['yb5', 'f'], ['pd5', 'I'], ['pd5', 'H'], ['wr', 'x'], ['wr', 'z'],
        ['me4', 'a'], ['hp8', 'isEmpty'], ['sr9', 'w']
    ];
    var mOk = 0, mBad = [];
    for (var j = 0; j < probes.length; j++) {
        var oc = probes[j][0], om = probes[j][1];
        try {
            var owner = G2.clsFor(oc, om);
            var nm = G2.method(oc, om);
            var cc = cl.loadClass(owner);
            var found = false;
            var ms = cc.getDeclaredMethods();
            for (var z = 0; z < ms.length; z++) {
                if (String(ms[z].getName()) === String(nm)) { found = true; break; }
            }
            if (found) { mOk++; }
            else { mBad.push(oc + '.' + om + ' -> ' + owner + '.' + nm + '(类在/方法缺)'); }
        } catch (e) {
            mBad.push(oc + '.' + om + ' -> ' + first(e).substring(0, 60));
        }
    }
    out('  ✅ 方法命中 ' + mOk + ' / ' + probes.length);
    if (mBad.length) {
        out('  ✗ 未命中 ' + mBad.length + ' 条:');
        for (var b = 0; b < mBad.length; b++) out('      ' + mBad[b]);
    }

    // ④ Xposed hook 表
    out('');
    out('=== 4) XposedBridge hook 表 ===');
    try {
        var XB = Java.use('de.robv.android.xposed.XposedBridge');
        var f = XB.class.getDeclaredField('sHookedMethodCallbacks');
        f.setAccessible(true);
        var hs = f.get(null);
        if (hs !== null) {
            var snap = hs.getSnapshot();
            out('  hook 表快照长度 = ' + snap.length);
        }
    } catch (e) { out('  (读不到，正常：Xposed 类不在目标 loader) — ' + first(e).substring(0, 60)); }

    // ⑤ 数美引擎监控
    out('');
    out('=== 5) 数美引擎状态（顺手监控）===');
    try {
        var Ctx = Java.use('com.ishumei.smantifraud.l11l11l111Il');
        var f2 = Ctx.class.getDeclaredField('l1111l111111Il');
        f2.setAccessible(true);
        var v = f2.get(null);
        out('  SmAntiFraud Context = ' + (v === null ? 'null（未启动 ✓）' : String(v)));
    } catch (e) { out('  ' + first(e).substring(0, 60)); }

    out('');
    out('=== DONE ===');
});
