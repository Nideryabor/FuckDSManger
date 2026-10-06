.class public final Lcom/varuns2002/disable_flag_secure/gm/GmKillRun;
.super Ljava/lang/Object;
.source "GmKillRun.java"

# interfaces
.implements Ljava/lang/Runnable;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    :try_start_0
    const-wide/16 v0, 0x5dc

    invoke-static {v0, p0}, Ljava/lang/Thread;->sleep(J)V
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_5

    :catchall_5
    :try_start_5
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v0

    invoke-static {v0}, Landroid/os/Process;->killProcess(I)V
    :try_end_c
    .catchall {:try_start_5 .. :try_end_c} :catchall_c

    :catchall_c
    return-void
.end method
