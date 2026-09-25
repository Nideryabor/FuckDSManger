.class public final Lcom/nidyaber/fuckdsmanger/gm/GmPaintModHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmPaintModHook.java"


# static fields
.field private static sTold:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_52

    array-length v1, v0

    const/4 v2, 0x6

    if-lt v1, v2, :cond_52

    const/4 v1, 0x1

    aget-object v1, v0, v1

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmPainterHook;->sPainter:Ljava/lang/Object;

    if-eqz v2, :cond_52

    if-ne v1, v2, :cond_52

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_52

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "vk0"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x2

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-wide/16 v4, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    const/4 v4, 0x1

    aput-object v3, v2, v4

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x5

    aput-object v1, v0, v2

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmPaintModHook;->sTold:Z

    if-nez v0, :cond_52

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmPaintModHook;->sTold:Z

    const-string v0, "GmPaintModHook: ColorFilter -> Dst(hengdeng) replaced, avatar should show original photo"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v2, :cond_52

    const-string v3, "4) identity filter (Dst) installed"

    invoke-static {v2, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_52
    .catchall {:try_start_0 .. :try_end_52} :catchall_53

    :cond_52
    return-void

    :catchall_53
    move-exception v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
