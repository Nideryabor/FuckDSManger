.class public final Lcom/nidyaber/fuckdsmanger/GmEntry;
.super Ljava/lang/Object;
.source "GmEntry.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# static fields
.field private static final GM:Ljava/lang/String; = "com.nidyaber.fuckdsmanger.gm."


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static hkAdd(Ljava/lang/String;Ljava/lang/String;I)V
    .registers 5

    .line 232
    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 233
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sHookInfo:Ljava/lang/String;

    if-eqz v1, :cond_c

    .line 234
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 235
    :cond_c
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "."

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " | "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 236
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/gm/GmCallDialog;->sHookInfo:Ljava/lang/String;
    :try_end_2a
    .catchall {:try_start_0 .. :try_end_2a} :catchall_2a

    :catchall_2a
    return-void
.end method

.method private static hookC2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V
    .registers 7

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    move-object p1, v0

    .line 198
    const-string v0, "<init>"

    .line 0
    const-string v1, "hookC2 "

    .line 198
    :try_start_9
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 199
    invoke-static {p2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lde/robv/android/xposed/XC_MethodHook;

    .line 200
    invoke-static {p0, p2}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->size()I

    move-result p0

    .line 201
    invoke-static {p1, v0, p0}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    .line 202
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".<init> count="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_39
    .catchall {:try_start_9 .. :try_end_39} :catchall_3a

    return-void

    :catchall_3a
    const/4 p0, -0x1

    .line 204
    invoke-static {p1, v0, p0}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method private static hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 8

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->method(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    move-object p1, v2

    move-object p2, v3

    .line 168
    const-string v0, "."

    .line 0
    const-string v1, "hookM "

    .line 168
    :try_start_e
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 169
    invoke-static {p3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lde/robv/android/xposed/XC_MethodHook;

    .line 170
    invoke-static {p0, p2, p3}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->size()I

    move-result p0

    .line 171
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " count="

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 172
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 173
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_44
    .catchall {:try_start_e .. :try_end_44} :catchall_45

    return-void

    :catchall_45
    move-exception p0

    .line 175
    new-instance p3, Ljava/lang/StringBuilder;

    const-string v1, "hookM FAIL "

    invoke-direct {p3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 176
    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 177
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static hookM2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 6

    .line 184
    const-string v0, "."

    .line 0
    const-string v1, "hookM2 "

    .line 184
    :try_start_4
    invoke-static {p1, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 185
    invoke-static {p3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lde/robv/android/xposed/XC_MethodHook;

    .line 186
    invoke-static {p0, p2, p3}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->size()I

    move-result p0

    .line 187
    invoke-static {p1, p2, p0}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    .line 188
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " count="

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_3a
    .catchall {:try_start_4 .. :try_end_3a} :catchall_3b

    return-void

    .line 190
    :catchall_3b
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p3, "hookM2 FAIL "

    invoke-direct {p0, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 p0, -0x1

    .line 191
    invoke-static {p1, p2, p0}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hkAdd(Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method private static hookPickAll(Ljava/lang/ClassLoader;)V
    .registers 4

    .line 211
    :try_start_0
    const-string v0, "android.app.Activity"

    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    const/4 v0, 0x0

    :goto_7
    if-eqz p0, :cond_1e

    .line 214
    const-string v1, "onActivityResult"

    new-instance v2, Lcom/nidyaber/fuckdsmanger/gm/GmPickHook;

    invoke-direct {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmPickHook;-><init>()V

    invoke-static {p0, v1, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->size()I

    move-result v1

    add-int/2addr v0, v1

    .line 215
    invoke-virtual {p0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;

    move-result-object p0

    goto :goto_7

    .line 217
    :cond_1e
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "FuckDSManger: pick hooks dynamic total="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_32
    .catchall {:try_start_0 .. :try_end_32} :catchall_33

    return-void

    :catchall_33
    move-exception p0

    .line 219
    const-string v0, "FuckDSManger: pick hooks dynamic FAIL"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 15

    .line 31
    const-string p0, "yp1"

    const-string v0, "FuckDSManger NL 2.22.112 handleLoadPackage ENTER"

    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 32
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCrashHook;->install()V

    .line 34
    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    .line 35
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "pkg="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 36
    :try_start_1d
    const-string v1, "kh7"

    iget-object v2, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;
    :try_end_24
    .catchall {:try_start_1d .. :try_end_24} :catchall_25

    goto :goto_35

    :catchall_25
    move-exception v1

    :try_start_26
    const-string v1, "qk7"

    iget-object v2, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;
    :try_end_2d
    .catchall {:try_start_26 .. :try_end_2d} :catchall_2e

    goto :goto_35

    :catchall_2e
    move-exception v1

    const-string v1, "[GATE] anchors kf5/uia missing - not host, skip"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 38
    :goto_35
    const-string v0, "===== NL 2.22.112 \u542f\u52a8 | \u65e5\u5fd7\uff1alogcat+DIAG+\u6587\u4ef6 \u4e09\u901a\u9053 \u00b7 \u8f6e\u8f6c256KB \u00b7 \u53ef\u8bfb\u65f6\u95f4\u6233 ====="

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 40
    iget-object p1, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    .line 41
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->envSafe(Ljava/lang/ClassLoader;)V

    .line 44
    const-string v0, "K"

    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmPainterHook"

    const-string v2, "kf5"

    invoke-static {p1, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 45
    const-string v0, "N"

    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmPaintModHook"

    const-string v2, "fh6"

    invoke-static {p1, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 46
    const-string v0, "me4"

    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmIconHook"

    const-string v2, "a"

    invoke-static {p1, v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 47
    const-string v0, "GmPaintModHook registered (fh6.N identity filter)"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    .line 48
    const-string v0, "getValue"

    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmVectorHook"

    const-string v3, "android.content.res.Resources"

    invoke-static {p1, v3, v0, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 49
    const-string v0, "early hooks registered"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    .line 52
    :try_start_6d
    const-string v0, "android.app.Activity"

    const-string v1, "onResume"

    new-instance v4, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;

    invoke-direct {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmResumeHook;-><init>()V

    filled-new-array {v4}, [Ljava/lang/Object;

    move-result-object v4

    invoke-static {v0, p1, v1, v4}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 53
    const-string v0, "hooked Activity.onResume OK"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_82
    .catchall {:try_start_6d .. :try_end_82} :catchall_83

    goto :goto_89

    :catchall_83
    move-exception v0

    .line 55
    const-string v1, "hook onResume FAIL"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 59
    :goto_89
    const-string v0, "getString"

    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmResTextHook"

    invoke-static {p1, v3, v0, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 60
    const-string v4, "getText"

    invoke-static {p1, v3, v4, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 61
    const-string v1, "q"

    const-string v5, "com.tencent.mmkv.MMKV"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmMmkvHook"

    invoke-static {p1, v5, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 62
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmCrashHook;->install()V

    .line 63
    const-string v1, "k"

    invoke-static {p1, v5, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "j"

    invoke-static {p1, v5, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "contains"

    invoke-static {p1, v5, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 64
    const-string v1, "android.app.Activity"

    const-string v5, "dispatchTouchEvent"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmTouchHook"

    invoke-static {p1, v1, v5, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 65
    const-string v1, "android.view.ViewGroup"

    invoke-static {p1, v1, v5, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 66
    const-string v1, "android.view.View"

    invoke-static {p1, v1, v5, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 69
    const-string v1, "m5"

    const-string v5, "com.nidyaber.fuckdsmanger.gm.GmEntryHook"

    const-string v6, "v"

    invoke-static {p1, v1, v6, v5}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 70
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmRevokeHook"

    const-string v5, "h91"

    invoke-static {p1, v5, v2, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 71
    const-string v1, "getDrawable"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmAvatarHook"

    invoke-static {p1, v3, v1, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 72
    const-string v1, "p5"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmUAvatarHook"

    invoke-static {p1, v1, v6, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 75
    const-string v1, "pn9"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmBubbleCellHook"

    const-string v8, "c"

    invoke-static {p1, v1, v8, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 76
    const-string v1, "ls9"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmUBubbleHook"

    const-string v9, "f"

    invoke-static {p1, v1, v9, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 77
    const-string v1, "uia"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmBubblePaintHook"

    invoke-static {p1, v1, v6, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 78
    const-string v10, "u"

    invoke-static {p1, v1, v10, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 79
    const-string v1, "tn0"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmBubbleFitHook"

    const-string v11, "b"

    invoke-static {p1, v1, v11, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 80
    const-string v1, "jd8"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmShadowHook"

    invoke-static {p1, v1, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookC2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    .line 81
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmAlphaHook"

    const-string v7, "se0"

    invoke-static {p1, v7, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookC2(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    .line 82
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmAlphaHook"

    invoke-static {p1, v7, v8, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 83
    const-string v1, "s"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmPageHook"

    const-string v12, "zc"

    invoke-static {p1, v12, v1, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 84
    const-string v1, "[\u6c14\u6ce1] AI \u6c14\u6ce1 hook \u6ce8\u518c\u5b8c\u6bd5\uff08pn9.c / uia.v / uia.u / tn0.b / jd8 / se0 / zc.s\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 87
    const-string v1, "s5"

    const-string v7, "com.nidyaber.fuckdsmanger.gm.GmNameHook"

    invoke-static {p1, v1, v6, v7}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 88
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookPickAll(Ljava/lang/ClassLoader;)V

    .line 91
    const-string v1, "h"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmDsHook"

    const-string v7, "p66"

    invoke-static {p1, v7, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 92
    const-string v1, "h02"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmDsHook"

    invoke-static {p1, v1, v10, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 95
    const-string v1, "I"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmCallHook"

    const-string v7, "ao1"

    invoke-static {p1, v7, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 96
    const-string v1, "J"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmCallHook"

    invoke-static {p1, v7, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 98
    :try_start_153
    invoke-static {v7, p1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 99
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallCtorHook;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmCallCtorHook;-><init>()V

    invoke-static {v1, v6}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 100
    const-string v1, "hook ctor ao1 OK"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_164
    .catchall {:try_start_153 .. :try_end_164} :catchall_165

    goto :goto_16a

    .line 102
    :catchall_165
    const-string v1, "hook ctor ao1 FAIL"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 105
    :goto_16a
    :try_start_16a
    invoke-static {v5, p1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 106
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallSeeHook;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmCallSeeHook;-><init>()V

    invoke-static {v1, v2, v6}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 107
    const-string v1, "hook h91.a (see ao1) OK"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 109
    invoke-static {p0, p1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 110
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmCallYpHook;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmCallYpHook;-><init>()V

    invoke-static {v1, v6}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 111
    const-string v1, "hook ctor yp1 (pair) OK"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_18c
    .catchall {:try_start_16a .. :try_end_18c} :catchall_18d

    goto :goto_192

    .line 113
    :catchall_18d
    const-string v1, "hook ctor yp1 (pair) FAIL"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 117
    :goto_192
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmAsrHook"

    invoke-static {p1, p0, v8, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 118
    const-string v1, "\u5df2\u505c\u7528 AudioRecord \u63a2\u9488\uff08\u72b6\u6001\u6539\u7531 PTT \u81ea\u884c\u8bbe\u7f6e\uff0c\u6559\u8bad 591\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 119
    const-string v1, "ASR \u63a2\u9488\u5df2\u6302\uff08yp1.c + AudioRecord\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 120
    const-string v1, "\u5df2\u505c\u7528 MediaPlayer/rj9 \u63a2\u9488\uff08\u6559\u8bad 591\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 121
    const-string v1, "TTS \u64ad\u653e\u63a2\u9488\u5df2\u6302\uff08MediaPlayer + \u5b8c\u6210\u56de\u8c03\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 122
    const-string v1, "\u5df2\u8df3\u8fc7 nn1.A \u94a9\u5b50\uff08\u5b83\u4f1a\u6253\u65ad\u53d1\u9001\u534f\u7a0b\uff0c\u6559\u8bad 577\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 123
    const-string v1, "\u5df2\u79fb\u9664 vq.S \u94a9\u5b50\uff08\u4f1a\u5f04\u574f\u5bbf\u4e3b\u6d88\u606f\u5217\u8868\uff0c\u6559\u8bad 581\uff09\uff1b\u6539\u7528\u8f6e\u8be2"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 126
    const-string v1, "get"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmDsHook2"

    const-string v8, "bx4"

    invoke-static {p1, v8, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 128
    :try_start_1be
    const-string v1, "py5"

    const-class v6, Ljava/util/Map;

    new-instance v8, Lcom/nidyaber/fuckdsmanger/gm/GmDsHook3;

    invoke-direct {v8}, Lcom/nidyaber/fuckdsmanger/gm/GmDsHook3;-><init>()V

    filled-new-array {v6, v8}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v1, p1, v6}, Lde/robv/android/xposed/XposedHelpers;->findAndHookConstructor(Ljava/lang/String;Ljava/lang/ClassLoader;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 129
    const-string v1, "hooked py5 init Map"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_1d3
    .catchall {:try_start_1be .. :try_end_1d3} :catchall_1d4

    goto :goto_1da

    :catchall_1d4
    move-exception v1

    .line 131
    const-string v6, "hook py5 init FAIL"

    invoke-static {v6, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 133
    :goto_1da
    const-string v1, "e"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmSuggestHook"

    const-string v8, "yb5"

    invoke-static {p1, v8, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 134
    const-string v1, "yb5"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmSuggestHook2"

    invoke-static {p1, v1, v9, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 135
    const-string v1, "I"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmPromptTextHook"

    const-string v8, "pd5"

    invoke-static {p1, v8, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 136
    const-string v1, "H"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmPromptTextHook"

    const-string v8, "pd5"

    invoke-static {p1, v8, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 137
    const-string v1, "isEmpty"

    const-string v6, "com.nidyaber.fuckdsmanger.gm.GmGateListHook"

    const-string v8, "hp8"

    invoke-static {p1, v8, v1, v6}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 139
    :try_start_205
    invoke-static {p0, p1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 140
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmGateHook;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmGateHook;-><init>()V

    invoke-static {v1, v6}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 141
    const-string v1, "hooked yp1 ctor (gate)"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_216
    .catchall {:try_start_205 .. :try_end_216} :catchall_217

    goto :goto_21d

    :catchall_217
    move-exception v1

    .line 143
    const-string v6, "hook yp1 ctor FAIL"

    invoke-static {v6, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 145
    :goto_21d
    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmSeeHook"

    invoke-static {p1, p0, v11, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 146
    const-string p0, "com.nidyaber.fuckdsmanger.gm.GmResIdHook"

    invoke-static {p1, v3, v0, p0}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 147
    const-string p0, "com.nidyaber.fuckdsmanger.gm.GmResIdHook"

    invoke-static {p1, v3, v4, p0}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 148
    const-string p0, "x"

    const-string v0, "wr"

    const-string v1, "com.nidyaber.fuckdsmanger.gm.GmSuggestAi"

    invoke-static {p1, v0, p0, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 149
    const-string p0, "z"

    invoke-static {p1, v0, p0, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 150
    invoke-static {p1, v5, v2, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 151
    const-string p0, "M"

    invoke-static {p1, v7, p0, v1}, Lcom/nidyaber/fuckdsmanger/GmEntry;->hookM(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 153
    :try_start_242
    invoke-static {v0, p1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 154
    new-instance p1, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestAi;

    invoke-direct {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmSuggestAi;-><init>()V

    invoke-static {p0, p1}, Lde/robv/android/xposed/XposedBridge;->hookAllConstructors(Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 155
    const-string p0, "hooked wr ctor (message container)"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_253
    .catchall {:try_start_242 .. :try_end_253} :catchall_254

    goto :goto_25a

    :catchall_254
    move-exception p0

    .line 157
    const-string p1, "hook wr ctor FAIL"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 159
    :goto_25a
    const-string p0, "suggest hooks registered (\u7a33\u5b9a\u57fa\u7ebf\uff1a\u65e0 MMKV \u63a5\u7ba1\u3001\u65e0\u914d\u7f6e dump)"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    .line 160
    const-string p0, "handleLoadPackage done"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    return-void
.end method
