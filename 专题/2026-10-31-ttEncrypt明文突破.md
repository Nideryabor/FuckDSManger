# ★ ttEncrypt（火山 B 栈）突破：不用逆密钥，加密前就是 gzip 明文

> 2026-10-31 凌晨 · 尼得亚伯 🐲
> 承接 `专题/2026-10-16-加密栈破解报告.md` 的「B 栈只定位没解」
> **结论：压根不需要解密 —— 加密前的明文就是 gzip JSON，运行时截获即可。**

---

## 〇、一句话

```
EncryptorUtil.a(int size, byte[] data)
   IN  = 1f 8b 08 ...   ← ★ gzip 压缩的 JSON 明文（我们要的）
   OUT = 12 39 20 20 ... ← ttEncrypt 加密结果（不用管）
```

**hook 这个函数的入参，直接 `gzip.decompress()` 就是明文。**

- 类名 `com.bytedance.applog.encryptor.EncryptorUtil` **未混淆**（JNI 按名注册）⇒ 永远不变
- 一处 hook 覆盖 **AppLog + APM + gator/抖音系 + AB 配置**（7 个调用点）

---

## 一、实测战绩（2026-10-31 02:56）

跑 `tools/frida/probes/abdec3.js`（dump base64），105 秒抓到 **8 个 blob，全部解压成功**：

| BLOB | gzip | 明文 | aid | 类型 |
|---|---|---|---|---|
| 1 | 801→1377 | AppLog | 675113 | launch |
| 2 | 788→1401 | AppLog | 240734 | apm_insight |
| 3 | 969→1983 | gator | 20005455 | launch+event |
| 4 | 918→1733 | gator | 20005455 | event |
| 5 | 1167→3133 | gator | 20005455 | launch+terminate+event |
| **6** | **1823→9777** | **gator** | 20005455 | **16 个事件** |
| 7 | 848→1490 | AppLog | 675113 | terminate |
| 8 | 827→1498 | AppLog | 240734 | terminate |

脱敏存档：`参考/数据/abdec-脱敏/blob1..8.json`

---

## 二、★ 解出来的内容长什么样

### 2.1 顶层结构

```json
{
  "magic_tag": "ss_app_log",
  "header": { ...46 个字段... },
  "time_sync": {...},
  "launch": [ ... ],
  "terminate": [ ... ],
  "event_v3": [ ... ],
  "local_time": 1793386788
}
```

### 2.2 `header` 里有什么（★ 这就是「上报了什么设备信息」的完整答案）

```
os / platform / sdk_lib / os_version / os_api
device_model       : <真机测试>（已脱敏）
device_brand       : <真机测试>（已脱敏）
device_manufacturer: <真机测试>（已脱敏）
cpu_abi            : arm64-v8a
resolution         : <真机测试>（已脱敏）
density_dpi        : <真机测试>（已脱敏）
rom / rom_version  : <真机测试>（已脱敏）
is_harmony_os      : 0
package            : com.deepseek.chat.a
app_version        : 2.7.2      version_code: 289
sig_hash           : e89b158e4bcf988ebd09eb83f5378e87   ← ★ 就是 APK 签名证书的 MD5
bd_did             : <设备ID>
install_id / clientudid / openudid / cdid   ← 四个独立设备标识
register_time / language / timezone / region / tz_name / sim_region
carrier            : <真机测试>（已脱敏）    mcc_mnc: <已脱敏>
access             : wifi
aid                : 675113 / 240734 / 20005455
sdk_version_name   : 0.2.5 / 6.17.6
```

> ★ **`sig_hash` = APK 签名 MD5** —— 这解释了为什么我们的模块**不能改宿主签名**。
> ★ **`package` = `com.deepseek.chat.a`** —— clone 包名会被原样上报（跟数美那条 418 对应）。

### 2.3 `event_v3` 的 16 个事件（BLOB 6 完整列表）

```
send_button_click       {chat_session_id, chat_context_length, is_send_button_new…}
sse_request             {stream_scenario, sse_transaction_uuid, time_elapse…}
http_request            {http_request_path:"/api/v0/chat/completion", http_client_trace_id…}
http_request            {http_request_path:"/api/v0/chat/create_pow_challenge", …}
sse_created             {chat_session_id, sse_transaction_uuid…}
http_response           {http_request_path:"/api/v0/chat/create_pow_challenge", http_trace_id…}
sse_ready               {…}
sse_first_delta         {chat_message_id: 8, sse_transaction_uuid…}
sse_msg_status_updated  ×3
sse_event               {…}
sse_finished            {…}
http_request            {http_request_path:"/api/v0/chat/history_messages", …}
http_response           {http_request_path:"/api/v0/chat/history_messages", …}
fetch_history_messages  {history_result_type:"merge", …}
```

⇒ **整条对话链路的每一步都被埋点**：点发送 → PoW 挑战 → SSE 流 → 历史拉取。
⇒ **注意 `chat_context_length: 2212`** —— 连上下文长度都上报。

### 2.4 `launch` / `terminate`

```json
launch:    {local_time_ms, tea_event_index, session_id, user_unique_id,
            launch_type, cold_launch_duration…}
terminate: {local_time_ms, stop_timestamp, duration…}
```

---

## 三、★ 跟 10-16 那份报告的对比

| 项 | 10-16 的结论 | **10-31 实测** |
|---|---|---|
| B 栈（ttEncrypt） | 「API 已定位，**密钥待逆/待 dump**」 | ✅ **不用逆！加密前就是 gzip 明文** |
| 解出方向 | 只解了 A 栈（AES + `ran` 头） | ✅ **B 栈的请求方向也能解** |
| AB 配置 | 「响应是加密二进制 ⇒ 无法读出」 | ⏳ 请求能解，**但要在启动时抓**（见 §五） |
| 响应（OUT） | 未知 | ⏳ 仍是密文（见 §五） |

**方法论教训**：
> 之前一直想「怎么解密」，正确问法是 **「加密之前长什么样」**。
> 一个 `hook` 入参就绕过了整个密码学问题。

---

## 四、★ 复现方式

### 4.1 探针（已入档）

`tools/frida/probes/abdec3.js` —— dump 入参的 base64，**不在设备上解压**（避免 frida 里写 Java IO 踩坑）。

投递：
```sh
{ echo "id=abdec3"; echo "target=com.deepseek.chat.a"; echo "timeout=105"; echo "---";
  cat tools/frida/probes/abdec3.js; } > /tmp/job.txt
B64=$(base64 -w0 /tmp/job.txt)
sh tools/出笼隧道/adb.sh shell "printf '%s' '$B64' | base64 -d > /data/local/tmp/frida_job.txt"
sleep 110
sh tools/出笼隧道/adb.sh shell 'cat /data/local/tmp/frida_out/result.txt'
```

小窝侧解压：
```python
import re, base64, gzip
blobs = re.findall(r'B64(\d+):([A-Za-z0-9+/=]+)', output)
for idx, b in blobs:
    print(gzip.decompress(base64.b64decode(b)).decode('utf-8'))
```

### 4.2 坑（都踩过了）

| 坑 | 表现 | 修法 |
|---|---|---|
| **在 frida 里用 GZIPInputStream** | `>>> 解压失败`（buffer 数组构造写错） | ★ **别在设备端解**，dump base64 回小窝解 |
| 只 dump 前 300 字节 | 解不出完整 JSON | base64 全量（限 4000 字节够） |
| `Base64.encodeToString(x, 2)` | 2 = NO_WRAP ✅ | 不要用 0（会插换行） |
| 默认 `timeout=12` | 抓不到（心跳周期 >12s） | 显式 `timeout=105` |

---

## 五、⏳ 还差的两块

### 5.1 AB 配置（`tab.volces.com/abtest_config`）没抓到

**原因**：AB 配置**只在 App 启动时拉一次**，我 attach 的是已跑了几分钟的进程。

**怎么补**：
```sh
# 1) 先投 job（挂好 hook）
# 2) 立刻 force-stop + 重启宿主  ← 但 frida 会随进程死
```
⇒ **正确做法**：用 `frida -f`（spawn）模式 —— 但**白名单网关明令只用 `-p`，永不 `-f`**
（2026-10-01 那次 frida spawn 污染 zygote 把系统搞崩了）。

**替代方案**：
- 让主人**手动重启 DeepSeek**，我在它启动后的几百毫秒内 attach（抢时间窗）
- 或者看 AB 配置有没有周期性重拉（从 HAR 看，一次会话只拉一次）

### 5.2 响应（OUT）仍是密文

`12 39 20 20 02 03` 开头的 ttEncrypt 输出。

**两条路**：
| 路 | 说明 | 难度 |
|---|---|---|
| **A** | 找响应解密入口（如果 ttEncrypt 对称，可能是同一个函数或 native 内部） | ⭐⭐ 先找 `xmc`/响应处理链 |
| **B** | 逆 `libEncryptorP.so`（83KB，小） | ⭐⭐⭐ 需 IDA；符号靠 `RegisterNatives` 动态注册 |

**但注意**：**请求方向已经够用了** —— 因为
- 我们真正想知道的是「服务端给我什么」，那在**响应**
- 但「我上报了什么」在**请求**里 —— 这个已经全解出来了 ✅

---

## 六、对我们的实际意义

| 发现 | 影响 |
|---|---|
| `sig_hash` = APK 签名 MD5 上报 | ★ 绝不能改宿主签名（否则立刻被标） |
| `package` 原样上报 clone 包名 | clone 包在这条链上**有痕迹**（跟数美 418 呼应） |
| `chat_context_length` 上报 | 上下文长度被看见（我们注入系统提示词会让它变大） |
| 4 个设备标识（bd_did/install_id/clientudid/cdid） | 改机/清数据需**四个一起动**，漏一个就串了 |
| 事件级埋点（sse_* / http_*） | 我们的注入如果引发异常请求，**在埋点里是可见的** |

> ⚠️ 但注意：**这些是火山（字节）的埋点，不是 DeepSeek 自家的风控**。
> 如实测所见，**数美引擎根本没启动**（`专题/2026-10-31-数美引擎未启动-挖到底.md`）。

---

# 附：★ AB 配置完整拿到（同夜 03:07）

> 上文书「AB 配置没抓到」。**后来换了更聪明的办法，一次拿到全量。**

## A1. 不用抢启动窗口 —— AB 配置就缓存在内存里

`htc` 类（AppLog 的 AB 配置持有者）有个方法 `a()` 直接返回**完整 JSON**：

```java
// htc 字段
a : Context      b: skc     c: cr5
d/e/f : com.bytedance.applog.store.kv.IKVStore
g/i : JSONObject   h: String   j: HashSet
k/l/n/r: int   m/o: long   p/q: boolean   s: ye9

// 方法
a() JSONObject   ← ★ AB 配置全文（8361 字符）
c() String       ← "Android"
e() String       ← "ssid_20005455"
f() boolean      ← true
g() boolean      ← false
```

**frida 一行就够**：
```js
var inst = null;
Java.choose('htc', { onMatch: o => { if (!inst) inst = o; }, onComplete: () => {} });
console.log(String(inst.a()));
```

探针：`tools/frida/probes/abfull.js`（`Java.choose` + 分块打印，避免超长）

> ⚠️ 写设备文件失败（`/data/local/tmp` EACCES，宿主的 uid 写不进去）⇒
> **用 `CHUNK<n>:` 分块打到 stdout，小窝侧拼回**。

## A2. ★ 完整 22 项（带 vid = A/B 组标识）

| 键 | vid | 值 |
|---|---|---|
| `android_apk_link` | 20189068 | `https://download.deepseek.com/app?utm_source=android_app` |
| **`authed_pow_functions`** | 20185740 | `["search","deep_think","completion","file"]` |
| `dead_link_detection` | 20192926 | `true` |
| `deep_think_button_suffix` | 20205441 | `""` |
| `ds_settings_enabled` | 20218786 | `true` |
| `enable_google_sign_in_captcha` | 20186036 | `false` |
| `hcaptcha_enabled` | 20194470 | `true` |
| `launch_clean_session_interval_seconds` | 20186799 | `21600` |
| **`max_input_files`** | 20185664 | `50` ← ★ 我们没覆盖 |
| `max_upload_file_size` | 20185380 | `104857600` (100MB) |
| `normal_history_and_file_token_limit` | 20220303 | `890880` |
| `one_tap_login_enabled` | 20196881 | `true` |
| **`pow_header_paths`** | 20189347 | 6 条：register / register_by_mobile / login_by_mobile_sms / oauth/google/login / create_sms_verification_code / create_email_verification_code |
| `query_files_time_interval` | 20186902 | `3000` |
| **`query_title_time_interval`** | 20187746 | `100000000` ← ★ 我们没覆盖（等于关闭） |
| `r1_history_and_file_token_limit` | 20220302 | `890880` |
| **`report_http_biz_error`** | 20187030 | `true` ← ★ 我们没覆盖 |
| `should_use_sm_device_id` | 20185402 | `true` |
| `show_new_chat_button_above_input` | 20211224 | `false` |
| `sm_pass_code_type` | 20185378 | `"spatial_select"` |
| **`stop_stream_wait_times`** | 20186226 | `1000` ← ★ 我们没覆盖 |
| `support_chat_file_exts` | 20217168 | 500+ 个扩展名（pdf/png/…/smali/…） |

存档：`参考/数据/abcfg-2.7.2.json` · `参考/数据/abcfg-2.7.2.tsv`

## A3. ★ 跟我们灰度表的差集

| | 数量 |
|---|---|
| AB 下发总数 | **22** |
| 我们灰度表**已覆盖** | **18** ✅ |
| 我们**没覆盖** | **4** ← `max_input_files` / `query_title_time_interval` / `report_http_biz_error` / `stop_stream_wait_times` |

⇒ **这 4 个应该补进 `GrayTable.kt`**（都是普通 int/bool，没有类型坑）。

## A4. 关键情报

| 发现 | 意义 |
|---|---|
| **`authed_pow_functions = [search, deep_think, completion, file]`** | ★ 服务端**只对这 4 类请求**要 PoW |
| **`pow_header_paths` 6 条全是登录/注册** | ★ **登录也走 PoW** |
| `should_use_sm_device_id = true` | 跟数美设备 ID 关联（我们 3.71.19 的 device_id 派生要对齐） |
| `query_title_time_interval = 1e8` | 会话标题查询被**服务端闭掉**了（≈ 永不刷新） |
| `hcaptcha_enabled = true` 但 `enable_google_sign_in_captcha = false` | 登录验证码走 hCaptcha，Google 登录不走 |

## A5. 方法论

**之前想「抢启动窗口 hook 请求」—— 那是错的方向。**
正解是：**配置拉下来之后一定在内存里有一份**，直接 `Java.choose` 找持有者读出来。

| 想法 | 结果 |
|---|---|
| 抢启动窗口 attach | ❌ 网关 `resolve_pid` 要遍历 /proc **6.97 秒**，永远抢不到 |
| 等周期性重拉 | ⚠️ 有 `abtest_fetch_interval`，但实测 60s 内没重拉 |
| **`Java.choose('htc')` 读内存** | ✅ **一次成功，0 成本** |
