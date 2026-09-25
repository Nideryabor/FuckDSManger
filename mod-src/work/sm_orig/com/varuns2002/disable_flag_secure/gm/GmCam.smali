.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCam;
.super Ljava/lang/Object;
.source "GmCam.java"


# static fields
.field static sCam:Landroid/hardware/Camera;

.field static sDeg:I

.field static sId:I

.field static sTv:Landroid/view/TextureView;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static applyFx(Landroid/content/Context;Landroid/view/View;)V
    .registers 6

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "cam fx mode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->mode(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " pos="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " alpha="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->alpha(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " cam="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->cam(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    if-eqz p1, :cond_66

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->mode(Landroid/content/Context;)I

    move-result v0

    const/4 v1, 0x2

    if-ne v0, v1, :cond_66

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v0

    const/4 v1, 0x2

    if-ne v0, v1, :cond_4d

    goto :goto_58

    :cond_4d
    if-eqz v0, :cond_58

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-virtual {p1, v1}, Landroid/view/View;->setAlpha(F)V

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->clearBlend(Landroid/view/View;)V

    return-void

    :cond_58
    :goto_58
    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->clearBlend(Landroid/view/View;)V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->alpha(Landroid/content/Context;)I

    move-result v1

    int-to-float v1, v1

    const/high16 v2, 0x42c80000    # 100.0f

    div-float/2addr v1, v2

    invoke-virtual {p1, v1}, Landroid/view/View;->setAlpha(F)V

    :cond_66
    return-void
.end method

.method static ask(Landroid/app/Activity;)V
    .registers 5

    :try_start_0
    const/4 v0, 0x1

    new-array v1, v0, [Ljava/lang/String;

    const/4 v0, 0x0

    const-string v2, "android.permission.CAMERA"

    aput-object v2, v1, v0

    const/16 v0, 0x4455

    invoke-virtual {p0, v1, v0}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_e

    goto :goto_f

    :catchall_e
    move-exception v0

    :goto_f
    const-string v0, "\u8bf7\u5148\u6388\u4e88 DeepSeek \u76f8\u673a\u6743\u9650\uff0c\u7136\u540e\u91cd\u65b0\u70b9\u4e00\u6b21\u300c\u6444\u50cf\u5934\u300d"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method static clearBlend(Landroid/view/View;)V
    .registers 4

    :try_start_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1d

    if-lt v0, v1, :cond_c

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setBlendMode(Landroid/graphics/BlendMode;)V
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_b

    goto :goto_c

    :catchall_b
    move-exception v0

    :cond_c
    :goto_c
    return-void
.end method

.method static doClose()V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sCam:Landroid/hardware/Camera;

    if-nez v0, :cond_5

    return-void

    :cond_5
    :try_start_5
    invoke-virtual {v0}, Landroid/hardware/Camera;->stopPreview()V
    :try_end_8
    .catchall {:try_start_5 .. :try_end_8} :catchall_9

    goto :goto_a

    :catchall_9
    move-exception v1

    :goto_a
    :try_start_a
    invoke-virtual {v0}, Landroid/hardware/Camera;->release()V
    :try_end_d
    .catchall {:try_start_a .. :try_end_d} :catchall_e

    goto :goto_f

    :catchall_e
    move-exception v1

    :goto_f
    const/4 v1, 0x0

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sCam:Landroid/hardware/Camera;

    const/4 v1, -0x1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sId:I

    return-void
.end method

.method static doOpen()V
    .registers 8

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->doClose()V

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_8

    return-void

    :cond_8
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sTv:Landroid/view/TextureView;

    if-nez v1, :cond_d

    return-void

    :cond_d
    const-string v2, "android.permission.CAMERA"

    invoke-virtual {v0, v2}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I

    move-result v3

    if-eqz v3, :cond_19

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->ask(Landroid/app/Activity;)V

    return-void

    :cond_19
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->cam(Landroid/content/Context;)I

    move-result v3

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->findId(I)I

    move-result v3

    if-ltz v3, :cond_56

    :try_start_23
    invoke-static {v3}, Landroid/hardware/Camera;->open(I)Landroid/hardware/Camera;

    move-result-object v4
    :try_end_27
    .catchall {:try_start_23 .. :try_end_27} :catchall_28

    goto :goto_2d

    :catchall_28
    move-exception v4

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void

    :goto_2d
    sput-object v4, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sCam:Landroid/hardware/Camera;

    sput v3, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sId:I

    invoke-static {v4, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->orient(Landroid/hardware/Camera;I)V

    invoke-virtual {v1}, Landroid/view/TextureView;->getSurfaceTexture()Landroid/graphics/SurfaceTexture;

    move-result-object v5

    if-nez v5, :cond_3b

    return-void

    :cond_3b
    :try_start_3b
    invoke-virtual {v4, v5}, Landroid/hardware/Camera;->setPreviewTexture(Landroid/graphics/SurfaceTexture;)V
    :try_end_3e
    .catchall {:try_start_3b .. :try_end_3e} :catchall_3f

    goto :goto_44

    :catchall_3f
    move-exception v6

    invoke-static {v6}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void

    :goto_44
    :try_start_44
    invoke-virtual {v4}, Landroid/hardware/Camera;->startPreview()V
    :try_end_47
    .catchall {:try_start_44 .. :try_end_47} :catchall_48

    goto :goto_4d

    :catchall_48
    move-exception v6

    invoke-static {v6}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void

    :goto_4d
    new-instance v7, Lcom/varuns2002/disable_flag_secure/gm/GmFitRun;

    invoke-direct {v7}, Lcom/varuns2002/disable_flag_secure/gm/GmFitRun;-><init>()V

    invoke-virtual {v1, v7}, Landroid/view/TextureView;->post(Ljava/lang/Runnable;)Z

    return-void

    :cond_56
    return-void
.end method

.method static findId(I)I
    .registers 6

    const/4 v0, -0x1

    :try_start_1
    invoke-static {}, Landroid/hardware/Camera;->getNumberOfCameras()I

    move-result v1
    :try_end_5
    .catchall {:try_start_1 .. :try_end_5} :catchall_6

    goto :goto_8

    :catchall_6
    move-exception v1

    return v0

    :goto_8
    const/4 v2, 0x0

    :goto_9
    if-ge v2, v1, :cond_1b

    new-instance v3, Landroid/hardware/Camera$CameraInfo;

    invoke-direct {v3}, Landroid/hardware/Camera$CameraInfo;-><init>()V

    invoke-static {v2, v3}, Landroid/hardware/Camera;->getCameraInfo(ILandroid/hardware/Camera$CameraInfo;)V

    iget v4, v3, Landroid/hardware/Camera$CameraInfo;->facing:I

    if-ne v4, p0, :cond_18

    return v2

    :cond_18
    add-int/lit8 v2, v2, 0x1

    goto :goto_9

    :cond_1b
    return v0
.end method

.method static fit(Landroid/view/TextureView;Landroid/hardware/Camera;)V
    .registers 15

    :try_start_0
    const/4 v0, 0x0

    const/4 v1, 0x0

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v2, :cond_16

    invoke-virtual {v2}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v1

    :cond_16
    if-lez v0, :cond_1b

    if-lez v1, :cond_1b

    goto :goto_23

    :cond_1b
    invoke-virtual {p0}, Landroid/view/TextureView;->getWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/view/TextureView;->getHeight()I

    move-result v1

    :goto_23
    if-lez v0, :cond_d0

    if-lez v1, :cond_d0

    sget v4, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sDeg:I

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v2, :cond_34

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->rot(Landroid/content/Context;)I

    move-result v3

    if-ltz v3, :cond_34

    move v4, v3

    :cond_34
    invoke-virtual {p1}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v2

    invoke-virtual {v2}, Landroid/hardware/Camera$Parameters;->getPreviewSize()Landroid/hardware/Camera$Size;

    move-result-object v2

    iget v5, v2, Landroid/hardware/Camera$Size;->width:I

    iget v6, v2, Landroid/hardware/Camera$Size;->height:I

    const/16 v2, 0x5a

    if-eq v4, v2, :cond_48

    const/16 v2, 0x10e

    if-ne v4, v2, :cond_4f

    :cond_48
    int-to-float v2, v0

    int-to-float v3, v6

    div-float/2addr v2, v3

    int-to-float v3, v1

    int-to-float v7, v5

    div-float/2addr v3, v7

    goto :goto_55

    :cond_4f
    int-to-float v2, v0

    int-to-float v3, v5

    div-float/2addr v2, v3

    int-to-float v3, v1

    int-to-float v7, v6

    div-float/2addr v3, v7

    :goto_55
    invoke-static {v2, v3}, Ljava/lang/Math;->max(FF)F

    move-result v2

    sget-object v10, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v10, :cond_66

    invoke-static {v10}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->crop(Landroid/content/Context;)I

    move-result v11

    int-to-float v11, v11

    const/high16 v12, 0x42c80000    # 100.0f

    div-float/2addr v11, v12

    mul-float/2addr v2, v11

    :cond_66
    int-to-float v3, v5

    mul-float/2addr v3, v2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    int-to-float v7, v6

    mul-float/2addr v7, v2

    invoke-static {v7}, Ljava/lang/Math;->round(F)I

    move-result v7

    new-instance v8, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v8, v3, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v9, 0x11

    iput v9, v8, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    invoke-virtual {p0, v8}, Landroid/view/TextureView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    int-to-float v8, v4

    invoke-virtual {p0, v8}, Landroid/view/TextureView;->setRotation(F)V

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "cam fit deg="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, " sDeg="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v2, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sDeg:I

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, " scr="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, "x"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, " prev="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, "x"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, " v="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, "x"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_d0
    .catchall {:try_start_0 .. :try_end_d0} :catchall_d1

    :cond_d0
    return-void

    :catchall_d1
    move-exception v0

    return-void
.end method

.method static orient(Landroid/hardware/Camera;I)V
    .registers 8

    :try_start_0
    new-instance v0, Landroid/hardware/Camera$CameraInfo;

    invoke-direct {v0}, Landroid/hardware/Camera$CameraInfo;-><init>()V

    invoke-static {p1, v0}, Landroid/hardware/Camera;->getCameraInfo(ILandroid/hardware/Camera$CameraInfo;)V

    iget v1, v0, Landroid/hardware/Camera$CameraInfo;->orientation:I

    iget v2, v0, Landroid/hardware/Camera$CameraInfo;->facing:I

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->rot()I

    move-result v3

    const/4 v4, 0x1

    if-ne v2, v4, :cond_1b

    add-int/2addr v1, v3

    rem-int/lit16 v1, v1, 0x168

    rsub-int v1, v1, 0x168

    rem-int/lit16 v1, v1, 0x168

    goto :goto_20

    :cond_1b
    sub-int/2addr v1, v3

    add-int/lit16 v1, v1, 0x168

    rem-int/lit16 v1, v1, 0x168

    :goto_20
    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sDeg:I

    const/4 v2, 0x0

    invoke-virtual {p0, v2}, Landroid/hardware/Camera;->setDisplayOrientation(I)V
    :try_end_26
    .catchall {:try_start_0 .. :try_end_26} :catchall_27

    goto :goto_28

    :catchall_27
    move-exception v0

    :goto_28
    return-void
.end method

.method public static refit()V
    .registers 3

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sTv:Landroid/view/TextureView;

    if-eqz v0, :cond_b

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sCam:Landroid/hardware/Camera;

    if-eqz v1, :cond_b

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->fit(Landroid/view/TextureView;Landroid/hardware/Camera;)V

    :cond_b
    return-void
.end method

.method static rot()I
    .registers 4

    const/4 v0, 0x0

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v2, :cond_1a

    invoke-virtual {v2}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v2

    invoke-interface {v2}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/Display;->getRotation()I

    move-result v1

    const/4 v3, 0x1

    if-eq v1, v3, :cond_1b

    const/4 v3, 0x2

    if-eq v1, v3, :cond_1e

    const/4 v3, 0x3

    if-eq v1, v3, :cond_21

    :cond_1a
    return v0

    :cond_1b
    const/16 v0, 0x5a

    return v0

    :cond_1e
    const/16 v0, 0xb4

    return v0

    :cond_21
    const/16 v0, 0x10e

    return v0
.end method

.method static setBlend(Landroid/content/Context;Landroid/view/View;)V
    .registers 5

    :try_start_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1d

    if-lt v0, v1, :cond_16

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->dirMul(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_f

    sget-object v0, Landroid/graphics/BlendMode;->SCREEN:Landroid/graphics/BlendMode;

    goto :goto_11

    :cond_f
    sget-object v0, Landroid/graphics/BlendMode;->MULTIPLY:Landroid/graphics/BlendMode;

    :goto_11
    invoke-virtual {p1, v0}, Landroid/view/View;->setBlendMode(Landroid/graphics/BlendMode;)V
    :try_end_14
    .catchall {:try_start_0 .. :try_end_14} :catchall_15

    goto :goto_16

    :catchall_15
    move-exception v0

    :cond_16
    :goto_16
    return-void
.end method

.method static spawn()V
    .registers 3

    :try_start_0
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/varuns2002/disable_flag_secure/gm/GmCamRun;

    invoke-direct {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmCamRun;-><init>()V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    :try_end_d
    .catchall {:try_start_0 .. :try_end_d} :catchall_e

    goto :goto_f

    :catchall_e
    move-exception v0

    :goto_f
    return-void
.end method

.method public static start(Landroid/view/TextureView;)V
    .registers 2

    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sTv:Landroid/view/TextureView;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->spawn()V

    return-void
.end method

.method public static stop()V
    .registers 2

    const/4 v0, 0x0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sTv:Landroid/view/TextureView;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->doClose()V

    return-void
.end method
