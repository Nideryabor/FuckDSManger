.class public final Lcom/varuns2002/disable_flag_secure/gm/GmDsHook3;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmDsHook3.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-nez v0, :cond_5

    return-void

    :cond_5
    array-length v1, v0

    const/4 v2, 0x1

    if-ge v1, v2, :cond_a

    return-void

    :cond_a
    const/4 v1, 0x0

    aget-object v1, v0, v1

    if-nez v1, :cond_10

    return-void

    :cond_10
    instance-of v2, v1, Ljava/util/Map;

    if-nez v2, :cond_15

    return-void

    :cond_15
    check-cast v1, Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1e

    return-void

    :cond_1e
    invoke-static {}, Landroid/app/AndroidAppHelper;->currentApplication()Landroid/app/Application;

    move-result-object v2

    if-nez v2, :cond_25

    return-void

    :cond_25
    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->dump(Landroid/content/Context;Ljava/util/Map;)V

    return-void
.end method
