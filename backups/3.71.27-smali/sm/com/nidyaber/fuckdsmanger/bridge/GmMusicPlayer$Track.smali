.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Track"
.end annotation


# instance fields
.field public final album:Ljava/lang/String;

.field public final artist:Ljava/lang/String;

.field public final dur:J

.field public final id:J

.field public final name:Ljava/lang/String;


# direct methods
.method public constructor <init>(JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V
    .registers 8

    .line 78
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 79
    iput-wide p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    .line 80
    const-string p1, ""

    if-nez p3, :cond_a

    move-object p3, p1

    :cond_a
    iput-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    if-nez p4, :cond_f

    move-object p4, p1

    .line 81
    :cond_f
    iput-object p4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    if-nez p5, :cond_14

    move-object p5, p1

    .line 82
    :cond_14
    iput-object p5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->album:Ljava/lang/String;

    .line 83
    iput-wide p6, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->dur:J

    return-void
.end method


# virtual methods
.method public toJson()Lorg/json/JSONObject;
    .registers 5

    .line 87
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 89
    :try_start_5
    const-string v1, "id"

    iget-wide v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 90
    const-string v1, "name"

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 91
    const-string v1, "artist"

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 92
    const-string v1, "album"

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->album:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 93
    const-string v1, "dur"

    iget-wide v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->dur:J

    invoke-virtual {v0, v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;
    :try_end_28
    .catchall {:try_start_5 .. :try_end_28} :catchall_28

    :catchall_28
    return-object v0
.end method
