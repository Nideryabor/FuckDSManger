// res_notint5.js —— 抓到真正的绘制入口 v24.F 🐲 2026-11-07
//
// 上一版的教训（重要）：
//   vo0.i(v24) 内部调用的是 **`v24.F(v24, ck5, JJFLgp0, II)V`** —— 一个
//   **接口的静态方法**，不是 do1.q（实例方法）。
//   ⇒ 我之前 hook do1.q，155 次全是别人的图，我们的 0 次。
//
//  另外 q88.g 里 `hg.l(gp0)` 就是 tint 落地的那一行：
//     :149  invoke-virtual {v0, v1}, Lhg;->l(Lgp0;)V
//
// 这一版 hook `v24.F`（接口静态方法），纯指针比对，零反射。
'use strict';

var TAG = '[NOTINT5]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

var ourRfs = [];
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
    p.setColor(-65536);                                 // 红
    c.drawCircle(w / 2, h / 2, Math.min(w, h) / 3, p);
    p.setColor(-16711936);                              // 绿
    c.drawRect(w * 0.05, h * 0.05, w * 0.3, h * 0.3, p);
    return b;
  }

  // ── ① s27.E：换成我们的 BitmapPainter ──────────────────────
  var hits = 0;
  try {
    var s27 = Java.use('s27');
    var E = s27.E.overload('int', 'int', 'v15');
    E.implementation = function (id, density, composer) {
      var orig = E.call(this, id, density, composer);
      try {
        if ((id >>> 0) !== tid || hits >= 6) return orig;
        hits++;
        var w = TW > 0 ? TW : 80, h = TH > 0 ? TH : 80;
        var rfObj = rfCls.$new(makeBitmap(w, h));
        ourRfs.push(rfObj);
        return vo0Cls.$new(rfObj);
      } catch (e) { return orig; }
    };
    P('✔ s27.E');
  } catch (e) { P('✘ s27.E: ' + e); }

  // ── ② v24.F：真正的绘制入口（接口静态方法）────────────────
  var nF = 0, nOurs = 0, nStrip = 0;
  try {
    var V = Java.use('v24');
    var F = V.F.overload('v24', 'ck5', 'long', 'long', 'float', 'gp0', 'int', 'int');
    F.implementation = function (self, ib, j1, j2, f1, filter, i1, i2) {
      nF++;
      // ★ 纯 JS 引用比对
      var mine = false;
      for (var i = 0; i < ourRfs.length; i++) {
        if (ourRfs[i] === ib) { mine = true; break; }
      }
      if (mine) {
        nOurs++;
        if (filter !== null) {
          nStrip++;
          if (nStrip <= 3) P('  ⟳ 剥离 tint #' + nStrip + ' 原 filter=' + filter.getClass().getName());
          return F.call(this, self, ib, j1, j2, f1, null, i1, i2);
        } else if (nOurs <= 3) {
          P('  （本来就无 tint）#' + nOurs);
        }
      }
      return F.call(this, self, ib, j1, j2, f1, filter, i1, i2);
    };
    P('✔ v24.F（真·绘制入口）');
  } catch (e) { P('✘ v24.F: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('换图=' + hits + ' v24.F调用=' + nF + ' 我们图被画=' + nOurs + ' 剥离tint=' + nStrip);
    P('==== 完 ====');
  }, 30000);
});
