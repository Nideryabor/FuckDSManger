.class public final Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;
.super Landroid/app/Application;
.source "FdmApp.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "FDM-DIAG"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 28
    invoke-direct {p0}, Landroid/app/Application;-><init>()V

    return-void
.end method

.method private dump(Ljava/lang/StringBuilder;)V
    .registers 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    .line 150
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    .line 151
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getPackageName()Ljava/lang/String;

    move-result-object v1

    .line 152
    const-string v2, "=== FDM \u81ea\u68c0\uff08PackageManager \u773c\u91cc\u7684\u4e8b\u5b9e\uff09===\n"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 153
    const-string v2, "pkg        = "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v2, 0xa

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const/4 v3, 0x0

    .line 155
    invoke-virtual {v0, v1, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v4

    .line 156
    const-string v5, "version    = "

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v4, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " ("

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v4, Landroid/content/pm/PackageInfo;->versionCode:I

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ")\n"

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 157
    const-string v4, "apk        = "

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v4

    iget-object v4, v4, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 159
    :try_start_49
    const-string v4, "apkSize    = "

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v4, Ljava/io/File;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v5

    iget-object v5, v5, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    invoke-direct {v4, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/io/File;->length()J

    move-result-wide v4

    invoke-virtual {p1, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    :try_end_63
    .catchall {:try_start_49 .. :try_end_63} :catchall_63

    :catchall_63
    const/16 v4, 0x8

    .line 163
    invoke-virtual {v0, v1, v4}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v4

    .line 164
    iget-object v4, v4, Landroid/content/pm/PackageInfo;->providers:[Landroid/content/pm/ProviderInfo;

    .line 165
    const-string v5, "providers  = "

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "null"

    if-nez v4, :cond_76

    move-object v6, v5

    goto :goto_7b

    :cond_76
    array-length v6, v4

    invoke-static {v6}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v6

    :goto_7b
    invoke-virtual {p1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 166
    const-string v6, " enabled="

    if-eqz v4, :cond_b7

    .line 167
    array-length v7, v4

    move v8, v3

    :goto_87
    if-ge v8, v7, :cond_b7

    aget-object v9, v4, v8

    .line 168
    const-string v10, "   \u00b7 name="

    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v9, Landroid/content/pm/ProviderInfo;->name:Ljava/lang/String;

    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, " authority="

    .line 169
    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v9, Landroid/content/pm/ProviderInfo;->authority:Ljava/lang/String;

    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, " exported="

    .line 170
    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v10, v9, Landroid/content/pm/ProviderInfo;->exported:Z

    invoke-virtual {p1, v10}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 171
    invoke-virtual {p1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v9, v9, Landroid/content/pm/ProviderInfo;->enabled:Z

    invoke-virtual {p1, v9}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 172
    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v8, v8, 0x1

    goto :goto_87

    :cond_b7
    const/4 v4, 0x1

    .line 176
    invoke-virtual {v0, v1, v4}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0

    .line 177
    const-string v1, "activities = "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v0, Landroid/content/pm/PackageInfo;->activities:[Landroid/content/pm/ActivityInfo;

    if-nez v1, :cond_c6

    goto :goto_cd

    :cond_c6
    iget-object v1, v0, Landroid/content/pm/PackageInfo;->activities:[Landroid/content/pm/ActivityInfo;

    array-length v1, v1

    invoke-static {v1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v5

    :goto_cd
    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 178
    iget-object v1, v0, Landroid/content/pm/PackageInfo;->activities:[Landroid/content/pm/ActivityInfo;

    if-eqz v1, :cond_129

    .line 179
    iget-object v0, v0, Landroid/content/pm/PackageInfo;->activities:[Landroid/content/pm/ActivityInfo;

    array-length v1, v0

    :goto_da
    if-ge v3, v1, :cond_129

    aget-object v4, v0, v3

    .line 180
    const-string v5, "   \u00b7 "

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v4, Landroid/content/pm/ActivityInfo;->name:Ljava/lang/String;

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 181
    const-string v5, "       exported="

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v5, v4, Landroid/content/pm/ActivityInfo;->exported:Z

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    .line 182
    invoke-virtual {p1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v5, v4, Landroid/content/pm/ActivityInfo;->enabled:Z

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v5, " labelRes=0x"

    .line 183
    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v4, Landroid/content/pm/ActivityInfo;->labelRes:I

    invoke-static {v5}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " nonLocalizedLabel="

    .line 184
    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v4, Landroid/content/pm/ActivityInfo;->nonLocalizedLabel:Ljava/lang/CharSequence;

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/CharSequence;)Ljava/lang/StringBuilder;

    const-string v5, " icon=0x"

    .line 185
    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v4, Landroid/content/pm/ActivityInfo;->icon:I

    invoke-static {v4}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 186
    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_da

    .line 193
    :cond_129
    const-string v0, "\u6e05\u5355sha256 = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v0

    iget-object v0, v0, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->manifestHash(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const/4 v0, 0x0

    .line 195
    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object p0

    .line 196
    const-string v0, "\u5916\u90e8\u76ee\u5f55   = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 197
    const-string v0, "\u914d\u7f6e(\u53ef\u9009) = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez p0, :cond_158

    const-string p0, "?"

    goto :goto_163

    :cond_158
    new-instance v0, Ljava/io/File;

    const-string v1, "fdm-config.json"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    :goto_163
    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 198
    const-string p0, "==========================================\n"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    return-void
.end method

.method private static manifestHash(Ljava/lang/String;)Ljava/lang/String;
    .registers 11

    const/4 v0, 0x0

    .line 205
    :try_start_1
    new-instance v1, Ljava/util/zip/ZipFile;

    invoke-direct {v1, p0}, Ljava/util/zip/ZipFile;-><init>(Ljava/lang/String;)V
    :try_end_6
    .catchall {:try_start_1 .. :try_end_6} :catchall_7f

    .line 206
    :try_start_6
    const-string p0, "AndroidManifest.xml"

    invoke-virtual {v1, p0}, Ljava/util/zip/ZipFile;->getEntry(Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object p0

    if-nez p0, :cond_14

    .line 207
    const-string p0, "APK \u91cc\u6ca1\u6709 AndroidManifest.xml"
    :try_end_10
    .catchall {:try_start_6 .. :try_end_10} :catchall_7a

    .line 231
    :try_start_10
    invoke-virtual {v1}, Ljava/util/zip/ZipFile;->close()V
    :try_end_13
    .catchall {:try_start_10 .. :try_end_13} :catchall_13

    :catchall_13
    return-object p0

    .line 208
    :cond_14
    :try_start_14
    invoke-virtual {v1, p0}, Ljava/util/zip/ZipFile;->getInputStream(Ljava/util/zip/ZipEntry;)Ljava/io/InputStream;

    move-result-object v0

    .line 209
    new-instance p0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v2, 0x2000

    .line 210
    new-array v2, v2, [B

    .line 212
    :goto_21
    invoke-virtual {v0, v2}, Ljava/io/InputStream;->read([B)I

    move-result v3

    const/4 v4, 0x0

    if-lez v3, :cond_2c

    invoke-virtual {p0, v2, v4, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_21

    .line 213
    :cond_2c
    invoke-virtual {p0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    .line 214
    const-string v2, "SHA-256"

    invoke-static {v2}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v2

    .line 215
    invoke-virtual {v2, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object v2

    .line 216
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 217
    array-length v5, v2

    :goto_40
    if-ge v4, v5, :cond_5c

    aget-byte v6, v2, v4

    and-int/lit16 v6, v6, 0xff

    .line 218
    invoke-static {v6}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v6

    .line 219
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    const/4 v8, 0x1

    if-ne v7, v8, :cond_56

    const/16 v7, 0x30

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 220
    :cond_56
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v4, v4, 0x1

    goto :goto_40

    .line 222
    :cond_5c
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    array-length p0, p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " B  sha256="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_71
    .catchall {:try_start_14 .. :try_end_71} :catchall_7a

    if-eqz v0, :cond_76

    .line 227
    :try_start_73
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_76
    .catchall {:try_start_73 .. :try_end_76} :catchall_76

    .line 231
    :catchall_76
    :cond_76
    :try_start_76
    invoke-virtual {v1}, Ljava/util/zip/ZipFile;->close()V
    :try_end_79
    .catchall {:try_start_76 .. :try_end_79} :catchall_79

    :catchall_79
    return-object p0

    :catchall_7a
    move-exception p0

    move-object v9, v1

    move-object v1, v0

    move-object v0, v9

    goto :goto_81

    :catchall_7f
    move-exception p0

    move-object v1, v0

    .line 224
    :goto_81
    :try_start_81
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u7b97\u4e0d\u51fa\uff1a"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_92
    .catchall {:try_start_81 .. :try_end_92} :catchall_9d

    if-eqz v1, :cond_97

    .line 227
    :try_start_94
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_97
    .catchall {:try_start_94 .. :try_end_97} :catchall_97

    :catchall_97
    :cond_97
    if-eqz v0, :cond_9c

    .line 231
    :try_start_99
    invoke-virtual {v0}, Ljava/util/zip/ZipFile;->close()V
    :try_end_9c
    .catchall {:try_start_99 .. :try_end_9c} :catchall_9c

    :catchall_9c
    :cond_9c
    return-object p0

    :catchall_9d
    move-exception p0

    if-eqz v1, :cond_a3

    .line 227
    :try_start_a0
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_a3
    .catchall {:try_start_a0 .. :try_end_a3} :catchall_a3

    :catchall_a3
    :cond_a3
    if-eqz v0, :cond_a8

    .line 231
    :try_start_a5
    invoke-virtual {v0}, Ljava/util/zip/ZipFile;->close()V
    :try_end_a8
    .catchall {:try_start_a5 .. :try_end_a8} :catchall_a8

    .line 234
    :catchall_a8
    :cond_a8
    throw p0
.end method

.method private static reg(Landroid/content/Context;Landroid/content/BroadcastReceiver;Ljava/lang/String;)V
    .registers 5

    .line 141
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0, p2}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 142
    sget p2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt p2, v1, :cond_10

    const/4 p2, 0x2

    .line 143
    invoke-virtual {p0, p1, v0, p2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    return-void

    .line 145
    :cond_10
    invoke-virtual {p0, p1, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    return-void
.end method

.method private regReceivers(Landroid/content/Context;)V
    .registers 6

    .line 56
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$1;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;)V

    .line 63
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$2;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$2;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;)V

    .line 79
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$3;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$3;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;)V

    .line 86
    const-string v3, "com.little_femaleboy.fdm.CONFIG_REQ"

    invoke-static {p1, v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->reg(Landroid/content/Context;Landroid/content/BroadcastReceiver;Ljava/lang/String;)V

    .line 87
    const-string v0, "com.little_femaleboy.fdm.CONFIG_APPLIED"

    invoke-static {p1, v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->reg(Landroid/content/Context;Landroid/content/BroadcastReceiver;Ljava/lang/String;)V

    .line 88
    const-string v0, "com.little_femaleboy.fdm.CONFIG_STATE"

    invoke-static {p1, v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->reg(Landroid/content/Context;Landroid/content/BroadcastReceiver;Ljava/lang/String;)V

    .line 92
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmBridge;->inHost(Landroid/content/Context;)Z

    move-result v0

    const-string v1, "FDM-DIAG"

    if-eqz v0, :cond_2c

    .line 93
    const-string v0, "\uff08\u5bbf\u4e3b\u8fdb\u7a0b\uff09\u52a8\u4f5c\u63a5\u6536\u5668\u7531 FdmBridge \u8d1f\u8d23 \u2713"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_31

    .line 95
    :cond_2c
    const-string v0, "\u672c\u5730\u8fdb\u7a0b\uff08UI\uff09\uff1a\u53ea\u76d1\u542c\u56de\u6267/\u771f\u503c\uff0c\u4e0d\u63a5\u52a8\u4f5c \u2713"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 98
    :goto_31
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$4;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp$4;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;)V

    .line 136
    const-string p0, "com.little_femaleboy.fdm.CMD_RESULT"

    invoke-static {p1, v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->reg(Landroid/content/Context;Landroid/content/BroadcastReceiver;Ljava/lang/String;)V

    .line 137
    const-string p0, "\u5df2\u6ce8\u518c\u300c\u7d22\u8981\u914d\u7f6e\u300d\u300c\u5bbf\u4e3b\u56de\u6267\u300d\u300c\u5bbf\u4e3b\u771f\u503c\u300d\uff08\u52a8\u4f5c\u4ec5\u5bbf\u4e3b\u6301\u6709\uff09\u2713"

    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static write(Ljava/io/File;Ljava/lang/StringBuilder;)V
    .registers 5

    const/4 v0, 0x0

    .line 240
    :try_start_1
    new-instance v1, Ljava/io/FileOutputStream;

    const/4 v2, 0x0

    invoke-direct {v1, p0, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V
    :try_end_7
    .catchall {:try_start_1 .. :try_end_7} :catchall_1d

    .line 241
    :try_start_7
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "UTF-8"

    invoke-static {p1}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_18
    .catchall {:try_start_7 .. :try_end_18} :catchall_1c

    .line 245
    :try_start_18
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V

    return-void

    :catchall_1c
    move-object v0, v1

    :catchall_1d
    if-eqz v0, :cond_22

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_22
    .catchall {:try_start_18 .. :try_end_22} :catchall_22

    :catchall_22
    :cond_22
    return-void
.end method


# virtual methods
.method public onCreate()V
    .registers 6

    .line 34
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    .line 36
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 38
    :try_start_8
    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->dump(Ljava/lang/StringBuilder;)V
    :try_end_b
    .catchall {:try_start_8 .. :try_end_b} :catchall_c

    goto :goto_1a

    :catchall_c
    move-exception v1

    .line 40
    const-string v2, "\u81ea\u68c0\u81ea\u5df1\u629b\u4e86\u5f02\u5e38\uff1a"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 v1, 0xa

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 42
    :goto_1a
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "FDM-DIAG"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 43
    new-instance v1, Ljava/io/File;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getFilesDir()Ljava/io/File;

    move-result-object v3

    const-string v4, "fdm-diag.txt"

    invoke-direct {v1, v3, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->write(Ljava/io/File;Ljava/lang/StringBuilder;)V

    const/4 v1, 0x0

    .line 44
    invoke-virtual {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    if-eqz v1, :cond_40

    .line 45
    new-instance v3, Ljava/io/File;

    invoke-direct {v3, v1, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->write(Ljava/io/File;Ljava/lang/StringBuilder;)V

    .line 48
    :cond_40
    :try_start_40
    invoke-direct {p0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmApp;->regReceivers(Landroid/content/Context;)V

    .line 49
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->push(Landroid/content/Context;)I
    :try_end_46
    .catchall {:try_start_40 .. :try_end_46} :catchall_47

    goto :goto_4d

    :catchall_47
    move-exception p0

    .line 51
    const-string v0, "\u6865\u521d\u59cb\u5316\u5931\u8d25"

    invoke-static {v2, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_4d
    return-void
.end method
