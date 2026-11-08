// res_notint8.js —— 用 Java.equals() 做身份比对（$handle 在 QuickJS 里是 undefined）🐲
//
// 上一版的坑：
//   `painter.$handle` 在 **QuickJS 引擎**里返回 undefined
//   ⇒ `indexOf(undefined) >= 0` 恒真 ⇒ 所有图标都被剥了 tint（181 次）
//   好消息：这次误伤证明了**剥离 tint 确实能让图显示原色**
//
// 正确做法：用 **Java 层的 equals**（Object.equals 默认按引用比）。
//   把我们的 painter 存进一个 Java ArrayList（java.util.ArrayList），
//   然后 `list.contains(this)` —— 走 Java equals，可靠。
'use strict';

var TAG = '[NOTINT8]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';

Java.performNow(function () {
  var pkg = null, res = null, tid = 0, TW = 0, TH = 0;
  var ourList = null;
  try {
    var AT = Java.use('android.app.ActivityThread');
    var app = AT.currentApplication();
    pkg = app.getPackageName();
    res = app.getResources();
    tid = res.getIdentifier(TARGET, 'drawable', pkg) >>> 0;
    var o = res.getDrawable(tid, null);
    TW = o.getIntrinsicWidth();
    TH = o.getIntrinsicHeight();
    // ★ 用 Java 层的 ArrayList 存，contains 走 Java equals（引用比较）
    ourList = Java.use('java.util.ArrayList').$new();
    P('pkg=' + pkg + ' target=' + hx(tid) + ' 原尺寸=' + TW + 'x' + TH);
  } catch (e) { P('init: ' + e); }

  var Bitmap = Java.use('android.graphics.Bitmap');
  var Canvas = Java.use('android.graphics.Canvas');
  var Paint = Java.use('android.graphics.Paint');
  var Cfg = Java.use('android.graphics.Bitmap$Config');
  var rfCls = Java.use('rf');
  var vo0Cls = Java.use('vo0');

  function hx(i) { return '0x' + (i >>> 0).toString(16); }

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
        ourList.add(painter);                    // ★ Java 层记账
        P('  换图 #' + hits + ' size=' + ourList.size());
        return painter;
      } catch (e) {
        P('  换图失败: ' + e);
        return orig;
      }
    };
    P('✔ s27.E');
  } catch (e) { P('✘ s27.E: ' + e); }

  var nG = 0, nOurs = 0, nStrip = 0;
  try {
    var q88 = Java.use('q88');
    var G = q88.g.overload('v24', 'long', 'float', 'gp0');
    G.implementation = function (drawScope, size, alpha, filter) {
      nG++;
      var mine = false;
      try { mine = ourList.contains(this); } catch (e) { }   // ★ Java equals
      if (mine) {
        nOurs++;
        if (nOurs <= 4) {
          P('  ★ 命中我们的 painter！filter='
            + (filter === null ? 'null' : String(filter.getClass().getName())));
        }
        if (filter !== null) nStrip++;
        return G.call(this, drawScope, size, alpha, null);
      }
      return G.call(this, drawScope, size, alpha, filter);
    };
    P('✔ q88.g（Java equals 比对）');
  } catch (e) { P('✘ q88.g: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('换图=' + hits + ' q88.g=' + nG + ' 命中我们的=' + nOurs + ' 剥离tint=' + nStrip);
    P('列表长度=' + (ourList === null ? -1 : ourList.size()));
    P('==== 完 ====');
  }, 30000);
});
