.class public final Lcom/nidyaber/fuckdsmanger/gm/GmNameHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmNameHook.java"


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

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmName;->isSet(Landroid/content/Context;)Z

    move-result v1

    if-nez v1, :cond_c

    return-void

    :cond_c
    :try_start_c
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    const-string v2, "a"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->getIntField(Ljava/lang/Object;Ljava/lang/String;)I

    move-result v1

    # ★ 2026-10-31（宿主 2.7.2 / vc289）：账号名分支从 a=8 挪到了 a=9！
    #   2.6.1 时代 s5.v() 的 a==8 就是账号名，于是这里一直写死 0x8。
    #   但 2.7.1 起宿主给那个 when 枚举**插了新分支**（a=8 变成 session_list 埋点
    #   ⇒ 我们不但不生效，还会把埋点的返回值替换成字符串 ✗ 危险）。
    #   证据：tmp/h272/c6.smali 的 packed-switch —— index 8=:pswitch_470（"session_list"）、
    #        index 9=:pswitch_413（olb.c / yy.b() → 空则 yy.e() 手机号 → "*****" 打码）。
    #   2.7.1 的 z5.w 同样在 index 9 ⇒ 这条从 2.7.1 起就是坏的（一直没察觉）。
    const/16 v2, 0x9

    if-eq v1, v2, :gm_accname
    goto :cond_2b

    :gm_accname

    const-string v2, "【昵称】a=9 命中账号名分支，替换为自定义名"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmName;->getText(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmNameHook;->sTold:Z

    if-nez v1, :cond_2b

    const/4 v1, 0x1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmNameHook;->sTold:Z

    const-string v1, "\u8d26\u53f7\u540d\u66ff\u6362\u5df2\u751f\u6548"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_2b
    .catchall {:try_start_c .. :try_end_2b} :catchall_2c

    :cond_2b
    return-void

    :catchall_2c
    move-exception v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method
