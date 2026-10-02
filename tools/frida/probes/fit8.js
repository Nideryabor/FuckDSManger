// fit8.js —— fit7 的修正版：钩【宿主自己的 AndroidCanvas】，拿"真正被画的那个矩形"
// 🐲 尼得亚伯 · 2026-10-02
//
// fit7 的真机结论：
//   [C] 对照组涨了 ⇒ frida 的 Java hook 在进程里是活的
//   [B] jq0.b(J) 被调 12 次，每次都返回我们的 GmBmpShader ⇒ 我们的底确实在渲染链上
//   [D] 零命中 ⇒ 不是"没画"，是我钩错了面
//
// 为什么错（静态查实）：
//   宿主 Compose 画布接口 Lvl1 只有两个实现者：Lhc;（真身，装 android.graphics.Canvas）
//   和 Ls54;（空画布）。hc.k → Canvas.drawRect(FFFF,Paint)；hc.g → drawRoundRect；hc.f → drawPath。
//   而运行时那个 Canvas 是 RecordingCanvas（硬件画布），它 override 了这些方法
//   ⇒ 钩基类 android.graphics.Canvas 会被虚分派绕过。
//   ⇒ 这一版直接钩宿主自己的 hc（宿主类，没这个问题）。
//
// 抗造设计：
//   · 不写死 overload 签名：按 .overloads 数量自动决定（1 个直接挂，多个按参数个数挑）
//   · Path 的 android.graphics.Path 字段名不写死：扫描运行时类的字段，找类型为 android.graphics.Path 的那个
//   · J 用 BigInt 正确拆 64 位（fit7 用 >>> 只取 32 位 ⇒ 宽高解成同一个值，全是"正方形"）
//   · 对照组 [C] 挂在**热路径**（hc.k 的调用计数），不是挂在基类
'use strict';

var TAG = '[FIT8]';
var MAX = 14;
var nK = 0, nG = 0, nF = 0, nHit = 0;
var mark = { 1: 1, 10: 1, 100: 1, 1000: 1 };

function tid() { try { return Process.getCurrentThreadId(); } catch (e) { return -1; } }

function bits2f(bits) {
  try { return Java.use('java.lang.Float').intBitsToFloat(bits | 0); } catch (e) { return NaN; }
}
function unpack2(v) {
  var hi = 0, lo = 0;
  try {
    if (typeof v === 'number') { hi = Math.floor(v / 4294967296); lo = v % 4294967296; }
    else {
      var n = BigInt(v.toString());
      hi = Number(n >> 32n);
      lo = Number(n & 0xffffffffn);
    }
  } catch (e) { return ['?', '?']; }
  return [bits2f(hi), bits2f(lo)];
}

// 反射：从运行时类（含父类）里找一个指定类型名的字段
function findFieldOfType(obj, typeName) {
  try {
    var c = obj.getClass();
    for (var i = 0; i < 8 && c !== null; i++) {
      var fs = c.getDeclaredFields();
      for (var j = 0; j < fs.length; j++) {
        try {
          if (fs[j].getType().getName() === typeName) { fs[j].setAccessible(true); return fs[j].get(obj); }
        } catch (e) { }
      }
      c = c.getSuperclass();
    }
  } catch (e) { }
  return null;
}

function shaderTag(paint) {
  try {
    if (paint === null) return '(no-paint)';
    var sh = paint.getShader();
    if (sh === null) return '(shader=null)';
    return sh.getClass().getName();
  } catch (e) { return '(err)'; }
}
function paintFromWrapper(sf) {
  var p = findFieldOfType(sf, 'android.graphics.Paint');
  return p;
}

Java.performNow(function () {
  console.log(TAG + ' inject ok, pid=' + Process.id);

  var L = null;
  Java.enumerateClassLoadersSync().forEach(function (l) {
    if (L) return;
    try { l.loadClass('jq0'); L = l; } catch (e) { }
  });
  var fac = L ? Java.ClassFactory.get(L) : Java.classFactory;
  console.log(TAG + ' loader=' + (L ? 'ok' : 'default'));

  function note(what, desc, sf) {
    if (what === 'drawRect') { nK++; if (mark[nK] === 1) { console.log(TAG + ' [C] ALIVE hc.k #' + nK + ' (drawRect)'); delete mark[nK]; } }
    if (what === 'drawRoundRect') nG++;
    if (what === 'drawPath') nF++;
    var tag = shaderTag(paintFromWrapper(sf));
    if (tag.indexOf('GmBmpShader') < 0) return;
    if (nHit >= MAX) { nHit++; return; }
    nHit++;
    console.log(TAG + ' [D#' + nHit + '] tid=' + tid() + ' ' + what + ' ' + desc + ' shader=' + tag +
      ' | counts k=' + nK + ' g=' + nG + ' f=' + nF);
  }

  // 通用挂钩：按 overloads 数量自适应；原调用用 m.call(this, ...) 按参数个数分派
  function hookIt(cls, name, arity, fmt) {
    try {
      var m = cls[name];
      if (m === undefined || m === null) { console.log(TAG + ' FAIL ' + name + ': no method'); return; }
      var impl = function () {
        var a = arguments;
        var desc = '';
        try { desc = fmt(a); } catch (e) { desc = '(fmt-fail)'; }
        var sf = null;
        try { sf = a[a.length - 1]; } catch (e) { }
        note(name === 'k' ? 'drawRect' : (name === 'g' ? 'drawRoundRect' : 'drawPath'), desc, sf);
        switch (a.length) {
          case 3: return m.call(this, a[0], a[1], a[2]);
          case 5: return m.call(this, a[0], a[1], a[2], a[3], a[4]);
          case 6: return m.call(this, a[0], a[1], a[2], a[3], a[4], a[5]);
          case 7: return m.call(this, a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
          case 8: return m.call(this, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
        }
        return undefined;
      };
      var ovs = m.overloads;
      if (ovs.length === 1) {
        m.implementation = impl;
      } else {
        var hit = 0;
        for (var i = 0; i < ovs.length; i++) {
          if (ovs[i].argumentTypes.length === arity) { ovs[i].implementation = impl; hit++; }
        }
        if (hit === 0) { console.log(TAG + ' FAIL ' + name + ': no overload with arity ' + arity + ' (' + ovs.length + ' total)'); return; }
      }
      console.log(TAG + ' OK hc.' + name + ' (overloads=' + ovs.length + ')');
    } catch (e) { console.log(TAG + ' FAIL hc.' + name + ': ' + e); }
  }

  try {
    var HC = fac.use('hc');
    // k(FFFF,sf) = drawRect
    hookIt(HC, 'k', 5, function (a) {
      return 'rect=(' + a[0] + ',' + a[1] + ',' + a[2] + ',' + a[3] + ') size=(' + (a[2] - a[0]) + ',' + (a[3] - a[1]) + ')';
    });
    // g(FFFFFF,sf) = drawRoundRect
    hookIt(HC, 'g', 7, function (a) {
      return 'rect=(' + a[0] + ',' + a[1] + ',' + a[2] + ',' + a[3] + ') size=(' + (a[2] - a[0]) + ',' + (a[3] - a[1]) + ') rx=' + a[4] + ' ry=' + a[5];
    });
    // f(path, J, sf) = drawPath
    hookIt(HC, 'f', 3, function (a) {
      var d = 'path=(?)';
      try {
        var rp = findFieldOfType(a[0], 'android.graphics.Path');
        if (rp !== null) {
          var rf = Java.use('android.graphics.RectF').$new();
          rp.computeBounds(rf, true);
          d = 'pathBounds=(' + rf.left + ',' + rf.top + ',' + rf.right + ',' + rf.bottom + ')';
        }
      } catch (e) { }
      return d + ' J=' + unpack2(a[1]).join('/');
    });
  } catch (e) { console.log(TAG + ' FAIL hc: ' + e); }

  // [B] 参考：J 的正确解码
  var bCnt = 0;
  try {
    var jq0 = fac.use('jq0');
    jq0.b.overload('long').implementation = function (size) {
      var r = this.b(size);
      if (bCnt < 8) {
        bCnt++;
        var wh = unpack2(size);
        console.log(TAG + ' [B#' + bCnt + '] J=(w=' + wh[0] + ', h=' + wh[1] + ') -> ' + (r === null ? 'null' : r.getClass().getName()));
      }
      return r;
    };
    console.log(TAG + ' OK jq0.b(long) (J decode fixed)');
  } catch (e) { console.log(TAG + ' FAIL jq0.b: ' + e); }

  console.log(TAG + ' READY - scroll the chat now');
});
