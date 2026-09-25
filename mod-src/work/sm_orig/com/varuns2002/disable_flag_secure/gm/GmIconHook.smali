.class public final Lcom/varuns2002/disable_flag_secure/gm/GmIconHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmIconHook.java"


# static fields
.field static sTold:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_29

    array-length v1, v0

    const/4 v2, 0x1

    if-lt v1, v2, :cond_29

    const/4 v1, 0x0

    aget-object v1, v0, v1

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;->sPainter:Ljava/lang/Object;

    if-eqz v2, :cond_29

    if-ne v1, v2, :cond_29

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmIconHook;->sTold:Z

    if-nez v0, :cond_29

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmIconHook;->sTold:Z

    const-string v0, "GmIconHook: our painter reached Icon layer (tint untouched; GmPaintModHook does the identity filter)"

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_29

    const-string v2, "3) painter reached Icon"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_29
    .catchall {:try_start_0 .. :try_end_29} :catchall_2a

    :cond_29
    return-void

    :catchall_2a
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
