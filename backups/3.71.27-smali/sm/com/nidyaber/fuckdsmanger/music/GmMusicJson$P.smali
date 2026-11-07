.class final Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;
.super Ljava/lang/Object;
.source "GmMusicJson.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "P"
.end annotation


# instance fields
.field private i:I

.field private final s:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;)V
    .registers 2

    .line 41
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 42
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method array()Ljava/util/List;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 88
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 89
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    .line 90
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 91
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->peek()C

    move-result v1

    const/16 v2, 0x5d

    if-ne v1, v2, :cond_1d

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    return-object v0

    .line 92
    :cond_1d
    :goto_1d
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v1, v3, :cond_48

    .line 93
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->value()Ljava/lang/Object;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 94
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 95
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->peek()C

    move-result v1

    const/16 v3, 0x2c

    if-ne v1, v3, :cond_40

    .line 96
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    goto :goto_1d

    :cond_40
    if-ne v1, v2, :cond_48

    .line 97
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    :cond_48
    return-object v0
.end method

.method number()Ljava/lang/Object;
    .registers 7

    .line 138
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    .line 139
    :goto_2
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    const/16 v3, 0x45

    const/16 v4, 0x65

    const/16 v5, 0x2e

    if-ge v1, v2, :cond_37

    .line 140
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    iget v2, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    invoke-virtual {v1, v2}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x2d

    if-eq v1, v2, :cond_30

    const/16 v2, 0x2b

    if-eq v1, v2, :cond_30

    if-eq v1, v5, :cond_30

    if-eq v1, v4, :cond_30

    if-eq v1, v3, :cond_30

    const/16 v2, 0x30

    if-lt v1, v2, :cond_37

    const/16 v2, 0x39

    if-gt v1, v2, :cond_37

    .line 143
    :cond_30
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    goto :goto_2

    .line 148
    :cond_37
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    invoke-virtual {v1, v0, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    .line 149
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_47

    return-object v1

    .line 151
    :cond_47
    :try_start_47
    invoke-virtual {p0, v5}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    if-gez v0, :cond_62

    invoke-virtual {p0, v4}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    if-gez v0, :cond_62

    invoke-virtual {p0, v3}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    if-gez v0, :cond_62

    .line 152
    invoke-static {p0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    return-object p0

    .line 154
    :cond_62
    invoke-static {p0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object p0
    :try_end_6a
    .catchall {:try_start_47 .. :try_end_6a} :catchall_6b

    return-object p0

    :catchall_6b
    return-object v1
.end method

.method object()Ljava/util/Map;
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 68
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    .line 69
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    .line 70
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 71
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->peek()C

    move-result v1

    const/16 v2, 0x7d

    if-ne v1, v2, :cond_1d

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    return-object v0

    .line 72
    :cond_1d
    :goto_1d
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v1, v3, :cond_60

    .line 73
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 74
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->string()Ljava/lang/String;

    move-result-object v1

    .line 75
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 76
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->peek()C

    move-result v3

    const/16 v4, 0x3a

    if-ne v3, v4, :cond_3f

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v3, v3, 0x1

    iput v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    .line 77
    :cond_3f
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->value()Ljava/lang/Object;

    move-result-object v3

    invoke-interface {v0, v1, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 78
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 79
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->peek()C

    move-result v1

    const/16 v3, 0x2c

    if-ne v1, v3, :cond_58

    .line 80
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    goto :goto_1d

    :cond_58
    if-ne v1, v2, :cond_60

    .line 81
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    :cond_60
    return-object v0
.end method

.method peek()C
    .registers 3

    .line 50
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_13

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    invoke-virtual {v0, p0}, Ljava/lang/String;->charAt(I)C

    move-result p0

    return p0

    :cond_13
    const/4 p0, 0x0

    return p0
.end method

.method string()Ljava/lang/String;
    .registers 7

    .line 104
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 105
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->peek()C

    move-result v1

    const/16 v2, 0x22

    if-eq v1, v2, :cond_12

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 106
    :cond_12
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    .line 107
    :cond_18
    :goto_18
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v1, v3, :cond_d0

    .line 108
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v4, v3, 0x1

    iput v4, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    invoke-virtual {v1, v3}, Ljava/lang/String;->charAt(I)C

    move-result v1

    if-ne v1, v2, :cond_32

    goto/16 :goto_d0

    :cond_32
    const/16 v3, 0x5c

    if-eq v1, v3, :cond_3a

    .line 110
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_18

    .line 111
    :cond_3a
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    if-lt v1, v4, :cond_46

    goto/16 :goto_d0

    .line 112
    :cond_46
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    iget v4, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v5, v4, 0x1

    iput v5, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    invoke-virtual {v1, v4}, Ljava/lang/String;->charAt(I)C

    move-result v1

    if-eq v1, v2, :cond_cb

    const/16 v4, 0x2f

    if-eq v1, v4, :cond_c6

    if-eq v1, v3, :cond_c1

    const/16 v3, 0x62

    if-eq v1, v3, :cond_ba

    const/16 v3, 0x66

    if-eq v1, v3, :cond_b3

    const/16 v3, 0x6e

    if-eq v1, v3, :cond_ac

    const/16 v3, 0x72

    if-eq v1, v3, :cond_a5

    const/16 v3, 0x74

    if-eq v1, v3, :cond_9e

    const/16 v3, 0x75

    if-eq v1, v3, :cond_76

    .line 131
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_18

    .line 123
    :cond_76
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x4

    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    if-gt v1, v3, :cond_18

    .line 125
    :try_start_82
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    iget v3, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v4, v3, 0x4

    invoke-virtual {v1, v3, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    const/16 v3, 0x10

    invoke-static {v1, v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;I)I

    move-result v1

    int-to-char v1, v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    :try_end_96
    .catchall {:try_start_82 .. :try_end_96} :catchall_96

    .line 128
    :catchall_96
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v1, v1, 0x4

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    goto/16 :goto_18

    :cond_9e
    const/16 v1, 0x9

    .line 115
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    :cond_a5
    const/16 v1, 0xd

    .line 116
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    :cond_ac
    const/16 v1, 0xa

    .line 114
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    :cond_b3
    const/16 v1, 0xc

    .line 118
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    :cond_ba
    const/16 v1, 0x8

    .line 117
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    .line 121
    :cond_c1
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    .line 119
    :cond_c6
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    .line 120
    :cond_cb
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto/16 :goto_18

    .line 134
    :cond_d0
    :goto_d0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method value()Ljava/lang/Object;
    .registers 3

    .line 54
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 55
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->peek()C

    move-result v0

    const/16 v1, 0x22

    if-eq v0, v1, :cond_48

    const/16 v1, 0x5b

    if-eq v0, v1, :cond_43

    const/16 v1, 0x66

    if-eq v0, v1, :cond_3a

    const/16 v1, 0x6e

    if-eq v0, v1, :cond_32

    const/16 v1, 0x74

    if-eq v0, v1, :cond_29

    const/16 v1, 0x7b

    if-eq v0, v1, :cond_24

    .line 63
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->number()Ljava/lang/Object;

    move-result-object p0

    return-object p0

    .line 57
    :cond_24
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->object()Ljava/util/Map;

    move-result-object p0

    return-object p0

    .line 60
    :cond_29
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v0, v0, 0x4

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    sget-object p0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    return-object p0

    .line 62
    :cond_32
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v0, v0, 0x4

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    const/4 p0, 0x0

    return-object p0

    .line 61
    :cond_3a
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v0, v0, 0x5

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    sget-object p0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p0

    .line 58
    :cond_43
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->array()Ljava/util/List;

    move-result-object p0

    return-object p0

    .line 59
    :cond_48
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->string()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method ws()V
    .registers 3

    .line 46
    :goto_0
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_1f

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->s:Ljava/lang/String;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    invoke-virtual {v0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v0

    invoke-static {v0}, Ljava/lang/Character;->isWhitespace(C)Z

    move-result v0

    if-eqz v0, :cond_1f

    iget v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->i:I

    goto :goto_0

    :cond_1f
    return-void
.end method
