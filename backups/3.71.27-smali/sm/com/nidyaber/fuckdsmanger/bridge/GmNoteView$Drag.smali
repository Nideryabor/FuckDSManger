.class final Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;
.super Ljava/lang/Object;
.source "GmNoteView.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "Drag"
.end annotation


# instance fields
.field private final kind:I

.field private moved:Z

.field private rawX:F

.field private rawY:F

.field private startX:I

.field private startY:I

.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;I)V
    .registers 3

    .line 416
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 417
    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->kind:I

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 8

    const/4 p1, 0x0

    .line 423
    :try_start_1
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_b5

    if-eq v0, v1, :cond_6a

    const/4 v2, 0x2

    if-eq v0, v2, :cond_11

    const/4 p2, 0x3

    if-eq v0, p2, :cond_6a

    return p1

    .line 438
    :cond_11
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->startX:I

    int-to-float v0, v0

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v2

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->rawX:F

    sub-float/2addr v2, v3

    add-float/2addr v0, v2

    .line 439
    iget v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->startY:I

    int-to-float v2, v2

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result v3

    iget v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->rawY:F

    sub-float/2addr v3, v4

    add-float/2addr v2, v3

    .line 440
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setX(F)V

    .line 441
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setY(F)V

    .line 442
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iget v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->rawX:F

    sub-float/2addr v0, v2

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v2

    const/high16 v3, 0x40c00000    # 6.0f

    invoke-static {v2, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v2

    int-to-float v2, v2

    cmpl-float v0, v0, v2

    if-gtz v0, :cond_67

    .line 443
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->rawY:F

    sub-float/2addr p2, v0

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p2

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v0

    int-to-float v0, v0

    cmpl-float p2, p2, v0

    if-lez p2, :cond_69

    .line 444
    :cond_67
    iput-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->moved:Z
    :try_end_69
    .catchall {:try_start_1 .. :try_end_69} :catchall_e3

    :cond_69
    return v1

    .line 451
    :cond_6a
    :try_start_6a
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getParent()Landroid/view/ViewParent;

    move-result-object p2

    check-cast p2, Landroid/view/ViewGroup;

    if-eqz p2, :cond_77

    .line 452
    invoke-virtual {p2, p1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V
    :try_end_77
    .catchall {:try_start_6a .. :try_end_77} :catchall_77

    .line 455
    :catchall_77
    :cond_77
    :try_start_77
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->clamp()V
    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$700(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    .line 456
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object p2

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getX()F

    move-result v0

    invoke-static {p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->px2dp(Landroid/content/Context;F)I

    move-result p2

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    .line 457
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getY()F

    move-result v2

    invoke-static {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->px2dp(Landroid/content/Context;F)I

    move-result v0

    .line 456
    invoke-static {p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setPos(II)V

    .line 458
    iget p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->kind:I

    if-ne p2, v1, :cond_b4

    iget-boolean p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->moved:Z

    if-nez p2, :cond_b4

    .line 459
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V
    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    .line 460
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setMin(Z)V

    .line 461
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V

    :cond_b4
    return v1

    .line 425
    :cond_b5
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getX()F

    move-result v0

    float-to-int v0, v0

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->startX:I

    .line 426
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getY()F

    move-result v0

    float-to-int v0, v0

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->startY:I

    .line 427
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->rawX:F

    .line 428
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->rawY:F

    .line 429
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->moved:Z
    :try_end_d5
    .catchall {:try_start_77 .. :try_end_d5} :catchall_e3

    .line 432
    :try_start_d5
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$Drag;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/view/ViewGroup;

    if-eqz p0, :cond_e2

    .line 433
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V
    :try_end_e2
    .catchall {:try_start_d5 .. :try_end_e2} :catchall_e2

    :catchall_e2
    :cond_e2
    return v1

    :catchall_e3
    move-exception p0

    .line 468
    const-string p2, "\u3010GmNote\u3011\u62d6\u52a8\u5931\u8d25"

    invoke-static {p2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return p1
.end method
