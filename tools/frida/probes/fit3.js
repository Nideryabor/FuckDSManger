// fit3.js —— 定位「AI 气泡图底 下半空白」
// 🐲 尼得亚伯 · 2026-10-02
//
// 要回答的唯一问题：
//   jq0.b(J) / Lim9.a(F,J,Lsf;) 收到的那个 J，**到底是不是真实的绘制尺寸**？
//   （如果它和实际画出来的高度差很多 ⇒ "下半个空白"就是"按错尺寸算了矩阵"的锅）
//
// 用法：
//   sh tools/frida/frida.sh watch com.deepseek.chat.a tools/frida/probes/fit3.js
//
// 注意：这台机器 Java.perform 不回调 ⇒ 必须用 Java.performNow
'use strict';

var TAG = '[FIT3]';

function bits2f(i) {
  var dv = new DataView(new ArrayBuffer(4));
  dv.setUint32(0, i >>> 0);
  return dv.getFloat32(0);
}

// frida 给 long 参数可能是 number 也可能是 Int64，两种都兜
function unpackSize(v) {
  try {
    if (v !== null && typeof v === 'object' && typeof v.shr === 'function') {
      var hi = v.shr(32).and(0xffffffff).toNumber();
      var lo = v.and(0xffffffff).toNumber();
      return bits2f(hi).toFixed(1) + 'x' + bits2f(lo).toFixed(1);
    }
    // number：高 32 = floor(v / 2^32)，低 32 = v mod 2^32
    var n = Number(v);
    if (!isFinite(n)) return 'raw=' + v;
    var hiN = Math.floor(n / 4294967296) % 4294967296;
    var loN = n % 4294967296;
    return bits2f(hiN).toFixed(1) + 'x' + bits2f(loN).toFixed(1);
  } catch (e) {
    return 'raw=' + v;
  }
}

var N = 0;
var LIMIT = 300;                 // 限流：别把日志刷爆
function say(what, size, extra) {
  N++;
  if (N > LIMIT) return;
  console.log(TAG + ' #' + N + ' ' + what + '  size=' + unpackSize(size) + (extra || ''));
}

Java.performNow(function () {
  console.log(TAG + ' 已注入 · arch=' + Process.arch + ' · pid=' + Process.id);

  // ① 缓存/绘制层：Lim9.a(float alpha, long size, sf paint)
  //    Lim9 = Compose 的 ShaderBrush（父类），这里的 size 是**绘制侧真正传下来的**
  try {
    var Lim9 = Java.use('Lim9');
    Lim9.a.overload('float', 'long', 'sf').implementation = function (alpha, size, paint) {
      say('Lim9.a ', size);
      return this.a(alpha, size, paint);
    };
    console.log(TAG + ' ✓ hook Lim9.a(float,long,sf)');
  } catch (e) {
    console.log(TAG + ' ✗ Lim9.a: ' + e);
  }

  // ② 取值层：jq0.b(long) —— 我们模块的 GmBubbleFitHook 也挂在这
  try {
    var jq0 = Java.use('jq0');
    jq0.b.overload('long').implementation = function (size) {
      var r = this.b(size);
      var cls = (r === null) ? 'null' : r.getClass().getName();
      say('jq0.b  ', size, '  → 返回 ' + cls);
      return r;
    };
    console.log(TAG + ' ✓ hook jq0.b(long)');
  } catch (e) {
    console.log(TAG + ' ✗ jq0.b: ' + e);
  }

  // ③ 旁证：ChatMessageCell 收到的 Modifier 是不是我们的（判据 = GmBmpShader / RuntimeShader）
  //    i93.i(ILsf6;Lo32;Lns;Lmr;Lx97;Lyx4;I)V 的第 6 参就是 Modifier
  try {
    var i93 = Java.use('i93');
    i93.i.overload('int', 'sf6', 'o32', 'ns', 'mr', 'x97', 'yx4', 'int').implementation = function () {
      var mod = arguments[5];
      var tag = 'null';
      try {
        if (mod !== null) tag = mod.getClass().getName() + '@' + mod.hashCode();
      } catch (e) { }
      if (N + 1000 > 0) { /* 保留位 */ }
      console.log(TAG + ' · ChatMessageCell modifier=' + tag);
      return this.i.apply(this, arguments);
    };
    console.log(TAG + ' ✓ hook i93.i（ChatMessageCell）');
  } catch (e) {
    console.log(TAG + ' ✗ i93.i: ' + e);
  }
});
