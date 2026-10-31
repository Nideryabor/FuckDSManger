# lspctl 白名单网关 🐲

> 2026-10-24 · 尼得亚伯
> 解决：LSPosed 2.2.0+ 的 `lspctl` 只能在 root 下跑，而尼尼（AI）只有 adb shell。

---

## 为什么不是"直接给 App 开 su"

| 方案 | 风险 |
|---|---|
| KSU 给工作区 App 授权 | **按 App 给，拿到就是该 App 内所有命令都能跑** —— 尼尼的 shell 是 AI 驱动的，提示注入 = root 被劫持 |
| **白名单网关**（本方案） | 能力锁死在「几条只读/低危的 lspctl 子命令」上 |

本项目有过 `事故-2026-10-01-frida污染zygote`（spawn 把系统搞成"一开就崩"，adb 修不回来）。所以这套防护是**踩过坑之后的设计**。

---

## 部署（主人，真 su）

### 1. 放文件 + 定权限

```sh
su -c '
mkdir -p /data/adb/lspctl-gw/out
cp /data/local/tmp/lspctl_gw_run.sh  /data/adb/lspctl-gw/run.sh
cp /data/local/tmp/lspctl_gw_allow.txt /data/adb/lspctl-gw/allow.txt
chown -R root:root /data/adb/lspctl-gw
chmod 0700 /data/adb/lspctl-gw
chmod 0700 /data/adb/lspctl-gw/run.sh
chmod 0600 /data/adb/lspctl-gw/allow.txt
chmod 0700 /data/adb/lspctl-gw/out
rm -f /data/local/tmp/lspctl_gw_*.sh /data/local/tmp/lspctl_gw_*.txt
ls -laR /data/adb/lspctl-gw/
'
```

### 2. 起网关

```sh
su -c 'sh /data/adb/lspctl-gw/run.sh'        # 后台（30 分钟空闲自动退）
su -c 'sh /data/adb/lspctl-gw/run.sh -f'     # 前台（看进度）
su -c 'sh /data/adb/lspctl-gw/run.sh -s'     # 状态
su -c 'sh /data/adb/lspctl-gw/run.sh -k'     # 停
```

**看到这行就成功：**
```
✓ 预检通过 · 等待 job（/data/local/tmp/lspctl_job.txt）
```

---

## 目录布局（权限是有意义的，别改）

```
/data/adb/lspctl-gw/          root:root 0700   ← 只 root 能进（尼尼改不了 run.sh/allow.txt）
  run.sh                      root:root 0700
  allow.txt                   root:root 0600   ← 白名单，只有你能改
  out/                        root:root 0700
    result.txt                root:root 0644   ← 权威结果（防篡改）
    audit.log                 root:root 0644

/data/local/tmp/lspctl_job.txt     shell 可写      ← 尼尼投任务
/data/local/tmp/lspctl_out/        root:root 0755 ← 只放只读副本
  result.txt                       root:root 0644 ← 尼尼读这个
  audit.log                        root:root 0644
```

**为什么结果要两份**：权威的在 root-only 目录（防 shell 篡改），对外只**单向拷贝**一份给尼尼读。
拷贝前 `rm -f` 再 `cp`，防止 shell 预置符号链接把写入导向别处。

---

## 投任务（尼尼这边）

### 约定（重要）

**必须用「写临时文件 + mv 原子替换」**，不能边写边被读：

```sh
cat > /data/local/tmp/lspctl_job.tmp <<'EOF'
id=<任务名>
cmd=lspctl --json status
timeout=30
EOF
mv -f /data/local/tmp/lspctl_job.tmp /data/local/tmp/lspctl_job.txt
```

网关侧也有双保险：**末尾不是换行就跳过本轮**（防半写）。

### 读结果

```sh
cat /data/local/tmp/lspctl_out/result.txt
```

格式：
```
job=<任务名>
status=ok | denied | timeout | killed | error
rc=<退出码>
time=2026-10-24 19:52:08
--- output ---
<命令输出（超 64KB 截断）>
```

---

## 白名单语义（`allow.txt`）

| 写法 | 允许什么 |
|---|---|
| `lspctl module list` | **只**允许这一条 |
| `lspctl scope add ` （带尾空格） | 允许 `lspctl scope add` **和** `lspctl scope add <参数>` |

⇒ 带不带尾空格都能用（实现里统一按「去尾空格 = base」判定）。

### 当前放开的

```
状态      lspctl status / --json status / -V / --version
只读      lspctl module list / --json module list
只读      lspctl scope list / --json scope list
可写      lspctl scope add|remove|set   ← 治"得手动点 LSPosed"的老痛点
只读      lspctl hook-debug ...
```

### 故意不放的

```
lspctl stop                    ← 停 daemon = 所有模块失效
lspctl module enable/disable   ← 能关别人的模块
lspctl module remove           ← 能删模块配置
```

**要临时放开**：手改 `allow.txt`（root:root 0600，尼尼改不了），用完立刻删那行。

---

## 安全设计（v5 修完 review#4）

### 🔴 必改（2 条，都是 v4 新引入的）

| # | 问题 | 修法 | 自测 |
|---|---|---|---|
| **1** | **`file_ok` 的 setuid 检查被全局变量副作用彻底废掉**（v4 新引入，**完全静默**）<br>`is_world_writable` 里 `_m="$1"; _m=${_m#?}` 改的是**全局 `_m`** ⇒ `file_ok` 里后续 `has_special_bits "$_m"` 收到削过的 3 位 ⇒ 永远 return 1 ⇒ **4755 的 allow.txt 能过** | 两个函数内部变量全改 `_wm/_wg/_wo/_sb`；`file_ok`/`dir_ok`/`check_pub_dir` 统一用独立 `_perm` | `4755 → ✗拒绝`<br>`2755 → ✗拒绝`<br>`2644 → ✗拒绝`<br>`600/400 → ✅通过`<br>**变量污染验证：调用后 `_m` 仍是 `4755` ✅** |
| **2** | **`-k` / `-s` 跑在 `MUST_DIR` 检查之前**（v4 新引入）⇒ 从 `/data/local/tmp` 跑 `-k`，`PID_FILE` 可被写任意 pid ⇒ **root 级杀进程面**；`rm -rf "$LOCK"` 也没 `dir_ok` 兜底 | `MUST_DIR` 校验**提到最前**（含 `-k`/`-s` 之前）；`stop_gw`/`show_status` 读 PID 前过 **`_safe_pid_file`**（非链接 + root 属主 + 非可写 + **内容是纯数字 1~8 位**）；清锁前 `[ ! -L "$LOCK" ]` | `1234 → ✅`<br>`999999999 → ✗`<br>`1234x → ✗`<br>`12; rm -rf / → ✗`<br>`-1 → ✗` |

### 🟡 建议（3 条）

| # | 问题 | 修法 |
|---|---|---|
| **3** | `_mono` 用 `$(...)` 读 `$SECONDS` —— 子 shell 若重置为 0 ⇒ `_now - LAST_ACT` 恒 0 ⇒ **空闲计时永不触发、进程永不退出** | 改 `_mono_set` 设全局 `_MONO_NOW`，**主 shell 直接读**（不 fork）；值非数字时归 0 |
| **4** | CRLF 规范化的 `mv` 失败未检查（静默继续，CRLF 没去掉却以为去掉了）| `mv ... \|\| { rm -f "$ALLOW.n"; say "✗ 替换失败"; return 1; }` |
| **5** | 无 `timeout` 降级分支：`kill "$_kpid"` 只杀子 shell，里面的 `sleep` **变孤儿**继续睡 | `_kill_tree "$_kpid"` 先杀其子进程再 `kill -9` |

### 🟢 小项

| 项 | 修法 |
|---|---|
| `pkill` 可能不存在（精简 ROM）| `_kill_tree` 退化到遍历 `/proc/<pid>/task/*/children`（递归）|
| `RESULT` 是 0644（OUT_DIR 755 时别人可读）| 保持 0644（内容与 PUB_RESULT 相同，本就公开），靠 `OUT_DIR` 700 隔离 |
| 版本号不一致（文件头 v3，里面全是 v4 标记）| **统一成 v5** |
| `_audit` 保留 TAB | 保留（不影响解析）|

---

## 自测记录（v5）

### 🔴1 file_ok 全组合

```
600   → ✅ 通过
400   → ✅ 通过
4755  → ✗ 拒绝     ← v4 会放行！
2755  → ✗ 拒绝
2644  → ✗ 拒绝
1755  → ✗ 拒绝
666   → ✗ 拒绝
777   → ✗ 拒绝

变量污染：调用前 _m=[4755] → 调用后 _m=[4755]  ✅
```

### 🔴2 PID 内容校验

```
[1234]          → ✅ 接受
[1]             → ✅ 接受
[99999999]      → ✅ 接受
[999999999]     → ✗ 拒绝（>8 位）
[1234x]         → ✗ 拒绝（非数字）
[]              → ✗ 拒绝
[12; rm -rf /]  → ✗ 拒绝
[-1]            → ✗ 拒绝
```

### 🟡3 单调时钟

```
a=1792844094 b=1792844096 差=2  ✅
（沙箱无 $SECONDS / /proc/uptime ⇒ 退到 date +%s；Android 会用前两者）
```

---

## 部署（v3 起必须用 deploy.sh）

### 🔴 必改

| # | 问题 | 修法 |
|---|---|---|
| **1** | **`stop_gw` 停不掉正在跑的命令** —— `timeout` 分支**没记子进程 PID**；而主 shell 阻塞在 `wait` 里时 **mksh 不处理 trap** ⇒ `-k` 后最长还要等 60 秒 | **timeout 分支也后台化并记 PID**；`stop_gw` 先 `pkill -9 -P`（连 timeout fork 出的真正 lspctl 一起杀）再杀主进程 |

### 🟡 建议

| # | 问题 | 修法 |
|---|---|---|
| **2** | `JOB` 与 `OUT_DIR` **可能跨文件系统**（`/data/adb` 是 KSU 挂载）⇒ 跨 fs 的 `mv` = 复制+删除，**不原子**，中途失败 job 部分丢失 | 改成 **`cp` → 校验（非空 + 末尾换行）→ 才 `rm` 源**；任一步失败 ⇒ 保留源、下轮重试 |
| **3** | 审计可被 **CR / LF / ANSI / 控制字符**污染 —— `denied` 的命令**没经过 `check_cmd` 字符集过滤**，最危险的是 `\n` 能**凭空伪造第二条 ALLOW 记录** | `_audit` 写入前 `tr -d '\000-\010\012-\037\177'`（**保留 TAB，删掉 LF**）+ 限长 300；`_jid` 也过 `_sanitize_jid`（只留 `[A-Za-z0-9._-]`，≤64）|
| **4** | `check_pub_dir` 的「可读性提示」对 **4 位权限取错位**（`2755` 的 `cut -c2` 拿到 user 位 7 ⇒ 误报 group 可读）| 先 `sed` 削掉 setuid/setgid 位再取 group 位 |

### 🟢 小问题

| 项 | 修法 |
|---|---|
| `has_special_bits` 定义未用 | **接进 `file_ok`**（数据文件不该带 setuid/setgid）|
| `if ! : > /dev/null; then :; fi` 死代码 | 删掉 |
| `_mono` 的 `$SECONDS` 注释「实测为空」 | 保留（避免后人误删）|
| `MAX_ARGS` 用 `wc -w` 分词 | 注释里写明「**参数不允许引号**」 |

---

## 自测记录（v4）

### 🔴1 timeout 分支记录 PID

```
记录的子进程 PID: 18864（实际 18864）  ✅
pkill -9 -P + kill -9 后：已杀掉（连带子进程）  ✅
```

### 🟡2 跨 fs 取 job

```
cp → 校验非空 + 末尾换行 → 才 rm 源
失败路径：保留下轮重试（不再 mv 丢数据）
```

### 🟡3 审计净化（**这条 v3 有漏洞**）

```
原始: lspctl x␍␛[31mFAKE␛[0m␊2026-01-01 FORGED ALLOW␉TAB
v3 净化后: ...FAKE...[0m␊2026-01-01 FORGED ALLOW␉TAB   ← ⚠️ 换行还在！
v4 净化后: lspctl x...[31mFAKE...[0m2026-01-01 FORGED ALLOW␉TAB
换行数: 0  ✅ 无法伪造第二条审计
TAB 保留 ✅ · ESC 已删 ✅
```

> v3 的 `tr -d '\000-\010\013-\037\177'` **从 `\013` 开始**，漏掉了 `\012`（LF）——
> 于是 `\n` 原样进了 audit.log，**攻击者可以用它凭空插一条 `ALLOW lspctl ...` 假记录**。
> v4 改成 `\000-\010\012-\037\177`（保留 `\011` TAB，删 `\012` LF）。

### 🟡4 权限取位

```
755  → 归一 755  group=5 → 可读   ✅
2755 → 归一 755  group=5 → 可读   ✅（v3 会读成 user 位 7）
2710 → 归一 710  group=1 → 不可读 ✅（v3 会误报可读）
700  → 归一 700  group=0 → 不可读 ✅
```

### 🟢 jid 净化

```
job1              → job1
job␛[31m红        → jobx1b31m      （ESC/中文已滤）
../../etc/passwd  → ....etcpasswd  （路径穿越字符没了）
（100 个 a）      → 64 个 a         （限长）
（空）            → unnamed
```

---

## 部署（v3 起必须用 deploy.sh）

### 🔴 必改（4 条）

| # | 问题 | 修法 |
|---|---|---|
| **1** | **`check_cmd` 的「无参数」语义被抹平** —— v2 里 `_base` 去掉尾空格后**无条件**前缀匹配 ⇒ 白名单每一行都允许追加任意参数（`lspctl module list --output=...` 也放行）。**这是 v2 新引入的 fail-open，和它声称修掉的旧 🔴2 是同一类错误换了个位置** | **严格区分**：先记 `_has_args`（行尾有无空白），精确等于 `base` 一律允许；**只有**行尾带空白时才允许 `base <args>`。再补**参数个数 ≤6、单参数 ≤120 字节**上限 |
| **2** | `_dir_make_public` 的 `rm -rf`/`mkdir`/`chown`/`chmod` 是新提权面（TOCTOU：shell 可在 rm 与 mkdir 之间塞 symlink，root 的 chown/chmod 就跟随到攻击者路径） | **改成只校验不重建**；`PUB_DIR` 由 `deploy.sh` 预创建并定死权限。发现是 symlink / 属主不对 / 别人可写 ⇒ **告警并拒绝继续** |
| **3** | `MUST_DIR` 定义了**从没用过** ⇒ 🔴4 的根因还在（脚本可从任意路径跑，`OUT_DIR` 父目录可能就是可写的） | 主流程开头硬校验 `[ "$HERE" = "$MUST_DIR" ] \|\| exit 1` |
| **4** | 单实例锁是 **check-then-write 不原子**（两实例同时启动都看到"不存在"⇒ 都写 ⇒ 两个都在跑） | 改用 **`mkdir` 原子锁**（同一文件系统上 mkdir 是原子的） |
| **5** | `timeout` 默认只发 **TERM**，忽略就杀不掉（进程残留继续跑），而降级分支用 `kill -9` ⇒ 两条路径强制力不一致 | `-s KILL` 优先（带能力探测）；不支持则 `-k 2`；再不行才裸 `timeout` |

### 🟡 建议（9 条）

| # | 问题 | 修法 |
|---|---|---|
| 6 | CRLF 规范化在**校验前**改写且不设权限（umask 0022 ⇒ 变 0644，别人可读白名单）| 先 `file_ok` → 规范化 → **显式 `chmod 0600` + `chown root:root`** → 再 `file_ok` |
| 7 | `sed -E` 兼容性（旧 toybox 不支持 ⇒ `_base` 空 ⇒ 全部拒绝）| 全改 **BRE**：`sed 's/[[:space:]]*$//'` |
| 8 | `stop_gw` 只杀主进程，`sh -c "$_cmd"` 子进程成孤儿 | 记 `CHILD_PID_FILE`，`-k` 时先杀子再杀主 + 清锁 |
| 9 | `mv` 失败每秒刷屏 | `_fail_backoff`：连续失败计数 + **只在原因变化时 say** + 3 次后 `sleep 2` |
| 10 | job 是 symlink 时 `mv` 移的是链接本身 | `[ -L "$JOB" ]` ⇒ 直接删 + 审计 DENY |
| 11 | `_emit` / `_emit_file` 90% 重复 | 合并成 `_write_result` |
| 12 | 审计只留 `.1` | 保留 **`.1`~`.3`** |
| 13 | 空闲计时用 `date +%s` 受时间跳变影响 | **三级降级**：`$SECONDS`（dash 不支持，实测为空）→ `/proc/uptime` → `date +%s`；启动时打印用的是哪个 |
| 14 | preflight 不保证 PUB_DIR 可读 | 检查 group 读位，读不到就明确说"尼尼可能读不到结果" |

### 🟢 小问题（4 条）

| # | 修法 |
|---|---|
| `is_world_writable` 不检查 setuid/setgid | 补 `has_special_bits()`（预留给将来校验可执行文件）|
| `_emit` 写失败静默 | 加 `say` |
| `check_cmd` 的 ③ 分支是死代码 | 删掉 |
| 137 来源区分（超时 kill vs OOM）| 用 `_kill_note` 标记，审计里能区分 |

---

## 自测记录（v3）

### 🔴1 关键回归（v2 的 fail-open）

```
✅ DENY   lspctl module list --output=/data/local/tmp/x   ← v2 会放行！
✅ DENY   lspctl module list x
✅ DENY   lspctl status --json
✅ DENY   lspctl --version extra
✅ ALLOW  lspctl module list                              ← 无参本身允许
✅ ALLOW  lspctl status
✅ ALLOW  lspctl --version

带参行（allow.txt 带尾空格）：
✅ ALLOW  lspctl scope add
✅ ALLOW  lspctl scope add com.a com.b
✅ ALLOW  lspctl scope remove com.a com.b
✅ ALLOW  lspctl hook-debug
✅ ALLOW  lspctl hook-debug --dump

参数上限：
✅ DENY   lspctl scope add a b c d e f g h    （8 个 > 6）
```

### allow.txt 语义自查（13 行）

```
仅无参  lspctl status / --json status / -V / --version
仅无参  lspctl module list / --json module list
仅无参  lspctl scope list / --json scope list
允许带参 lspctl scope add / remove / set
允许带参 lspctl hook-debug / --json hook-debug
```

### 其它

```
🔴1 权限判据：700/750/755/644/600 → 安全；1777/4777/2777/770/775/777/666 → 危险；空/abc/77 → 危险（fail-close）
🟡7 BRE：sed 's/[[:space:]]*$//' 生效
🟡13 时钟：$SECONDS 空 ⇒ /proc/uptime 无 ⇒ date +%s（差 2s ✅）
🟡5 timeout → rc=124 ✅
🟡8 半写检测 → 半条跳过 ✅
🟡6 审计轮转 → ✅
```

---

## 部署（v3 起必须用 deploy.sh）

```sh
su -c 'sh /data/local/tmp/deploy.sh'
```

`deploy.sh` 会：
1. 建 `/data/adb/lspctl-gw/{out}`（root:root 0700）
2. **预创建** `/data/local/tmp/lspctl_out`（root:root **0755**，group/other 只读不可写）
3. 复制 `run.sh`(0700) / `allow.txt`(0600) 并 chown root
4. **删掉** `/data/local/tmp/lspctl_gw_*` 暂存源文件
5. 逐项自检并打印 ✅/✗

**为什么 PUB_DIR 必须由 deploy.sh 建**：`run.sh` 运行期做 `rm -rf`+`mkdir`+`chown` 是本地提权面（review#2 🔴2），所以 v3 起 `run.sh` **只校验不重建**。

| # | 问题 | 修法 |
|---|---|---|
| 🔴1 | `is_world_writable` 对 4 位权限（1777/4777）**失败开放** | 4 位先削成末 3 位；拿不到有效值 ⇒ **一律当危险**（fail-close）|
| 🔴2 | `allow.txt` 尾空格语义与注释相反（无参版本不中） | 统一成 `base` 精确 + `"base "*` 前缀两条判定 |
| 🔴3 | 无单实例锁（跑两次 → `-k` 只杀得掉一个） | 启动前查活 PID，拒绝重复启动 + `trap TERM/INT` 清 PID_FILE |
| 🔴4 | `/data/local/tmp` 的 symlink/TOCTOU 可让白名单作废 | OUT_DIR 挪 root-only；对外只单向拷贝（`rm -f` 后 `cp`）；每轮校验副本目录不是符号链接 |
| 🟡5 | 无 `timeout` 命令 ⇒ 永不超时 ⇒ 守护挂死 | `timeout` 优先；没有则「后台 + 定时 kill」；两样都没有 ⇒ **拒绝运行** |
| 🟡6 | `audit.log` 无限增长 | 超 1MB 轮转成 `.1` |
| 🟡7 | `emit` 里全局变量污染 | 全部 `_` 前缀 |
| 🟡8 | job 半写 | 末尾不是换行 ⇒ 放回、下轮再试（+ README 约定 mv 原子替换）|
| 🟢9 | `chmod 0755 OUT_DIR` 副作用 | 不再 chmod，权限由部署脚本定死 |
| 🟢 | 字符集注释与代码不一致 / `mv` 失败静默 | 已统一 / 已加 `say` |

---

## 自测记录（v2）

```
🔴1 权限判据
  700/750/755/644/600 → ✅安全
  1777/4777/2777/770/775/777/666 → ✗危险
  空/abc/77 → ✗危险（fail-close）

🔴2 白名单
  lspctl scope add              → ALLOW ✅（尾空格模板的无参版本，v1 的 bug）
  lspctl scope add pkg scope    → ALLOW ✅
  lspctl hook-debug             → ALLOW ✅
  lspctl scope foo              → DENY  ✅（不在白名单）
  lspctl status; reboot         → DENY  ✅
  lspctl status && reboot       → DENY  ✅
  lspctl status | tee /x        → DENY  ✅
  lspctl $(reboot)              → DENY  ✅

🟡5 timeout     → rc=124 ✅
🟡8 半写检测     → 半条被跳过 / 完整条执行 ✅
🟡6 audit 轮转   → 超阈值移到 .1 ✅
```

---

## 这个网关能帮我们解决什么

| # | 用途 | 解决什么 |
|---|---|---|
| **1** | `scope` 读写 | 治老痛点：**装新版不用手动点 LSPosed 了**（文档 3.59/3.61 都记着"改不了 apk_path，得手动关开模块"）|
| **2** | `module list` 校验 | **「模块没生效」不再靠猜** —— 直接查启用状态 + 作用域 |
| **3** | `hook-debug` | **对数美最有用** —— 它查的正是 `sHookedMethodCallbacks`，能提前看自己露了多少 |

---

## ⚠️ 官方警告（记在这，别忘）

`lspctl --help` 里写着：

> It is **not a stable control protocol**. Everything may change without notice.
> **Do not build apps or unattended integrations against it.**

⇒ 尼尼只用它**做调试助手**（每次现场跑），**不写进模块代码**当依赖。
它改了我们也不受影响。
