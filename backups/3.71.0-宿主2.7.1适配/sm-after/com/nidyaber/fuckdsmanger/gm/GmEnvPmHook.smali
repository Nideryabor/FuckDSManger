.class public final Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmEnvPmHook.java"


# instance fields
.field private m:I


# direct methods
.method public constructor <init>(I)V
    .registers 2

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;->m:I

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 9

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->isOn()Z

    move-result v0

    if-eqz v0, :cond_6b

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->isApi()Z

    move-result v0

    if-eqz v0, :cond_6c

    iget v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;->m:I

    if-eqz v0, :cond_50

    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ljava/util/List;

    if-eqz v1, :cond_6d

    move-object v1, v0

    check-cast v1, Ljava/util/List;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_24
    :goto_24
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4c

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    const/4 v5, 0x0

    instance-of v6, v4, Landroid/content/pm/PackageInfo;

    if-eqz v6, :cond_39

    move-object v5, v4

    check-cast v5, Landroid/content/pm/PackageInfo;

    iget-object v5, v5, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    goto :goto_42

    :cond_39
    instance-of v6, v4, Landroid/content/pm/ApplicationInfo;

    if-eqz v6, :cond_42

    move-object v5, v4

    check-cast v5, Landroid/content/pm/ApplicationInfo;

    iget-object v5, v5, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    :cond_42
    :goto_42
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->badPkg(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_24

    invoke-interface {v2, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_24

    :cond_4c
    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void

    :cond_50
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_6e

    move-object v1, v0

    check-cast v1, Ljava/lang/String;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->badPkg(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_6f

    new-instance v1, Landroid/content/pm/PackageManager$NameNotFoundException;

    invoke-direct {v1}, Landroid/content/pm/PackageManager$NameNotFoundException;-><init>()V

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setThrowable(Ljava/lang/Throwable;)V

    return-void

    :cond_6b
    return-void

    :cond_6c
    return-void

    :cond_6d
    return-void

    :cond_6e
    return-void

    :cond_6f
    return-void
.end method
