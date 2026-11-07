.class final Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "Drag"
.end annotation


# instance fields
.field private moved:Z

.field private rx:F

.field private ry:F

.field private sx:I

.field private sy:I

.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method private constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 2

    .line 1734
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;)V
    .registers 3

    .line 1734
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 7

    const/4 p1, 0x0

    .line 1743
    :try_start_1
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_8e

    if-eq v0, v1, :cond_54

    const/4 v2, 0x2

    if-eq v0, v2, :cond_11

    const/4 p2, 0x3

    if-eq v0, p2, :cond_54

    return p1

    .line 1757
    :cond_11
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->sx:I

    int-to-float v0, v0

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v2

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->rx:F

    sub-float/2addr v2, v3

    add-float/2addr v0, v2

    .line 1758
    iget v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->sy:I

    int-to-float v2, v2

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->ry:F

    sub-float/2addr p2, v3

    add-float/2addr v2, p2

    .line 1760
    iget-boolean p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->moved:Z

    if-nez p2, :cond_49

    iget p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->sx:I

    int-to-float p2, p2

    sub-float p2, v0, p2

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p2

    const/high16 v3, 0x40400000    # 3.0f

    cmpl-float p2, p2, v3

    if-gtz p2, :cond_47

    iget p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->sy:I

    int-to-float p2, p2

    sub-float p2, v2, p2

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p2

    cmpl-float p2, p2, v3

    if-lez p2, :cond_49

    .line 1761
    :cond_47
    iput-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->moved:Z

    .line 1763
    :cond_49
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setX(F)V

    .line 1764
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setY(F)V
    :try_end_53
    .catchall {:try_start_1 .. :try_end_53} :catchall_bc

    return v1

    .line 1770
    :cond_54
    :try_start_54
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getParent()Landroid/view/ViewParent;

    move-result-object p2

    check-cast p2, Landroid/view/ViewGroup;

    if-eqz p2, :cond_61

    .line 1771
    invoke-virtual {p2, p1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V
    :try_end_61
    .catchall {:try_start_54 .. :try_end_61} :catchall_61

    .line 1774
    :catchall_61
    :cond_61
    :try_start_61
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->clamp()V
    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    .line 1780
    iget-boolean p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->moved:Z

    if-eqz p2, :cond_8d

    .line 1781
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object p2

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getX()F

    move-result v0

    invoke-static {p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result p2

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    .line 1782
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getY()F

    move-result p0

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result p0

    .line 1781
    invoke-static {p2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->savePos(II)V

    :cond_8d
    return v1

    .line 1745
    :cond_8e
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getX()F

    move-result v0

    float-to-int v0, v0

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->sx:I

    .line 1746
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getY()F

    move-result v0

    float-to-int v0, v0

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->sy:I

    .line 1747
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->rx:F

    .line 1748
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->ry:F

    .line 1749
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->moved:Z
    :try_end_ae
    .catchall {:try_start_61 .. :try_end_ae} :catchall_bc

    .line 1751
    :try_start_ae
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/view/ViewGroup;

    if-eqz p0, :cond_bb

    .line 1752
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V
    :try_end_bb
    .catchall {:try_start_ae .. :try_end_bb} :catchall_bb

    :catchall_bb
    :cond_bb
    return v1

    :catchall_bc
    move-exception p0

    .line 1790
    const-string p2, "\u3010GmMiniBar\u3011\u62d6\u52a8\u5931\u8d25"

    invoke-static {p2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return p1
.end method
