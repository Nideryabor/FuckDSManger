// fit7.js —— 【一次注入·只问一个问题】：用我们 shader 画的那个矩形，到底是什么？
// 🐲 尼得亚伯 · 2026-10-02
//
// 为什么是这个探针：
//   静态已经定死两件事（见 专题/AI气泡底-第二坑-排查中.md）：
//     ① J = DrawScope.size（节点尺寸），Lim9.a 拿它当缓存键，再原样传给我们
//     ② AI 的底是 GmBubbleCellHook 挂在【消息项 Modifier】上的（pn9.c），
//        而用户气泡挂在【气泡本体】（ls9.f / ua0.e）
//   ⇒ 现在只差一个数据：被画的那个矩形（topLeft + size）。
//     它和 J 一样 ⇒ 基准对，问题在"绘制域/被裁"
//     它和 J 不一样 ⇒ 基准错，底挂错了层
//
// 设计（一次注入、一问一答、见好就收）：
//   [C] 对照组 —— Canvas 绘制调用总计数（系统类，LSPosed 不碰）
//        ⇒ 它涨 = frida 的 Java hook 在这个进程里真的有效（先排除"工具无效"）
//   [D] 主证据 —— Paint 上 shader 是 GmBmpShader（我们自己造的）时，打 rect
//   [B] 参考   —— jq0.b(J) 的 J（此方法 LSPosed 也在钩，可能被顶掉 ⇒ 只作参考）
//
// ⚠️ 输出全 ASCII：中文经网关→adb 会被吃成 '?'（08-02 fit6 实测）。
'use strict';

var TAG = '[FIT7]';

var B_MAX = 12, D_MAX = 12;
var bCnt = 0, dCnt = 0, cCnt = 0;
var cMark = { 1: 1, 10: 1, 100: 1, 1000: 1, 10000: 1 };

function tid() { try { return Process.getCurrentThreadId(); } catch (e) { return -1; } }

function shaderName(paint) {
  try {
    var sh = paint.getShader();
    if (sh === null) return null;
    return sh.getClass().getName();
  } catch (e) { return '(err:' + e + ')'; }
}

Java.performNow(function () {
  console.log(TAG + ' inject ok, pid=' + Process.id);

  var Canvas = null;
  try { Canvas = Java.use('android.graphics.Canvas'); }
  catch (e) { console.log(TAG + ' FAIL Canvas: ' + e); }

  function notePaint(what, desc, paint) {
    cCnt++;
    if (cMark[cCnt] === 1) {
      console.log(TAG + ' [C] ALIVE #' + cCnt + ' draw-call (' + what + ')');
      delete cMark[cCnt];
    }
    var sn = shaderName(paint);
    if (sn === null) return;
    if (sn.indexOf('GmBmpShader') < 0) return;
    if (dCnt >= D_MAX) { dCnt++; return; }
    dCnt++;
    var line = TAG + ' [D#' + dCnt + '] tid=' + tid() + ' ' + what + ' ' + desc + ' shader=' + sn;
    try {
      var m = Java.use('android.graphics.Matrix').$new();
      paint.getShader().getLocalMatrix(m);
      var v = Java.array('float', [0, 0, 0, 0, 0, 0, 0, 0, 0]);
      m.getValues(v);
      line += ' matrix=[sx=' + v[0] + ',ky=' + v[1] + ',tx=' + v[2] + ' | kx=' + v[3] + ',sy=' + v[4] + ',ty=' + v[5] + ']';
    } catch (e2) { line += ' matrix=(n/a:' + e2 + ')'; }
    console.log(line);
  }

  if (Canvas !== null) {
    try {
      Canvas.drawRect.overload('float', 'float', 'float', 'float', 'android.graphics.Paint')
        .implementation = function (l, t, r, b, p) {
          notePaint('drawRect', 'rect=(' + l + ',' + t + ',' + r + ',' + b + ') size=(' + (r - l) + ',' + (b - t) + ')', p);
          return this.drawRect(l, t, r, b, p);
        };
      console.log(TAG + ' OK drawRect(f4,Paint)');
    } catch (e) { console.log(TAG + ' FAIL drawRect: ' + e); }

    try {
      Canvas.drawRoundRect.overload('float', 'float', 'float', 'float', 'float', 'float', 'android.graphics.Paint')
        .implementation = function (l, t, r, b, rx, ry, p) {
          notePaint('drawRoundRect', 'rect=(' + l + ',' + t + ',' + r + ',' + b + ') size=(' + (r - l) + ',' + (b - t) + ') rx=' + rx + ' ry=' + ry, p);
          return this.drawRoundRect(l, t, r, b, rx, ry, p);
        };
      console.log(TAG + ' OK drawRoundRect(f6,Paint)');
    } catch (e) { console.log(TAG + ' FAIL drawRoundRect: ' + e); }

    try {
      Canvas.drawRoundRect.overload('android.graphics.RectF', 'android.graphics.Paint')
        .implementation = function (rf, p) {
          notePaint('drawRoundRect(RectF)', 'rect=(' + rf.left + ',' + rf.top + ',' + rf.right + ',' + rf.bottom + ')', p);
          return this.drawRoundRect(rf, p);
        };
      console.log(TAG + ' OK drawRoundRect(RectF,Paint)');
    } catch (e) { console.log(TAG + ' FAIL drawRoundRect(RectF): ' + e); }

    try {
      Canvas.drawPath.overload('android.graphics.Path', 'android.graphics.Paint')
        .implementation = function (path, p) {
          var d = 'path(bounds-fail)';
          try {
            var rf = Java.use('android.graphics.RectF').$new();
            path.computeBounds(rf, true);
            d = 'pathBounds=(' + rf.left + ',' + rf.top + ',' + rf.right + ',' + rf.bottom + ') size=(' + (rf.right - rf.left) + ',' + (rf.bottom - rf.top) + ')';
          } catch (e3) { }
          notePaint('drawPath', d, p);
          return this.drawPath(path, p);
        };
      console.log(TAG + ' OK drawPath(Path,Paint)');
    } catch (e) { console.log(TAG + ' FAIL drawPath: ' + e); }
  }

  (function () {
    try {
      var L = null;
      Java.enumerateClassLoadersSync().forEach(function (l) {
        if (L) return;
        try { l.loadClass('jq0'); L = l; } catch (e) { }
      });
      var fac = L ? Java.ClassFactory.get(L) : Java.classFactory;
      var jq0 = fac.use('jq0');
      jq0.b.overload('long').implementation = function (size) {
        var r = this.b(size);
        if (bCnt < B_MAX) {
          bCnt++;
          var fw = Java.use('java.lang.Float').intBitsToFloat(size >>> 32);
          var fh = Java.use('java.lang.Float').intBitsToFloat(size & 0xffffffff);
          console.log(TAG + ' [B#' + bCnt + '] tid=' + tid() + ' J=(' + fw + ',' + fh + ') -> ' + (r === null ? 'null' : r.getClass().getName()));
        } else { bCnt++; }
        return r;
      };
      console.log(TAG + ' OK jq0.b(long) (ref-only)');
    } catch (e) { console.log(TAG + ' FAIL jq0.b: ' + e); }
  })();

  console.log(TAG + ' READY - scroll the chat now');
});
