// res_notint6.js —— 最终定位：拦 q88.g 的 tint 参数 🐲 2026-11-07
//
// 前面几版全在错误的位置：
//   · BitmapDrawable.draw  → BitmapPainter 不走它
//   · do1.b (drawRect)     → 第一参数是 brush，不是 ImageBitmap
//   · do1.q / v24.F        → 是底层 drawImage，被调 147 次但都不是我们的图
//
// 真相（q88.smali 逐行）：
//   q88.g(Lv24 drawScope, J size, F alpha, gp0 colorFilter)V   ← ★ Icon 走这个
//     :106  v0 = p0.c (上次的 colorFilter)
//     :110  if (v0 == p5) ...          ← 和上次比
//     :138  if-nez p5, :cond_49        ← p5 为空就不设 tint
//     :149  hg.l(v0)                   ← 设置 tint（宿主原色）
//     :180  hg.l(p5)                   ← 设置 tint（本次）
//     :191  iput p5 -> p0.c            ← 缓存
//
//  ⇒ 只要拦住 g 的 p5（第 4 个参数）传 null，这个 painter 就不会被染色。
//    再配合 ThreadLocal 判断"当前画的是不是我们的图"，做到精准剥离。
'use strict';

var TAG = '[NOTINT6]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

var ourPainters = [];    // 我们造的 vo0 对象
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

  // ── ① s27.E：换成我们的 BitmapPainter，记住 painter 对象 ────
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
        var painter = vo0Cls.$new(rfCls.$new(makeBitmap(w, h)));
        ourPainters.push(painter);
        P('  换图 #' + hits + ' → vo0 ' + w + 'x' + h);
        return painter;
      } catch (e) { return orig; }
    };
    P('✔ s27.E');
  } catch (e) { P('✘ s27.E: ' + e); }

  // ── ② q88.g：我们的 painter 就把 tint 置空 ──────────────────
  var nG = 0, nOurs = 0, nStrip = 0;
  try {
    var q88 = Java.use('q88');
    var G = q88.g.overload('v24', 'long', 'float', 'gp0');
    G.implementation = function (drawScope, size, alpha, filter) {
      nG++;
      var mine = false;
      for (var i = 0; i < ourPainters.length; i++) {
        if (ourPainters[i] === this) { mine = true; break; }
      }
      if (mine) {
        nOurs++;
        if (filter !== null) {
          nStrip++;
          if (nStrip <= 3) {
            P('  ⟳ 剥离 tint #' + nStrip + '（原 filter=' 
              + String(filter.getClass().getName()) + '）');
          }
        }
        // ★ 关键：把自己的缓存的 colorFilter 也清掉，否则 :106 那行会用旧值
        try {
          var fld = Java.use('q88').class.getDeclaredField('c');
          fld.setAccessible(true);
          fld.set(this, null);
        } catch (e) { }
        return G.call(this, drawScope, size, alpha, null);
      }
      return G.call(this, drawScope, size, alpha, filter);
    };
    P('✔ q88.g（带 tint 的绘制入口）');
  } catch (e) { P('✘ q88.g: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('换图=' + hits + ' q88.g调用=' + nG + ' 我们painter=' + nOurs + ' 剥离tint=' + nStrip);
    P('==== 完 ====');
  }, 30000);
});
