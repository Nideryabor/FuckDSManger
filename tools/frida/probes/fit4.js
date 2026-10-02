// fit4.js —— 回答三个问题（fit3 的修正版）
// 🐲 尼得亚伯 · 2026-10-02
//
// fit3 的教训：Java.use('Lim9') 直接 ClassNotFoundException ——
//   因为 frida 默认用的 classloader 不是宿主 app 的那个。
//   修法：先 use 一个**一定在 app dex 里**的类（jq0），拿它的 classLoader 拨正。
//
// 要回答：
//   ① jq0.b(J) 到底被不被调用？传进来的 size 是多少？
//   ② 我们自己的 GmBubbleFitHook 到底被不被调用？（= 钩子生效了没）
//   ③ ChatMessageCell 有没有在重绘？（确认"画"这件事发生了）
'use strict';

var TAG = '[FIT4]';

function bits2f(i) {
  var dv = new DataView(new ArrayBuffer(4));
  dv.setUint32(0, i >>> 0);
  return dv.getFloat32(0);
}
function unpackSize(v) {
  try {
    if (v !== null && typeof v === 'object' && typeof v.shr === 'function') {
      return bits2f(v.shr(32).and(0xffffffff).toNumber()).toFixed(1) + 'x'
           + bits2f(v.and(0xffffffff).toNumber()).toFixed(1);
    }
    var n = Number(v);
    if (!isFinite(n)) return 'raw=' + v;
    return bits2f(Math.floor(n / 4294967296) % 4294967296).toFixed(1) + 'x'
         + bits2f(n % 4294967296).toFixed(1);
  } catch (e) { return 'raw=' + v; }
}

Java.performNow(function () {
  console.log(TAG + ' 注入 ok · pid=' + Process.id);

  // ① 拨正 classloader（用 jq0 —— 它一定在 app dex 里，fit3 里 use 成功过）
  try {
    var jq0 = Java.use('jq0');
    var L = jq0.classLoader;
    if (L !== null) {
      Java.classFactory.loader = L;
      console.log(TAG + ' ✓ classloader 已拨正（取自 jq0）');
    } else {
      console.log(TAG + ' ⚠ jq0.classLoader 是 null');
    }
  } catch (e) { console.log(TAG + ' ✗ jq0: ' + e); }

  // ② 宿主读 shader 的地方
  try {
    var jq0b = Java.use('jq0');
    jq0b.b.overload('long').implementation = function (size) {
      var r = this.b(size);
      var cls = (r === null) ? 'null' : r.getClass().getName();
      console.log(TAG + ' jq0.b  size=' + unpackSize(size) + '  → ' + cls);
      return r;
    };
    console.log(TAG + ' ✓ hook jq0.b');
  } catch (e) { console.log(TAG + ' ✗ jq0.b: ' + e); }

  // ③ ★★★ 我们自己的 FitHook：它在哪、被调了没
  try {
    var Fit = Java.use('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook');
    var m = Fit.beforeHookedMethod.overload('de.robv.android.xposed.XC_MethodHook$MethodHookParam');
    m.implementation = function (p) {
      console.log(TAG + ' ★★ GmBubbleFitHook 被调用了！');
      return m.call(this, p);
    };
    console.log(TAG + ' ✓ hook 我们自己的 FitHook');
  } catch (e) { console.log(TAG + ' ✗ FitHook: ' + e); }

  // ④ ChatMessageCell（i93.i）—— 确认"画"发生了
  try {
    var i93 = Java.use('i93');
    var C = 0;
    i93.i.overload('int', 'sf6', 'o32', 'ns', 'mr', 'x97', 'yx4', 'int').implementation =
      function (a, b, c, d, e, f, g, h) {
        C++;
        if (C <= 25) {
          var mt = 'null';
          try { if (f !== null) mt = f.getClass().getName(); } catch (x) { }
          console.log(TAG + ' · ChatMessageCell #' + C + '  modifier=' + mt);
        }
        return this.i(a, b, c, d, e, f, g, h);
      };
    console.log(TAG + ' ✓ hook i93.i（ChatMessageCell）');
  } catch (e) { console.log(TAG + ' ✗ i93.i: ' + e); }

  console.log(TAG + ' —— 就绪，请滚动列表触发重绘 ——');
});
