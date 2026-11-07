.class Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$1;
.super Landroid/content/BroadcastReceiver;
.source "FdmApp.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->regReceivers(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;)V
    .registers 2

    .line 56
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 3

    .line 59
    const-string p0, "FDM-DIAG"

    const-string p2, "\u5bbf\u4e3b\u7d22\u8981\u914d\u7f6e \u21d2 \u63a8\u9001"

    invoke-static {p0, p2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 60
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->push(Landroid/content/Context;)I

    return-void
.end method
