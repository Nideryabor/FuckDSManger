# 气泡背景 · frida 实测结论（2026-10-31）

> 这部分是**有价值的硬证据**。下次直接从这儿开始，别再重新摸。

---

## 一、frida 通道怎么用（别再摸错）

```sh
# 主人：手机终端（真 su）起窗口
su -c 'sh /data/adb/frida/frida.sh'

# 我：投 job → 读 result
{ echo "id=xxx"; echo "target=com.deepseek.chat.a"; echo "timeout=120"; echo "---"; cat 脚本.js; } > /tmp/job.txt
sh /workspace/tools/出笼隧道/adb.sh push /tmp/job.txt /data/local/tmp/frida_job.txt
sh /workspace/tools/出笼隧道/adb.sh shell "cat /data/local/tmp/frida_out/result.txt"
```

### 判断网关是否活着：**别用 `ps -A | grep frida`**

进程名是 **`run.sh`**，没有 frida 字样 ⇒ 会误判成"没起来"（我今天误判两次）。

```sh
sh /workspace/tools/出笼隧道/adb.sh shell \
  "for p in /proc/[0-9]*; do c=\$(cat \$p/cmdline 2>/dev/null | tr '\0' ' '); case \"\$c\" in *run.sh*) echo \$p \$c;; esac; done"
# 正确输出： 534 : sh /data/adb/frida/run.sh --watch 1800
```

### 目标被冻结时网关会 `status=deny`

```
note=目标被冻结且就地解冻失败（oom_adj=900）。请手动打开一次再投。
```
⇒ 先手动打开一次。

---

## 二、`x98.t` / `x98.s` 签名（frida 枚举，与反编译完全一致）

```
t#0 : yj7 [Lyj7;] , long [J] , sy9 [Ly9;]              -> yj7
s#0 : yj7 [Lyj7;] , js0 [Ljs0;] , sy9 [Ly9;] , int [I] -> yj7
```

⇒ `GmPrims` 的签名匹配思路是对的；
⇒ `GmRemap` 的 `uia.v → x98.t` / `uia.u → x98.s` 映射也对。

**注意**：frida 里类型名是**混淆名 `yj7`**，不是 `androidx.compose.ui.Modifier`。
探测脚本按"首参类型 == 返回类型"筛，别按全名筛。

---

## 三、★★ `x98.t` **确实被调用**（推翻"R8 内联"的错误结论）

真机 `dsm.log`（14:23 / 14:28 两次滑动时）：

```
x98.t:-2 | 色=-9219133355105189888 | sd=0 | ub=0 | ud=0 | 形=kc5
x98.t:-2 | 色=-9214894673355603968 | sd=0 | ub=1 | ud=0 | 形=kc5   ← ub=1
x98.t:-2 | 色=-9223372036854775808 | sd=0 | ub=0 | ud=1 | 形=kc5   ← ud=1
```

**`ub=1` / `ud=1` 是用户气泡作用域的现成标记**：

| 标记 | 字段 | 谁维护 |
|---|---|---|
| `ub` | `GmBubble.sUBub` | `GmUBubbleHook`（挂 `wb0.e`）before +1 / after -1 |
| `ud` | `GmBubble.sUDepth` | `GmBubbleCellHook`（挂 `cfb.g`） |

### 为什么之前 frida 抓到 `x98.t ×0`

**因为没让屏幕动** —— Compose 不重组，一条都不调。
**抓渲染相关的东西，必须先让屏幕滚动起来。**

---

## 四、`ubMod` 从来没被调用（×0），卡在 caller 门

`GmBubblePaintHook.ub()` 的门槛链：

```
uOn() → isColorVer(name) → args.len>=3 → caller().startsWith(uCaller()) ★ → shape() → hostShape() → ubMod
```

`uCaller()` = `GmRemap.clsFor("ls9","f") + "." + method("ls9","f")` = **`wb0.e`**。
真实调用来自 **`okb.e`**（`UserChatMessageBubble.kt:261`）⇒ **这道门恒假**。

frida 实测：`GmBubble.ubMod ×0`、`PaintHook.ub ×40+`、`GmBubble.shape ×20（都返回 ib9）`。

---

## 五、用户气泡真的在用 `x98.t`

反编译 `okb.e`（`UserChatMessageBubble.kt:261`，2695 行）：

```smali
iget-object v5, v5, Leo3;->i:Ldo3;
iget-wide v8, v5, Ldo3;->a:J          # 颜色（宿主主题色）
sget-object v5, Lvcc;->n:Lkc5;        # 形状
invoke-static {v4, v8, v9, v5}, Lx98;->t(Lyj7;JLsy9;)Lyj7;
```

⇒ **用户气泡的 Modifier 就是被 `x98.t` 画的**。

---

## 六、`GmBubble.wrap` 处理的**不是**气泡背景

frida 实测：`[wrap] #1~#9 mod=y6a → 返回 r13`，共 13 次。

`y6a` 的 Kotlin metadata：
```
d2 = {"Ly6a;", "Ldk7;", "La7a;", "foundation-layout"}
```

⇒ **`y6a` 是 `foundation-layout` 的元素（padding/offset），不是背景**。
⇒ **在 `wrap` 里塞 background 注定摸错对象**（3.73.1 版"啥也没变"的原因）。

---

## 七、探测脚本

| 脚本 | 用途 |
|---|---|
| `tools/frida/probes/ub1~ub4.js` | 早期用户气泡探测（2026-10-02） |
| `tools/frida/probes/ube.js` | **本次主力**：挂 85 个候选背景原语，滑动后看谁命中 |

### `ube.js` 的正确写法要点

```js
// 1) 锚定宿主 ClassLoader（不能用模块的，否则 x98 都找不到）
for (...) { try { loaders[i].loadClass('com.deepseek.chat.MainActivity'); host = loaders[i]; break; } catch(e){} }
Java.classFactory.loader = host;

// 2) 结构判据：首参类型 == 返回类型（Modifier 链式标志）
if (at[0].className !== ov.returnType.className) return;

// 3) 回调里别用 this.xxx，要保存原重载对象
var ovT = x98.t.overload('yj7','long','sy9');
ovT.implementation = function(mod, color, shape){ ...; return ovT.call(this, mod, color, shape); };
```
