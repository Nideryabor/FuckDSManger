.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;
.super Ljava/lang/Object;
.source "GmGlassBackdrop.java"


# static fields
.field private static final MIN_GAP_MS:J = 0x104L

.field public static final SCALE:I = 0x4

.field private static final STUCK_MS:J = 0x9c4L

.field private static sAct:Landroid/app/Activity; = null

.field private static volatile sAt:J = 0x0L

.field private static volatile sBack:Landroid/graphics/Bitmap; = null

.field private static volatile sBusy:Z = false

.field private static volatile sBusyAt:J = 0x0L

.field private static volatile sCapturing:Z = false

.field private static volatile sErrLogged:Z = false

.field private static volatile sOkLogged:Z

.field private static volatile sQueueLogged:Z

.field private static final sRCount:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sRunLogged:Z

.field private static volatile sStep2Logged:Z

.field private static volatile sStep3Logged:Z

.field private static volatile sStepLogged:Z


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 91
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sRCount:Ljava/util/HashMap;

    const-wide/16 v0, 0x0

    .line 120
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusyAt:J

    const/4 v0, 0x0

    .line 188
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sRunLogged:Z

    .line 189
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sQueueLogged:Z

    .line 190
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sStepLogged:Z

    .line 191
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sStep2Logged:Z

    .line 192
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sStep3Logged:Z

    .line 265
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sOkLogged:Z

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Z
    .registers 1

    .line 32
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sRunLogged:Z

    return v0
.end method

.method static synthetic access$002(Z)Z
    .registers 1

    .line 32
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sRunLogged:Z

    return p0
.end method

.method static synthetic access$100()Landroid/app/Activity;
    .registers 1

    .line 32
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    return-object v0
.end method

.method static synthetic access$200(Landroid/app/Activity;Landroid/view/View;)V
    .registers 2

    .line 32
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->capture(Landroid/app/Activity;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$300()Z
    .registers 1

    .line 32
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z

    return v0
.end method

.method static synthetic access$302(Z)Z
    .registers 1

    .line 32
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z

    return p0
.end method

.method static synthetic access$402(Z)Z
    .registers 1

    .line 32
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z

    return p0
.end method

.method static synthetic access$502(Z)Z
    .registers 1

    .line 32
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z

    return p0
.end method

.method static synthetic access$600()Landroid/graphics/Bitmap;
    .registers 1

    .line 32
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBack:Landroid/graphics/Bitmap;

    return-object v0
.end method

.method static synthetic access$602(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;
    .registers 1

    .line 32
    sput-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBack:Landroid/graphics/Bitmap;

    return-object p0
.end method

.method static synthetic access$700()Z
    .registers 1

    .line 32
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sOkLogged:Z

    return v0
.end method

.method static synthetic access$702(Z)Z
    .registers 1

    .line 32
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sOkLogged:Z

    return p0
.end method

.method public static bind(Landroid/app/Activity;)V
    .registers 3

    if-nez p0, :cond_3

    return-void

    .line 86
    :cond_3
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    if-eq v0, p0, :cond_b

    const-wide/16 v0, 0x0

    sput-wide v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAt:J

    .line 87
    :cond_b
    sput-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    return-void
.end method

.method private static capture(Landroid/app/Activity;Landroid/view/View;)V
    .registers 7

    .line 207
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v0

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    .line 208
    div-int/lit8 v0, v0, 0x4

    const/4 v1, 0x1

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    div-int/lit8 p1, p1, 0x4

    invoke-static {v1, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    .line 209
    sget-object v2, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v0, p1, v2}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v2

    .line 210
    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sStepLogged:Z

    if-nez v3, :cond_3a

    .line 211
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sStepLogged:Z

    .line 212
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\u3010GmGlass\u3011\u6293\u56fe\u5f00\u59cb\uff08PixelCopy\uff09"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, "x"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 215
    :cond_3a
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z

    .line 217
    :try_start_3c
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p0

    new-instance v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;

    invoke-direct {v3, v2, v0, p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$2;-><init>(Landroid/graphics/Bitmap;II)V

    new-instance p1, Landroid/os/Handler;

    .line 254
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {p1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 217
    invoke-static {p0, v2, v3, p1}, Landroid/view/PixelCopy;->request(Landroid/view/Window;Landroid/graphics/Bitmap;Landroid/view/PixelCopy$OnPixelCopyFinishedListener;Landroid/os/Handler;)V
    :try_end_51
    .catchall {:try_start_3c .. :try_end_51} :catchall_52

    return-void

    :catchall_52
    move-exception p0

    const/4 p1, 0x0

    .line 256
    sput-boolean p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z

    .line 257
    sput-boolean p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z

    .line 258
    sget-boolean p1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z

    if-nez p1, :cond_6f

    .line 259
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z

    .line 260
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u3010GmGlass\u3011PixelCopy \u8bf7\u6c42\u5931\u8d25\uff08\u5c06\u9000\u5316\u4e3a\u4e0d\u6298\u5c04\uff09\uff1a"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_6f
    return-void
.end method

.method public static capturing()Z
    .registers 1

    .line 53
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z

    return v0
.end method

.method public static drop()V
    .registers 2

    .line 268
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBack:Landroid/graphics/Bitmap;

    const/4 v1, 0x0

    .line 269
    sput-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBack:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_10

    .line 270
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-nez v1, :cond_10

    .line 272
    :try_start_d
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V
    :try_end_10
    .catchall {:try_start_d .. :try_end_10} :catchall_10

    :catchall_10
    :cond_10
    return-void
.end method

.method public static get()Landroid/graphics/Bitmap;
    .registers 3

    .line 79
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->on()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return-object v1

    .line 80
    :cond_8
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBack:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_14

    .line 81
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v2

    if-eqz v2, :cond_13

    goto :goto_14

    :cond_13
    return-object v0

    :cond_14
    :goto_14
    return-object v1
.end method

.method public static request()V
    .registers 1

    const/4 v0, 0x0

    .line 105
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->requestInternal(Z)V

    return-void
.end method

.method public static requestForce()V
    .registers 1

    const/4 v0, 0x1

    .line 115
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->requestInternal(Z)V

    return-void
.end method

.method private static requestInternal(Z)V
    .registers 11

    .line 123
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_c

    .line 124
    const-string p0, "noact"

    const-string v0, "\u6ca1\u6709 Activity\uff08\u5bbf\u4e3b\u6ca1 resume \u8fc7\uff1f\uff09"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 125
    :cond_c
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->on()Z

    move-result v1

    if-nez v1, :cond_1a

    const-string p0, "off"

    const-string v0, "\u73bb\u7483\u5f00\u5173\u662f\u5173\u7684"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 131
    :cond_1a
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    .line 132
    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z

    if-eqz v3, :cond_55

    sget-wide v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusyAt:J

    const-wide/16 v5, 0x0

    cmp-long v3, v3, v5

    if-lez v3, :cond_55

    sget-wide v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusyAt:J

    sub-long v3, v1, v3

    const-wide/16 v5, 0x9c4

    cmp-long v3, v3, v5

    if-lez v3, :cond_55

    .line 133
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "sBusy \u5361\u4e86 "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-wide v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusyAt:J

    sub-long v4, v1, v4

    invoke-virtual {v3, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v4, "ms\uff0c\u5f3a\u5236\u89e3\u5361"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "unstuck"

    invoke-static {v4, v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v3, 0x0

    .line 134
    sput-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z

    .line 135
    sput-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z

    .line 137
    :cond_55
    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z

    if-eqz v3, :cond_61

    const-string p0, "busy"

    const-string v0, "\u4e0a\u4e00\u5f20\u8fd8\u5728\u6293"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 138
    :cond_61
    sget-boolean v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z

    if-eqz v3, :cond_6d

    const-string p0, "capturing"

    const-string v0, "\u6b63\u5728\u6293\u56fe"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_6d
    const/4 v3, 0x0

    .line 142
    :try_start_6e
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v4

    if-nez v4, :cond_75

    goto :goto_7e

    :cond_75
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0
    :try_end_7d
    .catchall {:try_start_6e .. :try_end_7d} :catchall_7e

    move-object v3, v0

    :catchall_7e
    :goto_7e
    if-nez v3, :cond_88

    .line 146
    const-string p0, "nodecor"

    const-string v0, "\u62ff\u4e0d\u5230 decorView"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 147
    :cond_88
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    if-lez v0, :cond_cb

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_95

    goto :goto_cb

    .line 154
    :cond_95
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    if-nez p0, :cond_ad

    .line 155
    sget-wide v6, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAt:J

    sub-long v6, v4, v6

    const-wide/16 v8, 0x104

    cmp-long p0, v6, v8

    if-gez p0, :cond_ad

    const-string p0, "gap"

    const-string v0, "\u8ddd\u4e0a\u6b21\u4e0d\u5230 260ms"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 156
    :cond_ad
    sput-wide v4, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAt:J

    const/4 p0, 0x1

    .line 157
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z

    .line 158
    sput-wide v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusyAt:J

    .line 163
    new-instance v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$1;

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$1;-><init>(Landroid/view/View;)V

    invoke-virtual {v3, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    move-result v0

    if-nez v0, :cond_ca

    .line 182
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sQueueLogged:Z

    if-nez v0, :cond_ca

    .line 183
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sQueueLogged:Z

    .line 184
    const-string p0, "\u3010GmGlass\u3011\u6293\u56fe\u4efb\u52a1\u6392\u961f\u5931\u8d25\uff08post \u8fd4\u56de false\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_ca
    return-void

    .line 150
    :cond_cb
    :goto_cb
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "decor \u5c3a\u5bf8 "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "x"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "zero"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->rwhy(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private static rwhy(Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    .line 94
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sRCount:Ljava/util/HashMap;

    monitor-enter v0

    .line 95
    :try_start_3
    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    if-nez v1, :cond_d

    const/4 v1, 0x0

    goto :goto_11

    .line 96
    :cond_d
    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    :goto_11
    const/4 v2, 0x3

    if-lt v1, v2, :cond_16

    .line 97
    monitor-exit v0

    return-void

    :cond_16
    add-int/lit8 v1, v1, 0x1

    .line 98
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 99
    monitor-exit v0
    :try_end_20
    .catchall {:try_start_3 .. :try_end_20} :catchall_3a

    .line 100
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010GmGlass\u3011\u5e95\u56fe\u6ca1\u6293("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")\uff1a"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    :catchall_3a
    move-exception p0

    .line 99
    :try_start_3b
    monitor-exit v0
    :try_end_3c
    .catchall {:try_start_3b .. :try_end_3c} :catchall_3a

    throw p0
.end method

.method public static winH()I
    .registers 2

    const/4 v0, 0x0

    .line 70
    :try_start_1
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_17

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    if-nez v1, :cond_c

    goto :goto_17

    .line 71
    :cond_c
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v1

    goto :goto_18

    :cond_17
    :goto_17
    const/4 v1, 0x0

    :goto_18
    if-nez v1, :cond_1b

    return v0

    .line 72
    :cond_1b
    invoke-virtual {v1}, Landroid/view/View;->getHeight()I

    move-result v0
    :try_end_1f
    .catchall {:try_start_1 .. :try_end_1f} :catchall_1f

    :catchall_1f
    return v0
.end method

.method public static winW()I
    .registers 2

    const/4 v0, 0x0

    .line 60
    :try_start_1
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_17

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    if-nez v1, :cond_c

    goto :goto_17

    .line 61
    :cond_c
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;

    invoke-virtual {v1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v1

    goto :goto_18

    :cond_17
    :goto_17
    const/4 v1, 0x0

    :goto_18
    if-nez v1, :cond_1b

    return v0

    .line 62
    :cond_1b
    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v0
    :try_end_1f
    .catchall {:try_start_1 .. :try_end_1f} :catchall_1f

    :catchall_1f
    return v0
.end method
