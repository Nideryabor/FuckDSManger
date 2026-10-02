# 专题 · 宿主 AI 语音通话（官方版）—— 域测绘 + hook 影响审计

> 建立：2026-10-02 🐲 尼得亚伯
> 基线：宿主 **2.6.1（vc279）** · 模块 **3.42.36（vc580）**
> 触发：主人告知「宿主又有 avb/AB 测试了，这次是我们原本做不出来的语音通话」
> 实测：**主人手机上看不到任何通话入口** ⇒ 与本文结论一致（闸门在服务端）

---

## 〇、三句话结论

1. **功能做完了，在包里躺着。** 2.6.1 里有一整套官方 AI 语音通话：真·RTC（腾讯 TRTC）+ 完整 UI + 前台服务 + 评价/设置/字幕。**不是半成品**。
2. **闸门在服务端。** 宿主 79 条灰度（settings 字典）+ 全部 `key_*` MMKV 键里，**一条通话开关都没有**。能不能用 = 服务端给不给你下发 `CallConfig`。这就是「AB 测试」的实体。
3. **我们的 hook 零影响。** 逐条查过闸门：通话页**不抬 `sDepth`**、不命中身份比对/资源 id/实例表判据 ⇒ 全部安全。**本版不需要为通话改任何 hook。**

---

## 一、通话域测绘（全部是挖出来的真名字）

### 1.1 引擎层：腾讯 TRTC（不是自研、不是拼接）

| 项 | 位置 |
|---|---|
| RTC 入口 | `com.tencent.trtc.TRTCCloud` / `TRTCCloudImpl` / `TRTCCloudDef` |
| native 桥 | `com.tencent.liteav.trtc.TrtcCloudJni`（+ `$EnterRoomParams` / `$AudioFrame` / `$LocalStatistics` …） |
| 音频 | `com.tencent.liteav.audio2.LiteavAudioRecord3` / `LiteavAudioTrack3` |
| 保活 | `com.deepseek.feature.call.foreground.CallForegroundService`（**清单里保留原包名**，前台服务） |

> ⚠️ 这条值得记牢：宿主通话是**双工 RTC 房间**，AI 状态用 **RTC 自定义消息/SEI** 同步。
> 我们当年的 wip 是 **ASR + TTS 自己拼**（PTT 按住说话 → 转文字 → 发消息 → 朗读）——**量级不同，做不出来不冤**。

### 1.2 数据模型（`com.deepseek.feature.call.network.model.*`）

| 模型 | 用途 | 混淆类 |
|---|---|---|
| `CallConfig` | ⭐ 通话配置（音色/语言） | `Liy0;`（serial）+ `Loy0;`（domain） |
| `CallAgent` | AI 坐席信息 | `Lgx0;` |
| `CallRoom` | 房间 | `Ls51;` |
| `TrtcCallStartRequest` / `TrtcCallStartBizData` / `TrtcCallConnection` | 起通话 | `Lrua;` / `Loua;` / `Lyta;` |
| `CallUpdateRequest` / `Response` / `ErrorData` | 通话中改配置（音色 / `search_enabled`） | `Ls81;` / `Lv81;` / `Lo81;` |
| `CallStopRequest` / `Response` | 挂断 | `Lo71;` / `Lr71;` |
| `CallRatingRequest` / `Response` | 通话评价 | `Lg51;` / `Lj51;` |
| `CallMutedData` / `CallStartErrorData` / `CallStartVoice` | 杂项 | `Lo21;` / `Lc71;` / `Lg71;` |

### 1.3 ⭐ CallConfig 的完整结构（从 serializer `<clinit>` 扒的）

类名：`com.deepseek.feature.call.network.model.CallConfig`（serializer = `Lgy0;`）

| # | JSON 键 | 类型 | 说明 |
|---|---|---|---|
| 1 | `voices` | List | 可选音色列表 |
| 2 | `default_voice_id` | String | 默认音色 |
| 3 | `languages` | List | 对话语言 |
| 4 | `stt_languages` | List | 语音识别语言 |
| 5 | `providers` | List | 服务提供方 |
| 6 | `voice_id` | String | 当前音色 |
| 7 | `search_enabled` | Boolean | **通话中联网搜索**（对应 UI 的 CallSearchSetting）|

**缓存**：MMKV `key_call_config_v1`（存 JSON 字符串）
- 读：`Ld8b;->a()Ljava/lang/String;`（`MMKV.j`）
- 写：`Ld8b;->b(Ljava/lang/String;)Z`（`MMKV.q`）
- 消费：`Lky0;-><init>(Lihc;)V` —— CallConfig 仓库（日志串：`Call config cache read failed: ` / `Call config cache invalid: ` / `Call config refresh failed: `）
- 接口实现：`Ld8b;` implements `Lmy0;`

### 1.4 UI 层（全是 Compose，`com.deepseek.chat.ui.pages.call.*`）

| 源码文件 | 方法（2.6.1） | 混淆宿主 |
|---|---|---|
| **CallPage.kt:42** | `CallPage` | `Li93;->f(...)` |
| **CallPage.kt:91** | `CallContent` | `Li93;->e(...)` |
| **CallSettingsBottomSheet.kt:110** | `CallSettingsBottomSheet` | `Lpr6;->c(...)` |
| CallSettingsBottomSheet.kt:168 | `CallSettingsContent` | `Lpr6;->d(...)` |
| **CallSettingsBottomSheet.kt:513** | ⭐ `CallSearchSetting`（通话中搜索） | `Lpr6;->b(...)` |
| CallSettingsBottomSheet.kt:287 | `CallSettingsSectionLabel` | `Lpr6;->e(...)` |
| CallSettingsBottomSheet.kt:302 | `CallVoicePager` | `Lpr6;->h(...)` |
| CallSettingsBottomSheet.kt:404 | `CallVoicePagerIndicator` | `Lpr6;->i(...)` |
| CallSettingsBottomSheet.kt:451 | `CallVoiceBlobPreview` | `Lpr6;->f(...)` |
| CallSettingsBottomSheet.kt:493 | `CallVoiceLoadError` | `Lpr6;->g(...)` |
| CallBanner.kt:69 | `CallBanner` | `La50;` |
| CallControls.kt:128 | `CallCaptionsButton`（**实时字幕**） | `Lal0;` |
| CallRatingBanner.kt:39/74 | `CallRatingBanner`（通话评价） | `Le06;` / `La70;` |
| — | `CallOrbTextureView`（那个会动的球） | `com.deepseek.chat.ui.pages.call.orb.rendering.CallOrbTextureView`（**未混淆**） |

> ⚠️ **`Li93;` 是个 R8 合并巨类**：CallPage/CallContent **和**聊天页的气泡单元、模型设置文案都在里面。
> **`Lpr6;` 同理**：ChatPage 和 CallSettings* 在同一个类。
> ⇒ 以后按「类」找通话会误伤，**必须按方法**（这条已在 `逆向方法-混淆指纹定位.md` 里，现在有了新铁证）。

### 1.5 RTC 协议层

| 类 | 用途 |
|---|---|
| `com.deepseek.feature.call.rtc.protocol.TrtcMetaInfoMessage` / `TrtcMetaInfoPayload` | RTC 自定义消息（元信息） |
| `com.deepseek.feature.call.rtc.protocol.TrtcAgentStateParser.AgentStateMessage` / `AgentStatePayload` | **AI 状态机**（聆听/思考/说话）走来这条 |

### 1.6 资源 / 文案（都在，一条不缺）

| 资源名 | 文案 |
|---|---|
| `call_deep_seek` | 打电话 |
| `hang_up_call` / `end_call` / `confirm_end_call` | 挂断 / 结束通话 / **是否挂断当前通话？** |
| `call_in_progress` | **通话中 %1$s** |
| `in_call` | 通话中 |
| `call_listening_hint` / `call_thinking` / `call_interrupt_hint` | 正在聆听 / …（思考）/ **说话或轻触打断** |
| `call_connecting` | （连接中） |
| `show_call_captions` / `hide_call_captions` | 显示/收起通话字幕 |
| `call_settings` | 通话设置 |
| `redial_call` | 重拨 |
| `call_rating_title` / `call_rating_description` / `dismiss_call_rating_prompt` | 评价本次通话体验 / 关闭通话评价提示 |
| `call_experience_good` / `call_experience_bad` / `submit_call_feedback` | 通话体验好/不好 / 提交反馈 |
| `call_feedback_*`（5 条） | 听不到我 / 意外结束 / 打断太频繁 / 信息错误 / 没听懂 |
| `daily_call_limit_title` / `daily_call_limit_description` | **通话时长已达今日上限** |
| `call_service_error_*` / `call_network_error_toast` / `call_service_unavailable_toast` | 通话服务异常 / 网络异常请挂断后重新拨打 |
| `call_active_on_other_device_toast` / `call_already_in_progress_toast` / `too_many_active_call_devices` | 其他设备正在通话中 / 该账号正在通话的设备过多 |
| `call_no_audio_title` / `call_no_audio_description` | （无音频） |
| `call_answered_on_another_device` | （另一设备接听） |
| 通知 | `notification_call` 布局 + `call_notification_*` id/color + `ic_call_hang_up` / `ic_call_mute` / `ic_call_network_poor` / `ic_call_redial` |
| 铃声 | `raw/call_connected` · `raw/call_disconnected` |

---

## 二、A/B 测试的实体是什么（结论）

| 找法 | 结果 |
|---|---|
| 宿主 `key_*` MMKV 键全 dump（64 个） | 通话相关的**只有** `key_call_config_v1`（是**缓存**，不是开关） |
| 宿主 settings 类型字典 `fu2`(65) + `yib`(7) + `wza`(7) = 79 条 | **没有一条通话键** |
| 自研 AB 平台（搜 `abtest` / `experiment` 类名） | **不存在**（`experiment` 命中的全是 TRTC 的 `callExperimentalAPI`） |

⇒ **「AB 测试」= 服务端给不给这个账号下发 `CallConfig`**。
⇒ 本地**没有**可以拨动的"显示入口"开关。
⇒ 主人"完全看不到入口"完全解释得通。

---

## 三、⭐ hook 影响审计（逐条，这是本次的重点）

### 3.1 底座当前注册表（45 条，从 `tmp/base130_261/sm/.../GmEntry.smali` 解析）

43 条 `hookM` + 2 条 `hookC2`。宿主类名经 `GmRemap` 运行时映射。

### 3.2 通话页实际会踩到我们 hook 的路径（**直接调用层实测**）

| 通话侧方法 | 它调用 | 我们挂的方法 |
|---|---|---|
| `i93.e`（CallContent） | `pr6.c` | ❌ 我们挂的是 `pr6.j`（ChatPage）—— **没撞** |
| `pr6.b`（CallSearchSetting） | `qk7.D` · `kh7.x` · `pe5.a` | ⚠️⚠️⚠️ **三条全中** |
| `pr6.d`（CallSettingsContent） | `qk7.D` · `pr6.e/h/g/b` | ⚠️ `qk7.D` |

### 3.3 逐条闸门（**决定生死的表**）

| hook 类 | 挂载点（2.6.1） | 闸门 | 通话页判定 |
|---|---|---|---|
| **GmBubblePaintHook** | `qk7.C` / `qk7.D` | ① `sDepth > 0`（否则直接 return）② caller `ua0.e` 排除 ③ `sSkipList` ④ `sAblateCur.contains` ⑤ 10 个调用点白名单 | ✅ **安全**（sDepth 恒 0；且 caller=`pr6.b` 也不在白名单）|
| **GmPainterHook** | `kh7.x` | 资源 id `== 0x7f07005a`（assistant_message_avatar） | ✅ 安全 |
| **GmIconHook** | `pe5.a` | **纯日志**（"our painter reached Icon layer"） | ✅ 安全 |
| **GmPaintModHook** | `w2b.Y` | `args[1] == GmPainterHook.sPainter`（**同一实例**） | ✅ 安全 |
| **GmBubbleFitHook** | `jq0.b` | `thisObject.d instanceof Shader` **且** `sBmpMap.get(thisObject) != null` | ✅ 安全 |
| **GmAlphaHook** | `eh0` ctor / `eh0.c` | `sDepth > 0` | ✅ 安全 |
| **GmShadowHook** | `dn9` ctor | `sDepth > 0` **且** `on()` | ✅ 安全 |
| **GmUBubbleHook** | `ua0.e` | 只做 `sUBub++/--` 计数 + logOnce | ✅ 安全（无副作用）|
| **GmGateListHook** | `dz9.isEmpty` | `thisObject == GmGateHook.sGate`（身份比对） | ✅ 安全 |
| **GmAvatarHook** | `Resources.getDrawable` | 资源 id `== 0x7f07005a` | ✅ 安全 |
| **GmResTextHook** | `Resources.getString/getText` | `id==0 ⇒ ""`；其余按资源 id | ✅ 安全 |
| **GmMmkvHook** | `MMKV.q/k/j/contains` | `handle()` 开头就 `key.equals("kv_remote_settings_model_configs_v1")`，否则返回 null ⇒ 原样放行；另有 `sPins` 白名单 | ✅ **不碰 `key_call_config_v1`** |
| **GmCallHook** | `gh2.k` / `gh2.l0`（旧 ao1.I/J） | **wip 遗产**（见 §五） | 🗑 待拆 |
| **GmAsrHook / GmCallSeeHook** | `yp1.c` / `yp1.b` | `yp1` 未定位 ⇒ `GmRemap` 返回 `com.gm.gone.yp1` ⇒ **本来就不注册** | 🗑 待拆 |

### 3.4 ⭐ 为什么"零影响"—— 一句话根因

```
sDepth 只在 GmBubbleCellHook（挂 i93.i = 气泡单元 Composable）里 ++/--
          ↓
通话页（i93.f CallPage → i93.e CallContent）**整条链路不调用 i93.i**
          ↓
sDepth 恒为 0  ⇒  GmBubble.inScope() = false
          ↓
气泡系（Paint / Alpha / Shadow / Fit / Pg / Ub）**全部在闸门前返回**
```

**旁证**：`i93` 内部自调用扫描结果 —— `i`/`R`/`S` 三个方法**没有任何 i93 内部调用者**；`f`(CallPage) 只调 `e`(CallContent)。

### 3.5 唯一残留开销

通话页走 `qk7.D` / `kh7.x` / `pe5.a` 时，仍会跑：
- `GmBubblePaintHook.rec()/dg()`（写我们自己的 `sAblateList/sSkipList` + `GmUtil.caller()` 栈扫描）
- `GmUBubbleHook` 的计数、`GmIconHook` 的 logOnce

⇒ **纯诊断开销，不写宿主任何字段**。若在意性能，可把 `dg()` 的 `caller()` 调用挪到闸门之后（**可选优化，非必需**）。

---

## 三·五、⭐ 2026-10-02 补挖：接口 + 入口（重大）

### A. 通话 API 全家桶（明文 URL，dex 里直接搜到）

| 方法 | URL | 出现类 |
|---|---|---|
| GET/POST | **`/api/v0/call/config`** | `Lkx0;` |
| POST | `/api/v0/call/start` | `Ld21;` / `Lf0;` |
| POST | `/api/v0/call/update` | `Ld0;` / `Ld21;` |
| POST | `/api/v0/call/stop` | `Ld0;` |

配套（同域）：
- `Lxk3;->prepareCallStartRequest(TrtcCallStartRequest;...)` —— 起通话前组装请求
- `Ldo1;->submitFeedback$app(CallFeedbackTag;String;Continuation;)` —— 评价提交
- `Lg21;` —— `CallMessageTree$SyncTarget`
- `Lts;->onAction$app(CallPageAction;)` —— CallPage 的 ViewModel

> ⚠️ `Lkx0;` 本身是个 Composable lambda（implements `Lcv4;`），**不是** Retrofit 接口；
> 它的字符串里同时有 `/api/v0/users/oauth/wechat/unbind`、`/users/settings`、`/users/current`、`/chat/tts/voices`、`/call/config`
> ⇒ **R8 把一批 URL 常量合并进了同一个类**，不能靠"URL 所在类"反推调用者。

### B. ⭐ 入口找到了：**聊天页输入栏上方的 Banner**（不是那排图标！）

`com.deepseek.chat.ui.pages.chat.call.*`（源码名保留在字符串里）：

| 源码位置 | 组件 | 作用 |
|---|---|---|
| **ChatCallHost.kt:32** | `ChatCallHost` | 通话宿主（挂在聊天页） |
| **ChatCallBanners.kt:23 / ChatCallHost.kt:99** | **`inputBanner`** | ⭐ **输入栏上方的通话横幅 = 打电话入口的真身** |
| ChatCallBanners.kt:36 | （banner 内部 lambda） | |
| **ChatCallState.kt:151** | `rememberChatCallState` | 通话状态 |
| ChatCallHost.kt:73/80/89/90/92 | `ChatConversationTransition` | **通话页 ↔ 聊天页 转场动画** |
| ChatCallHost.kt:109 | `ChatCallFeedback` | 通话反馈入口 |
| — | `ChatCallBannerState$Kind` | banner 种类枚举（`Ldr;->dismissBanner$app`） |

> 🎉 **这解释了当年的老困惑**：`专题/音频通话.md` 里写「拍照/照片/文件那排 Compose 写死插不进去」——
> **官方根本没往那排塞**，而是做成了**输入栏上方的 banner**。我们的悬浮钮方案其实"位置感"对了。

---

## 三·六、⭐⭐⭐ 真正开闸的那把钥匙：`model_configs[].call_feature`

> 2026-10-02 补挖。**这是整个专题最重要的一节。**

### A. 宿主有三个"开关载体"，通话在第三个

| # | 载体 | 通话有没有 |
|---|---|---|
| 1 | MMKV `key_*` | ❌ |
| 2 | remote settings（`kv_remote_settings_*` / 类型字典 79 条）| ❌ |
| 3 | **`model_configs` 里每个 model 的 `*_feature` 对象** | ✅ **`call_feature`** |

### B. ModelConfig 的 20 个字段（`com.deepseek.chat.settings.ModelConfig`）

```
model_type · name · description · welcome_msg · is_default · enabled · switchable
show_model_name_in_session · input_character_limit · think_feature · search_feature
tts_feature · file_feature · ★call_feature★ · camera_mode · prompt_feature
regenerate_options · tips · edit_quota · regenerate_quota
```

| 混淆名 | 身份 |
|---|---|
| `Lt77;` | `ModelConfig$Companion`（serializer，descriptor 在这里）|
| `Lv77;` | `ModelConfig$$serializer` |
| **`Lv87;`** | ⭐ **`ModelConfig` 数据类本体**（22 字段）|
| `Lu77;` | `ModelConfig$CallFeature$Companion` |
| **`Lw77;`** | ⭐ **`ModelConfig$CallFeature` 数据类** |

### C. ⭐ `CallFeature` 是**空标记对象**

```smali
# Lu77;-><clinit>()
const-string v2, "com.deepseek.chat.settings.ModelConfig.CallFeature"
const/4 v3, 0x0                    # ★ 字段数 = 0
invoke-direct {v1, v2, v0, v3}, Lca8;-><init>(...)V
# 后面一个 j("...") 都没有 —— 零字段
```

`Lw77;` 的 equals/hashCode 各只有 2 条指令（恒等）。

> 对照 `TtsFeature`（`Ls87;`）：**1 个字段** `auto_tts_enable_by_default`
> ⇒ **同款套路**：`{"call_feature":{}}` 存在即开启，**不下发就是 null**（descriptor 里它的 isOptional=true）

### D. ⭐ 判据原文（`Lws7;->m`，SourceInfo = **ChatPageTopBar.kt:105**）

```smali
.line 520   check-cast v2, Lv87;                 # config = (ModelConfig) state.value
.line 522   iget-object v2, v2, Lv87;->n:Lw77;  # callFeature = config.call_feature
.line 524   if-nez v2, :cond_20f               # != null 才往下
.line 526   move v15, v1 / goto :goto_210      #   null ⇒ v15 = false
:cond_20f   const/4 v15, 0x1                   #   != null ⇒ v15 = true
:goto_210   if-nez v15, :cond_220              # !v15 ⇒ 跳过
```

⇒ **`call_feature != null` ⇒ 显示**（方向已肉眼确认，不是反判断）

**`call_feature`（`Lv87;->n`）的全部读点**：
| 读点 | 性质 |
|---|---|
| **`Lws7;->m(...)`** | ⭐ **ChatPageTopBar.kt:105 —— UI 入口判据** |
| `Le0;->h(Object)` | 逻辑（2 处）|
| `Lj;->w()` | 逻辑 |
| `Lt77;->e(...)` | 序列化 |
| `Lv87;` 自身 | ctor / equals / toString |

### E. ⭐⭐ 完整闭环（现在全通了）

```
ChatPageTopBar 读 modelConfig.call_feature != null
        ↓  非 null ⇒ 顶部栏显示「打电话」图标
     点击
        ↓
CallPage (i93.f) / CallContent (i93.e)
        ↓  拉 /api/v0/call/config（音色/语言）+ /api/v0/call/start（roomId/userSig）
   TRTC 房间（腾讯 liteav）
        ↓  退出页面（通话继续，CallForegroundService 保活）
ChatCallHost.inputBanner（聊天页输入栏上方「通话中」横幅）
        ↓  挂断
ChatCallBanner / ChatCallFeedback（评价）
```

### F. 实现开关的**现成模板**：`GmTts`

```java
// GmTts（现有）
ensure(ctx): v = GmStore.read2(ctx,"kv_remote_settings_model_configs_v1","s")
             if (GmPrompt.ok(v)) { n = fix(v); if(!n.equals(v)) { bak(); write(n); } }
fix(json):   幂等（含 "tts_feature" 就直接返回）；否则
             "search_feature":{}  →  "search_feature":{},"tts_feature":{"auto_tts_enable_by_default":true}
             （退路锚 "think_feature":{}）
```

⇒ **`GmCall` 照抄即可**，锚点建议改 `"model_type":`（每个 model 的第一个字段，稳定且不与 GmTts 撞车）：

```
"model_type":   →   "call_feature":{},"model_type":
```

---

## 三·七、⭐ 抓包实证（2026-10-02 · 真机 HAR）

> 来源：`抓包/ProxyPin10-2_10_33_12.har`（隔离区，含 Token，**不入库**）
> 场景：装上 `FDM-3.42.37`、开关打开、点顶部栏「打电话」

### 两条接口，两种答案

| 接口 | HTTP | 业务码 | 结论 |
|---|---|---|---|
| `GET /api/v0/call/config` | **200** | `biz_code:0` | ✅ **完全放行**，数据完整 |
| `POST /api/v0/call/start` | **200** | **`biz_code:5`** | ❌ **`biz_msg:"call mode disabled"`** |

### `call/start` 请求体（**字段全在客户端**，将来可调）

```json
{"chat_session_id":"<UUID>","parent_message_id":null,
 "interrupt_speech_duration":300,     // 打断阈值(ms)
 "vad_silence_time":1000,             // 静音判定(ms)
 "vad_level":2,                       // VAD 灵敏度
 "provider":"trtc"}                   // 走腾讯 TRTC
```

### `call/config` 响应（脱敏）

```
voices:  mira   贝壳 · 百变活泼 · female   ← default_voice_id / voice_id
         echo   白浪 · 明朗坚定 · male
         stella 海星 · 俏皮甜美 · female
         tide   暗潮 · 低沉浑厚 · male
search_enabled = true
languages / stt_languages = 各 29 种（ar cs da de el en es fi fil fr hi hu id it ja ko ms nb nl pl pt ro ru sv th tr uk vi zh）
```

`mira` 的结构（＝ `CallConfig.voices[]` 的字段）：
`voice_id` · `name_i18n{zh,en}` · `description_i18n{zh,en}` · `gender` · `languages[]` · `demo_urls{<lang>: cdn url}`

### ⭐ 结论

1. **我们的 `call_feature` 开关完全正确**：图标出来了 → CallPage 渲染了 → 两条接口**真的发出去了**。
2. **服务端只挡了 `start`**（feature flag `call mode disabled`）—— 这正是主人说的「那个功能是坏的还没修」。
3. **一旦服务端开闸，立刻可用，客户端一行都不用再改。**
4. ⚠️ **本地绕不过**：TRTC 需要服务端发的 `roomId` / `userSig`（就是 `call/start` 的 `biz_data`，现在为 `null`）。
   没有它连不进房间 —— 这不是客户端能伪造的。

### 真机验证结论（3.42.37）

| 项 | 结果 |
|---|---|
| 顶部栏「打电话」图标 | ✅ 出现 |
| CallPage 渲染 | ✅ 正常 |
| wip 残留日志（`已捕获发送上下文`）| ✅ **0 条**（停用成功）|
| `hookM FAIL` | 只剩设计内的 `com.gm.gone.yp1.*` |
| 宿主自身功能 | ✅ 正常 |

### ⭐ 为什么本地绕不过（代码原文，2026-10-02 核）

进 TRTC 房间的 **4 个参数全部来自服务端**。`dua.smali:520-554`：

```smali
new-instance v1, TRTCCloudDef$TRTCParams
iget v2, p1, Ly51;->c:I                            → v1.sdkAppId  = p1.c
iget-object v2, p1, Ly51;->d:Ljava/lang/String;    → v1.userId    = p1.d
iget-object v2, p1, Ly51;->e:Ljava/lang/String;    → v1.userSig   = p1.e   ★
iget-object p1, p1, Ly51;->b:Ljava/lang/String;    → v1.strRoomId = p1.b
invoke-virtual {p1, v1, v3}, Lcom/tencent/trtc/TRTCCloud;->enterRoom(TRTCParams;I)V
```

而 `Ly51;` 的这 4 个字段 = `call/start` 响应里的 `TrtcCallConnection`
（`{sdk_app_id, user_id, user_sig}`，`Lyta;` 的 descriptor 实证）+ `strRoomId`。

> `TRTCParams` 的字段（腾讯 SDK 未混淆，`TRTCCloudDef$TRTCParams`）：
> `sdkAppId` · `userId` · `userSig` · `strRoomId` · `roomId` · `role` · `streamId` · `businessInfo` · `privateMapKey` · `userDefineRecordId`

**`userSig` = HMAC-SHA256(SDKSecretKey, sdkAppId+userId+expire)** —— 而 `SDKSecretKey` 只存在
**腾讯云控制台 / DeepSeek 服务端**，客户端不可能有。

⇒ 本地**无法自签**；伪造的签名会被**腾讯云**（不是 DeepSeek）拒掉。
⇒ `call/start` 现在回 `biz_data: null` ⇒ 4 个参数一个都没有 ⇒ `enterRoom` 根本凑不齐参数。

**结论：唯一的路是服务端开 `call mode`。换自己的 TRTC 账号也没用 —— AI 在 DeepSeek 的房间里。**

---

## 四、将来要做"开关"时的切入点（勘探结果）

| 目标 | 锚点 | 备注 |
|---|---|---|
| 读通话配置 | `Ld8b;->a()`（`MMKV.j("key_call_config_v1")`） | 我们的 `GmMmkvHook` 已经挂 `MMKV.j` ⇒ **天然可覆盖** |
| 写通话配置 | `Ld8b;->b(String)`（`MMKV.q`） | 同上（`MMKV.q` 已挂） |
| 配置消费点 | `Lky0;-><init>(Lihc;)V` / `Lky0;->a(Lf93;)`（refresh） | 想要"改了不被覆盖"要在这里动手 |
| ⚠️ 未知 | **谁读 CallConfig 决定"显示入口"** | 尚未定位（本轮没入口可验证） |

> ⚠️ **但要注意**：`key_call_config_v1` 只是**音色/语言缓存**，
> **不是**"能不能打电话"的开关。真正的开关（如果有）在服务端下发链路里。
> ⇒ 做开关前必须先**定位入口显隐判据**（下一步勘探任务）。

---

## 五、wip「音频通话」遗产清单（待拆）

> 主人决定：**如果宿主的能用，就把 wip 全部代码移除**，改成灰度工具箱里的一个开关。

**模块类（12 个）**
```
GmAsrHook      GmCallAiHook   GmCallBtn     GmCallCtorHook
GmCallDialog   GmCallHook     GmCallPTT     GmCallRun
GmCallSeeHook  GmCallTick     GmCallYpHook  GmRecHook
```

**底座注册表里的对应条目**
```
hookM  ao1 I   → GmCallHook        （→ gh2.k）
hookM  ao1 J   → GmCallHook        （→ gh2.l0）
hookM  yp1 c   → GmAsrHook         （→ GONE，本来就没注册）
hookM  yp1 b   → GmCallSeeHook     （→ GONE，本来就没注册）
hookC2 ao1     → GmCallCtorHook?   （需核）
```

**UI 侧（需一并清）**
- `GmCallBtn`（悬浮钮）· `GmCallDialog`（全屏通话页）· `GmChatDialog` 里的「音频通话 (wip)」菜单项
- `GmClick` 里的动作码 **0x39 / 0x3a / 0x3b / 0x3c**
- `GmResumeHook` 里的悬挂浮钮时机
- `GmBubble.gz3→bz4` 这条映射（`GmCallDialog` 专用）

**保留**：`GmSuggestAi` 也挂在 `gh2.W`（旧 ao1.M）——**这是活跃功能，别误删**。

---

## 六、下次接手第一件事

1. 若要**解锁**：先定位「读 CallConfig → 决定入口显隐」的判据（本轮没入口，验不了）。
2. 若要**拆 wip**：按 §五 清单删，**每删一处回读产物**（教训 268：停用必须落实到删代码）。
3. 本轮**结论：不需要为通话改任何现有 hook**。
