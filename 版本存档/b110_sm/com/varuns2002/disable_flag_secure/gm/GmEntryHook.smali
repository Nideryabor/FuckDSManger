.class public final Lcom/varuns2002/disable_flag_secure/gm/GmEntryHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmEntryHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static unit(Landroid/content/Context;)Ljava/lang/Object;
    .registers 4

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    :cond_4
    :try_start_4
    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "lp9"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "a"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->getStaticObjectField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0
    :try_end_14
    .catchall {:try_start_4 .. :try_end_14} :catchall_15

    return-object v0

    :catchall_15
    move-exception v1

    return-object v0
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-nez v0, :cond_5

    return-void

    :cond_5
    const-string v1, "a"

    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->getIntField(Ljava/lang/Object;Ljava/lang/String;)I

    move-result v1

    const/16 v2, 0x14

    if-eq v1, v2, :cond_10

    return-void

    :cond_10
    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v2, :cond_19

    const-string v3, "FDS: check-update row hit"

    invoke-static {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_19
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmMenuDialog;->open()V

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmEntryHook;->unit(Landroid/content/Context;)Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {p1, v3}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V
    :try_end_23
    .catchall {:try_start_0 .. :try_end_23} :catchall_24

    return-void

    :catchall_24
    move-exception v0

    return-void
.end method
