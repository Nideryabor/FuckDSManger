.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;
.super Ljava/lang/Object;
.source "GmGlassInstall.java"


# static fields
.field private static volatile sAct:Landroid/app/Activity; = null

.field private static volatile sAnimating:Z = false

.field private static volatile sInstalled:Z = false

.field private static volatile sSnapping:Z = false


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 343
    const-class v0, Landroid/os/Bundle;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Landroid/app/Activity;
    .registers 1

    .line 34
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    return-object v0
.end method

.method static synthetic access$002(Landroid/app/Activity;)Landroid/app/Activity;
    .registers 1

    .line 34
    sput-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    return-object p0
.end method

.method static synthetic access$100()V
    .registers 0

    .line 34
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->startAnim()V

    return-void
.end method

.method static synthetic access$202(Z)Z
    .registers 1

    .line 34
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAnimating:Z

    return p0
.end method

.method static synthetic access$302(Z)Z
    .registers 1

    .line 34
    sput-boolean p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sSnapping:Z

    return p0
.end method

.method public static act()Landroid/app/Activity;
    .registers 1

    .line 43
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    return-object v0
.end method

.method public static density()F
    .registers 2

    .line 242
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_16

    .line 245
    :try_start_4
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F
    :try_end_e
    .catchall {:try_start_4 .. :try_end_e} :catchall_16

    const v1, 0x3dcccccd    # 0.1f

    cmpl-float v1, v0, v1

    if-lez v1, :cond_16

    return v0

    :catchall_16
    :cond_16
    const/high16 v0, 0x40400000    # 3.0f

    return v0
.end method

.method private static findComposeView(Landroid/view/ViewGroup;)Landroid/view/View;
    .registers 4

    const/4 v0, 0x0

    .line 310
    :goto_1
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_22

    .line 311
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 312
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->hasSemanticsOwner(Landroid/view/View;)Z

    move-result v2

    if-eqz v2, :cond_12

    return-object v1

    .line 313
    :cond_12
    instance-of v2, v1, Landroid/view/ViewGroup;

    if-eqz v2, :cond_1f

    .line 314
    check-cast v1, Landroid/view/ViewGroup;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->findComposeView(Landroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :cond_1f

    return-object v1

    :cond_1f
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :cond_22
    const/4 p0, 0x0

    return-object p0
.end method

.method private static hasSemanticsOwner(Landroid/view/View;)Z
    .registers 4

    const/4 v0, 0x0

    .line 323
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    const-string v1, "getSemanticsOwner"

    new-array v2, v0, [Ljava/lang/Class;

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    :try_end_d
    .catchall {:try_start_1 .. :try_end_d} :catchall_f

    const/4 p0, 0x1

    return p0

    :catchall_f
    return v0
.end method

.method private static hookResume(Ljava/lang/ClassLoader;)V
    .registers 4

    .line 64
    :try_start_0
    const-string v0, "android.app.Activity"

    const-string v1, "onResume"

    new-instance v2, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$1;

    invoke-direct {v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$1;-><init>()V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_10
    .catchall {:try_start_0 .. :try_end_10} :catchall_11

    return-void

    :catchall_11
    move-exception p0

    .line 87
    const-string v0, "\u3010GmGlass\u3011onResume \u94a9\u5b50\u6302\u8f7d\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static hookTouch(Ljava/lang/ClassLoader;)V
    .registers 5

    .line 103
    :try_start_0
    const-string v0, "android.app.Activity"

    const-string v1, "dispatchTouchEvent"

    const-class v2, Landroid/view/MotionEvent;

    new-instance v3, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$2;

    invoke-direct {v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$2;-><init>()V

    filled-new-array {v2, v3}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 124
    const-string p0, "\u3010GmGlass\u3011\u89e6\u6478\u94a9\u5b50\u5df2\u6302\uff08Q \u5f39\u9a71\u52a8\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_18

    return-void

    :catchall_18
    move-exception p0

    .line 126
    const-string v0, "\u3010GmGlass\u3011\u89e6\u6478\u94a9\u5b50\u6302\u8f7d\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 3

    const-string v0, "\u3010GmGlass\u3011\u5b89\u88c5\u5b8c\u6210\uff1a\u6309\u94ae\u951a "

    .line 48
    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sInstalled:Z

    if-eqz v1, :cond_7

    return-void

    :cond_7
    const/4 v1, 0x1

    .line 49
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sInstalled:Z

    .line 51
    :try_start_a
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassScope;->install(Ljava/lang/ClassLoader;)I

    move-result v1

    .line 52
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSink;->install(Ljava/lang/ClassLoader;)V

    .line 53
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->hookResume(Ljava/lang/ClassLoader;)V

    .line 54
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->hookTouch(Ljava/lang/ClassLoader;)V

    .line 55
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u6761 \u00b7 \u753b\u5e95\u539f\u8bed\u5df2\u6302"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_2b
    .catchall {:try_start_a .. :try_end_2b} :catchall_2c

    return-void

    :catchall_2c
    move-exception p0

    .line 57
    const-string v0, "\u3010GmGlass\u3011\u5b89\u88c5\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static isFullPage(FF)Z
    .registers 7

    .line 274
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    const/4 v1, 0x0

    if-nez v0, :cond_6

    return v1

    .line 277
    :cond_6
    :try_start_6
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    .line 278
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v0
    :try_end_17
    .catchall {:try_start_6 .. :try_end_17} :catchall_31

    int-to-float v0, v0

    const/4 v3, 0x0

    cmpg-float v4, v2, v3

    if-lez v4, :cond_31

    cmpg-float v3, v0, v3

    if-gtz v3, :cond_22

    goto :goto_31

    :cond_22
    const v3, 0x3f7851ec    # 0.97f

    mul-float/2addr v2, v3

    cmpl-float p0, p0, v2

    if-ltz p0, :cond_31

    mul-float/2addr v0, v3

    cmpl-float p0, p1, v0

    if-ltz p0, :cond_31

    const/4 p0, 0x1

    return p0

    :catchall_31
    :cond_31
    :goto_31
    return v1
.end method

.method public static isNight()Z
    .registers 3

    .line 255
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    const/4 v1, 0x0

    if-eqz v0, :cond_17

    .line 258
    :try_start_5
    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    iget v0, v0, Landroid/content/res/Configuration;->uiMode:I
    :try_end_f
    .catchall {:try_start_5 .. :try_end_f} :catchall_17

    and-int/lit8 v0, v0, 0x30

    const/16 v2, 0x20

    if-ne v0, v2, :cond_17

    const/4 v0, 0x1

    return v0

    :catchall_17
    :cond_17
    return v1
.end method

.method public static refresh(Landroid/content/Context;)V
    .registers 3

    const-string v0, "\u3010GmGlass\u3011\u914d\u7f6e\u5237\u65b0 "

    .line 164
    :try_start_2
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->reload(Landroid/content/Context;)Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    move-result-object p0

    .line 165
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->drop()V

    const/4 v1, 0x0

    .line 166
    invoke-static {v1, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->setRootOffset(II)V

    .line 167
    iget-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->on:Z

    if-eqz v1, :cond_19

    .line 168
    sget-object v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->bind(Landroid/app/Activity;)V

    .line 169
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->request()V

    .line 171
    :cond_19
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_28
    .catchall {:try_start_2 .. :try_end_28} :catchall_29

    return-void

    :catchall_29
    move-exception p0

    .line 173
    const-string v0, "\u3010GmGlass\u3011\u914d\u7f6e\u5237\u65b0\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static rootOffset()[I
    .registers 3

    .line 291
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    const/4 v1, 0x0

    if-nez v0, :cond_a

    .line 292
    filled-new-array {v1, v1}, [I

    move-result-object v0

    return-object v0

    .line 293
    :cond_a
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v2

    if-nez v2, :cond_12

    const/4 v0, 0x0

    goto :goto_1a

    :cond_12
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    .line 294
    :goto_1a
    instance-of v2, v0, Landroid/view/ViewGroup;

    if-nez v2, :cond_23

    filled-new-array {v1, v1}, [I

    move-result-object v0

    return-object v0

    .line 295
    :cond_23
    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->findComposeView(Landroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    if-nez v0, :cond_30

    .line 296
    filled-new-array {v1, v1}, [I

    move-result-object v0

    return-object v0

    :cond_30
    const/4 v1, 0x2

    .line 297
    new-array v1, v1, [I

    .line 298
    invoke-virtual {v0, v1}, Landroid/view/View;->getLocationInWindow([I)V

    return-object v1
.end method

.method public static snap()V
    .registers 1

    .line 190
    const-string v0, "\u3010GmGlass\u3011\u81ea\u62cd\u5df2\u5173\u95ed\uff08\u6b63\u5f0f\u5305\u4e0d\u5e26\u8c03\u8bd5\u529f\u80fd\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static startAnim()V
    .registers 2

    .line 132
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAnimating:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    .line 133
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAnimating:Z

    .line 134
    invoke-static {}, Landroid/view/Choreographer;->getInstance()Landroid/view/Choreographer;

    move-result-object v0

    .line 135
    new-instance v1, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$3;

    invoke-direct {v1, v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$3;-><init>(Landroid/view/Choreographer;)V

    invoke-virtual {v0, v1}, Landroid/view/Choreographer;->postFrameCallback(Landroid/view/Choreographer$FrameCallback;)V

    return-void
.end method

.method public static watchActivity(Landroid/app/Activity;)V
    .registers 3

    if-nez p0, :cond_3

    goto :goto_12

    .line 333
    :cond_3
    sput-object p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->sAct:Landroid/app/Activity;

    .line 335
    :try_start_5
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->rootOffset()[I

    move-result-object p0

    const/4 v0, 0x0

    .line 336
    aget v0, p0, v0

    const/4 v1, 0x1

    aget p0, p0, v1

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassAtoms;->setRootOffset(II)V
    :try_end_12
    .catchall {:try_start_5 .. :try_end_12} :catchall_12

    :catchall_12
    :goto_12
    return-void
.end method
