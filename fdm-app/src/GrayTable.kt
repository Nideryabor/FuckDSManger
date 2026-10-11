// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用

package com.nidyaber.fuckdsmanger
import android.content.Context
import androidx.compose.ui.res.stringResource

/* 宿主灰度开关表（原 UI 的「灰度选项管理」页）——**生成物，别手改**
   来源：gm/GmDialog 的 (键, 标签, 类型) 三连 + 那条按 \n 分隔的说明串
   键已带 kv_remote_settings_ 前缀的按原样用（看 pfx 标记）

   ⚠️⚠️ 2026-10-02 尼得亚伯：本文件有 **2 处手工修正**（原说明串与宿主类型矛盾）——
       · input_default_voice ：原写「如 zh-CN」，但宿主 yib.smali 注册的是 Boolean
       · volcengine_enabled  ：原写「开关」，但宿主注册的是 String
       ⇒ **重新生成 GrayTable 时，这两条要保留成下面那样**（别被生成脚本冲掉）。
         根因在 `gm/GmDialog` 的说明串本身 —— 下次一并修那里。 */
enum class GrayType { B, I, S, L }

data class Gray(val key: String, val label: String, val hint: String,
                val type: GrayType, val pfx: Boolean)

object GrayTable {
    fun items(ctx: Context) = listOf(
        // ★ 2026-10-02 新增：语音输入的**真闸门**。宿主 `pn5.<init>` 要**两个都真**才给麦克风：
        //   `key_voice_available`（裸键，宿主默认 **false**！）+ `kv_settings_voice_input_enabled`
        //   ⇒ 只开下面那条「语音输入」是不够的（主人实测踩到）。
        Gray("key_voice_available", ctx.getString(R.string.gray_001), ctx.getString(R.string.gray_002), GrayType.B, false),
        Gray("voice_input_enabled", ctx.getString(R.string.gray_003), ctx.getString(R.string.gray_004), GrayType.B, false),
        Gray("input_default_voice", ctx.getString(R.string.gray_005), ctx.getString(R.string.gray_006), GrayType.B, false),
        Gray("input_view_voice_gesture_duration_ms", ctx.getString(R.string.gray_007), ctx.getString(R.string.gray_008), GrayType.I, false),
        Gray("record_empty_detect_time_ms", ctx.getString(R.string.gray_009), ctx.getString(R.string.gray_010), GrayType.I, false),
        Gray("record_stop_delay_ms", ctx.getString(R.string.gray_011), ctx.getString(R.string.gray_012), GrayType.I, false),
        Gray("max_duration_ms", ctx.getString(R.string.gray_013), ctx.getString(R.string.gray_014), GrayType.I, false),
        Gray("opus_bitrate", ctx.getString(R.string.gray_015), ctx.getString(R.string.gray_016), GrayType.I, false),
        Gray("deep_think_button_suffix", ctx.getString(R.string.gray_017), ctx.getString(R.string.gray_018), GrayType.S, false),
        Gray("conversation_search_enabled", ctx.getString(R.string.gray_019), ctx.getString(R.string.gray_020), GrayType.B, false),
        Gray("search_state_on_login", ctx.getString(R.string.gray_021), ctx.getString(R.string.gray_022), GrayType.S, false),
        Gray("search_state_on_launch", ctx.getString(R.string.gray_023), ctx.getString(R.string.gray_024), GrayType.S, false),
        Gray("allow_parallel_streams", ctx.getString(R.string.gray_025), ctx.getString(R.string.gray_026), GrayType.B, false),
        Gray("interrupt_and_send_enabled", ctx.getString(R.string.gray_027), ctx.getString(R.string.gray_028), GrayType.B, false),
        Gray("allow_file_with_search", ctx.getString(R.string.gray_029), ctx.getString(R.string.gray_030), GrayType.B, false),
        Gray("sse_smooth_follow", ctx.getString(R.string.gray_031), ctx.getString(R.string.gray_032), GrayType.B, false),
        Gray("normal_history_and_file_token_limit", ctx.getString(R.string.gray_033), ctx.getString(R.string.gray_034), GrayType.I, false),
        Gray("r1_history_and_file_token_limit", ctx.getString(R.string.gray_035), ctx.getString(R.string.gray_036), GrayType.I, false),
        Gray("completion_request_timeout_ms", ctx.getString(R.string.gray_037), ctx.getString(R.string.gray_038), GrayType.I, false),
        Gray("regenerate_request_timeout_ms", ctx.getString(R.string.gray_039), ctx.getString(R.string.gray_040), GrayType.I, false),
        Gray("hif_max_retry_interval_secs", ctx.getString(R.string.gray_041), ctx.getString(R.string.gray_042), GrayType.I, false),
        Gray("hcaptcha_enabled", ctx.getString(R.string.gray_043), ctx.getString(R.string.gray_044), GrayType.B, false),
        Gray("enable_google_sign_in_captcha", ctx.getString(R.string.gray_045), ctx.getString(R.string.gray_046), GrayType.B, false),
        Gray("one_tap_login_enabled", ctx.getString(R.string.gray_047), ctx.getString(R.string.gray_048), GrayType.B, false),
        Gray("hide_assistant_avatar", ctx.getString(R.string.gray_049), ctx.getString(R.string.gray_050), GrayType.B, false),
        Gray("select_text_without_markdown_syntax", ctx.getString(R.string.gray_051), ctx.getString(R.string.gray_052), GrayType.B, false),
        Gray("enable_webview_content_report", ctx.getString(R.string.gray_053), ctx.getString(R.string.gray_054), GrayType.B, false),
        Gray("picture_compress_format", ctx.getString(R.string.gray_055), ctx.getString(R.string.gray_056), GrayType.S, false),
        Gray("support_center_url", ctx.getString(R.string.gray_057), ctx.getString(R.string.gray_058), GrayType.S, false),
        Gray("query_files_time_interval", ctx.getString(R.string.gray_059), ctx.getString(R.string.gray_060), GrayType.I, false),
        Gray("markdown_top_level_node_limit", ctx.getString(R.string.gray_061), ctx.getString(R.string.gray_062), GrayType.I, false),
        Gray("pow_prefetch_count", ctx.getString(R.string.gray_063), ctx.getString(R.string.gray_064), GrayType.I, false),
        Gray("session_prefetch_count", ctx.getString(R.string.gray_065), ctx.getString(R.string.gray_066), GrayType.I, false),
        Gray("pow_prefetch", ctx.getString(R.string.gray_067), ctx.getString(R.string.gray_068), GrayType.B, false),
        Gray("session_prefetch", ctx.getString(R.string.gray_069), ctx.getString(R.string.gray_070), GrayType.B, false),
        Gray("continue_request_timeout_ms", ctx.getString(R.string.gray_071), ctx.getString(R.string.gray_072), GrayType.I, false),
        Gray("resume_request_timeout_ms", ctx.getString(R.string.gray_073), ctx.getString(R.string.gray_074), GrayType.I, false),
        Gray("edit_request_timeout_ms", ctx.getString(R.string.gray_075), ctx.getString(R.string.gray_076), GrayType.I, false),
        Gray("auto_resume_request_timeout_ms", ctx.getString(R.string.gray_077), ctx.getString(R.string.gray_078), GrayType.I, false),
        Gray("auto_resume_max_time_ms", ctx.getString(R.string.gray_079), ctx.getString(R.string.gray_080), GrayType.I, false),
        Gray("auto_resume_interval_ms", ctx.getString(R.string.gray_081), ctx.getString(R.string.gray_082), GrayType.I, false),
        Gray("launch_clean_session_interval_seconds", ctx.getString(R.string.gray_083), ctx.getString(R.string.gray_084), GrayType.I, false),
        Gray("pinned_session_limit", ctx.getString(R.string.gray_085), ctx.getString(R.string.gray_086), GrayType.I, false),
        Gray("max_upload_file_size", ctx.getString(R.string.gray_087), ctx.getString(R.string.gray_088), GrayType.I, false),
        Gray("max_input_file_count", ctx.getString(R.string.gray_089), ctx.getString(R.string.gray_090), GrayType.I, false),
        Gray("sse_auto_scroll_one_screen", ctx.getString(R.string.gray_091), ctx.getString(R.string.gray_092), GrayType.B, false),
        Gray("sse_auto_scroll_smooth_stiffness", ctx.getString(R.string.gray_093), ctx.getString(R.string.gray_094), GrayType.I, false),
        Gray("optimize_markdown", ctx.getString(R.string.gray_095), ctx.getString(R.string.gray_096), GrayType.B, false),
        Gray("disable_single_dollar_latex", "禁用单\$LaTeX", "开关：单个 \$ 不再当公式，避免误渲染", GrayType.B, false),
        Gray("show_new_chat_button_above_input", ctx.getString(R.string.gray_097), ctx.getString(R.string.gray_098), GrayType.B, false),
        Gray("copy_text_without_markdown_syntax", ctx.getString(R.string.gray_099), ctx.getString(R.string.gray_100), GrayType.B, false),
        Gray("search_state_on_manually_created_chat", ctx.getString(R.string.gray_101), ctx.getString(R.string.gray_102), GrayType.S, false),
        Gray("search_state_on_automatically_created_chat", ctx.getString(R.string.gray_103), ctx.getString(R.string.gray_104), GrayType.S, false),
        Gray("should_use_sm_device_id", ctx.getString(R.string.gray_105), ctx.getString(R.string.gray_106), GrayType.B, false),
        Gray("dead_link_detection", ctx.getString(R.string.gray_107), ctx.getString(R.string.gray_108), GrayType.B, false),
        Gray("gcy_enabled", ctx.getString(R.string.gray_109), ctx.getString(R.string.gray_110), GrayType.B, false),
        Gray("ds_settings_enabled", ctx.getString(R.string.gray_111), ctx.getString(R.string.gray_112), GrayType.B, false),
        Gray("volcengine_enabled", ctx.getString(R.string.gray_113), ctx.getString(R.string.gray_114), GrayType.S, false),
        Gray("sm_pass_code_type", ctx.getString(R.string.gray_115), ctx.getString(R.string.gray_116), GrayType.S, false),
        Gray("edit_menu_item_config", ctx.getString(R.string.gray_117), ctx.getString(R.string.gray_118), GrayType.I, false),
        Gray("files_host", ctx.getString(R.string.gray_119), ctx.getString(R.string.gray_120), GrayType.S, false),
        Gray("sm_sdk_host", ctx.getString(R.string.gray_121), ctx.getString(R.string.gray_122), GrayType.S, false),
        Gray("android_apk_link", ctx.getString(R.string.gray_123), ctx.getString(R.string.gray_124), GrayType.S, false),
        Gray("support_chat_file_exts", ctx.getString(R.string.gray_125), ctx.getString(R.string.gray_126), GrayType.S, true),
        Gray("pow_header_paths", ctx.getString(R.string.gray_127), ctx.getString(R.string.gray_128), GrayType.S, true),
        Gray("authed_pow_functions", ctx.getString(R.string.gray_129), ctx.getString(R.string.gray_130), GrayType.S, true),
        Gray("image_cache_invalidate_before", ctx.getString(R.string.gray_131), ctx.getString(R.string.gray_132), GrayType.L, true),
        Gray("camera_compress_ratio", ctx.getString(R.string.gray_133), ctx.getString(R.string.gray_134), GrayType.I, true),
        Gray("photo_picker_compress_ratio", ctx.getString(R.string.gray_135), ctx.getString(R.string.gray_136), GrayType.I, true),
        Gray("search_state_trigger", ctx.getString(R.string.gray_137), ctx.getString(R.string.gray_138), GrayType.S, true),
        Gray("model_configs_v1", ctx.getString(R.string.gray_139), ctx.getString(R.string.gray_140), GrayType.S, true),
        Gray("tts_connect_timeout_ms", ctx.getString(R.string.gray_141), ctx.getString(R.string.gray_142), GrayType.I, false),
        Gray("tts_prebuffer_ms", ctx.getString(R.string.gray_143), ctx.getString(R.string.gray_144), GrayType.I, false),
        Gray("tts_resume_buffer_ms", ctx.getString(R.string.gray_145), ctx.getString(R.string.gray_146), GrayType.I, false),
        Gray("tts_resume_max_times", ctx.getString(R.string.gray_147), ctx.getString(R.string.gray_148), GrayType.I, false),
        Gray("tts_resume_max_time_ms", ctx.getString(R.string.gray_149), ctx.getString(R.string.gray_150), GrayType.I, false),
        Gray("tts_resume_interval_ms", ctx.getString(R.string.gray_151), ctx.getString(R.string.gray_152), GrayType.I, false),
        Gray("tts_underrun_timeout_ms", ctx.getString(R.string.gray_153), ctx.getString(R.string.gray_154), GrayType.I, false),
        Gray("thinking_auto_fold_enabled", ctx.getString(R.string.gray_155), ctx.getString(R.string.gray_156), GrayType.B, false),
        Gray("report_http_failure_paths", ctx.getString(R.string.gray_157), ctx.getString(R.string.gray_158), GrayType.S, true),
        Gray("alert", ctx.getString(R.string.gray_159), ctx.getString(R.string.gray_160), GrayType.S, true),
        Gray("banner", ctx.getString(R.string.gray_161), ctx.getString(R.string.gray_162), GrayType.S, true),
        Gray("key_auto_tts_enabled", ctx.getString(R.string.gray_163), ctx.getString(R.string.gray_164), GrayType.B, false),
        Gray("key_tts_voice_id", ctx.getString(R.string.gray_165), ctx.getString(R.string.gray_166), GrayType.S, false),

        /* ── 以下：**宿主有、模块表里没有**的键（从宿主 MMKV / 反编译挖出来的）── */
        Gray("welcome_msg", ctx.getString(R.string.gray_167), ctx.getString(R.string.gray_168), GrayType.S, false),
        Gray("welcome_msg_v1", ctx.getString(R.string.gray_169), ctx.getString(R.string.gray_170), GrayType.S, false),
        Gray("languages", ctx.getString(R.string.gray_171), ctx.getString(R.string.gray_172), GrayType.S, false),
    )
}
