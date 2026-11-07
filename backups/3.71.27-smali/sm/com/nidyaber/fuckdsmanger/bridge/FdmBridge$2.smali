.class Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$2;
.super Landroid/content/BroadcastReceiver;
.source "FdmBridge.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->installReceiver(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 269
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 3

    .line 273
    :try_start_0
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->onCmd(Landroid/content/Context;Landroid/content/Intent;)V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_4

    return-void

    :catchall_4
    move-exception p0

    .line 275
    const-string p1, "\u3010FdmBridge\u3011\u52a8\u4f5c\u6267\u884c\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
