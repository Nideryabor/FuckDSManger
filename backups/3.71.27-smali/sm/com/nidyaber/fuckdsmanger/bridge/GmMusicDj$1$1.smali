.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1$1;
.super Ljava/lang/Object;
.source "GmMusicDj.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->on(Ljava/util/List;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
        "Ljava/util/List<",
        "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
        ">;>;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;)V
    .registers 2

    .line 245
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic on(Ljava/lang/Object;)V
    .registers 2

    .line 245
    check-cast p1, Ljava/util/List;

    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1$1;->on(Ljava/util/List;)V

    return-void
.end method

.method public on(Ljava/util/List;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;)V"
        }
    .end annotation

    .line 248
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fSong:Ljava/lang/String;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fArtist:Ljava/lang/String;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->doPick(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {p1, v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->access$100(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
