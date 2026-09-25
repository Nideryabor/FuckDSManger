.class public final Lcom/nidyaber/fuckdsmanger/gm/GmCallSeeHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCallSeeHook.java"


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

    if-eqz v0, :cond_28

    array-length v1, v0

    const/4 v2, 0x0

    :goto_6
    if-ge v2, v1, :cond_28

    aget-object v3, v0, v2

    if-eqz v3, :cond_25

    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v4, "ao1"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_25

    sput-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sSeeA:Ljava/lang/Object;

    const-string v4, "see.ao1"

    const-string v5, "[\u901a\u8bdd] \u6355\u83b7\u5230\u6e32\u67d3\u4e2d\u7684 ao1\uff08\u5f53\u524d\u4f1a\u8bdd component\uff09"

    invoke-static {v4, v5}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_25
    add-int/lit8 v2, v2, 0x1

    goto :goto_6
    :try_end_28
    .catchall {:try_start_0 .. :try_end_28} :catchall_29

    :cond_28
    return-void

    :catchall_29
    move-exception v0

    return-void
.end method
