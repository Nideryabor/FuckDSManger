.class public final Lcom/nidyaber/fuckdsmanger/gm/GmDeviceDialog;
.super Ljava/lang/Object;
.source "GmDeviceDialog.java"


# static fields
.field static sDlg:Landroid/app/Dialog;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static close()V
    .registers 1

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :cond_7
    return-void
.end method

.method public static open(Landroid/app/Activity;)V
    .registers 8

    if-eqz p0, :cond_4e

    :try_start_2
    const-string v0, "FuckDSManger: dialog build start"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceDialog;->close()V

    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u8bbe\u5907\u8eab\u4efd\uff08\u65e0\u9700\u767b\u5f55\u5373\u53ef\u64cd\u4f5c\uff09"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    const-string v1, "\u82e5\u767b\u5f55\u65f6\u63d0\u793a\u300c\u5f53\u524d\u8bbe\u5907\u8fd0\u884c\u73af\u5883\u5f02\u5e38\u300d\uff0c\u70b9\u4e0b\u65b9\u6309\u94ae\u6362\u4e00\u53f0\u201c\u65b0\u8bbe\u5907\u201d\u518d\u8bd5\u3002\n\n\u539f\u7406\uff1a\u66ff\u6362 android_id \u21d2 \u8bf7\u6c42\u5934 x-device-id \u53d8\u65b0\u3002\n\n\u63d0\u793a\uff1a\u4ee5\u540e\u5728\u4efb\u610f\u754c\u9762 1.5 \u79d2\u5185\u8fde\u70b9\u5c4f\u5e55 3 \u6b21\uff0c\u53ef\u91cd\u65b0\u6253\u5f00\u672c\u7a97\u53e3\u3002"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceClick;

    const/4 v2, 0x0

    invoke-direct {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceClick;-><init>(I)V

    const-string v2, "\u6362\u65b0\u8eab\u4efd\u5e76\u91cd\u542f App"

    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceClick;

    const/4 v2, 0x1

    invoke-direct {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceClick;-><init>(I)V

    const-string v2, "\u5173\u95ed"

    invoke-virtual {v0, v2, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v0

    const-string v1, "FuckDSManger: dialog showing"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-virtual {v0}, Landroid/app/AlertDialog;->show()V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmDeviceDialog;->sDlg:Landroid/app/Dialog;

    const-string v0, "FuckDSManger: dialog shown OK"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_46
    .catchall {:try_start_2 .. :try_end_46} :catchall_47

    return-void

    :catchall_47
    move-exception v0

    const-string v1, "FuckDSManger: dialog build FAIL"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void

    :cond_4e
    return-void
.end method
