// member1.js —— 活体成员名审计
// 思路：模块所有反射都走 XposedHelpers ⇒ hook 它，记录
//       (真实对象的类 → 要调的成员名 → 成功/失败)
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var XH = "de.robv.android.xposed.XposedHelpers";
  var seen = {};
  var fails = [];
  var calls = 0;

  // ── 先确认模块在不在这个进程里 ──
  var all = Java.enumerateLoadedClassesSync();
  var modCls = all.filter(function (c) {
    return c.indexOf("disable_flag_secure") >= 0 || c.indexOf("fuckdsmanger") >= 0;
  });
  L("[0] 模块类在宿主里 = " + modCls.length + " 个");
  modCls.slice(0, 10).forEach(function (c) { L("      " + c); });

  var note = function (kind, target, name, ok, extra) {
    var key = kind + "|" + target + "|" + name;
    if (seen[key]) { seen[key]++; return; }
    seen[key] = 1;
    L("[" + kind + "] " + target + " ." + name + (ok ? "" : "   ✗ " + extra));
    if (!ok) fails.push(kind + " " + target + " ." + name + " → " + extra);
  };

  var X = Java.use(XH);
  L("[1] 挂 XposedHelpers 的钩子…");

  var hook1 = function (name, sig, kindS) {          // 单参探针用不上，这里只做双参
    try {
      var o = X[name].overload.apply(null, sig);
      o.implementation = function (a, b) {
        calls++;
        var t = (a && a.getClass) ? a.getClass().getName()
              : (a && a.getName)  ? a.getName()
              : String(a);
        try {
          var r = o.call(this, a, b);
          note(kindS, t, b, true);
          return r;
        } catch (e) {
          note(kindS, t, b, false, String(e).slice(0, 100));
          throw e;
        }
      };
      return true;
    } catch (e) { L("[!] " + name + " 挂不上: " + e); return false; }
  };

  // findClass(String, ClassLoader) —— 用第二个参数位置当"成员名"没意义，单独处理
  try {
    var fc = X.findClass.overload('java.lang.String', 'java.lang.ClassLoader');
    var fcSeen = {};
    fc.implementation = function (cls, cl) {
      calls++;
      if (!fcSeen[cls]) {
        fcSeen[cls] = 1;
        L("[findClass] " + cls + (cl ? "" : " (cl=null)"));
      }
      try {
        return fc.call(this, cls, cl);
      } catch (e) {
        L("  ✗ findClass 失败: " + cls);
        throw e;
      }
    };
  } catch (e) { L("[!] findClass 挂不上: " + e); }

  hook1("callMethod",           ['java.lang.Object', 'java.lang.String', '[Ljava.lang.Object;'], "callMethod");
  hook1("getObjectField",       ['java.lang.Object', 'java.lang.String'],                        "getObjectField");
  hook1("callStaticMethod",     ['java.lang.Class',  'java.lang.String', '[Ljava.lang.Object;'], "callStaticMethod");
  hook1("getStaticObjectField", ['java.lang.Class',  'java.lang.String'],                        "getStaticObjectField");
  hook1("setObjectField",       ['java.lang.Object', 'java.lang.String', 'java.lang.Object'],    "setObjectField");

  L("[2] 钩子装好了 —— 请在宿主里【打开一个聊天页】让它跑起来");

  setTimeout(function () {
    L("");
    L("════════ 总结 ════════");
    L("总调用次数 = " + calls);
    var ks = Object.keys(seen);
    L("去重后 " + ks.length + " 条：");
    ks.sort().forEach(function (k) {
      var p = k.split("|");
      L("   " + (seen[k] > 1 ? seen[k] + "× " : "    ") + p[0] + "  " + p[1] + " ." + p[2]);
    });
    L("");
    L("════ ✗ 失败 " + fails.length + " 条（这些就是必须改的成员名）════");
    fails.sort().forEach(function (f) { L("   " + f); });
    L("[z] member1 done");
  }, 9000);
});
