.class Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$3;
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

    .line 79
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$3;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 3

    if-nez p2, :cond_4

    const/4 p0, 0x0

    goto :goto_a

    .line 82
    :cond_4
    const-string p0, "json"

    invoke-virtual {p2, p0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    :goto_a
    if-eqz p0, :cond_f

    .line 83
    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->saveHostState(Landroid/content/Context;Ljava/lang/String;)I

    :cond_f
    return-void
.end method
