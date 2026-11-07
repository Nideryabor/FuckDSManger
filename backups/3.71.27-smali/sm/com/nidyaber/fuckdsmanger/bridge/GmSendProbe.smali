.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;
.super Ljava/lang/Object;
.source "GmSendProbe.java"


# static fields
.field private static final CAND_GH2:[Ljava/lang/String;

.field private static final STR_MAX:I = 0x3c

.field private static final TOUCH_WINDOW:J = 0x5dcL

.field private static final WIN_MAX:I = 0x18

.field private static volatile sHits:I

.field private static volatile sLast:Ljava/lang/String;

.field private static final sPer:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sSumAt:J

.field private static volatile sTouchAt:J

.field private static volatile sWinCount:I

.field private static volatile sWinTouch:J


# direct methods
.method static constructor <clinit>()V
    .registers 3

    .line 58
    const-string v0, "ao1"

    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->CAND_GH2:[Ljava/lang/String;

    const-wide/16 v0, 0x0

    .line 67
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sTouchAt:J

    .line 68
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinTouch:J

    const/4 v2, 0x0

    .line 69
    sput v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinCount:I

    .line 71
    sput v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sHits:I

    .line 72
    const-string v2, ""

    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sLast:Ljava/lang/String;

    .line 75
    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    sput-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sPer:Ljava/util/HashMap;

    .line 76
    sput-wide v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sSumAt:J

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 78
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Ljava/lang/String;[Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    .line 55
    invoke-static {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->onHit(Ljava/lang/String;[Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V

    return-void
.end method

.method static synthetic access$102(J)J
    .registers 2

    .line 55
    sput-wide p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sTouchAt:J

    return-wide p0
.end method

.method private static cn(Ljava/lang/Object;)Ljava/lang/String;
    .registers 1

    if-nez p0, :cond_5

    .line 288
    const-string p0, "null"

    return-object p0

    :cond_5
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static desc(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)Ljava/lang/String;
    .registers 5

    .line 219
    :try_start_0
    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_3e

    iget-object v0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v0, v0

    if-nez v0, :cond_a

    goto :goto_3e

    .line 220
    :cond_a
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 221
    iget-object v1, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v1, v1

    const/4 v2, 0x3

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    const/4 v2, 0x0

    :goto_18
    if-ge v2, v1, :cond_2f

    if-lez v2, :cond_21

    .line 223
    const-string v3, ", "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 224
    :cond_21
    iget-object v3, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aget-object v3, v3, v2

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->one(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_18

    .line 226
    :cond_2f
    iget-object p0, p0, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length p0, p0

    if-le p0, v1, :cond_39

    const-string p0, ", \u2026"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 227
    :cond_39
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 219
    :cond_3e
    :goto_3e
    const-string p0, "\uff08\u65e0\u53c2\uff09"
    :try_end_40
    .catchall {:try_start_0 .. :try_end_40} :catchall_41

    return-object p0

    .line 229
    :catchall_41
    const-string p0, "?"

    return-object p0
.end method

.method private static fields(Ljava/lang/Object;)Ljava/lang/String;
    .registers 10

    .line 248
    const-string v0, ""

    :try_start_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 250
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v2

    array-length v3, v2

    const/4 v4, 0x0

    move v5, v4

    :goto_12
    if-ge v4, v3, :cond_61

    aget-object v6, v2, v4

    .line 251
    invoke-virtual {v6}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v7

    const-class v8, Ljava/lang/String;

    if-eq v7, v8, :cond_1f

    goto :goto_5e

    .line 252
    :cond_1f
    invoke-virtual {v6}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v7

    invoke-static {v7}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v7

    if-eqz v7, :cond_2a

    goto :goto_5e

    :cond_2a
    const/4 v7, 0x1

    .line 253
    invoke-virtual {v6, v7}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 254
    invoke-virtual {v6, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    .line 255
    instance-of v8, v7, Ljava/lang/String;

    if-nez v8, :cond_37

    goto :goto_5e

    :cond_37
    if-lez v5, :cond_3e

    const/16 v8, 0x20

    .line 256
    invoke-virtual {v1, v8}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 257
    :cond_3e
    invoke-virtual {v6}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "=\""

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    check-cast v7, Ljava/lang/String;

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->trim(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v6, 0x22

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v5, v5, 0x1

    const/4 v6, 0x4

    if-lt v5, v6, :cond_5e

    goto :goto_61

    :cond_5e
    :goto_5e
    add-int/lit8 v4, v4, 0x1

    goto :goto_12

    :cond_61
    :goto_61
    if-nez v5, :cond_64

    return-object v0

    .line 261
    :cond_64
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "{"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, "}"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_7a
    .catchall {:try_start_2 .. :try_end_7a} :catchall_7b

    return-object p0

    :catchall_7b
    return-object v0
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 8

    .line 88
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->installTouch(Ljava/lang/ClassLoader;)V

    .line 91
    :try_start_3
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->CAND_GH2:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    move v4, v2

    :goto_9
    if-ge v4, v1, :cond_1b

    aget-object v5, v0, v4
    :try_end_d
    .catchall {:try_start_3 .. :try_end_d} :catchall_a8

    .line 93
    :try_start_d
    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5, v2, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3
    :try_end_15
    .catchall {:try_start_d .. :try_end_15} :catchall_18

    if-eqz v3, :cond_18

    goto :goto_1b

    :catchall_18
    :cond_18
    add-int/lit8 v4, v4, 0x1

    goto :goto_9

    :cond_1b
    :goto_1b
    if-nez v3, :cond_24

    .line 100
    :try_start_1d
    const-string p0, "[\u53d1\u9001\u63a2\u9488] gh2 \u6ca1\u627e\u5230 \u2014\u2014 \u5bbf\u4e3b\u53ef\u80fd\u6539\u7248\u4e86"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto/16 :goto_ae

    .line 105
    :cond_24
    invoke-virtual {v3}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v0, p0

    move v1, v2

    :goto_2a
    if-ge v2, v0, :cond_8e

    aget-object v3, p0, v2

    .line 106
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v4

    invoke-static {v4}, Ljava/lang/reflect/Modifier;->isPublic(I)Z

    move-result v4

    if-nez v4, :cond_39

    goto :goto_8b

    .line 107
    :cond_39
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v4

    invoke-static {v4}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v4

    if-eqz v4, :cond_44

    goto :goto_8b

    .line 108
    :cond_44
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->isSynthetic()Z

    move-result v4

    if-nez v4, :cond_8b

    invoke-virtual {v3}, Ljava/lang/reflect/Method;->isBridge()Z

    move-result v4

    if-eqz v4, :cond_51

    goto :goto_8b

    .line 109
    :cond_51
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v4

    sget-object v5, Ljava/lang/Void;->TYPE:Ljava/lang/Class;

    if-eq v4, v5, :cond_5a

    goto :goto_8b

    :cond_5a
    const/4 v4, 0x1

    .line 115
    invoke-virtual {v3, v4}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 116
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v4

    .line 117
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v5

    .line 118
    new-instance v6, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$1;

    invoke-direct {v6, v4, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$1;-><init>(Ljava/lang/String;[Ljava/lang/Class;)V

    invoke-static {v3, v6}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v1, v1, 0x1

    .line 129
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "[\u53d1\u9001\u63a2\u9488] \u5df2\u6302 gh2."

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sig([Ljava/lang/Class;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_8b
    :goto_8b
    add-int/lit8 v2, v2, 0x1

    goto :goto_2a

    .line 131
    :cond_8e
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "[\u53d1\u9001\u63a2\u9488] \u5171\u6302 "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u4e2a\u5019\u9009\uff08\u5168\u90e8 void\uff09 \u2014\u2014 \u8bf7\u5728\u4f1a\u8bdd\u91cc\u3010\u8f93\u5165\u4e00\u53e5\u8bdd \u2192 \u70b9\u53d1\u9001\u6309\u94ae\u3011\uff0c\u65e5\u5fd7\u4f1a\u53ea\u7559\u90a3\u4e00\u4e0b"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_a7
    .catchall {:try_start_1d .. :try_end_a7} :catchall_a8

    goto :goto_ae

    :catchall_a8
    move-exception p0

    .line 134
    const-string v0, "[\u53d1\u9001\u63a2\u9488] \u5b89\u88c5\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_ae
    return-void
.end method

.method private static installTouch(Ljava/lang/ClassLoader;)V
    .registers 5

    .line 146
    :try_start_0
    const-string v0, "android.app.Activity"

    const-string v1, "dispatchTouchEvent"

    const-class v2, Landroid/view/MotionEvent;

    new-instance v3, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$2;

    invoke-direct {v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$2;-><init>()V

    filled-new-array {v2, v3}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, p0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 162
    const-string p0, "[\u53d1\u9001\u63a2\u9488] \u89e6\u6478\u7a97\u53e3\u5df2\u6302\uff08Activity.dispatchTouchEvent\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_18

    return-void

    :catchall_18
    move-exception p0

    .line 164
    const-string v0, "[\u53d1\u9001\u63a2\u9488] \u89e6\u6478\u7a97\u53e3\u6302\u5931\u8d25\uff08\u4e0d\u5f71\u54cd gh2 \u63a2\u9488\uff09"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private static onHit(Ljava/lang/String;[Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "[",
            "Ljava/lang/Class<",
            "*>;",
            "Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;",
            ")V"
        }
    .end annotation

    .line 171
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sHits:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sHits:I

    .line 172
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "gh2."

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 173
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sPer:Ljava/util/HashMap;

    monitor-enter v2

    .line 174
    :try_start_17
    invoke-virtual {v2, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    if-nez v3, :cond_21

    move v3, v1

    goto :goto_26

    .line 175
    :cond_21
    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    add-int/2addr v3, v1

    :goto_26
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v2, v0, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 176
    monitor-exit v2
    :try_end_2e
    .catchall {:try_start_17 .. :try_end_2e} :catchall_fa

    .line 178
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 179
    sget-wide v4, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sTouchAt:J

    const-wide/16 v6, 0x0

    cmp-long v0, v4, v6

    if-lez v0, :cond_f9

    sub-long v6, v2, v4

    const-wide/16 v8, 0x5dc

    cmp-long v0, v6, v8

    if-gez v0, :cond_f9

    .line 185
    sget-wide v6, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinTouch:J

    cmp-long v0, v4, v6

    if-eqz v0, :cond_86

    .line 186
    sput-wide v4, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinTouch:J

    const/4 v0, 0x0

    .line 187
    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinCount:I

    .line 188
    sget-wide v6, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sSumAt:J

    sub-long v6, v2, v6

    const-wide/16 v8, 0x1388

    cmp-long v0, v6, v8

    if-lez v0, :cond_6e

    .line 189
    sput-wide v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sSumAt:J

    .line 190
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v6, "[\u53d1\u9001\u63a2\u9488] \u7d2f\u8ba1\uff1a"

    invoke-direct {v0, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sumLine()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 192
    :cond_6e
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v6, "[\u53d1\u9001\u63a2\u9488] \u2550\u2550 \u7528\u6237\u64cd\u4f5c\u7a97\u53e3\u5f00\u59cb\uff08\u89e6\u6478\u540e "

    invoke-direct {v0, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sub-long v6, v2, v4

    invoke-virtual {v0, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v6, "ms\uff09\u2550\u2550"

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 194
    :cond_86
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinCount:I

    const/16 v6, 0x18

    if-lt v0, v6, :cond_8d

    return-void

    .line 195
    :cond_8d
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinCount:I

    add-int/2addr v0, v1

    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sWinCount:I

    .line 197
    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->desc(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)Ljava/lang/String;

    move-result-object v0

    .line 198
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v6, "gh2."

    invoke-direct {v1, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sig([Ljava/lang/Class;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sLast:Ljava/lang/String;

    .line 199
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v6, "[\u53d1\u9001\u63a2\u9488] \u2605 gh2."

    invoke-direct {v1, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sig([Ljava/lang/Class;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u2192 "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "  t+"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sub-long/2addr v2, v4

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, "ms  this="

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p2, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 200
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->cn(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 199
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 201
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "[\u53d1\u9001\u63a2\u9488]    \u6808="

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->stack()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_f9
    return-void

    :catchall_fa
    move-exception p0

    .line 176
    :try_start_fb
    monitor-exit v2
    :try_end_fc
    .catchall {:try_start_fb .. :try_end_fc} :catchall_fa

    throw p0
.end method

.method public static onSuggestClick(Ljava/lang/String;)V
    .registers 4

    const-string v0, "[\u5efa\u8bae] \u53d1\u9001\u6ca1\u6210\u529f \u2014\u2014 "

    const-string v1, "[\u5efa\u8bae] \u2605\u2605 \u88ab\u70b9\u4e86\uff01\u8981\u56de\u590d\u7684\u5185\u5bb9 = \u300c"

    .line 307
    :try_start_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\u300d"

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 308
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->send(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_24

    .line 310
    const-string p0, "[\u5efa\u8bae] \u2605 \u5df2\u66ff\u4f60\u53d1\u51fa\u53bb \u21d2 \u7b49 AI \u56de\u7b54\u5427"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 312
    :cond_24
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->status()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_37
    .catchall {:try_start_4 .. :try_end_37} :catchall_38

    return-void

    :catchall_38
    move-exception p0

    .line 316
    :try_start_39
    const-string v0, "[\u5efa\u8bae] \u70b9\u51fb\u5904\u7406\u5f02\u5e38"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_3e
    .catchall {:try_start_39 .. :try_end_3e} :catchall_3e

    :catchall_3e
    return-void
.end method

.method private static one(Ljava/lang/Object;)Ljava/lang/String;
    .registers 3

    if-nez p0, :cond_5

    .line 234
    const-string p0, "null"

    return-object p0

    .line 235
    :cond_5
    instance-of v0, p0, Ljava/lang/String;

    if-eqz v0, :cond_21

    .line 236
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\""

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    check-cast p0, Ljava/lang/String;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->trim(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 238
    :cond_21
    instance-of v0, p0, Ljava/lang/Number;

    if-nez v0, :cond_46

    instance-of v0, p0, Ljava/lang/Boolean;

    if-eqz v0, :cond_2a

    goto :goto_46

    .line 242
    :cond_2a
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->fields(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 238
    :cond_46
    :goto_46
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static sig([Ljava/lang/Class;)Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Ljava/lang/Class<",
            "*>;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 206
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "("

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz p0, :cond_20

    const/4 v1, 0x0

    .line 208
    :goto_a
    array-length v2, p0

    if-ge v1, v2, :cond_20

    if-lez v1, :cond_14

    const/16 v2, 0x2c

    .line 209
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 210
    :cond_14
    aget-object v2, p0, v1

    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_a

    .line 213
    :cond_20
    const-string p0, ")V"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static status()Ljava/lang/String;
    .registers 3

    .line 82
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u547d\u4e2d "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sHits:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6b21"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sLast:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1c

    const-string v1, ""

    goto :goto_2c

    :cond_1c
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\uff0c\u6700\u8fd1\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sLast:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_2c
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static sumLine()Ljava/lang/String;
    .registers 5

    .line 275
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 276
    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->sPer:Ljava/util/HashMap;

    monitor-enter v1

    .line 277
    :try_start_8
    invoke-virtual {v1}, Ljava/util/HashMap;->entrySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    .line 278
    :goto_10
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3d

    .line 279
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/Map$Entry;

    .line 280
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    if-lez v4, :cond_27

    const-string v4, " \u00b7 "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 281
    :cond_27
    invoke-interface {v3}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v4, 0x3d

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-interface {v3}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    goto :goto_10

    .line 283
    :cond_3d
    monitor-exit v1
    :try_end_3e
    .catchall {:try_start_8 .. :try_end_3e} :catchall_4c

    .line 284
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    if-nez v1, :cond_47

    const-string v0, "\uff08\u65e0\uff09"

    return-object v0

    :cond_47
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :catchall_4c
    move-exception v0

    .line 283
    :try_start_4d
    monitor-exit v1
    :try_end_4e
    .catchall {:try_start_4d .. :try_end_4e} :catchall_4c

    throw v0
.end method

.method private static trim(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    if-nez p0, :cond_5

    .line 268
    const-string p0, ""

    return-object p0

    .line 269
    :cond_5
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x3c

    if-le v0, v1, :cond_23

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v2, 0x0

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\u2026"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :cond_23
    const/16 v0, 0xa

    const/16 v1, 0x23ce

    .line 270
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
