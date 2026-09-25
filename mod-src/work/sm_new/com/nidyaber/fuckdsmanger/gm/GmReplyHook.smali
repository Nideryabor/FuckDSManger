.class public final Lcom/nidyaber/fuckdsmanger/gm/GmReplyHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmReplyHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    const-string p0, "[\u901a\u8bdd] nn1.A \u8fd4\u56de\uff08\u56de\u590d\u6d41\u63a2\u9488\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :try_start_5
    invoke-virtual {p1}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->getResult()Ljava/lang/Object;

    move-result-object v0

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v1, :cond_29

    invoke-virtual {v1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "we5"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "F"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->getStaticObjectField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    if-eq v0, v1, :cond_29

    const-string v2, "\u5f85\u673a\uff5c\u6309\u4f4f\u8bf4\u8bdd"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    const-string v2, "[\u901a\u8bdd] \u56de\u590d\u6d41\u7ed3\u675f\uff08nn1.A \u8fd4\u56de\uff09\u21d2 \u5f85\u673a"

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_29
    .catchall {:try_start_5 .. :try_end_29} :catchall_29

    :catchall_29
    :cond_29
    return-void
.end method
