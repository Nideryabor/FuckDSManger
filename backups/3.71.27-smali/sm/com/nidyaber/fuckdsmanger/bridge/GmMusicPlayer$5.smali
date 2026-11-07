.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$5;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Landroid/media/MediaPlayer$OnCompletionListener;


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


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V
    .registers 2

    .line 453
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$5;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCompletion(Landroid/media/MediaPlayer;)V
    .registers 4

    .line 456
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$5;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->loop:I
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$900(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_11

    const/4 p0, 0x0

    .line 458
    :try_start_a
    invoke-virtual {p1, p0}, Landroid/media/MediaPlayer;->seekTo(I)V

    .line 459
    invoke-virtual {p1}, Landroid/media/MediaPlayer;->start()V
    :try_end_10
    .catchall {:try_start_a .. :try_end_10} :catchall_10

    :catchall_10
    return-void

    .line 463
    :cond_11
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$5;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->next()V

    return-void
.end method
