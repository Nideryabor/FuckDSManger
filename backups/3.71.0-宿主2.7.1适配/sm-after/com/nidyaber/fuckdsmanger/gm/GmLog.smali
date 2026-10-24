.class public final Lcom/nidyaber/fuckdsmanger/gm/GmLog;
.super Ljava/lang/Object;
.source "GmLog.java"


# static fields
.field static sCleared:Z

.field static sDir:Ljava/io/File;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static clear()V
    .registers 4

    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_2f

    new-instance v1, Ljava/io/File;

    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    const-string v2, "DSMlogs"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v2, Ljava/io/File;

    const-string v3, "dsm.log"

    invoke-direct {v2, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v3

    if-eqz v3, :cond_2f

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    move-result v3

    if-eqz v3, :cond_2a

    const-string v0, "[\u65e5\u5fd7] \u5df2\u6e05\u7a7a\u4e0a\u4e00\u8f6e\u7684 dsm.log\uff08\u672c\u6b21\u4f1a\u8bdd\u4ece\u6b64\u884c\u5f00\u59cb\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    goto :goto_2f

    :cond_2a
    const-string v0, "[\u65e5\u5fd7] dsm.log \u5220\u9664\u5931\u8d25\uff08\u53ef\u80fd\u88ab\u5360\u7528\uff09"

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_2f
    :goto_2f
    return-void
    :try_end_30
    .catchall {:try_start_0 .. :try_end_30} :catchall_30

    :catchall_30
    move-exception v0

    return-void
.end method

.method public static dir()Ljava/io/File;
    .registers 4

    :try_start_0
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->sDir:Ljava/io/File;

    if-nez v0, :cond_20

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_20

    new-instance v2, Ljava/io/File;

    invoke-virtual {v1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v3, "DSMlogs"

    invoke-direct {v2, v1, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_1e

    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    :cond_1e
    sput-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->sDir:Ljava/io/File;
    :try_end_20
    .catchall {:try_start_0 .. :try_end_20} :catchall_23

    :cond_20
    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->sDir:Ljava/io/File;

    return-object v0

    :catchall_23
    move-exception v0

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->sDir:Ljava/io/File;

    return-object v0
.end method

.method public static path()Ljava/lang/String;
    .registers 3

    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->dir()Ljava/io/File;

    move-result-object v0

    if-eqz v0, :cond_b

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    return-object v0
    :try_end_b
    .catchall {:try_start_0 .. :try_end_b} :catchall_e

    :cond_b
    const-string v0, "(\u672a\u5c31\u7eea)"

    return-object v0

    :catchall_e
    move-exception v0

    const-string v0, "(\u5f02\u5e38)"

    return-object v0
.end method

.method public static w(Ljava/lang/String;)V
    .registers 9

    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->dir()Ljava/io/File;

    move-result-object v0

    if-eqz v0, :cond_73

    sget-boolean v7, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->sCleared:Z

    if-eqz v7, :cond_10

    const/4 v7, 0x1

    sput-boolean v7, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->sCleared:Z

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmLog;->clear()V

    :cond_10
    new-instance v1, Ljava/io/File;

    const-string v2, "dsm.log"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/32 v4, 0x40000

    cmp-long v6, v2, v4

    if-lez v6, :cond_35

    new-instance v6, Ljava/io/File;

    const-string v2, "dsm1.log"

    invoke-direct {v6, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v6}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_32

    invoke-virtual {v6}, Ljava/io/File;->delete()Z

    :cond_32
    invoke-virtual {v1, v6}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    :cond_35
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

    invoke-virtual {v4, v5}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->flush()V

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V
    :try_end_73
    .catchall {:try_start_0 .. :try_end_73} :catchall_74

    :cond_73
    return-void

    :catchall_74
    move-exception v0

    return-void
.end method
