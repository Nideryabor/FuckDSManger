// res_probe3.js —— 首屏图片路径判定 + 修掉 probe2 的三个 bug 🐲 2026-11-07
//
// probe2 的结论与遗留：
//   ✅ 文字：getString 是唯一漏斗（60 秒 1406 次命中，44 个宿主 string 带名字+值）
//   ⚠️ 图片：getDrawable 真实调用 0 次 —— 因为 painterResource 包在 remember 里，
//            attach 上去时界面早画完了。**必须趁首屏渲染时挂**
//   🐛 3 个 bug 本版已修：
//      ① getText 返回 JS string 不被接受（要 CharSequence）⇒ 用 SpannedString 包
//      ② Bitmap.Config 是内部类 ⇒ Java.use('android.graphics.Bitmap$Config')
//      ③ 上面①导致的自测 NPE
//
// 本版多挂 4 个图片漏斗，用来判定宿主图片到底走哪条：
//   Resources.getDrawable(int[,Theme]) / BitmapFactory.decodeResource(x2)
//   Context.getDrawable(int) / ResourcesCompat.getDrawable(...)
//
// ⚠️ Java.perform 不回调 ⇒ performNow
'use strict';

var TAG = '[RESP3]';
function P(s) { console.log(TAG + ' ' + s); }

var nS = 0, nSF = 0, nT = 0, nD = 0, nD2 = 0, nBF = 0, nCtxD = 0, nRC = 0;
var hostS = {}, hostD = {}, imgSeen = {};
var inHost = null;
var T_TEXT = {};
var T_IMG = {};
var TXT = '🐲尼尼改的';

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
    P('拿 Application 失败: ' + e);
  }

  function findId(name, type) {
    if (!res) return 0;
    try {
      var id = res.getIdentifier(name, type, pkg);
      return id >>> 0;
    } catch (e) { return 0; }
  }

  var SID = findId('session_init_title', 'string');
  var SID2 = findId('chat_input_placeholder_chat', 'string');
  var DID = findId('assistant_message_avatar', 'drawable');
  var DID2 = findId('deepseek_logo_title', 'drawable');
  P('靶子: S=' + hx(SID) + '/' + hx(SID2) + ' D=' + hx(DID) + '/' + hx(DID2));

  if (SID) T_TEXT[SID] = TXT;
  if (SID2) T_TEXT[SID2] = '尼尼在看着你嗷…';
  if (DID) T_IMG[DID] = 1;
  if (DID2) T_IMG[DID2] = 1;

  // ── 假图（修：Bitmap$Config 是内部类）──
  var Bitmap = null, Canvas = null, Paint = null, BD = null, Cfg = null;
  try {
    Bitmap = Java.use('android.graphics.Bitmap');
    Canvas = Java.use('android.graphics.Canvas');
    Paint = Java.use('android.graphics.Paint');
    BD = Java.use('android.graphics.drawable.BitmapDrawable');
    Cfg = Java.use('android.graphics.Bitmap$Config');
    P('✔ 图形类就位 Config=' + Cfg.ARGB_8888.value);
  } catch (e) {
    P('✘ 图形类失败: ' + e);
  }

  function fakeDrawable(r, w, h) {
    if (!Bitmap || !BD || !Cfg) return null;
    try {
      var cw = (w && w > 0) ? Math.min(w, 256) : 64;
      var ch = (h && h > 0) ? Math.min(h, 256) : 64;
      var bmp = Bitmap.createBitmap(cw, ch, Cfg.ARGB_8888.value);
      var c = Canvas.$new(bmp);
      var p = Paint.$new();
      p.setColor(-65536);                 // 红底
      c.drawRect(0, 0, cw, ch, p);
      p.setColor(-16711936);              // 绿圆
      c.drawCircle(cw / 2, ch / 2, Math.min(cw, ch) / 3, p);
      return BD.$new(r, bmp);
    } catch (e) {
      P('假图失败: ' + e);
      return null;
    }
  }

  function noteDrawable(tag, r, id) {
    try {
      if (hostD[id] === undefined && inHost) {
        var n = r.getResourceName(id);
        if (n && n.indexOf(inHost + ':') === 0) {
          hostD[id] = n;
          P('D[' + tag + '] ' + hx(id) + ' ' + n.replace(inHost + ':', '')
            + ' ' + (r ? (r.getIntrinsicWidth() + 'x' + r.getIntrinsicHeight()) : 'null')
            + ' cls=' + (r ? String(r.getClass().getSimpleName()) : '-'));
        }
      }
    } catch (e) { }
  }

  var Res = null;
  try { Res = Java.use('android.content.res.Resources'); } catch (e) { P('无 Resources: ' + e); }

  if (Res) {
    // ── 文字：getString(int) ──
    try {
      Res.getString.overload('int').implementation = function (id) {
        nS++;
        var r;
        try { r = this.getString(id); } catch (e) { throw e; }
        try {
          var t = T_TEXT[id];
          if (t !== undefined) return t;
          if (hostS[id] === undefined && inHost) {
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

    // ── 文字：getText(int) ★ 修：返回必须兼容 CharSequence ⇒ SpannedString 包 ──
    try {
      var SpannedString = Java.use('android.text.SpannedString');
      Res.getText.overload('int').implementation = function (id) {
        nT++;
        var r;
        try { r = this.getText(id); } catch (e) { throw e; }
        try {
          var t = T_TEXT[id];
          if (t !== undefined) return SpannedString.$new(t);
        } catch (e2) { }
        return r;
      };
      P('✔ getText(int) [SpannedString 包装]');
    } catch (e) { P('✘ getText(int): ' + e); }

    // ── 图片漏斗 ① getDrawable(int,Theme) ──
    try {
      Res.getDrawable.overload('int', 'android.content.res.Resources$Theme').implementation = function (id, th) {
        nD++;
        var r;
        try { r = this.getDrawable(id, th); } catch (e) { throw e; }
        try {
          if (T_IMG[id] !== undefined) {
            var d = fakeDrawable(this, r ? r.getIntrinsicWidth() : 0, r ? r.getIntrinsicHeight() : 0);
            if (d) { imgSeen['getDrawable/Theme'] = (imgSeen['getDrawable/Theme'] || 0) + 1; return d; }
          }
          noteDrawable('getDrawable/Theme', this, id);
        } catch (e2) { }
        return r;
      };
      P('✔ getDrawable(int,Theme)');
    } catch (e) { P('✘ getDrawable(int,Theme): ' + e); }

    // ── 图片漏斗 ② getDrawable(int) ──
    try {
      Res.getDrawable.overload('int').implementation = function (id) {
        nD2++;
        var r;
        try { r = this.getDrawable(id); } catch (e) { throw e; }
        try {
          if (T_IMG[id] !== undefined) {
            var d = fakeDrawable(this, r ? r.getIntrinsicWidth() : 0, r ? r.getIntrinsicHeight() : 0);
            if (d) { imgSeen['getDrawable'] = (imgSeen['getDrawable'] || 0) + 1; return d; }
          }
        } catch (e2) { }
        return r;
      };
      P('✔ getDrawable(int)');
    } catch (e) { P('✘ getDrawable(int): ' + e); }
  }

  // ── 图片漏斗 ③ BitmapFactory.decodeResource（bitmap 资源走这条）──
  try {
    var BF = Java.use('android.graphics.BitmapFactory');
    BF.decodeResource.overload('android.content.res.Resources', 'int').implementation = function (r, id) {
      nBF++;
      try {
        if (T_IMG[id] !== undefined) { imgSeen['decodeResource'] = (imgSeen['decodeResource'] || 0) + 1; }
        if (hostD[id] === undefined && inHost) {
          var n = r.getResourceName(id);
          if (n && n.indexOf(inHost + ':') === 0) {
            hostD[id] = n;
            P('DBF ' + hx(id) + ' ' + n.replace(inHost + ':', ''));
          }
        }
      } catch (e) { }
      return this.decodeResource(r, id);
    };
    P('✔ BitmapFactory.decodeResource(Res,int)');
  } catch (e) { P('✘ decodeResource(Res,int): ' + e); }

  try {
    var BF2 = Java.use('android.graphics.BitmapFactory');
    BF2.decodeResource.overload('android.content.res.Resources', 'int', 'android.graphics.BitmapFactory$Options').implementation = function (r, id, o) {
      nBF++;
      try {
        if (hostD[id] === undefined && inHost) {
          var n = r.getResourceName(id);
          if (n && n.indexOf(inHost + ':') === 0) {
            hostD[id] = n;
            P('DBF2 ' + hx(id) + ' ' + n.replace(inHost + ':', ''));
          }
        }
      } catch (e) { }
      return this.decodeResource(r, id, o);
    };
    P('✔ BitmapFactory.decodeResource(Res,int,Options)');
  } catch (e) { P('✘ decodeResource(Res,int,Options): ' + e); }

  // ── 图片漏斗 ④ Context.getDrawable(int) ──
  try {
    var Ctx = Java.use('android.content.Context');
    Ctx.getDrawable.overload('int').implementation = function (id) {
      nCtxD++;
      var r;
      try { r = this.getDrawable(id); } catch (e) { throw e; }
      try {
        if (T_IMG[id] !== undefined) {
          var d = fakeDrawable(res, r ? r.getIntrinsicWidth() : 0, r ? r.getIntrinsicHeight() : 0);
          if (d) { imgSeen['Context.getDrawable'] = (imgSeen['Context.getDrawable'] || 0) + 1; return d; }
        }
      } catch (e2) { }
      return r;
    };
    P('✔ Context.getDrawable(int)');
  } catch (e) { P('✘ Context.getDrawable: ' + e); }

  // ── 图片漏斗 ⑤ ResourcesCompat.getDrawable ──
  try {
    var RC = Java.use('androidx.core.content.res.ResourcesCompat');
    RC.getDrawable.overload('android.content.res.Resources', 'int', 'android.content.res.Resources$Theme').implementation = function (r, id, th) {
      nRC++;
      try {
        if (hostD[id] === undefined && inHost) {
          var n = r.getResourceName(id);
          if (n && n.indexOf(inHost + ':') === 0) {
            hostD[id] = n;
            P('DRC ' + hx(id) + ' ' + n.replace(inHost + ':', ''));
          }
        }
      } catch (e) { }
      return this.getDrawable(r, id, th);
    };
    P('✔ ResourcesCompat.getDrawable');
  } catch (e) { P('✘ ResourcesCompat.getDrawable: ' + e); }

  // ── 自测（界面无关，证明链子通）──
  P('==== 自测 ====');
  if (res && SID) {
    try {
      var got = res.getString(SID);
      P('getString 自测: 「' + tr(got, 30) + '」 ⇒ ' + (String(got) === TXT ? '✅已替换' : '❌没截住'));
    } catch (e) { P('getString 自测抛: ' + e); }
  }
  if (res && DID) {
    try {
      var dw = res.getDrawable(DID, null);
      P('getDrawable 自测: ' + (dw ? String(dw.getClass().getSimpleName()) : 'null') + ' ⇒ '
        + (dw && String(dw.getClass().getName()).indexOf('BitmapDrawable') >= 0 ? '✅已是 BitmapDrawable' : '❌没截住'));
    } catch (e) { P('getDrawable 自测抛: ' + e); }
  }
  P('==== 自测结束（接下来 40 秒是真实渲染窗口）====');

  // ── 心跳 ──
  var t = 0;
  var iv = setInterval(function () {
    t += 10;
    P('♥+' + t + 's S=' + nS + ' SF=' + nSF + ' T=' + nT
      + ' D=' + nD + ' D1=' + nD2 + ' BF=' + nBF + ' Ctx=' + nCtxD + ' RC=' + nRC
      + ' | 宿主S=' + Object.keys(hostS).length + ' 宿主D=' + Object.keys(hostD).length
      + ' 图命中=' + JSON.stringify(imgSeen));
    if (t >= 40) {
      clearInterval(iv);
      P('==== 收尾 ====');
      try {
        var kd = Object.keys(hostD);
        for (var j = 0; j < kd.length; j++) P('  DRW ' + hx(kd[j] | 0) + ' ' + hostD[kd[j]]);
        P('图片漏斗命中分布: ' + JSON.stringify(imgSeen));
      } catch (e) { P('收尾失败: ' + e); }
    }
  }, 10000);
});
