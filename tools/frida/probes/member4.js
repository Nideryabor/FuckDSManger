// member4.js —— 修掉 overload.apply(null) 那个坑 + 交叉验证反推的成员名
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var TARGET = "de.robv.android.xposed.XposedHelpers";

  // ── [A] 找 LSPosed 的 ClassLoader 并切过去 ──
  var loaders = [];
  try { loaders = Java.enumerateClassLoadersSync(); } catch (e) {}
  var hit = null;
  for (var i = 0; i < loaders.length; i++) {
    try { if (loaders[i].loadClass(TARGET)) { hit = loaders[i]; break; } } catch (e) {}
  }
  if (!hit) { L("[!] 没有 loader 能加载 " + TARGET); L("[z] done"); return; }
  var hn = "?";
  try { hn = hit.getClass().getName(); } catch (e) {}
  L("[A] ClassLoader 共 " + loaders.length + " 个；选中 " + hn);
  Java.classFactory.loader = hit;

  var X = null;
  try { X = Java.use(TARGET); L("[A] ✓ XposedHelpers 可用"); }
  catch (e) { L("[A] ✗ " + e); L("[z] done"); return; }

  // ── [B] 挂钩子（这次显式 overload）──
  L("");
  L("[B] 挂钩子");
  var seen = {}, fails = {}, calls = 0, printed = 0;

  var note = function (kind, target, name, ok, extra) {
    var key = kind + "|" + target + "|" + name;
    if (seen[key]) { seen[key]++; return; }
    seen[key] = 1;
    if (printed < 250) {
      printed++;
      L("[" + kind + "] " + target + " ." + name + (ok ? "" : "   ✗ " + extra));
    }
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

  var H = function (name, overloadArgs, argT, argN, kind) {
    try {
      var o = X[name].overload.apply(X[name], overloadArgs);   // ★ this 必须是 X[name]
      o.implementation = function () {
        calls++;
        var t = tn(arguments[argT]);
        var nm = String(arguments[argN]);
        var a = Array.prototype.slice.call(arguments);
        try {
          var r = o.call.apply(o, [this].concat(a));
          note(kind, t, nm, true);
          return r;
        } catch (e) {
          note(kind, t, nm, false, String(e).slice(0, 80));
          throw e;
        }
      };
      L("    ✓ " + kind);
    } catch (e) { L("    ✗ " + kind + " : " + String(e).slice(0, 90)); }
  };

  H("callMethod",           ['java.lang.Object','java.lang.String','[Ljava.lang.Object;'], 0, 1, "callMethod");
  H("callStaticMethod",     ['java.lang.Class','java.lang.String','[Ljava.lang.Object;'],  0, 1, "callStaticMethod");
  H("getObjectField",       ['java.lang.Object','java.lang.String'],                       0, 1, "getObjectField");
  H("getStaticObjectField", ['java.lang.Class','java.lang.String'],                        0, 1, "getStaticObjectField");
  H("setObjectField",       ['java.lang.Object','java.lang.String','java.lang.Object'],    0, 1, "setObjectField");

  try {
    var fc = X.findClass.overload('java.lang.String','java.lang.ClassLoader');
    var fcS = {};
    fc.implementation = function (cls, cl) { calls++; if (!fcS[cls]) { fcS[cls] = 1; if (printed++ < 250) L("[findClass] " + cls); } return fc.call(this, cls, cl); };
    L("    ✓ findClass");
  } catch (e) { L("    ✗ findClass : " + String(e).slice(0, 90)); }

  L("");
  L("[C] 装好了 —— 请在宿主里翻一下聊天页");

  setTimeout(function () {
    L("");
    L("════════ 总结 ════════");
    L("总调用 = " + calls + "   去重 = " + Object.keys(seen).length);
    L("");
    var fk = Object.keys(fails);
    L("════ ✗ 失败 " + fk.length + " 条（这些就是必须改的成员名）════");
    fk.sort().forEach(function (k) { L("   " + fails[k]); });
    L("[z] member4 done");
  }, 8000);
});
