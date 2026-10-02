// fit6.js —— 先做【对照实验】：确认 frida 的 Java hook 在这个进程里到底有没有效
// 🐲 尼得亚伯 · 2026-10-02
//
// 背景：fit4/fit5 里三个钩子全部 "✓ 挂上"，但 25 秒内**零调用**（连旋转屏幕都没触发）。
//       两种可能：
//         A. 目标真没被调（那就是宿主走了别的渲染路径）
//         B. frida 的 hook 被 LSPosed 顶掉了（LSPosed 在类加载时替换 ArtMethod，
//            可能覆盖 frida 运行时装的 implementation）⇒ 我的观测是假象
//       ⇒ 必须先用一个【一定会被调用】的方法做对照，才能区分 A / B。
//
// 用法：投 job 后，切一下后台再切回来（触发 onResume）
'use strict';

var TAG = '[FIT6]';

Java.performNow(function () {
  console.log(TAG + ' 注入 ok · pid=' + Process.id);

  // ── ① 对照组：Activity.onResume（系统类，boot classloader；一定会被调）──
  try {
    var Activity = Java.use('android.app.Activity');
    Activity.onResume.implementation = function () {
      console.log(TAG + ' ★对照★ onResume 被拦到 → ' + this.getClass().getName());
      return this.onResume();
    };
    console.log(TAG + ' ✓ hook Activity.onResume（对照）');
  } catch (e) { console.log(TAG + ' ✗ onResume: ' + e); }

  // ── ② 我们模块自己的静态方法：frida 能不能碰到模块类 ──
  (function () {
    try {
      var L = null;
      Java.enumerateClassLoadersSync().forEach(function (l) {
        if (L) return;
        try { l.loadClass('com.nidyaber.fuckdsmanger.gm.GmBubble'); L = l; } catch (e) { }
      });
      var fac = L ? Java.ClassFactory.get(L) : Java.classFactory;
      var GB = fac.use('com.nidyaber.fuckdsmanger.gm.GmBubble');
      GB.wrap.overload('java.lang.ClassLoader', 'java.lang.Object').implementation = function (cl, o) {
        console.log(TAG + ' ★ GmBubble.wrap 被调用！ 宿主对象=' + (o === null ? 'null' : o.getClass().getName()));
        return this.wrap(cl, o);
      };
      console.log(TAG + ' ✓ hook GmBubble.wrap');
    } catch (e) { console.log(TAG + ' ✗ GmBubble.wrap: ' + e); }
  })();

  // ── ③ 我们自己的 FitHook（被 Xposed 驱动的那个回调）──
  (function () {
    try {
      var L = null;
      Java.enumerateClassLoadersSync().forEach(function (l) {
        if (L) return;
        try { l.loadClass('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook'); L = l; } catch (e) { }
      });
      var fac = L ? Java.ClassFactory.get(L) : Java.classFactory;
      var Fit = fac.use('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook');
      var ov = Fit.beforeHookedMethod.overload('de.robv.android.xposed.XC_MethodHook$MethodHookParam');
      ov.implementation = function (p) {
        console.log(TAG + ' ★★ GmBubbleFitHook 被调用了！');
        return ov.call(this, p);
      };
      console.log(TAG + ' ✓ hook GmBubbleFitHook');
    } catch (e) { console.log(TAG + ' ✗ FitHook: ' + e); }
  })();

  // ── ④ 目标：宿主读 shader 的地方 ──
  (function () {
    try {
      var L = null;
      Java.enumerateClassLoadersSync().forEach(function (l) {
        if (L) return;
        try { l.loadClass('jq0'); L = l; } catch (e) { }
      });
      var fac = L ? Java.ClassFactory.get(L) : Java.classFactory;
      var jq0 = fac.use('jq0');
      jq0.b.overload('long').implementation = function (size) {
        var r = this.b(size);
        console.log(TAG + ' jq0.b 被调用 size=' + size + ' → ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
      console.log(TAG + ' ✓ hook jq0.b');
    } catch (e) { console.log(TAG + ' ✗ jq0.b: ' + e); }
  })();

  console.log(TAG + ' —— 就绪：请切一下后台再切回来 ——');
});
