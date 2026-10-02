// fit9.js —— 第三问：我们的图，到底是【paint 的 shader】画的，还是【RenderEffect(RuntimeShader)】画的？
// 🐲 尼得亚伯 · 2026-10-02
//
// fit8 的真机结论：
//   [C] hc.k（宿主 AndroidCanvas.drawRect）涨到 #1000 ⇒ 热路径对照组有效，矩形在画
//   [B] J=(641,161) / (1440,2058) / (1440,7546)，每次都返回我们的 GmBmpShader
//   [D] 依然零命中 ⇒ 用我们 shader 的 drawRect/drawRoundRect/drawPath **一次都没有**
// ⇒ 排除"钩错面"（hc.k 静态查实就是 drawRect）。
//   剩下两个可能：
//     (1) 我的探针读不到 paint（反射取字段失败）—— 这次带自诊断 [E] 排除
//     (2) ★ 图根本不是走 paint 画的：宿主把 brush 的 **RuntimeShader** 当
//         RenderEffect 用（3.42.31 我们往里 setInputBuffer 塞 BitmapShader 才让图露面），
//         而 jq0.b(J) 的返回值只被塞进一个"没人画"的 paint
//
// 这一版同时钉两边：
//   [E] hc.k 前 6 次：能不能读到 Paint？读到的话 shader 是什么（自诊断）
//   [W] ci.w() / ti7.w() 的返回值类名 ← 静态已知 b(J) 的 4 个调用点里有两个是这种 w()
//   [R] RenderEffect.createShaderEffect / createRuntimeShaderEffect 收到的是不是我们的
//   [S] sf.i(Shader)：我们的 shader 被装到 paint 上的次数（装不上/装上了）
'use strict';

var TAG = '[FIT9]';
var nK = 0, nW1 = 0, nW2 = 0, nS = 0, nHit = 0, nE = 0;
var mark = { 1: 1, 10: 1, 100: 1, 1000: 1 };

function tid() { try { return Process.getCurrentThreadId(); } catch (e) { return -1; } }

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
function fieldsDump(obj, max) {
  var out = [];
  try {
    var c = obj.getClass();
    if (c === null) return '?';
    out.push('cls=' + c.getName());
    var fs = c.getDeclaredFields();
    for (var j = 0; j < fs.length && out.length <= max; j++) {
      try { out.push(fs[j].getName() + ':' + fs[j].getType().getName()); } catch (e) { }
    }
  } catch (e) { out.push('(dump-fail:' + e + ')'); }
  return out.join(' ');
}
function shaderTagOf(paint) {
  try {
    if (paint === null) return '(null-paint)';
    var sh = paint.getShader();
    if (sh === null) return '(shader=null)';
    var n = sh.getClass().getName();
    return (n.indexOf('GmBmpShader') >= 0 ? '★OUT★' : n);
  } catch (e) { return '(err)'; }
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

  var ourShaderMap = null;
  try {
    var GB = fac.use('com.nidyaber.fuckdsmanger.gm.GmBubble');
    ourShaderMap = GB.sBmpShaderMap.value;
    console.log(TAG + ' sBmpShaderMap=' + (ourShaderMap === null ? 'null' : 'ok'));
  } catch (e) { console.log(TAG + ' FAIL sBmpShaderMap: ' + e); }

  function isOurs(obj) {
    try {
      if (obj === null) return false;
      var n = obj.getClass().getName();
      if (n.indexOf('GmBmpShader') >= 0) return true;
      if (ourShaderMap !== null && ourShaderMap.containsKey(obj)) return true;
    } catch (e) { }
    return false;
  }

  // ── [C][D][E] 宿主 AndroidCanvas.drawRect ──
  try {
    var HC = fac.use('hc');
    var mk = HC.k;
    mk.implementation = function (l, t, r, b, sf) {
      nK++;
      if (mark[nK] === 1) { console.log(TAG + ' [C] ALIVE hc.k #' + nK); delete mark[nK]; }
      if (nE < 6) {
        nE++;
        var p = null;
        try { p = findFieldOfType(sf, 'android.graphics.Paint'); } catch (e) { }
        console.log(TAG + ' [E#' + nE + '] paint=' + (p === null ? 'NOT-FOUND' : 'found') +
          ' shader=' + (p === null ? '-' : shaderTagOf(p)) + ' | ' + fieldsDump(sf, 6));
      }
      var pp = null;
      try { pp = findFieldOfType(sf, 'android.graphics.Paint'); } catch (e) { }
      if (pp !== null) {
        var tag = shaderTagOf(pp);
        if (tag.indexOf('★OUT★') >= 0) {
          if (nHit < 14) {
            nHit++;
            console.log(TAG + ' [D#' + nHit + '] tid=' + tid() + ' drawRect rect=(' + l + ',' + t + ',' + r + ',' + b +
              ') size=(' + (r - l) + ',' + (b - t) + ') counts k=' + nK);
          } else nHit++;
        }
      }
      return mk.call(this, l, t, r, b, sf);
    };
    console.log(TAG + ' OK hc.k');
  } catch (e) { console.log(TAG + ' FAIL hc.k: ' + e); }

  // ── [W] b(J) 的另外两个调用点：ci.w() / ti7.w() 返回什么 ──
  function hookW(clsName, tag) {
    try {
      var C = fac.use(clsName);
      var m = C.w;
      m.implementation = function () {
        var r = m.call(this);
        if (tag === 'ci' ? nW1 < 6 : nW2 < 6) {
          if (tag === 'ci') nW1++; else nW2++;
          console.log(TAG + ' [' + tag + '] w() -> ' + (r === null ? 'null' : r.getClass().getName()) +
            ' ours=' + isOurs(r));
        } else { if (tag === 'ci') nW1++; else nW2++; }
        return r;
      };
      console.log(TAG + ' OK ' + clsName + '.w()');
    } catch (e) { console.log(TAG + ' FAIL ' + clsName + '.w: ' + e); }
  }
  hookW('ci', 'ci');
  hookW('ti7', 'ti7');

  // ── [R] RenderEffect 的两个创建口 ──
  try {
    var RE = Java.use('android.graphics.RenderEffect');
    try {
      RE.createShaderEffect.overload('android.graphics.Shader').implementation = function (sh) {
        console.log(TAG + ' [R] createShaderEffect(' + (sh === null ? 'null' : sh.getClass().getName()) + ') ours=' + isOurs(sh));
        return this.createShaderEffect(sh);
      };
      console.log(TAG + ' OK RenderEffect.createShaderEffect');
    } catch (e) { console.log(TAG + ' FAIL createShaderEffect: ' + e); }
    try {
      RE.createRuntimeShaderEffect.overload('android.graphics.RuntimeShader', 'java.lang.String').implementation = function (rs, nm) {
        console.log(TAG + ' [R] createRuntimeShaderEffect(' + (rs === null ? 'null' : rs.getClass().getName()) + ', "' + nm + '") ours=' + isOurs(rs));
        return this.createRuntimeShaderEffect(rs, nm);
      };
      console.log(TAG + ' OK RenderEffect.createRuntimeShaderEffect');
    } catch (e) { console.log(TAG + ' FAIL createRuntimeShaderEffect: ' + e); }
  } catch (e) { console.log(TAG + ' FAIL RenderEffect: ' + e); }

  // ── [S] 宿主 paint wrapper 的 setShader：我们的 shader 被装上去了吗 ──
  try {
    var SF = fac.use('sf');
    var mi = SF.i;
    mi.implementation = function (sh) {
      var ours = isOurs(sh);
      if (ours && nS < 8) {
        nS++;
        console.log(TAG + ' [S#' + nS + '] sf.i(' + (sh === null ? 'null' : sh.getClass().getName()) + ') ★装上了★ tid=' + tid());
      } else if (ours) nS++;
      return mi.call(this, sh);
    };
    console.log(TAG + ' OK sf.i(Shader)');
  } catch (e) { console.log(TAG + ' FAIL sf.i: ' + e); }

  // ── [B] J（参考）──
  function bits2f(bits) { try { return Java.use('java.lang.Float').intBitsToFloat(bits | 0); } catch (e) { return NaN; } }
  function unpack2(v) {
    var hi = 0, lo = 0;
    try {
      if (typeof v === 'number') { hi = Math.floor(v / 4294967296); lo = v % 4294967296; }
      else { var n = BigInt(v.toString()); hi = Number(n >> 32n); lo = Number(n & 0xffffffffn); }
    } catch (e) { return ['?', '?']; }
    return [bits2f(hi), bits2f(lo)];
  }
  var bCnt = 0;
  try {
    var jq0 = fac.use('jq0');
    jq0.b.overload('long').implementation = function (size) {
      var r = this.b(size);
      if (bCnt < 6) {
        bCnt++;
        var wh = unpack2(size);
        console.log(TAG + ' [B#' + bCnt + '] J=(w=' + wh[0] + ', h=' + wh[1] + ') -> ' + (r === null ? 'null' : r.getClass().getName()));
      }
      return r;
    };
    console.log(TAG + ' OK jq0.b(long)');
  } catch (e) { console.log(TAG + ' FAIL jq0.b: ' + e); }

  console.log(TAG + ' READY - scroll the chat now');
});
