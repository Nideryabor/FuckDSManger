.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;
.super Landroid/view/GestureDetector$SimpleOnGestureListener;
.source "GmMiniBarView.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->installGestures()V
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

    .line 1119
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Landroid/view/GestureDetector$SimpleOnGestureListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onDoubleTap(Landroid/view/MotionEvent;)Z
    .registers 2

    .line 1138
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z

    move-result p1

    if-nez p1, :cond_a

    const/4 p0, 0x0

    return p0

    .line 1139
    :cond_a
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->togglePureImage()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2200(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const/4 p0, 0x1

    return p0
.end method

.method public onDown(Landroid/view/MotionEvent;)Z
    .registers 2

    const/4 p0, 0x1

    return p0
.end method

.method public onLongPress(Landroid/view/MotionEvent;)V
    .registers 8

    const-string v0, "\u3010GmMiniBar\u3011\u957f\u6309\u6b4c\u8bcd\u7b2c "

    .line 1145
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z

    move-result v1

    if-eqz v1, :cond_a1

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z

    move-result v1

    if-eqz v1, :cond_14

    goto/16 :goto_a1

    .line 1147
    :cond_14
    :try_start_14
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2300(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/ListView;

    move-result-object v1

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v2

    float-to-int v2, v2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    float-to-int p1, p1

    invoke-virtual {v1, v2, p1}, Landroid/widget/ListView;->pointToPosition(II)I

    move-result p1

    if-ltz p1, :cond_a1

    .line 1148
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lt p1, v1, :cond_37

    goto :goto_a1

    .line 1149
    :cond_37
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Long;

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    .line 1150
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1000()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v3

    if-eqz v3, :cond_51

    long-to-int v4, v1

    .line 1151
    invoke-virtual {v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->seekTo(I)V

    .line 1152
    :cond_51
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v4, 0x1

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z
    invoke-static {v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1402(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z

    .line 1153
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I
    invoke-static {v3, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1202(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;I)I

    .line 1154
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2300(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/ListView;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/ListView;->invalidateViews()V

    .line 1155
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lyricScrollToCurrent(Z)V
    invoke-static {v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V

    .line 1156
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u884c \u2192 \u8df3\u5230 "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    long-to-double v0, v1

    const-wide v4, 0x408f400000000000L    # 1000.0

    div-double/2addr v0, v4

    invoke-virtual {v3, v0, v1}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v0, "s\uff08"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    .line 1157
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\uff09"

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 1156
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_a1
    .catchall {:try_start_14 .. :try_end_a1} :catchall_a1

    :catchall_a1
    :cond_a1
    :goto_a1
    return-void
.end method

.method public onSingleTapConfirmed(Landroid/view/MotionEvent;)Z
    .registers 4

    .line 1127
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z

    move-result p1

    .line 1132
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v1, 0x1

    if-eqz p1, :cond_15

    .line 1128
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->exitPure()V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1900(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    .line 1129
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 p1, 0x0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusMode(Z)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2000(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V

    return v1

    .line 1132
    :cond_15
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z

    move-result p0

    xor-int/2addr p0, v1

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusMode(Z)V
    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2000(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V

    return v1
.end method
