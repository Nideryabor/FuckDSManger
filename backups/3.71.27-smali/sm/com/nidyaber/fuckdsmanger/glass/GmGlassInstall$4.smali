.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$4;
.super Ljava/lang/Object;
.source "GmGlassInstall.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->snap()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$a:Landroid/app/Activity;


# direct methods
.method constructor <init>(Landroid/app/Activity;)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 205
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$4;->val$a:Landroid/app/Activity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 10

    const-string v0, "\u3010GmGlass\u3011\u81ea\u62cd OK "

    const-string v1, "\u3010GmGlass\u3011\u81ea\u62cd\u5931\u8d25\uff1a\u5c3a\u5bf8 "

    const/4 v2, 0x0

    .line 209
    :try_start_5
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$4;->val$a:Landroid/app/Activity;

    invoke-virtual {v3}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v3

    .line 210
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v4

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v5
    :try_end_17
    .catchall {:try_start_5 .. :try_end_17} :catchall_9d

    .line 211
    const-string v6, "x"

    if-lez v4, :cond_84

    if-gtz v5, :cond_1e

    goto :goto_84

    .line 215
    :cond_1e
    :try_start_1e
    sget-object v1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v4, v5, v1}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v1

    .line 216
    new-instance v7, Landroid/graphics/Canvas;

    invoke-direct {v7, v1}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    invoke-virtual {v3, v7}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    .line 217
    new-instance v3, Ljava/io/File;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$4;->val$a:Landroid/app/Activity;

    invoke-virtual {p0}, Landroid/app/Activity;->getFilesDir()Ljava/io/File;

    move-result-object p0

    const-string v7, "fdm-snap.png"

    invoke-direct {v3, p0, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 218
    new-instance p0, Ljava/io/FileOutputStream;

    invoke-direct {p0, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 219
    sget-object v7, Landroid/graphics/Bitmap$CompressFormat;->PNG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v8, 0x64

    invoke-virtual {v1, v7, v8, p0}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 220
    invoke-virtual {p0}, Ljava/io/FileOutputStream;->flush()V

    .line 221
    invoke-virtual {p0}, Ljava/io/FileOutputStream;->close()V

    .line 222
    invoke-virtual {v1}, Landroid/graphics/Bitmap;->recycle()V

    .line 223
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u2192 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " ("

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 224
    invoke-virtual {v3}, Ljava/io/File;->length()J

    move-result-wide v0

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v0, " B)"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 223
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_80
    .catchall {:try_start_1e .. :try_end_80} :catchall_9d

    .line 228
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sSnapping:Z
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$302(Z)Z

    return-void

    .line 212
    :cond_84
    :goto_84
    :try_start_84
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_99
    .catchall {:try_start_84 .. :try_end_99} :catchall_9d

    .line 228
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sSnapping:Z
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$302(Z)Z

    return-void

    :catchall_9d
    move-exception p0

    .line 226
    :try_start_9e
    const-string v0, "\u3010GmGlass\u3011\u81ea\u62cd\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_a3
    .catchall {:try_start_9e .. :try_end_a3} :catchall_a7

    .line 228
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sSnapping:Z
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$302(Z)Z

    return-void

    :catchall_a7
    move-exception p0

    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sSnapping:Z
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$302(Z)Z

    .line 229
    throw p0
.end method
