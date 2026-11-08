// res_probe.js —— 「宿主の终极美化策略」可行性探针 🐲 2026-11-07
//
// 要回答三个问题（其他都别管）：
//   ① Compose 的文字**真的**都从 Resources.getString(int) 出来吗？→ 改指定 id 看界面变不变
//   ② painterResource 的图真的都从 Resources.getDrawable(int, Theme) 出来吗？→ 换成洋红图看变不变
//   ③ 实际界面到底摸到哪些资源？（顺手抓一份 id + 名字 + 当前值）
//
// 用法：投 frida_job.txt（target=com.deepseek.chat.a，timeout=90），然后主人点开宿主：
//        侧边栏 / 聊天页 / 设置页 / 模型列表 都点一遍（每个页面停留 3~5 秒）
//
// ⚠️ 这台机器 Java.perform 不回调 ⇒ 必须 performNow
// ⚠️ 每个 hook 都 try/catch + 失败返回原值：探针绝不能把宿主搞崩
'use strict';

var TAG = '[RESPROBE]';
function P(s) { console.log(TAG + ' ' + s); }

// ── 要"故意改掉"的两个靶子（看得见才算数）──
// 0x7f0f0312 = string/session_init_title      （聊天页顶部「新对话」）
// 0x7f0f009d = string/chat_input_placeholder_chat（输入框提示语）
var T_TEXT = { 0x7f0f0312: '🐲 尼尼改的标题', 0x7f0f009d: '尼尼在看着你嗷…' };
// 0x7f07005a = drawable/assistant_message_avatar（AI 头像）
// 0x7f07007b = drawable/deepseek_logo_title     （品牌字标）
var T_IMG = { 0x7f07005a: 1, 0x7f07007b: 1 };

var seenS = {};        // id -> name
var seenD = {};        // id -> name
var cntS = 0, cntD = 0;
var fmtS = 0;          // getString(int,Object[]) 命中的条数
var inHost = 'com.deepseek.chat.a';

function trunc(s, n) {
  s = String(s == null ? '' : s).replace(/\n/g, '\\n');
  return s.length > n ? s.substring(0, n) + '…' : s;
}

function hx(id) { return '0x' + (id >>> 0).toString(16); }

Java.performNow(function () {
  var Res = null;
  try { Res = Java.use('android.content.res.Resources'); } catch (e) { P('找不到 Resources: ' + e); return; }

  // 名字（宿主自己的才记；框架 id 直接跳过）
  function nameOf(res, id) {
    try {
      var n = res.getResourceName(id);           // "com.deepseek.chat.a:string/xxx"
      return n;
    } catch (e) {
      return null;
    }
  }
  function isHostName(n) { return n && n.indexOf(inHost + ':') === 0; }

  // ── ① getString(int) ───────────────────────────────────────────
  try {
    Res.getString.overload('int').implementation = function (id) {
      var r;
      try { r = this.getString(id); } catch (e) { throw e; }
      try {
        var t = T_TEXT[id];
        if (t !== undefined) { return t; }
        if (seenS[id] === undefined) {
          var n = nameOf(this, id);
          if (isHostName(n)) {
            seenS[id] = n;
            cntS++;
            P('S ' + hx(id) + ' ' + n.replace(inHost + ':', '') + ' = 「' + trunc(r, 50) + '」');
          }
        }
      } catch (e2) { }
      return r;
    };
    P('hook getString(int) OK');
  } catch (e) { P('hook getString(int) FAIL: ' + e); }

  // ── ② getString(int, Object[])（带 %1$s 的那些）────────────────
  try {
    Res.getString.overload('int', '[Ljava.lang.Object;').implementation = function (id, args) {
      var r;
      try { r = this.getString(id, args); } catch (e) { throw e; }
      try {
        var t = T_TEXT[id];
        if (t !== undefined) { return t; }
        if (fmtS < 12) {
          var n = nameOf(this, id);
          if (isHostName(n)) {
            fmtS++;
            P('SF ' + hx(id) + ' ' + n.replace(inHost + ':', '') + ' = 「' + trunc(r, 50) + '」');
          }
        }
      } catch (e2) { }
      return r;
    };
    P('hook getString(int,Object[]) OK');
  } catch (e) { P('hook getString(int,Object[]) FAIL: ' + e); }

  // ── ③ getText(int)（CharSequence / 带 span 的）──────────────────
  try {
    Res.getText.overload('int').implementation = function (id) {
      var r;
      try { r = this.getText(id); } catch (e) { throw e; }
      try {
        var t = T_TEXT[id];
        if (t !== undefined) { return t; }
      } catch (e2) { }
      return r;
    };
    P('hook getText(int) OK');
  } catch (e) { P('hook getText(int) FAIL: ' + e); }

  // ── ④ 造一张看得见的假图（洋红底 + 青色圆）──────────────────────
  var Bitmap = null, Canvas = null, Paint = null, BD = null;
  try {
    Bitmap = Java.use('android.graphics.Bitmap');
    Canvas = Java.use('android.graphics.Canvas');
    Paint = Java.use('android.graphics.Paint');
    BD = Java.use('android.graphics.drawable.BitmapDrawable');
  } catch (e) { P('图形类拿不到: ' + e); }

  function fakeDrawable(res, w, h) {
    try {
      var cw = (w && w > 0) ? Math.min(w, 512) : 96;
      var ch = (h && h > 0) ? Math.min(h, 512) : 96;
      var bmp = Bitmap.createBitmap(cw, ch, Bitmap.Config.ARGB_8888.value);
      var c = Canvas.$new(bmp);
      var p = Paint.$new();
      p.setColor(-65536);                    // 0xFFFF0000 红底（最扎眼）
      c.drawRect(0, 0, cw, ch, p);
      p.setColor(-16711936);                 // 0xFF00FF00 绿圆
      c.drawCircle(cw / 2, ch / 2, Math.min(cw, ch) / 3, p);
      var d = BD.$new(res, bmp);
      return d;
    } catch (e) {
      P('fakeDrawable FAIL: ' + e);
      return null;
    }
  }

  // ── ⑤ getDrawable(int, Theme) ─────────────────────────────────
  try {
    Res.getDrawable.overload('int', 'android.content.res.Resources$Theme').implementation = function (id, theme) {
      var r;
      try { r = this.getDrawable(id, theme); } catch (e) { throw e; }
      try {
        if (T_IMG[id] !== undefined) {
          var nd = fakeDrawable(this, r ? r.getIntrinsicWidth() : 0, r ? r.getIntrinsicHeight() : 0);
          if (nd) { P('IMG 命中（带主题）' + hx(id)); return nd; }
        }
        if (seenD[id] === undefined) {
          var n = nameOf(this, id);
          if (isHostName(n)) {
            seenD[id] = n;
            cntD++;
            P('D ' + hx(id) + ' ' + n.replace(inHost + ':', '')
              + ' ' + (r ? (r.getIntrinsicWidth() + 'x' + r.getIntrinsicHeight()) : 'null')
              + ' cls=' + (r ? r.getClass().getName() : '-'));
          }
        }
      } catch (e2) { }
      return r;
    };
    P('hook getDrawable(int,Theme) OK');
  } catch (e) { P('hook getDrawable(int,Theme) FAIL: ' + e); }

  // ── ⑥ getDrawable(int)（老接口，AppCompat 走这条）──────────────
  try {
    Res.getDrawable.overload('int').implementation = function (id) {
      var r;
      try { r = this.getDrawable(id); } catch (e) { throw e; }
      try {
        if (T_IMG[id] !== undefined) {
          var nd2 = fakeDrawable(this, r ? r.getIntrinsicWidth() : 0, r ? r.getIntrinsicHeight() : 0);
          if (nd2) { P('IMG 命中（无主题）' + hx(id)); return nd2; }
        }
      } catch (e2) { }
      return r;
    };
    P('hook getDrawable(int) OK');
  } catch (e) { P('hook getDrawable(int) FAIL: ' + e); }

  // ── ⑦ 收尾统计（40 秒后打一份，让 job 正常结束）──────────────
  setTimeout(function () {
    try {
      P('==== 统计 ====');
      P('string 条目（宿主）: ' + cntS + ' · 带格式参数命中: ' + fmtS);
      P('drawable 条目（宿主）: ' + cntD);
      var ks = Object.keys(seenS);
      P('string id 列表: ' + ks.map(function (k) { return hx(k | 0); }).join(','));
      var kd = Object.keys(seenD);
      P('drawable id 列表: ' + kd.map(function (k) { return hx(k | 0); }).join(','));
      P('==== 完（界面那两处改了没？顶部标题 / AI 头像）====');
    } catch (e) { P('统计失败: ' + e); }
  }, 40000);
});
