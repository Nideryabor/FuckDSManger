.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmGlassInstall.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->hookTouch(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 104
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 108
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->on()Z

    move-result p0

    if-nez p0, :cond_7

    goto :goto_33

    .line 109
    :cond_7
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length p0, p0

    if-lez p0, :cond_12

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 p1, 0x0

    aget-object p0, p0, p1

    goto :goto_13

    :cond_12
    const/4 p0, 0x0

    .line 110
    :goto_13
    instance-of p1, p0, Landroid/view/MotionEvent;

    if-nez p1, :cond_18

    goto :goto_33

    .line 111
    :cond_18
    check-cast p0, Landroid/view/MotionEvent;

    invoke-virtual {p0}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p0

    if-nez p0, :cond_27

    .line 113
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->onDown()V

    .line 114
    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->startAnim()V
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$100()V

    return-void

    :cond_27
    const/4 p1, 0x1

    if-eq p0, p1, :cond_2d

    const/4 p1, 0x3

    if-ne p0, p1, :cond_33

    .line 117
    :cond_2d
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassSpring;->onUp()V

    .line 118
    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->startAnim()V
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->access$100()V
    :try_end_33
    .catchall {:try_start_0 .. :try_end_33} :catchall_33

    :catchall_33
    :cond_33
    :goto_33
    return-void
.end method
