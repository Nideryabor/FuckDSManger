# adb 真机联调小工具（2026-09-30 · 3.29.0~3.30.0 液态玻璃那一轮攒的）🐲

> 教训：**别在沙箱里自嗨**。装上去、抓日志、看屏幕，才知道真因。

| 脚本 | 干什么 |
|---|---|
| `deploy.sh <apk>` | 装模块 + 重启宿主 |
| `cycle.sh` | 先把模块 UI 拉起来（配置源头），再重启宿主 ⇒ 触发配置推送 |
| `startui.sh` | 拉起模块 UI |
| `g.sh <正则> [行数]` | **在 LSPosed 模块日志里搜**（注意用 `-E`！见下） |
| `grep_lspd.sh <词>` | 同上（不带 -E 的版本，坑过一次） |
| `uidump.sh` | dump 当前界面树（拿坐标/文字） |
| `hshot2.sh <图>` | 设备端一条命令连拍（避免 PC 端竞态） |

## 三个必踩的坑

1. **LSPosed 的模块日志不在 logcat 里**，在
   `/data/adb/lspd/log/modules_*.log`（**分段轮转**，`----part N start----`）。
   要用 `su -c 'grep -ah … modules_*.log'` 跨段搜。
2. **`grep` 不加 `-E` 时 `|` 是字面量** —— 我被这个坑掉整整一轮。
3. **adb 的 daemon 会自己死**（每条命令都 "daemon not running"）⇒
   脚本里一律 `kill-server; start-server` + 重试到 `get-state == device`。

## 直接用 CMD 广播改宿主配置（不用碰手）

```sh
SEP=$(printf '\037')
am broadcast -a com.little_femaleboy.fdm.CMD \
  --es cmd cfg_put --es arg "fuckds_glass_scope${SEP}i${SEP}1"
#                         ↑键              ↑类型   ↑值
```

类型：`b` / `i` / `l` / `f` / `s`（**跟 GmStore.read2 的第三参同一套**）。

⚠️ 改完看日志回执：`【GmGlass】配置刷新 glass{… }` —— 值没变说明键名或类型错了。
⚠️ UI 的 `shared_prefs/fdm_ui.xml` 和宿主 MMKV 是**两份**：改 UI 的不等于改宿主的。
