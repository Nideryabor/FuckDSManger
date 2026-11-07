.class public final Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;
.super Ljava/lang/Object;
.source "FdmBridge.java"


# static fields
.field public static final ACTION_APPLIED:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_APPLIED"

.field public static final ACTION_PUSH:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_PUSH"

.field public static final ACTION_REQ:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_REQ"

.field public static final ACTION_STATE:Ljava/lang/String; = "com.little_femaleboy.fdm.CONFIG_STATE"

.field private static final BAK_NONE:Ljava/lang/String; = "\u0000__gm_none__"

.field private static final GM:Ljava/lang/String; = "com.nidyaber.fuckdsmanger.gm."

.field private static final GRAY:[[Ljava/lang/String;

.field public static final MODULE_PKG:Ljava/lang/String; = "com.little_femaleboy.cannot_show.the_big_won_whale"

.field private static final OUR_KEYS:[Ljava/lang/String;

.field private static lastData:Ljava/lang/String; = null

.field private static volatile sBubbleCacheLogged:Z = false

.field private static volatile sGotConfig:Z = false

.field private static volatile sPins:Ljava/util/HashMap; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sPinsSynced:Z = false

.field private static sRecv:Landroid/content/BroadcastReceiver; = null

.field private static volatile sRecvInstalled:Z = false

.field private static volatile sToken:Ljava/lang/String; = null

.field private static volatile sTried:Z = false


# direct methods
.method static constructor <clinit>()V
    .registers 86

    .line 2194
    const-string v29, "fuckds_prompt_feature"

    const-string v30, "fuckds_welcome_msg"

    const-string v1, "fuckds_gm"

    const-string v2, "fuckds_bubble_on"

    const-string v3, "fuckds_ububble_on"

    const-string v4, "fuckds_bubble_color"

    const-string v5, "fuckds_bubble_radius"

    const-string v6, "fuckds_bubble_alpha"

    const-string v7, "fuckds_bubble_maxz"

    const-string v8, "fuckds_bubble_img"

    const-string v9, "fuckds_ububble_color"

    const-string v10, "fuckds_ububble_radius"

    const-string v11, "fuckds_ububble_img"

    const-string v12, "fuckds_bg_on"

    const-string v13, "fuckds_bg_mode"

    const-string v14, "fuckds_bg_alpha"

    const-string v15, "fuckds_bg_grad"

    const-string v16, "fuckds_bg_crop"

    const-string v17, "fuckds_bg_pos"

    const-string v18, "fuckds_bg_dir"

    const-string v19, "fuckds_bg_rot"

    const-string v20, "fuckds_bg_cam"

    const-string v21, "fuckds_model_switch"

    const-string v22, "fuckds_suggest_on"

    const-string v23, "fuckds_suggest_ai"

    const-string v24, "fuckds_suggest_count"

    const-string v25, "fuckds_suggest_text"

    const-string v26, "fuckds_device_on"

    const-string v27, "fuckds_device_id"

    const-string v28, "fuckds_dev_ask3"

    filled-new-array/range {v1 .. v30}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->OUR_KEYS:[Ljava/lang/String;

    .line 2211
    const-string v0, "key_voice_available"

    const-string v1, "b"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v2

    const-string v0, "kv_remote_settings_voice_input_enabled"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v3

    const-string v0, "kv_remote_settings_input_default_voice"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v4

    const-string v0, "kv_remote_settings_input_view_voice_gesture_duration_ms"

    const-string v5, "i"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    const-string v6, "kv_remote_settings_record_empty_detect_time_ms"

    filled-new-array {v6, v5}, [Ljava/lang/String;

    move-result-object v6

    const-string v7, "kv_remote_settings_record_stop_delay_ms"

    filled-new-array {v7, v5}, [Ljava/lang/String;

    move-result-object v7

    const-string v8, "kv_remote_settings_max_duration_ms"

    filled-new-array {v8, v5}, [Ljava/lang/String;

    move-result-object v8

    const-string v9, "kv_remote_settings_opus_bitrate"

    filled-new-array {v9, v5}, [Ljava/lang/String;

    move-result-object v9

    const-string v10, "kv_remote_settings_deep_think_button_suffix"

    const-string v11, "s"

    filled-new-array {v10, v11}, [Ljava/lang/String;

    move-result-object v10

    const-string v12, "kv_remote_settings_conversation_search_enabled"

    filled-new-array {v12, v1}, [Ljava/lang/String;

    move-result-object v12

    const-string v13, "kv_remote_settings_search_state_on_login"

    filled-new-array {v13, v11}, [Ljava/lang/String;

    move-result-object v13

    const-string v14, "kv_remote_settings_search_state_on_launch"

    filled-new-array {v14, v11}, [Ljava/lang/String;

    move-result-object v14

    const-string v15, "kv_remote_settings_allow_parallel_streams"

    filled-new-array {v15, v1}, [Ljava/lang/String;

    move-result-object v15

    move-object/from16 v16, v0

    const-string v0, "kv_remote_settings_interrupt_and_send_enabled"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v17, v0

    const-string v0, "kv_remote_settings_allow_file_with_search"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v18, v0

    const-string v0, "kv_remote_settings_sse_smooth_follow"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v19, v0

    const-string v0, "kv_remote_settings_normal_history_and_file_token_limit"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v20, v0

    const-string v0, "kv_remote_settings_r1_history_and_file_token_limit"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v21, v0

    const-string v0, "kv_remote_settings_completion_request_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v22, v0

    const-string v0, "kv_remote_settings_regenerate_request_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v23, v0

    const-string v0, "kv_remote_settings_hif_max_retry_interval_secs"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v24, v0

    const-string v0, "kv_remote_settings_hcaptcha_enabled"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v25, v0

    const-string v0, "kv_remote_settings_enable_google_sign_in_captcha"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v26, v0

    const-string v0, "kv_remote_settings_one_tap_login_enabled"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v27, v0

    const-string v0, "kv_remote_settings_hide_assistant_avatar"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v28, v0

    const-string v0, "kv_remote_settings_select_text_without_markdown_syntax"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v29, v0

    const-string v0, "kv_remote_settings_enable_webview_content_report"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v30, v0

    const-string v0, "kv_remote_settings_picture_compress_format"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v31, v0

    const-string v0, "kv_remote_settings_support_center_url"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v32, v0

    const-string v0, "kv_remote_settings_query_files_time_interval"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v33, v0

    const-string v0, "kv_remote_settings_markdown_top_level_node_limit"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v34, v0

    const-string v0, "kv_remote_settings_pow_prefetch_count"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v35, v0

    const-string v0, "kv_remote_settings_session_prefetch_count"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v36, v0

    const-string v0, "kv_remote_settings_pow_prefetch"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v37, v0

    const-string v0, "kv_remote_settings_session_prefetch"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v38, v0

    const-string v0, "kv_remote_settings_continue_request_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v39, v0

    const-string v0, "kv_remote_settings_resume_request_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v40, v0

    const-string v0, "kv_remote_settings_edit_request_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v41, v0

    const-string v0, "kv_remote_settings_auto_resume_request_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v42, v0

    const-string v0, "kv_remote_settings_auto_resume_max_time_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v43, v0

    const-string v0, "kv_remote_settings_auto_resume_interval_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v44, v0

    const-string v0, "kv_remote_settings_launch_clean_session_interval_seconds"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v45, v0

    const-string v0, "kv_remote_settings_pinned_session_limit"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v46, v0

    const-string v0, "kv_remote_settings_max_upload_file_size"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v47, v0

    const-string v0, "kv_remote_settings_max_input_file_count"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v48, v0

    const-string v0, "kv_remote_settings_sse_auto_scroll_one_screen"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v49, v0

    const-string v0, "kv_remote_settings_sse_auto_scroll_smooth_stiffness"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v50, v0

    const-string v0, "kv_remote_settings_optimize_markdown"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v51, v0

    const-string v0, "kv_remote_settings_disable_single_dollar_latex"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v52, v0

    const-string v0, "kv_remote_settings_show_new_chat_button_above_input"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v53, v0

    const-string v0, "kv_remote_settings_copy_text_without_markdown_syntax"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v54, v0

    const-string v0, "kv_remote_settings_search_state_on_manually_created_chat"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v55, v0

    const-string v0, "kv_remote_settings_search_state_on_automatically_created_chat"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v56, v0

    const-string v0, "kv_remote_settings_should_use_sm_device_id"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v57, v0

    const-string v0, "kv_remote_settings_dead_link_detection"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v58, v0

    const-string v0, "kv_remote_settings_gcy_enabled"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v59, v0

    const-string v0, "kv_remote_settings_ds_settings_enabled"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v60, v0

    const-string v0, "kv_remote_settings_volcengine_enabled"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v61, v0

    const-string v0, "kv_remote_settings_sm_pass_code_type"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v62, v0

    const-string v0, "kv_remote_settings_edit_menu_item_config"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v63, v0

    const-string v0, "kv_remote_settings_files_host"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v64, v0

    const-string v0, "kv_remote_settings_sm_sdk_host"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v65, v0

    const-string v0, "kv_remote_settings_android_apk_link"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v66, v0

    const-string v0, "support_chat_file_exts"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v67, v0

    const-string v0, "pow_header_paths"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v68, v0

    const-string v0, "authed_pow_functions"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v69, v0

    const-string v0, "image_cache_invalidate_before"

    move-object/from16 v70, v2

    const-string v2, "l"

    filled-new-array {v0, v2}, [Ljava/lang/String;

    move-result-object v0

    const-string v2, "camera_compress_ratio"

    filled-new-array {v2, v5}, [Ljava/lang/String;

    move-result-object v2

    move-object/from16 v71, v0

    const-string v0, "photo_picker_compress_ratio"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v72, v0

    const-string v0, "search_state_trigger"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v73, v0

    const-string v0, "model_configs_v1"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v74, v0

    const-string v0, "kv_remote_settings_tts_connect_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v75, v0

    const-string v0, "kv_remote_settings_tts_prebuffer_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v76, v0

    const-string v0, "kv_remote_settings_tts_resume_buffer_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v77, v0

    const-string v0, "kv_remote_settings_tts_resume_max_times"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v78, v0

    const-string v0, "kv_remote_settings_tts_resume_max_time_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v79, v0

    const-string v0, "kv_remote_settings_tts_resume_interval_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v80, v0

    const-string v0, "kv_remote_settings_tts_underrun_timeout_ms"

    filled-new-array {v0, v5}, [Ljava/lang/String;

    move-result-object v0

    const-string v5, "kv_remote_settings_thinking_auto_fold_enabled"

    filled-new-array {v5, v1}, [Ljava/lang/String;

    move-result-object v5

    move-object/from16 v81, v0

    const-string v0, "report_http_failure_paths"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v82, v0

    const-string v0, "alert"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v83, v0

    const-string v0, "banner"

    filled-new-array {v0, v11}, [Ljava/lang/String;

    move-result-object v0

    move-object/from16 v84, v0

    const-string v0, "kv_remote_settings_key_auto_tts_enabled"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    const-string v1, "kv_remote_settings_key_tts_voice_id"

    filled-new-array {v1, v11}, [Ljava/lang/String;

    move-result-object v85

    move-object v11, v12

    move-object v12, v13

    move-object v13, v14

    move-object v14, v15

    move-object/from16 v15, v17

    move-object/from16 v17, v19

    move-object/from16 v19, v21

    move-object/from16 v21, v23

    move-object/from16 v23, v25

    move-object/from16 v25, v27

    move-object/from16 v27, v29

    move-object/from16 v29, v31

    move-object/from16 v31, v33

    move-object/from16 v33, v35

    move-object/from16 v35, v37

    move-object/from16 v37, v39

    move-object/from16 v39, v41

    move-object/from16 v41, v43

    move-object/from16 v43, v45

    move-object/from16 v45, v47

    move-object/from16 v47, v49

    move-object/from16 v49, v51

    move-object/from16 v51, v53

    move-object/from16 v53, v55

    move-object/from16 v55, v57

    move-object/from16 v57, v59

    move-object/from16 v59, v61

    move-object/from16 v61, v63

    move-object/from16 v63, v65

    move-object/from16 v65, v67

    move-object/from16 v67, v69

    move-object/from16 v69, v2

    move-object/from16 v2, v70

    move-object/from16 v70, v72

    move-object/from16 v72, v74

    move-object/from16 v74, v76

    move-object/from16 v76, v78

    move-object/from16 v78, v80

    move-object/from16 v80, v5

    move-object/from16 v5, v16

    move-object/from16 v16, v18

    move-object/from16 v18, v20

    move-object/from16 v20, v22

    move-object/from16 v22, v24

    move-object/from16 v24, v26

    move-object/from16 v26, v28

    move-object/from16 v28, v30

    move-object/from16 v30, v32

    move-object/from16 v32, v34

    move-object/from16 v34, v36

    move-object/from16 v36, v38

    move-object/from16 v38, v40

    move-object/from16 v40, v42

    move-object/from16 v42, v44

    move-object/from16 v44, v46

    move-object/from16 v46, v48

    move-object/from16 v48, v50

    move-object/from16 v50, v52

    move-object/from16 v52, v54

    move-object/from16 v54, v56

    move-object/from16 v56, v58

    move-object/from16 v58, v60

    move-object/from16 v60, v62

    move-object/from16 v62, v64

    move-object/from16 v64, v66

    move-object/from16 v66, v68

    move-object/from16 v68, v71

    move-object/from16 v71, v73

    move-object/from16 v73, v75

    move-object/from16 v75, v77

    move-object/from16 v77, v79

    move-object/from16 v79, v81

    move-object/from16 v81, v82

    move-object/from16 v82, v83

    move-object/from16 v83, v84

    move-object/from16 v84, v0

    filled-new-array/range {v2 .. v85}, [[Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->GRAY:[[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 83
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 44
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->applyPushed(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method static synthetic access$100(Landroid/content/Context;)Z
    .registers 1

    .line 44
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->syncPins(Landroid/content/Context;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$200()Z
    .registers 1

    .line 44
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sGotConfig:Z

    return v0
.end method

.method private static alias(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 1018
    const-string v0, "ui_nick"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "fuckds_nick"

    if-nez v0, :cond_1a

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1a

    const-string v0, "ui_name"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_19

    goto :goto_1a

    :cond_19
    return-object p0

    :cond_1a
    :goto_1a
    return-object v1
.end method

.method static allKeysOf(Landroid/content/SharedPreferences;)Ljava/util/List;
    .registers 19
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/SharedPreferences;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    move-object/from16 v1, p0

    .line 740
    const-string v2, "allKeys"

    const-string v3, ""

    const-string v4, " \u4e2a\u952e"

    .line 0
    const-string v5, " \u00b7 \u4f8b\uff1a"

    const-string v0, "\u3010FdmBridge\u3011allKeysOf\uff1a\u8d70 private allKeys(handle, true) \u21d2 "

    if-nez v1, :cond_16

    .line 741
    const-string v0, "\u3010FdmBridge\u3011allKeysOf\uff1asp == null"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 742
    sget-object v0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object v0

    :cond_16
    const/4 v6, 0x1

    const/4 v7, 0x0

    .line 758
    :try_start_18
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v8

    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->findNativeHandle(Ljava/lang/Class;)Ljava/lang/reflect/Field;

    move-result-object v8

    if-nez v8, :cond_28

    .line 760
    const-string v0, "\u3010FdmBridge\u3011allKeysOf\uff1a\u627e\u4e0d\u5230 nativeHandle \u5b57\u6bb5"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_9a

    .line 762
    :cond_28
    invoke-virtual {v8, v1}, Ljava/lang/reflect/Field;->getLong(Ljava/lang/Object;)J

    move-result-wide v8

    .line 763
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v10

    const/4 v11, 0x2

    new-array v11, v11, [Ljava/lang/Class;

    sget-object v12, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v12, v11, v7

    sget-object v12, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v12, v11, v6

    .line 764
    invoke-virtual {v10, v2, v11}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v10

    .line 765
    invoke-virtual {v10, v6}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 766
    invoke-static {v8, v9}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v8

    sget-object v9, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    filled-new-array {v8, v9}, [Ljava/lang/Object;

    move-result-object v8

    invoke-virtual {v10, v1, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    .line 767
    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asStrList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v8

    if-eqz v8, :cond_9a

    .line 769
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 770
    invoke-interface {v8}, Ljava/util/List;->size()I

    move-result v0

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 771
    invoke-interface {v8}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_6d

    move-object v0, v3

    goto :goto_7d

    :cond_6d
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sample(Ljava/util/List;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_7d
    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 769
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_87
    .catchall {:try_start_18 .. :try_end_87} :catchall_88

    return-object v8

    :catchall_88
    move-exception v0

    .line 776
    new-instance v8, Ljava/lang/StringBuilder;

    const-string v9, "\u3010FdmBridge\u3011allKeysOf\uff1aprivate allKeys \u8fd9\u6761\u8def\u4e0d\u901a \u21d2 "

    invoke-direct {v8, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_9a
    :goto_9a
    const/4 v8, 0x0

    .line 782
    :try_start_9b
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    new-array v9, v7, [Ljava/lang/Class;

    invoke-virtual {v0, v2, v8}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0
    :try_end_a5
    .catchall {:try_start_9b .. :try_end_a5} :catchall_a7

    move-object v2, v0

    goto :goto_a8

    :catchall_a7
    move-object v2, v8

    .line 789
    :goto_a8
    :try_start_a8
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v0
    :try_end_b0
    .catchall {:try_start_a8 .. :try_end_b0} :catchall_b2

    move-object v9, v0

    goto :goto_c6

    :catchall_b2
    move-exception v0

    .line 791
    new-array v9, v7, [Ljava/lang/reflect/Method;

    .line 792
    new-instance v10, Ljava/lang/StringBuilder;

    const-string v11, "\u3010FdmBridge\u3011allKeysOf\uff1agetMethods() \u5931\u8d25 \u21d2 "

    invoke-direct {v10, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 798
    :goto_c6
    const-class v10, [Ljava/lang/String;

    if-nez v2, :cond_ed

    .line 800
    array-length v0, v9

    move v11, v7

    :goto_cc
    if-ge v11, v0, :cond_ed

    aget-object v12, v9, v11

    .line 801
    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v13

    array-length v13, v13

    if-eqz v13, :cond_d8

    goto :goto_e9

    .line 802
    :cond_d8
    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v13

    if-eq v13, v10, :cond_df

    goto :goto_e9

    .line 803
    :cond_df
    invoke-virtual {v12}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v13

    invoke-static {v13}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v13

    if-eqz v13, :cond_ec

    :goto_e9
    add-int/lit8 v11, v11, 0x1

    goto :goto_cc

    :cond_ec
    move-object v2, v12

    .line 807
    :cond_ed
    const-string v11, "\u3010FdmBridge\u3011allKeysOf\uff1a\u8d70 "

    if-nez v2, :cond_1a7

    .line 809
    array-length v12, v9

    move v13, v7

    :goto_f3
    if-ge v13, v12, :cond_1a7

    aget-object v14, v9, v13

    .line 810
    invoke-virtual {v14}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v0

    .line 811
    array-length v15, v0

    if-ne v15, v6, :cond_1a1

    invoke-virtual {v14}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v15

    if-eq v15, v10, :cond_106

    goto/16 :goto_1a1

    .line 812
    :cond_106
    invoke-virtual {v14}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v15

    invoke-static {v15}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v15

    if-eqz v15, :cond_112

    goto/16 :goto_1a1

    .line 813
    :cond_112
    aget-object v15, v0, v7

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v15, v6, :cond_120

    aget-object v6, v0, v7

    sget-object v15, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-eq v6, v15, :cond_120

    goto/16 :goto_1a1

    .line 815
    :cond_120
    :try_start_120
    aget-object v0, v0, v7

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v0, v6, :cond_12b

    .line 816
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    goto :goto_131

    :cond_12b
    const-wide/16 v16, 0x0

    invoke-static/range {v16 .. v17}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    :goto_131
    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v0

    .line 815
    invoke-virtual {v14, v1, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 817
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asStrList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    if-eqz v0, :cond_1a1

    .line 819
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v14}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sig(Ljava/lang/reflect/Method;)Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v6, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v15, " \u21d2 "

    invoke-virtual {v6, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v15

    invoke-virtual {v6, v15}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 820
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v15

    if-eqz v15, :cond_165

    move-object v7, v3

    goto :goto_178

    :cond_165
    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v15, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sample(Ljava/util/List;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v15, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    :goto_178
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 819
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_182
    .catchall {:try_start_120 .. :try_end_182} :catchall_183

    return-object v0

    :catchall_183
    move-exception v0

    .line 824
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "\u3010FdmBridge\u3011allKeysOf\uff1a\u8bd5 "

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v14}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sig(Ljava/lang/reflect/Method;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " \u5931\u8d25 \u21d2 "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_1a1
    :goto_1a1
    add-int/lit8 v13, v13, 0x1

    const/4 v6, 0x1

    const/4 v7, 0x0

    goto/16 :goto_f3

    :cond_1a7
    if-nez v2, :cond_239

    .line 831
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v6, "\u3010FdmBridge\u3011allKeysOf\uff1aMMKV \u516c\u5f00\u65b9\u6cd5\u5171 "

    invoke-direct {v0, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    array-length v6, v9

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " \u4e2a \u00b7 \u8fd4\u56de String[] \u7684\uff1a"

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 833
    array-length v0, v9

    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_1c3
    const-string v12, "     \u00b7 "

    if-ge v6, v0, :cond_1e8

    aget-object v13, v9, v6

    .line 834
    invoke-virtual {v13}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v14

    if-eq v14, v10, :cond_1d0

    goto :goto_1e5

    .line 835
    :cond_1d0
    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14, v12}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v13}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sig(Ljava/lang/reflect/Method;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v14, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-static {v12}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    add-int/lit8 v7, v7, 0x1

    :goto_1e5
    add-int/lit8 v6, v6, 0x1

    goto :goto_1c3

    .line 838
    :cond_1e8
    const-string v0, "     \u00b7\uff08\u4e00\u4e2a\u90fd\u6ca1\u6709\uff09"

    if-nez v7, :cond_1ef

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 839
    :cond_1ef
    const-string v6, "\u3010FdmBridge\u3011allKeysOf\uff1a\u65e0\u53c2 \u00b7 \u8fd4\u56de String/Collection/Map \u7684\uff1a"

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 841
    array-length v6, v9

    const/4 v7, 0x0

    const/16 v16, 0x0

    :goto_1f8
    if-ge v7, v6, :cond_234

    aget-object v10, v9, v7

    .line 842
    invoke-virtual {v10}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v13

    array-length v13, v13

    if-eqz v13, :cond_204

    goto :goto_231

    .line 843
    :cond_204
    invoke-virtual {v10}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v13

    .line 844
    const-class v14, Ljava/lang/String;

    if-eq v13, v14, :cond_21c

    const-class v14, Ljava/util/Collection;

    .line 845
    invoke-virtual {v14, v13}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v14

    if-nez v14, :cond_21c

    const-class v14, Ljava/util/Map;

    .line 846
    invoke-virtual {v14, v13}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v13

    if-eqz v13, :cond_231

    .line 847
    :cond_21c
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13, v12}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v10}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sig(Ljava/lang/reflect/Method;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v13, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    add-int/lit8 v16, v16, 0x1

    :cond_231
    :goto_231
    add-int/lit8 v7, v7, 0x1

    goto :goto_1f8

    :cond_234
    if-nez v16, :cond_239

    .line 851
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_239
    if-eqz v2, :cond_2a6

    .line 856
    :try_start_23b
    invoke-virtual {v2, v1, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 857
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asStrList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    if-eqz v0, :cond_2a6

    .line 859
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "() \u21d2 "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 860
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_26a

    goto :goto_27d

    :cond_26a
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sample(Ljava/util/List;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    :goto_27d
    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 859
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_287
    .catchall {:try_start_23b .. :try_end_287} :catchall_288

    return-object v0

    :catchall_288
    move-exception v0

    .line 864
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v5, "\u3010FdmBridge\u3011allKeysOf\uff1a\u8c03\u7528 "

    invoke-direct {v3, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "() \u5931\u8d25 \u21d2 "

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 870
    :cond_2a6
    :try_start_2a6
    invoke-interface {v1}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    if-eqz v0, :cond_2e3

    .line 872
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u3010FdmBridge\u3011allKeysOf\uff1a\u8d70 getAll() \u21d2 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/Map;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 873
    new-instance v1, Ljava/util/ArrayList;

    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V
    :try_end_2d0
    .catchall {:try_start_2a6 .. :try_end_2d0} :catchall_2d1

    return-object v1

    :catchall_2d1
    move-exception v0

    .line 876
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u3010FdmBridge\u3011allKeysOf\uff1agetAll() \u4e5f\u4e0d\u53ef\u7528 \u21d2 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 879
    :cond_2e3
    const-string v0, "\u3010FdmBridge\u3011allKeysOf\uff1a\u26a0\ufe0f \u4e09\u6761\u8def\u90fd\u4e0d\u901a\uff0c\u8fd4\u56de\u7a7a\u8868"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 880
    sget-object v0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object v0
.end method

.method private static anyValue(Landroid/content/SharedPreferences;Ljava/lang/String;)Ljava/lang/Object;
    .registers 6

    .line 1154
    const-string v0, "\u0001__none__"

    :try_start_2
    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 1155
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0
    :try_end_a
    .catchall {:try_start_2 .. :try_end_a} :catchall_d

    if-nez v0, :cond_d

    return-object v1

    :catchall_d
    :cond_d
    const v0, -0x7ffffff9

    .line 1160
    :try_start_10
    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    if-eq v1, v0, :cond_1b

    .line 1161
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0
    :try_end_1a
    .catchall {:try_start_10 .. :try_end_1a} :catchall_1b

    return-object p0

    :catchall_1b
    :cond_1b
    const-wide v0, -0x7ffffffffffffff9L    # -3.5E-323

    .line 1166
    :try_start_20
    invoke-interface {p0, p1, v0, v1}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v2

    cmp-long v0, v2, v0

    if-eqz v0, :cond_2d

    .line 1167
    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0
    :try_end_2c
    .catchall {:try_start_20 .. :try_end_2c} :catchall_2d

    return-object p0

    :catchall_2d
    :cond_2d
    const v0, -0x7237b0e0    # -1.2345E-30f

    .line 1172
    :try_start_30
    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result v1

    cmpl-float v0, v1, v0

    if-eqz v0, :cond_3d

    .line 1173
    invoke-static {v1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object p0
    :try_end_3c
    .catchall {:try_start_30 .. :try_end_3c} :catchall_3d

    return-object p0

    .line 1177
    :catchall_3d
    :cond_3d
    :try_start_3d
    invoke-interface {p0, p1}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_4d

    const/4 v0, 0x0

    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0
    :try_end_4c
    .catchall {:try_start_3d .. :try_end_4c} :catchall_4d

    return-object p0

    :catchall_4d
    :cond_4d
    const/4 p0, 0x0

    return-object p0
.end method

.method private static applyPushed(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 20
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    move-object/from16 v1, p0

    move-object/from16 v0, p1

    .line 342
    const-string v2, "fuckds_ububble_on"

    const-string v3, "b"

    const-string v4, "fuckds_bubble_on"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->inHost(Landroid/content/Context;)Z

    move-result v5

    if-nez v5, :cond_18

    .line 343
    const-string v0, "FDM-DIAG"

    const-string v1, "\uff08\u672c\u5730\u8fdb\u7a0b\u6536\u5230\u914d\u7f6e\u63a8\u9001\uff0c\u5ffd\u7565\uff09"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 346
    :cond_18
    const-string v5, "json"

    if-nez v0, :cond_1e

    const/4 v7, 0x0

    goto :goto_22

    :cond_1e
    invoke-virtual {v0, v5}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    :goto_22
    const/4 v8, -0x1

    .line 347
    const-string v9, "rev"

    if-nez v0, :cond_28

    goto :goto_2c

    :cond_28
    invoke-virtual {v0, v9, v8}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v8

    :goto_2c
    if-nez v0, :cond_30

    const/4 v0, 0x0

    goto :goto_36

    .line 349
    :cond_30
    const-string v10, "bridge_token"

    invoke-virtual {v0, v10}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_36
    if-eqz v0, :cond_49

    .line 350
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v10

    if-nez v10, :cond_49

    .line 351
    sget-object v10, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sToken:Ljava/lang/String;

    if-nez v10, :cond_47

    .line 352
    const-string v10, "\u3010FdmBridge\u3011\ud83d\udd11 \u6536\u5230\u6865\u7684\u63e1\u624b\u4ee4\u724c\uff08\u4ee5\u540e\u8c03 provider \u5e26\u7740\u5b83\uff09"

    invoke-static {v10}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 354
    :cond_47
    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sToken:Ljava/lang/String;

    .line 357
    :cond_49
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->syncPins(Landroid/content/Context;)Z

    .line 358
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v10, "\u3010FdmBridge\u3011\ud83d\udce8 \u6536\u5230 UI \u63a8\u6765\u7684\u914d\u7f6e\uff1arev="

    invoke-direct {v0, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, " json="

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    if-eqz v7, :cond_2f7

    .line 359
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_2f7

    const-string v0, "{}"

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7b

    goto/16 :goto_2f7

    .line 364
    :cond_7b
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, v7}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 365
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v7

    invoke-interface {v7}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v7

    .line 368
    const-string v10, "bools"

    invoke-virtual {v0, v10}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v10

    .line 378
    new-instance v11, Lorg/json/JSONObject;

    invoke-direct {v11}, Lorg/json/JSONObject;-><init>()V

    const/4 v13, 0x0

    if-eqz v10, :cond_101

    .line 380
    new-instance v15, Ljava/util/ArrayList;

    invoke-direct {v15}, Ljava/util/ArrayList;-><init>()V

    .line 381
    invoke-virtual {v10}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v16

    :goto_9f
    invoke-interface/range {v16 .. v16}, Ljava/util/Iterator;->hasNext()Z

    move-result v17

    if-eqz v17, :cond_b1

    .line 382
    invoke-interface/range {v16 .. v16}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v17

    move-object/from16 v6, v17

    check-cast v6, Ljava/lang/String;

    invoke-interface {v15, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_9f

    .line 384
    :cond_b1
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    .line 385
    invoke-interface {v15}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v15

    :cond_ba
    :goto_ba
    invoke-interface {v15}, Ljava/util/Iterator;->hasNext()Z

    move-result v16

    if-eqz v16, :cond_e2

    invoke-interface {v15}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v16

    move-object/from16 v12, v16

    check-cast v12, Ljava/lang/String;

    .line 386
    invoke-virtual {v10, v12, v13}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v14

    invoke-static {v1, v12, v14}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->dispatch(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v14

    if-eqz v14, :cond_ba

    const/4 v14, 0x1

    .line 387
    invoke-virtual {v11, v12, v14}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 388
    invoke-virtual {v10, v12}, Lorg/json/JSONObject;->remove(Ljava/lang/String;)Ljava/lang/Object;

    .line 389
    invoke-virtual {v6, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v12, 0x20

    invoke-virtual {v6, v12}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_ba

    .line 392
    :cond_e2
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->length()I

    move-result v11

    if-lez v11, :cond_101

    .line 393
    new-instance v11, Ljava/lang/StringBuilder;

    const-string v12, "\u3010FdmBridge\u3011\u8d70\u4e13\u7528\u5165\u53e3\u7684\u5f00\u5173\uff1a"

    invoke-direct {v11, v12}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v11, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 397
    :cond_101
    invoke-static {v7, v10}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->putBools(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I

    move-result v6

    .line 398
    const-string v11, "ints"

    invoke-virtual {v0, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v11

    invoke-static {v7, v11}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->putInts(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I

    move-result v11

    add-int/2addr v6, v11

    .line 399
    const-string v11, "longs"

    invoke-virtual {v0, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v11

    invoke-static {v7, v11}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->putLongs(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I

    move-result v11

    add-int/2addr v6, v11

    .line 400
    const-string v11, "floats"

    invoke-virtual {v0, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v11

    invoke-static {v7, v11}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->putFloats(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I

    move-result v11

    add-int/2addr v6, v11

    .line 401
    const-string v11, "strings"

    invoke-virtual {v0, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-static {v7, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->putStrings(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I

    move-result v0

    add-int/2addr v6, v0

    if-nez v6, :cond_13d

    .line 404
    const-string v0, "\u3010FdmBridge\u3011\u6ca1\u8ba4\u51fa\u4efb\u4f55\u914d\u7f6e\u9879\uff0c\u8df3\u8fc7\uff08\u683c\u5f0f\u89c1 FdmBridge \u6ce8\u91ca\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/16 v16, 0x1

    .line 405
    sput-boolean v16, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sGotConfig:Z

    return-void

    .line 408
    :cond_13d
    invoke-interface {v7}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result v0

    .line 409
    new-instance v7, Ljava/lang/StringBuilder;

    const-string v11, "\u3010FdmBridge\u3011\u2705 \u5df2\u5199\u5165\u5bbf\u4e3b\u914d\u7f6e "

    invoke-direct {v7, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, " \u9879\uff08commit="

    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 415
    :try_start_15f
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    .line 416
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "\u3010FdmBridge\u3011\u6c14\u6ce1\u5f00\u5173\u73b0\u72b6\uff1aAI="

    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1, v4, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v11, " \u7528\u6237="

    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 417
    invoke-static {v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\uff08\u672c\u6b21\u63a8\u9001\u91cc\u7684 bools \u542b ububble_on="

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 418
    invoke-virtual {v10, v2}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " / bubble_on="

    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 419
    invoke-virtual {v10, v4}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 416
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_1a1
    .catchall {:try_start_15f .. :try_end_1a1} :catchall_1a1

    :catchall_1a1
    const/16 v16, 0x1

    .line 422
    sput-boolean v16, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sGotConfig:Z

    .line 435
    :try_start_1a5
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->refresh(Landroid/content/Context;)V
    :try_end_1a8
    .catchall {:try_start_1a5 .. :try_end_1a8} :catchall_1a8

    .line 444
    :catchall_1a8
    :try_start_1a8
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->refresh()V
    :try_end_1ab
    .catchall {:try_start_1a8 .. :try_end_1ab} :catchall_1ab

    .line 452
    :catchall_1ab
    :try_start_1ab
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmBubble"

    const-class v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    .line 453
    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    .line 452
    invoke-static {v0, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    .line 455
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 456
    invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v0

    array-length v3, v0

    move v4, v13

    move v7, v4

    :goto_1c3
    if-ge v4, v3, :cond_20b

    aget-object v10, v0, v4

    .line 457
    invoke-virtual {v10}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v11

    invoke-static {v11}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v11

    if-eqz v11, :cond_204

    .line 458
    invoke-virtual {v10}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v11

    sget-object v12, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-ne v11, v12, :cond_204

    .line 459
    invoke-virtual {v10}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v11

    const-string v12, "read"

    invoke-virtual {v11, v12}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11
    :try_end_1e7
    .catchall {:try_start_1ab .. :try_end_1e7} :catchall_235

    if-eqz v11, :cond_204

    const/4 v14, 0x1

    .line 461
    :try_start_1ea
    invoke-virtual {v10, v14}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_1ed
    .catchall {:try_start_1ea .. :try_end_1ed} :catchall_200

    const/4 v11, 0x0

    .line 462
    :try_start_1ee
    invoke-virtual {v10, v11, v13}, Ljava/lang/reflect/Field;->setBoolean(Ljava/lang/Object;Z)V

    add-int/lit8 v7, v7, 0x1

    .line 464
    invoke-virtual {v10}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_1fa
    .catchall {:try_start_1ee .. :try_end_1fa} :catchall_201

    const/16 v12, 0x20

    :try_start_1fc
    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    :try_end_1ff
    .catchall {:try_start_1fc .. :try_end_1ff} :catchall_208

    goto :goto_208

    :catchall_200
    const/4 v11, 0x0

    :catchall_201
    const/16 v12, 0x20

    goto :goto_208

    :cond_204
    const/4 v11, 0x0

    const/16 v12, 0x20

    const/4 v14, 0x1

    :catchall_208
    :goto_208
    add-int/lit8 v4, v4, 0x1

    goto :goto_1c3

    .line 469
    :cond_20b
    :try_start_20b
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u3010FdmBridge\u3011\u5df2\u6e05 GmBubble \u8bfb\u53d6\u7f13\u5b58 "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " \u4e2a\uff08"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\uff09\u21d2 \u6c14\u6ce1\u914d\u7f6e\u4e0b\u6b21\u73b0\u8bfb"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_234
    .catchall {:try_start_20b .. :try_end_234} :catchall_235

    goto :goto_247

    :catchall_235
    move-exception v0

    .line 472
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010FdmBridge\u3011\u6e05\u7f13\u5b58\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u529f\u80fd\uff09\uff1a"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 476
    :goto_247
    :try_start_247
    new-instance v0, Landroid/content/Intent;

    const-string v2, "com.little_femaleboy.fdm.CONFIG_APPLIED"

    invoke-direct {v0, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 477
    invoke-virtual {v0, v9, v8}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 478
    const-string v2, "count"

    invoke-virtual {v0, v2, v6}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 479
    invoke-virtual {v1, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_259
    .catchall {:try_start_247 .. :try_end_259} :catchall_259

    .line 490
    :catchall_259
    :try_start_259
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 491
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 492
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 493
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->OUR_KEYS:[Ljava/lang/String;

    array-length v6, v4

    move v7, v13

    :goto_26b
    if-ge v7, v6, :cond_275

    aget-object v8, v4, v7

    invoke-interface {v3, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v7, v7, 0x1

    goto :goto_26b

    .line 494
    :cond_275
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->GRAY:[[Ljava/lang/String;

    array-length v6, v4

    move v7, v13

    :goto_279
    if-ge v7, v6, :cond_285

    aget-object v8, v4, v7

    aget-object v8, v8, v13

    invoke-interface {v3, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v7, v7, 0x1

    goto :goto_279

    .line 496
    :cond_285
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :catchall_289
    :goto_289
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_2ad

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;
    :try_end_295
    .catchall {:try_start_259 .. :try_end_295} :catchall_2e4

    .line 498
    :try_start_295
    invoke-static {v2, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->anyValue(Landroid/content/SharedPreferences;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v7

    if-nez v7, :cond_29c

    goto :goto_289

    .line 500
    :cond_29c
    invoke-static {v7}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    .line 501
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_2a7

    goto :goto_289

    .line 502
    :cond_2a7
    invoke-virtual {v0, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_2aa
    .catchall {:try_start_295 .. :try_end_2aa} :catchall_289

    add-int/lit8 v13, v13, 0x1

    goto :goto_289

    .line 507
    :cond_2ad
    :try_start_2ad
    new-instance v2, Landroid/content/Intent;

    const-string v4, "com.little_femaleboy.fdm.CONFIG_STATE"

    invoke-direct {v2, v4}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 508
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v5, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 509
    invoke-virtual {v1, v2}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 510
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u3010FdmBridge\u3011\u5df2\u56de\u8bfb\u5bbf\u4e3b\u914d\u7f6e "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u4e2a\u952e\u5e76\u5e7f\u64ad\u7ed9 UI\uff08\u6e05\u5355 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u4e2a\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_2e3
    .catchall {:try_start_2ad .. :try_end_2e3} :catchall_2e4

    goto :goto_2f6

    :catchall_2e4
    move-exception v0

    .line 512
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u3010FdmBridge\u3011\u56de\u8bfb\u5bbf\u4e3b\u914d\u7f6e\u5931\u8d25\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_2f6
    return-void

    .line 360
    :cond_2f7
    :goto_2f7
    const-string v0, "\u3010FdmBridge\u3011\u914d\u7f6e\u662f\u7a7a\u7684\uff0c\u8df3\u8fc7\uff08\u4e0d\u6539\u5bbf\u4e3b\u4efb\u4f55\u4e1c\u897f\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static asBool(Ljava/lang/Object;)Z
    .registers 3

    .line 2338
    instance-of v0, p0, Ljava/lang/Boolean;

    if-eqz v0, :cond_b

    check-cast p0, Ljava/lang/Boolean;

    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    return p0

    .line 2339
    :cond_b
    const-string v0, "true"

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_26

    const-string v0, "1"

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_24

    goto :goto_26

    :cond_24
    const/4 p0, 0x0

    return p0

    :cond_26
    :goto_26
    const/4 p0, 0x1

    return p0
.end method

.method private static asStrList(Ljava/lang/Object;)Ljava/util/List;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 885
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 886
    instance-of v1, p0, [Ljava/lang/String;

    const/4 v2, 0x0

    if-eqz v1, :cond_19

    .line 887
    check-cast p0, [Ljava/lang/String;

    array-length v1, p0

    :goto_d
    if-ge v2, v1, :cond_4e

    aget-object v3, p0, v2

    if-eqz v3, :cond_16

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_16
    add-int/lit8 v2, v2, 0x1

    goto :goto_d

    .line 890
    :cond_19
    instance-of v1, p0, [Ljava/lang/Object;

    if-eqz v1, :cond_30

    .line 891
    check-cast p0, [Ljava/lang/Object;

    array-length v1, p0

    :goto_20
    if-ge v2, v1, :cond_4e

    aget-object v3, p0, v2

    if-eqz v3, :cond_2d

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_2d
    add-int/lit8 v2, v2, 0x1

    goto :goto_20

    .line 894
    :cond_30
    instance-of v1, p0, Ljava/util/Collection;

    if-eqz v1, :cond_4f

    .line 895
    check-cast p0, Ljava/util/Collection;

    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_3a
    :goto_3a
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_4e

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_3a

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_3a

    :cond_4e
    return-object v0

    :cond_4f
    const/4 p0, 0x0

    return-object p0
.end method

.method private static boxed(Ljava/lang/Class;)Ljava/lang/Class;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation

    .line 1144
    sget-object v0, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-ne p0, v0, :cond_7

    const-class p0, Ljava/lang/Boolean;

    return-object p0

    .line 1145
    :cond_7
    sget-object v0, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne p0, v0, :cond_e

    const-class p0, Ljava/lang/Integer;

    return-object p0

    .line 1146
    :cond_e
    sget-object v0, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-ne p0, v0, :cond_15

    const-class p0, Ljava/lang/Long;

    return-object p0

    .line 1147
    :cond_15
    sget-object v0, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    if-ne p0, v0, :cond_1b

    const-class p0, Ljava/lang/Float;

    :cond_1b
    return-object p0
.end method

.method private static callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 14
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "[",
            "Ljava/lang/Class<",
            "*>;[",
            "Ljava/lang/Object;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 1109
    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {p0, v1, v0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    const/4 v0, 0x0

    .line 1112
    :try_start_c
    invoke-virtual {p0, p1, p2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0
    :try_end_10
    .catch Ljava/lang/NoSuchMethodException; {:try_start_c .. :try_end_10} :catch_11

    goto :goto_5d

    :catch_11
    move-exception p2

    .line 1116
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v2, p0

    const/4 v3, 0x0

    move v4, v3

    :goto_19
    if-ge v4, v2, :cond_5a

    aget-object v5, p0, v4

    .line 1117
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_28

    goto :goto_4a

    .line 1118
    :cond_28
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v6

    .line 1119
    array-length v7, v6

    array-length v8, p3

    if-le v7, v8, :cond_31

    goto :goto_4a

    :cond_31
    move v7, v3

    .line 1121
    :goto_32
    array-length v8, v6

    if-ge v7, v8, :cond_50

    .line 1122
    aget-object v8, p3, v7

    if-nez v8, :cond_3a

    goto :goto_4d

    .line 1124
    :cond_3a
    aget-object v9, v6, v7

    invoke-static {v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->boxed(Ljava/lang/Class;)Ljava/lang/Class;

    move-result-object v9

    invoke-virtual {v8}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v8

    invoke-virtual {v9, v8}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v8

    if-nez v8, :cond_4d

    :goto_4a
    add-int/lit8 v4, v4, 0x1

    goto :goto_19

    :cond_4d
    :goto_4d
    add-int/lit8 v7, v7, 0x1

    goto :goto_32

    .line 1131
    :cond_50
    array-length p0, v6

    new-array p0, p0, [Ljava/lang/Object;

    .line 1132
    array-length p1, v6

    invoke-static {p3, v3, p0, v3, p1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    move-object p3, p0

    move-object p0, v5

    goto :goto_5b

    :cond_5a
    move-object p0, v0

    :goto_5b
    if-eqz p0, :cond_65

    .line 1139
    :goto_5d
    invoke-virtual {p0, v1}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 1140
    invoke-virtual {p0, v0, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0

    .line 1137
    :cond_65
    throw p2
.end method

.method private static clearBubbleCache()V
    .registers 3

    .line 2320
    :try_start_0
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmBubble"

    const-class v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    .line 2321
    invoke-virtual {v1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    .line 2320
    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    .line 2322
    const-string v1, "sBmpCache"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->setStaticObjectField(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_12
    .catchall {:try_start_0 .. :try_end_12} :catchall_12

    :catchall_12
    return-void
.end method

.method private static copyFile(Ljava/io/File;Ljava/io/File;)V
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 2328
    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 2329
    new-instance p0, Ljava/io/FileOutputStream;

    invoke-direct {p0, p1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/high16 p1, 0x10000

    .line 2330
    new-array p1, p1, [B

    .line 2332
    :goto_e
    invoke-virtual {v0, p1}, Ljava/io/FileInputStream;->read([B)I

    move-result v1

    if-lez v1, :cond_19

    const/4 v2, 0x0

    invoke-virtual {p0, p1, v2, v1}, Ljava/io/FileOutputStream;->write([BII)V

    goto :goto_e

    .line 2333
    :cond_19
    invoke-virtual {v0}, Ljava/io/FileInputStream;->close()V

    .line 2334
    invoke-virtual {p0}, Ljava/io/FileOutputStream;->close()V

    return-void
.end method

.method private static dispatch(Landroid/content/Context;Ljava/lang/String;Z)Z
    .registers 13

    const-string v0, "\u3010FdmBridge\u3011\u56de\u8bfb\u5bbf\u4e3b\u914d\u7f6e\uff1alen="

    const-string v1, "\u3010FdmBridge\u3011\u56de\u8bfb\u5bbf\u4e3b\u914d\u7f6e\u5931\u8d25\uff1a"

    const-string v2, "\u3010FdmBridge\u3011"

    const/4 v3, 0x0

    .line 1191
    :try_start_7
    const-string v4, "fuckds_bubble_on"

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4
    :try_end_d
    .catchall {:try_start_7 .. :try_end_d} :catchall_144

    const-string v5, "="

    const/4 v6, 0x1

    if-eqz v4, :cond_30

    .line 1192
    :try_start_12
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->setOn(Landroid/content/Context;Z)V

    .line 1193
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " \u2192 GmBubble.setOn"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v6

    .line 1196
    :cond_30
    const-string v4, "fuckds_ububble_on"

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_56

    .line 1197
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->setUOn(Landroid/content/Context;Z)V

    .line 1198
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " \u2192 GmBubble.setUOn"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v6

    .line 1201
    :cond_56
    const-string v4, "fuckds_model_switch"

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_106

    .line 1202
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmModel;->setOn(Landroid/content/Context;Z)Z

    move-result p0

    .line 1203
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " \u2192 GmModel.setOn \u2192 "

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_7f
    .catchall {:try_start_12 .. :try_end_7f} :catchall_144

    .line 1207
    :try_start_7f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPrompt;->host()Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_8f

    .line 1208
    const-string p2, "\"switchable\":false"

    invoke-virtual {p0, p2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p2

    if-eqz p2, :cond_8f

    move p2, v6

    goto :goto_90

    :cond_8f
    move p2, v3

    :goto_90
    if-eqz p0, :cond_9c

    .line 1209
    const-string v4, "\"switchable\":true"

    invoke-virtual {p0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_9c

    move v4, v6

    goto :goto_9d

    :cond_9c
    move v4, v3

    :goto_9d
    const/4 v5, -0x1

    if-nez p0, :cond_a2

    move v7, v5

    goto :goto_a8

    .line 1210
    :cond_a2
    const-string v7, "switchable"

    invoke-virtual {p0, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v7

    :goto_a8
    if-gez v7, :cond_ad

    .line 1211
    const-string v7, "\uff08\u627e\u4e0d\u5230 switchable\uff09"

    goto :goto_c1

    :cond_ad
    add-int/lit8 v8, v7, -0x18

    .line 1212
    invoke-static {v3, v8}, Ljava/lang/Math;->max(II)I

    move-result v8

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v9

    add-int/lit8 v7, v7, 0x20

    invoke-static {v9, v7}, Ljava/lang/Math;->min(II)I

    move-result v7

    invoke-virtual {p0, v8, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v7

    .line 1213
    :goto_c1
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez p0, :cond_c9

    goto :goto_cd

    :cond_c9
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v5

    :goto_cd
    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u542bswitchable:false="

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " \u542bswitchable:true="

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " \u7247\u6bb5=["

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v8, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_f4
    .catchall {:try_start_7f .. :try_end_f4} :catchall_f5

    goto :goto_105

    :catchall_f5
    move-exception p0

    .line 1217
    :try_start_f6
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_105
    return v6

    .line 1221
    :cond_106
    const-string v0, "fuckds_device_on"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_12c

    .line 1222
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->setOn(Landroid/content/Context;Z)V

    .line 1223
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " \u2192 GmDevice.setOn"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v6

    .line 1227
    :cond_12c
    const-string v0, "fuckds_note_on"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_138

    .line 1228
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setOn(Landroid/content/Context;Z)V

    return v6

    .line 1232
    :cond_138
    const-string v0, "fuckds_bar_on"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_15c

    .line 1233
    invoke-static {p0, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->setOn(Landroid/content/Context;Z)V
    :try_end_143
    .catchall {:try_start_f6 .. :try_end_143} :catchall_144

    return v6

    :catchall_144
    move-exception p0

    .line 1237
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " \u4e13\u7528\u5165\u53e3\u5931\u8d25\uff08\u9000\u56de\u88f8\u5199\uff09\uff1a"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_15c
    return v3
.end method

.method private static dispatchText(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z
    .registers 20

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 1333
    const-string v2, "com.nidyaber.fuckdsmanger.gm.GmPrompt"

    const-string v3, "com.nidyaber.fuckdsmanger.gm.GmHello"

    .line 0
    const-string v4, "\u3010FdmBridge\u3011\u56de\u590d\u5efa\u8bae \u2192 GmSuggest.setText\uff08\u5df2\u5f52\u4e00\u5316\u6362\u884c\uff0c"

    const/4 v5, 0x0

    .line 1333
    :try_start_b
    const-string v6, "fuckds_welcome_msg"

    invoke-virtual {v6, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6
    :try_end_11
    .catchall {:try_start_b .. :try_end_11} :catchall_1c5

    const-string v7, "apply"

    const-string v8, "put"

    const-string v9, "build"

    const-string v10, " \u6761\uff09"

    const-class v11, Ljava/lang/String;

    const/4 v12, 0x2

    const/4 v13, 0x1

    if-eqz v6, :cond_ee

    .line 1334
    :try_start_1f
    invoke-static/range {p2 .. p2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->splitLines(Ljava/lang/String;)Ljava/util/List;

    move-result-object v2

    .line 1337
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V
    :try_end_28
    .catchall {:try_start_1f .. :try_end_28} :catchall_1c5

    .line 1339
    :try_start_28
    const-string v6, "get"

    new-array v14, v13, [Ljava/lang/Class;

    const-class v15, Landroid/content/Context;

    aput-object v15, v14, v5

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v15

    invoke-static {v3, v6, v14, v15}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    if-nez v6, :cond_3c

    const/4 v6, 0x0

    goto :goto_4b

    .line 1342
    :cond_3c
    new-instance v14, Lorg/json/JSONObject;

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-direct {v14, v6}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v6, "messages"

    invoke-virtual {v14, v6}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v6

    :goto_4b
    if-eqz v6, :cond_71

    move v14, v5

    .line 1344
    :goto_4e
    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I

    move-result v15

    if-ge v14, v15, :cond_71

    .line 1345
    invoke-virtual {v6, v14}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v15
    :try_end_58
    .catchall {:try_start_28 .. :try_end_58} :catchall_71

    if-eqz v15, :cond_6a

    move/from16 v16, v5

    .line 1346
    :try_start_5c
    const-string v5, "id"

    invoke-virtual {v15, v5, v14}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-interface {v4, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_69
    .catchall {:try_start_5c .. :try_end_69} :catchall_73

    goto :goto_6c

    :cond_6a
    move/from16 v16, v5

    :goto_6c
    add-int/lit8 v14, v14, 0x1

    move/from16 v5, v16

    goto :goto_4e

    :catchall_71
    :cond_71
    move/from16 v16, v5

    .line 1351
    :catchall_73
    :try_start_73
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    move/from16 v6, v16

    .line 1352
    :goto_7a
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v14

    if-ge v6, v14, :cond_a6

    .line 1353
    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v14

    if-ge v6, v14, :cond_91

    invoke-interface {v4, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/Integer;

    invoke-virtual {v14}, Ljava/lang/Integer;->intValue()I

    move-result v14

    goto :goto_92

    :cond_91
    move v14, v6

    .line 1354
    :goto_92
    invoke-static {v14}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v14

    invoke-interface {v2, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Ljava/lang/String;

    filled-new-array {v14, v15}, [Ljava/lang/String;

    move-result-object v14

    invoke-interface {v5, v14}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v6, v6, 0x1

    goto :goto_7a

    .line 1356
    :cond_a6
    new-array v2, v13, [Ljava/lang/Class;

    const-class v4, Ljava/util/List;

    aput-object v4, v2, v16

    filled-new-array {v5}, [Ljava/lang/Object;

    move-result-object v4

    invoke-static {v3, v9, v2, v4}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 1358
    new-array v4, v12, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    aput-object v6, v4, v16

    aput-object v11, v4, v13

    filled-new-array {v0, v2}, [Ljava/lang/Object;

    move-result-object v9

    invoke-static {v3, v8, v4, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1360
    new-array v4, v12, [Ljava/lang/Class;

    aput-object v6, v4, v16

    aput-object v11, v4, v13

    filled-new-array {v0, v2}, [Ljava/lang/Object;

    move-result-object v0

    invoke-static {v3, v7, v4, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1362
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u3010FdmBridge\u3011\u62db\u547c\u8bed \u2192 build+put+apply\uff08"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v13

    :cond_ee
    move/from16 v16, v5

    .line 1365
    const-string v3, "fuckds_suggest_text"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_12e

    .line 1366
    const-string v2, "com.nidyaber.fuckdsmanger.gm.GmSuggest"

    const-string v3, "setText"

    new-array v5, v12, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    aput-object v6, v5, v16

    aput-object v11, v5, v13

    .line 1367
    invoke-static/range {p2 .. p2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->splitLines(Ljava/lang/String;)Ljava/util/List;

    move-result-object v6

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->joinLines(Ljava/util/List;)Ljava/lang/String;

    move-result-object v6

    filled-new-array {v0, v6}, [Ljava/lang/Object;

    move-result-object v0

    .line 1366
    invoke-static {v2, v3, v5, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1368
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 1369
    invoke-static/range {p2 .. p2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->splitLines(Ljava/lang/String;)Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1368
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v13

    .line 1372
    :cond_12e
    const-string v3, "fuckds_prompt_feature"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1b5

    .line 1373
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 1375
    invoke-static/range {p2 .. p2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->splitLines(Ljava/lang/String;)Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    move/from16 v5, v16

    :goto_145
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_16f

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 1376
    const-string v14, "\\|"

    const/4 v15, -0x1

    invoke-virtual {v6, v14, v15}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v6

    .line 1377
    array-length v14, v6

    if-ge v14, v12, :cond_15c

    goto :goto_145

    :cond_15c
    add-int/lit8 v14, v5, 0x1

    .line 1378
    invoke-static {v5}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v5

    aget-object v15, v6, v16

    aget-object v6, v6, v13

    filled-new-array {v5, v15, v6}, [Ljava/lang/String;

    move-result-object v5

    invoke-interface {v3, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    move v5, v14

    goto :goto_145

    .line 1380
    :cond_16f
    new-array v4, v13, [Ljava/lang/Class;

    const-class v5, Ljava/util/List;

    aput-object v5, v4, v16

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v2, v9, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 1382
    new-array v5, v12, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    aput-object v6, v5, v16

    aput-object v11, v5, v13

    filled-new-array {v0, v4}, [Ljava/lang/Object;

    move-result-object v4

    invoke-static {v2, v8, v5, v4}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1384
    new-array v4, v13, [Ljava/lang/Class;

    aput-object v6, v4, v16

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v0

    invoke-static {v2, v7, v4, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1385
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u3010FdmBridge\u3011\u63d0\u793a\u8bcd\u5185\u5bb9 \u2192 build+put+apply\uff08"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v13

    .line 1391
    :cond_1b5
    const-string v2, "fuckds_note_text"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1e1

    move-object/from16 v2, p2

    .line 1392
    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setTextFromCfg(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_1c2
    .catchall {:try_start_73 .. :try_end_1c2} :catchall_1c3

    return v13

    :catchall_1c3
    move-exception v0

    goto :goto_1c8

    :catchall_1c5
    move-exception v0

    move/from16 v16, v5

    .line 1396
    :goto_1c8
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010FdmBridge\u3011dispatchText "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u5931\u8d25\uff08\u9000\u56de\u88f8\u5199\uff09\uff1a"

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_1e1
    return v16
.end method

.method private static dumpHostStore(Landroid/content/Context;)Ljava/lang/String;
    .registers 11

    .line 923
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 925
    :try_start_5
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-nez p0, :cond_e

    .line 926
    const-string p0, "\uff08\u5bbf\u4e3b\u5b58\u50a8\u8fd8\u6ca1\u5c31\u7eea\uff09\n"

    return-object p0

    .line 928
    :cond_e
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->allKeysOf(Landroid/content/SharedPreferences;)Ljava/util/List;

    move-result-object v1

    .line 930
    new-instance v2, Ljava/util/TreeSet;

    invoke-direct {v2, v1}, Ljava/util/TreeSet;-><init>(Ljava/util/Collection;)V

    .line 933
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 934
    invoke-virtual {v2}, Ljava/util/TreeSet;->iterator()Ljava/util/Iterator;

    move-result-object v2

    const/4 v4, 0x0

    move v5, v4

    :cond_22
    :goto_22
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_86

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    if-nez v6, :cond_31

    goto :goto_22

    .line 936
    :cond_31
    const-string v7, "fuckds_pin_"

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_22

    const-string v7, "fuckds_bak_"

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7
    :try_end_3f
    .catchall {:try_start_5 .. :try_end_3f} :catchall_ad

    if-eqz v7, :cond_42

    goto :goto_22

    :cond_42
    const/4 v7, 0x0

    .line 940
    :try_start_43
    invoke-interface {p0, v6, v7}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7
    :try_end_47
    .catchall {:try_start_43 .. :try_end_47} :catchall_47

    :catchall_47
    if-nez v7, :cond_4a

    goto :goto_22

    .line 945
    :cond_4a
    :try_start_4a
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v8

    const/16 v9, 0x1f4

    if-le v8, v9, :cond_73

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v4, v9}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, "\u2026\uff08\u5171 "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, " \u5b57\uff09"

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 946
    :cond_73
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " = "

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v6, 0xa

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v5, v5, 0x1

    goto :goto_22

    .line 949
    :cond_86
    const-string p0, "\u5bbf\u4e3b\u5b58\u50a8\u5171 "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u4e2a\u952e"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\uff0c\u5176\u4e2d\u5b57\u7b26\u4e32\u578b "

    .line 950
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u6761\uff08\u5df2\u6392\u9664 fuckds_pin_/fuckds_bak_\uff09\n"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "----\n"

    .line 951
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;)Ljava/lang/StringBuilder;
    :try_end_ac
    .catchall {:try_start_4a .. :try_end_ac} :catchall_ad

    goto :goto_bb

    :catchall_ad
    move-exception p0

    .line 953
    const-string v1, "(DS DATA \u8bfb\u53d6\u5931\u8d25\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, ")\n"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 955
    :goto_bb
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static findNativeHandle(Ljava/lang/Class;)Ljava/lang/reflect/Field;
    .registers 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/reflect/Field;"
        }
    .end annotation

    const/4 v0, 0x1

    .line 980
    :try_start_1
    const-string v1, "nativeHandle"

    invoke-virtual {p0, v1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    .line 981
    invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_a
    .catchall {:try_start_1 .. :try_end_a} :catchall_b

    return-object v1

    .line 987
    :catchall_b
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object p0

    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    move-object v4, v2

    :goto_13
    if-ge v3, v1, :cond_32

    aget-object v5, p0, v3

    .line 988
    invoke-virtual {v5}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v6

    sget-object v7, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-eq v6, v7, :cond_20

    goto :goto_2f

    .line 989
    :cond_20
    invoke-virtual {v5}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v6

    invoke-static {v6}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v6

    if-eqz v6, :cond_2b

    goto :goto_2f

    :cond_2b
    if-eqz v4, :cond_2e

    return-object v2

    :cond_2e
    move-object v4, v5

    :goto_2f
    add-int/lit8 v3, v3, 0x1

    goto :goto_13

    :cond_32
    if-eqz v4, :cond_37

    .line 993
    invoke-virtual {v4, v0}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    :cond_37
    return-object v4
.end method

.method private static grayRead(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 7

    .line 523
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 524
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "fuckds_pin_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "kv_settings_"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "fuckds_pin_kv_settings_"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    filled-new-array {v0, p2, v1, p1}, [Ljava/lang/String;

    move-result-object p1

    const/4 p2, 0x0

    :goto_33
    const/4 v0, 0x4

    if-ge p2, v0, :cond_4d

    .line 530
    aget-object v0, p1, p2

    .line 534
    :try_start_38
    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->anyValue(Landroid/content/SharedPreferences;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_3f

    goto :goto_4a

    .line 536
    :cond_3f
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 537
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1
    :try_end_47
    .catchall {:try_start_38 .. :try_end_47} :catchall_4a

    if-nez v1, :cond_4a

    return-object v0

    :catchall_4a
    :cond_4a
    :goto_4a
    add-int/lit8 p2, p2, 0x1

    goto :goto_33

    .line 541
    :cond_4d
    const-string p0, ""

    return-object p0
.end method

.method private static grayWrite(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 21

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move-object/from16 v3, p2

    move-object/from16 v4, p3

    .line 551
    const-string v5, "\uff09"

    const-string v0, "fuckds_bak_"

    const-string v6, "fuckds_pin_"

    const-string v7, " = "

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v8

    .line 555
    const-string v9, "key_"

    invoke-virtual {v2, v9}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_1e

    move-object v10, v2

    goto :goto_2c

    .line 556
    :cond_1e
    new-instance v10, Ljava/lang/StringBuilder;

    const-string v11, "kv_remote_settings_"

    invoke-direct {v10, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    :goto_2c
    if-eqz v9, :cond_30

    move-object v9, v2

    goto :goto_3e

    .line 557
    :cond_30
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v11, "kv_settings_"

    invoke-direct {v9, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    .line 596
    :goto_3e
    filled-new-array {v9, v10}, [Ljava/lang/String;

    move-result-object v11

    const/4 v12, 0x0

    :goto_43
    const/4 v13, 0x2

    if-ge v12, v13, :cond_8e

    aget-object v13, v11, v12

    .line 598
    :try_start_48
    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v14, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    invoke-interface {v8, v14}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_60

    :catchall_5d
    move-object/from16 v16, v11

    goto :goto_89

    .line 599
    :cond_60
    invoke-static {v8, v13}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->anyValue(Landroid/content/SharedPreferences;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v14

    .line 600
    invoke-interface {v8}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v15
    :try_end_68
    .catchall {:try_start_48 .. :try_end_68} :catchall_5d

    move-object/from16 v16, v11

    :try_start_6a
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v11, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    if-nez v14, :cond_7e

    .line 601
    const-string v13, "\u0000__gm_none__"

    goto :goto_82

    :cond_7e
    invoke-static {v14}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v13

    .line 600
    :goto_82
    invoke-interface {v15, v11, v13}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    .line 601
    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_89
    .catchall {:try_start_6a .. :try_end_89} :catchall_89

    :catchall_89
    :goto_89
    add-int/lit8 v12, v12, 0x1

    move-object/from16 v11, v16

    goto :goto_43

    .line 609
    :cond_8e
    :try_start_8e
    invoke-static {v1, v9, v4, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 610
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "\u3010FdmBridge\u3011\u2705 \u5df2\u5199\u5bbf\u4e3b\u8986\u76d6\u5c42 "

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v11, "\uff08type="

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_b6
    .catchall {:try_start_8e .. :try_end_b6} :catchall_b7

    goto :goto_c9

    :catchall_b7
    move-exception v0

    .line 613
    new-instance v11, Ljava/lang/StringBuilder;

    const-string v12, "\u3010FdmBridge\u3011\u5199\u5bbf\u4e3b\u8986\u76d6\u5c42\u5931\u8d25 "

    invoke-direct {v11, v12}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-static {v11, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 618
    :goto_c9
    :try_start_c9
    invoke-interface {v8, v10}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_ff

    .line 619
    invoke-static {v1, v10, v4, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 620
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u3010FdmBridge\u3011\u2705 \u5df2\u5199\u5bbf\u4e3b\u7f13\u5b58\u5c42 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_ec
    .catchall {:try_start_c9 .. :try_end_ec} :catchall_ed

    goto :goto_ff

    :catchall_ed
    move-exception v0

    .line 623
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v3, "\u3010FdmBridge\u3011\u5199\u5bbf\u4e3b\u7f13\u5b58\u5c42\u5931\u8d25 "

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 630
    :cond_ff
    :goto_ff
    :try_start_ff
    invoke-interface {v8}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 631
    invoke-interface {v0, v1, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 632
    invoke-interface {v0, v1, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 633
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_13f
    .catchall {:try_start_ff .. :try_end_13f} :catchall_140

    goto :goto_146

    :catchall_140
    move-exception v0

    .line 635
    const-string v1, "\u3010FdmBridge\u3011\u5199\u5f71\u5b50\u952e\u5931\u8d25\uff08\u4e3b\u901a\u9053\u5df2\u5199\u771f\u5b9e\u952e\uff0c\u4e0d\u5f71\u54cd\u751f\u6548\uff09"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 639
    :goto_146
    :try_start_146
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->pins()Ljava/util/HashMap;

    move-result-object v0

    .line 640
    invoke-virtual {v0, v10, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 641
    invoke-virtual {v0, v9, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 642
    invoke-virtual {v0, v2, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 643
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u3010FdmBridge\u3011pin \u8868 +3\uff08"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_170
    .catchall {:try_start_146 .. :try_end_170} :catchall_171

    goto :goto_177

    :catchall_171
    move-exception v0

    .line 645
    const-string v1, "\u3010FdmBridge\u3011pin \u8868\u5199\u5165\u5931\u8d25\uff08\u53ea\u9760\u5f71\u5b50\u952e\u4e86\uff09"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_177
    return-void
.end method

.method private static helloLines(Landroid/content/Context;)Ljava/lang/String;
    .registers 11

    .line 1245
    const-string v0, ""

    .line 0
    const-string v1, "\u3010FdmBridge\u3011helloLines \u515c\u5e95\uff1araw="

    const-string v2, "\u3010FdmBridge\u3011helloLines get \u5931\u8d25\uff1a"

    const/4 v3, 0x0

    const/4 v4, 0x1

    const/4 v5, 0x0

    .line 1247
    :try_start_9
    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmHello"

    const-string v7, "get"

    new-array v8, v4, [Ljava/lang/Class;

    const-class v9, Landroid/content/Context;

    aput-object v9, v8, v3

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object v9

    invoke-static {v6, v7, v8, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    if-eqz v6, :cond_33

    .line 1249
    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2
    :try_end_21
    .catchall {:try_start_9 .. :try_end_21} :catchall_23

    move-object v5, v2

    goto :goto_33

    :catchall_23
    move-exception v6

    .line 1251
    :try_start_24
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_33
    :goto_33
    if-eqz v5, :cond_3f

    .line 1253
    invoke-virtual {v5}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_8c

    .line 1255
    :cond_3f
    const-string v2, "com.nidyaber.fuckdsmanger.gm.GmStore"

    const-string v6, "read2"

    const/4 v7, 0x3

    new-array v7, v7, [Ljava/lang/Class;

    const-class v8, Landroid/content/Context;

    aput-object v8, v7, v3

    const-class v8, Ljava/lang/String;

    aput-object v8, v7, v4

    const/4 v4, 0x2

    aput-object v8, v7, v4

    const-string v4, "kv_remote_settings_welcome_msg"

    const-string v8, "s"

    filled-new-array {p0, v4, v8}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v2, v6, v7, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-eqz p0, :cond_63

    .line 1258
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    .line 1259
    :cond_63
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez v5, :cond_6d

    const-string v1, "null"

    goto :goto_82

    :cond_6d
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u5b57"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_82
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_8c
    if-nez v5, :cond_8f

    return-object v0

    .line 1262
    :cond_8f
    new-instance p0, Lorg/json/JSONObject;

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v1, "messages"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    if-nez p0, :cond_a1

    return-object v0

    .line 1264
    :cond_a1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 1265
    :goto_a6
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v3, v2, :cond_d2

    .line 1266
    invoke-virtual {p0, v3}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    if-nez v2, :cond_b4

    move-object v2, v0

    goto :goto_ba

    .line 1267
    :cond_b4
    const-string v4, "text"

    invoke-virtual {v2, v4, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 1268
    :goto_ba
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_c1

    goto :goto_cf

    .line 1269
    :cond_c1
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    if-lez v4, :cond_cc

    const-string v4, "\n"

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1270
    :cond_cc
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_cf
    add-int/lit8 v3, v3, 0x1

    goto :goto_a6

    .line 1272
    :cond_d2
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_d6
    .catchall {:try_start_24 .. :try_end_d6} :catchall_d7

    return-object p0

    :catchall_d7
    return-object v0
.end method

.method public static inHost(Landroid/content/Context;)Z
    .registers 3

    const/4 v0, 0x0

    if-eqz p0, :cond_11

    .line 1407
    :try_start_3
    const-string v1, "com.little_femaleboy.cannot_show.the_big_won_whale"

    .line 1408
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_d
    .catchall {:try_start_3 .. :try_end_d} :catchall_11

    if-nez p0, :cond_11

    const/4 p0, 0x1

    return p0

    :catchall_11
    :cond_11
    return v0
.end method

.method private static installReceiver(Landroid/content/Context;)V
    .registers 6

    .line 245
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sRecvInstalled:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    .line 246
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sRecvInstalled:Z

    .line 248
    :try_start_8
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$1;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$1;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sRecv:Landroid/content/BroadcastReceiver;

    .line 258
    new-instance v0, Landroid/content/IntentFilter;

    const-string v1, "com.little_femaleboy.fdm.CONFIG_PUSH"

    invoke-direct {v0, v1}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 259
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/4 v2, 0x2

    const/16 v3, 0x21

    if-lt v1, v3, :cond_23

    .line 260
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sRecv:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v1, v0, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    goto :goto_28

    .line 262
    :cond_23
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sRecv:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v1, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 264
    :goto_28
    const-string v0, "\u3010FdmBridge\u3011\u2705 \u914d\u7f6e\u63a5\u6536\u5668\u5df2\u6302\uff08com.little_femaleboy.fdm.CONFIG_PUSH\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 269
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$2;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$2;-><init>()V

    .line 279
    new-instance v1, Landroid/content/IntentFilter;

    const-string v4, "com.little_femaleboy.fdm.CMD"

    invoke-direct {v1, v4}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 280
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v4, v3, :cond_41

    .line 281
    invoke-virtual {p0, v0, v1, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    goto :goto_44

    .line 283
    :cond_41
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 285
    :goto_44
    const-string v0, "\u3010FdmBridge\u3011\u2705 \u52a8\u4f5c\u63a5\u6536\u5668\u5df2\u6302\uff08com.little_femaleboy.fdm.CMD\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 287
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->startReask(Landroid/content/Context;)V
    :try_end_4c
    .catchall {:try_start_8 .. :try_end_4c} :catchall_4d

    return-void

    :catchall_4d
    move-exception p0

    .line 289
    const-string v0, "\u3010FdmBridge\u3011\u914d\u7f6e\u63a5\u6536\u5668\u6302\u8f7d\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static isDecodableImage(Ljava/io/File;)Z
    .registers 4

    const/4 v0, 0x0

    .line 2308
    :try_start_1
    new-instance v1, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v1}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    const/4 v2, 0x1

    .line 2309
    iput-boolean v2, v1, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 2310
    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    .line 2311
    iget p0, v1, Landroid/graphics/BitmapFactory$Options;->outWidth:I

    if-lez p0, :cond_19

    iget p0, v1, Landroid/graphics/BitmapFactory$Options;->outHeight:I
    :try_end_16
    .catchall {:try_start_1 .. :try_end_16} :catchall_19

    if-lez p0, :cond_19

    return v2

    :catchall_19
    :cond_19
    return v0
.end method

.method private static joinLines(Ljava/util/List;)Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 1316
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1317
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_9
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_24

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 1318
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    if-lez v2, :cond_20

    const-string v2, "\n"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1319
    :cond_20
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_9

    .line 1321
    :cond_24
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static onCmd(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 72

    move-object/from16 v1, p0

    move-object/from16 v0, p1

    .line 1423
    const-string v2, "text"

    .line 0
    const-string v3, "\u5df2\u56de\u8bfb\u65e5\u5fd7 + \u4e0b\u53d1\u6570\u636e "

    const-string v4, "\u72b6\u6001 "

    const-string v5, "\u52a9\u624b\u56fe\u7247="

    const-string v6, "\uff08\u8be5\u52a8\u4f5c\u6682\u672a\u63a5\u901a\uff09"

    const-string v7, "\u901a\u8bdd\u9875\u7559\u9a7b\u5df2"

    const-string v8, "\u901a\u8bdd\u529f\u80fd\u5df2"

    const-string v9, "\u901a\u8bdd\u9875\u7559\u9a7b\uff1a"

    const-string v10, "\u3010FdmBridge\u3011\u5b58\u50a8\u5012\u51fa\u524d 600 \u5b57\uff1a"

    const-string v11, "\u901a\u8bdd\u5f00\u5173\uff1a"

    const-string v12, "\u5df2\u5012\u51fa\u5bbf\u4e3b\u5b58\u50a8 "

    const-string v13, "\u5df2\u704c\u5165\u5f00\u7bb1\u793a\u4f8b\u6a21\u677f\uff08"

    const-string v14, "\u3010FdmBridge\u3011spec_remove("

    const-string v15, "\u97f3\u4e50\uff1a"

    move-object/from16 v16, v6

    const-string v6, "\u62db\u547c\u8bed\u5df2\u6062\u590d\u9ed8\u8ba4\uff08\u4ece\u5907\u4efd\u8fd8\u539f\uff09\u00b7 reapply="

    move-object/from16 v17, v5

    const-string v5, "\u3010FdmBridge\u3011\u5ba2\u6237\u7aef\u4f2a\u88c5 \u2192 "

    move-object/from16 v18, v3

    const-string v3, "\u3010FdmBridge\u3011"

    move-object/from16 v19, v7

    const-string v7, "\u8d26\u53f7\u540d\u5df2\u5199\u5165\u6a21\u5757\uff08"

    move-object/from16 v20, v9

    const-string v9, "\u3010FdmBridge\u3011cfg_put \u5199\u5b58\u50a8\u5931\u8d25 "

    move-object/from16 v21, v8

    const-string v8, "\u3010FdmBridge\u3011\u97f3\u4e50\u6307\u4ee4 "

    move-object/from16 v22, v11

    const-string v11, "\u3010FdmBridge\u3011\u6536\u5230\u767b\u5f55\u51ed\u8bc1\uff1a\u957f\u5ea6="

    move-object/from16 v23, v10

    const-string v10, "\u56fe\u7247\u5df2\u5c31\u4f4d\uff08"

    move-object/from16 v24, v12

    const-string v12, "\u5934\u50cf\u56fe\u5df2\u5c31\u5730\u5199\u5165 "

    move-object/from16 v25, v13

    const-string v13, "\u5df2\u5199 "

    move-object/from16 v26, v14

    const-string v14, "\u6c14\u6ce1\u56fe\u5df2\u4ea4\u7ed9\u5bbf\u4e3b\uff1a"

    move-object/from16 v27, v6

    const-string v6, "\u81ea\u62cd\u5931\u8d25 "

    move-object/from16 v28, v7

    const-string v7, "\u9632\u64a4\u56de\uff1a"

    move-object/from16 v29, v4

    const-string v4, "\u5143\u7d20\u6355\u83b7\u5668\uff1a"

    move-object/from16 v30, v2

    const-string v2, "saveImage\u2192"

    move-object/from16 v31, v15

    const-string v15, "\u52a9\u624b\u56fe\u7247\u5df2\u5199\u5165\uff1a"

    move-object/from16 v32, v8

    const-string v8, "\u80cc\u666f\u56fe\u5df2\u5c31\u5730\u5199\u5165 "

    move-object/from16 v33, v5

    const-string v5, "\u8d26\u53f7\u5934\u50cf\uff1a"

    move-object/from16 v34, v11

    const-string v11, ".file() \u62ff\u4e0d\u5230\u76ee\u6807\u6587\u4ef6 \u21d2 \u672a\u5199\u5165"

    move-object/from16 v35, v9

    const-string v9, "\u56fe\u7247\u5df2\u6536\uff08"

    move-object/from16 v36, v6

    const-string v6, "\u52a9\u624b\u56fe\u7247\uff1a"

    move-object/from16 v37, v13

    const-string v13, "\u5df2\u6362\u65b0\u8bbe\u5907\u8eab\u4efd\uff1a"

    move-object/from16 v38, v4

    const-string v4, "\u672c\u5730\u6570\u636e\u5e93\u5df2\u6e05\u7a7a\uff08\u73b0\u5b58 "

    move-object/from16 v39, v13

    const-string v13, "\u6c14\u6ce1\u56fe\u5df2\u5c31\u5730\u5199\u5165 "

    move-object/from16 v40, v4

    const-string v4, "fdm_img_"

    move-object/from16 v41, v7

    const-string v7, "\u5171 "

    move-object/from16 v42, v7

    const-string v7, "\u5df2\u8ba9\u5bbf\u4e3b\u5f39\u9009\u62e9\u5668\uff08"

    move-object/from16 v43, v7

    const-string v7, "\u6536\u5230\u5757 "

    move-object/from16 v44, v6

    const-string v6, "\u5f00\u59cb\u63a5\u6536 "

    move-object/from16 v45, v5

    const-string v5, "\u56fe\u7247\u76f4\u62f7\u5931\u8d25\uff1a"

    move-object/from16 v46, v14

    const-string v14, "fdm_in_"

    move-object/from16 v47, v4

    const-string v4, "fdm_in_"

    move-object/from16 v48, v15

    const-string v15, "\u6e90\u56fe\u4e0d\u53ef\u89e3\u7801\uff08"

    move-object/from16 v49, v9

    const-string v9, "\u5bbf\u4e3b\u8bfb\u4e0d\u5230\u90a3\u4e2a\u6587\u4ef6\uff08"

    move-object/from16 v50, v2

    const-string v2, "fdm_in_"

    move-object/from16 v51, v4

    const-string v4, "\u3010FDM-UI\u3011"

    move-object/from16 v52, v7

    const-string v7, "\u52a9\u624b\u56fe\u7247\u5df2\u4fdd\u5b58\uff1a"

    .line 1423
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->inHost(Landroid/content/Context;)Z

    move-result v53

    if-nez v53, :cond_c2

    .line 1424
    const-string v0, "FDM-DIAG"

    const-string v1, "\uff08\u672c\u5730\u8fdb\u7a0b\u6536\u5230\u52a8\u4f5c\uff0c\u5ffd\u7565\uff1b\u7b49\u5bbf\u4e3b\u6765\u6267\u884c\uff09"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_c2
    move-object/from16 v53, v14

    if-nez v0, :cond_ca

    const/4 v14, 0x0

    const/16 v54, 0x0

    goto :goto_d2

    :cond_ca
    const/16 v54, 0x0

    .line 1427
    const-string v14, "cmd"

    invoke-virtual {v0, v14}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    .line 1428
    :goto_d2
    sput-object v54, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    if-eqz v0, :cond_ea

    .line 1429
    invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v55

    if-nez v55, :cond_dd

    goto :goto_ea

    :cond_dd
    invoke-virtual {v0}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    move-object/from16 v55, v6

    const-string v6, "arg"

    invoke-virtual {v0, v6}, Landroid/os/Bundle;->get(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    goto :goto_ee

    :cond_ea
    :goto_ea
    move-object/from16 v55, v6

    move-object/from16 v0, v54

    :goto_ee
    const/16 p1, 0x0

    .line 1432
    :try_start_f0
    const-string v6, "avatar_img"

    invoke-virtual {v6, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    move/from16 v56, v6

    const/4 v6, 0x1

    if-eqz v56, :cond_117

    .line 1433
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v0

    .line 1434
    invoke-static {v1, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->setOn(Landroid/content/Context;Z)V

    .line 1435
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_12c

    .line 1436
    :cond_117
    const-string v7, "bubble_img"

    invoke-virtual {v7, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_131

    .line 1438
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 1437
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    .line 1439
    const-string v0, "\u6c14\u6ce1\u56fe\u5df2\u4fdd\u5b58"

    :goto_12c
    move-object v12, v14

    :goto_12d
    move-object/from16 v7, v30

    goto/16 :goto_1716

    .line 1440
    :cond_131
    const-string v7, "ui_step"

    invoke-virtual {v7, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_14b

    .line 1443
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1444
    const-string v0, "\u8bb0\u4e0b\u4e86"

    goto :goto_12c

    .line 1445
    :cond_14b
    const-string v4, "img_path"

    invoke-virtual {v4, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4
    :try_end_151
    .catchall {:try_start_f0 .. :try_end_151} :catchall_16ed

    const-string v7, "GmUAvatar"

    const-string v56, "GmAvatar"

    move/from16 v57, v6

    const-string v6, "bg"

    move/from16 v58, v4

    const-string v4, "file"

    move-object/from16 v59, v7

    const-string v7, "uavatar"

    move-object/from16 v60, v2

    const-string v2, " \u5b57\u8282\uff09"

    move-object/from16 v61, v14

    const-string v14, "ububble"

    move-object/from16 v62, v5

    const-string v5, "avatar"

    move-object/from16 v64, v11

    const-string v11, "com.nidyaber.fuckdsmanger.gm.GmBubble"

    move-object/from16 v65, v12

    const-string v12, "\uff08"

    move-object/from16 v66, v2

    const-string v2, "setOn"

    move-object/from16 v67, v13

    const-string v13, "com.nidyaber.fuckdsmanger.gm."

    if-eqz v58, :cond_4b1

    .line 1448
    :try_start_17f
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    move-object/from16 v58, v12

    const-string v12, "\\|"

    move-object/from16 v69, v8

    const/4 v8, -0x1

    invoke-virtual {v0, v12, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    .line 1449
    aget-object v8, v0, p1

    .line 1450
    new-instance v12, Ljava/io/File;

    move-object/from16 v63, v10

    aget-object v10, v0, v57

    invoke-direct {v12, v10}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 1451
    invoke-virtual {v12}, Ljava/io/File;->canRead()Z

    move-result v10

    if-nez v10, :cond_1c3

    .line 1452
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object v0, v0, v57

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\uff09\u21d2 \u6539\u7528\u5206\u5757\u5b57\u8282"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1453
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_4ab

    .line 1454
    :cond_1c3
    invoke-static {v12}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->isDecodableImage(Ljava/io/File;)Z

    move-result v0

    if-nez v0, :cond_1ef

    .line 1458
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v15}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v12}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " \u5b57\u8282 \u21d2 \u7a7a\u6587\u4ef6/\u4e91\u56fe/\u574f\u56fe\uff09\u21d2 \u6ca1\u6709\u6539\u52a8\u4efb\u4f55\u6587\u4ef6"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1459
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_4ab

    .line 1460
    :cond_1ef
    const-string v0, "bubble"

    invoke-virtual {v0, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_33c

    invoke-virtual {v14, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_33c

    invoke-virtual {v6, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_33c

    .line 1461
    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_33c

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0
    :try_end_20d
    .catchall {:try_start_17f .. :try_end_20d} :catchall_16e7

    if-eqz v0, :cond_211

    goto/16 :goto_33c

    .line 1513
    :cond_211
    :try_start_211
    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    .line 1514
    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    .line 1513
    invoke-static {v11, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    .line 1515
    invoke-virtual {v14, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_22b

    .line 1516
    const-string v9, "useUImgName"

    move/from16 v10, p1

    new-array v11, v10, [Ljava/lang/Object;

    invoke-static {v0, v9, v11}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_23a

    .line 1517
    :cond_22b
    const-string v9, "bubble"

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_23a

    .line 1518
    const-string v9, "sImgName"

    const-string v10, "fuckds_bubble.png"

    invoke-static {v0, v9, v10}, Lde/robv/android/xposed/XposedHelpers;->setStaticObjectField(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_23a
    .catchall {:try_start_211 .. :try_end_23a} :catchall_23a

    .line 1522
    :catchall_23a
    :cond_23a
    :goto_23a
    :try_start_23a
    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_243

    move-object/from16 v6, v56

    goto :goto_258

    .line 1523
    :cond_243
    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_24c

    move-object/from16 v6, v59

    goto :goto_258

    .line 1524
    :cond_24c
    invoke-virtual {v6, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_255

    const-string v0, "GmBg"

    goto :goto_257

    :cond_255
    const-string v0, "GmBubble"
    :try_end_257
    .catchall {:try_start_23a .. :try_end_257} :catchall_16e7

    :goto_257
    move-object v6, v0

    .line 1527
    :goto_258
    :try_start_258
    invoke-virtual {v13, v6}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v9, "saveImage"

    const/4 v10, 0x2

    new-array v11, v10, [Ljava/lang/Class;

    const-class v10, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v10, v11, v14

    const-class v10, Landroid/net/Uri;

    aput-object v10, v11, v57

    .line 1529
    invoke-static {v12}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;

    move-result-object v10

    filled-new-array {v1, v10}, [Ljava/lang/Object;

    move-result-object v10

    .line 1527
    invoke-static {v0, v9, v11, v10}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14
    :try_end_276
    .catchall {:try_start_258 .. :try_end_276} :catchall_277

    goto :goto_291

    :catchall_277
    move-exception v0

    .line 1531
    :try_start_278
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, ".saveImage \u5931\u8d25\uff1a"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    move-object/from16 v14, v54

    .line 1533
    :goto_291
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, ".saveImage \u2192 "

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1535
    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_2b1

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5
    :try_end_2af
    .catchall {:try_start_278 .. :try_end_2af} :catchall_16e7

    if-eqz v5, :cond_2cc

    .line 1537
    :cond_2b1
    :try_start_2b1
    invoke-virtual {v13, v6}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const/4 v10, 0x2

    new-array v7, v10, [Ljava/lang/Class;

    const-class v8, Landroid/content/Context;

    const/4 v10, 0x0

    aput-object v8, v7, v10

    sget-object v8, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v8, v7, v57

    .line 1539
    invoke-static/range {v57 .. v57}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v8

    filled-new-array {v1, v8}, [Ljava/lang/Object;

    move-result-object v8

    .line 1537
    invoke-static {v5, v2, v7, v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2cc
    .catchall {:try_start_2b1 .. :try_end_2cc} :catchall_2cc

    .line 1544
    :catchall_2cc
    :cond_2cc
    :try_start_2cc
    instance-of v2, v14, Ljava/lang/Boolean;

    if-eqz v2, :cond_2d8

    check-cast v14, Ljava/lang/Boolean;

    invoke-virtual {v14}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2
    :try_end_2d6
    .catchall {:try_start_2cc .. :try_end_2d6} :catchall_16e7

    if-nez v2, :cond_311

    .line 1546
    :cond_2d8
    :try_start_2d8
    invoke-virtual {v13, v6}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    move/from16 v5, v57

    new-array v5, v5, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v10, 0x0

    aput-object v6, v5, v10

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v2, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    .line 1548
    instance-of v4, v2, Ljava/io/File;

    if-eqz v4, :cond_311

    .line 1549
    move-object v4, v2

    check-cast v4, Ljava/io/File;

    invoke-static {v12, v4}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->copyFile(Ljava/io/File;Ljava/io/File;)V

    .line 1550
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " \uff5c\u515c\u5e95\u62f7\u5230 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    check-cast v2, Ljava/io/File;

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_311
    .catchall {:try_start_2d8 .. :try_end_311} :catchall_311

    .line 1555
    :catchall_311
    :cond_311
    :try_start_311
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v63

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v12}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v4, " \u5b57\u8282\uff09\u2192 "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1556
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_33a
    .catchall {:try_start_311 .. :try_end_33a} :catchall_16e7

    goto/16 :goto_4ab

    .line 1467
    :cond_33c
    :goto_33c
    :try_start_33c
    invoke-virtual {v6, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3ab

    .line 1468
    new-instance v0, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v4

    const-string v5, "fuckds_bg.png"

    invoke-direct {v0, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 1469
    invoke-static {v12, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->copyFile(Ljava/io/File;Ljava/io/File;)V

    .line 1470
    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmBg"

    const/4 v10, 0x2

    new-array v5, v10, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v10, 0x0

    aput-object v6, v5, v10

    sget-object v7, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v7, v5, v57

    .line 1471
    invoke-static/range {v57 .. v57}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v7

    filled-new-array {v1, v7}, [Ljava/lang/Object;

    move-result-object v7

    .line 1470
    invoke-static {v4, v2, v5, v7}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1472
    const-string v2, "com.nidyaber.fuckdsmanger.gm.GmBg"

    const-string v4, "setMode"

    const/4 v10, 0x2

    new-array v5, v10, [Ljava/lang/Class;

    const/4 v10, 0x0

    aput-object v6, v5, v10

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v6, v5, v57

    .line 1473
    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    filled-new-array {v1, v6}, [Ljava/lang/Object;

    move-result-object v6

    .line 1472
    invoke-static {v2, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1474
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v69

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v9, v58

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\u8282\uff09\u00b7 \u5df2\u5f00\u80cc\u666f + \u5207\u300c\u56fe\u7247\u300d\u6863"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_49c

    :cond_3ab
    move-object/from16 v9, v58

    .line 1476
    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_41b

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3ba

    goto :goto_41b

    .line 1492
    :cond_3ba
    invoke-virtual {v14, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3c3

    const-string v0, "fuckds_ububble.png"

    goto :goto_3c5

    :cond_3c3
    const-string v0, "fuckds_bubble.png"

    .line 1493
    :goto_3c5
    new-instance v2, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v4

    invoke-direct {v2, v4, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 1494
    invoke-static {v12, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->copyFile(Ljava/io/File;Ljava/io/File;)V

    .line 1495
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->clearBubbleCache()V
    :try_end_3d4
    .catchall {:try_start_33c .. :try_end_3d4} :catchall_48d

    .line 1497
    :try_start_3d4
    invoke-virtual {v14, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3dd

    const-string v0, "setUImgOn"

    goto :goto_3df

    :cond_3dd
    const-string v0, "setImgOn"

    :goto_3df
    const/4 v10, 0x2

    new-array v4, v10, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v10, 0x0

    aput-object v5, v4, v10

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v5, v4, v57

    .line 1498
    invoke-static/range {v57 .. v57}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    filled-new-array {v1, v5}, [Ljava/lang/Object;

    move-result-object v5

    .line 1497
    invoke-static {v11, v0, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_3f8
    .catchall {:try_start_3d4 .. :try_end_3f8} :catchall_3f8

    .line 1501
    :catchall_3f8
    :try_start_3f8
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v4, v67

    invoke-direct {v0, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-object/from16 v10, v66

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_49c

    :cond_41b
    :goto_41b
    move-object/from16 v10, v66

    .line 1478
    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_426

    move-object/from16 v7, v56

    goto :goto_428

    :cond_426
    move-object/from16 v7, v59

    .line 1479
    :goto_428
    invoke-virtual {v13, v7}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v5, 0x1

    new-array v6, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v8

    invoke-static {v0, v4, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 1481
    instance-of v4, v0, Ljava/io/File;

    if-eqz v4, :cond_486

    .line 1482
    move-object v4, v0

    check-cast v4, Ljava/io/File;

    invoke-static {v12, v4}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->copyFile(Ljava/io/File;Ljava/io/File;)V

    .line 1483
    invoke-virtual {v13, v7}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const/4 v6, 0x2

    new-array v6, v6, [Ljava/lang/Class;

    const/4 v14, 0x0

    aput-object v5, v6, v14

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v5, v6, v57

    .line 1485
    invoke-static/range {v57 .. v57}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    filled-new-array {v1, v5}, [Ljava/lang/Object;

    move-result-object v5

    .line 1483
    invoke-static {v4, v2, v6, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1486
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v65

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    move-object v4, v0

    check-cast v4, Ljava/io/File;

    invoke-virtual {v4}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    check-cast v0, Ljava/io/File;

    .line 1487
    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_49c

    :cond_486
    move-object/from16 v0, v64

    .line 1489
    invoke-virtual {v7, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_48c
    .catchall {:try_start_3f8 .. :try_end_48c} :catchall_48d

    goto :goto_49c

    :catchall_48d
    move-exception v0

    .line 1504
    :try_start_48e
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v62

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1506
    :goto_49c
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_4ab
    move-object/from16 v7, v30

    move-object/from16 v12, v61

    goto/16 :goto_1716

    :cond_4b1
    move-object v9, v12

    move-object/from16 v10, v66

    .line 1558
    const-string v8, "img_begin"
    :try_end_4b6
    .catchall {:try_start_48e .. :try_end_4b6} :catchall_16e7

    move-object/from16 v12, v61

    :try_start_4b8
    invoke-virtual {v8, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_50c

    .line 1560
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "\\|"

    const/4 v8, -0x1

    invoke-virtual {v0, v2, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    .line 1561
    new-instance v2, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    move-object/from16 v6, v60

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v14, 0x0

    aget-object v6, v0, v14

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v2, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 1562
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v4

    if-eqz v4, :cond_4ec

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    .line 1563
    :cond_4ec
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v55

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v14, 0x0

    aget-object v4, v0, v14

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v57, 0x1

    aget-object v0, v0, v57

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1564
    :cond_50c
    const-string v8, "img_chunk"

    invoke-virtual {v8, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_569

    .line 1565
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "\\|"

    const/4 v8, -0x1

    invoke-virtual {v0, v2, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    const/16 v68, 0x2

    .line 1566
    aget-object v2, v0, v68

    const/4 v14, 0x0

    invoke-static {v2, v14}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v2

    .line 1567
    new-instance v4, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v5

    new-instance v6, Ljava/lang/StringBuilder;

    move-object/from16 v7, v53

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object v7, v0, v14

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-direct {v4, v5, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 1568
    new-instance v5, Ljava/io/FileOutputStream;

    const/4 v6, 0x1

    invoke-direct {v5, v4, v6}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V

    .line 1569
    invoke-virtual {v5, v2}, Ljava/io/FileOutputStream;->write([B)V

    .line 1570
    invoke-virtual {v5}, Ljava/io/FileOutputStream;->close()V

    .line 1571
    new-instance v4, Ljava/lang/StringBuilder;

    move-object/from16 v5, v52

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    aget-object v0, v0, v6

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v0, v2

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1572
    :cond_569
    const-string v8, "img_end"

    invoke-virtual {v8, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_696

    .line 1573
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 1574
    new-instance v8, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v9

    new-instance v10, Ljava/lang/StringBuilder;

    move-object/from16 v15, v51

    invoke-direct {v10, v15}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-direct {v8, v9, v10}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 1575
    invoke-virtual {v8}, Ljava/io/File;->length()J

    move-result-wide v9

    .line 1577
    invoke-virtual {v5, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v15

    if-nez v15, :cond_625

    invoke-virtual {v7, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_59e

    goto/16 :goto_625

    .line 1586
    :cond_59e
    invoke-virtual {v6, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_5cc

    .line 1587
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmBg"

    const/4 v5, 0x1

    new-array v2, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v2, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v0, v4, v2, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 1588
    instance-of v2, v0, Ljava/io/File;

    if-eqz v2, :cond_5c8

    .line 1589
    move-object v2, v0

    check-cast v2, Ljava/io/File;

    invoke-static {v8, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->copyFile(Ljava/io/File;Ljava/io/File;)V

    .line 1590
    check-cast v0, Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v14

    goto/16 :goto_66f

    :cond_5c8
    move-object/from16 v14, v54

    goto/16 :goto_66f

    .line 1592
    :cond_5cc
    const-string v2, "bubble"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_606

    invoke-virtual {v14, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_5db

    goto :goto_606

    .line 1600
    :cond_5db
    const-string v0, "saveImage"

    const/4 v6, 0x2

    new-array v2, v6, [Ljava/lang/Class;

    const-class v4, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v4, v2, v14

    const-class v4, Landroid/net/Uri;

    const/16 v57, 0x1

    aput-object v4, v2, v57

    .line 1602
    invoke-static {v8}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;

    move-result-object v4

    filled-new-array {v1, v4}, [Ljava/lang/Object;

    move-result-object v4

    .line 1600
    invoke-static {v11, v0, v2, v4}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 1603
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v50

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    goto :goto_66f

    .line 1594
    :cond_606
    :goto_606
    invoke-virtual {v14, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_60f

    const-string v0, "fuckds_ububble.png"

    goto :goto_611

    :cond_60f
    const-string v0, "fuckds_bubble.png"

    .line 1595
    :goto_611
    new-instance v2, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v4

    invoke-direct {v2, v4, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 1596
    invoke-static {v8, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->copyFile(Ljava/io/File;Ljava/io/File;)V

    .line 1597
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->clearBubbleCache()V

    .line 1598
    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v14

    goto :goto_66f

    .line 1578
    :cond_625
    :goto_625
    invoke-virtual {v5, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_62e

    move-object/from16 v7, v56

    goto :goto_630

    :cond_62e
    move-object/from16 v7, v59

    .line 1579
    :goto_630
    invoke-virtual {v13, v7}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v5, 0x1

    new-array v6, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v11

    invoke-static {v0, v4, v6, v11}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 1580
    instance-of v4, v0, Ljava/io/File;

    if-eqz v4, :cond_5c8

    .line 1581
    move-object v4, v0

    check-cast v4, Ljava/io/File;

    invoke-static {v8, v4}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->copyFile(Ljava/io/File;Ljava/io/File;)V

    .line 1582
    invoke-virtual {v13, v7}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const/4 v6, 0x2

    new-array v6, v6, [Ljava/lang/Class;

    const/4 v14, 0x0

    aput-object v5, v6, v14

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v5, v6, v57

    .line 1583
    invoke-static/range {v57 .. v57}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    filled-new-array {v1, v5}, [Ljava/lang/Object;

    move-result-object v5

    .line 1582
    invoke-static {v4, v2, v6, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1584
    check-cast v0, Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v14

    .line 1605
    :goto_66f
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v49

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v9, v10}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " \u5b57\u8282\uff09\u2192 "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1606
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_12d

    .line 1607
    :cond_696
    const-string v6, "pick_avatar"

    invoke-virtual {v6, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_1685

    const-string v6, "pick_uavatar"

    invoke-virtual {v6, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_1685

    const-string v6, "pick_bubble"

    .line 1608
    invoke-virtual {v6, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_6b0

    goto/16 :goto_1685

    .line 1617
    :cond_6b0
    const-string v6, "img_bytes"

    invoke-virtual {v6, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_799

    .line 1620
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    const-string v6, "\u001f"

    const/4 v8, -0x1

    invoke-virtual {v0, v6, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    const/4 v14, 0x0

    .line 1621
    aget-object v6, v0, v14

    const/4 v7, 0x1

    .line 1622
    aget-object v0, v0, v7

    invoke-static {v0, v14}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v0

    .line 1624
    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_6eb

    .line 1625
    const-string v5, "com.nidyaber.fuckdsmanger.gm.GmAvatar"

    new-array v8, v7, [Ljava/lang/Class;

    const-class v7, Landroid/content/Context;

    aput-object v7, v8, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v7

    invoke-static {v5, v4, v8, v7}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 1627
    instance-of v5, v4, Ljava/io/File;

    if-eqz v5, :cond_6eb

    move-object v14, v4

    check-cast v14, Ljava/io/File;

    goto :goto_6ed

    :cond_6eb
    move-object/from16 v14, v54

    :goto_6ed
    if-eqz v14, :cond_732

    .line 1630
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, v14}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 1631
    invoke-virtual {v4, v0}, Ljava/io/FileOutputStream;->write([B)V

    .line 1632
    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    .line 1633
    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmAvatar"

    const/4 v6, 0x2

    new-array v5, v6, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v7, 0x0

    aput-object v6, v5, v7

    sget-object v6, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v6, v5, v57

    .line 1634
    invoke-static/range {v57 .. v57}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v6

    filled-new-array {v1, v6}, [Ljava/lang/Object;

    move-result-object v6

    .line 1633
    invoke-static {v4, v2, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1635
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v48

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v14}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v0, v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_788

    .line 1638
    :cond_732
    new-instance v2, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    move-object/from16 v7, v47

    invoke-direct {v5, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v2, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 1639
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 1640
    invoke-virtual {v4, v0}, Ljava/io/FileOutputStream;->write([B)V

    .line 1641
    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    .line 1642
    const-string v4, "saveImage"

    const/4 v6, 0x2

    new-array v5, v6, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v6, v5, v14

    const-class v6, Landroid/net/Uri;

    const/16 v57, 0x1

    aput-object v6, v5, v57

    .line 1644
    invoke-static {v2}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;

    move-result-object v2

    filled-new-array {v1, v2}, [Ljava/lang/Object;

    move-result-object v2

    .line 1642
    invoke-static {v11, v4, v5, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    .line 1645
    new-instance v4, Ljava/lang/StringBuilder;

    move-object/from16 v5, v46

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v0, v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1647
    :goto_788
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_12d

    .line 1648
    :cond_799
    const-string v4, "uavatar_on"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_7d3

    .line 1649
    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmUAvatar"

    const/4 v6, 0x2

    new-array v5, v6, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v6, v5, v14

    sget-object v6, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v6, v5, v57

    .line 1650
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asBool(Ljava/lang/Object;)Z

    move-result v6

    invoke-static {v6}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v6

    filled-new-array {v1, v6}, [Ljava/lang/Object;

    move-result-object v6

    .line 1649
    invoke-static {v4, v2, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1651
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asBool(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7c9

    const-string v0, "\u5df2\u5f00\u542f"

    goto :goto_7cb

    :cond_7c9
    const-string v0, "\u5df2\u5173\u95ed"

    :goto_7cb
    move-object/from16 v2, v45

    invoke-virtual {v2, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1652
    :cond_7d3
    const-string v4, "avatar_on"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_826

    .line 1653
    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmAvatar"

    const/4 v6, 0x2

    new-array v5, v6, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v6, v5, v14

    sget-object v6, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v6, v5, v57

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asBool(Ljava/lang/Object;)Z

    move-result v6

    invoke-static {v6}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v6

    filled-new-array {v1, v6}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v4, v2, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1654
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v44

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asBool(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_80a

    const-string v0, "\u5df2\u5f00\u542f"

    goto :goto_80c

    :cond_80a
    const-string v0, "\u5df2\u5173\u95ed"

    :goto_80c
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\uff08\u6709\u6ca1\u6709\u56fe\uff1a"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1655
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1656
    :cond_826
    const-string v4, "db_on"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_860

    .line 1657
    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmDb"

    const/4 v6, 0x2

    new-array v5, v6, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v6, v5, v14

    sget-object v6, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v6, v5, v57

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asBool(Ljava/lang/Object;)Z

    move-result v6

    invoke-static {v6}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v6

    filled-new-array {v1, v6}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v4, v2, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1658
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->asBool(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_856

    const-string v0, "\u5df2\u5f00\u542f"

    goto :goto_858

    :cond_856
    const-string v0, "\u5df2\u5173\u95ed"

    :goto_858
    move-object/from16 v2, v41

    invoke-virtual {v2, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1659
    :cond_860
    const-string v4, "db_info"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_88d

    .line 1660
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v42

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->count(Landroid/content/Context;)I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u6761\u5907\u4efd \u00b7 \u5360\u7528 "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->sizeKb(Landroid/content/Context;)J

    move-result-wide v4

    invoke-virtual {v0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " KB"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1661
    :cond_88d
    const-string v4, "db_clear"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_8b1

    .line 1662
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->clear(Landroid/content/Context;)V

    .line 1663
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v40

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->count(Landroid/content/Context;)I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u6761\uff09"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1664
    :cond_8b1
    const-string v4, "dev_reset"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_8d2

    .line 1665
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->reset()Ljava/lang/String;

    move-result-object v0

    .line 1666
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v39

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\uff08\u91cd\u542f\u5bbf\u4e3b\u540e\u751f\u6548\uff09"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1667
    :cond_8d2
    const-string v4, "probe_toggle"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_8f0

    .line 1668
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->toggle(Landroid/content/Context;)V

    .line 1669
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->shown()Z

    move-result v0

    if-eqz v0, :cond_8e6

    const-string v0, "\u5df2\u6302\u4e0a"

    goto :goto_8e8

    :cond_8e6
    const-string v0, "\u5df2\u53d6\u4e0b"

    :goto_8e8
    move-object/from16 v2, v38

    invoke-virtual {v2, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1670
    :cond_8f0
    const-string v4, "gray_put"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4
    :try_end_8f6
    .catchall {:try_start_4b8 .. :try_end_8f6} :catchall_16e5

    const-string v5, "kv_remote_settings_"

    const-string v6, ""

    if-eqz v4, :cond_945

    .line 1672
    :try_start_8fc
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "\u001f"

    const/4 v8, -0x1

    invoke-virtual {v0, v2, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    const/4 v14, 0x0

    .line 1673
    aget-object v2, v0, v14

    invoke-virtual {v2, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_919

    .line 1674
    aget-object v2, v0, v14

    const/16 v4, 0x13

    invoke-virtual {v2, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    goto :goto_91b

    :cond_919
    aget-object v2, v0, v14

    :goto_91b
    const/16 v57, 0x1

    .line 1675
    aget-object v4, v0, v57

    .line 1676
    array-length v5, v0

    const/4 v10, 0x2

    if-le v5, v10, :cond_925

    aget-object v6, v0, v10

    .line 1677
    :cond_925
    invoke-static {v1, v2, v4, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->grayWrite(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 1678
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v4, v37

    invoke-direct {v0, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\uff08\u539f\u503c\u5df2\u5907\u4efd \u00b7 \u5df2\u76f4\u63a5\u5199\u5165\u5bbf\u4e3b\u771f\u5b9e\u952e\uff09"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1679
    :cond_945
    const-string v4, "state_all"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_9b2

    .line 1681
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 1682
    const-string v13, "ui_avatar_on"

    const-string v14, "ui_uavatar_on"

    const-string v15, "ui_db_on"

    const-string v16, "fuckds_nick"

    const-string v17, "ui_nick"

    const-string v18, "ui_db_info"

    const-string v19, "ui_env_on"

    const-string v20, "ui_env_api"

    const-string v21, "ui_probe_on"

    filled-new-array/range {v13 .. v21}, [Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x0

    :goto_969
    const/16 v5, 0x9

    if-ge v4, v5, :cond_97b

    aget-object v5, v2, v4

    .line 1685
    invoke-static {v1, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->uiGet(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    if-eqz v6, :cond_978

    .line 1686
    invoke-virtual {v0, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_978
    add-int/lit8 v4, v4, 0x1

    goto :goto_969

    .line 1688
    :cond_97b
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 1689
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u72b6\u6001\u56de\u8bfb "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lorg/json/JSONObject;->length()I

    move-result v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " \u9879"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 1690
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u3010FdmBridge\u3011state_all\uff1a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    move-object v0, v2

    goto/16 :goto_12d

    .line 1691
    :cond_9b2
    const-string v4, "glass_snap"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4
    :try_end_9b8
    .catchall {:try_start_8fc .. :try_end_9b8} :catchall_16e5

    if-eqz v4, :cond_9f0

    .line 1696
    :try_start_9ba
    const-string v0, "com.nidyaber.fuckdsmanger.glass.GmDebug"

    const-class v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    .line 1698
    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    .line 1696
    invoke-static {v0, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    .line 1699
    const-string v2, "ENABLED"

    invoke-static {v0, v2}, Lde/robv/android/xposed/XposedHelpers;->getStaticObjectField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 1700
    sget-object v2, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {v2, v0}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9d8

    .line 1701
    const-string v0, "\u81ea\u62cd\u529f\u80fd\u672a\u6536\u5f55\uff08\u8fd9\u662f\u6b63\u5f0f\u5305\uff09"

    goto/16 :goto_12d

    .line 1703
    :cond_9d8
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->snap()V

    .line 1704
    const-string v0, "\u5df2\u89e6\u53d1\u81ea\u62cd\uff0c\u7a0d\u540e\u770b \u3010GmGlass\u3011\u81ea\u62cd OK"
    :try_end_9dd
    .catchall {:try_start_9ba .. :try_end_9dd} :catchall_9df

    goto/16 :goto_12d

    :catchall_9df
    move-exception v0

    .line 1707
    :try_start_9e0
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v36

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1709
    :cond_9f0
    const-string v4, "cfg_put"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_b1a

    .line 1712
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "\u001f"

    const/4 v8, -0x1

    invoke-virtual {v0, v2, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    const/4 v14, 0x0

    .line 1713
    aget-object v2, v0, v14

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->alias(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/16 v57, 0x1

    .line 1714
    aget-object v4, v0, v57

    .line 1715
    array-length v5, v0

    const/4 v10, 0x2

    if-le v5, v10, :cond_a16

    aget-object v0, v0, v10

    move-object v5, v0

    goto :goto_a17

    :cond_a16
    move-object v5, v6

    .line 1717
    :goto_a17
    const-string v0, "b"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a38

    .line 1718
    const-string v0, "true"

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_a32

    const-string v0, "1"

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a30

    goto :goto_a32

    :cond_a30
    const/4 v0, 0x0

    goto :goto_a33

    :cond_a32
    :goto_a32
    const/4 v0, 0x1

    :goto_a33
    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->dispatch(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    goto :goto_a39

    :cond_a38
    const/4 v0, 0x0

    :goto_a39
    if-nez v0, :cond_a3f

    .line 1722
    invoke-static {v1, v2, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->uiSet(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    :cond_a3f
    if-nez v0, :cond_a4d

    .line 1726
    const-string v7, "s"

    invoke-virtual {v7, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_a4d

    .line 1727
    invoke-static {v1, v2, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->dispatchText(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0
    :try_end_a4d
    .catchall {:try_start_9e0 .. :try_end_a4d} :catchall_16e5

    :cond_a4d
    move v7, v0

    if-nez v7, :cond_a71

    .line 1731
    :try_start_a50
    invoke-static {v1, v2, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->bak(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 1732
    invoke-static {v1, v2, v5, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_a56
    .catchall {:try_start_a50 .. :try_end_a56} :catchall_a57

    goto :goto_a71

    :catchall_a57
    move-exception v0

    .line 1734
    :try_start_a58
    new-instance v4, Ljava/lang/StringBuilder;

    move-object/from16 v8, v35

    invoke-direct {v4, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "\uff1a"

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_a71
    .catchall {:try_start_a58 .. :try_end_a71} :catchall_16e5

    :cond_a71
    :goto_a71
    if-eqz v2, :cond_a7e

    .line 1740
    :try_start_a73
    const-string v0, "fuckds_glass_"

    invoke-virtual {v2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_a7e

    .line 1741
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->refresh(Landroid/content/Context;)V
    :try_end_a7e
    .catchall {:try_start_a73 .. :try_end_a7e} :catchall_a7e

    .line 1747
    :catchall_a7e
    :cond_a7e
    :try_start_a7e
    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    .line 1748
    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    .line 1747
    invoke-static {v11, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    .line 1749
    invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v0

    array-length v4, v0

    const/4 v8, 0x0

    :goto_a8e
    if-ge v8, v4, :cond_ac3

    aget-object v9, v0, v8

    .line 1750
    invoke-virtual {v9}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v10

    invoke-static {v10}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v10

    if-eqz v10, :cond_abe

    .line 1751
    invoke-virtual {v9}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v10

    sget-object v11, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-ne v10, v11, :cond_abe

    .line 1752
    invoke-virtual {v9}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v10

    const-string v11, "read"

    invoke-virtual {v10, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v10

    if-eqz v10, :cond_abe

    const/4 v10, 0x1

    .line 1753
    invoke-virtual {v9, v10}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    move-object/from16 v10, v54

    const/4 v14, 0x0

    .line 1754
    invoke-virtual {v9, v10, v14}, Ljava/lang/reflect/Field;->setBoolean(Ljava/lang/Object;Z)V
    :try_end_abe
    .catchall {:try_start_a7e .. :try_end_abe} :catchall_ac3

    :cond_abe
    add-int/lit8 v8, v8, 0x1

    const/16 v54, 0x0

    goto :goto_a8e

    .line 1759
    :catchall_ac3
    :cond_ac3
    :try_start_ac3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " = "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v7, :cond_ad8

    const-string v4, "\uff08\u8d70\u6a21\u5757\u5165\u53e3\uff09"

    goto :goto_ada

    :cond_ad8
    const-string v4, "\uff08\u5199\u5b58\u50a8\uff09"

    :goto_ada
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1762
    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->uiGet(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_ae8

    goto :goto_af8

    .line 1766
    :cond_ae8
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-static {v4, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->anyValue(Landroid/content/SharedPreferences;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    if-nez v4, :cond_af3

    goto :goto_af7

    .line 1767
    :cond_af3
    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    :goto_af7
    move-object v4, v6

    .line 1769
    :goto_af8
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "{\"key\":\""

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\",\"ok\":true,\"value\":\""

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\"}"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    goto/16 :goto_12d

    :cond_b1a
    if-eqz v12, :cond_c73

    .line 1770
    const-string v4, "music_"

    invoke-virtual {v12, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_c73

    .line 1773
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v2

    if-nez v2, :cond_b31

    .line 1775
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->install(Landroid/content/Context;)V

    .line 1776
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v2

    :cond_b31
    const/4 v4, 0x6

    .line 1778
    invoke-virtual {v12, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    .line 1780
    const-string v5, "login_save"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5
    :try_end_b3c
    .catchall {:try_start_ac3 .. :try_end_b3c} :catchall_16e5

    if-eqz v5, :cond_b97

    if-nez v0, :cond_b42

    move-object v0, v6

    goto :goto_b46

    .line 1783
    :cond_b42
    :try_start_b42
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 1784
    :goto_b46
    const-string v5, "\u001f"

    const/4 v8, -0x1

    invoke-virtual {v0, v5, v8}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    .line 1785
    new-instance v5, Ljava/lang/StringBuilder;

    move-object/from16 v7, v34

    invoke-direct {v5, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v14, 0x0

    aget-object v7, v0, v14

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, " \u5206\u6bb5\u6570="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v7, v0

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v14, 0x0

    .line 1787
    aget-object v5, v0, v14

    .line 1788
    array-length v7, v0

    const/4 v10, 0x1

    if-le v7, v10, :cond_b78

    aget-object v7, v0, v10

    goto :goto_b79

    :cond_b78
    move-object v7, v6

    .line 1789
    :goto_b79
    array-length v8, v0

    const/4 v10, 0x2

    if-le v8, v10, :cond_b7f

    aget-object v6, v0, v10

    .line 1787
    :cond_b7f
    invoke-static {v1, v5, v7, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->save(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_b87

    goto/16 :goto_c40

    .line 1790
    :cond_b87
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->lastOp()Ljava/lang/String;
    :try_end_b8a
    .catchall {:try_start_b42 .. :try_end_b8a} :catchall_b8c

    goto/16 :goto_c40

    :catchall_b8c
    move-exception v0

    .line 1792
    :try_start_b8d
    const-string v5, "\u3010FdmBridge\u3011\u4fdd\u5b58\u767b\u5f55\u6001\u5931\u8d25"

    invoke-static {v5, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 1793
    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    goto/16 :goto_c40

    .line 1795
    :cond_b97
    const-string v5, "login_clear"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_ba4

    .line 1796
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->clear(Landroid/content/Context;)Z

    goto/16 :goto_c40

    .line 1798
    :cond_ba4
    const-string v5, "os_mode"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5
    :try_end_baa
    .catchall {:try_start_b8d .. :try_end_baa} :catchall_16e5

    if-eqz v5, :cond_bd9

    .line 1801
    :try_start_bac
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    .line 1802
    const-string v5, "fuckds_music_os"

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v6

    const-string v7, "i"

    invoke-static {v1, v5, v6, v7}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 1803
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->setOsMode(I)V

    .line 1804
    new-instance v5, Ljava/lang/StringBuilder;

    move-object/from16 v6, v33

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "\uff08pc=0 / android=1 / iphone=2\uff09\uff0c\u5df2\u5b58\u914d\u7f6e"

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_bd8
    .catchall {:try_start_bac .. :try_end_bd8} :catchall_c40

    goto :goto_c40

    :cond_bd9
    if-eqz v2, :cond_c40

    .line 1811
    :try_start_bdb
    const-string v5, "toggle"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_be7

    .line 1812
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->toggle()V

    goto :goto_c40

    .line 1813
    :cond_be7
    const-string v5, "next"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_bf3

    .line 1814
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->next()V

    goto :goto_c40

    .line 1815
    :cond_bf3
    const-string v5, "prev"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_bff

    .line 1816
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->prev()V

    goto :goto_c40

    .line 1817
    :cond_bff
    const-string v5, "stop"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_c0b

    .line 1818
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->stop()V

    goto :goto_c40

    .line 1819
    :cond_c0b
    const-string v5, "clear"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_c17

    .line 1820
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->clearQueue()V

    goto :goto_c40

    .line 1821
    :cond_c17
    const-string v5, "loop"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_c2d

    .line 1822
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object v0

    iget v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    const/16 v57, 0x1

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->setLoop(I)V

    goto :goto_c40

    .line 1823
    :cond_c2d
    const-string v5, "seek"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5
    :try_end_c33
    .catchall {:try_start_bdb .. :try_end_c33} :catchall_16e5

    if-eqz v5, :cond_c40

    .line 1825
    :try_start_c35
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->seekTo(I)V
    :try_end_c40
    .catchall {:try_start_c35 .. :try_end_c40} :catchall_c40

    .line 1830
    :catchall_c40
    :cond_c40
    :goto_c40
    :try_start_c40
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v5, v32

    invoke-direct {v0, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "\uff08\u64ad\u653e\u5668="

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v2, :cond_c53

    const/4 v2, 0x1

    goto :goto_c54

    :cond_c53
    const/4 v2, 0x0

    :goto_c54
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "\uff09"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1831
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v31

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_12d

    .line 1832
    :cond_c73
    const-string v4, "cfg_state"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_e67

    .line 1834
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V
    :try_end_c80
    .catchall {:try_start_c40 .. :try_end_c80} :catchall_16e5

    .line 1835
    :try_start_c80
    const-string v2, "avatar_on"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->isOn(Landroid/content/Context;)Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_end_c89
    .catchall {:try_start_c80 .. :try_end_c89} :catchall_c89

    .line 1836
    :catchall_c89
    :try_start_c89
    const-string v2, "avatar_img"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_end_c92
    .catchall {:try_start_c89 .. :try_end_c92} :catchall_c92

    .line 1837
    :catchall_c92
    :try_start_c92
    const-string v2, "db_on"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->isOn(Landroid/content/Context;)Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_end_c9b
    .catchall {:try_start_c92 .. :try_end_c9b} :catchall_c9b

    .line 1838
    :catchall_c9b
    :try_start_c9b
    const-string v2, "db_count"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->count(Landroid/content/Context;)I

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    :try_end_ca4
    .catchall {:try_start_c9b .. :try_end_ca4} :catchall_ca4

    .line 1839
    :catchall_ca4
    :try_start_ca4
    const-string v2, "device_on"

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->isOn()Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_end_cad
    .catchall {:try_start_ca4 .. :try_end_cad} :catchall_cad

    .line 1840
    :catchall_cad
    :try_start_cad
    const-string v2, "probe_on"

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->shown()Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_end_cb6
    .catchall {:try_start_cad .. :try_end_cb6} :catchall_cb6

    .line 1841
    :catchall_cb6
    :try_start_cb6
    const-string v2, "note_on"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->isOn(Landroid/content/Context;)Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_end_cbf
    .catchall {:try_start_cb6 .. :try_end_cbf} :catchall_cbf

    .line 1842
    :catchall_cbf
    :try_start_cbf
    const-string v2, "bar_on"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->isOn(Landroid/content/Context;)Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_end_cc8
    .catchall {:try_start_cbf .. :try_end_cc8} :catchall_cc8

    .line 1846
    :catchall_cc8
    :try_start_cc8
    const-string v2, "sysprompt_text"

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_cd1
    .catchall {:try_start_cc8 .. :try_end_cd1} :catchall_cd1

    .line 1851
    :catchall_cd1
    :try_start_cd1
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v2

    if-nez v2, :cond_cd9

    const/4 v14, 0x0

    goto :goto_cdd

    .line 1852
    :cond_cd9
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object v14

    .line 1853
    :goto_cdd
    const-string v2, "music_playing"

    if-eqz v14, :cond_ce7

    iget-boolean v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->playing:Z

    if-eqz v4, :cond_ce7

    const/4 v4, 0x1

    goto :goto_ce8

    :cond_ce7
    const/4 v4, 0x0

    :goto_ce8
    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 1854
    const-string v2, "music_name"

    if-eqz v14, :cond_cf9

    iget-object v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    if-nez v4, :cond_cf4

    goto :goto_cf9

    :cond_cf4
    iget-object v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v4, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    goto :goto_cfa

    :cond_cf9
    :goto_cf9
    move-object v4, v6

    :goto_cfa
    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 1855
    const-string v2, "music_artist"

    if-eqz v14, :cond_d0a

    iget-object v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    if-nez v4, :cond_d06

    goto :goto_d0a

    :cond_d06
    iget-object v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v6, v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    :cond_d0a
    :goto_d0a
    invoke-virtual {v0, v2, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 1856
    const-string v2, "music_pos"

    if-nez v14, :cond_d13

    const/4 v4, 0x0

    goto :goto_d15

    :cond_d13
    iget v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->pos:I

    :goto_d15
    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 1857
    const-string v2, "music_dur"

    if-nez v14, :cond_d1e

    const/4 v4, 0x0

    goto :goto_d20

    :cond_d1e
    iget v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    :goto_d20
    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 1858
    const-string v2, "music_queue"

    if-nez v14, :cond_d29

    const/4 v4, 0x0

    goto :goto_d2b

    :cond_d29
    iget v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->queueSize:I

    :goto_d2b
    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 1859
    const-string v2, "music_loop"

    if-nez v14, :cond_d34

    const/4 v4, 0x0

    goto :goto_d36

    :cond_d34
    iget v4, v14, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    :goto_d36
    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    :try_end_d39
    .catchall {:try_start_cd1 .. :try_end_d39} :catchall_d39

    .line 1863
    :catchall_d39
    :try_start_d39
    const-string v2, "music_logged"

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->loggedIn()Z

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 1864
    const-string v2, "music_user"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->summary(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 1866
    const-string v2, "music_login_diag"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->diag(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 1867
    const-string v2, "music_os_mode"

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->osMode()I

    move-result v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    :try_end_d5d
    .catchall {:try_start_d39 .. :try_end_d5d} :catchall_d5d

    .line 1869
    :catchall_d5d
    :try_start_d5d
    const-string v2, "bubble_on"

    const-string v4, "on"

    const/4 v14, 0x0

    new-array v5, v14, [Ljava/lang/Class;

    new-array v6, v14, [Ljava/lang/Object;

    invoke-static {v11, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_d6d
    .catchall {:try_start_d5d .. :try_end_d6d} :catchall_d6d

    .line 1871
    :catchall_d6d
    :try_start_d6d
    const-string v2, "ububble_on"

    const-string v4, "uOn"

    const/4 v14, 0x0

    new-array v5, v14, [Ljava/lang/Class;

    new-array v6, v14, [Ljava/lang/Object;

    invoke-static {v11, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_d7d
    .catchall {:try_start_d6d .. :try_end_d7d} :catchall_d7d

    .line 1873
    :catchall_d7d
    :try_start_d7d
    const-string v2, "bubble_img"

    const-string v4, "imgOn"

    const/4 v14, 0x0

    new-array v5, v14, [Ljava/lang/Class;

    new-array v6, v14, [Ljava/lang/Object;

    invoke-static {v11, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_d8d
    .catchall {:try_start_d7d .. :try_end_d8d} :catchall_d8d

    .line 1875
    :catchall_d8d
    :try_start_d8d
    const-string v2, "ububble_img"

    const-string v4, "uImgOn"

    const/4 v14, 0x0

    new-array v5, v14, [Ljava/lang/Class;

    new-array v6, v14, [Ljava/lang/Object;

    invoke-static {v11, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_d9d
    .catchall {:try_start_d8d .. :try_end_d9d} :catchall_d9d

    .line 1877
    :catchall_d9d
    :try_start_d9d
    const-string v2, "name"

    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmName"

    const-string v5, "getText"

    const/4 v10, 0x1

    new-array v6, v10, [Ljava/lang/Class;

    const-class v7, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v7, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v7

    invoke-static {v4, v5, v6, v7}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_db6
    .catchall {:try_start_d9d .. :try_end_db6} :catchall_db6

    .line 1880
    :catchall_db6
    :try_start_db6
    const-string v2, "welcome"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->helloLines(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_dbf
    .catchall {:try_start_db6 .. :try_end_dbf} :catchall_dbf

    .line 1881
    :catchall_dbf
    :try_start_dbf
    const-string v2, "suggest_text"

    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmSuggest"

    const/4 v5, 0x1

    new-array v6, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v5
    :try_end_dcf
    .catchall {:try_start_dbf .. :try_end_dcf} :catchall_dd9

    move-object/from16 v7, v30

    :try_start_dd1
    invoke-static {v4, v7, v6, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_dd8
    .catchall {:try_start_dd1 .. :try_end_dd8} :catchall_ddb

    goto :goto_ddb

    :catchall_dd9
    move-object/from16 v7, v30

    .line 1883
    :catchall_ddb
    :goto_ddb
    :try_start_ddb
    const-string v2, "prompt"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->promptLines(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_de4
    .catchall {:try_start_ddb .. :try_end_de4} :catchall_de4

    .line 1884
    :catchall_de4
    :try_start_de4
    const-string v2, "env_on"

    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmEnv"

    const-string v5, "isOn"

    const/4 v10, 0x1

    new-array v6, v10, [Ljava/lang/Class;

    const-class v8, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v8, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v8

    invoke-static {v4, v5, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_dfd
    .catchall {:try_start_de4 .. :try_end_dfd} :catchall_dfd

    .line 1886
    :catchall_dfd
    :try_start_dfd
    const-string v2, "env_api"

    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmEnv"

    const-string v5, "isApi"

    const/4 v10, 0x1

    new-array v6, v10, [Ljava/lang/Class;

    const-class v8, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v8, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v8

    invoke-static {v4, v5, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_e16
    .catchall {:try_start_dfd .. :try_end_e16} :catchall_e16

    .line 1888
    :catchall_e16
    :try_start_e16
    const-string v2, "model_switch"

    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmModel"

    const-string v5, "isOn"

    const/4 v10, 0x1

    new-array v6, v10, [Ljava/lang/Class;

    const-class v8, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v8, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v8

    invoke-static {v4, v5, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_e2f
    .catchall {:try_start_e16 .. :try_end_e2f} :catchall_e2f

    .line 1890
    :catchall_e2f
    :try_start_e2f
    const-string v2, "uavatar_on"

    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmUAvatar"

    const-string v5, "isOn"

    const/4 v10, 0x1

    new-array v6, v10, [Ljava/lang/Class;

    const-class v8, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v8, v6, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v8

    invoke-static {v4, v5, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_e48
    .catchall {:try_start_e2f .. :try_end_e48} :catchall_e48

    .line 1892
    :catchall_e48
    :try_start_e48
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 1893
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v29

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONObject;->length()I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u9879"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    :cond_e67
    move-object/from16 v7, v30

    .line 1894
    const-string v4, "name_put"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_eab

    .line 1895
    const-string v2, "com.nidyaber.fuckdsmanger.gm.GmName"

    const-string v4, "setText"

    const/4 v6, 0x2

    new-array v5, v6, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v6, v5, v14

    const-class v6, Ljava/lang/String;

    const/16 v57, 0x1

    aput-object v6, v5, v57

    .line 1896
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    filled-new-array {v1, v6}, [Ljava/lang/Object;

    move-result-object v6

    .line 1895
    invoke-static {v2, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1897
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v28

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff09"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1898
    :cond_eab
    const-string v4, "hello_reset"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_ee8

    .line 1901
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmHello"

    const-string v2, "restore"

    const/4 v10, 0x1

    new-array v4, v10, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v4, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v0, v2, v4, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1902
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmHello"

    const-string v2, "reapply"

    const/4 v10, 0x1

    new-array v4, v10, [Ljava/lang/Class;

    const/4 v14, 0x0

    aput-object v5, v4, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v0, v2, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 1903
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v27

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1904
    :cond_ee8
    const-string v4, "suggest_reset"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f07

    .line 1905
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmSuggest"

    const-string v2, "restore"

    const/4 v10, 0x1

    new-array v4, v10, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v4, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v0, v2, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1906
    const-string v0, "\u56de\u590d\u5efa\u8bae\u5df2\u6062\u590d\u9ed8\u8ba4"

    goto/16 :goto_1716

    .line 1907
    :cond_f07
    const-string v4, "rich_spec"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f15

    .line 1912
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->mergeIntoSystemPrompt()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1913
    :cond_f15
    const-string v4, "suggest_spec"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f23

    .line 1917
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->mergeSuggestIntoSystemPrompt()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1918
    :cond_f23
    const-string v4, "pvar_spec"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f31

    .line 1923
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->mergeIntoSystemPrompt()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1924
    :cond_f31
    const-string v4, "specs_clear"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f3f

    .line 1927
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->removeSpecs()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1928
    :cond_f3f
    const-string v4, "spec_remove"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_f7a

    if-nez v0, :cond_f4a

    goto :goto_f4e

    .line 1932
    :cond_f4a
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    .line 1933
    :goto_f4e
    const-string v0, "music"

    invoke-virtual {v0, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_f5b

    .line 1934
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->removeSpec()Ljava/lang/String;

    move-result-object v0

    goto :goto_f5f

    .line 1935
    :cond_f5b
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->removeSpec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1936
    :goto_f5f
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v26

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ") \u2192 "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_1716

    .line 1937
    :cond_f7a
    const-string v4, "prompt_compose"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4
    :try_end_f80
    .catchall {:try_start_e48 .. :try_end_f80} :catchall_16e3

    const-string v8, "\n"

    if-eqz v4, :cond_10a7

    .line 1949
    :try_start_f84
    new-instance v2, Lorg/json/JSONObject;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v2, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 1950
    const-string v0, "items"

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    .line 1951
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    if-eqz v0, :cond_103a

    const/4 v4, 0x0

    const/4 v5, 0x0

    .line 1954
    :goto_f9c
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v9

    if-ge v4, v9, :cond_103b

    .line 1955
    invoke-virtual {v0, v4}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v9

    if-nez v9, :cond_faa

    goto/16 :goto_1036

    .line 1957
    :cond_faa
    const-string v10, "t"

    invoke-virtual {v9, v10, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 1959
    const-string v11, "suggest"

    invoke-virtual {v11, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_fbd

    .line 1960
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->suggestSpec()Ljava/lang/String;

    move-result-object v10

    goto :goto_1015

    .line 1961
    :cond_fbd
    const-string v11, "music"

    invoke-virtual {v11, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_fca

    .line 1962
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->spec()Ljava/lang/String;

    move-result-object v10

    goto :goto_1015

    .line 1963
    :cond_fca
    const-string v11, "richtext"

    invoke-virtual {v11, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_fd7

    .line 1964
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->spec()Ljava/lang/String;

    move-result-object v10

    goto :goto_1015

    .line 1965
    :cond_fd7
    invoke-virtual {v7, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_1014

    .line 1966
    const-string v10, "title"

    invoke-virtual {v9, v10, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 1967
    invoke-virtual {v9, v7, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 1968
    const-string v13, "withTitle"

    const/4 v14, 0x0

    invoke-virtual {v9, v13, v14}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v9

    if-eqz v9, :cond_1012

    .line 1969
    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v9

    if-lez v9, :cond_1012

    .line 1970
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    move-object v10, v9

    goto :goto_1015

    :cond_1012
    move-object v10, v11

    goto :goto_1015

    :cond_1014
    const/4 v10, 0x0

    :goto_1015
    if-eqz v10, :cond_1036

    .line 1973
    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v9

    if-nez v9, :cond_1022

    goto :goto_1036

    .line 1974
    :cond_1022
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v9

    if-lez v9, :cond_102d

    const-string v9, "\n\n"

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1975
    :cond_102d
    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v5, v5, 0x1

    :cond_1036
    :goto_1036
    add-int/lit8 v4, v4, 0x1

    goto/16 :goto_f9c

    :cond_103a
    const/4 v5, 0x0

    .line 1979
    :cond_103b
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1980
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v2

    .line 1981
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->setText(Ljava/lang/String;)V

    .line 1982
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "\u7cfb\u7edf\u63d0\u793a\u8bcd\u5df2\u6309\u5361\u7247\u91cd\u5efa\uff1a"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " \u6bb5 / "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff08\u539f "

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v2, :cond_1068

    const/4 v0, 0x0

    goto :goto_106c

    .line 1983
    :cond_1068
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v0

    :goto_106c
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff09"

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1984
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u3010FdmBridge\u3011prompt_compose \u2192 "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_108c
    .catchall {:try_start_f84 .. :try_end_108c} :catchall_108e

    goto/16 :goto_1716

    :catchall_108e
    move-exception v0

    .line 1986
    :try_start_108f
    const-string v2, "\u3010FdmBridge\u3011prompt_compose \u5931\u8d25"

    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 1987
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u6309\u5361\u7247\u91cd\u5efa\u63d0\u793a\u8bcd\u5931\u8d25\uff1a"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1989
    :cond_10a7
    const-string v4, "rich_demo"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_10d5

    .line 1991
    const-string v0, "fuckds_rich_tpls"

    const-string v2, "# \u6bcf\u884c\u4e00\u6761\uff1a\u540d\u5b57|\u5bcc\u6587\u672c\uff08HTML \u5b50\u96c6\uff0c\u6362\u884c\u7528 <br>\uff09\ndemo|<b>\u2726 {1}</b> {2}\ntip|<c6>\u25b8 {1}</c>\nwarn|<bg3><c#000000> \u26a0 {1} </c></bg>\ncard|<c7>\u250c {1}</c><br><c7>\u2514</c> {2}\nhi|<b><c4>\u4f60\u597d\uff0c{1}</c></b> \u4eca\u5929{c2}\u5f88\u597d</c>\uff01"

    const-string v4, "s"

    invoke-static {v1, v0, v2, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 1994
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v25

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 1995
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->names()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u6761\uff09"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 1996
    :cond_10d5
    const-string v4, "prompt_reset"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1105

    .line 1997
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmPrompt"

    const-string v2, "restore"

    const/4 v10, 0x1

    new-array v4, v10, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v4, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v0, v2, v4, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1998
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmPrompt"

    const-string v2, "apply"

    const/4 v10, 0x1

    new-array v4, v10, [Ljava/lang/Class;

    const/4 v14, 0x0

    aput-object v5, v4, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v0, v2, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1999
    const-string v0, "\u63d0\u793a\u8bcd\u5185\u5bb9\u5df2\u6062\u590d\u9ed8\u8ba4"

    goto/16 :goto_1716

    .line 2000
    :cond_1105
    const-string v4, "name_clear"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1124

    .line 2001
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmName"

    const-string v2, "clear"

    const/4 v10, 0x1

    new-array v4, v10, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v5, v4, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v0, v2, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 2003
    const-string v0, "\u8d26\u53f7\u540d\u5df2\u6e05\u7a7a\uff08\u8ddf\u968f\u5bbf\u4e3b\uff09"

    goto/16 :goto_1716

    .line 2004
    :cond_1124
    const-string v4, "uavatar_img"

    invoke-virtual {v4, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_116a

    .line 2005
    const-string v4, "com.nidyaber.fuckdsmanger.gm.GmUAvatar"

    const-string v5, "saveImage"

    const/4 v6, 0x2

    new-array v8, v6, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v6, v8, v14

    const-class v9, Landroid/net/Uri;

    const/16 v57, 0x1

    aput-object v9, v8, v57

    .line 2007
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    filled-new-array {v1, v0}, [Ljava/lang/Object;

    move-result-object v0

    .line 2005
    invoke-static {v4, v5, v8, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 2008
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmUAvatar"

    const/4 v10, 0x2

    new-array v4, v10, [Ljava/lang/Class;

    const/4 v14, 0x0

    aput-object v6, v4, v14

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    const/16 v57, 0x1

    aput-object v5, v4, v57

    .line 2009
    invoke-static/range {v57 .. v57}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    filled-new-array {v1, v5}, [Ljava/lang/Object;

    move-result-object v5

    .line 2008
    invoke-static {v0, v2, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 2010
    const-string v0, "\u8d26\u53f7\u5934\u50cf\u5df2\u4fdd\u5b58"

    goto/16 :goto_1716

    .line 2011
    :cond_116a
    const-string v2, "rows_dump"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_12b6

    .line 2014
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    :try_end_1177
    .catchall {:try_start_108f .. :try_end_1177} :catchall_16e3

    .line 2016
    :try_start_1177
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmMmkvHook"

    const-string v4, "rows"

    const/4 v10, 0x1

    new-array v9, v10, [Ljava/lang/Class;

    const-class v10, Landroid/content/Context;

    const/4 v14, 0x0

    aput-object v10, v9, v14

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v10

    invoke-static {v0, v4, v9, v10}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 2018
    instance-of v4, v0, Ljava/util/List;

    if-eqz v4, :cond_11d2

    .line 2019
    check-cast v0, Ljava/util/List;

    .line 2020
    const-string v4, "rows() size="

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2022
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v4, 0x0

    :goto_11a5
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v9

    if-eqz v9, :cond_11ea

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    add-int/lit8 v10, v4, 0x1

    const/16 v11, 0x78

    if-le v4, v11, :cond_11b6

    goto :goto_11ea

    .line 2024
    :cond_11b6
    const-string v4, "  "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    instance-of v4, v9, [Ljava/lang/Object;

    if-eqz v4, :cond_11c6

    .line 2025
    check-cast v9, [Ljava/lang/Object;

    invoke-static {v9}, Ljava/util/Arrays;->deepToString([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    goto :goto_11ca

    :cond_11c6
    invoke-static {v9}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    .line 2024
    :goto_11ca
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2026
    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v4, v10

    goto :goto_11a5

    .line 2029
    :cond_11d2
    const-string v4, "rows() = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_11dd
    .catchall {:try_start_1177 .. :try_end_11dd} :catchall_11de

    goto :goto_11ea

    :catchall_11de
    move-exception v0

    .line 2032
    :try_start_11df
    const-string v4, "rows() \u5931\u8d25\uff1a"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2034
    :cond_11ea
    :goto_11ea
    const-string v0, "kv_remote_settings_opus_bitrate"

    const-string v4, "kv_remote_settings_voice_input_enabled"

    const-string v9, "kv_remote_settings_picture_compress_format"

    const-string v10, "kv_settings_hide_assistant_avatar"

    filled-new-array {v0, v4, v9, v10}, [Ljava/lang/String;

    move-result-object v4

    const/4 v9, 0x0

    :goto_11f7
    const/4 v0, 0x4

    if-ge v9, v0, :cond_1271

    aget-object v10, v4, v9
    :try_end_11fc
    .catchall {:try_start_11df .. :try_end_11fc} :catchall_16e3

    .line 2041
    :try_start_11fc
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-static {v0, v10}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->anyValue(Landroid/content/SharedPreferences;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0
    :try_end_1204
    .catchall {:try_start_11fc .. :try_end_1204} :catchall_1206

    :goto_1204
    move-object v11, v0

    goto :goto_1219

    :catchall_1206
    move-exception v0

    .line 2043
    :try_start_1207
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "\u76f4\u8bfb\u5931\u8d25:"

    invoke-virtual {v11, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_1218
    .catchall {:try_start_1207 .. :try_end_1218} :catchall_16e3

    goto :goto_1204

    .line 2046
    :goto_1219
    :try_start_1219
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmMmkvHook"

    const-string v13, "handle"

    const/4 v14, 0x2

    new-array v15, v14, [Ljava/lang/Class;

    const-class v16, Ljava/lang/String;

    const/16 v17, 0x0

    aput-object v16, v15, v17

    const/16 v57, 0x1

    aput-object v16, v15, v57

    filled-new-array {v10, v6}, [Ljava/lang/Object;

    move-result-object v14

    invoke-static {v0, v13, v15, v14}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 2048
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0
    :try_end_1236
    .catchall {:try_start_1219 .. :try_end_1236} :catchall_1237

    goto :goto_1249

    :catchall_1237
    move-exception v0

    .line 2050
    :try_start_1238
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    const-string v14, "hook\u5931\u8d25:"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2052
    :goto_1249
    const-string v13, "  "

    invoke-virtual {v2, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v5, v6}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v10

    const-string v13, "kv_settings_"

    invoke-virtual {v10, v13, v6}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, " : \u76f4\u8bfb="

    .line 2053
    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v10, "  hook="

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v9, v9, 0x1

    goto :goto_11f7

    .line 2055
    :cond_1271
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2056
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "rows_dump \u5b8c\u6210\uff08"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " \u5b57\uff09"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2057
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u3010FdmBridge\u3011rows_dump\uff1a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v5

    const/16 v6, 0x258

    invoke-static {v6, v5}, Ljava/lang/Math;->min(II)I

    move-result v5

    const/4 v14, 0x0

    invoke-virtual {v2, v14, v5}, Ljava/lang/StringBuilder;->substring(II)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_1716

    .line 2058
    :cond_12b6
    const-string v2, "store_dump"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_130d

    .line 2061
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->dumpAll(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_12c7

    .line 2062
    const-string v2, "(dumpAll \u8fd4\u56de null)"

    goto :goto_12c8

    :cond_12c7
    move-object v2, v0

    :goto_12c8
    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2063
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v24

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez v0, :cond_12d5

    const/4 v4, 0x0

    goto :goto_12d9

    :cond_12d5
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v4

    :goto_12d9
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " \u5b57"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 2064
    new-instance v4, Ljava/lang/StringBuilder;

    move-object/from16 v5, v23

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez v0, :cond_12f1

    const-string v0, "null"

    goto :goto_1300

    .line 2065
    :cond_12f1
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v5

    const/16 v6, 0x258

    invoke-static {v6, v5}, Ljava/lang/Math;->min(II)I

    move-result v5

    const/4 v14, 0x0

    invoke-virtual {v0, v14, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    :goto_1300
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2064
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    move-object v0, v2

    goto/16 :goto_1716

    .line 2066
    :cond_130d
    const-string v2, "gray_all"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_13b8

    .line 2067
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 2068
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 2069
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->GRAY:[[Ljava/lang/String;

    array-length v6, v4

    const/4 v8, 0x0

    :goto_1323
    if-ge v8, v6, :cond_1382

    aget-object v9, v4, v8

    const/4 v14, 0x0

    .line 2070
    aget-object v9, v9, v14

    .line 2071
    invoke-virtual {v9, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_1337

    const/16 v10, 0x13

    .line 2072
    invoke-virtual {v9, v10}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v10

    goto :goto_1338

    :cond_1337
    move-object v10, v9

    .line 2073
    :goto_1338
    invoke-static {v1, v10, v9}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->grayRead(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 2074
    invoke-virtual {v0, v10, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 2075
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v11

    const/16 v13, 0xdc

    if-ge v11, v13, :cond_137f

    const-string v11, "voice_input"

    invoke-virtual {v10, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    if-nez v11, :cond_136f

    const-string v11, "opus"

    invoke-virtual {v10, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    if-nez v11, :cond_136f

    const-string v11, "hide_assistant"

    .line 2076
    invoke-virtual {v10, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    if-nez v11, :cond_136f

    const-string v11, "picture_compress"

    .line 2077
    invoke-virtual {v10, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    if-nez v11, :cond_136f

    const-string v11, "model_configs"

    invoke-virtual {v10, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    if-eqz v11, :cond_137f

    .line 2078
    :cond_136f
    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, "=["

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, "] "

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_137f
    add-int/lit8 v8, v8, 0x1

    goto :goto_1323

    .line 2081
    :cond_1382
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v4

    sput-object v4, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2082
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u5df2\u56de\u8bfb "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lorg/json/JSONObject;->length()I

    move-result v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u4e2a\u7070\u5ea6\u503c"

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2083
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u3010FdmBridge\u3011\u7070\u5ea6\u6837\u4f8b\uff1a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_1716

    .line 2084
    :cond_13b8
    const-string v2, "gray_restore_all"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_14d4

    .line 2090
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 2091
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 2094
    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->GRAY:[[Ljava/lang/String;

    array-length v6, v4

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    :goto_13ce
    if-ge v8, v6, :cond_14a5

    aget-object v11, v4, v8

    const/4 v14, 0x0

    .line 2095
    aget-object v13, v11, v14

    invoke-virtual {v13, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_13e4

    .line 2096
    aget-object v13, v11, v14

    const/16 v15, 0x13

    invoke-virtual {v13, v15}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v13

    goto :goto_13e6

    :cond_13e4
    aget-object v13, v11, v14

    .line 2097
    :goto_13e6
    array-length v14, v11

    const/4 v15, 0x1

    if-le v14, v15, :cond_13ed

    aget-object v11, v11, v15

    goto :goto_13ef

    :cond_13ed
    const-string v11, "s"

    .line 2098
    :goto_13ef
    const-string v14, "key_"

    invoke-virtual {v13, v14}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v14

    .line 2100
    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v16, v4

    const-string v4, "fuckds_pin_kv_remote_settings_"

    invoke-virtual {v15, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v4}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 2101
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v15, "fuckds_pin_kv_settings_"

    invoke-virtual {v4, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v4}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 2102
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v15, "fuckds_pin_"

    invoke-virtual {v4, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v4}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    if-eqz v14, :cond_143a

    .line 2106
    filled-new-array {v13}, [Ljava/lang/String;

    move-result-object v4

    goto :goto_145e

    .line 2107
    :cond_143a
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v14, "kv_settings_"

    invoke-virtual {v4, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v14, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    filled-new-array {v4, v13}, [Ljava/lang/String;

    move-result-object v4

    .line 2106
    :goto_145e
    array-length v13, v4

    move v14, v10

    const/4 v10, 0x0

    :goto_1461
    if-ge v10, v13, :cond_149a

    aget-object v15, v4, v10

    move-object/from16 v17, v2

    .line 2108
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v18, v4

    const-string v4, "fuckds_bak_"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x0

    invoke-interface {v0, v2, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2
    :try_end_147f
    .catchall {:try_start_1238 .. :try_end_147f} :catchall_16e3

    if-nez v2, :cond_1482

    goto :goto_1493

    .line 2111
    :cond_1482
    :try_start_1482
    const-string v4, "\u0000__gm_none__"

    invoke-virtual {v4, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_148e

    .line 2112
    invoke-static {v1, v15}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->remove(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_1491

    .line 2115
    :cond_148e
    invoke-static {v1, v15, v2, v11}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1491
    .catchall {:try_start_1482 .. :try_end_1491} :catchall_1493

    :goto_1491
    add-int/lit8 v14, v14, 0x1

    :catchall_1493
    :goto_1493
    add-int/lit8 v10, v10, 0x1

    move-object/from16 v2, v17

    move-object/from16 v4, v18

    goto :goto_1461

    :cond_149a
    move-object/from16 v17, v2

    add-int/lit8 v9, v9, 0x1

    add-int/lit8 v8, v8, 0x1

    move v10, v14

    move-object/from16 v4, v16

    goto/16 :goto_13ce

    :cond_14a5
    move-object/from16 v17, v2

    .line 2123
    :try_start_14a7
    invoke-interface/range {v17 .. v17}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_14aa
    .catchall {:try_start_14a7 .. :try_end_14aa} :catchall_16e3

    .line 2126
    :try_start_14aa
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->pins()Ljava/util/HashMap;

    move-result-object v0

    .line 2127
    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V
    :try_end_14b1
    .catchall {:try_start_14aa .. :try_end_14b1} :catchall_14b1

    .line 2130
    :catchall_14b1
    :try_start_14b1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u5df2\u6062\u590d\u7070\u5ea6 "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u9879\uff1a\u64a4\u5f71 "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 \u8fd8\u539f\u771f\u503c "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 2131
    :cond_14d4
    const-string v2, "call_state"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_14f4

    .line 2134
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->state(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2135
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v22

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 2136
    :cond_14f4
    const-string v2, "call_set"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1533

    .line 2137
    const-string v2, "1"

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    .line 2138
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->setOn(Landroid/content/Context;Z)V

    .line 2139
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->state(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2140
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v21

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz v0, :cond_151b

    const-string v0, "\u5f00\u542f"

    goto :goto_151d

    :cond_151b
    const-string v0, "\u5173\u95ed"

    :goto_151d
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 2141
    :cond_1533
    const-string v2, "call_pin_state"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1553

    .line 2143
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->state(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2144
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v20

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 2145
    :cond_1553
    const-string v2, "call_pin_set"

    invoke-virtual {v2, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1592

    .line 2146
    const-string v2, "1"

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    .line 2147
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->setOn(Landroid/content/Context;Z)V

    .line 2148
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->state(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2149
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v19

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz v0, :cond_157a

    const-string v0, "\u5f00\u542f"

    goto :goto_157c

    :cond_157a
    const-string v0, "\u5173\u95ed"

    :goto_157c
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 2150
    :cond_1592
    const-string v0, "dump_text"

    invoke-virtual {v0, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1607

    .line 2151
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    :try_end_159f
    .catchall {:try_start_14b1 .. :try_end_159f} :catchall_16e3

    .line 2153
    :try_start_159f
    const-string v0, "===== DIAG =====\n"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->text()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_15ab
    .catchall {:try_start_159f .. :try_end_15ab} :catchall_15ac

    goto :goto_15ba

    :catchall_15ac
    move-exception v0

    .line 2155
    :try_start_15ad
    const-string v4, "(DIAG \u8bfb\u53d6\u5931\u8d25\uff1a"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ")\n"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_15ba
    .catchall {:try_start_15ad .. :try_end_15ba} :catchall_16e3

    .line 2158
    :goto_15ba
    :try_start_15ba
    const-string v0, "\n===== DS DATA\uff08\u670d\u52a1\u5668\u4e0b\u53d1\uff09=====\n"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->dumpHostStore(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_15c6
    .catchall {:try_start_15ba .. :try_end_15c6} :catchall_15c7

    goto :goto_15d5

    :catchall_15c7
    move-exception v0

    .line 2160
    :try_start_15c8
    const-string v4, "\n(DS DATA \u8bfb\u53d6\u5931\u8d25\uff1a"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ")\n"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2162
    :goto_15d5
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2163
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    const v4, 0x30d40

    if-le v2, v4, :cond_15eb

    const v2, 0x30d40

    const/4 v14, 0x0

    invoke-virtual {v0, v14, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    goto :goto_15ec

    :cond_15eb
    move-object v2, v0

    :goto_15ec
    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    .line 2164
    new-instance v2, Ljava/lang/StringBuilder;

    move-object/from16 v4, v18

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 2165
    :cond_1607
    const-string v0, "dump_clear"

    invoke-virtual {v0, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_161d

    .line 2166
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->buf()Ljava/lang/StringBuilder;

    move-result-object v0

    if-eqz v0, :cond_1619

    const/4 v14, 0x0

    .line 2167
    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->setLength(I)V

    .line 2168
    :cond_1619
    const-string v0, "\u65e5\u5fd7\u7f13\u51b2\u5df2\u6e05\u7a7a"

    goto/16 :goto_1716

    .line 2169
    :cond_161d
    const-string v0, "avatar_status"

    invoke-virtual {v0, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1675

    .line 2170
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v17

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->isOn(Landroid/content/Context;)Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "/\u6709\u56fe="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 \u9632\u64a4\u56de="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2171
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->isOn(Landroid/content/Context;)Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "/"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDb;->count(Landroid/content/Context;)I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "\u6761 \u00b7 \u8bbe\u5907\u4f2a\u88c5="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2172
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->isOn()Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " \u00b7 \u6355\u83b7\u5668="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmProbe;->shown()Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    .line 2174
    :cond_1675
    new-instance v0, Ljava/lang/StringBuilder;

    move-object/from16 v2, v16

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_1716

    :cond_1685
    :goto_1685
    move-object/from16 v7, v30

    .line 1611
    const-string v0, "pick_avatar"

    invoke-virtual {v0, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1692

    move-object/from16 v0, v56

    goto :goto_169f

    .line 1612
    :cond_1692
    const-string v0, "pick_uavatar"

    invoke-virtual {v0, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_169d

    move-object/from16 v0, v59

    goto :goto_169f

    :cond_169d
    const-string v0, "GmBubble"

    .line 1613
    :goto_169f
    const-string v2, "GmBubble"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_16aa

    const-string v2, "armPick"

    goto :goto_16ac

    :cond_16aa
    const-string v2, "pick"

    .line 1614
    :goto_16ac
    invoke-virtual {v13, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const/4 v14, 0x0

    new-array v5, v14, [Ljava/lang/Class;

    new-array v6, v14, [Ljava/lang/Object;

    invoke-static {v4, v2, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1615
    new-instance v4, Ljava/lang/StringBuilder;

    move-object/from16 v5, v43

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "."

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\uff09\u2014\u2014\u53bb\u5bbf\u4e3b\u754c\u9762\u4e0a\u9009\u56fe\u5373\u53ef"

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1616
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_16e2
    .catchall {:try_start_15c8 .. :try_end_16e2} :catchall_16e3

    goto :goto_1716

    :catchall_16e3
    move-exception v0

    goto :goto_16f1

    :catchall_16e5
    move-exception v0

    goto :goto_16ef

    :catchall_16e7
    move-exception v0

    move-object/from16 v7, v30

    move-object/from16 v12, v61

    goto :goto_16f1

    :catchall_16ed
    move-exception v0

    move-object v12, v14

    :goto_16ef
    move-object/from16 v7, v30

    .line 2177
    :goto_16f1
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v4, "\u52a8\u4f5c "

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " \u5931\u8d25\uff1a"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2178
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 2180
    :goto_1716
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010FdmBridge\u3011\u52a8\u4f5c "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " \u2192 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v0, :cond_1748

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v3

    const/16 v4, 0x78

    if-le v3, v4, :cond_1748

    .line 2181
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const/16 v4, 0x78

    const/4 v14, 0x0

    invoke-virtual {v0, v14, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\u2026"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    goto :goto_1749

    :cond_1748
    move-object v3, v0

    :goto_1749
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 2180
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 2183
    :try_start_1753
    new-instance v2, Landroid/content/Intent;

    const-string v3, "com.little_femaleboy.fdm.CMD_RESULT"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 2184
    const-string v3, "cmd"

    invoke-virtual {v2, v3, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 2185
    invoke-virtual {v2, v7, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 2187
    const-string v0, "data"

    sget-object v3, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->lastData:Ljava/lang/String;

    invoke-virtual {v2, v0, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 2188
    invoke-virtual {v1, v2}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_176c
    .catchall {:try_start_1753 .. :try_end_176c} :catchall_176c

    :catchall_176c
    return-void
.end method

.method public static onHostReady(Landroid/content/Context;)V
    .registers 3

    .line 88
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sTried:Z

    if-eqz v0, :cond_5

    goto :goto_26

    :cond_5
    const/4 v0, 0x1

    .line 89
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sTried:Z

    .line 92
    :try_start_8
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->apply(Landroid/content/Context;)V
    :try_end_b
    .catchall {:try_start_8 .. :try_end_b} :catchall_c

    goto :goto_12

    :catchall_c
    move-exception v0

    .line 94
    const-string v1, "\u3010FdmBridge\u3011\u8bfb\u56de\u97f3\u4e50\u767b\u5f55\u6001\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\uff09"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 97
    :goto_12
    :try_start_12
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->probe(Landroid/content/Context;)V
    :try_end_15
    .catchall {:try_start_12 .. :try_end_15} :catchall_16

    goto :goto_1c

    :catchall_16
    move-exception v0

    .line 99
    const-string v1, "\u3010FdmBridge\u3011\u6865\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5bbf\u4e3b\uff09"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 106
    :goto_1c
    :try_start_1c
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCall;->ensure(Landroid/content/Context;)V
    :try_end_1f
    .catchall {:try_start_1c .. :try_end_1f} :catchall_20

    goto :goto_26

    :catchall_20
    move-exception p0

    .line 108
    const-string v0, "\u3010FdmBridge\u3011GmCall.ensure \u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5bbf\u4e3b\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_26
    return-void
.end method

.method private static pins()Ljava/util/HashMap;
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 656
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sPins:Ljava/util/HashMap;

    if-eqz v0, :cond_7

    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sPins:Ljava/util/HashMap;

    return-object v0

    .line 657
    :cond_7
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 659
    :try_start_c
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmMmkvHook"

    const-class v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    .line 660
    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    .line 659
    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 662
    const-string v2, "setPins"

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v3

    invoke-static {v1, v2, v3}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 663
    const-string v1, "\u3010FdmBridge\u3011\ud83d\udd17 pin \u8868\u5df2\u4ea4\u7ed9\u5e95\u5ea7\uff08\u8bfb\u4fa7\u66ff\u6362\u751f\u6548\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_26
    .catchall {:try_start_c .. :try_end_26} :catchall_27

    goto :goto_2d

    :catchall_27
    move-exception v1

    .line 665
    const-string v2, "\u3010FdmBridge\u3011pin \u8868\u6ce8\u518c\u5931\u8d25\uff08\u9000\u56de\u53ea\u5199\u5f71\u5b50\u952e\uff09"

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 667
    :goto_2d
    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sPins:Ljava/util/HashMap;

    return-object v0
.end method

.method private static probe(Landroid/content/Context;)V
    .registers 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    const-string v0, "\u3010FdmBridge\u3011\u5bbf\u4e3b\u4fa7 PackageManager\uff1a\u53ef\u89c1\u672c\u5305 \u2713 providers="

    .line 161
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    .line 189
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->syncBubbleCache(Landroid/content/Context;)V

    .line 193
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->syncPins(Landroid/content/Context;)Z

    .line 196
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->installReceiver(Landroid/content/Context;)V

    const/4 v2, 0x0

    .line 200
    :try_start_10
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v3

    .line 201
    const-string v4, "com.little_femaleboy.cannot_show.the_big_won_whale"

    const/16 v5, 0x8

    invoke-virtual {v3, v4, v5}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v3

    .line 202
    iget-object v3, v3, Landroid/content/pm/PackageInfo;->providers:[Landroid/content/pm/ProviderInfo;

    .line 203
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez v3, :cond_28

    .line 204
    const-string v0, "null"

    goto :goto_2d

    :cond_28
    array-length v0, v3

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    :goto_2d
    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 203
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    if-eqz v3, :cond_79

    .line 206
    array-length v0, v3

    move v4, v2

    :goto_3b
    if-ge v4, v0, :cond_79

    aget-object v5, v3, v4

    .line 207
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "\u3010FdmBridge\u3011   \u00b7 authority="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v7, v5, Landroid/content/pm/ProviderInfo;->authority:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " exported="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v5, v5, Landroid/content/pm/ProviderInfo;->exported:Z

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_5f
    .catchall {:try_start_10 .. :try_end_5f} :catchall_62

    add-int/lit8 v4, v4, 0x1

    goto :goto_3b

    :catchall_62
    move-exception v0

    .line 211
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u3010FdmBridge\u3011\u5bbf\u4e3b\u4fa7 PackageManager\uff1a\u770b\u4e0d\u5230\u672c\u5305 \u2717 "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, "\uff08\u21d2 provider \u90a3\u6761\u8def\u8d70\u4e0d\u901a\uff0c\u8d70\u5e7f\u64ad\uff09"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 217
    :cond_79
    :try_start_79
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0

    .line 218
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, v0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, v0, Landroid/content/pm/PackageInfo;->versionCode:I

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ")"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_9e
    .catchall {:try_start_79 .. :try_end_9e} :catchall_9f

    goto :goto_a1

    .line 219
    :catchall_9f
    const-string v0, "?"

    .line 222
    :goto_a1
    const-string v2, "content://com.little_femaleboy.cannot_show.the_big_won_whale.config"

    invoke-static {v2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    .line 223
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    .line 224
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u3010FdmBridge\u3011\u5f00\u59cb\u63a2\u6865 \u2192 "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, "  host="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 226
    :try_start_cc
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sToken:Ljava/lang/String;

    .line 227
    new-instance v3, Landroid/os/Bundle;

    invoke-direct {v3}, Landroid/os/Bundle;-><init>()V

    .line 228
    const-string v4, "version"

    invoke-virtual {v3, v4, v0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_d8
    .catchall {:try_start_cc .. :try_end_d8} :catchall_126

    .line 229
    const-string v0, "bridge_token"

    if-eqz v1, :cond_df

    :try_start_dc
    invoke-virtual {v3, v0, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 230
    :cond_df
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u3010FdmBridge\u3011heartbeat \u2192 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "heartbeat"

    const/4 v6, 0x0

    invoke-virtual {p0, v2, v5, v6, v3}, Landroid/content/ContentResolver;->call(Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 231
    new-instance v3, Landroid/os/Bundle;

    invoke-direct {v3}, Landroid/os/Bundle;-><init>()V

    if-eqz v1, :cond_104

    .line 232
    invoke-virtual {v3, v0, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 233
    :cond_104
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u3010FdmBridge\u3011provider getConfig \u2192 "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "getConfig"

    invoke-virtual {p0, v2, v4, v6, v3}, Landroid/content/ContentResolver;->call(Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    if-nez v1, :cond_138

    .line 235
    const-string p0, "\u3010FdmBridge\u3011\uff08\u8fd8\u6ca1\u62ff\u5230\u4ee4\u724c \u21d2 provider \u4f1a\u62d2\uff1b\u7b49 UI \u63a8\u4e00\u6b21\u914d\u7f6e\u5c31\u4f1a\u8865\u4e0a\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_125
    .catchall {:try_start_dc .. :try_end_125} :catchall_126

    goto :goto_138

    :catchall_126
    move-exception p0

    .line 238
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010FdmBridge\u3011provider \u90a3\u6761\u8def\u6ca1\u901a\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_138
    :goto_138
    return-void
.end method

.method private static promptLines(Landroid/content/Context;)Ljava/lang/String;
    .registers 7

    .line 1281
    const-string v0, ""

    :try_start_2
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmPrompt"

    const-string v2, "get"

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/Class;

    const-class v4, Landroid/content/Context;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v1, v2, v3, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_19

    return-object v0

    .line 1284
    :cond_19
    new-instance v1, Lorg/json/JSONArray;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    .line 1285
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1286
    :goto_27
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v5, v2, :cond_60

    .line 1287
    invoke-virtual {v1, v5}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    if-nez v2, :cond_34

    goto :goto_5d

    .line 1289
    :cond_34
    const-string v3, "scene"

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 1290
    const-string v4, "content"

    invoke-virtual {v2, v4, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 1291
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_47

    goto :goto_5d

    .line 1292
    :cond_47
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    if-lez v4, :cond_52

    const-string v4, "\n"

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1293
    :cond_52
    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "|"

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_5d
    add-int/lit8 v5, v5, 0x1

    goto :goto_27

    .line 1295
    :cond_60
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_64
    .catchall {:try_start_2 .. :try_end_64} :catchall_65

    return-object p0

    :catchall_65
    return-object v0
.end method

.method private static putBools(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I
    .registers 7

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    .line 2345
    :cond_4
    invoke-virtual {p1}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v1

    move v2, v0

    :goto_9
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1f

    .line 2346
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 2347
    invoke-virtual {p1, v3, v0}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v4

    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v2, v2, 0x1

    goto :goto_9

    :cond_1f
    return v2
.end method

.method private static putFloats(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I
    .registers 7

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    .line 2378
    :cond_4
    invoke-virtual {p1}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v1

    :goto_8
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_21

    .line 2379
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    const-wide/16 v3, 0x0

    .line 2380
    invoke-virtual {p1, v2, v3, v4}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v3

    double-to-float v3, v3

    invoke-interface {p0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v0, v0, 0x1

    goto :goto_8

    :cond_21
    return v0
.end method

.method private static putInts(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I
    .registers 7

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    .line 2356
    :cond_4
    invoke-virtual {p1}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v1

    move v2, v0

    :goto_9
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1f

    .line 2357
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 2358
    invoke-virtual {p1, v3, v0}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v4

    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v2, v2, 0x1

    goto :goto_9

    :cond_1f
    return v2
.end method

.method private static putLongs(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I
    .registers 7

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    .line 2367
    :cond_4
    invoke-virtual {p1}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v1

    :goto_8
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_20

    .line 2368
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    const-wide/16 v3, 0x0

    .line 2369
    invoke-virtual {p1, v2, v3, v4}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v3

    invoke-interface {p0, v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v0, v0, 0x1

    goto :goto_8

    :cond_20
    return v0
.end method

.method private static putStrings(Landroid/content/SharedPreferences$Editor;Lorg/json/JSONObject;)I
    .registers 6

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    .line 2389
    :cond_4
    invoke-virtual {p1}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v1

    :goto_8
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_20

    .line 2390
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 2391
    const-string v3, ""

    invoke-virtual {p1, v2, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {p0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v0, v0, 0x1

    goto :goto_8

    :cond_20
    return v0
.end method

.method private static sample(Ljava/util/List;)Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 903
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x0

    .line 904
    :goto_6
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_22

    const/4 v2, 0x4

    if-ge v1, v2, :cond_22

    if-lez v1, :cond_16

    .line 905
    const-string v2, " | "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 906
    :cond_16
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    .line 908
    :cond_22
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static sig(Ljava/lang/reflect/Method;)Ljava/lang/String;
    .registers 4

    .line 960
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 961
    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x20

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x28

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 962
    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object p0

    const/4 v1, 0x0

    .line 963
    :goto_26
    array-length v2, p0

    if-ge v1, v2, :cond_3c

    if-lez v1, :cond_30

    .line 964
    const-string v2, ", "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 965
    :cond_30
    aget-object v2, p0, v1

    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_26

    :cond_3c
    const/16 p0, 0x29

    .line 967
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 968
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static splitLines(Ljava/lang/String;)Ljava/util/List;
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 1307
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1308
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    const-string v1, "\\r?\\n|\\\\n"

    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v1, p0

    const/4 v2, 0x0

    :goto_11
    if-ge v2, v1, :cond_29

    aget-object v3, p0, v2

    .line 1309
    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_26

    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_26
    add-int/lit8 v2, v2, 0x1

    goto :goto_11

    :cond_29
    return-object v0
.end method

.method private static startReask(Landroid/content/Context;)V
    .registers 6

    .line 302
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/4 v1, 0x0

    .line 303
    filled-new-array {v1}, [I

    move-result-object v1

    .line 304
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;

    invoke-direct {v2, p0, v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;-><init>(Landroid/content/Context;[ILandroid/os/Handler;)V

    const-wide/16 v3, 0xbb8

    invoke-virtual {v0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 326
    const-string p0, "\u3010FdmBridge\u3011\u5f00\u59cb\u5468\u671f\u4efb\u52a1\uff08\u6bcf 4 \u79d2\u4e00\u6b21\uff1a\u7d22\u8981\u914d\u7f6e + \u63a8\u8fdb pin \u8868\u540c\u6b65\uff0c\u6700\u591a 30 \u6b21\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static syncBubbleCache(Landroid/content/Context;)V
    .registers 6

    const-string v0, "\u3010FdmBridge\u3011\u6c14\u6ce1\u5f00\u5173\u5185\u5b58\u7f13\u5b58\u5df2\u5bf9\u9f50\uff08\u53ea\u6539\u5185\u5b58\uff0c\u4e0d\u5199\u5b58\u50a8\uff09\uff1a\u7528\u6237="

    .line 129
    :try_start_2
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-nez p0, :cond_9

    goto :goto_53

    .line 133
    :cond_9
    const-string v1, "fuckds_ububble_on"

    const/4 v2, 0x1

    invoke-interface {p0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    .line 134
    const-string v3, "fuckds_bubble_on"

    invoke-interface {p0, v3, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    .line 136
    const-string v3, "com.nidyaber.fuckdsmanger.gm.GmBubble"

    const-class v4, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;

    .line 138
    invoke-virtual {v4}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    .line 136
    invoke-static {v3, v4}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3

    .line 143
    const-string v4, "sUOn"

    invoke-static {v3, v4, v1}, Lde/robv/android/xposed/XposedHelpers;->setStaticBooleanField(Ljava/lang/Class;Ljava/lang/String;Z)V

    .line 144
    const-string v4, "sOn"

    invoke-static {v3, v4, p0}, Lde/robv/android/xposed/XposedHelpers;->setStaticBooleanField(Ljava/lang/Class;Ljava/lang/String;Z)V

    .line 145
    const-string v4, "sURead"

    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->setStaticBooleanField(Ljava/lang/Class;Ljava/lang/String;Z)V

    .line 146
    const-string v4, "sRead"

    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->setStaticBooleanField(Ljava/lang/Class;Ljava/lang/String;Z)V

    .line 148
    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sBubbleCacheLogged:Z

    if-nez v3, :cond_53

    .line 149
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sBubbleCacheLogged:Z

    .line 150
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, " AI="

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_53
    .catchall {:try_start_2 .. :try_end_53} :catchall_54

    :cond_53
    :goto_53
    return-void

    :catchall_54
    move-exception p0

    .line 154
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010FdmBridge\u3011\u5bf9\u9f50\u6c14\u6ce1\u7f13\u5b58\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\uff09\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static syncPins(Landroid/content/Context;)Z
    .registers 9

    const-string v0, "\u3010FdmBridge\u3011syncPins\uff1a\u5bbf\u4e3b\u5b58\u50a8\u91cc\u5171 "

    .line 695
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sPinsSynced:Z

    const/4 v2, 0x1

    if-eqz v1, :cond_8

    return v2

    :cond_8
    const/4 v1, 0x0

    .line 697
    :try_start_9
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-nez p0, :cond_15

    .line 699
    const-string p0, "\u3010FdmBridge\u3011pin \u8868\u540c\u6b65\uff1a\u5bbf\u4e3b\u5b58\u50a8\u8fd8\u6ca1\u5c31\u7eea\uff08MMKV \u672a\u521d\u59cb\u5316\uff09\u21d2 \u7a0d\u540e\u91cd\u8bd5"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v1

    .line 702
    :cond_15
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->pins()Ljava/util/HashMap;

    move-result-object v3

    .line 704
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->allKeysOf(Landroid/content/SharedPreferences;)Ljava/util/List;

    move-result-object v4

    .line 705
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u4e2a\u952e\uff0c\u5f00\u59cb\u7b5b fuckds_pin_"

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 706
    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    move v4, v1

    :cond_3a
    :goto_3a
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_65

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    if-eqz v5, :cond_3a

    .line 707
    const-string v6, "fuckds_pin_"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_51

    goto :goto_3a

    :cond_51
    const/4 v6, 0x0

    .line 708
    invoke-interface {p0, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    if-nez v6, :cond_59

    goto :goto_3a

    :cond_59
    const/16 v7, 0xb

    .line 710
    invoke-virtual {v5, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5, v6}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 v4, v4, 0x1

    goto :goto_3a

    .line 713
    :cond_65
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sPinsSynced:Z

    .line 714
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\u3010FdmBridge\u3011pin \u8868\u5168\u91cf\u540c\u6b65 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u6761\uff08\u5185\u5b58\u8868\u5171 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/util/HashMap;->size()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_8c
    .catchall {:try_start_9 .. :try_end_8c} :catchall_8d

    return v2

    :catchall_8d
    move-exception p0

    .line 717
    const-string v0, "\u3010FdmBridge\u3011pin \u8868\u540c\u6b65\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return v1
.end method

.method public static token()Ljava/lang/String;
    .registers 1

    .line 80
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sToken:Ljava/lang/String;

    return-object v0
.end method

.method private static uiGet(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .registers 9

    const-string v0, "\u5171 "

    .line 1023
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->alias(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 1025
    :try_start_6
    const-string v1, "ui_avatar_on"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1
    :try_end_c
    .catchall {:try_start_6 .. :try_end_c} :catchall_11a

    const-string v2, "isOn"

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v1, :cond_27

    .line 1026
    :try_start_12
    const-string p1, "com.nidyaber.fuckdsmanger.gm.GmAvatar"

    new-array v0, v3, [Ljava/lang/Class;

    const-class v1, Landroid/content/Context;

    aput-object v1, v0, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p1, v2, v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 1029
    :cond_27
    const-string v1, "ui_uavatar_on"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_44

    .line 1030
    const-string p1, "com.nidyaber.fuckdsmanger.gm.GmUAvatar"

    new-array v0, v3, [Ljava/lang/Class;

    const-class v1, Landroid/content/Context;

    aput-object v1, v0, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p1, v2, v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 1033
    :cond_44
    const-string v1, "ui_db_on"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1
    :try_end_4a
    .catchall {:try_start_12 .. :try_end_4a} :catchall_11a

    const-string v5, "com.nidyaber.fuckdsmanger.gm.GmDb"

    if-eqz v1, :cond_61

    .line 1034
    :try_start_4e
    new-array p1, v3, [Ljava/lang/Class;

    const-class v0, Landroid/content/Context;

    aput-object v0, p1, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v5, v2, p1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 1037
    :cond_61
    const-string v1, "fuckds_nick"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_85

    .line 1038
    const-string p1, "com.nidyaber.fuckdsmanger.gm.GmName"

    const-string v0, "getText"

    new-array v1, v3, [Ljava/lang/Class;

    const-class v2, Landroid/content/Context;

    aput-object v2, v1, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p1, v0, v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_80

    .line 1040
    const-string p0, ""

    return-object p0

    :cond_80
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 1042
    :cond_85
    const-string v1, "ui_db_info"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_c5

    .line 1043
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v0, "count"

    new-array v1, v3, [Ljava/lang/Class;

    const-class v2, Landroid/content/Context;

    aput-object v2, v1, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v5, v0, v1, v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, " \u6761 \u00b7 "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "sizeKb"

    new-array v1, v3, [Ljava/lang/Class;

    aput-object v2, v1, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    .line 1044
    invoke-static {v5, v0, v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, " KB"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 1046
    :cond_c5
    const-string v0, "ui_env_on"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0
    :try_end_cb
    .catchall {:try_start_4e .. :try_end_cb} :catchall_11a

    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmEnv"

    if-eqz v0, :cond_e2

    .line 1047
    :try_start_cf
    new-array p1, v3, [Ljava/lang/Class;

    const-class v0, Landroid/content/Context;

    aput-object v0, p1, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v1, v2, p1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 1050
    :cond_e2
    const-string v0, "ui_env_api"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_ff

    .line 1051
    const-string p1, "isApi"

    new-array v0, v3, [Ljava/lang/Class;

    const-class v2, Landroid/content/Context;

    aput-object v2, v0, v4

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v1, p1, v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 1054
    :cond_ff
    const-string p0, "ui_probe_on"

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_118

    .line 1055
    const-string p0, "com.nidyaber.fuckdsmanger.gm.GmProbe"

    const-string p1, "shown"

    new-array v0, v4, [Ljava/lang/Class;

    new-array v1, v4, [Ljava/lang/Object;

    invoke-static {p0, p1, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0
    :try_end_117
    .catchall {:try_start_cf .. :try_end_117} :catchall_11a

    return-object p0

    :cond_118
    const/4 p0, 0x0

    return-object p0

    :catchall_11a
    move-exception p0

    .line 1058
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u53d6\u4e0d\u5230:"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static uiSet(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z
    .registers 9

    .line 1065
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->alias(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 1066
    const-string v0, "true"

    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_19

    const-string v0, "1"

    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_17

    goto :goto_19

    :cond_17
    move v0, v1

    goto :goto_1a

    :cond_19
    :goto_19
    move v0, v2

    .line 1068
    :goto_1a
    :try_start_1a
    const-string v3, "ui_avatar_on"

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3
    :try_end_20
    .catchall {:try_start_1a .. :try_end_20} :catchall_be

    const-string v4, "setOn"

    const/4 v5, 0x2

    if-eqz v3, :cond_3d

    .line 1069
    :try_start_25
    const-string p2, "com.nidyaber.fuckdsmanger.gm.GmAvatar"

    new-array v3, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    aput-object v5, v3, v1

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v5, v3, v2

    .line 1070
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    filled-new-array {p0, v0}, [Ljava/lang/Object;

    move-result-object p0

    .line 1069
    invoke-static {p2, v4, v3, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    return v2

    .line 1073
    :cond_3d
    const-string v3, "ui_uavatar_on"

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_5d

    .line 1074
    const-string p2, "com.nidyaber.fuckdsmanger.gm.GmUAvatar"

    new-array v3, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    aput-object v5, v3, v1

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v5, v3, v2

    .line 1075
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    filled-new-array {p0, v0}, [Ljava/lang/Object;

    move-result-object p0

    .line 1074
    invoke-static {p2, v4, v3, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    return v2

    .line 1078
    :cond_5d
    const-string v3, "ui_db_on"

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_7d

    .line 1079
    const-string p2, "com.nidyaber.fuckdsmanger.gm.GmDb"

    new-array v3, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    aput-object v5, v3, v1

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v5, v3, v2

    .line 1080
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    filled-new-array {p0, v0}, [Ljava/lang/Object;

    move-result-object p0

    .line 1079
    invoke-static {p2, v4, v3, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    return v2

    .line 1083
    :cond_7d
    const-string v3, "fuckds_nick"

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_9b

    .line 1084
    const-string v0, "com.nidyaber.fuckdsmanger.gm.GmName"

    const-string v3, "setText"

    new-array v4, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    aput-object v5, v4, v1

    const-class v5, Ljava/lang/String;

    aput-object v5, v4, v2

    filled-new-array {p0, p2}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v0, v3, v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    return v2

    .line 1088
    :cond_9b
    const-string p2, "ui_env_api"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_bd

    .line 1089
    const-string p2, "com.nidyaber.fuckdsmanger.gm.GmEnv"

    const-string v3, "setApi"

    new-array v4, v5, [Ljava/lang/Class;

    const-class v5, Landroid/content/Context;

    aput-object v5, v4, v1

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v5, v4, v2

    .line 1090
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    filled-new-array {p0, v0}, [Ljava/lang/Object;

    move-result-object p0

    .line 1089
    invoke-static {p2, v3, v4, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->callGm(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_bc
    .catchall {:try_start_25 .. :try_end_bc} :catchall_be

    return v2

    :cond_bd
    return v1

    :catchall_be
    move-exception p0

    .line 1094
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "\u3010FdmBridge\u3011uiSet "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " \u5931\u8d25\uff1a"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v1
.end method
