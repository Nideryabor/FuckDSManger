.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;
.super Ljava/lang/Object;
.source "GmMusicDj.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->handle(Ljava/lang/String;)Ljava/lang/String;
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
.field final synthetic val$fArtist:Ljava/lang/String;

.field final synthetic val$fSong:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 228
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fArtist:Ljava/lang/String;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fSong:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic on(Ljava/lang/Object;)V
    .registers 2

    .line 228
    check-cast p1, Ljava/util/List;

    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->on(Ljava/util/List;)V

    return-void
.end method

.method public on(Ljava/util/List;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;)V"
        }
    .end annotation

    .line 233
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->lastCode()I

    move-result v0

    if-eqz p1, :cond_c

    .line 234
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_34

    :cond_c
    const/16 v1, 0xc8

    if-eq v0, v1, :cond_34

    const/4 v1, -0x1

    if-eq v0, v1, :cond_34

    .line 235
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->noteApiError(I)Z
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->access$000(I)Z

    move-result p0

    if-eqz p0, :cond_33

    .line 236
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object p0

    new-instance p1, Ljava/lang/StringBuilder;

    const-string v1, "\u266a \u7f51\u6613\u4e91\u62d2\u7edd\u4e86\u641c\u7d22\uff08code="

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "\uff09\u2014\u2014 \u53ef\u80fd\u88ab\u9650\u6d41\uff0c\u7a0d\u540e\u518d\u8bd5\uff1b\u4e00\u76f4\u4e0d\u884c\u5c31\u53bb\u97f3\u4e50\u9875\u91cd\u65b0\u767b\u5f55"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_33
    return-void

    :cond_34
    if-eqz p1, :cond_3c

    .line 241
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_6a

    :cond_3c
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fArtist:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_6a

    .line 242
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-eqz v0, :cond_6a

    .line 244
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v1, "\u3010DJ\u3011\u7ec4\u5408\u8bcd\u6ca1\u7ed3\u679c\uff0c\u9000\u56de\u7eaf\u6b4c\u540d\u518d\u641c\uff1a"

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fSong:Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 245
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fSong:Ljava/lang/String;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1$1;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;)V

    const/16 p0, 0x14

    invoke-virtual {v0, p1, p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->search(Ljava/lang/String;ILcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V

    return-void

    .line 254
    :cond_6a
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fSong:Ljava/lang/String;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj$1;->val$fArtist:Ljava/lang/String;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->doPick(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {p1, v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicDj;->access$100(Ljava/util/List;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
