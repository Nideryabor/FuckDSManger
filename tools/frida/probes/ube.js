// ubd.js —— 实时打印，不靠 setTimeout；专盯「用户气泡渲染时」的 background
Java.perform(function () {
  var L = function (s) { console.log(s); };
  var loaders = [];
  Java.enumerateClassLoaders({ onMatch: function (l) { loaders.push(l); }, onComplete: function () {} });
  var host = null;
  for (var i = 0; i < loaders.length; i++) {
    try { loaders[i].loadClass('com.deepseek.chat.MainActivity'); host = loaders[i]; break; } catch (e) {}
  }
  if (!host) { L('[!] no host'); return; }
  Java.classFactory.loader = host;
  L('[ok] host loader 就位');

  var classes = ['x98','vcc','gq9','z6a','px6','l23','nr0','fq5','z07','x34',
                 'dma','bn3','ow5','g83','qx6','zi9','o10','ru7'];
  var hooked = [];

  classes.forEach(function (cn) {
    var C;
    try { C = Java.use(cn); } catch (e) { return; }
    var names = {};
    try {
      C.class.getDeclaredMethods().forEach(function (jm) { names[jm.getName()] = 1; });
    } catch (e) { return; }
    Object.keys(names).forEach(function (nm) {
      try {
        if (!C[nm] || !C[nm].overloads) return;
        C[nm].overloads.forEach(function (ov) {
          var at = ov.argumentTypes;
          if (at.length < 2) return;
          if (at[0].className !== ov.returnType.className) return;
          var key = cn + '.' + nm;
          // ★ 排除已知噪音（AI 气泡走 wrap，不经过这些）
          ov.implementation = function () {
            var args = Array.prototype.slice.call(arguments);
            var ex = '';
            for (var i = 1; i < Math.min(args.length, 4); i++) {
              if (args[i] === null) { ex += ' null'; continue; }
              var ty = typeof args[i];
              if (ty === 'number') ex += (Math.abs(args[i]) > 65536 ? ' 0x' + (args[i] >>> 0).toString(16) : ' ' + args[i]);
              else { try { ex += ' ' + args[i].getClass().getSimpleName(); } catch (e) { ex += ' ?'; } }
            }
            // 前 3 次全打，之后按 key 限流
            if (!globalThis.__n) globalThis.__n = {};
            var n = (globalThis.__n[key] = (globalThis.__n[key] || 0) + 1);
            if (n <= 6) L('★[' + key + '] #' + n + ex);
            return ov.call.apply(ov, [this].concat(args));
          };
          hooked.push(key + '(' + at.map(function (t) { return t.className; }).join(',') + ')');
        });
      } catch (e) { }
    });
  });
  L('[ok] 挂上 ' + hooked.length + ' 个');
  L('[list] ' + hooked.join(' | '));
});
