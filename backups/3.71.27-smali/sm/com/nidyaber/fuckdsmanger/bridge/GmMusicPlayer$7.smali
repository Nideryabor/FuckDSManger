.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->search(Ljava/lang/String;ILcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

.field final synthetic val$cb:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;

.field final synthetic val$kw:Ljava/lang/String;

.field final synthetic val$limit:I


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;Ljava/lang/String;ILcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 552
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->val$kw:Ljava/lang/String;

    iput p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->val$limit:I

    iput-object p4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->val$cb:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 12

    .line 555
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 557
    :try_start_5
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->val$kw:Ljava/lang/String;

    iget v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->val$limit:I

    const/4 v3, 0x0

    invoke-static {v0, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->search(Ljava/lang/String;II)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_12
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_6d

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map;

    .line 558
    new-instance v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    const-string v4, "id"

    .line 559
    invoke-interface {v2, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->num(Ljava/lang/Object;)J
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1000(Ljava/lang/Object;)J

    move-result-wide v4

    const-string v6, "name"

    .line 560
    invoke-interface {v2, v6}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1100(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "artist"

    .line 561
    invoke-interface {v2, v7}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;
    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1100(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    const-string v8, "album"

    .line 562
    invoke-interface {v2, v8}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;
    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1100(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v8

    const-string v9, "duration"

    .line 563
    invoke-interface {v2, v9}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->num(Ljava/lang/Object;)J
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1000(Ljava/lang/Object;)J

    move-result-wide v9

    invoke-direct/range {v3 .. v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;-><init>(JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V

    .line 558
    invoke-interface {v1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_58
    .catchall {:try_start_5 .. :try_end_58} :catchall_59

    goto :goto_12

    :catchall_59
    move-exception v0

    .line 566
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010Music\u3011\u641c\u7d22\u5931\u8d25\uff1a"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->val$kw:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 568
    :cond_6d
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->ui:Landroid/os/Handler;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/os/Handler;

    move-result-object v0

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7$1;

    invoke-direct {v2, p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$7;Ljava/util/List;)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
