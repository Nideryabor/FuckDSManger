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
    .registers 3

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTick:J

    return-void
.end method
