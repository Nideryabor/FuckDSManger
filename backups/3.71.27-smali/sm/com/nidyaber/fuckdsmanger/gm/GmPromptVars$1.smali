.class Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;
.super Ljava/lang/Object;
.source "GmPromptVars.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->warm(J)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb<",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic val$id:J


# direct methods
.method constructor <init>(J)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 306
    iput-wide p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;->val$id:J

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic on(Ljava/lang/Object;)V
    .registers 2

    .line 306
    check-cast p1, Ljava/lang/String;

    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;->on(Ljava/lang/String;)V

    return-void
.end method

.method public on(Ljava/lang/String;)V
    .registers 5

    .line 309
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u6b4c\u8bcd\u9884\u70ed\u5b8c\u6210 id="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;->val$id:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, " len="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez p1, :cond_15

    const/4 p0, 0x0

    goto :goto_19

    .line 310
    :cond_15
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    :goto_19
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 309
    const-string p1, "pvar.warm"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
