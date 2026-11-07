.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

.field final synthetic val$r:Ljava/lang/Runnable;

.field final synthetic val$tag:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/lang/String;Ljava/lang/Runnable;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 274
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;->val$tag:Ljava/lang/String;

    iput-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;->val$r:Ljava/lang/Runnable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 4

    const-string p1, "\u3010GmMiniBar\u3011\ud83d\udc46 \u70b9\u4e86 "

    .line 278
    :try_start_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;->val$tag:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 279
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;->val$r:Ljava/lang/Runnable;

    invoke-interface {p1}, Ljava/lang/Runnable;->run()V
    :try_end_18
    .catchall {:try_start_2 .. :try_end_18} :catchall_19

    return-void

    :catchall_19
    move-exception p1

    .line 281
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010GmMiniBar\u3011\u6309\u94ae\u5931\u8d25 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;->val$tag:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
