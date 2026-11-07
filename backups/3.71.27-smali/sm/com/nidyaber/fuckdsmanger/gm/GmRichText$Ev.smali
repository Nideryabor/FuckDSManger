.class public final Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;
.super Ljava/lang/Object;
.source "GmRichText.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/gm/GmRichText;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Ev"
.end annotation


# instance fields
.field public final kind:I

.field public final tag:Ljava/lang/String;

.field public final text:Ljava/lang/String;


# direct methods
.method constructor <init>(ILjava/lang/String;Ljava/lang/String;)V
    .registers 4

    .line 656
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 657
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->kind:I

    .line 658
    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->text:Ljava/lang/String;

    .line 659
    iput-object p3, p0, Lcom/nidyaber/fuckdsmanger/gm/GmRichText$Ev;->tag:Ljava/lang/String;

    return-void
.end method
