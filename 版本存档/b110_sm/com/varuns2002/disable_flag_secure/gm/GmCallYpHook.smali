.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallYpHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCallYpHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sCtor:Ljava/lang/Object;

    if-eqz v0, :cond_11

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz v1, :cond_11

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sPairA:Ljava/lang/Object;

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sPairY:Ljava/lang/Object;

    const-string v2, "[\u901a\u8bdd] \u914d\u5bf9\u6210\u529f\uff1acomponent \u2194 \u5b83\u7684\u8f93\u5165\u72b6\u6001 yp1"

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_11
    .catchall {:try_start_0 .. :try_end_11} :catchall_11

    :catchall_11
    :cond_11
    return-void
.end method
