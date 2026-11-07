.class final Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmHtmlHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "SrcHook"
.end annotation


# static fields
.field private static volatile sProbe:I


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 265
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V
    .registers 2

    .line 265
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 7

    const-string p0, "\u3010HTML\u63a2\u9488\u3011#"

    .line 273
    :try_start_2
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v0, :cond_8b

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v0, v0

    const/4 v1, 0x1

    if-ge v0, v1, :cond_e

    goto/16 :goto_8b

    .line 274
    :cond_e
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x0

    aget-object v0, v0, v2

    .line 275
    instance-of v3, v0, Ljava/lang/String;

    if-nez v3, :cond_18

    goto :goto_8b

    .line 276
    :cond_18
    check-cast v0, Ljava/lang/String;

    .line 281
    sget v3, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;->sProbe:I

    const/4 v4, 0x6

    if-ge v3, v4, :cond_8b

    .line 282
    sget v3, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;->sProbe:I

    add-int/2addr v3, v1

    sput v3, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;->sProbe:I

    .line 283
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v3, 0x5a

    if-le v1, v3, :cond_31

    invoke-virtual {v0, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    goto :goto_32

    :cond_31
    move-object v1, v0

    .line 284
    :goto_32
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget p0, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$SrcHook;->sProbe:I

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u65b9\u6cd5="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    .line 285
    invoke-interface {p0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " len="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 286
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u5f00\u5173="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 287
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->on()Z

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " \u50cfHTML="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 288
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->looksLikeHtml(Ljava/lang/String;)Z

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " \u5934="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0xa

    const/16 p1, 0x20

    .line 289
    invoke-virtual {v1, p0, p1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    const/16 v0, 0xd

    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 284
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_8b
    .catchall {:try_start_2 .. :try_end_8b} :catchall_8c

    :cond_8b
    :goto_8b
    return-void

    :catchall_8c
    move-exception p0

    .line 298
    const-string p1, "htmlHook.src"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
