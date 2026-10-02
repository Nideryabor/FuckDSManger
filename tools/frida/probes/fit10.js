// fit10.js —— 第四枪：修表 + 一次问完
// 🐲 尼得亚伯 · 2026-10-02
//
// 前三枪栽在哪（都记我自己头上）：
//   fit7: 钩 android.graphics.Canvas 基类 ⇒ 被 RecordingCanvas 虚分派绕过
//   fit8: 钩对了宿主画布 hc.k/g/f，但用 paint.getShader() 读 shader ⇒ 抛异常被 catch 吞掉
//         ⇒ 静默全跳过 ⇒ 假"零命中"
//   fit9: [E] 自诊断把这事抓出来了（paint=found / shader=(err)）
//         并且知道 sf 的字段：a:Paint  b:int  c:Shader  d:jn0
//         ⇒ **直接读字段，不调 getShader()**
//
// 这一枪一次问四件事：
//   [A] hc 里**所有末参是 sf** 的绘制方法（drawRect/drawRoundRect/drawPath/drawCircle/drawArc/
//       drawLine/saveLayer… 全覆盖）——谁身上挂着我们的 shader、画的矩形是什么
//   [L] Lim9.a(F,J,Lsf)V —— 宿主把 brush 的 shader 装到 paint 上的那一步
//   [S] sf.i(Shader) —— wrapper 的 setShader 全部调用（不只我们的）
//   [B] jq0.b(J) —— 宿主要 shader 时给的尺寸
// 所有异常都打**原文**，绝不再吞。

'use strict';

var TAG = '[FIT10]';
var MAXD = 16, MAXS = 8, MAXL = 8, MAXB = 6;
var nD = 0, nS = 0, nL = 0, nB = 0;
var seenM = {};

function tid() { try { return Process.getCurrentThreadId(); } catch (e) { return -1; } }
function nm(o) { try { return o === null ? 'null' : o.getClass().getName(); } catch (e) { return 'NERR:' + e; } }

function fieldOf(obj, name) {
  try {
    var c = obj.getClass();
    for (var i = 0; i < 8 && c !== null; i++) {
      try { var f = c.getDeclaredField(name); f.setAccessible(true); return f.get(obj); } catch (e) { }
      c = c.getSuperclass();
    }
  } catch (e) { }
  return null;
}
// 在对象（含父类）里找第一个"类型名 == typeName"的字段
function fieldOfType(obj, typeName) {
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
// ★ 真正的 shader：优先读 sf.a（android.graphics.Paint）里的 Shader 字段，退而读 sf.c
function shaderOf(sfw) {
  try {
    var p = fieldOfType(sfw, 'android.graphics.Paint');
    if (p !== null) {
      var s = fieldOfType(p, 'android.graphics.Shader');
      if (s !== null) return s;
    }
  } catch (e) { }
  try { return fieldOf(sfw, 'c'); } catch (e) { }
  return null;
}
function ours(o) { try { return o !== null && o.getClass().getName().indexOf('GmBmpShader') >= 0; } catch (e) { return false; } }

// ★ 读 shader 自己的 local matrix（ob7.i 里有 setLocalMatrix，很可能是它冲掉了我们的铺满矩阵）
function matOf(sh) {
  try {
    if (sh === null) return '(no-shader)';
    var m = Java.use('android.graphics.Matrix').$new();
    sh.getLocalMatrix(m);
    var v = Java.array('float', [0, 0, 0, 0, 0, 0, 0, 0, 0]);
    m.getValues(v);
    return 'sx=' + v[0] + ' sy=' + v[4] + ' tx=' + v[2] + ' ty=' + v[5];
  } catch (e) { return 'MATERR:' + e; }
}

function bits2f(bits) { try { return Java.use('java.lang.Float').intBitsToFloat(bits | 0); } catch (e) { return NaN; } }
function unpack2(v) {
  var hi = 0, lo = 0;
  try {
    if (typeof v === 'number') { hi = Math.floor(v / 4294967296); lo = v % 4294967296; }
    else { var n = BigInt(v.toString()); hi = Number(n >> 32n); lo = Number(n & 0xffffffffn); }
  } catch (e) { return ['?', '?']; }
  return [bits2f(hi), bits2f(lo)];
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

  // ══ [A] hc：所有末参是 sf 的方法 ══
  try {
    var HC = fac.use('hc');
    var methods = HC.class.getDeclaredMethods();
    console.log(TAG + ' hc declaredMethods=' + methods.length);
    var hooked = 0;
    for (var i = 0; i < methods.length; i++) {
      var md = methods[i];
      var ps = md.getParameterTypes();
      if (ps.length < 1) continue;
      if (ps[ps.length - 1].getName() !== 'sf') continue;
      var types = [];
      for (var j = 0; j < ps.length; j++) types.push(ps[j].getName());
      (function (mname, types) {
        try {
          var mw = HC[mname];
          var ov = mw.overload.apply(mw, types);
          ov.implementation = function () {
            var a = arguments;
            var sfw = a[a.length - 1];
            var cnt = (seenM[mname] || 0) + 1;
            seenM[mname] = cnt;
            if (cnt === 1) {
              var sh0 = shaderOf(sfw);
              console.log(TAG + ' [A] first ' + mname + ' arity=' + a.length +
                ' paint=' + nm(fieldOf(sfw, 'a')) + ' shader=' + nm(sh0) + ' ours=' + ours(sh0) + ' mat=' + matOf(sh0));
            }
            var sh = shaderOf(sfw);
            if (ours(sh)) {
              if (nD < MAXD) {
                nD++;
                var desc = '';
                for (var q = 0; q < a.length - 1; q++) desc += a[q] + (q === a.length - 2 ? '' : ',');
                console.log(TAG + ' [D#' + nD + '] tid=' + tid() + ' ' + mname + '(' + desc + ') mat=' + matOf(sh));
              } else nD++;
            }
            switch (a.length) {
              case 3: return mw.call(this, a[0], a[1], a[2]);
              case 5: return mw.call(this, a[0], a[1], a[2], a[3], a[4]);
              case 6: return mw.call(this, a[0], a[1], a[2], a[3], a[4], a[5]);
              case 7: return mw.call(this, a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
              case 8: return mw.call(this, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
              case 9: return mw.call(this, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
            }
            return undefined;
          };
          hooked++;
        } catch (e) { console.log(TAG + ' FAIL ' + mname + ': ' + e); }
      })(mname, types);
    }
    console.log(TAG + ' [A] hooked=' + hooked);
  } catch (e) { console.log(TAG + ' FAIL hc: ' + e); }

  // ══ [L] Lim9.a ══
  try {
    var LM = fac.use('Lim9');
    var la = LM.a;
    la.overload('float', 'long', 'sf').implementation = function (alpha, size, sfw) {
      var r = la.call(this, alpha, size, sfw);
      var wh = unpack2(size);
      var sh = shaderOf(sfw);
      if (nL < MAXL) {
        nL++;
        console.log(TAG + ' [L#' + nL + '] alpha=' + alpha + ' J=(w=' + wh[0] + ',h=' + wh[1] + ') shader=' + nm(sh) + ' ours=' + ours(sh));
      } else nL++;
      return r;
    };
    console.log(TAG + ' OK Lim9.a');
  } catch (e) { console.log(TAG + ' FAIL Lim9.a: ' + e); }

  // ══ [S] sf.i(Shader) ══
  try {
    var SF = fac.use('sf');
    var si = SF.i;
    si.implementation = function (sh) {
      if (nS < MAXS) { nS++; console.log(TAG + ' [S#' + nS + '] sf.i(' + nm(sh) + ') ours=' + ours(sh) + ' tid=' + tid()); }
      else nS++;
      return si.call(this, sh);
    };
    console.log(TAG + ' OK sf.i');
  } catch (e) { console.log(TAG + ' FAIL sf.i: ' + e); }

  // ══ [B] jq0.b ══
  try {
    var jq0 = fac.use('jq0');
    jq0.b.overload('long').implementation = function (size) {
      var r = this.b(size);
      if (nB < MAXB) {
        nB++;
        var wh = unpack2(size);
        console.log(TAG + ' [B#' + nB + '] J=(w=' + wh[0] + ',h=' + wh[1] + ') -> ' + nm(r));
      }
      return r;
    };
    console.log(TAG + ' OK jq0.b');
  } catch (e) { console.log(TAG + ' FAIL jq0.b: ' + e); }

  console.log(TAG + ' READY - scroll the chat now');
});
