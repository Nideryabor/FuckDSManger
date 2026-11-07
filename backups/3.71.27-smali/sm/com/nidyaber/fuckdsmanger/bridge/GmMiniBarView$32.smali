.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->row(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;Ljava/lang/Runnable;Ljava/lang/Runnable;Ljava/lang/String;Ljava/lang/String;Landroid/content/Context;)Landroid/widget/LinearLayout;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

.field final synthetic val$onRight:Ljava/lang/Runnable;

.field final synthetic val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

.field final synthetic val$tip:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/lang/String;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/Runnable;)V
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1484
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;->val$tip:Ljava/lang/String;

    iput-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iput-object p4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;->val$onRight:Ljava/lang/Runnable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 3

    const-string p1, "\u3010GmMiniBar\u3011\ud83d\udc46 \u70b9\u4e86 "

    .line 1488
    :try_start_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;->val$tip:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\uff1a"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object p1, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1489
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;->val$onRight:Ljava/lang/Runnable;

    invoke-interface {p0}, Ljava/lang/Runnable;->run()V
    :try_end_24
    .catchall {:try_start_2 .. :try_end_24} :catchall_24

    :catchall_24
    return-void
.end method
