.class public final Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmPainterHook.java"


# static fields
.field private static sDiag:Z

.field private static sPainter:Ljava/lang/Object;

.field private static sStamp:J

.field private static sTold:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 14

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_cb

    array-length v1, v0

    if-lez v1, :cond_cb

    const/4 v1, 0x0

    aget-object v1, v0, v1

    instance-of v2, v1, Ljava/lang/Integer;

    if-eqz v2, :cond_cb

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    sget-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sDiag:Z

    if-nez v2, :cond_20

    const/4 v2, 0x1

    sput-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sDiag:Z

    const-string v3, "Li65.x called"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    :cond_20
    const v2, 0x7f070059

    if-ne v1, v2, :cond_cb

    const-string v3, "Li65.x ID MATCH 0x7f070059"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v2, :cond_34

    const-string v3, "PHook: sAct NULL"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void

    :cond_34
    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->isOn(Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_40

    const-string v3, "PHook: isOn FALSE"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void

    :cond_40
    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_61

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v4

    if-eqz v4, :cond_56

    const-string v4, "PHook: file EXISTS but EMPTY"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    goto :goto_5b

    :cond_56
    const-string v4, "PHook: file NOT EXIST"

    invoke-static {v4}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    :goto_5b
    const-string v3, "PHook: hasImage FALSE"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void

    :cond_61
    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v3

    if-nez v3, :cond_68

    return-void

    :cond_68
    invoke-virtual {v3}, Ljava/io/File;->lastModified()J

    move-result-wide v4

    invoke-virtual {v3}, Ljava/io/File;->length()J

    move-result-wide v6

    add-long/2addr v4, v6

    sget-wide v6, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sStamp:J

    cmp-long v1, v4, v6

    if-nez v1, :cond_7f

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sPainter:Ljava/lang/Object;

    if-eqz v1, :cond_7f

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void

    :cond_7f
    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;)Landroid/graphics/Bitmap;

    move-result-object v1

    if-nez v1, :cond_8f

    const-string v3, "PHook: decode NULL"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void

    :cond_8f
    invoke-virtual {v2}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v8

    const-string v9, "ke"

    invoke-static {v9, v8}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v9

    const/4 v10, 0x1

    new-array v10, v10, [Ljava/lang/Object;

    const/4 v11, 0x0

    aput-object v1, v10, v11

    invoke-static {v9, v10}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    const-string v9, "di0"

    invoke-static {v9, v8}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v8

    const/4 v9, 0x1

    new-array v9, v9, [Ljava/lang/Object;

    const/4 v10, 0x0

    aput-object v1, v9, v10

    invoke-static {v8, v9}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sPainter:Ljava/lang/Object;

    sput-wide v4, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sStamp:J

    const-string v3, "PHook: painter built OK"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    sget-boolean p0, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sTold:Z

    if-nez p0, :cond_cb

    const/4 p0, 0x1

    sput-boolean p0, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sTold:Z

    const-string p0, "\u5934\u50cf\u66ff\u6362\u5df2\u751f\u6548 (Painter \u5c42)"

    invoke-static {v2, p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_cb
    .catchall {:try_start_0 .. :try_end_cb} :catchall_cc

    :cond_cb
    return-void

    :catchall_cc
    move-exception v0

    const-string v0, "PHook: EXCEPTION"

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method
