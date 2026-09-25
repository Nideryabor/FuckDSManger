.class public final Lcom/nidyaber/fuckdsmanger/gm/GmGateListHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGateListHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmGateHook;->sGate:Ljava/lang/Object;

    if-eqz v0, :cond_1b

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-ne v1, v0, :cond_1b

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_1b

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggest;->on(Landroid/content/Context;)Z

    move-result v2

    if-eqz v2, :cond_1b

    const-string v2, "gate.off"

    const-string p0, "[\u5efa\u8bae] \u95f8\u95e8\u8c0e\u62a5\u5df2\u5f7b\u5e95\u505c\u7528\uff08\u4e0d\u518d\u4f2a\u9020 isEmpty\uff09"

    invoke-static {v2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1b
    return-void
    :try_end_1c
    .catchall {:try_start_0 .. :try_end_1c} :catchall_1c

    :catchall_1c
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
