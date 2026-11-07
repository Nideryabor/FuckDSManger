.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$4;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->buildTopBar()V
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

    .line 446
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    .line 449
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->exitFocus()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$300(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    return-void
.end method
