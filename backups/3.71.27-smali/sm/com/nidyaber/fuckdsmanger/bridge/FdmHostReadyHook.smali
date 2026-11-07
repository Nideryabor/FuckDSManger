.class public final Lcom/nidyaber/fuckdsmanger/bridge/FdmHostReadyHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "FdmHostReadyHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 16
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 21
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 22
    instance-of p1, p0, Landroid/content/Context;

    if-eqz p1, :cond_b

    .line 23
    check-cast p0, Landroid/content/Context;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->onHostReady(Landroid/content/Context;)V
    :try_end_b
    .catchall {:try_start_0 .. :try_end_b} :catchall_b

    :catchall_b
    :cond_b
    return-void
.end method
