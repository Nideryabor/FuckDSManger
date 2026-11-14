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
        Gray("key_voice_available", ctx.fdmStr(R.string.gray_001), ctx.fdmStr(R.string.gray_002), GrayType.B, false),
        Gray("voice_input_enabled", ctx.fdmStr(R.string.gray_003), ctx.fdmStr(R.string.gray_004), GrayType.B, false),
        Gray("input_default_voice", ctx.fdmStr(R.string.gray_005), ctx.fdmStr(R.string.gray_006), GrayType.B, false),
        Gray("input_view_voice_gesture_duration_ms", ctx.fdmStr(R.string.gray_007), ctx.fdmStr(R.string.gray_008), GrayType.I, false),
        Gray("record_empty_detect_time_ms", ctx.fdmStr(R.string.gray_009), ctx.fdmStr(R.string.gray_010), GrayType.I, false),
        Gray("record_stop_delay_ms", ctx.fdmStr(R.string.gray_011), ctx.fdmStr(R.string.gray_012), GrayType.I, false),
        Gray("max_duration_ms", ctx.fdmStr(R.string.gray_013), ctx.fdmStr(R.string.gray_014), GrayType.I, false),
        Gray("opus_bitrate", ctx.fdmStr(R.string.gray_015), ctx.fdmStr(R.string.gray_016), GrayType.I, false),
        Gray("deep_think_button_suffix", ctx.fdmStr(R.string.gray_017), ctx.fdmStr(R.string.gray_018), GrayType.S, false),
        Gray("conversation_search_enabled", ctx.fdmStr(R.string.gray_019), ctx.fdmStr(R.string.gray_020), GrayType.B, false),
        Gray("search_state_on_login", ctx.fdmStr(R.string.gray_021), ctx.fdmStr(R.string.gray_022), GrayType.S, false),
        Gray("search_state_on_launch", ctx.fdmStr(R.string.gray_023), ctx.fdmStr(R.string.gray_024), GrayType.S, false),
        Gray("allow_parallel_streams", ctx.fdmStr(R.string.gray_025), ctx.fdmStr(R.string.gray_026), GrayType.B, false),
        Gray("interrupt_and_send_enabled", ctx.fdmStr(R.string.gray_027), ctx.fdmStr(R.string.gray_028), GrayType.B, false),
        Gray("allow_file_with_search", ctx.fdmStr(R.string.gray_029), ctx.fdmStr(R.string.gray_030), GrayType.B, false),
        // ⛔ 2026-11-14 删除「僵尸键」sse_smooth_follow：
        //    `专题/2026-11-13-宿主2.8.0-数美与灰测核查.md` §2.5 铁证 ——
        //    **2.7.5 和 2.8.0 两版宿主全树都没有 `kv_remote_settings_sse_smooth_follow`
        //    这个字符串常量**（2.7.2 的 MMKV 里有值，但那是服务端下发的历史残留，
        //    宿主自己从来不读它）⇒ 面板上改了也没有任何效果，纯噪音。
        //    （更早的 3.71.0 差集报告就记过 `-sse_smooth_follow`，一直没清。）
        Gray("normal_history_and_file_token_limit", ctx.fdmStr(R.string.gray_033), ctx.fdmStr(R.string.gray_034), GrayType.I, false),
        Gray("r1_history_and_file_token_limit", ctx.fdmStr(R.string.gray_035), ctx.fdmStr(R.string.gray_036), GrayType.I, false),
        Gray("completion_request_timeout_ms", ctx.fdmStr(R.string.gray_037), ctx.fdmStr(R.string.gray_038), GrayType.I, false),
        Gray("regenerate_request_timeout_ms", ctx.fdmStr(R.string.gray_039), ctx.fdmStr(R.string.gray_040), GrayType.I, false),
        Gray("hif_max_retry_interval_secs", ctx.fdmStr(R.string.gray_041), ctx.fdmStr(R.string.gray_042), GrayType.I, false),
        Gray("hcaptcha_enabled", ctx.fdmStr(R.string.gray_043), ctx.fdmStr(R.string.gray_044), GrayType.B, false),
        Gray("enable_google_sign_in_captcha", ctx.fdmStr(R.string.gray_045), ctx.fdmStr(R.string.gray_046), GrayType.B, false),
        Gray("one_tap_login_enabled", ctx.fdmStr(R.string.gray_047), ctx.fdmStr(R.string.gray_048), GrayType.B, false),
        Gray("hide_assistant_avatar", ctx.fdmStr(R.string.gray_049), ctx.fdmStr(R.string.gray_050), GrayType.B, false),
        Gray("select_text_without_markdown_syntax", ctx.fdmStr(R.string.gray_051), ctx.fdmStr(R.string.gray_052), GrayType.B, false),
        Gray("enable_webview_content_report", ctx.fdmStr(R.string.gray_053), ctx.fdmStr(R.string.gray_054), GrayType.B, false),
        Gray("picture_compress_format", ctx.fdmStr(R.string.gray_055), ctx.fdmStr(R.string.gray_056), GrayType.S, false),
        Gray("support_center_url", ctx.fdmStr(R.string.gray_057), ctx.fdmStr(R.string.gray_058), GrayType.S, false),
        Gray("query_files_time_interval", ctx.fdmStr(R.string.gray_059), ctx.fdmStr(R.string.gray_060), GrayType.I, false),
        Gray("markdown_top_level_node_limit", ctx.fdmStr(R.string.gray_061), ctx.fdmStr(R.string.gray_062), GrayType.I, false),
        Gray("pow_prefetch_count", ctx.fdmStr(R.string.gray_063), ctx.fdmStr(R.string.gray_064), GrayType.I, false),
        Gray("session_prefetch_count", ctx.fdmStr(R.string.gray_065), ctx.fdmStr(R.string.gray_066), GrayType.I, false),
        Gray("pow_prefetch", ctx.fdmStr(R.string.gray_067), ctx.fdmStr(R.string.gray_068), GrayType.B, false),
        Gray("session_prefetch", ctx.fdmStr(R.string.gray_069), ctx.fdmStr(R.string.gray_070), GrayType.B, false),
        Gray("continue_request_timeout_ms", ctx.fdmStr(R.string.gray_071), ctx.fdmStr(R.string.gray_072), GrayType.I, false),
        Gray("resume_request_timeout_ms", ctx.fdmStr(R.string.gray_073), ctx.fdmStr(R.string.gray_074), GrayType.I, false),
        Gray("edit_request_timeout_ms", ctx.fdmStr(R.string.gray_075), ctx.fdmStr(R.string.gray_076), GrayType.I, false),
        Gray("auto_resume_request_timeout_ms", ctx.fdmStr(R.string.gray_077), ctx.fdmStr(R.string.gray_078), GrayType.I, false),
        Gray("auto_resume_max_time_ms", ctx.fdmStr(R.string.gray_079), ctx.fdmStr(R.string.gray_080), GrayType.I, false),
        Gray("auto_resume_interval_ms", ctx.fdmStr(R.string.gray_081), ctx.fdmStr(R.string.gray_082), GrayType.I, false),
        Gray("launch_clean_session_interval_seconds", ctx.fdmStr(R.string.gray_083), ctx.fdmStr(R.string.gray_084), GrayType.I, false),
        Gray("pinned_session_limit", ctx.fdmStr(R.string.gray_085), ctx.fdmStr(R.string.gray_086), GrayType.I, false),
        Gray("max_upload_file_size", ctx.fdmStr(R.string.gray_087), ctx.fdmStr(R.string.gray_088), GrayType.I, false),
        Gray("max_input_file_count", ctx.fdmStr(R.string.gray_089), ctx.fdmStr(R.string.gray_090), GrayType.I, false),
        Gray("sse_auto_scroll_one_screen", ctx.fdmStr(R.string.gray_091), ctx.fdmStr(R.string.gray_092), GrayType.B, false),
        Gray("sse_auto_scroll_smooth_stiffness", ctx.fdmStr(R.string.gray_093), ctx.fdmStr(R.string.gray_094), GrayType.I, false),
        Gray("optimize_markdown", ctx.fdmStr(R.string.gray_095), ctx.fdmStr(R.string.gray_096), GrayType.B, false),
        Gray("disable_single_dollar_latex", "禁用单\$LaTeX", "开关：单个 \$ 不再当公式，避免误渲染", GrayType.B, false),
        Gray("show_new_chat_button_above_input", ctx.fdmStr(R.string.gray_097), ctx.fdmStr(R.string.gray_098), GrayType.B, false),
        Gray("copy_text_without_markdown_syntax", ctx.fdmStr(R.string.gray_099), ctx.fdmStr(R.string.gray_100), GrayType.B, false),
        Gray("search_state_on_manually_created_chat", ctx.fdmStr(R.string.gray_101), ctx.fdmStr(R.string.gray_102), GrayType.S, false),
        Gray("search_state_on_automatically_created_chat", ctx.fdmStr(R.string.gray_103), ctx.fdmStr(R.string.gray_104), GrayType.S, false),
        Gray("should_use_sm_device_id", ctx.fdmStr(R.string.gray_105), ctx.fdmStr(R.string.gray_106), GrayType.B, false),
        Gray("dead_link_detection", ctx.fdmStr(R.string.gray_107), ctx.fdmStr(R.string.gray_108), GrayType.B, false),
        Gray("gcy_enabled", ctx.fdmStr(R.string.gray_109), ctx.fdmStr(R.string.gray_110), GrayType.B, false),
        Gray("ds_settings_enabled", ctx.fdmStr(R.string.gray_111), ctx.fdmStr(R.string.gray_112), GrayType.B, false),
        Gray("volcengine_enabled", ctx.fdmStr(R.string.gray_113), ctx.fdmStr(R.string.gray_114), GrayType.S, false),
        Gray("sm_pass_code_type", ctx.fdmStr(R.string.gray_115), ctx.fdmStr(R.string.gray_116), GrayType.S, false),
        Gray("edit_menu_item_config", ctx.fdmStr(R.string.gray_117), ctx.fdmStr(R.string.gray_118), GrayType.I, false),
        Gray("files_host", ctx.fdmStr(R.string.gray_119), ctx.fdmStr(R.string.gray_120), GrayType.S, false),
        Gray("sm_sdk_host", ctx.fdmStr(R.string.gray_121), ctx.fdmStr(R.string.gray_122), GrayType.S, false),
        Gray("android_apk_link", ctx.fdmStr(R.string.gray_123), ctx.fdmStr(R.string.gray_124), GrayType.S, false),
        Gray("support_chat_file_exts", ctx.fdmStr(R.string.gray_125), ctx.fdmStr(R.string.gray_126), GrayType.S, true),
        // ⛔ 2026-11-14 删除「僵尸键」pow_header_paths（同上，两版宿主全树 0 命中，
        //    连带把 FdmBridge.AB_IDS 里那条 vid 也删了 —— 灰度表里没这个键，
        //    `abIdPatch` 的分支就永远走不到，留着只会误导下一个人）。
        Gray("authed_pow_functions", ctx.fdmStr(R.string.gray_129), ctx.fdmStr(R.string.gray_130), GrayType.S, true),
        Gray("image_cache_invalidate_before", ctx.fdmStr(R.string.gray_131), ctx.fdmStr(R.string.gray_132), GrayType.L, true),
        Gray("camera_compress_ratio", ctx.fdmStr(R.string.gray_133), ctx.fdmStr(R.string.gray_134), GrayType.I, true),
        Gray("photo_picker_compress_ratio", ctx.fdmStr(R.string.gray_135), ctx.fdmStr(R.string.gray_136), GrayType.I, true),
        Gray("search_state_trigger", ctx.fdmStr(R.string.gray_137), ctx.fdmStr(R.string.gray_138), GrayType.S, true),
        Gray("model_configs_v1", ctx.fdmStr(R.string.gray_139), ctx.fdmStr(R.string.gray_140), GrayType.S, true),
        Gray("tts_connect_timeout_ms", ctx.fdmStr(R.string.gray_141), ctx.fdmStr(R.string.gray_142), GrayType.I, false),
        Gray("tts_prebuffer_ms", ctx.fdmStr(R.string.gray_143), ctx.fdmStr(R.string.gray_144), GrayType.I, false),
        Gray("tts_resume_buffer_ms", ctx.fdmStr(R.string.gray_145), ctx.fdmStr(R.string.gray_146), GrayType.I, false),
        Gray("tts_resume_max_times", ctx.fdmStr(R.string.gray_147), ctx.fdmStr(R.string.gray_148), GrayType.I, false),
        Gray("tts_resume_max_time_ms", ctx.fdmStr(R.string.gray_149), ctx.fdmStr(R.string.gray_150), GrayType.I, false),
        Gray("tts_resume_interval_ms", ctx.fdmStr(R.string.gray_151), ctx.fdmStr(R.string.gray_152), GrayType.I, false),
        Gray("tts_underrun_timeout_ms", ctx.fdmStr(R.string.gray_153), ctx.fdmStr(R.string.gray_154), GrayType.I, false),
        Gray("thinking_auto_fold_enabled", ctx.fdmStr(R.string.gray_155), ctx.fdmStr(R.string.gray_156), GrayType.B, false),
        Gray("report_http_failure_paths", ctx.fdmStr(R.string.gray_157), ctx.fdmStr(R.string.gray_158), GrayType.S, true),
        Gray("alert", ctx.fdmStr(R.string.gray_159), ctx.fdmStr(R.string.gray_160), GrayType.S, true),
        Gray("banner", ctx.fdmStr(R.string.gray_161), ctx.fdmStr(R.string.gray_162), GrayType.S, true),
        Gray("key_auto_tts_enabled", ctx.fdmStr(R.string.gray_163), ctx.fdmStr(R.string.gray_164), GrayType.B, false),
        Gray("key_tts_voice_id", ctx.fdmStr(R.string.gray_165), ctx.fdmStr(R.string.gray_166), GrayType.S, false),

        /* ── 以下：**宿主有、模块表里没有**的键（从宿主 MMKV / 反编译挖出来的）── */
        Gray("welcome_msg", ctx.fdmStr(R.string.gray_167), ctx.fdmStr(R.string.gray_168), GrayType.S, false),
        Gray("welcome_msg_v1", ctx.fdmStr(R.string.gray_169), ctx.fdmStr(R.string.gray_170), GrayType.S, false),
        Gray("languages", ctx.fdmStr(R.string.gray_171), ctx.fdmStr(R.string.gray_172), GrayType.S, false),
    )
}
