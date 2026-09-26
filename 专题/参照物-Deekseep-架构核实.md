# 参照物 Deekseep（com.dsmod.probe）· 架构核实

> 核实对象：`Deekseep_1.7.5.apk`（vc35, minSdk24 / targetSdk34, 11.3 MB, 972 zip 条目, 9166 类, 单 dex）
> 核实方式：`mt_apk_*` 读清单 + dex 搜索 + 类轮廓。核实日期 **2026-09-26**（由尼得亚伯执行）。

---

## 零、为什么核实

2026-09-25 我在 `UI-方案B-可运行版.md` 里写了一条：

> ~~**数据桥**：App 用 root 读写宿主配置（参照物用 Shizuku ✓ 我们有 root）~~

**这条是错的。** 主人当场纠正：「deekseep 的 shizuku 是用在另外地方的」。
下面是核实后的事实。

---

## 一、Shizuku 的真实用途：AI Agent 的高权限工具后端

**和「UI ↔ 宿主」毫无关系。** 它是给 **Agent 本地工具（文件 / Shell / 截屏）** 用的**权限来源之一**，
与 **Root 二选一**，由用户在设置里选。

证据：

| 位置 | 证据 |
|---|---|
| `com.dsmod.probe.AgentDeviceBridge`（148 方法） | 31 处 `shizuku` / `Shizuku` 字符串 |
| `AgentDeviceBridge$I01_` | `"Shizuku 已连接（shell 权限）"` / `"Shizuku connected (shell identity)"` |
| `AgentDeviceBridge$I01_iII` | `"尚未选择 Root 或 Shizuku 后端"` |
| `DeekseepUi` | `"工具 Root Shizuku"` / `"管理本地工具、权限模式以及 Root / Shizuku 后端。"` |
| `AgentSettingsUi` | `"已选择 Shizuku；连接时若服务未启动，会尝试通过 Root 自动启动"` |
| `II0IlIILII0` | `"截取当前屏幕；外部屏幕需要 Root 或 Shizuku"` |
| `HeartbeatToolProtocol` | `"应用内后端使用 DeepSeek 自身权限；用户选择 Root 或 Shizuku 且设为全部允许后，文件、Shell 与界面工具才会使用相应高权限。"` |
| **ZIP 条目** | `META-INF/com.dsmod.probe.agent/rish_shizuku_rt.dat` ← **把 rish 打包塞进 APK 当 shell 通道** |

⇒ 一句话：**Shizuku = "让 Agent 拿到 shell/文件/截屏权限"的可选后端**，
是**功能本身**（AI 操作手机），**不是**模块与 UI 之间的通信机制。

> 附：它的 `queries` 里只有 `com.deepseek.chat` / `com.tencent.qqmusic` / `com.netease.cloudmusic`
> —— 说明被它"服务"的目标就是这几个，Shizuku 也服务于同一批目标，而**不是用来读写宿主配置**。

---

## 二、真正的架构：一个 APK，两个身份，一条 ContentProvider 桥

### 2.1 一个 APK 两个身份

```xml
<meta-data android:name="xposedmodule"    android:value="true"/>
<meta-data android:name="xposeddescription" .../>
<meta-data android:name="xposedminversion" android:value="82"/>
<meta-data android:name="xposedscope"     android:resource="@..."/>
<activity android:name="com.dsmod.probe.SettingsActivity" android:exported="true">
    <intent-filter> MAIN / LAUNCHER </intent-filter>   ← 桌面图标：UI 层
</activity>
```

```
assets/xposed_init  →  com.dsmod.probe.Main        ← hook 层（无 UI，跑在宿主进程里）
```

⇒ **同一个包，既是 LSPosed 模块，又是普通桌面 App。** 这正是**主人今天提的那套思路**的现成实证。

### 2.2 桥：`XposedActivationProvider`（ContentProvider，不是 root、不是 Shizuku）

```
authority  : com.dsmod.probe.XposedService
exported   : true          ← 跨进程可达
入口       : call(String method, String arg, Bundle extras) → Bundle
             （query/insert/update/delete/getType 全是空壳，故意不用）
```

`call()` 的 method 派发（dex 里可见字符串）：

| method | 方向 | 作用 |
|---|---|---|
| `SendBinder` | UI → hook | 往里塞一个 `IBinder`（`frameworkBinder` 静态字段），拿到 libxposed 服务通道 |
| `ReportDeepSeekActive` | **hook → UI** | 宿主上报"我还活着"+ `versionName` / `versionCode` |
| `s0` / `g0` | hook → UI | keepalive 控制 / 取状态（返回 Bundle） |
| `SetPublicTunnel` / `GetPublicTunnel` / `CancelPublicTunnel` | hook → UI | 内网穿透开关 |
| `ControlLocalAudio` / `GetLocalAudioStatus` / `GetQqMusicStatus` | hook → UI | 音频控制（配合 FGS `LocalAudioPlaybackService`） |
| `GetPinggyTunnel` / `SetPinggyTunnel` | hook → UI | 另一条穿透通道 |

**方向确认（关键）**：hook 层类 `com.dsmod.probe.Main` 里直接就有
`content://com.dsmod.probe.XposedService` 字面量，出现在：

- `Main->callPublicTunnelProvider(Landroid/app/Activity;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;`
- `Main->reportActivationHeartbeat(Landroid/app/Activity;)V`

⇒ **在宿主进程里跑的 hook 层，主动 `ContentResolver.call()` 进 UI App 的 provider 取/存数据。**
（provider 属于 UI App 进程 → 会被自动拉起。）

### 2.3 安全校验（照抄这层）

provider 每个敏感方法开头都做：

```java
int uid = Binder.getCallingUid();
if (!uidOwnsPackage(context, uid, "com.deepseek.chat")) {
    // rejected ... from uid=   → 返回 error Bundle
}
```

`uidOwnsPackage()` = `PackageManager.getPackagesForUid(uid)` 里比对包名。
⇒ **不需要自定义权限，用 callingUid 白名单**，干净利落。

### 2.4 反向通道：hook 层用 Intent 拉起 UI

hook 层 `Main` 里的方法都吃 `deekseep-module` scheme：

```
Main->requestPublicTunnelBridge(Landroid/app/Activity;)V
Main->requestLocalApiFloatingWindowExact(Landroid/content/Context;ZLjava/lang/String;)Z
Main->requestLocalApiKeepAlive(Landroid/content/Context;ZZ)Z
Main->queueAgentDelay(...,Z)Z
```

对应 manifest 里一串 **trampoline activity**：

```xml
<activity android:name="com.dsmod.probe.z20"          android:exported="true"
          android:taskAffinity="" android:excludeFromRecents="true" android:noHistory="true">
    <data android:scheme="deekseep-module" android:host="ka1"/>
</activity>
<activity android:name="...AgentDelayActivity"         ... host="agent-delay"/>
<activity android:name="...RuntimeProofTrampolineActivity" ... host="rp257"/>
```

⇒ 宿主侧**只用 `startActivity`**，UI 全在 UI App 自己的进程里长出来。

### 2.5 存活/版本回执

```
prefs 名  : deekseep_activation
键        : target_at (long, 心跳时间) · target_version_name · target_version_code
TTL       : TARGET_FRESH_MS = 0x240C8400 = 604800000 ms = 7 天
静态 API  : isTargetRecentlyActive(ctx) · targetVersion(ctx) · targetVersionCode(ctx)
            isFrameworkConnected()  ← binder.pingBinder() 判框架在不在
```

⇒ UI 层**不靠宿主合作**就能显示「宿主最近活着没 / 什么版本 / 框架连没连」。
（`stateListener: Runnable` + `notifyStateChanged()` 做 UI 刷新。）

### 2.6 还有两套冗余通道（我们不需要，但知道它们存在）

- `XposedActivationReceiver` —— exported 广播（另一条 UI → hook 通路）
- `io.github.libxposed.service.IXposedService` —— **现代 libxposed(API 100) 的 Service 通道**
  （`SendBinder` 收的就是这根 binder）
- `RuntimeProofBrokerService / ProviderA / ProviderB` + `:rp_gate` / `:rp_a2` / `:rp_b2` 多进程
  —— 是它自己做"运行时自证"用的，**与通信无关**，别被名字骗。

---

## 三、结论（给我们自己的）

1. ~~我们用 root 读写宿主配置~~ → **不需要 root**。
   桥用 **`ContentProvider.call()` + Bundle + callingUid 白名单**，跟 Shizuku 无关。
2. **「UI 层 + hook 层，同包不同进程」是已被验证可行的架构**，参照物就是活证据。
3. 我们的额外优势：目标宿主是 `com.deepseek.chat`，**我们本来就有 root 装模块**，
   连"Shizuku 权限后端"那条路都不需要（那是 Deekseep 为了 AI 操作手机才做的）。
4. 我们**已有的两半**正好能拼成它：
   - `mod-src/`（真编译 + 自写 AXML 编解码 + 自封 APK + 自有私钥）→ **hook 层**
   - `fdm-app/`（Compose UI，3.0 已能打开）→ **UI 层**
   - 缺的就是这条 **provider 桥**。
