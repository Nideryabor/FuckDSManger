# 专题 · AI 气泡富文本（标记 → 渲染）· 锚点勘察

> 2026-10-03 🐲 尼得亚伯
> 宿主：`com.deepseek.chat.a` **2.6.1**（smali 树 = `tmp/h261`，15484 个文件）
> 状态：**已实施 → `版本/3.45.1.md`**（下面第三节里标 ★ 的 API 语义**全部用 smali 反汇编实证过**，不是推断）
> 前序：`专题/FDM新功能-系统提示词注入.md` · `版本/3.45.0.md`（显示侧 `GmSysPromptHideHook`）

---

## 〇、一句话

上次我们用 hook 把用户气泡里的 `⟦FDM⟧…⟦/FDM⟧` **删掉**；
这次要在 **AI 气泡**里反过来 —— 把 `⟦FDM:模板名⟧` **渲染成富文本**。

**落脚点已找到**：`fz2.p(AnnotatedString, …)` —— 宿主 markdown 渲染的**最后一道门**，
拿到的是**成品 AnnotatedString**，而且旁边就有 `AnnotatedString.Builder` 全部 API。

---

## 一、★★★ 宿主 markdown 渲染链路（全链实证）

```
AI 文本 (String)
 └─ svb.c(Ljava/lang/String;…)  ← AssistantTextItem（AssistantResponseItem.kt:167）★AI正文项
     └─ eu6.c(…)                ← Markdown Composable（Markdown.kt）
         └─ v91.m(String,Lk;,Z,x97,qt6,rla,Composer,I)
             ├─ new-instance Lin;                            ← AnnotatedString.Builder ★
             ├─ or6.w(Lin;String;Lk;Z;Composer;II)V           ← buildMarkdownAnnotatedString(builder, md)
             │     · 内部：appendAutoLink / appendInlineMath / appendBlockMath /
             │             appendCitation / appendLabelLink / appendReference
             │             （源文件 AnnotatedStringExt.kt）
             ├─ in.k()Lkn;                                    ← builder.toAnnotatedString() ★
             └─ fz2.p(Lkn;Lx97;Lrla;Lk;Lyx4;II)V              ★★★ 成品 AnnotatedString 渲染入口
                 └─ w2b（MarkdownBasicText.kt）→ 实际绘制
```

> `eu6` 另有 `a/b/c/d/e/f/g/h` 多个入口（thinking / 引用预览 / 分享等），
> 但**全部最终汇到 `fz2.p`** —— 所以只挂一个点就全覆盖。

---

## 二、★ 锚点对照表（2.6.1 实测）

| 混淆名 | 真实身份 | 关键证据 |
|---|---|---|
| **`kn`** | **`androidx.compose.ui.text.AnnotatedString`** | implements CharSequence；字段 `b:String`=text、`a:List`=spanStyles；`d(II)Lkn;`=subSequence |
| **`jn`** | **`AnnotatedString.Range`** | `<init>(Object item,int start,int end)`；字段 `a/b/c`；`kn` 构造器里 `instance-of …Lf0a;` 分流 |
| **`in`** | **`AnnotatedString.Builder`** | 字段 `a:StringBuilder`、`b:ArrayList`(push栈)；`k()`=toAnnotatedString |
| **`f0a`** | **`SpanStyle`** | toString `"SpanStyle(color="`；15 个字段 |
| **`gx2`** | **`ColorKt`** | `d(J)F`=red（`usr 56`⇒bits56-63）；`i(J)String`=colorToString |
| **`ko4`** | **`FontWeight`** | 静态字段 `b/c/d/e/f`（clinit 里 new + weight 值） |
| **`io4`** | **`FontStyle`** | 字段 `a:I`；无静态字段 ⇒ `new io4(0/1)` |
| **`dia`** | **`TextDecoration`** | 静态字段 `b`=0(None)/`c`=1(Underline)/`d`=2(LineThrough) |
| `or6` | `markdown.extensions.AnnotatedStringExtKt` | 全部 AnnotatedStringExt.kt 路标集中此文件 |
| `fz2` | `markdown.components.MarkdownTextKt`(+R8合并) | MarkdownText.kt:65/80、createInlineTextContent、createMergedInlineContentEntries |
| `eu6` | `markdown.MarkdownKt` | Markdown.kt:104/160/227/291/323/343/434 |
| `svb` | `…message_items.assistant.fragment.AssistantResponseItemKt` | AssistantResponseItem.kt:57/167 |
| `v91` | `…message_items.assistant.*`(+ChatInputField 等 R8 合并) | AssistantTtsButton.kt、ChatInputField.kt、MarkdownParagraph.kt |
| `sn` | `compose.foundation.text.InlineChildren` | AnnotatedStringResolveInlineContent.kt:67；`kn.d(II)` + `jn.b/c` 取占位区间 |
| `w2b` | `MarkdownBasicTextKt`(+R8合并了 `Modifier.paint`) | MarkdownBasicText.kt:39 ⚠️ 与 GmRemap 的 `fh6` 同落点 |

---

## 三、★ 新摸到的 API（这次最值钱的东西）

### 3.1 `AnnotatedString.Builder`（`in`）—— 全表

| 混淆 | 真身 | 签名 |
|---|---|---|
| `<init>()V` | `Builder()` | — |
| `<init>(Lkn;)V` | `Builder(AnnotatedString)` | 从现有串复制 |
| `a(C)V` | `append(char)` | |
| `b(Lkn;)V` | `append(AnnotatedString)` | 全量 |
| **`c(Lkn;II)V`** | **`append(AnnotatedString, start, end)`** | ★★★ **自动带上该区间的样式** |
| `d(CharSequence)V` | `append(CharSequence)` | |
| `e(String)V` | `append(String)` | |
| **`j(Lf0a;)I`** | **`pushStyle(SpanStyle)`** | ★★★ |
| `h(Lsi6;)I` | `pushStyle(ParagraphStyle)` | |
| **`f()V`** | **`pop()`** | ★ 操作 `b:ArrayList` 栈 |
| `g(I)V` | `pop(index: Int)` | |
| **`k()Lkn;`** | **`toAnnotatedString()`** | ★ |

### 3.2 `SpanStyle`（`f0a`）

```smali
# 主构造器（default mask 版，推荐用这个）
<init>(J color, J fontSize, Lko4; fontWeight, Lio4; fontStyle, Ljo4; fontSynthesis,
       Lxm4; fontFamily, String fontFeatureSettings, J letterSpacing, Loj0; baselineShift,
       Lgka; textGeometricTransform, Lyl6; localeList, J background, Ldia; textDecoration,
       Lbn9; shadow, I mask)V
```

- **mask 语义已实证**：`and-int/lit8 v2, v1, 0x1` ⇒ **bit N 置位 = 该参数取默认值**（bit0=color）
  （证据：`f0a.a(Lf0a;JI)Lf0a;` —— 就是 `copy(color=…)` 的 default 桥：
   bit0 置位→用 `this.color`，否则用入参）
- `f0a.a(Lf0a;JI)Lf0a;` = **copy(color)**（只改颜色）
- `f0a.d(Lf0a;)Lf0a;` = **merge(other)**
- 默认值构造：**mask 全 1 就全用默认** ⇒ 不需要知道 `TextUnit.Unspecified` 的值 ✔

### 3.3 Color 编码（`gx2`，已实证）

```smali
.method public static final d(J)F        # Color.red
    and-long/2addr v0, 0x3f              # 低 6 位
    cmp-long v0, v0, 0 → 若 ==0 则 sRGB
    ushr-long/2addr p0, 0x38             # >>> 56
    and-long/2addr p0, 0xff              # red
```

⇒ **`packed = (argb.toLong() and 0xFFFFFFFFL) shl 32`** ✔（低 6 位 = colorSpace id，sRGB = 0）

### 3.4 FontWeight / FontStyle / TextDecoration

- **FontWeight(`ko4`)**：静态字段 `b`(=0x258?)`c`=0x2bc… 运行时**枚举静态字段找 weight=700** 最稳
- **FontStyle(`io4`)**：`new io4(0)` = Normal，`new io4(1)` = Italic
- **TextDecoration(`dia`)**：`b`=None，`c`=Underline，`d`=LineThrough ✔ **直接可用**

---

## 四、★ 实现方案

### 4.1 核心算法（`fz2.p` 的 before hook）

```
1. QuickReject：text.indexOf('⟦') < 0 ⇒ 立刻 return（热路径，每帧都过）
2. 解析标记段 → List<Seg>
3. Object nb = new in();                       // Builder()
   int cur = 0;
   for (Seg s : segs) {
       if (s.start > cur) in.c(nb, origKn, cur, s.start);   // ★ 原样搬（样式自动保留）
       if (s.isTemplate) {
           List<Styled> rs = GmRichText.render(s.name, s.args);  // 模板 → 样式段
           for (Styled x : rs) {
               if (x.style != null) in.j(nb, x.style);          // pushStyle
               in.e(nb, x.text);
               if (x.style != null) in.f(nb);                   // pop
           }
       } else {
           in.e(nb, s.raw);
       }
       cur = s.end;
   }
   if (cur < text.length()) in.c(nb, origKn, cur, text.length());
4. args[0] = in.k(nb);
```

**★ 关键优势：位置映射问题被 `in.c(origKn, start, end)` 彻底消掉了** ——
搬原文段时样式自动跟着走，不用手工平移 offset。

### 4.2 性能（必须做，否则卡死）

`fz2.p` 是 **@Composable**，每帧可能重入 ⇒

| 层 | 手段 |
|---|---|
| 第一道 | `text.indexOf('⟦') < 0` 直接 return |
| 第二道 | **IdentityHashMap<Object,Object> 缓存**：同一个 `kn` 实例 → 同一个结果 kn（Compose 复用对象时命中） |
| 第三道 | 缓存按文本 hash 兜底（LRU，上限 ~64） |
| 纪律 | 全 `try/catch(Throwable)`，任何异常**原样放行**（教训 255） |

### 4.3 标记语法（段内）

```
⟦FDM:名字⟧                    自闭合，渲染模板「名字」
⟦FDM:名字|参数1|参数2⟧         带参
⟦FDM:名字⟧内容⟦/FDM⟧           容器：内容当参数 0
```

> 与系统提示词的 `⟦FDM⟧`（U+27E6 数学白方括号）**同族但不同形态**，
> 判定时先试 `⟦/FDM⟧` / `⟦FDM:` 前缀，避免和系统提示词那条撞车。

### 4.4 HTML 子集 → 样式映射

| 标签 | 效果 | 实现 |
|---|---|---|
| `<b>` `<strong>` | 粗体 | SpanStyle(fontWeight=700) |
| `<i>` `<em>` | 斜体 | SpanStyle(fontStyle=Italic) |
| `<u>` | 下划线 | SpanStyle(textDecoration=Underline) |
| `<s>` `<del>` | 删除线 | SpanStyle(textDecoration=LineThrough) |
| `<c#FF0000>` | 前景色 | SpanStyle(color=pack) |
| `<c1>`…`<c9>` | **色板引用**（模块里配） | 同上 |
| `<bg#FFFF00>` | 背景高亮 | SpanStyle(background=pack) |
| `<br>` | 换行 | `\n` |
| `<mono>` | 等宽 | fontFamily（待挖） |
| 嵌套 | 支持 | style **merge**（`f0a.d`）|

> **MVP 先做：b / i / u / s / c / bg / br / 嵌套**（零件全齐）。
> 字号（TextUnit packing）与等宽字族**留第二期** —— 除非先挖到 packed 常量。

### 4.5 模板存储（沿用 GmStore）

| 键 | 类型 | 说明 |
|---|---|---|
| `fuckds_rich_on` | b | 总开关 |
| `fuckds_rich_tpl_<名字>` | s | 模板正文（HTML 子集） |
| `fuckds_rich_names` | s | 模板名列表（`\n` 分隔，给 UI 用） |
| `fuckds_rich_c1`…`c9` | s | 色板（`#RRGGBB`） |
| `fuckds_rich_head` | s | 追加给 AI 的格式约定（灌进系统提示词） |

⚠️ **`GmStore.read2(ctx,key,x)` 第三参是「类型」不是「默认值」**（教训见 3.45.0）——
写 `"b"` / `"i"` / `"f"` / `"l"`，其余落 getString。**别再踩。**

### 4.6 新增类

- `gm/GmRichText.java` —— 解析 + 模板 + SpanStyle 构造（纯工具，可单测）
- `bridge/GmRichTextHook.java` —— 挂 `fz2.p`（+ 兜底挂 `v91.m` 做 markdown 降级）
- `GmRemap` 增锚点；`FdmEntry` 注册；`Tree.kt`/`Pages.kt` 加 UI

---

## 五、⚠️ 风险与边界

| # | 风险 | 缓解 |
|---|---|---|
| 1 | `fz2.p` 是 **@Composable 热路径** | 三重 quick-reject + 缓存 + 全 try/catch |
| 2 | 混淆名随宿主升级变 | 集中进 `GmRemap` + **结构自检**（`kn` 必须有 `b:String` 字段）再挂，否则安全跳过 |
| 3 | `AnnotatedString.Builder` 的 `j()` 到底是不是 pushStyle | **待真机探针确认**（一次日志就能钉死） |
| 4 | mask 位序若与我推断不符 | 先只做 **color**（有 `f0a.a` 实证兜底），逐项加 |
| 5 | 流式回复高频重渲染 | 缓存 + 只在 `⟦` 出现时才走重活 |
| 6 | 与 `GmSysPromptHideHook` 同时命中 | 标记形态不同，各判各的；都走"拿不到就放行" |

---

## 六、待办（下一步动作）

1. **写探针版**：只打日志（`fz2.p` 命中 / `in.j` 是否 pushStyle / `kn` 结构），零行为改动 → 出包装机
2. 拿到日志后钉死 §五-3、§五-4
3. 正式实现 `GmRichText` + UI
4. **顺带**：把格式约定写进系统提示词（UI 里给一段现成的，一键灌入）
5. 出包 → 写 `版本/<ver>.md`

---

## 十、★ 颜色 vs 背景：为什么一个活一个死（2026-10-05 结案）

> 现象：`<c#FF0000>` 显示成宿主正文色（浅色黑/深色白），`<bg#FFFF00>` 正常。
> 详见 `版本/3.48.2.md`。

### 10.1 三条硬事实（frida 实测）

**① `Java.choose('f0a')` 一次扫出 255 个 SpanStyle，规律很干净：**

```
#1  SpanStyle(color=Color(0.972549, 0.972549, 0.972549, 1.0, sRGB), fontSize=17.0.sp, ...)
                                                                    ↑ #F8F8F8 = 深色主题正文色
（255 个里）background=Color(0.0, 0.0, 0.0, 0.0, sRGB)      ← ★ 一个设 background 的都没有
```

- **宿主给正文 span 设 `color`** ⇒ color 这条道**有主**
- **宿主从不设 `background`** ⇒ background 这条道**无主**

**⇒ 我们写 color 会跟宿主抢（它赢），写 background 没人抢（我们赢）。**

**② `append(AnnotatedString, start, end)` 会夹带原串在该区间的 span**

内部走 `pn.a(Lkn;IILq3;)Ljava/util/List;`：

```smali
.method public static final a(Lkn;IILq3;)Ljava/util/List;
    if-nez p1, :cond_45              # start == 0 ?
    iget-object p0, p0, Lkn;->b:Ljava/lang/String;
    invoke-virtual {p0}, Ljava/lang/String;->length()I
    if-lt p2, p0, :cond_45           # 且 end >= 全长 ?
        return-object v0             # 整条原样返回
    :cond_45
        ... 裁剪路径：把落在区间内的 span 裁进来，一并返回
```

**③ Compose 合并重叠 span 的规则：后加的赢**

### 10.2 机制闭环

```
pushStyle(我们的颜色)               → 我们的 span 进列表（第 N 条）
append(orig, plain, i)             → 宿主的 color=浅灰白 也进来，排在**第 N+1 条**
                                     ⇒ 后加的赢 ⇒ 我们的颜色被盖
```

**而 background 宿主没设 ⇒ 没有第 N+1 条来抢 ⇒ 我们的活下来。**

### 10.3 修法

**当我们自己压着样式时，用 `append(String)` 纯文本，不用 `append(AnnotatedString,…)`：**

```java
private static void appendText(Object nb, Object orig, String text,
                              int from, int to, boolean styled) throws Exception {
    if (to <= from) return;
    if (styled) {
        mAppendStr.invoke(nb, text.substring(from, to));   // 纯文本：不带原串样式
    } else {
        mAppendKn.invoke(nb, orig, Integer.valueOf(from), Integer.valueOf(to));
    }
}
```

**⇒ 代价：被我们接管的那段文字会丢原文 markdown 样式（要粗体自己写 `<b>`）。**

> `emit` / `emitAnon`（模板段 / 匿名包裹）本来就用 `append(String)` ⇒ 一直是对的。
> **所以"模板模式没问题、裸标签出问题"也是同一个根因。**

### 10.4 ★ Compose `Color` 的 packed 布局（重要参照，别再推）

**ground truth = `k53.smali` 里的 `S0(J[FI)V`（把颜色解构进 float 数组），顺序 `h,g,e,d`**，
而 Compose 的 `toComponents` 顺序是 **红 绿 蓝 透明度**：

```
h(J)F = red    → value >>> 48       (bits 48-55)
g(J)F = green  → value >>> 40       (bits 40-47)
e(J)F = blue   → value >>> 32       (bits 32-39)
d(J)F = alpha  → value >>> 56       (bits 56-63)
```

**⇒ 布局 = `alpha(56) red(48) green(40) blue(32)`，即 ARGB 从高位到低位。**

**⇒ `packed = argb.toLong() shl 32` 是对的。**

> ⚠️ 我一度按位移"推"成 `d=red, h=alpha`（正好全反），并据此宣告编码错误 —— **错的**。
> **教训：找参照物（谁在用这些 getter），不要从位移推语义。**

### 10.5 取证方法（可复用）

| 手段 | 适用 | 边界 |
|---|---|---|
| **`Java.choose('f0a')` 扫 SpanStyle** | 看**常驻**样式（主题色、基础样式） | ✅ 好用 |
| `Java.choose('kn')` 扫 AnnotatedString | 看**瞬时**对象 | ❌ 基本扫不到（Compose 释放太快） |
| **hook `fz2.p` 现场 dump** | 看渲染那一刻的 span 列表 | ⚠️ 需要 25 秒窗口内有人触发渲染 |
| **把失败原因画成图回给宿主** | 让主人一眼看到错误 | ✅ 最省事（3.48.1 起） |
| `document.title` 写诊断 | frida 一句 `getTitle()` 读到 | ✅ 比 `registerClass` 回调稳 |
