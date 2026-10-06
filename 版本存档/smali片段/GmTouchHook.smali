.class public final Lcom/varuns2002/disable_flag_secure/gm/GmTouchHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmTouchHook.java"
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTick:J

    :try_start_6
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast v2, Landroid/app/Activity;

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDevice;->promptIfNeeded(Landroid/app/Activity;)V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_7

    return-void

    :catchall_7
    move-exception v2

    return-void
.end method
