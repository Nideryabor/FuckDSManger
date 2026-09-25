.class public final Lcom/nidyaber/fuckdsmanger/gm/GmUBubbleHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmUBubbleHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    :try_start_0
    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUBub:I

    if-lez v0, :cond_8

    add-int/lit8 v0, v0, -0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUBub:I
    :try_end_8
    .catchall {:try_start_0 .. :try_end_8} :catchall_9

    :cond_8
    return-void

    :catchall_9
    move-exception v0

    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    :try_start_0
    sget v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUBub:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/gm/GmBubble;->sUBub:I

    const-string v0, "[\u6c14\u6ce1] \u81ea\u68c0"

    const-string p0, "ls9.f \u7528\u6237\u6c14\u6ce1 lambda \u5df2\u8c03\u7528\uff08\u6a21\u5757 NL 2.22.104 \u751f\u6548 \u00b7 \u4ec5\u8bca\u65ad\uff0c\u4e0d\u53c2\u4e0e\u5224\u5b9a\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_e

    return-void

    :catchall_e
    move-exception v0

    return-void
.end method
