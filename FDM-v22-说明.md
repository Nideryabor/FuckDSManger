# FDM v22 · TrollFools 注入版

> 打包：2026-10-17 深夜
> 宿主：DeepSeek Chat **2.6.2**（`com.deepseek.chat`）
> 设备验证：iPhone 7P (iPhone9,2) · iOS 15.8.4 · Dopamine rootless

---

## 一、这个包和 hot-reload 版的区别

| 项 | hot-reload 版（v21） | **本包（TrollFools 版）** |
|---|---|---|
| 文件 | `FDMProbe.dylib` | **`FDM.dylib`** |
| `install_name` | `/usr/lib/FDMProbe.dylib`（绝对路径） | **`@executable_path/Frameworks/FDM.dylib`** |
| 给谁用 | ElleKit / `dlopen()` 从 `/var/jb/` 加载 | **TrollFools 注入到 App bundle** |
| 放在哪 | `/var/jb/usr/lib/TweakInject/` | **`DeepSeek Chat.app/Frameworks/`** |
| 代码内容 | 完全一样 | 完全一样（含 v21 全部功能） |

**唯一区别就是 `install_name`。** 这个字段决定 dyld 按什么路径找文件：

- 绝对路径（旧）→ 放进 App bundle 后**找不到** ⇒ 启动即崩
- `@executable_path/...`（新）→ 相对 App 主二进制定位，注入器放哪都能找对

---

## 二、文件信息

| 项 | 值 |
|---|---|
| 文件名 | `FDM.dylib` |
| 大小 | **815,920** 字节 |
| MD5 | `efac33449f580aa184c9ac26d741b2fa` |
| 架构 | arm64（thin） |
| 格式 | Mach-O 64-bit DYLIB |
| 最低系统 | iOS 15.0 |
| 导出符号 | 124 个 |

### 依赖（全部系统自带，无第三方）

```
/usr/lib/libobjc.A.dylib
/usr/lib/libSystem.B.dylib
Foundation · CoreFoundation · UIKit · QuartzCore
PhotosUI · CoreText · CoreGraphics
```

### 已确认

- `LC_ID_DYLIB` = `@executable_path/Frameworks/FDM.dylib`
- `__mod_init_func` 段存在 ⇒ 构造函数会被 dyld 执行
- `_fdm_init` 符号存在（`__attribute__((constructor))`）
- 无未定义符号（`NOUNDEFS`）

---

## 三、TrollFools 注入步骤

1. 把 `FDM.dylib` 传到手机上（AirDrop / Filza / 任意方式）
2. 打开 **TrollFools**
3. 选择 **DeepSeek Chat**
4. 点「注入」→ 选 `FDM.dylib`
5. TrollFools 会：
   - 把 dylib 复制进 `DeepSeek Chat.app/Frameworks/`
   - 给主二进制加一条 `LC_LOAD_DYLIB`
   - 需要签名时自己签
6. 启动 App

### 如果 TrollFools 放的位置不是 `Frameworks/`

正常情况下就是 `Frameworks/`。若某个版本放在 App **根目录**，
需要改 install_name：

```bash
install_name_tool -id @executable_path/FDM.dylib \
  "/var/containers/Bundle/Application/<UUID>/DeepSeek Chat.app/FDM.dylib"
```

或者告诉尼尼 TrollFools 的实际行为，重打一个包。

### 和 hot-reload 版共存

**不建议两份同时存在**，但**同时存在也不会出问题** —— v22 加了极早期防重：

```objc
static volatile int g_fdm_ctor_claimed = 0;   // 纯 C 原子锁

__attribute__((constructor))
static void fdm_init(void) {
    if (__sync_lock_test_and_set(&g_fdm_ctor_claimed, 1)) return;  // 第二份直接退
    ...
}
```

谁先加载谁干活，后来那份构造函数立刻返回、**不做任何初始化**。
比原来那个 3.5 秒后才生效的 `FDMInitGuard` 类锁早得多。

---

## 四、装完怎么确认活了

### 1. 看日志（最直接）

```
/var/mobile/Containers/Data/Application/<UUID>/Documents/fdm.log
```

启动 10 秒内应出现：

```
[hook] [strip] 显示层抹除=开（数据库层已弃用）
[ui]   [sug] ↻ 自动重铺巡检已启动（v4.1 · 0.35s）
[hook] [strip] 安装完成：6 处（仅显示层，数据库层已弃用）
[net]  [user] 账号名/头像改写就绪
[ui]   [avatar] ★ 已 hook …FooterView layoutSubviews（自有实现=0）
[hook] [init] 6s: strip 装完
```

**一条都没有 = 没加载成功**（先查 TrollFools 是否真注入了、文件在不在 Frameworks 里）。

### 2. 看界面

| 位置 | 应该看到 |
|---|---|
| 宿主「设置」页**最底部** | 多一行「🦖 FDM 模块设置」 |
| 点它 | 进 FDM 设置树（功能 / 聊天 / 美化 / 调试…） |
| AI 回复里的 `<Suggestion>` | 蓝色圆角胶囊，点了自动发送 |
| 抽屉左下角 | 自定义头像（若配了 `fdm-avatar.json`） |

---

## 五、配置（零配置也能跑）

全部在 App 的 `Documents/`：

```
fdm-inject.json     系统提示词注入
fdm-richtext.json   富文本模板池 + 色板
fdm-bg.json         聊天背景
fdm-avatar.json     头像（本地文件名 或 http(s) URL）
fdm-ui.json         入口位置
fdm-composer.json   模块自己发消息
fdm-debug.json      调试项
fdm-avatar.png      头像图
fdm-bg.jpg          背景图
```

**热生效（不用重启）：**

```bash
echo D > Documents/fdm-log.txt       # 日志级别 E/W/I/D/T，2 秒生效
echo 1 > Documents/fdm-sugdiag.txt   # 建议按钮诊断
```

常用示例：

```json
// fdm-avatar.json
{ "enabled": true, "url": "", "file": "fdm-avatar.png" }

// fdm-ui.json
{ "entry_list": true, "entry_button": false, "float_button": false }

// fdm-bg.json
{ "enabled": true, "chat_enabled": true, "list_enabled": true,
  "settings_enabled": true, "mode": "image", "file": "fdm-bg.jpg",
  "dim": 30, "alpha": 100, "bg_clear_all": false }
```

---

## 六、功能清单（v22 = v21 全部）

| 功能 | 状态 |
|---|---|
| 中文系统提示词注入 + 显示层抹除 | ✅ |
| AI 气泡富文本（模板 / 裸 HTML 子集 / 9 色板） | ✅ |
| `<Suggestion>` → 圆角胶囊 → 点击自动发送 | ✅ |
| 历史消息补扫 | ✅ |
| 模块自己发消息 | ✅ |
| 聊天背景（三页同源，无分界线） | ✅ |
| 模块入口（宿主设置页底部一行） | ✅ |
| 账号头像（本地图 / URL） | ✅ |
| 日志级别热切换 | ✅ |
| 原生设置界面（17 页 / 140 项） | ✅ |

### 已知不支持

| 项 | 原因 |
|---|---|
| 账号名改显示 | 宿主有内存缓存，UI 不认 |
| 气泡透明 | 与列表可读根本冲突 |
| 头像设置热生效 | 改 json 需重启 App |
| 防撤回 / 设备伪装 | 按要求不做 |

---

## 七、卸载

```
TrollFools → DeepSeek Chat → 移除 FDM.dylib 的注入
```

TrollFools 会把 App bundle 恢复原状。

配置和日志随 App 卸载消失；想手动清：

```bash
rm -f .../Documents/fdm-*.json .../Documents/fdm.log
```

---

## 八、排查

| 症状 | 先查 |
|---|---|
| App 启动直接闪退 | ① dylib 在不在 `Frameworks/` ② install_name 对不对 ③ 有没有签名 |
| 起来了但完全没功能 | 日志有没有新内容 → 没有就是**构造函数没跑**（dylib 未加载） |
| 日志正常但某项不生效 | 对应 json 的 `enabled`、改完重启 App |
| 两份都装了 | 正常，防重保证只跑一份 |
| 建议胶囊位置偏 | `echo 1 > fdm-sugdiag.txt` 看实际矩形 |

---

## 九、版本

```
v22 · 2026-10-17
  基于 v21 全部功能
  + install_name → @executable_path/Frameworks/FDM.dylib（TrollFools 可注入）
  + 极早期防重（纯 C 原子锁，防双份模块重复初始化）
```

开发日记 32 篇在仓库 `docs/`，索引 `docs/00-索引.md`。

🐲
