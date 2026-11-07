.class public final Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;
.super Ljava/lang/Object;
.source "GmMusicJson.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static arr(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/List;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 256
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    if-nez p0, :cond_8

    const/4 p0, 0x0

    return-object p0

    .line 257
    :cond_8
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asArr(Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public static asArr(Ljava/lang/Object;)Ljava/util/List;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 245
    instance-of v0, p0, Ljava/util/List;

    if-eqz v0, :cond_7

    check-cast p0, Ljava/util/List;

    return-object p0

    :cond_7
    const/4 p0, 0x0

    return-object p0
.end method

.method public static asObj(Ljava/lang/Object;)Ljava/util/Map;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 240
    instance-of v0, p0, Ljava/util/Map;

    if-eqz v0, :cond_7

    check-cast p0, Ljava/util/Map;

    return-object p0

    :cond_7
    const/4 p0, 0x0

    return-object p0
.end method

.method public static bool(Ljava/lang/Object;Ljava/lang/String;Z)Z
    .registers 3

    .line 286
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    if-nez p0, :cond_7

    goto :goto_16

    .line 288
    :cond_7
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 289
    instance-of p1, p0, Ljava/lang/Boolean;

    if-eqz p1, :cond_16

    check-cast p0, Ljava/lang/Boolean;

    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    return p0

    :cond_16
    :goto_16
    return p2
.end method

.method public static in(Ljava/lang/Object;Ljava/lang/String;I)I
    .registers 5

    int-to-long v0, p2

    .line 282
    invoke-static {p0, p1, v0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide p0

    long-to-int p0, p0

    return p0
.end method

.method public static lng(Ljava/lang/Object;Ljava/lang/String;J)J
    .registers 4

    .line 268
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    if-nez p0, :cond_7

    goto :goto_21

    .line 270
    :cond_7
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 271
    instance-of p1, p0, Ljava/lang/Number;

    if-eqz p1, :cond_16

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide p0

    return-wide p0

    .line 272
    :cond_16
    instance-of p1, p0, Ljava/lang/String;

    if-eqz p1, :cond_21

    .line 274
    :try_start_1a
    check-cast p0, Ljava/lang/String;

    invoke-static {p0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide p0
    :try_end_20
    .catchall {:try_start_1a .. :try_end_20} :catchall_21

    return-wide p0

    :catchall_21
    :cond_21
    :goto_21
    return-wide p2
.end method

.method public static obj()Ljava/util/Map;
    .registers 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 224
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    return-object v0
.end method

.method public static varargs obj([Ljava/lang/Object;)Ljava/util/Map;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 229
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj()Ljava/util/Map;

    move-result-object v0

    const/4 v1, 0x0

    :goto_5
    add-int/lit8 v2, v1, 0x1

    .line 230
    array-length v3, p0

    if-ge v2, v3, :cond_18

    .line 231
    aget-object v3, p0, v1

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    aget-object v2, p0, v2

    invoke-interface {v0, v3, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 v1, v1, 0x2

    goto :goto_5

    :cond_18
    return-object v0
.end method

.method public static parse(Ljava/lang/String;)Ljava/lang/Object;
    .registers 2

    if-nez p0, :cond_4

    const/4 p0, 0x0

    return-object p0

    .line 32
    :cond_4
    new-instance v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;-><init>(Ljava/lang/String;)V

    .line 33
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->ws()V

    .line 34
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson$P;->value()Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private static quote(Ljava/lang/StringBuilder;Ljava/lang/String;)V
    .registers 6

    const/16 v0, 0x22

    .line 203
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const/4 v1, 0x0

    .line 204
    :goto_6
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_67

    .line 205
    invoke-virtual {p1, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0xc

    if-eq v2, v3, :cond_5f

    const/16 v3, 0xd

    if-eq v2, v3, :cond_59

    if-eq v2, v0, :cond_53

    const/16 v3, 0x5c

    if-eq v2, v3, :cond_4d

    packed-switch v2, :pswitch_data_6c

    const/16 v3, 0x20

    if-ge v2, v3, :cond_37

    .line 215
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    const-string v3, "\\u%04x"

    invoke-static {v3, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 216
    :cond_37
    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 209
    :pswitch_3b
    const-string v2, "\\n"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 211
    :pswitch_41
    const-string v2, "\\t"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 212
    :pswitch_47
    const-string v2, "\\b"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 208
    :cond_4d
    const-string v2, "\\\\"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 207
    :cond_53
    const-string v2, "\\\""

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 210
    :cond_59
    const-string v2, "\\r"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_64

    .line 213
    :cond_5f
    const-string v2, "\\f"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_64
    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    .line 219
    :cond_67
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    return-void

    nop

    :pswitch_data_6c
    .packed-switch 0x8
        :pswitch_47
        :pswitch_41
        :pswitch_3b
    .end packed-switch
.end method

.method public static str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 261
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    if-nez p0, :cond_7

    goto :goto_d

    .line 263
    :cond_7
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_e

    :goto_d
    return-object p2

    .line 264
    :cond_e
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 250
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    if-nez p0, :cond_8

    const/4 p0, 0x0

    return-object p0

    .line 251
    :cond_8
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    return-object p0
.end method

.method public static write(Ljava/lang/Object;)Ljava/lang/String;
    .registers 2

    .line 165
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 166
    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->writeTo(Ljava/lang/StringBuilder;Ljava/lang/Object;)V

    .line 167
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static writeTo(Ljava/lang/StringBuilder;Ljava/lang/Object;)V
    .registers 6

    if-nez p1, :cond_8

    .line 172
    const-string p1, "null"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    return-void

    .line 173
    :cond_8
    instance-of v0, p1, Ljava/lang/String;

    if-eqz v0, :cond_12

    .line 174
    check-cast p1, Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->quote(Ljava/lang/StringBuilder;Ljava/lang/String;)V

    return-void

    .line 175
    :cond_12
    instance-of v0, p1, Ljava/lang/Boolean;

    if-nez v0, :cond_94

    instance-of v0, p1, Ljava/lang/Number;

    if-eqz v0, :cond_1c

    goto/16 :goto_94

    .line 177
    :cond_1c
    instance-of v0, p1, Ljava/util/Map;

    const/16 v1, 0x2c

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v0, :cond_63

    const/16 v0, 0x7b

    .line 178
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 180
    check-cast p1, Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_33
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5d

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    if-nez v3, :cond_44

    .line 181
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 183
    :cond_44
    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-static {p0, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->quote(Ljava/lang/StringBuilder;Ljava/lang/String;)V

    const/16 v3, 0x3a

    .line 184
    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 185
    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->writeTo(Ljava/lang/StringBuilder;Ljava/lang/Object;)V

    move v3, v2

    goto :goto_33

    :cond_5d
    const/16 p1, 0x7d

    .line 187
    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    return-void

    .line 188
    :cond_63
    instance-of v0, p1, Ljava/util/List;

    if-eqz v0, :cond_8c

    const/16 v0, 0x5b

    .line 189
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 191
    check-cast p1, Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_72
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_86

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    if-nez v3, :cond_81

    .line 192
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 194
    :cond_81
    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->writeTo(Ljava/lang/StringBuilder;Ljava/lang/Object;)V

    move v3, v2

    goto :goto_72

    :cond_86
    const/16 p1, 0x5d

    .line 196
    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    return-void

    .line 198
    :cond_8c
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->quote(Ljava/lang/StringBuilder;Ljava/lang/String;)V

    return-void

    .line 176
    :cond_94
    :goto_94
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    return-void
.end method
