.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8$1;
.super Ljava/lang/Object;
.source "GmMusicPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;

.field final synthetic val$fb:Landroid/graphics/Bitmap;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;Landroid/graphics/Bitmap;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 628
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8$1;->val$fb:Landroid/graphics/Bitmap;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    .line 632
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8$1;->this$1:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;

    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8;->val$cb:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$8$1;->val$fb:Landroid/graphics/Bitmap;

    invoke-interface {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;->on(Ljava/lang/Object;)V
    :try_end_9
    .catchall {:try_start_0 .. :try_end_9} :catchall_9

    :catchall_9
    return-void
.end method
