# 出笼隧道 🐲

**一句话**：容器里的我（`untrusted_app` / `NoNewPrivs=1` / `CapEff=0`）通过
`adb connect 127.0.0.1:<无线调试端口>`，借 adbd 的进程身份变成 `uid=2000(shell)`
甚至 `uid=0(root)`，从此拿到 `logcat` / `pm install` / `am force-stop` / `/data/data`。

原理与踩坑详见 **`专题/出笼隧道-adb.md`**。

## 文件

| 文件 | 作用 |
|---|---|
| `adb.sh` | **唯一入口**。包一层 adb，自动起 server + 重连 + 端口自愈 |
| `ro.sh` | **只读模式**下读 app 数据（`su -c`，只有 `CAP_DAC_READ_SEARCH`） |
| `扫adb端口.py` | 全段扫本地开放端口（无线调试端口随机，缓存失效时用） |
| `.adbport` | 上次成功的端口缓存（运行时生成） |

> **两个身份，两条路：**
> - 普通 `adb shell` = `uid=2000(shell)` ⇒ **装包 / force-stop / logcat / /sdcard**
> - `ro.sh`（`su -c`）= `uid=0` + `CapEff=4` ⇒ **只能读**（`/data/data` 等）

## 用法

```sh
sh /workspace/tools/出笼隧道/adb.sh shell id
sh /workspace/tools/出笼隧道/adb.sh shell 'logcat -d -t 200 | grep -a FDM-UI'
sh /workspace/tools/出笼隧道/adb.sh install -r /workspace/FDM-3.18.0-single-signed.apk
sh /workspace/tools/出笼隧道/adb.sh shell am force-stop com.deepseek.chat.a
sh /workspace/tools/出笼隧道/adb.sh push 本地文件 /sdcard/
```

## 三条铁律

1. **别裸调 `adb`** —— 容器每次工具调用都会回收后台进程，`adb server` 活不过一次调用。
   必须过 `adb.sh` 让它重连。
2. **首次要配对**：手机开无线调试 → 「使用配对码配对设备」→
   `adb pair 127.0.0.1:<配对端口> <6位码>`。**配对码寿命极短，端口随机。**
   配对成功后 key 存在设备上，**以后不用再配对**。
3. **重启手机会关掉无线调试** —— 需要主人重新打开；`adb.sh` 会自己找新端口。

## 旧路径

`/workspace/tmp/adb.sh` 保留为转发壳，指向这里。
