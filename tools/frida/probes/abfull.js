// abfull.js --- 完整 dump AB 配置（htc.a()），写到设备文件 + 打印
'use strict';
function P(s) { console.log(s); }
function first(e) { return (e && e.message) ? String(e.message).split('\n')[0] : String(e); }

Java.perform(function () {
    var inst = null;
    Java.choose('htc', { onMatch: function (o) { if (inst === null) inst = o; }, onComplete: function () { } });
    if (inst === null) { P('FAIL: 找不到 htc 实例'); return; }

    var json = '';
    try { json = String(inst.a()); } catch (e) { P('htc.a() 失败: ' + first(e)); return; }

    P('=== AB 配置总长度: ' + json.length + ' 字符 ===');

    // 写设备文件（分块写，避免 frida 参数长度问题）
    try {
        var FOS = Java.use('java.io.FileOutputStream');
        var fos = FOS.$new('/data/local/tmp/abcfg.json');
        var b = Java.use('java.lang.String').$new(json).getBytes('UTF-8');
        fos.write(b);
        fos.close();
        P('已写入 /data/local/tmp/abcfg.json (' + b.length + ' 字节)');
    } catch (e) { P('写文件失败: ' + first(e)); }

    // 也打印出来（分段，避免单行过长）
    var CH = 3000;
    P('===BEGIN_ABCFG===');
    for (var i = 0; i < json.length; i += CH) {
        P('CHUNK' + (i / CH) + ':' + json.substring(i, Math.min(i + CH, json.length)));
    }
    P('===END_ABCFG===');

    // 顺带把其它字段也 dump
    try {
        var fnames = ['c', 'd', 'e', 'f', 'g', 'h'];
        for (var k = 0; k < fnames.length; k++) {
            try {
                var v = inst[fnames[k]]();
                P('htc.' + fnames[k] + '() = ' + String(v).substring(0, 300));
            } catch (e) { }
        }
    } catch (e) { }
    P('=== DONE ===');
});
