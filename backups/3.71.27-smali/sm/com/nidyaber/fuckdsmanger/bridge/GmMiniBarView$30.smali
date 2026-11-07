.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$30;
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

.field final synthetic val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1413
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$30;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$30;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 1416
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1000()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-eqz v0, :cond_b

    .line 1417
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$30;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    invoke-virtual {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->play(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V

    .line 1418
    :cond_b
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$30;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v0, 0x0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showSearchPage(Z)V
    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V

    return-void
.end method
