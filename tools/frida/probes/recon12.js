Java.performNow(function () {
  var L = function (s) { console.log(s); };

  var dump = function (name, cap) {
    cap = cap || 30;
    L("");
    L("############ " + name);
    var k;
    try { k = Java.use(name); } catch (e) { L("  ✗ Java.use 失败"); return; }
    try { L("  isInterface = " + k.class.isInterface()); } catch (e) {}
    try {
      var sup = k.class.getInterfaces();
      for (var i = 0; i < sup.length; i++) L("  extends/implements " + sup[i].getName());
    } catch (e) {}
    try {
      var ms = k.class.getDeclaredMethods();
      L("  方法数 = " + ms.length);
      for (var m = 0; m < Math.min(ms.length, cap); m++) {
        var p = ms[m].getParameterTypes().map(function (x) { return x.getName(); });
        L("      " + ms[m].getName() + "(" + p.join(",") + ") : " + ms[m].getReturnType().getName());
      }
      if (ms.length > cap) L("      …（还有 " + (ms.length - cap) + " 个）");
    } catch (e) {}
  };

  // ★ 关键问题：va6 是不是 DrawScope / ContentDrawScope？
  dump("va6", 60);

  // 候选的 draw 接口
  ["ta6", "wz4", "gp7", "nsa"].forEach(function (n) { dump(n, 15); });

  // 顺带看 ContentDrawScope 那条链上常出现的类型
  ["e93", "ayb", "dl7"].forEach(function (n) { dump(n, 12); });

  L("");
  L("[z] recon12 done");
});
