.class public final Lcom/varuns2002/disable_flag_secure/gm/GmDeviceHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmDeviceHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    :try_start_0
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDevice;->ensure()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDevice;->isOn()Z

    move-result v0

    if-eqz v0, :cond_36

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_36

    array-length v1, v0

    const/4 v2, 0x2

    if-ge v1, v2, :cond_36

    const/4 v1, 0x1

    aget-object v1, v0, v1

    instance-of v2, v1, Ljava/lang/String;

    if-eqz v2, :cond_36

    const-string v2, "android_id"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_36

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDevice;->fake()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_36

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-eqz v2, :cond_36

    const-string v2, "devhit"

    const-string v3, "FuckDSManger: android_id replaced"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V
    :try_end_36
    .catchall {:try_start_0 .. :try_end_36} :catchall_37

    :cond_36
    return-void

    :catchall_37
    move-exception v0

    return-void
.end method
