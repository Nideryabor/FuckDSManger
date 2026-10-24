.class public final Lcom/nidyaber/fuckdsmanger/gm/GmCallCtorHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmCallCtorHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    # ★ 2026-10-02 wip「音频通话」停用：宿主官方语音通话（TRTC）已接管
    return-void
.end method

.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    # ★ 2026-10-02 wip「音频通话」停用：宿主官方语音通话（TRTC）已接管
    return-void
.end method
