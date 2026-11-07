.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$14;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->scheduleFollowResume()V
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

    .line 978
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$14;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 981
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$14;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v1, 0x0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcUnlock:Ljava/lang/Runnable;
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1302(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/lang/Runnable;)Ljava/lang/Runnable;

    .line 982
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$14;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    const/4 v1, 0x1

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1402(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z

    .line 983
    const-string v0, "\u3010GmMiniBar\u3011\u6b4c\u8bcd\u81ea\u52a8\u8ddf\u968f\u6062\u590d"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 984
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$14;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lyricScrollToCurrent(Z)V
    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$1500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V

    return-void
.end method
