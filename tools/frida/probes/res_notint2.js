// res_notint2.js —— 精准剥离 tint（hook drawImage 本体）🐲 2026-11-07
//
// 上一版失败原因：BitmapPainter **不经过 BitmapDrawable.draw**，
//   所以"绘制次数=0"、标记没生效。
//
// 这次找到真正的绘制入口（反编译 + 调用栈双重确认）：
//   do1.b(Lks0;Lda8;FLgp0;II)Lhg;     ← DrawScope.drawImage 的实现
//       p1 = ks0  (ImageBitmap，我们的 rf 实现了它，字段 f = Bitmap)
//       p4 = gp0  (ColorFilter 封装，字段 a = android.graphics.ColorFilter)
//   :149  hg.l(gp0) → Paint.setColorFilter     ← tint 落地的那一行
//
// 方案：在这个方法里判断 p1 是不是**我们的图**，是就把 p4 换成 null。
//   ⇒ 只影响我们替换过的那张图，宿主其它图标照常染色。
'use strict';

var TAG = '[NOTINT2]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

var ours = [];      // 我们自己造的 Bitmap（按引用比）

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

  // 造一张「透明底 + 红圆 + 左上绿方块」—— 颜色鲜艳，一眼能判断 tint 有没有被剥掉
  function makeBitmap(w, h) {
    var b = Bitmap.createBitmap(w, h, Cfg.ARGB_8888.value);
    var c = Canvas.$new(b);
    var p = Paint.$new();
    p.setColor(-65536);                                     // 红 FF0000
    c.drawCircle(w / 2, h / 2, Math.min(w, h) / 3, p);
    p.setColor(-16711936);                                  // 绿 00FF00
    c.drawRect(w * 0.05, h * 0.05, w * 0.3, h * 0.3, p);
    return b;
  }

  // ── ① s27.E：换图并记账 ─────────────────────────────────────
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
        P('  换图 #' + hits + ' ' + w + 'x' + h
          + ' 中心=' + (bmp.getPixel(Math.floor(w / 2), Math.floor(h / 2)) >>> 0).toString(16));
        return vo0.$new(rf.$new(bmp));
      } catch (e) {
        P('  替换失败: ' + e);
        return orig;
      }
    };
    P('✔ s27.E');
  } catch (e) { P('✘ s27.E: ' + e); }

  // ── ② do1.b = drawImage 本体：识别我们的图 → 剥离 tint ──────
  function bitmapOfImageBitmap(ib) {
    // ks0 的实现是 rf，字段 f = Bitmap
    if (ib === null) return null;
    try {
      var cn = String(ib.getClass().getName());
      if (cn === 'rf' || cn.indexOf('rf') === 0) {
        var fld = ib.getClass().getDeclaredField('f');
        fld.setAccessible(true);
        var v = fld.get(ib);
        if (v !== null) return v;
      }
    } catch (e) { }
    // 兜底：试 asAndroidBitmap / 遍历 ours 反查
    return null;
  }

  var nCall = 0, nStrip = 0;
  try {
    var do1 = Java.use('do1');
    var B = do1.b.overload('ks0', 'da8', 'float', 'gp0', 'int', 'int');
    B.implementation = function (ib, brush, alpha, filter, blendMode, filterQuality) {
      try {
        nCall++;
        var bmp = bitmapOfImageBitmap(ib);
        if (bmp !== null) {
          var hit = false;
          for (var i = 0; i < ours.length; i++) {
            if (ours[i] === bmp) { hit = true; break; }
          }
          if (hit && filter !== null) {
            nStrip++;
            if (nStrip <= 4) {
              P('  ⟳ 剥离 tint #' + nStrip + '（原本 filter=' 
                + String(filter.getClass().getName()) + '）');
            }
            return B.call(this, ib, brush, alpha, null, blendMode, filterQuality);
          }
          if (hit && nStrip < 6) {
            nStrip++;
            P('  ⟳ 本来就是无 filter #' + nStrip);
          }
        }
      } catch (e) {
        if (nCall < 3) P('  检查异常: ' + e);
      }
      return B.call(this, ib, brush, alpha, filter, blendMode, filterQuality);
    };
    P('✔ do1.b (drawImage)');
  } catch (e) { P('✘ do1.b: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('换图=' + hits + ' drawImage调用=' + nCall + ' 命中并剥离=' + nStrip);
    P('判读：');
    P(' · 看到**红色圆 + 绿色方块** ⇒ tint 剥掉了，方案成立');
    P(' · 还是单色 ⇒ do1.b 不是唯一路径，继续往上层找');
    P('==== 完 ====');
  }, 45000);
});
