// member2.js —— 侦察版：先搞清楚 XposedHelpers 在哪，再决定怎么挂
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var step = function (name, fn) {
    try { return fn(); }
    catch (e) { L("[✗ " + name + "] " + e); return null; }
  };

  // ── [0] 模块类 ──
  var all = step("enumLoaded", function () { return Java.enumerateLoadedClassesSync(); }) || [];
  var modCls = all.filter(function (c) {
    return c.indexOf("fuckdsmanger") >= 0 || c.indexOf("disable_flag_secure") >= 0;
  });
  L("[0] 模块类 = " + modCls.length + " 个");
  modCls.sort().slice(0, 60).forEach(function (c) { L("      " + c); });
  if (modCls.length > 60) L("      …（还有 " + (modCls.length - 60) + " 个）");

  // ── [1] XposedHelpers 在哪？──
  L("");
  L("[1] 找 Xposed 相关的类");
  var xp = all.filter(function (c) {
    return c.indexOf("xposed") >= 0 || c.indexOf("Xposed") >= 0 || c.indexOf("XposedBridge") >= 0;
  });
  L("    含 xposed 字样的类 = " + xp.length + " 个");
  xp.sort().slice(0, 25).forEach(function (c) { L("      " + c); });

  // ── [2] 到底能不能 Java.use ──
  L("");
  L("[2] 逐个试 Java.use");
  ["de.robv.android.xposed.XposedHelpers",
   "de.robv.android.xposed.XposedBridge",
   "de.robv.android.xposed.XC_MethodHook"].forEach(function (n) {
    var k = step("use " + n, function () { return Java.use(n); });
    L("    " + (k ? "✓" : "✗") + " " + n);
  });

  // ── [3] 模块自己的关键类能不能 use（换个方向：直接挂模块的类）──
  L("");
  L("[3] 模块自己类的可挂载性");
  ["com.nidyaber.fuckdsmanger.gm.GmBubble",
   "com.nidyaber.fuckdsmanger.gm.GmStore",
   "com.nidyaber.fuckdsmanger.gm.GmEntryHook",
   "com.nidyaber.fuckdsmanger.gm.GmProbe",
   "com.nidyaber.fuckdsmanger.gm.GmUtil"].forEach(function (n) {
    var k = step("use " + n, function () { return Java.use(n); });
    if (!k) { L("    ✗ " + n); return; }
    var ms = "";
    try { ms = k.class.getDeclaredMethods().length + " 方法"; } catch (e) { ms = ms + e; }
    L("    ✓ " + n + "  (" + ms + ")");
  });

  L("");
  L("[z] member2 done");
});
