Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var VH = "androidx.compose.ui.viewinterop.AndroidViewHolder";

  // 拿活实例
  var vh = null, n = 0;
  try {
    Java.choose(VH, {
      onMatch: function (v) { if (n++ === 0) vh = v; },
      onComplete: function () {}
    });
  } catch (e) { L("[!] choose 失败 " + e); }

  if (!vh) { L("[!] 没有活的 AndroidViewHolder"); L("[z] done"); return; }
  L("[A] 拿到活 AndroidViewHolder");
  var cls = vh.getClass();
  L("    实际类 = " + cls.getName());

  // ── 读字段 h（recon4 探明它是 x97 = Modifier）──
  var md = null;
  try {
    var f = cls.getDeclaredField("h");
    f.setAccessible(true);
    md = f.get(vh);
    L("[B] 字段 .h 读出 → " + (md ? md.getClass().getName() : "null"));
  } catch (e) { L("[B] 读字段 .h 失败: " + e); }

  // ── 如果 h 是 null，退而遍历所有 x97 类型的字段 ──
  if (!md) {
    L("[B'] .h 是空的，扫所有字段找死装的 Modifier");
    try {
      var X = Java.use("x97").class;
      var fs = cls.getDeclaredFields();
      for (var i = 0; i < fs.length; i++) {
        try {
          if (fs[i].getType().isPrimitive()) continue;
          fs[i].setAccessible(true);
          var v = fs[i].get(vh);
          if (v !== null && X.isInstance(v)) {
            L("      ★ ." + fs[i].getName() + " : " + fs[i].getType().getName()
              + "  →  " + v.getClass().getName());
            if (!md) md = v;
          }
        } catch (e2) {}
      }
    } catch (e) { L("      扫字段失败: " + e); }
  }

  // ── 解剖这个真实的 Modifier ──
  if (md) {
    L("");
    L("[C] 真实 Modifier 实例解剖");
    var c = md.getClass();
    L("    实际类 = " + c.getName());
    L("    isInterface = " + c.isInterface());
    var ifs = c.getInterfaces();
    for (var i = 0; i < ifs.length; i++) {
      L("    implements " + ifs[i].getName());
      try {
        var i2 = ifs[i].getInterfaces();
        for (var j = 0; j < i2.length; j++) {
          L("        extends " + i2[j].getName());
          try {
            var i3 = i2[j].getInterfaces();
            for (var k = 0; k < i3.length; k++) L("            extends " + i3[k].getName());
          } catch (e) {}
        }
      } catch (e) {}
    }
    L("");
    L("    自己的方法:");
    var ms = c.getDeclaredMethods();
    for (var m = 0; m < Math.min(ms.length, 30); m++) {
      var p = ms[m].getParameterTypes().map(function (x) { return x.getName(); });
      L("      m " + ms[m].getName() + "(" + p.join(",") + ") : " + ms[m].getReturnType().getName());
    }
    L("    方法数 = " + ms.length);
  }

  L("");
  L("[z] recon8 done");
});
