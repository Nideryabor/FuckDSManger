.class public final Lcom/little_femaleboy/cannot_show/the_big_won_whale/DisableFlagSecure;
.super Ljava/lang/Object;
.source "DisableFlagSecure.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 3

    const-string v0, "FuckDSManger v1.0.5 [NEWPKG-ENTRY] handleLoadPackage ENTER"

    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    new-instance v0, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;

    invoke-direct {v0}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;-><init>()V

    invoke-virtual {v0, p1}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V

    return-void
.end method
