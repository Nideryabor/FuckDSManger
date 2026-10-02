// probe1.js —— 第一次真正"问"宿主：Compose 的那些关键类到底叫什么、有什么
// 跑法：python3 frida_eval.py com.deepseek.chat.a -f probe1.js

Java.perform(function () {
    var all = Java.enumerateLoadedClassesSync();
    log("已加载类总数：" + all.length);

    // ① 还留着真名的 compose 类（能直接 use 的）
    var named = all.filter(function (c) { return c.indexOf("androidx.compose") === 0; });
    log("androidx.compose.* 保留真名的：" + named.length + " 个");
    named.slice(0, 10).forEach(function (c) { log("   " + c); });

    // ② 我们靠反编译猜出来的混淆名，验证它们是不是真有
    var guesses = ["c76", "da5", "b76", "te0", "se0", "d68", "k59", "uia", "uk8", "zc"];
    guesses.forEach(function (g) {
        try {
            var C = Java.use(g);
            var ms = C.class.getDeclaredMethods();
            var fs = C.class.getDeclaredFields();
            log("✓ " + g + " : " + ms.length + " 方法 / " + fs.length + " 字段   super="
                + C.class.getSuperclass().getName());
        } catch (e) {
            log("✗ " + g + " : " + e);
        }
    });
});
