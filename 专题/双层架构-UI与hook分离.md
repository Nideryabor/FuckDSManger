# 双层架构 · UI 层 + hook 层分离（方案 C）

> 提案人：**主人**（2026-09-26 早上）
> 整理/核实：尼得亚伯
> 参照物实证：`专题/参照物-Deekseep-架构核实.md`（com.dsmod.probe 1.7.5，已逐条读 dex 核实）

---

## 一、主人的原话

> **APP 本身 UI 不 hook 进宿主，在 APP 里面造俩：**
> **一个 UI 层，负责给用户看，宿主通过 intent 拉起**
> **一个 hook 层，没有 UI，专门把 UI 里面的东西应用进宿主**

---

## 二、为什么这条路是对的（三条收益，都是我们已经踩过的坑）

| # | 收益 | 对应我们踩过的坑 |
|---|---|---|
| **1** | **UI 崩了不连累宿主** | `2.22.122→142` 那二十多个包，为了让 Compose 长在宿主进程里，最后撞结构性死结（宿主 Compose 未混淆 ⇒ `ViewTreeLifecycleOwner` 的 tag key 两边 R 不是一个数 ⇒ 必崩） |
| **2** | **宿主进程里的 UI 全都能删掉** | 教训 **106**「功能在生效，只是你看不见」—— 自绘 Dialog 能收点击却不显示；`GmProbe` 悬浮点、探针手势、Toast 回执、`GmDiag` 内存环形缓冲（教训 170：**会静默丢中间段**）。这些**全部**是"在宿主里造 UI"逼出来的。搬走 ⇒ 这一整类坑消失 |
| **3** | **暴露面变小** | 宿主有**数美 + 字节 APM**反检测（`专题/环境伪装与反检测.md`）。宿主进程里少挂东西 = 少一分被看见 |

⇒ 参照物就是这么干的，而且**验证过了**：它的 UI 根本不在宿主进程里。

---

## 三、目标形态

```
                    ┌─────────────────────────────────────────┐
                    │  com.deepseek.chat （宿主进程）           │
                    │                                         │
   LSPosed 注入 ──▶ │  【hook 层】  assets/xposed_init → GmMain │
                    │   · 无 Activity / 无 Dialog / 无悬浮点    │
                    │   · 唯一职责：读配置 → apply 进宿主        │
                    │   · 判据/锚点/写入逻辑 = 现在 mod-src 那套 │
                    └───────────────┬─────────────────────────┘
                                    │ ① ContentResolver.call(provider)  ← 拉配置 / 报心跳
                                    │ ② startActivity(scheme://…)       ← 拉起 UI
                                    │ ③ 动态 BroadcastReceiver          ← 收"配置变了"
                                    ▼
        ┌───────────────────────────────────────────────────────────┐
        │  【UI 层】自己的进程（Compose，桌面有图标，LAUNCHER+exported）│
        │   Provider(authorities="<pkg>.config", exported=true)      │
        │     call("getConfig") → Bundle                             │
        │     call("heartbeat", …) ← hook 层上报宿主版本/存活         │
        │     ★ 每次校验 Binder.getCallingUid() ∈ {宿主包名}          │
        │   17 个二级页 · 试验台 · 排除名单 · 调试页 · 状态回执        │
        └───────────────────────────────────────────────────────────┘
```

**分工红线（关键）**

- **UI 层不碰宿主**：不 hook、不读宿主私有数据、**不需要 root、不需要 Shizuku**
- **hook 层不碰 UI**：没有 Activity、不弹任何东西、不画任何像素
- 两层只交换**纯数据**（Bundle / JSON 字符串）
- ⇒ 跨进程边界就是防止"UI 事故变成宿主事故"的那堵墙

---

## 四、桥怎么搭（照抄参照物，但可以更简单）

参照物只用了 `ContentProvider.call(String, String, Bundle) → Bundle`，`query/insert/update/delete` **全是空壳**。
安全靠 `Binder.getCallingUid()` + `PackageManager.getPackagesForUid()` 比对宿主包名。

### 4.1 我们的协议（草案，够用就行）

| call method | 方向 | 返回 |
|---|---|---|
| `getConfig` | hook → UI | `{rev:int, json:String}` |
| `heartbeat` | hook → UI | `{ok:true}` ← 顺带上报宿主 `versionName/versionCode/存活时间` |
| `applied` | hook → UI | `{ok:true}` ← 回报"已应用 rev=N"，UI 才能显示「**已生效**」而不是「已保存」 |
| `log` | hook → UI | 把 hook 层的诊断日志**推给 UI 显示**（替代 DIAG 环形缓冲） |

> ⚠️ 教训 **84**：诊断日志必须写到"用户能拿到的地方"。
> 现在靠 LSPosed 日志；接上 UI 层之后，日志应该**直接进 UI 的诊断页**。

### 4.2 三个必须处理的现实问题

| 问题 | 处理 |
|---|---|
| **provider 拉不到时（App 被冻结/停用）** | hook 层必须在**宿主自己的目录**留一份上次成功的配置缓存 ⇒ **模块单独也能跑** |
| **不能在主线程做 IPC** | `call()` 会拉起 UI 进程，可能几百 ms。判据入口是绘制路径（`GmBubblePaintHook.pg`）⇒ **严禁同步 IPC**。做法：**懒读 + 内存缓存 + 广播置脏**，绝不在 `pg` 里 call |
| **配置改了要立刻生效**（旧的 🟢 遗留：目前靠重启宿主） | 配置带 `rev`；UI 存完发一次**显式广播**（指向 hook 层注册的动态 receiver，action 带包名 + 随机后缀）⇒ hook 层置 `sDirty` ⇒ 下次判据入口重读 ⇒ **免重启** |

### 4.3 攻击面提醒

`exported=true` 的 provider 是**任何 App 都能调**的。必须：

1. 每个 method 都校验 callingUid（白名单 = 宿主包名）；**不通过直接返回 error，不执行任何副作用**
2. 不通过 provider 暴露文件路径 / shell / 任意读宿主数据的能力 —— **只交换我们自己的配置项**
3. 参照物还额外用 `RuntimeProofBrokerService` 之类做"运行时自证"，**我们不需要**，别被名字诱导加复杂度

---

## 四点五、✅ 主人拍板：**走单包**（2026-09-26）

> 主人原话：「**那不行，改成单包吧。**」
> 本节记录该决定的落地路线；§五保留两种方案的原始权衡，作为决策依据留档。

### 4.5.1 好消息：单包的底子**早就在仓库里**（实测）

| 发现 | 证据 |
|---|---|
| 有人已经写过**单包全流程脚本** | `pipeline/build_full.py`（"FDM 方案A 全流程：POM解析闭包 → 资源合并(0x7e) → R类 → Compose编译 → R8 → 组包 → 签名"）—— 而且它生成的 manifest 里 **已经写了 `xposedmodule` / `xposeddescription` / `xposedminversion` 三个 meta-data**，包名 `com.nidyaber.fuckdsmanger` |
| 它停在哪 | 脚本最后一行是 `③ link 资源 …✅ 资源链完成` ⇒ **④编译 ⑤R8 ⑥组包 ⑦签名 还没写成脚本**（当时是手敲的） |
| 拦路虎**已被解决** | `pipeline/待办-最后一公里.md` 记的是 `androidx.customview.poolingcontainer.R$id` 被 R8 吃掉 ⇒ 实测**现役 `FDM-UI-3.0-signed.apk` 的 `classes2.dex` 里 `poolingcontainer/R$id` 在 ✅** ⇒ 方案B 那条链已经把它修好了（手写 R 类 + D8 单独注入 + 合并） |

⇒ **单包不是重开一条路**，而是：把方案B 那条**已经跑通**的链，
补上"注入 hook 层 dex + assets/xposed_init"，再把 `build_full.py` 的 ④~⑦ 补完。

### 4.5.2 ⚠️ 单包之后**仍然需要 provider**（别误会）

**同一个包 ≠ 同一个进程 ≠ 同一个 uid。**

```
hook 层  跑在宿主进程  uid = com.deepseek.chat 的 uid
UI 层    跑在自己进程  uid = 模块包的 uid
```

⇒ hook 层**读不到** UI 层写的 SharedPreferences（Linux 权限就不允许）。
所以：**单包省掉的是"装两次"，一点都不省桥。**
provider 桥（§四）在单包下**原样必需**。

### 4.5.3 单包独有的两个坑（双包没有）

| # | 坑 | 说明 |
|---|---|---|
| **1** | **宿主进程要背整个 APK 的 dex** | LSPosed 把**模块 APK 路径**挂进宿主 classloader ⇒ APK 里 **所有**标准名 dex 都被 mmap。我们 UI 是 3 dex / 35.7 MB（vs 模块 197 KB） |
| **2** | **同名类冲突面变大** | 宿主自己的 **Compose 未混淆**。我们 UI 也带一份 `androidx.compose.**` ⇒ 一旦宿主进程里任何代码（包括 hook 层手滑）解析到这些类，就会命中**宿主那一份** ⇒ 正是 `2.22.122~142` 那个结构性死结的同源风险。**约束：hook 层的引用闭包必须与 UI/Compose 完全不相交**（要写自检脚本卡住） |

### 4.5.4 两条实现路线

| | **C1 · 直白单包** | **C2 · 单包 + UI dex 隐藏** |
|---|---|---|
| 做法 | 所有 dex 用标准名（`classes.dex` 放 hook 层 + `classes2..N.dex` 放 UI） | APK 根只有 `classes.dex`（hook 层 + 极薄 bootstrap）；UI 的 dex **改名**（如 `ui1.dex`）塞进 `assets/`；App 启动时 `attachBaseContext` 里把 UI dex 解出来、用 `DexClassLoader` + 反射**合并 dexElements 注入自己的 PathClassLoader**（热修复/插件化那一套） |
| 宿主背的 dex | **全量（35.7 MB）** | **只有 197 KB** ✅ |
| 复杂度 | 低 | 高（bootstrap 写错 ⇒ UI 直接起不来） |
| 何时用 | **先跑通闭环用这条** | C1 跑通后、如果宿主冷启动/内存被实测出问题，再升级 |

**尼得亚伯的建议：先 C1，跑通就回头量宿主。**
理由：C2 那套 classloader 注入是"要么全对要么全崩"，现在最缺的是**闭环能跑**，不是省那点 mmap。

> 顺带：C2 还有个隐藏好处 —— UI dex 不进宿主，**宿主 `maps` 里就只多一份 197 KB 的映射**，
> 反检测面几乎等于双包。将来真被检测到了，这条是退路。

### 4.5.5 单包落地要动的文件

```
fdm-app/AndroidManifest.xml   ← 源文件！加 4 个 meta-data + provider + scheme
                                （走 aapt2 link ⇒ 不用二进制补丁，最省事）
pipeline/build_full.py        ← 补 ④Kotlin/Compose编译 ⑤R8(不改名pro) ⑥组包 ⑦签名
mod-src/build.sh              ← 产出 hook 层 classes.dex（现成 ✅）
mod-src/pack/build_apk.py     ← 复用它的"往成品包里塞 dex/资源"能力（现成 ✅）
新: 自检脚本                  ← 卡住「hook 层引用闭包 ⊄ androidx.compose/**」
```

### 4.5.7 ✅ 路线 C 的拦路虎**自己没了**（2026-09-26 实测）

原本以为单包最难的是**"两套 resources.arsc 怎么合并"**（底座一份 + Compose UI 一份）。实测发现**根本不用合并**：

| 实测 | 结果 |
|---|---|
| **底座资源表**（`aapt2 dump resources base/FuckDSManger_NL_2.22.110….apk`） | 一共**只有 6 项**：`array/scope`(["com.deepseek.chat.a"]) · `color/ic_launcher_background` · `mipmap/ic_launcher` · `mipmap/ic_launcher_foreground` · `string/app_name` · `string/xposed_description` |
| **128 类有没有引用资源** | 扫底座 `classes.dex`（188 556 B）里所有 `0x7f******` int 常量 ⇒ **0 个** ✅ |
| **arm64 aapt2 能不能跑** | `aapt2_64 version → Android Asset Packaging Tool (aapt) 2.19` ✅ **能在盒子里跑**，dump 正常 |

⇒ 结论：**资源整个重建就行**（那 6 样重写一遍，图标换我们自己的），
**不需要动"合并二进制资源表"那颗硬骨头**，也**不会碰到 ID 漂移**（128 类压根不引用资源）。

### 4.5.8 单包构件清单（已核实，可直接施工）

```
classes.dex      ← 底座 2.22.110 的 188 556 B 【一个字节不动】（128 类 = hook 层主体）
classes2.dex     ← 【新写】hook 入口 HookMain（真编译）：读 provider 配置 → 写进宿主 SP
classes3..5.dex  ← Compose UI 那 3 个 dex（现状 19.9 + 10.9 + 3.3 MB）
assets/xposed_init → com.…HookMain
AndroidManifest  ← 从【源 XML】重建（aapt2 link，不用二进制补丁）：
                    包名沿用 com.little_femaleboy.cannot_show.the_big_won_whale
                    + 4 个 xposed meta-data + MainActivity(LAUNCHER+scheme) + ConfigProvider + <queries>
res/             ← 重建那 6 样（图标用我们自己的）
签名             ← 我们自己的私钥（4096-bit）
```

### 4.5.9 💡 一个让 hook 层"零改动"的甜点

**128 类一直在读宿主自己的 SharedPreferences / MMKV**（它们的配置来源从来就是宿主存储）。

⇒ 新入口 `HookMain` 只要干一件事：
**`call("getConfig")` 拿到 UI 的配置 → 写进宿主自己的 SP** ⇒ **128 类一行都不用改**，功能立刻按新配置走。
（通知：UI 改完后 `notifyChange` → 宿主进程里的 `ContentObserver` 醒来 → 重写宿主 SP。）

⇒ 单包的 hook 层增量 = **一个新入口类（约 200 行）**，不是重写。

### 4.5.10 版本号沿革（供归档）

| 版本 | 形态 |
|---|---|
| ≤ 2.22.110 | **单包**：模块 + View 路线 UI（**UI 跑在宿主进程里**，自绘 Dialog） |
| 2.22.111~120 | 同上，入口换成真编译的 `GmEntry`（`classes2.dex`） |
| 2.22.121~142 | 试「Compose 注入宿主」⇒ 撞结构性死结（宿主 Compose 未混淆） |
| **FDM-UI-3.0（方案B）** | **双包**：独立 Compose App（34.63 MB），能打开 ✅ |
| **本次（方案C）** | **单包**：`classes.dex` 128 类 hook + `classes2.dex` 新入口 + `classes3..5.dex` Compose UI ⇒ **UI 层跑在自己进程，hook 层在宿主进程** |

### 4.5.11 ✅ 包名：**沿用现役模块包名**（2026-09-26，主人拍板）

**决定：`com.little_femaleboy.cannot_show.the_big_won_whale`** —— 好处是 LSPosed 里的 scope / 授权原样有效，升级链连续，不用重新勾选。

| 选项 | 好处 | 代价 |
|---|---|---|
| **A. 沿用现役模块包名**（✅ 已选） | **LSPosed 里的 scope / 授权原样有效**，不用重勾；升级链连续 | 桌面 App 的名字取自 `android:label`（可随便起），但包名会露在应用信息里 |
| B. 用 `com.nidyaber.fuckdsmanger` | 包名干净 | 换包名 = 新 App ⇒ LSPosed 要重新启用 scope，旧 `com.nidyaber.fdmui` 也要卸 |

> 名字好不好看，用 `android:label` 解决就行 —— 为这个去动 LSPosed 的授权状态不划算。
> ⚠️ 注意：底座 `resources.arsc` 里的**资源包名**仍是老的 `com.varuns2002.disable_flag_secure`（id=7f）——
> 资源包名与 APK 包名**不必一致**，重建资源时顺手改掉即可，不影响任何事情。
| **B. 用 `com.nidyaber.fuckdsmanger`**（build_full.py 里写的） | 包名干净、就是"我们的" | ⇒ **换包名 = 新 App**：LSPosed 里要重新启用 scope；旧的 `com.nidyaber.fdmui`（方案B UI）也要卸 |

> 我倾向 **A**：单包的第一价值是"少折腾、别再出新变数"，而换包名会动到 LSPosed 的授权状态。
> 名字好不好看，用 `android:label` 解决就行。

---

## 五、（决策依据留档）单包 还是 双包？

| | **单包**（参照物做法） | **双包**（现状延伸） |
|---|---|---|
| 形态 | 一个 APK：既是 LSPosed 模块，又是桌面 App | 模块包（197 KB）+ UI App（35 MB）分开 |
| 宿主进程要挂的 dex | **整个 APK 的 dex** | **只有模块那份** |
| 实测数字 | 参照物：1 dex / 9166 类 / 11.3 MB | 我们的 UI：**3 dex / ~33.7k 类 / 35.7 MB**（`classes.dex` 19.9 MB + `classes2.dex` 10.9 MB + `classes3.dex` 3.3 MB）<br>我们的模块：**`classes.dex` 只有 197 148 B** |
| 反检测 | 宿主 `maps` 里多出一个 35 MB 的 dex 映射 | 多出 197 KB ⇒ **几乎看不见** |
| 更新 | 模块和 UI 一起换（一荣俱荣，一损俱损） | 解耦：模块热修 197 KB，UI 随便迭代 |
| 回退 | 回退要换大包 | 回退换小包，秒级 |
| 安装 | 一次安装，一个图标 | 两次安装 |

### 尼得亚伯的建议：**双包**（理由按重要性）

1. **宿主有反检测**（数美 + 字节 APM）。宿主是别人的地盘，**我们往里面塞的东西越小越好**。
   参照物敢塞 11 MB 是因为它**不 care 被 Deekseep 检测**（它是白盒合作/SDK 级？至少没在做环境伪装对抗）。
   我们在做，所以这条对我们权重更高。
2. **模块 = 命门，UI = 皮**。命门要能**独立、快速、最小化**地更新和回退。
3. **现在就能动手**：两半都已经有了（`mod-src` + `fdm-app/FDM-UI-3.0`），
   双包只需要**加一个 provider + 一个 receiver**；单包要先做瘦身（35.7 MB → 10 MB 以内）才能不心慌。

> 但**"双包"完全不违背主人的原意** —— 主人的两条红线（UI 不注入宿主、hook 层不带 UI）
> **两种方案都满足**。区别只是"两个层装在一个 APK 里还是两个 APK 里"。

### 顺带一条实测更正

之前说「去掉 `material-icons-extended` ⇒ ~20 MB」——**依据不足，先撤回**。实测：

```
classes.dex   19.9MB  material-icons/rounded 类 2132 个    compose 描述符 16149 个
classes2.dex  10.9MB  icons 0                              compose  7209
classes3.dex   3.3MB  icons 8   coroutines 926
```

⇒ 真正的体积是 **Compose runtime + material3 本身**，不是图标（图标只占 ~2-4 MB）。
要瘦身得**实测谁大**再动刀，不能凭感觉。（教训：**先量，再改**。）

---

## 六、从现状到这套，要动的 5 件事

| # | 事项 | 落点 |
|---|---|---|
| 1 | **hook 层改名/整编**：`GmEntry` → 明确的 hook 入口，**删掉所有 UI 痕迹**（`GmProbe` 悬浮点、探针、自绘 Dialog、`GmDiag` 缓冲） | `mod-src/src/` |
| 2 | **加 provider + 动态 receiver**（桥的两端） | 模块 `pack/axml.py` 里补 manifest 声明（我们自己的 AXML 编码器，已验证 1548 B 逐字节） |
| 3 | **配置读写收口**：UI 层 SP 写 + `rev` 自增；hook 层**懒读 + 缓存 + dirty 重读** | UI `Prefs.kt` / hook 侧新增 `GmConfig.java` |
| 4 | **入口拉起**：宿主里一个入口（如「关于/检查更新」）→ `startActivity(scheme://…)` | ✅ **已完成（3.13.0）** —— 见 `版本/3.13.0.md`：挂 `GmHomeUi.open()`，先显式 `ComponentName` 再 `fdm://open` 兜底 |
| 5 | **日志与状态回执上行**：hook 层 `log` / `applied` → UI 诊断页 | 替代 LSPosed 日志人肉搬运 |

---

## 七、这套架构顺手解决掉的旧遗留

| 旧遗留 | 现状 | 新架构下 |
|---|---|---|
| P1 **排除名单持久化** | 只在进程内存，重启即失 | 存 UI 层 SP（长命），hook 层读 ⇒ **顺手解决** |
| P2 **试验台/排除名单收进 UI** | 靠探针手势，易误触 | 天然属于 UI 层 |
| 🟢 **改完配置要免重启刷新** | 靠重启宿主 | `rev` + 广播置脏 ⇒ **顺手解决** |
| B-4 **搬 17 个二级页** | 独立 App 的活 | 就是 UI 层的全部工作 |
| 教训 106 / 170 / 84 | 自绘 UI 不可见 / DIAG 丢段 / 日志拿不到 | 由"UI 在宿主里"这个根因导致 ⇒ **整类消失** |

---

## 八、下一步（已拍板：单包 → 现在按这个顺序动）

- [x] ~~拍板：单包 or 双包~~ ⇒ **单包**（2026-09-26，主人）
- [ ] **定包名**（§4.5.6，倾向 A：沿用现役模块包名）
- [ ] **补完 `pipeline/build_full.py` 的 ④~⑦**（Kotlin/Compose 编译 → R8 → 组包 → 签名），
      目标：**用脚本重放出现在的 `FDM-UI-3.0`**（先证明"这条链可重放"，再往里加东西）
- [ ] **注入 hook 层**：`mod-src` 的 197 KB dex 升为 `classes.dex` + 补 `assets/xposed_init` + 4 个 meta-data
- [ ] **最小可跑闭环**（这是唯一的验收标准）：
      UI 上一个开关 → 存 SP → 广播 → hook 层置脏 → **宿主里那个功能真的变了**
      → `applied` 回报 UI 显示「**已生效**」（不是"已保存"）
- [ ] 跨过闭环之后，再把 17 个二级页一个个搬进去
