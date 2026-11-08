// res_paint2.js —— 查「图为什么是蓝色方块」🐲 2026-11-07
//
// 上一版探针已经证明链路完全正确：
//   getValue string="fdm_replaced" → getDrawable → BitmapDrawable → vo0(BitmapPainter)
// ⇒ 钩子全对，Painter 也返回了。问题一定在**位图内容**或**绘制参数**上。
//
// 这一版查三件事：
//   ① 位图本身：尺寸 / 中心像素 / 不透明像素比例（全透明 or 全同色 = 一眼看出）
//   ② BitmapPainter(vo0) 的 intrinsic size 字段（f 是 Bitmap、g/i 是尺寸）
//   ③ 传给 vo0 的那个 Bitmap 到底是什么（构造时抓）
'use strict';

var TAG = '[PAINT2]';
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
  } catch (e) { P('init 失败: ' + e); }

  // ── ① vo0(BitmapPainter) 构造时抓那个 Bitmap ─────────────────
  var reported = false;
  try {
    var vo0 = Java.use('vo0');
    var ctor = vo0.$init.overload('ck5');
    ctor.implementation = function (ck5) {
      var out = ctor.call(this, ck5);
      try {
        // ck5 是 ImageBitmap；真实类型 rf（包着 Bitmap）
        P('【vo0 构造】ck5=' + (ck5 === null ? 'null' : ck5.getClass().getName()));
        if (!reported && ck5 !== null) {
          reported = true;
          // rf.f 是 Bitmap 字段
          var bmp = null;
          try {
            var fld = ck5.getClass().getDeclaredField('f');
            fld.setAccessible(true);
            var v = fld.get(ck5);
            if (v !== null && v.getClass().getName().indexOf('Bitmap') >= 0) bmp = v;
          } catch (e) { P('  取 Bitmap 字段失败: ' + e); }
          // 再试 asAndroidBitmap
          if (bmp === null) {
            try { bmp = ck5.asAndroidBitmap(); } catch (e) { }
          }
          if (bmp !== null) {
            var w = bmp.getWidth(), h = bmp.getHeight();
            P('  位图 = ' + w + 'x' + h + ' config=' + bmp.getConfig());
            var p00 = bmp.getPixel(0, 0);
            var pc = bmp.getPixel(w / 2, h / 2);
            var pe = bmp.getPixel(w - 1, h - 1);
            // 统计中心行的不透明像素
            var row = Java.array('int', new Array(w));
            bmp.getPixels(row, 0, w, 0, Math.floor(h / 2), w, 1);
            var n = 0, colors = {};
            for (var i = 0; i < w; i++) {
              var px = row[i];
              if ((px >>> 24) !== 0) n++;
              colors[px] = (colors[px] || 0) + 1;
            }
            var keys = Object.keys(colors).slice(0, 6);
            P('  角=' + (p00 >>> 0).toString(16) + ' 中=' + (pc >>> 0).toString(16)
              + ' 末=' + (pe >>> 0).toString(16));
            P('  中线不透明=' + n + '/' + w + ' 不同颜色数=' + Object.keys(colors).length
              + ' 前几个=' + keys.join(','));
          } else {
            P('  ⚠️ 拿不到底层 Bitmap');
          }
        }
      } catch (e) { P('  检查失败: ' + e); }
      return out;
    };
    P('✔ vo0 ctor');
  } catch (e) { P('✘ vo0: ' + e); }

  // ── ② getDrawable 返回的 BitmapDrawable 里那张图 ──────────────
  var dReported = false;
  try {
    var R = Java.use('android.content.res.Resources');
    R.getDrawable.overload('int', 'android.content.res.Resources$Theme').implementation =
      function (id, th) {
        var r = this.getDrawable(id, th);
        try {
          if ((id >>> 0) === tid && r !== null && !dReported) {
            var cn = r.getClass().getName();
            if (cn.indexOf('BitmapDrawable') >= 0) {
              dReported = true;
              var b = r.getBitmap();
              if (b !== null) {
                var w = b.getWidth(), h = b.getHeight();
                P('【getDrawable】BitmapDrawable ' + w + 'x' + h
                  + ' 中=' + (b.getPixel(w / 2, h / 2) >>> 0).toString(16)
                  + ' 角=' + (b.getPixel(0, 0) >>> 0).toString(16));
              }
            }
          }
        } catch (e) { }
        return r;
      };
    P('✔ getDrawable 内容检查');
  } catch (e) { P('✘ getDrawable: ' + e); }

  setTimeout(function () {
    P('==== 判读 ====');
    P('· 位图 中线不透明=0 或 不同颜色数=1  ⇒ 图本身是空/纯色（源文件问题或裁切裁到空白）');
    P('· 位图正常但界面还是蓝块        ⇒ 问题在 Compose 的 tint，不是图');
    P('==== 完 ====');
  }, 45000);
});
