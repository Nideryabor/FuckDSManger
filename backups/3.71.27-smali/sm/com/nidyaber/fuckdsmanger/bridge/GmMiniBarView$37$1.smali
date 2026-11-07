.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37$1;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;)V
    .registers 2

    .line 1679
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    .line 1682
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->clamp()V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    .line 1683
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)F

    move-result p0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyPlayLayout(F)V
    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)V

    return-void
.end method
