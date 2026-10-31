// smfinal.js --- 挖死最后一击：数美 SDK 到底 init 了吗？libsmsdk 何时被请求加载？
// ① 读 l11l11l111Il 的 Context 字段（null = 没 init）
// ② 读 SmAntiFraud 的 option 字段（null = 没 init）
// ③ hook System.loadLibrary / Runtime.loadLibrary0 抓 libsmsdk 请求
// ④ hook SmAntiFraud 的所有公开方法，看有没有被调过
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    function out(s) { P(s); }

    // ① SDK Context
    out('=== 1) 数美 SDK 的 Context（null = 从未 init）===');
    try {
        var Ctx = Java.use('com.ishumei.smantifraud.l11l11l111Il');
        var f = Ctx.class.getDeclaredField('l1111l111111Il');
        f.setAccessible(true);
        var v = f.get(null);
        out('  l11l11l111Il.l1111l111111Il(Context) = ' + (v === null ? 'null  ★ 从未初始化' : String(v)));
        // 其他静态字段
        var f2 = Ctx.class.getDeclaredField('l111l1111l1Il');
        f2.setAccessible(true);
        out('  l11l11l111Il.l111l1111l1Il(boolean) = ' + f2.get(null));
        var f3 = Ctx.class.getDeclaredField('l111l11111Il');
        f3.setAccessible(true);
        out('  l11l11l111Il.l111l11111Il(String) = ' + f3.get(null));
    } catch (e) { out('  FAIL: ' + first(e)); }

    // ② SmAntiFraud.option
    out('');
    out('=== 2) SmAntiFraud 的 option（null = 从未配置）===');
    try {
        var SA = Java.use('com.ishumei.smantifraud.SmAntiFraud');
        var fo = SA.class.getDeclaredField('option');
        fo.setAccessible(true);
        var ov = fo.get(null);
        out('  SmAntiFraud.option = ' + (ov === null ? 'null  ★ 从未配置' : String(ov)));
        var fc = SA.class.getDeclaredField('l111l11111lIl');
        fc.setAccessible(true);
        out('  SmAntiFraud.IServerSmidCallback = ' + fc.get(null));
        var fs = SA.class.getDeclaredField('l1111l111111Il');
        fs.setAccessible(true);
        out('  SmAntiFraud.String = ' + fs.get(null));
    } catch (e) { out('  FAIL: ' + first(e)); }

    // ③ Hook 动态库加载
    out('');
    out('=== 3) hook 动态库加载（抓 libsmsdk）===');
    var libHits = [];
    try {
        var RT = Java.use('java.lang.Runtime');
        var ovs = RT.loadLibrary0.overloads;
        for (var i = 0; i < ovs.length; i++) {
            (function (impl) {
                impl.implementation = function () {
                    var a = [];
                    for (var k = 0; k < arguments.length; k++) a.push(String(arguments[k]));
                    var sig = a.join(' , ');
                    if (sig.toLowerCase().indexOf('smsdk') >= 0 || sig.toLowerCase().indexOf('shumei') >= 0) {
                        libHits.push('  ★★★ 请求加载: ' + sig);
                        out('  ★★★ 请求加载: ' + sig);
                    }
                    return impl.apply(this, arguments);
                };
            })(ovs[i]);
        }
        out('  Runtime.loadLibrary0 hook 已装 x' + ovs.length);
    } catch (e) { out('  Runtime hook 失败: ' + first(e)); }
    try {
        var SL = Java.use('java.lang.System');
        var ov2 = SL.loadLibrary.overloads;
        for (var j = 0; j < ov2.length; j++) {
            (function (impl2) {
                impl2.implementation = function (n) {
                    var s = String(n);
                    if (s.toLowerCase().indexOf('smsdk') >= 0) {
                        out('  ★★★ System.loadLibrary("' + s + '")');
                        libHits.push('System.loadLibrary(' + s + ')');
                    }
                    return impl2.call(this, n);
                };
            })(ov2[j]);
        }
        out('  System.loadLibrary hook 已装 x' + ov2.length);
    } catch (e) { out('  System hook 失败: ' + first(e)); }

    // ④ hook SmAntiFraud 的公开方法
    out('');
    out('=== 4) hook SmAntiFraud 全部方法（看谁调它）===');
    var saHits = {};
    try {
        var SA2 = Java.use('com.ishumei.smantifraud.SmAntiFraud');
        var methods = SA2.class.getDeclaredMethods();
        var hooked = 0;
        for (var m = 0; m < methods.length; m++) {
            var mn = methods[m].getName();
            (function (name) {
                try {
                    var ov3 = SA2[name].overloads;
                    for (var o = 0; o < ov3.length; o++) {
                        (function (impl3, sig) {
                            impl3.implementation = function () {
                                saHits[name] = (saHits[name] || 0) + 1;
                                out('  ### SmAntiFraud.' + name + '(' + sig + ') CALLED #' + saHits[name]);
                                var ret = impl3.apply(this, arguments);
                                return ret;
                            };
                        })(ov3[o], ov3[o].argumentTypes.length + ' args');
                        hooked++;
                    }
                } catch (e) { }
            })(mn);
        }
        out('  已 hook ' + hooked + ' 个重载');
    } catch (e) { out('  FAIL: ' + first(e)); }

    out('');
    out('=== 观察 20 秒 ===');
    var beat = 0;
    var iv = setInterval(function () {
        beat++;
        out('  ... t=' + (beat * 5) + 's  libHits=' + libHits.length + '  SmAntiFraud调用=' + (Object.keys(saHits).length ? JSON.stringify(saHits) : '0'));
        if (beat >= 4) {
            clearInterval(iv);
            out('');
            out('=== FINAL ===');
            out('libsmsdk 加载请求: ' + (libHits.length ? libHits.join(' | ') : '★ 20 秒内没有任何加载请求'));
            out('SmAntiFraud 方法调用: ' + (Object.keys(saHits).length ? JSON.stringify(saHits) : '★ 一次都没被调用'));
            out('=== DONE ===');
        }
    }, 5000);
});
