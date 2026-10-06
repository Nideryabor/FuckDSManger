.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBubblePickStart;
.super Ljava/lang/Object;
.source "GmBubblePickStart.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    :try_start_0
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->takePicking()Z

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->takePicking()Z

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUAvatar;->takePicking()Z

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->armPick()V

    const-string v2, "[\u6c14\u6ce1] \u5df2\u53d1\u8d77\u9009\u56fe\uff08pick \u5df2\u6b66\u88c5\uff09"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    const/4 v0, 0x1

    invoke-static {v2, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setImgOn(Landroid/content/Context;Z)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->act()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_25

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_25

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmBeautyDialog;->sAct:Landroid/app/Activity;

    :cond_25
    if-nez v0, :cond_2d

    const-string v2, "[\u6c14\u6ce1] \u62ff\u4e0d\u5230 Activity\uff08GmEntry.sAct \u4e0e GmBeautyDialog.sAct \u90fd\u4e3a\u7a7a\uff09\uff0c\u672a\u80fd\u62c9\u8d77\u9009\u56fe"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    :cond_2d
    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    const-string v2, "android.intent.action.GET_CONTENT"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const-string v2, "image/*"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    const v2, 0x435b

    invoke-virtual {v0, v1, v2}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    const-string v2, "[\u6c14\u6ce1] \u9009\u56fe\u5df2\u62c9\u8d77\uff08\u4e0b\u9762\u82e5\u4e00\u76f4\u65e0\u300c\u5df2\u6536\u5230\u9009\u56fe\u56de\u8c03\u300d\u21d2 \u5bbf\u4e3b\u6ca1\u56de onActivityResult\uff09"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_47
    .catchall {:try_start_0 .. :try_end_47} :catchall_48

    return-void

    :catchall_48
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u62c9\u8d77\u9009\u56fe\u629b\u5f02\u5e38\uff08Intent/\u6743\u9650\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
