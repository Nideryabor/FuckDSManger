// ub3.js —— 【干净版】：只 hook 模块内部方法，绝不碰宿主调用栈 🐲 2026-10-02
// 教训：ub2 里 hook 了 qk7.D ⇒ 在栈里插帧 ⇒ GmUtil.caller() 数到 qk7.D 自己
//       ⇒ caller 判据 startsWith("ua0.e") 失败 ⇒ ub() 提前返回
//       ⇒ 探针把被测对象搞坏了（观察者效应）。
// 这次只观察 GmBubble.* 这些 com.nidyaber.* 的方法：caller() 本来就会跳过它们。
Java.performNow(function () {
  var L = function (s) { console.log(s); };

  // 找模块 ClassLoader
  var factory = Java.ClassFactory, found = false;
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
  } catch (e) { L('[!] CL: ' + e); }
  if (!found) L('[CL] 没找到');

  var GB = null;
  try { GB = factory.use('com.nidyaber.fuckdsmanger.gm.GmBubble'); }
  catch (e) { L('[!] GmBubble: ' + e); }
  if (GB === null) { L('[ub3 done]'); return; }

  var desc = function (x) {
    if (x === null || x === undefined) return 'null';
    try { return x.getClass ? x.getClass().getName() : String(x); } catch (e) { return '?'; }
  };

  ['ubMod', 'shape', 'hostShape', 'uOn', 'uImgOn', 'useUImgName', 'wrap', 'wrapImg'].forEach(function (nm) {
    try {
      var f = GB[nm];
      if (!f || !f.overloads) { L('[skip] ' + nm); return; }
      f.overloads.forEach(function (ov) {
        ov.implementation = function () {
          var a = Array.prototype.slice.call(arguments);
          var r = ov.apply(this, arguments);
          L('[' + nm + '] (' + a.map(desc).join(', ') + ') → ' + desc(r));
          return r;
        };
      });
      L('[ok] ' + nm);
    } catch (e) { L('[!] ' + nm + ': ' + e); }
  });

  L('[挂载完毕] 请再滚一滚消息列表 / 改改用户气泡颜色');
  setTimeout(function () { L('[ub3 done]'); }, 120000);
});
