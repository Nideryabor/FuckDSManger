.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$16;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Landroid/animation/ValueAnimator$AnimatorUpdateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->animateLayout(F)V
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

    .line 1048
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$16;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onAnimationUpdate(Landroid/animation/ValueAnimator;)V
    .registers 3

    .line 1051
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$16;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Float;

    invoke-virtual {p1}, Ljava/lang/Float;->floatValue()F

    move-result p1

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$402(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)F

    .line 1052
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$16;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)F

    move-result p1

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyPlayLayout(F)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)V

    return-void
.end method
