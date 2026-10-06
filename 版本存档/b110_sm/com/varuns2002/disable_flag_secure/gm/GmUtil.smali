.class public final Lcom/varuns2002/disable_flag_secure/gm/GmUtil;
.super Ljava/lang/Object;
.source "GmUtil.java"


# static fields
.field private static sOnce:Ljava/util/HashSet;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static app()Landroid/content/Context;
    .registers 6

    const/4 v0, 0x0

    :try_start_1
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_6

    return-object v1
    :try_end_6
    .catchall {:try_start_1 .. :try_end_6} :catchall_2b

    :cond_6
    :goto_6
    :try_start_6
    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "currentApplication"

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    const/4 v2, 0x0

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Object;

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    instance-of v2, v1, Landroid/content/Context;

    if-eqz v2, :cond_2a

    check-cast v1, Landroid/content/Context;

    move-object v0, v1
    :try_end_28
    .catchall {:try_start_6 .. :try_end_28} :catchall_29

    goto :goto_2a

    :catchall_29
    move-exception v1

    :cond_2a
    :goto_2a
    return-object v0

    :catchall_2b
    move-exception v1

    goto :goto_6
.end method

.method public static bg(Landroid/content/Context;)I
    .registers 2

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->isNight(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_a

    const v0, -0xe1e1e2

    return v0

    :cond_a
    const/4 v0, -0x1

    return v0
.end method

.method public static caller()Ljava/lang/String;
    .registers 10

    :try_start_0
    new-instance v0, Ljava/lang/Throwable;

    invoke-direct {v0}, Ljava/lang/Throwable;-><init>()V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x2

    const/4 v3, 0x0

    const/16 v4, 0x20

    :goto_e
    if-ge v2, v1, :cond_62

    if-ge v2, v4, :cond_62

    aget-object v5, v0, v2

    invoke-virtual {v5}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    move-result-object v6

    const-string v7, "de.robv."

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_21

    goto :goto_5f

    :cond_21
    const-string v7, "com.varuns2002."

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_2a

    goto :goto_5f

    :cond_2a
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    const/4 v8, 0x1

    if-le v7, v8, :cond_5f

    add-int/lit8 v3, v3, 0x1

    const/4 v7, 0x2

    if-lt v3, v7, :cond_5f

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "."

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StackTraceElement;->getMethodName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ":"

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StackTraceElement;->getLineNumber()I

    move-result v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_5f
    :goto_5f
    add-int/lit8 v2, v2, 0x1

    goto :goto_e

    :cond_62
    const-string v0, ""

    return-object v0
    :try_end_65
    .catchall {:try_start_0 .. :try_end_65} :catchall_65

    :catchall_65
    move-exception v0

    const-string v0, "?"

    return-object v0
.end method

.method public static dp(Landroid/content/Context;I)I
    .registers 3

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    int-to-float p0, p1

    mul-float/2addr v0, p0

    const/high16 p0, 0x3f000000    # 0.5f

    add-float/2addr v0, p0

    float-to-int v0, v0

    return v0
.end method

.method public static envSafe(Ljava/lang/ClassLoader;)V
    .registers 4

    :try_start_0
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmEnv;->install(Ljava/lang/ClassLoader;)V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_4

    return-void

    :catchall_4
    move-exception v0

    const-string v1, "GmEnv install FAIL"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static isNight(Landroid/content/Context;)Z
    .registers 3

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    iget v0, v0, Landroid/content/res/Configuration;->uiMode:I

    and-int/lit8 v0, v0, 0x30

    const/16 v1, 0x20

    if-ne v0, v1, :cond_12

    const/4 v0, 0x1

    return v0

    :cond_12
    const/4 v0, 0x0

    return v0
.end method

.method public static line(Landroid/content/Context;)I
    .registers 2

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->isNight(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_a

    const v0, -0xcccccd

    return v0

    :cond_a
    const v0, -0x111112

    return v0
.end method

.method public static log(Ljava/lang/String;)V
    .registers 3

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "FuckDSManger: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method

.method public static logE(Ljava/lang/Throwable;)V
    .registers 4

    invoke-static {p0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "FuckDSManger: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "E "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method

.method public static logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    .registers 3

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method public static logOnce(Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->sOnce:Ljava/util/HashSet;

    if-nez v0, :cond_b

    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->sOnce:Ljava/util/HashSet;

    :cond_b
    invoke-virtual {v0, p0}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_14

    invoke-static {p1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_14
    return-void
.end method

.method public static sc(Landroid/app/Dialog;Landroid/view/View;)V
    .registers 4

    new-instance v0, Landroid/widget/ScrollView;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    invoke-virtual {v0, p1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    invoke-virtual {p0, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    return-void
.end method

.method public static stack()Ljava/lang/String;
    .registers 9

    :try_start_0
    new-instance v0, Ljava/lang/Throwable;

    invoke-direct {v0}, Ljava/lang/Throwable;-><init>()V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    array-length v2, v0

    const/4 v3, 0x2

    const/16 v4, 0xa

    :goto_12
    if-ge v3, v2, :cond_3f

    if-ge v3, v4, :cond_3f

    aget-object v5, v0, v3

    invoke-virtual {v5}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "."

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StackTraceElement;->getMethodName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ":"

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StackTraceElement;->getLineNumber()I

    move-result v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " < "

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_12

    :cond_3f
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
    :try_end_44
    .catchall {:try_start_0 .. :try_end_44} :catchall_44

    :catchall_44
    move-exception v0

    const-string v0, "?"

    return-object v0
.end method

.method public static sub(Landroid/content/Context;)I
    .registers 2

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->isNight(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_a

    const v0, -0x555556

    return v0

    :cond_a
    const v0, -0x777778

    return v0
.end method

.method public static toast(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method public static tx(Landroid/content/Context;)I
    .registers 2

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->isNight(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_8

    const/4 v0, -0x1

    return v0

    :cond_8
    const v0, -0x1000000

    return v0
.end method
