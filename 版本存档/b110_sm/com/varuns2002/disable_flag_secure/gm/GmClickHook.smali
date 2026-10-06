.class public final Lcom/varuns2002/disable_flag_secure/gm/GmClickHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmClickHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTick:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x5dc

    cmp-long p0, v0, v2

    if-lez p0, :cond_e

    return-void

    :cond_e
    const-string v0, "click"

    const-string v1, "FuckDSManger row clicked -> open manager (original blocked)"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmMenuDialog;->open()V

    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {p1, v0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void
.end method
