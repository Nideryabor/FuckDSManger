.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->lyric(JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

.field final synthetic val$cb:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;

.field final synthetic val$id:J


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 648
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    iput-wide p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->val$id:J

    iput-object p4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->val$cb:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    .line 651
    const-string v0, ""

    .line 653
    :try_start_2
    iget-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->val$id:J

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->lyric(J)Ljava/util/Map;

    move-result-object v1

    .line 654
    const-string v2, "lrc"

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_11

    goto :goto_1c

    .line 655
    :cond_11
    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0
    :try_end_15
    .catchall {:try_start_2 .. :try_end_15} :catchall_16

    goto :goto_1c

    :catchall_16
    move-exception v1

    .line 657
    const-string v2, "\u3010Music\u3011\u6b4c\u8bcd\u52a0\u8f7d\u5931\u8d25"

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 659
    :goto_1c
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_41

    .line 661
    :try_start_22
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sLyricCache:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1300()Ljava/util/Map;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Map;->size()I

    move-result v1

    const/4 v2, 0x6

    if-le v1, v2, :cond_34

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sLyricCache:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1300()Ljava/util/Map;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Map;->clear()V

    .line 662
    :cond_34
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sLyricCache:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1300()Ljava/util/Map;

    move-result-object v1

    iget-wide v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->val$id:J

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-interface {v1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_41
    .catchall {:try_start_22 .. :try_end_41} :catchall_41

    .line 667
    :catchall_41
    :cond_41
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->ui:Landroid/os/Handler;
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/os/Handler;

    move-result-object v1

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9$1;

    invoke-direct {v2, p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
