.class public final Lcom/varuns2002/disable_flag_secure/gm/GmDiag;
.super Ljava/lang/Object;
.source "GmDiag.java"


# static fields
.field private static sBuf:Ljava/lang/StringBuilder;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static buf()Ljava/lang/StringBuilder;
    .registers 2

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->sBuf:Ljava/lang/StringBuilder;

    if-nez v0, :cond_b

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->sBuf:Ljava/lang/StringBuilder;

    :cond_b
    return-object v0
.end method

.method public static log(Ljava/lang/String;)V
    .registers 4

    :try_start_0
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->buf()Ljava/lang/StringBuilder;

    move-result-object v0

    new-instance v1, Ljava/text/SimpleDateFormat;

    const-string v2, "HH:mm:ss.SSS"

    invoke-direct {v1, v2}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    new-instance v2, Ljava/util/Date;

    invoke-direct {v2}, Ljava/util/Date;-><init>()V

    invoke-virtual {v1, v2}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmLog;->w(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    const v2, 0x8000

    if-le v1, v2, :cond_39

    const v2, 0x6000

    sub-int v2, v1, v2

    invoke-virtual {v0, v2, v1}, Ljava/lang/StringBuilder;->delete(II)Ljava/lang/StringBuilder;

    move-result-object v0

    :cond_39
    return-void
    :try_end_3a
    .catchall {:try_start_0 .. :try_end_3a} :catchall_3a

    :catchall_3a
    move-exception v0

    return-void
.end method

.method public static text()Ljava/lang/String;
    .registers 1

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmDiag;->sBuf:Ljava/lang/StringBuilder;

    if-nez v0, :cond_7

    const-string v0, "(diag empty)"

    return-object v0

    :cond_7
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
