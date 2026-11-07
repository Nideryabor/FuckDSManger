.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$6;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Landroid/media/MediaPlayer$OnErrorListener;


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

    .line 467
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$6;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onError(Landroid/media/MediaPlayer;II)Z
    .registers 6

    .line 470
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u3010Music\u3011\u64ad\u653e\u9519\u8bef what="

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " extra="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 471
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$6;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    const/4 v0, 0x0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->preparing:Z
    invoke-static {p1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$402(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Z)Z

    .line 472
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$6;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u64ad\u653e\u51fa\u9519("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, "/"

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, ")"

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->error:Ljava/lang/String;
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$502(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Ljava/lang/String;)Ljava/lang/String;

    .line 473
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$6;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->notifyState()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)V

    const/4 p0, 0x1

    return p0
.end method
