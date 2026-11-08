// res_paint4.js —— frida 里直接换图，秒级验证（不重启宿主）🐲 2026-11-07
//
// 之前的问题：每验证一次要「改代码→打包→装包→重启」，一轮 5 分钟，而且
// 完全看不到"到底画成什么样"。这次在 frida 里**直接劫持 painterResource，
// 返回我们构造的 Painter**，立刻就能看到效果。
//
// 三件事：
//   ① 抓 s27.E 被调用时 id 和目标资源对不对
//   ② 在 frida 里直接构造 BitmapPainter(vo0) 返回 —— 绕开所有 Xposed 逻辑
//   ③ 把构造用的位图内容打出来（是不是纯色 / 多大）
'use strict';

var TAG = '[PAINT4]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

function hx(i) { return '0x' + (i >>> 0).toString(16); }

Java.performNow(function () {
  var app = null, res = null, pkg = null, tid = 0;
  try {
    var AT = Java.use('android.app.ActivityThread');
    app = AT.currentApplication();
    pkg = app.getPackageName();
    res = app.getResources();
    tid = res.getIdentifier(TARGET, 'drawable', pkg) >>> 0;
    P('pkg=' + pkg + ' target=' + hx(tid));
  } catch (e) { P('init: ' + e); }

  // 目标尺寸（宿主原图标的 intrinsic）
  var TW = 0, TH = 0;
  try {
    var orig = res.getDrawable(tid, null);
    TW = orig.getIntrinsicWidth();
    TH = orig.getIntrinsicHeight();
    P('宿主原图标 intrinsic = ' + TW + 'x' + TH);
  } catch (e) { P('取 intrinsic 失败: ' + e); }

  // ── 造一张一眼能认出来的图：红底 + 黄色对角线 ──────────────
  var Bitmap = Java.use('android.graphics.Bitmap');
  var Canvas = Java.use('android.graphics.Canvas');
  var Paint = Java.use('android.graphics.Paint');
  var Cfg = Java.use('android.graphics.Bitmap$Config');

  function makeBitmap(w, h, label) {
    var b = Bitmap.createBitmap(w, h, Cfg.ARGB_8888.value);
    var c = Canvas.$new(b);
    var p = Paint.$new();
    p.setColor(-65536);                 // 红
    c.drawRect(0, 0, w, h, p);
    p.setColor(-256);                   // 黄
    p.setStrokeWidth(Math.max(2, w / 8));
    c.drawLine(0, 0, w, h, p);
    c.drawLine(w, 0, 0, h, p);
    P(label + ' 造图 ' + w + 'x' + h + ' 角=' + (b.getPixel(0, 0) >>> 0).toString(16)
      + ' 中=' + (b.getPixel(Math.floor(w / 2), Math.floor(h / 2)) >>> 0).toString(16));
    return b;
  }

  // ── 直接劫持 s27.E，返回我们自己造的 BitmapPainter ──────────
  var hits = 0;
  try {
    var s27 = Java.use('s27');
    var E = s27.E.overload('int', 'int', 'v15');
    E.implementation = function (id, density, composer) {
      var orig = E.call(this, id, density, composer);
      try {
        if ((id >>> 0) !== tid || hits >= 3) return orig;
        hits++;
        P('【s27.E】命中 #' + hits + ' id=' + hx(id)
          + ' 原返回=' + (orig === null ? 'null' : orig.getClass().getName()));

        // 用宿主原图尺寸造图
        var w = TW > 0 ? TW : 70, h = TH > 0 ? TH : 70;
        var bmp = makeBitmap(w, h, '#' + hits);

        // rf 包着 Bitmap（ImageBitmap 实现）
        var rf = Java.use('rf');
        var imageBitmap = rf.$new(bmp);
        // vo0(BitmapPainter) 构造 (ck5)
        var vo0 = Java.use('vo0');
        var painter = vo0.$new(imageBitmap);
        P('  → 返回 ' + painter.getClass().getName());
        return painter;
      } catch (e) {
        P('  替换失败: ' + e);
        return orig;
      }
    };
    P('✔ s27.E 已劫持（会返回红黄测试图）');
  } catch (e) { P('✘ s27.E: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('s27.E 命中次数=' + hits);
    if (hits === 0) P('⚠️ 一次都没命中 ⇒ 这个图标不是 painterResource 画的！');
    P('==== 完 ====');
  }, 40000);
});
