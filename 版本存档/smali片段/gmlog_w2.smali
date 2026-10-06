.class public final Lcom/varuns2002/disable_flag_secure/gm/GmLog;
.super Ljava/lang/Object;

.field static sCleared:Z

.method public static w(Ljava/lang/String;)V
    .registers 9

    :try_start_0
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->dir()Ljava/io/File;

    move-result-object v0

    if-eqz v0, :cond_69

    sget-boolean v7, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->sCleared:Z

    if-eqz v7, :skip_clear

    const/4 v7, 0x1

    sput-boolean v7, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->sCleared:Z

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->clear()V

    :skip_clear
    new-instance v1, Ljava/io/File;

    const-string v2, "dsm.log"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/32 v4, 0x40000

    cmp-long v6, v2, v4

    if-lez v6, :cond_2b

    new-instance v6, Ljava/io/File;

    const-string v2, "dsm1.log"

    invoke-direct {v6, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v6}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_28

    invoke-virtual {v6}, Ljava/io/File;->delete()Z

    :cond_28
    invoke-virtual {v1, v6}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    :cond_2b
    new-instance v2, Ljava/text/SimpleDateFormat;

    const-string v3, "MM-dd HH:mm:ss.SSS"

    invoke-direct {v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    new-instance v3, Ljava/util/Date;

    invoke-direct {v3}, Ljava/util/Date;-><init>()V

    invoke-virtual {v2, v3}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\n"

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/io/FileOutputStream;

    const/4 v5, 0x1

    invoke-direct {v4, v1, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V

    const-string v5, "UTF-8"

    invoke-virtual {v3, v5}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->flush()V

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V
    :try_end_69
    .catchall {:try_start_0 .. :try_end_69} :catchall_6a

    :cond_69
    return-void

    :catchall_6a
    move-exception v0

    return-void
.end method
