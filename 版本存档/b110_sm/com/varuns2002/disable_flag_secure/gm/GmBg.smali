.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBg;
.super Ljava/lang/Object;
.source "GmBg.java"


# static fields
.field static final K_ALPHA:Ljava/lang/String;

.field static final K_CAM:Ljava/lang/String;

.field static final K_DIR:Ljava/lang/String;

.field static final K_GRAD:Ljava/lang/String;

.field static final K_MODE:Ljava/lang/String;

.field static final K_ON:Ljava/lang/String;

.field static final K_POS:Ljava/lang/String;

.field static final K_ROT:Ljava/lang/String;

.field static sPicking:Z

.field static sSig:I

.field static sView:Landroid/view/View;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const-string v0, "fuckds_bg_on"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ON:Ljava/lang/String;

    const-string v0, "fuckds_bg_mode"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_MODE:Ljava/lang/String;

    const-string v0, "fuckds_bg_alpha"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ALPHA:Ljava/lang/String;

    const-string v0, "fuckds_bg_grad"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_GRAD:Ljava/lang/String;

    const-string v0, "fuckds_bg_pos"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_POS:Ljava/lang/String;

    const-string v0, "fuckds_bg_dir"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_DIR:Ljava/lang/String;

    const-string v0, "fuckds_bg_cam"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_CAM:Ljava/lang/String;

    const-string v0, "fuckds_bg_rot"

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ROT:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static alpha(Landroid/content/Context;)I
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ALPHA:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_11

    const/16 v0, 0x19

    return v0

    :cond_11
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method public static bitmap(Landroid/content/Context;)Landroid/graphics/Bitmap;
    .registers 5

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    :try_start_9
    invoke-static {v0}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;)Landroid/graphics/Bitmap;

    move-result-object v1
    :try_end_d
    .catchall {:try_start_9 .. :try_end_d} :catchall_e

    goto :goto_f

    :catchall_e
    move-exception v2

    :goto_f
    return-object v1
.end method

.method public static cam(Landroid/content/Context;)I
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_CAM:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_10

    const/4 v0, 0x0

    return v0

    :cond_10
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method private static clearBg(Landroid/app/Activity;)V
    .registers 6

    :try_start_0
    const-string v1, "[\u80cc\u666f] ensure \u8d70\u5230\u6302\u8f7d\u540e\uff1a\u5f00\u59cb\u6e05 View \u5c42\u80cc\u666f"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-nez v0, :cond_1c

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    instance-of v1, v0, Landroid/view/ViewGroup;

    if-eqz v1, :cond_1c

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->clearBgGroup(Landroid/view/ViewGroup;)V

    :cond_1c
    return-void
    :try_end_1d
    .catchall {:try_start_0 .. :try_end_1d} :catchall_1d

    :catchall_1d
    move-exception v0

    return-void
.end method

.method private static clearBgGroup(Landroid/view/ViewGroup;)V
    .registers 6

    :try_start_0
    const/4 v0, 0x0

    :goto_1
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_1d

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :cond_1a

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    instance-of v3, v2, Landroid/view/ViewGroup;

    if-eqz v3, :cond_1a

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->clearBgGroup(Landroid/view/ViewGroup;)V

    :cond_1a
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :cond_1d
    return-void
    :try_end_1e
    .catchall {:try_start_0 .. :try_end_1e} :catchall_1e

    :catchall_1e
    move-exception v0

    return-void
.end method

.method public static crop(Landroid/content/Context;)I
    .registers 5

    const-string v0, "fuckds_bg_crop"

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_11

    const/16 v0, 0x64

    return v0

    :cond_11
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method public static dir(Landroid/content/Context;)I
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_DIR:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_10

    const/4 v0, 0x0

    return v0

    :cond_10
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method public static dirMul(Landroid/content/Context;)Z
    .registers 4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->dir(Landroid/content/Context;)I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_9

    const/4 v0, 0x1

    return v0

    :cond_9
    const/4 v1, 0x2

    if-ne v0, v1, :cond_e

    const/4 v0, 0x0

    return v0

    :cond_e
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->isNight(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_16

    const/4 v0, 0x1

    return v0

    :cond_16
    const/4 v0, 0x0

    return v0
.end method

.method public static ensure(Landroid/content/Context;)V
    .registers 12

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_29

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sView:Landroid/view/View;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->isOn(Landroid/content/Context;)Z

    move-result v1

    if-nez v1, :cond_2a

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->stop()V

    sget-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    invoke-static {p0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setBlend(Landroid/content/Context;Landroid/app/Activity;)V

    if-eqz v2, :cond_29

    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v1, v0, Landroid/view/ViewGroup;

    if-eqz v1, :cond_23

    check-cast v0, Landroid/view/ViewGroup;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_23
    const/4 v0, 0x0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sView:Landroid/view/View;

    const/4 v0, -0x1

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sSig:I

    :cond_29
    return-void

    :cond_2a
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->dir(Landroid/content/Context;)I

    move-result v3

    const v4, 0x5f5e100

    mul-int/2addr v3, v4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v4

    const v5, 0x989680

    mul-int/2addr v4, v5

    add-int/2addr v3, v4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->mode(Landroid/content/Context;)I

    move-result v4

    const v5, 0xf4240

    mul-int/2addr v4, v5

    add-int/2addr v3, v4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->cam(Landroid/content/Context;)I

    move-result v4

    const v5, 0x186a0

    mul-int/2addr v4, v5

    add-int/2addr v3, v4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->grad(Landroid/content/Context;)I

    move-result v4

    const/16 v5, 0x2710

    mul-int/2addr v4, v5

    add-int/2addr v3, v4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->alpha(Landroid/content/Context;)I

    move-result v4

    const/16 v5, 0xa

    mul-int/2addr v4, v5

    add-int/2addr v3, v4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->hasImage(Landroid/content/Context;)Z

    move-result v4

    if-nez v4, :cond_65

    add-int/lit8 v3, v3, 0x1

    :cond_65
    if-eqz v2, :cond_72

    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    if-eqz v4, :cond_72

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sSig:I

    if-eq v3, v4, :cond_72

    return-void

    :cond_72
    if-eqz v2, :cond_81

    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    instance-of v5, v4, Landroid/view/ViewGroup;

    if-eqz v5, :cond_81

    check-cast v4, Landroid/view/ViewGroup;

    invoke-virtual {v4, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_81
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->stop()V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->mode(Landroid/content/Context;)I

    move-result v6

    const/4 v7, 0x2

    if-ne v6, v7, :cond_99

    new-instance v5, Landroid/view/TextureView;

    invoke-direct {v5, v0}, Landroid/view/TextureView;-><init>(Landroid/content/Context;)V

    new-instance v6, Lcom/varuns2002/disable_flag_secure/gm/GmCamStl;

    invoke-direct {v6, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmCamStl;-><init>(Landroid/view/TextureView;)V

    invoke-virtual {v5, v6}, Landroid/view/TextureView;->setSurfaceTextureListener(Landroid/view/TextureView$SurfaceTextureListener;)V

    goto :goto_c4

    :cond_99
    new-instance v5, Lcom/varuns2002/disable_flag_secure/gm/GmBgView;

    invoke-direct {v5, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBgView;-><init>(Landroid/content/Context;)V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->mode(Landroid/content/Context;)I

    move-result v6

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->grad(Landroid/content/Context;)I

    move-result v7

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->alpha(Landroid/content/Context;)I

    move-result v8

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->bitmap(Landroid/content/Context;)Landroid/graphics/Bitmap;

    move-result-object v9

    invoke-virtual {v5, v6, v7, v8, v9}, Lcom/varuns2002/disable_flag_secure/gm/GmBgView;->setup(IIILandroid/graphics/Bitmap;)V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v6

    const/4 v7, 0x2

    if-ne v6, v7, :cond_c4

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->dirMul(Landroid/content/Context;)Z

    move-result v6

    if-nez v6, :cond_c0

    const/4 v6, 0x2

    goto :goto_c1

    :cond_c0
    const/4 v6, 0x1

    :goto_c1
    invoke-virtual {v5, v6}, Lcom/varuns2002/disable_flag_secure/gm/GmBgView;->setBlend(I)V

    :cond_c4
    :goto_c4
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v6

    invoke-virtual {v6}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v6

    instance-of v7, v6, Landroid/view/ViewGroup;

    if-eqz v7, :cond_29

    check-cast v6, Landroid/view/ViewGroup;

    new-instance v7, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v8, -0x1

    const/4 v9, -0x1

    invoke-direct {v7, v8, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v8

    if-eqz v8, :cond_e4

    const/4 v8, 0x0

    invoke-virtual {v6, v5, v8, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    goto :goto_ed

    :cond_e4
    if-eqz v8, :cond_ea

    invoke-virtual {v6, v5, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    goto :goto_ed

    :cond_ea
    invoke-virtual {v6, v5, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :goto_ed
    sget-object v6, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    invoke-static {v6}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->clearBg(Landroid/app/Activity;)V

    invoke-static {p0, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->applyFx(Landroid/content/Context;Landroid/view/View;)V

    sget-object v6, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    invoke-static {p0, v6}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setBlend(Landroid/content/Context;Landroid/app/Activity;)V

    sput-object v5, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sView:Landroid/view/View;

    sput v3, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sSig:I

    return-void
.end method

.method public static file(Landroid/content/Context;)Ljava/io/File;
    .registers 4

    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "fuckds_bg.png"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method public static grad(Landroid/content/Context;)I
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_GRAD:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method public static hasImage(Landroid/content/Context;)Z
    .registers 7

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/16 v4, 0x0

    cmp-long v1, v2, v4

    if-lez v1, :cond_10

    const/4 v0, 0x1

    return v0

    :cond_10
    const/4 v0, 0x0

    return v0
.end method

.method public static isOn(Landroid/content/Context;)Z
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ON:Ljava/lang/String;

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method

.method public static mode(Landroid/content/Context;)I
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_MODE:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method public static pick()V
    .registers 2

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sPicking:Z

    return-void
.end method

.method public static pos(Landroid/content/Context;)I
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_POS:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_10

    const/4 v0, 0x1

    return v0

    :cond_10
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method public static real(Landroid/content/Context;)Z
    .registers 3

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->isOn(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_e

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v0

    if-lez v0, :cond_e

    const/4 v0, 0x1

    return v0

    :cond_e
    const/4 v0, 0x0

    return v0
.end method

.method public static rot(Landroid/content/Context;)I
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ROT:Ljava/lang/String;

    const-string v1, "i"

    invoke-static {p0, v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->ok(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_10

    const/4 v0, -0x1

    return v0

    :cond_10
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmPrompt;->toInt(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method public static saveImage(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 12

    const/4 v9, 0x0

    sput v9, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sSig:I

    :try_start_3
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    new-instance v2, Ljava/io/FileOutputStream;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v3, 0x2000

    new-array v3, v3, [B

    :goto_18
    invoke-virtual {v1, v3}, Ljava/io/InputStream;->read([B)I

    move-result v4

    if-lez v4, :cond_23

    const/4 v5, 0x0

    invoke-virtual {v2, v3, v5, v4}, Ljava/io/FileOutputStream;->write([BII)V

    goto :goto_18

    :cond_23
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V

    const/4 v9, 0x1
    :try_end_2a
    .catchall {:try_start_3 .. :try_end_2a} :catchall_2b

    return v9

    :catchall_2b
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return v0
.end method

.method public static setAlpha(Landroid/content/Context;I)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ALPHA:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static setBlend(Landroid/content/Context;Landroid/app/Activity;)V
    .registers 7

    :try_start_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1d

    if-lt v0, v1, :cond_13

    const v0, 0x1020002

    invoke-virtual {p1, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_13

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setBlendMode(Landroid/graphics/BlendMode;)V
    :try_end_13
    .catchall {:try_start_0 .. :try_end_13} :catchall_14

    :cond_13
    return-void

    :catchall_14
    move-exception v0

    return-void
.end method

.method public static setCam(Landroid/content/Context;I)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_CAM:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setCrop(Landroid/content/Context;I)V
    .registers 5

    const-string v0, "fuckds_bg_crop"

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setDir(Landroid/content/Context;I)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_DIR:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setGrad(Landroid/content/Context;I)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_GRAD:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setMode(Landroid/content/Context;I)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_MODE:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ON:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v1

    const-string v2, "b"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setPos(Landroid/content/Context;I)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_POS:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setRot(Landroid/content/Context;I)V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->K_ROT:Ljava/lang/String;

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "i"

    invoke-static {p0, v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static takePicking()Z
    .registers 2

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sPicking:Z

    const/4 v1, 0x0

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->sPicking:Z

    return v0
.end method
