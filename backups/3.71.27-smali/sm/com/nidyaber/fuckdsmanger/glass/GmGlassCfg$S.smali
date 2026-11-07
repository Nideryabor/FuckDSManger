.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;
.super Ljava/lang/Object;
.source "GmGlassCfg.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "S"
.end annotation


# instance fields
.field public final blur:I

.field public final clean:Z

.field public final cleanTol:I

.field public final color:I

.field public final disp:I

.field public final drop:Z

.field public final edge:I

.field public final engine:I

.field public final fade:I

.field public final fit:Z

.field public final form:I

.field public final impl:I

.field public final on:Z

.field public final radiusDp:I

.field public final scope:I

.field public final src:I

.field public final tint:I


# direct methods
.method constructor <init>(ZIIIZIIIIZIIIZIII)V
    .registers 18

    .line 169
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 170
    iput-boolean p14, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fit:Z

    .line 171
    iput p15, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->form:I

    move/from16 p14, p16

    .line 172
    iput p14, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->edge:I

    move/from16 p14, p17

    .line 173
    iput p14, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fade:I

    .line 174
    iput p13, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->impl:I

    .line 175
    iput p12, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->src:I

    .line 176
    iput-boolean p10, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->clean:Z

    .line 177
    iput p11, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->cleanTol:I

    .line 178
    iput p9, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->engine:I

    .line 179
    iput p8, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->disp:I

    .line 180
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->on:Z

    .line 181
    iput p2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->tint:I

    .line 182
    iput p3, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->radiusDp:I

    .line 183
    iput p4, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->blur:I

    .line 184
    iput-boolean p5, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->drop:Z

    .line 185
    iput p6, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->scope:I

    .line 186
    iput p7, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->color:I

    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .registers 5

    .line 191
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "glass{on="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->on:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " tint="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->tint:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " r="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->radiusDp:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " blur="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->blur:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " drop="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->drop:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " color=#"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->color:I

    .line 193
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " disp="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->disp:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " engine="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->engine:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " clean="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->clean:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->cleanTol:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " src="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 196
    iget v2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->src:I

    const/4 v3, 0x1

    if-nez v2, :cond_77

    const-string v2, "\u5e95\u8272"

    goto :goto_7e

    :cond_77
    if-ne v2, v3, :cond_7c

    const-string v2, "\u622a\u56fe"

    goto :goto_7e

    :cond_7c
    const-string v2, "\u80cc\u666f\u56fe"

    :goto_7e
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " impl="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 197
    iget v2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->impl:I

    if-nez v2, :cond_8d

    const-string v2, "\u81ea\u52a8"

    goto :goto_94

    :cond_8d
    if-ne v2, v3, :cond_92

    const-string v2, "GPU"

    goto :goto_94

    :cond_92
    const-string v2, "CPU"

    :goto_94
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " scope="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 198
    iget v2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->scope:I

    if-nez v2, :cond_a3

    const-string v2, "\u5168\u90e8"

    goto :goto_a5

    :cond_a3
    const-string v2, "\u4ec5\u6309\u94ae"

    :goto_a5
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " fit="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fit:Z

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " form="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 200
    iget v2, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->form:I

    if-ne v2, v3, :cond_be

    const-string v2, "\u9542\u7a7a"

    goto :goto_c6

    :cond_be
    const/4 v3, 0x2

    if-ne v2, v3, :cond_c4

    const-string v2, "\u4ec5\u8fb9\u7f18"

    goto :goto_c6

    :cond_c4
    const-string v2, "\u6b63\u5e38"

    :goto_c6
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->edge:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " fade="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->fade:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "}"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
