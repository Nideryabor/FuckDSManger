Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var X97 = "x97";

  // ══════════════════════════════════════════════════════════
  // [A] 能力验证：能不能【运行时实现】那个被混淆的 Modifier？
  //     —— 这是整个"玻璃计划"的关键一枪
  // ══════════════════════════════════════════════════════════
  L("############ [A] Java.registerClass 实现 x97（Modifier）");
  var MyMod = null;
  try {
    var X = Java.use(X97);
    L("    x97.isInterface = " + X.class.isInterface());
    MyMod = Java.registerClass({
      name: "com.nidyaber.glass.ProbeModifier",
      implements: [X],
      methods: {
        g0: function (initial, operation) { return initial; },   // fold：先原样返回
        x:  function (other) { return other; },                  // then：先返回对方
        N:  function (pred) { return false; }                    // any：先返回 false
      }
    });
    L("    ✓ registerClass 成功 → " + MyMod.class.getName());
  } catch (e) {
    L("    ✗ registerClass 失败: " + e);
  }

  if (MyMod) {
    try {
      var inst = MyMod.$new();
      L("    ✓ 实例化成功 → " + inst.getClass().getName());
    } catch (e) { L("    ✗ 实例化失败: " + e); }
    try {
      var Xc = Java.use(X97).class;
      L("    ✓ instanceof Modifier = " + Xc.isInstance(inst));
    } catch (e) { L("    ? isInstance 检查失败: " + e); }
    try {
      var r = inst.x(inst);
      L("    ✓ 调 then() 成功，返回 " + (r ? r.getClass().getName() : "null"));
    } catch (e) { L("    ✗ 调 then() 失败: " + e); }
    try {
      L("    ✓ 调 N() 成功，返回 " + inst.N(null));
    } catch (e) { L("    ✗ 调 N() 失败: " + e); }
  }

  // ══════════════════════════════════════════════════════════
  // [B] 看真实的 Modifier 长什么样 —— 【不装钩子】，只找活对象
  // ══════════════════════════════════════════════════════════
  L("");
  L("############ [B] 活的 AndroidViewHolder.getModifier()");
  var n = 0;
  try {
    Java.choose("androidx.compose.ui.viewinterop.AndroidViewHolder", {
      onMatch: function (vh) {
        n++;
        if (n > 3) return;
        try {
          var md = vh.getModifier();
          if (md === null) { L("    #" + n + " getModifier() = null"); return; }
          L("    #" + n + " Modifier 实际类 = " + md.getClass().getName());
          var ifs = md.getClass().getInterfaces();
          for (var i = 0; i < ifs.length; i++) L("         implements " + ifs[i].getName());
        } catch (e) { L("    #" + n + " 读取失败: " + e); }
      },
      onComplete: function () { L("    活的 AndroidViewHolder 数 = " + n); }
    });
  } catch (e) { L("    没有活实例（宿主没用 AndroidView）: " + e); }

  L("");
  L("[z] recon6 done");
});
