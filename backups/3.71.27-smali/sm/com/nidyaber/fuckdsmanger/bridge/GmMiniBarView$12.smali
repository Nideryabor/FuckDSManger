.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$12;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->buildPlayPage(Landroid/widget/FrameLayout;)V
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

    .line 639
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$12;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 642
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1000()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object p0

    if-nez p0, :cond_7

    return-void

    .line 644
    :cond_7
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->state()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;

    move-result-object v0

    iget v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_11

    const/4 v1, 0x0

    :cond_11
    invoke-virtual {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->setLoop(I)V

    return-void
.end method
