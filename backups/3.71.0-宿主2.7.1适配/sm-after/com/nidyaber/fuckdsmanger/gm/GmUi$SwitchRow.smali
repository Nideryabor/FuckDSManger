.class public final Lcom/nidyaber/fuckdsmanger/gm/GmUi$SwitchRow;
.super Ljava/lang/Object;
.source "GmUi.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/nidyaber/fuckdsmanger/gm/GmUi;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "SwitchRow"
.end annotation


# instance fields
.field public final row:Landroid/widget/LinearLayout;

.field public final sw:Landroid/widget/Switch;


# direct methods
.method constructor <init>(Landroid/widget/LinearLayout;Landroid/widget/Switch;)V
    .registers 3

    .line 186
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 187
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmUi$SwitchRow;->row:Landroid/widget/LinearLayout;

    .line 188
    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/gm/GmUi$SwitchRow;->sw:Landroid/widget/Switch;

    return-void
.end method
