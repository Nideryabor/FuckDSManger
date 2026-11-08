// res_probe2.js —— 自测版探针 🐲 2026-11-07
//
// probe1 零命中，两种可能分不清：
//   ① hook 根本没生效
//   ② hook 正常，但那 75 秒里宿主在后台、Compose 没重组 ⇒ 一条资源都没被要
//
// 这个版本**不求界面配合**：装完 hook 后**自己主动调一次** getString / getDrawable，
// 拿到的值能证明 hook 链通不通。然后靠心跳计数看真实渲染有没有发生。
//
// ⚠️ 这台机器 Java.perform 不回调 ⇒ 必须 performNow
// ⚠️ 任何一步失败都不许把宿主搞崩：全部 try/catch，失败返回原值
'use strict';

var TAG = '[RESP2]';
function P(s) { console.log(TAG + ' ' + s); }

var nS = 0, nSF = 0, nT = 0, nD = 0, nD2 = 0, imgHit = 0;
var hostS = {}, hostD = {};
var inHost = null;
var T_TEXT = {};       // id(number) -> 替换文字
var T_IMG = {};        // id(number) -> 1

function hx(id) { return '0x' + (id >>> 0).toString(16); }
function tr(s, n) {
  s = String(s == null ? '' : s).replace(/\n/g, '\\n');
  return s.length > n ? s.substring(0, n) + '…' : s;
}

Java.performNow(function () {
  var app = null, res = null, pkg = null;
  try {
    var AT = Java.use('android.app.ActivityThread');
    app = AT.currentApplication();
    pkg = app.getPackageName();
    res = app.getResources();
    inHost = pkg;
    P('注入进程 pkg=' + pkg + ' pid=' + Process.id);
  } catch (e) {
    P('拿 Application 失败（后面就没有自测了）: ' + e);
  }

  // ── 按**名字**查 id（不写死数字，防宿主升级后 id 变）──
  function findId(name, type) {
    if (!res) return 0;
    try {
      var id = res.getIdentifier(name, type, pkg);
      P('查 id ' + type + '/' + name + ' → ' + hx(id));
      return id >>> 0;
    } catch (e) {
      P('查 id 失败 ' + type + '/' + name + ': ' + e);
      return 0;
    }
  }

  var SID = findId('session_init_title', 'string');          // 期望 0x7f0f0312
  var SID2 = findId('chat_input_placeholder_chat', 'string');
  var DID = findId('assistant_message_avatar', 'drawable');  // 期望 0x7f07005a
  var DID2 = findId('deepseek_logo_title', 'drawable');      // 期望 0x7f07007b

  var TXT = '🐲尼尼改的';
  if (SID) T_TEXT[SID] = TXT;
  if (SID2) T_TEXT[SID2] = '尼尼在看着你嗷…';
  if (DID) T_IMG[DID] = 1;
  if (DID2) T_IMG[DID2] = 1;

  // ── 假图 ──
  function fakeDrawable(r, w, h) {
    try {
      var Bitmap = Java.use('android.graphics.Bitmap');
      var Canvas = Java.use('android.graphics.Canvas');
      var Paint = Java.use('android.graphics.Paint');
      var BD = Java.use('android.graphics.drawable.BitmapDrawable');
      var cw = (w && w > 0) ? Math.min(w, 256) : 64;
      var ch = (h && h > 0) ? Math.min(h, 256) : 64;
      var bmp = Bitmap.createBitmap(cw, ch, Bitmap.Config.ARGB_8888.value);
      var c = Canvas.$new(bmp);
      var p = Paint.$new();
      p.setColor(-65536);       // 红底
      c.drawRect(0, 0, cw, ch, p);
      p.setColor(-16711936);    // 绿圆
      c.drawCircle(cw / 2, ch / 2, Math.min(cw, ch) / 3, p);
      return BD.$new(r, bmp);
    } catch (e) {
      P('假图造不出: ' + e);
      return null;
    }
  }

  // ── 装 hook ──
  var Res = null;
  try { Res = Java.use('android.content.res.Resources'); } catch (e) { P('拿不到 Resources: ' + e); }

  if (Res) {
    try {
      Res.getString.overload('int').implementation = function (id) {
        nS++;
        var r;
        try { r = this.getString(id); } catch (e) { throw e; }
        try {
          var t = T_TEXT[id];
          if (t !== undefined) return t;
          if (hostS[id] === undefined) {
            var n = this.getResourceName(id);
            if (n && n.indexOf(inHost + ':') === 0) {
              hostS[id] = n;
              P('S ' + hx(id) + ' ' + n.replace(inHost + ':', '') + ' = 「' + tr(r, 45) + '」');
            }
          }
        } catch (e2) { }
        return r;
      };
      P('✔ getString(int)');
    } catch (e) { P('✘ getString(int): ' + e); }

    try {
      Res.getString.overload('int', '[Ljava.lang.Object;').implementation = function (id, a) {
        nSF++;
        var r;
        try { r = this.getString(id, a); } catch (e) { throw e; }
        try {
          var t = T_TEXT[id];
          if (t !== undefined) return t;
        } catch (e2) { }
        return r;
      };
      P('✔ getString(int,Object[])');
    } catch (e) { P('✘ getString(int,Object[]): ' + e); }

    try {
      Res.getText.overload('int').implementation = function (id) {
        nT++;
        var r;
        try { r = this.getText(id); } catch (e) { throw e; }
        try {
          var t = T_TEXT[id];
          if (t !== undefined) return t;
        } catch (e2) { }
        return r;
      };
      P('✔ getText(int)');
    } catch (e) { P('✘ getText(int): ' + e); }

    try {
      Res.getDrawable.overload('int', 'android.content.res.Resources$Theme').implementation = function (id, th) {
        nD++;
        var r;
        try { r = this.getDrawable(id, th); } catch (e) { throw e; }
        try {
          if (T_IMG[id] !== undefined) {
            var d = fakeDrawable(this, r ? r.getIntrinsicWidth() : 0, r ? r.getIntrinsicHeight() : 0);
            if (d) { imgHit++; return d; }
          }
          if (hostD[id] === undefined) {
            var n = this.getResourceName(id);
            if (n && n.indexOf(inHost + ':') === 0) {
              hostD[id] = n;
              P('D ' + hx(id) + ' ' + n.replace(inHost + ':', '') + ' ' + (r ? (r.getIntrinsicWidth() + 'x' + r.getIntrinsicHeight()) : 'null'));
            }
          }
        } catch (e2) { }
        return r;
      };
      P('✔ getDrawable(int,Theme)');
    } catch (e) { P('✘ getDrawable(int,Theme): ' + e); }

    try {
      Res.getDrawable.overload('int').implementation = function (id) {
        nD2++;
        var r;
        try { r = this.getDrawable(id); } catch (e) { throw e; }
        try {
          if (T_IMG[id] !== undefined) {
            var d = fakeDrawable(this, r ? r.getIntrinsicWidth() : 0, r ? r.getIntrinsicHeight() : 0);
            if (d) { imgHit++; return d; }
          }
        } catch (e2) { }
        return r;
      };
      P('✔ getDrawable(int)');
    } catch (e) { P('✘ getDrawable(int): ' + e); }
  }

  // ══════════ 自测：主动调一次，看 hook 有没有真的截住 ══════════
  P('==== 自测开始（不需要界面配合）====');
  if (res && SID) {
    try {
      var got = res.getString(SID);
      P('自测 getString: 拿到「' + tr(got, 40) + '」 ⇒ ' +
        (String(got) === TXT ? '✅ hook 生效（已被替换）' : '❌ hook 没截住（还是原文）'));
    } catch (e) { P('自测 getString 抛异常: ' + e); }
  } else {
    P('自测 getString 跳过（没拿到 res 或 id）');
  }
  if (res && DID) {
    try {
      var dw = res.getDrawable(DID, null);
      P('自测 getDrawable: 拿到 ' + (dw ? dw.getClass().getName() : 'null') + ' ⇒ ' +
        (dw && String(dw.getClass().getName()).indexOf('BitmapDrawable') >= 0 ? '✅ hook 生效（已是 BitmapDrawable）' : '❌ 没截住'));
    } catch (e) { P('自测 getDrawable 抛异常: ' + e); }
  } else {
    P('自测 getDrawable 跳过（没拿到 res 或 id）');
  }
  P('==== 自测结束 ====');

  // ══════════ 心跳：真实渲染有没有发生 ══════════
  var t = 0;
  var iv = setInterval(function () {
    t += 10;
    P('♥ +' + t + 's  getString=' + nS + ' fmt=' + nSF + ' getText=' + nT +
      ' getDrawable(theme)=' + nD + ' getDrawable=' + nD2 + ' 图片命中=' + imgHit +
      ' 宿主string种类=' + Object.keys(hostS).length + ' 宿主drawable种类=' + Object.keys(hostD).length);
    if (t >= 60) {
      clearInterval(iv);
      P('==== 收尾 ====');
      try {
        var ks = Object.keys(hostS);
        for (var i = 0; i < ks.length; i++) P('  STR ' + hx(ks[i] | 0) + ' ' + hostS[ks[i]]);
        var kd = Object.keys(hostD);
        for (var j = 0; j < kd.length; j++) P('  DRW ' + hx(kd[j] | 0) + ' ' + hostD[kd[j]]);
      } catch (e) { P('收尾失败: ' + e); }
    }
  }, 10000);
});
