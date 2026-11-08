// res_notint4.js —— 精准剥离 tint（低开销版，上一版把宿主搞崩了）🐲 2026-11-07
//
// ⚠️ 上一版崩溃的原因（教训）：
//   `do1.q` 是**绘制热路径**，一次界面刷新就被调上万次。
//   我在回调里每次都做 `getClass().getDeclaredField('a')` + `fld.get()`
//   ⇒ 反射几十万次 ⇒ 宿主直接 OOM/超时 ⇒ Process terminated。
//   **热路径里绝不能做反射**（这条要记进教训）。
//
// 这一版的优化：
//   s27.E 里把 **rf 对象本身**（不是 Bitmap）存进 JS 变量。
//   do1.q 里只做 `ib === ourRf` —— 纯 JS 指针比较，零 Java 调用、零反射。
'use strict';

var TAG = '[NOTINT4]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

var ourRfs = [];       // ★ 存 rf 对象本身（不是 Bitmap）—— 比对零开销
function hx(i) { return '0x' + (i >>> 0).toString(16); }

Java.performNow(function () {
  var pkg = null, res = null, tid = 0, TW = 0, TH = 0;
  try {
    var AT = Java.use('android.app.ActivityThread');
    var app = AT.currentApplication();
    pkg = app.getPackageName();
    res = app.getResources();
    tid = res.getIdentifier(TARGET, 'drawable', pkg) >>> 0;
    var o = res.getDrawable(tid, null);
    TW = o.getIntrinsicWidth();
    TH = o.getIntrinsicHeight();
    P('pkg=' + pkg + ' target=' + hx(tid) + ' 原尺寸=' + TW + 'x' + TH);
  } catch (e) { P('init: ' + e); }

  var Bitmap = Java.use('android.graphics.Bitmap');
  var Canvas = Java.use('android.graphics.Canvas');
  var Paint = Java.use('android.graphics.Paint');
  var Cfg = Java.use('android.graphics.Bitmap$Config');
  var rfCls = Java.use('rf');
  var vo0Cls = Java.use('vo0');

  function makeBitmap(w, h) {
    var b = Bitmap.createBitmap(w, h, Cfg.ARGB_8888.value);
    var c = Canvas.$new(b);
    var p = Paint.$new();
    p.setColor(-65536);
    c.drawCircle(w / 2, h / 2, Math.min(w, h) / 3, p);
    p.setColor(-16711936);
    c.drawRect(w * 0.05, h * 0.05, w * 0.3, h * 0.3, p);
    return b;
  }

  // ── ① s27.E：换成我们的 BitmapPainter，记住 rf 对象 ──────────
  var hits = 0;
  try {
    var s27 = Java.use('s27');
    var E = s27.E.overload('int', 'int', 'v15');
    E.implementation = function (id, density, composer) {
      var orig = E.call(this, id, density, composer);
      try {
        if ((id >>> 0) !== tid || hits >= 6) return orig;
        hits++;
        var w = TW > 0 ? TW : 70, h = TH > 0 ? TH : 70;
        var rfObj = rfCls.$new(makeBitmap(w, h));
        ourRfs.push(rfObj);                    // ★ 存 rf 对象
        return vo0Cls.$new(rfObj);
      } catch (e) { return orig; }
    };
    P('✔ s27.E');
  } catch (e) { P('✘ s27.E: ' + e); }

  // ── ② do1.q：纯引用比对，剥 tint ────────────────────────────
  var nQ = 0, nOurs = 0, nStrip = 0;
  try {
    var do1 = Java.use('do1');
    var Q = do1.q.overload('ck5', 'long', 'long', 'long', 'long',
                           'float', 'gp0', 'int', 'int');
    Q.implementation = function (ib, j1, j2, j3, j4, f1, filter, i1, i2) {
      nQ++;
      // ★ 纯 JS 指针比较，不做任何 Java 调用
      var mine = false;
      for (var i = 0; i < ourRfs.length; i++) {
        if (ourRfs[i] === ib) { mine = true; break; }
      }
      if (mine) {
        nOurs++;
        if (filter !== null) {
          nStrip++;
          if (nStrip <= 3) P('  ⟳ 剥离 tint #' + nStrip);
          return Q.call(this, ib, j1, j2, j3, j4, f1, null, i1, i2);
        }
      }
      return Q.call(this, ib, j1, j2, j3, j4, f1, filter, i1, i2);
    };
    P('✔ do1.q（纯引用比对）');
  } catch (e) { P('✘ do1.q: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('换图=' + hits + ' drawImage(q)=' + nQ + ' 我们图被画=' + nOurs + ' 剥离tint=' + nStrip);
    P('==== 完 ====');
  }, 30000);
});
