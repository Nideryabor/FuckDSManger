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

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    const/16 v2, 0x1770

    if-le v1, v2, :cond_24

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->setLength(I)V

    :cond_24
    return-void
    :try_end_25
    .catchall {:try_start_0 .. :try_end_25} :catchall_25

    :catchall_25
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
