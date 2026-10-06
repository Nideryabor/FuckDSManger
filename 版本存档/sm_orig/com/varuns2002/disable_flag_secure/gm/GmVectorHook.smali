.class public final Lcom/varuns2002/disable_flag_secure/gm/GmVectorHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmVectorHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-nez v0, :cond_5

    return-void

    :cond_5
    array-length v1, v0

    const/4 v2, 0x3

    if-ge v1, v2, :cond_a

    return-void

    :cond_a
    const/4 v1, 0x0

    aget-object v2, v0, v1

    instance-of v3, v2, Ljava/lang/Integer;

    if-nez v3, :cond_12

    return-void

    :cond_12
    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    const v3, 0x7f070059

    if-eq v2, v3, :cond_1e

    return-void

    :cond_1e
    const/4 v1, 0x1

    aget-object v2, v0, v1

    instance-of v3, v2, Landroid/util/TypedValue;

    if-nez v3, :cond_26

    return-void

    :cond_26
    check-cast v2, Landroid/util/TypedValue;

    sget-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v3, :cond_2d

    return-void

    :cond_2d
    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->isOn(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_34

    return-void

    :cond_34
    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->hasImage(Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_3b

    return-void

    :cond_3b
    sget-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sPainter:Ljava/lang/Object;

    if-nez v3, :cond_40

    return-void

    :cond_40
    const-string v3, "string"

    const/4 p0, 0x0

    invoke-static {v2, v3, p0}, Lde/robv/android/xposed/XposedHelpers;->setObjectField(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v3, "GmVectorHook fired (painter ready)"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method
