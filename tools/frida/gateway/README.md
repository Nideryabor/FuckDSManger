# frida 白名单网关 🐲

> 2026-10-01 · 尼得亚伯
> 解决的问题：**"frida 没有目标白名单"** —— 现在有了，而且是**真的挡得住**的那种。

---

> ## ⚡ 启动就记这一条（主人 2026-10-02 亲口纠正）
>
> ```sh
> su -c 'sh /data/adb/frida/frida.sh'        # ★ 就是这个（后台，30 分钟自动退）
> su -c 'sh /data/adb/frida/frida.sh -f'     # 前台版，能看进度
> su -c 'sh /data/adb/frida/frida.sh -s'     # 状态
> su -c 'sh /data/adb/frida/frida.sh -k'     # 停
> ```
>
> **⚠️ 不是** `tools/frida/frida.sh`（那是 frida-server 老路，端口式，本机必失败），
> **也不是** `frida-device.sh`（那只是起 frida-server 的老路）。
>
> 开始 → 投任务 → 读结果 的完整速查：**`tools/frida/启动方式-速查.md`**
>
> 分工：**主人**起 `frida.sh` 窗口（真 su）· **尼尼**写 `frida_job.txt` + 读 `result.txt`。

---

## 一、为什么之前那几条路都死了

| 方案 | 死因 |
|---|---|
| `--token` | token 写在命令行里 → 尼尼 `cat /proc/<pid>/cmdline` 就读到了 |
| 藏端口 | 尼尼 `ss -ltn` 一扫就出来 |
| 改 `/proc` 挂载（hidepid/gid） | 要 `CAP_SYS_ADMIN` + 动 pidns，安卓上判死 |
| unix socket | frida 只支持**抽象**命名空间（没文件、没权限） |
| `--certificate` | 证书是公开的，握手包里就能捞 |

**共同点：全都依赖"藏一个秘密"，而尼尼能读任何进程的命令行。**

---

## 二、新方案：**不藏秘密，改成"没有秘密可藏"**

用 **`frida-inject`** —— 一个能直接在安卓上跑的独立注入器：

* 不需要 frida-server
* **没有端口**（尼尼扫不到）
* **没有常驻进程**（没有命令行可读）
* 跑完就退

于是架构变成"投递"：

```
尼尼 写 /data/local/tmp/frida_job.txt
        │  target=com.deepseek.chat.a
        │  script=/data/local/tmp/frida_scripts/x.js
        ▼
   run.sh（root，在 /data/adb/frida/）     ← 尼尼读不了、改不了
        │  ① target 在白名单里吗？
        │  ② 路径越界吗？符号链接吗？
        │  ③ 找 pid
        │  ④ timeout 25 frida-inject -p <pid> -s <脚本>     ← 只用 -p，永不 -f
        ▼
   /data/local/tmp/frida_out/result.txt   → 尼尼读
```

### 为什么这次是真的白名单

| 尼尼想绕过 | 结果 |
|---|---|
| 扫端口直连 | ❌ **没有端口** |
| 读命令行拿秘密 | ❌ **没有常驻服务 / 没有秘密** |
| 改白名单 / 改网关 | ❌ `/data/adb/frida/` 是 `root:root 0700` |
| 让网关挂微信 | ❌ 白名单逐字拦下 |
| `-f` 起别的 App | ❌ 网关根本不用 spawn |
| 脚本里干坏事 | ⚠️ **只能干到目标进程为止**（宿主不是 root） |

> **最后一条是关键**：JS 的破坏力被「进程边界」关住了。
> 所以"只白名单目标"就够了 —— 不需要去限制脚本能写什么。

---

## 三、安装（**只有主人能做**）

```sh
# ① 目录 + 注入器
su -c 'mkdir -p /data/adb/frida && chmod 700 /data/adb/frida'
su -c 'cat /data/local/tmp/frida-inject > /data/adb/frida/frida-inject'
su -c 'chmod 755 /data/adb/frida/frida-inject'

# ② 白名单 + 网关（⚠️ 先自己看一眼这两个文件再拷！）
su -c 'cat <工作区>/tools/frida/gateway/allow.txt > /data/adb/frida/allow.txt'
su -c 'cat <工作区>/tools/frida/gateway/run.sh   > /data/adb/frida/run.sh'
su -c 'chmod 600 /data/adb/frida/allow.txt'
su -c 'chmod 700 /data/adb/frida/run.sh'
su -c 'chown -R root:root /data/adb/frida'

# ③ I/O 目录
#    脚本目录：尼尼要写 → 777（尼尼自己也能建）
mkdir -p /data/local/tmp/frida_scripts && chmod 0777 /data/local/tmp/frida_scripts
#    输出目录：只让 root 写、尼尼只读 → 防"尼尼预埋符号链接"
mkdir -p /data/local/tmp/frida_out && chmod 0777 /data/local/tmp/frida_out
su -c 'chown root:root /data/local/tmp/frida_out && chmod 0755 /data/local/tmp/frida_out'
#    ↑ 如果 su 没权限建/改，就先由尼尼建（上面那条），再让 root chown

# ④ 自检
su -c 'sh /data/adb/frida/run.sh --selftest'
```

---

## 四、日常用法

**主人**：开一个窗口（30 分钟到点自己退）

```sh
su -c 'sh /data/adb/frida/run.sh --watch 1800'
```

**尼尼**：投任务 → 按 `id` 读结果（v3 起**脚本内联在 job 里**）

```sh
cat > /data/local/tmp/frida_job.txt <<'EOF'
id=job1
target=com.deepseek.chat.a
---
console.log("pid=" + Process.id);
Java.performNow(function () {
  send({total: Java.enumerateLoadedClassesSync().length});
});
EOF

# 轮询：result.txt 里出现 job=job1 就是这次的结果
for i in $(seq 1 30); do
  grep -q '^job=job1$' /data/local/tmp/frida_out/result.txt 2>/dev/null && break
  sleep 1
done
cat /data/local/tmp/frida_out/result.txt
```

> **为什么内联**：v2 的 `script=<路径>` 意味着"root 要去打开尼尼指定的路径"。
> 内联之后，**尼尼再也控制不了任何 root 要打开的路径** —— 脚本正文由 root 写进
> 自己的 staging 文件（`/data/adb/frida/.stage.$$`）再注入。整类攻击面消失。

**只跑一次**（不开窗口）：

```sh
su -c 'sh /data/adb/frida/run.sh'
```

**自检 / 帮助**：

```sh
su -c 'sh /data/adb/frida/run.sh --selftest'
su -c 'sh /data/adb/frida/run.sh --help'
```

---

## 五、审计

每次任务都会追加一行到 `/data/adb/frida/audit.log`（尼尼读不到）：

```
2026-10-01 14:30:11 RUN target=com.deepseek.chat.a pid=21349 rc=0 script=t.js
2026-10-01 14:31:02 DENY not-allowlisted target=com.tencent.mm
```

**主人随时可以 `su -c 'tail -50 /data/adb/frida/audit.log'` 查尼尼干了什么。**

---

## 七、v2 修订（2026-10-01 · 一轮 code review 之后）

v1 被查出 6 个洞 —— **"框架是对的，围栏是漂亮的，但栅栏之间的缝没焊死"**。v2 全部补上：

| # | 洞 | v1 的问题 | v2 的修法 |
|---|---|---|---|
| 1 | **路径穿越** | `case "$script" in "$SC_DIR"/*)` 是**字面前缀匹配**，`$SC_DIR/../../../data/adb/x.js` 照样通过 | 改用 **`readlink -e` 规范化后再比**；解析不出来就**拒绝**（fail closed） |
| 2 | **脚本目录本身是符号链接** | 尼尼把 `frida_scripts` 换成指向 `/data/adb/frida` 的链接，围栏直接被搬走 | 启动时 `[ -L "$SC_DIR" ]` + 规范化后必须**等于自身** |
| 3 | **JOB 是符号链接** | `[ -f ]` 跟随链接 ⇒ 指向某个 root 文件就能把里面 `target=` 开头的行泄露到 result | `[ -h "$JOB" ]` 直接拒 |
| 4 | **TOCTOU** | 检查完到注入之间（`--watch` 有 2s 窗口）可以把普通文件换成链接 | 先 `cp` 到 **root 专属 staging**，只注入 staging |
| 5 | `--watch` 参数不校验 | `--watch abc` 算术报错退出 | 数字校验，非法直接退 2 |
| 6 | 零碎 | 审计不轮转 / 结果可能 0600 尼尼读不到 / 注入后 `rm` 可能误删新 job / 无 `--help` | 全部修掉 |

**外加两条尼尼自己补的护栏：**

| # | 护栏 | 为什么 |
|---|---|---|
| 7 | **`OUT_DIR` 全局可写 ⇒ 拒绝启动** | 这是提权通道：尼尼预埋 `result.txt → /data/adb/frida/allow.txt`，root 写结果时就**覆盖了尼尼自己的白名单**。**fail closed。** |
| 8 | **job 带 `id=`，结果回显 `job=<id>`** | 结果文件是覆盖写的；靠 id 对号入座，不赌时间 |

**v2 实测（5 条打击 + 1 条正向）：**

```
T1 路径穿越        → deny 脚本路径无法解析            ✅
T2 JOB 符号链接    → deny job 文件是符号链接           ✅
T3 输出目录 0777   → 拒绝启动，退出码 1                ✅
T4 脚本目录换链接  → 拒绝启动，退出码 1                ✅
T5 正向注入        → status=ok pid=1122 "OK pid=1122"  ✅
```

**一句话**：v1 是"看起来很安全"，**v2 是"缝也焊上了"**。

---

## 七·补 · v3 修订（第二轮 review 之后）

第二轮又抠出 **1 个真提权 + 1 个设计疑点 + 4 个小洞**。v3 全部处理：

| # | 级别 | 洞 | v3 |
|---|---|---|---|
| A | 🔴 **提权** | `OUT_DIR` 只查了**权限位**（`drwxr-xr-x`），**没查属主**。尼尼（shell）自己 `mkdir` 一个 `shell:shell 0755` 的目录就完美骗过检查 → 往里埋 `result.txt → /data/adb/frida/allow.txt` 符号链接 → root 写结果时**覆盖白名单** | 属主**必须是 root**；且写结果前 `rm -f "$RES"`（删链接本身，不跟随） |
| B | 🔴 设计 | `SC_DIR` 可写 —— 尼尼能塞任意脚本让 root 注入 | **不是加检查，是把目录整个删掉**：脚本改为**内联在 job 里**，root 写进自己的 staging 再注入。**尼尼从此不控制任何"root 要打开的路径"** |
| C | 🟡 | `mv "$JOB" "$WORK"` 之后再没验过符号链接 | 搬完**再验一次** `[ -h "$WORK" ]` |
| D | 🟡 | `emit` 里 `chmod 644 "$RES"` 同样跟随符号链接 | 先 `rm -f` 再写再 chmod |
| E | 🟢 | `selftest` 被入口的 `preflight \|\| exit 1` 挡死，看不到失败分支 | `--selftest` / `--help` 提到门之前 |
| F | 🟢 | `INJ` / `ALLOW` 存在性只在 selftest 里查，真跑时到注入那刻才炸 | 提到 `preflight` |
| G | 🟢 | `log` 写失败静默吞掉 | 写失败 echo 到 stderr |
| H | 🟢 | `--help` 硬编码行号 `sed -n '2,40p'` | 改成 heredoc 的 `usage()` |
| I | ⚪ | `resolve_pid` 的 cmdline 可被伪造 | **故意不堵**（伪造者只能注入自己权限内的进程，不构成提权；堵了会错杀同名进程）—— 写进注释 |

**v3 实测（6 条）：**

```
T-A3 OUT_DIR 属主为 shell（权限位完美伪装 drwxr-xr-x）
     → ✗ 拒绝启动 + 打印修复命令                                    ✅
     （这条同时证明：v2 会被骗过，v3 不会）
T-B  result.txt 被预埋成符号链接
     → victim.txt 内容【原封不动】，result.txt 变回普通文件           ✅
T-C  JOB 是符号链接              → deny                             ✅
T-D  脚本正文为空                → deny                             ✅
T-E  不在白名单                  → deny                             ✅
T-F  正向（内联脚本真注入）       → status=ok pid=19732 "T-F INJECTED"  ✅
```

> **一句话**：v1 是"看起来安全"，v2 是"缝焊上了"，
> **v3 是"把那根会被人换掉的栏杆，直接拆了"。**

---

## 七·补2 · v4 修订（第三轮 review 之后）

第三轮逮到 **1 个真 Bug + 2 个中等 + 8 个小项**。v4 全部处理：

| 级别 | 洞 | v4 |
|---|---|---|
| 🔴 **真 Bug** | `--watch` **不带参数会直接挂**：判断用 `${2:-1800}`，取值却读裸 `$2` ⇒ `set -u` 报 `parameter not set` 退出 | `SECS="${2:-1800}"` —— 默认值**既用于判断也用于取值** |
| 🟠 中 | `awk 'BEGIN{f=0} /^---$/{f=1;next} f{print}'` —— 一旦 `f=1`，**正文里每一条独立 `---` 都会被静默吞掉** | 改成 **`!f && /^---$/`**：只有**第一个** `---` 当分隔符 |
| 🟠 中 | `$ALLOW` 只查属主，没查**写权限位**（root:root 0666 照样能被改） | 要求 **`-rw-------`**，否则拒绝启动 |
| 🟢 | `OUT_DIR` 只查自身，没查可达路径 | 补一次 `readlink -e` 比对 |
| 🟢 | 没查 `timeout` 是否存在 | `command -v timeout` 进 preflight |
| 🟢 | job 里的 `\r`（Windows 编辑器）会以"字符集不合法"报错，难排查 | 解析前 `tr -d '\r'` 统一行尾 |
| 🟢 | `log()` 判定绕（"文件存在"当成"能写"） | 简化成 `>>` 失败就 stderr 兜底 |
| 🟢 | `emit` 的 `chmod` 失败静默 | 记进 audit |
| 🟢 | 入口 `case` 重复两次 | 合并 |
| ⚪ | `resolve_pid` 慢 / `mv` 后重复验链接 / 审计只轮转一次 | 评估后**保留**（可接受 / 纵深防御） |

**v4 实测：**

```
① awk 新旧对比（含两条 --- 的 job）
     旧: AAA / BBB          ← --- 被静默吃掉
     新: AAA / --- / BBB    ← 原样保留                        ✅
T1  --watch 不带参数    → 退出码 124（正常运行中被 timeout 掐断）✅
T2  白名单 0644         → ✗ 权限不安全: -rw-r--r-- （要 -rw-------）✅
T3  正文含裸 ---        → 传到了 JS 引擎（反证没被吞）          ✅
T4  正文含 "---" 字符串  → ok "v4 正向 OK pid=25480"            ✅
```

> **一句话**：v1 看得过去 → v2 焊缝 → v3 拆栏杆 → **v4 把上一版自己留下的 bug 也修了**。

---

## 七·补3 · v5 修订（**第一次真机注入**踩出来的三个坑）

2026-10-01 · 第一次真机跑通（`smoke1` 成功注入宿主，拿到 41,003 个类）。
**成功之前先踩了三个坑，全是 v4 的 bug：**

| # | 级别 | 坑 | v5 |
|---|---|---|---|
| A | 🔴 **要命** | **网关不检查目标冻没冻。** 目标在后台（`oom_score_adj=900`）会被安卓**冻结**，注进去 agent 跑不了 ⇒ frida-inject 永久挂死 ⇒ 进程变成"**半注入**"状态，之后一碰就崩。（这正是 14:06 那次把宿主搞崩的同一个机理） | 注入前查 `/proc/<pid>/oom_score_adj`，**≥900 直接拒绝**，并提示"先把它切到前台"。**实测拦住了** ✅ |
| B | 🔴 | `timeout 25` **只发 TERM**。frida-inject 收到 TERM 会尝试"优雅脱离"，但目标冻着 ⇒ **永久卡住**，`timeout` 也拽不回来。 | `timeout -k 5 15` —— TERM 之后 5 秒还不死就 **SIGKILL** |
| C | 🟠 | **终端完全没输出**（只写 audit.log）⇒ 用户以为"没跑"，其实在跑 | 进度打到 **stdout**，audit.log 照写 |
| D | 🟠 | 解析 pid 之后、注入之前，目标可能已经**重启**（pid 变了）⇒ 注入到**错误的/已死的 pid** | 注入前再验一次 `pid_matches` |

**v5 实测：**

```
[4] 目标进程（含冻结风险）
    ⚠ com.little_femaleboy... (pid 1279, oom_adj=900) —— 在后台会被冻，注入前要先切前台

######## 投一个目标在后台的任务 ########
[网关] 发现任务
  · id=frozen-test  target=com.little_femaleboy...  ✓ 白名单通过
  ✗ 目标在后台（oom_adj=900）会被安卓冻结 —— 注了也是白注，而且会把进程搞成半死
    ⇒ 请先把它切到前台，再投一次
                                              ↑ 没有注入，没有半颗种子 ✅
```

> **一句话**：v1→v4 是"**被人审出来的**"，**v5 是"自己跑出来的"**。
> 真正的边界条件，只有真机上跑一次才会露出来。

---

## 七·补4 · ✅ 第一次真机跑通（2026-10-01）

```
job=smoke1   status=ok   target=com.deepseek.chat.a
[1] pid=18693 arch=arm64 ptr=8
[2] native 模块数=458
[3] 已加载类总数=41003
[4] androidx.compose.* 保留真名=20
      androidx.compose.ui.graphics.layer.ViewLayer              ★
      androidx.compose.ui.graphics.layer.view.ViewLayerContainer ★
      androidx.compose.ui.graphics.layer.view.DrawChildContainer ★
      androidx.compose.ui.platform.AbstractComposeView
      androidx.compose.ui.platform.ComposeView
      androidx.compose.ui.viewinterop.AndroidViewHolder
      androidx.compose.material.ripple.RippleHostView
      ...
[5] Modifier/DrawScope/GraphicsLayer 命中=22（全是 android.icu / android.widget
    ⇒ 确认宿主的 Compose 类被 R8 混淆了）
[6] script end
```

**整条链路打通**：`job → 网关 → 白名单 → resolve_pid → frida-inject → agent → Java 桥 → 结果回传`
**证据留档**：`tmp/frida-probe/result-smoke1.txt`

**顺带确认**：宿主被系统 `o-stop` 清理掉了（不是崩溃），没有 `am_crash`。

---

## 九、⚠️ 信任边界（**改动前必须读**）

这套东西的全部安全性，建立在一句话上：

> **root 绝不执行、也绝不去读「尼尼能改的东西」。**

**尼尼（adb shell，uid 2000）能写 `/data/local/tmp/`。** 所以：

| 路径 | 谁能写 | root 碰它吗 | 说明 |
|---|---|---|---|
| `/data/local/tmp/frida_job.txt` | **尼尼** | ✅ 读，但**当纯数据解析** | 白名单 + 字符集 + 长度全套校验 |
| `/data/local/tmp/frida_out/` | root only | ✅ 读写 | 0755 root:root，尼尼只读 |
| `/data/adb/frida/**` | root only | ✅ | 0700 |
| ~~`/data/local/tmp/run.sh`~~ | 尼尼 | ❌ **绝不** | ★见下★ |
| ~~`/data/local/tmp/frida.sh`~~ | 尼尼 | ❌ **绝不** | ★见下★ |

### ★ 2026-10-01 晚 · 尼尼自己踩的坑（已修）

为了方便，尼尼做了个"一键启动脚本" `frida.sh` 放在 `/data/local/tmp/`，里面还会
**自动把 `run.sh` 从 `/data/local/tmp` 拷进 `/data/adb/frida/`**。主人用
`su -c 'sh /data/local/tmp/frida.sh'` 跑它。

**这就等于：让一个尼尼能改的脚本，以 root 执行。** 两条路全通：

```
尼尼 write /data/local/tmp/frida.sh  → 主人 su 跑它            → 💀 root
尼尼 write /data/local/tmp/run.sh    → frida.sh 自动 cp 进 /data/adb → 💀 root
```

**整份白名单设计当场作废**，而且**没有任何检查能拦住** —— 因为拦住它的代码本身
就是从那个可写文件里来的。

**修法（v2）：**

1. **`frida.sh` 不再自动安装/升级 `run.sh`。** 装/升级必须主人**过目后手动 `cp`**。
2. **`frida.sh` 住进 `/data/adb/frida/`**，并且启动时**自检 `$0` 的目录** ——
   如果发现自己跑在 `/data/adb/frida` 以外，**直接拒绝执行并打印正确步骤**。
3. 以后只用：`su -c 'sh /data/adb/frida/frida.sh'`

### 同样要记住的：`frida-inject` 二进制

它是**尼尼推到 `/data/local/tmp`、主人再 `cp` 进 `/data/adb`** 的。
严格说这**也是同一类信任**：root 执行了一个尼尼经手的二进制。

⇒ **以后升级 `frida-inject` / `run.sh`，都请「过目 + 校对官方 sha256」，别直接 `cp`。**

（当时尼尼就把哈希给出来了，也明说了"**这个哈希是尼尼报的，可能不可信，你自己重下核对**"。）

---

## 十、还没做的（诚实清单）

1. **`resolve_pid` 只认"进程名 == 包名"**。宿主实测 `comm` 是 `deepseek.chat.a`（少了 `com.`），
   所以白名单里要填**实际进程名**，不一定等于包名 —— 装好后第一件事就是
   `su -c 'ps -A -o PID,NAME | grep -i deepseek'` 对一下。
2. **没有结果推送**，尼尼靠轮询（`sleep 3 && cat`）。够用。
3. **没做多目标并发**，一次一个任务。
4. **`--watch` 是常驻的**，虽然 30 分钟自退，但主人不想开就别开，用"跑一次"模式。
