.class final Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;
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
    name = "Resize"
.end annotation


# instance fields
.field private final corner:I

.field private resized:Z

.field private rx:F

.field private ry:F

.field private sh:I

.field private sw:I

.field private sx:I

.field private sy:I

.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;I)V
    .registers 3

    .line 1805
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1806
    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->corner:I

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 14

    const/4 p1, 0x0

    .line 1812
    :try_start_1
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1813
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_f5

    if-eq v1, v2, :cond_b1

    const/4 v3, 0x2

    if-eq v1, v3, :cond_17

    const/4 p2, 0x3

    if-eq v1, p2, :cond_b1

    return p1

    .line 1829
    :cond_17
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->rx:F

    sub-float/2addr v0, v1

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->ry:F

    sub-float/2addr p2, v1

    .line 1830
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->corner:I
    :try_end_27
    .catchall {:try_start_1 .. :try_end_27} :catchall_133

    if-eqz v1, :cond_2e

    if-ne v1, v3, :cond_2c

    goto :goto_2e

    :cond_2c
    move v3, p1

    goto :goto_2f

    :cond_2e
    :goto_2e
    move v3, v2

    :goto_2f
    if-eqz v1, :cond_36

    if-ne v1, v2, :cond_34

    goto :goto_36

    :cond_34
    move v1, p1

    goto :goto_37

    :cond_36
    :goto_36
    move v1, v2

    .line 1832
    :goto_37
    iget v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sw:I

    int-to-float v4, v4

    if-eqz v3, :cond_3e

    sub-float/2addr v4, v0

    goto :goto_3f

    :cond_3e
    add-float/2addr v4, v0

    :goto_3f
    float-to-int v0, v4

    .line 1833
    iget v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sh:I

    int-to-float v4, v4

    if-eqz v1, :cond_47

    sub-float/2addr v4, p2

    goto :goto_48

    :cond_47
    add-float/2addr v4, p2

    :goto_48
    float-to-int p2, v4

    .line 1834
    :try_start_49
    iget v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sx:I

    iget v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sy:I

    .line 1835
    iget-object v6, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/high16 v7, 0x43700000    # 240.0f

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v6, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v6

    iget-object v7, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/high16 v8, 0x43160000    # 150.0f

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v7, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v7

    .line 1836
    iget-object v8, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/high16 v9, 0x440c0000    # 560.0f

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v8, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v8

    iget-object v10, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {v10, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result v9

    if-ge v0, v6, :cond_77

    if-eqz v3, :cond_76

    .line 1838
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sx:I

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sw:I

    sub-int/2addr v3, v6

    add-int v4, v0, v3

    :cond_76
    move v0, v6

    :cond_77
    if-ge p2, v7, :cond_83

    if-eqz v1, :cond_82

    .line 1842
    iget p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sy:I

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sh:I

    sub-int/2addr v1, v7

    add-int v5, p2, v1

    :cond_82
    move p2, v7

    :cond_83
    if-le v0, v8, :cond_86

    goto :goto_87

    :cond_86
    move v8, v0

    :goto_87
    if-le p2, v9, :cond_8a

    goto :goto_8b

    :cond_8a
    move v9, p2

    .line 1847
    :goto_8b
    iget p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sw:I

    if-ne v8, p2, :cond_93

    iget p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sh:I

    if-eq v9, p2, :cond_95

    :cond_93
    iput-boolean v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->resized:Z

    .line 1848
    :cond_95
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    int-to-float v0, v4

    invoke-virtual {p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setX(F)V

    .line 1849
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    int-to-float v0, v5

    invoke-virtual {p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setY(F)V

    .line 1850
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p2

    .line 1851
    iput v8, p2, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 1852
    iput v9, p2, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 1853
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p0, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_b0
    .catchall {:try_start_49 .. :try_end_b0} :catchall_133

    return v2

    .line 1859
    :cond_b1
    :try_start_b1
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getParent()Landroid/view/ViewParent;

    move-result-object p2

    check-cast p2, Landroid/view/ViewGroup;

    if-eqz p2, :cond_be

    .line 1860
    invoke-virtual {p2, p1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V
    :try_end_be
    .catchall {:try_start_b1 .. :try_end_be} :catchall_be

    .line 1863
    :catchall_be
    :cond_be
    :try_start_be
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->clamp()V
    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    .line 1864
    iget-boolean p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->resized:Z

    if-eqz p2, :cond_f4

    .line 1865
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getWidth()I

    move-result p2

    int-to-float p2, p2

    invoke-static {v0, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result p2

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    .line 1866
    invoke-virtual {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getHeight()I

    move-result v1

    int-to-float v1, v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result v1

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    .line 1867
    invoke-virtual {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getX()F

    move-result v3

    invoke-static {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result v3

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getY()F

    move-result p0

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result p0

    .line 1865
    invoke-static {p2, v1, v3, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->saveSize(IIII)V

    :cond_f4
    return v2

    .line 1815
    :cond_f5
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->rx:F

    .line 1816
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->ry:F

    .line 1817
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getX()F

    move-result p2

    float-to-int p2, p2

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sx:I

    .line 1818
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getY()F

    move-result p2

    float-to-int p2, p2

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sy:I

    .line 1819
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getWidth()I

    move-result p2

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sw:I

    .line 1820
    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getHeight()I

    move-result p2

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->sh:I

    .line 1821
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->resized:Z
    :try_end_125
    .catchall {:try_start_be .. :try_end_125} :catchall_133

    .line 1823
    :try_start_125
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/view/ViewGroup;

    if-eqz p0, :cond_132

    .line 1824
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V
    :try_end_132
    .catchall {:try_start_125 .. :try_end_132} :catchall_132

    :catchall_132
    :cond_132
    return v2

    :catchall_133
    move-exception p0

    .line 1875
    const-string p2, "\u3010GmMiniBar\u3011\u62c9\u4f38\u5931\u8d25"

    invoke-static {p2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return p1
.end method
