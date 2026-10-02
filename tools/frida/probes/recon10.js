Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var VH = "androidx.compose.ui.viewinterop.AndroidViewHolder";

  var vh = null, n = 0;
  try {
    Java.choose(VH, { onMatch: function (v) { if (n++ === 0) vh = v; }, onComplete: function () {} });
  } catch (e) {}
  if (!vh) { L("[!] 没有活实例"); return; }

  // 沿父类链拿到 Modifier 对象
  var md = null;
  var c = vh.getClass(), dep = 0;
  while (c && dep < 8) {
    var cn = c.getName();
    if (cn === "java.lang.Object" || cn.indexOf("android.view") === 0) break;
    var fs = c.getDeclaredFields();
    for (var i = 0; i < fs.length; i++) {
      if (fs[i].getType().getName() !== "x97") continue;
      try {
        fs[i].setAccessible(true);
        var v = fs[i].get(vh);
        if (v !== null && !md) { md = v; L("[A] 起始 Modifier = " + v.getClass().getName()); }
      } catch (e) {}
    }
    c = c.getSuperclass(); dep++;
  }
  if (!md) { L("[!] 没找到 Modifier"); return; }

  // ── 递归展开修饰符树 ──
  var kinds = {};       // 元素类 → 次数
  var ifaceSet = {};    // 出现过的接口
  var visited = 0;

  var walk = function (m, depth) {
    if (!m || depth > 8 || visited > 60) return;
    visited++;
    var mc;
    try { mc = m.getClass(); } catch (e) { return; }
    var name = mc.getName();
    try {
      var ifs = mc.getInterfaces();
      for (var i = 0; i < ifs.length; i++) ifaceSet[ifs[i].getName()] = (ifaceSet[ifs[i].getName()] || 0) + 1;
    } catch (e) {}

    // 看它的字段里还有没有 x97（说明是"组合"而不是"元素"）
    var children = [];
    try {
      var mfs = mc.getDeclaredFields();
      for (var j = 0; j < mfs.length; j++) {
        if (mfs[j].getType().getName() !== "x97") continue;
        try {
          mfs[j].setAccessible(true);
          var cv = mfs[j].get(m);
          if (cv !== null) children.push(cv);
        } catch (e) {}
      }
    } catch (e) {}

    if (children.length > 0) {
      // 组合节点，继续下钻
      for (var k = 0; k < children.length; k++) walk(children[k], depth + 1);
    } else {
      // 叶子 —— 这就是一个"元素"
      kinds[name] = (kinds[name] || 0) + 1;
    }
  };

  walk(md, 0);

  L("");
  L("[B] 走到的【叶子元素】类（这就是 Modifier.Element 的实现）:");
  var ks = Object.keys(kinds);
  if (ks.length === 0) L("      （一个叶子都没走到）");
  ks.forEach(function (k) { L("    " + kinds[k] + " ×  " + k); });

  L("");
  L("[C] 这些元素实现的接口（找那个 extends x97 的 = Modifier.Element）:");
  Object.keys(ifaceSet).sort().forEach(function (k) {
    var mark = "";
    try {
      var kc = Java.use(k).class;
      if (kc.isInterface()) {
        var sup = kc.getInterfaces();
        var supNames = [];
        for (var q = 0; q < sup.length; q++) supNames.push(sup[q].getName());
        mark = "  [接口" + (supNames.length ? " extends " + supNames.join(",") : "") + "]";
      }
    } catch (e) { mark = "  (?)"; }
    L("    " + ifaceSet[k] + " ×  " + k + mark);
  });

  // ── 挑几个叶子，打方法签名，看谁带 draw ──
  L("");
  L("[D] 叶子元素的方法签名（找带 draw 的）:");
  ks.slice(0, 12).forEach(function (k) {
    try {
      var kc = Java.use(k).class;
      var ms = kc.getDeclaredMethods();
      var sigs = [];
      for (var m = 0; m < ms.length; m++) {
        var p = ms[m].getParameterTypes().map(function (x) { return x.getName(); }).join(",");
        sigs.push(ms[m].getName() + "(" + p + "):" + ms[m].getReturnType().getName());
      }
      L("    " + k + "   →   " + sigs.slice(0, 8).join(" | "));
    } catch (e) { L("    " + k + "   →  (读不到)"); }
  });

  L("");
  L("[z] recon10 done，共走了 " + visited + " 个节点");
});
