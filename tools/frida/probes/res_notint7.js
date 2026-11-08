// res_notint7.js —— 修正致命的比对错误（所有"0命中"的元凶）🐲 2026-11-07
//
// 这十几轮全部"我们图被画=0"，真正原因不是"hook 点找错"，
// 而是 frida 里 `===` 比较 Java 对象根本不可靠：
//   frida 每次访问 Java 对象，都可能创建一个**新的 JS wrapper**，
//   所以 `ourPainters[i] === this` 几乎永远 false（哪怕指向同一个 Java 实例）。
//
// 正确做法：比较 $handle（底层 native 指针，纯数字）：
//   ourHandles.push(painter.$handle);
//   if (ourHandles.indexOf(this.$handle) >= 0) { ... }
'use strict';

var TAG = '[NOTINT7]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';
var ourHandles = [];
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
        ourHandles.push(painter.$handle);
        P('  换图 #' + hits + ' → vo0 handle=' + painter.$handle);
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
      var mine = ourHandles.indexOf(this.$handle) >= 0;
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
    P('✔ q88.g（$handle 比对）');
  } catch (e) { P('✘ q88.g: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('换图=' + hits + ' q88.g调用=' + nG + ' 命中我们的=' + nOurs + ' 剥离tint=' + nStrip);
    P('手柄: ' + ourHandles.join(','));
    P('==== 完 ====');
  }, 30000);
});
