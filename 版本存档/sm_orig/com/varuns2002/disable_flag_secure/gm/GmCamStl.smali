.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCamStl;
.super Ljava/lang/Object;
.source "GmCamStl.java"

# interfaces
.implements Landroid/view/TextureView$SurfaceTextureListener;


# instance fields
.field private a:Landroid/view/TextureView;


# direct methods
.method public constructor <init>(Landroid/view/TextureView;)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCamStl;->a:Landroid/view/TextureView;

    return-void
.end method


# virtual methods
.method public onSurfaceTextureAvailable(Landroid/graphics/SurfaceTexture;II)V
    .registers 5

    iget-object v0, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCamStl;->a:Landroid/view/TextureView;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->start(Landroid/view/TextureView;)V

    return-void
.end method

.method public onSurfaceTextureDestroyed(Landroid/graphics/SurfaceTexture;)Z
    .registers 3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->stop()V

    const/4 v0, 0x1

    return v0
.end method

.method public onSurfaceTextureSizeChanged(Landroid/graphics/SurfaceTexture;II)V
    .registers 4

    return-void
.end method

.method public onSurfaceTextureUpdated(Landroid/graphics/SurfaceTexture;)V
    .registers 2

    return-void
.end method
