.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$29;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->refreshList()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

.field final synthetic val$ii:I


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;I)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1396
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$29;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$29;->val$ii:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 1399
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1000()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-eqz v0, :cond_b

    .line 1400
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$29;->val$ii:I

    invoke-virtual {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->removeAt(I)V

    .line 1401
    :cond_b
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$29;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->refreshList()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    return-void
.end method
