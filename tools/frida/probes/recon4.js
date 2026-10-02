Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var CAP = 70;   // 每个最多打多少行

  var targets = [
    "androidx.compose.ui.viewinterop.AndroidViewHolder",
    "androidx.compose.ui.viewinterop.ViewFactoryHolder",
    "androidx.compose.ui.platform.AndroidViewsHandler",
    "androidx.compose.ui.platform.AbstractComposeView",
    "androidx.compose.ui.platform.ComposeView",
    "androidx.compose.ui.graphics.layer.ViewLayer",
    "androidx.compose.ui.graphics.layer.view.ViewLayerContainer",
    "androidx.compose.ui.graphics.layer.view.DrawChildContainer"
  ];

  // 判断一个类型名是不是"被混淆的短名"（无包名的单段 token）
  var obf = function (n) {
    if (n.indexOf(".") >= 0) return false;
    if (n.indexOf("[") === 0) return false;
    var prim = { "int": 1, "long": 1, "float": 1, "double": 1, "boolean": 1, "byte": 1, "short": 1, "char": 1, "void": 1 };
    return !prim[n];
  };
  var mark = function (n) { return obf(n) ? " ★" : ""; };

  targets.forEach(function (tn) {
    L("");
    L("############ " + tn);
    var k;
    try { k = Java.use(tn); } catch (e) { L("  ✗ Java.use 失败"); return; }
    try {
      L("  父类: " + k.class.getSuperclass().getName() + mark(k.class.getSuperclass().getName()));
      var ifs = k.class.getInterfaces();
      for (var i = 0; i < ifs.length; i++) {
        L("  接口: " + ifs[i].getName() + mark(ifs[i].getName()));
      }
    } catch (e) {}

    var lines = [];
    try {
      var fs = k.class.getDeclaredFields();
      for (var a = 0; a < fs.length; a++) {
        var ft = fs[a].getType().getName();
        lines.push("  f  ." + fs[a].getName() + " : " + ft + mark(ft));
      }
    } catch (e) { lines.push("  字段失败: " + e); }
    try {
      var ms = k.class.getDeclaredMethods();
      for (var b = 0; b < ms.length; b++) {
        var p = ms[b].getParameterTypes().map(function (x) { return x.getName(); });
        var rt = ms[b].getReturnType().getName();
        var anyObf = p.some(obf) || obf(rt);
        var line = "  m  " + ms[b].getName() + "(" + p.join(",") + ") : " + rt;
        if (anyObf) {                       // 只留下"签名里带混淆类型"的 —— 那才是线索
          lines.push("★ " + line);
        } else if (lines.length < 20) {
          lines.push("  " + line);
        }
      }
    } catch (e) { lines.push("  方法失败: " + e); }

    var shown = 0;
    for (var z = 0; z < lines.length; z++) {
      if (shown++ >= CAP) { L("  …（截断）"); break; }
      L(lines[z]);
    }
  });

  L("");
  L("[z] recon4 done");
});
