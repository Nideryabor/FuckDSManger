.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

.field final synthetic val$fMsg:Ljava/lang/String;

.field final synthetic val$fUrl:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;Ljava/lang/String;Ljava/lang/String;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 411
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->val$fUrl:Ljava/lang/String;

    iput-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->val$fMsg:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 414
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->val$fUrl:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    .line 422
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    if-nez v0, :cond_3e

    .line 415
    iget-object v0, v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    const/4 v1, 0x0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$402(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Z)Z

    .line 416
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->val$fMsg:Ljava/lang/String;

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->error:Ljava/lang/String;
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$502(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Ljava/lang/String;)Ljava/lang/String;

    .line 417
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    .line 418
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    .line 419
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue:Ljava/util/List;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$700(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x1

    if-le v0, v1, :cond_3d

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->next()V

    :cond_3d
    return-void

    .line 422
    :cond_3e
    iget-object v0, v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;

    iget-object v1, v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;->val$fUrl:Ljava/lang/String;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->realPlay(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;)V
    invoke-static {v0, v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$800(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;)V

    return-void
.end method
