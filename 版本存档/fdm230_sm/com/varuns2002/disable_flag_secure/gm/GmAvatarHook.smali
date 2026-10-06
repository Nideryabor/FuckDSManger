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
    .registers 6

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    const v1, 0x7f070059

    if-ne v0, v1, :cond_3a

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_3a

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->isOn(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_3a

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_3a

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->drawable(Landroid/content/Context;)Landroid/graphics/drawable/Drawable;

    move-result-object v1

    if-eqz v1, :cond_3a

    const-string v2, "GmAvatarHook replaced drawable"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmAvatarHook;->sTold:Z

    if-nez v1, :cond_3a

    const/4 v1, 0x1

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmAvatarHook;->sTold:Z

    const-string v1, "\u52a9\u624b\u5934\u50cf\u66ff\u6362\u5df2\u751f\u6548"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_3a
    return-void
.end method
