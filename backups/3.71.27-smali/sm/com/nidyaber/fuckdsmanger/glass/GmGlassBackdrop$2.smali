.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;
.super Ljava/lang/Object;
.source "GmGlassBackdrop.java"

# interfaces
.implements Landroid/view/PixelCopy$OnPixelCopyFinishedListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->capture(Landroid/app/Activity;Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$bmp:Landroid/graphics/Bitmap;

.field final synthetic val$h:I

.field final synthetic val$w:I


# direct methods
.method constructor <init>(Landroid/graphics/Bitmap;II)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 217
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$bmp:Landroid/graphics/Bitmap;

    iput p2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$w:I

    iput p3, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$h:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onPixelCopyFinished(I)V
    .registers 7

    const-string v0, "\u3010GmGlass\u3011\u5e95\u56fe OK "

    const-string v1, "\u3010GmGlass\u3011PixelCopy \u5931\u8d25 result="

    const-string v2, "\u3010GmGlass\u3011\u5e95\u56fe\u5904\u7406\u5931\u8d25\uff1a"

    const/4 v3, 0x1

    const/4 v4, 0x0

    .line 221
    :try_start_8
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$502(Z)Z

    if-eqz p1, :cond_3b

    .line 223
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$bmp:Landroid/graphics/Bitmap;

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v0

    if-nez v0, :cond_1a

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$bmp:Landroid/graphics/Bitmap;

    invoke-virtual {p0}, Landroid/graphics/Bitmap;->recycle()V

    .line 224
    :cond_1a
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$300()Z

    move-result p0

    if-nez p0, :cond_37

    .line 225
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$302(Z)Z

    .line 226
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "\uff08\u5c06\u9000\u5316\u4e3a\u4e0d\u6298\u5c04\uff09"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_37
    .catchall {:try_start_8 .. :try_end_37} :catchall_a6

    .line 251
    :cond_37
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$402(Z)Z

    return-void

    .line 234
    :cond_3b
    :try_start_3b
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->needCpuBlur()Z

    move-result p1

    if-eqz p1, :cond_52

    .line 235
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$bmp:Landroid/graphics/Bitmap;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->get()Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    move-result-object v1

    iget v1, v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->blur:I

    div-int/lit8 v1, v1, 0x4

    invoke-static {v3, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    invoke-static {p1, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBlur;->blur(Landroid/graphics/Bitmap;I)V

    .line 237
    :cond_52
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBack:Landroid/graphics/Bitmap;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$600()Landroid/graphics/Bitmap;

    move-result-object p1

    .line 238
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$bmp:Landroid/graphics/Bitmap;

    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBack:Landroid/graphics/Bitmap;
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$602(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;

    if-eqz p1, :cond_6a

    .line 239
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$bmp:Landroid/graphics/Bitmap;

    if-eq p1, v1, :cond_6a

    invoke-virtual {p1}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-nez v1, :cond_6a

    invoke-virtual {p1}, Landroid/graphics/Bitmap;->recycle()V

    .line 240
    :cond_6a
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sOkLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$700()Z

    move-result p1

    if-nez p1, :cond_a2

    .line 241
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sOkLogged:Z
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$702(Z)Z

    .line 242
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$w:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "x"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;->val$h:I

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u00b7 \u6a21\u7cca\u534a\u5f84="

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 243
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->get()Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    move-result-object p0

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->blur:I

    div-int/lit8 p0, p0, 0x4

    invoke-static {v3, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 242
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_a2
    .catchall {:try_start_3b .. :try_end_a2} :catchall_a6

    .line 251
    :cond_a2
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$402(Z)Z

    return-void

    :catchall_a6
    move-exception p0

    .line 246
    :try_start_a7
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$300()Z

    move-result p1

    if-nez p1, :cond_bf

    .line 247
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$302(Z)Z

    .line 248
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_bf
    .catchall {:try_start_a7 .. :try_end_bf} :catchall_c3

    .line 251
    :cond_bf
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$402(Z)Z

    return-void

    :catchall_c3
    move-exception p0

    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$402(Z)Z

    .line 252
    throw p0
.end method
