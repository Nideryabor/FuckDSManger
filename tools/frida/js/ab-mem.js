/*
 * ab-mem.js —— 从内存里直接读 AB 配置（上次那条路，0 成本）🐲 2026-11-01
 *
 * 出处：巢穴/日记/2026-10-31.md 第六节 ——
 *   主人问「火山引擎下发的 AB 配置解密了吗」
 *   结论：**不该问「怎么解密」，该问「配置拉下来之后在内存里长什么样」**
 *   Java.choose('htc', ...) → inst.a() → 8361 字符完整 JSON，22 项全拿到（带 vid）
 *
 * 这次（2.7.2）：
 *   · htc 还在，a() 返回 JSONObject 也还在
 *   · 另外再 dump 一份 MMKV 侧的对照（我们已经有 60 项）
 *
 * 产出：把 JSON 打成一行一行的 key=value，方便和 MMKV 那份对齐比较。
 */

Java.perform(function () {
    var out = [];

    function emit(s) {
        out.push(s);
        console.log(s);
    }

    emit('[MEM] 开始扫描 htc 实例…');

    var inst = null;
    try {
        Java.choose('htc', {
            onMatch: function (o) { if (!inst) inst = o; },
            onComplete: function () { }
        });
    } catch (e) {
        emit('[MEM] Java.choose 失败: ' + e);
    }

    if (!inst) {
        emit('[MEM] 没找到 htc 实例（可能还没初始化，或已经改成别的类名）');
    } else {
        emit('[MEM] 找到 htc 实例: ' + inst);
        try {
            var jo = inst.a();
            var s = jo === null ? 'null' : jo.toString();
            emit('[MEM] a() 长度 = ' + s.length);
            emit('[MEM] ===== JSON 开始 =====');
            // 太长就分段打（网关的 result.txt 有大小限制）
            var CH = 3000;
            for (var i = 0; i < s.length; i += CH) {
                emit('[MEM] ' + s.substring(i, i + CH));
            }
            emit('[MEM] ===== JSON 结束 =====');
        } catch (e) {
            emit('[MEM] 调 a() 失败: ' + e);
        }
    }

    // ── 顺便把 htc 的所有 0 参方法试一遍，看还有没有别的有用的 ──
    try {
        var C = Java.use('htc');
        var ms = C.class.getDeclaredMethods();
        var names = [];
        ms.forEach(function (m) { if (m.getParameterTypes().length === 0) names.push(m.getName()); });
        emit('[MEM] htc 的 0 参方法: ' + names.join(','));
    } catch (e) {
        emit('[MEM] 枚举方法失败: ' + e);
    }

    emit('[MEM] 完成');
});
