.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$19;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Landroid/widget/AbsListView$OnScrollListener;


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

    .line 1174
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$19;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onScroll(Landroid/widget/AbsListView;III)V
    .registers 5

    return-void
.end method

.method public onScrollStateChanged(Landroid/widget/AbsListView;I)V
    .registers 3

    const/4 p1, 0x1

    if-ne p2, p1, :cond_13

    .line 1178
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$19;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 p2, 0x0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1402(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z

    .line 1179
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$19;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->scheduleFollowResume()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    .line 1180
    const-string p0, "\u3010GmMiniBar\u3011\u7528\u6237\u5f00\u59cb\u6ed1\u6b4c\u8bcd \u2192 \u6682\u505c\u8ddf\u968f 3 \u79d2"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_13
    return-void
.end method
