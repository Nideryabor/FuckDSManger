.class public final Lcom/varuns2002/disable_flag_secure/gm/GmFitRun;
.super Ljava/lang/Object;
.source "GmFitRun.java"

# interfaces
.implements Ljava/lang/Runnable;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sTv:Landroid/view/TextureView;

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->sCam:Landroid/hardware/Camera;

    if-eqz v0, :cond_8

    if-nez v1, :cond_9

    :cond_8
    return-void

    :cond_9
    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->fit(Landroid/view/TextureView;Landroid/hardware/Camera;)V
    :try_end_c
    .catchall {:try_start_0 .. :try_end_c} :catchall_d

    goto :goto_e

    :catchall_d
    move-exception v0

    :goto_e
    return-void
.end method
