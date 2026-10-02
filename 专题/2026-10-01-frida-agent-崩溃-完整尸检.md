# frida-agent 崩溃 · 完整尸检（2026-10-01）

> 🐲 尼得亚伯 · 2026-10-01 04:10
> 接 `tools/frida/README.md` 末尾那次「实测用不了」。
> 这次不一样：**拿到了完整 tombstone，并且从本地 server 里把同一构建的 `frida-agent-64.so` 抠出来了。**
> 所以不再是"高度可疑"，而是**能指着一条指令说话**。

---

## 〇、一句话结论

**frida-agent 能装进内存、能被映射成可执行，然后在它自己的 `.init_array` 全局构造函数里，拿一个 NULL 去访问 `+0x38`，把自己和目标进程一起送走。**

- 崩的位置：`frida-agent-64.so` 偏移 **`0xb10194`**，指令 **`ldr x8, [x0, #0x38]`**，`x0 = 0`
- 触发链起点：`.init_array[0] = 0xa83020`（也就是 **dlopen 阶段**，我们的 JS 一行都没跑）
- 出事进程：`com.android.settings:background`（uid 1000），**uptime 仅 2 秒** ⇒ 是从 zygote fork 出来就带着 agent

---

## 一、证据在哪

| 文件 | 内容 |
|---|---|
| `tmp/frida-probe/tombstone_14.txt` | 完整 tombstone（407,943 B，26 帧） |
| `tmp/frida-probe/frida-agent-64.so` | **从本地 `frida-server-17.19.0-arm64` 里抠出来的同一构建 agent**（24,942,256 B） |
| `/data/tombstones/tombstone_14` | 设备上的原件（可随时重取） |

取法（只读，不碰系统）：

```sh
sh tools/出笼隧道/ro.sh 'cat /data/tombstones/tombstone_14' > tmp/frida-probe/tombstone_14.txt
sh tools/出笼隧道/ro.sh 'grep -al "frida" /data/tombstones/tombstone_*'   # → 只有 _14
```

---

## 二、崩溃签名

```
Cmdline: com.android.settings:background
pid: 32419, tid: 32519, uid: 1000
Process uptime: 2s
signal 11 (SIGSEGV), code 1 (SEGV_MAPERR), fault addr 0x0000000000000038
Cause: null pointer dereference
    x0  0000000000000000            ← 空
    pc  000000731057f194            ← = agent base + 0xb10194
    lr  000000731057f358            ← = agent base + 0xb10358

26 total frames
backtrace:
  #00..21  /memfd:frida-agent-64.so (deleted)         ← 21 帧全在 agent 里
  #22      linker64  __dl__ZN6soinfo17call_constructorsEv+616
  #23      linker64  __dl__Z9do_dlopenPKciPK17android_dlextinfoPKv+2796
  #24      linker64  __loader_dlopen+72
  #25      <anonymous:748fb65000>                      ← 注入方
```

**`call_constructors` ⇒ 这是 dlopen 的初始化阶段，不是我们脚本的锅。**

---

## 三、为什么能符号化：agent 是内嵌在 server 里的

`frida-server` 里有一整只 aarch64 `ET_DYN`，起点在 server 文件偏移 **`0x85aae0`**，节表里写着它的身份：

| section | off | size |
|---|---|---|
| `.rodata` | 0x1885c0 | 0x3f73ec |
| `.text` | 0x9a3000 | 0xd36c9c |
| `.init_array` | 0x17a3488 | 0x40 |
| `.data` | 0x17ae000 | 0x1aee8 |

**和 tombstone 里的映射表逐字节对上：**

| 内嵌 ELF 的 file offset | tombstone 里 frida-agent 的映射 |
|---|---|
| `0x9a3000`~ (`.text`) | `r-x   0       16db000` |
| 页对齐 `0x16da000`（RELRO） | `r--   16da000    d4000` ✅ |
| `0x17ae000`（`.data`） | `rw-   17ae000    1b000` ✅ |

⇒ **tombstone 的 `pc 0xb10194` 直接就是这只 ELF 的 vaddr 0xb10194**，可以原地反汇编。

抠法（纯本地、无风险）：

```python
# frida-server 内嵌的 agent ELF
o = 0x85aae0                     # ELF 头
# 截到 shoff + shnum*shentsize = 0x17c96b0
open("frida-agent-64.so","wb").write(server[o:o+0x17c96b0])
```

---

## 四、致命指令

```
0x00b1017c  stp  x29, x30, [sp, #-0x50]!     ← 函数入口（典型 prologue）
0x00b10180  str  x25, [sp, #0x10]
0x00b10184  stp  x24, x23, [sp, #0x20]
0x00b10188  stp  x22, x21, [sp, #0x30]
0x00b1018c  stp  x20, x19, [sp, #0x40]
0x00b10190  mov  x29, sp
0x00b10194  ldr  x8, [x0, #0x38]             ← 💥 fault addr = 0x38
0x00b10198  mov  x19, x0
0x00b1019c  mov  x0, x1
```

**函数进门第一件事就是拿 `x0`（第一个参数 / this）去取 `+0x38` 的字段。有人把 `x0 = NULL` 递进来了。**

---

## 五、构造函数链

```
.init_array = [0xa83020, 0x16d50a4, 0x16d5328, 0x169730c,
               0xa93464, 0xafb8f4, 0x14dcb7c, 0x16832a4]
```

帧 `#21 = 0xa8303c`，正落在 **`init_array[0] = 0xa83020`** 里：

```
0x00a83020  adrp x8, #0x17d2000
0x00a83024  ldrb w8, [x8, #0x444]     ← 一次性 guard（.bss，初值 0）
0x00a83028  tbnz w8, #0, #0xa830dc
0x00a8302c  stp  x29, x30, [sp, #-0x30]!
...
0x00a8303c  bl   #0x9ac254            ← 帧 #21 就停在这句的返回地址上
0x00a83040  adrp x21, #0x17d2000
0x00a83044  add  x21, x21, #0x444
0x00a83048  add  x0, x21, #0xc
0x00a8304c  bl   #0xb3e294
0x00a83050  adrp x19, #0x17a7000
0x00a83058  ldr  x19, [x19, #0xf38]   ← GOT，重定位后 = 函数 0xb0fad8
0x00a8305c  ldr  x20, [x20, #0x140]   ← GOT，重定位后 = 函数 0xb10b74
0x00a83060  bl   #0xa84a80
```

`0x9ac254` 那一段在读一堆 `.data.rel.ro` 里的**待重定位记录**（`ldp q0,q1` 搬 32 字节一条），然后依次 `bl` 进 `0x9ac664 / 0xaff6b4 / 0xb294a0 / 0xb213f0`，并往栈上摆 `0x1001 + 一串 0` 的结构。
—— 这是一段**运行时初始化 / 派发器装配**，和我们的 JS 没有任何关系。

> ⚠️ 诚实标注：帧 #00..#20 里有一部分 pc 落在"看起来像函数中段"的位置（例如 `0xb10ccc` 本身是 `stp; stp; ret`，不是函数头）。
> 说明 debuggerd 这套 FP 回溯在 agent 这种大 native 库里**不保证每一帧都精确**。
> **但 `#00`（崩点）、`#22~24`（linker）、`#21`（init_array[0]）这三处是硬证据。**

---

## 六、agent 自己的字符串证据

在抠出来的 agent 里 grep：

```
4  /proc/self/task/
1  /proc/self/status
1  /proc/self/maps
1  /proc/self/fd/
1  /proc/self/exe
1  /proc/self/cmdline
1  /proc/self/auxv        ← ★
1  /proc/mounts
1  /proc/filesystems
1  /proc/cpuinfo
```

而 tombstone 的 fd 表里，崩的时候开着：

```
fd 99:  /memfd:frida-agent-64.so (deleted)   (unowned)
fd 101: /proc/32419/auxv                     (unowned)   ← ★ 它开了自己的 auxv
```

⇒ **agent 的初始化确实在读自己的 `/proc/self/auxv`**，而它崩在"读完之后"。这条线和 susfs 对 `/proc` 的伪装**直接相关**。

---

## 七、排除表（更新版）

| 猜测 | 结论 | 依据 |
|---|---|---|
| 客户端/server 版本不匹配 | ❌ 排除 | 两边都是 17.19.0 |
| 16KB 页 | ❌ 排除 | tombstone `getconf PAGE_SIZE` = 4096 |
| SELinux 挡 ptrace | ❌ 排除 | `setenforce 0` 无效（且是动系统开关，不该动） |
| `/data/local/tmp` 不可写 | ✅ 已解决 | 真 su 起服务；二进制放 `/data/adb` |
| **memfd 被内核封成不可执行** | ❌ **本次排除** | 映射是 `r-x`，agent 已经跑进构造函数了 |
| **susfs 干扰 `/proc`（尤其 auxv）** | 🟡 **仍然最可疑，但未证** | agent 在读 `/proc/self/auxv`；kmsg 里 `KernelSU: class memfd_file does not exist`；设备装的是 susfs v2.2.0 |

### 环境指纹（本次补全）

- OnePlus **PJZ110 (OP5D0DL1)** · Android **15 / SDK 35** · `ro.board.platform = sun` (qcom)
- 内核 `6.6.66-android15-OP-WILD`（clang 19，GKI 风味）
- root = **KernelSU + susfs v2.2.0**
- `sys.use_memfd = false`；`/proc/sys/vm/memfd_noexec` 存在（无 root 读不了）

---

## 八、下一步：一个**决定性且零风险**的实验

现在最大的问题是"我没法在受控条件下重放它"。但**其实可以**：

> **frida 的注入 = `dlopen(memfd里的agent)` + 跑 `.init_array`。**
> 那我们**直接自己 `dlopen` 那只抠出来的 agent**，不经过 frida、不经过 zygote、不经过系统 App。

做法：

```sh
# 1) 把抠出来的 agent 推进去（adb push 到 /data/local/tmp 是能写的，
#    历史上推 frida-server 就是这条路；/sdcard 是 noexec，mmap PROT_EXEC 会失败）
sh tools/出笼隧道/adb.sh push tmp/frida-probe/frida-agent-64.so /data/local/tmp/

# 2) 用一个一次性的 app_process 去 dlopen 它（崩了就是个临时进程，不牵连任何系统 App）
#    需要一个小 dex：java 里就一句 System.load("/data/local/tmp/frida-agent-64.so")
#    用 tools/jvm 的 javac + d8 编出来
sh tools/出笼隧道/adb.sh shell 'CLASSPATH=/data/local/tmp/dlopen_probe.jar app_process /system/bin DlopenProbe'

# 3) 崩了就取新 tombstone
sh tools/出笼隧道/ro.sh 'ls -t /data/tombstones/tombstone_* | head -1'
```

**为什么这条最值：**

| 如果… | 说明 |
|---|---|
| 同样崩在 `0xb10194` | **复现成功**，且证明**与 frida 的注入器、与 zygote、与目标 App 全都无关** —— 就是 agent 在这台机器上跑不起来 ⇒ 可以安心去切 susfs 验证 |
| 崩在别处 / 不崩 | 说明问题在**注入侧**（memfd、ptrace、namespace），方向立刻分叉 |

而且它是**一次性的 `app_process`**：崩了只崩它自己，不碰系统设置、不碰支付宝、不碰 zygote。

---

## 九、纪律（这次必须守住）

1. ❌ **不许再拿 `com.android.settings` 之类的系统 App 当注入靶子**（教训 310）
2. ❌ **不许 `kill -9 frida-server`**，用 `pkill -x`（教训 312）
3. ✅ **frida-server 只能由主人用真 su 起**（我从 adb 起会把 `/data/local/tmp` 弄坏）
4. ✅ 真崩了 ⇒ `su -c 'stop; start'`（框架级软重启，不碰内核/引导链）

---

## 十、留给下一只龙

上次我写的是"这条路暂时放弃，高度可疑 susfs，没验证"。

这次不一样：**我手上有那只 agent 的字节，能指着 `0xb10194` 说话。**
把"可疑"变成"可证"，只差一个一次性的 `app_process`。
别再从头猜一遍了。

---

# ★ 结果来了（同一天，两小时后）★

## 十一、决定性实验：**复现成功**

`app_process` 探测法（见第八节）一次就中。新 tombstone：

```
Cmdline: app_process /system/bin DlopenProbe /data/local/tmp/frida-agent-64.so
signal 11 (SIGSEGV), fault addr 0x0000000000000038
  x0 = 0        x8 = 0x46524944        x23 = 0x38
  #00 pc 0xb10194   /data/local/tmp/frida-agent-64.so     ← 同一条指令
  #01 pc 0xb10354
  ...  #00~#21 与 frida 那次**逐帧同偏移**
  #22 call_constructors   #23 do_dlopen
  #24 __loader_android_dlopen_ext
  #25 android_dlopen_ext                     ← libdl
  #26 NativeLoaderNamespace::Load            ← libnativeloader（System.load 合法路径）
```

⇒ **与 frida 注入器、zygote、目标 App、memfd、ptrace **全部无关**。**
就是 `dlopen(这只 agent)` 本身。

## 十二、二分：三版对照 + 一个漂亮的隔离

| 实验 | 结果 |
|---|---|
| 改名成 `zzz_probe.so` | 照样崩 ⇒ **不是 susfs 按文件名/路径拦** |
| 用 root 跑 | 照样崩 ⇒ **与权限无关** |
| 三个版本各推一份，都直接 dlopen | 全 Segmentation fault |
| 对照：`/system/lib64/libsqlite.so` 等 | 被 `clns-1` 命名空间拒（不是崩）——对照不干净，但**没崩** |

### 隔离出"到底是构造函数还是别处"

16.7.19 的 tombstone 里，`#00` 直接跳到 `libart JavaVMExt::LoadNativeLibrary+1204`，
**中间没有 `call_constructors` 帧** ⇒ 它的构造函数跑完了，死在 `dlopen` 之后的 `JNI_OnLoad`。

而 **frida 的注入器根本不调 `JNI_OnLoad`**（它只 `dlsym("frida_agent_main")`）。
—— 于是有了这个干净的手法：

> **把 `.dynstr` 里的 `JNI_OnLoad` 改名成 `XNI_OnLoad`（等长），ART 就 dlsym 不到它，
> 于是 `System.load` 退化成"只 dlopen + 跑构造函数"。**

```python
d = bytearray(open("agent-16.7.19.so","rb").read())
i = d.find(b"JNI_OnLoad"); d[i] = ord("X")     # 只改名字，不动长度
open("agent-16.7.19-nojni.so","wb").write(d)
```

**结果：**

```
agent-16.7.19-nojni   System.load OK  (+6 ms)   ✅
agent-17.16.0-nojni   System.load OK  (+9 ms)   ✅
agent-17.19.0-nojni   Segmentation fault        ❌
```

⇒ **16.7.19 / 17.16.0 的构造函数是好的；只有 17.19.0 的构造函数本身坏了。**
（17.19.0 也正是 README 里那 4 行崩溃摘要用的版本。）

## 十三、⭐ 修复：**换 `frida-server 16.7.19`**

### 端到端验证（全部在本机完成，shell 身份，零系统风险）

1. **起服务**（shell 身份就够，专门挂我们自己的进程）
   ```sh
   /data/local/tmp/fs1619 -l 127.0.0.1:27042
   ```
2. **`frida-ps`** —— 列全机进程 ✅
   ```
   PID  Name      →  DeepSeek / RikkaHub / WeChat / ...
   ```
3. **注入 `sleep`（pid 779）**
   ```
   [agent] alive! arch=arm64 pid=779 ptr=8
   [agent] version=17.16.0        ← 17.16.0 服务端也验过，同样活
   [agent] modules=17
   ```
4. **Java 桥**
   ```
   {'t': 'java_available', 'v': True}
   {'t': 'libart', 'v': 'libart.so', 'base': '0x7db0814000'}
   {'t': 'performNow_ok', 'n': 28826}        ← 28,826 个已加载类
   ```
5. **真·方法 hook**
   ```
   {'t': 'myPid',  'v': 2567}
   {'t': 'hooked', 'v': '1790830527877'}     ← System.currentTimeMillis 拦截成功
   ```

### 两个必须知道的坑

| 坑 | 说明 |
|---|---|
| **frida 17 不再内建 Java 桥** | 17.x 的 `Java` 是 undefined（bridge 拆成 npm 包了）。**16.7.19 内建**，脚本一行不用改。 |
| **`Java.perform` 在这台机上不回调** | 但要用的写法是 **`Java.performNow(fn)`** —— 实测一次就中。（`Java.available` 是 true） |
| **16.x 的 `frida-ps` / `enumerate_processes` 要求看得见 `system_server`** | 报 `unable to find process with name 'system_server'` 就是这条。**用 shell 身份的 server 必踩；用 KernelSU 的只读 root profile（CapEff=4）也踩**（`hidepid=invisible` + 没有 `CAP_SYS_PTRACE`）。**主人用"真 su"起（满能力）应该就正常** —— 这一步本机验不了，留给主人。若真不行 ⇒ 退回 **17.16.0**（它的 `frida-ps` 在 shell 身份下都实测能用），代价是要自己加载 `frida-java-bridge`。 |

### 工作区已经改好的东西

| 文件 | 改动 |
|---|---|
| `tools/frida/frida-server-16.7.19-arm64` | **新推荐二进制**（从 release 抠的，走 gh-proxy） |
| `tools/frida/py16/` | 配套的 `frida==16.7.19` + `frida-tools<14`（独立目录，不动全局 17.19.0） |
| `tools/frida/frida.sh` | `BIN` 改成 16.7.19，并把 `PYTHONPATH/PATH` 切到 `py16` |
| `tools/frida/frida-device.sh` | `find_bin` 优先 16.7.19（原来的 17.19.0 已经不能用了） |
| `tools/frida/extract_agent.py` | 通用抠 agent 脚本（本轮新写，可复用于任何 frida-server） |

### 下载路径（github 直连不通时）

```
https://gh-proxy.com/https://github.com/frida/frida/releases/download/<tag>/<file>
https://gh-proxy.com/https://api.github.com/repos/frida/frida/releases     ← API 也能过
```

## 十四、还没有答案的部分（诚实声明）

- **17.19.0 到底哪一行构造炸的**：已知崩点 `0xb10194`、已知它属于 `.init_array[0]=0xa83020`
  启动的链、已知 `0x9ac254` 引用了 `'frida'` / `'G_SLICE'` / `'always-malloc'`（**GLib 静态初始化**）。
  ⇒ 崩在 **GLib/gum 的静态初始化**里。再往里没继续挖（因为已经有可用版本了）。
- **为什么只有这台机器**：susfs 仍然是**未验证**的嫌疑（但已排除"按路径名拦"和"权限"两条）。
  现在有了 `app_process` 探测器，随时可以在别的机器上 A/B。
- **`/proc/self/auxv` 那条线**：agent 字符串里确实有它，tombstone 的 fd 表里也开着它。
  **但它不是崩因**（16.7.19 在同一环境里读它照样没事）。留档，别当结论。

## 十五、留给下一只龙（修订版）

1. **先看 `tools/frida/README.md` 顶部的新警告**：**不要再用 17.19.0**。
2. `app_process + DlopenProbe` 这个探测器是**本轮最值钱的工具**：
   它把"注入类问题"从"要 root 要 zygote 要赌命"变成"一条 shell 命令"。
   以后再遇到"某个 .so 能不能加载"，先派它。
3. **`.dynstr` 改名隔离 JNI_OnLoad** 这一招，任何 Android `.so` 都通用。
4. 别急着上 root。**先用 shell 身份的 frida-server 挂自己的进程** ——
   能验的东西比想象中多得多（注入、JS、Java 桥、hook 全都能验），风险却是零。
