// member3.js —— 先修 ClassLoader，再对模块所有反射调用做活体审计
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var TARGET = "de.robv.android.xposed.XposedHelpers";

  // ══════════════════════════════════════════════════════════
  // [A] 找能加载 XposedHelpers 的 ClassLoader
  // ══════════════════════════════════════════════════════════
  var loaders = [];
  try { loaders = Java.enumerateClassLoadersSync(); } catch (e) {
    L("[✗] enumerateClassLoadersSync 失败: " + e);
  }
  L("[A] ClassLoader 总数 = " + loaders.length);

  var hit = null, hitIdx = -1;
  for (var i = 0; i < loaders.length; i++) {
    var nm = "(?)";
    try { nm = loaders[i].getClass().getName(); } catch (e) {}
    var ok = false;
    try { ok = !!loaders[i].loadClass(TARGET); } catch (e) {}
    L("    #" + i + "  " + nm + "   " + (ok ? "★ 能加载 XposedHelpers" : ""));
    if (ok && !hit) { hit = loaders[i]; hitIdx = i; }
  }

  if (!hit) {
    L("[!] 没有 loader 能加载 " + TARGET + " —— 放弃");
    L("[z] member3 done");
    return;
  }
  L("[A] 选中 #" + hitIdx + "，切过去");
  Java.classFactory.loader = hit;

  // 验证切换成功
  var X = null;
  try { X = Java.use(TARGET); L("[A] ✓ Java.use(XposedHelpers) 成功"); }
  catch (e) { L("[A] ✗ 切换后仍然失败: " + e); L("[z] member3 done"); return; }

  // ── 顺便确认模块类也能 use 了 ──
  ["com.nidyaber.fuckdsmanger.gm.GmBubble",
   "com.nidyaber.fuckdsmanger.gm.GmUtil",
   "com.nidyaber.fuckdsmanger.gm.GmBubbleCellHook"].forEach(function (n) {
    try { Java.use(n); L("    ✓ 模块类 " + n); }
    catch (e) { L("    ✗ 模块类 " + n); }
  });

  // ══════════════════════════════════════════════════════════
  // [B] 挂 XposedHelpers 的钩子
  // ══════════════════════════════════════════════════════════
  L("");
  L("[B] 挂钩子…");
  var seen = {};
  var fails = [];
  var calls = 0;
  var MAXPRINT = 400;

  var note = function (kind, target, name, ok, extra) {
    var key = kind + "|" + target + "|" + name;
    if (seen[key]) { seen[key]++; return; }
    seen[key] = 1;
    if (Object.keys(seen).length <= MAXPRINT) {
      L("[" + kind + "] " + target + " ." + name + (ok ? "" : "   ✗ " + extra));
    }
    if (!ok) fails.push(kind + " " + target + " ." + name);
  };

  var tgtName = function (a) {
    try {
      if (a === null) return "null";
      if (typeof a === "string") return a;
      if (a.getClass) return a.getClass().getName();
      if (a.getName) return a.getName();
      return String(a);
    } catch (e) { return "?"; }
  };

  var tryHook = function (name, sig, argIdxTarget, argIdxName, kind) {
    try {
      var o = X[name].overload.apply(null, sig);
      o.implementation = function () {
        calls++;
        var t = tgtName(arguments[argIdxTarget]);
        var nm = String(arguments[argIdxName] === null ? "null" : arguments[argIdxName]);
        var args = Array.prototype.slice.call(arguments);
        try {
          var r = o.call.apply(o, [this].concat(args));
          note(kind, t, nm, true);
          return r;
        } catch (e) {
          note(kind, t, nm, false, String(e).slice(0, 90));
          throw e;
        }
      };
      L("    ✓ " + kind);
      return true;
    } catch (e) { L("    ✗ " + kind + " : " + e); return false; }
  };

  tryHook("callMethod",           ['java.lang.Object','java.lang.String','[Ljava.lang.Object;'], 0, 1, "callMethod");
  tryHook("callStaticMethod",     ['java.lang.Class','java.lang.String','[Ljava.lang.Object;'],  0, 1, "callStaticMethod");
  tryHook("getObjectField",       ['java.lang.Object','java.lang.String'],                       0, 1, "getObjectField");
  tryHook("getStaticObjectField", ['java.lang.Class','java.lang.String'],                        0, 1, "getStaticObjectField");
  tryHook("setObjectField",       ['java.lang.Object','java.lang.String','java.lang.Object'],    0, 1, "setObjectField");

  // findClass 单独：它只有类名
  try {
    var fc = X.findClass.overload('java.lang.String','java.lang.ClassLoader');
    var fcSeen = {};
    fc.implementation = function (cls, cl) {
      calls++;
      if (!fcSeen[cls]) { fcSeen[cls] = 1; L("[findClass] " + cls); }
      return fc.call(this, cls, cl);
    };
    L("    ✓ findClass");
  } catch (e) { L("    ✗ findClass : " + e); }

  L("");
  L("[C] 钩子装好 —— 请在宿主里翻一下聊天页，让它跑起来");

  setTimeout(function () {
    L("");
    L("════════ 总结 ════════");
    L("总调用 = " + calls + "   去重 = " + Object.keys(seen).length);
    L("");
    L("════ ✗ 失败 " + fails.length + " 条（要改的成员名）════");
    fails.sort().forEach(function (f) { L("   " + f); });
    L("[z] member3 done");
  }, 8500);
});
