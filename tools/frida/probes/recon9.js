Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var VH = "androidx.compose.ui.viewinterop.AndroidViewHolder";

  var vh = null, n = 0;
  try {
    Java.choose(VH, {
      onMatch: function (v) { if (n++ === 0) vh = v; },
      onComplete: function () {}
    });
  } catch (e) { L("[!] choose 失败 " + e); }
  if (!vh) { L("[!] 没有活实例"); L("[z] done"); return; }

  var cls = vh.getClass();
  L("[A] 活实例 = " + cls.getName() + "（父类链会往上走）");

  var X = null;
  try { X = Java.use("x97").class; } catch (e) { L("[!] 拿不到 x97: " + e); }

  // ── 走父类链，找"装着 Modifier 的字段"──
  L("");
  L("[B] 沿父类链找 Modifier 字段");
  var md = null;
  var c = cls, dep = 0;
  while (c && dep < 8) {
    var cn = c.getName();
    if (cn === "java.lang.Object" || cn.indexOf("android.view") === 0) break;
    var fs = c.getDeclaredFields();
    for (var i = 0; i < fs.length; i++) {
      var ft = fs[i].getType().getName();
      var isX = (ft === "x97");
      try {
        if (fs[i].getType().isPrimitive()) continue;
        fs[i].setAccessible(true);
        var v = fs[i].get(vh);
        if (v === null) {
          if (isX) L("      ." + cn.split(".").pop() + "." + fs[i].getName() + " : x97  = null");
          continue;
        }
        if (isX || (X && X.isInstance(v))) {
          L("      ★ " + cn.split(".").pop() + "." + fs[i].getName()
            + " : " + ft + "  →  " + v.getClass().getName());
          if (!md) md = v;
        }
      } catch (e2) {}
    }
    c = c.getSuperclass(); dep++;
  }
  if (!md) L("      （没找到非空的 Modifier 字段）");

  // ── 解剖 ──
  if (md) {
    L("");
    L("[C] 真实 Modifier 实例解剖");
    var mc = md.getClass();
    L("    实际类 = " + mc.getName());
    var ifs = mc.getInterfaces();
    for (var i = 0; i < ifs.length; i++) {
      L("    implements " + ifs[i].getName());
      try {
        var i2 = ifs[i].getInterfaces();
        for (var j = 0; j < i2.length; j++) {
          L("        extends " + i2[j].getName());
          try {
            var i3 = i2[j].getInterfaces();
            for (var k = 0; k < i3.length; k++) L("            extends " + i3[k].getName());
          } catch (e3) {}
        }
      } catch (e2) {}
    }
    L("");
    L("    自己声明的方法:");
    var ms = mc.getDeclaredMethods();
    for (var m = 0; m < Math.min(ms.length, 25); m++) {
      var p = ms[m].getParameterTypes().map(function (x) { return x.getName(); });
      L("      m " + ms[m].getName() + "(" + p.join(",") + ") : " + ms[m].getReturnType().getName());
    }
    L("    方法数 = " + ms.length);
  }

  L("");
  L("[z] recon9 done");
});
