.class public final Lcom/nidyaber/fuckdsmanger/gm/GmEnvPropHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmEnvPropHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->isOn()Z

    move-result v0

    if-eqz v0, :cond_22

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->isApi()Z

    move-result v0

    if-eqz v0, :cond_23

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_24

    move-object v1, v0

    check-cast v1, Ljava/lang/String;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_25

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void

    :cond_22
    return-void

    :cond_23
    return-void

    :cond_24
    return-void

    :cond_25
    return-void
.end method
