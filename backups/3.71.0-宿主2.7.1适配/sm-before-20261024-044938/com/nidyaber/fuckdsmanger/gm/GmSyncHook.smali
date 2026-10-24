.class public final Lcom/nidyaber/fuckdsmanger/gm/GmSyncHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSyncHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSync;->reapplyAll()V

    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_1e

    array-length v1, v0

    const/4 v2, 0x1

    if-lt v1, v2, :cond_1e

    const/4 v1, 0x0

    aget-object v1, v0, v1

    instance-of v2, v1, Ljava/util/Map;

    if-eqz v2, :cond_1e

    check-cast v1, Ljava/util/Map;

    const-string v2, "model_configs"

    invoke-interface {v1, v2}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_1e

    const-string v2, "[ds2] \u5e94\u7528\u70b9\u5df2\u79fb\u9664 model_configs\uff08\u9632\u8986\u76d6\u6a21\u578b\u5207\u6362\uff09"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_1e
    .catchall {:try_start_0 .. :try_end_1e} :catchall_1f

    :cond_1e
    return-void

    :catchall_1f
    move-exception v0

    return-void
.end method
