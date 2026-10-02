> 🔴🔴🔴 **2026-10-01 事故警告（必读，血的教训）**
>
> 本工具**用错姿势会把主人的手机搞崩**。已发生过一次：
> 拿 `com.android.settings` 当 spawn 靶子 ⇒ **frida 污染 zygote** ⇒
> 之后**系统设置、支付宝一开就崩**，而且 **adb 全程修不回来**，只有 `stop; start` 才能恢复。
>
> **硬规则：**
> 1. ❌ **不许拿系统 App / 系统框架做注入靶子** —— 要用就用自己的 App 或宿主
> 2. ❌ **不许 `kill -9` frida-server** —— 用 `pkill -x frida-server` 让它正常退
> 3. ✅ spawn 模式是"有系统级副作用"的操作，动手前先问自己"坏了谁收拾"
> 4. ✅ 真崩了 ⇒ 软重启框架 `su -c 'stop; start'`
>
> 完整档案：`专题/事故-2026-10-01-frida污染zygote.md`

---

# Frida 一条龙 🐲（2026-09-30 · 尼得亚伯）

> 目的：把「改一行 → 等 3~5 分钟」变成「改一行 → 秒级」。
> 顺带解决一个更根本的问题：**`Java.registerClass` 能在运行时实现混淆接口** ⇒
> 可以把玻璃**正着接进**宿主的 Compose，而不是像 Xposed 那样只能劫别人的 draw。

---

## 一条龙

```sh
sh frida.sh up                     # 起服务（推二进制/找可写目录/转发端口/自检）
sh frida.sh status                 # 看状态
sh frida.sh ps                     # 列进程
sh frida.sh eval   <包名|pid> '<js>'      # 跑 JS，回传输出  ★ 最常用
sh frida.sh attach <包名|pid> [x.js]      # 交互式挂上去
sh frida.sh watch  <包名> <脚本.js>       # 长驻脚本（Ctrl-C 退）
sh frida.sh selfshot [out.png]     # 让宿主自拍当前画面并拉回来（"眼睛"）
sh frida.sh down                   # 停服务 + 撤端口
```

宿主包名：`com.deepseek.chat.a`

---

## 起服务会撞的墙（已内置处理，但你要知道原理）

| 现象 | 真因 | 脚本怎么处理 |
|---|---|---|
| `adb: device offline` 反复出现 | adb daemon 自己死 | 每条命令前 `kill-server/start-server` + 重试 40 次 |
| `su -c 'xxx'` 静默没输出 | **这台设备是 `su 0 <cmd>`**（KernelSU） | 自动探测 `su 0` / `su -c` |
| `chmod: Operation not permitted`（/data/local/tmp） | KernelSU/susfs 保护，**root 也写不进** | 二进制放 `/data/adb` |
| `failed to create /data/local/tmp/frida-helper-*.dex` | frida 的 helper dex 走 temp 目录 | 起服务时带 `TMPDIR=/data/adb` |

⚠️ **不要 `setenforce 0`** —— 我试过一次，没用，而且那是动系统开关。（已复原成 Enforcing。）

---

## 上来就能用的 JS

### ① 列类（我现在全靠猜，有了这个就不用猜）

```sh
sh frida.sh eval com.deepseek.chat.a '
var n=0;
Java.enumerateLoadedClassesSync().forEach(function(c){
  if (/Modifier|DrawScope|DrawContext|GraphicsLayer|Semantics/.test(c)) { log(c); n++; }
});
log("命中 "+n+" 个");
'
```

### ② 拿**活的对象**（`Java.choose`）—— 这一招能省我好几轮试错

```sh
sh frida.sh eval com.deepseek.chat.a '
Java.perform(function(){
  Java.choose("androidx.compose.ui.Modifier", {
    onMatch: function(inst){ log("Modifier 实例: "+inst); },
    onComplete: function(){ log("done"); }
  });
});
'
```

### ③ dump 一个对象的字段（我猜 `DrawContext` 结构猜了 4 轮）

```sh
sh frida.sh eval com.deepseek.chat.a '
Java.perform(function(){
  var o = /* 上一步拿到的实例 */;
  var f = o.getClass().getDeclaredFields();
  f.forEach(function(x){ x.setAccessible(true); try{ log(x.getName()+" = "+x.get(o)); }catch(e){} });
});
'
```

### ④ 运行时实现一个混淆接口（**这是 Frida 真正的杀手锏**）

```sh
sh frida.sh eval com.deepseek.chat.a '
Java.perform(function(){
  var Modifier = Java.use("lc76");        // ← 宿主里 Modifier 的真实名字（会变，先搜）
  var Impl = Java.registerClass({
    name: "com.nidyaber.glass.GlassModifier",
    implements: [Modifier],
    methods: { /* 按接口方法逐个实现 */ }
  });
  log("已注册 " + Impl);
});
'
```

> 为什么要这个：Xposed 侧我们**编译期写不出 `implements Modifier`**（名字被混淆），
> 只能劫人家的 `draw` 再手动补 `drawContent()` —— 这正是"文字消失"那次事故的根源。
> 在 Frida 里可以**拿到活的 Class 对象再实现**，干净得多。

---

## 工作流建议

```
Frida 里把原型调对（秒级迭代）
        ↓
一次性移植回 Xposed 模块（mod-src/src/.../glass/）
        ↓
用 tools/adb/snapab.sh 做关/开 A/B 验收
```

---

## ⛔ 2026-09-30 实测结论：这台设备上 **Frida 用不了**

折腾了一整轮，卡在**注入阶段**，记录下来免得以后重走：

| 步骤 | 结果 |
|---|---|
| frida-server 启动 | ✅ 能跑（改用**真 su** 起，`/data/local/tmp` 才可写） |
| 端口 / 连接 | ✅ `127.0.0.1:27042` 从工作区**直连**（proot 与手机共用 netns，不用 adb forward） |
| `frida-ps` | ✅ 正常列进程 |
| **attach** | ❌ **把目标 App 直接搞崩** |

崩溃现场（`logcat -b crash`）：

```
signal 11 (SIGSEGV)  null pointer dereference
#00 … /memfd:frida-agent-64.so (deleted)     ← 崩在 frida 自己的 agent 里
#22 … linker64  call_constructors            ← dlopen 初始化就挂
#23 … linker64  do_dlopen
```

`am_crash` 旁证：**DeepSeek 和我们自己的模块 App 各崩了好几次**。

### 排除过的

| 猜测 | 实测 | 结论 |
|---|---|---|
| SELinux 挡 ptrace | `setenforce 0` 后**照样超时** | ❌ 不是它（**幸好先用 5 秒的法子验了，没白改规则**） |
| Android 15 的 16KB 页 | `getconf PAGE_SIZE` = **4096** | ❌ 不是 |
| tmp 目录不可写 | 真 su 起 → 可写 ✓ | 已解决 |

### 高度可疑：**susfs**

设备里有 `/data/adb/susfs4ksu`。susfs 会 hook `/proc`、`memfd`、路径可见性 —— 而 frida-agent 初始化正好要读这些。
**没验证**（要临时关掉隐藏 root，代价太大，主人没同意）。

### 另一条坑：`/data/local/tmp` 的可写性**取决于谁叫的 su**

```
真 su（终端 App）  → 写得进 ✓
adb 的 su（我）    → Permission denied ✗
```

⇒ **frida-server 只能由主人起**；我从 adb 重启一次就会把它弄坏。

### 所以

**这条路暂时放弃**（主人 2026-09-30 拍板走 C）。
回到 **Xposed + 宿主自拍 A/B** 那条：慢一点（每轮 3~4 分钟），但**能用、且不碰任何系统设置**。

---

## ✅✅ 2026-10-01 · 已修复：**换 frida-server 16.7.19**

> **一句话：不要再 use 17.19.0。BIN 已改成 `frida-server-16.7.19-arm64`。**
>
> 实测隔离：把各版 agent 从 server 里抠出来、直接把 `.dynstr` 的 `JNI_OnLoad`
> 改名（等长），再用一个一次性的 `app_process` 去 `System.load` 它（**不碰 frida/zygote/系统 App**）：
>
> ```
> agent-16.7.19-nojni   System.load OK  (+6 ms)   ✅
> agent-17.16.0-nojni   System.load OK  (+9 ms)   ✅
> agent-17.19.0-nojni   Segmentation fault        ❌   ← 构造函数本身坏了
> ```
>
> 端到端已验：`frida-ps` 列全机进程 ✅ · 注入 sleep ✅ · Java 桥 ✅ ·
> `Java.performNow` 28,826 个类 ✅ · `System.currentTimeMillis` 方法 hook ✅
>
> 两个坑：
> 1. **frida 17 的 `Java` 是 undefined**（bridge 拆成 npm 包了）。**16.7.19 内建**，脚本不用改。
> 2. **`Java.perform` 在这台机上不回调** ⇒ 用 **`Java.performNow(fn)`**。
>
> 全套证据：📄 **`专题/2026-10-01-frida-agent-崩溃-完整尸检.md`**（含完整 tombstone、
> 抠 agent 的方法、`.dynstr` 改名手法、以及"下一步还能怎么查"）。

---

## 🆕 2026-10-01 · frida 工作流的两个"必踩坑"

### 坑一：目标被冻结 → attach 超时 → **别再去动它**

第一次真机挂宿主（DeepSeek, pid 21349）实测：

```
RikkaHub  ✓ attached (0.6s)
Termux    ✓ attached (0.3s)
DeepSeek  ✗ TimedOutError (5.7s)      ← 只有它挂不上
```

**原因不是反调试**，是安卓 15 的**应用冻结**：

```
$ dumpsys activity processes | grep isFrozen
isFreezeExempt=false  isPendingFreeze=false  isFrozen=true     ← 冻住了
```

后台 App 的线程被 cgroup **全冻住** ⇒ 注进去的 agent 没机会跑、回不了信号 ⇒ 超时。

**❌ 错误处置（尼尼踩了）：**

```
attach 超时  →  am unfreeze  →  💥 SIGSEGV（宿主 native crash）
```

**因为超时那一刻，注入已经开始了一半**（agent 写进去了、构造函数没跑完）。
再去解冻/唤醒它，那半个 agent 就跑起来 → 崩。

**✅ 正确姿势：**

```sh
# ① attach 之前，先看目标冻没冻
adb shell 'dumpsys activity processes | grep -A2 "processName=<包名>" | grep isFrozen'

# ② 冻了 → 把它拉到【前台】（不是 unfreeze！），前台进程不会被冻
adb shell 'am start -n <包名>/<入口Activity>'      # 或者主人手动点开

# ③ 再确认一次 isFrozen=false，然后才 attach

# ④ 万一还是超时 → 【停止折腾那个进程】
#    它已经半注入了，正确的做法是 force-stop 它、重新打开，回到干净状态
adb shell 'am force-stop <包名>'
```

**一句话**：**超时的 attach 等于"留了半颗种子"，不要再给它浇水。**

---

### 坑二：端口藏不住、token 也藏不住（2026-10-01 实测）

主人起服务后**没告诉尼尼端口**，尼尼自己找到了：

```
$ cat /proc/<frida-server的pid>/cmdline
/data/adb/frida/frida-server -l 127.0.0.1:34636 -v
                                      ^^^^^^^^^^^^^ 从这读出来的
$ ss -ltn | grep 34636
LISTEN  127.0.0.1:34636                                    ← 或者从这扫出来
```

原因：adb shell 自带 `readproc` 组（adbd 硬编码），能读任意进程的 cmdline。
且 `/proc` 的加固（`hidepid=invisible,gid=3009`）**对 readproc 组无效**，
改它有 `CAP_SYS_ADMIN` / pidns 等一堆门槛 —— **实测判死，别再试**。

⇒ **"藏端口 / 藏 token" 在这台机器上都靠不住。**

### 顺带记：能挂 / 不能挂

| 目标 | 结果 |
|---|---|
| RikkaHub（自己的 App） | ✅ 0.6s |
| Termux | ✅ 0.3s |
| **DeepSeek（冻结态）** | ❌ 超时 → 再动它就崩 |
| **DeepSeek（前台态）** | ⏳ 待复测 |

---

## 🆕 2026-10-01 · 完整尸检（接上面那一段）

上面那 4 行崩溃摘要，**今天做成了可证的东西**：

> 📄 **`专题/2026-10-01-frida-agent-崩溃-完整尸检.md`** ← 全文在这

三个新事实：

1. **拿到了完整 tombstone**（`/data/tombstones/tombstone_14`，26 帧），
   并**从本地 `frida-server-17.19.0-arm64` 里抠出了同一构建的 `frida-agent-64.so`**
   （内嵌在 server 偏移 `0x85aae0`）——段布局和 tombstone 的映射表逐字节对上，
   所以 `pc` 偏移**可以原地反汇编**。
2. **致命指令 = `0xb10194: ldr x8, [x0, #0x38]`，`x0 = 0`。**
   位于函数 `0xb1017c` 入口第 7 条指令。崩在 **`.init_array[0] = 0xa83020`** 启动的构造函数链上
   ⇒ **dlopen 阶段，我们的 JS 一行都没跑。**
3. **`memfd 被内核封成不可执行` 这条假设死了** —— 映射是 `r-x`，agent 已经跑进构造函数了。

仍然最可疑的是 **susfs 对 `/proc` 的伪装**（agent 初始化在读 `/proc/self/auxv`，
tombstone 里 `fd 101` 就是它；agent 字符串里也有 `/proc/self/auxv`、`/proc/self/maps`）。
**下一步是一个零风险的决定性实验**：自己 `dlopen` 那只抠出来的 agent
（一次性的 `app_process`，不碰 zygote / 系统 App），看是不是同样崩在 `0xb10194`。
详见尸检文档第八节。
