.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;
.super Ljava/lang/Object;
.source "GmMusicLogin.java"


# static fields
.field private static final DIR:Ljava/lang/String; = "FDMmusic"

.field private static final FILE:Ljava/lang/String; = "login.json"

.field private static final UTF8:Ljava/nio/charset/Charset;

.field private static volatile sApp:Landroid/content/Context;

.field private static volatile sLastOp:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 36
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->UTF8:Ljava/nio/charset/Charset;

    const/4 v0, 0x0

    .line 39
    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sApp:Landroid/content/Context;

    .line 71
    const-string v0, ""

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sLastOp:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Landroid/content/Context;
    .registers 1

    .line 32
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sApp:Landroid/content/Context;

    return-object v0
.end method

.method public static apply(Landroid/content/Context;)V
    .registers 6

    .line 135
    const-string v0, "nick"

    const-string v1, ""

    .line 0
    const-string v2, "\u3010MusicLogin\u3011\u2705 \u5df2\u4ece\u6587\u4ef6\u8bfb\u56de\u767b\u5f55\u6001\uff08uid="

    if-nez p0, :cond_a

    goto/16 :goto_80

    .line 136
    :cond_a
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->setApp(Landroid/content/Context;)V

    .line 138
    :try_start_d
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    .line 139
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v3

    if-nez v3, :cond_1d

    .line 140
    const-string p0, "\u3010MusicLogin\u3011\u6ca1\u6709\u767b\u5f55\u6587\u4ef6\uff08\u672a\u767b\u5f55\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 143
    :cond_1d
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->read(Ljava/io/File;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_80

    .line 144
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    if-nez v3, :cond_2e

    goto :goto_80

    .line 145
    :cond_2e
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 146
    const-string p0, "musicU"

    invoke-virtual {v3, p0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 147
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v4

    if-nez v4, :cond_40

    goto :goto_80

    .line 148
    :cond_40
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->setLogin(Ljava/lang/String;)V

    .line 149
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v2, "uid"

    invoke-virtual {v3, v2, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " nick="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 150
    invoke-virtual {v3, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\uff09"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 149
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 156
    invoke-virtual {v3, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    if-nez p0, :cond_80

    .line 157
    new-instance p0, Ljava/lang/Thread;

    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin$1;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin$1;-><init>()V

    invoke-direct {p0, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 191
    invoke-virtual {p0}, Ljava/lang/Thread;->start()V
    :try_end_80
    .catchall {:try_start_d .. :try_end_80} :catchall_81

    :cond_80
    :goto_80
    return-void

    :catchall_81
    move-exception p0

    .line 194
    const-string v0, "\u3010MusicLogin\u3011\u8bfb\u56de\u767b\u5f55\u6001\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method public static clear(Landroid/content/Context;)Z
    .registers 2

    if-eqz p0, :cond_f

    .line 119
    :try_start_2
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    .line 120
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v0

    if-eqz v0, :cond_f

    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    .line 122
    :cond_f
    const-string p0, ""

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->setLogin(Ljava/lang/String;)V

    .line 123
    const-string p0, "\u3010MusicLogin\u3011\u5df2\u6e05\u9664\u767b\u5f55\u6001"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_19
    .catchall {:try_start_2 .. :try_end_19} :catchall_1b

    const/4 p0, 0x1

    return p0

    :catchall_1b
    move-exception p0

    .line 126
    const-string v0, "\u3010MusicLogin\u3011\u6e05\u9664\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 p0, 0x0

    return p0
.end method

.method public static diag(Landroid/content/Context;)Ljava/lang/String;
    .registers 6

    const-string v0, "\u6709 "

    .line 229
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 231
    :try_start_7
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    .line 232
    const-string v2, "\u6587\u4ef6\uff1a"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v2

    if-eqz v2, :cond_2c

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v3

    invoke-virtual {v2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, "B"

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_2e

    :cond_2c
    const-string p0, "\u65e0"

    :goto_2e
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_31
    .catchall {:try_start_7 .. :try_end_31} :catchall_32

    goto :goto_37

    .line 234
    :catchall_32
    const-string p0, "\u6587\u4ef6\uff1a\u8bfb\u5931\u8d25"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 237
    :goto_37
    :try_start_37
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->login()Ljava/lang/String;

    move-result-object p0

    .line 238
    const-string v0, "\u3000\u5185\u5b58\uff1a"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez p0, :cond_44

    const/4 p0, 0x0

    goto :goto_48

    :cond_44
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    :goto_48
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "\u5b57"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_50
    .catchall {:try_start_37 .. :try_end_50} :catchall_51

    goto :goto_56

    .line 240
    :catchall_51
    const-string p0, "\u3000\u5185\u5b58\uff1a\u8bfb\u5931\u8d25"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 242
    :goto_56
    sget-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sLastOp:Ljava/lang/String;

    if-eqz p0, :cond_68

    .line 243
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_68

    .line 244
    const-string v0, "\u3000\u4e0a\u6b21\u4fdd\u5b58\uff1a"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 246
    :cond_68
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static dir(Landroid/content/Context;)Ljava/io/File;
    .registers 3

    .line 49
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    const-string v1, "FDMmusic"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 50
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result p0

    if-nez p0, :cond_14

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    :cond_14
    return-object v0
.end method

.method public static file(Landroid/content/Context;)Ljava/io/File;
    .registers 3

    .line 55
    new-instance v0, Ljava/io/File;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->dir(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    const-string v1, "login.json"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method public static lastOp()Ljava/lang/String;
    .registers 1

    .line 74
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sLastOp:Ljava/lang/String;

    return-object v0
.end method

.method public static loggedIn()Z
    .registers 1

    .line 200
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->hasLogin()Z

    move-result v0

    return v0
.end method

.method private static read(Ljava/io/File;)Ljava/lang/String;
    .registers 7

    const/4 v0, 0x0

    .line 252
    :try_start_1
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_6
    .catchall {:try_start_1 .. :try_end_6} :catchall_2a

    .line 253
    :try_start_6
    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/32 v4, 0x100000

    invoke-static {v2, v3, v4, v5}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v2

    long-to-int p0, v2

    new-array p0, p0, [B

    .line 254
    invoke-virtual {v1, p0}, Ljava/io/FileInputStream;->read([B)I

    move-result v2

    if-gtz v2, :cond_1d

    .line 255
    const-string p0, ""

    goto :goto_26

    :cond_1d
    new-instance v3, Ljava/lang/String;

    sget-object v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->UTF8:Ljava/nio/charset/Charset;

    const/4 v5, 0x0

    invoke-direct {v3, p0, v5, v2, v4}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V
    :try_end_25
    .catchall {:try_start_6 .. :try_end_25} :catchall_2b

    move-object p0, v3

    .line 260
    :goto_26
    :try_start_26
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_29
    .catchall {:try_start_26 .. :try_end_29} :catchall_29

    :catchall_29
    return-object p0

    :catchall_2a
    move-object v1, v0

    :catchall_2b
    if-eqz v1, :cond_30

    :try_start_2d
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_30
    .catchall {:try_start_2d .. :try_end_30} :catchall_30

    :catchall_30
    :cond_30
    return-object v0
.end method

.method public static save(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .registers 11

    const-string v0, "\u3010MusicLogin\u3011\u2705 \u5df2\u4fdd\u5b58\u767b\u5f55\u6001\uff08\u51ed\u8bc1 "

    const-string v1, "\u6210\u529f\uff1a\u51ed\u8bc1 "

    const/4 v2, 0x0

    if-nez p0, :cond_11

    .line 79
    const-string p0, "\u5931\u8d25\uff1aContext \u4e3a\u7a7a"

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sLastOp:Ljava/lang/String;

    .line 80
    const-string p0, "\u3010MusicLogin\u3011\u26a0\ufe0f \u4fdd\u5b58\u5931\u8d25\uff1aContext \u4e3a\u7a7a"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2

    .line 83
    :cond_11
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->setApp(Landroid/content/Context;)V

    if-eqz p1, :cond_c6

    .line 84
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v3

    if-nez v3, :cond_1e

    goto/16 :goto_c6

    .line 91
    :cond_1e
    :try_start_1e
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 92
    const-string v4, "musicU"

    invoke-virtual {v3, v4, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 93
    const-string v4, "uid"
    :try_end_2a
    .catchall {:try_start_1e .. :try_end_2a} :catchall_af

    const-string v5, ""

    if-nez p2, :cond_30

    move-object v6, v5

    goto :goto_31

    :cond_30
    move-object v6, p2

    :goto_31
    :try_start_31
    invoke-virtual {v3, v4, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 94
    const-string v4, "nick"

    if-nez p3, :cond_39

    move-object p3, v5

    :cond_39
    invoke-virtual {v3, v4, p3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 95
    const-string p3, "at"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    invoke-virtual {v3, p3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 96
    const-string p3, "_warn"

    const-string v4, "\u26a0\ufe0f \u672c\u6587\u4ef6\u4e3a\u3010\u660e\u6587\u5b58\u50a8\u3011\uff0c\u5185\u542b\u767b\u5f55\u51ed\u8bc1\uff08MUSIC_U\uff09\u3002\u8bf7\u52ff\u5206\u4eab\u3001\u52ff\u4e0a\u4f20\uff1broot \u73af\u5883\u4e0b\u8bf7\u6ce8\u610f\u9690\u79c1\u5b89\u5168\u3002"

    invoke-virtual {v3, p3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 98
    new-instance p3, Ljava/io/FileOutputStream;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v4

    invoke-direct {p3, v4}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/4 v4, 0x1

    .line 99
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->toString(I)Ljava/lang/String;

    move-result-object v3

    sget-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->UTF8:Ljava/nio/charset/Charset;

    invoke-virtual {v3, v5}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v3

    invoke-virtual {p3, v3}, Ljava/io/FileOutputStream;->write([B)V

    .line 100
    invoke-virtual {p3}, Ljava/io/FileOutputStream;->flush()V

    .line 101
    invoke-virtual {p3}, Ljava/io/FileOutputStream;->close()V

    .line 103
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->setLogin(Ljava/lang/String;)V

    .line 104
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u5b57"

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    sput-object p3, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sLastOp:Ljava/lang/String;

    .line 105
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " \u5b57\uff0cuid="

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\uff09\u2014\u2014 \u26a0\ufe0f \u660e\u6587\u5b58\u50a8\u4e8e "

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 106
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 105
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_ae
    .catchall {:try_start_31 .. :try_end_ae} :catchall_af

    return v4

    :catchall_af
    move-exception p0

    .line 109
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "\u5931\u8d25\uff1a"

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    sput-object p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sLastOp:Ljava/lang/String;

    .line 110
    const-string p1, "\u3010MusicLogin\u3011\u4fdd\u5b58\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return v2

    .line 85
    :cond_c6
    :goto_c6
    const-string p0, "\u5931\u8d25\uff1a\u51ed\u8bc1\u662f\u7a7a\u7684\uff08UI \u90a3\u8fb9\u6ca1\u6293\u5230 MUSIC_U\uff09"

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sLastOp:Ljava/lang/String;

    .line 86
    const-string p0, "\u3010MusicLogin\u3011\u26a0\ufe0f \u4fdd\u5b58\u5931\u8d25\uff1a**\u51ed\u8bc1\u662f\u7a7a\u7684** \u2014\u2014 \u591a\u534a\u662f Set-Cookie \u91cc\u6ca1\u62a0\u5230 MUSIC_U\uff08\u767b\u5f55\u6ca1\u6210\u529f / \u63a5\u53e3\u53d8\u4e86\uff09"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return v2
.end method

.method public static setApp(Landroid/content/Context;)V
    .registers 1

    if-eqz p0, :cond_8

    .line 42
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    sput-object p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sApp:Landroid/content/Context;

    :cond_8
    return-void
.end method

.method public static summary(Landroid/content/Context;)Ljava/lang/String;
    .registers 5

    .line 205
    const-string v0, ""

    :try_start_2
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    .line 206
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v1

    if-nez v1, :cond_d

    return-object v0

    .line 207
    :cond_d
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->read(Ljava/io/File;)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_14

    return-object v0

    .line 209
    :cond_14
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 210
    const-string p0, "nick"

    invoke-virtual {v1, p0, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 211
    const-string v2, "uid"

    invoke-virtual {v1, v2, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 212
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 213
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    if-lez v3, :cond_33

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 214
    :cond_33
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result p0

    if-lez p0, :cond_4c

    .line 215
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result p0

    if-lez p0, :cond_44

    const-string p0, " \u00b7 "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 216
    :cond_44
    const-string p0, "uid="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 218
    :cond_4c
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_50
    .catchall {:try_start_2 .. :try_end_50} :catchall_51

    return-object p0

    :catchall_51
    return-object v0
.end method
