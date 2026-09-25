.class public final Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;
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

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;->sPick:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;->sPick:Z

    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    const-string v1, "android.app.Activity"

    const-string v2, "onActivityResult"

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;->reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "androidx.activity.ComponentActivity"

    const-string v2, "onActivityResult"

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;->reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "androidx.fragment.app.FragmentActivity"

    const-string v2, "onActivityResult"

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;->reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "pick hooks ensured"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static reg(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    :try_start_0
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    new-instance v1, Lcom/nidyaber/fuckdsmanger/gm/GmPickHook;

    invoke-direct {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmPickHook;-><init>()V

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

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->setAct(Landroid/app/Activity;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->onResume(Landroid/app/Activity;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->promptIfNeeded(Landroid/app/Activity;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmAvatarFix;->run(Landroid/content/Context;)V

    const-string v1, "onResume: module alive"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;->ensurePick(Landroid/app/Activity;)V

    :try_start_1f
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmSync;->ensure(Landroid/content/Context;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSync;->reapplyAll()V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmBg;->ensure(Landroid/content/Context;)V
    :try_end_28
    .catchall {:try_start_1f .. :try_end_28} :catchall_29

    goto :goto_2a

    :catchall_29
    move-exception v2

    :goto_2a
    :try_start_2a
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCallTick;->start()V
    :try_end_2d
    .catchall {:try_start_2a .. :try_end_2d} :catchall_2e

    goto :goto_34

    :catchall_2e
    move-exception v2

    const-string v2, "[\u901a\u8bdd] \u5b88\u62a4\u7ebf\u7a0b\u542f\u52a8\u5f02\u5e38"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_34
    :try_start_34
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmCallBtn;->show(Landroid/app/Activity;)V
    :try_end_37
    .catchall {:try_start_34 .. :try_end_37} :catchall_38

    goto :goto_3e

    :catchall_38
    move-exception v2

    const-string v2, "[\u901a\u8bdd] \u60ac\u6d6e\u94ae\u8c03\u7528\u5f02\u5e38"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_3e
    invoke-virtual {v0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    :try_start_42
    const-string v2, "kf5"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const-string v2, "check kf5 OK"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_4d
    .catchall {:try_start_42 .. :try_end_4d} :catchall_4e

    goto :goto_54

    :catchall_4e
    move-exception v2

    const-string v2, "check kf5 FAIL"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    :goto_54
    :try_start_54
    const-string v2, "ok0"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    const-string v2, "check ok0 OK"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_5f
    .catchall {:try_start_54 .. :try_end_5f} :catchall_60

    return-void

    :catchall_60
    move-exception v2

    const-string v2, "check ok0 FAIL"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method
