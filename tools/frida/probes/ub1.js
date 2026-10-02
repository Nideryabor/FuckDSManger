// ub1.js —— 用户气泡「定点重写」为什么没生效 🐲 2026-10-02
// 只读探测：只打日志，不改任何返回值。
Java.performNow(function () {
  var L = function (s) { console.log(s); };
  var U = function (n) { try { return Java.use(n); } catch (e) { return null; } };

  // ① ubMod 到底有没有被调用（这是"补底"那一步）
  var GmBubble = U('com.nidyaber.fuckdsmanger.gm.GmBubble');
  if (GmBubble) {
    try {
      GmBubble.ubMod.overload('java.lang.ClassLoader', 'java.lang.Object').implementation = function (cl, shape) {
        L('[ubMod] 进入 shape=' + (shape === null ? 'null' : shape.getClass().getName()));
        var r = this.ubMod(cl, shape);
        L('[ubMod] 返回 ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
      L('[ok] ubMod 已挂钩');
    } catch (e) { L('[!] ubMod: ' + e); }
    try {
      GmBubble.shape.overload('java.lang.ClassLoader').implementation = function (cl) {
        var r = this.shape(cl);
        L('[shape] = ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
    } catch (e) {}
    try {
      GmBubble.hostShape.overload('java.lang.ClassLoader').implementation = function (cl) {
        var r = this.hostShape(cl);
        L('[hostShape] = ' + (r === null ? 'null' : r.getClass().getName()));
        return r;
      };
    } catch (e) {}
  }

  // ② qk7.D / qk7.C 被调用时：参数类型 + 调用栈里的 caller
  var qk7 = U('qk7');
  if (qk7) {
    ['D', 'C'].forEach(function (nm) {
      try {
        qk7[nm].overloads.forEach(function (ov) {
          ov.implementation = function () {
            var a = Array.prototype.slice.call(arguments);
            var desc = a.map(function (x) {
              return x === null ? 'null' : (x.getClass ? x.getClass().getName() : String(x));
            }).join(' | ');
            L('[qk7.' + nm + '] n=' + a.length + '  ' + desc);
            return ov.apply(this, arguments);
          };
        });
        L('[ok] qk7.' + nm + ' 已挂钩');
      } catch (e) { L('[!] qk7.' + nm + ': ' + e); }
    });
  } else {
    L('[!] 找不到 qk7');
  }

  // ③ 顺带看看 ub() 里那个 caller 判据拿到的到底是什么
  var GmUtil = U('com.nidyaber.fuckdsmanger.gm.GmUtil');
  if (GmUtil) {
    try {
      var n = 0;
      GmUtil.caller.implementation = function () {
        var r = this.caller();
        if (n < 40) { n++; L('[caller] ' + r); }
        return r;
      };
      L('[ok] GmUtil.caller 已挂钩（前 40 次）');
    } catch (e) { L('[!] caller: ' + e); }
  }

  L('[ub1 done]');
});
