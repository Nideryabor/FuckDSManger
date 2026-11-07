.class Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;
.super Ljava/lang/Object;
.source "GmRichLink.java"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink;->newLink(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$label:Ljava/lang/String;

.field final synthetic val$payload:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 264
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;->val$label:Ljava/lang/String;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;->val$payload:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    const-string v0, "[\u5efa\u8bae] \u2605 \u70b9\u5230\u4e86\uff01label="

    const-string v1, "FdmRichLink("

    .line 268
    :try_start_4
    invoke-virtual {p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p2

    .line 270
    const-string v2, "toString"

    invoke-virtual {v2, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_24

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;->val$label:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 271
    :cond_24
    const-string v1, "hashCode"

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_35

    invoke-static {p1}, Ljava/lang/System;->identityHashCode(Ljava/lang/Object;)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0

    .line 272
    :cond_35
    const-string v1, "equals"

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_4d

    const/4 p0, 0x0

    if-eqz p3, :cond_48

    .line 273
    array-length p2, p3

    if-lez p2, :cond_48

    aget-object p2, p3, p0

    if-ne p1, p2, :cond_48

    const/4 p0, 0x1

    :cond_48
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0

    .line 276
    :cond_4d
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;->val$label:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " payload="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;->val$payload:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 277
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmRichLink$1;->val$payload:Ljava/lang/String;

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->onSuggestClick(Ljava/lang/String;)V
    :try_end_6d
    .catchall {:try_start_4 .. :try_end_6d} :catchall_6e

    goto :goto_74

    :catchall_6e
    move-exception p0

    .line 281
    :try_start_6f
    const-string p1, "[\u5efa\u8bae] \u70b9\u51fb\u56de\u8c03\u5f02\u5e38"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_74
    .catchall {:try_start_6f .. :try_end_74} :catchall_74

    :catchall_74
    :goto_74
    const/4 p0, 0x0

    return-object p0
.end method
