# 第三方声明 · Third-Party Notices

> 本文件说明「**哪些东西不是本项目作者的、它们的授权是什么、本项目的许可证管到哪儿**」。
>
> 一句话：**`LICENSE`（PolyForm Noncommercial 1.0.0）只覆盖作者自己写的东西**；
> 第三方资源、逆向所得数据、宿主 App 的商标与内容**都不在其中**，各归其主。

---

## 〇、本仓的授权范围

| 内容 | 谁的权利 | 是否被 `LICENSE` 覆盖 |
|---|---|---|
| `mod-src/` `fdm-app/` `pipeline/` `tools/`（脚本）里的**作者自写代码** | 尼得亚伯 (Nideryabor) & dxyabab | ✅ 覆盖 |
| `版本/` `专题/` `参考/` `大纲.md` 等**作者自写文档** | 同上 | ✅ 覆盖（文档同样按 PolyForm-NC 提供） |
| `版本存档/`（历代 dex / smali — **本项目自己的历史构建**） | 同上 | ✅ 覆盖 |
| **字体文件** `tools/symbols/*.ttf` | Google（Apache-2.0） | ❌ **不覆盖**，见第一节 |
| **底座模板衍生的脚手架**（早期） | varuns2002 | ❌ **不覆盖**，见第二节 |
| **宿主 App 的逆向数据**（键值清单 / 锚点总表 / 发送链路…） | 宿主 App 所有者 | ❌ **不覆盖**，见第三节 |
| 宿主 App 的**名称 / 商标 / 图标 / 内容** | 宿主 App 所有者 | ❌ **不覆盖**，见第三节 |
| `backups/` `tmp/` 中的**历史快照** | 混合；含上列各类 | ⚠️ 按各自归属判断 |

> `Required Notice: Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab`
> 分发本项目（或其副本、修改版）时，请一并保留 `LICENSE` 与本文件。

---

## 一、字体：Material Symbols（Apache License 2.0）

本仓包含（用于生成模块 UI 的图标子集）：

| 文件 | 来源 |
|---|---|
| `tools/symbols/MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf` | Google · Material Symbols |
| `tools/symbols/MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf` | Google · Material Symbols |
| `tools/symbols/fdm-symbols.ttf` | **由上述字体子集化/派生**而来 |

- **授权**：Apache License 2.0（<https://www.apache.org/licenses/LICENSE-2.0>）
- Apache-2.0 允许再分发，条件是**保留版权声明与许可证副本**。
  本仓并未内嵌 Apache-2.0 全文，若你需要完整条款请从上面链接获取；
  **若你是从本仓复制这些字体的人，请自行补齐该声明与许可证副本。**
- 商标：`Material Symbols` / `Material Design` 是 Google 的商标，本项目**与 Google 无任何关联**，
  也不主张任何背书关系。

---

## 二、底座模板：`Disable-FLAG_SECURE`（作者 varuns2002）

早期的模块外壳来自第三方 Xposed 模板：

- 模板：`Disable-FLAG_SECURE_2.0.0.apk`
- 包名痕迹：`com.varuns2002.disable_flag_secure`
- 用途：**仅作为最初的脚手架**（提供入口类骨架与打包形态）

**演变说明（重要）**：

- 自 **2.22.111** 起，模块入口类已换成**自编自写的 `GmEntry` / `FdmEntry`**，
  manifest、打包流程也改为**自造**（`mod-src/pack/` + `pipeline/`）。
- 自 **2.22.112** 起，包名已全部迁到 `com.nidyaber.fuckdsmanger.*`，
  不再使用模板的 `com.varuns2002.*`。
- 历史上的中间产物（`mod-src/work/sm_orig/`、`版本存档/` 里的旧 dex）仍留有该包名痕迹，
  它们属于**历史归档**，不作为当代码基。

**态度**：模板作者的权利归模板作者。本项目**不主张**对其模板的任何权利，
`LICENSE` **不覆盖**该模板衍生的部分。**若原作者有异议，请联系我，我会撤下相关残留**（致谢见 README）。

---

## 三、宿主 App：逆向数据 / 商标 / 内容

本仓大量文档是对某个**第三方 AI 聊天 App**（下称"宿主 App"）的逆向分析记录，例如：

- `专题/灰度/03-键值清单.md`、`参考/数据/*`（灰度键名、类型、下发 dump）
- `参考/数据/锚点总表-*.tsv`、`*重定位映射*`（混淆类/方法锚点）
- `专题/发送链路-gh2.S-2026-10-05.md`、`专题/AI气泡渲染任意HTML.md` 等（调用链与协议记录）
- smali 片段中出现的宿主类名 / 方法名 / 资源 id

**声明**：

1. 这些**逆向所得的事实性记录**，其原始权利属于**宿主 App 的所有者**；
   本项目**不主张**任何权利，`LICENSE` **不覆盖**它们。
2. 本仓**不包含**宿主 App 的原始 APK / 反编译全量产物
   （`*.apk` 已在 `.gitignore`；`tmp/` 下的反编译 dump 亦不入库）。
3. 宿主 App 的**名称、商标、图标、文案、界面**等，均归其所有者；
   本项目为**非官方第三方工具**，与宿主 App 官方**无任何关联、未获其授权或背书**。
4. 文中出现的所有商标仅用于**指称与互操作说明**（nominative / descriptive use）。

---

## 四、构建期依赖（不随本仓分发）

以下组件仅用于**编译/构建**，不在本仓内分发（多数已在 `.gitignore` 中）：

| 组件 | 授权 | 说明 |
|---|---|---|
| AndroidX · Material Components | Apache-2.0 | `fdm-app/` 的 UI 依赖（`libs*/` 不入库） |
| Kotlin / kotlinx-coroutines | Apache-2.0 | `kotlinc` 与 stdlib（`tools/jvm/` 不入库） |
| R8 / D8 | BSD-3-Clause (Google) | `tools/jvm/lib/r8.jar`（不入库） |
| smali / baksmali | BSD-3-Clause | dex ⇄ smali 工具 |
| `android.jar`（桩） | Android SDK 条款 | 仅编译期 classpath |
| frida-server 二进制 | wxWindows Library Licence | `tools/frida/frida-server-*`（不入库） |

> 若你**重新分发**本项目的构建产物（APK），请自行确认其中所含的第三方库许可
> （AndroidX/Material/Kotlin 均为 Apache-2.0，需保留其声明）。

---

## 五、使用边界（非许可条款，但请一并遵守）

> ⚠️ 以下不是 `LICENSE` 的附加条款（`LICENSE` 以 PolyForm 官方全文为准），
> 而是本项目作者对**使用方式**的期望与提醒。

1. **仅供学习交流 / 研究**，**禁止商业使用**（与 `LICENSE` 一致）。
2. **不得用于任何违法用途**，不得用于侵犯他人合法权益（隐私、账号、财产等）。
3. **使用风险完全自负**：本模块会修改宿主 App 的运行行为，可能导致
   **功能异常、数据丢失、账号被风控/封禁、设备不稳定**等后果，作者不承担任何责任。
4. 本模块可能**不符合宿主 App 的服务条款**，请自行评估并承担后果。
5. 请勿以作者名义发布修改版，也**不要暗示作者为你的版本背书**（`LICENSE` 未授予商标权）。

---

*建立于 2026-10-06。若你是上述任一第三方权利的所有者并认为本仓内容不当，
请联系作者，我会据实调整或撤下。*
