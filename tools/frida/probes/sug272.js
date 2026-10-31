// sug272.js --- 只读勘察：回复建议的 Modifier 链里到底有什么
// 目标：h67.f(List,vy4,yj7,Z,J,vy4,Z,r15,I,I)V   ← 建议列表外壳（带 « 3/3 » 翻页）
//       h67.c(gi7,fy4,yj7,ZJ,r15,I)V             ← 单个建议 chip
// 只看不改。产出：Modifier 链的 class 名 + 逐层 Element 名
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var R = [];
    function out(s) { R.push(s); P(s); }
    var seen = {};

    function dumpModifier(label, obj) {
        if (obj === null) { out('  [' + label + '] null'); return; }
        var cname = '';
        try { cname = String(obj.getClass().getName()); } catch (e) { cname = '<' + first(e) + '>'; }
        if (seen[cname]) { out('  [' + label + '] ' + cname + '  （已见过，跳过）'); return; }
        seen[cname] = 1;
        out('  [' + label + '] ' + cname);
        // Compose Modifier 是链表：字段里有个 companion/next
        try {
            var fs = obj.getClass().getDeclaredFields();
            for (var i = 0; i < fs.length; i++) {
                var f = fs[i];
                f.setAccessible(true);
                var t = String(f.getType().getName());
                var v = null;
                try { v = f.get(obj); } catch (e) { }
                if (v !== null && String(f.getName()).toLowerCase().indexOf('next') >= 0) {
                    out('        .' + f.getName() + ' (' + t + ') -> 递归');
                    dumpModifier(label + '>next', v);
                } else {
                    out('        .' + f.getName() + ' : ' + t + ' = ' + (v === null ? 'null' : String(v).substring(0, 70)));
                }
            }
        } catch (e) { out('        字段读失败: ' + first(e)); }
    }

    var hooked = 0;

    // ── h67.f：建议列表外壳 ──────────────────────────────
    try {
        var H = Java.use('h67');
        var ov = H.f.overloads;
        out('=== h67.f 重载数: ' + ov.length);
        for (var i = 0; i < ov.length; i++) {
            (function (impl, sig) {
                impl.implementation = function () {
                    if (!seen['__f__']) {
                        seen['__f__'] = 1;
                        out('');
                        out('=== ★ h67.f 被调用 (' + sig + ') ===');
                        var args = [];
                        for (var k = 0; k < arguments.length; k++) {
                            var a = arguments[k];
                            args.push(a === null ? 'null' : String(a.getClass().getName()));
                        }
                        out('  实参类型: ' + args.join(' | '));
                        // 逐个 dump 看起来像 Modifier 的
                        for (var k2 = 0; k2 < arguments.length; k2++) {
                            var a2 = arguments[k2];
                            if (a2 === null) continue;
                            var cn = String(a2.getClass().getName());
                            if (cn.indexOf('yj7') >= 0 || cn.indexOf('Modifier') >= 0 || cn.indexOf('Element') >= 0) {
                                dumpModifier('f.arg' + k2, a2);
                            }
                        }
                    }
                    return impl.apply(this, arguments);
                };
            })(ov[i], ov[i].argumentTypes.length + ' args');
            hooked++;
        }
    } catch (e) { out('h67.f hook 失败: ' + first(e)); }

    // ── h67.c：单个 chip ─────────────────────────────────
    try {
        var H2 = Java.use('h67');
        var ov2 = H2.c.overloads;
        out('=== h67.c 重载数: ' + ov2.length);
        for (var j = 0; j < ov2.length; j++) {
            (function (impl2, sig2) {
                impl2.implementation = function () {
                    if (!seen['__c__']) {
                        seen['__c__'] = 1;
                        out('');
                        out('=== ★ h67.c 被调用 (' + sig2 + ') ===');
                        for (var k = 0; k < arguments.length; k++) {
                            var a = arguments[k];
                            if (a === null) continue;
                            var cn = String(a.getClass().getName());
                            out('  arg' + k + ' : ' + cn);
                            if (cn.indexOf('yj7') >= 0 || cn.indexOf('Modifier') >= 0) dumpModifier('c.arg' + k, a);
                        }
                    }
                    return impl2.apply(this, arguments);
                };
            })(ov2[j], ov2[j].argumentTypes.length + ' args');
            hooked++;
        }
    } catch (e) { out('h67.c hook 失败: ' + first(e)); }

    // ── 兜底：h67 全部 static 方法都挂一遍，抓所有 Modifier 实参 ──
    try {
        var ALL = Java.use('h67');
        var ms = ALL.class.getDeclaredMethods();
        var extra = 0;
        for (var z = 0; z < ms.length; z++) {
            var mn = String(ms[z].getName());
            if (!/^[a-zA-Z]$/.test(mn)) continue;
            try {
                var ovz = ALL[mn].overloads;
                for (var w = 0; w < ovz.length; w++) {
                    (function (impl3, name, sig3) {
                        impl3.implementation = function () {
                            var key = name + '/' + sig3;
                            if (seen[key]) return impl3.apply(this, arguments);
                            var found = false;
                            for (var q = 0; q < arguments.length; q++) {
                                var aa = arguments[q];
                                if (aa === null) continue;
                                var ccn = String(aa.getClass().getName());
                                if (ccn.indexOf('yj7') >= 0) {
                                    if (!found) {
                                        seen[key] = 1; found = true;
                                        out('');
                                        out('=== ★ h67.' + name + ' (' + sig3 + ') 带 Modifier ===');
                                    }
                                    dumpModifier('h67.' + name + '.arg' + q, aa);
                                }
                            }
                            return impl3.apply(this, arguments);
                        };
                    })(ovz[w], mn, ovz[w].argumentTypes.length + ' args');
                    extra++;
                }
            } catch (e2) { }
        }
        out('=== 兜底：额外 hook ' + extra + ' 个重载');
    } catch (e) { out('兜底 hook 失败: ' + first(e)); }

    out('');
    out('=== 已 hook ' + hooked + ' 个，等触发（切换会话 / 滚动列表 让它重组）===');

    var beat = 0;
    var iv = setInterval(function () {
        beat++;
        out('  ... t=' + (beat * 5) + 's');
        if (beat >= 22) {
            clearInterval(iv);
            out('');
            out('=== DONE ===');
        }
    }, 5000);
});
