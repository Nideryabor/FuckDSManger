// res_tint.js —— 抓「谁给图标加了 tint」🐲 2026-11-07
//
// 已经确定的事实（frida 实测）：
//   · s27.E(painterResource) 命中，返回 vo0(BitmapPainter)  ✅ 链路正常
//   · 我造了张**完全不透明的红底黄叉**，屏幕上却是**蓝色方块**
//   ⇒ 唯一解释：Compose 的 Icon 用 tint（SrcIn 混合）把颜色整个覆盖了，
//      只保留 alpha。整块不透明 ⇒ 整块变成主题蓝 ⇒ 蓝方块。
//
// 这版直接抓**调用栈**：谁在 new ColorFilter / 谁在调 tint。
'use strict';

var TAG = '[TINT]';
function P(s) { console.log(TAG + ' ' + s); }
var TARGET = 'ic_copy_outline';
function hx(i) { return '0x' + (i >>> 0).toString(16); }

Java.performNow(function () {
  var pkg = null, res = null, tid = 0;
  try {
    var AT = Java.use('android.app.ActivityThread');
    var app = AT.currentApplication();
    pkg = app.getPackageName();
    res = app.getResources();
    tid = res.getIdentifier(TARGET, 'drawable', pkg) >>> 0;
    P('pkg=' + pkg + ' target=' + hx(tid));
  } catch (e) { P('init: ' + e); }

  function stack(tag, extra) {
    try {
      var T = Java.use('java.lang.Thread');
      var st = T.currentThread().getStackTrace();
      var out = [];
      for (var i = 0; i < st.length && out.length < 9; i++) {
        var s = String(st[i].toString());
        if (s.indexOf('java.lang.Thread') >= 0) continue;
        if (s.indexOf('frida') >= 0) continue;
        out.push(s.replace('com.deepseek.chat.a.', ''));
      }
      P(tag + ' ' + (extra || ''));
      for (var j = 0; j < out.length; j++) P('    ' + out[j]);
    } catch (e) { P(tag + ' 取栈失败: ' + e); }
  }

  // ── ① PorterDuffColorFilter（Compose 在小 API 上用它做 tint）──
  var nPD = 0;
  try {
    var PDF = Java.use('android.graphics.PorterDuffColorFilter');
    PDF.$init.overload('int', 'android.graphics.PorterDuff$Mode').implementation =
      function (color, mode) {
        var r = this.$init(color, mode);
        if (nPD < 3) {
          nPD++;
          stack('【PorterDuffColorFilter】color=' + (color >>> 0).toString(16)
            + ' mode=' + mode, '');
        }
        return r;
      };
    P('✔ PorterDuffColorFilter');
  } catch (e) { P('✘ PorterDuffColorFilter: ' + e); }

  // ── ② BlendModeColorFilter（API29+ 的路径）──────────────────
  var nBM = 0;
  try {
    var BMF = Java.use('android.graphics.BlendModeColorFilter');
    BMF.$init.overload('int', 'android.graphics.BlendMode').implementation =
      function (color, mode) {
        var r = this.$init(color, mode);
        if (nBM < 3) {
          nBM++;
          stack('【BlendModeColorFilter】color=' + (color >>> 0).toString(16)
            + ' mode=' + mode, '');
        }
        return r;
      };
    P('✔ BlendModeColorFilter');
  } catch (e) { P('✘ BlendModeColorFilter: ' + e); }

  // ── ③ Paint.setColorFilter（最终生效点）──────────────────────
  var nSC = 0;
  try {
    var Paint = Java.use('android.graphics.Paint');
    Paint.setColorFilter.overload('android.graphics.ColorFilter').implementation =
      function (cf) {
        if (cf !== null && nSC < 3) {
          nSC++;
          stack('【Paint.setColorFilter】cf=' + cf.getClass().getName(), '');
        }
        return this.setColorFilter(cf);
      };
    P('✔ Paint.setColorFilter');
  } catch (e) { P('✘ Paint.setColorFilter: ' + e); }

  setTimeout(function () {
    P('==== 统计 ====');
    P('PorterDuffColorFilter=' + nPD + ' BlendModeColorFilter=' + nBM
      + ' setColorFilter=' + nSC);
    if (nPD + nBM + nSC === 0) P('⚠️ 完全没抓到 tint ⇒ 蓝色不是 tint 造成的，另有原因');
    P('==== 完 ====');
  }, 40000);
});
