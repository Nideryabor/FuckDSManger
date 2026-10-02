# 宿主 Compose 混淆名对照表 🐲

> 2026-10-01 · 尼得亚伯
> 宿主：`com.deepseek.chat.a`（DeepSeek，Compose + R8 混淆）
> 实测样本：`41003` 个已加载类，其中 `androidx.compose.*` **20 个保留真名**

---

## 一、方法论：**从"已知世界"伸手进"未知世界"**

宿主的 Compose 被 R8 混淆了 —— `androidx.compose.ui.Modifier`、`DrawScope`、
`LayoutNode` 这些名字**全都不在**运行时类表里。

但有一批类**名字没被改**：

```
androidx.compose.ui.platform.AndroidComposeView      ← 系统 View 体系要按名引用它
androidx.compose.ui.platform.AbstractComposeView
androidx.compose.ui.platform.ComposeView
androidx.compose.ui.platform.AndroidViewsHandler
androidx.compose.ui.viewinterop.AndroidViewHolder
androidx.compose.ui.graphics.layer.ViewLayer
androidx.compose.ui.graphics.layer.view.ViewLayerContainer
androidx.compose.ui.graphics.layer.view.DrawChildContainer
androidx.compose.ui.window.DialogLayout / PopupLayout
...
```

**这些保留真名的类，方法名也保留了**（`getModifier()`、`getLayoutNode()`、`getDensity()`…）。

于是只要做一件事：

> **把保留真名的方法签名打出来，看里面引用了哪些"单段短名"的类 —— 那些就是被混淆的 Compose 内部类。**

**一个方法名，换一个混淆类的真名。** 这就是全部技巧。

---

## 二、对照表（实测得出）

| 混淆名 | 真实身份 | 证据（来自保留真名的方法） |
|---|---|---|
| **`x97`** | **`androidx.compose.ui.Modifier`** ⭐ | `AndroidViewHolder.getModifier() : x97` / `setModifier(x97)` |
| `kb6` | `androidx.compose.ui.node.LayoutNode` | `AndroidViewHolder.getLayoutNode() : kb6` |
| `g33` | `CompositionContext` | `AbstractComposeView.setParentCompositionContext(g33)` |
| `pq3` | `Density` | `AndroidViewHolder.getDensity() : pq3` |
| `ph6` | `LifecycleOwner` | `AndroidViewHolder.getLifecycleOwner() : ph6` |
| `f79` | `SavedStateRegistryOwner` | `AndroidViewHolder.getSavedStateRegistryOwner() : f79` |
| `t23` | `ComposeViewContext` | `AbstractComposeView.getComposeViewContext$ui() : t23` |
| `xfb` | `ViewCompositionStrategy` | `AbstractComposeView.setViewCompositionStrategy(xfb)` |
| `xh7` | `AndroidViewHolder` 的 Dispatcher | `getDispatcher() : xh7` |
| `o69` | `SavableRegistryEntry` | `ViewFactoryHolder.setSavableRegistryEntry(o69)` |
| `cv4` | `Function2`（内容 lambda，即 `Composable`） | `ComposeView.setContent(cv4)` |
| `wd7` | `MutableState`（接口） | 只有 `setValue(Object)`；`k2a` 是其父接口 |
| `q08` | `SnapshotMutableState` 实现（带 `Parcelable`） | `getValue()/setValue()/writeToParcel()` |
| `yl1` | `CanvasHolder` | `ViewLayer.getCanvasHolder() : yl1` |

---

## 三、`Modifier` 的真实形状（`x97`）

```
x97:
  isInterface = true
  getDeclaredClasses().length = 0      ← R8 把内部类拍平了
  getDeclaredMethods().length = 3
      g0(cv4, Object) : Object         ← fun <R> fold(initial: R, operation: (R, Element) -> R): R
      x(x97) : x97                     ← infix fun then(other: Modifier): Modifier
      N(ou4) : boolean                 ← fun any(predicate: (Element) -> Boolean): Boolean
```

**只有 3 个方法 —— 所以实现成本极低。**

---

## 四、⭐ 能力验证：**运行时实现它，成功了**

```js
var X = Java.use("x97");                       // Modifier
var MyMod = Java.registerClass({
  name: "com.nidyaber.glass.ProbeModifier",
  implements: [X],
  methods: {
    g0: function (initial, operation) { return initial; },
    x:  function (other) { return other; },
    N:  function (pred) { return false; }
  }
});
```

**实测输出（2026-10-01 16:09，宿主 pid 30272）：**

```
x97.isInterface = true
✓ registerClass 成功 → com.nidyaber.glass.ProbeModifier
✓ 实例化成功 → com.nidyaber.glass.ProbeModifier
✓ instanceof Modifier = true        ← ★ 宿主认它
✓ 调 N() 成功，返回 false
✗ 调 then() 失败: TypeError: not a function   ← 见下方"待解决"
```

### 意义

> **"Xposed 侧编译期写不出 `implements Modifier`（名字被混淆）"**
> —— 这个障碍在 Frida 侧**不存在**。
>
> 我们拿到了**活的 `Class` 对象**，`registerClass` 出来的实例**通过 `instanceof`**。

---

## 五、待解决 / 下一步

| 项 | 说明 |
|---|---|
| `then()` 调不通 | `inst.x(inst)` 报 `TypeError: not a function`。可能是 Frida JS 桥上单字母方法名冲突，需要用 `.x.overload('x97').call(inst, other)` 形式。**不影响 registerClass 结论。** |
| `AndroidViewHolder.getModifier()` 同样报 `not a function` | 同上，改用 `.overload()` 显式调用 |
| **还没找到 draw 那一族** | `Modifier.Element` / `DrawModifier` / `Modifier.Node` / `DrawModifierNode` 还没定位。R8 把内部类拍平了，`getDeclaredClasses()` 返回 0 |
| **还没找到 `DrawScope` / `GraphicsLayer`** | 同上 |
| **注入点还没定** | 实现容易，把它**接进宿主的 composition** 才是下一步的难点 |

### 找 draw 那一族的思路（下一步）

1. `Java.choose("androidx.compose.ui.viewinterop.AndroidViewHolder")` → `getModifier()` →
   拿到一个**真实的 Modifier 实例**，看它的类实现了哪些接口 ⇒ 接口集合里就有 `Modifier.Element`
2. 从 `Modifier` 的实现类里筛出**带 `draw` 语义**的（方法签名含 `Canvas`/`DrawScope` 类）
3. `ViewLayer` / `ViewLayerContainer` / `DrawChildContainer`（**都保留真名**）
   是 Compose 挂 Android View 的桥 —— 也可能是**最省事的玻璃注入点**

---

## 六、工具

| 文件 | 用途 |
|---|---|
| `probes/recon2.js` | 列全部 compose 类 + 关键类探测 + 抓活 AndroidComposeView |
| `probes/recon3.js` | 读 AndroidComposeView 的字段**真值**（声明类型 → 运行时类型） |
| `probes/recon4.js` | ⭐ **打保留真名类的方法签名，捞混淆名**（本表就是它的产出） |
| `probes/recon5.js` | 验 `x97` 形状 + 找谁真的装着 Modifier |
| `probes/recon6.js` | ⭐ **`Java.registerClass` 能力验证** |

原始输出存于 `tmp/frida-probe/result-reconN.txt`。
