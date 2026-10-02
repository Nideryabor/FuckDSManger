// ub2.js —— 用户气泡「定点重写」深度探测 🐲 2026-10-02
// 相比 ub1：先遍历 ClassLoader 定位【模块自己的】ClassLoader（LSPosed 的 InMemoryDex），
// 否则 GmBubble / GmUtil 根本 use 不到。只读，不改任何返回值。
Java.performNow(function () {
  var L = function (s) { console.log(s); };

  // ① 找模块 ClassLoader
  var factory = Java.ClassFactory;
  var found = false;
  try {
    Java.enumerateClassLoadersSync().forEach(function (cl) {
      if (found) return;
      try {
        cl.loadClass('com.nidyaber.fuckdsmanger.gm.GmBubble');
        factory = Java.ClassFactory.get(cl);
        found = true;
        L('[CL] 模块 ClassLoader = ' + cl.getClass().getName());
      } catch (e) { }
    });
  } catch (e) { L('[!] 遍历 ClassLoader: ' + e); }
  if (!found) L('[CL] 没找到模块 ClassLoader');

  var GmBubble = null, GmUtil = null;
  try { GmBubble = factory.use('com.nidyaber.fuckdsmanger.gm.GmBubble'); }
  catch (e) { L('[!] GmBubble: ' + e); }
  try { GmUtil = factory.use('com.nidyaber.fuckdsmanger.gm.GmUtil'); }
  catch (e) { L('[!] GmUtil: ' + e); }

  if (GmBubble !== null) {
    try {
      GmBubble.ubMod.overload('java.lang.ClassLoader', 'java.lang.Object').implementation = function (cl, shape) {
        L('[ubMod] 进入 shape=' + (shape === null ? 'null' : shape.getClass().getName()));
        var r = this.ubMod(cl, shape);
        L('[ubMod] 返回 ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
      L('[ok] ubMod');
    } catch (e) { L('[!] ubMod: ' + e); }

    try {
      GmBubble.shape.overload('java.lang.ClassLoader').implementation = function (cl) {
        var r = this.shape(cl);
        L('[shape] = ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
      L('[ok] shape');
    } catch (e) { L('[!] shape: ' + e); }

    try {
      GmBubble.hostShape.overload('java.lang.ClassLoader').implementation = function (cl) {
        var r = this.hostShape(cl);
        L('[hostShape] = ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
      L('[ok] hostShape');
    } catch (e) { L('[!] hostShape: ' + e); }

    try {
      GmBubble.imgBrush.overload('java.lang.ClassLoader').implementation = function (cl) {
        var r = this.imgBrush(cl);
        L('[imgBrush] = ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
      L('[ok] imgBrush');
    } catch (e) { L('[!] imgBrush: ' + e); }
  }

  // ② 宿主侧 qk7.D / qk7.C
  try {
    var qk7 = Java.use('qk7');
    ['D', 'C'].forEach(function (nm) {
      try {
        qk7[nm].overloads.forEach(function (ov) {
          ov.implementation = function () {
            var a = Array.prototype.slice.call(arguments);
            L('[qk7.' + nm + '] n=' + a.length + '  ' + a.map(function (x) {
              return x === null ? 'null' : (x.getClass ? x.getClass().getName() : String(x));
            }).join(' | '));
            return ov.apply(this, arguments);
          };
        });
        L('[ok] qk7.' + nm);
      } catch (e) { L('[!] qk7.' + nm + ': ' + e); }
    });
  } catch (e) { L('[!] qk7: ' + e); }

  // ③ caller 限次
  if (GmUtil !== null) {
    try {
      var n = 0;
      GmUtil.caller.implementation = function () {
        var r = this.caller();
        if (n < 60) { n++; L('[caller] ' + r); }
        return r;
      };
      L('[ok] caller');
    } catch (e) { L('[!] caller: ' + e); }
  }

  L('[挂载完毕] 现在请操作手机：滚一滚消息列表、改用户气泡颜色');
  setTimeout(function () { L('[ub2 done]'); }, 130000);
});
