.class public final Lcom/nidyaber/fuckdsmanger/gm/GmEnv;
.super Ljava/lang/Object;
.source "GmEnv.java"


# static fields
.field private static BAD:[Ljava/lang/String;

.field private static PKG:[Ljava/lang/String;

.field private static sApi:Z

.field private static sCl:Ljava/lang/ClassLoader;

.field private static sInit:Z

.field private static sOn:Z

.field private static sToast:Z


# direct methods
.method static constructor <clinit>()V
    .registers 4

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sOn:Z

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sApi:Z

    const/16 v0, 0x29

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "/su/bin/su"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "/sbin/su"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "/system/bin/su"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "/system/xbin/su"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "/system/sbin/su"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "/vendor/bin/su"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "/data/local/su"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "/data/local/bin/su"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "/data/local/xbin/su"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "/data/local/tmp/su"

    aput-object v2, v0, v1

    const/16 v1, 0xa

    const-string v2, "/system/bin/failsafe/su"

    aput-object v2, v0, v1

    const/16 v1, 0xb

    const-string v2, "/system/sd/xbin/su"

    aput-object v2, v0, v1

    const/16 v1, 0xc

    const-string v2, "/system/usr/we-need-root/su"

    aput-object v2, v0, v1

    const/16 v1, 0xd

    const-string v2, "/cache/su"

    aput-object v2, v0, v1

    const/16 v1, 0xe

    const-string v2, "/dev/su"

    aput-object v2, v0, v1

    const/16 v1, 0xf

    const-string v2, "/init.d/su"

    aput-object v2, v0, v1

    const/16 v1, 0x10

    const-string v2, "/magisk"

    aput-object v2, v0, v1

    const/16 v1, 0x11

    const-string v2, "/sbin/.magisk"

    aput-object v2, v0, v1

    const/16 v1, 0x12

    const-string v2, "/data/adb/magisk"

    aput-object v2, v0, v1

    const/16 v1, 0x13

    const-string v2, "/data/adb/ksu"

    aput-object v2, v0, v1

    const/16 v1, 0x14

    const-string v2, "/data/adb/modules"

    aput-object v2, v0, v1

    const/16 v1, 0x15

    const-string v2, "/data/adb/lspd"

    aput-object v2, v0, v1

    const/16 v1, 0x16

    const-string v2, "/system/xbin/daemonsu"

    aput-object v2, v0, v1

    const/16 v1, 0x17

    const-string v2, "/system/xbin/busybox"

    aput-object v2, v0, v1

    const/16 v1, 0x18

    const-string v2, "/system/bin/busybox"

    aput-object v2, v0, v1

    const/16 v1, 0x19

    const-string v2, "/system/bin/.ext"

    aput-object v2, v0, v1

    const/16 v1, 0x1a

    const-string v2, "/system/lib/libsuperuser.so"

    aput-object v2, v0, v1

    const/16 v1, 0x1b

    const-string v2, "/supersu"

    aput-object v2, v0, v1

    const/16 v1, 0x1c

    const-string v2, "/superuser.apk"

    aput-object v2, v0, v1

    const/16 v1, 0x1d

    const-string v2, "magisk"

    aput-object v2, v0, v1

    const/16 v1, 0x1e

    const-string v2, "busybox"

    aput-object v2, v0, v1

    const/16 v1, 0x1f

    const-string v2, "xposed"

    aput-object v2, v0, v1

    const/16 v1, 0x20

    const-string v2, "lsposed"

    aput-object v2, v0, v1

    const/16 v1, 0x21

    const-string v2, "edxposed"

    aput-object v2, v0, v1

    const/16 v1, 0x22

    const-string v2, "riru"

    aput-object v2, v0, v1

    const/16 v1, 0x23

    const-string v2, "shamiko"

    aput-object v2, v0, v1

    const/16 v1, 0x24

    const-string v2, "kernelsu"

    aput-object v2, v0, v1

    const/16 v1, 0x25

    const-string v2, "propid"

    aput-object v2, v0, v1

    const/16 v1, 0x26

    const-string v2, "zygisk"

    aput-object v2, v0, v1

    const/16 v1, 0x27

    const-string v2, "daemonsu"

    aput-object v2, v0, v1

    const/16 v1, 0x28

    const-string v2, "supersu"

    aput-object v2, v0, v1

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->BAD:[Ljava/lang/String;

    const/16 v0, 0x18

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "org.lsposed.manager"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "de.robv.android.xposed.installer"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "com.topjohnwu.magisk"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "eu.chainfire.supersu"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "com.noshufou.android.su"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "com.noshufou.android.su.elite"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "com.koushikdutta.superuser"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "com.thirdparty.superuser"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "com.yellowes.su"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "com.kingroot.kinguser"

    aput-object v2, v0, v1

    const/16 v1, 0xa

    const-string v2, "com.kingo.root"

    aput-object v2, v0, v1

    const/16 v1, 0xb

    const-string v2, "com.smedialink.oneclickroot"

    aput-object v2, v0, v1

    const/16 v1, 0xc

    const-string v2, "com.zhiqupk.root.global"

    aput-object v2, v0, v1

    const/16 v1, 0xd

    const-string v2, "com.alephzain.framaroot"

    aput-object v2, v0, v1

    const/16 v1, 0xe

    const-string v2, "me.weishu.kernelsu"

    aput-object v2, v0, v1

    const/16 v1, 0xf

    const-string v2, "com.ramdroid.appquarantine"

    aput-object v2, v0, v1

    const/16 v1, 0x10

    const-string v2, "com.little_femaleboy.cannot_show.the_big_won_whale"

    aput-object v2, v0, v1

    const/16 v1, 0x11

    const-string v2, "com.devadvance.rootcloak"

    aput-object v2, v0, v1

    const/16 v1, 0x12

    const-string v2, "com.devadvance.rootcloakplus"

    aput-object v2, v0, v1

    const/16 v1, 0x13

    const-string v2, "com.formyhm.hideroot"

    aput-object v2, v0, v1

    const/16 v1, 0x14

    const-string v2, "com.amphoras.hidemyroot"

    aput-object v2, v0, v1

    const/16 v1, 0x15

    const-string v2, "com.saurik.substrate"

    aput-object v2, v0, v1

    const/16 v1, 0x16

    const-string v2, "com.termux"

    aput-object v2, v0, v1

    const/16 v1, 0x17

    const-string v2, "com.zachspong.temprootremovejb"

    aput-object v2, v0, v1

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->PKG:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static bad(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x0

    if-eqz p0, :cond_1a

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->BAD:[Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    const/4 v2, 0x0

    :goto_a
    array-length v3, v1

    if-ge v2, v3, :cond_1a

    aget-object v3, v1, v2

    invoke-virtual {p0, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_17

    const/4 v0, 0x1

    return v0

    :cond_17
    add-int/lit8 v2, v2, 0x1

    goto :goto_a

    :cond_1a
    return v0
.end method

.method public static badCmd(Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0

    if-eqz p0, :cond_6b

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v1

    const-string v2, "sh -c "

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1c

    const/4 v2, 0x6

    invoke-virtual {v1, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    :cond_1c
    const-string v2, "su"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_26

    const/4 v0, 0x1

    return v0

    :cond_26
    const-string v2, "su "

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_30

    const/4 v0, 0x1

    return v0

    :cond_30
    const-string v2, "/su"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_3a

    const/4 v0, 0x1

    return v0

    :cond_3a
    const-string v2, "which su"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_44

    const/4 v0, 0x1

    return v0

    :cond_44
    const-string v2, "magisk"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_4e

    const/4 v0, 0x1

    return v0

    :cond_4e
    const-string v2, "daemonsu"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_58

    const/4 v0, 0x1

    return v0

    :cond_58
    const-string v2, "supersu"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_62

    const/4 v0, 0x1

    return v0

    :cond_62
    const-string v2, "busybox"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_6b

    const/4 v0, 0x1

    :cond_6b
    return v0
.end method

.method public static badPkg(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x0

    if-eqz p0, :cond_1a

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->PKG:[Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    const/4 v2, 0x0

    :goto_a
    array-length v3, v1

    if-ge v2, v3, :cond_1a

    aget-object v3, v1, v2

    invoke-virtual {p0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_17

    const/4 v0, 0x1

    return v0

    :cond_17
    add-int/lit8 v2, v2, 0x1

    goto :goto_a

    :cond_1a
    return v0
.end method

.method private static h(Ljava/lang/String;Ljava/lang/String;I)V
    .registers 4

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvHook;

    invoke-direct {v0, p2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvHook;-><init>(I)V

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    return-void
.end method

.method private static h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V
    .registers 6

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sCl:Ljava/lang/ClassLoader;

    invoke-static {p0, v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    invoke-static {v0, p1, p2}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "env hook "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "#"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V
    :try_end_32
    .catchall {:try_start_0 .. :try_end_32} :catchall_33

    return-void

    :catchall_33
    move-exception v0

    const-string v1, "env hook FAIL"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static hookRoot()V
    .registers 5

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvFileHook;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvFileHook;-><init>()V

    const-string v1, "java.io.File"

    const-string v2, "exists"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const/4 v3, 0x0

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;-><init>(I)V

    const-string v1, "android.app.ApplicationPackageManager"

    const-string v2, "getPackageInfo"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;-><init>(I)V

    const-string v1, "android.app.ApplicationPackageManager"

    const-string v2, "getApplicationInfo"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const/4 v3, 0x1

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;-><init>(I)V

    const-string v1, "android.app.ApplicationPackageManager"

    const-string v2, "getInstalledPackages"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPmHook;-><init>(I)V

    const-string v1, "android.app.ApplicationPackageManager"

    const-string v2, "getInstalledApplications"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const/4 v3, 0x0

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvExecHook;

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvExecHook;-><init>(I)V

    const-string v1, "java.lang.Runtime"

    const-string v2, "exec"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    const/4 v3, 0x1

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvExecHook;

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvExecHook;-><init>(I)V

    const-string v1, "java.lang.ProcessBuilder"

    const-string v2, "start"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPropHook;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvPropHook;-><init>()V

    const-string v1, "android.os.SystemProperties"

    const-string v2, "get"

    invoke-static {v1, v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h2(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    :try_start_64
    const-string v0, "android.os.Build"

    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sCl:Ljava/lang/ClassLoader;

    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    const-string v1, "TAGS"

    const-string v2, "release-keys"

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->setStaticObjectField(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_73
    .catchall {:try_start_64 .. :try_end_73} :catchall_74

    return-void

    :catchall_74
    move-exception v0

    const-string v1, "env buildtags FAIL"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static hookShumei()V
    .registers 3

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l111l11111lIl"

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l111l11111I1l"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l111l11111Il"

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l111l1111l1Il"

    const/4 v2, 0x2

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l111l1111llIl"

    const/4 v2, 0x3

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l111l1111lI1l"

    const/4 v2, 0x4

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l111l11IlIlIl"

    const/4 v2, 0x4

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l11l1111I11l"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l11l1111Ill"

    const/4 v2, 0x3

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l11l1111lIIl"

    const/4 v2, 0x3

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l11l111l11Il"

    const/4 v2, 0x4

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l11l111l1lll"

    const/4 v2, 0x4

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "com.ishumei.smantifraud.l1111l111111Il"

    const-string v1, "l11l11IlIIll"

    const/4 v2, 0x5

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v0, "sr9"

    const-string v1, "w"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->h(Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 3

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sInit:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sInit:Z

    sput-object p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sCl:Ljava/lang/ClassLoader;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->hookShumei()V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->hookRoot()V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->install(Ljava/lang/ClassLoader;)V

    const-string v0, "GmEnv installed"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_24

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->refresh(Landroid/content/Context;)V

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->toastOnce(Landroid/content/Context;)V

    :cond_24
    return-void
.end method

.method public static isApi()Z
    .registers 1

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sApi:Z

    return v0
.end method

.method public static isOn()Z
    .registers 1

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sOn:Z

    return v0
.end method

.method public static onResume(Landroid/app/Activity;)V
    .registers 1

    if-eqz p0, :cond_8

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->refresh(Landroid/content/Context;)V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->toastOnce(Landroid/content/Context;)V

    :cond_8
    return-void
.end method

.method public static prop(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    const-string v0, "ro.build.tags"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b

    const-string v0, "release-keys"

    return-object v0

    :cond_b
    const-string v0, "ro.debuggable"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_16

    const-string v0, "0"

    return-object v0

    :cond_16
    const-string v0, "ro.secure"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_21

    const-string v0, "1"

    return-object v0

    :cond_21
    const-string v0, "ro.build.type"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2c

    const-string v0, "user"

    return-object v0

    :cond_2c
    const-string v0, "ro.build.selinux"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_37

    const-string v0, "1"

    return-object v0

    :cond_37
    const-string v0, "ro.boot.verifiedbootstate"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_42

    const-string v0, "green"

    return-object v0

    :cond_42
    const-string v0, "ro.boot.flash.locked"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4d

    const-string v0, "1"

    return-object v0

    :cond_4d
    const-string v0, "ro.boot.veritymode"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_58

    const-string v0, "enforcing"

    return-object v0

    :cond_58
    const-string v0, "ro.boot.warranty_bit"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_63

    const-string v0, "0"

    return-object v0

    :cond_63
    const-string v0, "ro.warranty_bit"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6e

    const-string v0, "0"

    return-object v0

    :cond_6e
    const-string v0, "ro.crypto.state"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_79

    const-string v0, "encrypted"

    return-object v0

    :cond_79
    const-string v0, "ro.oem_unlock_supported"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_84

    const-string v0, "0"

    return-object v0

    :cond_84
    const-string v0, "sys.oem_unlock_allowed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_8f

    const-string v0, "0"

    return-object v0

    :cond_8f
    const/4 v0, 0x0

    return-object v0
.end method

.method public static refresh(Landroid/content/Context;)V
    .registers 3

    if-eqz p0, :cond_34

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->refresh(Landroid/content/Context;)V

    const-string v0, "key_env_bypass"

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "false"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_19

    const/4 v1, 0x1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sOn:Z

    goto :goto_1c

    :cond_19
    const/4 v1, 0x0

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sOn:Z

    :goto_1c
    const-string v0, "key_env_api"

    const-string v1, "b"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "false"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_30

    const/4 v1, 0x1

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sApi:Z

    return-void

    :cond_30
    const/4 v1, 0x0

    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sApi:Z

    return-void

    :cond_34
    return-void
.end method

.method public static setApi(Landroid/content/Context;Z)V
    .registers 5

    sput-boolean p1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sApi:Z

    if-eqz p1, :cond_7

    const-string v0, "true"

    goto :goto_9

    :cond_7
    const-string v0, "false"

    :goto_9
    const-string v1, "key_env_api"

    const-string v2, "b"

    invoke-static {p0, v1, v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 5

    sput-boolean p1, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sOn:Z

    if-eqz p1, :cond_7

    const-string v0, "true"

    goto :goto_9

    :cond_7
    const-string v0, "false"

    :goto_9
    const-string v1, "key_env_bypass"

    const-string v2, "b"

    invoke-static {p0, v1, v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static toastOnce(Landroid/content/Context;)V
    .registers 3

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sToast:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sOn:Z

    if-eqz v0, :cond_18

    const/4 v0, 0x1

    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sToast:Z

    sget-boolean v0, Lcom/nidyaber/fuckdsmanger/gm/GmEnv;->sApi:Z

    if-eqz v0, :cond_13

    const-string v1, "\u73af\u5883\u4f2a\u88c5\u5df2\u5f00\u542f\uff1aroot / \u6a21\u5757\u75d5\u8ff9\u5df2\u9690\u85cf"

    goto :goto_15

    :cond_13
    const-string v1, "\u73af\u5883\u4f2a\u88c5\u5df2\u5f00\u542f\uff08\u57fa\u7840\u7248\uff09"

    :goto_15
    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_18
    return-void
.end method
