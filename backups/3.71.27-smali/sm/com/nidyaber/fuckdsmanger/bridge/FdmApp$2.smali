.class Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$2;
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

    .line 63
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 5

    const/4 p0, -0x1

    if-nez p2, :cond_5

    move v0, p0

    goto :goto_b

    .line 66
    :cond_5
    const-string v0, "rev"

    invoke-virtual {p2, v0, p0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    :goto_b
    if-nez p2, :cond_e

    goto :goto_14

    .line 67
    :cond_e
    const-string v1, "count"

    invoke-virtual {p2, v1, p0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p0

    .line 68
    :goto_14
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v1, "\u2705 \u5bbf\u4e3b\u56de\u6267\uff1a\u5df2\u5e94\u7528 rev="

    invoke-direct {p2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u5171 "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u9879"

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p2, "FDM-DIAG"

    invoke-static {p2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 70
    :try_start_34
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "applied_rev"

    .line 71
    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "applied_at"

    .line 72
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-interface {p0, p1, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 73
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_4f
    .catchall {:try_start_34 .. :try_end_4f} :catchall_4f

    :catchall_4f
    return-void
.end method
