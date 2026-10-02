// ub4.js —— 抓「重写那一刻 sImgName 是谁」🐲 2026-10-02
// sImgName 是个全局静态字段，wrap()/saveImage()/imgBrush() 都看它 ⇒ 时序一乱就串图。
// 只读模块字段，不碰宿主调用栈。
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var factory = Java.ClassFactory, found = false;
  try {
    Java.enumerateClassLoadersSync().forEach(function (cl) {
      if (found) return;
      try {
        cl.loadClass('com.nidyaber.fuckdsmanger.gm.GmBubble');
        factory = Java.ClassFactory.get(cl); found = true;
      } catch (e) { }
    });
  } catch (e) { }
  if (!found) { L('[!] 模块 CL 没找到'); return; }

  var GB = null;
  try { GB = factory.use('com.nidyaber.fuckdsmanger.gm.GmBubble'); }
  catch (e) { L('[!] ' + e); return; }

  var name = function () { try { return GB.sImgName.value; } catch (e) { return '?'; } };
  var bool_ = function (f) { try { return GB[f](); } catch (e) { return '?'; } };

  try {
    GB.ubMod.overload('java.lang.ClassLoader', 'java.lang.Object').implementation = function (cl, shape) {
      L('[ubMod] 进 name=' + name() + ' uImgOn=' + bool_('uImgOn') + ' imgOn=' + bool_('imgOn'));
      var r = this.ubMod(cl, shape);
      L('[ubMod] 出 name=' + name() + ' ret=' + (r === null ? 'null' : r.getClass().getName()));
      return r;
    };
    L('[ok] ubMod');
  } catch (e) { L('[!] ubMod: ' + e); }

  try {
    GB.useUImgName.implementation = function () {
      var r = this.useUImgName();
      L('[useUImgName] → name=' + name());
      return r;
    };
    L('[ok] useUImgName');
  } catch (e) { L('[!] useUImgName: ' + e); }

  try {
    GB.imgBrush.overload('java.lang.ClassLoader').implementation = function (cl) {
      var n0 = name();
      var r = this.imgBrush(cl);
      L('[imgBrush] 用 name=' + n0 + ' → ' + (r === null ? 'null' : r.getClass().getName()));
      return r;
    };
    L('[ok] imgBrush');
  } catch (e) { L('[!] imgBrush: ' + e); }

  L('[挂载完毕] 请滚一滚 + 开关一下用户气泡图片底');
  setTimeout(function () { L('[ub4 done]'); }, 110000);
});
