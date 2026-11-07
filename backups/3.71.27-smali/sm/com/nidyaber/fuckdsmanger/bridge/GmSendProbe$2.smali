.class Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSendProbe.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->installTouch(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 147
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 151
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz p0, :cond_f

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length p0, p0

    if-lez p0, :cond_f

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 p1, 0x0

    aget-object p0, p0, p1

    goto :goto_10

    :cond_f
    const/4 p0, 0x0

    .line 152
    :goto_10
    instance-of p1, p0, Landroid/view/MotionEvent;

    if-nez p1, :cond_15

    goto :goto_27

    .line 153
    :cond_15
    check-cast p0, Landroid/view/MotionEvent;

    invoke-virtual {p0}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p0

    if-eqz p0, :cond_20

    const/4 p1, 0x1

    if-ne p0, p1, :cond_27

    .line 155
    :cond_20
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p0

    # setter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sTouchAt:J
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->access$102(J)J
    :try_end_27
    .catchall {:try_start_0 .. :try_end_27} :catchall_27

    :catchall_27
    :cond_27
    :goto_27
    return-void
.end method
