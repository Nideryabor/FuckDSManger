.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$35;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;
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

    .line 1605
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$35;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 1609
    :try_start_0
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1000()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-eqz v0, :cond_f

    .line 1610
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$35;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyState(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V
    :try_end_f
    .catchall {:try_start_0 .. :try_end_f} :catchall_f

    .line 1613
    :catchall_f
    :cond_f
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$35;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x1f4

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
