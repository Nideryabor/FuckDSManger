.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallAiHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCallAiHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 10

    :try_start_0
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    if-nez v0, :cond_6e

    const-string v0, "[\u901a\u8bdd][AI] \u94a9\u5b50\u5df2\u5c31\u7eea v2.19.4"

    const-string v1, "\u9996\u6b21\u547d\u4e2d\uff08\u6b64\u540e\u4e0d\u518d\u91cd\u590d\uff09"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v7

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->pickVq(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-nez v2, :cond_31

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->aiText(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    if-nez v3, :cond_31

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->aiRole(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    if-nez v4, :cond_2d

    const-string p0, "USER"

    invoke-virtual {p0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_67

    :cond_2d
    invoke-static {v3, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->applyAiText(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_6e

    :cond_31
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_5f

    array-length v6, v0

    const/4 v1, 0x1

    if-lt v6, v1, :cond_5f

    const/4 v5, 0x0

    :goto_3a
    if-ge v5, v6, :cond_5f

    aget-object v1, v0, v5

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->pickVq(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-nez v2, :cond_5c

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->aiText(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    if-nez v3, :cond_5c

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->aiRole(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    if-nez v4, :cond_58

    const-string p0, "USER"

    invoke-virtual {p0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_67

    :cond_58
    invoke-static {v3, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->applyAiText(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_6e

    :cond_5c
    add-int/lit8 v5, v5, 0x1

    goto :goto_3a

    :cond_5f
    const-string v1, "[\u901a\u8bdd][AI]"

    const-string v2, "\u94a9\u5b50\u88ab\u8c03\u7528\u4f46 args/thisObject \u91cc\u6ca1\u6709\u53ef\u7528\u6587\u672c"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_6e

    :cond_67
    const-string v1, "[\u901a\u8bdd][AI]"

    const-string v2, "\u547d\u4e2d\u4f46\u89d2\u8272=USER\uff08\u5df2\u8df3\u8fc7\uff09"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_6e
    .catchall {:try_start_0 .. :try_end_6e} :catchall_6e

    :catchall_6e
    :cond_6e
    :goto_6e
    return-void
.end method
