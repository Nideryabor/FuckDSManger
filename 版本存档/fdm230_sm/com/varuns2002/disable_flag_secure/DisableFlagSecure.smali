.class public final Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;
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

.method private static hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V
    .registers 8

    :try_start_0
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    invoke-static {v0, p2, p3}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "hookM "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " count="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_33
    .catchall {:try_start_0 .. :try_end_33} :catchall_34

    goto :goto_3a

    :catchall_34
    move-exception v0

    const-string v1, "hookM FAIL "

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_3a
    return-void
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 9

    const-string v0, "FuckDSManger v1.0.8 ENTER stealth-row-mode"

    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "pkg="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    :try_start_1d
    const-string v1, "i65"

    const-string v2, "x"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "p96"

    const-string v2, "b"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmTraceHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmTraceHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getValue"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmVectorHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmVectorHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "early hooks registered"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    const-string v1, "com.deepseek.chat.MainActivity"

    const-string v2, "onResume"

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    new-instance v5, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;

    invoke-direct {v5}, Lcom/varuns2002/disable_flag_secure/gm/GmResumeHook;-><init>()V

    aput-object v5, v3, v4

    invoke-static {v1, v0, v2, v3}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    move-result-object v1

    const-string v1, "hooked MainActivity.onResume OK"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_5e
    .catchall {:try_start_1d .. :try_end_5e} :catchall_5f

    goto :goto_65

    :catchall_5f
    move-exception v1

    const-string v2, "hook onResume FAIL"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_65
    const-string v1, "lac5"

    const-string v2, "A"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmTextHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmTextHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "hw1"

    const-string v2, "a"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmClickHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmClickHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "hw1"

    const-string v2, "b"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmClickHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmClickHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getString"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmResTextHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmResTextHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getText"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmResTextHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmResTextHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "android.app.Activity"

    const-string v2, "dispatchTouchEvent"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmTouchHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmTouchHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "yu9"

    const-string v2, "m"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmRevokeHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmRevokeHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getDrawable"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmAvatarHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatarHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "androidx.activity.ComponentActivity"

    const-string v2, "onActivityResult"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "androidx.fragment.app.FragmentActivity"

    const-string v2, "onActivityResult"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "android.app.Activity"

    const-string v2, "onActivityResult"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "uv1"

    const-string v2, "u"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "vp4"

    const-string v2, "get"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook2;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook2;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "az5"

    const-string v2, "h"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getValue"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmVectorHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmVectorHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "i65"

    const-string v2, "x"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmPainterHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "p96"

    const-string v2, "b"

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmTraceHook;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmTraceHook;-><init>()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const-string v1, "vp4"

    const-class v2, Ljava/util/Map;

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook3;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook3;-><init>()V

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    aput-object v2, v4, v5

    const/4 v5, 0x1

    aput-object v3, v4, v5

    invoke-static {v1, v0, v4}, Lde/robv/android/xposed/XposedHelpers;->findAndHookConstructor(Ljava/lang/String;Ljava/lang/ClassLoader;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    const-string v1, "handleLoadPackage done"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method
