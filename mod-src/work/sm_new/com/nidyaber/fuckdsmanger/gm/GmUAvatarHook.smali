.class public final Lcom/nidyaber/fuckdsmanger/gm/GmUAvatarHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmUAvatarHook.java"


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

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUAvatar;->isOn(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_33

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_33

    const/4 v1, 0x0

    :try_start_12
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    const-string v3, "a"

    invoke-static {v2, v3}, Lde/robv/android/xposed/XposedHelpers;->getIntField(Ljava/lang/Object;Ljava/lang/String;)I

    move-result v1
    :try_end_1a
    .catchall {:try_start_12 .. :try_end_1a} :catchall_34

    const/16 v2, 0xf

    if-ne v1, v2, :cond_33

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUAvatar;->uri(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_33

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmUAvatarHook;->sTold:Z

    if-nez v1, :cond_33

    const/4 v1, 0x1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmUAvatarHook;->sTold:Z

    const-string v1, "\u8d26\u53f7\u5934\u50cf\u66ff\u6362\u5df2\u751f\u6548"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_33
    return-void

    :catchall_34
    move-exception v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
