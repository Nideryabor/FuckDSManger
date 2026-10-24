.class public final Lcom/nidyaber/fuckdsmanger/gm/GmAlphaHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmAlphaHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static apply(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    :try_start_0
    sget v2, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sDepth:I

    if-lez v2, :cond_18

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz v0, :cond_18

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->alphaF()F

    move-result v1

    const-string v2, "c"

    invoke-static {v0, v2, v1}, Lde/robv/android/xposed/XposedHelpers;->setFloatField(Ljava/lang/Object;Ljava/lang/String;F)V

    const-string v1, "[\u6c14\u6ce1] \u56fe\u7247\u900f\u660e\u5ea6"

    const-string v2, "\u5df2\u6309\u914d\u7f6e\u5199\u5165 BackgroundElement \u7684 alpha\uff08NL 2.22.29 \u8d77\uff09"

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_18
    .catchall {:try_start_0 .. :try_end_18} :catchall_19

    :cond_18
    return-void

    :catchall_19
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmAlphaHook;->apply(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmAlphaHook;->apply(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    return-void
.end method
