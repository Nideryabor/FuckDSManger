# 日志网关 🐲（2026-10-30 · 可用）

> **一句话**：设备上跑一个 su 起的网关，小窝发 HTTP 请求，网关把 root-only 的
> 日志文件打包成 tar.gz 流回来。**只抓文件，不看 logcat 缓冲区**（256KB，很快滚掉）。

```
小窝（proot）                              设备（root）
/workspace/tools/logs/devlog.sh  ──HTTP──►  127.0.0.1:8756  devlog_gw.py
        ▲                                        │
        └────────── tar.gz 流（不落中间文件）◄────┘
                     ├ lspd/   /data/adb/lspd/log/{verbose*,modules*}
                     ├ crash/  /data/system/dropbox/*crash* *anr*
                     ├ anr/    /data/anr/*
                     ├ tomb/   /data/tombstones/*
                     └ app/    /data/data/com.deepseek.chat.a/**  日志类文件
```

小窝与 Android **共享网络命名空间**，直接 `curl 127.0.0.1:8756`，
不需要 `adb reverse`（用了反而自环）。

---

## 一、日常怎么用

```sh
cd /workspace/tools/logs

sh devlog.sh ping          # 自检：root？每组多少文件、最新是哪个
sh devlog.sh sync          # 全套拉回 → /workspace/tmp/devlogs/<时间戳>/
sh devlog.sh lspd          # 只要 LSPosed verbose* / modules*
sh devlog.sh crash         # 只要崩溃 + ANR + tombstone
sh devlog.sh run           # 只要 app 自己写的运行日志
sh devlog.sh ls /data/adb/lspd/log
sh devlog.sh tail /data/system/dropbox/xxx.txt 8000
sh devlog.sh grep 关键词    # 在最近落地目录里搜
sh devlog.sh open          # 看落地目录（latest 是软链）
sh devlog.sh stop
```

**增量**：`sync` 记住上次 `server_time`，只拉更新的。想全量：
`rm /workspace/tmp/devlogs/.state`

---

## 二、起网关（每次开机 · Termux 里一次）

```sh
su -c 'sh /data/local/tmp/devlog_start.sh --daemon'
```

`devlog_start.sh` 自己找 Termux 的 python3（`su` 下 PATH 不全也不怕）。

开机自启：装 **Termux:Boot**，把这行丢进 `~/.termux/boot/devlog.sh`。

---

## 三、为什么必须 root

```
$ adb shell ls -ld /data/adb /data/system/dropbox
ls: /data/adb: Permission denied
ls: /data/system/dropbox: Permission denied
```

`/data/adb`、`/data/system/dropbox`、`/data/anr`、`/data/tombstones` 全是
系统私有目录，uid=2000(shell) 连 `stat` 都不行。

所以 **`devlog.sh` 里一处提权动作都没有**，只 `curl` + `adb push`。
root 由你在 Termux 里 `su` 那一次提供，网关进程带着 root 常驻，
之后无限次请求都走它。

---

## 四、抓什么 / 不抓什么

| 组 | 根 | 规则 |
|---|---|---|
| `lspd` | `/data/adb/lspd/log` | 文件名以 `verbose` / `modules` 开头 |
| `crash` | `/data/system/dropbox` | 文件名含 `crash` / `anr`，只扫一层 |
| `anr` | `/data/anr` | 全部，只扫一层 |
| `tomb` | `/data/tombstones` | 全部，只扫一层 |
| `app` | `/data/data/com.deepseek.chat.a` | 名字含 `log`/`crash`/`anr`/`trace`，深度 5 |

### 明确不收（安全 / 体积）

```python
LOG_EXT  白名单：.log .vlog .txt .trace .dmp .stacktrace .out .err .anr
SKIP_EXT 黑名单：.json .xml .db .mmkv .cache .guard .bin .dat .zip .bak .so ...
SKIP_NAME_PAT  ：login token credential secret password cookie auth session account
MIN_SIZE       ：64 B 以下（标记文件）
```

> **这条是血的教训**：第一版规则只看文件名含 `log`，结果把
> `files/FDMmusic/login.json` 抓了回来 —— 里面是网易云音乐的
> 770 字符登录 token。已删，规则已固化成上面三条。

---

## 五、安全设计（三层）

### 1. 包名白名单 —— 请求参数不能扩展

```python
ALLOWED_APPS = ("com.deepseek.chat.a",)     # 只能启动时用 DEVLOG_ALLOWED_APPS 配置
app = check_app(g("app", "")) or APP        # 请求传别的包 → 忽略，回退默认
```

### 2. 路径沙箱 —— `/ls` `/file` 只能碰白名单目录树

```python
def safe_path(p):
    rp = os.path.realpath(p)      # 吃掉 ../ 和符号链接逃逸
    for root in allowed_roots():
        if rp == rr or rp.startswith(rr + os.sep):
            return rp
    return None                   # 其余 403
```

允许的根只有：`lspd` / `dropbox` / `anr` / `tombstones` + 白名单包的
`/data/data/<pkg>`、`/data/user_de/0/<pkg>`

### 3. 随机 token —— 代码里没有硬编码口令

```
启动时 secrets.token_hex(16) → /data/local/tmp/devlog_token
chown shell:shell + chmod 0640     ← 小窝经 adb shell 能读，别的 app 读不到
客户端自动读取并缓存到 /workspace/tmp/devlogs/.token (0600)
```

### 曾经的三个洞（都已堵）

| 洞 | 症状 |
|---|---|
| `?app=` 可覆盖 | 传 `com.tencent.mm` 真去扫微信，113 个文件 —— 等于开了个 root 任意文件读取服务 |
| `/ls` `/file` 无沙箱 | `/data/misc/keystore`、`/data/system/users` 都能读 |
| token 硬编码 | `nidyaber-devlog`，代码一泄露口令就穿了 |

**要改这些规则，改 `devlog_gw.py`，`push` 后重启网关。**

---

## 六、落地结构

```
/workspace/tmp/devlogs/<标签>/
  MANIFEST.json       打包时间 / root / 文件清单 / 被跳过的路径及原因
  lspd/verbose_*.log
  lspd/modules_*.log
  crash/data_app_crash@*.txt
  anr/anr_*.txt
  tomb/tombstone_*
  app/files/.../xxx.log
```

`latest` 软链指向最近一次。

---

## 七、接口

| 路径 | 作用 |
|---|---|
| `/ping` | 自检 JSON（root / allowed_apps / allowed_roots / 每组 count·bytes·newest） |
| `/ls?path=` | 列目录（受沙箱限制） |
| `/file?path=&tail=N` | 读文件 / 读尾（受沙箱限制） |
| `/bundle?only=lspd,crash&since=<mtime>&app=` | tar.gz 流 |
| `/quit` | 退出 |

全部需要 `?token=xxx` 或 `X-Devlog-Token` 头（从 `/data/local/tmp/devlog_token` 取）。

---

## 八、环境变量

**小窝侧**：`DEVLOG_OUT` `DEVLOG_APP` `DEVLOG_HOST` `DEVLOG_PORT` `DEVLOG_TOKEN` `DEVLOG_TOKEN_FILE`

**网关侧**：
```
DEVLOG_PORT / DEVLOG_BIND / DEVLOG_APP
DEVLOG_ALLOWED_APPS          包名白名单（逗号分隔，默认 = DEVLOG_APP）
DEVLOG_TOKEN / DEVLOG_TOKEN_FILE
DEVLOG_LSPD / DEVLOG_LSPD_PREFIX
DEVLOG_DROPBOX / DEVLOG_DROPBOX_MATCH
DEVLOG_ANR / DEVLOG_TOMB / DEVLOG_APPDIR
DEVLOG_MAX_FILE(16M) / DEVLOG_MAX_TOTAL(128M) / DEVLOG_MIN_SIZE(64)
```

---

## 九、本地测试（不用设备）

```sh
mkdir -p /tmp/gwt/{lspd,dropbox,anr,tomb,app/files/logs}
echo x > /tmp/gwt/lspd/verbose_1.log
echo x > /tmp/gwt/dropbox/data_app_crash@a.txt

DEVLOG_FORCE=1 DEVLOG_PORT=8766 DEVLOG_TOKEN=tk \
DEVLOG_LSPD=/tmp/gwt/lspd DEVLOG_DROPBOX=/tmp/gwt/dropbox \
DEVLOG_ANR=/tmp/gwt/anr DEVLOG_TOMB=/tmp/gwt/tomb \
DEVLOG_APPDIR=/tmp/gwt/app DEVLOG_TOKEN_FILE=/tmp/gwt/tok \
python3 devlog_gw.py --port=8766 &

DEVLOG_PORT=8766 DEVLOG_TOKEN=tk sh devlog.sh ping
```

`DEVLOG_FORCE=1` 只为绕过 root 检查（假数据测试用）。

---

## 十、踩坑

1. **别用 logcat 缓冲区当日志源** —— 256KB，App 没跑十几分钟就滚没了。
   要留证据必须抓文件（`dropbox` 里的 `data_app_crash@*.txt` 就是崩溃的真实落点）。
2. **`adb` 会吃 `while read` 的 stdin** —— `ADB() { ... </dev/null; }` 修掉。
3. **命令串里别套单引号** —— 同 `ro.sh` 的教训。
4. **`dropbox` / `anr` / `tombstones` 经常是空的** —— 没崩过就没有文件，正常。
5. `su` 在 shell uid 下不可见（SUSFS 隐藏），所以 `ro.sh` / `g.sh` / `grep_lspd.sh`
   目前都是哑炮；本工具不依赖它们。

---

## 十一、文件清单

```
小窝（本目录）
  devlog.sh          客户端（push/ping/sync/lspd/crash/run/ls/tail/grep/open/stop）
  devlog_gw.py       网关（设备端跑，必须 root）
  README.md          本文件

设备
  /data/local/tmp/devlog_gw.py        网关本体
  /data/local/tmp/devlog_start.sh     启动壳（自找 python3）
  /data/local/tmp/devlog_token        随机 token（运行时生成，0640 shell:shell）

输出
  /workspace/tmp/devlogs/             落地目录（latest 软链）
```

部署位置已经就绪，改代码后只需 `sh devlog.sh push` + 重启网关。
