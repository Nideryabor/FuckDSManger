.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmHtmlHook.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LangHook;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;
    }
.end annotation


# static fields
.field private static final CAND_HOLDER:[Ljava/lang/String;

.field private static final CAND_LANG:[Ljava/lang/String;

.field private static final SAFE_MERMAID:Ljava/lang/String; = "graph TD;A[.]"

.field private static volatile sHits:I

.field private static volatile sReady:Z

.field private static final sSwapped:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/webkit/WebView;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sWhy:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 56
    const-string v0, "hea"

    const-string v1, "oaa"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->CAND_LANG:[Ljava/lang/String;

    .line 72
    const-string v0, "z37"

    const-string v1, "b07"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->CAND_HOLDER:[Ljava/lang/String;

    .line 88
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    .line 89
    invoke-static {v0}, Ljava/util/Collections;->synchronizedMap(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sSwapped:Ljava/util/Map;

    const/4 v0, 0x0

    .line 92
    sput-boolean v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sReady:Z

    .line 93
    const-string v1, "\u672a\u521d\u59cb\u5316"

    sput-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sWhy:Ljava/lang/String;

    .line 94
    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sHits:I

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 51
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method static synthetic access$000(Ljava/lang/String;I)Ljava/lang/String;
    .registers 2

    .line 51
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->firstStringArg(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    .line 51
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->head(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static findViewerClass(Ljava/lang/ClassLoader;)Ljava/lang/Class;
    .registers 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/ClassLoader;",
            ")",
            "Ljava/lang/Class<",
            "*>;"
        }
    .end annotation

    .line 600
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->CAND_HOLDER:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_5
    if-ge v3, v1, :cond_2c

    aget-object v4, v0, v3

    .line 602
    :try_start_9
    invoke-static {v4, v2, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v4

    .line 603
    invoke-virtual {v4}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v4

    array-length v5, v4

    move v6, v2

    :goto_13
    if-ge v6, v5, :cond_29

    aget-object v7, v4, v6

    .line 604
    invoke-virtual {v7}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v7

    .line 606
    const-class v8, Landroid/webkit/WebView;

    if-eq v7, v8, :cond_26

    invoke-virtual {v8, v7}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v8
    :try_end_23
    .catchall {:try_start_9 .. :try_end_23} :catchall_29

    if-eqz v8, :cond_26

    return-object v7

    :cond_26
    add-int/lit8 v6, v6, 0x1

    goto :goto_13

    :catchall_29
    :cond_29
    add-int/lit8 v3, v3, 0x1

    goto :goto_5

    :cond_2c
    const/4 p0, 0x0

    return-object p0
.end method

.method private static firstStringArg(Ljava/lang/String;I)Ljava/lang/String;
    .registers 8

    const/16 v0, 0x28

    const/4 v1, 0x0

    .line 183
    :try_start_3
    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->indexOf(II)I

    move-result p1

    if-gez p1, :cond_a

    return-object v1

    :cond_a
    :goto_a
    add-int/lit8 p1, p1, 0x1

    .line 186
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-ge p1, v0, :cond_1d

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v0

    invoke-static {v0}, Ljava/lang/Character;->isWhitespace(C)Z

    move-result v0

    if-eqz v0, :cond_1d

    goto :goto_a

    .line 187
    :cond_1d
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-lt p1, v0, :cond_24

    return-object v1

    .line 188
    :cond_24
    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v0

    const/16 v2, 0x22

    const/16 v3, 0x27

    if-eq v0, v2, :cond_31

    if-eq v0, v3, :cond_31

    return-object v1

    :cond_31
    if-ne v0, v3, :cond_65

    .line 192
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    :goto_38
    add-int/lit8 p1, p1, 0x1

    .line 193
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge p1, v2, :cond_64

    .line 194
    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v4, 0x5c

    if-ne v2, v4, :cond_59

    add-int/lit8 v4, p1, 0x1

    .line 195
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v5

    if-ge v4, v5, :cond_59

    .line 196
    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    move-result p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move p1, v4

    goto :goto_38

    :cond_59
    if-ne v2, v3, :cond_60

    .line 199
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 200
    :cond_60
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_38

    :cond_64
    return-object v1

    .line 204
    :cond_65
    new-instance v0, Lorg/json/JSONTokener;

    invoke-virtual {p0, p1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Lorg/json/JSONTokener;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONTokener;->nextValue()Ljava/lang/Object;

    move-result-object p0

    .line 205
    instance-of p1, p0, Ljava/lang/String;

    if-eqz p1, :cond_79

    check-cast p0, Ljava/lang/String;
    :try_end_78
    .catchall {:try_start_3 .. :try_end_78} :catchall_79

    return-object p0

    :catchall_79
    :cond_79
    return-object v1
.end method

.method private static head(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    if-nez p0, :cond_5

    .line 212
    const-string p0, "(null)"

    return-object p0

    :cond_5
    const/16 v0, 0xa

    const/16 v1, 0x20

    .line 213
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    const/16 v0, 0xd

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 214
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x50

    if-le v0, v1, :cond_24

    const/4 v0, 0x0

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    :cond_24
    return-object p0
.end method

.method public static hits()I
    .registers 1

    .line 97
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sHits:I

    return v0
.end method

.method private static hookEval(Ljava/lang/ClassLoader;)I
    .registers 11

    .line 380
    const-class v0, Ljava/lang/String;

    const/4 v1, 0x0

    .line 383
    :try_start_3
    const-string v2, "android.webkit.WebView"

    invoke-static {v2, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0
    :try_end_9
    .catchall {:try_start_3 .. :try_end_9} :catchall_a

    goto :goto_11

    :catchall_a
    move-exception p0

    .line 385
    const-string v2, "htmlHook.findWebView"

    invoke-static {v2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    move-object p0, v1

    :goto_11
    const/4 v2, 0x0

    if-nez p0, :cond_1a

    .line 388
    const-string p0, "hookM html \u2192 android.webkit.WebView \u627e\u4e0d\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2

    .line 391
    :cond_1a
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "hookM html WebView \u7c7b="

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " loader="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 392
    invoke-virtual {p0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 391
    invoke-static {v3}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    const/4 v3, 0x1

    .line 397
    :try_start_3c
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object v4

    move v5, v2

    move v6, v5

    .line 398
    :goto_42
    array-length v7, v4

    if-ge v5, v7, :cond_64

    .line 399
    aget-object v7, v4, v5

    .line 400
    invoke-virtual {v7}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    .line 401
    array-length v9, v8

    if-lt v9, v3, :cond_61

    aget-object v8, v8, v2

    const-class v9, Landroid/content/Context;
    :try_end_52
    .catchall {:try_start_3c .. :try_end_52} :catchall_7e

    if-ne v8, v9, :cond_61

    .line 403
    :try_start_54
    invoke-virtual {v7, v3}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 404
    new-instance v8, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;

    invoke-direct {v8, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V

    invoke-static {v7, v8}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_5f
    .catchall {:try_start_54 .. :try_end_5f} :catchall_61

    add-int/lit8 v6, v6, 0x1

    :catchall_61
    :cond_61
    add-int/lit8 v5, v5, 0x1

    goto :goto_42

    .line 411
    :cond_64
    :try_start_64
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "hookM html \u63a2\u9488 WebView \u6784\u9020\u5668\u5df2\u6302 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " \u4e2a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_7d
    .catchall {:try_start_64 .. :try_end_7d} :catchall_7e

    goto :goto_85

    :catchall_7e
    move-exception v4

    .line 414
    const-string v5, "htmlHook.webviewCtor"

    invoke-static {v5, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    move v6, v2

    .line 419
    :goto_85
    :try_start_85
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v4

    move v5, v2

    .line 420
    :goto_8a
    array-length v7, v4

    if-ge v5, v7, :cond_c2

    .line 421
    aget-object v7, v4, v5

    .line 422
    const-string v8, "loadUrl"

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_9c

    goto :goto_b9

    .line 423
    :cond_9c
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    .line 424
    array-length v9, v8

    if-ne v9, v3, :cond_b9

    aget-object v8, v8, v2

    if-ne v8, v0, :cond_b9

    .line 425
    invoke-virtual {v7, v3}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 426
    new-instance v8, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;

    invoke-direct {v8, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LoadUrlHook;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V

    invoke-static {v7, v8}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v6, v6, 0x1

    .line 428
    const-string v7, "hookM html count=1 cls=android.webkit.WebView.loadUrl(String)"

    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_b9
    .catchall {:try_start_85 .. :try_end_b9} :catchall_bc

    :cond_b9
    :goto_b9
    add-int/lit8 v5, v5, 0x1

    goto :goto_8a

    :catchall_bc
    move-exception v4

    .line 432
    const-string v5, "htmlHook.loadUrl"

    invoke-static {v5, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 438
    :cond_c2
    :try_start_c2
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    move v4, v2

    .line 439
    :goto_c7
    array-length v5, p0

    if-ge v4, v5, :cond_e9

    .line 440
    aget-object v5, p0, v4

    .line 441
    const-string v7, "evaluateJavascript"

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_d9

    goto :goto_e6

    .line 442
    :cond_d9
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v7

    .line 443
    array-length v8, v7

    const/4 v9, 0x2

    if-ne v8, v9, :cond_e6

    aget-object v7, v7, v2

    if-ne v7, v0, :cond_e6

    goto :goto_ea

    :cond_e6
    :goto_e6
    add-int/lit8 v4, v4, 0x1

    goto :goto_c7

    :cond_e9
    move-object v5, v1

    :goto_ea
    if-nez v5, :cond_f2

    .line 449
    const-string p0, "hookM html \u2192 evaluateJavascript \u6ca1\u627e\u5230"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v6

    .line 452
    :cond_f2
    invoke-virtual {v5, v3}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 453
    new-instance p0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V

    invoke-static {v5, p0}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 454
    const-string p0, "hookM html count=1 cls=android.webkit.WebView.evaluateJavascript(String,ValueCallback)"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_102
    .catchall {:try_start_c2 .. :try_end_102} :catchall_104

    add-int/2addr v6, v3

    return v6

    :catchall_104
    move-exception p0

    .line 457
    const-string v0, "htmlHook.hookEval"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return v6
.end method

.method private static hookLang(Ljava/lang/ClassLoader;)I
    .registers 14

    .line 526
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->CAND_LANG:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    :goto_6
    if-ge v3, v1, :cond_a2

    aget-object v5, v0, v3

    .line 528
    :try_start_a
    invoke-static {v5, v2, p0}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v6

    .line 529
    invoke-virtual {v6}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v6

    move v7, v2

    .line 530
    :goto_13
    array-length v8, v6

    if-ge v7, v8, :cond_9e

    .line 531
    aget-object v8, v6, v7

    .line 536
    const-string v9, "G"

    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_31

    const-string v9, "U"

    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_31

    goto :goto_89

    .line 537
    :cond_31
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getModifiers()I

    move-result v9

    invoke-static {v9}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v9

    if-nez v9, :cond_3c

    goto :goto_89

    .line 538
    :cond_3c
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v9

    sget-object v10, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-eq v9, v10, :cond_45

    goto :goto_89

    .line 539
    :cond_45
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v9

    .line 540
    array-length v10, v9

    const/4 v11, 0x3

    if-eq v10, v11, :cond_4e

    goto :goto_89

    .line 541
    :cond_4e
    aget-object v10, v9, v2

    const-class v11, Ljava/lang/String;

    if-ne v10, v11, :cond_89

    const/4 v10, 0x1

    aget-object v12, v9, v10

    if-ne v12, v11, :cond_89

    const/4 v11, 0x2

    aget-object v9, v9, v11

    sget-object v11, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-eq v9, v11, :cond_61

    goto :goto_89

    .line 542
    :cond_61
    invoke-virtual {v8, v10}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 543
    new-instance v6, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LangHook;

    const/4 v7, 0x0

    invoke-direct {v6, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$LangHook;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V

    invoke-static {v8, v6}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v4, v4, 0x1

    .line 545
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "hookM html count=1 cls="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, ".U(String,String,boolean)"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_88
    .catchall {:try_start_a .. :try_end_88} :catchall_8c

    goto :goto_9e

    :cond_89
    :goto_89
    add-int/lit8 v7, v7, 0x1

    goto :goto_13

    :catchall_8c
    move-exception v6

    .line 549
    new-instance v7, Ljava/lang/StringBuilder;

    const-string v8, "htmlHook.install/lang/"

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_9e
    :goto_9e
    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_6

    :cond_a2
    return v4
.end method

.method private static hookViewer(Ljava/lang/Class;)I
    .registers 15
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class<",
            "*>;)I"
        }
    .end annotation

    .line 557
    const-class v0, Ljava/lang/String;

    .line 0
    const-string v1, "hookM html \u63a2\u9488 cls="

    const/4 v2, 0x2

    const/4 v3, 0x0

    const/4 v4, 0x1

    const/4 v5, 0x0

    .line 560
    :try_start_8
    new-array v6, v2, [Ljava/lang/Class;

    const-class v7, Landroid/content/Context;

    aput-object v7, v6, v5

    aput-object v0, v6, v4

    invoke-virtual {p0, v6}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v6

    .line 562
    invoke-virtual {v6, v4}, Ljava/lang/reflect/Constructor;->setAccessible(Z)V

    .line 563
    new-instance v7, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;

    invoke-direct {v7, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V

    invoke-static {v6, v7}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 564
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".<init>(Context,String)"

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_37
    .catchall {:try_start_8 .. :try_end_37} :catchall_38

    goto :goto_3d

    .line 566
    :catchall_38
    :try_start_38
    const-string v1, "hookM html \u63a2\u9488\uff1a\u6784\u9020\u5668( Context,String )\u6ca1\u627e\u5230\uff0c\u8df3\u8fc7\uff08\u4e0d\u5f71\u54cd\u529f\u80fd\uff09"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 568
    :goto_3d
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v1
    :try_end_41
    .catchall {:try_start_38 .. :try_end_41} :catchall_da

    move v6, v5

    move v7, v6

    .line 569
    :goto_43
    :try_start_43
    array-length v8, v1

    if-ge v6, v8, :cond_e1

    .line 570
    aget-object v8, v1, v6

    .line 571
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v9

    .line 572
    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v10

    sget-object v11, Ljava/lang/Void;->TYPE:Ljava/lang/Class;
    :try_end_52
    .catchall {:try_start_43 .. :try_end_52} :catchall_d7

    const-string v12, "."

    const-string v13, "hookM html count=1 cls="

    if-ne v10, v11, :cond_92

    :try_start_58
    array-length v10, v9

    if-ne v10, v4, :cond_92

    aget-object v10, v9, v5

    if-ne v10, v0, :cond_92

    .line 574
    invoke-virtual {v8, v4}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 575
    new-instance v9, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;

    invoke-direct {v9, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V

    invoke-static {v8, v9}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v7, v7, 0x1

    .line 577
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "(String)"

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_d3

    .line 578
    :cond_92
    array-length v10, v9

    if-ne v10, v2, :cond_d3

    aget-object v10, v9, v5

    if-ne v10, v0, :cond_d3

    aget-object v9, v9, v4

    invoke-virtual {v9}, Ljava/lang/Class;->isPrimitive()Z

    move-result v9

    if-nez v9, :cond_d3

    .line 580
    invoke-virtual {v8, v4}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 581
    new-instance v9, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;

    invoke-direct {v9, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V

    invoke-static {v8, v9}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    add-int/lit8 v7, v7, 0x1

    .line 583
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "(String,Cont)"

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_d3
    .catchall {:try_start_58 .. :try_end_d3} :catchall_d7

    :cond_d3
    :goto_d3
    add-int/lit8 v6, v6, 0x1

    goto/16 :goto_43

    :catchall_d7
    move-exception p0

    move v5, v7

    goto :goto_db

    :catchall_da
    move-exception p0

    .line 587
    :goto_db
    const-string v0, "htmlHook.hookViewer"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    move v7, v5

    :cond_e1
    return v7
.end method

.method public static install(Ljava/lang/ClassLoader;)I
    .registers 5

    .line 343
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->hookEval(Ljava/lang/ClassLoader;)I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-lez v0, :cond_a

    move v0, v1

    goto :goto_b

    :cond_a
    move v0, v2

    .line 346
    :goto_b
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->hookLang(Ljava/lang/ClassLoader;)I

    move-result v3

    .line 349
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->findViewerClass(Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    if-eqz p0, :cond_1a

    .line 350
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->hookViewer(Ljava/lang/Class;)I

    move-result p0

    add-int/2addr v0, p0

    .line 352
    :cond_1a
    const-string p0, "hookM FAIL html \u2192 "

    if-nez v0, :cond_34

    .line 353
    const-string v0, "\u4e00\u4e2a\u53ef\u7528\u7684\u88c5\u8f7d\u843d\u70b9\u90fd\u6ca1\u627e\u5230"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sWhy:Ljava/lang/String;

    .line 354
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sWhy:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2

    :cond_34
    if-nez v3, :cond_4c

    .line 361
    const-string v0, "\u8bed\u8a00\u95f8\u95e8 v7a.M(String,String,boolean) \u6ca1\u627e\u5230\uff08\u88c5\u8f7d\u843d\u70b9\u5df2\u5c31\u7eea\u4f46\u4e0d\u542f\u7528\uff09"

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sWhy:Ljava/lang/String;

    .line 362
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sWhy:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2

    .line 366
    :cond_4c
    sput-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sReady:Z

    .line 367
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v1, "\u8bed\u8a00\u95f8\u95e8 + "

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u4e2a\u88c5\u8f7d\u843d\u70b9"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sWhy:Ljava/lang/String;

    add-int/2addr v0, v3

    return v0
.end method

.method public static status()Ljava/lang/String;
    .registers 2

    .line 101
    new-instance v0, Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sReady:Z

    if-eqz v1, :cond_9

    const-string v1, "\u5df2\u5c31\u7eea"

    goto :goto_b

    :cond_9
    const-string v1, "\u672a\u5c31\u7eea"

    :goto_b
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, " \u00b7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sWhy:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff08\u66ff\u6362 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->sHits:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u6b21\uff09"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
