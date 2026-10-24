.class public final Lcom/nidyaber/fuckdsmanger/gm/GmEnvExecHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmEnvExecHook.java"


# instance fields
.field private m:I


# direct methods
.method public constructor <init>(I)V
    .registers 2

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvExecHook;->m:I

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->isOn()Z

    move-result v0

    if-eqz v0, :cond_48

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->isApi()Z

    move-result v0

    if-eqz v0, :cond_49

    iget v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvExecHook;->m:I

    if-nez v0, :cond_1d

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_4a

    move-object v1, v0

    check-cast v1, Ljava/lang/String;

    goto :goto_37

    :cond_1d
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast v0, Ljava/lang/ProcessBuilder;

    invoke-virtual {v0}, Ljava/lang/ProcessBuilder;->command()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_4b

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    instance-of v1, v0, Ljava/lang/String;

    if-eqz v1, :cond_4c

    move-object v1, v0

    check-cast v1, Ljava/lang/String;

    :goto_37
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->badCmd(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_4d

    new-instance v0, Ljava/io/IOException;

    const-string v1, "not found"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setThrowable(Ljava/lang/Throwable;)V

    return-void

    :cond_48
    return-void

    :cond_49
    return-void

    :cond_4a
    return-void

    :cond_4b
    return-void

    :cond_4c
    return-void

    :cond_4d
    return-void
.end method
