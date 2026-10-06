.class public final Lcom/varuns2002/disable_flag_secure/gm/GmEnvFileHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmEnvFileHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmEnv;->isOn()Z

    move-result v0

    if-eqz v0, :cond_2c

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmEnv;->isApi()Z

    move-result v0

    if-eqz v0, :cond_2d

    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v0

    sget-object v1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v1, v0}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2e

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast v0, Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmEnv;->bad(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2f

    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {p1, v0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void

    :cond_2c
    return-void

    :cond_2d
    return-void

    :cond_2e
    return-void

    :cond_2f
    return-void
.end method
