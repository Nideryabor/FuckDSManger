.class public final Lcom/varuns2002/disable_flag_secure/gm/GmLog;
.super Ljava/lang/Object;

.method public static clear()V
    .registers 4

    :try_start_0
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :end

    new-instance v1, Ljava/io/File;

    invoke-virtual {v0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    const-string v2, "DSMlogs"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v0

    if-eqz v0, :end

    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v0

    if-nez v0, :end

    array-length v1, v0

    const/4 v2, 0x0

    :loop
    if-ge v2, v1, :end

    aget-object v3, v0, v2

    if-eqz v3, :next

    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    :next
    add-int/lit8 v2, v2, 0x1

    goto :loop

    :end
    return-void
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    move-exception v0

    return-void
.end method
