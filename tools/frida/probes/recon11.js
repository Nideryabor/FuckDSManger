Java.performNow(function () {
  var L = function (s) { console.log(s); };

  var dump = function (name, cap) {
    cap = cap || 25;
    L("");
    L("############ " + name);
    var k;
    try { k = Java.use(name); } catch (e) { L("  ✗ Java.use 失败"); return; }
    try { L("  isInterface = " + k.class.isInterface()); } catch (e) {}
    try {
      var sup = k.class.getInterfaces();
      for (var i = 0; i < sup.length; i++) L("  extends " + sup[i].getName());
    } catch (e) {}
    try {
      var ms = k.class.getDeclaredMethods();
      L("  方法数 = " + ms.length);
      for (var m = 0; m < Math.min(ms.length, cap); m++) {
        var p = ms[m].getParameterTypes().map(function (x) { return x.getName(); });
        L("      m " + ms[m].getName() + "(" + p.join(",") + ") : " + ms[m].getReturnType().getName());
      }
    } catch (e) {}
  };

  dump("v97", 20);   // Modifier.Element
  dump("w97", 30);   // Modifier.Node

  // ══════════════════════════════════════════════════════════
  // 找活的 Modifier.Node 实例 —— 从它们的接口里挖 DrawModifierNode
  // ══════════════════════════════════════════════════════════
  L("");
  L("############ [N] 活的 Modifier.Node（w97）实例");
  var kinds = {}, ifaces = {}, cnt = 0;
  try {
    Java.choose("w97", {
      onMatch: function (node) {
        cnt++;
        if (cnt > 400) return;
        try {
          var nc = node.getClass();
          kinds[nc.getName()] = (kinds[nc.getName()] || 0) + 1;
          var ifs = nc.getInterfaces();
          for (var i = 0; i < ifs.length; i++) ifaces[ifs[i].getName()] = (ifaces[ifs[i].getName()] || 0) + 1;
        } catch (e) {}
      },
      onComplete: function () { L("    活节点总数 = " + cnt); }
    });
  } catch (e) { L("    Java.choose(w97) 失败: " + e); }

  L("");
  L("    节点类（前 25）:");
  Object.keys(kinds).slice(0, 25).forEach(function (k) { L("      " + kinds[k] + " ×  " + k); });

  L("");
  L("    节点实现的接口（前 30）—— 找一个带 draw 的:");
  Object.keys(ifaces).slice(0, 30).forEach(function (k) { L("      " + ifaces[k] + " ×  " + k); });

  // ⭐ 对出现的接口逐个看方法，找 draw 语义
  L("");
  L("    ★ 逐个体检这些接口（找方法签名里出现 Canvas/DrawScope 那类）:");
  Object.keys(ifaces).slice(0, 20).forEach(function (k) {
    try {
      var kc = Java.use(k).class;
      var ms = kc.getDeclaredMethods();
      var sigs = [];
      for (var m = 0; m < Math.min(ms.length, 6); m++) {
        var p = ms[m].getParameterTypes().map(function (x) { return x.getName(); }).join(",");
        sigs.push(ms[m].getName() + "(" + p + ")");
      }
      L("      " + k + "   →   " + sigs.join(" | "));
    } catch (e) { L("      " + k + "   →   (读不到)"); }
  });

  L("");
  L("[z] recon11 done");
});
