// dex1.js —— 宿主里有没有「动态加载的 dex」？（决定要不要上内存转储）
Java.performNow(function () {
  var L = function (s) { console.log(s); };

  // ── [A] ClassLoader 类型分布 ──
  var ls = [];
  try { ls = Java.enumerateClassLoadersSync(); } catch (e) {}
  var kinds = {};
  for (var i = 0; i < ls.length; i++) {
    var n = "?";
    try { n = ls[i].getClass().getName(); } catch (e) {}
    kinds[n] = (kinds[n] || 0) + 1;
  }
  L("[A] ClassLoader 共 " + ls.length + " 个，类型分布：");
  Object.keys(kinds).sort().forEach(function (k) { L("      " + kinds[k] + " × " + k); });

  // ── [B] InMemoryDexClassLoader 实例（= 运行时才有的 dex）──
  L("");
  var cnt = 0;
  try {
    Java.choose("dalvik.system.InMemoryDexClassLoader", {
      onMatch: function (x) {
        cnt++;
        if (cnt <= 8) {
          var s = "?";
          try { s = x.toString(); } catch (e) {}
          L("      #" + cnt + "  " + s.slice(0, 140));
        }
      },
      onComplete: function () { L("[B] InMemoryDexClassLoader 实例数 = " + cnt); }
    });
  } catch (e) { L("[B] choose 失败: " + e); }

  // ── [C] 已加载类里「单段短名」有多少（R8 类名 + 可能的随机名）──
  var all = Java.enumerateLoadedClassesSync();
  var rnd = all.filter(function (c) {
    if (c.indexOf(".") >= 0) return false;
    if (c.indexOf("[") === 0) return false;
    return c.length >= 3 && c.length <= 24 && /^[A-Za-z][A-Za-z0-9_$]*$/.test(c);
  });
  L("");
  L("[C] 已加载类总数 = " + all.length);
  L("    其中「单段短名」= " + rnd.length);
  L("    前 40 个：");
  L("      " + rnd.slice(0, 40).join(" "));

  // ── [D] 宿主那几个「随机名」类，在不在已加载表里 ──
  L("");
  L("[D] 找那几个可疑名字（Praimoork / MootuntShedath 之类）");
  var sus = all.filter(function (c) {
    return /praim|mootunt|shedath|moor/i.test(c);
  });
  if (sus.length === 0) L("      （这次没找到 —— 它们是运行时生成的）");
  else sus.slice(0, 10).forEach(function (c) { L("      " + c); });

  L("");
  L("[z] dex1 done");
});
