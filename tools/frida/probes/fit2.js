// fit2.js —— 抓「裁剪那一刻到底用了什么值」🐲 2026-10-02
// 专治：AI 图底被截断 / 跑到用户气泡下 / 下半截透明。
// 只 hook 模块自己的类，不碰宿主调用栈（避免上次那种观察者效应）。
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
  try { GB = factory.use('com.nidyaber.fuckdsmanger.gm.GmBubble'); } catch (e) { L('[!] GB: ' + e); }
  try { FH = factory.use('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook'); } catch (e) { L('[!] FH: ' + e); }
  try { XH = factory.use('de.robv.android.xposed.XposedHelpers'); } catch (e) { }
  var dn = function (x) { if (x === null || x === undefined) return 'null'; try { return x.getClass().getName(); } catch (e) { return '?'; } };

  var cnt = 0;
  if (FH !== null) {
    try {
      FH.beforeHookedMethod.implementation = function (p) {
        cnt++;
        var obj = null, d = null, bmp = null, jv = null;
        try { obj = p.thisObject.value; } catch (e) { }
        if (XH !== null && obj !== null) { try { d = XH.getObjectField(obj, 'd'); } catch (e) { } }
        try { var m = GB.sBmpMap.value; if (m !== null && obj !== null) bmp = m.get(obj); } catch (e) { }
        try { jv = p.args.value[0]; } catch (e) { }

        var s = '[Fit#' + cnt + '] this=' + dn(obj) + '  d=' + dn(d);
        s += '  配对=' + (bmp === null ? '✗没配到' : '✓');
        if (bmp !== null) {
          try { s += ' bmp=' + bmp.getWidth() + 'x' + bmp.getHeight(); } catch (e) { }
        }
        if (jv !== null) {
          try { s += '  J=' + jv.toString(); } catch (e) { }
        }
        s += '  sImgName=' + (function () { try { return GB.sImgName.value; } catch (e) { return '?'; } })();
        L(s);
        return this.beforeHookedMethod(p);
      };
      L('[ok] FitHook');
    } catch (e) { L('[!] FitHook hook: ' + e); }
  }

  if (GB !== null) {
    try {
      GB.imgBrush.overload('java.lang.ClassLoader').implementation = function (cl) {
        var n0 = (function () { try { return GB.sImgName.value; } catch (e) { return '?'; } })();
        var r = this.imgBrush(cl);
        var st = 'map=?';
        try {
          var m = GB.sBmpMap.value;
          if (m === null) st = 'map=null';
          else if (r === null) st = 'ret=null';
          else st = (m.get(r) === null ? 'put✗' : 'put✓');
        } catch (e) { st = 'err'; }
        L('[imgBrush] name=' + n0 + ' → ' + dn(r) + '  ' + st);
        return r;
      };
      L('[ok] imgBrush');
    } catch (e) { L('[!] imgBrush: ' + e); }
  }

  L('[挂载完毕] 滚一滚消息列表（让 AI 气泡和用户气泡都出现）');
  setTimeout(function () { L('[fit2 done] 共 ' + cnt + ' 次裁剪'); }, 120000);
});
