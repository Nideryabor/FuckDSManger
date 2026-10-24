.class public final Lcom/nidyaber/fuckdsmanger/gm/GmDevice;
.super Ljava/lang/Object;
.source "GmDevice.java"


# static fields
.field private static sCl:Ljava/lang/ClassLoader;

.field private static sFake:Ljava/lang/String;

.field private static sInit:Z

.field private static sOn:Z

.field private static sPrompted:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static ctx()Landroid/content/Context;
    .registers 2

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    return-object v0
.end method

.method public static ensure()V
    .registers 3

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sInit:Z

    if-nez v0, :cond_d

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->ctx()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_d

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->refresh(Landroid/content/Context;)V

    :cond_d
    return-void
.end method

.method static ensureFake(Landroid/content/Context;)V
    .registers 4

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sFake:Ljava/lang/String;

    if-eqz v0, :cond_b

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_b

    return-void

    :cond_b
    const/4 v0, 0x0

    if-eqz p0, :cond_16

    const-string v1, "fuckds_device_id"

    const-string v2, "s"

    invoke-static {p0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_16
    if-eqz v0, :cond_1f

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_1f

    goto :goto_2c

    :cond_1f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->gen()Ljava/lang/String;

    move-result-object v0

    if-eqz p0, :cond_2c

    const-string v1, "fuckds_device_id"

    const-string v2, "s"

    invoke-static {p0, v1, v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_2c
    :goto_2c
    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sFake:Ljava/lang/String;

    return-void
.end method

.method public static fake()Ljava/lang/String;
    .registers 3

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sFake:Ljava/lang/String;

    if-eqz v0, :cond_b

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_b

    return-object v0

    :cond_b
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->ctx()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_14

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->ensureFake(Landroid/content/Context;)V

    :cond_14
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sFake:Ljava/lang/String;

    return-object v0
.end method

.method static gen()Ljava/lang/String;
    .registers 4

    new-instance v0, Ljava/util/Random;

    invoke-direct {v0}, Ljava/util/Random;-><init>()V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v2, 0x0

    :goto_b
    const/16 v3, 0x10

    if-ge v2, v3, :cond_1f

    const/16 v3, 0x10

    invoke-virtual {v0, v3}, Ljava/util/Random;->nextInt(I)I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_b

    :cond_1f
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    return-object v3
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 6

    sput-object p0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sCl:Ljava/lang/ClassLoader;

    :try_start_2
    const-string v0, "android.provider.Settings$Secure"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceHook;

    invoke-direct {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceHook;-><init>()V

    const-string v2, "getString"

    invoke-static {v0, v2, v1}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "device hook Settings$Secure#getString="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_2b
    .catchall {:try_start_2 .. :try_end_2b} :catchall_2c

    return-void

    :catchall_2c
    move-exception v0

    return-void
.end method

.method public static isOn()Z
    .registers 1

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sOn:Z

    return v0
.end method

.method public static kill()V
    .registers 2

    :try_start_0
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmKillRun;

    invoke-direct {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmKillRun;-><init>()V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_e

    return-void

    :catchall_e
    move-exception v0

    return-void
.end method

.method public static promptIfNeeded(Landroid/app/Activity;)V
    .registers 5

    const-string v0, "deventer"

    const-string v1, "FuckDSManger: prompt ENTER"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p0, :cond_51

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sPrompted:Z

    if-nez v0, :cond_49

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sPrompted:Z

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->isOn()Z

    move-result v0

    if-nez v0, :cond_41

    :try_start_16
    const-string v0, "fuckds_dev_ask3"

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "done"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2c

    const-string v0, "FuckDSManger: prompt SKIP done-flag"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    :cond_2c
    const-string v0, "FuckDSManger: prompt OPEN dialog"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v0, "\u8bbe\u5907\u8eab\u4efd\u7a97\u53e3\u5df2\u6253\u5f00\uff1a\u5982\u9700\u66f4\u6362\u8eab\u4efd\u8bf7\u70b9\u7a97\u53e3\u91cc\u7684\u6309\u94ae"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceDialog;->open(Landroid/app/Activity;)V
    :try_end_39
    .catchall {:try_start_16 .. :try_end_39} :catchall_3a

    return-void

    :catchall_3a
    move-exception v0

    const-string v1, "FuckDSManger: prompt FAIL"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void

    :cond_41
    const-string v0, "devenabled"

    const-string v1, "FuckDSManger: prompt SKIP device-already-on"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_49
    const-string v0, "devalready"

    const-string v1, "FuckDSManger: prompt SKIP already-prompted"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_51
    const-string v0, "devnullact"

    const-string v1, "FuckDSManger: prompt SKIP null-activity"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static refresh(Landroid/content/Context;)V
    .registers 4

    if-eqz p0, :cond_1e

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sInit:Z

    const-string v0, "fuckds_device_on"

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "false"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sOn:Z

    if-eqz v0, :cond_1d

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->ensureFake(Landroid/content/Context;)V

    return-void

    :cond_1d
    return-void

    :cond_1e
    return-void
.end method

.method public static reset()Ljava/lang/String;
    .registers 5

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->gen()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sFake:Ljava/lang/String;

    const/4 v1, 0x1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sOn:Z

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->ctx()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_1f

    const-string v2, "fuckds_device_id"

    const-string v3, "s"

    invoke-static {v1, v2, v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v2, "fuckds_device_on"

    const-string v3, "true"

    const-string v4, "b"

    invoke-static {v1, v2, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_1f
    return-object v0
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 6

    sput-boolean p1, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sOn:Z

    if-eqz p1, :cond_8

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->fake()Ljava/lang/String;

    goto :goto_b

    :cond_8
    const/4 v0, 0x0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->sFake:Ljava/lang/String;

    :goto_b
    if-eqz p0, :cond_1b

    const-string v0, "fuckds_device_on"

    if-eqz p1, :cond_14

    const-string v1, "true"

    goto :goto_16

    :cond_14
    const-string v1, "false"

    :goto_16
    const-string v2, "b"

    invoke-static {p0, v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_1b
    return-void
.end method
