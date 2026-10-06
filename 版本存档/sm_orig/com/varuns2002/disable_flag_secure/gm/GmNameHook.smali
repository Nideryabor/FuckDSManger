.class public final Lcom/varuns2002/disable_flag_secure/gm/GmNameHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmNameHook.java"


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

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmName;->isSet(Landroid/content/Context;)Z

    move-result v1

    if-nez v1, :cond_c

    return-void

    :cond_c
    :try_start_c
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    const-string v2, "a"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->getIntField(Ljava/lang/Object;Ljava/lang/String;)I

    move-result v1

    const/16 v2, 0x8

    if-ne v1, v2, :cond_2b

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmName;->getText(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmNameHook;->sTold:Z

    if-nez v1, :cond_2b

    const/4 v1, 0x1

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmNameHook;->sTold:Z

    const-string v1, "\u8d26\u53f7\u540d\u66ff\u6362\u5df2\u751f\u6548"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_2b
    .catchall {:try_start_c .. :try_end_2b} :catchall_2c

    :cond_2b
    return-void

    :catchall_2c
    move-exception v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
