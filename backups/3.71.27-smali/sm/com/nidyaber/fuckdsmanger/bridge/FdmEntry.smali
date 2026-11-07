.class public final Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;
.super Ljava/lang/Object;
.source "FdmEntry.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# static fields
.field private static final BASE_ENTRY:Ljava/lang/String; = "com.nidyaber.fuckdsmanger.GmEntry"

.field private static final HOST_ANCHORS:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 3

    .line 46
    const-string v0, "uia"

    const-string v1, "fh6"

    const-string v2, "kf5"

    filled-new-array {v2, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->HOST_ANCHORS:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static isHost(Ljava/lang/ClassLoader;)Z
    .registers 6

    .line 50
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->HOST_ANCHORS:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_5
    if-ge v3, v1, :cond_15

    aget-object v4, v0, v3

    .line 52
    :try_start_9
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;
    :try_end_10
    .catchall {:try_start_9 .. :try_end_10} :catchall_12

    const/4 p0, 0x1

    return p0

    :catchall_12
    add-int/lit8 v3, v3, 0x1

    goto :goto_5

    :cond_15
    return v2
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 10

    .line 63
    const-string p0, "onCreate"

    const-class v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;

    .line 0
    const-string v1, "[FDM] HTML \u6e32\u67d3\uff1a"

    const-string v2, "[FDM] AI\u6c14\u6ce1\u5bcc\u6587\u672c\uff1a"

    .line 63
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "[FDM] FdmEntry.handleLoadPackage pkg="

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v4, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 65
    iget-object v3, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result v3

    if-eqz v3, :cond_76

    .line 70
    :try_start_23
    const-string v3, "android.app.Application"

    iget-object v4, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/FdmHostReadyHook;

    invoke-direct {v5}, Lcom/nidyaber/fuckdsmanger/bridge/FdmHostReadyHook;-><init>()V

    filled-new-array {v5}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v3, v4, p0, v5}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 72
    const-string v3, "[FDM] \u63a2\u6865\u94a9\u5b50\u5df2\u6302\uff08Application.onCreate\uff09"

    invoke-static {v3}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_38
    .catchall {:try_start_23 .. :try_end_38} :catchall_39

    goto :goto_8e

    :catchall_39
    move-exception v3

    .line 75
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "[FDM] \u63a2\u6865\u94a9\u5b50\uff08Application\uff09\u6302\u8f7d\u5931\u8d25\uff0c\u9000\u5230 Activity\uff1a"

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 77
    :try_start_4b
    const-string v3, "android.app.Activity"

    iget-object v4, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    const-class v5, Landroid/os/Bundle;

    new-instance v6, Lcom/nidyaber/fuckdsmanger/bridge/FdmHostReadyHook;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/bridge/FdmHostReadyHook;-><init>()V

    filled-new-array {v5, v6}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v3, v4, p0, v5}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 79
    const-string p0, "[FDM] \u63a2\u6865\u5907\u7528\u94a9\u5b50\u5df2\u6302\uff08Activity.onCreate\uff09"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_62
    .catchall {:try_start_4b .. :try_end_62} :catchall_63

    goto :goto_8e

    :catchall_63
    move-exception p0

    .line 81
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "[FDM] \u63a2\u6865\u5907\u7528\u94a9\u5b50\u6302\u8f7d\u5931\u8d25\uff1a"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    goto :goto_8e

    .line 85
    :cond_76
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v3, "[FDM] \u951a\u70b9\u4e0d\u5728 \u21d2 \u4e0d\u662f\u5bbf\u4e3b\uff0c\u8df3\u8fc7\u63a2\u6865\uff08pkg="

    invoke-direct {p0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v3, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\uff09"

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 89
    :goto_8e
    :try_start_8e
    const-string p0, "com.nidyaber.fuckdsmanger.GmEntry"

    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v3

    const/4 v4, 0x1

    invoke-static {p0, v4, v3}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    const/4 v3, 0x0

    .line 90
    new-array v5, v3, [Ljava/lang/Class;

    const/4 v5, 0x0

    invoke-virtual {p0, v5}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v6

    invoke-virtual {v6, v5}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 91
    const-string v6, "handleLoadPackage"

    new-array v4, v4, [Ljava/lang/Class;

    const-class v7, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;

    aput-object v7, v4, v3

    invoke-virtual {p0, v6, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    filled-new-array {p1}, [Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {p0, v5, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 92
    const-string p0, "[FDM] \u5df2\u8f6c\u53d1\u7ed9\u5e95\u5ea7\u5165\u53e3 com.nidyaber.fuckdsmanger.GmEntry \u2713"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_bd
    .catchall {:try_start_8e .. :try_end_bd} :catchall_be

    goto :goto_d0

    :catchall_be
    move-exception p0

    .line 94
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "[FDM] \u274c \u8f6c\u53d1\u5e95\u5ea7\u5165\u53e3\u5931\u8d25\uff1a"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 101
    :goto_d0
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_f5

    .line 103
    :try_start_d8
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCatchUp;->install(Ljava/lang/ClassLoader;)V

    .line 104
    const-string p0, "[FDM] \u8fdf\u5230\u7ed1\u5b9a\u63a2\u9488\u5df2\u6392\u961f\uff08\u51b7\u542f\u52a8\u8865\u4e00\u6b21 resume \u94fe\uff09"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_e2
    .catchall {:try_start_d8 .. :try_end_e2} :catchall_e3

    goto :goto_f5

    :catchall_e3
    move-exception p0

    .line 106
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "[FDM] GmCatchUp.install \u629b\u4e86\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 114
    :cond_f5
    :goto_f5
    :try_start_f5
    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmUiHook;->install(Ljava/lang/ClassLoader;)V
    :try_end_fc
    .catchall {:try_start_f5 .. :try_end_fc} :catchall_fd

    goto :goto_10f

    :catchall_fd
    move-exception p0

    .line 116
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "[FDM] FdmUiHook.install \u629b\u4e86\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 120
    :goto_10f
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_134

    .line 122
    :try_start_117
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmProbe;->install(Ljava/lang/ClassLoader;)V

    .line 123
    const-string p0, "[FDM] GmProbe \u5df2\u5b89\u88c5"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_121
    .catchall {:try_start_117 .. :try_end_121} :catchall_122

    goto :goto_134

    :catchall_122
    move-exception p0

    .line 125
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "[FDM] GmProbe \u5b89\u88c5\u5931\u8d25\uff1a"

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 133
    :cond_134
    :goto_134
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_154

    .line 135
    :try_start_13c
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmCallPin;->install(Ljava/lang/ClassLoader;)V
    :try_end_141
    .catchall {:try_start_13c .. :try_end_141} :catchall_142

    goto :goto_154

    :catchall_142
    move-exception p0

    .line 137
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "[FDM] GmCallPin.install \u629b\u4e86\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 146
    :cond_154
    :goto_154
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_179

    .line 148
    :try_start_15c
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHook;->install(Ljava/lang/ClassLoader;)I

    .line 149
    const-string p0, "[FDM] \u7cfb\u7edf\u63d0\u793a\u8bcd\u6ce8\u5165\u5df2\u5b89\u88c5"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_166
    .catchall {:try_start_15c .. :try_end_166} :catchall_167

    goto :goto_179

    :catchall_167
    move-exception p0

    .line 151
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "[FDM] \u7cfb\u7edf\u63d0\u793a\u8bcd\u6ce8\u5165\u5b89\u88c5\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 171
    :cond_179
    :goto_179
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_19e

    .line 173
    :try_start_181
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->install(Ljava/lang/ClassLoader;)V

    .line 174
    const-string p0, "[FDM] \u63d0\u793a\u8bcd\u663e\u793a\u4fa7\u9690\u85cf\u5df2\u5b89\u88c5"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_18b
    .catchall {:try_start_181 .. :try_end_18b} :catchall_18c

    goto :goto_19e

    :catchall_18c
    move-exception p0

    .line 176
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "[FDM] \u63d0\u793a\u8bcd\u663e\u793a\u4fa7\u9690\u85cf\u5b89\u88c5\u5931\u8d25\uff1a"

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 189
    :cond_19e
    :goto_19e
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_1d1

    .line 191
    :try_start_1a6
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->install(Ljava/lang/ClassLoader;)I

    .line 192
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmRichTextHook;->status()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_1be
    .catchall {:try_start_1a6 .. :try_end_1be} :catchall_1bf

    goto :goto_1d1

    :catchall_1bf
    move-exception p0

    .line 194
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "[FDM] AI\u6c14\u6ce1\u5bcc\u6587\u672c\u5b89\u88c5\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 218
    :cond_1d1
    :goto_1d1
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_204

    .line 220
    :try_start_1d9
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->install(Ljava/lang/ClassLoader;)I

    .line 221
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->status()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_1f1
    .catchall {:try_start_1d9 .. :try_end_1f1} :catchall_1f2

    goto :goto_204

    :catchall_1f2
    move-exception p0

    .line 223
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "[FDM] HTML \u6e32\u67d3\u5b89\u88c5\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 229
    :cond_204
    :goto_204
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_229

    .line 231
    :try_start_20c
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassInstall;->install(Ljava/lang/ClassLoader;)V

    .line 232
    const-string p0, "[FDM] \u6db2\u6001\u73bb\u7483\u5df2\u5b89\u88c5"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_216
    .catchall {:try_start_20c .. :try_end_216} :catchall_217

    goto :goto_229

    :catchall_217
    move-exception p0

    .line 234
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "[FDM] \u6db2\u6001\u73bb\u7483\u5b89\u88c5\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 243
    :cond_229
    :goto_229
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_24e

    .line 245
    :try_start_231
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->install(Ljava/lang/ClassLoader;)V

    .line 246
    const-string p0, "[FDM] \u60ac\u6d6e\u4fbf\u7b7e\u5df2\u5b89\u88c5"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_23b
    .catchall {:try_start_231 .. :try_end_23b} :catchall_23c

    goto :goto_24e

    :catchall_23c
    move-exception p0

    .line 248
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "[FDM] \u60ac\u6d6e\u4fbf\u7b7e\u5b89\u88c5\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 256
    :cond_24e
    :goto_24e
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmEntry;->isHost(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_273

    .line 258
    :try_start_256
    iget-object p0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->install(Ljava/lang/ClassLoader;)V

    .line 259
    const-string p0, "[FDM] \u8ff7\u4f60\u64ad\u653e\u6761\u5df2\u5b89\u88c5"

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_260
    .catchall {:try_start_256 .. :try_end_260} :catchall_261

    goto :goto_273

    :catchall_261
    move-exception p0

    .line 261
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "[FDM] \u8ff7\u4f60\u64ad\u653e\u6761\u5b89\u88c5\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u5176\u5b83\u94a9\u5b50\uff09\uff1a"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    :cond_273
    :goto_273
    return-void
.end method
