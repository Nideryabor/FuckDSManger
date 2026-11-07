.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$13;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->syncLyric(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 2

    .line 894
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$13;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic on(Ljava/lang/Object;)V
    .registers 2

    .line 894
    check-cast p1, Ljava/lang/String;

    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$13;->on(Ljava/lang/String;)V

    return-void
.end method

.method public on(Ljava/lang/String;)V
    .registers 2

    return-void
.end method
