.class final Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmHtmlHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "EvalHook"
.end annotation


# static fields
.field private static volatile sAll:I

.field private static volatile sProbe:I


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 128
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$1;)V
    .registers 2

    .line 128
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 11

    const-string p0, "\u3010HTML\u63a2\u9488\u3011"

    const-string v0, "\u6295\u9012\u6e90\u7801 \u957f\u5ea6="

    const-string v1, "\u3010HTML\u63a2\u9488\u3011evaluateJavascript #"

    .line 137
    :try_start_6
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    instance-of v2, v2, Landroid/webkit/WebView;

    if-nez v2, :cond_e

    goto/16 :goto_ee

    .line 138
    :cond_e
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-eqz v2, :cond_ee

    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v2, v2

    const/4 v3, 0x1

    if-ge v2, v3, :cond_1a

    goto/16 :goto_ee

    .line 139
    :cond_1a
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x0

    aget-object p1, p1, v2

    .line 140
    instance-of v4, p1, Ljava/lang/String;

    if-nez v4, :cond_25

    goto/16 :goto_ee

    .line 141
    :cond_25
    check-cast p1, Ljava/lang/String;

    .line 147
    sget v4, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;->sAll:I
    :try_end_29
    .catchall {:try_start_6 .. :try_end_29} :catchall_ef

    const/16 v5, 0x8

    const-string v6, " \u5934="

    const-string v7, "requestRenderMermaid"

    if-ge v4, v5, :cond_86

    .line 148
    :try_start_31
    sget v4, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;->sAll:I

    add-int/2addr v4, v3

    sput v4, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;->sAll:I

    .line 149
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v4

    const/16 v5, 0x64

    if-le v4, v5, :cond_43

    invoke-virtual {p1, v2, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    goto :goto_44

    :cond_43
    move-object v4, p1

    .line 150
    :goto_44
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;->sAll:I

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " len="

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 151
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u542bmermaid="

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 152
    invoke-virtual {p1, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :cond_67

    move v1, v3

    goto :goto_68

    :cond_67
    move v1, v2

    :goto_68
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0xa

    const/16 v8, 0x20

    .line 153
    invoke-virtual {v4, v1, v8}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v1

    const/16 v4, 0xd

    invoke-virtual {v1, v4, v8}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 150
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 157
    :cond_86
    const-string v1, "generateMermaid"

    invoke-virtual {p1, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-gez v1, :cond_92

    .line 158
    invoke-virtual {p1, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    :cond_92
    if-gez v1, :cond_95

    goto :goto_ee

    .line 161
    :cond_95
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->firstStringArg(Ljava/lang/String;I)Ljava/lang/String;
    invoke-static {p1, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->access$000(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p1

    .line 162
    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;->sProbe:I

    const/4 v4, 0x6

    if-ge v1, v4, :cond_ee

    .line 163
    sget v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;->sProbe:I

    add-int/2addr v1, v3

    sput v1, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook$EvalHook;->sProbe:I

    .line 164
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez p1, :cond_ac

    const/4 v0, -0x1

    goto :goto_b0

    :cond_ac
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    :goto_b0
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5f00\u5173="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 165
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->on()Z

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, " \u50cfHTML="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_cd

    .line 166
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->looksLikeHtml(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_cd

    goto :goto_ce

    :cond_cd
    move v3, v2

    :goto_ce
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 167
    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->head(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmHtmlHook;->access$100(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 168
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_ee
    .catchall {:try_start_31 .. :try_end_ee} :catchall_ef

    :cond_ee
    :goto_ee
    return-void

    :catchall_ef
    move-exception p0

    .line 175
    const-string p1, "htmlHook.eval"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
