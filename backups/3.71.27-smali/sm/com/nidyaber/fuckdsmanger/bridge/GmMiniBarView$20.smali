.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;
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

    .line 1190
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Landroid/view/GestureDetector$SimpleOnGestureListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onDoubleTap(Landroid/view/MotionEvent;)Z
    .registers 2

    .line 1206
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z

    move-result p1

    if-nez p1, :cond_a

    const/4 p0, 0x0

    return p0

    .line 1207
    :cond_a
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->exitPure()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1900(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const/4 p0, 0x1

    return p0
.end method

.method public onDown(Landroid/view/MotionEvent;)Z
    .registers 2

    const/4 p0, 0x1

    return p0
.end method

.method public onSingleTapConfirmed(Landroid/view/MotionEvent;)Z
    .registers 3

    .line 1198
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z

    move-result p1

    const/4 v0, 0x0

    if-nez p1, :cond_a

    return v0

    .line 1199
    :cond_a
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->exitPure()V
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1900(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    .line 1200
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusMode(Z)V
    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2000(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V

    const/4 p0, 0x1

    return p0
.end method
