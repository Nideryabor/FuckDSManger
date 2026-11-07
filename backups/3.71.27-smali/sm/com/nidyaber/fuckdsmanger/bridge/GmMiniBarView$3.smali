.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$3;
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

    .line 437
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    .line 440
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v0, 0x1

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showSearchPage(Z)V
    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V

    return-void
.end method
