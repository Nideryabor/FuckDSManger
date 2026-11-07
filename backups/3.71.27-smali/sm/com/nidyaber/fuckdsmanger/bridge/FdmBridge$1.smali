.class Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge$1;
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

    .line 248
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 3

    .line 252
    :try_start_0
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->applyPushed(Landroid/content/Context;Landroid/content/Intent;)V
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->access$000(Landroid/content/Context;Landroid/content/Intent;)V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_4

    return-void

    :catchall_4
    move-exception p0

    .line 254
    const-string p1, "\u3010FdmBridge\u3011\u5e94\u7528\u914d\u7f6e\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
