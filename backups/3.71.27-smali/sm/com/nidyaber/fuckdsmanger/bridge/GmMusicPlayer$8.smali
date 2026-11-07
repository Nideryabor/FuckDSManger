.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->cover(JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V
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

    .line 592
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    iput-wide p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->val$id:J

    iput-object p4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->val$cb:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    const-string v0, "https://"

    const/4 v1, 0x0

    .line 597
    :try_start_3
    const-string v2, ""

    .line 598
    iget-wide v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->val$id:J

    .line 599
    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    invoke-static {v3}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v3

    .line 598
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->songDetail(Ljava/util/List;)Ljava/util/List;

    move-result-object v3

    .line 600
    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_2a

    const/4 v2, 0x0

    invoke-interface {v3, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map;

    const-string v3, "picUrl"

    invoke-interface {v2, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->str(Ljava/lang/Object;)Ljava/lang/String;
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1100(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    .line 601
    :cond_2a
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    if-lez v3, :cond_a0

    const/16 v3, 0x3f

    .line 602
    invoke-virtual {v2, v3}, Ljava/lang/String;->indexOf(I)I

    move-result v3

    if-ltz v3, :cond_39

    goto :goto_4a

    :cond_39
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "?param=300y300"

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 603
    :goto_4a
    const-string v3, "http://"

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_63

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v0, 0x7

    invoke-virtual {v2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 604
    :cond_63
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, v2}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;

    const/16 v2, 0x2710

    .line 605
    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v2, 0x3a98

    .line 606
    invoke-virtual {v0, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 607
    const-string v2, "User-Agent"

    const-string v3, "Mozilla/5.0"

    invoke-virtual {v0, v2, v3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 608
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    .line 609
    invoke-static {v2}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;

    move-result-object v1
    :try_end_87
    .catchall {:try_start_3 .. :try_end_87} :catchall_8e

    .line 611
    :try_start_87
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_8a
    .catchall {:try_start_87 .. :try_end_8a} :catchall_8a

    .line 614
    :catchall_8a
    :try_start_8a
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_8d
    .catchall {:try_start_8a .. :try_end_8d} :catchall_8e

    goto :goto_a0

    :catchall_8e
    move-exception v0

    .line 617
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u3010Music\u3011\u5c01\u9762\u52a0\u8f7d\u5931\u8d25\uff1a"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_a0
    :goto_a0
    if-eqz v1, :cond_c1

    .line 623
    :try_start_a2
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sCoverCache:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1200()Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Map;->size()I

    move-result v0

    const/4 v2, 0x3

    if-le v0, v2, :cond_b4

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sCoverCache:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1200()Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 624
    :cond_b4
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->sCoverCache:Ljava/util/Map;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$1200()Ljava/util/Map;

    move-result-object v0

    iget-wide v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->val$id:J

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-interface {v0, v2, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_c1
    .catchall {:try_start_a2 .. :try_end_c1} :catchall_c1

    .line 628
    :catchall_c1
    :cond_c1
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->ui:Landroid/os/Handler;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/os/Handler;

    move-result-object v0

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8$1;

    invoke-direct {v2, p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;Landroid/graphics/Bitmap;)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
