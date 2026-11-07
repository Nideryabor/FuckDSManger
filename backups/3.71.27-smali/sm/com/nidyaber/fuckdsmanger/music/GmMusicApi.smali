.class public final Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;
.super Ljava/lang/Object;
.source "GmMusicApi.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;
    }
.end annotation


# static fields
.field public static final API_DOMAIN:Ljava/lang/String; = "https://interface.music.163.com"

.field private static final DEVICE_ID:Ljava/lang/String;

.field public static final DOMAIN:Ljava/lang/String; = "https://music.163.com"

.field public static final L_EXHIGH:Ljava/lang/String; = "exhigh"

.field public static final L_HIGHER:Ljava/lang/String; = "higher"

.field public static final L_LOSSLESS:Ljava/lang/String; = "lossless"

.field public static final L_STANDARD:Ljava/lang/String; = "standard"

.field public static final OS_ANDROID:I = 0x1

.field public static final OS_IPHONE:I = 0x2

.field public static final OS_PC:I

.field private static final SEQ:Ljava/util/concurrent/atomic/AtomicInteger;

.field private static final UTF8:Ljava/nio/charset/Charset;

.field private static volatile sLastCode:I

.field private static volatile sLastSetCookie:Ljava/lang/String;

.field private static volatile sLog:Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;

.field private static volatile sMusicA:Ljava/lang/String;

.field private static volatile sMusicU:Ljava/lang/String;

.field private static volatile sOsMode:I


# direct methods
.method static constructor <clinit>()V
    .registers 3

    .line 35
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->UTF8:Ljava/nio/charset/Charset;

    const/4 v0, 0x2

    .line 62
    sput v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    const/4 v0, 0x0

    .line 125
    sput-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLog:Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;

    .line 142
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "-"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->DEVICE_ID:Ljava/lang/String;

    .line 143
    new-instance v0, Ljava/util/concurrent/atomic/AtomicInteger;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicInteger;-><init>(I)V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->SEQ:Ljava/util/concurrent/atomic/AtomicInteger;

    .line 146
    sput-object v2, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    const/4 v0, -0x1

    .line 158
    sput v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastCode:I

    .line 165
    sput-object v2, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicA:Ljava/lang/String;

    .line 229
    sput-object v2, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastSetCookie:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 175
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static brief(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    if-nez p0, :cond_5

    .line 496
    const-string p0, "null"

    return-object p0

    .line 497
    :cond_5
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0xc8

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
    return-object p0
.end method

.method public static captchaSent(Ljava/lang/String;Ljava/lang/String;)Ljava/util/Map;
    .registers 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-eqz p1, :cond_8

    .line 275
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_a

    :cond_8
    const-string p1, "86"

    :cond_a
    move-object v1, p1

    const-string v3, "music_middleuser_pclogin"

    const-string v4, "cellphone"

    const-string v0, "ctcode"

    const-string v2, "secrete"

    move-object v5, p0

    filled-new-array/range {v0 .. v5}, [Ljava/lang/Object;

    move-result-object p0

    .line 274
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    .line 278
    const-string p1, "/api/sms/captcha/sent"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->weapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    .line 279
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->result(Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    return-object p0
.end method

.method private static d(Ljava/lang/String;)V
    .registers 2

    .line 132
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLog:Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;

    if-eqz v0, :cond_7

    .line 133
    invoke-interface {v0, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;->d(Ljava/lang/String;)V

    :cond_7
    return-void
.end method

.method public static deviceId()Ljava/lang/String;
    .registers 1

    .line 704
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->DEVICE_ID:Ljava/lang/String;

    return-object v0
.end method

.method private static e(Ljava/lang/String;Ljava/lang/Throwable;)V
    .registers 3

    .line 137
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLog:Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;

    if-eqz v0, :cond_7

    .line 138
    invoke-interface {v0, p0, p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;->e(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_7
    return-void
.end method

.method public static eapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 187
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->write(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 188
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicCrypto;->eapi(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 189
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 190
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v3, "_"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v3, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->SEQ:Ljava/util/concurrent/atomic/AtomicInteger;

    invoke-virtual {v3}, Ljava/util/concurrent/atomic/AtomicInteger;->getAndIncrement()I

    move-result v3

    rem-int/lit16 v3, v3, 0x2710

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    const-string v4, "%04d"

    invoke-static {v4, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 192
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "osver="

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 193
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->osVer()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 194
    const-string v4, "; deviceId="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v4, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->DEVICE_ID:Ljava/lang/String;

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 195
    const-string v4, "; os="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->osName()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 196
    const-string v4, "; appver="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->osAppVer()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 197
    const-string v4, "; versioncode=140; mobilename=; buildver="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 199
    invoke-static {v0, v1}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    const/16 v4, 0xa

    invoke-virtual {v0, v1, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 200
    const-string v0, "; resolution=1920x1080; __csrf=; channel="

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 202
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->osChannel()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 203
    const-string v0, "; requestId="

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 204
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    if-eqz v0, :cond_c3

    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_c3

    const-string v0, "; MUSIC_U="

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 205
    :cond_c3
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicA:Ljava/lang/String;

    if-eqz v0, :cond_dd

    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicA:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_dd

    const-string v0, "; MUSIC_A="

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicA:Ljava/lang/String;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->enc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 207
    :cond_dd
    const-string v0, "/api/"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_eb

    const/4 v0, 0x5

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    goto :goto_ec

    :cond_eb
    move-object v0, p0

    .line 208
    :goto_ec
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "https://interface.music.163.com/eapi/"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 210
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "params="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 211
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->osUa()Ljava/lang/String;

    move-result-object v2

    .line 210
    const-string v3, "application/x-www-form-urlencoded"

    invoke-static {v0, p1, v3, v1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->post(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 212
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->parse(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object v0

    if-eqz v0, :cond_155

    .line 216
    const-string v1, "code"

    const-wide/16 v2, -0x1

    invoke-static {v0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v1

    long-to-int v1, v1

    .line 217
    sput v1, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastCode:I

    const/16 v2, 0xc8

    if-eq v1, v2, :cond_154

    .line 218
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "[MusicApi] "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " \u975e 200 \u21d2 code="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u00b7 "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->brief(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->d(Ljava/lang/String;)V

    :cond_154
    return-object v0

    .line 213
    :cond_155
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u54cd\u5e94\u4e0d\u662f JSON\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->brief(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static enc(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    .line 489
    :try_start_0
    const-string v0, "UTF-8"

    invoke-static {p0, v0}, Ljava/net/URLEncoder;->encode(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "+"

    const-string v2, "%20"

    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0
    :try_end_e
    .catchall {:try_start_0 .. :try_end_e} :catchall_e

    :catchall_e
    return-object p0
.end method

.method public static hasLogin()Z
    .registers 1

    .line 699
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    if-eqz v0, :cond_e

    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_e

    const/4 v0, 0x1

    return v0

    :cond_e
    const/4 v0, 0x0

    return v0
.end method

.method public static lastCode()I
    .registers 1

    .line 162
    sget v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastCode:I

    return v0
.end method

.method public static lastSetCookie()Ljava/lang/String;
    .registers 1

    .line 232
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastSetCookie:Ljava/lang/String;

    return-object v0
.end method

.method public static login()Ljava/lang/String;
    .registers 1

    .line 172
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    return-object v0
.end method

.method public static loginByCaptcha(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/util/Map;
    .registers 15
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-eqz p2, :cond_8

    .line 293
    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_a

    :cond_8
    const-string p2, "86"

    :cond_a
    move-object v7, p2

    const-string v10, "remember"

    const-string v11, "true"

    const-string v0, "type"

    const-string v1, "1"

    const-string v2, "https"

    const-string v3, "true"

    const-string v4, "phone"

    const-string v6, "countrycode"

    const-string v8, "captcha"

    move-object v5, p0

    move-object v9, p1

    filled-new-array/range {v0 .. v11}, [Ljava/lang/Object;

    move-result-object p0

    .line 289
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    .line 296
    const-string p1, "/api/w/login/cellphone"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->weapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    .line 297
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->result(Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    return-object p0
.end method

.method public static loginByEmail(Ljava/lang/String;Ljava/lang/String;)Ljava/util/Map;
    .registers 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 320
    const-string v8, "rememberLogin"

    const-string v9, "true"

    const-string v0, "type"

    const-string v1, "0"

    const-string v2, "https"

    const-string v3, "true"

    const-string v4, "username"

    const-string v6, "password"

    move-object v5, p0

    move-object v7, p1

    filled-new-array/range {v0 .. v9}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    .line 326
    const-string p1, "/api/w/login"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->weapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    .line 327
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->result(Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    return-object p0
.end method

.method public static loginByPassword(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/util/Map;
    .registers 15
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-eqz p2, :cond_8

    .line 309
    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_a

    :cond_8
    const-string p2, "86"

    :cond_a
    move-object v7, p2

    const-string v10, "remember"

    const-string v11, "true"

    const-string v0, "type"

    const-string v1, "1"

    const-string v2, "https"

    const-string v3, "true"

    const-string v4, "phone"

    const-string v6, "countrycode"

    const-string v8, "password"

    move-object v5, p0

    move-object v9, p1

    filled-new-array/range {v0 .. v11}, [Ljava/lang/Object;

    move-result-object p0

    .line 305
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    .line 312
    const-string p1, "/api/w/login/cellphone"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->weapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    .line 313
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->result(Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    return-object p0
.end method

.method public static loginRefresh()Ljava/util/Map;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 338
    const-string v0, "/api/login/token/refresh"

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj()Ljava/util/Map;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->weapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    .line 339
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->result(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    return-object v0
.end method

.method public static loginStatus()Ljava/util/Map;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 332
    const-string v0, "/api/w/nuser/account/get"

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj()Ljava/util/Map;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->weapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    .line 333
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->result(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    return-object v0
.end method

.method public static lyric(J)Ljava/util/Map;
    .registers 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 673
    invoke-static {p0, p1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const/4 p0, -0x1

    .line 674
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 675
    const-string v6, "tv"

    .line 676
    const-string v0, "id"

    const-string v2, "lv"

    const-string v4, "kv"

    move-object v5, v3

    move-object v7, v3

    filled-new-array/range {v0 .. v7}, [Ljava/lang/Object;

    move-result-object p0

    .line 672
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    .line 677
    const-string p1, "/api/song/lyric"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->eapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    .line 678
    new-instance p1, Ljava/util/LinkedHashMap;

    invoke-direct {p1}, Ljava/util/LinkedHashMap;-><init>()V

    const-wide/16 v0, -0x1

    .line 679
    const-string v2, "code"

    invoke-static {p0, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-interface {p1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 680
    const-string v0, "lrc"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object v1

    const-string v2, "lyric"

    const-string v3, ""

    invoke-static {v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-interface {p1, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 681
    const-string v0, "tlyric"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object p0

    invoke-static {p0, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "tlrc"

    invoke-interface {p1, v0, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object p1
.end method

.method private static normalize(Ljava/util/Map;)Ljava/util/Map;
    .registers 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 573
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    .line 574
    const-string v1, "id"

    const-wide/16 v2, 0x0

    invoke-static {p0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-interface {v0, v1, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 577
    const-string v1, "name"

    const-string v4, ""

    invoke-static {p0, v1, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 578
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v6

    if-nez v6, :cond_28

    const-string v5, "title"

    invoke-static {p0, v5, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 579
    :cond_28
    invoke-interface {v0, v1, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 582
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    .line 583
    const-string v6, "ar"

    invoke-static {p0, v6}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->arr(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/List;

    move-result-object v6

    if-nez v6, :cond_3e

    .line 584
    const-string v6, "artists"

    invoke-static {p0, v6}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->arr(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/List;

    move-result-object v6

    :cond_3e
    if-eqz v6, :cond_67

    .line 586
    invoke-interface {v6}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :cond_44
    :goto_44
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_67

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    .line 587
    invoke-static {v7, v1, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 588
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v8

    if-lez v8, :cond_44

    .line 589
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->length()I

    move-result v8

    if-lez v8, :cond_63

    const/16 v8, 0x2f

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 590
    :cond_63
    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_44

    .line 594
    :cond_67
    const-string v6, "artist"

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v0, v6, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 597
    const-string v5, "al"

    invoke-static {p0, v5}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object v5

    .line 598
    const-string v6, "album"

    if-nez v5, :cond_7e

    invoke-static {p0, v6}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object v5

    :cond_7e
    if-nez v5, :cond_82

    move-object v1, v4

    goto :goto_86

    .line 599
    :cond_82
    invoke-static {v5, v1, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    :goto_86
    invoke-interface {v0, v6, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 600
    const-string v1, "picUrl"

    if-nez v5, :cond_8f

    move-object v6, v4

    goto :goto_93

    :cond_8f
    invoke-static {v5, v1, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    :goto_93
    invoke-interface {v0, v1, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 601
    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v6

    if-nez v6, :cond_ad

    if-eqz v5, :cond_ad

    .line 602
    const-string v6, "blurPicUrl"

    invoke-static {v5, v6, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v0, v1, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 606
    :cond_ad
    const-string v1, "dt"

    invoke-static {p0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v4

    cmp-long v1, v4, v2

    .line 607
    const-string v6, "duration"

    if-gtz v1, :cond_bd

    invoke-static {p0, v6, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v4

    .line 608
    :cond_bd
    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-interface {v0, v6, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 611
    const-string v1, "fee"

    invoke-static {p0, v1, v2, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    invoke-interface {v0, v1, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object v0
.end method

.method private static osAppVer()Ljava/lang/String;
    .registers 2

    .line 89
    sget v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    if-eqz v0, :cond_d

    const/4 v1, 0x1

    if-eq v0, v1, :cond_a

    .line 92
    const-string v0, "9.0.90"

    return-object v0

    .line 91
    :cond_a
    const-string v0, "8.20.20.231215173437"

    return-object v0

    .line 90
    :cond_d
    const-string v0, "3.1.17.204416"

    return-object v0
.end method

.method private static osChannel()Ljava/lang/String;
    .registers 2

    .line 97
    sget v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    if-eqz v0, :cond_d

    const/4 v1, 0x1

    if-eq v0, v1, :cond_a

    .line 100
    const-string v0, "distribution"

    return-object v0

    .line 99
    :cond_a
    const-string v0, "xiaomi"

    return-object v0

    .line 98
    :cond_d
    const-string v0, "netease"

    return-object v0
.end method

.method public static osMode()I
    .registers 1

    .line 69
    sget v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    return v0
.end method

.method private static osName()Ljava/lang/String;
    .registers 2

    .line 73
    sget v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    if-eqz v0, :cond_d

    const/4 v1, 0x1

    if-eq v0, v1, :cond_a

    .line 76
    const-string v0, "iPhone OS"

    return-object v0

    .line 75
    :cond_a
    const-string v0, "android"

    return-object v0

    .line 74
    :cond_d
    const-string v0, "pc"

    return-object v0
.end method

.method private static osUa()Ljava/lang/String;
    .registers 2

    .line 105
    sget v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    if-eqz v0, :cond_d

    const/4 v1, 0x1

    if-eq v0, v1, :cond_a

    .line 114
    const-string v0, "NeteaseMusic 9.0.90/5038 (iPhone; iOS 16.2; zh_CN)"

    return-object v0

    .line 111
    :cond_a
    const-string v0, "NeteaseMusic/9.1.65.240927161425(9001065);Dalvik/2.1.0 (Linux; U; Android 14; 23013RK75C Build/UKQ1.230804.001)"

    return-object v0

    .line 107
    :cond_d
    const-string v0, "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36 Chrome/91.0.4472.164 NeteaseMusicDesktop/3.0.18.203152"

    return-object v0
.end method

.method private static osVer()Ljava/lang/String;
    .registers 2

    .line 81
    sget v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    if-eqz v0, :cond_d

    const/4 v1, 0x1

    if-eq v0, v1, :cond_a

    .line 84
    const-string v0, "16.2"

    return-object v0

    .line 83
    :cond_a
    const-string v0, "14"

    return-object v0

    .line 82
    :cond_d
    const-string v0, "Microsoft-Windows-10-Professional-build-19045-64bit"

    return-object v0
.end method

.method public static pickCookie(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 12

    .line 381
    const-string v0, ""

    if-eqz p0, :cond_50

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_b

    goto :goto_50

    .line 382
    :cond_b
    const-string v1, "\n"

    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v1, p0

    const/4 v2, 0x0

    move v3, v2

    :goto_14
    if-ge v3, v1, :cond_50

    aget-object v4, p0, v3

    .line 383
    const-string v5, ";"

    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v4

    array-length v5, v4

    move v6, v2

    :goto_20
    if-ge v6, v5, :cond_4d

    aget-object v7, v4, v6

    .line 384
    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    const/16 v8, 0x3d

    .line 385
    invoke-virtual {v7, v8}, Ljava/lang/String;->indexOf(I)I

    move-result v8

    if-gtz v8, :cond_31

    goto :goto_4a

    .line 387
    :cond_31
    invoke-virtual {v7, v2, v8}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {p1, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_4a

    add-int/lit8 v8, v8, 0x1

    invoke-virtual {v7, v8}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_4a
    :goto_4a
    add-int/lit8 v6, v6, 0x1

    goto :goto_20

    :cond_4d
    add-int/lit8 v3, v3, 0x1

    goto :goto_14

    :cond_50
    :goto_50
    return-object v0
.end method

.method public static post(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 21
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    move-object/from16 v0, p3

    move-object/from16 v1, p4

    .line 400
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    if-nez p1, :cond_e

    .line 403
    const-string v3, ""

    goto :goto_10

    :cond_e
    move-object/from16 v3, p1

    :goto_10
    const/4 v4, 0x0

    .line 405
    const-string v5, "POST"

    move-object/from16 v7, p0

    move v6, v4

    move-object v8, v5

    :goto_17
    const/4 v9, 0x5

    if-ge v6, v9, :cond_1ad

    const/4 v9, 0x0

    .line 408
    :try_start_1b
    new-instance v10, Ljava/net/URL;

    invoke-direct {v10, v7}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v10

    check-cast v10, Ljava/net/HttpURLConnection;
    :try_end_26
    .catchall {:try_start_1b .. :try_end_26} :catchall_1a6

    .line 409
    :try_start_26
    invoke-virtual {v10, v4}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    .line 410
    invoke-virtual {v10, v8}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v9, 0x3a98

    .line 411
    invoke-virtual {v10, v9}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v9, 0x4e20

    .line 412
    invoke-virtual {v10, v9}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 413
    invoke-virtual {v10, v4}, Ljava/net/HttpURLConnection;->setUseCaches(Z)V

    .line 414
    const-string v9, "Content-Type"

    move-object/from16 v11, p2

    invoke-virtual {v10, v9, v11}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz v0, :cond_4d

    .line 415
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v9

    if-lez v9, :cond_4d

    const-string v9, "Cookie"

    invoke-virtual {v10, v9, v0}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    :cond_4d
    if-eqz v1, :cond_5a

    .line 416
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v9

    if-lez v9, :cond_5a

    const-string v9, "User-Agent"

    invoke-virtual {v10, v9, v1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 417
    :cond_5a
    const-string v9, "Referer"

    const-string v12, "https://music.163.com"

    invoke-virtual {v10, v9, v12}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 419
    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_82

    .line 420
    sget-object v9, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->UTF8:Ljava/nio/charset/Charset;

    invoke-virtual {v3, v9}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v9

    const/4 v12, 0x1

    .line 421
    invoke-virtual {v10, v12}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    .line 422
    array-length v12, v9

    invoke-virtual {v10, v12}, Ljava/net/HttpURLConnection;->setFixedLengthStreamingMode(I)V

    .line 423
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v12

    .line 424
    invoke-virtual {v12, v9}, Ljava/io/OutputStream;->write([B)V

    .line 425
    invoke-virtual {v12}, Ljava/io/OutputStream;->flush()V

    .line 426
    invoke-virtual {v12}, Ljava/io/OutputStream;->close()V

    .line 429
    :cond_82
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v9
    :try_end_86
    .catchall {:try_start_26 .. :try_end_86} :catchall_1a3

    .line 432
    :try_start_86
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getHeaderFields()Ljava/util/Map;

    move-result-object v12

    .line 433
    invoke-interface {v12}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v12

    invoke-interface {v12}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v12

    :cond_92
    :goto_92
    invoke-interface {v12}, Ljava/util/Iterator;->hasNext()Z

    move-result v13

    if-eqz v13, :cond_e5

    invoke-interface {v12}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/util/Map$Entry;

    .line 434
    invoke-interface {v13}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v14

    if-nez v14, :cond_a5

    goto :goto_92

    .line 435
    :cond_a5
    const-string v14, "set-cookie"

    invoke-interface {v13}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Ljava/lang/String;

    invoke-virtual {v14, v15}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v14

    if-nez v14, :cond_b4

    goto :goto_92

    .line 436
    :cond_b4
    invoke-interface {v13}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/util/List;

    if-nez v13, :cond_bd

    goto :goto_92

    .line 438
    :cond_bd
    invoke-interface {v13}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v13

    :cond_c1
    :goto_c1
    invoke-interface {v13}, Ljava/util/Iterator;->hasNext()Z

    move-result v14

    if-eqz v14, :cond_92

    invoke-interface {v13}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/String;

    if-eqz v14, :cond_c1

    .line 439
    invoke-virtual {v14}, Ljava/lang/String;->length()I

    move-result v15

    if-nez v15, :cond_d6

    goto :goto_c1

    .line 440
    :cond_d6
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v15

    if-lez v15, :cond_e1

    const/16 v15, 0xa

    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 441
    :cond_e1
    invoke-virtual {v2, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_e4
    .catchall {:try_start_86 .. :try_end_e4} :catchall_e5

    goto :goto_c1

    :catchall_e5
    :cond_e5
    const/16 v12, 0x12d

    .line 447
    const-string v13, " \u2192 "

    const/16 v14, 0x12f

    if-eq v9, v12, :cond_158

    const/16 v12, 0x12e

    if-eq v9, v12, :cond_158

    if-eq v9, v14, :cond_158

    const/16 v12, 0x133

    if-eq v9, v12, :cond_158

    const/16 v12, 0x134

    if-ne v9, v12, :cond_fc

    goto :goto_158

    :cond_fc
    const/16 v0, 0x190

    if-lt v9, v0, :cond_105

    .line 456
    :try_start_100
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object v0

    goto :goto_109

    :cond_105
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v0

    .line 457
    :goto_109
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->readAll(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object v0

    .line 458
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[MusicApi] "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, "\uff0c\u6b63\u6587 "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 459
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " \u5b57\uff0cSet-Cookie "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " \u5b57"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 458
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->d(Ljava/lang/String;)V

    .line 460
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastSetCookie:Ljava/lang/String;
    :try_end_152
    .catchall {:try_start_100 .. :try_end_152} :catchall_1a3

    if-eqz v10, :cond_157

    .line 465
    :try_start_154
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_157
    .catchall {:try_start_154 .. :try_end_157} :catchall_157

    :catchall_157
    :cond_157
    return-object v0

    .line 448
    :cond_158
    :goto_158
    :try_start_158
    const-string v12, "Location"

    invoke-virtual {v10, v12}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    .line 449
    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "[MusicApi] \u91cd\u5b9a\u5411 "

    invoke-virtual {v15, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->d(Ljava/lang/String;)V

    if-eqz v12, :cond_19d

    .line 450
    invoke-virtual {v12}, Ljava/lang/String;->length()I

    move-result v4

    if-nez v4, :cond_181

    goto :goto_19d

    .line 451
    :cond_181
    new-instance v4, Ljava/net/URL;

    new-instance v13, Ljava/net/URL;

    invoke-direct {v13, v7}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-direct {v4, v13, v12}, Ljava/net/URL;-><init>(Ljava/net/URL;Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/net/URL;->toString()Ljava/lang/String;

    move-result-object v7

    if-ne v9, v14, :cond_193

    .line 452
    const-string v8, "GET"
    :try_end_193
    .catchall {:try_start_158 .. :try_end_193} :catchall_1a3

    :cond_193
    if-eqz v10, :cond_198

    .line 465
    :try_start_195
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_198
    .catchall {:try_start_195 .. :try_end_198} :catchall_198

    :catchall_198
    :cond_198
    add-int/lit8 v6, v6, 0x1

    const/4 v4, 0x0

    goto/16 :goto_17

    :cond_19d
    :goto_19d
    if-eqz v10, :cond_1ad

    :try_start_19f
    invoke-virtual {v10}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_1a2
    .catchall {:try_start_19f .. :try_end_1a2} :catchall_1ad

    goto :goto_1ad

    :catchall_1a3
    move-exception v0

    move-object v9, v10

    goto :goto_1a7

    :catchall_1a6
    move-exception v0

    :goto_1a7
    if-eqz v9, :cond_1ac

    :try_start_1a9
    invoke-virtual {v9}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_1ac
    .catchall {:try_start_1a9 .. :try_end_1ac} :catchall_1ac

    .line 469
    :catchall_1ac
    :cond_1ac
    throw v0

    .line 472
    :catchall_1ad
    :cond_1ad
    :goto_1ad
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastSetCookie:Ljava/lang/String;

    .line 473
    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u91cd\u5b9a\u5411\u6b21\u6570\u8fc7\u591a\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    move-object/from16 v2, p0

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private static readAll(Ljava/io/InputStream;)Ljava/lang/String;
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-nez p0, :cond_5

    .line 477
    const-string p0, ""

    return-object p0

    .line 478
    :cond_5
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v1, 0x2000

    .line 479
    new-array v1, v1, [B

    .line 481
    :goto_e
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    if-lez v2, :cond_19

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_e

    .line 482
    :cond_19
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    .line 483
    new-instance p0, Ljava/lang/String;

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    sget-object v1, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->UTF8:Ljava/nio/charset/Charset;

    invoke-direct {p0, v0, v1}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    return-object p0
.end method

.method private static result(Ljava/util/Map;)Ljava/util/Map;
    .registers 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .line 344
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    const-wide/16 v1, -0x1

    .line 345
    const-string v3, "code"

    invoke-static {p0, v3, v1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-interface {v0, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 346
    const-string v1, "message"

    const-string v2, ""

    invoke-static {p0, v1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 347
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    const-string v4, "msg"

    if-nez v3, :cond_28

    invoke-static {p0, v4, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 348
    :cond_28
    invoke-interface {v0, v4, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 350
    sget-object v1, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastSetCookie:Ljava/lang/String;

    .line 351
    const-string v3, "MUSIC_U"

    invoke-static {v1, v3}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->pickCookie(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 352
    const-string v3, "musicU"

    invoke-interface {v0, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 358
    :try_start_38
    const-string v1, "profile"

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object v1

    const-wide/16 v3, 0x0

    if-eqz v1, :cond_57

    .line 360
    const-string v5, "nickname"

    invoke-static {v1, v5, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5
    :try_end_48
    .catchall {:try_start_38 .. :try_end_48} :catchall_78

    .line 361
    :try_start_48
    const-string v6, "userId"

    invoke-static {v1, v6, v3, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v6

    cmp-long v1, v6, v3

    if-lez v1, :cond_58

    .line 362
    invoke-static {v6, v7}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v2

    goto :goto_58

    :cond_57
    move-object v5, v2

    .line 364
    :cond_58
    :goto_58
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_7b

    .line 365
    const-string v1, "account"

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object v1

    if-eqz v1, :cond_7b

    .line 367
    const-string v6, "id"

    invoke-static {v1, v6, v3, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v6

    cmp-long v1, v6, v3

    if-lez v1, :cond_7b

    .line 368
    invoke-static {v6, v7}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v2
    :try_end_74
    .catchall {:try_start_48 .. :try_end_74} :catchall_75

    goto :goto_7b

    :catchall_75
    move-object v1, v2

    move-object v2, v5

    goto :goto_79

    :catchall_78
    move-object v1, v2

    :goto_79
    move-object v5, v2

    move-object v2, v1

    .line 373
    :cond_7b
    :goto_7b
    const-string v1, "nick"

    invoke-interface {v0, v1, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 374
    const-string v1, "uid"

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 375
    const-string v1, "raw"

    invoke-interface {v0, v1, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object v0
.end method

.method public static search(Ljava/lang/String;II)Ljava/util/List;
    .registers 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "II)",
            "Ljava/util/List<",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;>;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-nez p0, :cond_4

    .line 510
    const-string p0, ""

    :cond_4
    move-object v1, p0

    const/4 p0, 0x1

    .line 511
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    if-gtz p1, :cond_e

    const/16 p1, 0x1e

    .line 512
    :cond_e
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    const/4 p0, 0x0

    if-gez p2, :cond_16

    move p2, p0

    .line 513
    :cond_16
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    const-string v0, "s"

    const-string v2, "type"

    const-string v4, "limit"

    const-string v6, "offset"

    filled-new-array/range {v0 .. v7}, [Ljava/lang/Object;

    move-result-object p1

    .line 509
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p1

    .line 514
    const-string p2, "/api/search/get"

    invoke-static {p2, p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->eapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p1

    .line 515
    const-string p2, "code"

    const-wide/16 v0, -0x1

    invoke-static {p1, p2, v0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v0

    long-to-int p2, v0

    .line 516
    sput p2, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLastCode:I

    .line 517
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "[MusicApi] search code="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->d(Ljava/lang/String;)V

    .line 518
    new-instance p2, Ljava/util/ArrayList;

    invoke-direct {p2}, Ljava/util/ArrayList;-><init>()V

    .line 519
    const-string v0, "result"

    invoke-static {p1, v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object v1

    const-string v2, "songs"

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->arr(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/List;

    move-result-object v1

    if-nez v1, :cond_67

    .line 522
    invoke-static {p1, v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object p1

    invoke-static {p1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->arr(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/List;

    move-result-object v1

    :cond_67
    if-nez v1, :cond_6b

    goto/16 :goto_168

    .line 525
    :cond_6b
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_6f
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_88

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    .line 526
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object v0

    if-nez v0, :cond_80

    goto :goto_6f

    .line 528
    :cond_80
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->normalize(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_6f

    .line 536
    :cond_88
    :try_start_88
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 537
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_91
    :goto_91
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1
    :try_end_95
    .catchall {:try_start_88 .. :try_end_95} :catchall_169

    const-string v2, "id"

    const-string v3, "picUrl"

    if-eqz v1, :cond_d2

    :try_start_9b
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    .line 538
    invoke-interface {v1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    if-eqz v3, :cond_af

    .line 539
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    if-nez v3, :cond_91

    .line 540
    :cond_af
    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 541
    instance-of v2, v1, Ljava/lang/Number;

    if-eqz v2, :cond_91

    move-object v2, v1

    check-cast v2, Ljava/lang/Number;

    invoke-virtual {v2}, Ljava/lang/Number;->longValue()J

    move-result-wide v2

    const-wide/16 v4, 0x0

    cmp-long v2, v2, v4

    if-lez v2, :cond_91

    .line 542
    check-cast v1, Ljava/lang/Number;

    invoke-virtual {v1}, Ljava/lang/Number;->longValue()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-interface {p1, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_91

    .line 546
    :cond_d2
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_168

    .line 548
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->songDetail(Ljava/util/List;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_e0
    :goto_e0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_143

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    .line 549
    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 550
    invoke-interface {v1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    if-eqz v4, :cond_e0

    if-eqz v1, :cond_e0

    .line 551
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v5

    if-nez v5, :cond_101

    goto :goto_e0

    .line 552
    :cond_101
    check-cast v4, Ljava/lang/Number;

    invoke-virtual {v4}, Ljava/lang/Number;->longValue()J

    move-result-wide v4

    .line 553
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :cond_10b
    :goto_10b
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_e0

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/util/Map;

    .line 554
    invoke-interface {v7, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    .line 555
    instance-of v9, v8, Ljava/lang/Number;

    if-eqz v9, :cond_10b

    check-cast v8, Ljava/lang/Number;

    invoke-virtual {v8}, Ljava/lang/Number;->longValue()J

    move-result-wide v8

    cmp-long v8, v8, v4

    if-nez v8, :cond_10b

    .line 556
    invoke-interface {v7, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    if-eqz v8, :cond_13d

    .line 557
    invoke-interface {v7, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v8

    if-nez v8, :cond_10b

    .line 558
    :cond_13d
    invoke-interface {v7, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 p0, p0, 0x1

    goto :goto_10b

    .line 563
    :cond_143
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[MusicApi] \u5c01\u9762\u8865\u9f50 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "/"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u9996\uff08\u8d70 songDetail\uff09"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->d(Ljava/lang/String;)V
    :try_end_168
    .catchall {:try_start_9b .. :try_end_168} :catchall_169

    :cond_168
    :goto_168
    return-object p2

    :catchall_169
    move-exception v0

    move-object p0, v0

    .line 566
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "[MusicApi] \u5c01\u9762\u8865\u9f50\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u64ad\u653e\uff09\uff1a"

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->d(Ljava/lang/String;)V

    return-object p2
.end method

.method public static setLog(Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;)V
    .registers 1

    .line 128
    sput-object p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sLog:Lcom/nidyaber/fuckdsmanger/music/GmMusicApi$Log;

    return-void
.end method

.method public static setLogin(Ljava/lang/String;)V
    .registers 1

    if-nez p0, :cond_4

    .line 168
    const-string p0, ""

    :cond_4
    sput-object p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    return-void
.end method

.method public static setOsMode(I)V
    .registers 2

    const/4 v0, 0x2

    if-ltz p0, :cond_5

    if-le p0, v0, :cond_6

    :cond_5
    move p0, v0

    .line 65
    :cond_6
    sput p0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sOsMode:I

    return-void
.end method

.method public static songDetail(Ljava/util/List;)Ljava/util/List;
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/Long;",
            ">;)",
            "Ljava/util/List<",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;>;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 648
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "["

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v1, 0x0

    .line 649
    :goto_8
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_29

    if-lez v1, :cond_15

    const/16 v2, 0x2c

    .line 650
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 651
    :cond_15
    const-string v2, "{\"id\":"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 v2, 0x7d

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_8

    :cond_29
    const/16 p0, 0x5d

    .line 653
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 654
    const-string p0, "c"

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    filled-new-array {p0, v0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0

    .line 655
    const-string v0, "/api/v3/song/detail"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->eapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p0

    .line 656
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 657
    const-string v1, "songs"

    invoke-static {p0, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->arr(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/List;

    move-result-object p0

    if-nez p0, :cond_50

    goto :goto_6c

    .line 659
    :cond_50
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_54
    :goto_54
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_6c

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    .line 660
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object v1

    if-eqz v1, :cond_54

    .line 661
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->normalize(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_54

    :cond_6c
    :goto_6c
    return-object v0
.end method

.method public static songUrl(JLjava/lang/String;)Ljava/util/Map;
    .registers 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 621
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "["

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "]"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    if-eqz p2, :cond_1b

    .line 623
    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_1d

    :cond_1b
    const-string p2, "exhigh"

    :cond_1d
    move-object v5, p2

    const-string v6, "encodeType"

    const-string v7, "flac"

    const-string v2, "ids"

    const-string v4, "level"

    filled-new-array/range {v2 .. v7}, [Ljava/lang/Object;

    move-result-object p2

    .line 621
    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->obj([Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p2

    .line 625
    const-string v0, "/api/song/enhance/player/url/v1"

    invoke-static {v0, p2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->eapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;

    move-result-object p2

    .line 626
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    const-wide/16 v1, -0x1

    .line 627
    const-string v3, "code"

    invoke-static {p2, v3, v1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-interface {v0, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 628
    const-string v1, "data"

    invoke-static {p2, v1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->arr(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/List;

    move-result-object p2

    .line 629
    const-string v1, "url"

    const-string v2, ""

    if-eqz p2, :cond_bf

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v3

    if-lez v3, :cond_bf

    const/4 v3, 0x0

    .line 630
    invoke-interface {p2, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    invoke-static {p2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p2

    if-eqz p2, :cond_bf

    .line 632
    const-string v3, "id"

    invoke-static {p2, v3, p0, p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide p0

    invoke-static {p0, p1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    invoke-interface {v0, v3, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 633
    invoke-static {p2, v1, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-interface {v0, v1, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 634
    const-string p0, "br"

    const-wide/16 v3, 0x0

    invoke-static {p2, p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 635
    const-string p0, "size"

    invoke-static {p2, p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 636
    const-string p0, "type"

    invoke-static {p2, p0, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 637
    const-string p0, "level"

    invoke-static {p2, p0, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 638
    const-string p0, "fee"

    invoke-static {p2, p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v3

    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 639
    const-string p0, "freeTrialInfo"

    invoke-static {p2, p0, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const-string p1, "trial"

    invoke-interface {v0, p1, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 642
    :cond_bf
    invoke-interface {v0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_c8

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_c8
    return-object v0
.end method

.method private static urlEnc(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 259
    :try_start_0
    const-string v0, "UTF-8"

    invoke-static {p0, v0}, Ljava/net/URLEncoder;->encode(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_6
    .catchall {:try_start_0 .. :try_end_6} :catchall_6

    :catchall_6
    return-object p0
.end method

.method public static weapiPost(Ljava/lang/String;Ljava/util/Map;)Ljava/util/Map;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 237
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->write(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 238
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicCrypto;->weapi(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p1

    .line 239
    const-string v0, "/api/"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_15

    const/4 v0, 0x5

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 240
    :cond_15
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "https://music.163.com/weapi/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 247
    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    const-string v1, ";"

    if-eqz v0, :cond_45

    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_45

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "MUSIC_U="

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicU:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_47

    .line 248
    :cond_45
    const-string v0, ""

    :goto_47
    sget-object v2, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicA:Ljava/lang/String;

    if-eqz v2, :cond_6c

    sget-object v2, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicA:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :cond_6c

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " MUSIC_A="

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->sMusicA:Ljava/lang/String;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 250
    :cond_6c
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "params="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v2, 0x0

    aget-object v2, p1, v2

    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->urlEnc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "&encSecKey="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v2, 0x1

    aget-object p1, p1, v2

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->urlEnc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v1, "application/x-www-form-urlencoded"

    const-string v2, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0"

    invoke-static {p0, p1, v1, v0, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->post(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 252
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->parse(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p1

    if-eqz p1, :cond_a3

    return-object p1

    .line 253
    :cond_a3
    new-instance p1, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u54cd\u5e94\u4e0d\u662f JSON\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->brief(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {p1, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
