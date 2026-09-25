# Material Symbols（图标库）· 2026-09-25 抓取

主人提醒"要关 VPN 了"，趁网络放开时抓下来的。

| 文件 | 来源 | 用途 |
|---|---|---|
| `MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf` (15 MB) | GitHub `google/material-design-icons/variablefont` | 官方**变量字体**（连字式图标），Android 直接可用 |
| `MaterialSymbolsOutlined[...].ttf` (11 MB) | 同上 | 同上，Outlined 风格 |
| **`fdm-symbols.ttf`** | 上面那个切出来的**子集** | 只留我们用的 ~50 个图标 + ASCII ⇒ 进 assets 很小 |
| `svg-rounded/` (7858 个 SVG) | npm `@material-symbols/svg-400` (npmmirror) | **精确路径** ⇒ 可生成 VectorDrawable XML / Compose ImageVector |

## 两种用法

1. **连字字体**（跟 m3e-canvas 网页那套一样）：`TextView`/Compose `Text` 里写 `edit_note`，字体自己换成图标。
   ⇒ 需要 `--layout-features='*'` 保留 GSUB 连字表（切子集时必须带，否则连字失效）。
2. **矢量图**：把 `svg-rounded/*.svg` 转成 `res/drawable/*.xml`（aapt2 能编）或 Compose `ImageVector`。
   ⇒ 不依赖字体，渲染最稳。

⚠️ 切子集踩过的坑：字形名跟图标名不一致的（如 `copy` → 实际是 `content_copy`）会让
fontTools 抛 `MissingGlyphsSubsettingError` ⇒ **切之前先把图标名与字形名取交集**。
