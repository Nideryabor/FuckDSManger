// res_paint3.js —— 把「处理后的位图」直接抓出来看 🐲 2026-11-07
//
// 上一版证明链路完全正确：
//   getValue string="fdm_replaced" → getDrawable → BitmapDrawable → vo0(BitmapPainter)
// ⇒ 现在只剩一个问题：**那张位图长什么样**。
//
// 这版不猜了 —— 直接把 BitmapDrawable 里的 Bitmap 导出成 PNG base64，
// 我拿去解码就能看见它到底是不是纯色块。
'use strict';

var TAG = '[PAINT3]';
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

  var done = false;

  function dumpBitmap(tag, bmp) {
    if (bmp === null || done) return;
    done = true;
    try {
      var w = bmp.getWidth(), h = bmp.getHeight();
      P(tag + ' 位图 ' + w + 'x' + h + ' config=' + bmp.getConfig());

      // 采样几个点 + 统计
      var p00 = bmp.getPixel(0, 0) >>> 0;
      var pc = bmp.getPixel(Math.floor(w / 2), Math.floor(h / 2)) >>> 0;
      var pe = bmp.getPixel(w - 1, h - 1) >>> 0;
      P(tag + ' 角=0x' + p00.toString(16) + ' 中=0x' + pc.toString(16)
        + ' 末=0x' + pe.toString(16));

      // 统计不透明像素（用 9x9 网格采样，不用数组，避免上一版那个错）
      var opaque = 0, total = 0, colors = {};
      var step = Math.max(1, Math.floor(Math.min(w, h) / 9));
      for (var y = 0; y < h; y += step) {
        for (var x = 0; x < w; x += step) {
          var px = bmp.getPixel(x, y) >>> 0;
          total++;
          if ((px / 16777216 | 0) !== 0) opaque++;
          colors[px] = (colors[px] || 0) + 1;
        }
      }
      P(tag + ' 采样 ' + total + ' 点：不透明=' + opaque
        + ' 不同颜色数=' + Object.keys(colors).length);

      // 导出 PNG base64
      var BAOS = Java.use('java.io.ByteArrayOutputStream');
      var bos = BAOS.$new();
      bmp.compress(Java.use('android.graphics.Bitmap$CompressFormat').PNG.value, 100, bos);
      var bytes = bos.toByteArray();
      var B64 = Java.use('android.util.Base64');
      var s = B64.encodeToString(bytes, B64.NO_WRAP.value);
      P(tag + ' PNG base64 长度=' + s.length);
      P('===B64BEGIN===');
      P(s);
      P('===B64END===');
    } catch (e) {
      P(tag + ' dump 失败: ' + e);
    }
  }

  // 抓 getDrawable 返回的 BitmapDrawable
  try {
    var R = Java.use('android.content.res.Resources');
    R.getDrawable.overload('int', 'android.content.res.Resources$Theme').implementation =
      function (id, th) {
        var r = this.getDrawable(id, th);
        try {
          if ((id >>> 0) === tid && r !== null) {
            var cn = String(r.getClass().getName());
            if (cn.indexOf('BitmapDrawable') >= 0) {
              dumpBitmap('【getDrawable】', r.getBitmap());
            }
          }
        } catch (e) { }
        return r;
      };
    P('✔ getDrawable');
  } catch (e) { P('✘ getDrawable: ' + e); }

  setTimeout(function () {
    if (!done) P('⚠️ 没抓到 BitmapDrawable —— 说明根本没走位图分支');
    P('==== 完 ====');
  }, 40000);
});
