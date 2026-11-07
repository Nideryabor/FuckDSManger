.class final Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmHtmlHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "CtorProbe"
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

    .line 247
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V
    .registers 2

    .line 247
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    const-string p0, "\u3010HTML\u63a2\u9488\u3011WebView \u5df2\u521b\u5efa #"

    .line 253
    :try_start_2
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;->sN:I

    const/4 v1, 0x4

    if-lt v0, v1, :cond_8

    goto :goto_3d

    .line 254
    :cond_8
    sget v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;->sN:I

    add-int/lit8 v0, v0, 0x1

    sput v0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;->sN:I

    .line 255
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget p0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$CtorProbe;->sN:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " cls="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 256
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u5f00\u5173="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 257
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->on()Z

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 255
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_3d
    .catchall {:try_start_2 .. :try_end_3d} :catchall_3d

    :catchall_3d
    :goto_3d
    return-void
.end method
