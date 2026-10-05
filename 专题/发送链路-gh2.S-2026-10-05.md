# 专题 · 发送链路（模块自己发消息）· frida 实证

> 🐲 尼得亚伯 · 2026-10-05
> 宿主：`com.deepseek.chat.a` **2.6.1**（smali 树 = `tmp/h261`）
> 手段：**frida 白名单网关**（投 job → 读 result，35 秒一轮）
> 前置：`专题/音频通话.md`（2.5.2 的旧链路）· `专题/回复建议.md`（旧版"回复建议"）
> 状态：**链路已打通并真机验证发出过消息**；只剩"发到当前会话"的参数对齐

---

## 〇、一句话

需求：模块要能**自己发一条消息给 AI**（用于 `<Suggestion>` 点击后自动追问）。

2.5.2 时代的老路子（`new cn1(text,mask)` + `ao1.J(cmd)`）在 2.6.1 **全废**
（`cn1`/`yp1` 在 `GmRemap` 里都是 `null`，`ao1` 这个名字还被 Dagger 类抢了）。

本轮用 frida 把 2.6.1 的**真实发送链路**从头挖出来了。

---

## 一、★★★ 完整调用链（frida + 静态双向实证）

```
【用户点发送按钮】
   │
   ├─ qg2 / rg2        Compose 的 onClick 协程
   │      └─ pvb.y(...)   ★ 埋点 "send_button_click"（可用来确认"真的点了发送"）
   │
   ├─ dh2              onClick 的协程体（lambda 类）
   │      ├─ x42.o()            拿「输入框状态」gj2
   │      ├─ new lg3(文本, sp5)  造新草稿内容
   │      ├─ gj2.a(gj2, lg3)     换成新文本
   │      └─ gh2.R(newGj, dh2.h, dh2.k, dh2.l)
   │
   └─ gh2.R(gj2, List, m1a, Z)
          ├─ 检查：gh2.A.c(text) / gh2.B 状态不是 oh2 / sf1 门
          ├─ x42.o() → gj2.a → 草稿列表
          ├─ new qg2(...)          ★ 发送协程
          └─ zj3.f0(scope, ..., qg2, 3)   启动协程
                 │
                 └─ qg2.z()   遍历草稿 ny1 → 构造请求 → 发网络
                        └─ 消息进 ns（消息存储）■ 消息数 0 → 1 实测

另有静态封装：gh2.S(gh2, gj2, List, m1a, Z, mask)   ← Kotlin 默认参数版（推荐用这个）
```

**★ 实测确认**：用 `gh2.S` 主动调用后，**消息真的发出来了**（主人肉眼确认）。

---

## 二、★ 锚点对照表（2.6.1 实测）

| 混淆名 | 真身 / 作用 | 关键签名 |
|---|---|---|
| **`gh2`** | 会话组件（= 2.5.2 的 `ao1`） | 发送入口宿主；**`W()` 取消息存储 `ns`** |
| **`gn2`** | 输入框组件（Compose） | `c(j42)` 事件入口；`P()` 取会话；`n:x42` |
| **`x42`** | 会话控制器（发送逻辑所在） | `o()`=输入框状态 · `m()`=引用消息 · `s/b/A/x`=发送族 |
| **`ns`** | 消息主存储（`wr`→`ns`） | `a:String`=会话 id · `f:LinkedHashMap`=消息表 |
| **`f42`** | 发送事件（**带附件**）`(String text, x33)` | → `x42.s(t,x33,sid)`（**需非 null 附件，纯文本不用它**） |
| `h42` | 仅附件事件 `(x33)` | → `x42.b(x33,sid,Z)` |
| `zm2` | **设置输入框文本** `(String)` | `gn2.c(zm2)` → 改 `gj2` 状态 |
| **`gj2`** | 输入框状态 | `a:dz9`（草稿列表）· `b:q08`（草稿内容 MutableState）· `c()`=取文本 |
| **`lg3`** | 草稿内容 | `<init>(String, sp5)` |
| **`n2a`** | MutableState 实现 | `getValue()` · **`j(Object)` = setValue（R8 改名）** |
| **`m1a`** | ★ **发送目标标识** | `<init>(long, String)` · 字段 `b:J` · `a:String` |
| `dh2` | 发送按钮的协程体（lambda） | 字段 `j:String`(文本) `k:m1a` `h:List` `l:Z` |
| `qg2` | **发送协程**（遍历草稿 → 发网络） | `<init>(List,gh2,String,List,ZZIZZLm1a,String,Continuation)` |
| `x33` | **附件对象** | `<init>(Uri, String, long, int, int)` —— 全树只有 `n32` 从 `File` 造过 |
| `pvb.y(...)` | 埋点（12 参） | 第一个参数是 `chat_message_id` ⇒ **点发送的可靠信号** |

---

## 三、★★★ 发送的正确姿势

```java
// ① 拿 gh2 实例（宿主会话组件）
Object gh2 = /* hook gh2.R / gh2.S 的 thisObject，或 Java.choose("gh2") */;

// ② 拿当前输入框状态 gj2，并换成我们的文本
Object x42  = gh2.a0();                          // x42
Object gj0  = x42.o();                           // gj2（注意：不是 x42.j.getValue()！）
Object lg3  = new lg3(要发的文字, null);           // sp5 可 null
Object newGj = gj2.a(gj0, lg3);                  // gj2.a(gj2, lg3) -> gj2

// ③ m1a —— ★★★ 这一步是成败关键（见第四节）
Object m1a = /* 必须是「当前会话」的那个，不能自己 randomUUID */;

// ④ 发！
gh2.S(gh2, newGj, list, m1a, false, 0);
//        ↑      ↑     ↑    ↑     ↑   ↑ mask
//        |      |     |    |     |   0 = 三个参数全用传入值
//        |      |     |    |    false
//        |      |     |    m1a（不可为 null！）
//        |      |     List（null 可能崩，传空 ArrayList 更稳）
//        |      gj2（含文本）
//        会话组件
```

**`mask` 语义**（Kotlin 默认参数，实证）：bit 置位 = **该参数取默认值**

| bit | 参数 | 默认值 |
|---|---|---|
| `0x1` | `gj2` | `gh2.a0().o()`（当前输入框状态） |
| `0x2` | `List` | `null` |
| `0x4` | `m1a` | **`new m1a(SystemClock.elapsedRealtime(), UUID.randomUUID())`** ⚠️ |

> ⚠️⚠️ **mask=0x4 千万别用** —— 那等于"发到一个随机新会话"！

---

## 四、⚠️⚠️⚠️ 最大的坑：`m1a` 不是"模型参数"，是「发送目标」

**症状**：用 `gh2.S(gh2, gj2, null, m1a=自己造的随机值, false, 0)` 发送，
消息**确实发出去了**，但**每次都开了一个新对话**（主人实测：三条消息 = 三个新会话）。

**原因**：`m1a` 的默认值就是 `new m1a(elapsedRealtime, randomUUID)` ——
**它标识"这次要发到哪个会话/哪次对话"**。

> `gh2.S` 默认分支原文（`gh2.smali:5618`）：
> ```smali
> and-int/lit8 v0, p5, 0x4
> if-eqz v0, :cond_26
>    new-instance p3, Lm1a;
>    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;
>    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
>    invoke-direct {p3, v1, v2, v0}, Lm1a;-><init>(JLjava/lang/String;)V
> ```

**⇒ 正确的 `m1a` 必须从「当前会话」拿。** 已知的两条线索：

1. `ch2`（`gh2` 的内部状态/协程续体）有 **`g:Lm1a;`** 字段 —— `gh2.smali:3177` 读它、`3503` 写它
2. `dh2`（发送按钮 lambda）的 **`k:Lm1a;`** 就是从 UI 层一路传下来的那个

**⇒ 下一步（未完成）**：hook `gh2.S` / `dh2.z` 打印**真实发送时的 `m1a`**，
就能确定"当前会话的 m1a"从哪个字段取。**这是整条链最后一块拼图。**

---

## 五、★ 踩过的坑（按代价排序）

| # | 坑 | 教训 |
|---|---|---|
| 1 | **`x42.s(text, x33, sid)` 不是发送入口** | 我在这条路上花了好几轮：它**能调用成功**，但**从不真正发出**。真入口是 `gh2.R`/`gh2.S`。**"能调通"≠"是入口"** |
| 2 | **`m1a` 乱造 ⇒ 每次都开新会话** | 参数语义要从**默认值**反推（`UUID.randomUUID()` 一看就是"新标识"），别只看类型名 |
| 3 | **主动调用 `gh2.R(..., m1a=null, ...)` 崩宿主** | 参数没对齐就别急着调；**先只读观测**。崩了要 `am start -S` 重启 |
| 4 | **`x42.j.getValue()` ≠ `x42.o()`** | `dh2` 用的是 `x42.o()`。同一份"输入框状态"有两个出口，**要抄就抄真实调用那条** |
| 5 | **`n2a.setValue` 不存在** | R8 把它改名成 **`j(Object)`**。列一遍方法表就能发现（`getValue` 还在，setter 却没了） |
| 6 | **`Java.choose('gn2')` 永远是 null** | 输入框组件的实例 frida 抓不到 ⇒ **改用 hook 构造器 / 或从 `gh2.a0()` 绕过去** |
| 7 | **`frida_job.txt` 会被队列积压覆盖** | 多轮投递要**每轮都落盘**（`cat result.txt >> log`），否则前一轮的日志会被覆盖丢掉 |
| 8 | **网关 30 分钟自动退** | 每轮实验前确认网关还活着（`result.txt` 的时间戳就是信号） |

---

## 六、下一步（按顺序）

1. **拿真实 `m1a`**：hook `gh2.S` + `dh2.z`，主人发一条普通消息 ⇒ 打印 `m1a` 的 `a`/`b`
   - 若 `m1a.a` == `ns.a`（会话 id）⇒ 可以直接 `new m1a(elapsedRealtime, ns.a)`
   - 否则从 `ch2.g` / `gh2` 的某个字段取
2. **确认 `List` 参数**：真实值是 `dh2.h`（非 null）—— 若传 null 会崩，改传 `new ArrayList()`
3. **模块化**：`bridge/GmSender.java`
   - 捕获 `gh2` 实例（hook `gh2.S` / `gh2.R` 的 `thisObject`）
   - `send(String text)`：`x42.o()` → `gj2.a(..., lg3)` → `gh2.S(..., m1a, false, 0)`
   - 锚点全部走**结构自检**，找不到就整体不启用
4. **接上 `<Suggestion>`**：`GmRichLink` 的 listener 里调 `GmSender.send(payload)`
5. UI 开关 + 日志

---

## 七、旧链路对照（2.5.2，已废）

```java
// 2.5.2（音频通话时期，真机验证过）：
Lyp1; input = new Lyp1();      // 输入框状态
input.c("文字");
Lao1;->I(Lyp1;)V               // 发送

// 2.6.1 现状：
//   yp1 → GmRemap 里 = null（未定位）
//   ao1 → gh2（但 ao1.I → ？ 未对上；真实入口是 gh2.R / gh2.S）
//   底座 GmCallDialog.testSend()/send() 代码仍在，但 sYp1 恒 null ⇒ 静默不工作
```

**⇒ 结论：旧链路在 2.6.1 上彻底不可用，用本专题的新链路。**
