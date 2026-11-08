// res_paint.js —— 图片替换「运行时真相」探针 🐲 2026-11-07
//
// 目的：Xposed 上我已经瞎猜了 10 轮。这里一次性把运行时看清楚：
//   ① painterResource(s27.E) 被调用时 id 是多少、返回什么 Painter 类型
//   ② Resources.getValue 拿到的 tv.string 到底长什么样
//   ③ 最终走了哪条分支（getXml / getDrawable / openRawResource）
//   ④ **直接在 frida 里替换返回值**试效果 —— 秒级验证，不用重启宿主
//
// 用法：投 frida_job.txt（target=com.deepseek.chat.a, timeout=90）
//       然后主人点开有那个图标的界面（歌卡片底部按钮行）
'use strict';

var TAG = '[RESPAINT]';
function P(s) { console.log(TAG + ' ' + s); }

// 目标资源名（主人一直在改的那个）
var TARGET_NAME = 'ic_copy_outline';

function hx(i) { return '0x' + (i >>> 0).toString(16); }

Java.performNow(function () {
  var app = null, res = null, pkg = null, targetId = 0;
  try {
    var AT = Java.use('android.app.ActivityThread');
    app = AT.currentApplication();
    pkg = app.getPackageName();
    res = app.getResources();
    targetId = res.getIdentifier(TARGET_NAME, 'drawable', pkg) >>> 0;
    P('注入 pkg=' + pkg + ' pid=' + Process.id);
    P('目标 ' + TARGET_NAME + ' → ' + hx(targetId));
  } catch (e) {
    P('初始化失败: ' + e);
  }

  // ── ① Resources.getValue：看 tv.string / tv.type ────────────────
  try {
    var R = Java.use('android.content.res.Resources');
    R.getValue.overload('int', 'android.util.TypedValue', 'boolean').implementation =
      function (id, tv, resolve) {
        var r = this.getValue(id, tv, resolve);
        try {
          if ((id >>> 0) === targetId) {
            P('【getValue】id=' + hx(id)
              + ' type=' + tv.type.value
              + ' string=' + (tv.string.value === null ? 'null' : '"' + tv.string.value + '"')
              + ' data=' + hx(tv.data.value));
          }
        } catch (e) { }
        return r;
      };
    P('✔ getValue');
  } catch (e) { P('✘ getValue: ' + e); }

  // ── ② s27.E = painterResource 本体 ─────────────────────────────
  var s27 = null;
  try {
    s27 = Java.use('s27');
    var E = s27.E.overload('int', 'int', 'v15');
    E.implementation = function (id, density, composer) {
      var out = E.call(this, id, density, composer);
      try {
        if ((id >>> 0) === targetId) {
          P('【s27.E】id=' + hx(id) + ' density=' + density
            + ' → ' + (out === null ? 'null' : out.getClass().getName()));
          // 打印 Painter 的 intrinsic size
          try {
            var w = out.getIntrinsicWidth(1.0);
            var h = out.getIntrinsicHeight(1.0);
            P('   intrinsic = ' + w + 'x' + h);
          } catch (e2) { P('   取 intrinsic 失败: ' + e2); }
        }
      } catch (e) { }
      return out;
    };
    P('✔ s27.E (painterResource)');
  } catch (e) { P('✘ s27.E: ' + e); }

  // ── ③ Resources.getXml / getDrawable / openRawResource ────────
  try {
    var R2 = Java.use('android.content.res.Resources');
    R2.getXml.overload('int').implementation = function (id) {
      if ((id >>> 0) === targetId) P('【getXml】id=' + hx(id) + ' ← 走矢量分支了');
      return this.getXml(id);
    };
    P('✔ getXml');
  } catch (e) { P('✘ getXml: ' + e); }

  try {
    var R3 = Java.use('android.content.res.Resources');
    R3.getDrawable.overload('int', 'android.content.res.Resources$Theme').implementation =
      function (id, th) {
        var r = this.getDrawable(id, th);
        try {
          if ((id >>> 0) === targetId) {
            P('【getDrawable】id=' + hx(id) + ' → '
              + (r === null ? 'null' : r.getClass().getName()));
          }
        } catch (e) { }
        return r;
      };
    P('✔ getDrawable(int,Theme)');
  } catch (e) { P('✘ getDrawable: ' + e); }

  try {
    var R4 = Java.use('android.content.res.Resources');
    R4.openRawResource.overload('int', 'android.util.TypedValue').implementation =
      function (id, tv) {
        if ((id >>> 0) === targetId) P('【openRawResource】id=' + hx(id));
        return this.openRawResource(id, tv);
      };
    P('✔ openRawResource(int,TypedValue)');
  } catch (e) { P('✘ openRawResource: ' + e); }

  // ── ④ 手动跑一次 painterResource，看看能不能直接换 ──────────────
  //   这里只做"读取"，不动返回值 —— 先看清楚再动手
  setTimeout(function () {
    P('==== 统计 ====');
    P('如果上面没有任何【s27.E】行 ⇒ 说明这个图标不是 painterResource 画的');
    P('如果有【s27.E】但没有【getDrawable】⇒ 走的是 getXml 矢量分支');
    P('如果有【s27.E】且有【getDrawable】→ 返回 BitmapDrawable ⇒ 位图分支正常');
    P('==== 完 ====');
  }, 60000);
});
