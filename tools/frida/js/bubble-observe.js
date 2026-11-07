/* bubble-observe.js —— 气泡绘制链【纯观察】版
 * 2026-10-31 · 尼得亚伯 🐲
 *
 * 目标：不发一个包，在活进程里回答三个问题
 *   Q1 用户气泡的底色到底从哪个方法出来？颜色值是多少？
 *   Q2 l23.n 的 p1/p2 是不是每次重组都换对象？
 *   Q3 x98.t 被调用多少次、caller 是谁？
 *
 * 只说真话：不改任何入参、不改返回值，零风险。
 */
'use strict';

var MAXLOG = 40;
var cnt = {};
function once(k, s) {
  cnt[k] = (cnt[k] || 0) + 1;
  if (cnt[k] <= MAXLOG) send(s);
  else if (cnt[k] === MAXLOG + 1) send('… [' + k + '] 后续静默（已超 ' + MAXLOG + ' 条）');
}

function stackTop(n) {
  var st = Java.use('android.util.Log').getStackTraceString(Java.use('java.lang.Throwable').$new());
  var lines = st.split('\n');
  var out = [];
  for (var i = 0; i < lines.length && out.length < n; i++) {
    var t = lines[i].trim();
    if (t.indexOf('at ') === 0) out.push(t.substring(3));
  }
  return out.join(' <- ');
}

function hex(v) {
  try {
    if (typeof v === 'number') { return (v < 0 ? '0x' + (v >>> 0).toString(16) : '0x' + v.toString(16)); }
    var n = v.longValue();
    return '0x' + (n >>> 0).toString(16);
  } catch (e) { return String(v); }
}

function hookBySig(cls, sigKeep, label, fn) {
  var C;
  try { C = Java.use(cls); } catch (e) { send('[!] 找不到类 ' + cls); return false; }
  var m = C[sigKeep];
  if (!m) { send('[!] ' + cls + '.' + sigKeep + ' 不存在'); return false; }
  var ols = m.overloads || [];
  var hit = 0;
  ols.forEach(function (ol) {
    var at = ol.argumentTypes.map(function (t) { return t.className; });
    hit++;
    ol.implementation = function () {
      return fn.call(this, ol, at, Array.prototype.slice.call(arguments));
    };
  });
  send('[+] ' + label + ' 挂上 ' + hit + ' 个重载');
  return true;
}

function wrap(cls, name, label, fn) {
  var C;
  try { C = Java.use(cls); } catch (e) { send('[!] 找不到类 ' + cls); return; }
  var m = C[name];
  if (!m) { send('[!] ' + cls + '.' + name + ' 不存在'); return; }
  var ols = m.overloads || [];
  ols.forEach(function (ol) {
    var at = ol.argumentTypes.map(function (t) { return t.className; });
    ol.implementation = function () {
      return fn.call(this, ol, at, Array.prototype.slice.call(arguments));
    };
  });
  send('[+] ' + label + ' 挂上 ' + ols.length + ' 个重载');
}

function run() {
  send('=== bubble-observe 启动 ===');

  // ---- Q3: x98.t(Modifier, long color, shape) -> Modifier  = 「画底色」
  wrap('x98', 't', 'x98.t(画底色)', function (ol, at, args) {
    var keep = ol.returnType.className;
    var r = ol.apply(this, args);
    if (at.length === 3 && at[1] === 'long') {
      once('x98.t', '[x98.t] color=' + hex(args[1]) + ' shape=' + (args[2] ? args[2].getClass().getName() : 'null')
        + ' | caller=' + stackTop(4));
    } else {
      once('x98.t-other', '[x98.t] 其他重载 args=' + at.join(','));
    }
    return r;
  });

  // ---- Q1: l23.l(content, color, modifier, ...) 被谁调用、颜色多少
  wrap('l23', 'l', 'l23.l(疑似气泡底)', function (ol, at, args) {
    var r = ol.apply(this, args);
    once('l23.l', '[l23.l] color=' + hex(args[1]) + ' | caller=' + stackTop(4));
    return r;
  });

  // ---- Q2: l23.n(MessageBubbleLayout) p1/p2 对象身份
  wrap('l23', 'n', 'l23.n(气泡布局)', function (ol, at, args) {
    var r = ol.apply(this, args);
    var id = function (o) { return o === null ? 'null' : (o.getClass().getName() + '@' + o.hashCode()); };
    once('l23.n', '[l23.n] argN=' + at.length + ' p1=' + id(args[1]) + ' p2=' + id(args[2]));
    return r;
  });

  // ---- l23.m(ContentLayer)
  wrap('l23', 'm', 'l23.m(内容层)', function (ol, at, args) {
    var r = ol.apply(this, args);
    once('l23.m', '[l23.m] p1=' + (args[1] === null ? 'null' : args[1].getClass().getName()));
    return r;
  });

  // ---- zi9.S / zi9.R 看「Modifier 追加 element」是否每次都新建
  wrap('zi9', 'R', 'zi9.R(Modifier+element)', function (ol, at, args) {
    var before = args[1];
    var r = ol.apply(this, args);
    once('zi9.R', '[zi9.R] in=' + (before === null ? 'null' : before.hashCode())
      + ' out=' + (r === null ? 'null' : r.hashCode())
      + ' same=' + (before === r));
    return r;
  });

  send('=== 全部挂好，去聊天页滑一下 ===');
}

setTimeout(function () {
  try { Java.perform(run); } catch (e) { send('[FATAL] ' + e); }
}, 0);
