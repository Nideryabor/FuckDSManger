.class public final Lcom/varuns2002/disable_flag_secure/gm/GmTouchHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmTouchHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTick:J

    const-string v0, "[\u89e6\u6478\u94a9\u5b50]"

    const-string v1, "dispatchTouchEvent \u94a9\u5b50\u5df2\u88ab\u8c03\u7528\uff08\u8bf4\u660e\u89e6\u6478\u94a9\u5b50\u751f\u6548\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz p0, :cond_4d

    array-length v0, p0

    if-eqz v0, :cond_4d

    const/4 v0, 0x0

    aget-object p0, p0, v0

    instance-of v0, p0, Landroid/view/MotionEvent;

    if-eqz v0, :cond_4d

    check-cast p0, Landroid/view/MotionEvent;

    invoke-virtual {p0}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    if-nez v0, :cond_3d

    const-string v0, "[\u89e6\u6478] DOWN"

    const-string v1, "\u6536\u5230 ACTION_DOWN\uff08\u5f00\u7a97\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    const-string p0, "\u6309"

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    if-eqz v0, :cond_33

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_33
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sTouchMs:J

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sTouchOn:Z

    goto :goto_4d

    :cond_3d
    const-wide/16 v0, 0x0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sTouchMs:J

    const-string p0, "\u653e"

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->sInst:Lcom/varuns2002/disable_flag_secure/gm/GmProbe;

    if-eqz v0, :cond_4a

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_4a
    const/4 v0, 0x0

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->sTouchOn:Z

    :cond_4d
    :goto_4d
    :try_start_4d
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    instance-of v0, p0, Landroid/app/Activity;

    if-nez v0, :cond_58

    check-cast p0, Landroid/app/Activity;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDevice;->promptIfNeeded(Landroid/app/Activity;)V
    :try_end_58
    .catchall {:try_start_4d .. :try_end_58} :catchall_59

    :cond_58
    return-void

    :catchall_59
    move-exception p0

    return-void
.end method
