.class public final Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;
.super Ljava/lang/Object;
.source "GmRichText.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/gm/GmRichText;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Seg"
.end annotation


# instance fields
.field public anonymous:Z

.field public args:[Ljava/lang/String;

.field public dj:Z

.field public djBody:Ljava/lang/String;

.field public end:I

.field public name:Ljava/lang/String;

.field public start:I

.field public sugLabel:Ljava/lang/String;

.field public sugPayload:Ljava/lang/String;

.field public suggest:Z


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 422
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public raw(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 443
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->start:I

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Seg;->end:I

    invoke-virtual {p1, v0, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
