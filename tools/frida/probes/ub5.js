// ub5.js —— 一次问清「用户气泡到底走哪条路」🐲 2026-10-31
//
// 背景：模块里那些 logOnce 按内容去重，看不清 x98.t 到底被调用过没有。
// 这里用 frida 直接挂宿主里的 x98.t / x98.s / GmBubble.ubMod，
// **每次调用都数一次**，最后统一汇报。
//
// 只读：除了计数不做任何修改（不 replace 返回值）。
// 目的只有三个：
//   ① x98.t 到底被调了多少次？参数里的颜色是多少？
//   ② 用户气泡渲染时 x98.t 的 caller 是谁（跟 uCaller() 期望的 wb0.e 对不对）
//   ③ GmBubble.ubMod / GmBubblePaintHook.ub 到底有没有被调用

Java.perform(function () {
  var L = function (s) { console.log(s); };
  var U = function (n) { try { return Java.use(n); } catch (e) { return null; } };

  // ───────── ① 计数桶 ─────────
  var cnt = {};             // 方法名 -> 次数
  var colorSeen = {};       // x98.t 的参数颜色（去重）
  var callers = {};         // x98.t 的 caller（去重）
  var MAXLOG = 40;          // 每条最多打这么多行，防止刷爆

  function bump(k) { cnt[k] = (cnt[k] || 0) + 1; return cnt[k]; }
  function once(map, k) { if (!map[k]) { map[k] = 1; return true; } return false; }

  // ───────── ② 找 x98.t / x98.s（按签名，不认名字）─────────
  // 宿主 2.7.2 的 Modifier 扩展桶：x98 / qu7 / z2c / g83 / j37 / zi9
  var buckets = ['x98', 'qu7', 'z2c', 'g83', 'j37', 'zi9'];
  var hooked = [];

  buckets.forEach(function (bn) {
    var C = U(bn);
    if (!C) return;
    C.class.getDeclaredMethods().forEach(function (m) {
      try {
        var name = m.getName();
        var ps = m.getParameterTypes();
        var ret = m.getReturnType().getName();
        // 颜色版： (Modifier, long, Shape) -> Modifier
        if (ps.length === 3 && ps[1].getName() === 'long' && ret === 'androidx.compose.ui.Modifier') {
          var ov = C[name].overload('androidx.compose.ui.Modifier', 'long', 'androidx.compose.ui.graphics.Shape');
          ov.implementation = function (mod, color, shape) {
            var n = bump(bn + '.' + name + '(色)');
            if (n <= MAXLOG) {
              var cs = '0x' + (color >>> 0).toString(16);
              L('[x98色] ' + bn + '.' + name + ' #' + n + ' color=' + color + ' (' + cs + ') shape='
                + (shape === null ? 'null' : shape.getClass().getName()));
              if (once(colorSeen, 'c' + color)) {
                var st = Java.use('android.util.Log').getStackTraceString(Java.use('java.lang.Exception').$new());
                var lines = st.split('\n');
                L('     └ 首次见这个颜色，调用栈前 8 层：');
                for (var i = 1; i < Math.min(9, lines.length); i++) L('       ' + lines[i].trim());
              }
            }
            return this[name](mod, color, shape);
          };
          hooked.push(bn + '.' + name + '(色)');
        }
        // 刷子版： (Modifier, Brush, Shape, int) -> Modifier
        if (ps.length === 4 && ps[3].getName() === 'int' && ret === 'androidx.compose.ui.Modifier') {
          var ov2 = C[name].overload('androidx.compose.ui.Modifier',
              ps[1].getName(), 'androidx.compose.ui.graphics.Shape', 'int');
          ov2.implementation = function (mod, brush, shape, a) {
            var n2 = bump(bn + '.' + name + '(刷)');
            if (n2 <= MAXLOG) L('[x98刷] ' + bn + '.' + name + ' #' + n2 + ' alpha=' + a);
            return this[name](mod, brush, shape, a);
          };
          hooked.push(bn + '.' + name + '(刷)');
        }
      } catch (e) { }
    });
  });

  L('[ok] 按签名挂上的原语：' + (hooked.length ? hooked.join(', ') : '（一个都没有！）'));

  // ───────── ③ 模块自己的两个入口 ─────────
  var GmBubble = U('com.nidyaber.fuckdsmanger.gm.GmBubble');
  if (GmBubble) {
    try {
      GmBubble.shape.overload('java.lang.ClassLoader').implementation = function (cl) {
        var r = this.shape(cl);
        if (bump('GmBubble.shape') <= MAXLOG)
          L('[shape] 调用 #' + cnt['GmBubble.shape'] + ' → ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
    } catch (e) { L('[!] shape: ' + e); }
    try {
      GmBubble.ubMod.overload('java.lang.ClassLoader', 'java.lang.Object').implementation = function (cl, mod) {
        var n = bump('GmBubble.ubMod');
        if (n <= MAXLOG) L('[ubMod] 调用 #' + n + ' mod=' + (mod === null ? 'null' : mod.getClass().getName()));
        var r = this.ubMod(cl, mod);
        if (n <= MAXLOG) L('[ubMod] 返回 ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
    } catch (e) { L('[!] ubMod: ' + e); }
    try {
      GmBubble.wrap.overload('java.lang.ClassLoader', 'java.lang.Object').implementation = function (cl, mod) {
        var n = bump('GmBubble.wrap');
        if (n <= 10) L('[wrap] 调用 #' + n + ' mod=' + (mod === null ? 'null' : mod.getClass().getName()));
        var r = this.wrap(cl, mod);
        if (n <= 10) L('[wrap] 返回 ' + (r === null ? 'null' : (r === mod ? '原样' : r.getClass().getName())));
        return r;
      };
    } catch (e) { L('[!] wrap: ' + e); }
  } else {
    L('[!] GmBubble 类没找到');
  }

  var PH = U('com.nidyaber.fuckdsmanger.gm.GmBubblePaintHook');
  if (PH) {
    try {
      PH.ub.overload('de.robv.android.xposed.XC_MethodHook$MethodHookParam').implementation = function (p) {
        var n = bump('PaintHook.ub');
        if (n <= MAXLOG) L('[PaintHook.ub] 调用 #' + n);
        return this.ub(p);
      };
    } catch (e) { L('[!] PaintHook.ub: ' + e); }
    L('[ok] GmBubblePaintHook 已挂钩');
  } else {
    L('[!] GmBubblePaintHook 类没找到（可能整个类没加载 —— VerifyError？）');
  }

  // ───────── ④ 15 秒后统一汇报 ─────────
  setTimeout(function () {
    L('');
    L('════════ 汇总 ════════');
    var keys = Object.keys(cnt).sort();
    if (!keys.length) L('（一次都没被调用）');
    keys.forEach(function (k) { L('  ' + k + '  ×' + cnt[k]); });
    L('════════════════════');
  }, 15000);
});
