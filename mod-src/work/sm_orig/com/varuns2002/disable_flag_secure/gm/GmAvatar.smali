.class public final Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;
.super Ljava/lang/Object;
.source "GmAvatar.java"


# static fields
.field static final AVATAR_ID:I = 0x7f070059

.field static sPicking:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static drawable(Landroid/content/Context;)Landroid/graphics/drawable/Drawable;
    .registers 3

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/graphics/drawable/Drawable;->createFromPath(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    return-object v0
.end method

.method public static file(Landroid/content/Context;)Ljava/io/File;
    .registers 4

    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "fuckds_avatar.png"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method public static hasImage(Landroid/content/Context;)Z
    .registers 5

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_16

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v0

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-lez v0, :cond_16

    const/4 v0, 0x1

    return v0

    :cond_16
    const/4 v0, 0x0

    return v0
.end method

.method public static isOn(Landroid/content/Context;)Z
    .registers 4

    const-string v0, "fuckds_gm"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "avatar_on"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static pick()V
    .registers 2

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->sPicking:Z

    return-void
.end method

.method public static saveImage(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 12

    const/4 v9, 0x0

    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    new-instance v2, Ljava/io/FileOutputStream;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->file(Landroid/content/Context;)Ljava/io/File;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v3, 0x2000

    new-array v3, v3, [B

    :goto_16
    invoke-virtual {v1, v3}, Ljava/io/InputStream;->read([B)I

    move-result v4

    if-lez v4, :cond_21

    const/4 v5, 0x0

    invoke-virtual {v2, v3, v5, v4}, Ljava/io/FileOutputStream;->write([BII)V

    goto :goto_16

    :cond_21
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V

    const/4 v9, 0x1
    :try_end_28
    .catchall {:try_start_1 .. :try_end_28} :catchall_29

    return v9

    :catchall_29
    move-exception v0

    const-string v1, "saveImage: EXCEPTION"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->log(Ljava/lang/String;)V

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    const/4 v0, 0x0

    return v0
.end method

.method public static setOn(Landroid/content/Context;Z)V
    .registers 4

    const-string v0, "fuckds_gm"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "avatar_on"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method public static takePicking()Z
    .registers 2

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->sPicking:Z

    const/4 v1, 0x0

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmAvatar;->sPicking:Z

    return v0
.end method
