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
    .registers 5

    const-string v2, "PickHook: entered"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->takePicking()Z

    move-result v0

    if-eqz v0, :cond_41

    const-string v2, "PickHook: picking mode ON"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    check-cast v0, Landroid/content/Intent;

    if-eqz v0, :cond_41

    invoke-virtual {v0}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    if-eqz v0, :cond_41

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_41

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->saveImage(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v0

    if-eqz v0, :cond_37

    const-string v2, "PickHook: saveImage TRUE"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->setOn(Landroid/content/Context;Z)V

    const-string v0, "\u52a9\u624b\u5934\u50cf\u5df2\u4fdd\u5b58\uff08\u91cd\u542f App \u751f\u6548\uff09"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_37
    const-string v2, "PickHook: saveImage FALSE"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    const-string v0, "\u56fe\u7247\u4fdd\u5b58\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_41
    return-void
.end method
