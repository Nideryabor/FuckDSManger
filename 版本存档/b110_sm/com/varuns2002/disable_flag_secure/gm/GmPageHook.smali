.class public final Lcom/varuns2002/disable_flag_secure/gm/GmPageHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmPageHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    :try_start_0
    sget p0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageDepth:I

    if-lez p0, :cond_8

    add-int/lit8 p0, p0, -0x1

    sput p0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageDepth:I
    :try_end_8
    .catchall {:try_start_0 .. :try_end_8} :catchall_9

    :cond_8
    return-void

    :catchall_9
    move-exception p0

    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    :try_start_0
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageDepth:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageDepth:I

    const/4 v0, 0x0

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageCnt:I

    const-wide/16 v0, 0x0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPageColor:J

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sSurfaceColor:J

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sExtraColor:J

    const-string v0, "[\u5b9e\u5316] ChatPage \u4f5c\u7528\u57df\u5df2\u5f00"

    const-string p0, "\u80cc\u666f\u5b9e\u5316\u4f5c\u7528\u57df\u5f00\u542f\uff08NL 2.22.33 \u8d77\uff09"

    invoke-static {v0, p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_18
    .catchall {:try_start_0 .. :try_end_18} :catchall_19

    return-void

    :catchall_19
    move-exception v0

    return-void
.end method
