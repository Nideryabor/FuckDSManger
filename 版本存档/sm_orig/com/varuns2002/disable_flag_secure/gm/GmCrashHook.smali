.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;
.super Ljava/lang/Object;
.source "GmCrashHook.java"

# interfaces
.implements Ljava/lang/Thread$UncaughtExceptionHandler;


# static fields
.field static sOld:Ljava/lang/Thread$UncaughtExceptionHandler;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static install()V
    .registers 3

    :try_start_0
    invoke-static {}, Ljava/lang/Thread;->getDefaultUncaughtExceptionHandler()Ljava/lang/Thread$UncaughtExceptionHandler;

    move-result-object v0

    instance-of v1, v0, Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;

    if-nez v1, :cond_17

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;->sOld:Ljava/lang/Thread$UncaughtExceptionHandler;

    new-instance v1, Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;

    invoke-direct {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;-><init>()V

    invoke-static {v1}, Ljava/lang/Thread;->setDefaultUncaughtExceptionHandler(Ljava/lang/Thread$UncaughtExceptionHandler;)V

    const-string v1, "[\u5d29\u6e83\u6355\u624b] \u5df2\u5b89\u88c5\uff1a\u5bbf\u4e3b\u5d29\u6e83\u5806\u6808\u4f1a\u6253\u5230\u6a21\u5757\u65e5\u5fd7"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_18

    :cond_17
    return-void

    :catchall_18
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method


# virtual methods
.method public uncaughtException(Ljava/lang/Thread;Ljava/lang/Throwable;)V
    .registers 7

    :try_start_0
    invoke-static {p2}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_8

    const-string v0, "?"

    :cond_8
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[FuckDSManger-CRASH] \u7ebf\u7a0b="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/Thread;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_2b
    .catchall {:try_start_0 .. :try_end_2b} :catchall_33

    :goto_2b
    :try_start_2b
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;->sOld:Ljava/lang/Thread$UncaughtExceptionHandler;

    if-eqz v1, :cond_32

    invoke-interface {v1, p1, p2}, Ljava/lang/Thread$UncaughtExceptionHandler;->uncaughtException(Ljava/lang/Thread;Ljava/lang/Throwable;)V
    :try_end_32
    .catchall {:try_start_2b .. :try_end_32} :catchall_35

    :cond_32
    return-void

    :catchall_33
    move-exception v0

    goto :goto_2b

    :catchall_35
    move-exception v0

    return-void
.end method
