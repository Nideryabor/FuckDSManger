// member6.js —— 收集窗口拉到 80 秒，配合网关 timeout=90
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var T0 = Date.now();
  var el = function () { return ((Date.now() - T0) / 1000).toFixed(1) + "s"; };
  var TARGET = "de.robv.android.xposed.XposedHelpers";

  // ── [A] 切到 LSPosed 的 ClassLoader ──
  var hit = null;
  try {
    var ls = Java.enumerateClassLoadersSync();
    for (var i = 0; i < ls.length; i++) {
      try { if (ls[i].loadClass(TARGET)) { hit = ls[i]; break; } } catch (e) {}
    }
  } catch (e) {}
  if (!hit) { L("[" + el() + "] ✗ 没找到 loader"); L("[z] done"); return; }
  Java.classFactory.loader = hit;
  var X = null;
  try { X = Java.use(TARGET); } catch (e) { L("[" + el() + "] ✗ " + e); L("[z] done"); return; }
  L("[" + el() + "] ✓ XposedHelpers 可用");

  // ── [B] 挂钩子 ──
  var seen = {}, fails = {}, calls = 0;
  var note = function (kind, target, name, ok, extra) {
    var key = kind + "|" + target + "|" + name;
    if (seen[key]) { seen[key]++; return; }
    seen[key] = 1;
    L("[" + el() + "][" + kind + "] " + target + " ." + name + (ok ? "" : "   ✗ " + extra));
    if (!ok) fails[key] = kind + " " + target + " ." + name;
  };
  var tn = function (a) {
    try {
      if (a === null || a === undefined) return "null";
      if (typeof a === "string") return a;
      if (a.getClass) return a.getClass().getName();
      if (a.getName) return a.getName();
      return String(a);
    } catch (e) { return "?"; }
  };
  var H = function (name, ov, aT, aN, kind) {
    try {
      var o = X[name].overload.apply(X[name], ov);
      o.implementation = function () {
        calls++;
        var tt = tn(arguments[aT]);
        var nm = String(arguments[aN]);
        var a = Array.prototype.slice.call(arguments);
        try { var r = o.call.apply(o, [this].concat(a)); note(kind, tt, nm, true); return r; }
        catch (e) { note(kind, tt, nm, false, String(e).slice(0, 80)); throw e; }
      };
    } catch (e) { L("[" + el() + "] ✗ " + kind + " : " + String(e).slice(0, 70)); }
  };
  H("callMethod",           ['java.lang.Object','java.lang.String','[Ljava.lang.Object;'], 0, 1, "callMethod");
  H("callStaticMethod",     ['java.lang.Class','java.lang.String','[Ljava.lang.Object;'],  0, 1, "callStaticMethod");
  H("getObjectField",       ['java.lang.Object','java.lang.String'],                       0, 1, "getObjectField");
  H("getStaticObjectField", ['java.lang.Class','java.lang.String'],                        0, 1, "getStaticObjectField");
  H("setObjectField",       ['java.lang.Object','java.lang.String','java.lang.Object'],    0, 1, "setObjectField");
  try {
    var fc = X.findClass.overload('java.lang.String','java.lang.ClassLoader');
    var fcS = {};
    fc.implementation = function (cls, cl) {
      calls++;
      if (!fcS[cls]) { fcS[cls] = 1; L("[" + el() + "][findClass] " + cls); }
      return fc.call(this, cls, cl);
    };
  } catch (e) {}

  L("");
  L("[网关] 钩子装好了（" + el() + "）—— ★现在请打开 DeepSeek 翻聊天★");

  // 80 秒后总结（网关 timeout=90 给足余量）
  setTimeout(function () {
    L("");
    L("════════ [" + el() + "] 总结 ════════");
    L("总调用 = " + calls + "   去重 = " + Object.keys(seen).length);
    var fk = Object.keys(fails);
    L("");
    L("════ ✗ 失败 " + fk.length + " 条（要改的成员名）════");
    fk.sort().forEach(function (k) { L("   " + fails[k]); });
    L("[z] member6 done");
  }, 80000);
});
