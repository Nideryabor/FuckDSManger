.class public final Lcom/nidyaber/fuckdsmanger/gm/GmDeviceClick;
.super Ljava/lang/Object;
.source "GmDeviceClick.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field private m:I


# direct methods
.method public constructor <init>(I)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceClick;->m:I

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .registers 8

    const/4 v0, 0x0

    :try_start_1
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0
    :try_end_5
    .catchall {:try_start_1 .. :try_end_5} :catchall_6

    goto :goto_7

    :catchall_6
    move-exception v1

    :goto_7
    if-eqz v0, :cond_12

    const-string v1, "fuckds_dev_ask3"

    const-string v2, "done"

    const-string v3, "b"

    invoke-static {v0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_12
    const/4 v1, -0x1

    if-ne p2, v1, :cond_26

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->reset()Ljava/lang/String;

    if-eqz v0, :cond_1f

    const-string v1, "\u5df2\u751f\u6210\u65b0\u7684\u8bbe\u5907\u8eab\u4efd\uff0c\u5373\u5c06\u91cd\u542f App\u2026"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_1f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceDialog;->close()V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->kill()V

    return-void

    :cond_26
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceDialog;->close()V

    return-void
.end method
