.class public final Lcom/varuns2002/disable_flag_secure/gm/GmDs;
.super Ljava/lang/Object;
.source "GmDs.java"


# static fields
.field static sLast:J


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static clear(Landroid/content/Context;)V
    .registers 2

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    return-void
.end method

.method public static dump(Landroid/content/Context;Ljava/util/Map;)V
    .registers 12

    if-eqz p1, :cond_56

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->sLast:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0xbb8

    cmp-long v4, v0, v2

    if-ltz v4, :cond_56

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->sLast:J

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-interface {p1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_22
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_49

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    invoke-interface {p1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\n"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\n\n"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_22

    :cond_49
    sget v1, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook;->sHits:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/varuns2002/disable_flag_secure/gm/GmDsHook;->sHits:I

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->save(Landroid/content/Context;Ljava/lang/String;)V

    :cond_56
    return-void
.end method

.method public static file(Landroid/content/Context;)Ljava/io/File;
    .registers 4

    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "fuckds_ds.txt"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method public static hasData(Landroid/content/Context;)Z
    .registers 2

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    return v0
.end method

.method public static read(Landroid/content/Context;)Ljava/lang/String;
    .registers 8

    const-string v0, "(\u6682\u65e0\u6570\u636e\uff0c\u7b49 App \u62c9\u53d6\u4e00\u6b21\u670d\u52a1\u7aef\u914d\u7f6e\u540e\u56de\u6765\u5237\u65b0)"

    :try_start_2
    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_30

    new-instance v1, Ljava/io/FileInputStream;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    const/16 v2, 0x2000

    new-array v2, v2, [B

    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v3}, Ljava/io/ByteArrayOutputStream;-><init>()V

    :goto_1e
    invoke-virtual {v1, v2}, Ljava/io/FileInputStream;->read([B)I

    move-result v4

    if-lez v4, :cond_29

    const/4 v5, 0x0

    invoke-virtual {v3, v2, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_1e

    :cond_29
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V

    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_30
    .catchall {:try_start_2 .. :try_end_30} :catchall_31

    :cond_30
    return-object v0

    :catchall_31
    move-exception v1

    return-object v0
.end method

.method public static save(Landroid/content/Context;Ljava/lang/String;)V
    .registers 4

    :try_start_0
    new-instance v0, Ljava/io/FileOutputStream;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-virtual {p1}, Ljava/lang/String;->getBytes()[B

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_13
    .catchall {:try_start_0 .. :try_end_13} :catchall_14

    return-void

    :catchall_14
    move-exception v0

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    return-void
.end method

.method public static scan(Landroid/content/Context;)V
    .registers 5

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmStore;->dumpAll(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_f

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_f

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->save(Landroid/content/Context;Ljava/lang/String;)V

    :cond_f
    return-void
.end method

.method public static sizeKb(Landroid/content/Context;)J
    .registers 5

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmDs;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v0

    const-wide/16 v2, 0x400

    div-long/2addr v0, v2

    return-wide v0
.end method
