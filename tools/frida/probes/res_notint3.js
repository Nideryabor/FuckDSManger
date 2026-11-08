// res_notint3.js —— 精准剥离 tint（最终版）🐲 2026-11-07
//
// 前两版失败的原因（都是"认错了方法"）：
//   · 用 BitmapDrawable.draw  → BitmapPainter 根本不走它（绘制次数=0）
//   · 用 do1.b(drawRect)      → 它第一个参数是 brush(ks0)，不是 ImageBitmap
//                                974 次调用全部错过
//
// 这次是**反编译逐行确认**的真实入口：
//   do1.q(Lck5 p1, JJJJF, gp0 p11, II)V
//     p1  = ImageBitmap（我们造的 rf，字段 a = Bitmap）
//     p11 = gp0（ColorFilter 封装，字段 a = android.graphics.ColorFilter）
//   内部：
//     :17  do1.b(..., p11)         → hg.l(p11) → Paint.setColorFilter   ← tint 落地
//     :69  bo1.p(p1, ..., hg)      → 真正画这张图
//
// 方案：p1 是我们的图 ⇒ 把 p11 传 null（不染色）。
//   ⇒ 只影响我们替换过的图，宿主其它图标照常 tint。
'use strict';

var TAG = '[NOTINT3]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

var ours = [];        // 我们自己造的 Bitmap
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

  // 透明底 + 大红圆 + 左上绿方块 —— 颜色鲜艳，tint 有没有剥离一眼可辨
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
        var w = TW > 0 ? TW : 70, h = TH > 0 ? TH : 70;
        var bmp = makeBitmap(w, h);
        ours.push(bmp);
        return Java.use('vo0').$new(Java.use('rf').$new(bmp));
      } catch (e) { return orig; }
    };
    P('✔ s27.E');
  } catch (e) { P('✘ s27.E: ' + e); }

  // ── ② do1.q：drawImage 真身 → 剥离 tint ────────────────────
  function isOurs(ib) {
    if (ib === null) return false;
    try {
      var cn = String(ib.getClass().getName());
      if (cn !== 'rf') return false;
      var fld = ib.getClass().getDeclaredField('a');   // ★ 字段名是 a，不是 f
      fld.setAccessible(true);
      var b = fld.get(ib);
      if (b === null) return false;
      for (var i = 0; i < ours.length; i++) {
        if (ours[i] === b) return true;
      }
    } catch (e) { }
    return false;
  }

  var nQ = 0, nStrip = 0, nOursDraw = 0;
  try {
    var do1 = Java.use('do1');
    var Q = do1.q.overload('ck5', 'long', 'long', 'long', 'long',
                           'float', 'gp0', 'int', 'int');
    Q.implementation = function (ib, j1, j2, j3, j4, f1, filter, i1, i2) {
      try {
        nQ++;
        if (isOurs(ib)) {
          nOursDraw++;
          if (filter !== null) {
            nStrip++;
            if (nStrip <= 3) P('  ⟳ 剥离 tint #' + nStrip);
            return Q.call(this, ib, j1, j2, j3, j4, f1, null, i1, i2);
          } else if (nOursDraw <= 3) {
            P('  （本来就是无 tint）#' + nOursDraw);
          }
        }
      } catch (e) {
        if (nQ <= 3) P('  检查异常: ' + e);
      }
      return Q.call(this, ib, j1, j2, j3, j4, f1, filter, i1, i2);
    };
    P('✔ do1.q (drawImage 真身)');
  } catch (e) { P('✘ do1.q: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('换图=' + hits + ' drawImage(q)调用=' + nQ
      + ' 我们图被画=' + nOursDraw + ' 剥离tint=' + nStrip);
    P('判读：');
    P(' · 看到**红圆 + 绿方块** ⇒ 成功，写进 Xposed');
    P(' · 我们图被画=0 ⇒ 连 vo0 都没画（另有渲染路径）');
    P(' · 被画>0 但仍单色 ⇒ tint 不走这条，我再往上找');
    P('==== 完 ====');
  }, 45000);
});
