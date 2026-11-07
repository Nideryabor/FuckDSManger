.class Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;
.super Ljava/lang/Object;
.source "GmNoteView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->bootstrap()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 2

    .line 220
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    .line 223
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curItem()Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "x"

    const/4 v2, -0x1

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v0

    .line 224
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curItem()Lorg/json/JSONObject;

    move-result-object v1

    const-string v3, "y"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v1

    .line 225
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 226
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    if-nez v3, :cond_27

    const/4 v3, 0x0

    goto :goto_2b

    .line 227
    :cond_27
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v3

    :goto_2b
    if-ltz v0, :cond_47

    if-gez v1, :cond_30

    goto :goto_47

    .line 232
    :cond_30
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    int-to-float v0, v0

    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v0

    int-to-float v0, v0

    invoke-virtual {v3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setX(F)V

    .line 233
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    int-to-float v1, v1

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setY(F)V

    goto :goto_6d

    .line 229
    :cond_47
    :goto_47
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    const/high16 v1, 0x41200000    # 10.0f

    if-lez v3, :cond_59

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->getWidth()I

    move-result v4

    sub-int/2addr v3, v4

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v1

    sub-int/2addr v3, v1

    int-to-float v1, v3

    goto :goto_5e

    :cond_59
    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v1

    int-to-float v1, v1

    :goto_5e
    invoke-virtual {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setX(F)V

    .line 230
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    const/high16 v1, 0x430c0000    # 140.0f

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->dp(Landroid/content/Context;F)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->setY(F)V

    .line 235
    :goto_6d
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$10;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->clamp()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$700(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    :try_end_72
    .catchall {:try_start_0 .. :try_end_72} :catchall_72

    :catchall_72
    return-void
.end method
