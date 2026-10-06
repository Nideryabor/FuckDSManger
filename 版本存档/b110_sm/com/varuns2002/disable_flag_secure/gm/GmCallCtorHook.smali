.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallCtorHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCallCtorHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz v0, :cond_e

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sNewA:Ljava/lang/Object;

    const/4 v1, 0x0

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sCtor:Ljava/lang/Object;

    const-string v1, "[\u901a\u8bdd] \u65b0\u7684 ao1 \u5b9e\u4f8b\uff08\u4f1a\u8bdd component\uff09\u5df2\u8bb0\u5f55"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_e

    :catchall_e
    :cond_e
    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sCtor:Ljava/lang/Object;

    return-void
.end method
