.class final Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;
.super Ljava/lang/Object;
.source "GmPromptVars.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Snap"
.end annotation


# instance fields
.field album:Ljava/lang/String;

.field around:[Ljava/lang/String;

.field artist:Ljava/lang/String;

.field dur:I

.field id:J

.field name:Ljava/lang/String;

.field playing:Z

.field pos:I


# direct methods
.method private constructor <init>()V
    .registers 3

    .line 419
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 420
    const-string v0, ""

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->name:Ljava/lang/String;

    .line 421
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->artist:Ljava/lang/String;

    .line 422
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->album:Ljava/lang/String;

    const-wide/16 v0, 0x0

    .line 423
    iput-wide v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->id:J

    const/4 v0, 0x0

    .line 424
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->pos:I

    .line 425
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->dur:I

    .line 426
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->playing:Z

    const/4 v0, 0x0

    .line 427
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->around:[Ljava/lang/String;

    return-void
.end method

.method synthetic constructor <init>(Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$1;)V
    .registers 2

    .line 419
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;-><init>()V

    return-void
.end method


# virtual methods
.method summary()Ljava/lang/String;
    .registers 3

    .line 430
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 431
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->name:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_1c

    const/16 v1, 0x300a

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x300b

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 432
    :cond_1c
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->artist:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_34

    .line 433
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    if-lez v1, :cond_2f

    const-string v1, " - "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 434
    :cond_2f
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->artist:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 436
    :cond_34
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    if-nez v1, :cond_3d

    const-string p0, ""

    return-object p0

    .line 437
    :cond_3d
    const-string v1, " ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->pos:I

    # invokes: Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->fmt(I)Ljava/lang/String;
    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->access$100(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 438
    iget v1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->dur:I

    if-lez v1, :cond_5d

    const/16 v1, 0x2f

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars$Snap;->dur:I

    # invokes: Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->fmt(I)Ljava/lang/String;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmPromptVars;->access$100(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_5d
    const/16 p0, 0x29

    .line 439
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 440
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
