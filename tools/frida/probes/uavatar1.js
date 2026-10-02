// uavatar1.js —— 直接问：「GmUAvatarHook 到底钩了谁」
Java.performNow(function () {
  var L = function (s) { console.log(s); };

  // ── ① 找【模块】所在的 ClassLoader（跟 XposedHelpers 未必同一个）──
  var MOD = "com.nidyaber.fuckdsmanger.gm.GmUAvatarHook";
  var modLoader = null;
  try {
    var ls = Java.enumerateClassLoadersSync();
    for (var i = 0; i < ls.length; i++) {
      try { if (ls[i].loadClass(MOD)) { modLoader = ls[i]; break; } } catch (e) {}
    }
  } catch (e) {}
  if (!modLoader) {
    // 退一步：逐层列出哪个 loader 能加载模块类
    L("[!] 没有 loader 能加载 " + MOD + " —— 列出各 loader 试：");
    try {
      var l2 = Java.enumerateClassLoadersSync();
      for (var j = 0; j < l2.length; j++) {
        var ok = false;
        try { ok = !!l2[j].loadClass("com.nidyaber.fuckdsmanger.gm.GmUtil"); } catch (e) {}
        if (ok) { L("    #" + j + " 可以加载模块类"); modLoader = l2[j]; break; }
      }
    } catch (e) {}
  }
  if (!modLoader) { L("[!] 放弃"); L("[z] done"); return; }
  Java.classFactory.loader = modLoader;
  L("[A] 找到模块的 ClassLoader ✓");

  // ── ② 钩 GmUAvatarHook.beforeHookedMethod：把「钩了谁」全打出来 ──
  var hits = 0;
  try {
    var K = Java.use(MOD);
    var HM = K.beforeHookedMethod;
    HM.implementation = function (param) {
      hits++;
      var info = "?";
      var ret = "?";
      var decl = "?";
      var mname = "?";
      var tobj = "?";
      try { tobj = param.thisObject ? param.thisObject.getClass().getName() : "null"; } catch (e) {}
      try {
        var m = param.method.value;   // ★Frida 要取 .value
        mname = m.getName();
        decl = m.getDeclaringClass().getName();
        var ps = m.getParameterTypes().map(function (x) { return x.getName(); }).join(",");
        ret = m.getReturnType().getName();
        info = decl + "#" + mname + "(" + ps + ") : " + ret;
      } catch (e) { info = "读 method 失败: " + e; }

      L("");
      L("★★★ GmUAvatarHook 被触发 #" + hits);
      L("    钩住的方法 = " + info);
      L("    thisObject  = " + tobj);

      // 再看字段 "a"
      var fa = "读不到";
      try {
        if (param.thisObject) {
          var v = Java.use("de.robv.android.xposed.XposedHelpers");
          fa = "" + v.getIntField(param.thisObject, "a");
        }
      } catch (e) { fa = "异常: " + String(e).slice(0, 60); }
      L("    getIntField(\"a\") = " + fa);

      // 放行原逻辑
      var r = HM.call(this, param);
      try {
        var res = param.getResult();
        L("    setResult 后返回值 = " + (res === null ? "null" :
            (typeof res === "string" ? ("String(\"" + res + "\")") : res.getClass().getName())));
      } catch (e) {}
      return r;
    };
    L("[B] ✓ GmUAvatarHook.beforeHookedMethod 已挂钩");
  } catch (e) {
    L("[B] ✗ 挂不上: " + e);
  }

  // ── ③ 顺便钩 GmUtil.toast，抓吐司那一刻的栈 ──
  try {
    var U = Java.use("com.nidyaber.fuckdsmanger.gm.GmUtil");
    U.toast.overload('android.content.Context', 'java.lang.String').implementation = function (c, s) {
      L("");
      L("★ 吐司！ 内容 = " + s);
      try {
        var st = Java.use("android.util.Log").getStackTraceString(Java.use("java.lang.Throwable").$new());
        L("  栈：");
        st.split("\n").slice(0, 12).forEach(function (l) { if (l.trim()) L("    " + l.trim()); });
      } catch (e) {}
      return U.toast.overload('android.content.Context', 'java.lang.String').call(this, c, s);
    };
    L("[C] ✓ GmUtil.toast 已挂钩");
  } catch (e) { L("[C] ✗ " + e); }

  L("");
  L("[👉] 现在请在宿主里【上传一次图片】，让吐司弹出来");
  setTimeout(function () { L(""); L("[z] uavatar1 done（触发 " + hits + " 次）"); }, 70000);
});
