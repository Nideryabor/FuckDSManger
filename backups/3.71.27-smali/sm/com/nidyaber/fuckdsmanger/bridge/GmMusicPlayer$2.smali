.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$2;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;-><init>()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V
    .registers 2

    .line 195
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 199
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->mp:Landroid/media/MediaPlayer;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$000(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/media/MediaPlayer;

    move-result-object v0

    if-eqz v0, :cond_d

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_d

    .line 202
    :catchall_d
    :cond_d
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->ui:Landroid/os/Handler;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x1f4

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
