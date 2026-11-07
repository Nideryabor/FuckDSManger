.class Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;
.super Ljava/lang/Object;
.source "FdmBridge.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->startReask(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$ctx:Landroid/content/Context;

.field final synthetic val$h:Landroid/os/Handler;

.field final synthetic val$n:[I


# direct methods
.method constructor <init>(Landroid/content/Context;[ILandroid/os/Handler;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 304
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;->val$ctx:Landroid/content/Context;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;->val$n:[I

    iput-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;->val$h:Landroid/os/Handler;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    .line 310
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;->val$ctx:Landroid/content/Context;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->syncPins(Landroid/content/Context;)Z
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->access$100(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_14

    .line 311
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sGotConfig:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->access$200()Z

    move-result v1

    if-eqz v1, :cond_14

    .line 312
    const-string p0, "\u3010FdmBridge\u3011\u914d\u7f6e\u5df2\u5230\u624b \u00b7 pin \u8868\u5df2\u540c\u6b65 \u21d2 \u505c\u6b62\u5468\u671f\u4efb\u52a1"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 315
    :cond_14
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;->val$n:[I

    const/4 v2, 0x0

    aget v3, v1, v2

    add-int/lit8 v4, v3, 0x1

    aput v4, v1, v2

    const/16 v1, 0x1e

    if-lt v3, v1, :cond_44

    .line 316
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010FdmBridge\u3011\u5468\u671f\u4efb\u52a1\u6536\u644a\uff08\u914d\u7f6e="

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->sGotConfig:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->access$200()Z

    move-result v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " \u00b7 pin \u8868="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 320
    :cond_44
    :try_start_44
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;->val$ctx:Landroid/content/Context;

    new-instance v1, Landroid/content/Intent;

    const-string v2, "com.little_femaleboy.fdm.CONFIG_REQ"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_50
    .catchall {:try_start_44 .. :try_end_50} :catchall_50

    .line 323
    :catchall_50
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$3;->val$h:Landroid/os/Handler;

    const-wide/16 v1, 0xfa0

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
