.class Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$8;
.super Ljava/lang/Object;
.source "GmNoteView.java"

# interfaces
.implements Landroid/view/View$OnFocusChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->buildCard()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 2

    .line 160
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$8;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFocusChange(Landroid/view/View;Z)V
    .registers 3

    if-nez p2, :cond_7

    .line 162
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$8;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->endEdit()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    :cond_7
    return-void
.end method
