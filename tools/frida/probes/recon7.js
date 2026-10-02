Java.performNow(function () {
  var L = function (s) { console.log(s); };

  var CLS_ARR = function (names) {
    return Java.array("java.lang.Class", names.map(function (n) { return Java.use(n).class; }));
  };
  var OBJ_ARR = function (vals) {
    return Java.array("java.lang.Object", vals);
  };

  // ══════════════════════════════════════════════════════════
  // [A] 诊断：Frida 在这类实例上到底暴露了什么？
  // ══════════════════════════════════════════════════════════
  L("############ [A] Frida 在活实例上暴露的属性");
  var vhInst = null;
  var VH = "androidx.compose.ui.viewinterop.AndroidViewHolder";
  var n = 0;
  try {
    Java.choose(VH, {
      onMatch: function (v) { if (n++ === 0) vhInst = v; },
      onComplete: function () { L("    活 AndroidViewHolder 数 = " + n); }
    });
  } catch (e) { L("    choose 失败: " + e); }

  if (vhInst) {
    try {
      var props = Object.getOwnPropertyNames(vhInst);
      L("    实例 wrapper 属性（前 40）: " + props.slice(0, 40).join(", "));
      L("    getModifier 在不在: " + (props.indexOf("getModifier") >= 0));
      L("    _getModifier 在不在: " + (props.indexOf("_getModifier") >= 0));
    } catch (e) { L("    属性列举失败: " + e); }

    // ══════════════════════════════════════════════════════
    // [B] 三种拿 getModifier 的方式
    // ══════════════════════════════════════════════════════
    L("");
    L("############ [B] 三种方式拿 getModifier()");
    var md = null;

    // ① 直呼
    try { md = vhInst.getModifier(); L("    ① 直呼 vh.getModifier()  ✓ → " + (md ? md.getClass().getName() : "null")); }
    catch (e) { L("    ① 直呼  ✗ " + e); }

    // ② Frida 的 .call 形式
    if (!md) {
      try {
        var MK = Java.use(VH);
        md = MK.getModifier.call(vhInst);
        L("    ② K.getModifier.call(vh) ✓ → " + (md ? md.getClass().getName() : "null"));
      } catch (e) { L("    ② .call  ✗ " + e); }
    }

    // ③ 反射
    if (!md) {
      try {
        var cls = vhInst.getClass();
        var m = cls.getMethod("getModifier", Java.array("java.lang.Class", []));
        md = m.invoke(vhInst, Java.array("java.lang.Object", []));
        L("    ③ 反射 getMethod+invoke ✓ → " + (md ? md.getClass().getName() : "null"));
      } catch (e) { L("    ③ 反射  ✗ " + e); }
    }

    // ══════════════════════════════════════════════════════
    // [C] 拿到了 Modifier，它是什么？实现了哪些接口？
    // ══════════════════════════════════════════════════════
    if (md) {
      L("");
      L("############ [C] 真实 Modifier 实例的解剖");
      var c = md.getClass();
      L("    实际类 = " + c.getName());
      var dep = 0;
      while (c && dep < 6) {
        var cn = c.getName();
        if (cn === "java.lang.Object") break;
        L("      类链: " + cn + (c.isInterface() ? " [接口]" : ""));
        var ifs = c.getInterfaces();
        for (var i = 0; i < ifs.length; i++) {
          L("        implements " + ifs[i].getName());
          // 再往上一层
          try {
            var i2 = ifs[i].getInterfaces();
            for (var j = 0; j < i2.length; j++) {
              L("            extends " + i2[j].getName());
              try {
                var i3 = i2[j].getInterfaces();
                for (var k2 = 0; k2 < i3.length; k2++) L("                extends " + i3[k2].getName());
              } catch (e) {}
            }
          } catch (e) {}
        }
        c = c.getSuperclass(); dep++;
      }
    }
  } else {
    L("    没有活的 AndroidViewHolder 实例");
  }

  L("");
  L("[z] recon7 done");
});
