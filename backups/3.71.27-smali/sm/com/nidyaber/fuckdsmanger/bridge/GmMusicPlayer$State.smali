.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "State"
.end annotation


# instance fields
.field public dur:I

.field public error:Ljava/lang/String;

.field public index:I

.field public level:Ljava/lang/String;

.field public loop:I

.field public playing:Z

.field public pos:I

.field public preparing:Z

.field public queueSize:I

.field public track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;


# direct methods
.method public constructor <init>()V
    .registers 2

    .line 101
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 106
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    const/4 v0, -0x1

    .line 107
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->index:I

    .line 111
    const-string v0, "exhigh"

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->level:Ljava/lang/String;

    return-void
.end method
