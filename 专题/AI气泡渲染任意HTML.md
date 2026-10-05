# 专题 · AI 气泡渲染任意 HTML（WebView 搭车）

> 🐲 尼得亚伯 · 2026-10-04
> 宿主：`com.deepseek.chat.a` **2.6.1**（smali 树 = `tmp/h261`）
> 状态：**已打通，主人验收「OK 好了」**
> 版本：`版本/3.47.4.md`（本轮 3.46.0 → 3.47.4 共 9 包）
> 前置：`专题/AI气泡富文本-锚点勘察.md`（那是"文字级富文本"，本文是"整页 HTML"）

---

## 〇、为什么这件事难

**Compose 里"往气泡塞一个控件"对我们封死了**：
`AndroidView` 是 `@Composable`，而 Composable 的 `Composer` 状态机调用顺序是
**Kotlin + compose 编译器在编译期算好的** —— 我们的 `mod-src` 是纯 Java + javac，
手写调用必然破坏 composition（会崩）。

**⇒ 唯一的出路是"搭宿主的车"。** 而宿主自己有条现成通道：
它用 **WebView** 渲染 ` ```mermaid ` 代码块。我们要做的就是**把那条链路截下来换成自己的内容**。

---

## 一、★ 完整链路（frida 实证）

```
```html 代码块
  │
  ├─ ① 语言闸门        o01（MarkdownCodeKt）里：v7a.M(语言, "mermaid", true)Z
  │                     ⇒ 让 "html" 也返回 true ⇒ 宿主当成 Diagram
  │
  ├─ ② 建 WebView       new MermaidGeneratorWebView(Context)
  │                     ★ 内联渲染 = Generator；Viewer 是"点图表全屏预览"那条路
  │
  ├─ ③ 加载页面        loadUrl("file:///android_asset/generator.html")
  │                     ⇒ ★ 换成自建页的 data: URL（两个页面都接管）
  │
  ├─ ④ 投递内容        evaluateJavascript(
  │                       "if (window.generateMermaid) { window.generateMermaid(源码, "dark"); }")
  │
  └─ ⑤ 渲染 + 回执      HTML → <svg><foreignObject> → Image → canvas → PNG
                        → window.AndroidBridge.onImageRendered(png, "")
```

---

## 二、★ 锚点对照表（2.6.1 实测）

| 混淆名 / 真名 | 身份 | 用法 |
|---|---|---|
| **`v7a`** | 语言判断工具（R8 合并类） | **`M(String lang, String target, boolean ignoreCase)Z`** —— 就是 `equals` / `equalsIgnoreCase` |
| **`o01`** | `MarkdownCodeKt`（R8 合并） | 里面那句 `v7a.M(v3, "mermaid", true)`，**语言闸门就在这** |
| `…mermaid.render.MermaidGeneratorWebView` | **真名没混淆** | 内联渲染器。`<init>(Context)` · `a(String,String,Cont)` · `b(String,String,Cont)` |
| `…mermaid.render.MermaidViewerWebView` | **真名没混淆** | 全屏预览器。`<init>(Context,String theme)` · `a(String)` · `b(String,Cont)` |
| **`wz6`** | 持有 `MermaidViewerWebView` 的混淆类 | **从它字段类型里"伸手拿"WebView 子类** ⇒ 规避铁律（不写宿主包名字面量） |
| `assets/generator.html` | 内联渲染页（813 B） | 我们**换掉它** |
| `assets/viewer.html` | 全屏预览页（796 B） | 我们**换掉它** |
| `assets/generator.js` (4.4 KB) | ★ **回执协议的唯一权威来源** | 每次要动这块，先回来读它 |
| `assets/viewer.js` (4.4 KB) | 全屏那条路的协议 | 用 `NativeBridge.onMermaidRendered` |

> ⚠️ **别去猜"哪个类在渲染"** —— 我前四个包全在猜（一直以为是 Viewer），一条日志都不中。
> **用 frida 让它自己报**：hook `WebView` 构造器，把 `getClass().getName()` 打出来。

---

## 三、★ 协议（逐字从 `generator.js` / `viewer.js` 抄的）

### 内联渲染（generator.html）

```js
window.generateMermaid = (src, theme, maxW, maxH) => {
    // 原版：mermaid.render(...) → SVG → 转 PNG
    window.AndroidBridge.onImageRendered(pngDataURL, diagramType);        // 成功
    window.AndroidBridge.onImageRenderFailed("RENDER_FAILED", msg);       // 失败
}
```

### 全屏预览（viewer.html）

```js
window.JSBridge.requestRenderMermaid = (src, id) => {
    // 原版：runMermaid(src) → "FINISHED" / 错误串
    window.NativeBridge.onMermaidRendered(result, id);                    // 回执
}
```

**⚠️ 最容易搞混的一点：**
- **内联 → `AndroidBridge`**（`addJavascriptInterface` 注入的对象）
- **全屏 → `NativeBridge`**

写错了就是「永远等不到回执」⇒ 界面卡在「生成中」。

---

## 四、★ 五个坑（每个都烧掉好几轮）

### 坑 1 · `am force-stop` 可能是空转

```
$ ps -A | grep deepseek      → 1
$ am force-stop <包名>
$ ps -A | grep deepseek      → 1   ← 没死！
```

⇒ 宿主进程没换 ⇒ **LSPosed 加载的还是旧 dex** ⇒ 新代码根本没生效，
而你还在纳闷"为什么探针一条都不打"。

**✅ 用 `am start -S`**，并且**装完必须验证进程号变了**。

### 坑 2 · `file://` 被 `targetSdk>=30` 默认禁

```
url = file:///data/user/0/<包>/files/fdm_generator.html
title = 网页无法打开
```

⇒ 页面没加载 ⇒ `window.generateMermaid` 不存在 ⇒ 宿主 `if (…)` 跳过 ⇒ 卡住。

**✅ 自建页走 `data:text/html;charset=utf-8;base64,…`。**
（`android_asset` 是特权通道，宿主自己用 file:// 没问题 —— 只有**我们**不能用。）

### 坑 3 · ★★★ `<br>` 毁掉整份 SVG

**SVG 是 XML**；XML 里 `<br>` / `<img>` / `<hr>` 这类空元素**必须自闭合**。
拼 `innerHTML` 塞进 `<foreignObject>` ⇒ 一遇 `<br>` 就是格式错误 ⇒ **整份 SVG 解析失败**。

**⇒ 这就是"简单表格能过、复杂文档过不去"的真凶**（表格里没有空标签）。

**✅ `new XMLSerializer().serializeToString(el)`** —— 自动输出 `<br />`，
并处理好 `&`、属性引号。CSS 另外做一次 `&`/`<` 转义。

### 坑 4 · `<script>` 不执行

`innerHTML` / `XMLSerializer` 插进去的 `<script>` **都不会跑** ⇒
打字机、数字滚动、滚动显现这些回调驱动的元素**渲染出来全是空白**。

**✅ 把 `<script>` 抠出来手动跑**：`(new Function(code))()`，
并把截图前等待提到 **260ms**（给动画时间）。

### 坑 5 · 宽度取容器宽 ⇒ 图里内容显得很小

**✅ 包一层 `display:inline-block`**，它的 `offsetWidth` 就是**内容自然宽度**。

---

## 五、自建页的完整实现要点（`gm/GmHtml.java`）

| 点 | 做法 |
|---|---|
| 页面载体 | `data:text/html;charset=utf-8;base64,…`（进程内缓存） |
| 两套接口 | 同时实现 `generateMermaid`（回 PNG）和 `requestRenderMermaid`（回 FINISHED） |
| 渲染 | `<svg><foreignObject>` + `XMLSerializer` → `Image` → `canvas.drawImage` → `toDataURL` |
| 透明底 | canvas **不 `fillRect`** ⇒ 保留 alpha |
| 流式容错 | 递增 `seq`，**只有最后一次投递才回调**（AI 的 HTML 是一点点长出来的） |
| 尺寸保护 | 超 4000×8000 直接回 `TOO_LARGE`（那种尺寸下 SVG→图片必失败） |
| 脚本执行 | `querySelectorAll('script')` → `new Function` → 用后移除 |
| **诊断出口** | 状态写进 **`document.title`**（`FDM\|OK len=…` / `FDM\|ERR …` / `FDM\|size=WxH`）⇒ frida 一句 `getTitle()` 就读到 |

---

## 六、★ frida 白名单网关（本轮的"第二双眼睛"）

**投递式，无端口、无常驻进程、不写任何文件。** 详见 `tools/frida/启动方式-速查.md`。

```sh
# 主人（设备上，真 su）
su -c 'sh /data/adb/frida/frida.sh'

# 尼尼：投 job
B64=$(base64 -w0 /tmp/job.txt)
sh tools/出笼隧道/adb.sh shell "printf '%s' '$B64' | base64 -d > /data/local/tmp/frida_job.txt"

# 尼尼：读结果（等 35 秒）
sh tools/出笼隧道/adb.sh shell "cat /data/local/tmp/frida_out/result.txt"
```

job 格式：
```
id=<任务名>
target=com.deepseek.chat.a
---
<JS 正文>
```

### 三条"探针模板"（直接用）

**① 让宿主自报用了哪些 WebView 子类**
```js
Java.perform(function(){
  Java.choose('android.webkit.WebView', {
    onMatch: function(i){ console.log('[FDM] ' + i.getClass().getName()); },
    onComplete: function(){}
  });
});
```

**② 读当前 WebView 的 URL / title（★ 方法必须在主线程）**
```js
Java.perform(function(){
  var f=null;
  Java.choose('android.webkit.WebView',{onMatch:function(i){if(!f)f=i;},onComplete:function(){}});
  if(!f){console.log('[FDM] 没有实例');return;}
  Java.scheduleOnMainThread(function(){
    console.log('[FDM] url='+f.getUrl());
    console.log('[FDM] title='+f.getTitle());     // ← 我们的诊断出口就在这
  });
});
```

**③ 挂 loadUrl / evaluateJavascript 看投递**
```js
Java.perform(function(){
  var W=Java.use('android.webkit.WebView');
  W.loadUrl.overload('java.lang.String').implementation=function(u){
    console.log('[FDM] loadUrl='+u); return this.loadUrl(u);
  };
  W.evaluateJavascript.overload('java.lang.String','android.webkit.ValueCallback')
   .implementation=function(js,cb){
    console.log('[FDM] evalJS='+String(js).substring(0,200)); return this.evaluateJavascript(js,cb);
  };
});
```

**⚠️ 实测踩到的两个坑：**
- `Java.registerClass` 做回调在 attach + 25s 窗口下**不稳**（`status=empty`）⇒ **改用 `document.title` 传信息**
- WebView 的方法**必须在主线程调**，否则抛 `All WebView methods must be called on the same thread`

---

## 七、宿主存储里的配置键

| 键 | 类型 | 说明 |
|---|---|---|
| `fuckds_html_on` | b | 总开关（默认关） |
| `fuckds_html_light` | b | 页面用浅色（默认跟随宿主深色主题） |

> ⚠️ **读开关一定要三档兜底（`b` → `s` → `i`）** ——
> UI 的开关控件实际把值写进了 JSON 的 `ints`，只试 `"b"` 会永远读到默认值。
> 统一用 `GmRichText.boolOf()`，别再抄第二份。

---

## 八、⚠️ 已知边界

| # | 边界 | 说明 |
|---|---|---|
| 1 | **预览会被宿主裁剪** | frida 测到宿主给的 `contentHeight=352`，而内容常上千像素 ⇒「预览看大概、全屏看完整」是当前架构下的合理分工 |
| 2 | **JS 只跑一次** | 我们是在"投递那一刻"跑脚本再截图 ⇒ **不是活的网页**，点按交互（除链接外）无效 |
| 3 | **超大内容会被拦** | 超 4000×8000 回 `TOO_LARGE`（与其黑屏不如报清楚） |
| 4 | **`exportPngBase64` 是假的** | 我没实现真正的 PNG 导出（回一个明确错误），所以「保存」按钮对 HTML 块无效 |
| 5 | **宿主升级会变** | `v7a` / `o01` 是混淆名；`MermaidGeneratorWebView` 是真名但宿主改版也可能动 ⇒ 结构自检 + 找不到就整体不启用 |
