.class final Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmHtmlHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "WebViewCtorProbe"
.end annotation


# static fields
.field private static volatile sN:I


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 226
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V
    .registers 2

    .line 226
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    const-string p0, "\u3010HTML\u63a2\u9488\u3011WebView \u6784\u9020 #"

    .line 232
    :try_start_2
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;->sN:I

    const/16 v1, 0xc

    if-lt v0, v1, :cond_9

    goto :goto_35

    .line 233
    :cond_9
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;->sN:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;->sN:I

    .line 234
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-nez p1, :cond_14

    goto :goto_35

    .line 236
    :cond_14
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    .line 239
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget p0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$WebViewCtorProbe;->sN:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " = "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_35
    .catchall {:try_start_2 .. :try_end_35} :catchall_35

    :catchall_35
    :goto_35
    return-void
.end method
