.class public final Lcom/nidyaber/fuckdsmanger/gm/GmTickHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmTickHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    const-string v0, "composable"

    const-string p0, "profile Composable tick() fired"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEntry;->tick()V

    return-void
.end method
