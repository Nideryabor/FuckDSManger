{"ok":true,"data":{"workspaceId":"bpii9fup","editSessionId":"","locator":"dex_class:Lcom/varuns2002/disable_flag_secure/gm/GmDialog;","name":"Lcom/varuns2002/disable_flag_secure/gm/GmDialog;","textSourceKind":"class_smali","targetVersion":"sha256:06e454644ce6c9cc657b63808e84166930e258ae8f938c12772850bdd2e53afa","limit":2000,"truncated":true,"truncatedReason":"window","textWindow":{"text":".class public final Lcom/varuns2002/disable_flag_secure/gm/GmDialog;
.super Ljava/lang/Object;
.source "GmDialog.java"
.field static DESCS:[Ljava/lang/String;

.field static KEYS:[Ljava/lang/String;

.field static NAMES:[Ljava/lang/String;

.field static TYPES:[Ljava/lang/String;

.field static sAct:Landroid/app/Activity;

.field static sDlg:Landroid/app/Dialog;

.field static sKeys:Ljava/util/ArrayList;

.field static sOrig:Ljava/util/ArrayList;

.field static sSaveBtn:Landroid/widget/Button;

.field static sTypes:Ljava/util/ArrayList;

.field static sViews:Ljava/util/ArrayList;
.method static constructor <clinit>()V
    .registers 6

    const/16 v0, 0x53

    new-array v1, v0, [Ljava/lang/String;

    new-array v2, v0, [Ljava/lang/String;

    new-array v3, v0, [Ljava/lang/String;

    const/4 v4, 0x0

    const-string v5, "voice_input_enabled"

    aput-object v5, v1, v4

    const-string v5, "语音输入"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/4 v4, 0x1

    const-string v5, "input_default_voice"

    aput-object v5, v1, v4

    const-string v5, "默认音色"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/4 v4, 0x2

    const-string v5, "input_view_voice_gesture_duration_ms"

    aput-object v5, v1, v4

    const-string v5, "语音手势时长"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/4 v4, 0x3

    const-string v5, "record_empty_detect_time_ms"

    aput-object v5, v1, v4

    const-string v5, "空录音检测"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/4 v4, 0x4

    const-string v5, "record_stop_delay_ms"

    aput-object v5, v1, v4

    const-string v5, "录音停止延迟"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/4 v4, 0x5

    const-string v5, "max_duration_ms"

    aput-object v5, v1, v4

    const-string v5, "最长录音时长"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/4 v4, 0x6

    const-string v5, "opus_bitrate"

    aput-object v5, v1, v4

    const-string v5, "Opus 码率"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/4 v4, 0x7

    const-string v5, "deep_think_button_suffix"

    aput-object v5, v1, v4

    const-string v5, "深度思考后缀"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x8

    const-string v5, "conversation_search_enabled"

    aput-object v5, v1, v4

    const-string v5, "会话搜索"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x9

    const-string v5, "search_state_on_login"

    aput-object v5, v1, v4

    const-string v5, "登录后搜索态"

    aput-object v5, v2, v4

    const-string v5, "t"

    aput-object v5, v3, v4

    const/16 v4, 0xa

    const-string v5, "search_state_on_launch"

    aput-object v5, v1, v4

    const-string v5, "启动后搜索态"

    aput-object v5, v2, v4

    const-string v5, "t"

    aput-object v5, v3, v4

    const/16 v4, 0xb

    const-string v5, "allow_parallel_streams"

    aput-object v5, v1, v4

    const-string v5, "并发流"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0xc

    const-string v5, "interrupt_and_send_enabled"

    aput-object v5, v1, v4

    const-string v5, "打断并发"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0xd

    const-string v5, "allow_file_with_search"

    aput-object v5, v1, v4

    const-string v5, "文件+搜索"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0xe

    const-string v5, "sse_smooth_follow"

    aput-object v5, v1, v4

    const-string v5, "流式平滑跟随"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0xf

    const-string v5, "normal_history_and_file_token_limit"

    aput-object v5, v1, v4

    const-string v5, "普通上下文上限"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x10

    const-string v5, "r1_history_and_file_token_limit"

    aput-object v5, v1, v4

    const-string v5, "R1 上下文上限"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x11

    const-string v5, "completion_request_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "补全超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x12

    const-string v5, "regenerate_request_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "重新生成超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x13

    const-string v5, "hif_max_retry_interval_secs"

    aput-object v5, v1, v4

    const-string v5, "重试间隔(s)"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x14

    const-string v5, "hcaptcha_enabled"

    aput-object v5, v1, v4

    const-string v5, "hCaptcha 验证"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x15

    const-string v5, "enable_google_sign_in_captcha"

    aput-object v5, v1, v4

    const-string v5, "Google 登录验证"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x16

    const-string v5, "one_tap_login_enabled"

    aput-object v5, v1, v4

    const-string v5, "一键登录"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x17

    const-string v5, "hide_assistant_avatar"

    aput-object v5, v1, v4

    const-string v5, "隐藏助手头像"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x18

    const-string v5, "select_text_without_markdown_syntax"

    aput-object v5, v1, v4

    const-string v5, "选中去MD语法"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x19

    const-string v5, "enable_webview_content_report"

    aput-object v5, v1, v4

    const-string v5, "WebView 上报"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x1a

    const-string v5, "picture_compress_format"

    aput-object v5, v1, v4

    const-string v5, "图片压缩格式"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x1b

    const-string v5, "support_center_url"

    aput-object v5, v1, v4

    const-string v5, "客服中心地址"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x1c

    const-string v5, "query_files_time_interval"

    aput-object v5, v1, v4

    const-string v5, "文件轮询间隔"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x1d

    const-string v5, "markdown_top_level_node_limit"

    aput-object v5, v1, v4

    const-string v5, "MD 节点上限"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x1e

    const-string v5, "pow_prefetch_count"

    aput-object v5, v1, v4

    const-string v5, "PoW 预取数"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x1f

    const-string v5, "session_prefetch_count"

    aput-object v5, v1, v4

    const-string v5, "会话预取数"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x20

    const-string v5, "pow_prefetch"

    aput-object v5, v1, v4

    const-string v5, "PoW 预取开关"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x21

    const-string v5, "session_prefetch"

    aput-object v5, v1, v4

    const-string v5, "会话预取开关"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x22

    const-string v5, "continue_request_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "继续生成超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x23

    const-string v5, "resume_request_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "恢复生成超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x24

    const-string v5, "edit_request_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "编辑请求超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x25

    const-string v5, "auto_resume_request_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "自动续传超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x26

    const-string v5, "auto_resume_max_time_ms"

    aput-object v5, v1, v4

    const-string v5, "自动续传窗口"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x27

    const-string v5, "auto_resume_interval_ms"

    aput-object v5, v1, v4

    const-string v5, "自动续传间隔"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x28

    const-string v5, "launch_clean_session_interval_seconds"

    aput-object v5, v1, v4

    const-string v5, "启动清理间隔(s)"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x29

    const-string v5, "pinned_session_limit"

    aput-object v5, v1, v4

    const-string v5, "置顶会话上限"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x2a

    const-string v5, "max_upload_file_size"

    aput-object v5, v1, v4

    const-string v5, "最大上传大小"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x2b

    const-string v5, "max_input_file_count"

    aput-object v5, v1, v4

    const-string v5, "最大输入文件数"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x2c

    const-string v5, "sse_auto_scroll_one_screen"

    aput-object v5, v1, v4

    const-string v5, "自动滚动一屏"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x2d

    const-string v5, "sse_auto_scroll_smooth_stiffness"

    aput-object v5, v1, v4

    const-string v5, "平滑滚动刚度"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x2e

    const-string v5, "optimize_markdown"

    aput-object v5, v1, v4

    const-string v5, "优化 Markdown"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x2f

    const-string v5, "disable_single_dollar_latex"

    aput-object v5, v1, v4

    const-string v5, "禁用单$LaTeX"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x30

    const-string v5, "show_new_chat_button_above_input"

    aput-object v5, v1, v4

    const-string v5, "输入框上方新会话"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x31

    const-string v5, "copy_text_without_markdown_syntax"

    aput-object v5, v1, v4

    const-string v5, "复制去 MD 语法"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x32

    const-string v5, "search_state_on_manually_created_chat"

    aput-object v5, v1, v4

    const-string v5, "手动新建搜索态"

    aput-object v5, v2, v4

    const-string v5, "t"

    aput-object v5, v3, v4

    const/16 v4, 0x33

    const-string v5, "search_state_on_automatically_created_chat"

    aput-object v5, v1, v4

    const-string v5, "自动新建搜索态"

    aput-object v5, v2, v4

    const-string v5, "t"

    aput-object v5, v3, v4

    const/16 v4, 0x34

    const-string v5, "should_use_sm_device_id"

    aput-object v5, v1, v4

    const-string v5, "使用数美设备 ID"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x35

    const-string v5, "dead_link_detection"

    aput-object v5, v1, v4

    const-string v5, "死链检测"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x36

    const-string v5, "gcy_enabled"

    aput-object v5, v1, v4

    const-string v5, "观测云上报"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x37

    const-string v5, "ds_settings_enabled"

    aput-object v5, v1, v4

    const-string v5, "DS 设置开关"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x38

    const-string v5, "volcengine_enabled"

    aput-object v5, v1, v4

    const-string v5, "火山引擎开关"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x39

    const-string v5, "sm_pass_code_type"

    aput-object v5, v1, v4

    const-string v5, "验证码类型"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x3a

    const-string v5, "edit_menu_item_config"

    aput-object v5, v1, v4

    const-string v5, "编辑菜单配置"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x3b

    const-string v5, "files_host"

    aput-object v5, v1, v4

    const-string v5, "文件服务域名"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x3c

    const-string v5, "sm_sdk_host"

    aput-object v5, v1, v4

    const-string v5, "数美 SDK 域名"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x3d

    const-string v5, "android_apk_link"

    aput-object v5, v1, v4

    const-string v5, "安卓下载链接"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x3e

    const-string v5, "kv_remote_settings_support_chat_file_exts"

    aput-object v5, v1, v4

    const-string v5, "支持文件后缀"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x3f

    const-string v5, "kv_remote_settings_pow_header_paths"

    aput-object v5, v1, v4

    const-string v5, "PoW 头路径"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x40

    const-string v5, "kv_remote_settings_authed_pow_functions"

    aput-object v5, v1, v4

    const-string v5, "PoW 功能列表"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x41

    const-string v5, "kv_remote_settings_image_cache_invalidate_before"

    aput-object v5, v1, v4

    const-string v5, "图片缓存失效"

    aput-object v5, v2, v4

    const-string v5, "l"

    aput-object v5, v3, v4

    const/16 v4, 0x42

    const-string v5, "kv_remote_settings_camera_compress_ratio"

    aput-object v5, v1, v4

    const-string v5, "拍照压缩比"

    aput-object v5, v2, v4

    const-string v5, "f"

    aput-object v5, v3, v4

    const/16 v4, 0x43

    const-string v5, "kv_remote_settings_photo_picker_compress_ratio"

    aput-object v5, v1, v4

    const-string v5, "选图压缩比"

    aput-object v5, v2, v4

    const-string v5, "f"

    aput-object v5, v3, v4

    const/16 v4, 0x44

    const-string v5, "kv_remote_settings_search_state_trigger"

    aput-object v5, v1, v4

    const-string v5, "搜索触发器"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x45

    const-string v5, "kv_remote_settings_model_configs_v1"

    aput-object v5, v1, v4

    const-string v5, "模型配置表"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x46

    const-string v5, "tts_connect_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "TTS 连接超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x47

    const-string v5, "tts_prebuffer_ms"

    aput-object v5, v1, v4

    const-string v5, "TTS 预缓冲"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x48

    const-string v5, "tts_resume_buffer_ms"

    aput-object v5, v1, v4

    const-string v5, "TTS 续播缓冲"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x49

    const-string v5, "tts_resume_max_times"

    aput-object v5, v1, v4

    const-string v5, "TTS 续播次数"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x4a

    const-string v5, "tts_resume_max_time_ms"

    aput-object v5, v1, v4

    const-string v5, "TTS 续播窗口"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x4b

    const-string v5, "tts_resume_interval_ms"

    aput-object v5, v1, v4

    const-string v5, "TTS 续播间隔"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x4c

    const-string v5, "tts_underrun_timeout_ms"

    aput-object v5, v1, v4

    const-string v5, "TTS 欠载超时"

    aput-object v5, v2, v4

    const-string v5, "i"

    aput-object v5, v3, v4

    const/16 v4, 0x4d

    const-string v5, "thinking_auto_fold_enabled"

    aput-object v5, v1, v4

    const-string v5, "思考自动折叠"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x4e

    const-string v5, "kv_remote_settings_report_http_failure_paths"

    aput-object v5, v1, v4

    const-string v5, "失败上报路径"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x4f

    const-string v5, "kv_remote_settings_alert"

    aput-object v5, v1, v4

    const-string v5, "公告弹窗"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x50

    const-string v5, "kv_remote_settings_banner"

    aput-object v5, v1, v4

    const-string v5, "横幅"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    const/16 v4, 0x51

    const-string v5, "key_auto_tts_enabled"

    aput-object v5, v1, v4

    const-string v5, "自动朗读总开关"

    aput-object v5, v2, v4

    const-string v5, "b"

    aput-object v5, v3, v4

    const/16 v4, 0x52

    const-string v5, "key_tts_voice_id"

    aput-object v5, v1, v4

    const-string v5, "朗读音色 ID"

    aput-object v5, v2, v4

    const-string v5, "s"

    aput-object v5, v3, v4

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->KEYS:[Ljava/lang/String;

    sput-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->NAMES:[Ljava/lang/String;

    sput-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->TYPES:[Ljava/lang/String;

    const-string v0, "开关：输入框显示麦克风；关闭：完全隐藏语音入口\
语音识别的默认语言/音色标识，如 zh-CN\
按住说话手势的识别时长，单位毫秒\
录到多少毫秒静音就判定为“空录音”\
松手后再录多久才停，防止截断尾音\
单次录音上限，超时自动停止\
语音上传的 Opus 编码码率，越高越清晰也越费流量\
深度思考按钮后面拼的文字，如 R1\
开关：会话内可搜索历史消息\
搜索态：填 on=默认开 / off=默认关，留空=跟随下发\
搜索态：填 on / off，留空=跟随下发（冷启动）\
开关：AI 回复中也能直接发新消息（多流并发）\
开关：发新消息会立即打断当前回复\
开关：联网搜索时可同时带文件一起问\
开关：流式输出时页面平滑跟随；关闭则直接跳到底\
普通模式带上下文的最大 token 数，超了会截断\
R1 深度思考模式的上下文 token 上限\
等 AI 回复的超时毫秒数，超时断开\
点“重新生成”后的请求超时\
请求失败后重试的最大间隔（指数退避上限）\
开关：登录/注册时弹 hCaptcha 人机验证\
开关：Google 登录也要过人机验证\
开关：支持运营商一键登录\
开关：AI 回复旁不显示头像\
开关：选中文本时自动去掉 ** 等 MD 符号\
开关：WebView 内容上报做安全检测\
上传图片压缩成 webp / jpeg 等\
打开“帮助与反馈”跳转的客服地址\
轮询文件解析状态的间隔毫秒\
单条消息最多渲染多少顶层 MD 节点，防卡死\
提前缓存多少个 PoW 令牌\
提前缓存多少个会话\
开关：提前算好 PoW 令牌，发消息更快\
开关：提前拉取会话，列表秒开\
“继续生成”请求的超时毫秒\
“断点续传”请求的超时毫秒\
编辑消息后重发的超时毫秒\
自动续传单次请求的超时毫秒\
断流后最多在多长时间内自动续传\
自动续传的重试间隔毫秒\
启动时多久清理一次空会话（秒）\
最多能置顶几个会话\
单个文件大小上限（字节），超了不让传\
一次最多选几个文件上传\
开关：自动滚动每次只滚一屏\
平滑滚动刚度（整数，默认 50，越大越跟手）\
开关：启用 Markdown 渲染性能优化\
开关：单个 $ 不再当公式，避免误渲染\
开关：输入框上方显示“新对话”按钮\
开关：复制时自动去掉 MD 符号\
搜索态：填 on / off，留空=跟随下发（手动新建会话）\
搜索态：填 on / off，留空=跟随下发（自动新建会话）\
开关：风控使用数美设备指纹 ID\
开关：检测消息里的失效链接\
开关：埋点数据上报到观测云（第三方监控）\
DeepSeek 客户端设置模块总开关\
开关：使用火山引擎相关服务\
短信验证码的样式/类型\
编辑菜单项配置，JSON 字符串\
文件服务接口域名\
数美风控 SDK 的域名\
提示更新时跳转的安装包下载地址\
支持上传的文件后缀白名单，JSON 数组\
需要带 PoW 头的请求路径，JSON 数组\
需要 PoW 校验的功能列表，JSON 数组\
早于此时间戳的图片缓存全部失效（毫秒）\
拍照上传的图片压缩比，0~1 浮点\
从相册选图上传的压缩比，0~1 浮点\
联网搜索触发条件配置，JSON 对象\
模型配置总表，JSON 数组（key 为 model_configs_v1）\
TTS 朗读连接超时毫秒，默认 5000\
TTS 起播前预缓冲毫秒，默认 240\
TTS 续播缓冲毫秒，默认 240\
TTS 最多续播次数，-1 表示无限\
TTS 续播总时长上限毫秒，-1 表示无限\
TTS 续播重试间隔毫秒，默认 1000\
TTS 欠载超时毫秒，默认 1000\
开关：深度思考过程自动折叠\
失败上报的请求路径，JSON 数组\
服务端公告弹窗 JSON，清空即恢复下发值\
服务端横幅 JSON，清空即恢复下发值\
开关：自动朗读（TTS）总开关，默认关，关闭后无视服务端能力\
朗读音色 ID（zh-CN 或具体音色标识）"

    const-string v1, "\
"

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->DESCS:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static addRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 16

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sAct:Landroid/app/Activity;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "kv_"

    invoke-virtual {p2, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_11

    move-object v1, p2

    goto :goto_27

    :cond_11
    const-string v2, "key_"

    invoke-virtual {p2, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1b

    move-object v1, p2

    goto :goto_27

    :cond_1b
    const-string v2, "kv_settings_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_27
    invoke-static {v0, v1, p3}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_46

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "kv_remote_settings_"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3, p3}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :cond_46
    invoke-static {p3, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->norm(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    sget-object v4, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sOrig:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v4, 0x10

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v4, 0xa

    invoke-static {v0, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    const/16 v5, 0xc

    invoke-static {v0, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-virtual {v3, v5, v4, v5, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v4, Landroid/widget/LinearLayout;

    invoke-direct {v4, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v5, 0x1

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v5, Landroid/widget/TextView;

    invoke-direct {v5, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v5, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v6

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;

    invoke-direct {v5, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v5, p4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v6, -0x777778

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v6, 0x41200000

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v6, 0x0

    const/4 v7, -0x2

    const/high16 v8, 0x3f800000

    invoke-direct {v5, v6, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/4 v4, 0x0

    invoke-static {p3}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->isSw(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_c1

    new-instance v5, Landroid/widget/Switch;

    invoke-direct {v5, v0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->asOn(Ljava/lang/String;)Z

    move-result v6

    invoke-virtual {v5, v6}, Landroid/widget/Switch;->setChecked(Z)V

    move-object v4, v5

    goto :goto_e9

    :cond_c1
    new-instance v5, Landroid/widget/EditText;

    invoke-direct {v5, v0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    invoke-virtual {v5, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v7

    invoke-virtual {v5, v7}, Landroid/widget/EditText;->setTextColor(I)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, 0x0

    const/4 v8, -0x2

    const/high16 v9, 0x3f800000

    invoke-direct {v6, v7, v8, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v5, v6}, Landroid/widget/EditText;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const-string v6, "i"

    invoke-virtual {v6, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_e8

    const/4 v6, 0x2

    invoke-virtual {v5, v6}, Landroid/widget/EditText;->setInputType(I)V

    :cond_e8
    move-object v4, v5

    :goto_e9
    new-instance v5, Lcom/varuns2002/disable_flag_secure/gm/GmDirtyTouch;

    invoke-direct {v5}, Lcom/varuns2002/disable_flag_secure/gm/GmDirtyTouch;-><init>()V

    invoke-virtual {v4, v5}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v5, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sKeys:Ljava/util/ArrayList;

    invoke-virtual {v5, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    sget-object v5, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sTypes:Ljava/util/ArrayList;

    invoke-virtual {v5, p3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    sget-object v5, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sViews:Ljava/util/ArrayList;

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    invoke-virtual {p0, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v4, Landroid/view/View;

    invoke-direct {v4, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->line(Landroid/content/Context;)I

    move-result v5

    invoke-virtual {v4, v5}, Landroid/view/View;->setBackgroundColor(I)V

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v6, -0x1

    const/4 v7, 0x1

    invoke-direct {v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

.method static asOn(Ljava/lang/String;)Z
    .registers 3

    const/4 v0, 0x0

    if-eqz p0, :cond_13

    const-string v1, "true"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_d

    const/4 v0, 0x1

    return v0

    :cond_d
    const-string v1, "on"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    :cond_13
    return v0
.end method

.method public static close()V
    .registers 2

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :cond_7
    return-void
.end method

.method static isSw(Ljava/lang/String;)Z
    .registers 2

    const-string v0, "b"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a

    const/4 v0, 0x1

    return v0

    :cond_a
    const-string v0, "t"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static markDirty()V
    .registers 3

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sSaveBtn:Landroid/widget/Button;

    if-eqz v0, :cond_d

    const-string v1, "保存"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setEnabled(Z)V

    :cond_d
    return-void
.end method

.method static norm(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    const-string v0, "b"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_14

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->asOn(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_11

    const-string v0, "true"

    return-object v0

    :cond_11
    const-string v0, "false"

    return-object v0

    :cond_14
    const-string v0, "t"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_28

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->asOn(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_25

    const-string v0, "on"

    return-object v0

    :cond_25
    const-string v0, "off"

    return-object v0

    :cond_28
    return-object p1
.end method

.method public static open()V
    .registers 12

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_7

    return-void

    :cond_7
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v1, :cond_12

    invoke-virtual {v1}, Landroid/app/Dialog;->isShowing()Z

    move-result v2

    if-eqz v2, :cond_12

    return-void

    :cond_12
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sKeys:Ljava/util/ArrayList;

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sOrig:Ljava/util/ArrayList;

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sTypes:Ljava/util/ArrayList;

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sViews:Ljava/util/ArrayList;

    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sDlg:Landroid/app/Dialog;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v3, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v3}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->bg(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/16 v4, 0x18

    invoke-static {v0, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "FuckDSManger"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    sget-object v3, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->tx(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41a00000

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "改完点保存，重启 App 生效；均会自动备份原值，点全部恢复可还原"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->sub(Landroid/content/Context;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41400000

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/4 v3, 0x0

    :goto_a5
    sget-object v4, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->KEYS:[Ljava/lang/String;

    array-length v5, v4

    if-ge v3, v5, :cond_be

    aget-object v5, v4, v3

    sget-object v6, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->NAMES:[Ljava/lang/String;

    aget-object v6, v6, v3

    sget-object v7, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->TYPES:[Ljava/lang/String;

    aget-object v7, v7, v3

    sget-object v8, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->DESCS:[Ljava/lang/String;

    aget-object v8, v8, v3

    invoke-static {v2, v6, v5, v7, v8}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->addRow(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    add-int/lit8 v3, v3, 0x1

    goto :goto_a5

    :cond_be
    new-instance v3, Landroid/widget/ScrollView;

    invoke-direct {v3, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v3, v2}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x1

    const/4 v6, 0x0

    const/high16 v7, 0x3f800000

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v1, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v4, Landroid/widget/LinearLayout;

    invoke-direct {v4, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v5, 0x8

    invoke-static {v0, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v5

    invoke-virtual {v4, v5, v5, v5, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v5, Landroid/widget/Button;

    invoke-direct {v5, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v6, "保存"

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    new-instance v6, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/4 v7, 0x1

    invoke-direct {v6, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    sput-object v5, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sSaveBtn:Landroid/widget/Button;

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;

    invoke-direct {v5, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v6, "全部恢复灰度"

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    new-instance v6, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/4 v7, 0x2

    invoke-direct {v6, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Button;

    invoke-direct {v5, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v6, "关闭"

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    new-instance v6, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/4 v7, 0x3

    invoke-direct {v6, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v5, v6}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sDlg:Landroid/app/Dialog;

    invoke-virtual {v2, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    if-eqz v3, :cond_13f

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V

    :cond_13f
    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method public static resetAll()V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sKeys:Ljava/util/ArrayList;

    if-nez v1, :cond_a

    return-void

    :cond_a
    const/4 v1, 0x0

    :goto_b
    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sKeys:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-ge v1, v3, :cond_27

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    sget-object v4, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sTypes:Ljava/util/ArrayList;

    invoke-virtual {v4, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-static {v0, v3, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->restore(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_b

    :cond_27
    const-string v1, "已全部恢复为服务端灰度值"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static save()V
    .registers 10

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

","startLine":0,"startColumn":0,"endLine":2000,"endColumn":0,"lineTruncated":false,"absoluteStartLine":null,"absoluteEndLine":null},"pagination":{"hasMore":true,"nextCursor":"Aw7QD9APAzBMY29tL3ZhcnVuczIwMDIvZGlzYWJsZV9mbGFnX3NlY3VyZS9nbS9HbURpYWxvZzsB4NQD0A8Arx4","returnedCount":2000,"limitMax":2000,"totalAvailableCount":2161}},"error":null,"nextActions":[{"tool":"mt_apk_continue","purpose":"continue","description":"Continue reading next page","arguments":{"workspaceId":"bpii9fup","editSessionId":"","nextCursor":"Aw7QD9APAzBMY29tL3ZhcnVuczIwMDIvZGlzYWJsZV9mbGFnX3NlY3VyZS9nbS9HbURpYWxvZzsB4NQD0A8Arx4","limit":2000}}]}