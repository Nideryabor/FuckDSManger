.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBubble;
.super Ljava/lang/Object;
.source "GmBubble.java"


# static fields
.field public static sAblateCur:Ljava/lang/String;

.field public static sAblateHits:I

.field public static sAblateIdx:I

.field public static sAblateLast:Ljava/lang/String;

.field public static sAblateList:Ljava/lang/String;

.field public static sAlpha:I

.field public static sBmp:Landroid/graphics/Bitmap;

.field public static sBrush:Ljava/lang/Object;

.field public static sCellAll:I

.field public static sCntCell:I

.field public static sCntInU:I

.field public static sCntInV:I

.field public static sCntInj:I

.field public static sCntU:I

.field public static sCntV:I

.field public static sColor:I

.field public static sDepth:I

.field public static sExtraColor:J

.field public static sHit:Z

.field public static sHostShape:Ljava/lang/Object;

.field public static sImg:Z

.field public static sImgName:Ljava/lang/String;

.field private static sOn:Z

.field public static sPageCnt:I

.field public static sPageColor:J

.field public static sPageDepth:I

.field public static sPgLogCnt:I

.field public static sPgWhy:I

.field private static sPicking:Z

.field public static sProbeArm:Z

.field public static sProbeLog:Ljava/lang/String;

.field public static sRadius:I

.field private static sRead:Z

.field private static sReadCfg:Z

.field public static sSkipCount:I

.field public static sSkipList:Ljava/lang/String;

.field public static sSurfaceColor:J

.field public static sTouchMs:J

.field public static sTouchOn:Z

.field public static sUBub:I

.field public static sUCntCell:I

.field public static sUColor:I

.field public static sUDepth:I

.field public static sUImg:Z

.field public static sUOn:Z

.field private static sUPick:Z

.field public static sURadius:I

.field private static sURead:Z

.field public static sZoom:I


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const-string v0, "fuckds_bubble.png"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImgName:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static alpha()I
    .registers 1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAlpha:I

    return v0
.end method

.method public static alphaF()F
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAlpha:I

    int-to-float v0, v0

    const/high16 v1, 0x42c80000    # 100.0f

    div-float/2addr v0, v1

    return v0
.end method

.method public static applyColor(Landroid/content/Context;I)V
    .registers 4

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->sUser:Z

    if-eqz v1, :cond_11

    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setUColor(Landroid/content/Context;I)V

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setUImg(Landroid/content/Context;Z)V

    const-string v0, "\u7528\u6237\u6c14\u6ce1\u989c\u8272\u5df2\u66f4\u65b0\uff08\u5217\u8868\u5212\u4e00\u4e0b\u5373\u53ef\u770b\u5230\uff09"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_11
    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setColor(Landroid/content/Context;I)V

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setImg(Landroid/content/Context;Z)V

    const-string v0, "AI \u6c14\u6ce1\u989c\u8272\u5df2\u66f4\u65b0\uff08\u5217\u8868\u5212\u4e00\u4e0b\u5373\u53ef\u770b\u5230\uff09"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static applyOn(Landroid/content/Context;Z)V
    .registers 4

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->sUser:Z

    if-eqz v1, :cond_12

    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setUOn(Landroid/content/Context;Z)V

    if-eqz p1, :cond_c

    const-string v0, "\u7528\u6237\u6c14\u6ce1\uff1a\u5df2\u5f00\u542f"

    goto :goto_e

    :cond_c
    const-string v0, "\u7528\u6237\u6c14\u6ce1\uff1a\u5df2\u5173\u95ed"

    :goto_e
    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_12
    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setOn(Landroid/content/Context;Z)V

    if-eqz p1, :cond_1a

    const-string v0, "AI \u6c14\u6ce1\uff1a\u5df2\u5f00\u542f"

    goto :goto_1c

    :cond_1a
    const-string v0, "AI \u6c14\u6ce1\uff1a\u5df2\u5173\u95ed"

    :goto_1c
    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static applyRadius(Landroid/content/Context;I)V
    .registers 5

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->sUser:Z

    if-eqz v1, :cond_2a

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->uRadius()I

    move-result v0

    add-int/2addr p1, v0

    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setURadius(Landroid/content/Context;I)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u7528\u6237\u6c14\u6ce1\u5706\u89d2 = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->uRadius()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " dp\uff08\u5217\u8868\u5212\u4e00\u4e0b\u5373\u53ef\u770b\u5230\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_2a
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->radius()I

    move-result v0

    add-int/2addr p1, v0

    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setRadius(Landroid/content/Context;I)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "AI \u6c14\u6ce1\u5706\u89d2 = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->radius()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " dp\uff08\u5217\u8868\u5212\u4e00\u4e0b\u5373\u53ef\u770b\u5230\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static armPick()V
    .registers 2

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->sUser:Z

    if-eqz v0, :cond_8

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->pickU()V

    return-void

    :cond_8
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->pick()V

    return-void
.end method

.method public static brush(Ljava/lang/ClassLoader;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    return-object v0

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sBrush:Ljava/lang/Object;

    if-eqz v0, :cond_7

    return-object v0

    :cond_7
    const/4 v0, 0x0

    :try_start_8
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    const-wide v2, -0x74a30a00000000L    # -2.401880300011147E306

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    const-wide v2, -0xdd2c1200000000L

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    const-string v4, "c73"

    const/4 v5, 0x0

    invoke-static {v4, v5, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v4

    const/4 v5, 0x2

    new-array v5, v5, [Ljava/lang/Class;

    const/4 v6, 0x0

    const-class v7, Ljava/util/List;

    aput-object v7, v5, v6

    const/4 v6, 0x1

    aput-object v7, v5, v6

    invoke-virtual {v4, v5}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v4

    const/4 v5, 0x2

    new-array v5, v5, [Ljava/lang/Object;

    const/4 v6, 0x0

    aput-object v1, v5, v6

    const/4 v6, 0x1

    const/4 v7, 0x0

    aput-object v7, v5, v6

    invoke-virtual {v4, v5}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sBrush:Ljava/lang/Object;

    const-string v1, "[\u6c14\u6ce1] \u6e10\u53d8 Brush \u6784\u9020\u6210\u529f\uff08\u7d2b #8B5CF6 \u2192 \u9752 #22D3EE\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_50
    .catchall {:try_start_8 .. :try_end_50} :catchall_51

    goto :goto_57

    :catchall_51
    move-exception v1

    const-string v2, "[\u6c14\u6ce1] \u6e10\u53d8 Brush \u6784\u9020\u5931\u8d25\uff08\u6ce8\u5165\u5c06\u9000\u56de\u7eaf\u8272\uff09"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_57
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sBrush:Ljava/lang/Object;

    return-object v0
.end method

.method public static color()I
    .registers 1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sColor:I

    return v0
.end method

.method public static colorLong()J
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUDepth:I

    if-lez v0, :cond_a

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sColor:I

    goto :goto_c

    :cond_a
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUColor:I

    :goto_c
    int-to-long v0, v0

    const/16 v2, 0x20

    shl-long/2addr v0, v2

    return-wide v0
.end method

.method public static finishPick(Landroid/content/Context;Z)V
    .registers 4

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUPick:Z

    const/4 v1, 0x0

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUPick:Z

    if-eqz v0, :cond_19

    if-eqz p1, :cond_13

    const/4 v0, 0x1

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setUImg(Landroid/content/Context;Z)V

    const-string v0, "\u7528\u6237\u6c14\u6ce1\u56fe\u5df2\u4fdd\u5b58\uff08\u5217\u8868\u5212\u4e00\u4e0b\u5373\u53ef\u770b\u5230\uff09"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_13
    const-string v0, "\u7528\u6237\u6c14\u6ce1\u56fe\u4fdd\u5b58\u5931\u8d25"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_19
    if-eqz p1, :cond_25

    const/4 v0, 0x1

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setImg(Landroid/content/Context;Z)V

    const-string v0, "\u6c14\u6ce1\u56fe\u5df2\u4fdd\u5b58\uff08\u5217\u8868\u5212\u4e00\u4e0b\u5373\u53ef\u770b\u5230\uff09"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_25
    const-string v0, "\u6c14\u6ce1\u56fe\u4fdd\u5b58\u5931\u8d25"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static hostShape(Ljava/lang/ClassLoader;)Ljava/lang/Object;
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sHostShape:Ljava/lang/Object;

    if-eqz v0, :cond_19

    :try_start_4
    const-string v0, "zc"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    const-string v1, "o"

    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->getStaticObjectField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sHostShape:Ljava/lang/Object;
    :try_end_12
    .catchall {:try_start_4 .. :try_end_12} :catchall_13

    goto :goto_19

    :catchall_13
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u53d6\u5bbf\u4e3b\u6c14\u6ce1\u5f62\u72b6 zc.o \u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_19
    :goto_19
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sHostShape:Ljava/lang/Object;

    return-object v0
.end method

.method public static imgBrush(Ljava/lang/ClassLoader;)Ljava/lang/Object;
    .registers 8

    const/4 v0, 0x0

    :try_start_1
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    new-instance v1, Ljava/io/File;

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImgName:Ljava/lang/String;

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_54

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/16 v4, 0x0

    cmp-long v0, v2, v4

    if-eqz v0, :cond_5b

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;)Landroid/graphics/Bitmap;

    move-result-object v0

    if-nez v0, :cond_62

    const-string v1, "[\u6c14\u6ce1] \u6c14\u6ce1\u56fe\u4e0d\u53ef\u7528 \u21d2 \u6539\u7528\u300c\u4fee\u6539\u80cc\u666f\u300d\u90a3\u5f20 fuckds_bg.png\uff08\u73b0\u6210\u53ef\u7528\u901a\u9053\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    new-instance v2, Ljava/io/File;

    const-string v3, "fuckds_bg.png"

    invoke-direct {v2, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;)Landroid/graphics/Bitmap;

    move-result-object v0

    if-nez v0, :cond_62

    const-string v1, "[\u6c14\u6ce1] \u6c14\u6ce1\u56fe\u4e0e\u80cc\u666f\u56fe\u90fd\u6ca1\u6709\u53ef\u7528\u56fe\u7247 \u21d2 \u9000\u56de\u7eaf\u8272"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "[\u6c14\u6ce1] \u89e3\u7801\u5931\u8d25\u4f46\u6587\u4ef6\u975e\u7a7a\uff1a\u4e0d\u662f\u53ef\u8bc6\u522b\u7684\u56fe\u7247\u683c\u5f0f"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    return-object v0

    :cond_54
    const-string v1, "[\u6c14\u6ce1] \u6587\u4ef6\u4e0d\u5b58\u5728\uff1afilesDir/fuckds_bubble.png\uff08saveImage \u6ca1\u5199\u5230\u8fd9\u91cc\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    return-object v0

    :cond_5b
    const-string v1, "[\u6c14\u6ce1] \u6587\u4ef6\u5b58\u5728\u4f46\u957f\u5ea6\u4e3a 0\uff08\u62f7\u8d1d\u6ca1\u5199\u8fdb\u5185\u5bb9\uff0csaveImage \u5224\u636e\u592a\u677e\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    return-object v0

    :cond_62
    new-instance v1, Lcom/varuns2002/disable_flag_secure/gm/GmBmpShader;

    sget-object v2, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct {v1, v0, v2, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBmpShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V

    iput-object v0, v1, Lcom/varuns2002/disable_flag_secure/gm/GmBmpShader;->bmp:Landroid/graphics/Bitmap;

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sBmp:Landroid/graphics/Bitmap;

    const-string v0, "tn0"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Class;

    const/4 v3, 0x0

    const-class v4, Landroid/graphics/Shader;

    aput-object v4, v2, v3

    invoke-virtual {v0, v2}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v0

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object v1, v2, v3

    invoke-virtual {v0, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_89
    .catchall {:try_start_1 .. :try_end_89} :catchall_8a

    return-object v0

    :catchall_8a
    move-exception v1

    const-string v2, "[\u6c14\u6ce1] \u56fe\u7247 Brush \u6784\u9020\u5931\u8d25"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method public static imgOn()Z
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUDepth:I

    if-lez v0, :cond_a

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImg:Z

    return v0

    :cond_a
    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUImg:Z

    return v0
.end method

.method public static inScope()Z
    .registers 2

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sDepth:I

    if-gtz v0, :cond_9

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->on()Z

    move-result v0

    return v0

    :cond_9
    const/4 v0, 0x0

    return v0
.end method

.method public static isPicking()Z
    .registers 1

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPicking:Z

    return v0
.end method

.method public static load()V
    .registers 6

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    if-nez v0, :cond_86

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    :try_start_7
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "fuckds_bubble_color"

    const v2, -0xd5dec0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sColor:I

    const-string v1, "fuckds_bubble_radius"

    const/16 v2, 0x10

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sRadius:I

    const-string v1, "fuckds_bubble_img"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImg:Z

    const-string v1, "fuckds_bubble_alpha"

    const/16 v2, 0x64

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAlpha:I

    const-string v1, "fuckds_bubble_maxz"

    const/16 v2, 0xc8

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sZoom:I

    const-string v1, "fuckds_ububble_color"

    const v2, -0xd5dec0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUColor:I

    const-string v1, "fuckds_ububble_radius"

    const/16 v2, 0x10

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURadius:I

    const-string v1, "fuckds_ububble_img"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUImg:Z
    :try_end_5f
    .catchall {:try_start_7 .. :try_end_5f} :catchall_60

    goto :goto_86

    :catchall_60
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u8bfb\u989c\u8272/\u5706\u89d2\u914d\u7f6e\u5931\u8d25\uff08\u7528\u9ed8\u8ba4\u503c\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const v0, -0xd5dec0

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sColor:I

    const/16 v0, 0x10

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sRadius:I

    const/4 v0, 0x0

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImg:Z

    const/16 v0, 0x64

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAlpha:I

    const/16 v0, 0xc8

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sZoom:I

    const v0, -0xd5dec0

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUColor:I

    const/16 v0, 0x10

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURadius:I

    const/4 v0, 0x0

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUImg:Z

    :cond_86
    :goto_86
    return-void
.end method

.method public static on()Z
    .registers 4

    const/4 v3, 0x1

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sRead:Z

    if-nez v0, :cond_1f

    sput-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sRead:Z

    move v0, v3

    :try_start_8
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "fuckds_bubble_on"

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0
    :try_end_16
    .catchall {:try_start_8 .. :try_end_16} :catchall_17

    goto :goto_1d

    :catchall_17
    move-exception v1

    const-string v2, "[\u6c14\u6ce1] \u8bfb fuckds_bubble_on \u5931\u8d25\uff0c\u6309\u9ed8\u8ba4\uff08\u5f00\uff09"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1d
    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sOn:Z

    :cond_1f
    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sOn:Z

    return v0
.end method

.method public static pick()V
    .registers 1

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPicking:Z

    const/4 v0, 0x0

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUPick:Z

    return-void
.end method

.method public static pickU()V
    .registers 1

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPicking:Z

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUPick:Z

    return-void
.end method

.method public static radius()I
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUDepth:I

    if-lez v0, :cond_e

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUBub:I

    if-lez v0, :cond_e

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sRadius:I

    return v0

    :cond_e
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURadius:I

    return v0
.end method

.method public static saveImage(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 10

    const/4 v0, 0x0

    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    if-eqz v1, :cond_a8

    new-instance v3, Ljava/io/BufferedInputStream;

    invoke-direct {v3, v1}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    move-object v1, v3

    new-instance v2, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    sget-object v4, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImgName:Ljava/lang/String;

    invoke-direct {v2, v3, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    invoke-static {v1}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;

    move-result-object v3

    if-nez v3, :cond_8e

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    const-string v4, "[\u6c14\u6ce1] openInputStream \u8bfb\u4e0d\u51fa\u56fe \u21d2 \u6539\u7528 loadThumbnail\uff08Photo Picker \u515c\u5e95\uff09"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    const/16 v5, 0x400

    new-instance v6, Landroid/util/Size;

    invoke-direct {v6, v5, v5}, Landroid/util/Size;-><init>(II)V

    const/4 v7, 0x0

    invoke-virtual {v4, p1, v6, v7}, Landroid/content/ContentResolver;->loadThumbnail(Landroid/net/Uri;Landroid/util/Size;Landroid/os/CancellationSignal;)Landroid/graphics/Bitmap;

    move-result-object v3

    if-nez v3, :cond_8e

    const-string v4, "[\u6c14\u6ce1] loadThumbnail \u4e5f\u6ca1\u62ff\u5230 \u21d2 \u6539\u7528 ImageDecoder\uff08\u73b0\u4ee3\u89e3\u7801 API\uff0c\u4e13\u6cbb provider URI\uff09"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    invoke-static {v4, p1}, Landroid/graphics/ImageDecoder;->createSource(Landroid/content/ContentResolver;Landroid/net/Uri;)Landroid/graphics/ImageDecoder$Source;

    move-result-object v5

    invoke-static {v5}, Landroid/graphics/ImageDecoder;->decodeBitmap(Landroid/graphics/ImageDecoder$Source;)Landroid/graphics/Bitmap;

    move-result-object v3

    if-nez v3, :cond_8e

    const-string v4, "[\u6c14\u6ce1] ImageDecoder \u4e5f\u5931\u8d25 \u21d2 \u6539\u7528 MediaStore \u76f4\u8bfb\uff08\u4ece picker URI \u63d0 id\uff0c\u4e0d\u9700\u4e34\u65f6\u6388\u6743\uff09"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-virtual {p1}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;

    move-result-object v5

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "content://media/external/images/media/"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    const/16 v6, 0x400

    new-instance v7, Landroid/util/Size;

    invoke-direct {v7, v6, v6}, Landroid/util/Size;-><init>(II)V

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    const/4 v6, 0x0

    invoke-virtual {v4, v5, v7, v6}, Landroid/content/ContentResolver;->loadThumbnail(Landroid/net/Uri;Landroid/util/Size;Landroid/os/CancellationSignal;)Landroid/graphics/Bitmap;

    move-result-object v3

    if-nez v3, :cond_8e

    const-string v4, "[\u6c14\u6ce1] \u8fde MediaStore \u7f29\u7565\u56fe\u90fd\u62ff\u4e0d\u5230 \u21d2 \u786e\u5b9e\u662f\u8fd9\u5f20\u56fe\u7684\u7f16\u7801\u4e0d\u53ef\u89e3"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_ad

    const-string v4, "[\u6c14\u6ce1] MediaStore \u76f4\u8bfb\u4e5f\u5931\u8d25\uff08id \u53ef\u80fd\u4e0d\u5728 images \u96c6\u5408\u91cc\uff09"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_ad

    :cond_8e
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    sget-object v5, Landroid/graphics/Bitmap$CompressFormat;->PNG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v6, 0x64

    invoke-virtual {v3, v5, v6, v4}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->flush()V

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->recycle()V

    const/4 v0, 0x1

    goto :goto_ad

    :cond_a8
    const-string v2, "[\u6c14\u6ce1] \u6253\u5f00\u6240\u9009\u56fe\u7247\u5931\u8d25\uff08Uri \u6743\u9650\uff1f\uff09"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_ad
    .catchall {:try_start_1 .. :try_end_ad} :catchall_ae

    :goto_ad
    goto :goto_b5

    :catchall_ae
    move-exception v1

    const-string v2, "[\u6c14\u6ce1] \u4fdd\u5b58\u6c14\u6ce1\u56fe\u5931\u8d25"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    :goto_b5
    return v0
.end method

.method public static setAlpha(Landroid/content/Context;I)V
    .registers 6

    :try_start_0
    const/16 v0, 0xa

    if-ge p1, v0, :cond_6

    const/16 p1, 0xa

    :cond_6
    const/16 v0, 0x64

    if-le p1, v0, :cond_c

    const/16 p1, 0x64

    :cond_c
    sput p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sAlpha:I

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "fuckds_bubble_alpha"

    const-string v2, "i"

    invoke-static {p0, v1, v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1c
    .catchall {:try_start_0 .. :try_end_1c} :catchall_1d

    return-void

    :catchall_1d
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u900f\u660e\u5ea6\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setColor(Landroid/content/Context;I)V
    .registers 6

    :try_start_0
    sput p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sColor:I

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "fuckds_bubble_color"

    const-string v2, "i"

    invoke-static {p0, v1, v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_10
    .catchall {:try_start_0 .. :try_end_10} :catchall_11

    return-void

    :catchall_11
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u989c\u8272\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setImg(Landroid/content/Context;Z)V
    .registers 6

    :try_start_0
    sput-boolean p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImg:Z

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    const/4 v0, 0x0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sBrush:Ljava/lang/Object;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "fuckds_bubble_img"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_1a

    return-void

    :catchall_1a
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u56fe\u7247\u5f00\u5173\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setImgOn(Landroid/content/Context;Z)V
    .registers 4

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->sUser:Z

    if-eqz v1, :cond_8

    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setUImg(Landroid/content/Context;Z)V

    return-void

    :cond_8
    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setImg(Landroid/content/Context;Z)V

    return-void
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 5

    :try_start_0
    sput-boolean p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sOn:Z

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sRead:Z

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "fuckds_bubble_on"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_17

    return-void

    :catchall_17
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199 fuckds_bubble_on \u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setRadius(Landroid/content/Context;I)V
    .registers 6

    :try_start_0
    if-gez p1, :cond_3

    const/4 p1, 0x0

    :cond_3
    const/16 v0, 0x30

    if-le p1, v0, :cond_9

    const/16 p1, 0x30

    :cond_9
    sput p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sRadius:I

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "fuckds_bubble_radius"

    const-string v2, "i"

    invoke-static {p0, v1, v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_1a

    return-void

    :catchall_1a
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u5706\u89d2\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setUColor(Landroid/content/Context;I)V
    .registers 6

    :try_start_0
    sput p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUColor:I

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "fuckds_ububble_color"

    const-string v2, "i"

    invoke-static {p0, v1, v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_10
    .catchall {:try_start_0 .. :try_end_10} :catchall_11

    return-void

    :catchall_11
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u7528\u6237\u6c14\u6ce1\u989c\u8272\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setUImg(Landroid/content/Context;Z)V
    .registers 6

    :try_start_0
    sput-boolean p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUImg:Z

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "fuckds_ububble_img"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_17

    return-void

    :catchall_17
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u7528\u6237\u6c14\u6ce1\u56fe\u5f00\u5173\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setUOn(Landroid/content/Context;Z)V
    .registers 5

    :try_start_0
    sput-boolean p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUOn:Z

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURead:Z

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "fuckds_ububble_on"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_17

    return-void

    :catchall_17
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199 fuckds_ububble_on \u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setURadius(Landroid/content/Context;I)V
    .registers 6

    :try_start_0
    if-gez p1, :cond_3

    const/4 p1, 0x0

    :cond_3
    const/16 v0, 0x30

    if-le p1, v0, :cond_9

    const/16 p1, 0x30

    :cond_9
    sput p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURadius:I

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "fuckds_ububble_radius"

    const-string v2, "i"

    invoke-static {p0, v1, v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_1a

    return-void

    :catchall_1a
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u7528\u6237\u6c14\u6ce1\u5706\u89d2\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setZoom(Landroid/content/Context;I)V
    .registers 6

    :try_start_0
    const/16 v0, 0x64

    if-ge p1, v0, :cond_6

    const/16 p1, 0x64

    :cond_6
    const/16 v0, 0x258

    if-le p1, v0, :cond_c

    const/16 p1, 0x258

    :cond_c
    sput p1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sZoom:I

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sReadCfg:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "fuckds_bubble_maxz"

    const-string v2, "i"

    invoke-static {p0, v1, v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1c
    .catchall {:try_start_0 .. :try_end_1c} :catchall_1d

    return-void

    :catchall_1d
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u5199\u6700\u5927\u653e\u5927\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static shape(Ljava/lang/ClassLoader;)Ljava/lang/Object;
    .registers 7

    const/4 v0, 0x0

    :try_start_1
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-nez v1, :cond_f

    const-string v1, "[\u6c14\u6ce1] \u62ff\u4e0d\u5230 Context"

    const-string v2, "\u8df3\u8fc7\u81ea\u9020 Shape\uff08\u4e0b\u4e00\u5019\u9009 zc.o\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_36

    :cond_f
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->radius()I

    move-result v2

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v1

    int-to-float v1, v1

    invoke-static {v1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v1

    const-string v2, "tt7"

    invoke-static {v2, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object v1, v3, v4

    const-string v4, "b"

    invoke-static {v2, v4, v3}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_2e
    .catchall {:try_start_1 .. :try_end_2e} :catchall_2f

    goto :goto_36

    :catchall_2f
    move-exception v1

    const-string v2, "[\u6c14\u6ce1] \u81ea\u9020\u5706\u89d2 Shape \u5931\u8d25\uff08\u4e0b\u4e00\u5019\u9009 zc.o\uff09"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    :goto_36
    if-nez v0, :cond_47

    :try_start_38
    const-string v1, "zc"

    invoke-static {v1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "o"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->getStaticObjectField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0
    :try_end_44
    .catchall {:try_start_38 .. :try_end_44} :catchall_45

    goto :goto_47

    :catchall_45
    move-exception v1

    const/4 v0, 0x0

    :cond_47
    :goto_47
    return-object v0
.end method

.method public static takePicking()Z
    .registers 2

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPicking:Z

    const/4 v1, 0x0

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sPicking:Z

    return v0
.end method

.method public static uColor()I
    .registers 1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUColor:I

    return v0
.end method

.method public static uColorLong()J
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUColor:I

    int-to-long v0, v0

    const/16 v2, 0x20

    shl-long/2addr v0, v2

    return-wide v0
.end method

.method public static uImgOn()Z
    .registers 1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUImg:Z

    return v0
.end method

.method public static uOn()Z
    .registers 4

    const/4 v3, 0x1

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURead:Z

    if-nez v0, :cond_1f

    sput-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURead:Z

    move v0, v3

    :try_start_8
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "fuckds_ububble_on"

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0
    :try_end_16
    .catchall {:try_start_8 .. :try_end_16} :catchall_17

    goto :goto_1d

    :catchall_17
    move-exception v1

    const-string v2, "[\u6c14\u6ce1] \u8bfb fuckds_ububble_on \u5931\u8d25\uff0c\u6309\u9ed8\u8ba4\uff08\u5f00\uff09"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1d
    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUOn:Z

    :cond_1f
    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUOn:Z

    return v0
.end method

.method public static uRadius()I
    .registers 1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sURadius:I

    return v0
.end method

.method public static ubMod(Ljava/lang/ClassLoader;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 9

    const/4 v6, 0x0

    :try_start_1
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->shape(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_65

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->uImgOn()Z

    move-result v1

    if-eqz v1, :cond_3e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->useUImgName()V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->imgBrush(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_3e

    const/4 v2, 0x4

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p1, v2, v3

    const/4 v3, 0x1

    aput-object v1, v2, v3

    const/4 v3, 0x2

    aput-object v0, v2, v3

    const/4 v3, 0x3

    const/4 v4, 0x0

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    const-string v3, "uia"

    invoke-static {v3, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3

    const-string v4, "u"

    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    const-string v3, "[\u6c14\u6ce1] \u7528\u6237\u6c14\u6ce1"

    const-string v4, "\u56fe\u7247\u5e95\u5df2\u5b9a\u70b9\u91cd\u5199\uff08ls9.f \u4f5c\u7528\u57df\u5185\uff09"

    invoke-static {v3, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_65

    :cond_3e
    const/4 v2, 0x3

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p1, v2, v3

    const/4 v3, 0x1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->uColorLong()J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x2

    aput-object v0, v2, v3

    const-string v3, "uia"

    invoke-static {v3, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3

    const-string v4, "v"

    invoke-static {v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    const-string v3, "[\u6c14\u6ce1] \u7528\u6237\u6c14\u6ce1"

    const-string v4, "\u989c\u8272/\u5706\u89d2\u5df2\u5b9a\u70b9\u91cd\u5199\uff08ls9.f \u4f5c\u7528\u57df\u5185\uff09"

    invoke-static {v3, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_65
    .catchall {:try_start_1 .. :try_end_65} :catchall_66

    :cond_65
    :goto_65
    return-object v6

    :catchall_66
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u7528\u6237\u6c14\u6ce1\u91cd\u5199\u5931\u8d25\uff08\u5df2\u541e\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method public static useImgName()V
    .registers 2

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUPick:Z

    if-eqz v0, :cond_7

    const-string v0, "fuckds_ububble.png"

    goto :goto_9

    :cond_7
    const-string v0, "fuckds_bubble.png"

    :goto_9
    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImgName:Ljava/lang/String;

    return-void
.end method

.method public static useUImgName()V
    .registers 1

    const-string v0, "fuckds_ububble.png"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImgName:Ljava/lang/String;

    return-void
.end method

.method public static wrap(Ljava/lang/ClassLoader;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 8

    :try_start_0
    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sUDepth:I

    if-lez v0, :cond_7

    const-string v0, "fuckds_bubble.png"

    goto :goto_9

    :cond_7
    const-string v0, "fuckds_ububble.png"

    :goto_9
    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sImgName:Ljava/lang/String;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->shape(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_19

    const-string v1, "[\u6c14\u6ce1] \u6ca1\u53d6\u5230 Shape"

    const-string v2, "\u653e\u5f03\u6ce8\u5165\uff08shape \u4e3a\u7a7a\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-object p1

    :cond_19
    move-object v4, v0

    invoke-static {p0, p1}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->wrapImg(Ljava/lang/ClassLoader;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_21

    return-object v0

    :cond_21
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->colorLong()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const/4 v2, 0x3

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p1, v2, v3

    const/4 v3, 0x1

    aput-object v1, v2, v3

    const/4 v3, 0x2

    aput-object v4, v2, v3

    const-string v0, "uia"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    const-string v1, "v"

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_41
    .catchall {:try_start_0 .. :try_end_41} :catchall_4b

    if-eqz v0, :cond_4a

    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntInj:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sCntInj:I

    return-object v0

    :cond_4a
    return-object p1

    :catchall_4b
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u6ce8\u5165\u5e95\u677f\u629b\u5f02\u5e38\uff08\u4e0d\u5f71\u54cd\u5bbf\u4e3b\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-object p1
.end method

.method public static wrapImg(Ljava/lang/ClassLoader;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    :try_start_1
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->imgOn()Z

    move-result v1

    if-eqz v1, :cond_3a

    const-string v1, "[\u6c14\u6ce1] \u56fe\u7247\u7248\u6ce8\u5165\u5df2\u542f\u7528"

    const-string v2, "\u5f00\u59cb\u6784\u5efa\u56fe\u7247 Brush\uff08\u82e5\u8fd9\u884c\u6ca1\u51fa\u73b0 = imgOn \u4e3a false\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->shape(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_3a

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->imgBrush(Ljava/lang/ClassLoader;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_3a

    const/4 v4, 0x4

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    aput-object p1, v4, v5

    const/4 v5, 0x1

    aput-object v3, v4, v5

    const/4 v5, 0x2

    aput-object v2, v4, v5

    const/4 v5, 0x3

    const/4 v6, 0x0

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v4, v5

    const-string v5, "uia"

    invoke-static {v5, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v5

    const-string v6, "u"

    invoke-static {v5, v6, v4}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_3a
    .catchall {:try_start_1 .. :try_end_3a} :catchall_3b

    :cond_3a
    return-object v0

    :catchall_3b
    move-exception v1

    const-string v2, "[\u6c14\u6ce1] \u56fe\u7247\u7248\u6ce8\u5165\u5931\u8d25\uff08\u9000\u56de\u7eaf\u8272\uff09"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method public static zoom()I
    .registers 1

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sZoom:I

    return v0
.end method

.method public static zoomF()F
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->load()V

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sZoom:I

    int-to-float v0, v0

    const/high16 v1, 0x42c80000    # 100.0f

    div-float/2addr v0, v1

    return v0
.end method
