.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Landroid/widget/SeekBar$OnSeekBarChangeListener;


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

    .line 564
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onProgressChanged(Landroid/widget/SeekBar;IZ)V
    .registers 6

    if-eqz p3, :cond_24

    .line 567
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curDur:I
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)I

    move-result p1

    if-lez p1, :cond_24

    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vPos:Landroid/widget/TextView;
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/TextView;

    move-result-object p1

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curDur:I
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)I

    move-result p0

    int-to-long v0, p0

    int-to-long p2, p2

    mul-long/2addr v0, p2

    const-wide/16 p2, 0x3e8

    div-long/2addr v0, p2

    long-to-int p0, v0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->fmt(I)Ljava/lang/String;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$700(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_24
    return-void
.end method

.method public onStartTrackingTouch(Landroid/widget/SeekBar;)V
    .registers 2

    .line 572
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 p1, 0x1

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->seekTouching:Z
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$902(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z

    return-void
.end method

.method public onStopTrackingTouch(Landroid/widget/SeekBar;)V
    .registers 5

    .line 577
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v1, 0x0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->seekTouching:Z
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$902(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z

    .line 578
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1000()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    .line 579
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curDur:I
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)I

    move-result v1

    if-lez v1, :cond_28

    if-eqz v0, :cond_28

    .line 580
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curDur:I
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)I

    move-result p0

    int-to-long v1, p0

    invoke-virtual {p1}, Landroid/widget/SeekBar;->getProgress()I

    move-result p0

    int-to-long p0, p0

    mul-long/2addr v1, p0

    const-wide/16 p0, 0x3e8

    div-long/2addr v1, p0

    long-to-int p0, v1

    invoke-virtual {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->seekTo(I)V

    :cond_28
    return-void
.end method
