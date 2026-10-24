.class public final Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;
.super Ljava/lang/Object;
.source "GmCallTick.java"

# interfaces
.implements Ljava/lang/Runnable;


# static fields
.field static sH:Landroid/os/Handler;

.field static sOn:Z

.field static sR:Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;


# direct methods
.method static constructor <clinit>()V
    .registers 2

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sH:Landroid/os/Handler;

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sR:Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static start()V
    .registers 4

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sOn:Z

    if-nez v0, :cond_15

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sOn:Z

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sH:Landroid/os/Handler;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sR:Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;

    const-wide/16 v2, 0x3e8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    const-string v0, "[\u901a\u8bdd] \u901a\u8bdd\u5b88\u62a4\u5df2\u542f\u52a8\uff081s \u4e00\u6b21\uff0c\u60ac\u6d6e\u94ae\u5df2\u505c\u7528\uff09v2.20.0"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_15
    return-void
.end method

.method public static stop()V
    .registers 2

    const/4 v0, 0x0

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sOn:Z

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sH:Landroid/os/Handler;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sR:Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_8

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallBtn;->ensure(Landroid/app/Activity;)V

    goto :goto_9

    :cond_8
    nop

    :goto_9
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->tick()V
    :try_end_c
    .catchall {:try_start_0 .. :try_end_c} :catchall_d

    goto :goto_e

    :catchall_d
    move-exception v0

    :goto_e
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sH:Landroid/os/Handler;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->sR:Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;

    const-wide/16 v2, 0x3e8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
