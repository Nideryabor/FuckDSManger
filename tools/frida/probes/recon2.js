Java.performNow(function () {
  var L = function (s) { console.log(s); };

  // ── [a] 完整的 androidx.compose.* 名单（上次只打了 10 个）──
  var all = Java.enumerateLoadedClassesSync();
  var comp = all.filter(function (c) { return c.indexOf("androidx.compose") === 0; });
  L("[a] androidx.compose.* 总数 = " + comp.length);
  comp.sort().forEach(function (c) { L("    " + c); });

  // ── [b] 关键类探测：这些是"能不能干净地实现 Modifier"的命门 ──
  var anchors = [
    "androidx.compose.ui.Modifier",
    "androidx.compose.ui.Modifier$Element",
    "androidx.compose.ui.Modifier$Node",
    "androidx.compose.ui.node.ModifierNodeElement",
    "androidx.compose.ui.node.DrawModifierNode",
    "androidx.compose.ui.node.LayoutModifierNode",
    "androidx.compose.ui.graphics.drawscope.DrawScope",
    "androidx.compose.ui.graphics.drawscope.ContentDrawScope",
    "androidx.compose.ui.graphics.layer.GraphicsLayer",
    "androidx.compose.ui.node.NodeCoordinator",
    "androidx.compose.ui.node.LayoutNode",
    "androidx.compose.ui.platform.AbstractComposeView",
    "androidx.compose.ui.platform.ComposeView",
    "androidx.compose.ui.platform.AndroidComposeView"
  ];
  L("");
  L("[b] 关键类探测（✓=保留真名）：");
  anchors.forEach(function (n) {
    try {
      var k = Java.use(n);
      var fs = k.class.getDeclaredFields().length;
      var ms = k.class.getDeclaredMethods().length;
      var kind = k.class.isInterface() ? "接口" : (k.class.isEnum() ? "枚举" : "类");
      L("    ✓ " + n + "   [" + kind + " 字段" + fs + " 方法" + ms + "]");
    } catch (e) {
      L("    ✗ " + n + "   （被混淆 / 没加载）");
    }
  });

  // ── [c] 从"活的视图实例"往内部摸 ──
  //     AndroidComposeView 是 Compose 挂到 Android View 树上的那个根，
  //     摸到它就能顺着字段找到 Recomposer / LayoutNode / 修饰符链
  L("");
  L("[c] 活实例：androidx.compose.ui.platform.AndroidComposeView");
  var n = 0;
  try {
    Java.choose("androidx.compose.ui.platform.AndroidComposeView", {
      onMatch: function (inst) {
        n++;
        if (n > 2) return;
        try {
          L("    ✓ 实例真实类 = " + inst.getClass().getName());
          var c = inst.getClass();
          var depth = 0;
          while (c && depth < 6) {
            var cn = c.getName();
            if (cn === "java.lang.Object" || cn.indexOf("android.view") === 0) break;
            var fs = c.getDeclaredFields();
            for (var i = 0; i < fs.length; i++) {
              var tn = fs[i].getType().getName();
              L("        ." + cn.split(".").pop() + "." + fs[i].getName() + " : " + tn.split(".").pop());
            }
            c = c.getSuperclass(); depth++;
          }
        } catch (e) { L("        字段读取失败: " + e); }
      },
      onComplete: function () { L("    实例总数 = " + n); }
    });
  } catch (e) {
    L("    ✗ choose 失败（多半是这个类被混淆了）: " + e);
  }

  L("[z] recon2 done");
});
