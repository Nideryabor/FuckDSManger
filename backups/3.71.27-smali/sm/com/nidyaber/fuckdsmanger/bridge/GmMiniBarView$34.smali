.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ensureCover(J)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
        "Landroid/graphics/Bitmap;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

.field final synthetic val$id:J


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;J)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1586
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    iput-wide p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;->val$id:J

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public on(Landroid/graphics/Bitmap;)V
    .registers 6

    .line 1590
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->coverWanted:J
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)J

    move-result-wide v0

    iget-wide v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;->val$id:J

    cmp-long v0, v0, v2

    if-nez v0, :cond_1f

    if-eqz p1, :cond_1f

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/ImageView;

    move-result-object v0

    if-eqz v0, :cond_1f

    .line 1591
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$3500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/ImageView;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V
    :try_end_1f
    .catchall {:try_start_0 .. :try_end_1f} :catchall_1f

    :catchall_1f
    :cond_1f
    return-void
.end method

.method public bridge synthetic on(Ljava/lang/Object;)V
    .registers 2

    .line 1586
    check-cast p1, Landroid/graphics/Bitmap;

    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;->on(Landroid/graphics/Bitmap;)V

    return-void
.end method
