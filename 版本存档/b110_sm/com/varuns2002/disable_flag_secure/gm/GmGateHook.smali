.class public final Lcom/varuns2002/disable_flag_secure/gm/GmGateHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGateHook.java"


# static fields
.field static sCtx:Landroid/content/Context;

.field static sGate:Ljava/lang/Object;

.field static sState:Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz v0, :cond_d

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmGateHook;->sState:Ljava/lang/Object;

    const-string v1, "gate.state"

    const-string v2, "[\u5efa\u8bae] \u5df2\u6355\u83b7\u8f93\u5165\u72b6\u6001\uff08\u4ec5\u4f9b\u573a\u666f\u533a\u5206\uff1b\u5e38\u663e\u95f8\u95e8\u4ecd\u505c\u7528\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_d
    return-void
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_e

    :catchall_e
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
