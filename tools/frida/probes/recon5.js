Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var X97 = "x97";

  var dump = function (name, cap) {
    cap = cap || 40;
    L("");
    L("############ " + name);
    var k;
    try { k = Java.use(name); } catch (e) { L("  ✗ Java.use 失败"); return; }
    try { L("  isInterface = " + k.class.isInterface()); } catch (e) {}
    try { L("  父类 = " + k.class.getSuperclass().getName()); } catch (e) {}
    try {
      var ifs = k.class.getInterfaces();
      for (var i = 0; i < ifs.length; i++) L("  接口 = " + ifs[i].getName());
    } catch (e) {}
    try {
      var dcs = k.class.getDeclaredClasses();
      L("  内部类数 = " + dcs.length);
      for (var d = 0; d < Math.min(dcs.length, 8); d++) L("      $ " + dcs[d].getName());
    } catch (e) {}
    try {
      var ms = k.class.getDeclaredMethods();
      L("  方法数 = " + ms.length);
      for (var m = 0; m < Math.min(ms.length, cap); m++) {
        var p = ms[m].getParameterTypes().map(function (x) { return x.getName(); });
        L("      m " + ms[m].getName() + "(" + p.join(",") + ") : " + ms[m].getReturnType().getName());
      }
      if (ms.length > cap) L("      …（还有 " + (ms.length - cap) + " 个）");
    } catch (e) {}
  };

  // [A] 主角
  dump(X97, 60);

  // [B] AndroidViewHolder 实现的 4 个接口（可能有 DrawModifier 那一族）
  ["gi7", "a23", "ix7", "rq7"].forEach(function (n) { dump(n, 30); });

  // [C] 高频可疑类型
  ["q08", "wd7"].forEach(function (n) { dump(n, 30); });

  // [D] ★ 从活实例出发：谁真的装着 Modifier？★
  L("");
  L("############ [D] 活 AndroidComposeView 里，哪些字段真的装着 x97");
  var n = 0;
  try {
    Java.choose("androidx.compose.ui.platform.AndroidComposeView", {
      onMatch: function (inst) {
        if (n++ > 0) return;
        var X = null;
        try { X = Java.use(X97).class; } catch (e) {}
        var c = inst.getClass(), dep = 0;
        while (c && dep < 8) {
          var cn = c.getName();
          if (cn === "java.lang.Object" || cn.indexOf("android.view") === 0) break;
          var fs = c.getDeclaredFields();
          for (var i = 0; i < fs.length; i++) {
            try {
              if (fs[i].getType().isPrimitive()) continue;
              fs[i].setAccessible(true);
              var v = fs[i].get(inst);
              if (v === null) continue;
              if (X && X.isInstance(v)) {
                L("    ★ ." + fs[i].getName() + " : " + fs[i].getType().getName()
                  + "   →   " + v.getClass().getName() + "   【是 Modifier】");
              }
            } catch (e) {}
          }
          c = c.getSuperclass(); dep++;
        }
      },
      onComplete: function () { L("    实例数 = " + n); }
    });
  } catch (e) { L("    choose 失败: " + e); }

  L("");
  L("[z] recon5 done");
});
