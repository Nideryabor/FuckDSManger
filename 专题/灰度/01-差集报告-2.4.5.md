# 服务端下发灰度 vs 管理器支持列表 —— 差集报告

> 生成时间：2026-09-12
> 数据来源：`1.txt`（服务端下发快照，2.4.5 实测，**54 项**）
> 对照对象：`FuckDSManger 2.3.0` 的 `GmDialog` KEYS/NAMES/TYPES（**62 项**）
> 交集：**40 项**
> 二次验证：已在 `DeepSeek2_2.4.5.apk` 的 dex 字符串中逐条核对 key 是否真实存在
> （workspaceId `nojs8uv8`，临时）

---

## A. 🔴 服务端有、管理器【没有】 —— 共 14 项

### A1. ✅ APK 里真实存在的 key（**8 项，值得补进管理器**）

| # | key | 服务端值 | 类型 | APK 中的证据 |
|---|---|---|---|---|
| 1 | `support_chat_file_exts` | 数百项文件后缀数组 | json/`l` | `Lp91` / `Luv1`：`kv_remote_settings_support_chat_file_exts` |
| 2 | `pow_header_paths` | 6 条路径数组 | json/`l` | `Lok2` / `Luv1`：`kv_remote_settings_pow_header_paths` |
| 3 | `authed_pow_functions` | `["search","deep_think","completion","file"]` | json/`l` | `Lv01` / `Luv1`：`kv_remote_settings_authed_pow_functions` |
| 4 | `image_cache_invalidate_before` | `1777444200000` | `l`(long) | `Laz5` / `MMKV`：`kv_remote_settings_image_cache_invalidate_before` |
| 5 | `camera_compress_ratio` | `0.8` | `f` | `Luv1`：`kv_remote_settings_id_camera_compress_ratio` |
| 6 | `photo_picker_compress_ratio` | `0.8` | `f` | `Luv1`：`kv_remote_settings_id_photo_picker_compress_ratio` |
| 7 | `search_state_trigger` | `{"trigger":"on","trigger_version":1}` | json | `Luv1`：`kv_remote_settings_id_search_state_trigger` |
| 8 | `model_configs` | 模型配置 JSON 数组 | json | `Laz5`：**`kv_remote_settings_model_configs_v1`** ⚠️ 见 D-3 |

### A2. ❌ APK 里**搜不到**的 key（6 项，加进管理器也不会生效）

| # | key | 服务端值 | 实际情况 |
|---|---|---|---|
| 9 | `completion_request_timeout_millis` | `120000` | APK 里只有 `completion_request_timeout_ms`（管理器已有此项） |
| 10 | `max_input_files` | `50` | APK 里只有 `max_input_file_count`（管理器已有此项） |
| 11 | `query_title_time_interval` | `3000` | APK 全库无 `title_time_interval` |
| 12 | `stop_stream_wait_times` | `1000` | 只有 `stop_stream_reason` / `stop_stream_success` / `/api/v0/chat/stop_stream` |
| 13 | `citation_strategy` | `2` | 只有 `citation_dedupe_scope`、`[citation:n]` 等，无该 key |
| 14 | `report_http_biz_error` | `true` | APK 里只有 `report_http_failure_paths`（管理器已有此项） |

> **结论**：A2 这 6 项是服务端下发了、但 App 客户端**根本不会读取**的键
> （多见于服务端灰度遗留 / 内部实验项 / 被其它键取代的旧键）。

---

## B. 🟡 管理器有、服务端【未下发】 —— 共 22 项

> 不是错误。App 内置默认项 / 其它灰度路径 / 本次未推给该设备的项。

```
allow_parallel_streams              conversation_search_enabled
copy_text_without_markdown_syntax   disable_single_dollar_latex
edit_menu_item_config               enable_webview_content_report
gcy_enabled                         hide_assistant_avatar
input_default_voice                 input_view_voice_gesture_duration_ms
interrupt_and_send_enabled          markdown_top_level_node_limit
max_duration_ms                     max_input_file_count
opus_bitrate                        pinned_session_limit
record_empty_detect_time_ms         select_text_without_markdown_syntax
session_prefetch_count              sse_auto_scroll_smooth_stiffness
support_center_url                  voice_input_enabled
```

## C. ✅ 双方都有 —— 40 项

```
allow_file_with_search              android_apk_link
auto_resume_interval_ms             auto_resume_max_time_ms
auto_resume_request_timeout_ms      completion_request_timeout_ms
continue_request_timeout_ms         dead_link_detection
deep_think_button_suffix            ds_settings_enabled
edit_request_timeout_ms             enable_google_sign_in_captcha
files_host                          hcaptcha_enabled
hif_max_retry_interval_secs         launch_clean_session_interval_seconds
max_upload_file_size                normal_history_and_file_token_limit
one_tap_login_enabled               optimize_markdown
picture_compress_format             pow_prefetch
pow_prefetch_count                  query_files_time_interval
r1_history_and_file_token_limit     record_stop_delay_ms
regenerate_request_timeout_ms       resume_request_timeout_ms
search_state_on_automatically_created_chat   search_state_on_launch
search_state_on_login               search_state_on_manually_created_chat
session_prefetch                    show_new_chat_button_above_input
should_use_sm_device_id             sm_pass_code_type
sm_sdk_host                         sse_auto_scroll_one_screen
sse_smooth_follow                   volcengine_enabled
```

---

## D. 关键发现

1. **服务端下发格式带 id**：每条是 `key\n{"id":<N>,"value":<V>}`，
   这个 `id` 正是项目总结待办 #4 提到的 `kv_remote_settings_id_*` 变体的来源。
2. **服务端下发的键 ≠ App 读取的键**：54 项里有 **6 项** App 根本不认（A2），
   说明服务端的 settings 表里有历史遗留 key。
3. **`model_configs` 命名错位**：服务端下发 `model_configs`，
   但 App 实际读的是 `kv_remote_settings_model_configs_v1` /
   `kv_remote_settings_id_model_configs_v1`（**带 `_v1`**）。
   → 若要在管理器里改模型配置，key 必须写 `model_configs_v1`。
4. **本次未出现 `providers_v1` / `languages` / `report_http_failure_paths` 的下发**，
   但它们在 APK 中存在（属 B 组性质）。
5. **管理器当前只支持 `b/i/f/s` 四种类型**；A1 里 5 项是数组/对象/json，
   若要纳管需扩展类型（建议当作 `s` 原样写入 json 字符串）。

---

## E. 建议下一步

1. 把 **A1 的 8 项**按类型补进 `GmDialog` 的 `KEYS/NAMES/TYPES/DESCS`
   （json 类建议用 `s` 类型，或新增 `j` 类型走 getString）
2. A2 的 6 项**不建议加**（App 不读，加了没效果）
3. `model_configs` 若要加，key 用 `model_configs_v1`
4. 可选：给管理器加「服务端下发键自动发现」——打开下发页时把未纳管的 key 列出来
