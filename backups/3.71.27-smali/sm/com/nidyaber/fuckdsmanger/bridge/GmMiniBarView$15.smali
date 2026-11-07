.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$15;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusMode(Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 2

    .line 1013
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$15;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    .line 1017
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$15;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    move-result-object v0

    if-eqz v0, :cond_11

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$15;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    move-result-object v0

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->notifyDataSetChanged()V

    .line 1018
    :cond_11
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$15;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v0, 0x0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lyricScrollToCurrent(Z)V
    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_17

    :catchall_17
    return-void
.end method
