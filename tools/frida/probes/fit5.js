// fit5.js —— 修 fit4 的两个错，继续回答「AI 气泡图底 下半空白」
// 🐲 尼得亚伯 · 2026-10-02
//
// fit4 的教训：
//   `Java.classFactory.loader = L` 之后，`Java.use()` 反而报
//   "TypeError: cannot read property '$h' of undefined" —— 全局 loader 改坏了后续 use。
//   ⇒ 正确姿势：`Java.ClassFactory.get(L).use(...)`，每个类用对的 factory。
//
// ⚠️ 另一个更重要的前提：**宿主必须在【前台】**（后台 App 不重绘 ⇒ 钩子抓不到东西）
'use strict';

var TAG = '[FIT5]';

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

// 找出哪个 classloader 能 load 到这个类
function loaderFor(name) {
  var found = null;
  try {
    Java.enumerateClassLoadersSync().forEach(function (l) {
      if (found) return;
      try { l.loadClass(name); found = l; } catch (e) { }
    });
  } catch (e) { }
  return found;
}

Java.performNow(function () {
  console.log(TAG + ' 注入 ok · pid=' + Process.id);

  // ── 拿到 app 的 factory ────────────────────────────────────────────
  var fac = null;
  try {
    var L = loaderFor('jq0');
    if (L !== null) { fac = Java.ClassFactory.get(L); console.log(TAG + ' ✓ 拿到 jq0 的 classloader'); }
    else { fac = Java.ClassFactory.get(Java.classFactory.loader); console.log(TAG + ' ⚠ 没找到 jq0 的 loader，退回默认'); }
  } catch (e) {
    console.log(TAG + ' ✗ 找 loader: ' + e);
    fac = Java.classFactory;
  }

  // ── ① 宿主读 shader 的地方 ─────────────────────────────────────────
  try {
    var jq0 = fac.use('jq0');
    jq0.b.overload('long').implementation = function (size) {
      var r = this.b(size);
      var cls = (r === null) ? 'null' : r.getClass().getName();
      console.log(TAG + ' jq0.b  size=' + unpackSize(size) + '  → ' + cls);
      return r;
    };
    console.log(TAG + ' ✓ hook jq0.b');
  } catch (e) { console.log(TAG + ' ✗ jq0.b: ' + e); }

  // ── ② 我们自己的 FitHook：到底被调了没 ─────────────────────────────
  (function () {
    try {
      var FL = loaderFor('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook');
      var f2 = (FL !== null) ? Java.ClassFactory.get(FL) : fac;
      var Fit = f2.use('com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook');
      var ov = Fit.beforeHookedMethod.overload('de.robv.android.xposed.XC_MethodHook$MethodHookParam');
      ov.implementation = function (p) {
        console.log(TAG + ' ★★ 我们的 GmBubbleFitHook 被调用了！');
        return ov.call(this, p);
      };
      console.log(TAG + ' ✓ hook 我们自己的 FitHook');
    } catch (e) { console.log(TAG + ' ✗ FitHook: ' + e); }
  })();

  // ── ③ ChatMessageCell 重绘（确认"画"发生了）───────────────────────
  (function () {
    try {
      var i93 = fac.use('i93');
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
  })();

  console.log(TAG + ' —— 就绪（宿主必须在前台 + 正在聊天页）——');
});
