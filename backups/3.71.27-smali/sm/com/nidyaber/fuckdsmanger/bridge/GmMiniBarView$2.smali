.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$2;
.super Landroid/view/ViewOutlineProvider;
.source "GmMiniBarView.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->build()V
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

    .line 322
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Landroid/view/ViewOutlineProvider;-><init>()V

    return-void
.end method


# virtual methods
.method public getOutline(Landroid/view/View;Landroid/graphics/Outline;)V
    .registers 9

    .line 325
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v3

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v4

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/high16 p1, 0x41800000    # 16.0f

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I

    move-result p0

    int-to-float v5, p0

    const/4 v1, 0x0

    const/4 v2, 0x0

    move-object v0, p2

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Outline;->setRoundRect(IIIIF)V

    return-void
.end method
