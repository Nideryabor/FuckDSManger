.class public final Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmResumeHook.java"


# static fields
.field private static sPick:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method private static ensurePick(Landroid/app/Activity;)V
    .registers 4

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;->sPick:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;->sPick:Z

    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    const-string v1, "android.app.Activity"

    const-string v2, "onActivityResult"

    invoke-static {v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;->reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "androidx.activity.ComponentActivity"

    const-string v2, "onActivityResult"

    invoke-static {v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;->reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "androidx.fragment.app.FragmentActivity"

    const-string v2, "onActivityResult"

    invoke-static {v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;->reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "pick hooks ensured"

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    :try_start_0
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    new-instance v1, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;

    invoke-direct {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;-><init>()V

    invoke-static {v0, p2, v1}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0
    :try_end_11
    .catchall {:try_start_0 .. :try_end_11} :catchall_11

    :catchall_11
    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast v0, Landroid/app/Activity;

    const-string v1, "activity"

    const-string v2, "MainActivity.onResume -> activity recorded"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->setAct(Landroid/app/Activity;)V

    const-string v1, "onResume: module alive"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;->ensurePick(Landroid/app/Activity;)V

    invoke-virtual {v0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    :try_start_1a
    const-string v2, "i65"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const-string v2, "check i65 OK"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_25
    .catchall {:try_start_1a .. :try_end_25} :catchall_26

    goto :goto_2c

    :catchall_26
    move-exception v2

    const-string v2, "check i65 FAIL"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    :goto_2c
    :try_start_2c
    const-string v2, "p96"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const-string v2, "check p96 OK"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_37
    .catchall {:try_start_2c .. :try_end_37} :catchall_38

    return-void

    :catchall_38
    move-exception v2

    const-string v2, "check p96 FAIL"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method
