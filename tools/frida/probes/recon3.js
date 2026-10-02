Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var ACV = "androidx.compose.ui.platform.AndroidComposeView";

  var n = 0;
  try {
    Java.choose(ACV, {
      onMatch: function (inst) {
        if (n++ > 0) return;

        // ── [a] 继承链 ──
        L("[a] 继承链（AndroidComposeView 是什么的什么）:");
        var c = inst.getClass();
        var d = 0;
        while (c && d < 10) {
          L("    " + c.getName() + (c.isInterface() ? "  [接口]" : ""));
          if (c.getName() === "java.lang.Object") break;
          c = c.getSuperclass(); d++;
        }

        // ── [b] 字段：声明类型 → 运行时类型（读真值）──
        L("");
        L("[b] 字段真值（声明类型  →  实际装着的类）:");
        var seen = {};
        var c2 = inst.getClass();
        var dep = 0;
        while (c2 && dep < 8) {
          var cn = c2.getName();
          if (cn === "java.lang.Object" || cn.indexOf("android.view") === 0) break;
          var fs = c2.getDeclaredFields();
          for (var i = 0; i < fs.length; i++) {
            var f = fs[i];
            try {
              if (f.getType().isPrimitive()) continue;
              f.setAccessible(true);
              var v = f.get(inst);
              if (v === null) continue;
              var rc = v.getClass().getName();
              seen[rc] = (seen[rc] || 0) + 1;
              L("    ." + f.getName() + " : " + f.getType().getName() + "   →   " + rc);
            } catch (e) {}
          }
          c2 = c2.getSuperclass(); dep++;
        }

        // ── [c] 那些混淆类型：是接口吗？几个方法？──
        L("");
        L("[c] 出现过的混淆类型，逐个体检:");
        var names = Object.keys(seen);
        for (var j = 0; j < names.length; j++) {
          var nm = names[j];
          if (nm.indexOf(".") >= 0) {          // 有包名的多半是系统类，跳过
            if (nm.indexOf("android.") !== 0 && nm.indexOf("java.") !== 0) {
              L("    " + nm + "  ×" + seen[nm] + "   （有包名，非混淆）");
            }
            continue;
          }
          try {
            var k = Java.use(nm);
            var kind = k.class.isInterface() ? "接口 ★" : "类";
            var ms = k.class.getDeclaredMethods().length;
            var flds = k.class.getDeclaredFields().length;
            L("    " + nm + "  ×" + seen[nm] + "   [" + kind + " 方法" + ms + " 字段" + flds + "]");
          } catch (e) {
            L("    " + nm + "  ×" + seen[nm] + "   （Java.use 失败: " + e + "）");
          }
        }
      },
      onComplete: function () { L("[z] recon3 done，实例数 = " + n); }
    });
  } catch (e) {
    L("[!] Java.choose 失败: " + e);
  }
});
