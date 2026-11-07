.class public final Lcom/nidyaber/fuckdsmanger/gm/GmRichText;
.super Ljava/lang/Object;
.source "GmRichText.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;,
        Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;
    }
.end annotation


# static fields
.field public static final ANON_CLOSE:Ljava/lang/String; = "\u27e6/FDM\u27e7"

.field public static final ANON_OPEN:Ljava/lang/String; = "\u27e6FDM\u27e7"

.field public static final CLOSE:Ljava/lang/String; = "\u27e7"

.field public static final DEF_COLORS:[I

.field public static final DEMO_TPLS:Ljava/lang/String; = "# \u6bcf\u884c\u4e00\u6761\uff1a\u540d\u5b57|\u5bcc\u6587\u672c\uff08HTML \u5b50\u96c6\uff0c\u6362\u884c\u7528 <br>\uff09\ndemo|<b>\u2726 {1}</b> {2}\ntip|<c6>\u25b8 {1}</c>\nwarn|<bg3><c#000000> \u26a0 {1} </c></bg>\ncard|<c7>\u250c {1}</c><br><c7>\u2514</c> {2}\nhi|<b><c4>\u4f60\u597d\uff0c{1}</c></b> \u4eca\u5929{c2}\u5f88\u597d</c>\uff01"

.field public static final DJ_CLOSE:Ljava/lang/String; = "\u27e7"

.field public static final DJ_CLOSES:[Ljava/lang/String;

.field public static final DJ_OPEN:Ljava/lang/String; = "\u27e6DJ:"

.field public static final DJ_OPENS:[Ljava/lang/String;

.field private static final EMPTY_ARGS:[Ljava/lang/String;

.field public static final EV_POP:I = 0x2

.field public static final EV_PUSH:I = 0x1

.field public static final EV_TEXT:I = 0x0

.field public static final K_BARE:Ljava/lang/String; = "fuckds_rich_bare"

.field public static final K_C:Ljava/lang/String; = "fuckds_rich_c"

.field public static final K_ON:Ljava/lang/String; = "fuckds_rich_on"

.field public static final K_TPLS:Ljava/lang/String; = "fuckds_rich_tpls"

.field public static final OPEN:Ljava/lang/String; = "\u27e6FDM:"

.field public static final SPEC_TAG:Ljava/lang/String; = "\u3010\u56de\u7b54\u6392\u7248\u3011"

.field public static final SUG2_CLOSE:Ljava/lang/String; = "\u27e6/SUG\u27e7"

.field public static final SUG2_OPEN:Ljava/lang/String; = "\u27e6SUG\u27e7"

.field public static final SUG_CLOSE:Ljava/lang/String; = "</Suggestion>"

.field public static final SUG_OPEN:Ljava/lang/String; = "<Suggestion>"

.field public static final SUG_SPEC_TAG:Ljava/lang/String; = "\u3010\u8ffd\u95ee\u5efa\u8bae\u3011"


# direct methods
.method static constructor <clinit>()V
    .registers 4

    const/16 v0, 0xa

    .line 80
    new-array v0, v0, [I

    fill-array-data v0, :array_2c

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->DEF_COLORS:[I

    .line 158
    const-string v0, "\uff3bDJ:"

    const-string v1, "\u3010DJ:"

    const-string v2, "\u27e6DJ:"

    const-string v3, "[DJ:"

    filled-new-array {v2, v3, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->DJ_OPENS:[Ljava/lang/String;

    .line 179
    const-string v0, "\uff3d"

    const-string v1, "\u3011"

    const-string v2, "\u27e7"

    const-string v3, "]"

    filled-new-array {v2, v3, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->DJ_CLOSES:[Ljava/lang/String;

    const/4 v0, 0x0

    .line 221
    new-array v0, v0, [Ljava/lang/String;

    sput-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->EMPTY_ARGS:[Ljava/lang/String;

    return-void

    nop

    :array_2c
    .array-data 4
        0x0
        -0xadae
        -0x4d00
        -0x2a00
        -0xb350b0
        -0xd95966
        -0xbd5a0b
        -0x81a83e
        -0x13bf86
        -0x616162
    .end array-data
.end method

.method private constructor <init>()V
    .registers 1

    .line 223
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static bareOn()Z
    .registers 3

    .line 295
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x1

    if-nez v0, :cond_8

    return v1

    .line 298
    :cond_8
    :try_start_8
    const-string v2, "fuckds_rich_bare"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_f

    return v0

    :catchall_f
    return v1
.end method

.method public static boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z
    .registers 11

    .line 240
    const-string v0, "false"

    const-string v1, "true"

    const-string v2, "0"

    const-string v3, "1"

    if-nez p0, :cond_b

    goto :goto_64

    .line 242
    :cond_b
    :try_start_b
    const-string v4, "b"

    invoke-static {p0, p1, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 243
    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    const/4 v6, 0x1

    if-nez v5, :cond_63

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_1f

    goto :goto_63

    .line 244
    :cond_1f
    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    const/4 v7, 0x0

    if-nez v5, :cond_62

    invoke-virtual {v2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2d

    goto :goto_62

    .line 245
    :cond_2d
    const-string v4, "s"

    invoke-static {p0, p1, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 246
    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_61

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_40

    goto :goto_61

    .line 247
    :cond_40
    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_60

    invoke-virtual {v2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4d

    goto :goto_60

    .line 248
    :cond_4d
    const-string v0, "i"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 249
    invoke-virtual {v3, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_5a

    return v6

    .line 250
    :cond_5a
    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_5e
    .catchall {:try_start_b .. :try_end_5e} :catchall_64

    if-eqz p0, :cond_64

    :cond_60
    :goto_60
    return v7

    :cond_61
    :goto_61
    return v6

    :cond_62
    :goto_62
    return v7

    :cond_63
    :goto_63
    return v6

    :catchall_64
    :cond_64
    :goto_64
    return p2
.end method

.method private static cutParagraph(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    if-nez p0, :cond_5

    .line 928
    const-string p0, ""

    return-object p0

    .line 929
    :cond_5
    invoke-virtual {p0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p1

    if-gez p1, :cond_c

    return-object p0

    .line 933
    :cond_c
    const-string v0, "\n\n"

    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;I)I

    move-result v1

    const/4 v2, 0x0

    if-ltz v1, :cond_18

    add-int/lit8 v1, v1, 0x2

    goto :goto_19

    :cond_18
    move v1, v2

    .line 936
    :goto_19
    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result p1

    if-gez p1, :cond_23

    .line 937
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1

    .line 939
    :cond_23
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static fill(Ljava/lang/String;[Ljava/lang/String;)Ljava/lang/String;
    .registers 10

    if-eqz p0, :cond_68

    .line 612
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_68

    :cond_9
    if-nez p1, :cond_d

    .line 613
    sget-object p1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->EMPTY_ARGS:[Ljava/lang/String;

    .line 614
    :cond_d
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    add-int/lit8 v1, v1, 0x20

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 615
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v2, 0x0

    :goto_1d
    if-ge v2, v1, :cond_63

    .line 617
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v3

    const/16 v4, 0x7b

    if-eq v3, v4, :cond_2b

    .line 619
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_60

    :cond_2b
    add-int/lit8 v5, v2, 0x1

    const/16 v6, 0x7d

    .line 622
    invoke-virtual {p0, v6, v5}, Ljava/lang/String;->indexOf(II)I

    move-result v7

    if-gez v7, :cond_39

    .line 624
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_60

    .line 627
    :cond_39
    invoke-virtual {p0, v5, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    .line 630
    :try_start_41
    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3
    :try_end_45
    .catchall {:try_start_41 .. :try_end_45} :catchall_46

    goto :goto_47

    :catchall_46
    const/4 v3, -0x1

    :goto_47
    if-gtz v3, :cond_53

    .line 635
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_5f

    .line 639
    :cond_53
    array-length v2, p1

    if-gt v3, v2, :cond_5f

    add-int/lit8 v3, v3, -0x1

    .line 640
    aget-object v2, p1, v3

    if-eqz v2, :cond_5f

    .line 641
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_5f
    :goto_5f
    move v2, v7

    :goto_60
    add-int/lit8 v2, v2, 0x1

    goto :goto_1d

    .line 645
    :cond_63
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 612
    :cond_68
    :goto_68
    const-string p0, ""

    return-object p0
.end method

.method public static hasBareTag(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x0

    if-eqz p0, :cond_60

    .line 591
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v2, 0x3

    if-ge v1, v2, :cond_b

    goto :goto_60

    :cond_b
    const/4 v1, -0x1

    :cond_c
    const/16 v2, 0x3c

    const/4 v3, 0x1

    add-int/2addr v1, v3

    .line 593
    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v1

    if-ltz v1, :cond_60

    add-int/lit8 v2, v1, 0x1

    .line 594
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v4

    if-lt v2, v4, :cond_1f

    return v0

    .line 595
    :cond_1f
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v4, 0x62

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x42

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x69

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x49

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x75

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x55

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x73

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x53

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x63

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x43

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x64

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x44

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x65

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x45

    if-eq v2, v4, :cond_5f

    const/16 v4, 0x2f

    if-ne v2, v4, :cond_c

    :cond_5f
    return v3

    :cond_60
    :goto_60
    return v0
.end method

.method public static hasDj(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 172
    :cond_4
    sget-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->DJ_OPENS:[Ljava/lang/String;

    array-length v2, v1

    move v3, v0

    :goto_8
    if-ge v3, v2, :cond_17

    aget-object v4, v1, v3

    .line 173
    invoke-virtual {p0, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    if-ltz v4, :cond_14

    const/4 p0, 0x1

    return p0

    :cond_14
    add-int/lit8 v3, v3, 0x1

    goto :goto_8

    :cond_17
    return v0
.end method

.method public static hasMark(Ljava/lang/String;)Z
    .registers 2

    if-eqz p0, :cond_c

    .line 418
    const-string v0, "\u27e6FDM:"

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p0

    if-ltz p0, :cond_c

    const/4 p0, 0x1

    return p0

    :cond_c
    const/4 p0, 0x0

    return p0
.end method

.method public static hasSuggest(Ljava/lang/String;)Z
    .registers 2

    if-eqz p0, :cond_14

    .line 587
    const-string v0, "<Suggestion>"

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    if-gez v0, :cond_12

    const-string v0, "\u27e6SUG\u27e7"

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p0

    if-ltz p0, :cond_14

    :cond_12
    const/4 p0, 0x1

    return p0

    :cond_14
    const/4 p0, 0x0

    return p0
.end method

.method public static mergeIntoSystemPrompt()Ljava/lang/String;
    .registers 2

    .line 841
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->spec()Ljava/lang/String;

    move-result-object v0

    const-string v1, "\u3010\u56de\u7b54\u6392\u7248\u3011"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->mergeSpec(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static mergeSpec(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    const-string v0, "\u5df2\u5199\u8fdb\u7cfb\u7edf\u63d0\u793a\u8bcd\uff08\u539f\u6587 "

    .line 960
    :try_start_2
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_11

    .line 961
    invoke-virtual {v1, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p1

    if-ltz p1, :cond_11

    .line 962
    const-string p0, "\u7cfb\u7edf\u63d0\u793a\u8bcd\u91cc\u5df2\u7ecf\u6709\u8fd9\u6bb5\u7ea6\u5b9a\u4e86\uff0c\u6ca1\u91cd\u590d\u52a0"

    return-object p0

    :cond_11
    if-eqz v1, :cond_2f

    .line 964
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_1a

    goto :goto_2f

    :cond_1a
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\n\n"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_30

    :cond_2f
    :goto_2f
    move-object p1, p0

    .line 965
    :goto_30
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->setText(Ljava/lang/String;)V

    .line 966
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez v1, :cond_3c

    const/4 v0, 0x0

    goto :goto_40

    :cond_3c
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    :goto_40
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57 \u2192 \u73b0\u5728 "

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 967
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " \u5b57\uff0c\u8ffd\u52a0 "

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u5b57\uff09"

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_64
    .catchall {:try_start_2 .. :try_end_64} :catchall_65

    return-object p0

    :catchall_65
    move-exception p0

    .line 969
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u5199\u63d0\u793a\u8bcd\u5931\u8d25\uff1a"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static mergeSuggestIntoSystemPrompt()Ljava/lang/String;
    .registers 2

    .line 870
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->suggestSpec()Ljava/lang/String;

    move-result-object v0

    const-string v1, "\u3010\u8ffd\u95ee\u5efa\u8bae\u3011"

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->mergeSpec(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static nameOk(Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0

    if-eqz p0, :cond_32

    .line 316
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_32

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0x18

    if-le v1, v2, :cond_12

    goto :goto_32

    :cond_12
    move v1, v0

    .line 317
    :goto_13
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_30

    .line 318
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    .line 319
    invoke-static {v2}, Ljava/lang/Character;->isLetterOrDigit(C)Z

    move-result v3

    if-nez v3, :cond_2d

    const/16 v3, 0x5f

    if-eq v2, v3, :cond_2d

    const/16 v3, 0x2d

    if-ne v2, v3, :cond_2c

    goto :goto_2d

    :cond_2c
    return v0

    :cond_2d
    :goto_2d
    add-int/lit8 v1, v1, 0x1

    goto :goto_13

    :cond_30
    const/4 p0, 0x1

    return p0

    :cond_32
    :goto_32
    return v0
.end method

.method public static names()Ljava/util/List;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 374
    new-instance v0, Ljava/util/ArrayList;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->tplMap()Ljava/util/LinkedHashMap;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object v0
.end method

.method public static normTag(Ljava/lang/String;)Ljava/lang/String;
    .registers 10

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    .line 675
    :cond_4
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    .line 676
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_13

    return-object v0

    :cond_13
    const/16 v1, 0x3d

    .line 678
    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    if-ltz v1, :cond_23

    const-string v1, "="

    const-string v2, ""

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    :cond_23
    const/16 v1, 0x20

    .line 679
    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v2

    const/4 v3, 0x0

    if-ltz v2, :cond_34

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    invoke-virtual {p0, v3, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    .line 681
    :cond_34
    const-string v1, "b"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_ed

    const-string v2, "strong"

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_46

    goto/16 :goto_ed

    .line 682
    :cond_46
    const-string v1, "i"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_ed

    const-string v2, "em"

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_58

    goto/16 :goto_ed

    .line 683
    :cond_58
    const-string v1, "u"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_61

    return-object v1

    .line 684
    :cond_61
    const-string v1, "s"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_ed

    const-string v2, "del"

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_ed

    const-string v2, "strike"

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_7b

    goto/16 :goto_ed

    .line 685
    :cond_7b
    const-string v1, "br"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_84

    return-object v1

    .line 687
    :cond_84
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0x39

    const/16 v4, 0x31

    const/16 v5, 0x23

    const/4 v6, 0x1

    if-le v1, v6, :cond_bc

    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v7, 0x63

    if-ne v1, v7, :cond_bc

    .line 688
    invoke-virtual {p0, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    .line 689
    invoke-virtual {v1, v3}, Ljava/lang/String;->charAt(I)C

    move-result v7

    if-eq v7, v5, :cond_ad

    .line 690
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v8

    if-ne v8, v6, :cond_bc

    if-lt v7, v4, :cond_bc

    if-gt v7, v2, :cond_bc

    :cond_ad
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "c"

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 692
    :cond_bc
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v7, 0x2

    if-le v1, v7, :cond_ec

    const-string v1, "bg"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_ec

    .line 693
    invoke-virtual {p0, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 694
    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v3

    if-eq v3, v5, :cond_df

    .line 695
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v5

    if-ne v5, v6, :cond_ec

    if-lt v3, v4, :cond_ec

    if-gt v3, v2, :cond_ec

    :cond_df
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_ec
    return-object v0

    :cond_ed
    :goto_ed
    return-object v1
.end method

.method public static on()Z
    .registers 3

    .line 274
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 277
    :cond_8
    :try_start_8
    const-string v2, "fuckds_rich_on"

    invoke-static {v0, v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0
    :try_end_e
    .catchall {:try_start_8 .. :try_end_e} :catchall_f

    return v0

    :catchall_f
    return v1
.end method

.method private static oneLine(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    if-nez p0, :cond_5

    .line 828
    const-string p0, ""

    return-object p0

    :cond_5
    const/16 v0, 0xa

    const/16 v1, 0x20

    .line 829
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    const/16 v0, 0xd

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 830
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x3c

    if-le v0, v1, :cond_35

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

    :cond_35
    return-object p0
.end method

.method public static palette(I)I
    .registers 5

    const-string v0, "fuckds_rich_c"

    const/4 v1, 0x1

    if-lt p0, v1, :cond_50

    const/16 v1, 0x9

    if-le p0, v1, :cond_a

    goto :goto_50

    .line 387
    :cond_a
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_4b

    .line 390
    :try_start_10
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    if-eqz v2, :cond_4b

    .line 391
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v2, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_4b

    .line 392
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "i"

    invoke-static {v1, v0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_4b

    .line 393
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_4b

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_4a
    .catchall {:try_start_10 .. :try_end_4a} :catchall_4b

    return p0

    .line 399
    :catchall_4b
    :cond_4b
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->DEF_COLORS:[I

    aget p0, v0, p0

    return p0

    :cond_50
    :goto_50
    const/4 p0, 0x0

    return p0
.end method

.method public static parseHtml(Ljava/lang/String;)Ljava/util/List;
    .registers 18
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;",
            ">;"
        }
    .end annotation

    move-object/from16 v0, p0

    .line 711
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    if-eqz v0, :cond_162

    .line 712
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_11

    goto/16 :goto_162

    .line 714
    :cond_11
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 715
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 717
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v4

    const/4 v5, 0x0

    move v6, v5

    :goto_21
    const/4 v7, 0x2

    const/4 v8, 0x1

    const/4 v9, 0x0

    if-ge v6, v4, :cond_136

    .line 720
    invoke-virtual {v0, v6}, Ljava/lang/String;->charAt(I)C

    move-result v10

    const/16 v11, 0x3c

    if-eq v10, v11, :cond_34

    .line 722
    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v6, v6, 0x1

    goto :goto_21

    :cond_34
    const/16 v10, 0x3e

    .line 726
    invoke-virtual {v0, v10, v6}, Ljava/lang/String;->indexOf(II)I

    move-result v10

    if-gez v10, :cond_41

    .line 729
    invoke-virtual {v3, v0, v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;II)Ljava/lang/StringBuilder;

    goto/16 :goto_136

    :cond_41
    add-int/lit8 v6, v6, 0x1

    .line 732
    invoke-virtual {v0, v6, v10}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    add-int/lit8 v10, v10, 0x1

    .line 736
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->length()I

    move-result v11

    if-lez v11, :cond_5e

    .line 737
    new-instance v11, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-direct {v11, v5, v12, v9}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 738
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->setLength(I)V

    .line 740
    :cond_5e
    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v11

    if-eqz v11, :cond_66

    goto/16 :goto_133

    .line 742
    :cond_66
    invoke-virtual {v6, v5}, Ljava/lang/String;->charAt(I)C

    move-result v11

    const/16 v12, 0x2f

    if-ne v11, v12, :cond_10a

    .line 743
    invoke-virtual {v6, v8}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    .line 744
    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v11

    if-eqz v11, :cond_94

    .line 746
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_133

    .line 747
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v6

    sub-int/2addr v6, v8

    invoke-interface {v2, v6}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 748
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    invoke-direct {v6, v7, v9, v9}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto/16 :goto_133

    .line 751
    :cond_94
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->normTag(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 752
    const-string v12, "c"

    const-string v13, "bg"

    if-nez v11, :cond_ad

    .line 758
    invoke-virtual {v12, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v14

    if-eqz v14, :cond_a6

    move-object v11, v12

    goto :goto_ad

    .line 759
    :cond_a6
    invoke-virtual {v13, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_ad

    move-object v11, v13

    :cond_ad
    :goto_ad
    if-nez v11, :cond_b1

    goto/16 :goto_133

    .line 763
    :cond_b1
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v6

    sub-int/2addr v6, v8

    :goto_b6
    if-ltz v6, :cond_ec

    .line 764
    invoke-interface {v2, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/String;

    .line 765
    invoke-virtual {v14, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v15

    if-eqz v15, :cond_c7

    move/from16 v16, v8

    goto :goto_ef

    .line 766
    :cond_c7
    invoke-virtual {v12, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v15

    if-eqz v15, :cond_d8

    invoke-virtual {v14, v5}, Ljava/lang/String;->charAt(I)C

    move-result v15

    move/from16 v16, v8

    const/16 v8, 0x63

    if-ne v15, v8, :cond_da

    goto :goto_ef

    :cond_d8
    move/from16 v16, v8

    .line 767
    :cond_da
    invoke-virtual {v13, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_e7

    invoke-virtual {v14, v13}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_e7

    goto :goto_ef

    :cond_e7
    add-int/lit8 v6, v6, -0x1

    move/from16 v8, v16

    goto :goto_b6

    :cond_ec
    move/from16 v16, v8

    const/4 v6, -0x1

    :goto_ef
    if-gez v6, :cond_f2

    goto :goto_133

    .line 770
    :cond_f2
    :goto_f2
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v8

    if-le v8, v6, :cond_133

    .line 771
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v8

    add-int/lit8 v8, v8, -0x1

    invoke-interface {v2, v8}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 772
    new-instance v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    invoke-direct {v8, v7, v9, v9}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_f2

    :cond_10a
    move/from16 v16, v8

    .line 776
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->normTag(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    if-nez v6, :cond_113

    goto :goto_133

    .line 778
    :cond_113
    const-string v7, "br"

    invoke-virtual {v7, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_126

    .line 779
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    const-string v7, "\n"

    invoke-direct {v6, v5, v7, v9}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_133

    .line 782
    :cond_126
    invoke-interface {v2, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 783
    new-instance v7, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    move/from16 v8, v16

    invoke-direct {v7, v8, v9, v6}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_133
    :goto_133
    move v6, v10

    goto/16 :goto_21

    .line 787
    :cond_136
    :goto_136
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->length()I

    move-result v0

    if-lez v0, :cond_148

    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v0, v5, v3, v9}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 788
    :cond_148
    :goto_148
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_162

    .line 789
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v0

    const/16 v16, 0x1

    add-int/lit8 v0, v0, -0x1

    invoke-interface {v2, v0}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 790
    new-instance v0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;

    invoke-direct {v0, v7, v9, v9}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_148

    :cond_162
    :goto_162
    return-object v1
.end method

.method private static parsePool(Ljava/lang/String;Ljava/util/LinkedHashMap;)V
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    if-eqz p0, :cond_5c

    .line 358
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_5c

    .line 359
    :cond_9
    const-string v0, "\n"

    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    const/4 v0, 0x0

    move v1, v0

    .line 360
    :goto_11
    array-length v2, p0

    if-ge v1, v2, :cond_5c

    .line 361
    aget-object v2, p0, v1

    if-nez v2, :cond_1b

    const-string v2, ""

    goto :goto_1f

    :cond_1b
    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    .line 362
    :goto_1f
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_59

    invoke-virtual {v2, v0}, Ljava/lang/String;->charAt(I)C

    move-result v3

    const/16 v4, 0x23

    if-ne v3, v4, :cond_2e

    goto :goto_59

    :cond_2e
    const/16 v3, 0x7c

    .line 363
    invoke-virtual {v2, v3}, Ljava/lang/String;->indexOf(I)I

    move-result v3

    if-gtz v3, :cond_37

    goto :goto_59

    .line 365
    :cond_37
    invoke-virtual {v2, v0, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    add-int/lit8 v3, v3, 0x1

    .line 366
    invoke-virtual {v2, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    .line 367
    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->nameOk(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_59

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_56

    goto :goto_59

    .line 368
    :cond_56
    invoke-virtual {p1, v4, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_59
    :goto_59
    add-int/lit8 v1, v1, 0x1

    goto :goto_11

    :cond_5c
    :goto_5c
    return-void
.end method

.method public static removeSpec(Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    const-string v0, "\u5df2\u6e05\u7a7a "

    const-string v1, "\u7cfb\u7edf\u63d0\u793a\u8bcd\u91cc\u6ca1\u6709 "

    .line 911
    :try_start_4
    const-string v2, "suggest"

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_f

    const-string p0, "\u3010\u8ffd\u95ee\u5efa\u8bae\u3011"

    goto :goto_11

    :cond_f
    const-string p0, "\u3010\u56de\u7b54\u6392\u7248\u3011"

    .line 912
    :goto_11
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_6b

    .line 913
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_1e

    goto :goto_6b

    .line 914
    :cond_1e
    invoke-virtual {v2, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3

    if-gez v3, :cond_36

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u8fd9\u4e00\u6bb5\uff08\u53ef\u80fd\u672c\u6765\u5c31\u6ca1\u704c\uff09"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 916
    :cond_36
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v1

    .line 917
    invoke-static {v2, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->cutParagraph(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->tidy(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 918
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->setText(Ljava/lang/String;)V

    .line 919
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\uff08"

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u5b57 \u2192 "

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u5b57\uff09\uff1b\u4f60\u81ea\u5df1\u5199\u7684\u5185\u5bb9\u539f\u6837\u4fdd\u7559"

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 913
    :cond_6b
    :goto_6b
    const-string p0, "\u7cfb\u7edf\u63d0\u793a\u8bcd\u672c\u6765\u662f\u7a7a\u7684\uff0c\u6ca1\u4ec0\u4e48\u53ef\u6e05"
    :try_end_6d
    .catchall {:try_start_4 .. :try_end_6d} :catchall_6e

    return-object p0

    :catchall_6e
    move-exception p0

    .line 922
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u6e05\u7a7a\u5931\u8d25\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static removeSpecs()Ljava/lang/String;
    .registers 4

    .line 882
    const-string v0, "\u5df2\u6e05\u7a7a\u704c\u5165\u7684\u7ea6\u5b9a\uff08"

    :try_start_2
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->text()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_4d

    .line 883
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_f

    goto :goto_4d

    .line 885
    :cond_f
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    .line 886
    const-string v3, "\u3010\u56de\u7b54\u6392\u7248\u3011"

    invoke-static {v1, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->cutParagraph(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 887
    const-string v3, "\u3010\u8ffd\u95ee\u5efa\u8bae\u3011"

    invoke-static {v1, v3}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->cutParagraph(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 888
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->tidy(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 890
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    if-ne v3, v2, :cond_2c

    .line 891
    const-string v0, "\u6ca1\u627e\u5230\u6211\u4eec\u704c\u8fdb\u53bb\u7684\u7ea6\u5b9a\uff08\u53ef\u80fd\u672c\u6765\u5c31\u6ca1\u704c\uff0c\u6216\u88ab\u624b\u52a8\u5220\u8fc7\uff09"

    return-object v0

    .line 893
    :cond_2c
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->setText(Ljava/lang/String;)V

    .line 894
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57 \u2192 "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\uff09\uff1b\u4f60\u81ea\u5df1\u5199\u7684\u5185\u5bb9\u539f\u6837\u4fdd\u7559"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 883
    :cond_4d
    :goto_4d
    const-string v0, "\u7cfb\u7edf\u63d0\u793a\u8bcd\u672c\u6765\u5c31\u662f\u7a7a\u7684\uff0c\u6ca1\u4ec0\u4e48\u53ef\u6e05"
    :try_end_4f
    .catchall {:try_start_2 .. :try_end_4f} :catchall_50

    return-object v0

    :catchall_50
    move-exception v0

    .line 897
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u6e05\u7a7a\u5931\u8d25\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static scan(Ljava/lang/String;)Ljava/util/List;
    .registers 17
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;",
            ">;"
        }
    .end annotation

    move-object/from16 v0, p0

    .line 458
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    if-eqz v0, :cond_1d7

    .line 459
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_11

    goto/16 :goto_1d7

    .line 461
    :cond_11
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    const/4 v3, 0x0

    move v4, v3

    :goto_17
    if-ge v4, v2, :cond_1d7

    .line 463
    const-string v5, "\u27e6FDM:"

    invoke-virtual {v0, v5, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    .line 464
    const-string v6, "\u27e6FDM\u27e7"

    invoke-virtual {v0, v6, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    .line 465
    const-string v7, "<Suggestion>"

    invoke-virtual {v0, v7, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v8

    .line 466
    const-string v9, "\u27e6SUG\u27e7"

    invoke-virtual {v0, v9, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v10

    move v12, v3

    const/4 v13, -0x1

    const/4 v14, -0x1

    .line 470
    :goto_34
    sget-object v15, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->DJ_OPENS:[Ljava/lang/String;

    array-length v11, v15

    if-ge v12, v11, :cond_4a

    .line 471
    aget-object v11, v15, v12

    invoke-virtual {v0, v11, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v11

    if-ltz v11, :cond_47

    if-ltz v13, :cond_45

    if-ge v11, v13, :cond_47

    :cond_45
    move v13, v11

    move v14, v12

    :cond_47
    add-int/lit8 v12, v12, 0x1

    goto :goto_34

    :cond_4a
    if-gez v5, :cond_56

    if-gez v6, :cond_56

    if-gez v8, :cond_56

    if-gez v10, :cond_56

    if-gez v13, :cond_56

    goto/16 :goto_1d7

    :cond_56
    if-ltz v5, :cond_59

    goto :goto_5a

    :cond_59
    const/4 v5, -0x1

    :goto_5a
    const/4 v4, 0x1

    if-ltz v6, :cond_63

    if-ltz v5, :cond_61

    if-ge v6, v5, :cond_63

    :cond_61
    move v5, v4

    goto :goto_65

    :cond_63
    move v6, v5

    move v5, v3

    :goto_65
    const/4 v11, 0x2

    if-ltz v8, :cond_6e

    if-ltz v6, :cond_6c

    if-ge v8, v6, :cond_6e

    :cond_6c
    move v5, v11

    goto :goto_6f

    :cond_6e
    move v8, v6

    :goto_6f
    const/4 v6, 0x3

    if-ltz v10, :cond_78

    if-ltz v8, :cond_76

    if-ge v10, v8, :cond_78

    :cond_76
    move v5, v6

    goto :goto_79

    :cond_78
    move v10, v8

    :goto_79
    const/4 v8, 0x4

    if-ltz v13, :cond_82

    if-ltz v10, :cond_80

    if-ge v13, v10, :cond_82

    :cond_80
    move v5, v8

    goto :goto_83

    :cond_82
    move v13, v10

    .line 488
    :goto_83
    const-string v10, ""

    if-ne v5, v8, :cond_c6

    .line 491
    aget-object v5, v15, v14

    .line 492
    sget-object v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->DJ_CLOSES:[Ljava/lang/String;

    aget-object v6, v6, v14

    .line 493
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v7

    add-int/2addr v7, v13

    invoke-virtual {v0, v6, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v7

    if-gez v7, :cond_9a

    goto/16 :goto_1d7

    .line 495
    :cond_9a
    new-instance v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;

    invoke-direct {v8}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;-><init>()V

    .line 496
    iput v13, v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    .line 497
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v6

    add-int/2addr v6, v7

    iput v6, v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    .line 498
    iput-boolean v4, v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->dj:Z

    .line 499
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v4

    add-int/2addr v13, v4

    invoke-virtual {v0, v13, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    iput-object v4, v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->djBody:Ljava/lang/String;

    .line 500
    iput-object v10, v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    .line 501
    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->EMPTY_ARGS:[Ljava/lang/String;

    iput-object v4, v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->args:[Ljava/lang/String;

    .line 502
    invoke-interface {v1, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 503
    iget v4, v8, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    goto/16 :goto_17

    :cond_c6
    const/16 v8, 0x7c

    if-eq v5, v11, :cond_15b

    if-ne v5, v6, :cond_ce

    goto/16 :goto_15b

    :cond_ce
    if-ne v5, v4, :cond_f6

    .line 536
    const-string v5, "\u27e6/FDM\u27e7"

    add-int/lit8 v6, v13, 0x5

    invoke-virtual {v0, v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    if-gez v5, :cond_dc

    goto/16 :goto_1d7

    .line 538
    :cond_dc
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;-><init>()V

    .line 539
    iput v13, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    add-int/lit8 v5, v5, 0x6

    .line 540
    iput v5, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    .line 541
    iput-boolean v4, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->anonymous:Z

    .line 542
    iput-object v10, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    .line 543
    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->EMPTY_ARGS:[Ljava/lang/String;

    iput-object v4, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->args:[Ljava/lang/String;

    .line 544
    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 545
    iget v4, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    goto/16 :goto_17

    :cond_f6
    add-int/lit8 v4, v13, 0x5

    .line 549
    const-string v5, "\u27e7"

    invoke-virtual {v0, v5, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v5

    if-gez v5, :cond_102

    goto/16 :goto_1d7

    .line 551
    :cond_102
    invoke-virtual {v0, v4, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    .line 552
    new-instance v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;

    invoke-direct {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;-><init>()V

    .line 553
    iput v13, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    add-int/lit8 v5, v5, 0x1

    .line 554
    iput v5, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    .line 556
    invoke-virtual {v4, v8}, Ljava/lang/String;->indexOf(I)I

    move-result v5

    if-gez v5, :cond_122

    .line 558
    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    iput-object v4, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    .line 559
    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->EMPTY_ARGS:[Ljava/lang/String;

    iput-object v4, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->args:[Ljava/lang/String;

    goto :goto_14a

    .line 561
    :cond_122
    invoke-virtual {v4, v3, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    iput-object v7, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    add-int/lit8 v5, v5, 0x1

    .line 562
    invoke-virtual {v4, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "\\|"

    const/4 v7, -0x1

    invoke-virtual {v4, v5, v7}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v4

    move v5, v3

    .line 563
    :goto_13a
    array-length v7, v4

    if-ge v5, v7, :cond_148

    aget-object v7, v4, v5

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    aput-object v7, v4, v5

    add-int/lit8 v5, v5, 0x1

    goto :goto_13a

    .line 564
    :cond_148
    iput-object v4, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->args:[Ljava/lang/String;

    .line 567
    :goto_14a
    iget v4, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    .line 568
    iget-object v5, v6, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    invoke-static {v5}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->nameOk(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_156

    goto/16 :goto_17

    .line 569
    :cond_156
    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto/16 :goto_17

    :cond_15b
    :goto_15b
    if-ne v5, v11, :cond_15e

    goto :goto_15f

    :cond_15e
    move-object v7, v9

    :goto_15f
    if-ne v5, v11, :cond_164

    .line 510
    const-string v5, "</Suggestion>"

    goto :goto_166

    :cond_164
    const-string v5, "\u27e6/SUG\u27e7"

    .line 511
    :goto_166
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v6

    add-int/2addr v6, v13

    invoke-virtual {v0, v5, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v6

    if-gez v6, :cond_172

    goto :goto_1d7

    .line 513
    :cond_172
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    add-int/2addr v7, v13

    invoke-virtual {v0, v7, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v7

    .line 514
    new-instance v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;

    invoke-direct {v9}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;-><init>()V

    .line 515
    iput v13, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    .line 516
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v5

    add-int/2addr v6, v5

    iput v6, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    .line 517
    iput-boolean v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->suggest:Z

    .line 518
    iput-object v10, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->name:Ljava/lang/String;

    .line 519
    sget-object v4, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->EMPTY_ARGS:[Ljava/lang/String;

    iput-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->args:[Ljava/lang/String;

    .line 520
    invoke-virtual {v7, v8}, Ljava/lang/String;->indexOf(I)I

    move-result v4

    if-gez v4, :cond_19e

    .line 522
    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    iput-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    goto :goto_1b4

    .line 524
    :cond_19e
    invoke-virtual {v7, v3, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v5

    iput-object v5, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    add-int/lit8 v4, v4, 0x1

    .line 525
    invoke-virtual {v7, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    iput-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugPayload:Ljava/lang/String;

    .line 527
    :goto_1b4
    iget-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1c0

    const-string v4, "\u25b8 \u8ffd\u95ee"

    iput-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    .line 528
    :cond_1c0
    iget-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugPayload:Ljava/lang/String;

    if-eqz v4, :cond_1cc

    iget-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugPayload:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1d0

    :cond_1cc
    iget-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugLabel:Ljava/lang/String;

    iput-object v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->sugPayload:Ljava/lang/String;

    .line 529
    :cond_1d0
    invoke-interface {v1, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 530
    iget v4, v9, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    goto/16 :goto_17

    :cond_1d7
    :goto_1d7
    return-object v1
.end method

.method public static setBare(Z)V
    .registers 4

    .line 305
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 308
    :cond_7
    :try_start_7
    const-string v1, "fuckds_rich_bare"

    if-eqz p0, :cond_e

    const-string p0, "true"

    goto :goto_10

    :cond_e
    const-string p0, "false"

    :goto_10
    const-string v2, "b"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_15
    .catchall {:try_start_7 .. :try_end_15} :catchall_16

    return-void

    :catchall_16
    move-exception p0

    .line 310
    const-string v0, "richText.setBare"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setOn(Z)V
    .registers 4

    .line 284
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 287
    :cond_7
    :try_start_7
    const-string v1, "fuckds_rich_on"

    if-eqz p0, :cond_e

    const-string p0, "true"

    goto :goto_10

    :cond_e
    const-string p0, "false"

    :goto_10
    const-string v2, "b"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_15
    .catchall {:try_start_7 .. :try_end_15} :catchall_16

    return-void

    :catchall_16
    move-exception p0

    .line 289
    const-string v0, "richText.setOn"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static setPalette(II)V
    .registers 5

    const-string v0, "fuckds_rich_c"

    const/4 v1, 0x1

    if-lt p0, v1, :cond_2d

    const/16 v1, 0x9

    if-le p0, v1, :cond_a

    goto :goto_2d

    .line 405
    :cond_a
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-nez v1, :cond_11

    goto :goto_2d

    .line 408
    :cond_11
    :try_start_11
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p1

    const-string v0, "i"

    invoke-static {v1, p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_26
    .catchall {:try_start_11 .. :try_end_26} :catchall_27

    return-void

    :catchall_27
    move-exception p0

    .line 410
    const-string p1, "richText.setPalette"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_2d
    :goto_2d
    return-void
.end method

.method public static spec()Ljava/lang/String;
    .registers 4

    .line 805
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->names()Ljava/util/List;

    move-result-object v0

    .line 806
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u3010\u56de\u7b54\u6392\u7248\u3011\u4ee5\u4e0b\u662f\u53ef\u7528\u7684\u5bcc\u6587\u672c\u6807\u7b7e\uff0c\u5199\u4e0a\u5c31\u4f1a\u88ab\u6e32\u67d3\u6210\u771f\u6b63\u7684\u6837\u5f0f\uff0c\u8bf7\u9002\u5f53\u4f7f\u7528\u6765\u8ba9\u56de\u7b54\u66f4\u6e05\u695a\uff1a\n  <b>\u7c97\u4f53</b>  <i>\u659c\u4f53</i>  <u>\u4e0b\u5212\u7ebf</u>  <s>\u5220\u9664\u7ebf</s>\n  <c1>\u6587\u5b57</c1> \u2026 <c9>\u6587\u5b57</c9>\uff1a\u4e5d\u79cd\u989c\u8272\uff08\u7ed3\u675f\u6807\u7b7e\u5199 </c> \u4e5f\u884c\uff09\n  <c#FF0000>\u7ea2\u8272</c>\uff1a\u76f4\u63a5\u6307\u5b9a\u989c\u8272\uff0c\u7528\u516d\u4f4d\u5341\u516d\u8fdb\u5236\n  <bg1>\u6587\u5b57</bg1> \u2026 <bg9>\u6587\u5b57</bg9>\uff1a\u4e5d\u79cd\u80cc\u666f\u9ad8\u4eae\uff1b<bg#FFFF00>\u9ad8\u4eae</bg> \u540c\u7406\n  <br>\uff1a\u6362\u884c\n\u2605 \u76f4\u63a5\u5199\u5c31\u884c\uff0c\u4e0d\u8981\u518d\u7528\u522b\u7684\u7b26\u53f7\u628a\u6807\u7b7e\u5305\u8d77\u6765\u3002\u5728\u4ee3\u7801\u5757\u91cc\u4e0d\u8981\u4f7f\u7528\u8fd9\u4e9b\u6807\u7b7e\u3002\n"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 816
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_17

    .line 817
    const-string v0, "\uff08\u5f53\u524d\u8fd8\u6ca1\u6709\u914d\u7f6e\u4efb\u4f55\u6392\u7248\u6a21\u677f\u3002\uff09\n"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_4a

    .line 819
    :cond_17
    const-string v2, "\u53e6\u5916\u8fd8\u6709\u51e0\u4e2a\u73b0\u6210\u7684\u6392\u7248\u6a21\u677f\uff0c\u7528 \u27e6FDM:\u540d\u5b57|\u53c2\u65701|\u53c2\u65702\u27e7 \u8c03\u7528\uff1a\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 820
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_20
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4a

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 821
    const-string v3, "  "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " \u2192 "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->tpl(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->oneLine(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v2, 0xa

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_20

    .line 824
    :cond_4a
    :goto_4a
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static suggestSpec()Ljava/lang/String;
    .registers 1

    .line 859
    const-string v0, "\u3010\u8ffd\u95ee\u5efa\u8bae\u3011\u5f53\u4f60\u60f3\u8ba9\u7528\u6237\u7ee7\u7eed\u8ffd\u95ee\u3001\u6216\u60f3\u5f15\u5bfc\u5bf9\u8bdd\u65b9\u5411\u65f6\uff0c\u5728\u56de\u590d\u7684\u6700\u540e\u53e6\u8d77\u4e00\u884c\u8f93\u51fa\uff1a\n  <Suggestion>\u25b8 \u4f60\u7684\u5efa\u8bae\u95ee\u9898</Suggestion>\n\u53ef\u4ee5\u5199\u591a\u884c\uff0c\u6bcf\u884c\u4e00\u6761\u5efa\u8bae\uff0c\u754c\u9762\u4f1a\u6e32\u67d3\u6210\u53ef\u70b9\u51fb\u7684\u6309\u94ae\u3002\n\u2605 \u60f3\u300c\u663e\u793a\u77ed\u4e00\u70b9\u3001\u5b9e\u9645\u53d1\u7684\u5185\u5bb9\u957f\u4e00\u70b9\u300d\u65f6\uff0c\u7528\u7ad6\u7ebf\u5206\u5f00\uff1a\n  <Suggestion>\u25b8 \u8bf4\u8bf4\u770b|\u8bf7\u4ece\u539f\u7406\u4e0a\u8be6\u7ec6\u89e3\u91ca\u4e00\u4e0b</Suggestion>\n\u2605 \u76f4\u63a5\u5199\u5c31\u884c\uff0c\u4e0d\u8981\u5728\u4ee3\u7801\u5757\u91cc\u5199\uff0c\u4e5f\u4e0d\u8981\u518d\u7528\u522b\u7684\u7b26\u53f7\u628a\u5b83\u5305\u8d77\u6765\u3002\n"

    return-object v0
.end method

.method private static textOr(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    .line 260
    :try_start_0
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->get(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    if-eqz v0, :cond_d

    .line 261
    invoke-interface {v0, p1}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_d

    if-nez v0, :cond_d

    goto :goto_17

    .line 266
    :catchall_d
    :cond_d
    :try_start_d
    const-string v0, "s"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_13
    .catchall {:try_start_d .. :try_end_13} :catchall_17

    if-nez p0, :cond_16

    goto :goto_17

    :cond_16
    move-object p2, p0

    :catchall_17
    :goto_17
    return-object p2
.end method

.method private static tidy(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    if-nez p0, :cond_5

    .line 944
    const-string p0, ""

    return-object p0

    .line 945
    :cond_5
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 946
    :goto_9
    const-string v0, "\n\n\n"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_18

    .line 947
    const-string v1, "\n\n"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    goto :goto_9

    :cond_18
    return-object p0
.end method

.method public static tpl(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 379
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->nameOk(Ljava/lang/String;)Z

    move-result v0

    const-string v1, ""

    if-nez v0, :cond_9

    return-object v1

    .line 380
    :cond_9
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->tplMap()Ljava/util/LinkedHashMap;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    if-nez p0, :cond_16

    return-object v1

    :cond_16
    return-object p0
.end method

.method public static tplMap()Ljava/util/LinkedHashMap;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 337
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    .line 339
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    .line 340
    const-string v2, ""

    if-eqz v1, :cond_1f

    .line 342
    :try_start_d
    const-string v3, "fuckds_rich_tpls"

    const-string v4, "s"

    invoke-static {v1, v3, v4}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1
    :try_end_15
    .catchall {:try_start_d .. :try_end_15} :catchall_19

    if-eqz v1, :cond_1f

    move-object v2, v1

    goto :goto_1f

    :catchall_19
    move-exception v1

    .line 345
    const-string v3, "richText.tplMap"

    invoke-static {v3, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 348
    :cond_1f
    :goto_1f
    invoke-static {v2, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->parsePool(Ljava/lang/String;Ljava/util/LinkedHashMap;)V

    .line 349
    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_49

    .line 351
    const-string v1, "# \u6bcf\u884c\u4e00\u6761\uff1a\u540d\u5b57|\u5bcc\u6587\u672c\uff08HTML \u5b50\u96c6\uff0c\u6362\u884c\u7528 <br>\uff09\ndemo|<b>\u2726 {1}</b> {2}\ntip|<c6>\u25b8 {1}</c>\nwarn|<bg3><c#000000> \u26a0 {1} </c></bg>\ncard|<c7>\u250c {1}</c><br><c7>\u2514</c> {2}\nhi|<b><c4>\u4f60\u597d\uff0c{1}</c></b> \u4eca\u5929{c2}\u5f88\u597d</c>\uff01"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->parsePool(Ljava/lang/String;Ljava/util/LinkedHashMap;)V

    .line 352
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u6a21\u677f\u6c60\u662f\u7a7a\u7684 \u21d2 \u7528\u5f00\u7bb1\u793a\u4f8b\u6a21\u677f\uff08"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, "\uff09"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "richHook.demo"

    invoke-static {v2, v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    :cond_49
    return-object v0
.end method
