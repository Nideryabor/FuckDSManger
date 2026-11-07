.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->bootstrap()V
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

    .line 1661
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 7

    .line 1665
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    .line 1666
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_12

    move v0, v1

    goto :goto_16

    .line 1667
    :cond_12
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v0

    :goto_16
    const/4 v2, -0x1

    .line 1668
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->loadY(I)I

    move-result v3
    :try_end_1b
    .catchall {:try_start_0 .. :try_end_1b} :catchall_6f

    .line 1674
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    if-gez v3, :cond_3f

    if-lez v0, :cond_34

    .line 1672
    :try_start_21
    invoke-virtual {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getHeight()I

    move-result v3

    sub-int/2addr v0, v3

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/high16 v5, 0x42c00000    # 96.0f

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v3, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v3

    sub-int/2addr v0, v3

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    goto :goto_3a

    :cond_34
    const/high16 v0, 0x43b40000    # 360.0f

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v4, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v0

    :goto_3a
    int-to-float v0, v0

    invoke-virtual {v4, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setY(F)V

    goto :goto_48

    :cond_3f
    int-to-float v0, v3

    .line 1674
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v4, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v0

    int-to-float v0, v0

    invoke-virtual {v4, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setY(F)V

    .line 1676
    :goto_48
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->loadX(I)I

    move-result v0

    .line 1677
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    if-gez v0, :cond_57

    const/high16 v0, 0x41200000    # 10.0f

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v0

    goto :goto_5c

    :cond_57
    int-to-float v0, v0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v0

    :goto_5c
    int-to-float v0, v0

    invoke-virtual {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setX(F)V

    .line 1678
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->clamp()V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    .line 1679
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37$1;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;)V

    invoke-virtual {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->post(Ljava/lang/Runnable;)Z
    :try_end_6f
    .catchall {:try_start_21 .. :try_end_6f} :catchall_6f

    :catchall_6f
    return-void
.end method
