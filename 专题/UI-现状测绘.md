# UI 现状测绘（改版前的地基）

> 测绘：2026-09-25 · 尼得亚伯 🐲 · 基于 **2.22.110 / 2.22.111** 的 dex（123 个 `gm.*` 类）
> 用途：UI 改版动手前的"现状底账"。设计图到了之后，对着这张表决定"哪些留、哪些改、哪些退休"。

---

## 一、UI 层有多少东西

**123 个 `gm.*` 类里，UI 相关的有 32 个**：

### 1. 对话框 / 页面（17）

| 类 | 字段/方法 | 是什么 |
|---|---|---|
| `GmMenuDialog` | 2 / 3 | **主菜单页**（所有入口的总闸） |
| `GmDialog` | 11 / 12 | 灰度选项管理（**83 项**，最大的一页） |
| `GmChatDialog` | 2 / 3 | 聊天（防撤回 / 本地数据库管理） |
| `GmBeautyDialog` | 3 / 8 | 美化（助手图片 / 账号名 / 头像 / 文件快捷选项 / 招呼用语 / 修改背景） |
| `GmBubbleDialog` | 4 / 5 | AI 气泡美化（调色 / 圆角 / 图片底） |
| `GmBgDialog` | 2 / **24** | 修改背景（模式 / 位置 / 透明度 / 裁切…） |
| `GmEnvDialog` | 2 / 3 | 环境伪装 |
| `GmDeviceDialog` | 1 / 3 | 设备身份（换身份 + 重启） |
| `GmDsDialog` | 2 / 4 | 服务端灰度下发查看 |
| `GmDumpDialog` | 2 / 6 | 模块日志 & 服务器最新下发内容 |
| `GmDbDialog` | 2 / 4 | 本地数据库管理 |
| `GmHelloDialog` | 5 / 12 | 招呼用语 |
| `GmPromptDialog` | 6 / 12 | 提示语 |
| `GmSuggestDialog` | 8 / 12 | 回复建议（自定义建议） |
| `GmCallDialog` | **24 / 37** | 通话诊断（**最重的一个**） |
| `GmProbe` | 6 / 9 | 元素捕获器（`TextView` 悬浮点，可拖） |
| `GmProbeSwitch` | 0 / 2 | 捕获器开关 |

### 2. 点击 / 开关监听（7 + 8）

| 类别 | 类 |
|---|---|
| 点击 | `GmClick` · `GmAlphaClick` · `GmDeviceClick` · `GmEnvClick` · `GmRadiusClick` · `GmSwatchClick` · `GmZoomClick` |
| 开关 | `GmSwitch` · `GmBgSwitch` · `GmAvatarSwitch` · `GmUAvatarSwitch` · `GmBubbleSwitch` · `GmEnvSwitch` · `GmModelSwitch` · `GmProbeSwitch` |

> 规律：**一个页面 = 一个 Dialog 类 + 若干 Click + 若干 Switch**。
> 也就是说，"改 UI" 实际动的就是这 32 个类，不是 123 个。

---

## 二、入口链路（改版不能碰坏这条）

```
宿主 App 设置页
 └── 「检查更新」条目被偷换 → GmEntryHook（hook m5.v）
      └── GmMenuDialog（主菜单）
           ├── 灰度选项管理   ›  GmDialog
           ├── 聊天           ›  GmChatDialog
           ├── 美化           ›  GmBeautyDialog
           │     ├── AI 气泡美化 › GmBubbleDialog
           │     └── 修改背景   › GmBgDialog
           ├── 环境伪装       ›  GmEnvDialog
           ├── 调试           ›  GmDumpDialog / GmProbeSwitch
           ├── 服务端下发查看  ›  GmDsDialog
           └── [关闭]
```

- 弹窗外壳：**系统 `AlertDialog`**（2.9.23 从自绘 Dialog 换过来的）+ 统一套竖向 `ScrollView`（2.22.24 的 `GmUtil.sc`）
- **不碰宿主 Compose**：设置页那些是 R8 混淆后的 Composable，改一行动辄重排寄存器 ⇒ 一直是"偷换一个条目 + 纯 View 弹窗"

---

## 三、地基 API（新版 UI 直接对接这两个）

### `GmUtil`（17 个方法，UI 只用这几个）

| 方法 | 用途 |
|---|---|
| `dp(Context, int)` | dp → px |
| `tx / sub / bg / line(Context)` | **配色四件套**（主文字 / 次要文字 / 卡片底 / 分隔线），**全部夜色自适应** |
| `sc(Dialog, View)` | 给弹窗套竖向滚动 |
| `toast(Context, String)` | 提示 |
| `app()` | 兜底拿全局 Context |

### `GmStore`（9 个方法）

| 方法 | 用途 |
|---|---|
| `read / read2(Context, key, def)` | 读设置 |
| `write(Context, key, type, val)` | 写设置（`type` = `b`/`i`/`l`/`f`/`t`，**类型必须与宿主读法一致**） |
| `remove(Context, key)` | 删（自动处理影子键 `fuckds_pin_`） |
| `bak / restore` | 备份 / 还原原值 |
| `dumpAll(Context)` | 调试页那坨文本 |

---

## 四、新版 UI 的技术路线（已拍）

**真编译的 Java，不用手写 smali。**

- 位置：`mod-src/src/com/nidyaber/fuckdsmanger/ui/`
- 工具箱已就绪：**`GmUi`**（`column / title / desc / menu / switchRow / button / chip / divider / round / pad / attach`）—— 已真编译通过（javac → d8 → dex ✅）
- 出包走我们自己的流水线：`mod-src/package.sh`（自造 manifest + apksigner + 我们的私钥）

### ⚠️ 一个硬约束（设计时要顾及）

**沙箱里没有 aapt2**（Google 只发 x86_64 版，这台机器是 arm64）⇒ **加不了新的 layout/drawable/color 资源**。

所以 UI 只有两种画法：

| 画法 | 能不能走我们的流水线 | 说明 |
|---|---|---|
| ✅ **纯代码建 View**（现行做法，`GmUi` 走这条） | 能 | 圆角/描边用 `GradientDrawable`，颜色写常量，图标用字符或自绘 |
| ⚠️ 要真资源（矢量图 / 复杂 selector / 图片素材） | 要绕一道 | 用 MT 编译一次资源（把资源编进一个模板包），再把 `resources.arsc` + `res/` 抽出来当"素材"喂给我们的打包器 |

> **提设计要求时请顺手说一句**：有没有位图 / 矢量素材？有的话我走绕道那条；纯色块 + 圆角 + 文字的话，纯代码就够，也最稳。
> 另外：`assets/` 是**可以随便加**的（字体文件、图片都行）—— 我们的打包器直接塞得进去。

---

## 五、等设计图时要确认的几件事

1. **改哪些页**：是"17 个页面全重做"，还是先挑几个（比如主菜单 + 美化）？
2. **结构动不动**：`GmMenuDialog` 现在是一层二级菜单，要不要改成分组/分页/搜索？
3. **素材**：纯代码（推荐）还是带图（走 MT 编译资源的绕道）？
4. **深浅色**：现在靠 `GmUtil` 的四件套自适应，新版是否沿用这套语义？
5. **旧类怎么办**：新版上线后，老的 `Gm*Dialog` 是先留着（可回退）还是一起退休？
