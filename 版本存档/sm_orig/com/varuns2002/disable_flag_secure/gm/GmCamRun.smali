.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCamRun;
.super Ljava/lang/Object;
.source "GmCamRun.java"

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
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCam;->doOpen()V

    return-void
.end method
