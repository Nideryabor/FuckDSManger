.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9$1;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;

.field final synthetic val$f:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;Ljava/lang/String;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 667
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9$1;->val$f:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    .line 671
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9;->val$cb:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$9$1;->val$f:Ljava/lang/String;

    invoke-interface {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;->on(Ljava/lang/Object;)V
    :try_end_9
    .catchall {:try_start_0 .. :try_end_9} :catchall_9

    :catchall_9
    return-void
.end method
