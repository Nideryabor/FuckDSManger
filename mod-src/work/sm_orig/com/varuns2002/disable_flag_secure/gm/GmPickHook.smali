.class public final Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmPickHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    const-string v2, "[\u6c14\u6ce1] PickHook \u5165\u53e3\uff1a\u6536\u5230\u4e00\u6b21 onActivityResult\uff08\u6709\u8fd9\u884c = \u94a9\u5b50\u5728\u8dd1\uff09"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    :try_start_5
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    const v1, 0x435b

    if-ne v0, v1, :cond_7c

    const-string v2, "[\u6c14\u6ce1] \u672c\u6b21\u8bf7\u6c42\u7801 = 0x435b\uff08\u6c14\u6ce1\u9009\u56fe\uff09\u21d2 \u76f4\u5224\u5904\u7406"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    check-cast v0, Landroid/content/Intent;

    if-eqz v0, :cond_71

    invoke-virtual {v0}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    if-eqz v0, :cond_71

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[\u6c14\u6ce1] \u9009\u4e2d uri = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " \uff5c type="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v3, v3, v1

    check-cast v3, Landroid/content/Intent;

    invoke-virtual {v3}, Landroid/content/Intent;->getType()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_71

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->useImgName()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->takePicking()Z

    move-result v2

    if-eqz v2, :cond_71

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v0

    if-eqz v0, :cond_6c

    const/4 v0, 0x1

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->finishPick(Landroid/content/Context;Z)V

    goto :goto_75

    :cond_6c
    const/4 v0, 0x0

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->finishPick(Landroid/content/Context;Z)V

    goto :goto_75

    :cond_71
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->takePicking()Z

    move-result v2
    :try_end_75
    .catchall {:try_start_5 .. :try_end_75} :catchall_76

    :goto_75
    return-void

    :catchall_76
    move-exception v0

    const-string v1, "[\u6c14\u6ce1] \u76f4\u5224\u5904\u7406\u629b\u5f02\u5e38\uff08\u5df2\u541e\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_7c
    const-string v2, "PickHook: entered"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->takePicking()Z

    move-result v0

    if-nez v0, :cond_c3

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->takePicking()Z

    move-result v0

    if-eqz v0, :cond_135

    const-string v2, "PickHook: picking mode ON"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    check-cast v0, Landroid/content/Intent;

    if-eqz v0, :cond_16d

    invoke-virtual {v0}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    if-eqz v0, :cond_16d

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_16d

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v0

    if-eqz v0, :cond_b9

    const-string v2, "PickHook: saveImage TRUE"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->setOn(Landroid/content/Context;Z)V

    const-string v0, "\u52a9\u624b\u5934\u50cf\u5df2\u4fdd\u5b58\uff08\u91cd\u542f App \u751f\u6548\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_b9
    const-string v2, "PickHook: saveImage FALSE"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    const-string v0, "\u56fe\u7247\u4fdd\u5b58\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_c3
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    check-cast v0, Landroid/content/Intent;

    if-eqz v0, :cond_16d

    invoke-virtual {v0}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    if-eqz v0, :cond_16d

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_16d

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v0

    if-eqz v0, :cond_ed

    const/4 v0, 0x1

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setOn(Landroid/content/Context;Z)V

    const/4 v0, 0x0

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->setMode(Landroid/content/Context;I)V

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->ensure(Landroid/content/Context;)V

    const-string v0, "\u80cc\u666f\u56fe\u5df2\u4fdd\u5b58"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_ed
    const-string v0, "\u80cc\u666f\u56fe\u4fdd\u5b58\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->isPicking()Z

    move-result v0

    if-eqz v0, :cond_135

    const-string v2, "[\u6c14\u6ce1] \u5df2\u6536\u5230\u9009\u56fe\u56de\u8c03\uff08\u672c\u884c\u51fa\u73b0 = \u7b2c\u56db\u5bb6\u5df2\u63a5\u4e0a\uff09"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v2, "PickHook: bubble picking ON"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    check-cast v0, Landroid/content/Intent;

    if-eqz v0, :cond_135

    invoke-virtual {v0}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    if-eqz v0, :cond_135

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_135

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->useImgName()V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->takePicking()Z

    move-result v2

    if-eqz v2, :cond_135

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v0

    if-eqz v0, :cond_129

    const/4 v0, 0x1

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->finishPick(Landroid/content/Context;Z)V

    return-void

    :cond_129
    const/4 v0, 0x0

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->finishPick(Landroid/content/Context;Z)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->pick()V

    const-string v2, "[\u6c14\u6ce1] \u672c\u6b21\u7ed3\u679c\u6ca1\u5e26\u4e0a\u56fe\u7247\uff0c\u5df2\u91cd\u65b0\u6b66\u88c5\u7b49\u4e0b\u4e00\u6b21\uff08\u53ef\u518d\u9009\u4e00\u6b21\uff09"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_135
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUAvatar;->takePicking()Z

    move-result v0

    if-eqz v0, :cond_16d

    const-string v2, "PickHook: user avatar picking ON"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    check-cast v0, Landroid/content/Intent;

    if-eqz v0, :cond_16d

    invoke-virtual {v0}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    if-eqz v0, :cond_16d

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_16d

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUAvatar;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v0

    if-eqz v0, :cond_168

    const-string v2, "PickHook: uavatar saveImage TRUE"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    const/4 v0, 0x1

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUAvatar;->setOn(Landroid/content/Context;Z)V

    const-string v0, "\u8d26\u53f7\u5934\u50cf\u5df2\u4fdd\u5b58\uff08\u91cd\u542f App \u751f\u6548\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_168
    const-string v0, "\u56fe\u7247\u4fdd\u5b58\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_16d
    return-void
.end method
