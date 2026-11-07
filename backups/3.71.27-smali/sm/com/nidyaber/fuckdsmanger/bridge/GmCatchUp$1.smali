.class Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;
.super Ljava/lang/Object;
.source "GmCatchUp.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field n:I

.field final synthetic val$cl:Ljava/lang/ClassLoader;

.field final synthetic val$h:Landroid/os/Handler;


# direct methods
.method constructor <init>(Ljava/lang/ClassLoader;Landroid/os/Handler;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 67
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->val$cl:Ljava/lang/ClassLoader;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->val$h:Landroid/os/Handler;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 p1, 0x0

    .line 68
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->n:I

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 72
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->sDone:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->access$000()Z

    move-result v0

    if-eqz v0, :cond_7

    return-void

    .line 73
    :cond_7
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->n:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->n:I

    .line 74
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->currentActivity()Landroid/app/Activity;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->access$100()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_1e

    .line 76
    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->sDone:Z
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->access$002(Z)Z

    .line 77
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->val$cl:Ljava/lang/ClassLoader;

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->n:I

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->bind(Landroid/app/Activity;Ljava/lang/ClassLoader;I)V
    invoke-static {v0, v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->access$200(Landroid/app/Activity;Ljava/lang/ClassLoader;I)V

    return-void

    .line 80
    :cond_1e
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->n:I

    const/16 v2, 0x18

    if-lt v0, v2, :cond_40

    .line 81
    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->sDone:Z
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->access$002(Z)Z

    .line 82
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010FDM\u3011\u8fdf\u5230\u7ed1\u5b9a\uff1a\u8bd5\u4e86 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->n:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u6b21\u4ecd\u6ca1\u627e\u5230\u6d3b\u7740\u7684 Activity \u21d2 \u653e\u5f03\uff08\u4e0b\u6b21 resume \u4f1a\u7167\u5e38\u8865\u4e0a\uff09"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 86
    :cond_40
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp$1;->val$h:Landroid/os/Handler;

    const-wide/16 v1, 0xfa

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
