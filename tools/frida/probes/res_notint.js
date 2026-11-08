// res_notint.js —— 验证「只对我们换的图免除 tint」🐲 2026-11-07
//
// 已确认（frida 实测栈）：
//   BlendModeColorFilter color=ff8b8b8b mode=SRC_IN
//   Paint.setColorFilter ← hg.l ← ... ← zpb.i(图标绘制)
// ⇒ Icon 的 tint 把我们的图整个染色了，只剩一个色条。
//
// 解法（这版验证）：只对**我们替换的那张 Bitmap** 免除 tint。
//   ① 在 s27.E 里造图时，把 Bitmap 记进 JS 数组（Bitmap 没重写 equals ⇒ 按引用比）
//   ② hook BitmapDrawable.draw：正在画的是我们的图 ⇒ 设 ThreadLocal 标记
//   ③ hook Paint.setColorFilter：标记为真 ⇒ 传 null（不染色）
//
// 这样宿主的其它图标仍然正常染色，只有我们换过的保持原色。
'use strict';

var TAG = '[NOTINT]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

var ours = [];              // 我们自己造的 Bitmap
var inOurs = false;         // 当前线程是否在画我们的图

function hx(i) { return '0x' + (i >>> 0).toString(16); }

Java.performNow(function () {
  var app = null, res = null, pkg = null, tid = 0, TW = 0, TH = 0;
  try {
    var AT = Java.use('android.app.ActivityThread');
    app = AT.currentApplication();
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

  // 造一张**带透明区域**的测试图：透明底 + 红色实心圆 + 绿色方块
  // （这样能一眼看出：透明处保留透明 / 红色没被染成蓝）
  function makeBitmap(w, h) {
    var b = Bitmap.createBitmap(w, h, Cfg.ARGB_8888.value);
    var c = Canvas.$new(b);
    var p = Paint.$new();
    p.setColor(-65536);                                    // 红
    c.drawCircle(w / 2, h / 2, Math.min(w, h) / 3, p);
    p.setColor(-16711936);                                 // 绿
    c.drawRect(w * 0.1, h * 0.1, w * 0.3, h * 0.3, p);
    P('造图 ' + w + 'x' + h + ' 中心=' + (b.getPixel(Math.floor(w / 2), Math.floor(h / 2)) >>> 0).toString(16)
      + ' 角落=' + (b.getPixel(0, 0) >>> 0).toString(16) + '（角落应为 0=全透明）');
    return b;
  }

  // ── ① s27.E：换成我们的 BitmapPainter，并记住 Bitmap ──────────
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
        var rf = Java.use('rf');
        var vo0 = Java.use('vo0');
        return vo0.$new(rf.$new(bmp));
      } catch (e) {
        P('替换失败: ' + e);
        return orig;
      }
    };
    P('✔ s27.E（换图并记账）');
  } catch (e) { P('✘ s27.E: ' + e); }

  // ── ② BitmapDrawable.draw：画到我们的图时打标记 ──────────────
  var nDraw = 0;
  try {
    var BD = Java.use('android.graphics.drawable.BitmapDrawable');
    BD.draw.overload('android.graphics.Canvas').implementation = function (canvas) {
      var mine = false;
      try {
        var b = this.getBitmap();
        if (b !== null) {
          for (var i = 0; i < ours.length; i++) {
            if (ours[i] === b) { mine = true; break; }
          }
        }
      } catch (e) { }
      if (mine) {
        nDraw++;
        inOurs = true;
      }
      try {
        return this.draw(canvas);
      } finally {
        if (mine) inOurs = false;
      }
    };
    P('✔ BitmapDrawable.draw（标记）');
  } catch (e) { P('✘ BitmapDrawable.draw: ' + e); }

  // ── ③ Paint.setColorFilter：画我们的图时不染色 ───────────────
  var skipped = 0;
  try {
    var P2 = Java.use('android.graphics.Paint');
    P2.setColorFilter.overload('android.graphics.ColorFilter').implementation =
      function (cf) {
        if (inOurs && cf !== null) {
          skipped++;
          if (skipped <= 5) P('  ⟳ 跳过 tint（我们的图）');
          return this.setColorFilter(null);
        }
        return this.setColorFilter(cf);
      };
    P('✔ Paint.setColorFilter（按需剥离）');
  } catch (e) { P('✘ Paint.setColorFilter: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('s27.E 换图次数=' + hits + ' 我们图的绘制次数=' + nDraw + ' 跳过 tint 次数=' + skipped);
    P('判读：');
    P(' · 跳过 tint>0 且界面出现红圆+绿方块 ⇒ 方案成立，我把它写进 Xposed');
    P(' · 跳过 tint=0 ⇒ tint 不是走 Paint.setColorFilter，要换 hook 点');
    P('==== 完 ====');
  }, 45000);
});
