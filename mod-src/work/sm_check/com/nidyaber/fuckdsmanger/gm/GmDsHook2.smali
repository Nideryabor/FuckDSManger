.class public final Lcom/nidyaber/fuckdsmanger/gm/GmDsHook2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmDsHook2.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-eqz v0, :cond_15

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-eqz v1, :cond_15

    const-string v2, "a"

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    if-eqz v1, :cond_15

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDs;->dump(Landroid/content/Context;Ljava/util/Map;)V

    :cond_15
    return-void
.end method
