.class final Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;
.super Ljava/lang/Object;
.source "GmGlassWallpaper.java"


# static fields
.field public static final FILE_NAME:Ljava/lang/String; = "fuckds_bg.png"

.field private static final K_BG_ON:Ljava/lang/String; = "fuckds_bg_on"

.field private static volatile sLogged:Z = false

.field private static sRaw:Landroid/graphics/Bitmap;

.field private static sRawAt:J

.field private static sScaled:Landroid/graphics/Bitmap;

.field private static sScaledH:I

.field private static sScaledW:I


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static file(Landroid/content/Context;)Ljava/io/File;
    .registers 3

    .line 78
    :try_start_0
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    const-string v1, "fuckds_bg.png"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    :try_end_b
    .catchall {:try_start_0 .. :try_end_b} :catchall_c

    return-object v0

    :catchall_c
    const/4 p0, 0x0

    return-object p0
.end method

.method static get(Landroid/content/Context;II)Landroid/graphics/Bitmap;
    .registers 14

    const-string v0, "\uff081/4\uff09"

    const-string v1, "\u3010GmGlass\u3011\u80cc\u666f\u56fe\u5df2\u6309\u7a97\u53e3\u7f29\u5230 "

    const-string v2, "\u3010GmGlass\u3011\u80cc\u666f\u56fe\u5df2\u52a0\u8f7d "

    .line 94
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->switchOn(Landroid/content/Context;)Z

    move-result v3

    const/4 v4, 0x0

    if-nez v3, :cond_13

    .line 95
    const-string p1, "\u80cc\u666f\u5f00\u5173\u662f\u5173\u7684 \u21d2 \u56de\u9000\u300c\u5143\u7d20\u5e95\u8272\u300d"

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->why(Landroid/content/Context;Ljava/lang/String;)V

    return-object v4

    .line 98
    :cond_13
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v3

    if-eqz v3, :cond_112

    .line 99
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result v5

    if-nez v5, :cond_21

    goto/16 :goto_112

    .line 104
    :cond_21
    :try_start_21
    invoke-virtual {v3}, Ljava/io/File;->lastModified()J

    move-result-wide v5

    .line 105
    sget-object v7, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;
    :try_end_27
    .catchall {:try_start_21 .. :try_end_27} :catchall_fa

    const-string v8, "x"

    if-eqz v7, :cond_37

    :try_start_2b
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v7

    if-nez v7, :cond_37

    sget-wide v9, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRawAt:J

    cmp-long v7, v5, v9

    if-eqz v7, :cond_8d

    .line 106
    :cond_37
    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;)Landroid/graphics/Bitmap;

    move-result-object v7

    if-nez v7, :cond_47

    .line 108
    const-string p1, "\u89e3\u4e0d\u51fa\u56fe\uff08\u53ef\u80fd\u4e0d\u662f\u56fe\u7247\uff09\u21d2 \u56de\u9000\u300c\u5143\u7d20\u5e95\u8272\u300d"

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->why(Landroid/content/Context;Ljava/lang/String;)V

    return-object v4

    .line 111
    :cond_47
    sget-object v9, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;

    if-eqz v9, :cond_56

    invoke-virtual {v9}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v9

    if-nez v9, :cond_56

    sget-object v9, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;

    invoke-virtual {v9}, Landroid/graphics/Bitmap;->recycle()V

    .line 112
    :cond_56
    sput-object v7, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;

    .line 113
    sput-wide v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRawAt:J

    .line 114
    sput-object v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaled:Landroid/graphics/Bitmap;

    .line 115
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v2

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v2

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "\uff08"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 116
    invoke-virtual {v3}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/16 v6, 0x400

    div-long/2addr v2, v6

    invoke-virtual {v5, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " KB\uff09"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 115
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_8d
    if-lez p1, :cond_90

    goto :goto_96

    .line 120
    :cond_90
    sget-object p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;

    invoke-virtual {p1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result p1

    :goto_96
    div-int/lit8 p1, p1, 0x4

    const/4 v2, 0x1

    invoke-static {v2, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    if-lez p2, :cond_a0

    goto :goto_a6

    .line 121
    :cond_a0
    sget-object p2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;

    invoke-virtual {p2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result p2

    :goto_a6
    div-int/lit8 p2, p2, 0x4

    invoke-static {v2, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    .line 122
    sget-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaled:Landroid/graphics/Bitmap;

    if-eqz v3, :cond_be

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v3

    if-nez v3, :cond_be

    sget v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaledW:I

    if-ne v3, p1, :cond_be

    sget v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaledH:I

    if-eq v3, p2, :cond_f7

    .line 124
    :cond_be
    sget-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;

    invoke-static {v3, p1, p2, v2}, Landroid/graphics/Bitmap;->createScaledBitmap(Landroid/graphics/Bitmap;IIZ)Landroid/graphics/Bitmap;

    move-result-object v3

    .line 125
    sget-object v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaled:Landroid/graphics/Bitmap;

    if-eqz v5, :cond_d3

    invoke-virtual {v5}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v5

    if-nez v5, :cond_d3

    sget-object v5, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaled:Landroid/graphics/Bitmap;

    invoke-virtual {v5}, Landroid/graphics/Bitmap;->recycle()V

    .line 126
    :cond_d3
    sput-object v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaled:Landroid/graphics/Bitmap;

    .line 127
    sput p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaledW:I

    .line 128
    sput p2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaledH:I

    .line 129
    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sLogged:Z

    if-nez v3, :cond_f7

    .line 130
    sput-boolean v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sLogged:Z

    .line 131
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 134
    :cond_f7
    sget-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaled:Landroid/graphics/Bitmap;
    :try_end_f9
    .catchall {:try_start_2b .. :try_end_f9} :catchall_fa

    return-object p0

    :catchall_fa
    move-exception p1

    .line 136
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "\u8bfb\u80cc\u666f\u56fe\u5931\u8d25\uff1a"

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " \u21d2 \u56de\u9000\u300c\u5143\u7d20\u5e95\u8272\u300d"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->why(Landroid/content/Context;Ljava/lang/String;)V

    return-object v4

    .line 100
    :cond_112
    :goto_112
    const-string p1, "\u627e\u4e0d\u5230 fuckds_bg.png \u21d2 \u56de\u9000\u300c\u5143\u7d20\u5e95\u8272\u300d"

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->why(Landroid/content/Context;Ljava/lang/String;)V

    return-object v4
.end method

.method static invalidate()V
    .registers 2

    const/4 v0, 0x0

    .line 143
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sScaled:Landroid/graphics/Bitmap;

    .line 144
    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRaw:Landroid/graphics/Bitmap;

    const-wide/16 v0, 0x0

    .line 145
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassWallpaper;->sRawAt:J

    return-void
.end method

.method public static switchOn(Landroid/content/Context;)Z
    .registers 3

    const/4 v0, 0x0

    .line 67
    :try_start_1
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    if-nez p0, :cond_8

    return v0

    .line 69
    :cond_8
    const-string v1, "fuckds_bg_on"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0
    :try_end_e
    .catchall {:try_start_1 .. :try_end_e} :catchall_f

    return p0

    :catchall_f
    return v0
.end method

.method private static why(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 150
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "\u3010GmGlass\u3011\u80cc\u666f\u56fe\u5e95\u56fe\u4e0d\u53ef\u7528\uff1a"

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "glass.wallpaper.why"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
