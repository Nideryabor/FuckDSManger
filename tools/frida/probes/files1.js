// files1.js —— 看宿主 filesDir 里那几张图到底在不在 🐲 2026-10-02
Java.perform(function () {
  var L = function (s) { console.log(s); };
  try {
    var AT = Java.use('android.app.ActivityThread');
    var app = AT.currentApplication();
    var ctx = app.getApplicationContext();
    var dir = ctx.getFilesDir().getAbsolutePath();
    L('[filesDir] ' + dir);
    var F = Java.use('java.io.File');
    ['fuckds_bubble.png', 'fuckds_ububble.png', 'fuckds_bg.png',
      'fuckds_avatar.png', 'fuckds_uavatar.png'].forEach(function (n) {
        var x = F.$new(dir + '/' + n);
        var ex = x.exists();
        L('  ' + n + '  exists=' + ex + '  len=' + (ex ? x.length() : -1));
      });
  } catch (e) { L('[!] ' + e); }
  L('[files1 done]');
});
