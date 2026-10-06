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

.method private static hkAdd(Ljava/lang/String;Ljava/lang/String;I)V
    .registers 6

    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sHookInfo:Ljava/lang/String;

    if-nez v1, :cond_c

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_c
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " | "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sHookInfo:Ljava/lang/String;
    :try_end_2a
    .catchall {:try_start_0 .. :try_end_2a} :catchall_2a

    :catchall_2a
    return-void
.end method

.method private static hookC2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V
    .registers 8

    :try_start_0
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    invoke-static {p2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lde/robv/android/xposed/XC_MethodHook;

    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0

    const-string v2, "<init>"

    invoke-static {p1, v2, v0}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "hookC2 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ".<init> count="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_37
    .catchall {:try_start_0 .. :try_end_37} :catchall_38

    return-void

    :catchall_38
    const-string v0, "<init>"

    const/4 v1, -0x1

    invoke-static {p1, v0, v1}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method private static hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 8

    :try_start_0
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    invoke-static {p3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lde/robv/android/xposed/XC_MethodHook;

    invoke-static {v0, p2, v1}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

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
    :try_end_3d
    .catchall {:try_start_0 .. :try_end_3d} :catchall_3e

    return-void

    :catchall_3e
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "hookM FAIL "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static hookM2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 10

    :try_start_0
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    invoke-static {p3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lde/robv/android/xposed/XC_MethodHook;

    invoke-static {v0, p2, v1}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0

    invoke-static {p1, p2, v0}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "hookM2 "

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
    :try_end_3d
    .catchall {:try_start_0 .. :try_end_3d} :catchall_3e

    return-void

    :catchall_3e
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "hookM2 FAIL "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v0, -0x1

    invoke-static {p1, p2, v0}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method private static hookPickAll(Ljava/lang/ClassLoader;)V
    .registers 6

    :try_start_0
    const-string v0, "com.deepseek.chat.MainActivity"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    const/4 v1, 0x0

    :goto_7
    if-eqz v0, :cond_1e

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;

    invoke-direct {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmPickHook;-><init>()V

    const-string v3, "onActivityResult"

    invoke-static {v0, v3, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->size()I

    move-result v2

    add-int/2addr v1, v2

    invoke-virtual {v0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object v0

    goto :goto_7

    :cond_1e
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "FuckDSManger: pick hooks dynamic total="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_32
    .catchall {:try_start_0 .. :try_end_32} :catchall_33

    return-void

    :catchall_33
    move-exception v0

    const-string v1, "FuckDSManger: pick hooks dynamic FAIL"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 9

    const-string v0, "FuckDSManger NL 2.22.110 handleLoadPackage ENTER"

    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;->install()V

    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "pkg="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "com.deepseek.chat"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_27

    return-void

    :cond_27
    const-string v0, "===== NL 2.22.110 \u542f\u52a8 | \u65e5\u5fd7\uff1alogcat+DIAG+\u6587\u4ef6 \u4e09\u901a\u9053 \u00b7 \u8f6e\u8f6c256KB \u00b7 \u53ef\u8bfb\u65f6\u95f4\u6233 ====="

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->envSafe(Ljava/lang/ClassLoader;)V

    const-string v1, "kf5"

    const-string v2, "K"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmPainterHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "fh6"

    const-string v2, "N"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmPaintModHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "me4"

    const-string v2, "a"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmIconHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "GmPaintModHook registered (fh6.N identity filter)"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getValue"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmVectorHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "early hooks registered"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    :try_start_5f
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
    :try_end_77
    .catchall {:try_start_5f .. :try_end_77} :catchall_78

    goto :goto_7e

    :catchall_78
    move-exception v1

    const-string v2, "hook onResume FAIL"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_7e
    const-string v1, "android.content.res.Resources"

    const-string v2, "getString"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmResTextHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getText"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmResTextHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "com.tencent.mmkv.MMKV"

    const-string v2, "q"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmMmkvHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "com.tencent.mmkv.MMKV"

    const-string v2, "k"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmMmkvHook"

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCrashHook;->install()V

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "android.app.Activity"

    const-string v2, "dispatchTouchEvent"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmTouchHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "android.view.ViewGroup"

    const-string v2, "dispatchTouchEvent"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmTouchHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "android.view.View"

    const-string v2, "dispatchTouchEvent"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmTouchHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "m5"

    const-string v2, "v"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmEntryHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "h91"

    const-string v2, "a"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmRevokeHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getDrawable"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmAvatarHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "p5"

    const-string v2, "v"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmUAvatarHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "pn9"

    const-string v2, "c"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmBubbleCellHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "ls9"

    const-string v2, "f"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmUBubbleHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "uia"

    const-string v2, "v"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmBubblePaintHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "uia"

    const-string v2, "u"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmBubblePaintHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "tn0"

    const-string v2, "b"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmBubbleFitHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "jd8"

    const-string v2, "com.varuns2002.disable_flag_secure.gm.GmShadowHook"

    invoke-static {v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookC2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "se0"

    const-string v2, "com.varuns2002.disable_flag_secure.gm.GmAlphaHook"

    invoke-static {v0, v1, v2}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookC2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "se0"

    const-string v2, "c"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmAlphaHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "zc"

    const-string v2, "s"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmPageHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "[\u6c14\u6ce1] AI \u6c14\u6ce1 hook \u6ce8\u518c\u5b8c\u6bd5\uff08pn9.c / uia.v / uia.u / tn0.b / jd8 / se0 / zc.s\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "s5"

    const-string v2, "v"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmNameHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookPickAll(Ljava/lang/ClassLoader;)V

    const-string v1, "p66"

    const-string v2, "h"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmDsHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "h02"

    const-string v2, "u"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmDsHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "ao1"

    const-string v2, "I"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmCallHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "ao1"

    const-string v2, "J"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmCallHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :try_start_166
    const-string v1, "ao1"

    invoke-static {v1, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallCtorHook;

    invoke-direct {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmCallCtorHook;-><init>()V

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    const-string v1, "hook ctor ao1 OK"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_179
    .catchall {:try_start_166 .. :try_end_179} :catchall_17a

    goto :goto_180

    :catchall_17a
    move-exception v1

    const-string v1, "hook ctor ao1 FAIL"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_180
    :try_start_180
    const-string v1, "h91"

    invoke-static {v1, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallSeeHook;

    invoke-direct {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmCallSeeHook;-><init>()V

    const-string v3, "a"

    invoke-static {v1, v3, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    const-string v1, "hook h91.a (see ao1) OK"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "yp1"

    invoke-static {v1, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallYpHook;

    invoke-direct {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmCallYpHook;-><init>()V

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    const-string v1, "hook ctor yp1 (pair) OK"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_1a8
    .catchall {:try_start_180 .. :try_end_1a8} :catchall_1a9

    goto :goto_1af

    :catchall_1a9
    move-exception v1

    const-string v1, "hook ctor yp1 (pair) FAIL"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_1af
    const-string v1, "yp1"

    const-string v2, "c"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmAsrHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "\u5df2\u505c\u7528 AudioRecord \u63a2\u9488\uff08\u72b6\u6001\u6539\u7531 PTT \u81ea\u884c\u8bbe\u7f6e\uff0c\u6559\u8bad 591\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "ASR \u63a2\u9488\u5df2\u6302\uff08yp1.c + AudioRecord\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "\u5df2\u505c\u7528 MediaPlayer/rj9 \u63a2\u9488\uff08\u6559\u8bad 591\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "TTS \u64ad\u653e\u63a2\u9488\u5df2\u6302\uff08MediaPlayer + \u5b8c\u6210\u56de\u8c03\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "\u5df2\u8df3\u8fc7 nn1.A \u94a9\u5b50\uff08\u5b83\u4f1a\u6253\u65ad\u53d1\u9001\u534f\u7a0b\uff0c\u6559\u8bad 577\uff09"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "\u5df2\u79fb\u9664 vq.S \u94a9\u5b50\uff08\u4f1a\u5f04\u574f\u5bbf\u4e3b\u6d88\u606f\u5217\u8868\uff0c\u6559\u8bad 581\uff09\uff1b\u6539\u7528\u8f6e\u8be2"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "bx4"

    const-string v2, "get"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmDsHook2"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :try_start_1df
    const-string v1, "bx4"

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

    const-string v1, "hooked bx4 init Map"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_1f9
    .catchall {:try_start_1df .. :try_end_1f9} :catchall_1fa

    goto :goto_200

    :catchall_1fa
    move-exception v1

    const-string v2, "hook bx4 init FAIL"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_200
    const-string v1, "yb5"

    const-string v2, "e"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmSuggestHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "yb5"

    const-string v2, "f"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmSuggestHook2"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "pd5"

    const-string v2, "I"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmPromptTextHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "pd5"

    const-string v2, "H"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmPromptTextHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "hp8"

    const-string v2, "isEmpty"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmGateListHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :try_start_22d
    const-string v1, "yp1"

    invoke-static {v1, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmGateHook;

    invoke-direct {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmGateHook;-><init>()V

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v1

    const-string v1, "hooked yp1 ctor (gate)"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_241
    .catchall {:try_start_22d .. :try_end_241} :catchall_242

    goto :goto_248

    :catchall_242
    move-exception v1

    const-string v2, "hook yp1 ctor FAIL"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_248
    const-string v1, "yp1"

    const-string v2, "b"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmSeeHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getString"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmResIdHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "android.content.res.Resources"

    const-string v2, "getText"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmResIdHook"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "wr"

    const-string v2, "x"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmSuggestAi"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "wr"

    const-string v2, "z"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmSuggestAi"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "h91"

    const-string v2, "a"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmSuggestAi"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "ao1"

    const-string v2, "M"

    const-string v3, "com.varuns2002.disable_flag_secure.gm.GmSuggestAi"

    invoke-static {v0, v1, v2, v3}, Lcom/varuns2002/disable_flag_secure/DisableFlagSecure;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :try_start_287
    const-string v1, "wr"

    invoke-static {v1, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestAi;

    invoke-direct {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestAi;-><init>()V

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    const-string v1, "hooked wr ctor (message container)"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_29a
    .catchall {:try_start_287 .. :try_end_29a} :catchall_29b

    goto :goto_2a1

    :catchall_29b
    move-exception v1

    const-string v2, "hook wr ctor FAIL"

    invoke-static {v2, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_2a1
    const-string v1, "suggest hooks registered (\u7a33\u5b9a\u57fa\u7ebf\uff1a\u65e0 MMKV \u63a5\u7ba1\u3001\u65e0\u914d\u7f6e dump)"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    const-string v1, "handleLoadPackage done"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method
