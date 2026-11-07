.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassInstall.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->hookResume(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 65
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    .line 69
    const-string p0, " \u00b7 "

    .line 0
    const-string v0, "\u3010GmGlass\u3011onResume \u5df2\u7ed1\u5b9a\uff1a"

    .line 69
    :try_start_4
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 70
    instance-of v1, p1, Landroid/app/Activity;

    if-nez v1, :cond_b

    goto :goto_4e

    .line 71
    :cond_b
    check-cast p1, Landroid/app/Activity;

    .line 72
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$002(Landroid/app/Activity;)Landroid/app/Activity;

    .line 73
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->bind(Landroid/app/Activity;)V

    .line 74
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->reload(Landroid/content/Context;)Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    const/4 v1, 0x0

    .line 75
    invoke-static {v1, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->setRootOffset(II)V

    .line 76
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->on()Z

    move-result v1

    if-eqz v1, :cond_23

    .line 77
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->request()V

    .line 79
    :cond_23
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 80
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->get()Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 81
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->stats()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 79
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_4e
    .catchall {:try_start_4 .. :try_end_4e} :catchall_4e

    :catchall_4e
    :goto_4e
    return-void
.end method
