.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->doSearch()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
        "Ljava/util/List<",
        "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
        ">;>;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 2

    .line 1361
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic on(Ljava/lang/Object;)V
    .registers 2

    .line 1361
    check-cast p1, Ljava/util/List;

    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;->on(Ljava/util/List;)V

    return-void
.end method

.method public on(Ljava/util/List;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;)V"
        }
    .end annotation

    .line 1364
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v1, 0x0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searching:Z
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3202(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z

    .line 1365
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    if-nez p1, :cond_f

    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    :cond_f
    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->results:Ljava/util/List;
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3302(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/util/List;)Ljava/util/List;

    .line 1366
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showQueue:Z
    invoke-static {p1, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3002(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z

    .line 1367
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->refreshList()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    return-void
.end method
