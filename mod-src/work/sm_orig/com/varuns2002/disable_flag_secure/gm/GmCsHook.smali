.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCsHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCsHook.java"


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
    .registers 8

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_58

    array-length v1, v0

    const/16 v2, 0x24

    if-lt v1, v2, :cond_58

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSync;->ctx()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_58

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->isOn(Landroid/content/Context;)Z

    move-result v2

    if-eqz v2, :cond_58

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->pos(Landroid/content/Context;)I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_58

    const-wide/16 v4, 0x0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    const/16 v2, 0xd

    aput-object v3, v0, v2

    const/16 v2, 0xf

    aput-object v3, v0, v2

    const/16 v2, 0x11

    aput-object v3, v0, v2

    const/16 v2, 0x1d

    aput-object v3, v0, v2

    const/16 v2, 0x1e

    aput-object v3, v0, v2

    const/16 v2, 0x1f

    aput-object v3, v0, v2

    const/16 v2, 0x20

    aput-object v3, v0, v2

    const/16 v2, 0x21

    aput-object v3, v0, v2

    const/16 v2, 0x22

    aput-object v3, v0, v2

    const/16 v2, 0x23

    aput-object v3, v0, v2

    sget-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmCsHook;->sTold:Z

    if-nez v2, :cond_58

    const/4 v2, 0x1

    sput-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmCsHook;->sTold:Z

    const-string v2, "\u9875\u9762\u5e95\u8272\u5df2\u900f\u660e\u5316\uff08surface \u7cfb\u5217 10 \u9879\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_56
    .catchall {:try_start_0 .. :try_end_56} :catchall_57

    return-void

    :catchall_57
    move-exception v0

    :cond_58
    return-void
.end method
