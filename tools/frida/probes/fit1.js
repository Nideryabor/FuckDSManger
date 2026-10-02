// fit1.js —— 探「实例→位图」配对到底成没成 🐲 2026-10-02
// 只读：hook 模块自己的 GmBubbleFitHook / GmBubble.imgBrush，不碰宿主调用栈。
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var factory = Java.ClassFactory, found = false;
  try {
    Java.enumerateClassLoadersSync().forEach(function (cl) {
      if (found) return;
      try {
        cl.loadClass('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook');
        factory = Java.ClassFactory.get(cl); found = true;
        L('[CL] ' + cl.getClass().getName());
      } catch (e) { }
    });
  } catch (e) { }
  if (!found) { L('[!] 模块 CL 没找到'); return; }

  var GB = null, FH = null, XH = null;
  try { GB = factory.use('com.nidyaber.fuckdsmanger.gm.GmBubble'); } catch (e) { L('[!] GB ' + e); }
  try { FH = factory.use('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook'); } catch (e) { L('[!] FH ' + e); }
  try { XH = factory.use('de.robv.android.xposed.XposedHelpers'); } catch (e) { }
  var dn = function (x) { if (x === null || x === undefined) return 'null'; try { return x.getClass().getName(); } catch (e) { return '?'; } };

  // ① FitHook 每次触发时，看 d 是什么、map 里有没有自己那张图
  if (FH !== null) {
    try {
      FH.beforeHookedMethod.implementation = function (p) {
        var obj = null, d = null, bmp = null;
        try { obj = p.thisObject.value; } catch (e) { }
        if (XH !== null && obj !== null) { try { d = XH.getObjectField(obj, 'd'); } catch (e) { } }
        try {
          var map = GB.sBmpMap.value;
          if (map !== null && obj !== null) bmp = map.get(obj);
        } catch (e) { }
        L('[Fit] this=' + dn(obj) + ' d=' + dn(d) + ' 配对=' + (bmp === null ? '✗ 没配到' : '✓ ' + dn(bmp)));
        return this.beforeHookedMethod(p);
      };
      L('[ok] FitHook');
    } catch (e) { L('[!] FitHook hook: ' + e); }
  }

  // ② imgBrush 返回的 jq0 进表了吗
  if (GB !== null) {
    try {
      GB.imgBrush.overload('java.lang.ClassLoader').implementation = function (cl) {
        var r = this.imgBrush(cl);
        var hit = 'map=null';
        try {
          var map = GB.sBmpMap.value;
          if (map !== null && r !== null) {
            var v = map.get(r);
            hit = (v === null ? 'put✗（表里没有这个实例）' : 'put✓');
          }
        } catch (e) { hit = 'err ' + e; }
        L('[imgBrush] → ' + dn(r) + '  ' + hit);
        return r;
      };
      L('[ok] imgBrush');
    } catch (e) { L('[!] imgBrush: ' + e); }
  }

  L('[挂载完毕] 请滚一滚消息列表');
  setTimeout(function () { L('[fit1 done]'); }, 120000);
});
