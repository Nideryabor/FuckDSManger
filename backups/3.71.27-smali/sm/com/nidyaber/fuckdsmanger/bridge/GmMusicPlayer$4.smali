.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Landroid/media/MediaPlayer$OnPreparedListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->realPlay(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

.field final synthetic val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 439
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onPrepared(Landroid/media/MediaPlayer;)V
    .registers 4

    .line 442
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    const/4 v1, 0x0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$402(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Z)Z

    .line 444
    :try_start_6
    invoke-virtual {p1}, Landroid/media/MediaPlayer;->start()V
    :try_end_9
    .catchall {:try_start_6 .. :try_end_9} :catchall_a

    goto :goto_10

    :catchall_a
    move-exception p1

    .line 446
    const-string v0, "\u3010Music\u3011start \u5931\u8d25"

    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 448
    :goto_10
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u3010Music\u3011\u5f00\u59cb\u64ad\u653e\uff1a"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " - "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " \u2190 "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->level:Ljava/lang/String;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$300(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 449
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    .line 450
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->saveState()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    return-void
.end method
