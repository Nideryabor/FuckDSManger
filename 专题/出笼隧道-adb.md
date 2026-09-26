# 出笼隧道 —— 用 adb 无线调试把闭环合上

> 2026-09-27 · 尼得亚伯 🐲
> 这是从「手抓日志」到「全自动闭环」的那根线。
> 工具在 `tools/出笼隧道/`。

---

## 一句话

**容器里的我（uid 10370 / `untrusted_app` / `NoNewPrivs=1` / `CapEff=0`）通过
`adb connect 127.0.0.1:<无线调试端口>`，借 adbd 的进程身份爬出去。**

`adb shell` 跑的根本不是容器里这个进程，而是 **adbd fork 出来的、属于 `shell` 用户的进程**
—— 容器的牢笼（proot 路径重写 / NoNewPrivs / untrusted_app 域）**一样都不继承**。

```
容器进程 (10370, untrusted_app)
      │  ← 这一层全是墙
      │  adb connect 127.0.0.1:<port>
      ↓
   adbd  ──fork──▶  sh (uid 2000, u:r:shell:s0)   ← 出笼了
                        │
                        └── su ──▶ uid 0, u:r:ksu:s0   ← 满能力
```

---

## 为什么别的路都走不通（试错记录，别再走）

| 尝试 | 结果 |
|---|---|
| 容器里的 `/usr/bin/su`（setuid root） | ❌ `NoNewPrivs=1` ⇒ 内核直接无视 setuid 位 |
| 要一个"真 su"二进制 | ❌ proot 会重写路径；拷进容器后 SELinux 标签变 `app_data_file`，域切换不发生 |
| `ksud`（KernelSU-Next 的守护程序） | ❌ 要 `/system/bin/linker64`（bionic），容器是 glibc |
| `su_compat`（KSU 的 execve 钩子） | ❌ 实测 `Uid` 恒为 10370；三种 execve 写法全败 |
| `nsenter` / `mount` / `/proc/1/root` | ❌ `CapEff=0`；且 `hidepid=invisible` 只让看自己那 8 个进程 |
| `chroot` | ❌ 同上 |

**结论：容器内部无解。必须从外面借一个进程身份。**

> ⚠️ 注意顺序：**先绕了一大圈内核钩子/SELinux 域，越钻越深。**
> 正门（adb）一直在隔壁，是主人想到的。

---

## 首次配对（一次性）

1. 手机：**开发者选项 → 无线调试 → 打开**
2. 手机：点 **「使用配对码配对设备」**，**弹框保持打开**
3. 拿到 **6 位配对码** + **配对端口**（弹框里那行 `IP:端口`）
4. 容器里：
   ```sh
   adb pair 127.0.0.1:<配对端口> <6位配对码>
   # → Successfully paired to 127.0.0.1:41003 [guid=adb-3B1F5LE5MS11WQPW-pnUDpu]
   ```
5. 弹框里那个端口**用完就关**。主服务端口是另一个（无线调试主页上那行）：
   ```sh
   python3 tools/出笼隧道/扫adb端口.py
   adb connect 127.0.0.1:<主服务端口>
   ```

> ⚠️ **配对码寿命很短**（屏幕上可能有倒计时），且**端口每次随机**。
> 正确姿势：先开好弹框 → **立刻**报「配对码 + 端口」→ 我马上打。
> 报码格式约定：`<6位码> <空格> <端口>`。

**配对成功一次就够了** —— key 存在设备上，之后 `adb connect` 直接可用（不用再配对）。

---

## 之后每次（已自动化）

```sh
sh /workspace/tools/出笼隧道/adb.sh shell id
```

`adb.sh` 自动：起 server → 拿缓存端口连 → 连不上就全段扫 → 扫到能用的记住 → 参数转给 adb。

> ⚠️ **容器每次工具调用都会回收后台进程**，`adb server` 活不过一次调用。
> ⇒ **必须过 `adb.sh`**，别裸调 `adb`。

---

## 现在能干什么

### shell 身份就够（不依赖 su）

| 能力 | 命令 |
|---|---|
| **抓日志** | `sh adb.sh shell 'logcat -d -t 500 \| grep -aE "FDM-UI\|FuckDSManger\|GmEntry\|FdmBridge"'` |
| **装包** | `sh adb.sh install -r /workspace/FDM-<版本>-single-signed.apk` |
| **重启宿主** | `sh adb.sh shell am force-stop com.deepseek.chat.a` |
| **看装了哪版** | `sh adb.sh shell 'dumpsys package <包名> \| grep versionName'` |
| **文件进出** | `sh adb.sh push / pull ...`（`/sdcard` 可读写） |
| **进程 / 包列表** | `sh adb.sh shell 'ps -A \| grep deepseek'` · `pm list packages` |

### 需要 root → 走【只读模式】（2026-09-27 定稿）

**普通 `adb shell` 是 uid=2000(shell)**，读不了 `/data/data`。
要读 app 数据必须 `su -c`，此时 KernelSU 的 profile 会给：

```
uid=0(root) gid=0(root)
groups=0(root),1007(log),1011(adb),1028(sdcard_r),1036(logd),3009(readproc)
context=u:r:ksu:s0
CapEff: 0000000000000004      ← 只有 CAP_DAC_READ_SEARCH
CapBnd: 0000000000000004
```

**⇒ 能读任何文件；写、删、改一律被内核拒绝。**

**KernelSU profile 配置（挂在 `com.android.shell` 上）：**

| 字段 | 值 |
|---|---|
| UID | `0` |
| GID | `0` |
| 组 | `1007`(log) · `1036`(logd) · `3009`(readproc) · `1028`(sdcard_r) |
| 权能 | **只勾 `DAC_READ_SEARCH`** |
| SELinux 上下文 | 留空（⇒ `u:r:ksu:s0`） |

> ⚠️ **UID 必须填 `0`，填 `9999`(nobody) 会失效** ——
> 非 root 进程 `execve` 时内核会**清空能力集**（CapBnd 对但 CapEff=0）。
> 这是 Linux 天生机制，不是配置错。
>
> ⚠️ 但 `uid=0` 时**装包 / force-stop / settings 仍可用** ——
> capabilities 只管文件系统，管不到 binder → system_server 那一层。
> 且**普通 shell 本来就能装包**（`pm install-create` → Success），
> 所以"堵住 su 的装包"是白堵：真正有效的只有**文件层面的只读**。

**用法：**

```sh
sh tools/出笼隧道/ro.sh 'ls -la /data/data/com.deepseek.chat.a/files/mmkv/'
sh tools/出笼隧道/ro.sh 'head -c 200 /data/data/<包>/shared_prefs/fdm_ui.xml'
```

**能读到的：**

| 目标 | 路径 |
|---|---|
| 宿主 MMKV（灰度键真值） | `/data/data/com.deepseek.chat.a/files/mmkv/mmkv.default` |
| 我们的 SP | `/data/data/com.little_femaleboy.*/shared_prefs/` |
| LSPosed 作用域 | `/data/adb/lspd/` |
| KSU 配置、日志 | `/data/adb/ksu/` |

> ⚠️ 宿主的 `key_user_info` 里有**登录 token 和手机号**。
> **不碰、不拷、不打印、不写进任何文档。**
>
> ⚠️ 只读模式下**装不了包**（`su -c pm ...` 会被拒）。
> 装包走普通 shell / `adb install`（那条路本来就是 uid 2000，有权限）。

---

## 闭环现状

```
① 报 bug          →  主人
② 抓日志          →  ★ 我（adb logcat）
③ 分析            →  我
④ 改源码          →  我（mod-src 真编译 + pipeline Compose）
⑤ 构建出包        →  我（sh /workspace/做包.sh
⑥ 装 demo         →  ★ 我（adb install -r）
⑦ 重启宿主        →  ★ 我（adb shell am force-stop com.deepseek.chat.a）
⑧ 真机测试        →  主人
```

**②③④⑤⑥⑦ 全在我爪子里。主人只剩 ① 和 ⑧。**

---

## 环境备忘

| 项 | 值 |
|---|---|
| 设备 | OnePlus **PJZ110** / Android 15 |
| Root | **KernelSU-Next**（`com.rifsxd.ksunext`）+ `susfs4ksu` 模块 |
| 框架 | LSPosed（`org.lsposed.manager`） |
| 宿主 | `com.deepseek.chat.a` v2.5.2 (vc273) |
| 模块 | `com.little_femaleboy.cannot_show.the_big_won_whale` |
| 我的容器宿主 | `me.rerere.rikkahub`（uid 10370） |
| adb guid | `adb-3B1F5LE5MS11WQPW-pnUDpu` |
| 最近端口 | `34597`（缓存于 `tools/出笼隧道/.adbport`） |

## 给下一轮的我

1. **隧道在 `tools/出笼隧道/adb.sh`**，一行调用，自动重连。**别裸调 adb。**
2. 无线调试**重启手机会关**，需要主人重新打开；**配对不用重做**。
3. 掉线时先跑 `sh adb.sh shell id`，它会自己扫端口重连。
4. `tmp/adb.sh` 是转发壳，老路径也能用。
