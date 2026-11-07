.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->startCurrent()V
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

    .line 394
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    .line 397
    const-string v0, ""

    .line 400
    :try_start_2
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->val$t:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-wide v1, v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->level:Ljava/lang/String;
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$300(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->songUrl(JLjava/lang/String;)Ljava/util/Map;

    move-result-object v1

    .line 401
    const-string v2, "url"

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_19

    goto :goto_1d

    .line 402
    :cond_19
    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 403
    :goto_1d
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_26

    const-string v1, "\u8fd9\u9996\u62ff\u4e0d\u5230\u64ad\u653e\u5730\u5740\uff08\u65e0\u7248\u6743 / \u9700\u8981\u4f1a\u5458\uff09"
    :try_end_25
    .catchall {:try_start_2 .. :try_end_25} :catchall_28

    goto :goto_4c

    :cond_26
    const/4 v1, 0x0

    goto :goto_4c

    :catchall_28
    move-exception v1

    .line 405
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u53d6\u64ad\u653e\u5730\u5740\u5931\u8d25\uff1a"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v3

    if-nez v3, :cond_3b

    invoke-virtual {v1}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v3

    goto :goto_3f

    :cond_3b
    invoke-virtual {v1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v3

    :goto_3f
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 406
    const-string v3, "\u3010Music\u3011\u53d6\u5730\u5740\u5931\u8d25"

    invoke-static {v3, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    move-object v1, v2

    .line 411
    :goto_4c
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->ui:Landroid/os/Handler;
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;)Landroid/os/Handler;

    move-result-object v2

    new-instance v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;

    invoke-direct {v3, p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$3;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
