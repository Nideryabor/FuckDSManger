.class public final Lcom/varuns2002/disable_flag_secure/gm/GmAvatarHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmAvatarHook.java"


# static fields
.field static sTold:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 7

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_46

    array-length v1, v0

    const/4 v2, 0x1

    if-lt v1, v2, :cond_46

    const/4 v1, 0x0

    aget-object v2, v0, v1

    instance-of v3, v2, Ljava/lang/Integer;

    if-eqz v3, :cond_46

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    const v3, 0x7f070059

    if-ne v2, v3, :cond_46

    sget-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v3, :cond_46

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->isOn(Landroid/content/Context;)Z

    move-result v4

    if-eqz v4, :cond_46

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v4

    if-eqz v4, :cond_46

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->drawable(Landroid/content/Context;)Landroid/graphics/drawable/Drawable;

    move-result-object v4

    if-eqz v4, :cond_46

    invoke-virtual {p1, v4}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    const-string v4, "GmAvatarHook replaced drawable"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    sget-boolean v4, Lcom/varuns2002/disable_flag_secure/gm/GmAvatarHook;->sTold:Z

    if-nez v4, :cond_46

    const/4 v4, 0x1

    sput-boolean v4, Lcom/varuns2002/disable_flag_secure/gm/GmAvatarHook;->sTold:Z

    const-string v4, "avatar.ok"

    const-string p0, "\u52a9\u624b\u5934\u50cf\u66ff\u6362\u5df2\u751f\u6548\uff08\u5df2\u79fb\u9664 Toast \u63d0\u793a\uff0c\u9632\u975e\u4e3b\u7ebf\u7a0b\u5d29\u6e83\uff09"

    invoke-static {v4, p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_46
    .catchall {:try_start_0 .. :try_end_46} :catchall_47

    :cond_46
    return-void

    :catchall_47
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
