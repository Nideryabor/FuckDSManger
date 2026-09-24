# 宿主 · 消息分片（fragments）体系 · DeepSeek 2.5.2 / vc273

> 侦查日期：2026-09-24　｜　侦查人：尼得亚伯 🐲
> 工作区：**`4jxpk0y3`**（`deepseek2.5.2 (273).apk`，13311 类，只读）
> 结论来源：**smali 直读 + dex_strings 里宿主自带的 source/property 名字符串**（`?t8` 系列序列化器把 FQN 全暴露了）
> 用途：给「AI 回复显示到通话页」这条**已暂停线**（见 `版本/2.20.0.md` 第五节）提供**确定的数据模型**，接回时不必再猜。

---

## 0. 一句话

**AI 回复的正文不是「一个字符串字段」，而是消息里一串「分片（fragment）」中的一个。**
`nx`（= `AppStaticMessage`）的 **`v`** 字段就是 **`fragments`** 列表；
`vq.C()` / `vq.l()`（模块 `aiText` 的底层）**只从 `gg0` 系的碎片里取字**，
而在 `nx.v` 里那就是 **`tt8` = `StaticChatMessageFragment.ResponseFragment`**（`type` = `RESPONSE` / `TEMPLATE_RESPONSE`）。

---

## 1. 容器链（实证 ★★★）

```
vq (抽象消息基类)
 └── nx = com.deepseek.chat.domain.chat.model.completion.message.AppStaticMessage   [唯一具体子类]
      ├─ v  : List  ← ★★★ 就是 "fragments"（descriptor idx 15）
      ├─ s  : List  = extra_search_providers (idx 12)
      ├─ u  : q06   = tips (idx 14)
      └─ w  : Boolean = has_pending_fragment (idx 16)  ← ★ 流式进行中标志

vq.s()  →  new a41(nx.v)         # a41 = StaticFragmentList（只读包装，toString="StaticFragmentList(innerList=")
vq.C()  →  for i in 0..vq.s().size():
              o = vq.s().get(i)
              check-cast o, v81                    # 列表元素类型 = v81
              if (o instanceof gg0) sb += ((gg0)o).j()   # ★ 只认 gg0 系
```

**证据**
- `kx.<clinit>`：`PluginGeneratedSerialDescriptor("…AppStaticMessage", 19)`，元素依次 =
  `message_id, parent_id, role, inserted_at, ban_edit, ban_regenerate, status, quasi_status, thinking_enabled,
  search_enabled, search_triggered, accumulated_token_usage, extra_search_providers, feedback, tips,
  **fragments**, **has_pending_fragment**, conversation_mode, incomplete_message`
- `kx.b(CompositeEncoder, Object)`（序列化器）：把每个字段按**字面量索引**写出，其中
  - `const/16 v0, 0xf` + `sget-object v3, Ly31;->a:Ly31;` + `new-instance v4, La41;` `a41(nx.v)` + `Lpn9;->J(desc, 0xf, y31, a41)` ⇒ **`nx.v` ↔ idx 0xf = fragments** ✓
  - `const/16 v3, 0x10` + `nx.w:Boolean` ⇒ **`nx.w` ↔ has_pending_fragment** ✓
  - `const/16 v3, 0x11` + `nx.x` 与 `"DEFAULT"` 比较 ⇒ idx 0x11 = conversation_mode ✓
  - `const/16 v3, 0x12` + `nx.y` ⇒ idx 0x12 = incomplete_message ✓
  - 交叉验证：idx 2 = role ↔ `nx.i`（配 `"ASSISTANT"` 判据）✓；idx 6/7 = status/quasi_status ↔ `nx.m`/`nx.n`（`w91` 包装）✓
- `nx.s()`：`new a41` + `iget-object p0, p0, Lnx;->v:Ljava/util/List;` ⇒ **`s()` 包的是 `v`，不是 `s` 字段**（旧文档曾写成「块表 = `nx->s`」，此处更正）

> ⚠️ **更正**：`nx.s` 字段 = extra_search_providers；块表外壳 `nx.s()` **方法** 包的是 `nx.v`。别混。

---

## 2. 分片的两个「形态」（实证/强推断）

宿主把每个分片都做了**两份实现**：

| 形态 | 接口 | 名字 | 特点 |
|---|---|---|---|
| **静态/存储态** | `ou8` | `StaticChatMessageFragment` | `@Serializable`，随消息进 DB / 反序列化，**`nx.v` 里装的就是它** |
| **动态/UI 态** | `x43` | `DynamicChatMessageFragment` | 带 Compose 渲染方法 + 可变状态（`rs8` / `hp8`），只在内存 |

- 共同父接口：**`v81` = `ChatMessageFragment`**（只有 `e():String`（类型串）+ `getId():I` 两个方法）
- 互转：`x43.o():ou8`（动态→静态）、`ou8.b():x43`（静态→动态）
  - 实证：`q43.<init>` **只**被 `tt8.b()` 调用；`tt8.<init>` **只**被 `q43.o()` 调用（一对互转）
- 桥接序列化器：**`y43` = `ChatMessageFragmentSerializer`**
  `y43.b(enc, v)` = `v.o()` 后交给 `it8.serializer()`；`y43.e(dec)` = 解出 `ou8` 后 `.b()` 还原 `x43`
- `it8` = `ou8.Companion`，`it8.serializer()` = `new gs3(1)`

> 「`ou8` = StaticChatMessageFragment / `x43` = DynamicChatMessageFragment」是**强推断**：
> 10 个静态类的字符串形如 `…fragments.StaticChatMessageFragment.ResponseFragment`，
> 动态类的字符串形如 `…fragments.DynamicChatMessageFragment.ReadLinkFragment`，
> 且 `y43` 自报名为 `ChatMessageFragmentSerializer`。

---

## 3. ★ `type` → 具体类 路由表（`gs3`，`ou8` 静态族 = **实证 ★★★**）

`gs3`（extends `vu4`，多态序列化器）的 `h(Lev4;)`：
- 取 JSON 的 **`"type"`** 字段（缺失 ⇒ `IllegalArgumentException("Missing 'type' field")`）
- `packed-switch` 两个模式：`new gs3(1)` = 静态族（`it8.serializer()`）

### 3.1 静态族（`ou8` = `StaticChatMessageFragment`）——共 10 个 final 具体类

| `type` | 混淆名 | 真实名 | 备注 |
|---|---|---|---|
| **`RESPONSE`** / **`TEMPLATE_RESPONSE`** | **`tt8`** | `StaticChatMessageFragment.ResponseFragment` | ★★ **AI 正文就在这里** |
| `THINK` | `au8` | `.ThinkFragment` | 思维链（带 `elapsedSeconds:Float`） |
| `TIP` | `du8` | `.TipFragment` | |
| `FILE` | `kt8` | `.FileFragment` | 另有 `StaticChatMessageFileFragmentSerializer.FileFragmentSurrogate` |
| `SEARCH` / `TOOL_SEARCH` | `xt8` | `.SearchFragment` | 带 `queries` / `results` |
| `TOOL_OPEN` | `ku8` | `.ToolOpenFragment` | |
| `TOOL_FIND` | `gu8` | `.ToolFindFragment` | |
| `READ_LINK` | `nt8` | `.ReadLinkFragment` | |
| `REQUEST` | `qt8` | `.RequestFragment` | |
| （其余/默认 + `"link"`/`""`） | `nu8` | `.UnknownFragment` | 兜底 |

**名字是怎么钉死的**：`?t8` 系列是**生成的 serializer**，其 descriptor 字符串直接写了 FQN：
`rt8`→ResponseFragment · `yt8`→ThinkFragment · `bu8`→TipFragment · `et8`→FileFragmentSurrogate ·
`vt8`→SearchFragment · `iu8`→ToolOpenFragment · `eu8`→ToolFindFragment · `lt8`→ReadLinkFragment ·
`ot8`→RequestFragment · `lu8`→UnknownFragment
（与其配套的 Companion：`st8/zt8/cu8/jt8/wt8/ju8/fu8/mt8/pt8/mu8` 分别挂在 `tt8/au8/du8/kt8/xt8/ku8/gu8/nt8/qt8/nu8` 上 ⇒ 一一对应）

### 3.2 动态族（`x43` = `DynamicChatMessageFragment`）——8 个 final 具体类

| 混淆名 | 真实名 | 证据 |
|---|---|---|
| `p43` | `.ReadLinkFragment` | 字符串实证 |
| `r43` | `.SearchFragment` | 字符串实证 |
| `s43` | `.ThinkFragment` | 字符串实证 |
| `u43` | `.ToolFindFragment` | 字符串实证 |
| `v43` | `.ToolOpenFragment` | 字符串实证 |
| `q43` | `.ResponseFragment` | 强推断（与 `tt8` 互转 + `gg0` 同族） |
| `t43` | `.TipFragment` | 强推断（与 `du8` 同挂 `qg0`，`du8` 已实证 TIP） |
| `w43` | `.UnknownFragment` | 强推断（与 `nu8` 同构） |

### 3.3 `gs3` 的另一个模式（`new gs3(0)`）——4 个类型，**用途未确认**

`SEARCH`→`as3` · `TOOL_OPEN`→`xr3` · `TOOL_FIND`→`ur3` · 默认→`ds3`（各自 Companion `zr3`/`wr3`/`tr3`/`cs3`）
⇒ 疑似「流式增量的部分分片」，待查。

---

## 4. 抽象基类（`?g0` 家族）

| 混淆名 | 名字 | 证据 | 具体子类 |
|---|---|---|---|
| `ah0` | `BaseToolOpenFragment` | 字符串 ★★★ | `ku8`(静) / `v43`(动) |
| `ig0` | `BaseSearchFragment` | 字符串 ★★★ | `xt8`(静) / `r43`(动) |
| `vg0` | `BaseToolFindFragment` | 字符串 ★★★ | `gu8`(静) / `u43`(动) |
| `eg0` | `BaseReadLinkFragment` | 字符串 ★★★ | `nt8`(静) / `p43`(动) |
| `qg0` | `BaseTipFragment` | ★★（`du8`/`t43` 同挂 + `ng0` 持有 `BaseTipFragment.TipStyle`） | `du8`(静) / `t43`(动) |
| **`gg0`** | **未暴露**（正文族基类） | `vq.C()` 的 `instance-of` 目标；只有 `q43`/`tt8` 两个子类 | **`tt8`(静) / `q43`(动)** |
| `mg0` | 未暴露（Think 族基类） | `au8`/`s43` 同挂；`equals/hashCode` 用 `k():String` + `m():Float` | `au8`(静) / `s43`(动) |
| `r8a` | 未暴露（接口，`a():List`） | `gg0`、`mg0` 都 implements 它 | — |

配套枚举/小类：`ng0`=BaseTipFragment.TipStyle · `sg0`=BaseToolFindFragment.Status · `xg0`=BaseToolOpenFragment.Status · `bg0`=BaseReadLinkFragment.Status · `bs3`=FragmentReference.UnknownFragmentReference

`gg0` / `mg0` 的方法形状：
```
gg0(abstract, implements r8a): j():String  k():ps8
mg0(abstract, implements r8a): j(Ley3;)Lhv3;  k():String  l():ps8  m():Float
q43 (=gg0, 动态正文): a():List  j():String(= 字段 d:rs8 的 getValue)  k():ps8  o():Lou8(→tt8)
tt8 (=gg0, 静态正文): a():List(字段 d)  j():String(= 字段 f:rs8 的 getValue)  b():Lx43(→q43)
```
⇒ **`q43`/`tt8` 的 `j()` 都是读一个 `rs8` 可变状态** ⇒ 流式追加就是「改写这个 `rs8`」。

---

## 5. 「合并工具」类（不属静态族，运行时构造）

| 混淆名 | 实现 | `e()`（类型串） | 备注 |
|---|---|---|---|
| `l53` | `v81` | `MERGED_TOOL_FIND` | 构造器 118 条指令，内含 `j32.B0` |
| `cv8` | `uf0` | `MERGED_TOOL_OPEN` | `WIP`/`FINISHED`/`FAILED` |
| `n53` | `uf0` | `MERGED_TOOL_OPEN` | 带两个 `vp1` 状态 |
| `q53` | `v81` | （字段 `c`） | 有 `g():List`、`h()/i():wz5`（`FINISHED`） |

`uf0`（接口：`d(Ley3;)Lhv3;` / `f(Ley3;)Lhv3;`）只被 `cv8`/`n53` 实现。

---

## 6. 序列化器索引

| 混淆名 | 名字/作用 | 证据 |
|---|---|---|
| `kx` | `AppStaticMessage` 的生成序列化器（`a` = INSTANCE） | `kx.<clinit>` 的 descriptor |
| **`gs3`** | **分片多态序列化器**（`type` 分发） | `h(Lev4;)` 的 `Missing 'type' field` |
| `y43` | `ChatMessageFragmentSerializer`（`x43` ⇄ `ou8`） | `y43.<init>` 的 `Ljc5;->i("ChatMessageFragmentSerializer")` |
| `y31` | `fragments` 字段的 List 序列化器（`sget-object Ly31;->a`） | `kx.b` idx 0xf |
| **`a41`** | `StaticFragmentList`（只读 List 包装，`Companion:z31`） | `toString()` 字符串 |
| `k53` | `DynamicFragmentListSerializer` | 类内字符串 |
| `v83` | `emptyList` 单例（`v83.a`） | `kx.b` 里与 `nx.v` 比较 |

---

## 7. 对模块的价值（接回「AI 回复 → 通话页」时直接用）

1. **正文取法没写错**：`vq.C()`/`vq.l()` 就是「从 `nx.v`(=fragments) 里挑 `gg0` 系拼 `j()`」⇒ `aiText` 的方向是对的。
2. **为什么可能取到空**：`C()` **只认 `gg0`**。如果那一刻列表里只有 `au8`(THINK) / `xt8`(SEARCH) / `ku8`(TOOL_OPEN) 等，`C()` 会返回空串，**不是 bug**。AI 正文分片是 `tt8`(`RESPONSE`)。
3. **★ 免费的「生成结束」信号**：`nx.w:Boolean` = **`has_pending_fragment`**（descriptor idx 16）。
   比现在的「文本连续 3 秒不增长」硬得多，也不依赖早就被证伪的 `um1`。
4. **流式的真正落点**：动态正文 `q43` 的 `d:rs8`（文本状态）与 `f:hp8`（SnapshotStateList）。
   想「边生成边显示」，正路是盯 `q43` 那两个状态容器，而不是继续猜 setter。
5. **别碰的点**：`x43` 动态族的渲染方法（`k/f/q(Ley3;)`）跑在 Compose 热路径上，和 2.18.0 踩过的 `vq.S` 同类。

---

## 8. 复核命令速查（`workspaceId 4jxpk0y3`）

```
容器链     mt_apk_read_text  dex_method:Lvq;->C()Ljava/lang/String;
           mt_apk_read_text  dex_method:Lnx;->s()Lb41;
           mt_apk_dex_xref   dex_field:Lnx;->v:Ljava/util/List;   (not_applicable)
字段名     mt_apk_read_text  dex_method:Lkx;-><clinit>()V          # descriptor 19 个名字
字段↔索引  mt_apk_read_text  dex_method:Lkx;->b(Lpn9;Ljava/lang/Object;)V
多态表     mt_apk_read_text  dex_method:Lgs3;->h(Lev4;)Lv35;
桥         mt_apk_dex_outline_class dex_class:Ly43;
具体类清点 mt_apk_search smali  query=".implements Lou8;"   → 10 个（静态族）
           mt_apk_search smali  query=".implements Lx43;"   →  8 个（动态族）
类名还原   mt_apk_search dex_strings query="ChatMessageFragment" / "fragments.Base"
基类归属   mt_apk_search smali  query=".super L<基类>;"        # eg0/ig0/vg0/ah0/qg0/gg0/mg0
```

---

## 9. 把握分级（别把推断当实证 —— 见 `专题/界面导航管理器-宿主对照.md` §4.5）

| 结论 | 把握 |
|---|---|
| `nx.v` = `fragments`（descriptor idx 15） | **实证 ★★★**（两条独立证据：`<clinit>` 名字序 + `b()` 的索引） |
| `nx.w` = `has_pending_fragment` | **实证 ★★★** |
| 10 个静态具体类 与 `type` 的对应 | **实证 ★★★**（`gs3.h` 直读） |
| 10 个静态类的**名字** | **实证 ★★★**（生成序列化器里的 FQN 字符串） |
| 5 个动态类名（p43/r43/s43/u43/v43） | **实证 ★★★** |
| 4 个 Base 类名（ah0/eg0/ig0/vg0） | **实证 ★★★** |
| `v81`/`ou8`/`x43` 的名字 | **强推断 ★★☆**（命名法 + `y43` 自报名） |
| `qg0` = BaseTipFragment | **实证 ★★☆** |
| `q43/t43/w43` 的动态类名 | **推断 ★☆☆**（同构） |
| `gg0`/`mg0`/`r8a` 的名字 | **未知**（字符串里没暴露，只能按族关系描述） |
| `gs3` 模式 0（`as3/ds3/xr3/ur3`）的用途 | **未知** |
